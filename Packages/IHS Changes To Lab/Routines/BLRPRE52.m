BLRPRE52 ; IHS/MSC/MKK - IHS Lab Pre/Post Routine for patch LR*5.2*1052 ; 21-Jun-2022 07:30 ; MKK
 ;;5.2;IHS LABORATORY;**1052**;NOV 01, 1997;Build 17
 ;
EEP ; Ersatz EP
 W !!,$C(7),$C(7),$C(7)
 W !,?4,$$SHOUTMSG^BLRGMENU("Must Use Line Labels To Access Subroutines.",60)
 W !!,$C(7),$C(7),$C(7)
 Q
 ;
 ;
POST ; EP - Post-Install
 NEW BLRVERN,CP,CPSTR,PATCHNUM,TAB,TODAY,WOTCNT
 ;
 D SETEVARS
 ;
 S TODAY=$$DT^XLFDT
 S WOTCNT=$$WOTCNT(BLRVERN)
 S TAB=$J("",5)
 ;
 D BMES^XPDUTL("Post Install of LR*5.2*1052 Begins.")
 ;
 D MONKYPOX
 ;
 D ADDOPTS    ; Add new option to BLRMENU
 ;
 D ADDDELTA   ; Add ARE YOU SURE Delta Check
 ;
 ; D POSTEGFR^BLRP52P3    ; Create CKD-EPI EGFR & BEDSIDE SCHWARTZ EGFR tests in File 60.
 ;
 D RINDEX65   ; RE-INDEX BLOOD INVENTORY (#65) File
 ;
 D BMES^XPDUTL("Post Install of LR*5.2*1052 Ends.")
 Q
 ;
MONKYPOX ; EP - Monkey Pox LOINCs
 NEW TAB
 S TAB=$J("",5)
 D BMES^XPDUTL(TAB_"Adding Monkey Pox LOINCs Begins.")
 D ADDLLCOM^BLRP52P2    ; Add Data to LAB LOINC COMPONENT (#95.31) file
 D ADDLECOD^BLRP52P2    ; Add Data to the LAB ELECTRONIC CODES (#64.061) file
 D ADDLOINC^BLRP52P2    ; Add MONKEYPOX LOINC Data to the LAB LOINC (#95.3) file
 D BMES^XPDUTL(TAB_"Adding Monkey Pox LOINCs Ends.")
 Q
 ;
ADDOPTS ; EP - Add new options to BLRMENU
 NEW NEWOPT,NEWOPTM,TAB
 ;
 S TAB=$J("",5)
 ;
 S NEWOPT="BLR CKD-EPI (2021) Create"
 S NEWOPTM="GFRC"
 D OPTADD(NEWOPT,NEWOPTM,TAB)
 ;
 S NEWOPT="BLR Bedside Schwartz eGFR Make"
 S NEWOPTM="BGFR"   ; Beside GFR
 D OPTADD(NEWOPT,NEWOPTM,TAB)
 ;
 S NEWOPT="BLR COUNT ACC TESTS"
 S NEWOPTM="CACC"
 D OPTADD(NEWOPT,NEWOPTM,TAB)
 ;
 Q
 ;
OPTADD(NEWOPT,NEWOPTM,TAB) ; EP 
 NEW BLRMIEN,F19IEN
 ;
 S TAB=$G(TAB,5)
 ;
 D BMES^XPDUTL(TAB_"Adding '"_NEWOPT_"' option to BLRMENU.")
 ; S BLRMIEN=$$FIND1^DIC(19,,"O","BLRMENU")
 S BLRMIEN=$$LKOPT^XPDMENU("BLRMENU")
 ; S F19IEN=$$FIND1^DIC(19,,"O",NEWOPT)
 S F19IEN=$$LKOPT^XPDMENU(NEWOPT)
 I $O(^DIC(19,BLRMIEN,10,"B",F19IEN,0)) D  Q
 . D MES^XPDUTL(TAB_TAB_"'"_NEWOPT_"' option already on BLRMENU.")
 . D MES^XPDUTL(" ")
 ;
 S X=$$ADD^XPDMENU("BLRMENU",NEWOPT,NEWOPTM)
 D:X=1 MES^XPDUTL(TAB_TAB_"'"_NEWOPT_"' added to BLRMENU. OK.")
 I X'=1 D
 . D MES^XPDUTL(TAB_TAB_"Error in adding '"_NEWOPT_"' option to BLRMENU.")
 . D MES^XPDUTL(TAB_TAB_TAB_"Error Message: "_$$UP^XLFSTR($P(X,"^",2)))
 ;
 D MES^XPDUTL(" ")
 Q
 ;
ADDDELTA ; EP - Add ARE YOU SURE Delta Check
 NEW ERRS,FDA,IEN
 ;
 S IEN=$$FIND1^DIC(62.1,,"O","ARE YOU SURE")  ; Determine if it already exists
 I IEN D  Q
 . D BMES^XPDUTL("'ARE YOU SURE' entry already exists in the DELTA CHECKS (#62.1) file.")
 . D MES^XPDUTL("")
 ;
 S FDA(62.1,"+1,",.01)="ARE YOU SURE"
 S FDA(62.1,"+1,",10)="D AREUSURE^BLRLRX"
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS)<1 D  Q
 . D BMES^XPDUTL("Added 'ARE YOU SURE' entry to DELTA CHECKS (#62.1) file.")
 . D MES^XPDUTL("")
 ;
 ; If here, there was an error.
 D BMES^XPDUTL("ERROR Adding 'ARE YOU SURE' entry to DELTA CHECKS (#62.1) file.")
 D BMES^XPDUTL($J("",5)_"ERROR:"_$G(ERRS("DIERR",1,"TEXT",1))_".")
 D MES^XPDUTL("")
 ;
 ; Send ERROR Email
 NEW ERRMSG
 S ERRMSG(1)="Post Install LR*5.2*1052 Message."
 S ERRMSG(2)=" "
 S ERRMSG(3)="ERROR Adding 'ARE YOU SURE' entry to DELTA CHECKS (#62.1) file."
 S ERRMSG(4)=" "
 S ERRMSG(5)=$J("",5)_"ERROR:"_$G(ERRS("DIERR",1,"TEXT",1))_"."
 ;
 D MAILALMI^BLRUTIL3("Post Install LR*5.2*1052 Error",.ERRMSG,$$GET1^DIQ(200,DUZ,"NAME"))
 Q
 ;
 ;
RINDEX65 ; EP - RE-INDEX BLOOD INVENTORY (#65) File
 NEW TAB
 S TAB=$J("",5)
 D BMES^XPDUTL(TAB_"Re-Indexing Blood Inventory (#65) file Begins.")
 D ^XBFMK
 S DIK="^LRD(65,"
 S DA(1)=65
 D MES^XPDUTL(TAB_TAB_"D IXALL^DIK.")
 D IXALL^DIK
 D ^XBFMK
 D MES^XPDUTL(TAB_"Re-Indexing Blood Inventory (#65) file Ends.")
 Q
 ;
 ;
 ; ========================= UTILITIES FOLLOW ==========================
 ;
SETEVARS ; EP - SET standard "Enviroment" VARiables.
 S (CP,PATCHNUM)=$P($T(+2),"*",3)
 S CPSTR="LR*5.2*"_CP
 S BLRVERN=$TR($P($T(+1),";")," ")
 Q
 ;
BLANK ; EP - Blank Line
 D MES^XPDUTL("")
 Q
 ;
MESCNTR(STR) ; EP - Center a line and use XPDUTL to display it
 D MES^XPDUTL($$CJ^XLFSTR(STR,IOM))
 Q
 ;
WOTCNT(BLRVERN) ; EP - Counter for ^XTMP
 NEW CNT,TODAY
 ;
 S TODAY=$$DT^XLFDT
 ;
 S CNT=1+$G(^XTMP(BLRVERN,0,TODAY))
 S ^XTMP(BLRVERN,0,TODAY)=CNT
 Q $TR($J(CNT,3)," ","0")
