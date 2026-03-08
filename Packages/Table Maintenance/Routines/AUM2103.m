AUM2103 ; IHS/ASDST/GTH - LOCATION FILE COMP UPDATE ; [ 11/28/2001  12:13 PM ]
 ;;02.1;TABLE MAINTENANCE;**3**;SEP 28,2001
 ;
 ; KIDS environment check routine.
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 S X=$$VERSION^XPDUTL("AUM")
 W !!,$$CJ^XLFSTR("Need AUM v 2.1.....AUM v "_X_" Present",IOM)
 I '(+X=2.1) D SORRY(2) Q
 ;
 S X=$$VERSION^XPDUTL("DI")
 W !,$$CJ^XLFSTR("Need at least FileMan 21.....FileMan "_X_" Present",IOM)
 I X<21 D SORRY(2) Q
 ;
 S X=$$VERSION^XPDUTL("XU")
 W !,$$CJ^XLFSTR("Need at least Kernel 8.....Kernel "_X_" Present",IOM)
 I X<8 D SORRY(2) Q
 ;
 S X=$$VERSION^XPDUTL("AUT")
 W !,$$CJ^XLFSTR("Need at least AUT 98.1.....AUT "_X_" Present",IOM)
 I X<98.1,+X'=1.1,+X'=2.1 D SORRY(2) Q
 ;
 NEW DA,DIC
 S X="AUM",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUM")) D  Q
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AUM"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7
 . D SORRY(2)
 . I $$DIR^XBDIR("E")
 .Q
 ;
 W !,$$CJ^XLFSTR("No 'AUM' dups in PACKAGE file",IOM)
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","AUM2103")
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D HELP^XBHELP("INTROI","AUM2103")
 .Q
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ; -----------------------------------------------------
POST ;EP - From KIDS.
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUM2103",$J)
 D AUDS,START^AUM21031,AUDR
 S XMSUB=$P($P($T(+1),";",2)," ",4,99),XMDUZ=$G(DUZ,.5),XMTEXT="^TMP(""AUM2103"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUPROGMODE","AG TM MENU","ABMDZ TABLE MAINTENANCE","APCCZMGR" D SINGLE(%)
 NEW DIFROM
 D ^XMD
 KILL ^TMP("AUM2103",$J)
 D BMES^XPDUTL("The results are in your MailMan 'IN' basket.")
 I $D(ZTQUEUED) S ZTREQ="@"
 Q:'$L($T(+1^AUMDELR))
 S ZTRTN="DEL^AUMDELR(""AUM2103"")",ZTDESC="Delete routines in the 'AUM2103' namespace.",ZTDTH=$$HADD^XLFDT($H,0,0,30,0),ZTIO="",ZTPRI=1
 D ^%ZTLOAD
 I '$D(ZTSK) D BMES^XPDUTL("Q to TaskMan to delete routines in background failed (?).") Q
 D BMES^XPDUTL("NOTE:  The routines in this update will be deleted in background"),MES^XPDUTL("30 minutes from now by Task #"_ZTSK_".")
 Q
 ; -----------------------------------------------------
SINGLE(K) ; Get holders of a single key K.
 NEW Y
 S Y=0
 Q:'$D(^XUSEC(K))
 F  S Y=$O(^XUSEC(K,Y)) Q:'Y  S XMY(Y)=""
 Q
 ;
 ; -----------------------------------------------------
 ; Data auditing at the file level is indicated by a lower case "a"
 ; in the 2nd piece of the 0th node of the global.
 ; Data auditing at the field level is indicated by a lower case "a"
 ; in the 2nd piece of the 0th node of the field definition in ^DD(.
AUDS ; Save current settings, and SET data auditing 'on'.
 S ^XTMP("AUM*2.1*3",0)=$$FMADD^XLFDT(DT,56)_"^"_DT_"^"_"AUM*2.1*3 STANDARD TABLE UPDATES"
 NEW G,P
 F %=1:1 S G=$P($T(AUD+%),";",3) Q:G="END"  D
 . S P=$P(@(G_"0)"),"^",2)
 . I '$D(^XTMP("AUM*2.1*3",G)) S ^XTMP("AUM*2.1*3",G)=P
 . S:'(P["a") $P(@(G_"0)"),"^",2)=P_"a"
 . Q:'(G["^DD(")
 . I '$D(^XTMP("AUM*2.1*3",G,"AUDIT")) S ^XTMP("AUM*2.1*3",G,"AUDIT")=$G(@(G_"""AUDIT"")"))
 . S (@(G_"""AUDIT"")"))="y"
 .Q
 Q
 ; -----------------------------------------------------
AUDR ; Restore the file data audit values to their original values.
 NEW G,P
 F %=1:1 S G=$P($T(AUD+%),";",3) Q:G="END"  D
 . S $P(@(G_"0)"),"^",2)=^XTMP("AUM*2.1*3",G)
 . Q:'(G["^DD(")
 . S (@(G_"""AUDIT"")"))=^XTMP("AUM*2.1*3",G,"AUDIT")
 . K:@(G_"""AUDIT"")")="" @(G_"""AUDIT"")")
 .Q
 Q
 ; -----------------------------------------------------
AUD ; These are files/fields to be audited for this patch, only.
 ;;^AUTTAREA(
 ;;^DD(9999999.21,.01,
 ;;^DD(9999999.21,.02,
 ;;^DD(9999999.21,.03,
 ;;^DD(9999999.21,.04,
 ;;^AUTTSU(
 ;;^DD(9999999.22,.01,
 ;;^DD(9999999.22,.02,
 ;;^DD(9999999.22,.03,
 ;;^DD(9999999.22,.04,
 ;;^AUTTLOC(
 ;;^DD(9999999.06,.01,
 ;;^DD(9999999.06,.04,
 ;;^DD(9999999.06,.05,
 ;;^DD(9999999.06,.07,
 ;;^DD(9999999.06,.31,
 ;;^DIC(4,
 ;;^DD(4,.01,
 ;;END
 ; -----------------------------------------------------
INTROE ; Intro text during KIDS Environment check.
 ;;The contents of this KIDS distribution automates a comprehensive
 ;;update to the LOCATION file.  This comprehensive update is at the
 ;;request of the IHS SCB WorkGroup.  That WG is convened under the
 ;;authority of the Principal Statistician, IHS Headquarters.  Data
 ;;used in this update was extracted from the NPIRS SCB table,
 ;;Section VIII-C, as of 2001 Nov 20.  Because LOCATION requires
 ;;entries in the SERVICE UNIT and AREA files, this distribution also
 ;;updates those files, where necessary.
 ;;NOTE:  INACTIVE facilities are -not- added into your local
 ;;       LOCATION file.
 ;;###
 ;
INTROI ; Intro text during KIDS Install.
 ;;A standard message will be produced by this update.
 ;;  
 ;;If you run interactively, results will be displayed on your screen,
 ;;as well as in the mail message and the entry in the INSTALL file.
 ;;If you queue to TaskMan, please read the mail message for results of
 ;;this update, and remember not to Q to the HOME device.
 ;;###
 ;
GREET ;;EP - To add to mail message.
 ;;  
 ;;Greetings.
 ;;  
 ;;This is a comprehensive update to your RPMS LOCATION, AREA, and
 ;;SERVICE UNIT files.  This report is by action only.  I.e., if the
 ;;entries in your files match the data in this distribution, no action
 ;;will be taken or reported.
 ;;
 ;;Sections of the IHS Standard Code Book (SCB) can be viewed, printed,
 ;;and extracted from the NPIRS IntrAnet website at url:
 ;;  http://dpsntweb1.hqw.ihs.gov/ciweb/main.html
 ;;  
 ;;Standard tables on your RPMS system have been updated.
 ;;  
 ;; ( Just a reminder....
 ;;   Data auditing is turned on for add/edits to the files effected
 ;;   by this update.  When the add/edits are complete, the data
 ;;   audit configurations are returned to their pre-update values.
 ;;   
 ;;   If you retrieve the audits from the AUDIT file, it "appears"
 ;;   like whomever ran this update modified the data. )
 ;;  
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information, only.
 ;;You need do nothing in response to this message.
 ;;  
 ;;Requests for modifications or additions to RPMS standard tables,
 ;;whether they are or are not reflected in the IHS Standard Code
 ;;Book (SCB), can be submitted to your Area Information System
 ;;Coordinator (ISC).
 ;;  
 ;;Questions about this patch, which is a product of the RPMS DBA
 ;;(George T. Huggins, 520-670-4871), can be directed to the DIR/RPMS
 ;;Support Center, at 505-248-4371, or via e-mail to
 ;;"hqwhd@mail.ihs.gov".  Please refer to patch "AUM*2.1*3".
 ;;  
 ;;###;NOTE: This line indicates the end of text in this message.
 ;
