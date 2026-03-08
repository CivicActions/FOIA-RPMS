XMYPOST8 ;SFISC/GMB - Correct message basket numbers ;12/10/96  16:14
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**37**;Jun 02, 1994
 N XMDUZ,XMK,XMZ,XMKZ
 S XMDUZ=0
 F  S XMDUZ=$O(^XMB(3.7,XMDUZ)) Q:XMDUZ'>0  D
 . L +^XMB(3.7,XMDUZ)
 . S XMK=0
 . F  S XMK=$O(^XMB(3.7,XMDUZ,2,XMK)) Q:XMK'>0  D
 . . Q:'$O(^XMB(3.7,XMDUZ,2,XMK,1,0))
 . . S XMKZ=0
 . . F  S XMKZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ)) Q:XMKZ'>0  D
 . . . S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ,0))
 . . . I $D(^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)),$P(^(0),U,2)'=XMKZ S $P(^(0),U,2)=XMKZ
 . L -^XMB(3.7,XMDUZ)
 Q
