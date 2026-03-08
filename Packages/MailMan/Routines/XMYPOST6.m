XMYPOST6 ;SFISC/GMB - Kill identifier node ;02/06/97  08:39
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**36**;Jun 02, 1994
 K ^DD(3.8,0,"ID",5.1)
 L +^XMB(3.7):60 E  Q
 K ^XMB(3.7,"F")
 S DIK="^XMB(3.7,",DIK(1)="2^F" D ENALL^DIK K DIK
 L -^XMB(3.7)
 Q
