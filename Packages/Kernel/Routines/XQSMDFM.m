XQSMDFM ;ISC-SF(SEA)/JLI,MJM - PERMIT USER TO BUILD LIMITED FM OPTIONS ;10/22/92  14:29 ; 02/01/90;7/3/92  2:51 PM [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;;Jul 10, 1995
 ;
RULES ;See if this user has an assigned namespace to use.  Quit if not.
 D NAME^XQSMD4 G:'XQVALID K^XQSMD4
 W !!,"The option types that may be built are P(rint), E(dit), and I(nquire), and",!,"you must have a template or templates ready to be included in the option.",!!,"Or enter D(elete) to DELETE an option",!!
 ;
ASK ;Get option type and templates to use
 R !,"Select Option Type (P/E/I/D): ",X:DTIME Q:'$T!(X[U)!(X="")  I "PpDdEeIi"'[$E(X) W $C(7),"  ??" G RULES
 S X=$E(X) S:X?1L X=$C($A(X)-32) S XQSMDTY=X G:X="D" OPT S XQTMPLT=$S(X="P":"^DIBT(",X="E":"^DIE(",1:"^DIPT(")
 I "PE"[X W !?5,"Enter ",$S(X="P":"Sort",X="E":"Edit",1:"Print")," Template Name: " R X:DTIME Q:'$T!(X[U)!(X="")
 K XQTMP I X="I" W !?5,"Enter Print Template Name (Optional): " R X:DTIME G:'$T!(X[U) OUT I X="" S DIC=1,DIC(0)="AEQM" D ^DIC G:Y'>0 ASK S (XQFIL,XQYV)=+Y,XQTMP=" "
 D:'$D(XQTMP) CHKTMP G:'$D(XQTMP) ASK
 I XQSMDTY="P" S XQFIL=XQYV,XQTMP1=$S($D(XQTMP):XQTMP,1:""),XQTMPLT="^DIPT(" W !?5,"Enter Print Template Name: " R X:DTIME Q:'$T!(X[U)!(X="")  D CHKTMP
 Q:XQYV'>0
 I XQSMDTY="E" S XQDIC0="AEQM" W !,"Should the User be allowed to ADD a new ",$P(^DIC(XQYV,0),U)," File entry? N// " R X:DTIME Q:'$T!(X[U)  S:X="" X="N" I "Yy"[$E(X) S XQDIC0=XQDIC0_"L"
OPT R !?5,"Option Name: ",X:DTIME Q:'$T!(X[U)!(X="")  D CHKNAM^XQSMD4 G:'XQVALID OPT
 S XQSMDOPT=X,DIC(0)="MLE",DIC=19,DLAYGO=19 D ^DIC G:Y'>0 RULES S XQSMDY=+Y G:XQSMDTY="D" DELETE
 S XQYV=$P(^DIC(XQYV,0,"GL"),U,2) I XQSMDTY="E" S DR="1;3.5;4///E;30///"_XQYV_";31///"_XQDIC0_";50///"_XQYV_";51///["_XQTMP_"];",DIE=19,DA=XQSMDY D ^DIE
 I XQSMDTY="P" S DR="1;3.5;4///P;60///"_XQYV_";62///0;63///["_XQTMP_"];64///["_XQTMP1_"];",DIE=19,DA=XQSMDY D ^DIE
 I XQSMDTY="I" S:XQTMP=" " XQTMP="" S DR="1;3.5;4///I;30///"_XQYV_";31///AEMQ;80///"_XQYV_";",DIE=19,DA=XQSMDY S:XQTMP'="" DR=DR_"63///["_XQTMP_"];" D ^DIE
 I '$D(^VA(200,DUZ,19.5,"B",XQSMDY)) S:'$D(^VA(200,DUZ,19.5,0)) ^(0)="^200.19^" S DIC="^VA(200,DUZ,19.5,",DIC("P")=200.19,DIC(0)="L",X=XQSMDOPT,DA(1)=DUZ,DLAYGO=200 D ^DIC
 ;
OUT ;Clean up and quit
 K %,%1,DA,DIC,DIE,DIV,DLAYGO,DR,J,K,M,N,X,X1,XQDICO,XQFIL,XQSA,XQSB,XQSMDOPT,XQSMDTY,XQSMDY,XQTMP,XQTMP1,XQTMPLT,XQVALID,XQYV,Y,YV,Z,ZRG
 Q
 ;
CHKTMP ;Get the template that the user entered
 K XQSA,XQSB I $D(@(XQTMPLT_"""B"","""_X_""")")) F I=0:0 S I=$O(@(XQTMPLT_"""B"","""_X_""",I)")) Q:I'>0  S XQSA(X,I)=""
 S X1=X F J=0:0 S X1=$O(@(XQTMPLT_"""B"","""_X1_""")")) Q:$E(X1,1,$L(X))'=X  F I=0:0 S I=$O(@(XQTMPLT_"""B"","""_X1_""",I)")) Q:I'>0  S XQSA(X1,I)=""
 S X="",K=0 F I=0:0 S X=$O(XQSA(X)) Q:X=""  F J=0:0 S J=$O(XQSA(X,J)) Q:J'>0  S Y=@(XQTMPLT_J_",0)"),Y=$P(Y,U,4) S Z=$S('$D(XQFIL):0,XQFIL=Y:0,1:1) K:Z Y,XQSA(X,J) I $D(Y) D CHKFIL S:YV K=K+1,XQSB(K)=X_U_Y K XQSA(X,J)
 I '$D(XQSB) W $C(7),"  ??" S XQYV=-1 Q
 I K=1 S XQTMP=$P(XQSB(1),U),XQYV=+$P(XQSB(1),U,2) W $E(X,$L(XQTMP+1),$L(X)),! Q
 F I=0:0 S I=$O(XQSB(I)) Q:I'>0  S K=I W !,$J(I,3),"   ",$P(XQSB(I),U),?40,"File ",$P(XQSB(I),U,2) I '(K#10) D SELEC
 I K#10 D SELEC
 S XQYV=-1 I X>0&(X'>K) S XQYV=+$P(XQSB(+X),U,2),XQTMP=$P(XQSB(+X),U)
 Q
 ;
SELEC ;See which one they realy want
 I $D(XQSA) W:$O(XQSA(X,J))>0 !?10,"Enter '^' to stop, RETURN to continue or"
 W !?10,"Select from 1 through ",K,": " R X:DTIME Q:'$T!(X[U)!(X>0&(X'>K))
 Q
 ;
CHKFIL ;See if user has file access if Part 3 has been run
 S YV=1 I XQTMPLT["E" I $D(^DIC(Y,0,"WR")) S YZ=^("WR") D:'$D(^VA(200,"AFOF")) CHKFMA I $D(^VA(200,"AFOF")) S YV="" I $D(^VA(200,DUZ,"FOF",Y,0)),$P(^(0),U,6) S YV=1 Q
 I XQTMPLT'["E" I $D(^DIC(Y,0,"RD")) S YZ=^("RD") D:'$D(^VA(200,"AFOF")) CHKFMA I $D(^VA(200,"AFOF")) S YV="" I $D(^VA(200,DUZ,"FOF",Y,0)),$P(^(0),U,5) S YV=1 Q
 Q
 ;
CHKFMA ;If not Part 3 check old style FM access codes
 Q:YZ=""  S YV="",XQFMA=$P(^VA(200,DUZ,0),U,4) I $L(XQFMA) F I=1:1:$L(XQFMA) I YZ[$E(XQFMA,I) S YV=1 Q
 Q
DELETE ;
 I '$D(^VA(200,DUZ,19.5,"B",XQSMDY)) W !,$C(7),"This option is not among your delegated options" G RULES
 I $D(^VA(200,"AP",XQSMDY)) W !!,"This option is used as a PRIMARY MENU for:",! D  W !!,$C(7),"Can't delete while it is used as a primary menu.",!! K XQJ G RULES
 .F XQJ=0:0 S XQJ=$O(^VA(200,"AP",XQSMDY,XQJ)) Q:XQJ'>0  W !?10,$P(^VA(200,XQJ,0),U)
 S DIR("A")="Do your REALLY want to DELETE "_$P(^DIC(19,+XQSMDY,0),U),DIR("B")="NO",DIR(0)="Y" D ^DIR K DIR G:'Y RULES
 F XQJ=0:0 S XQJ=$O(^DIC(19,"AD",XQSMDY,XQJ)) Q:XQJ'>0  S DA=$O(^DIC(19,XQJ,10,"B",XQSMDY,0)) I DA>0 S DA(1)=XQJ,DIK="^DIC(19,DA(1),10," D ^DIK K DIK
 F XQJ=0:0 S XQJ=$O(^VA(200,"AD",XQSMDY,XQJ)) Q:XQJ'>0  S DA=$O(^(XQJ,0)),DA(1)=XQJ,DIK="^VA(200,DA(1),203," D ^DIK K DIK
 F XQJ=0:0 S XQJ=$O(^VA(200,XQJ)) Q:XQJ'>0  I $D(^(XQJ,19.5,"B",XQSMDY)) S DA=$O(^(XQSMDY,0)),DA(1)=XQJ,DIK="^VA(200,DA(1),19.5," D ^DIK K DIK
 S DA=XQSMDY,DIK="^DIC(19," D ^DIK K DIK,XQJ
 G RULES
