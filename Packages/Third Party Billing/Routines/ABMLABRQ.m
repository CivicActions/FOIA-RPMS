ABMLABRQ ; IHS/SD/SDR - Require lab results by insurer ;  
 ;;2.6;IHS Third Party Billing;**3,29**;NOV 12, 2009;Build 562
 ;IHS/SD/SDR 2.6*29 CR10404 Added CLIA# Req'd prompt; rewrote CPT prompts part to make prompt text be what I wanted;
 ;   Updated help text to be more accurate
 ;
EN ;EP
 W !!?5,"An insurer and a list of CPT/HCPCS codes will be prompted for."
 ;start old abm*2.6*29 IHS/SD/SDR CR10404
 ;W !?5,"Any codes entered for that insurer will require that a lab result be"
 ;W !?5,"entered.  If no result is entered, an error will display in the claim"
 ;W !?5,"editor.",!!
 ;end old start new abm*2.6*29 IHS/SD/SDR CR10404
 W !?5,"Any codes entered for that insurer can be set up to require:"
 W !?8,"- Results for the lab being performed"
 W !?8,"- A CLIA number to be included on the claim"
 W !?5,"This information, when present on a claim, will populate in the "
 W !?5,"837P electronic export file.",!!
 ;end new abm*2.6*29 IHS/SD/SDR CR10404
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
 ;W !!?2,"Current Codes",?18,"Req'd?"  ;abm*2.6*29 IHS/SD/SDR CR10404
 ;start new abm*2.6*29 IHS/SD/SDR CR10404
 W !!?1,"Current",?10,"Results",?20,"CLIA"
 W !?2,"Codes",?10,"Req'd?",?19,"Req'd?"
 I DUZ(0)="@" W ?29,"CPT IEN"
 S ABMCNT=0
 ;end new abm*2.6*29 IHS/SD/SDR CR10404
 S ABMCPT=0
 F  S ABMCPT=$O(^ABMNINS(DUZ(2),ABMP("INS"),4,ABMCPT)) Q:+ABMCPT=0  D
 .S ABMCNT=+$G(ABMCNT)+1
 .;W !?2,$P($G(^ABMNINS(DUZ(2),ABMP("INS"),4,ABMCPT,0)),U),?18,$S($P($G(^ABMNINS(DUZ(2),ABMP("INS"),4,ABMCPT,0)),U,2)="Y":"YES",1:"NO")  ;abm*2.6*29 IHS/SD/SDR CR10404
 .;start new abm*2.6*29 IHS/SD/SDR CR10404
 .W !?2,$P($G(^ICPT($P(^ABMNINS(DUZ(2),ABMP("INS"),4,ABMCPT,0),U),0)),U)
 .W ?12,$S($P($G(^ABMNINS(DUZ(2),ABMP("INS"),4,ABMCPT,0)),U,2)="Y":"YES",1:"NO")
 .W ?21,$S($P($G(^ABMNINS(DUZ(2),ABMP("INS"),4,ABMCPT,0)),U,3)="Y":"YES",1:"NO")
 .I DUZ(0)="@" W ?29,$P(^ABMNINS(DUZ(2),ABMP("INS"),4,ABMCPT,0),U)
 .;end new abm*2.6*29 IHS/SD/SDR CR10404
 W !
 I +$G(ABMCNT)=0 W !?3,"No entries at this time"
 ;W !  ;abm*2.6*29 IHS/SD/SDR CR10404
 ;
 ;prompt for new codes
 F  D  Q:+$G(Y)<0
 .W !!  ;abm*2.6*29 IHS/SD/SDR CR10404
 .K DIC,DIE,DIR,X,Y,DA
 .S DA(1)=ABMP("INS")
 .S DIC(0)="AEQLM"
 .S DIC="^ABMNINS("_DUZ(2)_","_DA(1)_",4,"
 .S DIC("A")="Enter CPT/HCPCS codes: "
 .S DIC("P")=$P(^DD(9002274.09,4,0),U,2)
 .;start old abm*2.6*29 IHS/SD/SDR CR10404
 .;S DIC("DR")="W !!;.02RESULTS REQ'D FOR INSURER?"
 .;S DIC("DR")=DIC("DR")_";.03SEND CLIA NUMBER WITH THIS CODE?"  ;abm*2.6*29 IHS/SD/SDR CR10404
 .;D ^DIC
 .;Q:Y<0
 .;S ABMIEN=Y
 .;I $P(ABMIEN,U,3)'=1 D
 .;.K DIC,DIE,DIR,X,Y,DA
 .;.S DA(1)=ABMP("INS")
 .;.S DA=+ABMIEN
 .;.S DIE="^ABMNINS("_DUZ(2)_","_DA(1)_",4,"
 .;.;S DR=".01//;.02//"  ;abm*2.6*29 IHS/SD/SDR CR10404
 .;.S DR=".01//;W !;.02    RESULTS REQ'D FOR THIS INSURER;.03    SEND CLIA NUMBER WITH THIS CODE"  ;abm*2.6*29 IHS/SD/SDR CR10404
 .;.D ^DIE
 .;end old start new abm*2.6*29 IHS/SD/SDR CR10404
 .D ^DIC
 .Q:Y<0
 .S ABMIEN=Y
 .K DIC,DIE,DIR,X,Y,DA
 .S DA(1)=ABMP("INS")
 .S DA=+ABMIEN
 .S DIE="^ABMNINS("_DUZ(2)_","_DA(1)_",4,"
 .S DR=".01CPT/HCPCS code//;W !;.02    RESULTS REQ'D FOR THIS INSURER//;.03    SEND CLIA NUMBER WITH THIS CODE//"
 .D ^DIE
 .;end new abm*2.6*29 IHS/SD/SDR CR10404
 Q
