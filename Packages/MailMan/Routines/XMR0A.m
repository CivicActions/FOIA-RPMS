XMR0A ;(WASH ISC)/CAP-SMTP RECEIVER (SPECIAL) ;06/08/99  06:54
 ;;7.1;MailMan;**27,50**;Jun 02, 1994
 ; *** Note that this command (MESS <what:parm>) is not standard.
 ; *** MESS ID, in particular, may return 'RSET', which is supposed
 ;     to be sent only by the sender, not by the receiver.
MESS ; CHECK IF DUPLICATE MESSAGE / USERS...
 N XMWHAT,XMPARM
 I XMP="" D ERRCMD^XMR Q
 S XMWHAT=$E($P(XMP,":"),1,6),XMPARM=$P(XMP,":",2,99)
 I $T(@XMWHAT)="" D ERRCMD^XMR Q
 D @XMWHAT
 Q
BLOB ;; MESS BLOB
 D BLOB^XMR0BLOB(XMPARM)
 Q
CLOSED ;; MESS CLOSED
 S XMZFDA(3.9,XMZIENS,1.95)="y"
 S XMSG="250 OK" X XMSEN
 Q
CONFID ;; MESS CONFIDENTIAL
 S XMZFDA(3.9,XMZIENS,1.96)="y"
 S XMSG="250 OK" X XMSEN
 Q
CONFIR ;; MESS CONFIRMATION
 S XMZFDA(3.9,XMZIENS,1.3)="y"
 S XMSG="250 OK" X XMSEN
 Q
ID ;;
 N XMZCHK
 S XMREMID=XMPARM
 S XMZCHK=$$LOCALXMZ^XMR1A(XMREMID)
 I 'XMZCHK S XMSG="250 OK" X XMSEN Q
 I $P(XMZCHK,U,2,3)="1^P" S XMSG="250 OK" X XMSEN Q
 I $P(XMZCHK,U,2) S XMTRAN="Message originated here." D TRAN^XMC1
 I '$P(XMZCHK,U,2) S XMTRAN="Previously received message." D TRAN^XMC1
 S XMRXMZ=+XMZCHK
 I $P(XMZCHK,U,3)'="E"!(XMRXMZ=XMZ) D  Q
 . I $P(XMZCHK,U,3)="P" S XMTRAN="Already purged." D TRAN^XMC1
 . I $P(XMZCHK,U,3)="R" S XMTRAN="Already purged & replaced with a different message." D TRAN^XMC1
 . S XMSG="RSET :"_XMRXMZ_"@"_^XMB("NETNAME")_":Duplicate purged" X XMSEN
 S XMTRAN="Delivering to additional recipients." D TRAN^XMC1
 S XMSG="RSET :"_XMRXMZ_"@"_^XMB("NETNAME")_":Previously received" X XMSEN
 Q
INFO ;; MESS INFORMATION 
 S XMZFDA(3.9,XMZIENS,1.97)="y"
 S XMSG="250 OK" X XMSEN
 Q
TYPE ;; MESS TYPE
 S XMZFDA(3.9,XMZIENS,1.7)=XMPARM
 S XMSG="250 OK" X XMSEN
 Q
