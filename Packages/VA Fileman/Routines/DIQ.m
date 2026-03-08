DIQ ;SFISC/GFT-CAPTIONED TEMPLATE ;1/25/95  13:54 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**5**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 G INQ^DII
 ;
GET1(DIQGR,DA,DR,DIQGPARM,DIQGETA,DIQGERRA,DIQGIPAR) ;Extrinsic Function
 ; file,record,field,parm,targetarray,errortargetarray,internal
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 G DDENTRY^DIQG
 ;
GETS(DIQGR,DA,DR,DIQGPARM,DIQGTA,DIQGERRA,DIQGIPAR) ;Procedure Call
 ; file,record,field,parm,targetarray,errortargetarray,internal
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D INIZE^DIEFU
 N DIQGQERR
 D DDENTRY^DIQGQ
 I $G(DIQGQERR)]"" S DIERR=DIQGQERR
 D:$G(DIQGERRA)]"" CALLOUT^DIEFU(DIQGERRA)
 Q
 ;
 ;
GUY S:'$D(DTIME) DTIME=300 K DTOUT,DUOUT,DIRUT,DIR
 S D0=DA,D=DIC_DA_",",DL=1 S:$S('$D(S)#2:1,1:'S) S=3 I '$D(DIQS) W !
 E  S Z=0,A=0 F  S @("Z=$O("_DIQS_"Z))") Q:Z=""  S @(DIQS_"Z)=""""")
 E  S Z=-1
 I $D(DX(0))[0 S DX(0)="Q" I $D(IOST)#2,IOST?1"C".E S DX(0)="S S=S+1 I S>22 N X,Y S DIR(0)=""E"" D ^DIR K DIR W ! S S=$S($D(DIRUT):0,1:1)"
1 I $D(DIQS) S Z=0,A=0 F  S @("Z=$O("_DIQS_"Z))") S:Z="" Z=-1 S A=$O(^DD(DD,"B",Z,0)) S:A="" A=-1 Q:Z<0  I $D(^DD(DD,A,0)) S C=$P(^(0),U,2) I C["C" D COM S @(DIQS_"Z)=X")
 I N<0,$D(^DD(DD,.001,0)) S W=.001,A=-1,Y=@("D"_(DL\2)) G W
 I $G(DIQ(0))["R",N<0,(DL\2)=0 S W=.001,A=-1,O="NUMBER",Y=D0 G W2
N S @("N=$O("_D_"N))") S:N="" N=-1 I DL=1,@E D LF D:$D(DIQ(0)) ^DIQ1:DIQ(0)["C" G Q
 I $D(^(N))#2 S Z=^(N),A=-1 G NS
 I N<0 S DL=DL-1 G B
 I DL#2 S Z=$O(^DD(DD,"GL",N,0,0)) S:Z="" Z=-1 G N:Z<0 S O=0,X=+$P(^DD(DD,Z,0),"^",2) X:$D(DICS) DICS E  G N
 E  G N:N'>0 S X=DD,O=-1,@("D"_(DL\2)_"=N") D LF Q:'S  I $D(DSC(X)) X DSC(X) E  G N
 S DD(DL)=DD,D(DL)=D,N(DL)=N,DL=DL+1 S:+N'=N N=""""_N_"""" S D=D_N_",",N=O,DD=X G 1:DL#2,N
 ;
B I $D(DIQ(0)),DIQ(0)["C",'(DL#2) D ^DIQ1
 S N=N(DL),D=D(DL),DD=DD(DL) D LF Q:'S  G N
 ;
DIQS S @(DIQS_"O)=Y")
NS S A=$O(^DD(DD,"GL",N,A)) S:A="" A=-1 G N:A<0
 S W=$O(^(A,0)) S:W="" W=-1 I A S Y=$P(Z,"^",A) G W:Y]"",NS
 S Y=$E(Z,+$E(A,2,9),$P(A,",",2)) G NS:Y?." "
W S O=$P(^DD(DD,W,0),"^"),C=$P(^(0),"^",2) I $D(DICS) X DICS E  G NS
 I C["W",'$D(DIQS) D DIQ^DIWW G:$D(DN) Q:'DN S DL=DL-2 G B
 D Y I $D(DIQS) G @("DIQS:$D("_DIQS_"O))"),NS:'$D(^(W)) S O=W G DIQS
W2 I $X'<40!($L(O)+$L(Y)>38) S O=$E(O,1,253-$L(Y))
 S O=O_": "_Y I  D LF Q:'S
 W:$X ?40 W:W'?1"."1.2"0"1"1" ?2 W O G NS
 ;
Y I C["O",$D(^(2)) X ^(2) Q  ;NAKED REFERENCE IS TO ^DD(FILE#,FIELD#,0)
S I C["S" S C=";"_$P(^(0),U,3),%=$F(C,";"_Y_":") S:% Y=$P($E(C,%,999),";",1) Q
 I C["P",$D(@("^"_$P(^(0),U,3)_"0)")) S C=$P(^(0),U,2) Q:'$D(^(+Y,0))  S Y=$P(^(0),U) I $D(^DD(+C,.01,0)) S C=$P(^(0),U,2) G S
 I C["V",+Y,$D(@("^"_$P(Y,";",2)_"0)")) S C=$P(^(0),U,2) Q:'$D(^(+Y,0))  S Y=$P(^(0),U) I $D(^DD(+C,.01,0)) S C=$P(^(0),U,2) G S
 Q:C'["D"  Q:'Y
D ;S %=$E(Y,4,5)*3,Y=$S(%:$E("JANFEBMARAPRMAYJUNJULAUGSEPOCTNOVDEC",%-2,%)_" ",1:"")_$S($E(Y,6,7):$J(+$E(Y,6,7),2)_", ",1:"")_($E(Y,1,3)+1700)_$S(Y[".":"@"_$E(Y_0,9,10)_":"_$E(Y_"000",11,12)_$S($E(Y,13,14):":"_$E(Y_0,13,14),1:""),1:"") Q
 S Y=$$FMTE^DILIBF(Y,"1U") Q
 ;
DT D D:Y W Y Q
H G H^DIO2
 ;
LF I '$D(DIQS),$X W ! X DX(0)
 Q
EN1 S DRX=DR
EN2 S DR=$P(DRX,";",1),DRX=$P(DRX,";",2,999) D EN W ! G EN2:DRX]""&S
 K DRX Q
EN ;
 S S=0 S:$D(DICSS) DICS=DICSS
 I '$D(IOST)!'$D(IOSL)!'$D(IOM) S IOP="HOME" D ^%ZIS Q:POP
 G Q:'$D(@(DIC_"0)")) S U="^",DD=+$P(^(0),U,2),DK=DD
 I '$D(DR) S N=-1,O=""
 E  S N=$P(DR,":"),N=$S(0[N:-1,+N=N:N-.000001,1:$E(N,1,$L(N)-1)_$C($A(N,$L(N))-1)),O=$P(DR,":",DR[":"+1) G EN1:DR[";"
 S E="N<0" I O]"" S E=E_"!(N]"""_$S(+O=O:"?"")!(N>"_O_")",1:O_""")")
 D GUY S DA=D0 I $D(DIQ(0)),DIQ(0)["A" D AUD^DII
Q K C,O,W,N,E,Z,D,DD,IOP Q
 ;
COM X $P(^(0),U,5,99) S C=$P($P(C,"J",2),",",2) I C?1N.E,X S X=$J(X,0,C)
