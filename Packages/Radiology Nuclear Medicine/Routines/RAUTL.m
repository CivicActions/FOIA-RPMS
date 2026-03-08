RAUTL ; IHS/ADC/PDW -Radiology Utility Routine 10:53 ;    [ 11/01/2001  12:04 PM ]
 ;;4.0;RADIOLOGY;**11**;NOV 20, 1997
 ;
DATE ;
 S POP=0 K BEGDATE,ENDDATE W !!,"**** Date Range Selection ****"
 W ! S %DT="APEX"_$S($D(RASKTIME):"T",1:""),%DT("A")="   Beginning DATE : ",%DT(0)=$S($D(RADDT):"0000101",1:-DT) D ^%DT S:Y<0 POP=1 Q:Y<0  S (%DT(0),BEGDATE)=Y
END ;
 W ! S %DT="APEX"_$S($D(RASKTIME):"T",1:""),%DT("A")="   Ending    DATE : " D ^%DT K %DT S:Y<0 POP=1 Q:Y<0  S ENDDATE=Y
 Q
 ;
ZIS ;
 I '$D(ZTDESC) S ZTDESC=$S($D(ZTRTN):ZTRTN,1:"UNKNOWN OPTION")
 S RAMES=$S($D(RAMES):RAMES,1:"W !?5,*7,""Request Queued."",!")
 ;
 ;---> NEXT LINE: "Q"=QUEUABLE, "M"=ASK RIGHT MARGIN, "P"=DEFAULT  ;IHS/ANMC/MWR 06/03/92
 ;---> CLOSEST PRINTER.                           ;IHS/ANMC/MWR 06/03/92
 S %ZIS="QMP" D ^%ZIS Q:POP  I $D(RAZIS),$E(IOST)'="P" D ^%ZISC W *7,!?5,"You must select a printer for this output.",! G ZIS
 ;
 ;---> NEXT LINE: IF NOT QUEUED, GO ZIS1 AND QUIT (DON'T SET POP=1).  ;IHS/ANMC/MWR 06/03/92
 G ZIS1:'$D(IO("Q"))
 ;
 ;---> NEXT LINE: LINE LABEL "ZISQ" ADDED FOR ENTRY WHERE DEVICE  ;IHS/ANMC/MWR 06/03/92
 ;---> INFO HAS ALREADY BEEN ASKED AND USER QUEUED OUTPUT.   ;IHS/ANMC/MWR 06/03/92
ZISQ ;                                                ;IHS/ANMC/MWR 06/03/92
 ;---> NEXT LINES: JOB WAS QUEUED, THEREFORE SET POP=1 SO THAT THE  ;IHS/ANMC/MWR 06/03/92
 ;---> CALLING ROUTINE WILL QUIT (AND LET TASKMAN FINISH THIS JOB).  ;IHS/ANMC/MWR 06/03/92
 K IO("Q") S ZTIO=$S($D(ION):ION,1:"") I ZTIO]"" S ZTIO=ZTIO_$S($D(IO("DOC")):";"_IOST_";"_IO("DOC"),1:";"_IOST_";"_IOM_";"_IOSL)
 ;D ^%ZTLOAD X:$D(ZTSK) RAMES K RAMES,ZTDESC,ZTSK,ZTIO,ZTSAVE,ZTRTN,RASV,ZTDTH S POP=1 Q
 ;
 ;Above line modified for VA patches IHS/HQW/SCR - 9/5/01 **11**
 D ^%ZTLOAD X:$D(ZTSK) RAMES K RAMES,ZTDESC,ZTSK,ZTIO,ZTSAVE,ZTRTN,RASV,ZTDTH D HOME^%ZIS S POP=1 Q  ;IHS/HQW/SCR - 9/5/01 **11**
 ;
ZIS1 ;
 K RAMES,ZTDESC,ZTRTN,ZTSAVE Q
 ;
CLOSE ;EP
 ;Above entry point invoked by RAEDCN - IHS/HQW/SCR 8/27/01 **11**
 I $D(ZTQUEUED) S ZTREQ="@" Q
 D ^%ZISC Q
 ;
EN ;EP
 ;Above entry point invoked by RASTED - IHS/HQW/SCR - 8/27/01 **11**
 ;Entry point to credit x-ray clinic stops
 I '$D(RAMDIV)!'$D(RADTE)!'$D(RADFN)!'$D(RAPRIT) G NOGO
 S SDIV=RAMDIV,SDATE=$P(RADTE,"."),DFN=RADFN,SDC="",SDMSG="S"
 G NOGO:'$D(^RAMIS(71,RAPRIT,0)) S X=+$P(^(0),"^",9),X=$S($D(^ICPT(X,0)):$P(^(0),"^"),1:"")
 I X S X1=$S($D(^RA(79,RAMDIV,"PC")):^("PC"),1:"") G NOGO:'X1 S SDCPT(1)="900^"_X1_"^"_X
 I $O(^RAMIS(71,RAPRIT,2,0)) F I=0:0 S I=$O(^RAMIS(71,RAPRIT,2,I)) Q:I'>0  I $D(^RAMIS(71,RAPRIT,2,I,0)) S RAPR=+$P(^(0),"^") I $D(^RAMIS(71.1,RAPR,0)) F J=0:0 S J=$O(^RAMIS(71.1,RAPR,1,"B",J)) Q:J'>0  D CON
 ;
 ;
 ;---> REQUIRES MAS 5.0                           ;IHS/ANMC/MWR 06/03/92
 ;S SDCTYPE=$S($D(SDCPT(1)):"B",1:"S") W:'$D(ZTQUEUED) !!?5,"Attempting to credit a Radiology Clinic Stop.",! D EN3^SDACS I SDERR=1 G NOGO  ; CMT'D OUT                                                           ;IHS/ANMC/MWR 06/03/92
 G NOGO                                           ;IHS/ANMC/MWR 06/03/92
 ;
 ;MAS 5.0 is in place.
 ;Modified to include VA patches IHS/HQW/SCR - 9/5/01 **11**
 S SDCTYPE=$S($D(SDCPT(1)):"B",1:"S") W:'$D(ZTQUEUED) !!?5,"Attempting to credit a Radiology Clinic Stop.",! D EN3^SDACS I SDERR=1 G NOGO
 S $P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),"^",24)="Y" W:'$D(ZTQUEUED) !?5,"Radiology Clinic Stop credited." G EXIT
CON ;
 S K=$S($D(^DIC(40.7,+J,0)):$P(^(0),"^",2),1:"") I K S:SDC'[K SDC=K_"^"_SDC
 Q
 ;
 ;---> NEXT LINE COMMENTED OUT TO INHIBIT UNNECESSARY MESSAGE.   ;IHS/ANMC/MWR 06/03/92
NOGO ;
 ;W:'$D(ZTQUEUED) *7,!?5,"Unable to credit a Radiology Clinic Stop!",!  ;IHS/ANMC/MWR 06/03/92
 ;
EXIT ;
 K I,J,K,RAPR,SDC,SDCPT,SDCTYPE,SDERR,SDATE,SDIV,X,X1 Q
 ;
D ;EP
 ;Above entry point invoked by RABTCH1 - IHS/HQW/SCR - 8/27/01 **11**
 S Y=$P("JAN^FEB^MAR^APR^MAY^JUN^JUL^AUG^SEP^OCT^NOV^DEC","^",$E(Y,4,5))_" "_$S(Y#100:$J(Y#100\1,2)_",",1:"")_(Y\10000+1700)_$S(Y#1:"  "_$E(Y_0,9,10)_":"_$E(Y_"000",11,12),1:"") Q
 ;
USER ;
 S RADUZ=DUZ S:'$D(RAMDV) RAMDV="" I '$P(RAMDV,"^",6) S %="A",%DUZ=DUZ W ! D ^XUVERIFY G USERQ:%=-1 I %'=1 W *7," ??" G USER
USER1 ;
 Q:'$D(RAKEY)  Q:$D(^XUSEC(RAKEY,RADUZ))  W !!?3,*7,"Must be a user with the appropriate privileges to continue!"
USERQ ;
 S RAPOP=1 Q
 ;
DEV ;EXECUTEABLE HELP FOR DEVICE FIELDS IN FILE 79.1 (RADIOLOGY LOCATIONS)
 ;
 ;D HOME^%ZIS W @IOF,!,"The following is a list of possible devices. You must choose",!,"one of these by entering in the device's full name.",!!,"NOTE: This field is not a pointer field to file 3.5!",!        ;IHS/ANMC/MWR 06/03/92
 ;---> REMOVE IOF SO USER CAN SEE WHAT DEVICES ARE ALREADY THERE.  ;IHS/ANMC/MWR 06/03/92
 D HOME^%ZIS W !,"The following is a list of possible devices. You must choose",!,"one of these by entering in the device's full name.",!!,"NOTE: This field is not a pointer field to file 3.5!",!              ;IHS/ANMC/MWR 06/03/92
 ;
 ;
 W !?3,"Device Name:",?25,"Device Location:",!?3,"------------",?25,"----------------"
 F I=0:0 S I=$O(^%ZIS(1,I)) Q:I'>0  I $D(^(I,0)) W !?3,$P(^(0),"^"),?25,$S($D(^(1)):^(1),1:"") I ($Y+4)>IOSL R !,"(Type ""^"" to stop)",X:DTIME Q:'$T!(X="^")  W @IOF
 Q
 ;
VERIFY ;Ask Access Code
 K RADUZ S %="A",%DUZ=DUZ W ! D ^XUVERIFY S RADUZ=DUZ Q:%=-1!(%=1)  W:%=2 *7,!,"Sorry, that's not your access code.  Try again." W:%=0 !,"Enter your access code or an uparrow to exit." G VERIFY
 ;
A ;
 ;CREATE SIGNATURE BLOCK NAME
 S %X=$P(^VA(200,RASIG("PER"),0),"^"),%X=$P(%X,",",2)_" "_$P(%X,",")_$P(%X,",",3),$P(^VA(200,RASIG("PER"),20),"^",2)=%X K %X Q
DUZ ;
 ;LOOKUP AND SET RASIG("PER")=NEW PERSON FILE IFN
 S %=1 I $D(DUZ)#2,+DUZ>0,$D(^VA(200,DUZ,0)) S RASIG("PER")=DUZ
 I '$D(RASIG("PER")) S %=0 W:'$D(%INT) !,*7,"YOU ARE NOT IN THE 'NEW PERSON' FILE. CONTACT YOUR IRM SERVICE",! K %INT Q
 I '$D(^VA(200,RASIG("PER"),20)) D A K %INT Q
 I $P(^VA(200,RASIG("PER"),20),"^",2)="" S %X=$P(^VA(200,RASIG("PER"),0),"^"),%X=$P(%X,",",2)_" "_$P(%X,",")_$P(%X,",",3),$P(^(20),"^",2)=%X K %X
 S RASIG("NAME")=$P(^VA(200,RASIG("PER"),20),"^",2) K %INT Q
 ;
SSN(PID,BID,DOD) ;EP
 ;Above entry point invoked by RARTVER1 - IHS/HQW/SCR - 8/27/01 **11**
 ;returns full Pt.ID (VA("PID")), BID=1 returns VA("BID")
 ;DOD is defined to internal entry # of eligibility of desired Pt.ID
 N DFN
 I '$D(RADFN) Q "Unknown"
 S:'$D(BID) BID="" S:$D(DOD) VAPTYP=DOD
 ;
 ;
 ;---> CALL RA ROUTINE FOR COMPATIBLILTY WITH MAS 4.   ;IHS/ANMC/MWR 06/03/92
 ;S DFN=RADFN D PID^VADPT6 I VAERR K VAERR Q "Unknown"   ;IHS/ANMC/MWR 06/03/92
 ;S DFN=RADFN D PID^RAZDPT                        ;IHS/ANMC/MWR 06/03/92
 ;
 ;Above lines commented out for VA patches - MAS 5.0 is now required
 ;IHS/HQW/SCR - 9/5/01 **11**
 S DFN=RADFN D PID^VADPT6 I VAERR K VAERR Q "Unknown" ;IHS/HQW/SCR-9/5/01**11** 
 I VAERR K VAERR Q "Unknown"                      ;IHS/ANMC/MWR 06/03/92
 S RASSN=$S(BID:VA("BID"),1:VA("PID"))
 K VA("BID"),VA("PID"),VAERR,VAPTYP
 Q RASSN
