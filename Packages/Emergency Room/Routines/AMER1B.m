AMER1B ; IHS/ANMC/GIS -ISC - OVERFLOW FROM AMER1 ;   
 ;;3.0;ER VISIT SYSTEM;**16**;MAR 3, 2009;Build 14
 ;
QA6 ; TRANSFER
 S DIR("B")="NO" I $G(^TMP("AMER",$J,1,6)) S DIR("B")="YES"
 S DIR(0)="YO",DIR("A")="*Was this patient transferred from another facility" D ^DIR K DIR
 D OUT^AMER
 I Y K ^TMP("AMER",$J,1,10) ; ELIMINATE REGULAR TRANSPORT MODES
 I Y!(Y?1."^") Q
 F I=7,8,9 K ^TMP("AMER",$J,1,I) ; KILL OFF ALL DESCENDENTS
 S AMERRUN=9
 Q
 ;
QA7 ; TRANSFERED FROM
 S DIC("A")="*Transferred from: " K DIC("B")
 I $G(^TMP("AMER",$J,1,7)) S %=+^(7),DIC("B")=$P(^AMER(2.1,%,0),U)
 S DIC="^AMER(2.1,",DIC(0)="AEQM"
 D ^DIC K DIC
 D OUT^AMER
 Q
 ;
QA8 ; TRANSFER TRANSPORTATION
 N DIC
 S DIC("A")="*Mode of transport to the ER: " K DIC("B")
 I $G(^TMP("AMER",$J,1,8))>0 S %=+^(8),DIC("B")=$P(^AMER(3,%,0),U)
 E  S DIC("B")="PRIVATE VEHICLE"
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("TRANSFER DETAILS"),DIC(0)="AEQ"
 D ^DIC K DIC
 D OUT^AMER
 I Y=-1!(Y="") Q
 S Z=$P(Y,U,2)
 I Z'["AMBULANCE" F I=10:1:14 K ^TMP("AMER",$J,1,I)
 I Z="PRIVATE VEHICLE" S AMERRIN=9 Q
 Q
 ; 
QA9 ; TRANSFER ATTENDANT
 S DIR("B")="NO" I $G(^TMP("AMER",$J,1,9)) S DIR("B")="YES"
 S DIR(0)="YO",DIR("A")="Medical attendant present during transfer" D ^DIR K DIR
 D OUT^AMER
 S %=$G(^TMP("AMER",$J,1,8)) I $P(%,U,2)="AMBULANCE" S AMERRUN=10,^TMP("AMER",$J,1,10)=^TMP("AMER",$J,1,8) Q
 ;GDIT/HS/BEE;FEATURE#110347;AMER*3.0*16;TRAUMA REGISTRY
 ;I X'=U S AMERRUN=98
 I X'=U S AMERRUN=36
 Q
 ;
 ;GDIT/HS/BEE;FEATURE#110347;AMER*3.0*16;TRAUMA REGISTRY - QA37,QA38,QA39
QA37 ; Trauma Team Activation
 ;
 S DIR("B")="NO" I $G(^TMP("AMER",$J,1,37)) S DIR("B")="YES"
 S DIR(0)="YO",DIR("A")="*Was the Trauma Team Activated for this visit" D ^DIR K DIR
 D OUT^AMER
 I 'Y D
 . NEW I F I=38,39 K ^TMP("AMER",$J,1,I)
 . S AMERRUN=99
 ;
 Q
 ;
QA38 ; Trauma Team Activated Provider
 ;
 S DIR("A")="*Trauma Activated Provider" K DIR("B")
 I $G(^TMP("AMER",$J,1,38))>0 S %=+^(38),DIR("B")=$$GET1^DIQ(200,%_",",.01,"E")
 S DIR("?")="^D NHELP^AMERMPV1(""P"")"
 S DIR="^VA(200,",DIR(0)="PO^200:AEQM"
 S DIR("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 D ^DIR
 K DIR
 D OUT^AMER
 I Y<1 S AMERRUN=36 Q
 ;
 Q
 ;
QA39 ; Trauma Team Activation Date/Time
 ;
 ;Quit if no trauma
 I '$G(^TMP("AMER",$J,1,37)) Q
 ;
 S DIR("A")="*Trauma Team Activation Date/Time" K DIR("B")
 I $D(^TMP("AMER",$J,1,39)) S Y=^(39) X ^DD("DD") S DIR("B")=Y
 S DIR(0)="DO^::ER",DIR("?")="Enter a time and date in the usual FileMan format (e.g., 1/3/90@1PM)." D ^DIR K DIR
 D OUT^AMER
 I Y="" S Y=-1
 I Y<1 S AMERRUN=37 Q
 ;
 S AMERRUN=99
 ;
 Q
 ;
VAR NEW %,AMERRIN,AMERRUN,X,Y,Z
 Q
