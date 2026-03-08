BPDM27PS ;ihs/cmi/maw - PDM 2.0 Patch 7 Post Init ; 03 Nov 2021  3:13 PM
 ;;2.0;CONTROLLED DRUG EXPORT SYSTEM;**7**;NOV 15, 2011;Build 51
 ;
ENV ;-- environment check
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I '$$INSTALLD("XU*8.0*1018") D SORRY(2) Q
 I '$$INSTALLD("DI*22.0*1018") D SORRY(2) Q
 I '$$INSTALLD("APSP*7.0*1034") D SORRY(2) Q
 I '$$INSTALLD("BPDM*2.0*6") D SORRY(2) Q
 Q
 ;
PRE ;-- pre init calls
 ;I '$$INSTALLD("APSP*7.0*1034") D APSP34
 Q
 ;
APSP34 ;-- add p34 to package file for beta
 N PKG,VER,PATCH,PATCHI
 S PKG=$O(^DIC(9.4,"C","APSP",0))
 Q:'PKG
 S VER=$O(^DIC(9.4,PKG,22,"B","7.0",0))
 Q:'VER
 N FDA,FERR,FIENS
 S FIENS="+3,"_VER_","_PKG_","
 S FDA(9.4901,FIENS,.01)=1034
 S FDA(9.4901,FIENS,.02)=DT
 S FDA(9.4901,FIENS,.03)=DUZ
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 Q
 ;
RAPSP34 ;-- remove P1034 after install
 N PKG,VER,PATCH,PATCHI
 S PKG=$O(^DIC(9.4,"C","APSP",0))
 Q:'PKG
 S VER=$O(^DIC(9.4,PKG,22,"B","7.0",0))
 Q:'VER
 S PATCHI=$O(^DIC(9.4,PKG,22,VER,"PAH","B",1034,0))
 Q:'PATCHI
 S DIK="^DIC(9.4,"_PKG_",22,"_VER_",PAH,"
 S DA=PATCHI
 D ^DIK
 Q
 ;
POST ;-- post init calls
 ;N FLDS
 D AIRF
 D PROTO("APSP PICKUP LOG EVENT","BPDM PICKUP AIR ELEMENTS")
 ;D RAPSP34
 ;D ADDNOPTS
 ;D PAT01
 ;D DSP13  ;V4.2 AND V4.2A
 ;D RIDXPEL
 Q
 ;
AIRF ;-- populate new 4.2B fields
 W !,"Adding date for new DSP and AIR fields..."
 D FLD("DSP","DSP17","S X=$$DSP17^BPDMUTL1(BPDMR,BPDMRF)")
 D FLD("AIR","AIR03","S X=$$AIR03^BPDMUTL1(BPDMR,BPDMRF)")
 D FLD("AIR","AIR04","S X=$$AIR04^BPDMUTL1(BPDMR,BPDMRF)")
 D FLD("AIR","AIR05","S X=$$AIR05^BPDMUTL1(BPDMR,BPDMRF)")
 D FLD("AIR","AIR06","S X=$$AIR06^BPDMUTL1(BPDMR,BPDMRF)")
 D FLD("AIR","AIR07","S X=$$AIR07^BPDMUTL1(BPDMR,BPDMRF)")
 D FLD("AIR","AIR08","S X=$$AIR08^BPDMUTL1(BPDMR,BPDMRF)")
 D FLD("AIR","AIR11","S X=$$AIR11^BPDMUTL1(BPDMR,BPDMRF)")
 Q
 ;
RIDXPEL ;-- reindex the ABF cross reference on the PDM EXPORT LOG file
 ;Q:$D(^BPDMLOG("ABF"))  ;dont index if already present
 S DIK="^BPDMLOG("
 S DIK(1)=".1"
 D ENALL^DIK
 Q
 ;
FLD(SEG,FLD,VAL) ;-- populate the field with a value
 N ENT,ENTA
 S ENT=$O(^BPDMRECC("B",SEG,0))
 Q:'ENT
 S ENTA=$O(^BPDMRECC(ENT,11,"B",FLD,0))
 Q:'ENTA
 S ^BPDMRECC(ENT,11,ENTA,11)=VAL
 Q
 ;
DSP01 ;-- remove minnesota specific code
 N ENT,ENTA
 S ENT=$O(^BPDMRECA("B","DSP",0))
 Q:'ENT
 S ENTA=$O(^BPDMRECA(ENT,11,"B","DSP01",0))
 Q:'ENTA
 S ^BPDMRECA(ENT,11,ENTA,11)="S X=BPDMSTAT"
 Q
 ;
PRE08 ;-- setup the phone number field for all sites
 N PRE,PREA
 S PRE=$O(^BPDMRECA("B","PRE",0))
 Q:'PRE
 S PREA=$O(^BPDMRECA(PRE,11,"B","PRE08",0))
 Q:'PREA
 S ^BPDMRECA(PRE,11,PREA,11)="S X=$$PRE08^BPDMUTL(BPDMPROV,BPDMSTE)"
 Q
 ;
MKREQ(STE,FLD) ;-- make the fields required
 N FDA,SEG,SIEN,FIEN,STII,STI
 S STI=$O(^DIC(5,"B",STE,0))
 Q:'STI
 S FDA=0 F  S FDA=$O(FLD(FDA)) Q:FDA=""  D
 . S SEG=$E(FDA,1,3)
 . S SIEN=$O(^BPDMRECA("B",SEG,0))
 . Q:'SIEN
 . S FIEN=$O(^BPDMRECA(SIEN,11,"B",FDA,0))
 . Q:'FIEN
 . S STII=$O(^BPDMRECA(SIEN,11,FIEN,12,"B",STI,0))
 . Q:'STII
 . I $P($G(^BPDMRECA(SIEN,11,FIEN,12,STII,0)),U,2)="N" D
 .. S $P(^BPDMRECA(SIEN,11,FIEN,12,STII,0),U,2)="RR"
 Q
 ;
INSTALLD(BPDMSTAL) ;EP - Determine if patch BPDMSTAL was installed, where
 ; BPDMSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BPDMY,DIC,X,Y
 S X=$P(BPDMSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BPDMSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BPDMSTAL,"*",3)
 D ^DIC
 S BPDMY=Y
 D IMES
 Q $S(BPDMY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BPDMSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
ADDNOPTS      ; EP - ADD New OPTionS
 Q:$G(DEBUG)
 ;
 S TAB=$G(TAB,$J("",5))
 ;
 ;D NEWOPT("BPDMMENU","BPDM EXPORT TRANSACTIONS NEW","EPDN",995)
 ;D NEWOPT("BPDMMENU","BPDM EXPORT DATE RANGE NEW","EXDN",996)
 ;D NEWOPT("BPDMMENU","BPDM EXPORT DATE RANGE TST NEW","TESN",997)
 D NEWOPT("BPDMMENU","BPDM UPDATE ZERO REQ ELEMENTS","USRZ",55)
 ;D NEWOPT("BPDMMENU","BPDM SSH KEY GENERATION","SSH",99)
 ;
 Q
 ;
NEWOPT(MENU,NEWOPTN,NEWSYNM,NEWORD) ; EP - Add Option to a Menu
 NEW BLRIEN,TAB
 ;
 S TAB=$J("",5)
 ;
 S BLRIEN=$$LKOPT^XPDMENU(MENU)
 Q:$$FIND1^DIC(19.01,","_BLRIEN_",",,NEWSYNM,"C")    ; Don't add if already on MENU
 ;
 D BMES^XPDUTL("Adding '"_NEWOPTN_"' option to "_MENU_".")
 ;
 S X=$$ADD^XPDMENU(MENU,NEWOPTN,NEWSYNM,$G(NEWORD,""))
 ;
 I X=1 D MES^XPDUTL(TAB_"'"_NEWOPTN_"' added to "_MENU_". OK."),BLANK  Q
 ;
 D MES^XPDUTL(TAB_"Error in adding '"_NEWOPTN_"' option to "_MENU_".")
 D MES^XPDUTL(TAB_TAB_"Error Message: "_$$UP^XLFSTR($P(X,"^",2))),BLANK
 ;
 Q
 ;
BLANK ; EP - Blank Line
 D MES^XPDUTL(" ")
 Q
 ;
PROTO(P,C) ;add the child event to the parent protocol
 N PI,CI,FDA,FERR,FIENS
 S PI=$O(^ORD(101,"B",P,0))
 Q:'PI
 S CI=$O(^ORD(101,"B",C,0))
 Q:'CI
 Q:$O(^ORD(101,PI,10,"B",CI,0))  ;already there don't try to add
 S FIENS="+2,"_PI_","
 S FDA(101.01,FIENS,.01)=CI
 S FDA(101.01,FIENS,3)=989
 D UPDATE^DIE("","FDA","FIENS","FERR(2)")
 Q
 ;
