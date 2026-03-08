XMUTASK ;(WASH ISC)/CML-MAILMAN MISC UTILITIES ;12/4/93  11:47
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 Q
NAMEA I $S(X["""":1,$A(X)=45:1,$L(X)>30:1,$L(X)<3:1,1:0) K X Q
 Q:X'?.E1L.E
 W !,"Converting input to UPPERCASE !",!
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
