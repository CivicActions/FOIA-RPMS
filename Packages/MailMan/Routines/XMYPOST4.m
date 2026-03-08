XMYPOST4 ;(WASH ISC)/CAP-VERSION 3.91 CHANGES ;3/25/91  11:52
VER ;;7.1;Mailman;**1003**;OCT 27, 1998
VER ;;7.1;MailMan;;Jun 02, 1994
 W !!,*7,"I will now create a TaskMan task to do the following:"
 W !!?9,"1.  Create new x-references for the 3.73 (Later'd Messages) file."
 W !?9,"2.  Reset Mail Box and Basket counters."
 W !?9,"3.  Clean up 3.9 ""B"" x-reference."
 W !?9,"4.  Move MailMan Institution field from the USER to MailBox file."
 W !?9,"5.  Fill in the original message field for all responses."
 ;
 S ZTIO="",ZTRTN="ZTSK^XMYPOST4",ZTDESC="MailMan v7 POSTINIT",ZTDTH=$H,ZTSAVE("*")=""
 D ^%ZTLOAD
 W !!,"Task created -- Please make sure TaskMan is running to start it.",!!,"If the POSTMASTER does not receive a message indicating completion,",!,"you may restart it by typing ""D ^XMYPOST4"" from the programmer prompt."
 W !,"The task will LOCK ^XMB(""POSTINIT"").  You may tell if it is running",!,"by checking the LOCK TABLE.  Any duplicate tasks will quit",!,"because of the lock.",!!
 Q
ZTSK ;TaskMan Entry point
 ;
 ;Reset 3.73 x-refs
 L +^XMB("POSTINIT") S DIK="^XMB(3.73," D IXALL^DIK
 ;Stuff correct counts into the Mail Basket Zero nodes.
 S XMA=0
A S XMA=$O(^XMB(3.7,XMA)) I +XMA'=XMA K XMA,XMB,%,%0 G D
 S XMB=0
B S XMB=$O(^XMB(3.7,XMA,2,XMB)) G A:+XMB'=XMB S %=0,%1=0
C S %=$O(^XMB(3.7,XMA,2,XMB,1,%)) I +%'=% S $P(^XMB(3.7,XMA,2,XMB,0),U,5)=%1 G B
 S %1=%1+1 G C
 ;
D ;Fill in ORIGINAL MESSAGE field for all responses
 S (I,K)=0
F S I=$O(^XMB(3.9,I)) G FQ:I="" S K=K+1 G F:'$D(^(I,3)) F %=0:0 S %=$O(^XMB(3.9,I,3,%)) G F:+%'=% I $D(^(%,0)) S J=+^(0) I $D(^XMB(3.9,J,0)) S Y=^(0),$P(Y,U,8)=I,^(0)=Y
 G F
FQ K %,I,J,K,Y
 ;
ENTB W:'$D(ZTQUEUED) !!,"Cleaning up 'B' X-ref of 3.9 file !   THIS MAY TAKE A WHILE !!!",!!
 S I="",C=0 F J=0:0 S I=$O(^XMB(3.9,"B",I)) Q:I=""  S J=0 F C=C:1 S J=$O(^XMB(3.9,"B",I,J)) Q:'J  I '$D(^XMB(3.9,J,0)) K ^XMB(3.9,"B",I,J)
 ;
 ;MOVE 6000 NODES from file 3 to file 3.7
 S C=0 F J=0:0 S J=$O(^DIC(3,J)) Q:+J'=J  S C=C+1 I $D(^(J,6000)) S X=^(6000) I $D(^XMB(3.7,J,0)) S ^(6000)=X
 L -^XMB("POSTINIT") D END Q
END Q:'$D(ZTQUEUED)  N A,XMDUZ,XMSUB,XMTEXT,XMZ,XMXUSEC S XMSUB="MAILMAN V7 POSTINIT COMPLETED",^TMP("XMY",$J,.5)="",XMDUZ="MailManPostINIT",XMTEXT="A(",A(1)="The MailMan PostINIT has completed." D ^XMD Q
 Q
