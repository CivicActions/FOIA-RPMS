BRAPLINK ;IHS/CMI/DAY - PCC Link Tool  ; 08 Aug 2017  12:57 PM
 ;;5.0;Radiology/Nuclear Medicine;**1007**;Mar 16, 1998;Build 14
 ;
 ;PCC Link Tool to display Exam, Report, and PCC Link Info
 ;
 ;
CASE ;EP - Select Patient and Exam
 ;
 W !
 K RADFN,RADTI,RACNI
 D SET^RAPSET1 I $D(XQUIT) K XQUIT,POP Q
 S RAXIT=0,DIC(0)="AEMQ" D ^RADPA
 I Y<0 G EXIT
 S RADFN=+Y,RAHEAD="**** Check Radiology Exam Status and PCC Link ****"
 D ^RAPTLU G CASE:"^"[X
 ;
 N RASSAN,RACNDSP S RASSAN=$$SSANVAL^RAHLRU1(RADFN,RADTI,RACNI)
 S RACNDSP=$S((RASSAN'=""):RASSAN,1:RACN)
 I $$USESSAN^RAHLRU1() W !!?5,"Case No.: ",RACNDSP,!?4,"Procedure: ",$E(RAPRC,1,30),?56,"Date: ",RADATE
 I '$$USESSAN^RAHLRU1() W !!,"Case No.:",RACN,?15,"Procedure:",$E(RAPRC,1,30),?57,"Date:",RADATE
 N RADISPLY
 S RADISPLY=$G(^RAMIS(71,+$P($G(^RADPT(+RADFN,"DT",+RADTI,"P",+RACNI,0)),U,2),0))
 S RADISPLY=$$PRCCPT^RADD1()
 W !,?25,RADISPLY
 ;
 I $D(^RA(72,"AA",RAIMGTY,0,+RAST)) W !!?3,$C(7),"Exam has been 'cancelled'" G CASE
 ;
 ;Get status variables
 ;
 ;PCC Node (P1 = Visit Date, P2=V Rad IEN, P3=Visit IEN)
 S BRAPCC=$G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC"))
 ;
 ;Check if PCC Nodes Exist
 ;
 S BRAVFI=$P(BRAPCC,U,2)
 I +$G(BRAVFI),'$D(^AUPNVRAD(BRAVFI)) D
 .S $P(BRAPCC,U,2)=""
 .S $P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC"),U,2)=""
 ;
 S BRAVSTI=$P(BRAPCC,U,3)
 I +$G(BRAVSTI),'$D(^AUPNVSIT(BRAVSTI)) D
 .S $P(BRAPCC,U,3)=""
 .S $P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC"),U,3)=""
 ;
 ;PCC Visit Date
 S BRAVSTE=$P(BRAPCC,U)
 ;
 ;PCC V DFN
 S BRAVFI=$P(BRAPCC,U,2)
 ;
 ;PCC V DFN Visit IEN
 S BRAVFVST=""
 I BRAVFI S BRAVFVST=$P(^AUPNVRAD(BRAVFI,0),U,3)
 ;
 ;V File Impression - If exist and not NO IMPRESSION set to 1
 S BRAVFIMP=""
 I BRAVFI D
 .S X=$$GET1^DIQ(9000010.22,BRAVFI,1101)
 .I X="" Q
 .I X="NO IMPRESSION." S BRAVFIMP=X Q
 .S BRAVFIMP=$E(X,1,30)_" <more>"
 ;
 ;PCC Visit IEN
 S BRAVSTI=$P(BRAPCC,U,3)
 ;
 ;Report IEN
 S BRARPTI=$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,17)
 ;
 ;Report Number
 S BRARPTE=""
 I BRARPTI S BRARPTE=$$GET1^DIQ(74,BRARPTI,.01)
 ;
 ;Report Status
 S BRARPTS="None"
 I BRARPTI S BRARPTS=$$GET1^DIQ(74,BRARPTI,5)
 I BRARPTS="" S BRARPTS="None"
 ;
 ;Impression Status (1 = present)
 S BRARIMP="NO"
 I BRARPTI,$D(^RARPT(BRARPTI,"I")) S BRARIMP="YES"
 ;
 ;Exam Date
 S BRAEXDT=$P(^RADPT(RADFN,"DT",RADTI,0),U)
 S BRAEXDT=$P(BRAEXDT,".")
 ;
 ;Exam Status
 S BRAEXSTA=""
 S BRAEIEN=$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,3)
 I BRAEIEN S BRAEXSTA=$$GET1^DIQ(72,BRAEIEN,.01)
 ;
 ;
 ;Display Exam Status
 W !!
 W "Exam Date:",?24,$E(BRAEXDT,4,5),"/",$E(BRAEXDT,6,7),"/",(1700+$E(BRAEXDT,1,3))
 W !
 W "Exam Status: ",?24,BRAEXSTA
 W !
 W "Report:",?24,BRARPTE
 W !
 W "Report Status:",?24,BRARPTS
 W !
 W "Report has Impression:",?24,BRARIMP
 W !
 W "PCC Visit Date:",?24,$E(BRAVSTE,4,5),"/",$E(BRAVSTE,6,7),"/",(1700+$E(BRAVSTE,1,3))
 W !
 W "PCC Visit IEN:",?24,BRAVSTI
 ;
 ;Check if Visit is deleted
 I BRAVSTI,$P(^AUPNVSIT(BRAVSTI,0),U,11)=1 W "   [Visit Marked as Deleted]"
 W !
 W "PCC V RAD IEN:",?24,BRAVFI
 W !
 W "PCC V RAD Impression:",?24,BRAVFIMP
 W !
 ;
 I +$G(BRAVFVST),+$G(BRAVSTI),BRAVSTI'=BRAVFVST D
 .;
 .W !,"********************************************************"
 .W !,"  V RAD was re-pointed to visit ",BRAVFVST
 .;
 .S Y=$P($G(^AUPNVSIT(BRAVFVST,0)),U)
 .X ^DD("DD")
 .W "  (",Y,")"
 .W !,"*********************************************************"
 .W !
 ;
 ;Check if PCC Link needs to be triggered or not
 S BRALINK=0,BRAUPDT=0
 I BRAVSTE="" S BRALINK=1
 I BRAVSTI="" S BRALINK=1
 I BRAVFI="" S BRALINK=1
 I BRALINK=0 D
 .I BRARIMP="YES",BRAVFIMP="" S BRALINK=1,BRAUPDT=1
 .I BRARIMP="YES",BRAVFIMP="NO IMPRESSION." S BRALINK=1,BRAUPDT=1
 ;
 I BRALINK=0 D  G CASE
 .W !,"  PCC Link has already been triggered!",!
 .I BRARIMP="NO" D
 ..W "  Impression cannot be updated in PCC - Not in Report",!
 .K DIR
 .S DIR(0)="EO"
 .D ^DIR
 .K DIR
 ;
 K DIR
 S DIR(0)="YO"
 I BRAUPDT=0 S DIR("A")="Do you want to trigger the PCC Link"
 I BRAUPDT=1 S DIR("A")="Do you want to update the PCC Impression"
 D ^DIR
 K DIR
 I X="^" G CASE
 I X="" G CASE
 I Y=0 G CASE
 ;
 ;Now trigger the PCC Link based on the specific Exam
 ;
 ;Set these for Link
 S ORDSTS=""
 ;Action of SC is for EXAMINED without a verified report
 S ACTION="SC"
 ;With a verified report, use an action of "RE"
 I BRARPTS="VERIFIED" S ACTION="RE"
 ;If no PCC Date in "PCC" node, then add it
 I BRAVSTE="" S ^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC")=BRAEXDT
 ;
 ;If BRALINK=1 and BRAUPDT=0 then do the CREATE Link
 I BRALINK=1,BRAUPDT=0 D  Q
 .;
 .D CREATE^BRAPCC
 .D CREATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 .;
 .I BRAEXSTA'="COMPLETE" Q
 .;
 .;If Exam status is complete, then Update Impression
 .;
 .D UPDTIMP^BRAPCC($G(RADFN),$G(RADTI))
 .D UPDTDX^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 ;
 ;If BRAUPDT=1 then just update the Impression
 I BRALINK=1,BRAUPDT=1 D
 .D UPDTIMP^BRAPCC($G(RADFN),$G(RADTI))
 .D UPDTDX^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 ;
 G CASE
 ;
EXIT ;EP - End of Job Processing
 K %,%DT,%Y,A,C,D0,D1,D2,DA,DIC,I,X,Y
 K XQUIT,VAINDT,VADMVT
 K RACN,RACNI,RACNT,RACT,RADADA,RADATE,RADATI
 K RADFN,RADIE,RADTE,RADTI,RAHEAD,RAMES,RANME,RAOR,RAORDIFN
 K RAPOP,RAPRC,RAPRI,RAQUICK,RARPT,RASN,RASSN,RAST,RASTI
 K BRAPCC,BRAVFI,BRAVSTI,BRAVSTE,BRAVFVST,BRAVFIMP
 K BRARPTI,BRARPTE,BRARPTS,BRARIMP,BRAEXDT,BRAEXSTA,BRAEIEN
 K BRALINK,BRAUPDT,ORDSTS,ACTION
 K ^TMP($J,"RAEX")
 K %W,%Y1,D,D3,DDER,DI,DK,DL,POP,DISYS,DUOUT,RAI
 Q
