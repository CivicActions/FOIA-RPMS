ABMDCOPN ; IHS/SD/SDR - RE-OPEN COMPLETED CLAIM ;
 ;;2.6;IHS 3P BILLING SYSTEM;**9,33,34,37,38**;NOV 12, 2009;Build 756
 ;
 ;IHS/SD/SDR 2.5*12 UFMS If user isn't logged into cashiering session they can't do this option
 ;
 ;IHS/SD/SDR 2.6*33 ADO60185 CR12178 Added preferred name to display
 ;IHS/SD/SDR 2.6*34 ADO60696 CR7333 Updated so user can exit without entering closed reason, but it
 ; also won't close the claim, leaving it in an open status.  NOTE: claim editor is calling tag CLOSE
 ; for the menu 'Close' option, so they both work the same.
 ;IHS/SD/SDR 2.6*37 ADO81491 Updated preferred name PPN to use XPAR site parameter
 ;IHS/SD/SRD 2.6*38 ADO99134 Added S DIC("W") within FOR loop so standard data would show up
 ;
START ;START
 ;start new code abm*2.6*9 NOHEAT - ensure UFMS is setup
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)="" D  Q
 .W !!,"* * UFMS SETUP MUST BE DONE BEFORE ANY BILLING FUNCTIONS CAN BE USED! * *",!
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;end new code
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 S DIC="^ABMDCLM(DUZ(2),",DIE=DIC,DIC(0)="AEMQ"
 S DIC("W")="S Z=$P($G(^ABMDCLM(DUZ(2),+Y,0)),""^"") W !?10 D DICW^ABMDECLN"  ;abm*2.6*37 IHS/SD/SDR ADO81491
 F  D  Q:$G(ABM("QUIT"))
 .W !
 .S DIC("W")="S Z=$P($G(^ABMDCLM(DUZ(2),+Y,0)),""^"") W !?10 D DICW^ABMDECLN"  ;abm*2.6*38 IHS/SD/SDR ADO99134
 .D ^DIC I Y<0 S ABM("QUIT")=1 Q
 .S ABM("C#")=+Y
 .;start new abm*2.6*33 IHS/SD/SDR ADO60185
 .S ABMPDFN=$P($G(^ABMDCLM(DUZ(2),ABM("C#"),0)),U)
 .;I $$GETPREF^AUPNSOGI(ABMPDFN,"")'="" D  ;abm*2.6*37 IHS/SD/SDR ADO81491
 .I $$GETPREF^AUPNSOGI(ABMPDFN,"I",1)'="" D  ;abm*2.6*37 IHS/SD/SDR ADO81491
 ..;W !?5,$$EN^ABMVDF("RVN"),"* - ",$$GETPREF^AUPNSOGI(ABMPDFN,""),$$EN^ABMVDF("RVF")  ;abm*2.6*37 IHS/SD/SDR ADO81491
 .;end new abm*2.6*33 IHS/SD/SDR ADO60185
 .S ABM("CSTATUS")=$P(^ABMDCLM(DUZ(2),ABM("C#"),0),"^",4)
 .S ABM("SNAR")=$F("FERUCX",ABM("CSTATUS"))
 .S ABM("SNAR")=$P("^Flagged as Billable^Edit Mode^Claim Rejected^Uneditable (Billed)^Complete^Closed","^",ABM("SNAR"))
 .W !,"Current Claim Status is: ",ABM("SNAR")
 .I ABM("CSTATUS")="U" W *7," ??" Q
 .I ABM("CSTATUS")="X"!(ABM("CSTATUS")="C") D OPEN  ;CLOSED OR COMPLETE
 .I ABM("CSTATUS")'="X"&(ABM("CSTATUS")'="C") D CLOSE  ;CLOSED OR COMPLETE
 K DIC,ABM Q
OPEN ;OPEN CLOSED CLAIM
 S DIR(0)="Y",DIR("A")="Re-Open Claim",DIR("B")="NO" D ^DIR K DIR
 Q:Y'=1
 S DA=ABM("C#"),DR=".04///E" D ^DIE
 N DA,DIC,DIE,X,Y,DIR
 S DA(1)=ABM("C#")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",69,"
 S DIC("P")=$P(^DD(9002274.3,69,0),U,2)
 S DIC(0)="L"
 S X="NOW"
 S DIC("DR")=".02////"_DUZ_";.03////O"
 D ^DIC
 W !!,"Claim # ",ABM("C#")," now in Edit Mode.",!
 Q
CLOSE ;CLOSE OPEN CLAIM
 S DIR(0)="Y",DIR("A")="Change Status to Closed",DIR("B")="NO" D ^DIR K DIR
 Q:Y'=1
 ;start old abm*2.6*34 IHS/SD/SDR ADO60696
 ;S DA=ABM("C#"),DR=".04///X" D ^DIE
 ;N DA,DIC,DIE,X,Y,DIR
 ;S DA(1)=ABM("C#")
 ;S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",69,"
 ;S DIC("P")=$P(^DD(9002274.3,69,0),U,2)
 ;S DIC(0)="L"
 ;S X="NOW"
 ;S DIC("DR")=".02////"_DUZ_";.03////C"
 ;D ^DIC
 ;S ABMANS=Y
 ;K DIC,DIE,X,Y,DIR,DA,DR
 ;S DA(1)=ABM("C#")
 ;S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",69,"
 ;S DA=+ABMANS
 ;S DR=".04R"
 ;S DIE("NO^")=""
 ;D ^DIE
 ;end old start new abm*2.6*34 IHS/SD/SDR ADO60696
 N DA,DIC,DIE,X,Y,DIR
 S DIC="^ABMCLCLM("
 S DIC(0)="AEMQ"
 S DIC("A")="CLOSED REASON:"
 D ^DIC
 I +Y<1 W !!,"<Claim "_ABM("C#")_" not closed>" H 2 Q
 S ABMANS=+Y
 S DA(1)=ABM("C#")
 S DIC="^ABMDCLM(DUZ(2),"_DA(1)_",69,"
 S DIC("P")=$P(^DD(9002274.3,69,0),U,2)
 S DIC(0)="L"
 S X="NOW"
 S DIC("DR")=".02////"_DUZ_";.03////C;.04////"_ABMANS
 D ^DIC
 S DIE="^ABMDCLM(DUZ(2),",DA=ABM("C#"),DR=".04///X" D ^DIE
 ;end new abm*2.6*34 IHS/SD/SDR ADO60696
 W !!,"Claim # ",ABM("C#")," Now in Status Closed.",!
 Q
