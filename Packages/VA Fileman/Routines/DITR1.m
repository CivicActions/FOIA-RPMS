DITR1 ;SFISC/GFT-FIND ENTRY MATCHES ;2/18/98  12:37 [ 09/10/1998  10:50 AM ]
 ;;21.0;VA FileMan;**1007**;Sep 08, 1998
 ;;21.0;VA FileMan;**41**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;12380;6525800;2516;
 ;
 S W=DMRG,X=$P(Z,U),%=DFL\2,Y=@("D"_%),A=1 S:$G(DIFRDKP) DIFRNOAD=$D(@DIFRSA@("^DD",DIFRFILE,DDT(DTL),.01,0))
 G WORD:$P(^DD(DDT(DTL),.01,0),U,2)["W",Q:X="",ON:'W
 K DINUM I ^(0)["DINUM" S V=+Y G:$P(^(0),U,2)["P" DINUM S V=X,DA=Y,Y=0,D0=$S($D(D0):D0,$D(DFR):DFR,1:"") D DA X $P(^(0),U,5,99) S X=V,Y=DA Q:'$D(DINUM)  S (Y,V)=DINUM K DINUM G DINUM
 S V=0 D:'$D(DISYS) OS^DII
B I '$D(^DD(DDT(DTL),0,"IX","B",DDT(DTL),.01)) F A=1:1 S V=$O(@(DTO(DTL)_V_")")) G NEW:V'>0 I $D(^(V,0)),$P(^(0),U)=X D MATCH G OLD:'$D(A) S A=1
 S %=+$P(^DD("OS",DISYS,0),U,7) S:'% %=63
 S V=$S($O(@(DTO(DTL)_"""B"",$E(X,1,%),V)"))>0:$O(^(V)),1:$O(@(DTO(DTL)_"""B"",$E(X,1,30),V)"))) G NEW:V'>0
 I $D(@(DTO(DTL)_V_",0)")),$P(^(0),X)="" D MATCH G OLD:'$D(A)
 G B
 ;
DA Q:'%  S DA(%)=@("D"_Y),Y=Y+1,%=%-1 G DA
 ;
DINUM I @("$D("_DTO(DTL)_"Y))") G:'DKP OLD D MATCH G:'$D(A) OLD S A=1 G Q
 G ADD
 ;
NEW S W=0
ON I @("$D("_DTO(DTL)_"Y))") G OLD:W S DITRCNT=$G(DITRCNT)+1,Y=DITRCNT G ON
ADD G:$G(DIFRDKP) Q:DIFRNOAD S @("V="_DTO(DTL)_"0)"),^(0)=$P(V,U,1,2)_U_Y_U_($P(V,U,4)+1),^(Y,0)=X
OLD S DTO(DTL+1)=DTO(DTL)_Y_",",DTN(DTL+1)=0,A=0
Q Q
 ;
WORD I $G(DIFRDKP) Q:$D(@DIFRSA@("^DD",DIFRFILE,DDT(DTL),.01))
 S @("V=$O("_DTO(DTL)_"0))") X:V'>0!'DKP "K "_$E(DTO(DTL),1,$L(DTO(DTL))-1)_") S:$D("_DFR(DFL)_"0)) "_DTO(DTL)_"0)=^(0)","F V=0:0 S V=$O("_DFR(DFL)_"V)) Q:V'>0  S:$D(^(V,0)) "_DTO(DTL)_"V,0)=^(0)" S (DFL,DTL)=DFL-1 Q
 ;
MATCH S A=1 I Y'=V,$D(^DD(DDT(DTL),.001,0)) Q
 S Y=V,I=.01
I S I=$O(^DD(DDT(DTL),0,"ID",I)) I I'>0 G:$G(DIFRDKPR)&($G(DIFRDKPD))&('DTL) REPLACE K A Q
 G I:'$D(^DD(DDT(DTL),I,0)) K B D P G I:W="" S B=W
 I DTO S A=$P(A,";",2)_U_$P(A,";",1) F %=0:0 S %=$O(^UTILITY("DITR",$J,DDF(DFL+1),%)) G I:%'>0 Q:^(%)=A
 E  S %=I
 G I:'$D(^DD(DDF(DFL+1),%,0)) D P G I:W="",I:W=B
 S Y=@("D"_(DFL\2)) Q
 ;
P S A=$P(^(0),U,4),%=$P(A,";",2),W=$P(A,";",1) I @("'$D("_$S('$D(B):DTO(DTL)_"Y,",DFL:DFR(DFL)_"DFN(DFL),",1:DFR(1))_"W))") S W="" Q
 I % S W=$P(^(W),U,%)
 E  S W=$E(^(W),+$E(W,2,9),$P(W,",",2))
 I W'?.UNP F %=1:1:$L(W) I $E(W,%)?1L S W=$E(W,0,%-1)_$C($A(W,%)-32)_$E(W,%+1,999)
 Q
 ;
REPLACE ;
 N DA,DIK
 K @DIFRSA@("TMP")
 I DIFRDKPS M @DIFRSA@("TMP",DIFRFILE,Y)=@(DTO(DTL)_Y_")")
 S DA=Y,DIK=DIFROOT
 N %,A,B,D0,DDF,DDT,DFL,DFR,DINUM,DKPKDMGR,DTL,DTN,DTO,I,W,X,Y,Z
 D ^DIK
 S DIFRDKPD=0,V="A"
 Q
