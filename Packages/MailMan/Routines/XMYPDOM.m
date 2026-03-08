XMYPDOM ;(WASH ISC)/CAP-XM POST INIT ;4/12/93  17:40 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 D WARN^XMYPDOM1 S DIR(0)="Y",DIR("B")="NO",DIR("A")="Do you wish to init your MINIENGINE & AUSTIN Scripts for the IDCU"
 D ^DIR K DIR,DIRUT Q:$S(X["^":1,"Nn"[$E(X):1,"Yy"'[$E(X):1,1:0)
 R !!,"Enter the IDCU UserID sent to you by mail: ",XMU:299 G OUT:XMU["^"!'$T R !!,"Enter the IDCU Password sent to you by mail: ",XMP:299 G OUT:XMP["^"!'$T I XMP=""!(XMU="") D IDCU^XMYPDOM1 G OUT
 S X="MINIENGINE" D IDCU S X="AUSTIN" D IDCU Q
 ;
 ;Set up IDCU Transmission Script TEXT
IDCU S Y=$O(^XMB(4.6,"B",X,0)) I 'Y S DIC="^XMB(4.6,",DIC(0)="E" D FILE^DICN
 W !!,"initializing your "_X_" script." S:'$D(XMP) XMP="" S:'$D(XMU) XMU=""
 I '$L(XMP)!'$L(XMU) W *7,!!,"NO UserID or Password entered.  Edit "_X_" script in the 4.6 file later",!,"or your network mail will not function !",!
 S XME=$O(^XMB(4.6,"B",X,0)) K ^XMB(4.6,XME,1) S ^(1,0)="^^9^9^"_$E(DT,1,7)
 F X=1:1 S Y=$P("W 6^S^L USER ID?^S"_$S($L(XMU):" "_XMU,1:"UserID")_"^L PASSWORD?^S"_$S($L(XMP):" "_XMP,1:"Password")_"^L DESTINATION^X W XMHOST,*13^S^L |CONNECTED| |DISCON|",U,X) Q:Y=""  S ^XMB(4.6,XME,1,X,0)=Y
 K ^XMB(4.6,XME,2) S ^(2,0)="^^1^1^"_$E(DT,1,7),^(1,0)="This is the script for the Miniengine of the IDCU."
 Q
OUT K XMP,XMU,XME Q
SCRIPT ;RESET AUSTIN SCRIPT
 W !!,"Checking AUSTIN TRANSMISSION SCRIPT !",!!
 S (DIE,DIC)="^XMB(4.6,",DIC(0)="M",X="AUSTIN" D ^DIC K J
 I Y>0 F I=0:0 S I=$O(^XMB(4.6,+Y,1,I)) Q:I=""  I $D(^(I,0)) S %=^(0) I %["VAAREG" G R:%["password" W !!,"AUSTIN SCRIPT OKAY",!! G M
 S %="AUSTIN",%1="VADATS",%2="IDCU" D ERR G M
R R !!,"Please enter your site's Region #.  This is the OLD REGION NUMBER",!,"from those remote days some of us remember in the distant past.",!!,"Enter your sites OLD REGION NUMBER (1-7): ",R:299
 I R?1"^".E W !,"PLEASE correct your AUSTIN script BEFORE trying to transmit data to AUSTIN.",!,"To do so invoke SCRIPT^XMYPOST.",! G A
 I R'?1N!(R<1)!(R>7) W !,*7,"PLEASE ENTER A WHOLE NUMBER FROM 1 THRU 7. (OR '^' TO ABORT)" G R
 S K=$F(J,"VAAREG") I K S J=$E(J,1,K-1)_R_$E(J,K+1,99)
 E  W !!,"*** REGION NUMBER NOT UPDATED ***"
 S K=$F(J,"password") I K S J=$E(J,1,K-9)_$P("EKLUND^ROBERSON^TAYLOR^YONOVITZ^GOLDSMITH^MUNNECKE^POLLOCK",U,R)_$C(34)_",$C(13)"
 E  W !!,"*** PASSWORD NOT UPDATED ***"
 S ^(0)=J
A W !!,"This is your AUSTIN TRANSMISSION SCRIPT:",!
 F I=0:0 S I=$O(^XMB(4.6,+Y,1,I)) Q:I=""  W !,^(I,0)
 W !
M W !!,"**** CHECKING MINI-ENGINE SCRIPT ****"
 S (DIE,DIC)="^XMB(4.6,",DIC(0)="M",X="MINI" D ^DIC
 I Y<0 W !!,*7,"  There was no MINI-ENGINE script.  YOU WILL NOT HAVE A VADATS CONNECTION.",!! Q
 S DA=+Y,DR=1 F I=0:0 S I=$O(^XMB(4.6,DA,1,I)) Q:'I  S %=^(I,0) Q:%["password"
 I 'I S %="MINIENGINE",%1="VADATS",%2="IDCU" G ERR
 W !!,"NOW EDIT THE 'MINI' TRANSMISSION SCRIPT !!",!!
 S (DIE,DIC)="^XMB(4.6,",DIC(0)="M",X="MINI" D ^DIC
 I Y<0 W !!,*7,"  There was no MINI-ENGINE script.  YOU WILL NOT HAVE A VADATS CONNECTION.",!! Q
 S DA=+Y,DR=1
 W !!,"The following is necessary to initialize your communications"
 W !,"over the Network.  You will be editing your transmission script for the"
 W !,"MINI-ENGINE.",!!,"ON LINE 4 BELOW !!!",!!,"The string '999' must be changed to your VADATS site number (eg. VAMC WASH=688)."
 W !,"The string 'password' must be changed to be your VADATS site password.",!
 D ^DIE Q
 ;
ERR ;Notify of scripts
 W !!,"We will not initialize your "_%_" script for a",!,%1_" connection.  It was either already set up properly",!,"or you are using "_%2_" instead.",!!
 K %1,%2 Q
