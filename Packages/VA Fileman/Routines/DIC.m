DIC ;SFISC/XAK,TKW,SEA/TOAD-VA FileMan: Lookup, Part 1 ;3/17/97  11:43 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**8,29,40**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 N D
 S D="B" K DF,DS,DIROUT,DTOUT,DUOUT
EN K DO,DICR N DIASKOK S U="^" S:DIC DIC=^DIC(DIC,0,"GL")
 I $G(DICWSET)="" N DICWSET S DICWSET=$S($D(DIC("W"))#2:1,1:0)
 S DIC(0)=$G(DIC(0)) I $D(ZTQUEUED) S DIC(0)=$TR(DIC(0),"AEQ")
 D PGM^DIC2 I $D(DIPGM) S DIPGM(0)=1 G @DIPGM
 I '$D(@(DIC_"0)")),'$D(DIC("P")),$E(DIC,1,6)'="^DOPT(" S Y=-1 G Q^DIC2
ASK I DIC(0)["A" W ! D ^DIC1
 I $D(DIADD),X'["""",U'[X,X'?."?" S X=""""_X_""""
X ;
 I $G(DICWSET)="" N DICWSET S DICWSET=$S($D(DIC("W"))#2:1,1:0)
 D DO^DIC1:'$D(DO) I U'[X,X'?."?",$D(^DD(+DO(2),.01,7.5)) X ^(7.5) G:'$D(X) BAD^DIC1
 D PGM^DIC2 I $D(DIPGM) S DIPGM(0)=2 G @DIPGM
RTN D:'$D(DO) DO^DIC1
 G O^DIC1:X'?.ANP,N:$L(X)>30
 I X?.NP G NO:X="",N:U[X,NUM:+X=X&(X>0),^DICQ:X?1."?" I X=" ",$L(DIC)<29,$D(^DISV(DUZ,DIC))#2 S Y=+^(DIC) D S G GOT^DIC2:$T,BAD^DIC1
F ;
 S (DD,DS)=0
T S Y=$O(@(DIC_"D,X,0)")),DIX=X S:Y="" Y=-1 I Y'<0 G DIY:$O(^(Y))]""!((DIC(0)'["O")&(DIC(0)["E")) D MN I  G K:DS S DS=1 G GOT^DIC2
DIX I DIC(0)'["X" S:$TR(X,"-.")?.N&(DO(2)'["D")&'$D(DIDA) DIX=$O(@(DIC_"D,DIX_"" "")"),-1) S DIX=$O(@(DIC_"D,DIX)")) I $P(DIX,X)="",DIX'="" S Y=$O(^(DIX,0)) S:Y="" Y=-1 G DIY
M I DIC(0)["M" S D=$S($D(DID):$P(DID,U,DID(1)),1:$O(@(DIC_"D)"))) S:$D(DID) DID(1)=DID(1)+1
 I DIC(0)["M",D]"" G M:$D(@(DIC_"D)"))-10,T:X'?.NP,T:+X'=X D DO^DIC1:'$D(DO) S Y=$O(^DD(+DO(2),0,"IX",D,0)) S:Y="" Y=-1 G T:$O(^(Y,0))="",T:'$D(^DD(Y,$O(^(0)),0)),M:$P(^(0),U,2)["P",T
 D D G G:DS=1,Y^DIC1:DS
N I X[U S DUOUT=1 G NO
 D DO^DIC1:'$D(DO) I X?1"`".NP S Y=$E(X,2,30),DZ=0 G A:Y="" D S S DS=1,DD=Y G GOT^DIC2:$T I DIC(0)'["L" W:DIC(0)["Q" $C(7),$S('$D(DDS):"  ??",1:"") G A
 G ^DICQ:X?."?",^DICM
NUM D DO^DIC1:'$D(DO) G F:DO(2)<0!$D(DF) S DD=$D(^DD(+DO(2),.001)),DS=$P(^(.01,0),"^",2) I $D(@(DIC_"X)")) G:'DD P:DS["N"!('$O(^("A["))&($O(^("A["))]"")) S Y=X D S G GOT^DIC2:$T
P I DS["P"!(DS["V"),DIC(0)'["U" S (DD,DS)=0 G M
 G F
1 ;
 D S G GOT^DIC2:$T,F
MN S DZ=$S(DIC(0)["D":1,$D(@(DIC_"D,DIX,Y)"))-1:0,1:^(Y)),DIYX=0 D:'$D(DO) DO^DIC1
 I D="B",'DZ,$D(@(DIC_"D,DIX,Y)"))-1 D
 . N I S I=Y F  S DZ=$G(^(I)),I=$O(^(I,0)) Q:I=""
 . Q
 S DIY="" I '$D(@(DIC_"Y,0)")) X "I 0" Q
 I 'DZ,'$D(DO("SCR")),$L(DIX)<30,D="B",'$D(DIC("S")),'$D(@(DIC_"Y,-9)")) Q
 D S S:D="B"&'DZ&($P(DIY,DIX)="") DIY=$P(DIY,DIX,2,9),DIYX=1
 Q
S D:'$D(DO) DO^DIC1 I $D(@(DIC_"Y,0)")) S DIY=$P(^(0),U)
 E  S DIY="" Q
 I '$D(^(-9)) X:$D(DIC("S")) DIC("S") K DIAC,DIFILE Q:'$T!'$D(DO("SCR"))  I $D(@(DIC_"Y,0)")) X DO("SCR")
 Q
Y S Y=$O(@(DIC_"D,DIX,Y)")) S:Y="" Y=-1
DIY I Y<0 G DIX:DIC(0)'["O"&(DIC(0)["E"),G:DS=1&(D="B")&(DIX=X),DIX
 D MN E  G Y
K S DZ=$O(DS(0)) F DZ=DZ:1:DS I $D(DS(DZ)),+DS(DZ)=Y,DIC(0)'["C" G Y
 I DS-($O(DS(0)))>100 D
 . N D1,D2 S D1=$O(DS(0)),D2=D1+19
 . F D1=D1:1:D2 K DS(D1),DIY(D1),DIYX(D1)
 . Q
 S DS=DS+1,DS(DS)=Y_"^"_$P(DIX,X,2,99),DIY(DS)=DIY S:DIY]""&$G(DIYX) DIYX(DS)=1 G Y:DS#5-1,Y:DS=1,Y:DIC(0)["Y",Y^DIC1
G I $D(DIDA),$P(DS(1),U,2,99)]"" S DIASKOK=1
 S DIY=1,DIX=X I DIC(0)["E",DIC(0)'["D",'$D(DICRS) D
 . N D S D=$P(DS(1),U,2,99)
 . I $G(DIDA),D]"" S D="  partial match to:  "_$$FMTE^DILIBF(X_D,"1U") W:'$D(DDS) !
 . I '$D(DDS) W D Q
 . S DST=$S($D(DST)#2:DST_"  ",1:"")_X_D_$S($G(DIYX(1)):$G(DIY(1)),1:"")
 . Q
C S Y=+DS(DIY),X=X_$P(DS(DIY),"^",2),DIYX=$G(DIYX(DIY)),DIY=DIY(DIY)
 G GOT^DIC2
 ;
D S D=$S($D(DF):DF,1:"B") S:$D(DID(1)) DID(1)=2 Q
IX K DTOUT,DUOUT S DF=D G EN
A K DIY,DIYX,DS I DIC(0)["A" D D G ASK
NO S Y=-1 G Q^DIC2
 ;
 ;DBS entry points
 ;
LIST(DIFILE,DIFIEN,DIFIELDS,DIFLAGS,DINUMBER,DIFROM,DIPART,DINDEX,DICALSCR,DIWRITE,DILIST,DIMSGA) ;SEA/TOAD
 ;ENTRY POINT--return a list of entries from a file
 ;subroutine, DIFROM passed by value
 G IN^DICL
 ;
FIND1(DIFILE,DIEN,DIFLAGS,DIVALUE,DINDEX,DISCREEN,DIMSGA) ;SEA/TOAD
 ;ENTRY POINT--find a single entry in the file
 ;function, all passed by value
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 N DICLERR S DICLERR=$G(DIERR) K DIERR
 N DIERN,DIFIND,DIPE,DITARGET
 D FIND^DICF($G(DIFILE),$G(DIEN),"",$G(DIFLAGS)_"f",$G(DIVALUE),1,$G(DINDEX),$G(DISCREEN),"","DITARGET")
 I $D(DIERR) S DIFIND=""
 E  I $P($G(DITARGET(0)),U,3) K DITARGET S DIFIND="" D
 .S DIERN=299
 .S DIPE(1)=$G(DIVALUE)
F1 .S DIPE("FILE")=$G(DIFILE)
 .S DIPE("IEN")=$G(DIEN)
 .D BLD^DIALOG(DIERN,.DIPE,.DIPE)
 .Q
 E  S DIFIND=+$G(DITARGET(1))
 I DICLERR'=""!$G(DIERR) D
 . S DIERR=$G(DIERR)+DICLERR_U_($P($G(DIERR),U,2)+$P(DICLERR,U,2))
 I $G(DIMSGA)'="" D CALLOUT^DIEFU(DIMSGA)
 Q DIFIND
 ;
FIND(DIFILE,DIEN,DIFLDS,DIFLAGS,DIVALUE,DIMAX,DIFORCE,DISCREEN,DID,DILIST,DIMSGA) ;SEA/TOAD
 ;ENTRY POINT--in a file find entries that match a value
 ;procedure, all passed by value
 G FINDX^DICF
 ;
