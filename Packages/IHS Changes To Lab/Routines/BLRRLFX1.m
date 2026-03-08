BLRRLFX1 ;IHS/CMI/THL/MAW - Refile Utility; 05-Apr-2018 16:50 ; MAW
 ;;5.2;IHS LABORATORY;**1041,1047**;NOV 01, 1997;Build 21
 Q
EN ;EP;TO REFILE LAB MESSAGE
 N QUIT,PAT,PATX,PID,MTYPE,SID,FN,FI,ACC,X,Y,Z,J,JJ,K,ONO,LOOK,ALL,DFN
 N SEG,SEQ,SSN,SEX,NAM,IEN,LRDFN,LROX,LINE,LN,FN,MN,END,DOB,SEGX
 S QUIT=0
 W @IOF
 W !?10,"Select patients and HL7 messages for ACCESSION NUMBER correction"
 D MTYPE
 Q:QUIT
 F  D P1 Q:QUIT
 Q
 ;
PAT ;FIND INDIVIDUAL PATIENT
 S QUIT=0
 F  D P1 Q:QUIT
 S QUIT=0
 Q
 ;
ALL ;FIND MESSAGES W NO ACC NUM
 K ^TMP("BLRRLPAT"),^("BLRRLPN")
 S X1=DT
 S X2=-60
 D C^%DTC
 S END=X
 I '$D(ZTQUEUED) D  Q:QUIT
 .K DIR
 .S DIR(0)="DO"
 .S DIR("A")="Search dates since"
 .D DIR
 .I QUIT S QUIT=0 Q
 .S END=Y
 S END=(END+17000000)-1
 I MTYPE=1 D AHL7
 I MTYPE=2 D AINTHU
 Q:$D(ZTQUEUED)
 I '$D(^TMP("BLRRLPAT")) D  Q
 .W !!,"No HL7 messages with missing Accession Numbers were found."
 S QUIT=0
 F  D LALL Q:QUIT
 S QUIT=0
 Q
 ;
P1 ;PAT
 K ^TMP("BLRRLPAT"),^("BLRRLPN")
 N ONO,PAT,SID
 S (ONO,PAT,SID)=""
 W @IOF
 W !?10,"Select patients to search for in the '",$S(MTYPE=1:"HL(772,",1:"INTHU("),"' global"
 K DIR
 S DIR(0)="SO^1:Use FM patient lookup;2:Enter patient name;3:Specimen ID;4:Order No.;5:List recent messages with missing ACCESSION NUMBER;6:Lookup Patient by UID"
 S DIR("A")="Which user name option"
 D DIR
 Q:QUIT=1
 S LOOK=X
 I LOOK=1 D FM I 1
 E  I LOOK=2 D PNAM I 1
 E  I LOOK=3 D SID I 1
 E  I LOOK=4 D ONO I 1
 E  I LOOK=6 D ACCL I 1
 E  I LOOK=5 D ALL Q
 I QUIT D  Q
 .W:12[LOOK !!,"Patient name missing."
 .W:LOOK=3 !!,"Specimen ID missing."
 .W:LOOK=4 !!,"Order Number missing or Patient Not found for order number."
 .W:LOOK=6 !!,"UID is missing."
 .H 2
 .S QUIT=0
 W !!,"We'll search for messages in"
 W !!?15,"global: ",$S(MTYPE=1:"HL(772,",1:"INTHU(")
 W !?10,"for patient: ",$S(PAT]"":PAT,1:"(not entered)")
 W !?10,"Specimen ID: ",$S(SID]"":SID,1:"(not entered)")
 W !?10,"  Order No.: ",$S(ONO]"":ONO,1:"(not entered)")
 W !!?1,"that are missing the",!?5,"Accession number:"
 I LOOK=6 D DISPTST
 D PAUSE
 D FIND(PAT,SID,ONO)
 Q:$O(^TMP("BLRRLPAT",""))=""
 S:$G(PATX)]"" PAT=PATX
 S:PAT="" PAT=$O(^TMP("BLRRLPAT",""))
 D LIST(PAT)
 K ^TMP("BLRRLPAT"),^("BLRRLPN")
 Q
 ;
ACCL ;look pat by acc
 N UIDA,UIDD,UIDN,UIDI,PATI,TSTDA,TSTI,CNT,PATI,PATE,PATN
 K DIR
 S DIR(0)="FO^1:10"
 S DIR("A")="Enter the UID"
 D DIR
 Q:QUIT
 S UID=$G(X)
 S UIDI=$Q(^LRO(68,"C",UID))
 S UIDA=$QS(UIDI,4),UIDD=$QS(UIDI,5),UIDN=$QS(UIDI,6)
 S PATI=$P($G(^LRO(68,UIDA,1,UIDD,1,UIDN,0)),U)
 S PATE=$P($G(^LR(PATI,0)),U,3)
 S PATN=$P($G(^DPT(PATE,0)),U)
 S PAT=$P(PATN,",")_U_$P($P(PATN,",",2)," ")
 S CNT=0
 S TSTDA=0 F  S TSTDA=$O(^LRO(68,UIDA,1,UIDD,1,UIDN,4,TSTDA)) Q:'TSTDA  D
 . S TSTI=$P($G(^LRO(68,UIDA,1,UIDD,1,UIDN,4,TSTDA,0)),U)
 . S CNT=CNT+1
 . I $G(TSTI) S TST(CNT)=$P($G(^LAB(60,TSTI,0)),U)
 Q
 ;
DISPTST ;
 W !!,"Tests attached to UID: "_UID
 N TDA
 S TDA=0 F  S TDA=$O(TST(TDA)) Q:'TDA  D
 . W !,$G(TST(TDA))
 Q
 ;
FM ;FM LKUP
 K DFN,DIC
 S DIC="^DPT("
 S DIC(0)="AEMQZ"
 S DIC("A")="Enter PATIENT NAME or Chart Number: "
 W !
 D ^DIC
 I Y<1 S QUIT=1 Q
 S PAT=$P($P(Y,U,2),",")_U_$E($P($P(Y,U,2),",",2))
 Q
 ;
PNAM ;DIR PT NM
 K DIR
 S DIR(0)="FO^1:30"
 S DIR("A",1)="Enter the patient's NAME"
 S DIR("A")="LASTNAME,FIRSTNAME"
 D DIR
 Q:QUIT
 I X'?1U.U1",".U D  G PNAM
 .W !!,"Enter the patient's name in the format:"
 .W !!,"LASTNAME followed by a comma and the first initial or"
 .W !,"any number of characters of the patient's first initial"
 .H 2
 S PAT=$TR(X,",","^")
 Q
 ;
MTYPE ;772 OR INTHU
 S MTYPE=$P($G(^BLRSITE(DUZ(2),"RL")),U,22)
 I MTYPE]"" D  Q
 .S MTYPE=$S(MTYPE=1:1,1:2)
 K DIR
 S DIR(0)="SO^1:Messages in HL(772, global;2:Messages in INTHU( global"
 S DIR("A")="Which global to search"
 D DIR
 Q:QUIT
 S MTYPE=X
 Q
 ;
ACCNUM ;ACC NUM
 K DIR,ACC
 S DIR(0)="FO^10:10"
 S DIR("A",1)="Enter the Missing"
 S DIR("A")="Accession number"
 D DIR
 Q:QUIT
 I X'?10N W !!,"Accession number must be 10 numeric characters." G ACCNUM
 S ACC=X
 Q
 ;
SPECID ;SPEC ID
 S SID=""
 K DIR
 S DIR(0)="FO^1:15"
 S DIR("A")="Specimen ID"
 D DIR
 I QUIT S QUIT=0 Q
 S SID=X
 Q
 ;
FIND(PAT,SID,ONO) ;FIND MSGS
 I MTYPE=1 D HL7
 I MTYPE=2 D INTHU
 Q
 ;
LIST(PAT) ;LIST MSGS
 S QUIT=0
 F  D L1 Q:QUIT
 S QUIT=0
 Q
 ;
L1 ;LIST ALL MSGS FOR PAT
 N X,Y,Z,XX
 S Y=$O(^TMP("BLRRLPAT",PAT,0))
 I Y,'$O(^TMP("BLRRLPAT",PAT,Y)) D IEN(PAT,Y) S QUIT=1 Q
 D LHEAD(PAT)
 K DIR
 S DIR(0)="FO^1:15"
 S DIR("A",1)="Add Accession numbers to"
 S DIR("A")="OBR segments for message IEN"
 D DIR
 Q:QUIT
 I X'?1N.N W !,"IEN must be a numeric value" G L1
 I '$D(XX(X)) W !!,"IEN: ",X," not found." H 2 Q
 S NAM=XX(X)
 S IEN=X
 D IEN(NAM,IEN)
 S QUIT=0
 Q
 ;
HL7 ;SEARCH 772
 N X,Y,Z,QUIT
 S JJ=0
 S QUIT=0
 S X=9999999999
 F  S X=$O(^HLMA(X),-1) Q:'X  S IEN=+$G(^(X,0)) I IEN,$G(^HLMA(X,"MSH",1,0))["ORU^R01",$D(^HL(772,IEN,"IN")) D
 .I PAT]"",$P($G(^HL(772,IEN,"IN",1,0)),"|",6)'[PAT Q
 .S PID=$P(^HL(772,IEN,"IN",1,0),"|",6)_" DOB: "_$P(^(0),"|",8)_" SEX: "_$P(^(0),"|",9)
 .S J=0
 .S Y=1
 .F  S Y=$O(^HL(772,IEN,"IN",Y)) Q:'Y  I $G(^(Y,0))["OBR|",$P(^(0),"|",3)'?10N S XX=^(0) D
 ..I SID]"",$P(XX,"|",4)'=SID Q
 ..I ONO]"",$P(XX,"|",19)'=ONO Q
 ..S J=J+1
 ..S ^TMP("BLRRLPAT",PID,IEN,J)=Y_"***"_XX
 ..I SID]"",PAT="" S PATX=PID
 ..I ONO]"",PID[PAT S PATX=PID
 D PN
 Q
 ;
INTHU ;SEARCH INTHU
 S X=9999999999
 F  S X=$O(^INTHU(X),-1) Q:'X  D:$G(^(X,3,1,0))["ORU^R01"
 .I PAT]"",$P($G(^INTHU(X,3,2,0)),"|",6)'[PAT Q
 .S PID=$P(^INTHU(X,3,2,0),"|",6)_" DOB: "_$P(^(0),"|",8)_" SEX: "_$P(^(0),"|",9)
 .S J=0
 .S Y=2
 .F  S Y=$O(^INTHU(X,3,Y)) Q:'Y  I $G(^(Y,0))["OBR|",$P(^(0),"|",3)'?10N S XX=^(0) D
 ..I SID]"",$P(XX,"|",4)'=SID Q
 ..I ONO]"",$P(XX,"|",19)'=ONO Q
 ..S J=J+1
 ..S ^TMP("BLRRLPAT",PID,X,J)=Y_"***"_XX
 ..I SID]"",PAT="" S PATX=PID
 ..I ONO]"",PID[PAT S PATX=PID
 D PN
 Q
 ;
AHL7 ;SEARCH HL(772
 N X,Y,Z,QUIT
 S QUIT=0
 S JJ=0
 S X=9999999999
 F  S X=$O(^HLMA(X),-1) Q:'X!QUIT  S IEN=+$G(^(X,0)) I IEN,$G(^HLMA(X,"MSH",1,0))["ORU^R01",$E($P(^(0),"|",7),1,8)>END,$D(^HL(772,IEN,"IN")) D
 .S J=0
 .S Y=0
 .F  S Y=$O(^HL(772,IEN,"IN",Y)) Q:'Y  I $G(^(Y,0))["PID|"!($G(^(0))["OBR|") S XX=^(0) D
 ..I XX["PID|" S PID=$P(XX,"|",6)_" DOB: "_$P(XX,"|",8)_" SEX: "_$P(^(0),"|",9) Q
 ..Q:$P(XX,"|",3)?10N
 ..S J=J+1
 ..S ^TMP("BLRRLPAT",PID,IEN,J)=Y_"***"_XX
 D PN
 Q
 ;
PN ;CREATE ARRAY
 S JJ=0
 S X=0
 F  S X=$O(^TMP("BLRRLPAT",X)) Q:X=""  S JJ=JJ+1,^TMP("BLRRLPN",JJ)=X
 Q
 ;
AINTHU ;SEARCH INTHU
 S JJ=0
 S X=9999999999
 F  S X=$O(^INTHU(X),-1) Q:'X  I $G(^(X,3,1,0))["ORU^R01",$E($P(^(0),"|",7),1,8)>END D
 .S J=0
 .S Y=0
 .F  S Y=$O(^INTHU(X,3,Y)) Q:'Y  I $G(^(Y,0))["PID|"!($G(^(0))["OBR|") S XX=^(0) D
 ..I XX["PID|" S PID=$P(XX,"|",6)_" DOB: "_$P(XX,"|",8)_" SEX:  "_$P(^(0),"|",9) Q
 ..Q:$P(XX,"|",3)?10N
 ..S J=J+1
 ..S ^TMP("BLRRLPAT",PID,X,J)=Y_"***"_XX
 D PN
 Q
 ;
IEN(NAM,IEN) ;SELECT SEGS TO ADD ACC NUM
 S X=$O(^TMP("BLRRLPAT",NAM,IEN,0))
 I '$O(^TMP("BLRRLPAT",NAM,IEN,X)) D  Q
 .D CHANGE(NAM,IEN,X)
 .Q:QUIT
 .I 'QUIT D REFILE(NAM,IEN)
 .S QUIT=0
 D IENHEAD(NAM,IEN)
 K DIR
 S DIR(0)="LO^1:"_J
 S DIR("A")="Select sequence number(s) for segments to change"
 D DIR
 I QUIT S QUIT=0 Q
 S ALL=Y
 S K=0
 F J=1:1:($L(ALL,",")-1) S SEQ=$P(ALL,",",J) D CHANGE(NAM,IEN,SEQ)
 I QUIT S QUIT=0 Q
 D REFILE(NAM,IEN)
 Q
 ;
CHANGE(NAM,IEN,SEQ) ;ENTER AN AND CHANGE SEGMENT
CH1 W @IOF
 S QUIT=0
 S X=$G(^TMP("BLRRLPAT",NAM,IEN,SEQ))
 Q:X=""
 S SEG=+X
 S SEGX=$P(X,"***",2)
 W !!,"    Patient: ",NAM
 W !,"Message IEN: ",IEN
 W !,"Sequence No: ",SEQ
 W !," Segment No: ",SEG
 W !!?5,SEGX
 S DFN=$$DFN(NAM)
 D:DFN ACC(DFN,IEN,SEG,SEGX)
 D:$D(ACC(1))
 .W !!?5,"No.",?10,"Accession Number"
 .W !?5,"---",?10,"----------------"
 .S J=0
 .F  S J=$O(ACC(J)) Q:'J  W !?5,J,?10,ACC(J)
 S ACC=""
 D ACCS
 I QUIT D  Q
 .W !!,"Accession number not specified."
 .H 2
 I ACC="" G CH1
 K DIR
 S DIR(0)="YO"
 S DIR("A",1)="Is "_ACC_" the correct"
 S DIR("A")="Accession Number for segment "_SEG_" "
 S DIR("B")="YES"
 D DIR
 I Y'=1 S K=K+1 Q  S:K=($L(ALL,",")-1) QUIT=1 Q
C1 I MTYPE=1 S $P(^TMP("BLRRLPAT",NAM,IEN,SEQ),"|",3)=ACC
 I MTYPE=2 S $P(^TMP("BLRRLPAT",NAM,IEN,SEQ),"|",3)=ACC
C2 I MTYPE=1 S $P(^HL(772,IEN,"IN",SEG,0),"|",3)=ACC
 I MTYPE=2 S $P(^INTHU(IEN,3,SEG,0),"|",3)=ACC
 Q
 ;
REFILE(NAM,IEN) ;REFILE
 I $G(MTYPE)=1 D  Q:'BLRRLMA
 .S BLRRLMA=$O(^HLMA("B",IEN,0))
 I MTYPE=1 D EN^XBNEW("CALLHL^BLRRLFX1","BLRRLMA")
 I MTYPE=2 S ^INLHSCH(0,$H,IEN)=""
 Q:$D(ZTQUEUED)
 W !!," HL7 Message IEN: ",IEN," has been refiled with"
 W !,"Accession Number: ",ACC
 D PAUSE
 Q
 ;
LALL ;LIST MSGS WOUT ACC NUM
 S QUIT=0
 D AHEAD
 S JJ=0
 F  S JJ=$O(^TMP("BLRRLPN",JJ)) Q:JJ=""!QUIT  S XX=^(JJ) D
 .W !,JJ,?10,$P(XX,"DOB:")
 .W ?40,"DOB: ",$P($P(XX,"SEX:"),"DOB:",2)
 .W ?56,"SEX: ",$P(XX,"SEX:",2)
 .I JJ>1,JJ#20=0 D  Q:QUIT
 ..W !,"---------------------------"
 ..D LINE
 ..Q:QUIT
 ..D AHEAD
 S QUIT=0
 S JJ=$O(^TMP("BLRRLPN",9999999999),-1)
 S NAM=$$ASEL(JJ)
 Q:QUIT
 D LIST(NAM)
 Q
 ;
ASEL(NUM) ;SELECT PAT EDIT
 S NAM=""
 K DIR
 S DIR(0)="NO^1:"_NUM
 S DIR("A")="Which Patient"
 D DIR
 Q:QUIT ""
 I 'X!'$D(^TMP("BLRRLPN",+X)) W !,"Enter a number from 1 to ",JJ Q ""
 S NAM=$G(^TMP("BLRRLPN",X))
 Q NAM
 ;
LINE ;
 Q:$D(ZTQUEUED)
 W !!,"Press <ENTER> to continue,"
 R !,"Enter '^' followed by <ENTER> to exit...",XXX:DTIME
 S:XXX[U QUIT=1
 Q
 ;
LHEAD(NAM) ;LIST HEAD
 W @IOF
 I LOOK=6 D DISPTST
 W !?10,"HL7 Messages for ",PAT
 W !?10,"with missing ACCESSION NUMBER"
 W !!,"Message",?10,"Sequence",?20,"Segment"
 W !,"IEN",?10,"NO.",?20,"NO."
 W !,"--------",?10,"--------",?20,"-------"
 S LINE=0
 S JJ=0
 S X=$E(NAM,1,$L(NAM)-1)
 F  S X=$O(^TMP("BLRRLPAT",X)) Q:X'[NAM  D
 .W !?10,X
 .S Y=0
 .F  S Y=$O(^TMP("BLRRLPAT",X,Y)) Q:'Y  D
 ..S XX(Y)=X
 ..S LINE=LINE+1
 ..D LINE:(LINE#20=0)
 ..W !,Y
 ..Q:QUIT
 ..S K=0
 ..S Z=0
 ..F  S Z=$O(^TMP("BLRRLPAT",X,Y,Z)) Q:'Z  S XX=^(Z) D
 ...S K=K+1
 ...S LINE=LINE+1 D LINE:(LINE#20=0) Q:QUIT
 ...W:K>1 !
 ...W ?10,Z,?20,+XX,?27,$E($P(XX,"***",2),1,48),"..."
 Q
 ;
IENHEAD(NAM,IEN) ;LIST IEN SEGS
 W @IOF
 W !?10,"OBR segments with missing Accession"
 W !?10,"Number for message: ",IEN
 W !!,"Message",?10,"Sequence",?20,"Segment"
 W !,"IEN",?10,"NO.",?20,"NO."
 W !,"--------",?10,"--------",?20,"-------"
 W !,IEN
 S J=0
 S X=0
 F  S X=$O(^TMP("BLRRLPAT",NAM,IEN,X)) Q:'X  S XX=^(X) D
 .S J=X
 .W:J>1 !
 .W ?10,X,?20,+XX,?27,$E($P(XX,"***",2),1,48),"..."
 Q
 ;
AHEAD ;HDR
 W @IOF
 W !,"No.",?10,"Patient"
 W !,"-----",?10,"----------------------------------------"
 Q
 ;
PAUSE ;
 Q:$D(ZTQUEUED)
 R !!,"Press <ENTER> to continue...",XXX:DTIME
 Q
 ;
DFN(NAM) ;FIND DFN
 S X=$P(NAM," DOB: ")
 S DOB=$P($P(NAM,"SEX: "),"DOB: ",2)-17000000
 S SEX=$P(NAM,"SEX: ",2)
 S LN=$P(X,U)
 S FN=$P(X,U,2)
 S MN=$P(X,U,3)
 S X=LN_","_FN_$S(MN]"":" "_MN,1:"")
 S DIC="^DPT("
 S DIC(0)="M"
 S DIC("S")="I $P(^(0),U,3)=DOB,$P(^(0),U,2)=SEX"
 D ^DIC
 I Y<1 Q ""
 Q +Y
 ;
ACC(DFN,IEN,SEG,SEGX) ;FIND RECENT ACC NUM
 N X,Y,Z,PAT,DAT,LRO,DATX
 K ACC
 S DAT=$E($P(SEGX,"|",9),1,8)-17000000
 S DATX=DAT_"."_$E($P(SEGX,"|",8),9,12)
 Q:'DAT
 S LRO=0
 F  S LRO=$O(^LRO(68,LRO)) Q:'LRO  S LROX=$P(^(LRO,0),U) D A1
 Q
 ;
A1 ;
 S DX=DAT-1
 F  S DX=$O(^LRO(68,LRO,1,DX)) Q:'DX!(DX'[DAT)  D
 .S J=0
 .S X=0
 .F  S X=$O(^LRO(68,LRO,1,DX,1,X)) Q:'X  I +$G(^(X,0))=DFN S Y=$P($G(^(3)),U),ACC=$P($G(^(.3)),U) D:ACC
 ..S J=J+1
 ..S ACC(J)=ACC_U_LROX
 ..S PAT=$P($G(^DPT(DFN,0)),U)
 ..Q:PAT=""
 ..S $P(SEGX,"|",3)=ACC
 ..S ^TMP("BLRR MATCH",PAT,IEN,SEG)=ACC_U_SEGX
 Q
 ;
MATCH ;PROCESS MSGS
 N X,Y,Z
 S X=""
 F  S X=$O(^TMP("BLRRLPAT",X)) Q:X=""  D
 .S Y=0
 .F  S Y=$O(^TMP("BLRRLPAT",X,Y)) Q:'Y  D
 ..S Z=0
 ..F  S Z=$O(^TMP("BLRRLPAT",X,Y,Z)) Q:'Z  S XX=$G(^(Z)) D:XX M1(X,Y,Z,XX)
 Q
 ;
M1(PAT,IEN,SEQ,XX) ;PROCESS
 S SEG=+XX
 S SEGX=$P(XX,"***",2)
 S DFN=$$DFN(PAT)
 Q:'DFN
 D ACC(DFN,IEN,SEG,SEGX)
 Q:'$O(ACC(0))
 Q
 ;
MON ;MONITOR
 Q:$O(^TMP("BLRR MATCH",""))=""
 D MDISP
 S QUIT=0
 F  D MSEL Q:QUIT
 S QUIT=0
 Q
 ;
MSEL ;SEL MATCH
 K DIR
 S DIR(0)="LO^1:"_JJ
 S DIR("A")="Select all for which the Accession Number is correct"
 D DIR
 Q:QUIT=1
 I 'X W !,"Enter a number or list of number from 1 to ",JJ G MSEL
 S ALL=Y
 S K=0
 F J=1:1:($L(ALL,",")-1) S SEQ=$P(ALL,",",J),X=^TMP("BLRR PROC",SEQ) D P1S(X)
 Q
 ;
P1S(X) ;
 S IEN=$P(X,U)
 S SEG=$P(X,U,2)
 S ACC=$P(X,U,3)
 D C2
 D REFILE(NAM,IEN)
 Q
 ;
MDISP ;DISPLAY MATCH LOG
 D MHEAD
 N X,Y,Z
 S J=0
 S X=0
 F  S X=$O(^TMP("BLRR MATCH",X)) Q:X=""  D
 .S Y=0
 .F  S Y=$O(^TMP("BLRR MATCH",X,Y)) Q:'Y  D
 ..S Z=0
 ..F  S X=$O(^TMP("BLRR MATCH",X,Y,Z)) Q:'Z  S XX=^(Z) D
 ...S J=J+1
 ...W !,J,?5,X,?35,Y,?45,Z
 ...W !?5,$P(XX,U,2)
 ...S ^TMP("BLRR PROC",JJ)=Y_U_Z_U_$P(XX,U,1,99)
 S JJ=J
 Q
 ;
MHEAD ;HDR
 Q:$D(ZTQUEUED)
 W @IOF
 W !?5,"Accession Number Matches for HL7 Messages"
 W !!,"Seq",?35,"Message"
 W !,"No.",?5,"Patient",?35,"IEN",?45,"Seg"
 W !,"----",?5,"-----------------------------",?35,"---------",?45,"---"
 Q
 ;
CALLHL ;REFILE
 N ORIGDUZ
 S ORIGDUZ=DUZ
 D REPROC^HLUTIL(BLRRLMA,"D ORU^LA7VHL")
 D DUZ^XUP(ORIGDUZ)
 K BLRRLMA
 Q
 ;
SID ;SPEC ID     
 K DIR
 S DIR(0)="FO^1:30"  ;^I X'?1U.UN"  ;maw removed 3/23/2018 for RML
 S DIR("A")="Enter the Specimen ID"
 D DIR
 Q:QUIT
 S SID=X
 Q
 ;
ONO ;ORD NUM
 K DIR
 S DIR(0)="FO^1:30"
 S DIR("A")="Enter the Order Number"
 D DIR
 Q:QUIT
 I X'?1N.N D  G ONO
 .W !!,"Response must be numeric"
 .H 2
 S ONO=X
 S DA(1)=+$O(^LRO(69,"C",X,0))
 S DA=+$O(^LRO(69,"C",X,DA(1),0))
 S LRDFN=+$G(^LRO(69,DA(1),1,DA,0))
 D PATN(LRDFN)
 I PAT="" S QUIT=1 Q
 Q
 ;
DIR ;
 W !!
 D ^DIR
 K DIR
 I X[U!(X="") S QUIT=1
 Q
 ;
PATN(X) ;PAT NAM
 S Y=$P($G(^DPT(X,0)),U)
 S PAT=$P(Y,",")_U_$P($P(Y,",",2)," ")
 Q
 ;
DMESS(IEN) ;DISMSG
 W @IOF
 W !?10,"HL7 Message Text"
 w !?10,"---------------------------------"
 I MTYPE=1 D DM1
 I MTYPE=2 D DM2
 D PAUSE
 Q
 ;
DM1 ;
 N X,Y,Z
 S LINE=2
 S X=$O(^HLMA("B",IEN,0))
 W !,$E($G(^HLMA(X,"MSH",1,0)),1,80)
 S X=0
 F  S X=$O(^HL(772,IEN,"IN",X)) Q:'X  S Y=^(X,0) D
 .S LINE=LINE+1
 .D LINE:(LINE#20=0)
 .W !,$E(Y,1,80)
 Q
 ;
DM2 ;
 N X,Y,Z
 S LINE=0
 S X=0
 F  S X=$O(^INTHU(IEN,3,X)) Q:'X  S Y=^(X,0) D
 .S LINE=LINE+1
 .D LINE:(LINE#20=0)
 .W !,$E(Y,1,80)
 Q
 ;
ACCS ;DIS MSG ENT AN
 K DIR
 S DIR(0)="SO^E:Enter Missing Accession Number;D:Display HL7 Message"
 S DIR("A")="Which option"
 D DIR
 Q:QUIT
 I "ED"'[X W !!,"Select either 'E' to Enter missing Accession Number or 'D' to Display the HL7 message."  G ACCS
 I X="E" D ACCNUM Q
 I X="D" D DMESS(IEN) Q
 Q
 ;
