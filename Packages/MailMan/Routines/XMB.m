XMB ;(WASH ISC)/THM/RWF/CAP-Bulletins & TaskMan ;06/02/99  15:47
 ;;7.1;MailMan;**3,7,24,26,27,50**;Jun 02, 1994
 ; Entry points are (DBIA 10069):
 ; ^XMB     Create and deliver a bulletin in the background (task).
 ; EN^XMB   Create a bulletin in the foreground (now) and send it in
 ;          the background (task)
 ; BULL^XMB Interactive create and send a bulletin
 ;
 ; The recipients of the bulletin include any entries in the XMY
 ; array that the caller has defined and the members of mail group
 ; that are included in the definition of the entry in the Bulletin
 ; file (#3.6) at the time of delivery.  There must be valid
 ; recipients or the message will not be delivered.
 ;
 ; I/O Variables:
 ; XMB             (in) Bulletin name (an entry in File #3.6)
 ; XMB(parameter#) (in, optional) Value to be stuffed into the bulletin
 ;                 for each required parameter
 ;                 eg. XMB(1)=data for parameter#1
 ; XMTEXT          (in, optional) Name of array containing
 ;                 additional bulletin text
 ; XMY             (in, optional) Array of additional recipients of a
 ;                 bulletin
 ; XMDUZ           (in, optional) Sender # or string saying who or what
 ;                 sent the bulletin (default=DUZ)
 ; XMDT            (in, optional) Date/time to send bulletin (default=now)
 ; XMYBLOB         (in, optional) MIME array
 ; XMZ             (out) Message number (if successful)
 ;
 ; Entry ^XMB:
 ; Needs:    XMB
 ; Accepts:  XMDUZ,XMTEXT,XMY,XMDT,XMYBLOB
 ; Returns:  (XMB=-1 if bulletin does not exist in file 3.6)
 ; Kills:    XMTEXT,XMY
 N XMINSTR,XMATTACH,XMTASK
 K XMERR,^TMP("XMERR",$J)
 I '$O(^XMB(3.6,"B",XMB,"")) S XMB=-1 Q
 I '$G(DUZ) N DUZ D DUZ^XUP(.5)
 I $G(XMDUZ)=""!($G(XMDUZ)=0) S XMDUZ=DUZ
 I XMDUZ'?.N S %=XMDUZ N XMDUZ S XMDUZ=% K %
 D:$D(XMYBLOB) SETBLOB(.XMYBLOB,.XMATTACH)
 D:$D(XMDT) SETLATER(XMDT,.XMINSTR)
 I XMDUZ'?.N D SETFROM^XMD(.XMDUZ,.XMINSTR) Q:$G(XMMG)["Error ="
 S:$D(XMTEXT) XMTEXT=$$CREF^DILF(XMTEXT)
 S:$D(XMDF) XMINSTR("ADDR FLAGS")="R" ; Ignore addressee restrictions
 S:$D(XMBTMP) XMINSTR("ADDR FLAGS")=$G(XMINSTR("ADDR FLAGS"))_"I" ; Don't initialize (kill) the ^TMP addressee global
 D TASKBULL^XMXBULL(XMDUZ,XMB,.XMB,.XMTEXT,.XMY,.XMINSTR,.XMTASK,.XMATTACH)
 K:$D(XMERR) XMERR,^TMP("XMERR",$J)
 K XMTEXT,XMY
 Q
EN ;Interactive Bulletin Entry Point
 ; Needs:    XMB
 ; Accepts:  XMDUZ,XMTEXT,XMY,XMDT,XMYBLOB
 ; Returns:  XMZ,(XMB=-1 if bulletin does not exist in file 3.6)
 ; Kills:    XMB,XMTEXT,XMY
 N XMBIEN,XMINSTR
 K XMERR,^TMP("XMERR",$J)
 S XMBIEN=$O(^XMB(3.6,"B",XMB,"")) I XMBIEN="" S XMB=-1 Q
 I '$G(DUZ) N DUZ D DUZ^XUP(.5)
 I $G(XMDUZ)=""!($G(XMDUZ)=0) S XMDUZ=DUZ
 I XMDUZ'?.N S %=XMDUZ N XMDUZ S XMDUZ=% K %
 D:$D(XMYBLOB) SETBLOB(.XMYBLOB,.XMATTACH)
 I XMDUZ'?.N D SETFROM^XMD(.XMDUZ,.XMINSTR) Q:$G(XMMG)["Error ="
 S:$D(XMTEXT) XMTEXT=$$CREF^DILF(XMTEXT)
 S:$D(XMDF) XMINSTR("ADDR FLAGS")="R" ; Ignore addressee restrictions
 S:$D(XMBTMP) XMINSTR("ADDR FLAGS")=$G(XMINSTR("ADDR FLAGS"))_"I" ; Don't initialize (kill) the ^TMP addressee global
 D SEND^XMXBULL(XMDUZ,XMBIEN,.XMB,.XMTEXT,.XMY,.XMINSTR,.XMZ,.XMATTACH)
 K:$D(XMERR) XMERR,^TMP("XMERR",$J)
 K XMB,XMTEXT,XMY
 Q
SETBLOB(XMYBLOB,XMATTACH) ;
 N %X,%Y
 S %X="XMYBLOB(",%Y="XMATTACH(""IMAGE""," D %XY^%RCR
 Q
SETLATER(XMDT,XMINSTR) ;
 S XMINSTR("LATER")=$$XMDATE^XMXPARM("XMDT",XMDT)
 I $D(XMERR) K XMINSTR("LATER"),XMERR,^TMP("XMERR",$J)
 Q
BULL ; Manually post a bulletin
 D BULLETIN^XMJMBULL
 Q
ZTSK ;ENTRY POINT FROM THE TASK MANAGER
 S XMTSK=ZTSK S:'$D(XMDT) XMDT="N"
 S:'$D(XMIO) XMIO="" D KILL:"236"'[XMB("TYPE")
 S:'$D(XMDUZ) XMDUZ=.5 G @(XMB("TYPE"))
2 K:'$G(XMBTMP) ^TMP("XMY",$J),^TMP("XMY0",$J) K XMDT S XMB=XMB("A") G EN ; BULLETIN
3 D XMTAUDIT^XMBPOST(.XMB)
 G ZTSK^XMS0 ; REMOTE TRANSMISSION
4 ; PRINT MESSAGE ON DEVICE
 S XMDUZ=XMB("XMDUZ")
 S XMZ=XMB("XMZ")
 S XMDVIENS=$$IENS(XMZ,XMB("XMXX"))
 G DEVICE^XMTDO
5 ; PUMP INTO SERVER
 S XMZ=XMB("XMZ")
 S XMSERVER=XMB("XMXX")
 S XMSVIENS=$$IENS(XMZ,XMB("XMXX"))
 G SERVER^XMTDO
6 G ZTSK^XMS1 ; POLLER
7 G RECV^XMS3 ; INTER-UCI TRANSFER
 Q
IENS(XMZ,XMRECIP) ;
 Q $$FIND1^DIC(3.91,","_XMZ_",","QX",XMRECIP,"C")_","_XMZ_","
KILL ; Kill task ZTSK
 N %
 S %=$S($D(XMINST):XMINST,$D(XMSCR):XMSCR,1:0)
 I % D
 . K ^XMBS(4.2999,%,3)
 . S $P(^XMBS(4.2999,%,4),U,2)=$$NOW^XLFDT
 S ZTREQ="@" Q
NEW ;this tag is no longer called, XM*7.1*24
 Q
