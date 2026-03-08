XUCS2RA ;CLARKSBURG/SO REPORT FOR GLOBAL REFERENCES BY VG/DATE - PRINT ;8/17/93 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**6**;Apr 25, 1995
PRINT ; Print Report
 S (XUCSAOG,XUCSI)=0 D S2^XUCSUTL3
 S XUCSVG="" F  S XUCSVG=$O(^TMP($J,3,XUCSVG)) Q:XUCSVG=""!(XUCSEND)  D SITEH^XUCSUTL3 D
 . S XUCSDT=0 F  S XUCSDT=$O(^TMP($J,3,XUCSVG,+XUCSDT)) Q:+XUCSDT<1!(XUCSEND)  D
 .. S XUCSAP="" F  S XUCSAP=$O(^TMP($J,3,XUCSVG,+XUCSDT,XUCSAP)) Q:XUCSAP=""!(XUCSEND)  S XUCSTG=^(XUCSAP,"ZZZTGR") D HDR D  I 'XUCSEND D AVE,PAUSE^XUCSUTL
 ... S XUCSUCI="" F  S XUCSUCI=$O(^TMP($J,3,XUCSVG,+XUCSDT,XUCSAP,XUCSUCI)) Q:XUCSUCI=""!(XUCSUCI="ZZZTGR")!(XUCSEND)  D SHDR D  I 'XUCSEND D PAO
 .... S XUCSGBL="" F  S XUCSGBL=$O(^TMP($J,3,XUCSVG,+XUCSDT,XUCSAP,XUCSUCI,XUCSGBL)) Q:XUCSGBL=""!(XUCSEND)  S XUCSXG=^(XUCSGBL) D WL
 .... Q
 ... Q
 .. Q
 . Q
 Q
AVE ; Print Averages
 Q:XUCSEND
 D PAUSE^XUCSUTL
 Q:XUCSEND
 I $E(IOST)="C"!($Y>(IOSL-5)) D HDR
 N X
 W !,"** Summary For This Session **"
 S X=$J($P(XUCSTG,"^",2),8,0) W !,"Total Global References:",?45,X
 S X=$J(($P(XUCSTG,"^",2)/$P(XUCSTG,"^")),8,1) W !,"Average Global References per Second:",?45,X
 Q
HDR ; Header Sub-routine
 I $D(XUCSHSW),$E(IOST)="P",$Y>2,$Y<(IOSL-10) DO  Q
 . N X
 . W !
 . S X="",$P(X,"-",IOM)="" W !,X
 . Q
 W:$D(XUCSHSW) @IOF
 I '$D(XUCSHSW) S XUCSHSW=1,XUCSPG=0 D NOW^%DTC S Y=% D DD^%DT S XUCSRDT=$P(Y,"@")_"@"_$P($P(Y,":",1,2),"@",2) W:$E(IOST)="C" @IOF
 S XUCSPG=XUCSPG+1 W !,"Global Reference Report  ",XUCSRDT,?(IOM-10),"Page: ",XUCSPG
 N X
 S X="",$P(X,"-",IOM)="" W !,X
 Q
SHDR ; Change of UCI
 I $Y>(IOSL-5) D HDR
 S Y=$P(XUCSTG,"^",3) D DD^%DT W !!,$P(Y,"@")," (",$P($P(Y,":",1,2),"@",2),"-" S X=$P(XUCSTG,"^",3) D H^%DTC
 S %T=%T+$P(XUCSTG,"^"),%H=%H_","_%T D YMD^%DTC S Y=DT+% D DD^%DT W $P($P(Y,":",1,2),"@",2),")  ",XUCSITEH,?(IOM-15),"Ave.# Jobs: ",$J($P(XUCSTG,"^",4),2,0)
 W !,"Global",?9,"GREF/S",?30,"UCI: ",$P(XUCSUCI,"~")," ",$S($P(XUCSUCI,"~",2)="p":"(PROD)",$P(XUCSUCI,"~",2)="m":"(MGR)",1:"(OTHR)")
 Q
PAO ; Print All Other for UCI
 I XUCSI>0 DO
 . N X
 . W !,"<thresh" S XUCSX=((XUCSAOG/XUCSI)/$P(XUCSXG,"^")) D WLD
 . W !,?16,"# of Globals <thresh:" S X=$J(XUCSI,8,0) W ?38,X
 . W !,?16,"Tot. GREFs <thresh:" S X=$J(XUCSAOG,8,0) W ?38,X
 . I $E(IOST)="C" D PAUSE^XUCSUTL
 . Q
 S (XUCSAOG,XUCSI)=0
 Q
WL ; Print detail Line
 S XUCSX=$P(XUCSXG,"^",2)/$P(XUCSXG,"^") I XUCSX<XUCSTH S XUCSI=XUCSI+1,XUCSAOG=XUCSAOG+$P(XUCSXG,"^",2) Q
 W !,XUCSGBL
WLD ; Draw Picture
 S XUCSX1=XUCSX\XUCSS2G,XUCSX2=$S(XUCSX1<50:XUCSX1,1:49)
 W ?9,$J(XUCSX,6,1),$S(XUCSX1<28:" |",1:" +"),?17 F I1=1:1:XUCSX2 W "*"
 I $Y>(IOSL-4),$E(IOST)="C" D PAUSE^XUCSUTL
 I 'XUCSEND,$Y>(IOSL-4) D HDR,SHDR
 Q
