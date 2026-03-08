RAZPCC1 ; IHS/ADC/PDW - RADIOLOGY PCC LINK RELATED ;     [ 03/07/2002  11:32 AM ]
 ;;4.0;RADIOLOGY;**4,12**;NOV 20, 1997
 ;
DIVPAR ;---> DISPLAY PROBLEM WITH PCC LINK.
 ;---> CALLED FROM "RADIOLOGY DIVISION" PARAMETERS PRINT TEMPLATE.
 N DIC,Y
 I $P(^AUTTSITE(1,0),U,8)'="Y" D  Q
 .W "No, PCC is not running at this site."
 I '$D(DUZ(2)) W "DUZ(2) is not defined." Q
 I '$D(^APCCCTRL(DUZ(2))) D  Q
 .W "No, no PCC MASTER CONTROL file at this site."
 I $P(^APCCCTRL(DUZ(2),0),U,4)']"" D  Q
 .W "No, VISIT TYPE is not defined in the"
 .W !?41,"PCC MASTER CONTROL file."
 S DIC=9.4,DIC(0)="",X="RADIOLOGY" D ^DIC
 I Y<0 W "No, RADIOLOGY is not in the PACKAGE file." Q
 I '$D(^APCCCTRL(DUZ(2),11,+Y,0)) D  Q
 .W "No, RADIOLOGY not in PCC MASTER CONTROL file"
 I '$P(^APCCCTRL(DUZ(2),11,+Y,0),U,2) D  Q
 .W "No, ""PASS DATA TO PCC"" is set to ""NO"" for"
 .W !?41,"RADIOLOGY in PCC MASTER CONTROL file."
 W "YES"
 Q
 ;
LINK ;EP---> DISPLAY PCC-RADIOLOGY LINK STATUS
 N X D ^XBKVAR
 ;S:'$D(IOF) IOF="!!!" ;CMTD OUT IHS/ISD/EDE 04/01/97
 ;W @IOF ;CMTD OUT IHS/ISD/EDE 04.01.97
 W !! ; IHS/ISD/EDE 04/01/97
 W ?24,"RADIOLOGY-PCC LINK ENVIRONMENT"
 W !?18,"------------------------------------------",!?8
 W "(Parameters 1-7 must be ""YES"" for PCC link to be operational.)",!
 W !!?5,"1) PCC is running at this site (RPMS SITE file):" D DOTS
 W $S($P(^AUTTSITE(1,0),U,8)="Y":"YES",1:"NO")
 ;
 W !!?5,"2) PCC MASTER CONTROL file is defined for this site:" D DOTS
 S X=$D(^APCCCTRL(DUZ(2))) W $S(X:"YES",1:"NO")
 ;
 W !!?5,"3) VISIT TYPE is defined in the PCC MASTER CONTROL file:"
 D DOTS D
 W $S('X:"NO",$P(^APCCCTRL(DUZ(2),0),U,4)]"":"YES",1:"NO") K X
 ;
 W !!?5,"4) RADIOLOGY is defined in the PACKAGE file:" D DOTS
 S DIC=9.4,DIC(0)="",X="RADIOLOGY" D ^DIC W $S(Y:"YES",1:"NO")
 ;
 W !!?5,"5) RADIOLOGY entry exists in the PCC MASTER CONTROL file:"
 D DOTS
 W $S($D(^APCCCTRL(DUZ(2),11,+Y,0)):"YES",1:"NO")
 ;
 D DIRZ^RAZUTL
 Q:$D(DIRUT)
 D ^RAZHDR
 W !! ; IHS/ISD/EDE 04/01/97
 W ?24,"RADIOLOGY-PCC LINK ENVIRONMENT (CONTINUED)"
 W !?18,"------------------------------------------------------",!?8
 I $D(^APCCCTRL(DUZ(2),11,+Y,0)) D
 .W !!?5,"6) RADIOLOGY entry in PCC MASTER CONTROL file has"
 .W !?8,"""PASS DATA TO PCC"" set to:" D DOTS
 .W $S('Y:"NO",$P(^APCCCTRL(DUZ(2),11,+Y,0),U,2):"YES",1:"NO")
 ;
 W !!?5,"7) V RADIOLOGY file exists in this UCI:" D DOTS
 S DIC=1,DIC(0)="",X="V RADIOLOGY" D ^DIC W $S(Y:"YES",1:"NO")
 ;
 W !!?5,"8) RADIOLOGY DIVISION parameter ""ASK PCC DATE/TIME"" set to:"
 D DOTS
 I '$D(RAMDV) D SETUP^RAZOREX
 W $S($P(RAMDV,U,30):"YES",1:"NO")
 W !!?5,"9) SEND TO PCC AT EXAMINED:" D DOTS W $S(+$G(^RA(79,RAMDIV,9999999)):"YES",1:"NO")
 D DIRZ^RAZUTL
 Q
 ;
DOTS ;
 F I=1:1:(67-$X) W "."
 Q
 ;
PCCDT() ;EP---> COLLECT PCC DATE & TIME
 ;TO USE: S VARIABLE=$$PCCDT^RAZPCC1
PCCDATE ;
 ;K %DT S %DT="AETX",%DT("A")="PCC Date: ",%DT("B")="TODAY"  modified below for patch 12. IHS/HQW/SCR 3/7/02 **12**
 K %DT S %DT="AETXP",%DT("A")="PCC Date: ",%DT("B")="TODAY" ;Addition of P in %DT to assume past dates. IHS/HQW/SCR 3/7/02 **12**
 D ^%DT K %DT
 Q:Y=-1 Y
 ;---> NEXT LINE: IF TIME IS ALREADY ENTERED, QUIT.
 Q:$P(Y,".",2) Y
PCCTIME ;
 W !,"PCC Time: " R X:DTIME
 Q:'$T!(X["^") -1
 I X="",$D(^APCCCTRL(DUZ(2),0)),'$P(^(0),U,2) Q Y_".12"
 I "??"[X D  G PCCTIME
 .W !?10,"Enter the time from the top left corner of the PCC form."
 .W !?10,"Examples of Valid Times: 10, 10AM, 10:30, etc."
 .W !?10,"Time is REQUIRED in this response."
 I X=$E("NOW",1,$L(X)) D  G:X PCCDATE
 .D NOW^%DTC
 .I X=Y S X="NOW" Q
 .W !?10,"""NOW"" does not agree with the PCC Date you entered."
 S:X'["NOW" X=Y_"@"_X
 S %DT="ETXR" D ^%DT K %DT
 G:Y=-1 PCCDATE
 Q Y
