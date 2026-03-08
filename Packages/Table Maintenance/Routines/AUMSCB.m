AUMSCB ;IHS/OIT/NKD - SCB UPDATE ENVIRONMENT CHECK/PRE/POST INSTALL 3/08/2013 ;
 ;;26.0;TABLE MAINTENANCE;**1**;SEP 11,2025;Build 1
 ; 03/12/14 - Removed use of AUMPRE for pre-install, changed to just remove AUMDATA entries
 ; 12/16/14 - Removed old/unused code, added support for future environment checking
 ; 03/11/15 - Modified environment checking display to write to screen
 ; 12/04/17 - Removed confirmation prompt from environment checker
 ; 03/23/20 - One time Health Factor index cleanup
 ;          - Off-cycle emergency COVID-19 code update
 ; AUM*21.0*2 - Moved TAG processing to AUMSCBD
 ; AUM*23.0*4 - TRIBE INA CLEANUP
 ; AUM*23.0*5 - PROVIDER CLASS AUDIT CHECK
 ; AUM*24.0*4 - AUT REQUIREMENT UPDATE FOR SOP FILE
 ; AUM*24.0*5 - AUT REQUIREMENT UPDATE FOR HTI-1
 ; AUM*25.0*4 - AVA REQUIREMENT UPDATE FOR HTI-1
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),80)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_$S($L($P($T(+2),";",5))>4:" Patch "_$P($T(+2),";",5),1:"")_".",80),!
 ;
 S:'$$VCHK("XU","8.0","1018") XPDQUIT=2
 S:'$$VCHK("DI","22.0","1018") XPDQUIT=2
 ;S:'$$VCHK("AUM","20.0") XPDQUIT=2  ;IHS/OIT/NKD AUM*20.0*2 ADDED ONE TIME ICD REQUIREMENT
 S:'$$PCHK("AUM","25.0","5") XPDQUIT=2
 S:'$$VCHK("AVA","93.2","29") XPDQUIT=2
 S:'$$VCHK("AUT","98.1","33") XPDQUIT=2
 ;
 NEW DA,DIC
 S X="AUM",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUM")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",80),!,$$CJ^XLFSTR("PACKAGE File with an ""AUM"" prefix.",80)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",80)
 . D SORRY(2)
 .Q
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",80),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",80)
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 .Q
 ;
 ;I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2)  ;IHS/OIT/NKD AUM*18.0*1 REMOVED CONFIRMATION PROMPT
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",80)
 Q
 ;
VCHK(AUMPRE,AUMVER,AUMPAT) ; Check patch level
 N AUMV,AUMP
 S AUMV=$$VERSION^XPDUTL(AUMPRE)
 I (AUMV<AUMVER) K DIFQ D DISP(AUMPRE,AUMVER,$G(AUMPAT),AUMV,$G(AUMP),0) Q 0
 I '$D(AUMPAT) D DISP(AUMPRE,AUMVER,$G(AUMPAT),AUMV,$G(AUMP),1) Q 1
 S AUMP=+$$LAST(AUMPRE,AUMVER)
 I (AUMP<AUMPAT) K DIFQ D DISP(AUMPRE,AUMVER,$G(AUMPAT),AUMVER,$G(AUMP),0) Q 0
 D DISP(AUMPRE,AUMVER,$G(AUMPAT),AUMVER,$G(AUMP),1)
 Q 1
 ;
 ; IHS/OIT/NKD AUM*15.0*1 ADDED FUTURE SUPPORT FOR GLOBAL/PATCH CHECKING - START NEW CODE
GCHK(AUMGL,AUMMSG) ; Check for global
 Q:'$L($G(AUMGL)) 0
 N AUMS
 S AUMS="Requires "_$S('$L($G(AUMMSG)):AUMGL,1:$G(AUMMSG))_"....."
 S AUMS=AUMS_$S($D(@AUMGL):"Present",1:"Not found ***FIX IT***")
 ;D MES^XPDUTL($$CJ^XLFSTR(AUMS,IOM))  ; IHS/OIT/NKD AUM*15.0*2 WRITE TO SCREEN
 W !,$$CJ^XLFSTR(AUMS,80)
 Q $S($D(@AUMGL):1,1:0)
 ;
PCHK(PKG,VER,PAT) ; Check specific patch
 N PKGIEN,VERIEN,PATIEN,AUMS
 S PKG=$G(PKG),VER=$G(VER),PAT=$G(PAT)
 S AUMS="Requires "_PKG_" v"_VER_" p"_PAT_"....."
 D
 . S PKGIEN=+$O(^DIC(9.4,"C",PKG,"")) Q:'PKGIEN
 . S VERIEN=+$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN
 . S PATIEN=+$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH","B",PAT,""))
 S AUMS=AUMS_$S(+$G(PATIEN):"Present",1:"Not found ***FIX IT***")
 ;D MES^XPDUTL($$CJ^XLFSTR(AUMS,IOM))  ; IHS/OIT/NKD AUM*15.0*2 WRITE TO SCREEN
 W !,$$CJ^XLFSTR(AUMS,80)
 Q $S(+$G(PATIEN):1,1:0)
 ; IHS/OIT/NKD AUM*15.0*1 END NEW CODE
 ;
DISP(AUMPRE,AUMVER,AUMPAT,AUMV,AUMP,AUMR) ; Display requirement checking results
 ;
 N AUMS
 S AUMS="Need at least "_$G(AUMPRE)_" v"_$G(AUMVER)_$S($G(AUMPAT)]"":" p"_$G(AUMPAT),1:"")_"....."
 S AUMS=AUMS_$G(AUMPRE)_" v"_$G(AUMV)_$S($G(AUMP)]"":" p"_$G(AUMP),1:"")_" Present"
 S AUMS=AUMS_$S('AUMR:" ***FIX IT***",1:"")
 W !,$$CJ^XLFSTR(AUMS,80)
 Q
LAST(PKG,VER) ; EP - returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"C",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
 ;
PRE ; EP FR KIDS
 ; REMOVE DATA FROM AUMDATA
 N AUMI
 S AUMI=0 F  S AUMI=$O(^AUMDATA(AUMI)) Q:'AUMI  K ^AUMDATA(AUMI)
 F AUMI=3,4 S $P(^AUMDATA(0),"^",AUMI)=0
 ; IHS/OIT/NKD AUM*20.0*2 HF INDEX CLEANUP - START NEW CODE
 ;D BMES^XPDUTL("AUM*20.0*2 Pre-install cleanup of Health Factor index...")
 ;K ^AUTTHF("F")
 ;N DIK S DIK="^AUTTHF(",DIK(1)=".03^F" D ENALL^DIK
 ; IHS/OIT/NKD AUM*20.0*2 END NEW CODE
 Q
 ;
POST ; EP FR KIDS
 K ^TMP("AUM",$J)
 ; IHS/OIT/NKD AUM*23.0*4 TRIBE INA CLEANUP - START NEW CODE
 ;D BMES^XPDUTL("AUM*23.0*4 POST-install cleanup of Tribe Inactive field values...")
 ;S AUMI=0 F  S AUMI=$O(^AUTTTRI(AUMI)) Q:'AUMI  S:$P($G(^AUTTTRI(AUMI,0)),"^",4)="N" $P(^AUTTTRI(AUMI,0),"^",4)=""
 ; IHS/OIT/NKD AUM*23.0*4 END NEW CODE
 ; IHS/OIT/NKD AUM*23.0*5 PROVIDER CLASS AUDIT CHECK - START NEW CODE
 ;D BMES^XPDUTL("AUM*23.0*5 POST-install audit file check...")
 ;N AUMI
 ;I $D(^DIA(7)),'$D(^DIA(7,0)) S AUMI=$O(^DIA(7,"@"),-1) S:AUMI ^DIA(7,0)="PROVIDER CLASS AUDIT^1.1I^"_AUMI_"^"_AUMI
 ; IHS/OIT/NKD AUM*23.0*5 END NEW CODE
 D POST^AUMSCBD
 Q
 ;
