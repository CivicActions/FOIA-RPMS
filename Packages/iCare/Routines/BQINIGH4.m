BQINIGH4 ;GDIT/HS/ALA-Nightly process ; 22 Feb 2022  4:16 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,2,3,7**;Mar 01, 2021;Build 14
 ;
 ;
REG ;EP - Check for register updates and apply in iCare
 ; Process register records into tags
 NEW REGIEN,RDATA,TAG,FILE,FIELD,XREF,STFILE,STFLD,STEX,SUBREG,GLBREF,GLBNOD
 NEW DFN,RIEN,QFL,DATE,TGNM,PSTAT,DATA
 S REGIEN=0
 F  S REGIEN=$O(^BQI(90507,REGIEN)) Q:'REGIEN  D
 . S RDATA=^BQI(90507,REGIEN,0)
 . ; If the register is inactive, quit
 . I $P(RDATA,U,8)=1 Q
 . ; Check if register is associated with a tag, if there isn't one, quit
 . S TAG=$O(^BQI(90506.2,"AD",REGIEN,"")) I TAG="" Q
 . S FILE=$P(RDATA,U,7),FIELD=$P(RDATA,U,5),XREF=$P(RDATA,U,6)
 . S STFILE=$P(RDATA,U,15),STFLD=$P(RDATA,U,14),STEX=$G(^BQI(90507,REGIEN,1))
 . S SUBREG=$P(RDATA,U,9)
 . S GLBREF=$$ROOT^DILFD(FILE,"")_XREF_")"
 . S GLBNOD=$$ROOT^DILFD(FILE,"",1)
 . I GLBNOD="" Q
 . ;
 . I '$D(@GLBNOD@(0)) Q
 . ;
 . S DFN=""
 . F  S DFN=$O(@GLBREF@(DFN)) Q:DFN=""  D
 .. ; If patient is deceased, quit
 .. I $P($G(^DPT(DFN,.35)),U,1)'="" Q
 .. ; If patient has no active HRNs, quit
 .. I '$$HRN^BQIUL1(DFN) Q
 .. ; If patient has no visit in last 3 years, quit
 .. I '$$VTHR^BQIUL1(DFN) Q
 .. ;
 .. I $G(SUBREG)'="" S QFL=0 D  Q:'QFL
 ... Q:FILE'=9002241
 ... S RIEN=""
 ... F  S RIEN=$O(@GLBREF@(DFN,RIEN)) Q:RIEN=""  D
 .... I $P($G(@GLBNOD@(RIEN,0)),U,5)=SUBREG S QFL=1,IENS=RIEN
 .. ; Check register status
 .. I $G(SUBREG)="" S IENS=$O(@GLBREF@(DFN,""))
 .. I STEX'="" X STEX Q:'$D(IENS)
 .. S PSTAT=$$GET1^DIQ(STFILE,IENS,STFLD,"I")
 .. S DATE=$P($G(^BQIPAT(DFN,20,TAG,0)),U,2)
 .. I $O(^BQIREG("C",DFN,TAG,""))'="" Q
 .. I PSTAT="U"!(PSTAT="") D  Q
 ... ; If patient is already tagged, quit
 ... I $O(^BQIPAT(DFN,20,TAG,0))'="" Q
 ... ; else build a "proposed" record
 ... D EN^BQITDPRC(.DATA,DFN,TAG,"P",DATE,"NIGHTLY JOB",8,"Register status is "_PSTAT) Q
 .. I PSTAT="D" Q
 .. I PSTAT="I" D  Q
 ... ; If the patient was not tagged and is inactive on register, quit
 ... I $O(^BQIPAT(DFN,20,TAG,0))="" Q
 ... ; If the patient was tagged and is inactive on register
 ... D EN^BQITDPRC(.DATA,DFN,TAG,"P",DATE,"NIGHTLY JOB",8,"Register status is "_PSTAT) Q
 .. D EN^BQITDPRC(.DATA,DFN,TAG,"A",DATE,"NIGHTLY JOB",8,"Register status is "_PSTAT)
 .. ; Remove any temporary BQIPAT data
 .. NEW DA,DIK
 .. S DA(1)=DFN,DA=TAG,DIK="^BQIPAT("_DA(1)_",20,"
 .. D ^DIK
 Q
 ;
RTAX ;EP - Check for report taxonomies
 ;determine if any taxonomies need deconstruction for Source and layouts
 ; For HIV/AIDS Quality of Care
 S RGN=1
 ; Clean up labs
 NEW DA,IENS,CIEN,TXN,TXDATA,DFLG,TAX,TREF,LBIEN,LLIST,LAB,RGN,BQQN
 S CIEN=$O(^BQI(90506.5,"B","HIV QoC","")) I CIEN="" Q
 S DA=0,DA(1)=CIEN
 F  S DA=$O(^BQI(90506.5,CIEN,10,DA)) Q:'DA  D
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90506.51,IENS,.09)=1
 I $D(BQIUPD) D FILE^DIE("","BQIUPD","ERROR")
 ;
 S TXN=0
 F  S TXN=$O(^BQI(90507,RGN,20,1,10,TXN)) Q:'TXN  D
 . S TXDATA=^BQI(90507,RGN,20,1,10,TXN,0)
 . S DFLG=+$P(TXDATA,"^",4)
 . I 'DFLG Q
 . S TAX=$P(TXDATA,"^",1),TREF=$NA(^TMP("BKMTAX",$J)) K @TREF
 . I $P(TXDATA,"^",2)["ATXLAB" D BLD^BQITUTL(TAX,.TREF,"L")
 . I $P(TXDATA,"^",2)'["ATXLAB" D BLD^BQITUTL(TAX,.TREF,"")
 . S LBIEN=""
 . F  S LBIEN=$O(@TREF@(LBIEN)) Q:LBIEN=""  D
 .. ;I $T(@("DECON^BKMCMLBP"))'="" D DECON^BKMCMLBP(LBIEN,.LLIST)
 .. ;I $T(@("LBT^BKMCMLBP"))'="" D LBT^BKMCMLBP(.LLIST)
 .. K LLIST
 .. ;
 K @TREF
 Q
 ;
HIGH ;EP - Check for High Risk patients
 NEW TEMP,IIEN,IEN,PIEN,STAT,DFN,ONSET,VIS,CNT,NCD,TYP,COND,Y
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S TEMP=$NA(^XTMP("BQIHIGH")) K @TEMP
 S @TEMP@(0)=$$FMADD^XLFDT(DT,14)_U_DT_U_"Determine High Risk patients"
 S IIEN="" F  S IIEN=$O(^BQI(90505.9,"B",IIEN)) Q:IIEN=""  D
 . S IEN=$O(^BQI(90505.9,"B",IIEN,"")),COND=$P(^BQI(90505.9,IEN,0),"^",2)
 . I $P(^BQI(90505.9,IEN,0),"^",3)=1 Q
 . S PIEN="" F  S PIEN=$O(^AUPNPROB("B",IIEN,PIEN)) Q:PIEN=""  D
 .. S STAT=$P($G(^AUPNPROB(PIEN,0)),"^",12) I STAT="" Q
 .. I STAT="I"!(STAT="D") Q
 .. S DFN=$P($G(^AUPNPROB(PIEN,0)),"^",2) I DFN="" Q
 .. S ONSET=$$PROB^BQIUL1(PIEN)
 .. S @TEMP@(DFN,IIEN)=COND_"^"_ONSET_"^P^"_PIEN
 . ;
 . S PIEN="" F  S PIEN=$O(^AUPNVPOV("B",IIEN,PIEN)) Q:PIEN=""  D
 .. S DFN=$P($G(^AUPNVPOV(PIEN,0)),"^",2) I DFN="" Q
 .. S VIS=$P($G(^AUPNVPOV(PIEN,0)),"^",3) I VIS="" Q
 .. S ONSET=$P(^AUPNVSIT(VIS,0),"^",1)\1
 .. I '$D(@TEMP@(DFN,IIEN)) S @TEMP@(DFN,IIEN)=COND_"^"_ONSET_"^V^"_PIEN
 ;
 K HTY S HTY="" F  S HTY=$O(^BQIPAT("AH",HTY)) Q:HTY=""  D
 . S DFN="" F  S DFN=$O(^BQIPAT("AH",HTY,DFN)) Q:DFN=""  I '$D(@TEMP@(DFN)) K ^BQIPAT(DFN,5)
 K ^BQIPAT("AH"),^BQIPAT("AI")
 ;
 S DFN=0 F  S DFN=$O(@TEMP@(DFN)) Q:DFN=""  D
 . K ^BQIPAT(DFN,5) I $P($G(^DPT(DFN,.35)),"^",1)'="" Q
 . S IIEN="" F  S IIEN=$O(@TEMP@(DFN,IIEN)) Q:IIEN=""  D
 .. S COND=$P(@TEMP@(DFN,IIEN),"^",1),ONSET=$P(@TEMP@(DFN,IIEN),"^",2),TYP=$P(@TEMP@(DFN,IIEN),"^",3),PIEN=$P(@TEMP@(DFN,IIEN),"^",4)
 .. D FIL
 . S CNT=0,NCD="" F  S NCD=$O(^BQIPAT(DFN,5,"C",NCD)) Q:NCD=""  S CNT=CNT+1
 . S UPD(90507.5,DFN_",",.09)=CNT D FILE^DIE("","UPD","ERROR")
 ;
 S DIK="^BQIPAT(",DIK(1)=".09"
 D ENALL^DIK
 Q
 ;
FIL ;
 NEW DIC,X,DINUM,DLAYGO,DA,IENS,BQIUPD
 I $G(^BQIPAT(DFN,0))="" S ^BQIPAT(DFN,0)=DFN,^BQIPAT("B",DFN,DFN)=""
 S X=IIEN,DLAYGO=90507.57,DA(1)=DFN,DIC("P")=DLAYGO
 I $G(^BQIPAT(DA(1),5,0))="" S ^BQIPAT(DA(1),5,0)="^90507.57P^^"
 S DIC="^BQIPAT("_DA(1)_",5,",DIC(0)="FLX"
 K DO,DD D FILE^DICN
 S DA=+Y I DA=-1 Q
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.57,IENS,.02)=COND
 S BQIUPD(90507.57,IENS,.03)=ONSET
 S BQIUPD(90507.57,IENS,.04)=TYP
 S BQIUPD(90507.57,IENS,.05)=PIEN
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
IMCO ; Find Immunocompromised Patients
 NEW TEMP,IIEN,IEN,PIEN,STAT,DFN,ONSET,VIS,CNT,NCD,TYP,COND,Y
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S TEMP=$NA(^XTMP("BQIIMMUNO")) K @TEMP
 S @TEMP@(0)=$$FMADD^XLFDT(DT,14)_U_DT_U_"Determine Immunocompromised patients"
 S IIEN="" F  S IIEN=$O(^BQI(90505.3,"B",IIEN)) Q:IIEN=""  D
 . S IEN=$O(^BQI(90505.3,"B",IIEN,"")),COND=$P(^BQI(90505.3,IEN,0),"^",2)
 . I $P(^BQI(90505.3,IEN,0),"^",3)=1 Q
 . S PIEN="" F  S PIEN=$O(^AUPNPROB("B",IIEN,PIEN)) Q:PIEN=""  D
 .. S STAT=$P($G(^AUPNPROB(PIEN,0)),"^",12) I STAT="" Q
 .. I STAT="I"!(STAT="D") Q
 .. S DFN=$P($G(^AUPNPROB(PIEN,0)),"^",2) I DFN="" Q
 .. S ONSET=$$PROB^BQIUL1(PIEN)
 .. S @TEMP@(DFN,IIEN)=COND_"^"_ONSET_"^P^"_PIEN
 . ;
 . S PIEN="" F  S PIEN=$O(^AUPNVPOV("B",IIEN,PIEN)) Q:PIEN=""  D
 .. S DFN=$P($G(^AUPNVPOV(PIEN,0)),"^",2) I DFN="" Q
 .. S VIS=$P($G(^AUPNVPOV(PIEN,0)),"^",3) I VIS="" Q
 .. S ONSET=$P(^AUPNVSIT(VIS,0),"^",1)\1
 .. I '$D(@TEMP@(DFN,IIEN)) S @TEMP@(DFN,IIEN)=COND_"^"_ONSET_"^V^"_PIEN
 ;
 K ITY S ITY="" F  S ITY=$O(^BQIPAT("AJ",ITY)) Q:ITY=""  D
 . S DFN="" F  S DFN=$O(^BQIPAT("AJ",ITY,DFN)) Q:DFN=""  I '$D(@TEMP@(DFN)) K ^BQIPAT(DFN,8)
 K ^BQIPAT("AJ")
 ;
 S DFN=0 F  S DFN=$O(@TEMP@(DFN)) Q:DFN=""  D
 . K ^BQIPAT(DFN,8) I $P($G(^DPT(DFN,.35)),"^",1)'="" Q
 . S IIEN="" F  S IIEN=$O(@TEMP@(DFN,IIEN)) Q:IIEN=""  D
 .. S COND=$P(@TEMP@(DFN,IIEN),"^",1),ONSET=$P(@TEMP@(DFN,IIEN),"^",2),TYP=$P(@TEMP@(DFN,IIEN),"^",3),PIEN=$P(@TEMP@(DFN,IIEN),"^",4)
 .. D IFIL
 Q
 ;
IFIL ;
 NEW DIC,X,DINUM,DLAYGO,DA,IENS,BQIUPD
 I $G(^BQIPAT(DFN,0))="" S ^BQIPAT(DFN,0)=DFN,^BQIPAT("B",DFN,DFN)=""
 S X=IIEN,DLAYGO=90507.58,DA(1)=DFN,DIC("P")=DLAYGO
 I $G(^BQIPAT(DA(1),8,0))="" S ^BQIPAT(DA(1),8,0)="^90507.58P^^"
 S DIC="^BQIPAT("_DA(1)_",8,",DIC(0)="FLX"
 K DO,DD D FILE^DICN
 S DA=+Y I DA=-1 Q
 S IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.58,IENS,.02)=COND
 S BQIUPD(90507.58,IENS,.03)=ONSET
 S BQIUPD(90507.58,IENS,.04)=TYP
 S BQIUPD(90507.58,IENS,.05)=PIEN
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
ORIT ;EP - Orderable Item list
 NEW ORN,OIT
 S ORN=+$P($G(^BQI(90508,1,"VISIT")),"^",3)
 F  S ORN=$O(^OR(100,ORN)) Q:'ORN  D
 . S $P(^BQI(90508,1,"VISIT"),"^",3)=ORN
 . S ORSTDT=$P(^OR(100,ORN,0),"^",8),ORSPDT=$P(^(0),"^",9)
 . I ORSTDT'="" S ^XTMP("BQIORSTDT",ORSTDT,ORN)=""
 . I ORSPDT'="" S ^XTMP("BQIORSPDT",ORSPDT,ORN)=""
 . S OLOC=$P(^OR(100,ORN,0),"^",10) S:OLOC=""!(OLOC=0) OLOC="~"
 . I OLOC'="~" S OLN=$P(OLOC,";",1),OLNM=$P($G(^SC(OLN,0)),"^",1) I OLNM="" S OLOC="~",OLN=""
 . ;I OLOC="~" S OLNM="NO LOCATION",OLN=""
 . ;I $G(OLNM)'="" S $P(^XTMP("BQIORLOC",OLNM),"^",1)=$G(OLN),$P(^XTMP("BQIORLOC",OLNM),"^",2)=$P($G(^XTMP("BQIORLOC",OLNM)),"^",2)+1
 . I $G(OLN)'="" S ^XTMP("BQIORLOC",OLN)=$G(^XTMP("BQIORLOC",OLN))+1
 . I OLOC="~" S ^XTMP("BQIORLOC",OLOC)=$G(^XTMP("BQIORLOC",OLOC))+1
 . S OPRV=$P(^OR(100,ORN,0),"^",4)
 . I OPRV'="" D
 .. ;S OPVNM=$P($G(^VA(200,OPRV,0)),"^",1) I OPVNM="" Q
 .. ;S $P(^XTMP("BQIORPRV",OPVNM),"^",1)=OPRV,$P(^XTMP("BQIORPRV",OPVNM),"^",2)=$P($G(^XTMP("BQIORPRV",OPVNM)),"^",2)+1
 .. S ^XTMP("BQIORPRV",OPRV)=$G(^XTMP("BQIORPRV",OPRV))+1
 . S OSTAT=$P($G(^OR(100,ORN,3)),"^",3) I OSTAT'="" S ^XTMP("BQIORSTA",OSTAT)=""
 . S OIT="" F  S OIT=$O(^OR(100,ORN,.1,"B",OIT)) Q:OIT=""  D
 .. S ITEM=$P($G(^ORD(101.43,OIT,0)),"^",1) I ITEM="" Q
 .. D ORST(OIT)
 .. S ^XTMP("BQIORITM",GRP,OIT)=$G(^XTMP("BQIORITM",GRP,OIT))+1
 ;
 S GRP="" F  S GRP=$O(^XTMP("BQIORITM",GRP)) Q:GRP=""  D
 . S CT=0,IT="" F  S IT=$O(^XTMP("BQIORITM",GRP,IT)) Q:IT=""  S CT=CT+1
 . S ^XTMP("BQIORITM",GRP)=CT
 K IT,ITEM,CT,INACD,TY,GRP
 ;
 ;S GRP="" F  S GRP=$O(^XTMP("BQIORSRV",GRP)) Q:GRP=""  D
 ;. S SRV="" F  S SRV=$O(^XTMP("BQIORSRV",GRP,SRV)) Q:SRV=""  D
 ;.. S CT=0,ITM="" F  S ITM=$O(^XTMP("BQIORSRV",GRP,SRV,ITM)) Q:ITM=""  S CT=CT+1
 ;.. S ^XTMP("BQIORSRV",GRP,SRV)=CT
 S ^XTMP("BQIORITM",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Orderable Item List"
 S ^XTMP("BQIORSRV",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Item Service List"
 S ^XTMP("BQIORSTA",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Order Status List"
 S ^XTMP("BQIORLOC",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Order Location List"
 S ^XTMP("BQIORPRV",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Order Provider List"
 S ^XTMP("BQIORSTDT",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Order Start Date"
 S ^XTMP("BQIORSPDT",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Order Stop Date"
 Q
 ;
ORST(ON) ;
 S GRN=$P(^ORD(101.43,ON,0),"^",5),GRP=$P(^ORD(100.98,GRN,0),"^",1)
 I GRP="PHARMACY" D  Q
 . S PDATA=$G(^ORD(101.43,ON,"PS"))
 . S INP=$P(PDATA,"^",1),OUT=$P(PDATA,"^",2),NON=$P(PDATA,"^",7)
 . I INP D
 .. S OGNM=$S(INP=2:"IV MEDICATIONS",INP=1:"INPATIENT MEDICATIONS",1:"")
 .. S ^XTMP("BQIORSRV",GRP,OGNM,ON)=$G(^XTMP("BQIORSRV",GRP,OGNM,ON))+1
 . I OUT S OGNM="OUTPATIENT MEDICATIONS",^XTMP("BQIORSRV",GRP,OGNM,ON)=$G(^XTMP("BQIORSRV",GRP,OGNM,ON))+1
 . I NON S OGNM="NON-VA MEDICATIONS",^XTMP("BQIORSRV",GRP,OGNM,ON)=$G(^XTMP("BQIORSRV",GRP,OGNM,ON))+1
 ;
 I GRP="IMAGING" D  Q
 . S OGNM=$$GET1^DIQ(101.43,ON_",",71.3,"E") I OGNM="" Q
 . S ^XTMP("BQIORSRV",GRP,OGNM,ON)=$G(^XTMP("BQIORSRV",GRP,OGNM,ON))+1
 ;
 I GRP="LABORATORY" D  Q
 . S OGNM=$$GET1^DIQ(101.43,ON_",",60.6,"E") I OGNM="" Q
 . S ^XTMP("BQIORSRV",GRP,OGNM,ON)=$G(^XTMP("BQIORSRV",GRP,OGNM,ON))+1
 ;
 S OST=""
 F  S OST=$O(^ORD(101.43,ON,9,"B",OST)) Q:OST=""  D
 . S OSN=$O(^ORD(100.98,"B",OST,"")) I OSN="" Q
 . S OGNM=$P(^ORD(100.98,OSN,0),"^",1)
 . S ^XTMP("BQIORSRV",GRP,OGNM,ON)=$G(^XTMP("BQIORSRV",GRP,OGNM,ON))+1
 Q
