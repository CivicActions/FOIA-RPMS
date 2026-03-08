XUCT01 ; GENERATED FROM 'XUSERINQ' PRINT TEMPLATE (#885) ; 04/01/03 ; (FILE 200, MARGIN=80)
 G BEGIN
N W !
T W:$X ! I '$D(DIOT(2)),DN,$D(IOSL),$S('$D(DIWF):1,$P(DIWF,"B",2):$P(DIWF,"B",2),1:1)+$Y'<IOSL,$D(^UTILITY($J,1))#2,^(1)?1U1P1E.E X ^(1)
 S DISTP=DISTP+1,DILCT=DILCT+1 D:'(DISTP#100) CSTP^DIO2
 Q
DT I $G(DUZ("LANG"))>1,Y W $$OUT^DIALOGU(Y,"DD") Q
 I Y W $P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC",U,$E(Y,4,5))_" " W:Y#100 $J(Y#100\1,2)_"," W Y\10000+1700 W:Y#1 "  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12) Q
 W Y Q
M D @DIXX
 Q
BEGIN ;
 S:'$D(DN) DN=1 S DISTP=$G(DISTP),DILCT=$G(DILCT)
 I $D(DXS)<9 M DXS=^DIPT(885,"DXS")
 S I(0)="^VA(200,",J(0)=200
 D N:$X>0 Q:'DN  W ?0 X DXS(1,9.2) S %=$L(X),%1=$X,$P(%2,"-",%)="-" W X,!,?%1,%2 K %1,%2 S X="" K DIP K:DN Y W X
 X DXS(2,9.2) S X1=DIP(3) S:X]""&(X?.ANP)&(X1'[U)&(X1'["$C(94)") DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 W ?11 W:$L($P(^VA(200,D0,0),U,11)) !,*7,?3,"Terminated: ",DIPA("TD") K DIP K:DN Y
 X DXS(3,9.2) S X1=DIP(3) S:X]""&(X?.ANP)&(X1'[U)&(X1'["$C(94)") DIPA($E(X,1,30))=X1 S X="" K DIP K:DN Y W X
 W ?22 W:DIPA("DIS")["Y" !,?3,"Disuser: ",DIPA("DIS") K DIP K:DN Y
 W ?33 D INQ^XUS9 S X="" K DIP K:DN Y
 D T Q:'DN  D N D N:$X>0 Q:'DN  W ?0 S X="ATTRIBUTES",%=$L(X),%1=$X,$P(%2,"-",%)="-" W X,!,?%1,%2 K %1,%2 S X="" K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "Creator"
 W ?11 X DXS(4,9.2) S X1=DIP(2) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>42 Q:'DN  W ?42 S X="Date entered" K DIP K:DN Y W X
 W ?53 X DXS(5,9.2) S X1=DIP(3) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "Mult Sign-on"
 W ?16 X DXS(6,9.2) S X1=DIP(3) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>42 Q:'DN  W ?42 W "Fileman codes"
 W ?57 X DXS(7,9.2) S X1=DIP(2) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "Time-out"
 W ?12 X DXS(8,9.2) S X1=DIP(2) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>42 Q:'DN  W ?42 W "Type-ahead"
 W ?54 X DXS(9,9.2) S X1=DIP(3) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "Title"
 W ?9 X DXS(10,9.2) S X1=DIP(2) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>42 Q:'DN  W ?42 W "Office Phone"
 W ?56 X DXS(11,9.2) S X1=DIP(2) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "Auto-Menu"
 W ?13 X DXS(12,9.2) S X1=DIP(3) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>42 Q:'DN  W ?42 W "Voice Pager"
 W ?55 X DXS(13,9.2) S X1=DIP(2) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "Last Sign-on"
 W ?16 X DXS(14,9.2) S X1=DIP(3) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>42 Q:'DN  W ?42 W "Digital Pager"
 W ?57 X DXS(15,9.2) S X1=DIP(2) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>2 Q:'DN  W ?2 W "Has a E-SIG"
 S DIPA("ESIG")=$S($L($P($G(^VA(200,D0,20)),U,4)):"Yes",1:"No") K DIP K:DN Y
 W ?15 X DXS(16,9.2) S X1=DIP(1) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>42 Q:'DN  W ?42 W "Write Med's"
 W ?55 X DXS(17,9.2) S X1=DIP(3) S %=$X,%1=$S(X>%:X-%,1:0),%="",$P(%,".",%1)="." W %,X1 K %,%1 S (X,X1)="" K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 W " "
 D N:$X>2 Q:'DN  W ?2 W "Person Class: "
 W ?18 D SHPC^XUSER1(D0) K DIP K:DN Y
 D N:$X>0 Q:'DN  W ?0 W " "
 D N:$X>0 Q:'DN  W ?0 S DIP(1)=$S($D(^VA(200,D0,201)):^(201),1:"") S X="Primary Menu: "_$S('$D(^DIC(19,+$P(DIP(1),U,1),0)):"",1:$P(^(0),U,1)) K DIP K:DN Y W X
 D N:$X>39 Q:'DN  W ?39 X DXS(18,9.2) S X=$P(DIP(101),U,2) S D0=I(0,0) K DIP K:DN Y W X
 D N:$X>0 Q:'DN  W ?0 S X="Secondary Menu(s)",%=$L(X),%1=$X,$P(%2,"-",%)="-" W X,!,?%1,%2 K %1,%2 S X="" K DIP K:DN Y W X
 S I(1)=203,J(1)=200.03 F D1=0:0 Q:$O(^VA(200,D0,203,D1))'>0  X:$D(DSC(200.03)) DSC(200.03) S D1=$O(^(D1)) Q:D1'>0  D:$X>11 T Q:'DN  D A1
 G A1R^XUCT011
A1 ;
 G ^XUCT011
