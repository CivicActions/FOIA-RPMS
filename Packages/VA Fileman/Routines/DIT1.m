DIT1 ;SFISC/GFT,TKW-TRANSFER DD'S ;10/9/90  11:59 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 K A W !! S A=+Y,E=A
CHK F V=0:0 S V=$O(^DD(A,"SB",V)) Q:'V  S A(V)=0,L(V)=DLAYGO_$P(V,E,2,9)
 S A=$O(A(0)),B=A#1+DHIT I A'="" K A(A) G P:$P(DHIT,".",1)+1'>B,CHK:'$D(^DD(B)),P:DHIT["." S X=$P(^(B,0),U,1) S:$D(^DIC(B,0)) X=$P(^(0),U,1)_" FILE" W $P(^DD(A,0),U,1)_" WOULD COLLIDE WITH "_X,$C(7),! K L,A Q
 S A=$O(L(0)) I A S %X="^DIC("_A_",""%D"",",%Y="^DIC("_L(A)_",""%D""," D %XY^%RCR
 D WAIT^DICD F A="^DIE(","^DIPT(","^DIBT(" F V=0:0 S V=$O(@(A_"V)")) Q:'V  I $D(^(V,0)),$P(^(0),U,4)-Y=0 S ^UTILITY("DITR",$J,A,V)=$P(^(0),U,1)
 S A="F B=0:0 Q:F=DTO!'$F(W,DTO)  S W=$P(W,DTO)_F_$P(W,DTO,2,9)"
 G GO:$O(^UTILITY("DITR",$J,-1))="" W !,"DO YOU WANT TO COPY '",$P(Y,U,2),"'S TEMPLATES INTO YOUR NEW FILE" D YN^DICN W !
 I %=1 S E="I DIK=""^DIBT("",%Z=1,$D(L(+W)) S $P(W,U,1)=L(+W)" F DIK="^DIE(","^DIPT(","^DIBT(" S V=$P(@(DIK_"0)"),U,3),%X=DIK_"Z,",%Y=DIK_"V," D ^DIT2,IXALL^DIK
GO S Y=DLAYGO K ^UTILITY("DITR",$J),^DD(Y,"B"),^(.01),^("IX"),^("RQ"),^(0,"IX"),E
 S @("V=$P("_DTO_"0),U,2)"),@("^(0)=$P("_DTO(0)_"0),U,1,2)_$P(V,DDF(1),2)_U_U")
DD W ! S L=$O(L(L)),Y=L#1+DHIT Q:L=""  S B=0,V=$O(^DD(L,0,"NM",0)),^DD(Y,0)=^DD(L,0) I V]"",$O(^(0,"NM",0))="" S ^(V)=""
 S V=-1 I $D(^DD(L,0,"UP")) S ^DD(Y,0,"UP")=^("UP")#1+DHIT
ID S V=$O(^DD(L,0,"ID",V)) I V]"",$D(^(V))#2 S W=^(V) X A S ^DD(Y,0,"ID",V)=W G ID
 F V=0:0 S V=$O(^DD(L,V)) Q:'V  I $D(^(V,0)) W "." S W=^(0),D=$P(W,U,2),%Z=0,%A="" S:D L(+D)=D#1+DHIT,W=$P(W,U,1)_U_L(+D)_$P(D,+D,2,9)_U_$P(W,U,3,99) X A D Y S ^DD(Y,V,0)=W,%B=0 D N
 S DA(1)=Y,DIK="^DD("_Y_"," D IXALL^DIK K %A,%B,%C,%Z G DD
 ;
P W $C(7),"FILE #"_+Y_" SHOULD ONLY BE TRANSFERRED TO A FILE WHOSE NUMBER",!?8,"ALSO "_$S(Y#1:"ENDS WITH '"_(Y#1)_"'",1:"IS INTEGER") K L,A Q
 ;
N S %B=$O(@("^DD(L,V,"_%A_"%B)")) G:%B=5 N I %B="" Q:'%Z  S @("%B="_$P(%A,",",%Z)),%Z=%Z-1,%A=$P(%A,",",1,%Z)_$E(",",%Z>0) G N
 I @("$D(^DD(L,V,"_%A_"%B))#2") S W=^(%B) D D S @("^DD(Y,V,"_%A_"%B)=W")
 I @("$D(^DD(L,V,"_%A_"%B))<9") G N
 S:+%B'=%B %B=""""_%B_"""" S %A=%A_%B_",",%Z=%Z+1,%B=-1 G N
 ;
D X A
Y F DTL=0:0 S DTL=$O(L(DTL)) Q:'DTL  F %=2:1 S B=$P(W,DTL,%,999) Q:B=""  S:'B W=$P(W,DTL,1,%-1)_(DTL#1+DHIT)_B,%=%-1
