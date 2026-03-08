APSPEC32 ;IHS/CIA/PLS - APSP ENVIRONMENT CHECK ROUTINE ;17-Feb-2023 09:21;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1032**;Sep 23, 2004;Build 26
 ;
ENV ;EP
 ;
 S X=$$GET1^DIQ(200,DUZ,.01)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" v"_$P($T(+2),";",3)_", Patch "_$P($T(+2),"**",2)_".",IOM)
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0  ; Suppress the Disable options and Move routines prompts
 S XPDABORT=0
 I 'XPDABORT D
 .W !!,"All requirements for installation have been met...",!
 E  D
 .W !!,"Unable to continue with the installation...",!
 Q
 ;
MES(TXT,QUIT) ;EP
 D BMES^XPDUTL("  "_$G(TXT))
 S:$G(QUIT) XPDABORT=QUIT
 Q
 ;
PRE ;EP - Pre-init
 D DATACONV
 Q
RENXPAR(OLD,NEW) ; Rename parameter
 N IEN,FDA,FIL
 S FIL=8989.51
 Q:$$FIND1^DIC(FIL,,"X",NEW)  ; New name already exists
 S IEN=$$FIND1^DIC(FIL,,"X",OLD)
 Q:'IEN  ; Old name doesn't exist
 S FDA(FIL,IEN_",",.01)=NEW
 D FILE^DIE("E","FDA")
 Q
 ;
REMXPAR(PAR) ;Remove values stored for a given parameter
 N PIEN,ENT,INT,VIEN,DIK,DA
 S PIEN=$O(^XPAR(8989.51,"B",PAR,0))
 Q:'PIEN
 S ENT=0 F  S ENT=$O(^XPAR(8989.5,"AC",PIEN,ENT)) Q:ENT=""  D  ;Entity
 .S INT=0 F  S INT=$O(^XPAR(8989.5,"AC",PIEN,ENT,INT)) Q:INT=""  D  ;Instance
 ..S DA=0 F  S DA=$O(^XPAR(8989.5,"AC",PIEN,ENT,INT,DA)) Q:'DA  D  ;Value IEN
 ...S DIK="^XTV(8989.5," D ^DIK
 Q
POST ;EP
 D REGNMSP^CIAURPC("APSP","CIAV VUECENTRIC")
 D:$L($$GET1^DID(59.7,80.7,,"LABEL")) POST153,POST159
 Q
 ;
DATACONV ;
 ;Only perform once
 I $G(^DD(9009032,.06,0))'["^DIC(6," D  Q  ;Conversion already done if not pointing to File 6
 .D BMES^XPDUTL(" APSP DUE REVIEW Conversion already completed.")
 D BMES^XPDUTL(" Performing conversion of the APSP DUE REVIEW File.")
 K ^TMP($J,"DATACONV")
 N LP,OV,NV,N0,GR,X,CNT
 S CNT=0
 S LP=0 F  S LP=$O(^APSPDUE(32,LP)) Q:'LP  S GR="^APSPDUE(32,"_LP_")" S N0=^(LP,0) D
 .Q:'$P(N0,U,6)
 .S X=$$F6($P(N0,U,6))
 .S CNT=CNT+1
 .S ^TMP($J,"DATACONV",CNT)=LP_"  ("_$P(N0,U,6)_")  "_$P($G(^DIC(16,$P(N0,U,6),0)),U)_"  ("_X_")  "_$S(X:$$GET1^DIQ(200,X,.01),1:"No match found")
 .D UPDPRV(GR,X)
 D CONVMAIL
 Q
 ;
F6(IEN) ;Return File 200 ptr given File 6 ptr
 Q +$G(^DIC(16,IEN,"A3"))
UPDPRV(GB,VAL) ;
 S $P(@GB@(0),U,6)=VAL
 Q
 ;
CONVMAIL ;Send email to installer containing converted information
 D BMES^XPDUTL("Sending Conversion message...")
 N XMDUZ,XMSUB,XMTEXT,XMY,DIFROM,DA,MCNT,LP
 S XMDUZ="Patch APSP*7.0*1032 Data Conversion"
 S:$G(DUZ) XMY(DUZ)=""
 S XMSUB="APSP DUE REVIEW File Conversion for File 6"
 S XMTEXT="APSPTMP("
 S APSPTMP(1)="List of entries converted to NEW PERSON File in"
 S APSPTMP(2)="the APSP DUE REVIEW File"
 S APSPTMP(3)=""
 S APSPTMP(4)="Output format: IEN  (F16)Name                 (F200)Name"
 S APSPTMP(5)=""
 S APSPTMP(6)="=========================================================="
 S MCNT=6,LP=0 F  S LP=$O(^TMP($J,"DATACONV",LP)) Q:'LP  S MCNT=MCNT+1,APSPTMP(MCNT)=$G(^(LP))
 I '$O(^TMP($J,"DATACONV",0)) S MCNT=7,APSPTMP(MCNT)="No entries found."
 D ^XMD K APSPTMP,^TMP($J,"DATACONV")
 D BMES^XPDUTL("Data conversion message sent.")
 Q
 ; Create "B" xref for ZipCodes
ZCXREF ;EP
 D MES("Building ZipCode Proximity crossreference (a '.' represents 100 entries)")
 N ZC
 S ZC=0 F  S ZC=$O(^APSPZCPX(ZC)) Q:'ZC  D
 .D ONEZC(ZC)
 .W:'(ZC#100) "."
 Q
 ;
ONEZC(ZC) ;EP
 N LP,DAT
 K ^APSPZCPX(ZC,1,"B")
 S LP=0 F  S LP=$O(^APSPZCPX(ZC,1,LP)) Q:'LP  D
 .S DAT=^APSPZCPX(ZC,1,LP,0)
 .S ^APSPZCPX(ZC,1,"B",$P(DAT,U,2),LP)=""
 Q
 ;
 ; Register a protocol to an extended action protocol
 ; Input: P-Parent protocol
 ;        C-Child protocol
 ;     SEQ-Sequence Number
REGPROT(P,C,SEQ,ERR) ;EP
 N IENARY,PIEN,AIEN,FDA
 D
 .I '$L(P)!('$L(C)) S ERR="Missing input parameter" Q
 .S IENARY(1)=$$FIND1^DIC(101,"","",P)
 .S AIEN=$$FIND1^DIC(101,"","",C)
 .I 'IENARY(1)!'AIEN S ERR="Unknown protocol name" Q
 .S FDA(101.01,"?+2,"_IENARY(1)_",",.01)=AIEN
 .S FDA(101.01,"?+2,"_IENARY(1)_",",3)=SEQ
 .D UPDATE^DIE("S","FDA","IENARY","ERR")
 ;Q:$Q $G(ERR)=""
 Q
 ; UnRegister a protocol from an extended action protocol
 ; Input: P-Parent protocol
 ;        C-Child protocol
UREGPROT(P,C,ERR) ;EP-
 N IENARY,PIEN,AIEN,FDA
 D
 .I '$L(P)!('$L(C)) S ERR="Missing input parameter" Q
 .S IENARY(1)=$$FIND1^DIC(101,"","",P)
 .S AIEN=$$FIND1^DIC(101,"","",C)
 .I 'IENARY(1)!'AIEN S ERR="Unknown protocol name" Q
 .S IENARY(2)=$$FIND1^DIC(101.01,","_IENARY(1)_",","",C)
 .S FDA(101.01,IENARY(2)_","_IENARY(1)_",",.01)="@"
 .D UPDATE^DIE("S","FDA","","ERR")
 Q
SETPKGV(PKG,VER) ;EP
 N PIEN,FDA
 S PIEN=$$FIND1^DIC(9.4,,,PKG)
 Q:'PIEN
 S FDA(9.4,PIEN_",",13)=VER
 D UPDATE^DIE(,"FDA")
 Q
 ; Fix Out of Order Message and lock with APSP Key
OFOMSG(OPT,MSG,KEY) ;
 N IEN,VAL,FDA,KIEN
 S IEN=$$FIND1^DIC(19,,"X",OPT)
 S KIEN=$$FIND1^DIC(19.1,,"X",KEY)
 I IEN D
 .S VAL=$S($L($G(MSG)):MSG,1:"Not used in IHS")
 .S FDA(19,IEN_",",2)=VAL
 .S:KIEN FDA(19,IEN_",",3)=KIEN
 .D FILE^DIE("K","FDA")
 Q
 ; Cleanup PCC Link in NVA node
CLNNVA ;EP -
 N DFN,IEN,FDA,NVAERR
 S DFN=0 F  S DFN=$O(^PS(55,"APCC","+1",DFN)) Q:'DFN  D
 .S IEN=0 F  S IEN=$O(^PS(55,"APCC","+1",DFN,IEN)) Q:'IEN  D
 ..S FDA(55.05,IEN_","_DFN_",",9999999.11)="@"
 D:$D(FDA) UPDATE^DIE("","FDA",,"NVAERR")
 W:$G(DIERR) $G(NVAERR("DIERR",1,"TEXT",1))
 Q
 ; Fix VMed entries lacking Date Discontinued
FIXVMEDD(DAYS) ;EP -
 N RX,BDT,EDT,FDT,VMED,ACT
 S EDT=$$DT^XLFDT()
 S BDT=$$FMADD^XLFDT(EDT,-$G(DAYS,730))
 S FDTLP=BDT-.01
 F  S FDTLP=$O(^PSRX("AD",FDTLP)) Q:'FDTLP!(FDTLP>EDT)  D
 .S RX=0
 .F  S RX=$O(^PSRX("AD",FDTLP,RX)) Q:'RX  D
 ..Q:$G(^PSRX(RX,"STA"))'=15        ;status not Discontinued (Edit)
 ..S VMED=+$G(^PSRX(RX,999999911))
 ..Q:'VMED
 ..Q:$P($G(^AUPNVMED(VMED,0)),U,8)  ;already marked as discontinued
 ..;Check last activity node for a discontinued type
 ..S ACT=$P($G(^PSRX(RX,"A",0)),U,4)
 ..Q:'ACT
 ..S ACT=$G(^PSRX(RX,"A",ACT,0))
 ..I $P(ACT,U,2)="C" D
 ...S $P(^AUPNVMED(VMED,0),U,8)=$P(+ACT,".")
 Q
 ; Send Quantity Qualifier MailMan message
MM ;EP-
 N LP,XMTEXT,XMY,XMSUB,XMDUZ,DA,DIFROM,CNT,DATA
 N QQARY,DNM,QQNM,STR,X
 K ^TMP("DATA",$J)
 F LP=0:1 S X=$P($T(IENS+LP),";;",2) Q:'$L(X)  D
 .D SEARCH(+X)
 I $D(^TMP("DATA",$J)) D
 .S DATA=$NA(^TMP("APSP1016Z",$J))
 .K @DATA
 .S XMTEXT="^TMP(""APSP1016Z"",$J,"
 .S XMDUZ="NDF MANAGER"
 .S XMSUB="DRUGS ASSOCIATED WITH INACTIVATED QUANTITY QUALIFIERS"
 .D BLDTXT
 .S CNT=7
 .S DNM="" F  S DNM=$O(^TMP("DATA",$J,DNM)) Q:DNM=""  D
 ..S QQNM="" F  S QQNM=$O(^TMP("DATA",$J,DNM,QQNM)) Q:QQNM=""  D
 ...S X=^TMP("DATA",$J,DNM,QQNM)
 ...S STR=DNM,$E(STR,52)=+X,$E(STR,59)=QQNM
 ...S CNT=CNT+1
 ...S @DATA@(CNT)=STR
 .S DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
 .S XMY("G.NDF DATA@"_^XMB("NETNAME"))=""
 .D ^XMD
 Q
 ;
 ;Add fixed text to message global
BLDTXT ;EP-
 S @DATA@(1)="The following entries in your DRUG file (#50) are associated with"
 S @DATA@(2)="NCPDP Quantity Qualifiers in the APSP NCPDP Control Codes file."
 S @DATA@(3)="It is critical that you rematch these products immediately so that"
 S @DATA@(4)="the Surescripts interface will continue to work without errors."
 S @DATA@(5)=""
 S @DATA@(6)="DRUG                                               IEN    QTY QUALIFIER"
 S @DATA@(7)=""
 Q
SEARCH(QQ) ;EP- Given qualifier return list of drug file entries linked to quantity qualifier
 N DIEN,DRGQQ
 S DIEN=0 F  S DIEN=$O(^PSDRUG(DIEN)) Q:'DIEN  D
 .S DRGQQ=+$P($G(^PSDRUG(DIEN,9999999.145)),U)
 .Q:DRGQQ'=QQ
 .S ^TMP("DATA",$J,$$GET1^DIQ(50,DIEN,.01),$$GET1^DIQ(9009033.7,QQ,.01))=DIEN_U_QQ_U_$$GET1^DIQ(9009033.7,QQ,1)
 Q
CHKP55 ;EP -Check for .01 field being empty in file 55
 N PSODFN,DIK,DA
 S DIK="^PS(55,"
 S PSODFN=0
 F  S PSODFN=$O(^PS(55,PSODFN)) Q:'+PSODFN  D
 .I '$D(^PS(55,PSODFN,0))!($P($G(^PS(55,PSODFN,0)),U,1)="") D
 ..L +^PS(55,PSODFN):10
 ..S $P(^PS(55,PSODFN,0),U,1)=PSODFN
 ..S DA=PSODFN
 ..S DIK(1)=".01"
 ..D EN1^DIK
 ..L -^PS(55,PSODFN)
 Q
 ;
BLDPCLST ;Build XPAR Subset of Person Class
 N LP,X,XPAR
 S XPAR="APSP SS PERSON CLASS SUBSET"
 D NDEL^XPAR("SYS",XPAR)
 S (LP,SEQ)=0
 F LP=0:1 S X=$P($T(PCVAL+LP),";;",2) Q:'$L(X)  D
 .D ADD^XPAR("SYS",XPAR,$P(X,";"),$P(X,";",2))
 Q
 ; SEQ;File 8932.1 IEN
PCVAL ;;1;205
 ;;2;203
 ;;
POST153 ;; set the USE DOSAGE FORM MED ROUTE LIST field to YES for sites that have the
 ; DEFAULT MED ROUTE FOR CPRS field (#80.7) of the PHARMACY SYSTEM file (#59.7) set to NO.
 ; Otherwise, the USE DOSAGE FORM MED ROUTE LIST field is set to NO.
 N PSSVAL,PSSIEN
 S PSSVAL=$P($G(^PS(59.7,1,80)),"^",7)
 S PSSIEN=0 F  S PSSIEN=$O(^PS(50.7,PSSIEN)) Q:'PSSIEN  I $D(^(PSSIEN,0)) D
 .S $P(^PS(50.7,PSSIEN,0),"^",13)=$S($G(PSSVAL)=1:"N",1:"Y")
 Q
 ;
POST159 ;;
 ; delete data of the DEFAULT MED ROUTE FOR CPRS field (#80.7)
 K DIE,DA,DR S DIE=59.7,DR="80.7///@",DA=1 D ^DIE K DA,DIE,DR
 ;
 ; delete DD for the DEFAULT MED ROUTE FOR CPRS field (#80.7)
 S DIK="^DD(59.7,",DA=80.7,DA(1)=59.7 D ^DIK K DA,DIK
 ;
 ; if no default med route, no possible med routes and the USE DOSAGE FORM MED ROUTE LIST field is set to NO
 ; change the field to "YES" and generate mailman message.
 S MCT=1,PSSIEN=0 F  S PSSIEN=$O(^PS(50.7,PSSIEN)) Q:'PSSIEN  I $D(^(PSSIEN,0)) S PSSNODE0=$G(^PS(50.7,PSSIEN,0)) D
 .I $P(PSSNODE0,"^",13)="N",'$P($G(^PS(50.7,PSSIEN,0)),"^",6)&('$O(^PS(50.7,PSSIEN,3,0))) D
 ..S $P(^PS(50.7,PSSIEN,0),"^",13)="Y",^TMP($J,"PSSP159",MCT)=$J(PSSIEN,10)_"     "_$E($P(PSSNODE0,"^"),1,20),MCT=MCT+1
MAIL ; create mail message
 D BMES^XPDUTL(" Generating Mail Message....")
 N XMDUZ,XMSUB,XMTEXT,XMY,DIFROM,DA
 S XMDUZ="Patch APSP*7.0*1032 Post Install"
 ;F PSSFDS=0:0 S PSSFDS=$O(@XPDGREF@("PSSARX",PSSFDS)) Q:'PSSFDS  S XMY(PSSFDS)=""
 S DA=0 F  S DA=$O(^XUSEC("PSNMGR",DA)) Q:'DA  S XMY(DA)=""
 S:$G(DUZ) XMY(DUZ)=""
 S XMSUB="Pharmacy Orderable Item Updates",XMTEXT="PSSTMP("
 S PSSTMP(1)="Pharmacy Orderable Item Auto-change:",PSSTMP(2)=""
 S PSSTMP(3)="The USE DOSAGE FORM MED ROUTE LIST field of the following Orderable Items"
 S PSSTMP(4)="has been changed from NO to YES because these Orderable Items did not have the"
 S PSSTMP(5)="DEFAULT MED ROUTE and/or any POSSIBLE MED ROUTES populated. The medication"
 S PSSTMP(6)="routes associated with the Dosage Form for these Orderable Items will be "
 S PSSTMP(7)="displayed for selection in RPMS EHR, as they were prior to this patch."
 S PSSTMP(8)=""
 S PSSTMP(9)="If you wish to make adjustments to the Medication Routes that display in "
 S PSSTMP(10)="RPMS EHR for these Orderable Items, use the Edit Orderable Items "
 S PSSTMP(11)="[PSS EDIT ORDERABLE ITEMS] option."
 S PSSTMP(12)=""
 S PSSTMP(13)="",PSSTMP(14)="OI Number      OI NAME",PSSTMP(15)="==========     ===================="
 S CNT=15,X=0 F  S X=$O(^TMP($J,"PSSP159",X)) Q:'X  S CNT=CNT+1,PSSTMP(CNT)=$G(^(X))
 I '$O(^TMP($J,"PSSP159",0)) S CNT=16,PSSTMP(16)="               None Found"
 D ^XMD K PSSTMP,^TMP($J,"PSSP159")
 D BMES^XPDUTL(" Mail message sent.")
 Q
