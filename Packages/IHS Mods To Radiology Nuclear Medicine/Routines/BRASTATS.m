BRASTATS ;IHS/WOIFO/JSL - BRA PATIENT RAD EXAM REPORT ;05 DEC 2023@22:36
 ;;5.0;Radiology/Nuclear Medicine;**1010**;Mar 16, 1998;Build 1
 Q
ENTRY ; Entry point from Patient Radiology Exams menu
 I '$D(DUZ) U 0 W *7,"No DUZ defined, Please login RPMS with the user's access code first." H 1 Q
 N RALOC,RAPROC,RAQUIT,RAXIT,DIR,DIC,X,Y,RATOTAL,RADIV
 I $O(RACCESS(DUZ,""))="" S RAPSTX="" D VARACC^RAUTL6(DUZ)
 K ^TMP($J,"RASTAT")
 W !,"Rad/Nuc PATIENT RAD EXAM REPORT",!
 S DIR(0)="S^L:Location;I:Imaging Type;D:Division;T:Totals Only"
 S DIR("A")="Enter Report Detail Needed",DIR("B")="Location"
 S RARPT=1,RAQUIT=0,RATOTAL=0
 S X=$$DIVLOC S:'X ZTDESC="Rad/Nuc PATIENT RAD EXAM REPORT"
 I 'X!'$G(RAQUIT) D RAINIT  ;init the job
 U IO W !,"Total: ",RATOTAL,!
 D PURGE
 QUIT
 ;
DIVLOC() ; Entry point to setup division/img-typ/img-loc  access
 N X
 ;
 S RAXIT=$$SETUPDI^RAUTL7()
 I RAXIT D CLEAN(1) Q 1
 ;
 D SETUP^RAUTL7A
 S X=$$DIVLOC^RAUTL7()
 I X K RACCESS(DUZ,"DIV-IMG") D CLEAN(1) Q 1
 ; 
 S X=""
 F  S X=$O(^TMP($J,"RA I-TYPE",X)) Q:X=""  S ^TMP($J,"RA I-TYPE-INDEX",$O(^TMP($J,"RA I-TYPE",X,"")))=X
 ;
 D RADIV ; <-------------- Select Rad division(s)
 I '$D(^TMP($J,"RA D-TYPE")) Q 1
 ;
 S X=0
 F  S X=$O(^TMP($J,"DIV-IMG",X)) Q:X'=+X  I $D(RACCESS(DUZ,"IMG",X)) S ^TMP($J,"RA I-TYPE",$P($G(^RA(79.2,+X,0)),U),X)="",^TMP($J,"RA I-TYPE-INDEX",X)=$P($G(^RA(79.2,+X,0)),U)
 ;
 D SELLOC^RAUTL7
 D RALOC ; Select Rad location(s)
 I '$D(^TMP($J,"RA LOC-TYPE")) Q 1
 D RAPROC ; Select exam procedure
 K ^TMP($J,"DIV-IMG")
 Q 0
 ;
CLEAN(RAXIT)  ; Clean temp globals and vars 
 K ^TMP($J,"DIV-IMG")
 ;
 I RAXIT K RAXIT K:$D(RAPSTX) RACCESS,RAPSTX,I,POP,RAQUIT Q
 Q
 ;
RAINIT ; Init TMP globals before generating report
 N A,B
 S A=""
 F  S A=$O(RACCESS(DUZ,"DIV-IMG",A)) Q:A']""  D
 . Q:'$D(^TMP($J,"RA D-TYPE",A))
 . S ^TMP($J,"RASTAT","RADIV",A)=0,B=""
 . F  S B=$O(RACCESS(DUZ,"DIV-IMG",A,B)) Q:B']""  D
 .. Q:'$D(^TMP($J,"RA I-TYPE",B))
 .. S ^TMP($J,"RASTAT","RAIMG",A,B)=0
 .. Q
 . Q
 ; 
 S ZTRTN="START^BRASTATS"
 F I="BEGDTX","ENDDTX","BEGDATE","ENDDATE","RARPT","RATMEFRM","^TMP($J,""RA D-TYPE"",","^TMP($J,""RA I-TYPE"",","^TMP($J,""RASTAT""," S ZTSAVE(I)=""
 D DATE^RAUTL G:RAPOP PURGE
 S BEGDTX=$$FMTE^XLFDT(BEGDATE,1),ENDDTX=$$FMTE^XLFDT(ENDDATE,1)
 S RATMEFRM="For Period: "_BEGDTX_" to "_ENDDTX_"."
 W !
 D ZIS^RAUTL
 I RAPOP D PURGE Q
 ;
START ; Set-up date variables for selected date range.
 ; NOTE: RADTE is the exam reg date/time, and RADTI is the
 ; internal date number
 U IO S RABEG=BEGDATE-.0001,RAEND=ENDDATE+.9999 D HD1
 S RACNB=6,RADU="C:CONTRACT;E:EMPLOYEE;I:INPATIENT;O:OUTPATIENT;R:RESEARCH;S:SHARING;"
 F RADTE=RABEG:0 S RADTE=$O(^RADPT("AR",RADTE)) Q:'RADTE!(RADTE>RAEND)  D  Q:$G(RAXIT)
 . S RADTI=9999999.9999-RADTE,RADAT=$P(RADTE,".") D RADFN
 . Q
 ; generate report
 S (RAPGE,RATOT,RAXIT)=0,RARUNDT=$$FMTE^XLFDT($$DT^XLFDT(),1)
 S $P(RALINE,"-",78)=""
 I '$D(^TMP($J,"RASTAT","RALOC")) D PURGE Q
 I 'RAXIT D DIVSYN
 D PURGE
 Q
1 ; Print Location Statistics
 S RADNM=$O(^TMP($J,"RASTAT","RALOC",""))
 S RAINM=$O(^TMP($J,"RASTAT","RALOC",RADNM,""))
 S RALNM=$O(^TMP($J,"RASTAT","RALOC",RADNM,RAINM,""))
 S T1=1 D HD^RAESR3 S RADNM=""
 F  S RADNM=$O(^TMP($J,"RASTAT","RALOC",RADNM)) Q:RADNM=""  D  Q:RAXIT
 . S RAINM=""
 . F  S RAINM=$O(^TMP($J,"RASTAT","RALOC",RADNM,RAINM)) Q:RAINM=""  D  Q:RAXIT
 .. S RALNM=""
 .. F  S RALNM=$O(^TMP($J,"RASTAT","RALOC",RADNM,RAINM,RALNM)) Q:RALNM=""  D  Q:RAXIT
 ... S RADAT=0
 ... F  S RADAT=$O(^TMP($J,"RASTAT","RALOC",RADNM,RAINM,RALNM,RADAT)) Q:'RADAT  D  Q:RAXIT
 .... S RASTAT=$G(^TMP($J,"RASTAT","RALOC",RADNM,RAINM,RALNM,RADAT))
 .... S RADAT("X")=$$FMTE^XLFDT(RADAT,1) D PRT^RAESR3
 .... ;;W !,"TMP($J,""RASTAT"",""RALOC"")",RADNM,U,RAINM,U,RALNM,U,RADAT,!  ;BRA1010
 .... Q
 ... D LOCCHK^RAESR2 Q:RAXIT
 ... Q
 .. D IMGCHK^RAESR2 Q:RAXIT
 .. Q
 . D DIVCHK^RAESR2 Q:RAXIT
 . Q
 Q
 ;
HD1 ; report Header
 Q:$G(RAXIT)!$G(RAQUIT)
 U IO W "Name^ Pt ID^ Ward/Clinic Procedure^ Exam Status^ Case #^ Exam DT^ Requesting Provider^ Rad/Nuc Med Div^ Imaging Location",!
 I $G(IOSL)=24 U IO W "---------- ---------- ----------- ----- -------- ---------- ---------- --------",!
 Q
RADIV ; Select Rad/Nuc Med Division
 S Y="" F X=1:1 S Y=$O(^TMP($J,"RA D-TYPE",Y)) Q:Y=""  S RADIV(Y)=X ;screen set
 Q
RALOC ; Select Imaging Location
 S Y="" F X=1:1 S Y=$O(^TMP($J,"RA LOC-TYPE",Y)) Q:Y=""  S RALOC(Y)=X ;screen set
 Q
RAPROC ; Select one/many/all Rad/Nuc Med procedures
 N RADIC,RAUTIL,DIC
 ;
 K ^TMP($J,"RA PROCEDURES"),RAPROC
 S RADIC="^RAMIS(71,",RADIC(0)="QEAMZ",RAUTIL="RA PROCEDURES"
 S RADIC("A")="Select Procedures: ",RADIC("B")="All",RAXIT=0
 S RADIC("S")="I $$SCRPROC^BRASTATS(+Y)"
 W !! D EN1^RASELCT(.RADIC,RAUTIL)
 S Y="" F X=1:1 S Y=$O(^TMP($J,"RA PROCEDURES",Y)) Q:Y=""  S RAPROC(Y)=X ;screen set
 K %W,%Y1,DIC,RADIC,RAUTIL,X,Y
 Q
 ;
SCRPROC(DA)  ; screen procudres
 N RA71,IMGTYP
 S RA71(0)=$G(^RAMIS(71,DA,0))
 Q:'$P(RA71(0),U,9) 0   ; must have a CPT code (detailed/series)
 S IMGTYP=$P(RA71(0),U,12)  ; Type of Imaging
 Q:'$D(^TMP($J,"RA I-TYPE-INDEX",IMGTYP)) 0
 S RA71("I")=$G(^RAMIS(71,DA,"I"))
 I $P(RA71("I"),U,1) Q 0
 Q 1
 ;
PURGE ; Kill variables, close device and exit
 K %DT,%W,%Y1,A,B,BEGDATE,BEGDTX,ENDDATE,ENDDTX,I,RABEG,RACMP,RACNB
 K RACNI,RACTE,RAD0,RADAT,RADFN,RADNB,RADNM,RADTE,RADTI,RADU,RAEND,RAFLG
 K RAINM,RALINE,RALNM,RAP0,RAPGE,RAPOP,RAQUIT,RARD,RARPT,RARUNDT,RASTAT
 K RATMEFRM,RATMP,RATOT,RAXIT,RAZ,T,T1,X,X1,Y,Z,ZTDESC,ZTRTN,ZTSAVE
 K ^TMP($J,"RASTAT"),^TMP($J,"RA D-TYPE"),^TMP($J,"RA I-TYPE"),VA("PID")
 K ^TMP($J,"DIV-ITYP-ILOC")
 K ^TMP($J,"RA I-TYPE-INDEX")
 K ^TMP($J,"RA LOC-TYPE")
 K ^TMP($J,"RA PROCEDURES")
 K:$D(RAPSTX) RACCESS,RAPSTX
 D CLOSE^RAUTL
 K POP,RAMES
 Q
DIVSYN ; Division synopsis
 S RAXIT=$$EOS^RAUTL5() Q:RAXIT
 S (RADNM,RAINM,RALNM)="" D HD^RAESR3
 N A,B,C
 S A="",C=0
 F  S A=$O(^TMP($J,"RASTAT","RAIMG",A)) Q:A']""  D  Q:RAXIT
 . W !!,"Division: ",A,!?3,"Imaging Type(s): " S B="",C=C+1
 . F  S B=$O(^TMP($J,"RASTAT","RAIMG",A,B)) Q:B']""  D  Q:RAXIT
 .. I $Y>(IOSL-4) S RAXIT=$$EOS^RAUTL5() Q:RAXIT  D HD^RAESR3
 .. W:$X>(IOM-25) !?($X+$L("Imaging Type(s): ")+3) W B,?($X+3)
 .. Q
 . W ! S RATOT=$G(^TMP($J,"RASTAT","RADIV",A)) D TOT1^RAESR3
 . Q
 I C>1 D
 . I $Y>(IOSL-4) S RAXIT=$$EOS^RAUTL5() Q:RAXIT  D HD^RAESR3
 . W !!?3,"Total Over All Divisions:",!
 . S RATOT=$G(^TMP($J,"RASTAT","RATOT")) D TOT1^RAESR3
 . Q
 Q
 ;
RADFN ; Set RADFN the internal file number in the patient file 70, and check if
 ; an Exam was registered on the specified date, RADTE
 ; if so set RADO to the value of the Exam Registration node via the naked reference
 N DATA,I,NO,X,PID,CASENM,REQPVD,PTNAME,DFN,RARPC,RASTA,RADFN,EXAMDT,RACNI,RAMDIV,RAIMGLOC,CNT,UP
 S (CNT,RADFN)=0 S UP=$S($G(IO("HFSIO"))="":"  ",1:"^")
 F CNT=0:0 S RADFN=$O(^RADPT("AR",RADTE,RADFN)) Q:'RADFN  I $D(^RADPT(RADFN,"DT",RADTI,0)) S RAD0=$G(^(0)) D  Q:$G(RAXIT)
 . S NO=+$P($G(^RADPT(RADFN,"DT",RADTI,"P",0)),U,3),DFN=+$G(^RADPT(RADFN,0)),PTNAME=$P($G(^DPT(DFN,0)),U)
 . S RAMDIV=$P(RAD0,U,3) S:+RAMDIV RAMDIV=$P($G(^DIC(4,+RAMDIV,0)),U)
 . I $L($O(RADIV(""))) Q:($L(RAMDIV)<1)  Q:'$D(RADIV(RAMDIV))      ;Med Division screen
 . S RAIMGLOC=$P(RAD0,U,4) S:+RAIMGLOC RAIMGLOC=+$P($G(^RA(79.1,+RAIMGLOC,0)),U),RAIMGLOC=$P($G(^SC(RAIMGLOC,0)),U)
 . I $L($O(RALOC(""))) Q:($L(RAIMGLOC)<2)  Q:'$D(RALOC(RAIMGLOC))  ;IMG LOC screen
 . F RACNI=1:1:NO S DATA=$G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)) I $L(DATA) D  Q:$G(RAXIT)  ;RACNI
 .. S CASENM=$P(DATA,U),RARPC=$P(DATA,U,2),RASTA=$P(DATA,U,3),EXAMDT=$$FMTE^XLFDT(+RAD0,1),REQPVD=$P(DATA,U,14)
 .. S:+REQPVD REQPVD=$P($G(^VA(200,REQPVD,0)),U)
 .. S:+RARPC RARPC=$P($G(^RAMIS(71,+RARPC,0)),U) I $L($O(RAPROC(""))) Q:($L(RARPC)<2)  Q:'$D(RAPROC(RARPC))  ;EXAM procedure screen
 .. S:+RASTA RASTA=$P($G(^RA(72,+RASTA,0)),U)
 .. I $$ISIHS^MAGSPID() S DFN=RADFN D DEM^VADPT S PID=$S($G(VA("PID")):VA("PID"),1:DFN) ;PID/MRN
 .. ;Name^ Pt ID^ Ward/Clinic Procedure^ Exam Status^ Case #^ Exam DT^ Requesting Provider^ Rad/Nuc Med Div^ Imaging Location
 .. U IO W PTNAME,UP,$G(PID,RADFN),UP,RARPC,UP,RASTA,UP,CASENM,UP,EXAMDT,UP,REQPVD,UP,RAMDIV,UP,RAIMGLOC,!
 .. S RATOTAL=RATOTAL+1
 .. I $G(IOSL)=24 I (RATOTAL#10)=0 S RAXIT=$$EOS^RAUTL5() Q:RAXIT  U IO W ! D HD1
 .. Q
 . Q
 K VA("PID")
 Q
