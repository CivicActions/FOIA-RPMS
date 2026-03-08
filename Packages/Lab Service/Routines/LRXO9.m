LRXO9 ; IHS/DIR/AAB - Order Comments ;
 ;;5.2;LR;**1002**;JUN 01, 1998
 ;
 ;;5.2;LAB SERVICE;**100,128**;Sep 27, 1994
RCOM ;;Required coment
 K LRCOM
 S LRCCOM="~For Test: "_LRTSTNM_"   "_$P(^LAB(62,LRSAMP,0),"^") S:$P(^(0),"^")'=$P(^LAB(61,LRSPEC,0),"^") LRCCOM=LRCCOM_"   "_$P(^(0),"^") I $S('$D(DUZ("AG")):1,"ARMYAFN"'[DUZ("AG"):1,1:0) W !,LRCCOM
 D RCS,EN
 I LRCCOM="" S X=+^XUTL("OR",$J,"COM",LROST,LRZX(1),LRSAMP,LRSPEC,LRSX) I $D(^XUTL("OR",$J,"COM",LROST,LRZX(1),LRSAMP,LRSPEC,LRSX,X)),^XUTL("OR",$J,"COM",LROST,LRZX(1),LRSAMP,LRSPEC,LRSX,X)["~For Test:" D
 .K ^XUTL("OR",$J,"COM",LROST,LRZX(1),LRSAMP,LRSPEC,LRSX,X)
 .S ^XUTL("OR",$J,"COM",LROST,LRZX(1),LRSAMP,LRSPEC,LRSX)=X-1
 Q
EN ;from
 Q:'LREXP  S LRCCOM="" S:'$D(LREXP) LREXP=0 S:'$D(LRTSTNM) LRTSTNM="" ;ASK REQUIRED COMENT
 I LREXP,$L(^LAB(62.07,LREXP,.1)) X ^(.1) S:'$L(LRCCOM)&($L($G(LRCOM))) LRCCOM=LRCOM W:$E(LRCCOM)="?"&$D(^(.2)) ^(.2) G EN:$E(LRCCOM)="?"
 I 'LREXP R !,"Enter Order Comment: ",LRCCOM:DTIME
 G ZQ:LRCCOM="?"!(LRCCOM="??"),Z3:LRCCOM=""!(LRCCOM="^") I LRCCOM["^"!(LRCCOM[";") W !,"No up-arrows or semicolons allowed." G ZQ
 G ZQ:$L(LRCCOM)>68!($L(LRCCOM)<1)!(LRCCOM'?.ANP) S B3="" D Z1 W "  (",$E(B3,1,$L(B3)-1),")" S LRCCOM=B3 K A4,B3,B6
Z3 Q:$D(LRQ)
 ;S:LRCCOM["^" LRCCOM="" S %=1 W !,"  OK" D YN^DICN I %'=1 S:%=-1 LRCCOM="" G EN:%=2 I %=0 W !,"Unless special comments are required, this comment will be associated with",!,"all tests requested for this entry." G Z3
RCS ;from
 I $D(ORACTION),$D(LRCCOM),$L(LRCCOM),$D(LROST),$D(LRSAMP),$D(LRSPEC),$D(LRZX(1)),$D(LRSX) S X=1+$S($D(^XUTL("OR",$J,"COM",LROST,LRZX(1),LRSAMP,LRSPEC,LRSX)):^XUTL("OR",$J,"COM",LROST,LRZX(1),LRSAMP,LRSPEC,LRSX),1:0) D  Q
 . N GOT,I
 . S GOT=0,I=0 F  S I=$O(^XUTL("OR",$J,"COM",LROST,LRZX(1),LRSAMP,LRSPEC,LRSX,I)) Q:I<1  I ^(I)[LRCCOM S GOT=1 Q
 . Q:GOT
 . S ^XUTL("OR",$J,"COM",LROST,LRZX(1),LRSAMP,LRSPEC,LRSX)=X,^XUTL("OR",$J,"COM",LROST,LRZX(1),LRSAMP,LRSPEC,LRSX,X)=LRCCOM,^(X,LRTST)=""
 Q
Z1 F V=1:1 Q:$P(LRCCOM," ",V,99)=""  S B6=$P(LRCCOM," ",V),Y="" D:B6]"" Z2 S A4=$L(B3)+$L(B6) S:A4'>68 B3=B3_B6_" " I A4>68 W "  too long",! Q
 I $D(LRPCE) S LRCCOM=$S('$L(LRPCE):LRCCOM,1:LRPCE_LRCCOM) K LRPCE
 Q
Z2 S Y=0 F  S Y=$O(^LAB(62.5,"B",B6,Y)) Q:'Y  I "KA"[$P(^LAB(62.5,Y,0),"^",4) S B6=$P(^LAB(62.5,Y,0),"^",2) Q:'$D(^(9))  S Y=$P(X," ",I-1),Y=$E(Y,$L(Y)) S:Y>1 B6=^(9) Q
 Q
ZQ S X=$S(X="??":"??",1:"?"),(DIE,DIC)="^LAB(62.5,",DIC(0)="Q",DIC("S")="I ""KA""[$P(^(0),U,4)",D="B",DZ=X K DO D DQ^DICQ K DIC S DIC=DIE D DO^DIC1
 G EN
