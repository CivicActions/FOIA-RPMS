DIC2 ;SF/XAK-LOOKUP (CONT) ;8/15/96  15:15 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
WO S DST=$G(DST)_"  " D WR I $D(DIC("W")),$D(@(DIC_"Y,0)")) D:$D(DDS)&'$D(DDH("ID")) ID^DICQ1 I '$D(DDS) D
 . W $G(DST),"  " N DISAVEX S DISAVEX=X N X S X=DISAVEX
 . X DIC("W") K DST Q
 Q
WR D:'$D(DO) DO^DIC1 I DIC(0)["S",X'=" " Q:"  "[$G(DST)  G S
 S DST=$G(DST)
 I DO(2)["V" S %X=Y,DIYS=DIY D NAME^DICM2 S Y=%X,DIY=DIYS,DST=DST_DINAME K DINAME,%X G S
 I DIY'?1.N.1".".N G W1
 I DO(2)["D" S %=DIY D DT^DIC1 G S
 I DO(2)["P",$D(@("^"_$P(^DD(+DO(2),.01,0),"^",3)_+DIY_",0)")) S %X=Y,Y=DIY,C=$P(^DD(+DO(2),.01,0),U,2) D Y^DIQ S DST=DST_Y,Y=%X G S
W1 S:'$G(DIYX) DST=DST_DIY
S S A1=Y I '$D(DDS) W DST K DST,A1 Q
H S:'$D(A1) A1="T" S DDH=$G(DDH)+1,DDH(DDH,A1)=DST K DST,A1 Q
 ;
PGM K DIPGM I DIC(0)'["I",'$D(DF),$D(@(DIC_"0)")),$D(^DD(+$P(^(0),U,2),0,"DIC"))#2,^("DIC")'?1"DI".E S DIPGM=U_^("DIC")
 Q
 ;
GOT I DIC(0)["E" D WO I $D(DDS),$D(DDH)>10 D LIST^DDSU K DDH("ID")
 S Y=Y_"^"_$S(DIY="":X,$G(DIYX):X_DIY,1:DIY)
 I DIC(0)["E" I DO(2)["O"!($G(DIASKOK)) K DIASKOK G OK^DIC1
R D:'$D(DICR) ACT^DICM1 G A^DIC:Y<0
 I DIC(0)["Z" K D S:$D(C)#2 D=C S Y(0)=@(DIC_"+Y,0)"),C=$P(^DD(+DO(2),.01,0),U,2),DS=Y,Y=$P(Y(0),U) D Y^DIQ S Y(0,0)=Y,Y=DS,Y(0)=@(DIC_"+Y,0)") S:$D(D) C=D
ACT I DIC(0)'["F",$D(DUZ)#2 S ^DISV(DUZ,$E(DIC,1,28))=$E(DIC,29,999)_+Y
 I $D(@(DIC_"+Y,0)"))
Q K DIDA,DID,DISMN,DINUM,DS,DF,DD,DIX,DIY,DIYX,DZ,DO,D,DIAC,DIFILE,DIASKOK
 K:'$G(DICR) DIC("W")
 Q
