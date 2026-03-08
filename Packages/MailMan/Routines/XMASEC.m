XMASEC ;(WASH ISC)/GM-SECURE PACKMAN MESSAGE ;07/18/96  13:17 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;7.1;MailMan;**33**;Jun 02, 1994
 D INIT
YN W !,"Do you wish to secure this message" S %=2 D YN^DICN
 I %<0 S Y=-1 G Q
 G Q:%=2 I %=0 S X="XM-SECURE-MESSAGE",XMHLP="HELP" D HLP G YN
 D HINT
EN ;
 I '$D(XMKEY) G C1:$D(DIFROM) Q
 S DIE="^XMB(3.9,",DA=XMZ,DR="1.8///"_XMHINT_" " D ^DIE
 W !!,"Securing the message, now.  This may take a while !!!",!
 D SKEY^XME S ^XMB(3.9,XMZ,"K")=1_XMKEY,X="$SEC^3" D ENC
 S X=$O(^XMB(3.9,XMZ,2,.999)),X=^(X,0),%=$P(X,"on",2),X=$P(X,"on")_"at"_$P(%,"at",2)_" on"_$P(%,"at"),$P(X,U,2)=Y,^(0)=X,%=0,%2=0
C S %=$O(^XMB(3.9,XMZ,2,%)) G C1:%=""
 G C:'$D(^(%,0)) S X=^(0) G C0:$E(X)="$"
 S %0=0 F %1=1:1:$L(X) S %0=$A(X,%1)*%1+%0
 S %2=%2+%0+$L(X)
C0 G C:$E(X)'="$"
 I $E(X,1,4)="$ROU" W:$X>70 ! W $J($P(X," ",2),10) I $P(X," ",2)?.AN1"NTEG" D INTEG G C
 I $E(X,1,4)'="$END" S %2=0,$P(^XMB(3.9,XMZ,2,%,0)," ",2)=$S($E(X,1,4)'="$KID":U,1:"")_$P(X," ",2) G C
 S X="$SEC"_U_(%2+XMRW) D ENC S $P(^XMB(3.9,XMZ,2,%,0),U,2)=Y
 G C
C1 S Y=^XMB(3.9,XMZ,2,0),X=$P(Y,U,3)+1,$P(Y,U,3,4)=X_U_($P(Y,U,4)+1),^(0)=Y,^(X,0)="$END "_"MESSAGE",(X,Y)=1
Q S:Y<0 X=U
 K %,%0,%1,%2,XMHLP,XMKEY,XMHINT,XQH,XMRW,XMCL,XMSEC Q
QUES ;
 D INIT
HINT R !,"Enter the scramble hint: ",XMHINT:$S($D(DTIME):DTIME,1:300)
 I '$T S DTOUT=1,Y=-1 G Q
 I "^"[XMHINT S:XMHINT'=""&$D(DIFROM) DUOUT=1 S Y=-1 G Q
 I XMHINT["?" S X="XMS-TRANS-SCR-HINT",XMHLP="Q3^XME" D HLP G HINT
 I $L(XMHINT)>39 W !,"Must be less than 40 characters.",! G HINT
P X ^%ZOSF("EOFF") R !,"Enter scramble password: ",X:DTIME X ^%ZOSF("EON")
 I '$T S Y=-1 S:$D(DIFROM) DTOUT=1 Q
 I U[X S:X'=""&$D(DIFROM) DUOUT=1 S Y=-1 G Q
 I X="",'$D(DIFROM) S Y=-1 G Q
 I X["?" S X="XMS-TRANS-SCR-HINT",XMHLP="Q1^XME" D HLP G P
 I X?.E1L.E S XMKEY=$$UP^XLFSTR(X)
 E  S XMKEY=X
 K %,XQH,XMHLP
 Q
INIT S Y=1,DIC="^DIC(9.2,",DIC(0)="M" Q
HLP D ^DIC S:+Y>0 XQH=X D @($S(+Y<0:XMHLP,1:"EN^XQH")) S Y=1 Q
HELP W !!,"If you answer yes, this message will be secured to insure that"
 W !,"what you send is what is actually received." Q
ENC I '$D(XMSEC) D ENT^XME1
 S Y="" F %0=1:1:$L(X) S Y=Y_$C($F(XMSEC(%0#XMCL+1),$E(X,%0))+30)
 Q
INTEG S $P(^XMB(3.9,XMZ,2,%,0)," ",2)=U_$P(X," ",2)
I S %=$O(^XMB(3.9,XMZ,2,%)) Q:%=""  S X=^(%,0) Q:"$END"[$E(X_" ",1,4)
 I X?.UN1" ;;".N S X=$P(X,";",3)+XMRW D ENC S $P(^XMB(3.9,XMZ,2,%,0),";",3)=Y
 G I
