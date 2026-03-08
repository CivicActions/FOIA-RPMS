DICN1 ;SFISC/GFT,SEA/TOAD-PROCESS DIC("DR") ;1/16/97  10:24 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;12257;5825723;3890;
 ;
 K DIDA,DICRS,Y,%RCR
 F Y="DIADD","I","J","X","DO","DC","DA","DE","DG","DIE","DR","DIC","D","D0","D1","D2","D3","D4","D5","D6","DI","DH","DIA","DICR","DK","DIK","DL","DLAYGO","DM","DP","DQ","DU","DW","DIEL","DOV","DIOV","DIEC","DB","DV","DIFLD" S %RCR(Y)=""
 S DZ="W !?3,$S("""_$P(DO,U)_"""'=$P(DQ(DQ),U):"""_$P(DO,U)_""",1:"""")_"" ""_$P(DQ(DQ),U)_"": """
 I $D(DIC("DR")) S DD=DIC("DR")
 E  S DD="",%=0,Y=0 F  S Y=$O(^DD(+DO(2),0,"ID",Y)) S:Y="" Y=-1 Q:Y'>0  D CKID I '$D(%) D W G BAD
 S %RCR="RCR^DICN1" D STORLIST^%RCR G D^DICN:$D(Y)<9
BAD S:$D(D)#2 DA=D K Y I '$D(DO(1)) S Y=-1 G Q^DIC2
 K DO G A^DIC
 ;
CKID I $D(DUZ(0)),DUZ(0)'="@",$D(^DD(+DO(2),Y,9)),^(9)]"" F %=1:1 I DUZ(0)[$E(^(9),%) Q:$L(^(9))'<%  K:$P(^(0),U,2)["R" % G Q
 S DD=DD_Y_";"
Q Q
 ;
W S A1="T",DST="SORRY!  A VALUE FOR '"_$P(^(0),U,1)_"' MUST BE ENTERED," W:'$D(DDS) ! D H
 S A1="T",DST="BUT YOU DON'T HAVE 'WRITE ACCESS' FOR THIS FIELD" W:'$D(DDS) !,?6 D H D:$D(DDS) LIST^DDSU
 S %RCR="D^DICN1" D STORLIST^%RCR Q
 ;
H I $D(DDS) S DDH=$S($D(DDH):DDH+1,1:1),DDH(DDH,A1)=DST K A1,DST Q
 W DST K A1,DST Q
RCR ;
 K DR,DIADD,DQ,DG,DE,DO S DIE=DIC,DR=DD,DIE("W")=DZ K DIC I $D(DIE("NO^")) S %RCR("DIE(""NO^"")")=DIE("NO^")
 S DIE("NO^")="OUTOK"
 D:$D(DDS) CLRMSG^DDS D ^DIE K DIE("W"),DIE("NO^")
 D:$D(DDS)
 . I $Y<IOSL D CLRMSG^DDS Q
 . D REFRESH^DDSUTL
A I '$D(DA) S Y(0)=0 Q
 Q:$D(Y)<9&'$D(DTOUT)&'$D(DIC("W"))
 S:'$G(DTOUT)&($D(Y)'<9) DUOUT=1
ZAP S DIK=DIE,A1="T",DST=$C(7)_"   <'"_$P(@(DIK_"DA,0)"),U,1)_"' DELETED>" W:'$D(DDS) !?3 D H D:$D(DDS) LIST^DDSU
 D ^DIK S Y(0)=0 K DST Q
 ;
D S DIE=DIC G ZAP
 ;
ASKP001 ; ask user to confirm new record's .001 field value
 ; NEW^DICN
 ;
 ; quit if there's no .001 or we can't ask
 ;
 I DIC(0)'["E" S Y=1 Q
 S Y=$P(DO,U,2)
 I '$D(^DD(+Y,.001,0)) S Y=1 Q
 ;
 ; if this is not a LAYGO lookup in which X looks like an IEN, and we're 
 ; adding a new file, and we haven't tried this before, then offer a new 
 ; .001 based on the user's or site's file range, whichever's handy. 
 ; NEW^DICN will increment this .001 forward to find the first gap, then 
 ; drop back through here to the paragraph below (because DO(3) will be 
 ; defined next time) to offer it to the user
 ;
 I '$D(DIENTRY),DIC="^DIC(",'$D(DO(3)) D  S Y="TRY NEXT" Q
 . S DO(3)=1
 . I $S($D(^VA(200,DUZ,1))#2:1,1:$D(^DIC(3,DUZ,1))#2),$P(^(1),U) D  Q
 . . S DIY=.1,X=+$P(^(1),U) ; NAKED
 . I $D(^DD("SITE",1)),X\1000'=^(1) S X=^(1)*1000,%=0
 ;
 ; set up our prompt, if .001 looks valid use it as a default, otherwise
 ; count forward until we find a valid one to offer
 ;
 S DST="   "_$P(DO,U)_" "_$P(^DD(+Y,.001,0),U)_": "
 S %=$P(^DD(+Y,.001,0),U,2),X=$S(%'["N"!(%["O"):0,1:X),%Y=X
 I X F %=1:1 D N Q:$D(X)  S X=0 Q:%>999  S X=%Y+DIY,%Y=X
 I X S DST=DST_X_"// "
 ;
 ; prompt user for .001
 ;
 I '$D(DDS) D
 . W !,DST K DST R Y:$S($D(DTIME):DTIME,1:300) E  S DTOUT=1,Y=U W $C(7)
 E  D
 . S A1="Q",DST=3_U_DST D H,LIST^DDSU S Y=$S($D(DTOUT):U,1:%) K %
 ;
 ; sort through possible responses
 ;
 I Y[U S Y=U Q
 I Y="" S Y=1 Q
 I Y'="?" D  Q:Y
 . S X=Y D N S Y=$D(X)#2 Q:Y
 . W $C(7)
 . W:'$D(DDS) "??"
 ;
 ; for bad response or help request, offer help and try new IEN
 ;
 S DST="" I $D(^DD(+DO(2),.001,3)) S DST="     "_^(3)
 I '$D(DDS) D
 . W:DST]"" !?5,DST X:$D(^(4)) ^(4) K DST ; NAKED
 E  D
 . S A1=0 D H S:$D(^(4)) DDH("ID")=^(4) D LIST^DDSU ; NAKED
 S X=$P(DO,U,3) D INCR^DICN
 S Y="TRY NEXT"
 Q
 ;
N ; test X as an IEN (apply input transform and numeric restrictions)
 ; USR^DICN, ASKP001
 ;
 I $D(^DD(+$P(DO,U,2),.001,0)),'$D(DINUM) X $P(^(0),U,5,99)
 I $D(X),$L(X)<15,+X=X,X>0,X>1!(DIC'="^DIC(") Q
 K X
 Q
 ;
