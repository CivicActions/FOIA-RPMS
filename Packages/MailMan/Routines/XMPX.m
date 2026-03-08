XMPX ;(WASH ISC)/THM-PACKAGE COMMUNICATIONS FUNCTIONS ; 12/4/87  2:02 PM ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 I '$D(IOF) S IOP="HOME" D ^%ZIS
NOKL S DIK="^DOPT(""XMPX""," G F:$D(^DOPT("XMPX",1))
G S ^DOPT("XMPX",0)="Package Transport Function^1N^" F I=1:1 S X=$E($T(F+I),4,99) Q:X=""  S ^DOPT("XMPX",I,0)=X
 D IXALL^DIK
F S DIC="^DOPT(""XMPX"",",DIC(0)="AEQZ" D ^DIC K DIC Q:Y<0  S X=$P(Y(0),U,2,99) K Y D @X W ! G F
 ;;WRITE MESSAGE TO DEVICE (KERNAL FORMAT)^WR^XMPX
 ;;READ MESSAGE FROM DEVICE (KERNAL FORMAT)^RD^XMPX
 ;;ISM INPUT (%GO OR %RO)^IM^XMPX
 ;
WR ;
 S DIC(0)="AEQMZ" D F^XMP Q:Y<0  D ^%ZIS Q:POP
 R !,"OK TO WRITE MESSAGE? ",X:DTIME Q:X'["Y"
 S XCN=0 U IO D W1 W !! U IO(0) W !,I," LINES WRITTEN FROM MESSAGE" Q
W1 F I=1:1 D NT Q:+XCN'=XCN  W X,! I '(I#100) U IO(0) W "." U IO
 Q
RD D NM,R1 Q
NM R !,"ENTER NAME OF NEW MESSAGE ",X:DTIME Q:X=""!(X["^")  S X=$C(34)_X_$C(34),DIC(0)="L" D F^XMP Q:Y<0
 Q
R1 U IO R X:DTIME Q:X=""  D NP G R1
 U IO(0) W !,XCNP," LINES READ INTO MESSAGE" Q
 Q
GO ;
 S G="",X=X1 D G2 S X="$END GLB "_G D NP U IO(0) Q
G1 U IO R X:DTIME Q:X=""
G2 D B:$P(X,"(",1)'=G,NP R X:DTIME S X="="_X D NP G G1
B S Y=X I $L(G) S X="$END GLB "_G D NP
 S X="$GLB "_Y,G=Y D NP S X=Y U IO(0) W !,"Loading ",G U IO Q
 Q
RO ;
 S ROU=X1 D ROU1 U IO(0) Q
ROU U IO R ROU:DTIME Q:ROU=""
ROU1 S X="$ROU "_ROU U IO(0) D NP W !,"Loading ",ROU U IO
 F XCNP=XCNP:1 R X:DTIME Q:X=""  D NP
 S X="$END ROU "_ROU D NP G ROU
 Q
NT S XCN=$O(@(DIE_XCN_")")) Q:+XCN'=XCN  S X=^(XCN,0) Q
NP S @(DIF_XCNP_",0)")=X,XCNP=XCNP+1 I '(XCNP#100) U IO(0) W "." U IO Q
 Q
IM D ^%ZIS Q:POP  U IO R DES:DTIME,DAT:DTIME,X1:DTIME U IO(0) W !,$P("Globals,Routines",",",X1'["^"+1)," were saved on ",DAT,!,"With description: ",DES
 R !,"Load message? (Y/N): Y// ",X:DTIME Q:'$T  S X=X["N"
 Q:X  D NM S X="$TXT Imported ISM format generated "_DAT D NP S X="$TXT With Description: "_DES D NP
 G GO:X["^",RO
