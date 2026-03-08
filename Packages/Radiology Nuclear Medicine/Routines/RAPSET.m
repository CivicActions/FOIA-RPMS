RAPSET ;AISC/MJK/RMO-Routine to set parameters upon sign-on ;9/27/91  11:02    [ 01/17/2002  8:15 AM ]
 ;;4.0;RADIOLOGY;**11**;NOV 20, 1997
 ;
 ;Occurrences of "^" in this routine have been replaced by U 
 ;IHS/HQW/SCR 9/10/01 **11**
 ;
 D CHKSP^RAUTL2 I 'RADV!('RALC) W !!,*7,"You must initialize at least one radiology division and one radiology location",!,"to proceed. Use the routine called 'RASETUP' to do this initialization.",!! K RADV,RALC S XQUIT="" Q
 K RADV,RALC S (RADIV,RALOC,RADEV,DIV,LOC,DEV)="" G LOC:$D(^RA(79.2,"AC","E"))
 D HOME^%ZIS I $D(IOS),IOS S DEV=$P(^%ZIS(1,+IOS,0),U)
 ;
 ;--->                                            ;IHS/ANMC/MWR 02/04/97
 ;---> IF ONLY ONE RADIOLOGY LOCATION EXISTS, SET PARAMS AND GO. IHS/ANMC/MWR 02/04/97
 S LOC=$O(^RA(79.1,0)) I '$O(^RA(79.1,LOC)) D  G:LOC PAR  ;IHS/ANMC/MWR 02/04/97
 .S RALOC=^RA(79.1,LOC,0),DIV=$O(^RA(79,"AL",LOC,0))  ;IHS/ANMC/MWR 02/04/97
 .I DIV'>0!('$D(^RA(79,+DIV,0))) S LOC=0 Q        ;IHS/ANMC/MWR 02/04/97
 .S RADIV=^RA(79,DIV,0)                           ;IHS/ANMC/MWR 02/04/97
 ;---> 
 ;
 G LOC:'$D(IOS),LOC:'$D(^RA(79.1,"AD",DEV)) S LOC=$O(^(DEV,0)) G LOC:LOC'>0!('$D(^RA(79.1,+LOC,0))) S DEVI=$O(^RA(79.1,"AD",DEV,+LOC,0))
 S RALOC=^RA(79.1,LOC,0),DIV=$O(^RA(79,"AL",LOC,0)) I DIV'>0!('$D(^RA(79,+DIV,0))) G LOC
 S RADIV=^RA(79,DIV,0) I $D(^RA(79.1,LOC,"D",DEVI,0)) S:$D(^(.1)) RADEV=^(.1) G PAR
 ;
LOC ;
 I $S('($D(DUZ)#2):1,'DUZ:1,1:0) W !,*7,"Your user code 'DUZ' must be defined to continue." S XQUIT="" G Q^RAPSET1
 S DEV="" W:$D(^RA(79.2,"AC","E")) ?15,"**** Normal Computer is Down. ****",!
 I $D(^DISV(+DUZ,"^RA(79.1,")),$D(^RA(79.1,+^DISV(+DUZ,"^RA(79.1,"),0)) S DIC("B")=$S($D(^RA(79.1,+^DISV(+DUZ,"^RA(79.1,"),0)):$S($D(^SC(+^(0),0)):$P(^(0),U),1:""),1:"") I DIC("B")']"" K DIC("B")
LOC1 ;
 S DIC("A")="Please select a Radiology Location: ",DIC="^RA(79.1,",DIC(0)="AEMQ",DIC("S")="I $D(^RA(79.2,+$P(^(0),U,6),0)),$P(^(0),U,3)=""RA""" D ^DIC K DIC("A"),DIC("S") I X=U S XQUIT="" G Q^RAPSET1
 I Y<0 W !?3,*7,"You must choose a radiology 'location' to continue...or enter '^' to stop." G LOC1
 S LOC=+Y,DIV=$O(^RA(79,"AL",LOC,0)) I DIV'>0!('$D(^RA(79,+DIV,0))) W !,*7,"Radiology division definition error. Call your site manager." S XQUIT="" G Q^RAPSET1
 S RADIV=^RA(79,DIV,0),RALOC=$S($D(^RA(79.1,LOC,0)):^(0),1:"") I RALOC']"" W !!,*7,"Radiology location definition error. Call your site manager." S XQUIT="" G Q^RAPSET1
 ;
PAR ;
 S RAMDIV=DIV,Y=$S($D(^RA(79,DIV,.1)):^(.1),1:""),RAMDV="" F I=1:1 Q:$P(Y,U,I,99)']""  S RAMDV=RAMDV_$S($P(Y,U,I)="Y"!($P(Y,U,I)="y"):1,1:0)_U
 I $P(RAMDV,U,6),DEV,$P(RADEV,U)["Y" S $P(RAMDV,U,6)=0
 ;
 S DTIME=$S($D(^RA(79.2,+$P(RALOC,U,6),0)):$S($P(^(0),U,2)]"":$P(^(0),U,2),1:300),1:300),RAMTY=$S($D(^(0)):$P(^(0),U,3),1:"RA")
 S RAMLC=LOC_U_$S('$P(RAMDV,U,2):+$P(RALOC,U,2),1:0)
 S RAI=$S($P(RALOC,U,3)']"":-1,1:$O(^%ZIS(1,"B",$P(RALOC,U,3),0))),RAFLH=$S($D(^%ZIS(1,+RAI,0)):$P(RALOC,U,3),1:"")
 ;
 ;K IOS I RAFLH']""!($D(^RA(79.2,"AC","E"))) S %ZIS="N",%ZIS("A")="Default Flash Card Printer: " D ^%ZIS S RAFLH=$S(POP:"",IO=IO(0):"",1:ION)  ;Modified for VA patches IHS/HQW/SCR 9/10/01 **11**
 ;
 I RAFLH']""!($D(^RA(79.2,"AC","E"))) S %ZIS="N",%ZIS("A")="Default Flash Card Printer: " D ^%ZIS S RAFLH=$S(POP:"",IO=IO(0):"",1:ION),RAI=$S(RAFLH="":"",1:$O(^%ZIS(1,"B",RAFLH,0)))  ;IHS/HQW/SCR 9/10/01 **11**
 ;
 ;S RAMLC=RAMLC_U_RAFLH_U_$S($P(RAMDV,U,8):$S($P(RALOC,U,4):$P(RALOC,U,4),1:2),1:0),RAFLH=$S(RAFLH']"":0,$D(IOS):IOS,RAI>0:RAI,1:0)  ;Modified for VA patches IHS/HQW/SCR - 10/10/01 **11**
 ;
 S RAMLC=RAMLC_U_RAFLH_U_$S($P(RAMDV,U,8):$S($P(RALOC,U,4):$P(RALOC,U,4),1:2),1:0),RAFLH=$S(RAFLH']"":0,RAI>0:RAI,1:0)  ;IHS/HQW/SCR 9/10/01 **11**
 ;
 S RAI=$S($P(RALOC,U,5)']"":-1,1:$O(^%ZIS(1,"B",$P(RALOC,U,5),0))),RAJAC=$S($D(^%ZIS(1,+RAI,0)):$P(RALOC,U,5),1:"")
 ;
 ;I RAJAC']""!($D(^RA(79.2,"AC","E"))) K IOS S %ZIS="N",%ZIS("A")="Default Jacket Label Printer: " D ^%ZIS S RAJAC=$S(POP:"",IO=IO(0):"",1:ION);Modified for VA patches IHS/HQW/SCR 9/10/01 **11**
 ;
 I RAJAC']""!($D(^RA(79.2,"AC","E"))) S %ZIS="N",%ZIS("A")="Default Jacket Label Printer: " D ^%ZIS S RAJAC=$S(POP:"",IO=IO(0):"",1:ION),RAI=$S(RAJAC="":"",1:$O(^%ZIS(1,"B",RAJAC,0))) ;IHS/HQW/SCR 9/10/01 **11**
 ;
 ;S RAMLC=RAMLC_U_RAJAC_U_$P(RALOC,U,6,9),RAJAC=$S(RAJAC']"":0,$D(IOS):IOS,RAI>0:RAI,1:0) ;Modified for VA patches IHS/HQW/SCR 9/10/01 **11**
 ;
 S RAMLC=RAMLC_U_RAJAC_U_$P(RALOC,U,6,9),RAJAC=$S(RAJAC']"":0,RAI>0:RAI,1:0) ;IHS/HQW/SCR 9/10/01 **11**
 ;
 S RAI=$S($P(RALOC,U,10)']"":-1,1:$O(^%ZIS(1,"B",$P(RALOC,U,10),0))),RARPT=$S($D(^%ZIS(1,+RAI,0)):$P(RALOC,U,10),1:"")
 ;
 ;I RARPT']""!($D(^RA(79.2,"AC","E"))) K IOS S %ZIS="N",%ZIS("A")="Default Report Printer: " D ^%ZIS S RARPT=$S(POP:"",IO=IO(0):"",1:ION) ;Modified for VA patches IHS/HQW/SCR 9/10/01 **11**
 ;
 I RARPT']""!($D(^RA(79.2,"AC","E"))) S %ZIS="N",%ZIS("A")="Default Report Printer: " D ^%ZIS S RARPT=$S(POP:"",IO=IO(0):"",1:ION),RAI=$S(RARPT="":"",1:$O(^%ZIS(1,"B",RARPT,0))) ;IHS/HQW/SCR 9/10/01 **11**
 ;
 ;---> NEXT LINE CHANGE TO ADD PCS 14-18 TO RAMLC FOR REQUEST   PTR  ;IHS/ANMC/MWR 06/03/92
 ;S RAMLC=RAMLC_U_RARPT_U_$P(RALOC,U,11,13),RARPT=$S(RARPT']"":0,$D(IOS):IOS,RAI>0:RAI,1:0) K IOS S LINE="",$P(LINE,"-",80)=""   ;IHS/ANMC/MWR 06/03/92
 ;
 S RAMLC=RAMLC_U_RARPT_U_$P(RALOC,U,11,18)  ;IHS/ANMC/MWR 06/03/92
 S RARPT=$S(RARPT']"":0,$D(IOS):IOS,RAI>0:RAI,1:0) ;IHS/ANMC/MWR 06/03/92
 ;K IOS S LINE="",$P(LINE,"-",80)=""              ;IHS/ANMC/MWR 06/03/92
 S LINE="",$P(LINE,"-",80)="" ;                     IHS/ISD/EDE 02/13/97
 ;---> NEXT LINE QUITS IF CALL IS FROM ORDER ENTRY IHS/ANMC/MWR 06/03/92
 Q:$D(RAZOREX)
 ;
 ;
 ;G ^RAPSET1 ;Modified for VA patches IHS/HQW/SCR 9/10/01 **11**
 D HOME^%ZIS G ^RAPSET1  ;IHS/HQW/SCR 9/10/01 **11**
