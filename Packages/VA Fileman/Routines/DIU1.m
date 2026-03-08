DIU1 ;SFISC/GFT-REINDEX A FILE ;2/24/93  14:13 ; [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
4 ;
 W !! K ^UTILITY("DIK",$J),X S DIK=DIU,X=0 D DD^DIK S DW=0,DIUF=DI K DU,DV
DW S DW=$O(^UTILITY("DIK",$J,DW)),DV=0 S:DW="" DW=-1
 I DW>0 S DU=0 F  S DV=$O(^UTILITY("DIK",$J,DW,DV)),DH=0 G DW:DV="" S Y=0 F  S DH=$O(^UTILITY("DIK",$J,DW,DV,DH)) Q:DH=""  S Y=^(DH),X=X+1,X(X)=Y,X(X,0)=DW_U_DV S:$P(Y,U,3)=""&'Y&$D(^(DH,0)) X(X)=^(0)
 K ^UTILITY("DIK",$J) G DD:'X,ONE:X>1
ALL W "OK, ARE YOU SURE YOU WANT TO KILL OFF THE EXISTING "_$S(X=1:$P(^DD(+X(1,0),$P(X(1,0),U,2),0),U,1)_" INDEX",1:X_" INDICES") S %=2
 D YN^DICN G:%-1 NO:%,Q W !,"DO YOU THEN WANT TO 'RE-CROSS-REFERENCE'" D YN^DICN G NO:%<1 S N=%=1 D WAIT^DICD
 F X=X:-1:1 S %=$P(X(X),U,2) I %]"",+X(X)=DI K @(DIK_"%)") K:$P(X(X),U,3)'="MUMPS" X(X)
 S DIK(0)="AB" I $O(X(0))'="" S X=2,(DA,DCNT)=0 D DD^DIK,CNT^DIK1
 K X I N W !,$C(7),"FILE WILL NOW BE 'RE-CROSS-REFERENCED'..." H 5 D DD S DIK=^DIC(DIUF,0,"GL") D IXALL^DIK
 K DIK,DIC Q
 ;
DD S DIK="^DD(DI,",DA(1)=DI K ^DD(DI,"B"),^("GL"),^("IX"),^("RQ"),^("GR"),^("SB")
 W "." D IXALL^DIK:$D(^(0))#2 S DI=$O(^DD(DI)) S:DI="" DI=-1 I DI>0,DI<$O(^DIC(DIUF)) G DD
 Q
 ;
ONE S %=2 W "THERE ARE "_X_" INDICES WITHIN THIS FILE",!,"DO YOU WISH TO RE-CROSS-REFERENCE ONE PARTICULAR INDEX" D YN^DICN W ! I %-1 G ALL:%=2,NO:%,Q
 K X S X="CW" D DI^DIU G NO:Y<0 S (DA,DL)=+Y,DICD="RE-CROSS-REFERENCE" D CHIX^DICD G NO:'DICD
 S X=$P(I,U,2)
 W !,"ARE YOU SURE YOU WANT TO DELETE AND RE-CROSS-REFERENCE "_$S(X]"":"THE '"_X_"' INDEX",1:"THIS TRIGGER") S %=2 D YN^DICN G NO:%-1
 G IND:X="" F %=0:0 S %=$O(^DD(+I,0,"IX",X,%)) Q:%=""  F %Y=0:0 S %Y=$O(^DD(+I,0,"IX",X,%,%Y)) Q:%Y=""  I %Y-DA!(%-DI) G IND
 I +I=DIUF,$P(I,U,3)="",X]"" K @(DIK_"X)") G REDO
IND S X=^DD(J(N),DA,1,DICD,2) D DD^DICD:"Q"'[X S DIU=^DIC(DIUF,0,"GL")
REDO S X=^DD(J(N),DL,1,DICD,1) D DD^DICD:"Q"'[X W $C(7),"    ...DONE!" Q
 ;
Q F I=1:1:X W !,"FIELD " S %=X(I,0),J=$P(%,U,2) W J_" ('"_$P(^DD(+%,J,0),U,1)_"'" W:%-DI ", "_$O(^DD(+%,0,"NM",0))_" SUBFILE" W ") IS ",$S(X(I):"'"_$P(X(I),U,2)_"' INDEX",1:$P(X(I),U,3)) D UP
 G 4
UP I X(I),X(I)-DI S %=$D(^DD(+X(I),0,"UP")) W " OF "_$O(^("NM",0))_" "_$P("SUB",U,%>0)_"FILE" Q
 S %=+$P(X(I),U,4),(%F,Y)=+$P(X(I),U,5) I %,$D(^DD(%,Y,0)) W:$X>44 ! W " OF " D WR^DIDH
 Q
 ;
NO W !?7,$C(7),"<NO ACTION TAKEN>" K DICD,X,DH
 Q
