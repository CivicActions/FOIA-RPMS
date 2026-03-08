ABMURTST ; IHS/SD/SDR - 3PB/UFMS Reconcile Sessions Option   
 ;;2.6;IHS Third Party Billing;**42**;NOV 12, 2009;Build 789
 ;IHS/SD/SDR 2.6*42 ADO112033 Create file but don't transmit if Kernel System Parm is set to NOT production (so test)
EP ;EP
 S ABMPATH=$P($G(^ABMDPARM(ABMLOC,1,4)),U,13)  ;UFMS directory
 D OPEN^%ZISH("ABMF",ABMPATH,ABMFILE,"W")
 Q:POP
 U IO
 S ABMCNT=0
 F  S ABMCNT=$O(^ABMUFMS($J,ABMCNT)) Q:'ABMCNT  D
 .W !,$G(^ABMUFMS($J,ABMCNT))
 D CLOSE^%ZISH("ABMF")
 W !!!?2 W $$EN^ABMVDF("RVN") W "NOTE:" W $$EN^ABMVDF("RVF")
 W " File created but not transmitted to UFMS because Kernel System",!?2,"Parameter indicates this is a test system.",! H 1
 Q
