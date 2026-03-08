ABMDE0 ; IHS/ASDST/DMJ - Claim Summary Page ; 10 Nov 2009  2:48 PM
 ;;2.6;IHS 3P BILLING SYSTEM;**29,34**;NOV 12, 2009;Build 645
 ;
 ;IHS/ASDS/LSL 08/13/2001 2.4*9 NOIS HQW-0798-100082 If all insurers are unbillable - ask if delete claim
 ;
 ;IHS/SD/SDR 2.5*8 Fix supplied by Carlene McIntyre for OmniCell link
 ;IHS/SD/SDR,TPF 2.5*8 added code for pending status (12)
 ;IHS/SD/SDR 2.5*8 task 57 Added code for Rx changes (dt disc. and RTS)
 ;IHS/SD/SDR 2.5*8 task 5 Added code for CLIA number to populate on claims if none on claim and default is present
 ;IHS/SD/SDR 2.5*9 per Adrian -Only display meds check if claim status isn't Uneditable or Complete
 ;IHS/SD/SDR 2.5*11 IM22787 Modified so future term date for replacement insurer will work
 ;
 ;IHS/SD/SDR 2.6*29 CR10404 Made so CLIA number will only populate on the claim automatically when claim is Flagged As Billable;
 ;  Sites were deleting it and then it was adding it back on erroneously
 ;IHS/SD/SDR 2.6*34 ADO60696 CR7333 Added Close option to menu.  It will only display if the user has security key
 ;  ABMDZ CE CLOSE CLAIM.  Also changed pending to work same as closed, so if the user '^' out, they will get a message
 ;  the claim isn't pended and put them back on page 0 of the claim editor.
 ;*********************************************************************
 ;
OPT K ABM,ABMV,ABME,ABMZ
 G XIT:$D(ABMP("DDL")),CONT:$G(ABMP("OPT"))="V"
 W !!?15,"...<< Processing, Claim Error Checks >>..."
 S ABMP("GL")="^ABMDCLM(DUZ(2),"_ABMP("CDFN")_","
 S ABMC("QUE")=2
 S ABMC("E0")=""
 D ERRIN^ABMDECK
 D ^ABMDE1X
 D TPICHECK^ABMDE1
 N I F I=106,107,108,10,102,12,13,6,151,152,153,109 D
 . Q:'$D(ABME(I))
 . S ABMP("JUMP1")=0
 K ABME,ABMC,ABMP("CHK"),ABMP("DDL")
 G CONT:$P($G(ABMP("STATUS")),U)=1
 D PCC
 G:$G(ABMNOPCC) XIT
 D ELIG
 G:$G(ABMNOELG) XIT
 S $P(ABMP("STATUS"),U)=1
 D D2^ABMDE8X  ;build array of Rxs from V Med file/23 multiple
 ;this checks to see if drugs are RTS or discontinued
 S ABMRXIEN=0,ABMRXFLG=0
 F  S ABMRXIEN=$O(ABMMEDS(ABMRXIEN)) Q:+ABMRXIEN=0  D  Q:ABMRXFLG=1
 .I $P($G(ABMMEDS(ABMRXIEN)),U,3)'="",('$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,"B",ABMRXIEN))) S ABMRXFLG=1
 .I $P($G(ABMMEDS(ABMRXIEN)),U,4)'="",('$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,"B",ABMRXIEN))) S ABMRXFLG=1
 I ABMRXFLG=1 D PUTMEDS
 D D2^ABMDE8X
 ;
CONT ; EP
 D OPEN^ABMDTMS(+$G(ABMP("PDFN")),+$G(ABMP("CDFN")))  ;OmniCell call
 D CLIACHK
 D ^ABMDE0X
 W $$EN^ABMVDF("IOF")
 S ABMP("OPT")="VCFNJQ"
 ;start new abm*2.6*34 IHS/SD/SDR ADO60696
 S ABMBTCK=0
 S ABMBTKEY=$O(^DIC(19.1,"B","ABMDZ CE CLOSE CLAIM",0))
 I +$G(ABMBTKEY)'=0 I $G(^VA(200,DUZ,51,ABMBTKEY,0))'="" S ABMBTCK=1
 I ABMBTCK=1 S ABMP("OPT")="VCFLNJQ"
 ;end new abm*2.6*34 IHS/SD/SDR ADO60696
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,4)="U"!($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,4)="X") D
 . S ABMP("OPT")="VNJQ"
 . S ABMP("DFLT")="Q"
 . S ABMP("VIEWMODE")=1
 D DISP^ABMDE0A
 W !
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)="P" D
 .W !
 .W "Pending for "
 .W $P($G(^ABMPSTAT($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,18),0)),U)  ;status
 .W " by "_$P($G(^VA(200,$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,19),0)),U,2)  ;new person inits
 .W !
 D SEL^ABMDEOPT
 ;I "CFV"'[$E(Y) G XIT  ;abm*2.6*34 IHS/SD/SDR ADO60696
 I "CFLV"'[$E(Y) G XIT  ;abm*2.6*34 IHS/SD/SDR ADO60696
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 K ABM,ABMZ
 I $E(X)="V" D  G OPT
 .D ^ABMDECK
 .S ABMP("SCRN")=0
 .K DUOUT,DTOUT,DIRUT,DIROUT
 .S ABMP("OPT")="V"
 I $E(X)="C"!($E(X)="A") D ^ABMDEOK G XIT:$D(ABMP("OVER")),OPT
 ;I $E(X)="F" D  S Y="Q" G XIT  ;abm*2.6*34 IHS/SD/SDR ADO60696
 I $E(X)="F" D  I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)'="P" S Y="F" G XIT  ;abm*2.6*34 IHS/SD/SDR ADO60696
 .D EN^ABMSTAT($G(ABMP("CDFN")))
 .S ABMP("SCRN")=0
 .K DUOUT,DTOUT,DIRUT,DIROUT
 .S ABMP("OPT")="V"
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)'="P" W !!,"<Claim "_ABMP("CDFN")_" not pended>",! H 2  ;abm*2.6*34 IHS/SD/SDR ADO60696
 .S Y="F"  ;abm*2.6*34 IHS/SD/SDR ADO60696
 ;start new abm*2.6*34 IHS/SD/SDR ADO60696
 I "Ll"[$E(Y) D  G XIT  ;L=Close Claim
 .S ABM("C#")=ABMP("CDFN")
 .K Y
 .D CLOSE^ABMDCOPN  ;this is the OCMG code to close, so they work exactly the same
 .K DUOUT,DTOUT,DIRUT,DIROUT,ABM,ABMZ
 .I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)'="X" S Y="L" Q  ;they choose not to close the claim, go back to page 0
 .S Y="Q"  ;this causes it to go to the Select CLAIM or PATIENT: prompt
 ;end new abm*2.6*34 IHS/SD/SDR ADO60696
 ;
XIT ;
 I $G(ABMP("JUMP1")) D
 .S ABMP("SCRN")=1
 .K ABMP("JUMP1")
 K ABM,ABMV,ABME,ABMZ
 Q
 ;
 ; *********************************************************************
ELIG ;EP - CHECK ELIGIBILITY
 K ABMNOELG
 W !!?8,"...<< Checking Eligibility Files for Potential Coverage >>...",!!
 D ^ABMDE2E
 N INSGOOD,INS
 S (INSGOOD,INS)=0
 F  S INS=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,INS)) Q:'+INS  D
 .S:$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,INS,0)),U,3)'="U" INSGOOD=1
 I '+INSGOOD D
 .D ^ABMDE0X
 .D DISP^ABMDE0A
 .W !?3,$$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF")
 .W " CANNOT OPEN CLAIM - NO ELIGIBILITY FOUND FOR THIS PATIENT.",!
 .D ENT2^ABMDECAN
 .S Y="Q"
 .S ABMNOELG=1
 Q
PCC ;check pcc primary visit         
 K ABMNOPCC
 Q:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,"AC","P"))
 N I
 S I=0
 F  S I=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,"AC","P",I)) Q:'I  D
 .Q:$P($G(^AUPNVSIT(I,0)),"^",11)
 .S ABMPRI=I
 Q:$G(ABMPRI)
 D ^ABMDE0X
 D DISP^ABMDE0A
 W !?3,$$EN^ABMVDF("RVN"),"NOTE:",$$EN^ABMVDF("RVF")
 W " THE PRIMARY PCC VISIT FOR THIS CLAIM HAS BEEN DELETED.",!
 D ENT2^ABMDECAN
 S Y="Q"
 S ABMNOPCC=1
 Q
PUTMEDS ;
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)="C"!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)="U") Q
 W !!,"             * * * * * * M E D I C A T I O N  A L E R T * * * * * *"
 W !!
 K DD,DO,DIE,DIC,DIR
 S DIR("A")="DO YOU WISH TO INCLUDE THOSE ENTRIES ON PAGE 8D"
 S DIR("A",1)="MEDICATIONS WITH A 'DATE DISCONTINUED' OR 'RETURN TO STOCK' ENTRY HAVE BEEN"
 S DIR("A",2)="IDENTIFIED."
 S DIR("A",3)=""
 S DIR(0)="Y"
 S DIR("B")="N"
 D ^DIR K DIR
 I Y=1 D
 .S ABMRXFLG=1
 .S ABMVIEN=0
 .F  S ABMVIEN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,ABMVIEN)) Q:+ABMVIEN=0  D
 ..S ABMP("V0")=$G(^AUPNVSIT(ABMVIEN,0))
 ..D ^ABMDVST5 ;they want to include all meds on claim
 K ABMMEDS,ABMRXFLG,ABMVIEN
 Q
CLIACHK ;
 ;reference
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,4)'="F" Q  ;abm*2.6*29 IHS/SD/SDR CR10404
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,23)="" D  ;ref lab CLIA
 .K DIE,DA,DR
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".923////"_$P($G(^ABMDPARM(DUZ(2),1,4)),U,12)
 .D ^DIE
 ;in-house
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),9)),U,22)="" D  ;in-house CLIA
 .K DIE,DA,DR
 .S DIE="^ABMDCLM(DUZ(2),"
 .S DA=ABMP("CDFN")
 .S DR=".922////"_$P($G(^ABMDPARM(DUZ(2),1,4)),U,11)
 .D ^DIE
 Q
