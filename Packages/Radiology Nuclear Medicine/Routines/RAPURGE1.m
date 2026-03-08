RAPURGE1 ; IHS/ADC/PDW -Routine to Purge Radiology Data 09:07 ;   [ 11/23/2001  9:34 AM ]
 ;;4.0;RADIOLOGY;**11**;NOV 20, 1997
 ;
 ;Instances of "^" have been replaced by U in this routine for patch 11
 ;IHS/HQW/SCR 0601 **11**
 ;
 ;BEGIN changes for VA patches IHS/HQW/SCR 9/6/01 **11**
 ;
START ;
 ;U IO S %DT="T",X="NOW" D ^%DT K %DT W !!,"Purge radiology data routine started at " D D^RAUTL W Y,".",!  ;Cmn'td out  IHS/HQW/SCR 9/6/01 **11**
 ;G EXIT:'$D(^RA(79.2,RAPUR,.1)) S RAX=^(.1),(RAPRECNT,RAEXCNT,RARPCNT,RADT)=0  ;Cmn'td out IHS/HQW/SCR 9/6/01 **11**
 U IO D NOW^%DTC S Y=%,RACRT=$E(IOST,1,2)="C-" K %,%H,%I W !!,"Purge data routine started at " D D^RAUTL W Y,"."   ;IHS/HQW/SCR 9/6/01 **11**
 G EXIT:'$O(RAPUR(0))  ;IHS/HQW/SCR 9/6/01 **11**
 ;
 ;F RAI=1:1:5 S X2=$S($P(RAX,U,RAI)>89:$P(RAX,U,RAI),1:1461),RAVAR=$P("RACT^RAWR^RACL^RATK^RAPR",U,RAI),X1=DT,X2=-X2 D C^%DTC S @(RAVAR_"=X") S:@RAVAR>RADT RADT=@RAVAR  ;Cmn'td out IHS/HQW/SCR 9/6/01 **11**
 ;
 S (RADT,RAODT,RAIEN)=0 F  S RAIEN=$O(RAPUR(RAIEN)) Q:'RAIEN  S RAX=$G(^RA(79.2,RAIEN,.1)) D   ;IHS/HQW/SCR 9/6/01 **11**
 .F RAI=1:1:4 S X2=-$S($P(RAX,U,RAI)>89:$P(RAX,U,RAI),1:1461),X1=DT D C^%DTC S $P(RAPUR(RAIEN),U,RAI)=X S:X>RADT RADT=X   ;IHS/HQW/SCR 9/6/01 **11**
 .S X2=-$S($P(RAX,U,6)>29:$P(RAX,U,6),1:90),X1=DT D C^%DTC S $P(RAPUR(RAIEN),U,5)=X S:X>RAODT RAODT=X  ;IHS/HQW/SCR 9/6/01 **11**
 .F RAI=6:1:8 S $P(RAPUR(RAIEN),U,RAI)=0  ;IHS/HQW/SCR 9/6/01 **11**
 ;
REG ;
 ;REG replaced by the tag "EXAM" for VA patches IHS/HQW/SCR 9/6/01**11**
 ;
EXAM ;Purge exam/report data IHS/HQW/SCR 9/6/01 **11**
 W !!,"Purging exams/reports.",!  ;IHS/HQW/SCR 9/6/01 **11**
 ;
 ;F RADTE=0:0 S RADTE=$O(^RADPT("AR",RADTE)) Q:RADTE'>0!(RADTE>RADT)  S RADTI=9999999.9999-RADTE F RADFN=0:0 S RADFN=$O(^RADPT("AR",RADTE,RADFN)) Q:RADFN'>0  D RACNI  -- Cmn'ted out for VA patches IHS/HQW/SCR 9/6/01 **11**
 F RADTE=0:0 S RADTE=$O(^RADPT("AR",RADTE)) Q:RADTE'>0!(RADTE>RADT)  S RADTI=9999999.9999-RADTE F RADFN=0:0 S RADFN=$O(^RADPT("AR",RADTE,RADFN)) Q:RADFN'>0  D     ;IHS/HQW/SCR 9/6/01 **11**
 .F RACN=0:0 S RACN=$O(^RADPT(RADFN,"DT",RADTI,"P","B",RACN)) Q:RACN'>0  S RACNI=+$O(^(RACN,0)),RA0=$G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),RARPT=+$P(RA0,U,17) D:$S('$D(^("NOPURGE")):1,^("NOPURGE")'="n":1,1:0)    ;IHS/HQW/SCR 9/6/01 **11**
 ..S RAIMAG=+$P($G(^RAMIS(71,+$P(RA0,U,2),0)),U,12) Q:'$D(RAPUR(RAIMAG))  W:RACRT "."   ;IHS/HQW/SCR 9/6/01 **11**
 ..K RARP S RARPTNP=$G(^RARPT(RARPT,"NOPURGE")) I $S('$D(^RARPT(RARPT,0)):0,RAREPURG:1,'$D(^("PURGE")):1,1:0),RARPTNP'="n" D   ;IHS/HQW/SCR 9/6/01 **11**
 ...I $P(RAPUR(RAIMAG),U,2)>RADTE,$D(^RARPT(RARPT,"R")) K ^("R") S RARP=""    ;IHS/HQW/SCR 9/6/01 **11**
 ...I $P(RAPUR(RAIMAG),U)>RADTE,$D(^RARPT(RARPT,"L")) K ^("L") S RARP=""   ;IHS/HQW/SCR 9/6/01 **11**
 ...I $P(RAPUR(RAIMAG),U,3)>RADTE,$D(^RARPT(RARPT,"H")) K ^("H") S RARP=""   ;IHS/HQW/SCR 9/6/01 **11**
 ..S:$D(RARP) ^RARPT(RARPT,"PURGE")=DT,$P(RAPUR(RAIMAG),U,7)=$P(RAPUR(RAIMAG),U,7)+1   ;IHS/HQW/SCR 9/6/01 **11**
 ..I $S(RAREPURG:1,'$D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PURGE")):1,1:0) K RAEX D    ;IHS/HQW/SCR 9/6/01 **11**
 ...I $P(RAPUR(RAIMAG),U)>RADTE,$D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"L")) K ^("L") S RAEX=""   ;IHS/HQW/SCR 9/6/01 **11**
 ...I $P(RAPUR(RAIMAG),U,3)>RADTE,$D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"H")) K ^("H") S RAEX="" ;IHS/HQW/SCR 9/6/01 **11**
 ...I $P(RAPUR(RAIMAG),U,4)>RADTE,$D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"T")) K ^("T") S REAX=""  ;IHS/HQW/SCR 9/6/01 **11**
 ..S:$D(RAEX) ^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PURGE")=DT,$P(RAPUR(RAIMAG),U,6)=$P(RAPUR(RAIMAG),U,6)+1   ;IHS/HQW/SCR 9/6/01 **11**
 ;
ORD ;
 ;ORD replaced by tag ORDER for VA patches IHS/HQW/SCR 9/6/01 **11**
 ;
ORDER ;IHS/HQW/SCR 9/6/01 **11**
 ;Purge order/request data IHS/HQW/SCR 9/6/01 **11**
 ;
 ;W !!,"...will now purge radiology requests" -Cmn'ted out for VA patches IHS/HQW/SCR 9/6/01 **11**
 ;S RAPKG="",RAORDCNT=0,DIC="^RA(79.2,",DIC(0)="",X="RADIOLOGY" D ^DIC K DIC S RAORPURG=$S(Y<0:90,$D(^RA(79.2,+Y,.1)):+$P(^(.1),U,6),1:90) S X="T",%DT="" D ^%DT K %DT S DT=Y   ;Cmn'ted out for VA patches IHS/HQW/SCR 9/6/01 **11**
 ;F RAODTE=0:0 S RAODTE=$O(^RAO(75.1,"AO",RAODTE)) Q:'RAODTE  F RAOIFN=0:0 S RAOIFN=$O(^RAO(75.1,"AO",RAODTE,RAOIFN)) Q:'RAOIFN  S X1=RAODTE,X2=RAORPURG D C^%DTC I DT>X,$D(^RAO(75.1,RAOIFN,0)),+$P(^(0),U,5)<6 S RAORD0=^(0) D ENPUR
 ;Above line cmn'ted out for VA patches IHS/HQW/SCR 9/6/01 **11**
 ;S DA=RAPUR,DIE="^RA(79.2,",DR="100///""NOW""",DR(2,79.23)="2///P;3////"_DUZ_";4///"_RAEXCNT_";5///"_RARPCNT_";6///"_RAORDCNT D ^DIE K DE,DQ,DIE,DR  ;Cmn'ted out for VA patches IHS/HQW/SCR 9/6/01 **11**
 ;S %DT="T",X="NOW" D ^%DT K %DT W !!,"Data purge completed at " D D^RAUTL W Y,".",!!,"The following purge statistics were compiled:",!?5,"No. of exam records processed      : ",RAEXCNT,!?5,"No. of reports processed           : ",RARPCNT
 ;Above line cmn'ted out for VA patches IHS/HQW/SCR 9/6/01 **11**
 ;W !?5,"No. of radiology requests processed: ",RAORDCNT ;Cmn'ted out forVA patches IHS/HQW/SCR 9/6/01 **11**
 ;
 W !,"Purging orders/requests.",!  ;IHS/HQW/SCR 9/6/01 **11**
 S RAPKG="" F RAODTE=0:0 S RAODTE=$O(^RAO(75.1,"AO",RAODTE)) Q:'RAODTE!(RAODTE>RAODT)  F RAOIFN=0:0 S RAIOFN=$O(^RAO(75.1,"AO",RAODTE,RAOIFN)) Q:'RAOIFN  S RAORD0=$G(^RAO(75.1,RAOIFN,0)),RAIMAG=+$P(RAORD0,U,3) D   ;IHS/HQW/SCR 9/6/01 **11**
 .I $D(RAPUR(RAIMAG)),$P(RAORD0,U,5)<6,$P(RAORD0,U,21)<DT!($P(RAORD0,U,21)'<DT&($P(RAORD0,U,5)<3)) D ENPUR  ;IHS/HQW/SCR 9/6/01 **11**
 ;
 ;Update statistics in Imaging Type file (#79.2)
 D NOW^%DTC S Y=% K %,%H,%I W !,"Data purge completed at " D D^RAUTL W Y,".",!!,"The following purge statistics were compiled:" ;IHS/HQW/SCR 9/6/01**11**
 K RAX S RAX="" F  S RAX=$O(RAPUR(RAX)) Q:'RAX  S DA=RAX,DIE="^RA(79.2,",DR="100///""NOW""",DR(2,79.23)="2///P;3////"_DUZ_";4///"_$P(RAPUR(RAX),U,6)_";5///"_$P(RAPUR(RAX),U,7)_";6///"_$P(RAPUR(RAX),U,8) D ^DIE D   ;IHS/HQW/SCR 9/6/01 **11**
 .W !!,"Imaging Type: ",$P($G(^RA(79.2,RAX,0)),U),!  ;IHS/HQW/SCR 9/6/01 **11**
 .W !?5,"No. of exam records processed     : ",$P(RAPUR(RAX),U,6)  ;IHS/HQW/SCR 9/6/01 **11**
 .W !?5,"No. of reports processed          : ",$P(RAPUR(RAX),U,7)   ;IHS/HQW/SCR 9/6/01 **11**
 .W !?5,"No. of requests processed        : ",$P(RAPUR(RAX),U,8)   ;IHS/HQW/SCR 9/6/01 **11**
 ;
EXIT ;
 ;K DA,RAORDCNT,RAPRECNT,RA0,RACL,RACN,RACNI,RACT,RADFN,RADT,RADTE,RADTI,RAEX,RAEXCNT,RAI,RAOIFN,RAPKG,RAPUR,RAREPURG,RARP,RARPCNT,RARPT,RATK,RAVAR,RAWR,RAX,D0,D1,DA,DLAYGO,POP,RAPR,RAPUR,RAREPURG D CLOSE^RAUTL
 ;Above line modified for VA patches IHS/HQW/SCR 9/6/01 **11**
 K D0,D1,DA,DE,DIE,DQ,DR,DLAYGO,POP,RA0,RACN,RACNI,RACRT,RADFN,RADT,RADTE,RADTI,RAEX,RAI,RAIEN,RAIMAG,RAODT,RAODTE,RAOIFN,RAORD0,RAPKG,RAPUR,RAREPURG,RARP,RARPRT,RARPTNP,RAX,X,X1,X2,Y D CLOSE^RAUTL   ;IHS/HQW/SCR 9/6/01 **11**
 Q
 ;
RACNI ;
 ;The code in this tag is no longer used IHS/HQW/SCR 9/6/01 **11**
 ;F RACN=0:0 S RACN=$O(^RADPT(RADFN,"DT",RADTI,"P","B",RACN)) Q:RACN'>0  S RACNI=$O(^(RACN,0)) Q:'$D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0))  S RA0=^(0),RARPT=+$P(RA0,U,17) D RACNI1:$S('$D(^("NOPURGE")):1,^("NOPURGE")'="n":1,1:0)
 ;Q
 ;
RACNI1 ;
 ;The code in this tag is no longer used IHS/HQW/SCR 9/6/01 **11**
 ;D @($S(RAREPURG:"P",'$D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PURGE")):"P",1:"P1")) W "." Q
 ;
P ;
 ;The code in this tag is no longer used IHS/HQW/SCR 9/6/01 **11**
 ;K RAEX I RACT>RADTE I $D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"L")) K ^("L") S RAEX=""
 ;I RACL>RADTE I $D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"H")) K ^("H") S RAEX=""
 ;I RATK>RADTE I $D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"T")) K ^("T") S RAEX=""
 ;S:$D(RAEX) ^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PURGE")=DT,RAEXCNT=RAEXCNT+1
P1 ;
 ;The code in this tag is no longer used IHS/HQW/SCR 9/6/01 **11**
 ;K RARP I RACL>RADTE K ^RADPT(RADFN,"DT",RADTI,"H")
 ;Q:$S('$D(^RARPT(RARPT,0)):1,RAREPURG:0,'$D(^("PURGE")):0,1:1)
 ;I $D(^RARPT(RARPT,"NOPURGE")),^("NOPURGE")="n" Q
 ;I RAWR>RADTE,$D(^RARPT(RARPT,"R")) K ^("R") S RARP=""
 ;I RACT>RADTE,$D(^RARPT(RARPT,"L")) K ^("L") S RARP=""
 ;I RACL>RADTE,$D(^RARPT(RARPT,"H")) K ^("H") S RARP=""
 ;S:$D(RARP) ^RARPT(RARPT,"PURGE")=DT,RARPCNT=RARPCNT+1
 ;Q
 ;
 ;
ENPUR ;
 ;OE/RR Entry Point for the PURGE ACTION Option
 I '$D(RAPKG) Q:'$D(ORPK)!('$D(ORSTS))  S OREND=$S(ORSTS<6:0,1:1) Q:OREND!(ORPK'>0)  S RAOIFN=+ORPK
 ;
 ;S DA=RAOIFN,DIK="^RAO(75.1," D ^DIK K DIK I $D(RAPKG) W "." S RAORDCNT=RAORDCNT+1 I $D(^ORD(100.99)) S ORIFN=+$P(RAORD0,U,7),ORSTS="K" D ST^ORX K ORIFN,ORSTS  ;Cmn'ted out for VA patches IHS/HQW/SCR 9/6/01 **11**
 ;I '$D(RAPKG) S ORSTS="K" D ST^ORX K ORIFN,ORSTS ;IHS/HQW/SCR 9/6/01 **11**
 ;
 ;Above lines modified for VA patches IHS/HQW/SCR 9/6/01 **11**
 S DA=RAOIFN,DIK="^RAO(75.1," D ^DIK K DIK I $D(RAPKG) W:RACRT "." S $P(RAPUR(RAIMAG),U,8)=$P(RAPUR(RAIMAG),U,8)+1 I $D(^ORD(100.99)) S ORIFN=+$P(RAORD0,U,7),ORSTS="K" D:ORIFN ST^ORX K ORIFN,ORSTS  ;IHS/HQW/SCR 9/6/01 **11**
 I '$D(RAPKG) S ORSTS="K" D:ORIFN ST^ORX K ORIFN,ORSTS ;IHS/HQW/SCR 9/6/01 **11**
 ;
 I $D(^RADPT("AO",RAOIFN)) S DA(2)=+$O(^(RAOIFN,0)),DA(1)=+$O(^(DA(2),0)),DA=+$O(^(DA(1),0)),DIE="^RADPT("_DA(2)_",""DT"","_DA(1)_",""P"",",DR="11///@" D ^DIE K DE,DQ,DIE,DR
 Q
