XMZTERM1 ;ISC-SF/GMB - Delete Mailbox (continued) ;06/19/97  14:33
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**44**;Jun 02, 1994
 ; Taken from XUSTERM (SEA/AMF/WDE)
ALL1TASK ;
 N XMI,XMABORT,XMTERM,XMNAME,XMWHY,XMCUTEXT,XMLEN,XMCNT,XMADDED,XMAC,XMVC,XMPM,XMLASTON,XMTDATE,XMDELM,XMTOTAL
 S XMCUTEXT=$$FMTE^XLFDT(XMCUTOFF,"2DF")
 S XMLEN=$L($P(^VA(200,0),U,3))
 S (XMCNT,XMABORT,XMTOTAL)=0
 W:IOST["C-" @IOF D HEADER1
 S XMI=.999
 F  S XMI=$O(^XMB(3.7,XMI)) Q:XMI'>0  D  Q:XMABORT
 . S XMTOTAL=XMTOTAL+1 I '$D(ZTQUEUED) I XMTOTAL\100=0 U IO(0) W:$X>50 ! W "." U IO
 . D CHECK1(XMI,XMGRACE,XMCUTOFF,.XMTERM,.XMNAME,.XMWHY) Q:'XMTERM
 . I $Y+3>IOSL D  Q:XMABORT
 . . I IOST["C-" D  Q:XMABORT
 . . . N DIR
 . . . S DIR(0)="E"
 . . . D ^DIR S:$D(DIRUT) XMABORT=1
 . . W @IOF D HEADER1
 . D GETDATA(XMI,.XMADDED,.XMAC,.XMVC,.XMPM,.XMLASTON,.XMTDATE,.XMDELM)
 . W !,$J(XMI,XMLEN)," ",$E(XMNAME,1,32-XMLEN),?34,XMADDED,?44,XMAC,?47,XMVC,?50,XMPM,?53,XMLASTON,?63,XMTDATE,?76,XMDELM
 . S XMCNT=XMCNT+1
 . D:'XMTEST TERMINAT(XMI)  ; Delete if real mode
 W:XMCNT=0 !!,"No user mailboxes deleted."
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
HEADER1 ;
 W $S(XMTEST:"Test: ",1:""),"Delete user mailbox"
 W !,"(Logon cutoff date: ",XMCUTEXT,", AC=Access Code, VC=Verify Code, PM=Primary Menu)"
 ;       " ^VA(200             Last   Terminate  Delete"
 ;       " Created  AC VC PM  Sign on    Date     Mail"
 ;        xx/xx/xx  y  y  y  xx/xx/xx  xx/xx/xx     y
 W !!,?34," ^VA(200             Last   Terminate  Delete"
 W !,?XMLEN+1,"Delete Mailbox",?34," Created  AC VC PM  Sign on    Date     Mail"
 W !,"-------------------------------------------------------------------------------"
 Q
CHECK1(XMI,XMGRACE,XMCUTOFF,XMTERM,XMNAME,XMWHY) ;
 N XMREC,XMADDED
 S XMTERM=0
 Q:XMI<1
 S XMREC=$G(^VA(200,XMI,0))
 I XMREC="" D  Q
 . S XMTERM=1
 . S XMNAME="*No Name*"
 . S XMWHY="Not in NEW PERSON file"
 ; User is in NEW PERSON file
 S XMADDED=$P($G(^VA(200,XMI,1)),U,7)
 Q:XMADDED>XMGRACE
 I $P(XMREC,U,3)="" D  Q  ; if no access code...
 . N XMTDATE
 . S XMTDATE=$P(XMREC,U,11)
 . I XMTDATE="" D  Q
 . . S XMTERM=1
 . . S XMNAME=$P(XMREC,U)
 . . S XMWHY="No AC, no termination date"
 . I XMTDATE'<DT Q  ; To be Terminated in the future
 . I $P(XMREC,U,5)="n" Q  ; Terminated w/mail retention
 . S XMTERM=1
 . S XMNAME=$P(XMREC,U)
 . S XMWHY="No AC, terminated w/o mail retention"
 ; User has access code
 I $P($G(^VA(200,XMI,201)),U,1)="" D  Q  ; if no primary menu...
 . S XMTERM=1
 . S XMNAME=$P(XMREC,U)
 . S XMWHY="AC, but no PM"
 ; User has primary menu
 N XMLASTON  ; last sign on
 S XMLASTON=$P($G(^VA(200,XMI,1.1)),U)
 I $P($G(^VA(200,XMI,.1)),U,2)="" D  Q  ; if no verify code...
 . I XMLASTON="" D  Q
 . . I XMADDED<XMCUTOFF D  Q
 . . . S XMTERM=1
 . . . S XMNAME=$P(XMREC,U)
 . . . S XMWHY="AC & PM, no VC, no logon, added "_$$FMTE^XLFDT(XMADDED,"2DF")
 . I XMLASTON<XMCUTOFF D  Q
 . . S XMTERM=1
 . . S XMNAME=$P(XMREC,U)
 . . S XMWHY="AC & PM, no VC, last logon "_$$FMTE^XLFDT(XMLASTON,"2DF")
 ; User has verify code
 Q
GETDATA(XMI,XMADDED,XMAC,XMVC,XMPM,XMLASTON,XMTDATE,XMDELM,XMNEW) ;
 N XMREC
 S XMREC=$G(^VA(200,XMI,0))
 S XMADDED=$P($G(^VA(200,XMI,1)),U,7)  ; date added to NEW PERSON file
 S XMADDED=$S(XMADDED="":"",1:$$FMTE^XLFDT(XMADDED,"2DF"))
 S XMAC=$S($P(XMREC,U,3)="":"",1:"Y") ; access code
 S XMVC=$S($P($G(^VA(200,XMI,.1)),U,2)="":"",1:"Y") ; verify code
 S XMPM=$S($P($G(^VA(200,XMI,201)),U,1)="":"",1:"Y") ; primary menu
 S XMLASTON=$P($G(^VA(200,XMI,1.1)),U) ; last sign on
 S XMLASTON=$S(XMLASTON="":"",1:$$FMTE^XLFDT(XMLASTON,"2DF"))
 S XMTDATE=$P(XMREC,U,11)              ; termination date
 S XMTDATE=$S(XMTDATE="":"",1:$$FMTE^XLFDT(XMTDATE,"2DF"))
 S XMDELM=$$UP^XLFSTR($P(XMREC,U,5)) ; delete mail on termination
 S XMNEW=$P($G(^XMB(3.7,XMI,0)),U,6)  ; New messages
 Q
ALL2TASK ;
 N XMI,XMABORT,XMTERM,XMNAME,XMWHY,XMCUTEXT,XMSVC,XMLEN,XMCNT,XMADDED,XMAC,XMVC,XMPM,XMLASTON,XMTDATE,XMDELM,XMREC,XMTOTAL,XMNEW,XMFIRST
 K ^TMP("XM",$J)
 S XMCUTEXT=$$FMTE^XLFDT(XMCUTOFF,"2DF")
 S XMLEN=$L($P(^VA(200,0),U,3))
 S (XMCNT,XMABORT,XMTOTAL)=0,XMFIRST=1
 S XMI=.999
 F  S XMI=$O(^XMB(3.7,XMI)) Q:XMI'>0  D  Q:XMABORT
 . S XMTOTAL=XMTOTAL+1 I '$D(ZTQUEUED) I XMTOTAL\100=0 U IO(0) W:$X>50 ! W "." U IO
 . D CHECK2(XMI,XMCUTOFF,.XMTERM,.XMNAME,.XMWHY) Q:'XMTERM
 . S XMCNT=XMCNT+1
 . D GETDATA(XMI,.XMADDED,.XMAC,.XMVC,.XMPM,.XMLASTON,.XMTDATE,.XMDELM,.XMNEW)
 . S XMSVC=$S($P($G(^VA(200,XMI,5)),U,1)="":"*None*",1:$P($G(^DIC(49,$P(^(5),U,1),0),"*None*"),U,1))
 . S ^TMP("XM",$J,XMSVC,$S(XMNAME="":"*No Name*",1:$E(XMNAME,1,25-XMLEN)),XMI)=XMAC_U_XMVC_U_XMPM_U_XMLASTON_U_XMTDATE_U_XMDELM_U_XMNEW
 S (XMSVC,XMNAME,XMI)=""
 F  S XMSVC=$O(^TMP("XM",$J,XMSVC)) Q:XMSVC=""  D  Q:XMABORT
 . I XMFIRST D
 . . S XMFIRST=0
 . . W:IOST["C-" @IOF D HEADER2
 . E  D PAGE2(.XMABORT) Q:XMABORT
 . F  S XMNAME=$O(^TMP("XM",$J,XMSVC,XMNAME)) Q:XMNAME=""  D  Q:XMABORT
 . . F  S XMI=$O(^TMP("XM",$J,XMSVC,XMNAME,XMI)) Q:XMI=""  D  Q:XMABORT
 . . . I $Y+3>IOSL D PAGE2(.XMABORT) Q:XMABORT
 . . . S XMREC=^TMP("XM",$J,XMSVC,XMNAME,XMI)
 . . . W !,$J(XMI,XMLEN)," ",XMNAME,?27,$P(XMREC,U,1),?30,$P(XMREC,U,2),?33,$P(XMREC,U,3),?36,$P(XMREC,U,4),?46,$P(XMREC,U,5),?58,$P(XMREC,U,6),?60,$J($P(XMREC,U,7),6)
 W:XMCNT=0 !!,"No user mailboxes to report."
 K ^TMP("XM",$J)
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
PAGE2(XMABORT) ;
 I IOST["C-" D  Q:XMABORT
 . N DIR
 . S DIR(0)="E"
 . D ^DIR S:$D(DIRUT) XMABORT=1
 W @IOF D HEADER2
 Q
HEADER2 ;
 W "Check user mailbox for Service/Section: ",XMSVC
 W !!,"(Logon cutoff date: ",XMCUTEXT,", AC=Access Code, VC=Verify Code, PM=Primary Menu)"
 ;       "                                         Term  Deact"
 ;       "           Last   Terminate  Del   New   User  VISTA"
 ;       "AC VC PM  Sign on    Date    Mail  Msgs  Mbox  Access"
 ;        y  y  y  xx/xx/xx  xx/xx/xx   y  xxxxxx 
 ;
 W !!,?27,"                                         Term  Deact"
 W !,?27,"           Last   Terminate  Del   New   User  VISTA"
 W !,?XMLEN+1,"Check Mailbox",?27,"AC VC PM  Sign on    Date    Mail  Msgs  Mbox  Access"
 W !,"--------------------------------------------------------------------------------"
 Q
CHECK2(XMI,XMCUTOFF,XMTERM,XMNAME,XMWHY) ;
 N XMREC
 S XMTERM=0
 Q:XMI<1
 S XMREC=$G(^VA(200,XMI,0))
 Q:XMREC=""  ; not in NEW PERSON file
 I $P(XMREC,U,3)="" D  Q
 . ; no access code
 . N XMTDATE
 . S XMTDATE=$P(XMREC,U,11)
 . Q:XMTDATE=""  ; not terminated
 . Q:XMTDATE'<XMCUTOFF  ; terminated after cutoff date
 . Q:$P(XMREC,U,5)'="n"  ; Terminated w/o mail retention
 . S XMTERM=1
 . S XMNAME=$P(XMREC,U)
 . S XMWHY="No AC, terminated w/mail retention"
 ; User has access code
 Q:$P($G(^VA(200,XMI,201)),U,1)=""  ; no primary menu
 Q:$P($G(^VA(200,XMI,.1)),U,2)=""   ; no verify code
 ; User has verify code and primary menu
 N XMLASTON  ; last sign on
 S XMLASTON=$P($G(^VA(200,XMI,1.1)),U)
 I XMLASTON<XMCUTOFF D  Q
 . S XMTERM=1
 . S XMNAME=$P(XMREC,U)
 . I XMLASTON="" S XMWHY="AC, VC, & PM, no logon" Q
 . S XMWHY="AC, VC, & PM, last logon "_$$FMTE^XLFDT(XMLASTON,"2DF")
 Q
TERMINAT(XMDUZ) ; Remove user from MailMan
 D GROUP(XMDUZ)
 D SURROGAT(XMDUZ)
 D MAILBOX(XMDUZ)
 D LATERNEW(XMDUZ)
 D LATERSND(XMDUZ)
 Q
GROUP(XMDUZ) ; Remove user from mail groups
 N XMI,XMJ,DIK,DA
 ; Remove user as member from all mail groups
 S XMI=0
 F  S XMI=$O(^XMB(3.8,"AB",XMDUZ,XMI)) Q:XMI'>0  D
 . S DA(1)=XMI,DIK="^XMB(3.8,XMI,1,",XMJ=0
 . F  S XMJ=$O(^XMB(3.8,"AB",XMDUZ,XMI,XMJ)) Q:XMJ'>0  S DA=XMJ D ^DIK
 K ^XMB(3.8,"AB",XMDUZ)
 ; Remove user's personal mail groups
 S XMI=0,DIK="^XMB(3.8,"
 F  S XMI=$O(^XMB(3.8,XMI)) Q:XMI'>0  I $P(^(XMI,0),U,6)=1,$G(^(3))=XMDUZ S DA=XMI D ^DIK
 ; Remove user as authorized sender from all mail groups
 S XMI=0,DIK="^XMB(3.8,XMI,4,"
 F  S XMI=$O(^XMB(3.8,XMI)) Q:XMI'>0  D
 . Q:'$D(^XMB(3.8,XMI,4,"B",XMDUZ))
 . S DA=$O(^XMB(3.8,XMI,4,"B",XMDUZ,0))
 . I '$D(^XMB(3.8,XMI,4,DA,0)) K ^XMB(3.8,XMI,4,"B",XMDUZ) Q
 . S DA(1)=XMI D ^DIK
 Q
SURROGAT(XMDUZ) ; Remove as mail surrogate
 N XMI,DA,DIK
 S XMI=0,DIK="^XMB(3.7,XMI,9,"
 F  S XMI=$O(^XMB(3.7,"AB",XMDUZ,XMI)) Q:XMI'>0  D
 . S DA=$O(^XMB(3.7,"AB",XMDUZ,XMI,0))
 . I '$D(^XMB(3.7,XMI,9,DA,0)) K ^XMB(3.7,"AB",XMDUZ,XMI) Q
 . S DA(1)=XMI D ^DIK
 K ^XMB(3.7,"AB",XMDUZ)
 Q
MAILBOX(XMDUZ) ; Remove user's mail box
 Q:'$D(^XMB(3.7,XMDUZ,0))
 N DIK,DA
 S DIK="^XMB(3.7,",DA=XMDUZ D ^DIK
 Q
LATERNEW(XMDUZ) ; Remove the scheduling of any messages slated to become new for this user
 N DIK,DA
 S DIK="^XMB(3.73,"
 S DA=""
 F  S DA=$O(^XMB(3.73,"C",XMDUZ,DA)) Q:'DA  D ^DIK
 Q
LATERSND(XMDUZ) ; Remove the scheduling of any messages slated to be sent by this user.
 N XMZ,DIK,DA
 S XMZ=0
 F  S XMZ=$O(^XMB(3.9,"AW",XMDUZ,XMZ)) Q:'XMZ  D
 . S DA(1)=XMZ
 . S DIK="^XMB(3.9,"_DA(1)_",7,"
 . S DA=0
 . F  S DA=$O(^XMB(3.9,"AW",XMDUZ,XMZ,DA)) Q:'DA  D ^DIK
 Q
