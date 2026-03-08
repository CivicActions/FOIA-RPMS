DICOMPZ ;SFISC/GFT-EVALUATE COMPUTED FLD EXPR ;5/17/93  12:33 PM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
ARG ;
 S DPS(DPS,DICF)="",DPS(DPS)=" "_^(1)_DPS(DPS)_" S X=X" I $D(^(2)) S %=$P(^(2),U,1) I %]"" S DPS(DPS,%)=""
 I DPS=1,$D(^(10)),^(10)]"" S DPS(^(10))=""
 S %=$S($D(^(3)):^(3),1:0) G W:%?.N
 S %=1 F %Y=M+1:1 S Y=$E(I,%Y) Q:")"[Y  S:Y="," %=%+1
 S DPS(DPS)=" K X"_%_DPS(DPS)
W S:%>1 W(DPS)=% Q
 ;
MUL ;
 I $E(I,M,M+1)="'["!(W["[") G CNTNS
 I D S X=$P(^DD(+D,.01,0),U,2) G WP:X["W" D X G FOR
 S %=D,DIMW="m"_$E("w",%["w"),(DICN,D)=$P(Y(0),U,5,99) F Y=0:0 S Y=$F(D,"X DICMX",Y) Q:Y'>0  S D=$E(D,1,Y-8)_DICMX_$E(D,Y,999),Y=$L(DICMX)-7+Y
 I DICMX'="X DICMX",D=DICN S D=DICMX D DIM S D="S DICMX="_DA_DIM_") "_DICN
 I %["p" S Y=+$P(%,"p",2),(%,DLV,DLV0)=DLV0+100,I(%)=^DIC(Y,0,"GL"),J(%)=Y D DICOMPX^DICOMPV
DIM S DIM=DIM+.1,X(DIM)=D,X=" X "_$S(DA:"^DD("_A_","_DA_",",1:DA)_DIM_")" Q
 ;
X ;
 S X="S X=$P(^(0),U,1)"_$S(X["D":",Y=X D D^DIQ S X=Y",X["P":" S:$D(^"_$P(^(0),U,3)_"+X,0)) X=$P(^(0),U,1)",X["S":",Y=$F(^DD("_+D_",.01,0),X_$C(58)) S:Y X=$P($E(^(0),Y,999),$C(59),1)",1:""),DIMW="m" Q
 ;
WP S DIMW="m"_$E("w",X'["L")
M S X="S X=^(0)"
FOR S Y=T#100+1,D=$P($P(Y(0),U,4),";",1),X="D)) Q:D'>0  I $D(^(D,0))#2 "_X_" "_DICMX_" Q:'$D(D)  S D=D"_Y S:+D'=D D=Q_D_Q
 F T=T:-1:T\100*100 S X=$S(T<DLV0:"I("_T_",0)",1:"D"_(T#100))_","_D_","_X,D=I(T)
 S D="F D=0:0 S (D,D"_Y_")=$O("_D_X
 I DICOMP["I" S X=I(DLV0) D QQ^DICOMPX:X["""" S D="S I("_DLV0_")="""_X_""",J("_DLV0_")="_J(DLV0)_" "_D
 D DIM S X=X_":D"_(Y-1)_">0 S X="""""
 Q
 ;
CNTNS K DICF S:$D(DICMX) DICF=DICMX S DPS=DPS+1,DPS(DPS)=DG(DLV0)+1,DG(DLV0)=DPS(DPS)+1,DD=W="'",DICMX="I X["_DQI_DPS(DPS)_") S "_DQI_(DPS(DPS)+1)_")="_'DD_" K D"
 D M K DICMX S:$D(DICF) DICMX=DICF
 S DIMW="",I=$E(I,M+DD+1,999),DPS(DPS)=" S "_DQI_DPS(DPS)_")=X,"_DQI_(DPS(DPS)+1)_")="_DD_X_" S X="_DQI_(DPS(DPS)+1)_")" K Y D I^DICOMP,^DICOMP0:X]""
 I $D(Y) S K=K+1,K(K)=X,X=DPS(DPS),DBOOL=1
 S DPS=DPS-1
 Q
SD ;
 I +DICOMPX=200,$P(^DIC(200,0),U)="NEW PERSON" W:DICOMP["?" !?5,"CANNOT SET DATA INTO THE NEW PERSON FILE" K X Q
 I +DICOMPX=3,$P(^DIC(3,0),U)="USER" W:DICOMP["?" !?5,"CANNOT SET DATA INTO THE USER FILE" K X Q
 I $P($G(^DD(+DICOMPX,0,"DI")),U,2)["Y" W:DICOMP["?" !?5,"CANNOT SET DATA INTO A RESTRICTED"_$S($P($G(^("DI")),U)["Y":" (ARCHIVE)",1:"")_" FILE" K X Q
 S %=$P($P(DICO,",",$L(DICO,",")),")") I $A(%)=34,"^@"[$E(%,2) W:DICOMP["?" !?5,"CANNOT SET "_%_" INTO A FIELD" K X Q
 S DICF=I(DLV0)
 I $P(^DD(+DICOMPX,+$P(DICOMPX,U,2),0),U,2)["C" W:DICOMP["?" !?5,"CANNOT SET DATA INTO A COMPUTED FIELD" K X Q
 I $P($P(^(0),U,4),";",2),%[U W:DICOMP["?" !?5,"CANNOT SET A VALUE WHICH CONTAINS AN '^' INTO A FIELD" K X Q
 S DICF(1)=0 F %=DLV0:0 S %=$O(I(%)) Q:%'>0  S DICF=DICF_"D"_(%#10-1)_","_$E(Q,I(%)[Q)_I(%)_$E(Q,I(%)[Q)_",",DICF(1)=DICF(1)+1
 S %=" S DA=D"_DICF(1),Y=0
 I DICF(1)>0 F DICF(1)=DICF(1)-1:-1:0 S Y=Y+1,%=%_",DA("_Y_")=D"_DICF(1)
 S DICF(1)=%_",DIH="_+DICOMPX_",DIG="_+$P(DICOMPX,U,2)_",DIC="_Q_DICF_Q
 Q
