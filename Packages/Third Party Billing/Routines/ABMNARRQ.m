ABMNARRQ ; IHS/SD/SDR - Require Narrative by insurer ;  
 ;;2.6;IHS Third Party Billing;**9,28,29**;NOV 12, 2009;Build 562
 ;IHS/SD/SDR 2.6*28 CR10648 Added prompt USE CPT DESCRIPTION
 ;IHS/SD/SDR 2.6*29 CR10669 Fixed CPT prompt so it will only let them choose from active CPT; if the INACTIVE FLAG is populated it will
 ;   screen those entries out
 ;
EN ;EP
 W !!?5,"An insurer and a list of CPT/HCPCS codes will be prompted for."
 W !?5,"Any codes entered for that insurer will send a NARRATIVE of "
 W !?5,"""NOT OTHERWISE CLASSIFIED"" in the 5010 Professional/Institutional"
 W !?5,"export.  If no narrative is entered, an error will display in the claim"
 ;W !?5,"editor.",!!  ;abm*2.6*28 IHS/SD/SDR CR10648
 W !?5,"editor.  You will also have the option to select the CPT description"  ;abm*2.6*28 IHS/SD/SDR CR10648
 W !?5,"as the narrative being sent.",!!  ;abm*2.6*28 IHS/SD/SDR CR10648
 ;
SELINS ;select insurer
 K DIC,DIE,DIR,X,Y,DA
 S DIC="^AUTNINS("
 S DIC(0)="AEQM"
 S DIC("A")="Select INSURER: "
 D ^DIC
 Q:$D(DUOUT)!$D(DTOUT)
 I +Y<0 G SELINS
 S ABMP("INS")=+Y
 ;
 ;For selected insurer, display list of CPTs (if any) entered w/status
 ;W !!?2,"Current Codes",?18,"Req'd?"  ;abm*2.6*28 IHS/SD/SDR CR10648
 W !!?2,"Current Codes",?18,"Req'd?",?27,"Use CPT Desc?"  ;abm*2.6*28 IHS/SD/SDR CR10648
 S ABMCPT=0
 F  S ABMCPT=$O(^ABMNINS(DUZ(2),ABMP("INS"),5,ABMCPT)) Q:+ABMCPT=0  D
 .S ABMCNT=+$G(ABMCNT)+1
 .W !?2,$P($$CPT^ABMCVAPI($P($G(^ABMNINS(DUZ(2),ABMP("INS"),5,ABMCPT,0)),U),DT),U,2)
 .W ?18,$S($P($G(^ABMNINS(DUZ(2),ABMP("INS"),5,ABMCPT,0)),U,2)="Y":"YES",1:"NO")
 .I $P($G(^ABMNINS(DUZ(2),ABMP("INS"),5,ABMCPT,0)),U,3)="Y" W ?27,"YES"  ;abm*2.6*28 IHS/SD/SDR CR10648
 W !
 I +$G(ABMCNT)=0 W !?3,"No entries at this time"
 W !
 ;
 ;prompt for new codes
 F  D  Q:+$G(Y)<0
 .;start old abm*2.6*29 IHS/SD/SDR CR10669
 .;K DIC,DIE,DIR,X,Y,DA
 .;S DA(1)=ABMP("INS")
 .;S DIC(0)="AEQLM"
 .;S DIC="^ABMNINS("_DUZ(2)_","_DA(1)_",5,"
 .;S DIC("A")="Enter CPT/HCPCS codes: "
 .;S DIC("P")=$P(^DD(9002274.09,5,0),U,2)
 .;;S DIC("DR")=".02"  ;abm*2.6*28 IHS/SD/SDR CR10648
 .;S DIC("DR")=".02;.03"  ;abm*2.6*28 IHS/SD/SDR CR10648
 .;D ^DIC
 .;Q:Y<0
 .;S ABMIEN=Y
 .;I $P(ABMIEN,U,3)'=1 D
 .;.K DIC,DIE,DIR,X,Y,DA
 .;.S DA(1)=ABMP("INS")
 .;.S DA=+ABMIEN
 .;.S DIE="^ABMNINS("_DUZ(2)_","_DA(1)_",5,"
 .;.;S DR=".01//;.02//"  ;abm*2.6*28 IHS/SD/SDR CR10648
 .;.S DR=".01//;.02//;.03//"  ;abm*2.6*28 IHS/SD/SDR CR10648
 .;.D ^DIE
 .;end old start new abm*2.6*29 IHS/SD/SDR CR10669
 .D ^XBFMK
 .S DIC="^ICPT("
 .S DIC(0)="AEQI"
 .S DIC("S")="I $$CHKCPT^ABMDUTL(+Y)'=0"
 .D ^DIC
 .Q:(+Y<0)!$D(DTOUT)!$D(DIROUT)!$D(DIRUT)
 .S ABMIEN=Y
 .D ^XBFMK
 .S DA(1)=ABMP("INS")
 .S DIC(0)="L"
 .S DIC="^ABMNINS("_DUZ(2)_","_DA(1)_",5,"
 .S X="`"_+ABMIEN
 .S DIC("P")=$P(^DD(9002274.09,5,0),U,2)
 .D ^DIC
 .S ABMIEN=Y
 .D ^XBFMK
 .S DA(1)=ABMP("INS")
 .S DA=+ABMIEN
 .S DIE="^ABMNINS("_DUZ(2)_","_DA(1)_",5,"
 .S DR=".01//;.02//;.03//"
 .D ^DIE
 ;end new abm*2.6*29 IHS/SD/SDR CR10669
 Q
