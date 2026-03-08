AUM3104 ;IHS/SET/GTH - SCB UPDATE 2002 DEC 02 ; [ 12/05/2002   9:27 AM ]
 ;;3.1;TABLE MAINTENANCE;**4**;SEP 23,2002
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_" Patch "_$P($T(+2),";",5)_".",IOM)
 ;
 I $$VCHK("AUM","3.1",2,"'=")
 ;
 NEW DA,DIC
 S X="AUM",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","AUM")) D
 . W !!,*7,*7,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM),!,$$CJ^XLFSTR("PACKAGE File with an ""AUM"" prefix.",IOM)
 . W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 . D SORRY(2)
 .Q
 ;
 I $G(XPDQUIT) W !,$$CJ^XLFSTR("FIX IT! Before Proceeding.",IOM),!!,*7,*7,*7 Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 D HELP^XBHELP("INTROE","AUM3104")
 ;
 I $G(XPDENV)=1 D
 . S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 . D HELP^XBHELP("INTROI","AUM3104")
 .Q
 ;
 I '$$DIR^XBDIR("E","","","","","",1) D SORRY(3)
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
 ;
VCHK(AUMPRE,AUMVER,AUMQUIT,AUMCOMP) ; Check versions needed.
 ;  
 NEW AUMV
 S AUMV=$$VERSION^XPDUTL(AUMPRE)
 W !,$$CJ^XLFSTR("Need "_$S(AUMCOMP="<":"at least ",1:"")_AUMPRE_" v "_AUMVER_"....."_AUMPRE_" v "_AUMV_" Present",IOM)
 I @(AUMV_AUMCOMP_AUMVER) D SORRY(AUMQUIT) Q 0
 Q 1
 ;
INSTALLD(AUM) ;EP - Determine if patch AUM was installed, where AUM is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 ;
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(AUM,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(AUM,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(AUM,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ;
 ; -----------------------------------------------------
POST ;EP - From KIDS.
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 KILL ^TMP("AUM3104",$J)
 D AUDS,START^AUM31041,AUDR
 S XMSUB=$P($P($T(+1),";",2)," ",3,99),XMDUZ=$G(DUZ,.5),XMTEXT="^TMP(""AUM3104"",$J,",XMY(1)="",XMY(DUZ)=""
 F %="XUPROGMODE","AGZBILL","ABMDZ TABLE MAINTENANCE","APCCZMGR" D SINGLE(%)
 NEW DIFROM
 D ^XMD
 KILL ^TMP("AUM3104",$J)
 D BMES^XPDUTL("The results are in your MailMan 'IN' basket.")
 I $D(ZTQUEUED) S ZTREQ="@"
 Q:'$L($T(+1^AUMDELR))
 S ZTRTN="DEL^AUMDELR(""AUM3104"")",ZTDESC="Delete routines in the 'AUM3104' namespace.",ZTDTH=$$HADD^XLFDT($H,0,0,30,0),ZTIO="",ZTPRI=1
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
 S ^XTMP("AUM3104",0)=$$FMADD^XLFDT(DT,56)_"^"_DT_"^"_"2002 DEC 02 STANDARD TABLE UPDATES"
 NEW G,P
 F %=1:1 S G=$P($T(AUD+%),";",3) Q:G="END"  D
 . S P=$P(@(G_"0)"),"^",2)
 . I '$D(^XTMP("AUM3104",G)) S ^XTMP("AUM3104",G)=P
 . S:'(P["a") $P(@(G_"0)"),"^",2)=P_"a"
 . D AUDF(+P)
 .Q
 Q
AUDF(F) ; Process all fields for file F, including sub-files.
 NEW D,P
 S D=0
 F  S D=$O(^DD(F,D)) Q:'D  D
 . I $P(^DD(F,D,0),U,2) D AUDF(+$P(^(0),U,2)) Q
 . S P=$P(^DD(F,D,0),U,2),G="^DD("_F_","_D_","
 . I '$D(^XTMP("AUM3104",G)) S ^XTMP("AUM3104",G)=P
 . I '$D(^XTMP("AUM3104",G,"AUDIT")) S ^XTMP("AUM3104",G,"AUDIT")=$G(@(G_"""AUDIT"")"))
 . S:'(P["a") $P(@(G_"0)"),"^",2)=P_"a"
 . S ^DD(F,D,"AUDIT")="y"
 .Q
 Q
 ; -----------------------------------------------------
AUDR ; Restore the file data audit values to their original values.
 NEW G,P
 S G=0
 F  S G=$O(^XTMP("AUM3104",G)) Q:'$L(G)  D
 . S $P(@(G_"0)"),"^",2)=^XTMP("AUM3104",G)
 . Q:'(G["^DD(")
 . S (@(G_"""AUDIT"")"))=^XTMP("AUM3104",G,"AUDIT")
 . K:@(G_"""AUDIT"")")="" @(G_"""AUDIT"")")
 .Q
 Q
 ; -----------------------------------------------------
AUD ; These are files to be data audited for this patch, only.
 ;;^AUTTAREA(
 ;;^AUTTCOM(
 ;;^AUTTCTY(
 ;;^AUTTLOC(
 ;;^AUTTSU(
 ;;^AUTTTRI(
 ;;END
 ;
AUDPRT ;
 Q:$D(ZTQUEUED)
 W !,"*** Print from the AUDIT file."
 NEW DIC
 S DIC=1,DIC("A")="Select the file from which you want to print the data AUDIT: ",DIC(0)="A"
 D ^DIC
 Q:+Y<1
 NEW BY,FLDS
 S DIC="^DIA("_+Y_",",FLDS="[CAPTIONED]",BY=.02
 D EN1^DIP
 Q
 ; -----------------------------------------------------
INTROE ; Intro text during KIDS Environment check.
 ;;This distribution:
 ;;(1) Implements SCB mods for 02 Dec 2002.
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
 ;;You are receiving this message because of the particular RPMS
 ;;security keys that you hold.  This is for your information, only.
 ;;You need do nothing in response to this message.
 ;;  
 ;;Requests for modifications or additions to RPMS standard tables,
 ;;whether they are or are not contained in the IHS Standard Code
 ;;Book (SCB), can be submitted to your Area Information System
 ;;Coordinator (ISC).
 ;;  
 ;;Sections of the IHS Standard Code Book (SCB) can be viewed, printed,
 ;;and extracted from the NPIRS IntrAnet website at url:
 ;;  http://dpsntweb1.hqw.ihs.gov/ciweb/main.html
 ;;  
 ;;Questions about this patch, which is a product of the RPMS DBA
 ;;(George T. Huggins, 520-670-4871), can be directed to the DIR/RPMS
 ;;Support Center, at 505-248-4371, or via e-mail to
 ;;"hqwhd@mail.ihs.gov".  Please refer to patch "AUM*3.1*4".
 ;;  
 ;;###;NOTE: This line indicates the end of text in this message.
 ;
