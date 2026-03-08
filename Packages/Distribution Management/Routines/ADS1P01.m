ADS1P01 ;GDIT/HS/BEE-ADS Version 1.0 Patch 1 Post Install ; 01 Apr 2020  10:00 AM
 ;;1.0;DISTRIBUTION MANAGEMENT;**1**;Apr 23, 2020;Build 16
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT,LIEN
 ;
 ;Check for ADS v1.0
 I $$VERSION^XPDUTL("ADS")<1 D BMES^XPDUTL("Version 1.0 of DISTRIBUTION MANAGEMENT (ADS) is required!") S XPDQUIT=2 Q
 D IMES("VERSION 1.0 of DISTRIBUTION MANAGEMENT (ADS)",1)
 ;
 ;Check for BSTS*2.0*1 - Needed for logging call
 I '$$INSTALLD("BSTS*2.0*1") D BMES^XPDUTL("Version 2.0 Patch 1 of BSTS is required!") S XPDQUIT=2 Q
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D BMES^XPDUTL("Version 8.0 Patch 1020 of XU is required!") S XPDQUIT=2 Q
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D BMES^XPDUTL("Version 22.0 Patch 1020 of DI is required!") S XPDQUIT=2 Q
 ;
 Q
POST ; Post Install Tag (Schedule the option to be run on a periodic basis - and do the first run.)
 ;
 ;For Beta sites - need to loop through and clean up single '
 D LCLN
 ;
 D JOB
 D SCHEDULE
 ;
 Q
LCLN ;Clean up ' entries from BSTS log
 S LIEN="" F  S LIEN=$O(^XTMP("BSTSPROCQ","L",LIEN)) Q:LIEN=""  D
 . NEW NODE,T,NNODE
 . S NODE=$G(^XTMP("BSTSPROCQ","L",LIEN)) Q:NODE=""
 . S T=$P(NODE,U) I T'="LICENSE",T'="ASU",T'="PKG",T'="IZP" Q
 . ;
 . ;Look for ' and convert if needed
 . S NNODE=$$TFRMT^ADSRPT(NODE) Q:NNODE=NODE
 . ;
 . ;An ' was found, replace with updated string
 . S ^XTMP("BSTSPROCQ","L",LIEN)=NNODE
 ;
 Q
JOB ; Job off the ADS SITE INFORMATION EXPORT TASK for the first time immediately.
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 S ZTDESC="ADS SITE INFORMATION EXPORT TASK",ZTRTN="TASK^ADSFAC",ZTIO=""
 D ^%ZTLOAD
 Q
SCHEDULE ; Schedule the task to run on a "Daily" basis.
 ;
 NEW FREQ,OPTION,OPTN,SDATM,ERROR
 S OPTION="ADSSITEEXPORT",FREQ="1D" ; ADS SITE INFORMATION EXPORT TASK
 S OPTN=$$FIND(OPTION) Q:OPTN'>0
 I $O(^DIC(19.2,"B",OPTN,""))'="" Q  ; If already scheduled, do not schedule again.
 S SDATM=$$FMADD^XLFDT(DT,1)_".22" ; Schedule the task for 2200 hours (10PM).
 D RESCH^XUTMOPT(OPTION,SDATM,"",FREQ,"L",.ERROR)
 Q
FIND(X) ;EP - Find an option
 S X=$O(^DIC(19,"B",X,0)) I X'>0 Q -1
 Q X
INSTALLD(ADSSTAL) ;EP - Determine if patch ADSSTAL was installed, where
 ; ADSSTAL is the name of the INSTALL.  E.g "XU*8.0*1019"
 ;
 NEW ADSY,INST
 ;
 S ADSY=$O(^XPD(9.7,"B",ADSSTAL,""))
 S INST=$S(ADSY>0:1,1:0)
 D IMES(ADSSTAL,INST)
 Q INST
 ;
IMES(ADSSTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_ADSSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
