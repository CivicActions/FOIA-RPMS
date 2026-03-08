ABMDE7 ; IHS/SD/SDR - Edit Page 7 - Inpatient ; 
 ;;2.6;IHS 3P BILLING SYSTEM;**10,34**;NOV 12, 2009;Build 645
 ;
 ;IHS/DSD/JLG 05/27/98 NOIS NDA-0598-180119 Modified to remove call to the claim generator for
 ;     missing hospital admission date, too many side-effects
 ;
 ;IHS/SD/SDR 2.5*8 IM14016/IM15234/IM15615 Fixed Prior Authorization field
 ;
 ;IHS/SD/SDR 2.6*34 ADO60694 CR7384 Made changes for DRG display, prompt, lookup; removed prompt for professional
 ;   component days (it doesn't apply anymore)
 ;
 I $P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),6)),U)="" D
 .Q:ABMP("VTYP")=831
 . ; Needs to use primary not 1st
 .S ABMVDFN=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,"AC","P","")) Q:'ABMVDFN
 .I $G(ABMP("VDT"))]"" S ^AUPNVSIT("ABILL",ABMP("VDT"),ABMVDFN)=""
 ;
OPT K ABM,ABME,ABMZ
 D DISP^ABMDE7A,^ABMDE7X,^ABMDE7C
 D PRIMDX^ABMDE5  ;abm*2.6*34 IHS/SD/SDR ADO60694
 ;S ABMZ("NUM")=$S($D(ABMP("VTYP",999))&$D(ABMP("FLAT")):14,1:13)  ;abm*2.6*34 IHS/SD/SDR ADO60694
 S ABMZ("NUM")=14  ;abm*2.6*34 IHS/SD/SDR ADO60694
 I +$O(ABME(0)) S ABME("CONT")="" D ^ABMDERR K ABME("CONT")
 W ! S ABMP("OPT")="ENVJBQ" D SEL^ABMDEOPT I "EV"'[$E(Y) S:$D(ABMP("DDL"))&($E(ABMP("PAGE"),$L(ABMP("PAGE")))=7) ABMP("QUIT")="" G XIT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 I $E(Y)="V" D V1^ABMDE7A G OPT
 ;
EDIT ; Entry of Claim Identifiers
 ;S ABMP("FLDS")=$S($D(ABMP("VTYP",999))&$D(ABMP("FLAT")):14,1:13)  ;abm*2.6*34 IHS/SD/SDR ADO60694
 S ABMP("FLDS")=14  ;abm*2.6*34 IHS/SD/SDR ADO60694
 D FLDS^ABMDEOPT
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S DR="" F ABM("I")=1:1 S ABM=$P(ABMP("FLDS"),",",ABM("I")) Q:ABM=""  S:ABM("I")>1 DR=DR_";" S DR=DR_$P($T(@ABM),";;",2)
 S DIE="^ABMDCLM(DUZ(2),",DA=ABMP("CDFN") D ^DIE K DR
 ;
 S ABM("C5")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),ABM("C7")=$G(^(7))
 ;commented out the next two lines; they were making Prof Comp Days prompt come up twice when they edited all the fields on page  ;abm*2.6*34 IHS/SD/SDR ADO60694
 ;I ABMP("FLDS")[14,$D(ABMP("FLAT")),$D(ABMP("VTYP",999)) D  ;abm*2.6*34 IHS/SD/SDR ADO60694
 ;.S DR=".57//"_$P(ABM("C7"),U,3) D ^DIE  ;abm*2.6*34 IHS/SD/SDR ADO60694
 S ABM("C5")=$G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5))
 S $P(ABMP("FLAT"),U,8)=$P(ABM("C5"),U,7)
 I ABMP("FLDS")[3,+ABM("C5")=85,ABMP("FLDS")'[5,$P(ABM("C5"),U,2)<53!($P(ABM("C5"),U,2)>57) S DR=".52///@" D ^DIE S DR=".52T~R" D ^DIE G E2
 I ABMP("FLDS")[3,ABMP("FLDS")'[5,$P(ABM("C5"),U,2)>52,$P(ABM("C5"),U,2)<58 S DR=".52///@;.525///@" D ^DIE S DR=".52T~R" D ^DIE
 ;
E2 K ABMP("FLDS")
 G OPT
 ;
1 ;;.61T
2 ;;.62T
3 ;;.51T;S:$G(X)'=85 Y="@1";.525T;@1
4 ;;.52T
5 ;;W !,"** CODING SYSTEM IS "_$S(ABMP("VDT")<ABMP("ICD10"):"ICD-9",1:"ICD-10")_"**";.59T
  ;;.59T  ;original line 5  ;abm*2.6*10 ICD10 002U
  ;start new abm*2.6*34 IHS/SD/SDR ADO60694
6 ;;D DRG^ABMDE7;.513[6] DRG;I +$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),5)),U,13) W " "_$E($G(^ICD($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),5),U,13),1,1,0)),1,50)
7 ;;.63[7] Discharge Date.........: "
8 ;;.64[8] Discharge Hour.........: "
9 ;;.53[9] Discharge Status........: "
10 ;;.71[10] Service From Date.......: "
11 ;;.72[11] Service Thru Date......: "
12 ;;.73[12] Covered Days...........: "
13 ;;.66[13] Non Covered Days.......: "
14 ;;.512[14] Prior Authorization No: "
16 ;;.67T
17 ;;.68T
 ;end new start old abm*2.6*34 IHS/SD/SDR ADO60694
 ;6 ;;.63T
 ;7 ;;.64T
 ;8 ;;.53T
 ;9 ;;.71[9] Service From Date.......: "
 ;10 ;;.72[10] Service Thru Date......: "
 ;11 ;;.73[11] Covered Days...........: "
 ;12 ;;.66[12] Non Covered Days.......: "
 ;13 ;;.512[13] Prior Authorization No: "
 ;14 ;;.57[14] Professional Comp Days.: "
 ;16 ;;.67T
 ;17 ;;.68T
 ;end old abm*2.6*34 IHS/SD/SDR ADO60694
 ;
XIT K ABM,ABME
 Q
 ;
INP ;EP for Prof Comp Days Input Transform
 Q:'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),5))!'$D(^ABMDCLM(DUZ(2),ABMP("CDFN"),7))
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U)=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,2),X>1 K X Q
 I X>($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),7),U,3)+1) K X
 Q
 ;start new abm*2.6*34 IHS/SD/SDR ADO60694
DRG ;
 I +$G(ABMP("PDX"))'=0 D
 .S ABMLST=$$GETDRG^ICDEX(80,ABMP("PDX"),ABMP("VDT"),"")
 .I $P(ABMLST,";",2)>ABMP("VDT") K ABMLST Q  ;DRG effective date is before visit date
 .S ABMLST=$P(ABMLST,";")
 .I $G(ABMLST)="" K ABMLST Q  ;no DRGs for Primary DX
 .W !!,"DRGs associated with Primary DX:"
 .N ABMI
 .F ABMI=1:1:($L(ABMLST,"^")-1) D
 ..W !?3,$P(ABMLST,"^",ABMI)_" "_$P($G(^ICD($P(ABMLST,"^",ABMI),0)),U)_" ("_$G(^ICD($P(ABMLST,"^",ABMI),1,1,0))_")"
 .W !
 .W !?3,"NOTE: Use your coding guidance to determine what DRG best aligns with",!?3," the services provided, which may not necessarily be from the list above"
 .W !
 Q
 ;end new abm*2.6*34 IHS/SD/SDR ADO60694
