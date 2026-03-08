AUM2101 ; IHS/ASDST/GTH - STANDARD TABLE UPDATES, 2001 SEP 28 ; [ 10/31/2001   3:40 PM ]
 ;;02.1;TABLE MAINTENANCE;**1**;SEP 28,2001
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
 I X<98.1,+X'=1.1 D SORRY(2) Q
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
 D HELP^XBHELP("INTROE","AUM2101")
 ;
 I $G(XPDENV)=1 D
 . ; The following line prevents the "Disable Options..." and "Move
 . ; Routines..." questions from being asked during the install.
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D HELP^XBHELP("INTROI","AUM2101")
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
 ;
POST ;EP - From KIDS.
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUM2101",$J)
 D AUDS,START^AUM21011,START^AUM21012,AUDR
 S XMSUB=$P($P($T(+1),";",2)," ",4,99),XMDUZ=$G(DUZ,.5),XMTEXT="^TMP(""AUM2101"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUPROGMODE","AG TM MENU","ABMDZ TABLE MAINTENANCE","APCCZMGR" D SINGLE(%)
 NEW DIFROM
 D ^XMD
 KILL ^TMP("AUM2101",$J)
 D BMES^XPDUTL("The results are in your MailMan 'IN' basket.")
 S ZTRTN="DEL^AUMDELR(""AUM2101"")",ZTDESC="Delete routines in the 'AUM2101' namespace.",ZTDTH=$$HADD^XLFDT($H,0,0,30,0),ZTIO="",ZTPRI=1
 D ^%ZTLOAD
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
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
 S ^XTMP("AUM*2.1*1",0)=$$FMADD^XLFDT(DT,56)_"^"_DT_"^"_"AUM*2.1*1 STANDARD TABLE UPDATES"
 NEW G,P
 F %=1:1 S G=$P($T(AUD+%),";",3) Q:G="END"  D
 . S P=$P(@(G_"0)"),"^",2)
 . I '$D(^XTMP("AUM*2.1*1",G)) S ^XTMP("AUM*2.1*1",G)=P
 . S:'(P["a") $P(@(G_"0)"),"^",2)=P_"a"
 . Q:'(G["^DD(")
 . I '$D(^XTMP("AUM*2.1*1",G,"AUDIT")) S ^XTMP("AUM*2.1*1",G,"AUDIT")=$G(@(G_"""AUDIT"")"))
 . S (@(G_"""AUDIT"")"))="y"
 .Q
 Q
 ;
AUDR ; Restore the file data audit values to their original values.
 NEW G,P
 F %=1:1 S G=$P($T(AUD+%),";",3) Q:G="END"  D
 . S $P(@(G_"0)"),"^",2)=^XTMP("AUM*2.1*1",G)
 . Q:'(G["^DD(")
 . S (@(G_"""AUDIT"")"))=^XTMP("AUM*2.1*1",G,"AUDIT")
 . K:@(G_"""AUDIT"")")="" @(G_"""AUDIT"")")
 .Q
 Q
 ;
AUD ; These are files/fields to be audited for this patch, only.
 ;;^AUTTAREA(
 ;;^AUTTSU(
 ;;^AUTTCTY(
 ;;^AUTTLOC(
 ;;^DIC(4,
 ;;^AUTTCOM(
 ;;^AUTTREFT(
 ;;^AUTTMSR(
 ;;^DD(9999999.21,.01,
 ;;^DD(9999999.21,.02,
 ;;^DD(9999999.21,.03,
 ;;^DD(9999999.21,.04,
 ;;^DD(9999999.22,.01,
 ;;^DD(9999999.22,.02,
 ;;^DD(9999999.22,.03,
 ;;^DD(9999999.22,.04,
 ;;^DD(9999999.23,.01,
 ;;^DD(9999999.23,.02,
 ;;^DD(9999999.23,.03,
 ;;^DD(9999999.23,.04,
 ;;^DD(9999999.23,.06,
 ;;^DD(9999999.06,.01,
 ;;^DD(9999999.06,.04,
 ;;^DD(9999999.06,.05,
 ;;^DD(9999999.06,.07,
 ;;^DD(9999999.06,.31,
 ;;^DD(4,.01,
 ;;^DD(9999999.05,.01,
 ;;^DD(9999999.05,.02,
 ;;^DD(9999999.05,.03,
 ;;^DD(9999999.05,.05,
 ;;^DD(9999999.05,.06,
 ;;^DD(9999999.05,.07,
 ;;^DD(9999999.73,.01,
 ;;^DD(9999999.73,.02,
 ;;^DD(9999999.73,.03,
 ;;^DD(9999999.07,.01,
 ;;^DD(9999999.07,.02,
 ;;^DD(9999999.07,.03,
 ;;END
 ; -----------------------------------------------------
INTROE ; Intro text during KIDS Environment check.
 ;;The contents of this distribution automates additions to
 ;;standard IHS tables as distributed by a message from Joseph
 ;;Herrera, date stamped September 28, 2001, and adds entries to
 ;;the MEASUREMENT TYPE and REFUSAL TYPE files.
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
 ;;Questions about this patch, which is a product of the RPMS DBA,
 ;;can be directed to the DIR/RPMS Support Center, at
 ;;505-248-4371, or via e-mail to "hqwhd@mail.ihs.gov".  Please
 ;;refer to patch "AUM*2.1*1".
 ;;  
 ;;###;NOTE: This line indicates the end of text in this message.
 ;
