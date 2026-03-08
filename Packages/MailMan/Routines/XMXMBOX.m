XMXMBOX ;ISC-SF/GMB- Mailbox APIs ;03/03/99  07:56
 ;;7.1;MailMan;**50**;Jun 02, 1994
QMBOX(XMDUZ,XMMSG) ; Message counts for a mailbox
 K XMERR,^TMP("XMERR",$J)
 S XMMSG=""
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC  Q
 S XMMSG=$$NEWS^XMXUTIL(XMDUZ)
 Q
FLTRMBOX(XMDUZ,XMMSG) ; Filter all the messages in a user's mailbox.
 K XMERR,^TMP("XMERR",$J)
 S XMMSG=""
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 N XMK
 S XMK=.99
 F  S XMK=$O(^XMB(3.7,XMDUZ,2,XMK)) Q:XMK'>0!(XMDUZ=.5&(XMK>999))  D
 . D FLTRBSKT^XMXBSKT(XMDUZ,XMK)
 S XMMSG="Mailbox filtered."
 Q
CRE8MBOX(XMDUZ,XMDATE) ; Create a Mailbox for a user
 ; XMDUZ  The user's DUZ
 ; XMDATE The user has been reinstated after not having worked here a
 ;        while.  Please note the earliest message date which the user
 ;        may access, and don't let the user access any messages before
 ;        that date, except for any which someone might forward to the
 ;        user.
 ;        =fileman date or any supported date format that FileMan
 ;         recognizes- The user may not access any before this date.
 ;        =0      - (default) The user may access any old msgs which had
 ;                  been addressed to the user.
 K XMERR,^TMP("XMERR",$J)
 ;I DUZ'=.5,'$$POSTPRIV^XMXSEC Q
 I '$D(^XMB(3.7,XMDUZ,0)) D
 . N XMFDA,XMIEN
 . S XMFDA(3.7,"+1,",.01)=XMDUZ
 . S XMIEN(1)=XMDUZ
 . D UPDATE^DIE("","XMFDA","XMIEN")
 D:'$D(^XMB(3.7,XMDUZ,2,.5,0)) MAKEBSKT^XMXBSKT(XMDUZ,.5,"WASTE")
 D:'$D(^XMB(3.7,XMDUZ,2,1,0)) MAKEBSKT^XMXBSKT(XMDUZ,1,"IN")
 ; Limit message access at reinstatement?
 Q:$G(XMDATE)=""
 N XMRESULT
 D VAL^DIE(3.7,XMDUZ_",",1.2,"",XMDATE,.XMRESULT)
 I XMRESULT=U D  Q
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)=^TMP("DIERR",$J,1,"TEXT",1)
 . K DIERR,^TMP("DIERR",$J)
 S $P(^XMB(3.7,XMDUZ,0),U,7)=XMRESULT
 Q
TERMMBOX(XMDUZ) ; Terminate a user's Mailbox
 ; (Delete all traces of a user in MailMan)
 ; XMDUZ  The user's DUZ
 K XMERR,^TMP("XMERR",$J)
 I DUZ'=.5,'$$POSTPRIV^XMXSEC Q
 D TERMINAT^XMUTERM1(XMDUZ)
 Q
