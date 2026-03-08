BYIMRT4 ;IHS/CIM/THL - IMMUNIZATION DATA EXCHANGE;
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**7**;AUG 20, 2020;Build 747
 ;
 ;
 ;REAL-TIME HL7 MESSAGE PROCESSING - CONTINUED
 ;
 ;=====
 Q
DISP ;EP;CONTENT DISPLAY
 I $O(DISE(0)) D EDE
 I $O(DISW(0)) D EDW
 Q:$G(DTYP)=3
 I $O(DISP(0)) D PDISP
 I $O(DISF(0)) D FDISP
 Q
 ;=====
 ;
PDISP ;PATIENT DISPLAY
 S J=0
 F  S J=$O(HDR(J)) Q:'J  W !,HDR(J)
 S JJ=""
 F  S JJ=$O(DISP(JJ)) Q:'JJ!$G(BYIMQUIT)  D
 .W !,DISP(JJ)
 .I IOST["C-",IOSL<($Y+4) D
 ..D PAUSE
 ..I $G(BYIMPAUS)]"",BYIMPAUS[U S BYIMQUIT=1
 ..Q:$G(BYIMQUIT)
 ..W @IOF
 ..S J=0
 ..F  S J=$O(HDR(J)) Q:'J  W !,HDR(J)
 D:'$G(BYIMQUIT) PAUSE
 Q
 ;=====
 ;
FDISP ;FORECAST DISPLAY
 W @IOF
 S J=0
 F  S J=$O(HDF(J)) Q:'J  W !,HDF(J)
 S JJ=""
 F  S JJ=$O(DISF(JJ)) Q:'JJ!$G(BYIMQUIT)  D
 .W !,DISF(JJ)
 .I IOST["C-",IOSL<($Y+4) D
 ..D PAUSE
 ..I $G(BYIMPAUS)]"",BYIMPAUS[U S BYIMQUIT=1
 ..Q:$G(BYIMQUIT)
 ..W @IOF
 ..S J=0
 ..F  S J=$O(HDF(J)) Q:'J  W !,HDF(J)
 D:'$G(BYIMQUIT) PAUSE
 Q
 ;=====
 ;
EDE ;ERRORS
 W @IOF
 N BYIMQUIT
 S J=0
 F  S J=$O(HDE(J)) Q:'J  W !,HDE(J)
 S JJ=""
 F  S JJ=$O(DISE(JJ)) Q:'JJ!$G(BYIMQUIT)  D
 .W !,DISE(JJ)
 .W:$D(DISE(JJ,1)) !,DISE(JJ,1)
 .I IOST["C-",IOSL<($Y+4) D
 ..D PAUSE
 ..I $G(BYIMPAUS)]"",BYIMPAUS[U S BYIMQUIT=1
 ..Q:$G(BYIMQUIT)
 ..W @IOF
 ..S J=0
 ..F  S J=$O(HDE(J)) Q:'J  W !,HDE(J)
 D:'$G(BYIMQUIT) PAUSE
 Q
 ;=====
 ;
EDW ;WARNINGS
 W @IOF
 S J=0
 F  S J=$O(HDW(J)) Q:'J  W !,HDW(J)
 S JJ=""
 F  S JJ=$O(DISW(JJ)) Q:'JJ!$G(BYIMQUIT)  D
 .W !,DISW(JJ)
 .W:$D(DISW(JJ,1)) !,DISW(JJ,1)
 .I IOST["C-",IOSL<($Y+4) D
 ..D PAUSE
 ..I $G(BYIMPAUS)]"",BYIMPAUS[U S BYIMQUIT=1
 ..Q:$G(BYIMQUIT)
 ..W @IOF
 ..S J=0
 ..F  S J=$O(HDW(J)) Q:'J  W !,HDW(J)
 D:'$G(BYIMQUIT) PAUSE
 Q
 ;=====
 ;
IND ;EP;SELECT DISPLAY OF COMBO VAX OR EACH INDIVIDUAL COMPONENT
 ;V3.0 PATCH 7 - FID-106212 SELECT DISPLAY OF COMBO OR INDIVIDUAL VAX
 K DIR
 S DIR(0)="SO^1:The Compound Vaccine Only;2:Each Separate Component"
 S DIR("A")="Select type of display"
 S DIR("B")="The Compound Vaccine Only"
 W !?5,"Select type of display for Compound Vaccines"
 W !?5,"(vaccines with more than one component vaccine)"
 D ^DIR
 K DIR
 I 'Y S BYIMQUIT=1 Q
 S IND=$S(+Y=1:1,1:0)
 ;V3.0 PATCH 7 FID-106212  END
 Q
 ;=====
 ;
PAUSE ;PAUSE
 D PAUSE^BYIMIMM6
 Q
 ;=====
 ;
PID(X) ;EP;DISPLAY RT PID SEGMENT
 N Y,Z
 S Y=$P(X,"|",6)
 S Y=$P(Y,U)_","_$P(Y,U,2)_" "_$P(Y,U,3)
 S (DOB,Z)=$E($P(X,"|",8),1,8)
 S:Z]"" $E(Y,32)=$E(Z,5,6)_"/"_$E(Z,7,8)_"/"_$E(Z,1,4)
 S $E(Y,43)=$P(X,"|",9)_" HRN: "_$E($P($P(X,"|",4),U),7,99)
 S HDR(1)=Y
 S HDR(2)="------------------------------ ---------- - -----------"
 S HDR(3)="  CVX VACCINE ADM DATE AGE    LOCATION REACTION VOL SITE LOT   MAN VALID STATUS"
 S HDR(4)="- --- ------- -------- ------ -------- -------- --- --- ------ --- ----- ------"
 ;FORECAST MESSAGE HEADER
 S HDF(1)=HDR(1)
 S HDF(2)=HDR(2)
 S Y="    IMMUNIZATION FORECAST:"
 S HDF(3)=Y
 S Y="CVX VACCINE     STATUS DUE        EARLIEST   LATEST     STANDARD"
 S HDF(4)=Y
 S Y="--- ----------- ------ ---------- ---------- ---------- --------"
 S HDF(5)=Y
 ;ERROR MESSAGE HEADER
 S HDE(1)=HDR(1)
 S HDE(2)=HDR(2)
 S Y="ERROR MESSAGE(S)"
 S HDE(3)=Y
 S Y="--------------------------------------------------------------------------------"
 S HDE(4)=Y
 ;ERROR MESSAGE HEADER
 S HDW(1)=HDR(1)
 S HDW(2)=HDR(2)
 S Y="WARNING(S)"
 S HDW(3)=Y
 S Y="--------------------------------------------------------------------------------"
 S HDW(4)=Y
 Q
 ;=====
 ;
ERR(RSPDA,DTYP,ERR,QRYDA) ;EP;DISPLAY ERROR AND WARNINGS
 N X,Y,Z,XX,YY,ZZ,X0,BYIMQUIT
 N SEG,CNT,FLD,SFLD,PID,LOC,FAC,NAME,DOB
 N EN,N
 ;DISPLAY NF OR TM IF ON FILE AND QUIT
 S QRYDA=+$G(QRYDA)
 S X=+$O(^BYIMRT(RSPDA,4,0))
 S Y=$G(^BYIMRT(RSPDA,4,X,0))
 I Y]"","NFTM"[$E(Y,1,2) D  Q
 .S X0=$G(^BYIMRT(RSPDA,0))
 .W !,$P($G(^DIC(5,+$P(X0,U,10),0)),U)," reports ",$P(Y,U,2)
 .D PAUSE
 D ARRAY^BYIMRT3(RSPDA,QRYDA)
 S PID=$G(^BYIMRT(QRYDA,1,2,0))
 I PID'["PID|",PID'["QPD|" S PID=$$DPID^BYIMRT3(+$G(DFN))
 S HRN=$E($P($P(PID,"|",4),U),7,99)
 S:$E(HRN)?1N HRN=+HRN
 S LOC=$E($P($P(PID,"|",4),U),1,6)
 S LOC=$S(LOC]"":+$O(^AUTTLOC("C",LOC,0)),1:0)
 S FAC=$P($G(^DIC(4,LOC,0)),U)
 S NAME=$P(PID,"|",$S(PID["PID|":6,1:5))
 S DOB=$P(PID,"|",$S(PID["PID|":8,1:7))
 S PID(1)="NAME: "_$P(NAME,U)_","_$P(NAME,U,2)_" "_$P(NAME,U,3)
 S PID(2)="DOB : "_$E(DOB,5,6)_"/"_$E(DOB,7,8)_"/"_$E(DOB,1,4)
 S PID(3)="HRN : "_HRN_" ("_FAC_")"
 F EN=4,5 D:$D(^BYIMRT(RSPDA,EN)) ODISP
 Q
 ;=====
 ;
ERR11 ;EP;ERROR DISPLAY
 S ERRN=$P(ERR,"|",3)
 S RESP=$P(ERR,"|",4)
 S ETYP=$P(ERR,"|",5)
 S ENOD=$S(ETYP="E":4,1:5)
 S NOTE=$P(ERR,"|",9)
 S SEGN=$P(ERRN,U)
 S:SEGN="" SEGN="ERR"
 S OCC=$P(ERRN,U,2)
 S:'OCC OCC=1
 S X=$E(OCC,$L(OCC))
 S:OCC]"" OCC=OCC_$S(OCC=11!(OCC=12)!(OCC=13):"th",X=1:"st",X=2:"nd",X=3:"rd",1:"th")
 S:SEGN["PID" OCC=1
 S FLD=$S($P(ERRN,U,3):$P(ERRN,U,3),1:1)
 S SFLD=$S($P(ERRN,U,5):$P(ERRN,U,5),1:1)
 S SEGX=SEGN_"-"_FLD_"."_SFLD
 S SEGDA=+$O(^BYIMSEG("B",SEGX,0))
 S FNAM=$P($G(^BYIMSEG(SEGDA,0)),U,4)
 S QPD=$G(^BYIMRT(RSPDA,1,5,0))_$G(^BYIMRT(RSPDA,1,6,0))
 Q
 ;=====
 ;
MSH ;EP;DISPLAY RT MSH SEGMENT
 W !,$TR($P(X,"|",3),"^"," "),"  ",$TR($P(X,"|",4),"^"," "),"  "
 S Y=$P(X,"|",7)
 W $E(Y,5,6),"/",$E(Y,7,8),"/",$E(Y,1,4),"  ",$P(X,"|",9),"  ",$P(X,"|",11)
 Q
 ;=====
 ;
ODISP ;EP;DISPLAY IN SEG ORDER
 N SN,TCNT,ZZ,YY,X,Y,Z,SEGN,OCN,SEG,CNT,FLD,SFLD
 S SN=""
 F  S SN=$O(^BYIMRT(RSPDA,EN,SN)) Q:SN=""  D
 .S N=0
 .F  S N=$O(^BYIMRT(RSPDA,EN,SN,N)) Q:'N!$G(BYIMQUIT)  S RECD=$G(^(N,99)) D
 ..S TCNT=$S(N<1:1,1:N) ;ONLY 1 SENT SEG FOR <1 ARRAY ENTRIES
 ..S SENT=$G(^BYIMTMP("ARR",$J,SN,TCNT))
 ..S Y=$G(^BYIMRT(RSPDA,EN,SN,N,.5))
 ..Q:Y=""
 ..S SEGN=$P(Y,U)
 ..S OCN=$P(Y,U,2)
 ..S CNT=$P(Y,U,2)
 ..S FLD=$P(Y,U,3)
 ..S SFLD=$P(Y,U,4)
 ..W @IOF
 ..I EN=4 D  I 1
 ...W !?4,IORVON
 ...W "ERROR: Patient or Immunization may have been rejected."
 ...W IORVOFF
 ..E  W !?11,"WARNING"
 ..F J=1:1:3 W !?5,PID(J)
 ..W !
 ..F J=2:1:4 S Y=$G(^BYIMRT(RSPDA,EN,SN,N,J)) D:Y]""
 ...W !?5,$E(Y,1,70)
 ...I $L($E(Y,71,140)) W !?5,$E(Y,71,140)
 ...I $L($E(Y,141,210)) W !?5,$E(Y,141,210)
 ...I $L($E(Y,211,999)) W !?5,$E(Y,211,999)
 ..W !!,"HL7 Sent: ",SENT
 ..W !!,"RSP R'cd: ",RECD
 ..I IOST["C-" D PAUSE S:$G(BYIMPAUS)=U BYIMQUIT=1 W @IOF
 ..W !
 K:$G(BYIMQUIT) BYIMQUIT
 Q
 ;=====
 ;
RTALL ;EP;TO SPECIFY NEW ONLY OR ALL IMMUNIZATIONS
 K BYIMALL
 W !!,"Which immunizations should be included:"
 K DIR
 S DIR(0)="SO^1:NEW or EDITED Immunizations;2:ALL Immunizations"
 S DIR("A")="Send NEW or ALL Immunizations"
 S DIR("B")="NEW or EDITED Immunizations"
 D ^DIR
 K DIR
 I 'Y S BYIMQUIT=1 Q
 S (BYIMALL,BYIMADM)=+Y
 I Y=2 S BYIMHX=0
 Q
 ;=====
 ;
