BIREPCSV ;IHS/CMI/MWR - REPORT, CSV CALL; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**31**;OCT 24,2011;Build 137
 ;
DELIM(BIREPT,BIREPTN,BIREPTS,BIREPTQ) ;EP
 D FULL^VALM1
 ;---> Main entry point for delmited output of the Two-Yr-Old Rates Report.
 W !!!,"You have selected to create a .csv (comma delimited) file for use in EXCEL."
 W !,"You can have this output file created as a file in your site's export"
 W !,"directory (",$$GETDEDIR(),") OR you can have the delimited output display"
 W !,"on your screen so that you can do a file capture.  Keep in mind that if you"
 W !,"choose to do a screen capture you CANNOT Queue your report to run in"
 W !,"the background!!",!!
DE1 ;
 S DIR(0)="S^S:SCREEN - delimited output will display on screen for capture;F:FILE - delimited output will be written to an output file",DIR("A")="Select output type",DIR("B")="S" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 S BIDELT=Y
 I BIDELT="S" G DP
PT1 ;
 S DIR(0)="F^1:40",DIR("A")="Enter a filename for the .csv file (no more than 40 characters)" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DE1
 I Y="" G DE1
 I Y["/" W !!!,"Your filename cannot contain a '/'." H 2 G PT1
 S BIDELF=Y
 W !!,"When the report is finished your delimited output can be found in the",!,$$GETDEDIR()," directory."
 S BIDEDIR=$$GETDEDIR()
 W !,"The filename will be ",BIDELF_".csv.",!! S BIDELF=BIDELF_".csv"
 ;
 S DIR(0)="Y",DIR("A")="Do you wish to Queue this to the background",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PT1
 I Y D  Q
 .K ZTSAVE S ZTSAVE("BI*")=""
 .S ZTRTN="DP^BIREPCSV",ZTDESC=BIREPTN,ZTIO="",ZTDTH=DT
 .D ^%ZTLOAD
 .D PAUSE,EXIT,RESET(BIREPTS)
 ;
 W !!?10,"This may take some time.  Please hold on...",!
 ;
DP ;---> Prepare report.
 K ^TMP(BIREPT,$J),^TMP("BIDUL",$J)
 N VALM,VALMHDR
 D START(BIREPTS) ;BIQDT,BITAR,BIAGRPS,.BICC,.BIHCF,.BICM,.BIBEN,BISITE,BIUP),HDR(BIREPTS)
 ;
 ;D PRTLST^BIUTL8("BIREPT1"),EXIT
 ;OPEN HOST FILE AND LOOP AND SAVE OFF FILE
 I BIDELT="S" D
 .N N,BITEXT S N=0
 .F  S N=$O(VALMHDR(N)) Q:'N  W !,VALMHDR(N)
 .F  S N=$O(^TMP(BIREPT,$J,N)) Q:'N  D
 ..S BITEXT=^TMP(BIREPT,$J,N,0)
 ..W !,BITEXT
 .W !
 I BIDELT="F" D
 .S Y=$$OPEN^%ZISH(BIDEDIR,BIDELF,"W")
 .I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file to write out CSV data.  Notify programmer." Q
 .U IO
 .N N,BITEXT S N=0
 .F  S N=$O(VALMHDR(N)) Q:'N  W VALMHDR(N),!
 .F  S N=$O(^TMP(BIREPT,$J,N)) Q:'N  D
 ..S BITEXT=^TMP(BIREPT,$J,N,0)
 ..W BITEXT,!
 .D ^%ZISC
 .X ^%ZIS("C")
 .D HOME^%ZIS
 .I '$D(ZTQUEUED) W !!,"Your file "_BIDELF_" has been created.",!
 I '$D(ZTQUEUED) D PAUSE,EXIT,RESET(BIREPTS)
 Q
 ;
GETDEDIR() ;EP - get default directory
 NEW D
 S D=""
 S D=$P($G(^AUTTSITE(1,1)),"^",2)
 I D]"" Q D
 S D=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 I D]"" Q D
 I $P(^AUTTSITE(1,0),U,21)=1 S D="/usr/spool/uucppublic/"
 Q D
PAUSE ;
 Q:$D(ZTQUEUED)
 K DIR
 S DIR(0)="E",DIR("A")="Press Enter to continue" D ^DIR KILL DIR
 Q
 ;
EXIT ;EP
 ;---> Cleanup, EOJ.
 K ^TMP(BIREPT,$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
 ;
HDR(PROG) ;EP
 ;---> Header code
 I PROG="TWO" D HEAD^BIREPT2(BIQDT,BITAR,BIAGRPS,.BICC,.BIHCF,.BICM,.BIBEN,BIUP)
 Q
 ;
RESET(PROG) ;
 I PROG="TWO" D RESET^BIREPT Q
 I PROG="FLU" D RESET^BIREPF Q
 I PROG="QTR" D RESET^BIREPQ Q
 I PROG="ADO" D RESET^BIREPD Q
 I PROG="ADL" D RESET^BIREPL Q
 Q
START(PROG) ;
 I PROG="TWO" D START^BIREPT2(BIQDT,BITAR,BIAGRPS,.BICC,.BIHCF,.BICM,.BIBEN,BISITE,BIUP),HEAD^BIREPT2(BIQDT,BITAR,BIAGRPS,.BICC,.BIHCF,.BICM,.BIBEN,BIUP)
 I PROG="FLU" D HEAD^BIREPF2(BIYEAR,.BICC,.BIHCF,.BICM,.BIBEN,BIFH,BIUP),START^BIREPF2(BIYEAR,.BICC,.BIHCF,.BICM,.BIBEN,BIFH,BIUP)
 I PROG="QTR" D HDR^BIREPQ1,START^BIREPQ2(BIQDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHPV,BIUP)
 I PROG="ADO" D START^BIREPD2(BIQDT,BIDAR,BIAGRPS,.BICC,.BIHCF,.BICM,.BIBEN,BISITE,BIUP,.BITOTPTS,.BITOTFPT,.BITOTMPT),HEAD^BIREPD2(BIQDT,BIDAR,BIAGRPS,.BICC,.BIHCF,.BICM,.BIBEN,BIUP)
 I PROG="ADL" D HEAD^BIREPL2(BIQDT,.BICC,.BIHCF,.BIBEN,BICPTI,BIUP),START^BIREPL2(BIQDT,.BICC,.BIHCF,.BIBEN,BICPTI,BIUP)
 Q
