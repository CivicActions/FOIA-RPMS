XMUT5G ;(WASH ISC)/CAP-VALIDATE MAIL GROUP MEMBERS ;12/13/96  08:52
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**36**;Jun 02, 1994
 S DIC="^XMB(3.8,",DIC(0)="AEO" D ^DIC
 S A=0,XMA0=+Y,C=0 W !,"Analyzing "_$P(Y,U,2)_" Mail Group",!!
A S A=$O(^XMB(3.8,XMA0,1,"B",A)) G Q:'A
 S C=C+1 I C#100=0 W "***"_A_"*** "
 S F=$G(^VA(200,A,0))
 I '$L($P(F,U,2))!$L($P(F,U,11)) W A," "
 G A
Q K A,C,XMA0,DIC,DTOUT,DUOUT Q
