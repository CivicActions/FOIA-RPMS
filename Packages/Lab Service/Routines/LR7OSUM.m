LR7OSUM ;VA/SLC/DCM - Silent Patient cum ;8/11/97
 ;;5.2;LAB SERVICE;**121,187,230,256,IHS,1018,1054**;NOV 1, 1997;Build 20
 ;
 ; ADO 73380 - LR*5.2*1054 - Write Performing Labs on EHR Cumulative
 ;
 ;
DFN S LRIN=0,LRIDT=0,LREND=0,LROUT=9999999
 K ZTRTN,DIC,X2
 D ^LRDPA Q:Y<0
 N LRPLS      ; IHS/MSC/MKK - LR*5.2*1054
 U IO
 D LRLLOC,END
 D SITELIST   ; IHS/MSC/MKK - LR*5.2*1054
 Q
LRLLOC ;
 N GCNT,GIOSL,CCNT,B,C,LRSB,VA,VA200,VAERR,W
 S CCNT=1,GCNT=0,GIOSL=999999,LRLLOC=$S($L(LRWRD):LRWRD,$D(^LR(LRDFN,.1)):^(.1),1:"File Room"),SSN=" "_SSN_" "
 S ^TMP($J,LRDFN,0)=PNM_U_SSN_U_AGE_U_LRDPF_U_DFN
 I $S('$D(SUBHEAD):1,1:$D(SUBHEAD("MISCELLANEOUS TESTS"))) S ^TMP($J,LRDFN,"MISC")="MISCELLANEOUS TESTS^"
 D LRIDT^LR7OSUM1
 D ^LR7OSUM3
 I $S('$D(SUBHEAD):1,1:$D(SUBHEAD("MICROBIOLOGY"))) D MICRO^LR7OSUM1
 I $S('$D(SUBHEAD):1,1:$D(SUBHEAD("BLOOD BANK"))) D EN^LR7OSBR
 D EN^LR7OSAP ;Anatomic Path
 Q
END D END^LRACM
 Q
EN(Y,DFN,SDATE,EDATE,COUNT,GIOM,SUBHEAD) ;Enter here to get silent lab results
 ;Results in "CH" subscript are stored in the Cumulative format
 ;Headers for each format are found in ^TMP("LRH",$J,name)=ln count
 ;Index for where tests are found in ^TMP("LRT",$J,print name)=header^line # of1st occurance.  Entries without a header means that the test exists in the report, but no result.
 ;Formatted reports are found in ^TMP("LRC",$J,ifn)
 ;DFN=Patient
 ;SDATE=Start date to search for results (optional)
 ;EDATE=End date to search for results (optional)
 ;COUNT=Count of results to send (optional)
 ;GIOM=Right margin - default 80 (optional)
 ;SUBHEAD=Array of subheaders from file 64.5, misc, micro & AP to show results.  Null param = get all results
 Q:'$G(DFN)
 S LRDFN=$$LRDFN^LR7OR1(DFN)
 Q:'LRDFN
 K ^TMP($J,"EVAL")
 N A,AGE,CT1,DIC,DOB,F,G,H,I,IFN,INC,J,K,LR,LRA,LRAA,LRABV,LRACT,LRADM,LRADX,LRCNT,LRCTN,LRDP,LREND,LRJ02,LRMD,LRMIT,LRN,LRNAME,LRPRAC,LRQ,LRRB,LRSAV,LRSPE,LRSPEM,LRTEST,LRTOP,LRTREA,LRUNKNOW,LRUNT,LRVAL,LRW,M,N,P,P7,S1,SP,T,X,X1,XZ,Y,Y1
 D PT^LRX
 S LRADM=$P($G(VAIN(7)),"^",2),LRADX=$G(VAIN(9)),CT1=0
 K VA,VADM,VAERR,VAIN
 D DTRNG^LR7OR1
 S COUNT=$S($G(COUNT):COUNT,1:9999999),GIOM=$S($G(GIOM):GIOM,1:80)
 I GIOM>240 S GIOM=240
 S (LRIN,LRIDT)=SDATE,LROUT=EDATE,LREND=0
 D LRLLOC,END
 S Y=$NA(^TMP("LRC",$J))
 Q
TEST ;Test the output
 N IFN
 S IFN=0 F  S IFN=$O(^TMP("LRC",$J,IFN)) Q:IFN<1  W !,^(IFN,0)
 Q
GET64(Y) ;Get minor headers from file 64.5
 N I,J
 S I=0 F  S I=$O(^LAB(64.5,1,1,I)) Q:I<1  S J=0 F  S J=$O(^LAB(64.5,1,1,I,1,J)) Q:J<1  S X=^(J,0),Y($P(X,"^"))=""
 S Y("MISCELLANEOUS TESTS")=""
 S Y("MICROBIOLOGY")=""
 S Y("BLOOD BANK")=""
 S Y("CYTOPATHOLOGY")=""
 S Y("SURGICAL PATHOLOGY")=""
 S Y("EM")=""
 S Y("AUTOPSY")=""
 S Y=$NA(Y)
 Q
PT ;Test with a loop thru multiple patients
 N X,DFN,PTN,PTNX
 W !!,"How many patients: " R X:DTIME Q:X["^"
 I X'?1N.N W !!,"Enter a number" G PT
 S DFN=0,PTNX=X
 F PTN=1:1:PTNX S DFN=$O(^DPT(DFN)) Q:DFN<1  I $D(^DPT(DFN,"LR")) K ^TMP("LRC",$J),^TMP("LRH",$J),^TMP("LRT",$J) D EN(.Y,DFN) W !!!!,"////////////////////"_$P(^DPT(DFN,0),"^")_" LRDFN:"_+^DPT(DFN,"LR")_"////////////////////",!! D TEST
 Q
CLEAN ;Clean up TMP globals
 K ^TMP("LRC",$J),^TMP("LRT",$J),^TMP("LRH",$J)
 Q
AP(DFN) ;Get just the AP results
 Q:'$D(DFN)
 N SUBHEAD,LRAU,LRV,LRZ,%I,E
 K ^TMP("LRC",$J)
 S SUBHEAD("CYTOPATHOLOGY")=""
 S SUBHEAD("SURGICAL PATHOLOGY")=""
 S SUBHEAD("EM")=""
 S SUBHEAD("AUTOPSY")=""
 D EN(.ZIP,DFN,,,,80,.SUBHEAD)
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1054
SITELIST ; EP - Cloned from LRRP2
 Q:$D(LRPLS)<1
 ;
 NEW COL,ADDRESS
 ;
 W !!,"Performing Labs:",!!
 S LRPLS=0
 F  S LRPLS=$O(LRPLS(LRPLS)) Q:LRPLS=""  D
 . I $T(NAME^XUAF4)]"",($T(PADD^XUAF4)]"") D
 .. W $$LJ^XLFSTR("["_LRPLS_"]",8)    ; IHS/MSC/MKK - LR*5.2*1038
 .. W ?7,$$NAME^XUAF4(LRPLS),"   "
 .. S X=$$PADD^XUAF4(LRPLS)
 .. S ADDRESS=$P(X,U)_"   "_$P(X,U,2)_", "_$P(X,U,3)_" "_$P(X,U,4)
 .. S COL=+$X
 .. I COL+$L(ADDRESS)>IOM W !,?10,ADDRESS
 .. I COL+$L(ADDRESS)<(IOM+1) W ADDRESS
 . W !
 Q
 ; ----- END IHS/MSC/MKK - LR*5.2*1054
 ;
