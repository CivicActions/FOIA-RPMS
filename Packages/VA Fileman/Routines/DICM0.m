DICM0 ;SF/XAK - LOOKUP WHEN INPUT MUST BE TRANSFORMED ;9/20/96  14:41 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**6,29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
P ;Pointers, called by ^DICM1
 S DICR(DICR,1)=DIC,DIC=U_$P(DS,U,3),Y=DIC(0),DIC(0)=$TR(Y,"L","")
 S DICR(DICR,2)=$S(%="B":Y,1:DIC(0)),DICR(DICR,2.1)=$S($P(DS,U,2)["'":DIC(0),1:Y)
 I DIC(0)["B" S DIC(0)=$TR(DIC(0),"M",""),DICR(DICR,2.1)=$TR(DICR(DICR,2.1),"M","")
 S DIC(0)=$TR(DIC(0),"N","")
 F Y="DR","S","P","W" I $D(DIC(Y)) S DICR(DICR,Y)=DIC(Y) K DIC(Y)
AST G P1:$P(DS,U,2)'["*"
 F D=" D ^DIC"," D IX^DIC"," D MIX^DIC1" S Y=$F(DS,D) I Y X $P($E(DS,1,Y-$L(D)-1),U,5,99) S:DS["DIC(0)=" DICR(DICR,2.1)=DIC(0) I $D(DIC("S")) S DICR(DICR,31)=DIC("S")
P1 S Y="("_DICR(DICR,1) G L1:'$D(DO) K DO I @("$O"_Y_"0))'>0") G L1
 S I="DIC"_DICR,D="X ""I 0"" F "_I_"=0:0 S "_I_"=$O"_Y,%=""""_%_"""" I @("$O"_Y_%_",0))>0") S D=D_%_",Y,"_I_")) Q:"_I_"'>0  I $D"_Y_I_",0))"
 E  I DS["DINUM=X" S D="I $D"_Y_"Y,0)) S "_I_"=Y"
 E  I $P(DS,U,4)="0;1" S D=D_I_")) Q:"_I_"'>0  I $P(^("_I_",0),U)=Y"
 E  S D="" G L1
 I $D(DICR(DICR,31)) S D="X DICR("_DICR_",31) "_D
 I $D(DICR(DICR,"S")) S D=D_" S %Y"_DICR_"=Y,Y="_I_" X DICR("_DICR_",""S"") S Y=%Y"_DICR_" I "
 S DIC("S")=D_" Q",D="B",Y=0 N DS D X^DIC
L1 K DIC("S"),@("DIC"_DICR) I Y'>0,'$D(DICR(DICR,8)) S:$D(DICR(DICR,31)) DIC("S")=DICR(DICR,31) G RETRY
 I DICR(DICR,2)["L",DICR(DICR,2)["E",@("$P("_DIC_"0),U,2)'[""O"""),$P(@(DICR(DICR,1)_"0)"),U,2)'["O" S DST="         ...OK",%=1 D Y^DICN W:'$D(DDS) ! G:%-1 L2
R K DICS,DICW,DO,DIC("W"),DIC("S")
 S DIC=DICR(DICR,1),%=DICR(DICR,2),DIC(0)=$P(%,"M")_$P(%,"M",2)
 F X="DR","S","P","W" S:$D(DICR(DICR,X)) DIC(X)=DICR(DICR,X)
 I $D(DIC("P")),+DIC("P")=.12 S DIC(0)=DIC(0)_"X"
 D DO^DIC1 S X=+Y K:X'>0 X Q
 ;
L2 G NO:%-2 S DIC("S")="I Y-"_+Y_$S($D(DICR(DICR,31)):" "_DICR(DICR,31),1:""),X=DICR(DICR) W:'$D(DDS) "     "_X I $D(DDS),$G(DDH) D LIST^DDSU
 K DST ;
RETRY D DO^DIC1 K DICR(U,+DO(2)) S D="B",DIC(0)=DICR(DICR,2.1) D X^DIC K DICR(DICR,6)
 G R
 ;
NO S Y=-1 G R
 ;
