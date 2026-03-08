DICQ ;SFISC/XAK-HELP FOR LOOKUPS ;1/22/97  14:20 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 S DZ=X D:DIC(0)]"" DQ
 I '$D(DDS),$D(DDH)#2,DDH D ^DDSU
 S:$D(DZ) X=DZ K DZ,DDH,DIZ,DDD G NO^DIC:$D(DTOUT),A^DIC
 ;
DQ S DDC=$S($D(DDS):7,1:15),DDH=$S($D(DDH):DDH,1:0) N DID02 S:$G(DID)]"" DID02=1
 D:'$D(DO) DO^DIC1 K DS,%Y I DO="0^-1" K DO S DST="  Pointed-to File does not exist!" D % Q
 S DD="",Y=$P(DO,U,4),DIY=DO,DIX=D D DIY
 S X=$S($D(^DD(+DO(2),.001,0)):$P(^(0),U,1),DIC(0)["N":"NUMBER",1:""),DIZ=X]"",DIW=^DD(+DO(2),.01,0)
 S DIW=$P(DIW,U,2,3) G:$D(^DD(+DO(2),0,"QUES")) @^("QUES") I DIZ S DS=.001 D DS
IX S X=$O(^DD(+DO(2),0,"IX",DIX,"")) S:X="" %=DO(2) I X]"" S DS=$O(^(X,0)) I $D(^DD(X,DS,0)) S:+DO(2)'=X DS=X_" "_DS S %=$P(^(0),U,2,3),X=$P(^(0),U) D DS
 I @("$D("_DIC_"DIX))>9!$D(DF)"),DD="" S DD=DIX,DIW=% S:'Y Y=2 S:'$D(^(DD)) Y=0,DIZ=0
 D  G IX:DIC(0)["M"&(DIX]"")
 . I $G(DID)]"" S DID02=DID02+1,DIX=$P(DID,U,DID02) S:DIX=-1 DIX="" Q
 . S DIX=$O(^DD(+DO(2),0,"IX",DIX))
 I DD="" S DIZ=1 S:$O(^DD(+DO(2),0,"IX","AZ"))]"" Y=0
 I $D(DZ)#2 G C:DZ["??" S:DZ["BAD" Y=0
 S DST=$$EZBLD^DIALOG(8063,$P(DO,U)) S DS=0
 F X=1:1 S DS=$O(DS(DS)) Q:DS=""  S:X>1!$G(DS(0)) DST=DST_$$EZBLD^DIALOG(8067) D:$L(DST)+$L(DS(DS))>70 N S DST=DST_" "_DS(DS)
 K DS S DST=DST_$E(":",Y) D % G 0:'Y
20 G C:Y<11 S DDH=DDH+1,DDH(DDH,"Q")=0_U_$$EZBLD^DIALOG(8064)_$S(DO(2)'["s"&'$D(DIC("S"))&'$D(DF):$$EZBLD^DIALOG(8065,Y),1:"")_$$EZBLD^DIALOG(8066,$P(DO,U))
 S:$D(DDS) DDD=1 D ^DDSU I '$D(DDS) Q:$D(DTOUT)  G 21
 Q:$D(DDSQ)  S %=1
21 S A1="T",DDH=$S($D(DDH):DDH,1:0) S:%=1 %Y=1 I %Y'="??" S %Y=$E(%Y,2,99) S:%=2&(DIC(0)["L") DZ=""
 G 0:%#2=0!(%<0&(%Y="")),C:%Y=""
 S DIZ=$S(+%Y=%Y:1,DD]"":0,1:DIZ) I +%Y'=%Y G 20:DD="" I $P(DIW,U,1)["D" S DS=Y,X=%Y,%DT="T" D ^%DT K %DT S %Y=Y,Y=DS,DIZ=0 I %Y<0 S DST=$C(7) D % G 20
C I Y>1,$D(DZ)#2 S DST=" " D:DZ["??"&'$D(DDS) % S DST=$$EZBLD^DIALOG(8068) D %
 S X=$P(" D S I ",U,$D(DIC("S"))!$D(DO("SCR")))
 I DIZ S DS="I $D(^(Y,0))#2,'$D(^(-9)) S X=$P(^(0),""^"",1)"_X_" S DDH=DDH+1,DDH(DDH,Y)=Y_$E(DIEQ,1,15-$L(Y))_"" """,DIX="S Y=$O("_DIC_"Y)) S:Y="""" Y=-1 I Y'>0" G A
 S DIX="S X=$O("_DIC_""""_DD_""",X)) I X="""""
 S DS=$S(X]""!$D(DIC("W"))!($G(DZ)["?"):"S Y=0 F  S Y=$O("_DIC_""""_DD_""",X,Y)) Q:'Y "_$P(" I $D(^(Y))#2,'^(Y)",1,DD="B")_" I $D("_DIC_"Y,0)),'$D(^(-9))"_X_" D CHK Q:$D(DICQ1Q) ",1:"I 1")_" S DDH=DDH+1"
 I $G(DICWSET)="" N DICWSET S DICWSET=$S($D(DIC("W"))#2:1,1:0)
 N DID01 I 'DICWSET,DD'="B",'$D(^DD(+DO(2),0,"IX",DD,+DO(2),.01)),DIC(0)'["S" D
 . S DID01="W ""   "",$$EXTERNAL^DILFD("_+DO(2)_",.01,"""",$P("_DIC_"Y,0),U))"
 . Q
A S X="X"
D S Y=$P(DIW,U,1) I Y["D" S DIY=27,X=" S %="_X_"_U_"_DIZ_" D DT" G ^DICQ1
 I Y["P" S DIY=U_$P(DIW,U,2),X="$S($D("_DIY_X_",0))#2:$P(^(0),""^"",1),1:"_X_")" I @("$D("_DIY_"0))") S DIY=^(0) D DIY S DIW=$P(^(0),U,2,3) G D
 I Y["S" S DS(95)=";"_$P(DIW,U,2),X="$P($P(DS(95),"";""_"_X_"_"":"",2),"";"")"
 I Y["V" S X=" S %Y=Y,Y=X,C=$P(^DD(+DO(2),.01,0),U,2) D Y^DIQ S DDH(DDH,%Y)=$S($D(DDH(DDH,%Y)):DDH(DDH,%Y),1:"""")_"" ""_Y S Y=%Y" G ^DICQ1
 S X=" S DDH(DDH,Y)=$G(DDH(DDH,Y))"_"_"_X
M G ^DICQ1
 ;
N D % S DST="    " Q
 ;
% S DDH=DDH+1,DDH(DDH,"T")=DST K DST Q
 ;
0 K DIW,DIZ,DS Q:$D(DTOUT)  S:$D(DDS) DDD=1 G 0^DICQ1:DIC(0)["L" Q  ;END
 ;
DIY S DIY=$P(^DD(+$P(DIY,U,2),.01,0),"$L(X)>",2),DIY=$S(DIY:DIY,1:30)+7 Q
 ;
SOUNDEX G IX
 ;
DS S:DO'[X DS(DS)=X I DO[X,$G(DZ)'["??" S DS(0)=1
 ;
 ;#8063  Answer with |Filename|
 ;#8064  Do you want the entire
 ;#8065  |Number of entries| Entry
 ;#8066  |Filename| List
 ;#8067  , or
 ;#8068  Choose from
