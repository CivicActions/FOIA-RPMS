XMUT7 ;(WASH ISC)/CAP-Send Message to Forwarding Address ;12/4/93 11:44
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ;
 ;Input = Y = user's DUZ
 ;X(1)="User's name",X(2)=FORWARDING ADDRESS
 ;
ENT(Y) N %,X,XMSUB,XMTEXT,XMZ,XMDUZ,XMDUN,XMY
 S XMDUZ=.5,XMDUN="POSTMASTER"
 S X=$P(^VA(200,Y,0),U),%=$P(^XMB(3.7,Y,0),U,2) Q:%=""
 S XMSUB="TESTING NEW FORWARDING ADDRESS FOR "_X
 S XMY(%)="",XMTEXT="%(" I '+$G(^XMB(1,1,"FORWARD")) S XMY(.5)=""
 S %(1)="This is a test.  Please ignore."
 S %(2)="This is to confirm that the FORWARDING ADDRESS: "_%
 S %(3)="for user '"_X_"' does not generate an error"
 S %(4)="at "_$P(%,"@",2)_"."
 N ZTSK
 D ^XMD
 Q
