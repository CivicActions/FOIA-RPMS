XMA1B ;(WASH ISC)/CAP/THM-Save/Delete Message ;06/24/99  14:15
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Entry points (DBIA 10065):
 ; KL    Delete a message from a basket
 ; KLQ   Delete a message from a basket and put it in the WASTE basket.
 ; S2    Put a message in a basket
 ;
KL ; Delete a message from a basket
 ; In:
 ; XMDUZ  User's DUZ
 ; XMK    Basket number (optional)
 ; XMZ    Message number
 I '$D(XMK) S XMK=$O(^XMB(3.7,"M",XMZ,XMDUZ,0)) Q:'XMK
 I XMK,'$D(^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)) S XMK=$O(^XMB(3.7,"M",XMZ,XMDUZ,0)) Q:'XMK
 D ZAPIT^XMXMSGS2(XMDUZ,XMK,XMZ)
 Q
KLQ ; Delete a message from a basket AND put it in waste basket
 ; In:
 ; XMDUZ  User's DUZ
 ; XMK    Basket number (optional)
 ; XMZ    Message number
 D KL Q:XMK=.5
 S XMKM=.5
 ; Fall through to S2
S2 ; Put a message in a basket.
 ; In:
 ; XMDUZ   User's DUZ
 ; XMKM    Basket number
 ; XMZ     Message number
 N XMK,XMKN
 K XMERR,^TMP("XMERR",$J)
 S XMK=$$XMK^XMXPARM(XMDUZ,"XMKM",.XMKM)
 I $D(XMERR) K XMERR,^TMP("XMERR",$J) Q
 S XMKN=$S(XMK>1:$P(^XMB(3.7,XMDUZ,2,XMK,0),U,1),XMK=.5:"WASTE",1:"IN")
 D PUTMSG^XMXMSGS2(XMDUZ,XMK,XMKN,XMZ)
 K XMKM
 Q
