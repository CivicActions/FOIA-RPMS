LA59 ;DALOI/JMC - LA*5.2*59 PATCH ENVIRONMENT CHECK ROUTINE ;5/5/2000
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**59**;Sep 27, 1994
EN ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
 I '$G(XPDENV) D  Q
 . S XQAMSG="Transport global for patch "_$G(XPDNM,"Unknown patch")_" loaded on "_$$HTE^XLFDT($H)
 . S XQA("G.LMI")=""
 . D SETUP^XQALERT
 . D BMES^XPDUTL($$CJ^XLFSTR("Sending transport global loaded alert to mail group G.LMI",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" started on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 D CHECK
 D EXIT
 Q
 ;
CHECK ; Perform environment check
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("Terminal Device is not defined",80))
 . S XPDQUIT=2
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("Please log in to set local DUZ... variables",80))
 . S XPDQUIT=2
 I $P($$ACTIVE^XUSER(DUZ),"^")'=1 D  Q
 . D BMES^XPDUTL($$CJ^XLFSTR("You are not a valid user on this system",80))
 . S XPDQUIT=2
 S XPDIQ("XPZ1","B")="NO"
 Q
 ;
EXIT ;
 I $G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Install Environment Check FAILED ---",80))
 I '$G(XPDQUIT) D BMES^XPDUTL($$CJ^XLFSTR("--- Environment Check is Ok ---",80))
 Q
 ;
 ;
PRE ; KIDS Pre install for LA*5.2*59
 ;
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install started alert to mail group G.LMI",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install started ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("--- No action required ---",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Pre install completed ***",80))
 ;
 Q
 ;
 ;
POST ; KIDS Post install for LA*5.2*59
 N LA7ACT,X,XQA,XQAMSG
 ;
 S LA7ACT=0
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install started ***",80))
 ;
 ; Check if site has routine LA7UIIN3 (LA*5.2*41 test patch).
 D CHKLA41
 ;
 I 'LA7ACT D BMES^XPDUTL($$CJ^XLFSTR("--- No action required ---",80))
 D BMES^XPDUTL($$CJ^XLFSTR("*** Post install completed ***",80))
 D BMES^XPDUTL($$CJ^XLFSTR("Sending install completion alert to mail group G.LMI",80))
 ;
 S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 S XQA("G.LMI")=""
 D SETUP^XQALERT
 ;
 Q
 ;
 ;
CHKLA41 ; Check for patch LA*5.2*41 in history or patch routines
 ; and send mail message if found.
 ;
 N DIF,DIFROM,LA41,LAROU,LASITE,LAX,X,Y
 N XCNP,XMINSTR,XMSUB,XMTO
 ;
 S LA41=$$PATCH^XPDUTL("LA*5.2*41")
 F LAX="LA7UIIN3","LAMIDWN0" D
 . S X=LAX X ^%ZOSF("TEST") Q:'$T
 . S X=LAX X ^%ZOSF("RSUM")
 . S LAROU(LAX)=Y
 ;
 ; No patch history or routines.
 I 'LA41,$O(LAROU(""))="" Q
 ;
 S LASITE=$$KSP^XUPARAM("WHERE")
 I LASITE'[".VA.GOV" Q
 ;
 K ^TMP("LA41",$J)
 S ^TMP("LA41",$J,1,0)="$TXT Created by POSTMASTER at "_LASITE_" on "_$$HTE^XLFDT($H)
 S ^TMP("LA41",$J,2,0)="LA*5.2*41 in patch history: "_$S(LA41:"YES",1:"NO")
 S LAX=""
 F XCNP=3:1 S LAX=$O(LAROU(LAX)) Q:LAX=""  S ^TMP("LA41",$J,XCNP,0)="Routine "_$$LJ^XLFSTR(LAX,8)_" checksum value = "_LAROU(LAX)
 S ^TMP("LA41",$J,XCNP,0)="END $TXT"
 S $P(^TMP("LA41",$J,0),U,3,4)=XCNP_U_XCNP
 ;
 S DIF="^TMP(""LA41"",$J,"
 S LAX=""
 F  S LAX=$O(LAROU(LAX)) Q:LAX=""  D
 . S X=LAX,XCNP=XCNP+1,@(DIF_XCNP_",0)")="$ROU "_X
 . X ^%ZOSF("LOAD") S $P(@(DIF_"0)"),U,3,4)=XCNP_U_XCNP
 . S @(DIF_XCNP_",0)")="$END ROU "_X
 ;
 S XMSUB="Patch LA*5.2*41 found installed at "_LASITE
 S XMTO("G.LABTEAM@ISC-DALLAS.VA.GOV")=""
 S XMINSTR("FROM")=.5
 S XMINSTR("ADDR FLAGS")="R"
 D SENDMSG^XMXAPI(DUZ,XMSUB,"^TMP(""LA41"",$J)",.XMTO,.XMINSTR)
 D BMES^XPDUTL($$CJ^XLFSTR("--- Sending mail message to Lab Development Team  ---",80))
 D BMES^XPDUTL($$CJ^XLFSTR("--- that test patch LA*5.2*41 exists on this system ---",80))
 ;
 S LA7ACT=1
 K ^TMP("LA41",$J)
 Q
