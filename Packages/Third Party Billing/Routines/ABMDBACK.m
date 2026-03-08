ABMDBACK ; IHS/ASDST/DMJ - APC-PCC Back Visit Check ;
 ;;2.6;IHS 3P BILLING SYSTEM;**35,36**;NOV 12, 2009;Build 698
 ;Original;TMD;08/05/96 4:25 PM
 ;IHS/SD/SDR 2.6*35 ADO60700 Record who did backbill check and when; updated backbill check to only do the one visit location
 ;  it was done for, not all locations; updated the prompt so user has a second chance to say NO
 ;IHS/SD/SDR 2.6*36 ADO76874 Backbilling check won't requeue a visit if there's a cancelled claim associated with it;
 ;  Added end date so it will check for a date range; Made it so a future date can't be added and the end date has to be after the start date
 ;
 S U="^" K ABM
 D EDIT^ABMCGAPI(ABMCGIEN,"BKMG")  ;abm*2.6*35 IHS/SD/SDR ADO60700
PCC ;
 ;S (ABM("BD"),ABM("D"))=$P(^ABMDPARM(DUZ(2),1,0),U,19)-.01 F  S ABM("D")=$O(^AUPNVSIT("B",ABM("D"))) Q:'ABM("D")  D  ;abm*2.6*36 IHS/SD/SDR ADO76874
 S (ABM("BD"),ABM("D"))=$P(^ABMDPARM(DUZ(2),1,0),U,19)-.01  ;abm*2.6*36 IHS/SD/SDR ADO76874
 S ABM("ED")=$P(^ABMDPARM(DUZ(2),1,0),U,23)+.999999  ;back bill check end date  ;abm*2.6*36 IHS/SD/SDR ADO76874
 F  S ABM("D")=$O(^AUPNVSIT("B",ABM("D"))) Q:'ABM("D")!(ABM("D")>ABM("ED"))  D  ;abm*2.6*36 IHS/SD/SDR ADO76874
 .S ABM("VDFN")="" F  S ABM("VDFN")=$O(^AUPNVSIT("B",ABM("D"),ABM("VDFN"))) Q:'ABM("VDFN")  D
 ..I $P($G(^AUPNVSIT(ABM("VDFN"),0)),U,6)'=DUZ(2) Q  ;only requeue visits for this location, not all locations  ;abm*2.6*35 IHS/SD/SDR/ADO60700
 ..;I ABM("D")>ABM("BD"),'$D(^ABMDCLM(DUZ(2),"AV",ABM("VDFN"))) S ^AUPNVSIT("ABILL",$P(ABM("D"),"."),ABM("VDFN"))=""  ;abm*2.6*35 IHS/SD/SDR ADO60700
 ..;I ABM("D")>ABM("BD"),'$D(^ABMDCLM(DUZ(2),"AV",ABM("VDFN"))) S ^AUPNVSIT("ABILL",$P(ABM("D"),"."),ABM("VDFN"))="" D VISIT^ABMCGAPI(ABM("VDFN"),ABMCGIEN,"","",1)  ;abm*2.6*35 IHS/SD/SDR ADO60700  ;abm*2.6*36 IHS/SD/SDR ADO76874
 ..I ABM("D")>ABM("BD"),'$D(^ABMDCLM(DUZ(2),"AV",ABM("VDFN"))),'$D(^ABMCCLMS(DUZ(2),"AV",ABM("VDFN"))) S ^AUPNVSIT("ABILL",$P(ABM("D"),"."),ABM("VDFN"))="" D VISIT^ABMCGAPI(ABM("VDFN"),ABMCGIEN,"","",1)  ;abm*2.6*36 IHS/SD/SDR ADO76874
 ;
APC S ABM("D")=$P(^ABMDPARM(DUZ(2),1,0),U,19) S ABM="^AAPCRCDS(""APC"","_ABM("D")_")" F  S ABM=$Q(@ABM),ABM("DT")=$P($P(ABM,"(",2),",",2) Q:ABM("DT")<ABM("D")  I ABM("DT")>ABM("BD") D
 .S ABM("VDFN")=+$P($P(ABM,"(",2),",",5)
 .Q:$D(^ABMDCLM(DUZ(2),"APC",ABM("VDFN")))
 .S ^AAPCRCDS("ABILL",ABM("DT"),ABM("VDFN"))=""
 ;
DEL S DIE="^ABMDPARM(DUZ(2),",DA=1,DR=".19///@" D ^ABMDDIE
 S DIE="^ABMDPARM(DUZ(2),",DA=1,DR=".191////@;.192////@" D ^DIE  ;abm*2.6*35 IHS/SD/SDR ADO60700
 S DIE="^ABMDPARM(DUZ(2),",DA=1,DR=".193////@" D ^DIE  ;abm*2.6*36 IHS/SD/SDR ADO76874
 ;
XIT K ABM
 Q
 ;
SEL ;EP - Entry Point for intiating a back-billing check
 W !!?5,"This program will cause the nightly claim generator to initiate "
 W !?5,"a one time job of checking all visits back to the date specified."
 W !! S DIR(0)="YO",DIR("A")="Do you wish to run this program (Y/N)" D ^DIR K DIR G XIT:$D(DIRUT)!'$G(Y)
 I +$P($G(^ABMDPARM(DUZ(2),1,0)),U,16) S X1=DT,X2=0-($P(^(0),U,16)*30.417) D C^%DTC S ABM("D")=X I 1
 ;E  S ABM("D")=DT-10000  ;abm*2.6*35 IHS/SD/SDR ADO60700
 ;start new abm*2.6*35 IHS/SD/SDR ADO60700
 E  D
 .S X1=DT
 .S X2=-1000
 .D C^%DTC
 .S ABM("D")=X
 ;end new abm*2.6*35 IHS/SD/SDR ADO60700
 D DT
 ;W ! S DIE="^ABMDPARM(DUZ(2),",DA=1,DR=".19Check all Visits back to (Date): //"_ABM("D") D ^ABMDDIE G XIT:$D(Y)!$D(ABM("DIE-FAIL"))  ;abm*2.6*35 IHS/SD/SDR ADO60700
 ;start new abm*2.6*35 IHS/SD/SDR ADO60700
 I +$P($G(^ABMDPARM(DUZ(2),1,0)),U,19)'=0 D  G XIT:$D(DIRUT)!'$G(Y)
 .;W !!?5,"The back-billing check is already set to run for ",$$SDT^ABMDUTL(+$P($G(^ABMDPARM(DUZ(2),1,0)),U,19))  ;abm*2.6*36 IHS/SD/SDR ADO76874
 .W !!?5,"The back-billing check is already set to run for "  ;abm*2.6*36 IHS/SD/SDR ADO76874
 .W !?5,"Date range "_$$SDT^ABMDUTL(+$P($G(^ABMDPARM(DUZ(2),1,0)),U,19))_" thru "_$$SDT^ABMDUTL(+$P($G(^ABMDPARM(DUZ(2),1,0)),U,23))  ;abm*2.6*36 IHS/SD/SDR ADO76874
 .W !?5,"for "_$P($G(^AUTTLOC(DUZ(2),0)),U,2)_" and was set by "_$P($G(^VA(200,$P($G(^ABMDPARM(DUZ(2),1,0)),U,21),0)),U)
 .W !!?5,"If you continue, whatever you enter will override this date"
 .W !?5,"with whatever date you enter"
 .W !! S DIR(0)="YO",DIR("A")="Do you wish to continue (Y/N)" D ^DIR K DIR G XIT:$D(DIRUT)!'$G(Y)
 W !
 S ABMSV=ABM("D")  ;abm*2.6*36 IHS/SD/SDR ADO76874
DTPROMPT ;  ;added line tag  ;abm*2.6*36 IHS/SD/SDR ADO76874
 K X,Y,DIR,DIE,DIC,DA
 S ABM("D")=ABMSV  ;abm*2.6*36 IHS/SD/SDR ADO76874
 ;S DIR(0)="DO"  ;abm*2.6*36 IHS/SD/SDR ADO76874
 S DIR(0)="DO^:DT"  ;abm*2.6*36 IHS/SD/SDR ADO76874
 ;S DIR("A")="Check all Visits back to (Date)"  ;abm*2.6*36 IHS/SD/SDR ADO76874
 S DIR("A")="Check all Visits from (Starting Date)"  ;abm*2.6*36 IHS/SD/SDR ADO76874
 S DIR("B")=ABM("D")
 D ^DIR
 I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) W !?3,"Exiting..backbill check won't be done" H 1 Q
 S ABM("D")=+Y
 ;start new abm*2.6*36 IHS/SD/SDR ADO76874
 S DIR("A")="                      Thru (End Date)"
 S DIR("B")=$$SDT^ABMDUTL(DT)
 D ^DIR
 I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) W !?3,"Exiting..backbill check won't be done" H 1 Q
 S ABM("ED")=+Y
 I ABM("ED")<ABM("D") W !!,"End date cannot be before start date" G DTPROMPT
 ;end new abm*2.6*36 IHS/SD/SDR ADO76874
 ;W !!?3,"BACKBILLING CHECK QUEUED TO RUN FOR "_$P($G(^AUTTLOC(DUZ(2),0)),U,2)_" to "_$$SDT^ABMDUTL(ABM("D"))  ;abm*2.6*36 IHS/SD/SDR ADO76874
 ;start new abm*2.6*36 IHS/SD/SDR ADO76874
 W !!?3,"BACKBILLING CHECK QUEUED TO RUN FOR "_$P($G(^AUTTLOC(DUZ(2),0)),U,2)
 W !?3,"For Date Range "_$$SDT^ABMDUTL(ABM("D"))_" thru "_$$SDT^ABMDUTL(ABM("ED")),!
 ;end new abm*2.6*36 IHS/SD/SDR ADO76874
 K X,Y,DIR,DIE,DIC,DA
 S DIR(0)="Y"
 S DIR("A")="ARE YOU SURE"
 D ^DIR
 I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT)!(Y<1) W !?3,"Exiting..backbill check won't be done" H 1 Q
 S DIE="^ABMDPARM(DUZ(2),"
 S DA=1
 ;S DR=".19////"_ABM("D")  ;abm*2.6*36 IHS/SD/SDR ADO76874
 S DR=".19////"_ABM("D")_";.193////"_ABM("ED")  ;abm*2.6*36 IHS/SD/SDR ADO76874
 D ^DIE
 ;end new abm*2.6*35 IHS/SD/SDR ADO60700
 ;
 S ABM("D")=$P(^ABMDPARM(DUZ(2),1,0),U,19) D DT
 ;W !!,"OK, all visits will be checked back to ",ABM("D")," during the nightly",!,"claim generation process.",!  ;abm*2.6*35 IHS/SD/SDR ADO60700
 ;start new abm*2.6*35 IHS/SD/SDR ADO60700
 ;W !!,"OK, all visits will be checked back to ",ABM("D")," for "_$P($G(^AUTTLOC(DUZ(2),0)),U,2)  ;abm*2.6*36 IHS/SD/SDR ADO76874
 W !!,"OK, all visits from ",ABM("D")," to ",$$SDT^ABMDUTL($P($G(^ABMDPARM(DUZ(2),1,0)),U,23))," will be checked for "_$P($G(^AUTTLOC(DUZ(2),0)),U,2)  ;abm*2.6*36 IHS/SD/SDR ADO76874
 W !,"during the nightly claim generation process.",!
 D NOW^%DTC
 S DIE="^ABMDPARM(DUZ(2),",DA=1,DR=".191////"_DUZ_";.192////"_%
 D ^DIE
 ;end new abm*2.6*35 IHS/SD/SDR ADO60700
 K DIR S DIR(0)="E" D ^DIR
 G XIT
 ;
DT ;date external
 ;S ABM("D")=$$HDT^ABMDUTL(ABM("D"))  ;abm*2.6*35 IHS/SD/SDR ADO60700
 S ABM("D")=$$SDT^ABMDUTL(ABM("D"))  ;abm*2.6*35 IHS/SD/SDR ADO60700
 Q
