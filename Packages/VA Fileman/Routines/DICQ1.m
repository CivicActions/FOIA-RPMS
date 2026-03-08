DICQ1 ;SFISC/GFT-HELP FOR LOOKUPS ;1/21/97  13:23 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
EN K DDD I $D(DDH)>10 S:$D(DDS) DDD=1 D LIST^DDSU Q:$D(DDSQ)
 S Y=$S('$D(%Y):0,%Y:%Y-.00000001,1:%Y)
 I $L(DS)+$L(X)<240 S DS=DS_X G N
 E  S DS=DS_" X DS(3)",DS(3)=$S($E(X)=" ":$E(X,2,999),1:X)
N S X="" I DIZ S DIY=$L($P(DO,U,3))+DIY+5 S:Y="" Y=0
 E  S X=$S(Y=0:"",1:Y),Y=0
 D:$D(DIC("W"))!($D(DID01)) ID K DID01 S DDD=5,DIY=99,DIEQ="",$P(DIEQ," ",40)=" ",DIZ=DDC
 I '$D(DDS) D Z^DDSU
 ;
L X DIX I  D BK^DIEQ S:'$D(DDS) DDD=3 D LIST^DDSU K DDH Q:$D(DDSQ)  G 0
 X DS I $D(DICQ1Q) K DICQ1Q Q:$D(DTOUT)!$D(DDSQ)  G:'$D(DDH) 0
 I $D(DDS),DDH'<DIZ S DIZ=DDH+DDC D LIST^DDSU Q:$D(DDSQ)
 I '$D(DDS),DDH'<DDC D LIST^DDSU Q:$D(DTOUT)  G:'$D(DDH) 0
 G L
CHK ;Called by code in DS at line L+1 when we're doing a lookup with
 ;a DIC("S") and/or DIC("W") defined.
 I $D(DDS),DDH'<DIZ S DIZ=DDH+DDC D LIST^DDSU I $D(DDSQ) S DICQ1Q=1
 I '$D(DDS),DDH'<DDC D LIST^DDSU I $D(DTOUT)!'$D(DDH) S DICQ1Q=1
 Q
 ;
ID S DIY="I $D("_DIC_"Y,0))" I $D(DID01) S DIY=DIY_" "_DID01_" "_DIY
 I '$D(DIC("W")) S DDH("ID")=DIY Q
 S DIY=DIY_" "
 I $L(DIC("W"))+$L(DIY)<240 S DDH("ID")=DIY_DIC("W") Q
 S DDH("ID")=DIY_"X DDH(""ID"",1)" S DDH("ID",1)=DIC("W") Q
 ;
WOV S %DIC=DIC,%WW=Y,DIC=%Z,Y=%Y,%X=0
W1 S %X=$O(^DD(%W,0,"ID",%X)) I %X]"" S %=^(%X) X "W ""  "",$E("_%Z_%Y_",0),0)",% G W1
 S DIC=%DIC,Y=%WW K %DIC,%W,%X,%YY,%Z,%WW Q
 ;
S S DS(1)=X,DS(2)=Y I 1 X:$D(DIC("S")) DIC("S")
 I $T S Y=DS(2) D SCR:$D(DO("SCR"))
 S X=DS(1),Y=DS(2) Q
 ;
SCR I @("$D("_DIC_"Y,0))") X DO("SCR")
 Q
 ;
DT S A2=$P(%,U,2),%=$P(%,U),A1="" ;I $G(DUZ("LANG"))>1 S A1=$$OUT^DIALOGU(%,"DD"),DDH(DDH,Y)=$S(A2:DDH(DDH,Y),1:"")_A1 Q
 ;S:$E(%,4,5) A1=$E(%,4,5)_"-" S:$E(%,6,7) A1=A1_$E(%,6,7)_"-" S A1=A1_($E(%,1,3)+1700)
 ;S:%["." A1=A1_" @ "_$E(%_0,9,10)_":"_$E(%_"000",11,12)_$S(+$E(%,13,14):":"_$E(%_0,13,14),1:"   ")
 S DDH(DDH,Y)=$S(A2:DDH(DDH,Y),1:"")_$$FMTE^DILIBF(%,6) Q
 ;
0 ;
 K DDC,DIEQ,DIW,DS G:DIC(0)'["L" QQ
 S DDH=$S($D(DDH):DDH,1:0) K A1
 I $D(%Y) S:%Y="??" DZ=%Y S:%Y?1P DZ="?"
 I $S($D(DLAYGO):DO(2)-DLAYGO\1,1:1),DUZ(0)'="@",'$D(^DD(+DO(2),0,"UP")) G JMP
10 I DZ="?" S DST=$$EZBLD^DIALOG(8069,$P(DO,U)) D DS^DIEQ,HP
 D H
 I $D(DZ),DO(2)["S" S DST=$$EZBLD^DIALOG(8068)_" " D %^DICQ D
 . N X,Y,A2,DST,DISETOC,DIMAXL S DIMAXL=0,DISETOC=$P(^DD(+DO(2),.01,0),U,3)
 . F X=1:1 S Y=$P($P(DISETOC,";",X),":") Q:Y=""  S:$L(Y)>DIMAXL DIMAXL=$L(Y)
 . S DIMAXL=DIMAXL+4
 . F X=1:1 S Y=$P(DISETOC,";",X) Q:Y=""  S A2="",$P(A2," ",DIMAXL-$L($P(Y,":")))=" ",DST="  "_$P(Y,":")_A2_$P(Y,":",2) D DS^DIEQ
 . Q
 I DO(2)["V" S DU=+DO(2),D=.01 D V^DIEQ
 ;
RCR G:DO(2)'["P"!($G(DZ(1))=0) QQ
 N D,DIC
 S D="B",DS=^DD(+DO(2),.01,0),DIC=U_$P(DS,U,3),DIC(0)=$E("L",$P(DS,U,2)'["'")
 I $P(DS,U,2)["*" F DILCV=" D ^DIC"," D IX^DIC"," D MIX^DIC1" S DICP=$F(DS,DILCV) I DICP X $P($E(DS,1,DICP-$L(DILCV)-1),U,5,99) Q
 K DICP,DILCV,DO D DQ^DICQ K DICW,DICS,DO
QQ K A1,A2,DST Q:$D(DDH)'>10
 S:$D(DDS) DDC=-1 D LIST^DDSU K DDC Q
 ;
HP F DG=3,12 I $D(^DD(+DO(2),.01,DG)) S X=^(DG) F %=$L(X," "):-1:1 I $L($P(X," ",1,%))<70 S DST=$P(X," ",1,%) D DS^DIEQ,P1 Q
 Q
 ;
P1 I %'=$L(X," ") S DST=$P(X," ",%+1,99) D DS^DIEQ
 Q
 ;
H S %=DIC,X=DZ N DIC,D,DP S DIC=%,D=.01,DP=+DO(2) D H^DIEQ Q
 ;
JMP S DIFILE=+DO(2),DIAC="LAYGO" D ^DIAC K DIAC,DIFILE G RCR:'%,10
 ;
Q K A1,A2 Q
 ;
 ;#8069  You may enter a new |filename|, if you wish
 ;#8068  Choose from
