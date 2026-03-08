APSPPAL ;IHS/MSC/PLS - Pickup Activity Log Support ;21-Feb-2025 08:57;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1034,1035**;Sep 23, 2004;Build 39
 ; IHS/MSC/PLS - 04/24/2023 - Original routine
 ;             - 04/09/2024 - FID 108533
 ;             - 07/11/2024 - FID 99319
SPEED ;-Main entry - Called from APSP SPEED PICKUP Protocol
 D:'$D(PSOPAR) ^PSOLSET I '$D(PSOPAR) D MSG^PSODPT G EX^PSOORFIN
 D SPEED^APSPPAL6
 Q
 N RXIEN,APSPPOP,ACTDT,DFN,APSPVAL,APSPZPAL,ARY,APSPUSE
 S APSPPOP=0,APSPZPAL=0,APSPUSE=0
 N VALMCNT I '$G(PSOCNT) S VALMSG="This patient has no Prescriptions!" S VALMBCK="" Q
 K PSOFDR,DIR,DUOUT,DIRUT S DIR("A")="Select Orders by number",DIR(0)="LO^1:"_PSOCNT D ^DIR I $D(DIRUT)!($D(DTOUT))!($D(DUOUT)) K DIR,DIRUT,DTOUT,DUOUT S VALMBCK="" Q
 K DIR,DIRUT,DTOUT,PSOOELSE,DTOUT I +Y S (SPEED,PSOOELSE)=1 D FULL^VALM1 S LST=Y D  G:$G(PSOPICK("DFLG"))!($G(PSOPICK("QFLG"))) SPEEDX
 .Q:$G(APSPVAL("DFLG"))
 .F ORD=1:1:$L(LST,",") Q:$P(LST,",",ORD)']""!($G(PSOPICK("QFLG")))  S ORN=$P(LST,",",ORD) D:+PSOLST(ORN)=52
 ..W !,"Processing Order number: "_ORD       ;Rx#: "_$P($G(^PSRX($P(PSOLST(ORN),"^",2),0)),"^")
 ..D PSOL^PSSLOCK($P(PSOLST(ORN),"^",2)) I '$G(PSOMSG) W $C(7),!!,$S($P($G(PSOMSG),"^",2)'="":$P($G(PSOMSG),"^",2),1:"Another person is editing Rx "_$P(^PSRX($P(PSOLST(ORN),"^",2),0),"^")),! D PAUSE^VALM1 K PSOMSG Q
 ..;FID 108533
 ..I $$GET1^DIQ(52,$P(PSOLST(ORN),U,2),9999999.23,"I") D  D ULK Q
 ...W $C(7),!!?5,"Unable to document pickup for external prescriptions." W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue." D ^DIR K DIR Q
 ..I '$$GET1^DIQ(52,$P(PSOLST(ORN),U,2),22,"I") D  D ULK Q
 ...W $C(7),!!?5,"Unable to document pickup for prescriptions with no fill date." W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR Q
 ..I APSPUSE=1 D  Q:APSPUSE>0  ;Auto fill
 ...N GF
 ...S GF=$$GETFILL($P(PSOLST(ORN),"^",2))  ;returns 0 or 1 for APSPPOP
 ...I GF S APSPUSE=-1  ; aborted so don't auto fill
 ...E  D  Q
 ....N DATA
 ....D UPTPKL(.DATA,$P(PSOLST(ORN),"^",2),.ARY)
 ..I 'APSPPOP D SINGLERX
 ..I $L(LST,",")>2&'APSPUSE,'APSPPOP D
 ...W !
 ...I 'APSPUSE,$L(LST,",")>2 I $$DIRYN^APSPUTIL("Use the same information for remaining prescriptions","Yes") D
 ....D BUILDARY($P(PSOLST(ORN),"^",2),.ARY)
 ....S APSPUSE=1
 ...E  S APSPUSE=-1
 ..D ULK
 ..W !
 ;
SPEEDX D EX
 S:'$D(VALMBCK) VALMBCK="R"
 Q
EX D PSOUL^PSSLOCK($P(PSOLST(ORN),U,2)) D ^PSOBUILD
 Q
 S RXIEN=$$GETIEN1^APSPUTIL(52,"Select Prescription: ",-1,.APSPPOP)
 Q:APSPPOP
 S ACTDT=$$DIR^APSPUTIL("52.999999951,.01","Pickup Date/Time","Now",,.APSPPOP)
 Q:APSPPOP
 ;
 Q
 ;
BUILDARY(RX,ARY) ;-
 ;
 N DATA,MSG
 S IENS=APSPZPAL_","_RX_","
 D GETS^DIQ(52.999999951,IENS,"**","IE","DATA","MSG")
 ;S ARY("PICKUP TIME")=$$GETFLD(.DATA,.01,"I")
 S ARY("PICKUP PERSON TYPE")=$$GETFLD(.DATA,.04,"I")
 S ARY("PICKUP PERSON RELATIONSHIP")=$$GETFLD(.DATA,.05,"I")
 S ARY("PICKUP PERSON ID QUALIFIER")=$$GETFLD(.DATA,.07,"I")
 S ARY("PICKUP PERSON ID JURISDICTION")=$$GETFLD(.DATA,.06,"I")
 S ARY("PICKUP PERSON ID NUMBER")=$$GETFLD(.DATA,.08,"E")
 S ARY("PICKUP PERSON FIRST NAME")=$$GETFLD(.DATA,2.02,"E")
 S ARY("PICKUP PERSON LAST NAME")=$$GETFLD(.DATA,2.01,"E")
 S ARY("PICKUP PERSON DOB")=$$GETFLD(.DATA,2.03,"I")
 S ARY("PICKUP PERSON ADDRESS 1")=$$GETFLD(.DATA,3.01,"E")
 S ARY("PICKUP PERSON ADDRESS 2")=$$GETFLD(.DATA,3.02,"E")
 S ARY("PICKUP PERSON CITY")=$$GETFLD(.DATA,4.01,"E")
 S ARY("PICKUP PERSON STATE")=$$GETFLD(.DATA,4.02,"E")
 S ARY("PICKUP PERSON ZIP")=$$GETFLD(.DATA,4.03,"E")
 S ARY("PICKUP PERSON PHONE NUMBER")=$$GETFLD(.DATA,4.04,"E")
 Q
GETFLD(DATA,FLD,F) ;-
 Q $G(DATA(52.999999951,IENS,FLD,F))
 ;
ULK D PSOUL^PSSLOCK($P(PSOLST(ORN),"^",2))
 Q
 ;
PKL ;Called from APSP PICKUP protocol
 N VALMCNT,DIR,DUOUT,DIRUT
 I '$G(PSOCNT) S VALMSG="This patient has no Prescriptions!" S VALMBCK="" Q
 ;
 S DIR("A")="Select Orders by number",DIR(0)="LO^1:"_PSOCNT D ^DIR I $D(DIRUT)!($D(DTOUT))!($D(DUOUT)) K DIR,DIRUT,DTOUT,DUOUT S VALMBCK="" Q
 D DIRZ^APSPUTIL("Press ENTER to exit")
 S VALMBCK="R"
 Q
 ;
SINGLERX ;
 N RXP,ARY,DATA
 S RXP=+$P(PSOLST(ORN),U,2)
 S PSORPDFN=+$P($G(^PSRX(RXP,0)),"^",2)
 D FULL^VALM1
 S APSPPOP=0
 D GETPUP1(RXP)
 I APSPPOP S VALMBCK="R",VALMSG="" Q
 S VALMSG="Pickup Recorded"
 S VALMBCK="R"
 Q
 ;
GETPUP1(RXN) ;-
 N DIC,DA,DIE,RXREF,DISPTYPE,ZDR,DEFJUR,DR,IENS,JURID,PTTYP
 N X,DIR,FDT,%DT,Y,EDT
 S DA=RXN
 ;FID 108533
 I $$GET1^DIQ(52,RXN,9999999.23,"I") D  Q
 .S APSPPOP=1
 .W $C(7),!!?5,"Unable to document pickup for external prescriptions"
 .W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR Q
 S FDT=$$GET1^DIQ(52,RXN,22,"I")
 I 'FDT D  Q
 .S APSPPOP=1
 .W $C(7),!!?5,"Unable to document pickup for prescriptions with no fill date."
 .W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR Q
 ;
 S Y=$$GETDPITM(RXN)
 I Y=-3 S APSPPOP=1 Q
 I Y=-2 D  Q
 .S APSPPOP=1
 .W $C(7),!!,?5,"All dispenses have a pickup log entry. Use the Prescription Pickup"
 .W !,?5,"Log Edit and/or Delete actions to manage entries as necessary."
 .W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR Q
 I Y<0 D  Q
 .S APSPPOP=1
 .W $C(7),!!,?5,"Entering a pickup requires selection of a dispense."
 .W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR Q   ;D DIRZ^APSPUTIL("Press ENTER to Continue") Q
 S EDT=$P($P(Y,":",2),U,3)
 S RXREF=+$P(Y,":",2)
 S ARY("RX REFERENCE")=RXREF
 S ARY("DISPENSE TYPE")=$P($P(Y,":",2),U,4)
 W !,"Rx#:"_$P(^PSRX(RXN,0),U)_" -Entering pickup information for "_$P($P(Y,":",2),U,2)_" on "_$$FMTE^XLFDT($P($P(Y,":",2),U,3),"5Z")
 S DIR("?",1)="   Enter value using MO/DD/YEAR@TIME format"
 S DIR("?",2)="  "
 S DIR("?",3)="   Enter a time which is less than or equal to <NOW>"
 S DIR("?",4)="   and equal to or greater than the Fill Date of the "
 S DIR("?")="   selected dispense("_$$FMTE^XLFDT(EDT,"5Z")_")"_"."
 S DIR("A")="Enter Pickup Date/Time"
 S DIR("B")="NOW"
 ;S EDT=$P($P(Y,":",2),U,3)
 S DIR(0)="D^"_EDT_":NOW:EXPR"
 D ^DIR
 I Y<1 S APSPPOP=1 Q
 I Y<EDT S APSPPOP=1 D  Q
 .W $C(7),!!?5,"Entered Pickup Date is prior to Fill Date of "_$$FMTE^XLFDT(FDT,"5E") W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR Q
 S DA(1)=RXN,X=Y
 S DIC="^PSRX(RXN,""ZPAL"",",DIC(0)="BQEL" D ^DIC
 I Y'>0 S APSPPOP=1 Q
 S:$D(APSPZPAL) APSPZPAL=+Y
 S RXREF=ARY("RX REFERENCE")
 S DISPTYPE=ARY("DISPENSE TYPE")
 S DEFJUR=$$GET1^DIQ(52,RXN,"20:100:.02")
 K DIC
 S DA=+Y
 S DA(1)=RXN
 S IENS=DA_","_RXN_","
 S DIE="^PSRX(RXN,""ZPAL"","
 ;ZDR holds common fields to be stuffed
 S ZDR="@1;.02////^S X=RXREF;.03///^S X=DISPTYPE;1.01////^S X=$$NOW^XLFDT();1.02////^S X=DUZ"
 S DR=".04//^S X=""PATIENT"";S PTTYP=X;.07R//^S X=""DRIVER'S LICENSE ID"";S JURID=X;.06R//^S X=$$GDEFJUR^APSPPAL(JURID,IENS,DEFJUR);.08R;S:PTTYP=""P"" Y=""@1"";.05T~R"_$$GFLDXPAR^APSPPAL()_";"_ZDR
 ;2.02T~R;2.01T~R;2.03T~R;3.01T~R;3.02T;4.01T~R;4.02T~R;4.03T~R;4.04T~R;"_ZDR
 D ^DIE
 I $D(Y) D  Q
 .S DIK=DIE D ^DIK
 .S APSPPOP=1
 E  D
 .D FIREEVT(RXN,DA)
 Q
 ;
GETFILL(RXIEN) ;-
 N Y,RXREF,DTYPE,Y1
 S APSPPOP=0
 S Y=$$GETDPITM(RXIEN)
 I Y>0 D
 .S Y1=$P(Y,":",2)
 .S RXREF=+Y1
 .S DTYPE=$P(Y1,U,4)
 .S ARY("DISPENSE TYPE")=DTYPE
 .S ARY("RX REFERENCE")=RXREF
 .;Prompt for pickup date
 .I '$$ASKDATE(.Y) D
 ..S ARY("PICKUP TIME")=Y
 .E  S APSPPOP=1
 E  S APSPPOP=1
 Q APSPPOP
 ;
 N VAL,FTYPE,FNUM,SOURCE
 S SOURCE=$$GET1^DID(52.999999951,.03,"","SPECIFIER")_U_$$GET1^DID(52.999999951,.03,"","POINTER")
 S FTYPE="",FNUM=0,APSPPOP=0
 S VAL=$$REFPAR(RXIEN)
 I VAL D  ;If Refill and/or Partial
 .I $P(VAL,U,2),'$P(VAL,U,3) D  ; If Refill and no Partial then default to Refill
 ..S FTYPE="R",FNUM=$P(VAL,U,2)
 .E  D
 ..S FTYPE=$$DIR^APSPUTIL(SOURCE,"Dispense type",,,.APSPPOP,"I $$TYPSCRN^APSPPAL(VAL)")
 ..Q:FTYPE="O"!APSPPOP
 ..S FNUM=$$DIR^APSPUTIL("N^1:"_$S(FTYPE="P":$P(VAL,U,3),1:$P(VAL,U,2)),"Fill number",$S(FTYPE="P":$P(VAL,U,3),1:$P(VAL,U,2)),,.APSPPOP)
 I 'APSPPOP D
 .S ARY("DISPENSE TYPE")=$S(FTYPE="":"O",1:FTYPE)
 .S ARY("RX REFERENCE")=FNUM
 Q APSPPOP
 ;
ASKDATE(Y) ;Prompt user for pickup date when using SPEED option
 N DIR,EDT
 S EDT=$P($P(Y,":",2),U,3)
 S DIR("?",1)="   Enter value using MO/DD/YEAR@TIME format"
 S DIR("?",2)="  "
 S DIR("?",3)="   Enter a time which is less than or equal to <NOW>"
 S DIR("?",4)="   and equal to or greater than the Fill Date of the"
 S DIR("?")="   selected dispense("_$$FMTE^XLFDT(EDT,"5E")_")"_"."
 S DIR("A")="Enter Pickup Date/Time"
 S DIR("B")="NOW"
 S EDT=$P($P(Y,":",2),U,3)
 S DIR(0)="D^"_EDT_":NOW:EXPR"
 D ^DIR
 I Y<1 S APSPPOP=1 Q
 I Y<EDT S APSPPOP=1 D  Q
 .W $C(7),!!?5,"Entered Pickup Date is prior to Fill Date of "_$$FMTE^XLFDT(EDT,"5E") W ! K DIR S DIR(0)="E",DIR("A")="Press Return to Continue" D ^DIR K DIR Q
 Q APSPPOP
TYPSCRN(VAL) ;-Allows Original when no refills, otherwise Refill or Partial when there have been dispenses
 N RES
 S RES=+$S(Y="O":'$P(VAL,U,2),1:$P(VAL,U,$S(Y="R":2,Y="P":3,1:0)))
 Q RES
 ;
GETCOM ;-
 N COM
 S COM=$$DIR^APSPUTIL("FO^1:80","Comment",,,.APSPPOP)
 S:'APSPPOP ARY("COMMENT")=COM
 Q
 ;
GDEFJUR(JURID,IENS,LDEF) ;-
 N DEF,ID
 S DEF=""
 S ID=$$GET1^DIQ(9009033.89,JURID,.03,"I")
 S ID=","_ID_","
 I ",2,6,11,"[ID S DEF=$G(LDEF)
 E  I ",1,4,5,7,"[ID S DEF="UNITED STATES"
 E  I ",3,8,9,"[ID S DEF="OTHER"
 Q DEF
 ;
GFLDXPAR() ;
 N LST,ARY,RES,FLD
 S RES=""
 S ARY("F")="2.02T~R"
 S ARY("L")="2.01T~R"
 S ARY("D")="2.03T~R"
 S ARY("A1")="3.01T~R"
 S ARY("A2")="3.02T"
 S ARY("C")="4.01T~R"
 S ARY("S")="4.02T~R"
 S ARY("Z")="4.03T~R"
 S ARY("P")="4.04T~R"
 D GETLST^XPAR(.LST,"ALL","APSP PICKUP FIELDS PROXY","I")
 F FLD="L","F","D","A1","A2","C","S","Z","P" I $G(LST(FLD))=1 S RES=RES_";"_ARY(FLD)
 Q RES
 ;
REFPAR(RXIEN) ;-
 N RF,PF,IDX
 S RF=0,IDX="" F  S IDX=$O(^PSRX(+RXIEN,1,IDX)) Q:IDX=""  S:$D(^PSRX(+RXIEN,1,IDX,0)) RF=RF+1
 S PF=0,IDX="" F  S IDX=$O(^PSRX(+RXIEN,"P",IDX)) Q:IDX=""  S:$D(^PSRX(+RXIEN,"P",IDX,0)) PF=PF+1
 Q RF+PF_U_RF_U_PF
 ;
UPTPKL(DATA,RX,ARY) ;-
 N IENS,FDA,FN,IENS,ERR,CIEN,APSPIEN
 S IENS="+1,"_RX_","
 S DATA=0
 S FN=52.999999951
 S FDA(FN,IENS,.01)=ARY("PICKUP TIME")
 S FDA(FN,IENS,.02)=ARY("RX REFERENCE")
 S FDA(FN,IENS,.03)=ARY("DISPENSE TYPE")
 S FDA(FN,IENS,.04)=ARY("PICKUP PERSON TYPE")
 S FDA(FN,IENS,.05)=$G(ARY("PICKUP PERSON RELATIONSHIP"))
 S FDA(FN,IENS,.06)=$G(ARY("PICKUP PERSON ID JURISDICTION"))
 S FDA(FN,IENS,.07)=$G(ARY("PICKUP PERSON ID QUALIFIER"))
 S FDA(FN,IENS,.08)=$G(ARY("PICKUP PERSON ID NUMBER"))
 S FDA(FN,IENS,1.01)=$$NOW^XLFDT()
 S FDA(FN,IENS,1.02)=DUZ
 S FDA(FN,IENS,2.01)=$G(ARY("PICKUP PERSON LAST NAME"))
 S FDA(FN,IENS,2.02)=$G(ARY("PICKUP PERSON FIRST NAME"))
 S FDA(FN,IENS,2.03)=$G(ARY("PICKUP PERSON DOB"))
 S FDA(FN,IENS,3.01)=$G(ARY("PICKUP PERSON ADDRESS 1"))
 S FDA(FN,IENS,3.02)=$G(ARY("PICKUP PERSON ADDRESS 2"))
 S FDA(FN,IENS,4.01)=$G(ARY("PICKUP PERSON CITY"))
 S FDA(FN,IENS,4.02)=$G(ARY("PICKUP PERSON STATE"))
 S FDA(FN,IENS,4.03)=$G(ARY("PICKUP PERSON ZIP"))
 S FDA(FN,IENS,4.04)=$G(ARY("PICKUP PERSON PHONE NUMBER"))
 S FDA(FN,IENS,9)=$G(ARY("COMMENT"))
 D UPDATE^DIE(,"FDA","APSPIEN","ERR")
 I '$D(ERR) D
 .S DATA=1
 .D FIREEVT(RX,$G(APSPIEN(1)))
 E  S DATA="0^Unable to update log"
 Q
 ;
FIREEVT(RXN,DA) ;-
 N RXNUM,ZPAL
 S RXNUM=RXN,ZPAL=DA
 D
 .N RXN,ARY,APSPUSE,ORD,LIST,X
 .S X=$O(^ORD(101,"B","APSP PICKUP LOG EVENT",0))_";ORD(101,"
 .D:X EN^XQOR  ;Fire protocol
 Q
HELP ;
 W !,"   Enter value using MO/DD/YEAR@TIME format"
 W !,"  "
 W !,"   Enter a time which is less than or equal to <NOW>"
 W !,"   and equal to or greater than the selected Fill Date."
 W !,"  "
 W !,"   Date/Time may be entered as NOW or Date/Time in past using"
 W !,"   MO/DD?YEAR@TIME format.",!
 Q
 ;
GETDPITM(RX) ; Return a dispense
 N LST,C,LP,XX,Y
 S XX=""
 D FIND(.LST,RX)
 S LP=0 F  S LP=$O(LST(LP)) Q:'LP  D
 .S XX=$S($L(XX):XX_";",1:"")_LP_":"_$P(LST(LP),U,2)_" on "_$$FMTE^XLFDT($P(LST(LP),U,3),"5Z")
 I $L(XX,";")>1 D
 .N LAST
 .S LAST=$L(XX,";")
 .S LP=0 F  S LP=$O(LST(LP)) Q:'LP  D  Q:LP+1=LAST
 ..I LP<LAST D
 ...S DIR("L",LP+1)="  "_LP_" - "_$P(LST(LP),U,2)_" on "_$$FMTE^XLFDT($P(LST(LP),U,3),"5Z")
 ..S DIR("L",1)="The following dispenses are selectable for pickup:"
 ..S DIR("L")="  "_LAST_" - "_$P(LST(LAST),U,2)_" on "_$$FMTE^XLFDT($P(LST(LAST),U,3),"5Z")
 .S DIR(0)="SO^"_XX
 .S DIR("A")="Select a dispense"
 .D ^DIR
 E  S Y=1
 Q:'$L(XX) -2  ;No dispenses available
 Q:$G(Y)=U -3  ;User forced exit
 Q $S($G(Y)>0:Y_":"_LST(+Y),1:-1)  ;-1=timeout
 ;
FIND(LST,RX) ;-
 ;
 ;Check Original Dispense
 N LP,XX
 S LP=0,XX=""
 I '$D(^PSRX(RX,"ZPAL","AC",0)) D  ;Include only if no pickup recorded
 .S LST($$INC)="0^Original^"_$$GET1^DIQ(52,RX,22,"I")_"^O"
 ;Check Refills
 ; - Exclude nodes with existing pickup
 ; - Exclude nodes with future refill date
 F  S LP=$O(^PSRX(RX,1,LP)) Q:'LP  D
 .Q:$D(^PSRX(RX,"ZPAL","AC",LP))
 .Q:+^PSRX(RX,1,LP,0)>DT
 .S LST($$INC)=LP_"^Refill^"_+^PSRX(RX,1,LP,0)_"^R"
 Q
INC() ;
 S C=$G(C)+1
 Q C
 ;
