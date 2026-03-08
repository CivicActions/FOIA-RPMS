RAHLQ ;IHS/HQW/SCR-Process Query Message (QRY) Type; [ 11/23/2001  9:21 AM ]
 ;;4.0;RADIOLOGY;**11**;NOV 20, 1997
 ;
 ;Routine added to include VA patches in patch **11** 
 ;IHS/HQW/SCR 9/24/01 **11**
 ;
 I 'HLDUZ S HLERR="Invalid Access Code" G ACK
 N I,X,X0,X1,Y K HLERR S RAN=3,RAII=+$O(^HL(772,HLDA,"IN",1)) S RAX0=$G(^(RAII,0)) I $P(RAX0,HLFS)'="QRD" S HLERR="Invalid Segment Type" G ACK
 D CHKPRV I '$D(HLERR) D QRD
ACK ;
 ;Compile 'ACK' Segment
 S:$D(HLERR) $P(HLSDATA(1),HLFS,9)="ACK" S HLMTN=$P(HLSDATA(1),HLFS,9)
 I $D(HLERR) S X1=HLSDATA(1) K HLSDATA S HLSDATA(1)=X1
 S HLSDATA(2)="MSA"_HLFS_$S($D(HLERR):"AE",1:"AA")_HLFS_HLMID_$S($D(HLERR):HLFS_HLERR,1:"")
 S HLSDATA(3)=RAX0,$P(HLSDATA(3),HLFS,8)=$S($D(RAEXAM):1_$E(HLECH)_"RD",'$D(RAC):0,1:(RAC-1)_$E(HLECH)_"RD")
 K DFN,RAC,RACN0,RACNI,RACT,RADFN,RADTI,RAEXAM,RAI,RAII,RAN,RARAD,RASSN,RAX0,VA,VADM,VAERR
 D:$D(HLTRANS) EN1^HLTRANS Q
 ;Analyze 'QRY' Message from Non-DHCP System
QRD ;
 S RACT=$P($P(RAX0,HLFS,8),$E(HLECH)) S:$P(RAX0,HLFS,11)="PATIENT" RASSN=$P(RAX0,HLFS,9) S:$P(RAX0,HLFS,11)="EXAM" RAEXAM=$P(RAX0,HLFS,9)
 I '$D(RASSN),'$D(RAEXAM) S HLERR="Invalid "_$S($P(RAX0,HLFS,11)="PATIENT":"Patient",1:"Exam")_" ID" Q
 I $D(RASSN) I '$S(RASSN?9N:1,RASSN?9N1A:1,RASSN?1A4N:1,1:0) S HLERR="Invalid Patient ID" Q
 I $D(RAEXAM) I '$S(RAEXAM?6N1"-".N:1,RAEXAM?.N:1,1:0) S HLERR="Invalid Exam ID" Q
 D:$D(RASSN) SSN D:$D(RAEXAM) EXAM K RARPT Q
 ;Look Up Query Subject by SSN or BS5 X-refs
SSN ;
 S:$E(RASSN)?1L RASSN=$C($A($E(RASSN))-32)_$E(RASSN,2,5) S RAI=$S(RASSN?1U4N:"BS5",1:"SSN") S:$L(RASSN)=10&($E(RASSN,10)?1L) RASSN=$E(RASSN,1,9)_$C($A($E(RASSN,10))-32)
 S RADFN=$O(^DPT(RAI,RASSN,0)) I 'RADFN S HLERR="Invalid Patient Identifier" Q
 I $O(^DPT(RAI,RASSN,RADFN)) S HLERR="Ambiguous Patient Identifier" Q
 I '$D(^RADPT(RADFN)) S HLERR="No Exams on File for This Patient" Q
 K VADM,VAERR S DFN=RADFN D DEM^VADPT I VADM(1)']"" S HLERR="Invalid Patient Identifier" Q
 S RAC=0
 F RADTI=0:0 S RADTI=$O(^RADPT(RADFN,"DT",RADTI)) Q:RADTI'>0!(RAC>RACT)  F RACNI=0:0 S RACNI=$O(^RADPT(RADFN,"DT",RADTI,"P",RACNI)) Q:RACNI'>0!(RAC>RACT)  I $D(^(RACNI,0)) S RACN0=^(0) D  I 'RARPT S RAC=RAC+1 Q:RAC>RACT  D ^RAHLQ1
 .S RARPT=+$P(RACN0,U,17) Q:'RARPT  S RARPT=$G(^RARPT(RARPT,0)),RARPT=$S($P(RARPT,U,5)["D":0,1:1)
 I 'RAC S HLERR="No Exams on File for This Patient"
 Q
EXAM ;
 ;Look Up Query Subject by Exam/Case Number
 S RAI=$S(RAEXAM["-":"ADC",1:"C")
 S RADFN=$O(^RADPT(RAI,RAEXAM,0)) I 'RADFN S HLERR="Invalid Exam Number or Exam Already Complete" Q
 I $O(^RADPT(RAI,RAEXAM,RADFN)) S HLERR="Ambiguous Exam Number" Q
 S RADTI=$O(^RADPT(RAI,RAEXAM,RADFN,0)) I 'RADTI S HLERR="Invalid Exam Number" Q
 S RACNI=$O(^RADPT(RAI,RAEXAM,RADFN,RADTI,0)) I 'RACNI S HLERR="Invalid Exam Number" Q
 S RACN0=$S($D(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)):^(0),1:"") I 'RACN0 S HLERR="Invalid Case Number" Q
 I $P(RACN0,U,17) S RARPT=$G(^RARPT($P(RACN0,U,17),0)),RARPT=$S($P(RARPT,U,5)["D":0,1:1) I RARPT S HLERR="Report Already On File" Q
 K VA,VADM,VAERR S DFN=RADFN D DEM^VADPT I VADM(1)']"" S HLERR="Invalid Patient Identifier" Q
 D ^RAHLQ1 Q
CHKPRV ;
 ;Check for valid radiologist
 S RARAD=$S($D(^VA(200,"ARC","S",HLDUZ)):15,$D(^VA(200,"ARC","R",HLDUZ)):12,1:"") I 'RARAD S HLERR="Provider is not a Radiologist" Q
 I '$D(^XUSEC("RA VERIFY",HLDUZ)) S HLERR="Provider does not hold the appropriate Radiology security key" Q
 I '$S('$D(^VA(200,HLDUZ,"RA")):1,$P(^("RA"),U)'="Y":1,1:0) K HLESIG
 Q
