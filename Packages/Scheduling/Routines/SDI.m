SDI ; IHS/ADC/PDW/ENM - CHECK-IN/UNSCHEDULED APPOINTMENT ;  [ 06/22/2000  3:31 PM ]
 ;;5.0;IHS SCHEDULING;**5**;MAR 25, 1999
 ;;MAS VERSION 5.0;
 ;IHS/HQW/KML 2/13/97 replace $N with $O w/o changing functionality
 ;IHS/ANMC/RAM,LJF
 ; -- added calls to ASDI for IHS changes
 ; -- added entry point comments for calls from ^ASDI & ^ASDCR
 ; -- added public entry point for call from ^AMER1
 ; -- added check for skipping chart request for ^AMER1
 ;PATCH 5: added call to create visit at check-in and to modify
 ;            visit date if check-in date/time is changed
 ;
 Q  ;IHS added line
 D END,DT^DICRW
PT K SDAPTYP W !! S DIC="^DPT(",DIC(0)="AEQMZ",SDD=0 D ^DIC K DIC,I,J G:Y<0 END S DFN=+Y D 2^VADPT I +VADM(6) W *7,!,"** PATIENT HAS DIED! **" G END
 S SDSEX=$P(VADM(5),"^")="F"
 F SDPR=DT:0 S SDPR=$O(^DPT(DFN,"S",SDPR)) Q:$P(SDPR,".",1)-DT  I $P(^DPT(DFN,"S",SDPR,0),"^",2)'["C",$P(^(0),"^",2)'["N" S:$D(^(0)) I(SDPR)=+^(0)
 F J=0:0 S J=$O(^DPT(DFN,"DE",J)) Q:'$D(^(J,0))  S:$P(^(0),"^",2)'["I" J(+^(0))=""
 F SDPR=0:0 S SDPR=$O(I(SDPR)) Q:'SDPR  F I=0:0 S I=$O(^SC(I(SDPR),"S",SDPR,1,I)) Q:'$D(^(I,0))  I ^(0)-DFN=0 D GOT S SDD=SDD+1
 I SDD W !!,"BESIDES "_$S(SDD>1:"THESE APPOINTMENTS,",1:"THIS APPOINTMENT,"),! G NEW
 W *7,!,"THIS PATIENT HAS NO APPOINTMENTS SCHEDULED TODAY",!
 I $D(J)<9 W "AND ISN'T ACTIVELY ENROLLED IN ANY CLINICS" G SDI
NEW ;EP; called by ^ASDI; IHS added comment
 ;W "DO YOU WANT TO ADD A NEW 'UNSCHEDULED' APPOINTMENT FOR H"_$P("IM^ER",U,SDSEX+1) S %=2 D YN^DICN I '% W !,"RESPOND YES OR NO",! G NEW ;IHS orig va
 W "DO YOU WANT TO ADD A NEW 'UNSCHEDULED' APPOINTMENT FOR H"_$P("IM^ER",U,SDSEX+1) S %=1 D YN^DICN I '% W !,"RESPOND YES OR NO",! G NEW ;IHS chgd
 ;G NO:%-1 S DIC=44,DIC(0)="AEMQ",DIC("A")="IN WHAT CLINIC (MUST BE ONE IN WHICH "_$E("S",SDSEX)_"HE IS ACTIVELY ENROLLED): ",DIC("S")="I $P(^(0),""^"",3)=""C"",$D(^(""SL"")),$D(J(Y))!$D(J(+$P(^(""SL""),U,5)))" ;IHS orig va
 G NO:%-1 S DIC=44,DIC(0)="AEMQ",DIC("A")="IN WHAT CLINIC: "  ;,DIC("S")="I $P(^(0),""^"",3)=""C"",$D(^(""SL"")),$D(J(Y))!$D(J(+$P(^(""SL""),U,5)))" ;IHS chgd
 D ^DIC K J,DIC G NO:Y<0
ER1 ;PEP; called by ER rtn AMER1 to stuff walk-in visit & request chart
 S SC=+Y,SDSL=$S($D(^SC(SC,"SL")):+^("SL"),1:"") K SDRE,SDIN,SDRE1 I $D(^SC(SC,"I")) S SDIN=+^("I"),SDRE=+$P(^("I"),"^",2),Y=SDRE D DTS^SDUTL S SDRE1=Y
 I $S('$D(SDIN):0,'SDIN:0,SDIN>DT:0,SDRE'>DT&(SDRE):0,1:1) W !,*7,"Clinic is inactive ",$S(SDRE:"from ",1:"as of ") S Y=SDIN D DTS^SDUTL W Y,$S(SDRE:" to "_SDRE1,1:"") G SDI
TIME R !,"APPOINTMENT TIME: NOW// ",X:DTIME I X["^"!('$T) G NO
 ;I X?.E1"?" W !,"  Enter a time or date@time for the appointment or return for 'NOW'",!,"Date must be today or earlier" G TIME;IHS orig va
 I X?.E1"?" W !,"  Enter a time or date@time for the appointment or return for 'NOW'",!,"  Date must be today or earlier.  Or enter ^ to cancel making appointment." G TIME ;IHS chgd
 S:X="" X="NOW" S:X'="NOW"&(X'["@") X="T@"_X
 S %DT="TEP",%DT(0)="-(DT+1)" D ^%DT
 I $D(^SC(SC,"ST",$P(Y,"."))),'$D(^SC(SC,"ST",$P(Y,"."),"CAN")) G OKTD
 I $D(^SC(SC,"ST",$P(Y,"."),"CAN")) G:^(1)'["CANCEL" CANP W !,*7,"<THIS DATE'S CLINIC HAS BEEN CANCELLED>",!,*7 G SDI
 S SDY=Y,X=$P(Y,".") D DOW^SDM0 I $D(^SC(SC,"T"_Y)) S Z=$O(^SC(SC,"T"_Y,DT)) I $D(^SC(SC,"T"_Y,Z,1)),^(1)]"" S Y=SDY G OKTD
 G NOMET
OKTD ;EP; called by ^ASDI & ^ASDCR ;IHS added comment
 I Y>0,$D(^DPT(DFN,"S",Y,0)) W !!,*7,"Patient already has an appt on " D AT^SDUTL W Y,! G NO
 S Y1=Y I Y>0 D ^SDM4 G END:X="^"
 ;I Y1>0 S (SDPR,Y)=Y1 D INPT,SSD S ^DPT(DFN,"S",SDPR,0)=SC_"^"_SDINP_"^^^^^4^^^^^^^^^"_SDAPTYP,I(SDPR)=SC K SDINP F I=1:1 I '$D(^SC(SC,"S",SDPR,1,I)) S:'$D(^(0)) ^(0)="^44.003PA^^" S ^(I,0)=DFN_"^"_SDSL D SET,RT,GOT,DUAL G CHKR ;IHS orig va
 ;IHS line below chgd
 I Y1>0,DFN>0 S (SDPR,Y)=Y1 D INPT,SSD S ^DPT(DFN,"S",SDPR,0)=SC_"^"_SDINP_"^^^^^4^^^^^^^^^"_SDAPTYP,I(SDPR)=SC K SDINP F I=1:1 I '$D(^SC(SC,"S",SDPR,1,I)) S:'$D(^(0)) ^(0)="^44.003PA^^" S ^(I,0)=DFN_"^"_SDSL D SET,RT,GOT,DUAL,OTHER^ASDM G CHKR
NO W !?3,"<NO NEW APPOINTMENT MADE>",*7
 I $D(AMERDFN) S AMERQUIT="" ;IHS added
 G SDI
 ;
NOMET W !,*7,"<CLINIC DOES NOT MEET ON THIS DATE!!>",!,*7 G SDI
CANP W !,*7,"<WARNING--- PART OF THIS DAY'S CLINIC HAS BEEN CANCELLED>",!,*7 G OKTD
 ;
RT S SDRT="A",SDTTM=SDPR,SDPL=I,SDSC=SC D RT^SDUTL Q
GOT ;EP; called by ^ASDI ;IHS added comment
 Q:$D(ASDCR)  ;IHS added call
 W !,"APPOINTMENT AT "_$E(SDPR_"000",9,12)_" ON " S Y=SDPR\1 D DTS^SDUTL W Y," IN "_$P(^SC(I(SDPR),0),U,1),!
 ;S:'$D(^SC(I(SDPR),"S",0)) ^(0)="^44.001DA^^" S DA(2)=I(SDPR),DA(1)=SDPR,DIE="^SC("_DA(2)_",""S"","_DA(1)_",1,",DA=I,DR="309//NOW" D ^DIE Q  ;PATCH 5
 S:'$D(^SC(I(SDPR),"S",0)) ^(0)="^44.001DA^^" S DA(2)=I(SDPR),DA(1)=SDPR,DIE="^SC("_DA(2)_",""S"","_DA(1)_",1,",DA=I,DR="309//NOW" D ^DIE  ;PATCH 5
 I $G(ASDCKO) D VDATE^ASDV(I(SDPR),SDPR,$$SCX^ASDI,DFN,ASDCKO,.ASDMSG) K ASDCKO D:$D(ASDMSG) MSG^ASDV($P(ASDMSG(1),U,2),1,0)  Q  ;check-in time changed ;PATCH 5
 D CHKIN^ASDV(I(SDPR),SDPR,$$SCX^ASDI,DFN) ;create visit ;PATCH 5
 Q  ;PATCH 5
CHKR ;
 I $D(ASDCR) S SDMADE="" G SDI ;IHS added call
 D CHKR^ASDI Q  ;IHS added code
 S:'$D(^DPT(DFN,"S",0)) ^(0)="^2.98P^^" S %=1 W !,"WANT TO PRINT ROUTING SLIP NOW" D YN^DICN I '% W !,"RESPOND YES OR NO" G CHKR
 I (%-1) W:%<0 " NO" G PT
 K IOP S (SDX,SDSTART,ORDER,SDREP)="" D EN^SDROUT1 G SDI
 ;
DUAL I $O(VAEL(1,0))>0 S SDEMP="" D ELIG^SDM4:"369"[SDAPTYP S SDEMP=$S(SDDECOD:SDDECOD,1:SDEMP) I +SDEMP S $P(^SC(SC,"S",SDPR,1,I,0),"^",10)=+SDEMP K SDEMP
 Q
INPT K SDINP S X=Y D INPAT^SDM0
 Q
SSD S SD=SDPR D EN1^SDM3
 Q
END ;EP; called by ^ASDI ;IHS added comment
 D KVAR^VADPT K %,%DT,%Y,C,COLLAT,D0,D,DA,DFN,DI,DIC,DIE,DIV,DP,DQ,DR,GDATE,I,J,ORDER,PRDATE
 K SDZHS ;IHS added
 K SC,SDALLE,SDATD,SDAPTYP,SD,SDD,SDDECOD,SDEC,SDEMP,SDIN,SDINP,SDIQ,SDOEL,SDPL,SDPR,SDRE,SDRE1,SDREP,SDRT,SDSC,SDSEX,SDSL,SDSTART,SDTTM,SDX,SDY,X,Y,Y1,Z Q
SET S ^SC(SC,"S",SDPR,1,I,0)=DFN_"^"_SDSL_"^^^^"_DUZ_"^"_DT,^SC(SC,"S",SDPR,0)=SDPR Q
