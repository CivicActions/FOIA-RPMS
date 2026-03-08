XMDF ;(WASH ISC)/THM/CAP- Message Sending API Continued ;05/12/99  09:04
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Entry points (DBIA 10071):
 ; $$ENT  Forward a message.  This entry point is no longer supported.
 ;        Use ENT1^XMD or FWDMSG^XMXAPI, instead.
ENT(XMTO,XMK,XMZ,XMDUZ) ;Forward Message / Deliver imediately - Local rcpts only
 ; XMTO   Rcpt DUZ
 ; XMK    Basket # (1=default)
 ; XMZ    Message #
 ; XMDUZ  DUZ of Forwarder
 N XMY
 Q:$D(^XMB(3.9,XMZ,1,"C",XMTO)) 1  ; Quit if already a recipient
 Q:+XMTO'=XMTO 0  ; Quit if not a local recipient
 S XMY(XMTO)=""
 S:$G(XMK) XMY(XMTO,0)=XMK
 D ENT1A^XMD(0)
 Q 1
 ; This actually delivers in foreground, but should not be used,
 ; because it has total disregard for 'first come, first served'.
 N XMZREC,XMSUBJ,XMFROM,XMINSTR,XMRESTR,XMER
 Q:$D(^XMB(3.9,XMZ,1,"C",XMTO)) 1  ; Quit if already a recipient
 Q:+XMTO'=XMTO 0  ; Quit if not a local recipient
 K XMERR,^TMP("XMERR",$J)
 S XMZREC=^XMB(3.9,0)
 S XMSUBJ=$P(XMZREC,U,1)
 S XMFROM=$P(XMZREC,U,2)
 D INMSG2^XMXUTIL2(XMDUZ,XMZ,XMZREC,"",.XMINSTR)
 D GETRESTR^XMXSEC1(XMDUZ,XMZ,XMZREC,.XMINSTR,.XMRESTR)
 S XMK=$G(XMK,1)
 I XMDUZ'?1N.N D SETFWD^XMD(XMDUZ,.XMINSTR)
 D INIT^XMVVITAE
 D INIT^XMXADDR
 D CHKADDR^XMXADDR(XMDUZ,XMTO,.XMINSTR,.XMRESTR)
 I $D(XMERR) D  Q XMER
 . S XMER="-1 "_^TMP("XMERR",$J,1,"TEXT",1)
 . K XMERR,^TMP("XMERR",$J)
 D FWD^XMKP(XMDUZ,XMZ,.XMINSTR)
 D CLEANUP^XMXADDR
 L +^XMB("POSTDONE",XMZ)
 D DELIVER^XMTDL2(XMTO,XMZ,XMSUBJ,XMFROM,XMDUZ)
 L -^XMB("POSTDONE",XMZ)
 Q $D(^XMB(3.7,"M",XMZ,XMTO))
