AGEL4 ; IHS/ASDS/EFG - Add/Edit Eligibility PART 4 ;   [ 06/04/2003  8:34 AM ]
 ;;7.0;IHS PATIENT REGISTRATION;**1,2,4**;MAY 21, 2004
 ;
 ; IHS/SD/SDR - 7/18/2002 - Split lines for readability
 ;
COV ;EP - PROMPT FOR COVERAGE TYPE
 S DIC("S")="I $P(^(0),U,2)=AGELP(""INS"")"
 S DIC("DR")=".02////"_AGELP("INS")
 S DIE="^AUPN3PPH("
 S DR=".05[6] Select COVERAGE TYPE: ",DA=AGELP("PH")
 D ^DIE
 K DIC
 Q:$P(^AUPN3PPH(AGELP("PH"),0),U,5)=""!$D(Y)
 S AGEL("COV")=$P(^AUPN3PPH(AGELP("PH"),0),U,5)
 Q
 ;
H14 ; EP
 S AGEL("OLDN")=$P(^AUTNEMPL(0),U,4)
 S DIE="^AUPN3PPH("
 S DR=".16[14] Select EMPLOYER: "
 S DA=AGELP("PH")
 D ^DIE
 Q:$P(^AUPN3PPH(AGELP("PH"),0),U,16)=""!$D(Y)  S AGEL("DFN")=$P(^(0),U,16)
 Q:$P(^AUTNEMPL(0),U,4)=AGEL("OLDN")
 ;
EMPL S DIE="^AUTNEMPL(",DA=AGEL("DFN")
 W !!,"<---------EDIT EMPLOYER DEMOGRAPHICS--------->"
 S DR=".02 Street...: ;.03 City.....: ;.04 State....: "
 S DR=DR_";.05 Zip......: ;.06 Phone....: "
 D ^DIE
 Q
 ;
P14 S AGEL("OLDN")=$P(^AUTNEMPL(0),U,4)
 ;S DIE="^AUPNPAT("  ; IHS/SD/EFG  AG*7*2  #5
 ;S DR=".19[14] Select EMPLOYER: ",DA=AGELP("PHPAT")  IHS/SD/EFG  AG*7*2  #5
 S DIE="^AUPN3PPH("  ; IHS/SD/EFG  AG*7*2  #5
 S DR=".16[14] Select EMPLOYER: ",DA=AGELP("PH")  ; IHS/SD/EFG  AG*7*2  #5
 D ^DIE
 ;Q:$P(^AUPNPAT(AGELP("PHPAT"),0),U,19)=""!$D(Y)  S AGEL("DFN")=$P(^(0),U,19)  ; IHS/SD/EFG  AG*7*2  #5
 Q:$P(^AUPN3PPH(AGELP("PH"),0),U,16)=""!$D(Y)  S AGEL("DFN")=$P(^(0),U,16)  ; IHS/SD/EFG  AG*7*2  #5
 Q:$P(^AUTNEMPL(0),U,4)=AGEL("OLDN")
 G EMPL
 ;
GRP ;EP - PROMPT FOR GROUP FIELDS
 S AGEL("OLDN")=$P(^AUTNEGRP(0),U,4)
 S DIE="^AUPN3PPH(",DR=".06[5] Select GROUP NAME: ",DA=AGELP("PH") D ^DIE
 Q:$P(^AUPN3PPH(AGELP("PH"),0),U,6)=""!$D(Y)  S AGEL("EGRP")=$P(^AUPN3PPH(AGELP("PH"),0),U,6)
 Q:$P(^AUTNEGRP(0),U,4)=AGEL("OLDN")
 W ! S DIE="^AUTNEGRP(",DA=AGEL("EGRP")
 W !!?5 W "NOTE: Some Insurers assign different Group Numbers based upon the",!?11,"particular type of visit (dental, outpatient, etc.) that",!?11,"occurred."
 W ! K DIR S DIR("B")="N",DIR(0)="Y",DIR("A")="Do the Group Numbers vary depending on Visit Type (Y/N)"
 S DIR("B")=$S($D(^AUTNEGRP(AGEL("EGRP"),11)):"Y",1:"N") D ^DIR
 ;Q:$D(DUOUT)!$D(DTOUT)  W !
 Q:$D(DTOUT)!(Y="^")  W !
 I Y=0 S DIE="^AUTNEGRP(",DA=AGEL("EGRP"),DR=".02R~[5a] Group Number.....: " D ^DIE K ^AUTNEGRP(AGEL("EGRP"),11) Q
 S DA=AGEL("EGRP"),DIE="^AUTNEGRP(",DR="11" D ^DIE
 Q
CARDCOPY ; EP
 ;I $G(AGINSPTR)'="" S DA=AGINSPTR  ;IHS/SD/TPF AG*7.0*4  5/12/2004
 ;E  S DA=AGELP("INS")  ;IHS/SD/TPF AG*7.0*4  5/12/2004
 S DA=AGEL("IN")    ;IHS/SD/TPF AG*7.0*4 5/12/2004
 ; N DIC,DIE,DA  ; IHS/SD/EFG  AG*7*2  #5
 S DA(1)=DFN
 ; S DA=D0  ; IHS/SD/EFG  AG*7*2  #5
 S DIE="^AUPNPRVT("_DA(1)_",11,"
 S DR=".15[7] Card Copy on file: "
 D ^DIE
 I X="Y" D
 .S DR=".16 Date CC obtained..: "
 .;I $G(AGINSPTR)'="" S DA=AGINSPTR   ;IHS/SD/TPF AG*7.0*4 5/12/2004
 .;E  S DA=AGELP("INS")  ;IHS/SD/TPF AG*7.0*4  5/12/2004
 .D ^DIE
 K DIE
 Q
PRECERT ; EP
 I $G(AUPNPAT)="" S AUPNPAT=AGELP("PDFN")  ;  IHS/SD/EFG  AG*7*1  6/4/03
 S DIC="^AUPNPCRT("
 S DIC(0)="AELQMZ"
 S DIC("S")="I $P($G(^AUPNPCRT(Y,0)),U,2)=$G(AUPNPAT)"
 S DIC("A")="[8] Pre-Certification #.:"
 S DIC("DR")=".02////^S X=AUPNPAT"  ; IHS/SD/EFG  AG*7*2  #5
 D ^DIC
 K DIC("S")
 Q:Y<0
 S DIE=DIC
 S DA=+Y,AGPCIEN=Y
 ;S DR=".02////"_AUPNPAT_";.03 Pre-cert Date.: "  ; IHS/SD/EFG  AG*7*2  #5
 S DR=".03 Pre-cert Date.: ;.04"  ; IHS/SD/EFG  AG*7*2  #5
 D ^DIE
 K DIC,DIE
 Q
PCCONTAC ; EP
 Q:$G(AGPCIEN)=""
 S DIE="^AUPNPCRT("
AG S DR=".04[9] Pre-cert Contact: "
 S DA=+AGPCIEN
 D ^DIE
 K DIE
 Q
PCP ; EP
 S DIE="^AUPNPRVT("_DFN_",11,"
 S DR=".14[10] Primary Care Provider: "
 I $G(AGINSPTR)'="" S DA=AGINSPTR
 D ^DIE
 K DIE
 Q
