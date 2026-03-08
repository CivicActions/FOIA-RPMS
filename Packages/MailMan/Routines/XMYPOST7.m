XMYPOST7 ;SFISC/GMB - Correct message multipe zero nodes ;02/11/97  15:04
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**37**;Jun 02, 1994
 N XMDUZ,XMK,XMZ,XMCNT
 L +^XMB(3.7):0 E  Q
 S XMDUZ=0
 F  S XMDUZ=$O(^XMB(3.7,XMDUZ)) Q:XMDUZ'>0  D
 . ;W !,"User ",XMDUZ
 . ;L +^XMB(3.7,XMDUZ)
 . S XMK=0
 . F  S XMK=$O(^XMB(3.7,XMDUZ,2,XMK)) Q:XMK'>0  D
 . . Q:'$O(^XMB(3.7,XMDUZ,2,XMK,1,0))
 . . S (XMZ,XMCNT)=0
 . . F  S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,XMZ)) Q:XMZ'>0  S XMCNT=XMCNT+1
 . . ;W !," Basket ",XMK," from ",$P(^XMB(3.7,XMDUZ,2,XMK,1,0),U,4)," to ",XMCNT
 . . S $P(^XMB(3.7,XMDUZ,2,XMK,0),U,5)=XMCNT
 . . S ^XMB(3.7,XMDUZ,2,XMK,1,0)="^3.702P^"_+$O(^XMB(3.7,XMDUZ,2,XMK,1,"C"),-1)_U_XMCNT
 . ;L -^XMB(3.7,XMDUZ)
 L -^XMB(3.7)
 Q
