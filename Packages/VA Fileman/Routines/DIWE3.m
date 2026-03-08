DIWE3 ;SFISC/GFT-WP - MOVE, DELETE, REPEAT, TRANSFER ;11/2/96  06:21 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**33**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
M ;MOVE
 S DWAFT=1 G 1:X=U,OPT:'X S (DW1,DW3)=0 D MOVE Q:$D(DTOUT)  S:DW1>DW3 DW1=DW1+I,DW2=DW2+I D DEL:DW1
1 G ^DIWE1
 ;
OPT W ! G OPT^DIWE1
 ;
R ;REPEAT
 S DWAFT=1 G 1:X=U,OPT:'X D MOVE
 G 1
 ;
D ;DELETE
 S DW1=X G 1:X=U,OPT:'X W "  thru: "_DW1_"// " R DW2:DTIME S:'$T DTOUT=1
 G 1:DW2=U!'$T S:DW2="" DW2=DW1 I DW1>DW2 W $C(7),"??" G OPT
 I DW2>DWLC S DW2=DWLC W "  ("_DW2_")"
 S X=DW2-DW1+1,%=2 W !,"OK TO REMOVE "_X_" LINE"_$E("S",X>1)
 D YN^DICN I %-1 W "  <NOTHING DELETED>" G 1
 S %=2 I DW1=1,DW2=DWLC W !,$C(7),"ARE YOU SURE YOU WANT TO DELETE THIS ENTIRE TEXT" D YN^DICN G 1:%-1
 D DEL K DWL G 1
 ;
F R !,"From line: ",DWL:DTIME S:'$T DTOUT=1 G Q:DWL=U!'$T
 I DWL?."?" D H G F
 I +DWL'=DWL W $C(7)," ??    Please enter a number." G F
MOVE R "  thru: ",DW2:DTIME S:'$T DTOUT=1 G Q:DW2=U!'$T S DW1=DWL
 I $E(DW2)="E"!($E(DW2)="e") S DW2=9999999
 I 'DW2 S DW2=DW1 W " (",DW1,")"
 S %=2 G YN:'DWAFT R " after line: ",DW3:DTIME S:'$T DTOUT=1 G Q:DW3=U!'$T
 I DW1-1<DW3,DW2>DW3 G Q
 I DW1<1!(DW2>DWLC)!(DW1>DW2)!(DW3<0)!(DW3>DWLC)!(+DW3'=DW3) G Q
YN W !,"ARE YOU SURE" D YN^DICN
 G Q:%-1 K ^UTILITY($J,"W") S I=0
 I DWAFT?.N X "S J=DW1-.1 F  S J=$O("_DIC_"J)) Q:J>DW2!(J'>0)  I $D(^(J,0)) S X=^(0) D O" S:J="" J=-1 G DN
 I DW1>DW2 G Q
 N % S %=DW1-1 F  S %=$O(^TMP($J,"DIWE3",%)) Q:%'>0!(%>DW2)  I $D(^(%,0))#2 S X=^(0) D O
DN G Q:'I X "F J=DWLC:-1:DW3+1 S "_DIC_"J+I,0)="_DIC_"J,0)","F J=1:1:I S "_DIC_"DW3+J,0)=^UTILITY($J,""W"",J,0) W ""."""
 K ^UTILITY($J,"W"),DWL,X,DICMX,^TMP($J,"DIWE3") S DWLC=DWLC+I,@(DIC_"0)")=DWLC Q
DEL S I=+DW1
 X "F J=DW2+1:1:DWLC S "_DIC_"I,0)="_DIC_"J,0),I=I+1 W ""."""
 S I=DW2-DW1
 X "F J=DWLC-I:1:DWLC K "_DIC_"J) W ""."""
 S DWLC=DWLC-I-1 Q
H N DIR,X,Y,DIRUT,%
 S DIR(0)="E"
 F %=1:1 Q:'$D(^TMP($J,"DIWE3",%))  S X=$G(^(%,0)) W !,$J(%,3),">",X I %#15=0 D ^DIR Q:X=U!$D(DIRUT)
 Q
Q W "  <NO CHANGE>",$C(7) S DW1=0 K DWL,X,DICMX,DWAFT Q
O S I=I+1,^UTILITY($J,"W",I,0)=X Q
Z ;
 Q:X=""!(X[U)!(X>DWLC)  S DW3=X
 N VAL,FILE,FLD,WPROOT,IENS,ARR,RT,FI,FD,WPRT,IEN S FI=0,RT=DIC
 D RT(RT,"ARR") I $G(ARR)=U G Z0
 S FI=ARR("FILE"),FD=ARR("FLDNO"),WPRT=ARR("ROOT"),IEN=ARR("IENS")
Z0 N MSG S MSG="",FILE=FI,FLD=$G(FD),WPROOT=$G(WPRT),IENS=$G(IEN)
 R !,"From what text: ",VAL:DTIME I '$T!(U[VAL)!(VAL="") S DUOUT=1 Q
 I VAL?1."?" D  G Z0
 .N X,Y,D,DIC,DIR,DZ,DIX,DIY,DIZ,DO,DD
 .W !! I $G(FILE)=3.9 W ?5,"Enter the message number or SUBJECT of another mailman message, OR ",!
 .I FILE,FILE'=3.9 W ?5,"Select another entry in this file OR"
 .W !?5,"Use relational syntax to pick up information from a word-processing",!?5,"field in another file.",!
 .W ?5,"ex.  ""VALUE"":FILE NAME:WORD PROCESSING FIELD NAME",!
 .I FILE D
 ..W !,"Do you want the entire "_$O(^DD(FILE,0,"NM",0))_" list?"
 ..S DZ="??" S DIR(0)="Y" D ^DIR Q:'Y
 ..S DIC=WPROOT,DIC(0)="QEM",D="B" D DQ^DICQ
 ..Q
 .Q
 I VAL'[":",'FILE S MSG="SELECT FILE TO TRANSFER FROM" D Q0 G Z0
 I VAL[":" D PRSREL I MSG]"" D Q0 G Z0
 D DIC I MSG]"" D Q0 G Z0
 I FILE=3.9 S Y=+IENS D XM(.Y) Q:'Y  S IENS=+Y_","
 D GET1 I MSG]"" D Q0 G Z0
 S DWAFT=U D F
 Q
RT(ROOT,DIARR) ;
 N A,B,C,D,Z,SUB,RT,FILE,TOPFILE,%,IENS
 Q:$G(ROOT)']""  S:'$D(DIARR) DIARR="^TMP($J,ROOT)" K @DIARR
 S A=",",IENS="",(B,D)=$L(ROOT,A)-1
 F  S RT=$P(ROOT,A,1,B-1),B=B-1 Q:RT=""  D  Q:$G(FILE)
 . S RT=RT_A I +$P($G(@(RT_"0)")),U,2) S C=+$P(^(0),U,2) I $D(^DD(C,0)),RT[^DIC($$FNO^DILIBF(C),0,"GL") S FILE=C D RT1
 I RT="" S @DIARR=U Q
 Q
RT1 S @DIARR@("FILE")=FILE
 S (@DIARR@("TOPFILE"),TOPFILE)=$$FNO^DILIBF(FILE)
 S @DIARR@("ROOT")=RT
 N Y,X F  S SUB=$P(ROOT,A,D) D  Q:Y!(SUB="")
 .S Y=0 Q:SUB=""
 .I 'SUB S SUB=$S($E(SUB)=$C(34):$E(SUB,2,$L(SUB)-1),$G(@SUB):@SUB,1:"") Q:SUB=""
 .S X=$O(^DD(FILE,"GL",SUB,0,""))  I $G(X),$P($P(^DD(FILE,X,0),U,4),";")=SUB S @DIARR@("FLDNO")=X,Y=1 Q
 .S @DIARR@("FLDNO")=$O(^DD(^DD(FILE,0,"UP"),"GL",SUB,0,"")),Y=1
 S RT=$S(FILE=TOPFILE:ROOT,1:RT),RT=$P(RT,"(",2),Z=$L(RT,A)-1
 F %=1:2:Z S IENS=IENS_$P(RT,A,Z-%) I $P(RT,A,Z-%)]"" S IENS=IENS_A
 S @DIARR@("IENS")=$S(FILE=TOPFILE:"",1:IENS)
 Q
PRSREL N X,FTYPE,T,M,W,I,FI,FD,WPRT S X=VAL
 S T=$F(X," IN ") I T S X=$E(X,1,T-5),W=":",M=T-4,I=X_W_$E(VAL,T,999),T=$F(I," FILE",M) S:T&$F(W,$E(I,T)) I=$E(I,1,T-6)_$E(I,T,999) S X=I
 S VAL=$P(X,":"),FI=$P(X,":",2),FD=$P(X,":",3)
 I 'VAL,VAL'?1"`".N,VAL'?1"""".E1"""" S MSG="INVALID SYNTAX" Q
 I $E(VAL)=$C(34) D
 . I VAL?3"""".E3"""" S @("VAL="_VAL) Q
 . S VAL=$E(VAL,2,$L(VAL)-1)
 S FI=$S(FI="":0,FI&($G(^DIC(FI,0))]""):FI,FI'?.N:$O(^DIC("B",FI,"")),1:0)
 I 'FI S MSG="INVALID FILE" Q
 D DIAC I 'FI S MSG="NO READ ACCESS TO FILE" Q
 S FD=$S(FD:FD,FD'?.N:$O(^DD(FI,"B",FD,"")),1:0)
 I 'FD!('$D(^DD(FI,+FD,0))) S MSG="INVALID FIELD" Q
 I FD S FTYPE=$P($G(^DD(+$P($G(^DD(FI,FD,0)),U,2),.01,0)),U,2) I FTYPE'["W" S MSG="NOT A WORD PROCESSING FLD" Q
 I FTYPE["L" D
 .N DIR,X,Y
 .W $C(7),!!,"WARNING!",!,"The field you are transferring text from displays text without wrapping."
 .W !,"The field you are transferring text into may display text differently."
 .W !!,"Do you want to continue?",! N X,Y,DIR S DIR(0)="Y" D ^DIR
 .W ! S:'Y MSG="TEXT TRANSFER CANCELLED" Q
 S:MSG="" FILE=FI,FLD=FD,WPROOT=$G(^DIC(FI,0,"GL")) Q
DIC N X,DIC,Y
 S DIC=WPROOT,X=VAL,DIC(0)="QEM" D ^DIC
 I Y<0 S MSG="NO RECORD FOUND" Q
 I IENS]"" S IENS=+Y_","_IENS
 E  S IENS=+Y_","
 Q
GET1 N X K ^TMP($J,"DIWE3")
 S X=$$GET1^DIQ(FILE,IENS,FLD,"Z","^TMP($J,""DIWE3"")")
 I $D(^TMP($J,"DIWE3")) Q
 S MSG="NO TEXT TO TRANSFER FROM"
 Q
NW N DIR,X,Y
 W $C(7),!!,"WARNING!",!,"The field you are transferring text from displays text without wrapping."
 W !,"The field you are transferring text into may display text differently."
 W !!,"Do you want to continue?",! N X,Y,DIR S DIR(0)="Y" D ^DIR
 W ! S:'Y MSG="TEXT TRANSFER CANCELLED" Q
Q0 W "  <"_MSG_">",$C(7) Q
DIAC I FILE=3.9 Q
 N DIAC,DIFILE
 S DIAC="RD",DIFILE=FILE
 D ^DIAC S:'DIAC FILE=0
 Q
XM(Z) N %,A9,XMZ,ARR,MSG,A1
 S A1=Z
% W !,"Transfer from Response: Original Message// " R A9:DTIME I A9[U S MSG="TEXT TRANSFER CANCELLED",Z=0 D Q0 Q
 I A9?1."?" S XMZ=+Z D ENT8^XMAH S Z=A1 G %
 I A9=""!(A9=0)!(A9="O") Q
 I A9 D  Q:Z
 . N A0 S %=$$HDR^XMGAPI2(+Y,.ARR,9) S A0=$G(ARR("RSP",A9))
 . I A0 S Z=A0 Q
 . S MSG="INVALID RESPONSE",Z=0 D Q0
 S Z=A1 G %
