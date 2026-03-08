DICM3 ;SFISC/XAK-PROCESS INDIVIDUAL FILE FOR VAR PTR ;12/12/96  13:27 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
DIC ;
 Q:$D(DIVP(+DIVPDIC))
 I $D(DIC("V")) S Y=DIVP,Y(0)=DIVPDIC X DIC("V") I '$T K Y S Y=-1 G DQ
 I '$D(^DIC(+DIVPDIC,0,"GL")) S Y=-1 G DQ
 N DIVP1SAV I $D(DIVP1) S DIVP1SAV=DIVP1 N DIVP1 S DIVP1=DIVP1SAV
 S (Y,DIC)=^("GL"),%="DIC"_DICR,D=$G(DICR(DICR,4)) S:D="" D="B"
 I DIC["""" S Y="" F A1=1:1:$L(DIC,",")-1 S A0=$P(DIC,",",A1) S:A0["""" A0=$P(A0,"""")_""""""_$P(A0,"""",2)_""""""_$P(A0,"""",3) S Y=Y_A0_","
 S:DIC(0)'["L"!'$D(DICR(DICR,"V")) DIC("S")="X ""I 0"" F "_%_"=0:0 S "_%_"=$O("_DIVDIC_""""_D_""""_",(+Y_"";"_$E(Y,2,99)_"""),"_%_")) Q:"_%_"'>0  I $D("_DIVDIC_%_",0))"_$S($D(DIV("S")):" S %YV=Y,Y="_%_" X DIV(""S"") S Y=%YV I ",1:"")_" Q"
 S %=DIC(0),DIC(0)="DM"_$E("E",%["E")_$E("O",%["O") I D="B",$P(DIVPDIC,U,6)="y",$D(DICR(DICR,"V")),%["L" S DIC(0)=DIC(0)_"L"
 I $D(DICR(DICR,"V")),$P(DIVPDIC,U,5)="y",$D(^DD(DIVDO,DIVY,"V",DIVP,1)),^(1)]"" S %=$S($D(DIC("S")):DIC("S"),1:"") X ^(1) S DIC("S")=DIC("S")_" "_%
 I DIC(0)["E",$D(DIVP1),$D(DICR(DICR,"V")) D H1^DIE3
 I X?."?" S DZ=X_$E("?",'$D(DICR(DICR,"V"))) D DQ^DICQ S X=$S($D(DZ):DZ,1:"?"),Y=-1 G DQ
 D DO^DIC1
 S D="B" D X^DIC G DQ:$D(DUOUT) S X=+Y_";"_$E(DIC,2,99),%=1 K:Y<0 X
 I Y<0,DIC(0)["E",$D(DIVP1),$D(DICR(DICR,"V")) W !
 I '$D(DICR(DICR,"V")) K DICR("^",+DIVPDIC) S DIVP(+DIVPDIC)=0
 I Y>0,$D(DIVP1),DIC(0)["E",'$P(Y,U,3),$P(@(DIC_"0)"),U,2)'["O" D S1^DIE3
DQ K A0,A1,DIC,DO S DIC=DIVDIC,D=$S($D(DICR(DICR,4)):DICR(DICR,4),1:"B"),DIC(0)=DICR(DICR,0) S:$D(DIVP1SAV) DIVP1=DIVP1SAV I $D(DIV("V")) S DIC("V")=DIV("V")
 Q
