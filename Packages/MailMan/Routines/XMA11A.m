XMA11A ;(WASH ISC)/CAP/THM-Send a Message/Answer ;05/26/99  10:01
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Entry points (DBIA 1233):
 ; WRITE  Send a message or Answer a message
 ;
WRITE ; Send a message or Answer a message
 ; Needs:
 ; XMDUZ  user number
 ; X      if $E(X)="A", then send an answer, else send a message
 ; XMZ    original message number, if we are sending an answer
 N XMV
 D INIT^XMVVITAE
 I $E(X)'="A" D SEND^XMJMS Q
 N XMZREC
 S XMZREC=^XMB(3.9,XMZ,0)
 K XMERR,^TMP("XMERR",$J)
 I '$$ANSWER^XMXSEC(XMDUZ,XMZ,XMZREC) D SHOW^XMJERR Q
 D ANSWER^XMJMA(XMDUZ,XMZ,$P(XMZREC,U,1),$P(XMZREC,U,2))
 Q
