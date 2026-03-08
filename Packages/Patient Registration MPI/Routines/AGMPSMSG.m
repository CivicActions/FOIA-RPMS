AGMPSMSG ;IHS/SD/TPF - MPI SEND MSG UTILITIES; 12/15/2007
 ;;1.0;AGMP;**1,2,3**;Apr 30, 2021;Build 45
 Q
 ;
DIRCON ;EP - SEND A DIRECT CONNECT VQQ-Q02
 ; VQQ messages have been disabled
 W !!,"THIS OPTION HAS BEEN DISABLED" Q
 I '$$ENABLED^AGMPOPT(1) Q  ; CHECK WHETHER MPI HAS BEEN DISABLED
 W !!,"ENTER PATIENT YOU WISH TO QUERY THE MPI FOR:"
 W !
 ;D PTLK^AG
 K DFN,RHIFLAG,DIC
 S DIC="^AUPNPAT(",DIC(0)="AEMQ"
 S DIC("S")="I $$LKUP^AGMPSMSG(+$G(Y))"
 ;D PTLKNKIL^AG
 D ^AUPNLK
 Q:'$D(DFN)
 ;I '$$XMITPAT(DFN,1) G DIRCON  ;DEMO PATIENT CHECK
 I $$DEMOPAT(DFN) W !,"Demo patients may not be uploaded from this environment" G DIRCON  ;Demo Patient Check
 D CREATMSG^AGMPHLO(DFN,"VTQ",,.SUCCESS)
 I SUCCESS D  Q
 .W !!,"Query message "_$G(SUCCESS)_" has been sent to the MPI"
 W !,"Unable to query patient "_$P(^DPT(DFN,0),U)_" on MPI"
 Q
 ;
A28 ;EP - SEND AN A28 ADD A PATIENT
 I '$$ENABLED^AGMPOPT(1) Q  ; CHECK WHETHER MPI HAS BEEN DISABLED
 W !!,"ENTER PATIENT YOU WISH TO ADD TO THE MPI:"
 ;D PTLK^AG
 K DFN,RHIFLAG,DIC,AGQUIT,NAME
 S DIC="^AUPNPAT(",DIC(0)="AEMQ"
 S DIC("S")="I $$LKUP^AGMPSMSG(+$G(Y))"
 ;D PTLKNKIL^AG
 D ^AUPNLK
 Q:'$D(DFN)
 ;
 ;Prompt for confirmation if a demo patient
 I $$DEMOPAT(DFN) D  I AGQUIT K AGQUIT W !,"Demo patients may not be uploaded from this environment" G A28
 . S AGQUIT=1,NAME=$P($G(^DPT(DFN,0)),U) w !,NAME,!
 . I NAME?1"DEMO,PATIENTCCDA".E!(NAME?1"DEMO,PATIENTMPI".E) S AGQUIT=0
 ;
 D CREATMSG^AGMPHLO(DFN,"A28",,.SUCCESS)
 I SUCCESS D  Q
 .W !!,"A28 Message "_SUCCESS_" has been sent to add patient "_$P(^DPT(DFN,0),U)_" to the MPI." H 2
 .;This was causing an extra message to be sent to EDR.
 .;S X="AG REGISTER A PATIENT",DIC=101,INDA=DFN
 .;D EN^XQOR
 W !,"Unable to create A28 to add patient "_$P(^DPT(DFN,0),U)_" to MPI"
 Q
 ;
A08 ;EP - SEND AN A08 UPDATE
 I '$$ENABLED^AGMPOPT(1) Q  ; CHECK WHETHER MPI HAS BEEN DISABLED
 W !!,"ENTER PATIENT YOU WISH TO UPDATE IN THE MPI:"
 ;D PTLK^AG
 K DFN,RHIFLAG,DIC
 S DIC="^AUPNPAT(",DIC(0)="AEMQ"
 S DIC("S")="I $$LKUP^AGMPSMSG(+$G(Y))"
 ;D PTLKNKIL^AG
 D ^AUPNLK
 Q:'$D(DFN)
 I $$DEMOPAT(DFN) W !,"Demo patients may not be uploaded from this environment" G A08  ;Demo Patient Check
 D CREATMSG^AGMPHLO(DFN,"A08","",.SUCCESS)
 I SUCCESS D  Q
 .W !!,"A08 Message "_SUCCESS_" has been sent to update patient "_$P(^DPT(DFN,0),U)_" on the MPI." H 2
 .;This was causing an extra message to be sent to EDR.
 .;S X="AG UPDATE A PATIENT",DIC=101,INDA=DFN
 .;D EN^XQOR
 W !,"Unable to create A08 to update patient "_$P(^DPT(DFN,0),U)_" on MPI"
 Q
 ;
VISITMSG ;EP - CREATE A NEW A01 OR A03
 I '$$ENABLED^AGMPOPT(1) Q  ; CHECK WHETHER MPI HAS BEEN DISABLED
 W !!,"CREATE A VISIT HL7 MESSAGE"
 ;D PTLK^AG
 K DFN,RHIFLAG,DIC
 S DIC="^AUPNPAT(",DIC(0)="AEMQ"
 S DIC("S")="I $$LKUP^AGMPSMSG(+$G(Y))"
 ;D PTLKNKIL^AG
 D ^AUPNLK
 Q:'$D(DFN)
 ;I '$$XMITPAT(DFN,1) G VISITMSG  ;DEMO PATIENT CHECK
 I $$DEMOPAT(DFN) W !,"Demo patients may not be uploaded from this environment" Q  ;Demo Patient Check
 K DIR
 S DIR(0)="SO^A:ADMISSION;D:DISCHARGE;CIN:CHECK-IN;COUT:CHECK-OUT"
 D ^DIR
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y="")
 ;CHECK IN - CHECK OUT
 I Y="CIN"!(Y="COUT") D  Q  Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y="")
 .S EVENT=$S(Y="CIN":4,1:5)
 .K DIR
 .S DIR(0)="D^::RE"
 .S DIR("A")="ENTER CHECK-"_$S(Y="CIN":"IN",1:"OUT")_" DATE"
 .D ^DIR
 .D NOW^%DTC S NOW=%
 .Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y="")
 .S DATE=Y
 .D CHKINOUT^AGMPADT(EVENT,DFN,DATE,.SUCCESS)
 .I SUCCESS D  Q
 ..W !!,$S(EVENT=4:"A01",1:"A03")_" Message IEN "_SUCCESS_" has been sent to update patient"
 ..W !,$P(^DPT(DFN,0),U)_" last treated date on the MPI." H 2
 .W !,"Unable to create "_$S(EVENT=4:"A01",1:"A03")_" to update patient "_$P(^DPT(DFN,0),U)_" on MPI"
 ;
 ;ADMISSION - DISCHARGE
 S TYPE=$S(Y="A":1,1:3)
 K DIR
 S DIR(0)="D^::RE"
 S DIR("A")="ENTER MOVEMENT DATE"
 D ^DIR
 D NOW^%DTC S NOW=%
 Q:$D(DUOUT)!$D(DTOUT)!$D(DIROUT)!(Y="")
 S DATETIME=Y
 D ADMDIS^AGMPADT(DFN,TYPE,,DATETIME,.SUCCESS)
 I SUCCESS D  Q
 .W !!,$S(TYPE=1:"A01",1:"A03")_" Message IEN "_SUCCESS_" has been sent to update patient"
 .W !,$P(^DPT(DFN,0),U)_" last treated date on the MPI." H 2
 W !,"Unable to create "_$S(TYPE=1:"A01",1:"A03")_" to update patient "_$P(^DPT(DFN,0),U)_" on MPI"
 Q
 ;
A40 ;EP - SEND A40 MERGE FROM/TO
 ; A40 messages have been disabled
 W !!,"THIS OPTION HAS BEEN DISABLED" Q
 N DFN1,DFN2,MRGDIR,NAME1,NAME2
PT1 ;ASK FOR FROM PATIENT
 I '$$ENABLED^AGMPOPT(1) Q  ; CHECK WHETHER MPI HAS BEEN DISABLED
 W !,"ENTER PATIENT TO KEEP:"
 S DIC="^VA(15,",DIC(0)="AEMQ",DIC("A")="Select PATIENT NAME: " D ^DIC
 Q:Y=-1
 S IEN=$P(Y,"^")
 S MRGDIR=$$GET1^DIQ(15,IEN_",",.04,"I")  ; 1=.01->.02, 2=.02->.01
 S DFN1=$P($$GET1^DIQ(15,IEN_",",$S(MRGDIR=1:.01,1:.02),"I"),";")  ; From patient
 S DFN2=$P($$GET1^DIQ(15,IEN_",",$S(MRGDIR=1:.02,1:.01),"I"),";")  ; To patient
 I $$DEMOPAT(DFN1) W !,"Demo patients may not be uploaded from this environment" G PT1  ;Demo Patient Check
 I $$DEMOPAT(DFN2) W !,"Demo patients may not be uploaded from this environment" G PT1  ;Demo Patient Check
 I $G(^DPT(DFN1,-9))'=DFN2 D  G PT1
 .W !,"THIS PATIENT HAS NOT BEEN MERGED TO FIRST PATIENT SUCCESSFULLY!"
 .K DIR
 .S DIR(0)="E"
 .D ^DIR
 S NAME1=$P($G(^DPT(DFN1,0)),U)  ; ^DIQ doesn't work on merged patients
 S NAME2=$$GET1^DIQ(2,DFN2_",",.01,"I")
 W !
 K DIR
 S DIR(0)="Y",DIR("A")="Send A40 for "_NAME1_" merged into "_NAME2,DIR("B")="Yes"
 D ^DIR
 I Y="^" Q
 I 'Y W ! G PT1
 D CREATMSG^AGMPHLO(DFN2,"A40",DFN1,.SUCCESS)
 I SUCCESS D  Q
 .W !!,"A40 Message "_SUCCESS_" has been sent to merge patient"
 .W !,$P(^DPT(DFN1,0),U)_" to patient "_$P(^DPT(DFN2,0),U) H 2
 W !,"Unable to merge "_$P(^DPT(DFN1,0),U)_" to patient "_$P(^DPT(DFN2,0),U)_" on MPI" H 2
 Q
 ;
MFNMFK ;EP - PROCESS MFN MESSAGE AND CREATE A MFK RESPONSE
 ; MFK messages have been disabled
 W !!,"THIS OPTION HAS BEEN DISABLED" Q
 I '$$ENABLED^AGMPOPT(1) Q  ; CHECK WHETHER MPI HAS BEEN DISABLED
 K DIR,DIC,DA,DIE,DIR
 W !!
 S DIC(0)="AQEM"
 S DIC("S")="I $G(^HLB(Y,2))[""MFN"""
 S DIC="^HLB("
 D ^DIC
 Q:Y<0
 D PROC^AGMPMFN(+Y,.SUCCESS)
 K DIR,DIC,DA,DIE,DIR
 I SUCCESS D  Q
 .W !!,"MFK Message "_SUCCESS_" has been sent to the MPI" H 2
 W !,"Unable to create MFK message." H 2
 Q
 ;
RESEND ;EP - RESEND MESSAGE(S)
RSAGAIN ;EP
 N FRMSGIEN,TOMSGIEN,DIC,DT,NEWIEN,ERROR,Y
 N MPIDIREC,TOTEVENT,GRDTOTAL,ERRORS
FROM ;EP - ASK FROM
 I '$$ENABLED^AGMPOPT(1) Q  ; CHECK WHETHER MPI HAS BEEN DISABLED
 S (MPIDIREC,TOTEVENT,GRDTOTAL,ERRORS)=0
 W !!
 S DIC=778
 S DIC(0)="AEQM"
 S DIC("A")="SELECT FROM MESSAGE: "
 ;S DIC("W")="W $P(^(0),U,20)_""**""_$P($G(^HLA($P(^(0),U,2),0)),U,4)"
 S DIC("W")="W $P($G(^(0)),U,5)_""**""_$P($G(^HLA($P(^(0),U,2),0)),U,4)"
 S DIC("S")="I $P($G(^(0)),U,4)=""O"",($P($G(^(0)),U,20)'=""SU""),($P($G(^(0)),U,5)=""MPI"")"
 D ^DIC
 Q:Y<0
 S FRMSGIEN=+Y
TO ;EP - ASK TO
 S DIC=778
 S DIC(0)="AEQM"
 S DIC("A")="SELECT TO MESSAGE: "
 S DIC("B")=FRMSGIEN
 ;S DIC("W")="W $P(^(0),U,20)_""**""_$P($G(^HLA($P(^(0),U,2),0)),U,4)"
 S DIC("W")="W $P($G(^(0)),U,5)_""**""_$P($G(^HLA($P(^(0),U,2),0)),U,4)"
 S DIC("S")="I $P($G(^(0)),U,4)=""O"",($P($G(^(0)),U,20)'=""SU""),$P($G(^(0)),U,5)=""MPI"""
 D ^DIC
 Q:Y<0
 S TOMSGIEN=+Y
 I FRMSGIEN>TOMSGIEN D  G FROM
 .W !,"FROM MSG ID CAN NOT BE GREATER THAN THE TO MSG ID" H 2
 S MSGIEN=FRMSGIEN-.01
 F  S MSGIEN=$O(^HLB(MSGIEN)) Q:MSGIEN>TOMSGIEN  D
 .S LINK=$P($G(^HLB(MSGIEN,0)),U,5)
 .Q:LINK'="MPI"
 .S DIREC=$P($G(^HLB(MSGIEN,0)),U,4)
 .Q:DIREC'="O"
 .S COMSTAT=$P($G(^HLB(MSGIEN,0)),U,20)
 .Q:COMSTAT="SU"
 .S EVENT=$P($P($G(^HLB(MSGIEN,2)),U,4),"~",2)
 .S NEWIEN=$$RESEND^HLOAPI3(MSGIEN,.ERROR)
 .D PARSE^AGMPACK(.DATA,NEWIEN,.HLMSTATE)
 .S DFN=$G(DATA(2,4,3,1,1))
 .S GRDTOTAL=GRDTOTAL+1
 .I '$D(ERROR) D  I 1
 ..W !,"MESSAGE RESENT, NEW NUMBER: "_NEWIEN
 ..W !?17,"OLD NUMBER: ",MSGIEN
 ..D NOW^%DTC S Y=% X ^DD("DD") W !,"SENT AT ",Y
 ..S TOTEVENT(EVENT)=$G(TOTEVENT(EVENT))+1
 .E  D  Q
 ..S ERRORS(ERROR)=$G(ERRORS(ERROR))+1
 ..K ERROR
 ;.Since this is a 'resend', we do not need to kick off these protocols again.
 ;.IF NO ERROR KICK PROTOCOL OFF
 ;.I EVENT="A28" D  Q
 ;..S X="AG REGISTER A PATIENT",DIC=101,INDA=DFN
 ;..D EN^XQOR
 ;.I EVENT="A08" D
 ;..S X="AG UPDATE A PATIENT",DIC=101,INDA=DFN
 ;..D EN^XQOR
 W !!,"TOTAL MESSAGES PROCESSED: ",GRDTOTAL
 S ERROR=""
 F  S ERROR=$O(ERRORS(ERROR)) Q:ERROR=""  D
 .W !,ERRORS(ERROR)," ",ERROR
 S EVENT=""
 F  S EVENT=$O(TOTEVENT(EVENT)) Q:EVENT=""  D
 .W !,TOTEVENT(EVENT)," ",EVENT
 G RSAGAIN
 Q
 ;
CONDT(DATE) ;EP - CONVERT FM DATE INTO 2009-04-14 00:00:00
 N NEWDATE,TIME
 I +DATE=0 Q ""
 S TIME=$P(DATE,".",2)
 S DATE=$P(DATE,".")
 S TIME="."_$$FILLSTR^AGMPHL1(TIME,6,"L",0)
 S DATE=DATE_TIME
 S NEWDATE=(1700+$E(DATE,1,3))
 S DATE=$TR(DATE,"."," ") S DATE=$E(DATE,4,14),NEWDATE=NEWDATE_DATE
 S NEWDATE=$E(NEWDATE,1,4)_"-"_$E(NEWDATE,5,6)_"-"_$E(NEWDATE,7,8)_" "_$E(NEWDATE,10,11)_":"_$E(NEWDATE,12,13)_":"_$E(NEWDATE,14,15)
 Q NEWDATE
 ;
XMITPAT(DFN,DISPMSG) ;EP - Check whether a patient may be transmitted
 N UPLDTYPE,ISDEMO
 S DISPMSG=$G(DISPMSG)
 I $G(DFN)="" Q ""
 ;S UPLDTYPE=$$GET1^DIQ(9002021.01,"1,",.03,"I")
 ;I UPLDTYPE="A" Q 1  ; INCLUDE ALL
 S ISDEMO=$$DEMOPAT(DFN)
 ;I ISDEMO,UPLDTYPE="D" Q 1  ; DEMO ONLY
 ;I 'ISDEMO,UPLDTYPE="E" Q 1  ; EXCLUDE DEMO
 ;I UPLDTYPE="D",DISPMSG W !,"Only demo patients may be uploaded from this environment"
 ;I UPLDTYPE="E",DISPMSG W !,"Demo patients may not be uploaded from this environment"
 I ISDEMO W:DISPMSG !,"Demo patients may not be uploaded from this environment" Q 0
 Q 1
 ;
DEMOPAT(DFN) ;EP - Check whether a patient is a demo patient.
 ; This is a demo patient if any one of the following criteria is true:
 ; a) TEST PATIENT INDICATOR (file 2, field 0.6) is set
 ; b) First five digits of the SSN are 0
 ; c) Patient's name matches 1"DEMO,PATIENT".E
 ; d) Patient is in the RPMS DEMO PATIENT NAMES sort template
 Q:$G(DFN)="" 0
 N NODE,NAME
 S NODE=$G(^DPT(DFN,0))
 I $P(NODE,U,21) Q 1
 I $E($P(NODE,U,9),1,5)="00000" Q 1
 ;
 ;Check the patient's name
 S NAME=$P(NODE,U)
 ;Handle merged patients
 I NAME["(",NAME[")" S NAME=$P($P(NAME,"(",2),")")
 I NAME["DEMO,PATIENT" Q 1
 ;
 ;Check the patient against the demo patient sort template
 N %
 S %=$O(^DIBT("B","RPMS DEMO PATIENT NAMES",0))
 I '% Q 0
 I $D(^DIBT(%,1,DFN)) Q 1
 Q 0
 ;
LKUP(DFN) ;EP - Patient Lookup Screening
 ;
 ;This tag is called by DIC("S") logic in the MPI patient lookups
 ;it determines whether a patient can be selected based on the
 ;value of the UPLOAD TYPE field in AGMP PARAMETERS
 ;possibly put call in DEMO^APCLUTL to look at demo patients
 ;
 N UPLDTYPE,ISDEMO
 I $G(DFN)="" Q 0
 ;
 ;No longer use parameter setting - include demo and screen out later
 ;S UPLDTYPE=$$GET1^DIQ(9002021.01,"1,",.03,"I")
 ;I UPLDTYPE="A" Q 1  ; INCLUDE ALL
 ;S ISDEMO=$$DEMOPAT(DFN)
 ;I ISDEMO,UPLDTYPE="D" Q 1  ; DEMO ONLY
 ;I 'ISDEMO,UPLDTYPE="E" Q 1  ; EXCLUDE DEMO
 ;Q 0
 Q 1
