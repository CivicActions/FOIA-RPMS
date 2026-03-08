DICR ;SFISC/GFT-RECURSIVE CALL FOR X-REFS ON TRIGGERED FLDS ;4/17/89  11:05 ; [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 I DIU]"" F DIW=0:0 S DIW=$O(^DD(DIH,DIG,1,DIW)),X=DIU Q:'DIW  I $P(^(DIW,0),U,3)=""!'$D(DB(0,DIH,DIG,DIW,2)) S DB(0,DIH,DIG,DIW,2)=1 D SAVE X ^(2) D RESTORE
 I DIV]"" F DIW=0:0 S DIW=$O(^DD(DIH,DIG,1,DIW)),X=DIV Q:'DIW  I $P(^(DIW,0),U,3)=""!'$D(DB(0,DIH,DIG,DIW,1)) S DB(0,DIH,DIG,DIW,1)=1 D SAVE X ^(1) D RESTORE
Q Q
 ;
SAVE F DB=1:1 Q:'$D(DB(DB))
 F Y="DIC","DIV","DA" S %="" F DB=DB:0 S @("%=$O("_Y_"(%))") Q:%=""  S DB(DB,Y,%)=@(Y_"(%)")
 F %="DIC","DIW","DIU","DIV","DIH","DIG","DB","DG","DA","DICR" S DB(DB,%)="" I $D(@%)#2 S DB(DB,%)=@%
 K DA F Y=-1:1 Q:'$D(DIV(Y+1))
 I Y+1 S DA=DIV(Y) F %=Y-1:-1:0 S DA(Y-%)=DIV(%)
 Q
 ;
RESTORE F DB=1:1 Q:'$D(DB(DB+1))
 F Y="DIC","DIV","DA" K @Y S %="" F DB=DB:0 S %=$O(DB(DB,Y,%)) Q:%=""  S @(Y_"(%)=DB(DB,Y,%)")
 S Y="" F %=0:0 S Y=$O(DB(DB,Y)) Q:Y=""  S @Y=DB(DB,Y)
 K DB(DB) K:DB=1 DB Q
 ;
DICL N I
 K DIC("S"),DLAYGO I '$P(Y,U,3) K DIC Q
DICADD ;
 S (D0,DIV(0))=+Y,DIV(U)=Y
 I DIC S DIH=DIC,DIC=^DIC(DIC,0,"GL")
 E  S @("DIH=+$P("_DIC_"0),U,2)")
 S DICR=$S($D(DA)#2:DA,1:0),DA=D0 F DIG=.001:0 S DIG=$O(DIC(DIG)) Q:DIG'>0  D U:DIC(DIG)]""
 S DA=DICR,Y=DIV(U) K DIC Q
 ;
U S %=$P(^DD(DIH,DIG,0),U,4),Y=$P(%,";",2),%=$P(%,";",1),X="",DIV=DIC(DIG) I @("$D("_DIC_DIV(0)_",%))") S X=^(%)
 G P:Y,Q:Y'?1"E"1N.NP S D=+$E(Y,2,9),Y=$P(Y,",",2),DIU=$E(X,D,Y) I DIU?." " S DIU="" S:$L(X)+1<D X=X_$J("",D-1-$L(X))
 S ^(%)=$E(X,1,D-1)_DIV_$E(X,Y+1,999)
 G DICR
P S DIU=$P(X,U,Y),$P(^(%),U,Y)=DIV
 G DICR
CONV ;
 K DA F %=0:1 Q:'$D(@("D"_%))
 S %=%-1 I '% S DA=D0 K % Q
 S DA=@("D"_%),%=%-1,Y=0
 F %1=%:-1:0 S Y=Y+1,DA(Y)=@("D"_%1)
 K %,%1,Y
 Q
SD ;
 S DIV(0)=DA D U K DA,DIH,DIG,DIV Q
