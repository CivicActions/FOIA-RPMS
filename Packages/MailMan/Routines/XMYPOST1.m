XMYPOST1 ;(WASH ISC)/CAP-RESET MAILBOX'S X-REFS ;7/31/89  09:11 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 Q
 ;Converts 3.09 & previous versions to new structure (XMYPOST0 continued)
NEW ;This code is for use when XMYPOST0 finds more than 100 NEW messages for
 ;a single user.  It continues where XMYPOST0 left off (Z0+2^XMYPOST0)
 ;and drops back into YQ^XMYPOST0 to set the 'B' x-refs.  It exists
 ;to prevent storage errors in the local symbol table.
 ;
 S %X="XMN0(",%Y="^TMP(""XMY"","
 K ^TMP("XMY") D %XY^%RCR K XMN0
 G Z0
 ;
 ;FIND NEW MESSAGES / COUNT BY BASKET / TOTAL
 ;
Z S XMZ=$O(^XMB(3.7,XMDUZ,"N",XMZ)) G Y:'XMZ S XMK=0
Z0 S XMK=$O(^XMB(3.7,XMDUZ,"N",XMZ,XMK)) I 'XMK G Z
 I '$D(^TMP("XMY",XMK)) S ^(XMK)=""
 S Y=^TMP("XMY",XMK),^(XMK)=Y+1,^(XMK,XMZ)="",XMC0=XMC0+1
 G Z0
 ;
 ;RESET NEW 'N' NODES / FLAG NEW MESSAGES / SET COUNTS INTO FILE
 ;
Y S $P(^XMB(3.7,XMDUZ,0),U,6)=XMC0,XMK=0 K ^XMB(3.7,XMDUZ,"R")
Y1 S XMK=$O(^TMP("XMY",XMK)) G YQ:'XMK S Y=^(XMK),$P(^XMB(3.7,XMDUZ,2,XMK,0),U,2)=Y
 S XMZ=0
Y2 S XMZ=$O(^TMP("XMY",XMK,XMZ)) G Y1:'XMZ
 W "-" W:$X>78 !
 S ^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)=XMZ_"^^1",^XMB(3.7,XMDUZ,"N0",XMK,XMZ)=""
 G Y2
YQ K ^TMP("XMY")
 G YQ^XMYPOST0
