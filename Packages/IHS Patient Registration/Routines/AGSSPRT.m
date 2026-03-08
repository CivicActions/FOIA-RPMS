AGSSPRT ; IHS/ASDS/EFG - SSN VERIFICATION FROM NPIRS/SSA ;  
 ;;7.0;IHS PATIENT REGISTRATION;**2**;MAR 28, 2003
 ;
 K DUOUT,DFOUT,DIRUT,DTOUT
LOOP ;S AGSSPAT="",AGSSITE=$P(^AUTTSITE(1,0),U) F  S AGSSPAT=$O(^AGSTEMP(AGSS("JOBID"),AGSGLO,AGSSPAT)) Q:AGSSPAT=""  Q:($G(DUOUT)!$G(DFOUT)!$G(DIRUT)!$G(DTOUT))  D  ; IHS/SD/EFG  AG*7*2  #17
 ;.S AGSDFN=0 F  S AGSDFN=$O(^AGSTEMP(AGSS("JOBID"),AGSGLO,AGSSPAT,AGSDFN)) Q:'AGSDFN  Q:($G(DUOUT)!$G(DFOUT)!$G(DIRUT)!$G(DTOUT))  S AGSCREC=^AGSTEMP(AGSS("JOBID"),AGSGLO,AGSSPAT,AGSDFN) D PRINT  ; IHS/SD/EFG  AG*7*2  #17
 S AGSDFN=0 F  S AGSDFN=$O(^AGSSTEMP(AGSSITE,AGSGLO,AGSDFN)) Q:'AGSDFN  Q:($G(DUOUT)!$G(DFOUT)!$G(DURUT)!$G(DTOUT))  S AGSCREC=^AGSSTEMP(AGSSITE,AGSGLO,AGSDFN) D PRINT  ; IHS/SD/EFG  AG*7*2  #17
 Q
 ;--------------------------
PRINT ;
 U IO D AGSSPG Q:($G(DIRUT)!$G(DUOUT)!$G(DFOUT)!$G(DTOUT))
 D LVAR,PATL   ;Print the info from Local database
 I AGSCREC]"" D
 .D CVAR,PATC  ;Print the info from NPIRS
 E  D          ;else
 .W !!         ;Allow for no record printed
 Q
VARS ;
CVARS ;
 ;
CVAR ; 
 S AGSUFAC=$P(AGSCREC,U,1)           ;$E(AGSCREC,1,6)
 S AGSHRN=+$P(AGSCREC,U,2)           ;+$E(AGSCREC,7,12)
 S AGSCSSN1=+$P(AGSCREC,U,3)         ;+$E(AGSCREC,13,21)
 S AGSCLN=$P(AGSCREC,U,4)            ;$E(AGSCREC,22,34)
 S AGSCFN=$P(AGSCREC,U,5)            ;$E(AGSCREC,35,44)
 S AGSCMN=$P(AGSCREC,U,6)            ;$E(AGSCREC,45,51)
 S AGSCDOB=$P(AGSCREC,U,7)-17000000  ;$E(AGSCREC,52,59)-17000000  ;Y2000
 S AGSCSX=$P(AGSCREC,U,8)            ;$E(AGSCREC,60)              ;Y2000
 S AGSCVC=$P(AGSCREC,U,9)            ;$E(AGSCREC,61)              ;Y2000
 S AGSCSSN2=+$P(AGSCREC,U,10)        ;+$E(AGSCREC,62,70)          ;Y2000
 ;---------------------------
 F AGSX="AGSCLN","AGSCFN","AGSCMN" S AGSY=$L(@AGSX) I AGSY F AGSI=AGSY:-1:0 Q:$E(@AGSX,AGSI)]" "  S @AGSX=$E(@AGSX,0,AGSI-1)
 S AGSCNM=AGSCLN_","_AGSCFN ;S:AGSCMN]"" AGSCNM=AGSCNM_" "_AGSCMN
 S:AGSCVC="V" AGSCSSN2=AGSCSSN1
ECVAR Q
 ;------------------------
LVAR ;
 S AG0=^DPT(AGSDFN,0),AGSHRN=$G(^AUPNPAT(AGSDFN,41,AGSSITE,0)),AGSHRN=$P(AGSHRN,U,2)
 S AGSLNM=$P(AG0,U),AGSLSSN=$P(AG0,U,9),AGSLSX=$P(AG0,U,2)
 S AGSLDOB=$P(AG0,U,3)
ELVAR Q
 ;----------------------------------------------------------
PATL ;
 U IO W !,AGSHRN,?8,AGSLNM,?35,"L: ",AGSLSSN,?49,"I: ",$J(AGSDFN,9),?64,AGSLVC,?66,AGSLSX,?68,$$MDT(AGSLDOB)
 Q
PATC ;
 W !,AGSHRN,?8,AGSCNM,?35,"S: ",AGSCSSN2,?49,"D: ",$J(AGSCSSN1,9),?64,AGSCVC,?66,AGSCSX,?68,$$MDT(AGSCDOB),!
 Q
LAST ;------
AGSSPG ;EP page controller
 Q:($Y<(IOSL-4))!($G(DOUT)!$G(DFOUT))
 S AGSSPG=$G(AGSSPG)+1
 I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR
 Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 D AGSSHDR,AGSSHD
 Q
AGSSHDR ;EP write page header
 W:$Y @IOF W ! Q:'$D(AGSSHDR)  S:'$D(AGSSLINE) $P(AGSSLINE,"-",IOM-2)="" S:'$D(AGSSPG) AGSSPG=1 I '$D(AGSSDT) S %H=$H D YX^%DTC S AGSSDT=Y
 U IO W ?(IOM-40-$L(AGSSHDR)/2),AGSSHDR,?(IOM-40),AGSSDT,?(IOM-10),"PAGE: ",AGSSPG,!,AGSSLINE
 Q
AGSSHD ;EP write column header / message
 I AGSSPG=1 W !,?3,"Local Data",!,?5,"HRN",?10,"Name ",?20,"L: Local SSN",?44,"I: Internal Entry Number for patient"
 ;I AGSSPG=1,"RD,RN,RP"[AGSGLO W !,?3,"SSA   Data",!,?5,"HRN",?10,"Name ",?20,"S: Social Security SSN ",?44,"D: IHS NPIRS SSN",!,?5,"Codes: V-Verified    A-Only one on file    *-1 digit differs",!  ; IHS/SD/EFG  AG*7*2  #17
 I AGSSPG=1,"RD,RN,RP"[AGSGLO W !,?3,"NPIRS Data",!,?5,"HRN",?10,"Name ",?20,"S: Social Security SSN ",?44,"D: IHS NPIRS SSN",!,?5,"Codes: V-Verified    A-Only one on file    *-1 digit differs",!  ; IHS/SD/EFG  AG*7*2  #17
 W !,"HRN",?8,"Name",?35,"SSNs",?60,"Code",?65,"Sex",?70,"DOB"
 Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
EAGSSPG Q
MDT(X) ;EP - date format dd mmm yyyy
 I X="" Q X
 S X=+$E(X,6,7)_" "_$P($T(MTHS+1),";;",+$E(X,4,5)+1)_" "_($E(X,1,3)+1700)
 S X=$J(X,12)
 Q X
MTHS ;months
 ;;JAN;;FEB;;MAR;;APR;;MAY;;JUN;;JUL;;AUG;;SEP;;OCT;;NOV;;DEC
