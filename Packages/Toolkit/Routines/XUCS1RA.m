XUCS1RA ;CLARKSBURG/SO RPT. R-CMDS/R-GLB ACC BY VG,DATE - PRINT ;8/10/93 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**6**;Apr 25, 1995
PRINT ; Print Report
 S (XUCSAOC,XUCSAOG,XUCSI)=0 D S1^XUCSUTL3
 S XUCSVG="" F  S XUCSVG=$O(^TMP($J,2,XUCSVG)) Q:XUCSVG=""!(XUCSEND)  D SITEH^XUCSUTL3 D
 . S XUCSDT=0 F  S XUCSDT=$O(^TMP($J,2,XUCSVG,+XUCSDT)) Q:+XUCSDT<1!(XUCSEND)  D
 .. S XUCSAP="" F  S XUCSAP=$O(^TMP($J,2,XUCSVG,+XUCSDT,XUCSAP)) Q:XUCSAP=""!(XUCSEND)  S XUCSTC=^(XUCSAP,"ZZZTRC"),XUCSTG=^("ZZZTRG") D HDR D  I 'XUCSEND D AVE,PAUSE^XUCSUTL
 ... S XUCSUCI="" F  S XUCSUCI=$O(^TMP($J,2,XUCSVG,+XUCSDT,XUCSAP,XUCSUCI)) Q:XUCSUCI=""!(XUCSUCI="ZZZTRC")!(XUCSUCI="ZZZTRG")!(XUCSEND)  D SHDR D  I 'XUCSEND D PAO
 .... S XUCSROU="" F  S XUCSROU=$O(^TMP($J,2,XUCSVG,+XUCSDT,XUCSAP,XUCSUCI,XUCSROU)) Q:XUCSROU=""!(XUCSEND)  S XUCSXRC=^(XUCSROU,"CMDS"),XUCSXRG=^("RGBL") D WL
 .... Q
 ... Q
 .. Q
 . Q
 Q
AVE ; Print Averages
 Q:XUCSEND
 I $D(^TMP($J,2,XUCSVG,XUCSDT,XUCSAP,"zzz~o","~TBLOVF~"))>0 D
 . W !,"tblovf"
 . S XUCSX=^TMP($J,2,XUCSVG,XUCSDT,XUCSAP,"zzz~o","~TBLOVF~","CMDS") W ?9,$J($P(XUCSX,"^",2)/$P(XUCSX,"^"),6,1)
 . S XUCSX=^TMP($J,2,XUCSVG,XUCSDT,XUCSAP,"zzz~o","~TBLOVF~","RGBL") W ?72,$J($P(XUCSX,"^",2)/$P(XUCSX,"^"),6,1)
 . Q
 D PAUSE^XUCSUTL
 Q:XUCSEND
 I $E(IOST)="C"!($Y>(IOSL-5)) D HDR
 N X
 W !,"** Summary For This Session **"
 S X=$J($P(XUCSTC,"^",2),10,0) W !,"Total Routine Commands Counted:",?45,X
 S X=$J(($P(XUCSTC,"^",2)/$P(XUCSTC,"^")),10,1) W !,"Average Routine Commands per Second:",?45,X
 S X=$J($P(XUCSTG,"^",2),10,0) W !,"Total Routine Global References Counted:",?45,X
 S X=$J(($P(XUCSTG,"^",2)/$P(XUCSTG,"^")),10,1) W !,"Average Routine Global References per Second:",?45,X
 Q
HDR ; Header Sub-routine
 I $D(XUCSHSW),$E(IOST)="P",$Y>2,$Y<(IOSL-10) DO  Q
 . N X
 . W !
 . S X="",$P(X,"-",IOM)="" W !,X
 . Q
 W:$D(XUCSHSW) @IOF
 I '$D(XUCSHSW) S XUCSHSW=1,XUCSPG=0 D NOW^%DTC S Y=% D DD^%DT S XUCSRDT=$P(Y,"@")_"@"_$P($P(Y,":",1,2),"@",2) W:$E(IOST)="C" @IOF
 S XUCSPG=XUCSPG+1 W !,"CMNDs vs GREF By Routine  ",XUCSRDT,?(IOM-10),"Page: ",XUCSPG
 N X
 S X="",$P(X,"-",IOM)="" W !,X
 Q
SHDR ; Change of UCI
 I $Y>(IOSL-5) D HDR
 I $D(XUCSRNEG) W !,"Note: (???) indicates that NEGATIVE counts occur in the MSM-RTHIST global.",!
 S Y=$P(XUCSTC,"^",3) D DD^%DT W:'$D(XUCSRNEG) ! W !,$P(Y,"@")," (",$P($P(Y,":",1,2),"@",2),"-" S X=$P(XUCSTC,"^",3) D H^%DTC
 S %T=%T+$P(XUCSTC,"^"),%H=%H_","_%T D YMD^%DTC S Y=DT+% D DD^%DT W $P($P(Y,":",1,2),"@",2),")  ",XUCSITEH,?(IOM-15),"Ave.# Jobs: ",$J($P(XUCSTC,"^",4),2,0)
 W !,"Routine  CMND/S",?30,"UCI: ",$P(XUCSUCI,"~")," ",$S($P(XUCSUCI,"~",2)="p":"(PROD)",$P(XUCSUCI,"~",2)="m":"(MGR)",1:"(OTHR)"),?73,"GREF/S"
 Q
PAO ; Print All Other for UCI
 I XUCSI>0 DO
 . N X
 . W !,"<thresh" S XUCSX=((XUCSAOC/XUCSI)/$P(XUCSXRC,"^")),XUCSY=((XUCSAOG/XUCSI)/$P(XUCSXRG,"^")) D WLD
 . W !,?16,"# of Routines <thresh:" S X=$J(XUCSI,8,0) W ?38,X
 . W !,?16,"Tot. CMDS <thresh:" S X=$J(XUCSAOC,8,0) W ?38,X
 . W !,?16,"Tot. GREFs <thresh:" S X=$J(XUCSAOG,8,0) W ?38,X
 . I $E(IOST)="C" D PAUSE^XUCSUTL
 . Q
 S (XUCSAOC,XUCSAOG,XUCSI)=0
 Q
WL ; Print detail Line
 S XUCSX=$P(XUCSXRC,"^",2)/$P(XUCSXRC,"^"),XUCSY=$P(XUCSXRG,"^",2)/$P(XUCSXRG,"^")
 I XUCSX<XUCSTH,XUCSY<XUCSTH S XUCSI=XUCSI+1,XUCSAOC=XUCSAOC+$P(XUCSXRC,"^",2),XUCSAOG=XUCSAOG+$P(XUCSXRG,"^",2) K XUCSX,XUCSY Q
 W !,XUCSROU
WLD ; Draw Picture
 S XUCSX1=XUCSX\XUCSS1C,XUCSX2=$S(XUCSX1<28:XUCSX1,1:27),XUCSY1=XUCSY\XUCSS1G,XUCSY2=$S(XUCSY1<28:XUCSY1,1:27)
 W ?9,$J(XUCSX,6,1)
 I '$P(XUCSXRC,U,3) W $S(XUCSX1<28:" |",1:" +"),?(44-XUCSX1) F I1=1:1:XUCSX2 W "+"
 I $P(XUCSXRC,U,3) W " | (???)",?44
 F I2=1:1:XUCSY2 W "-"
 W ?71,$S(XUCSY1<28:"|",1:"- "),$J(XUCSY,6,1)
 I $Y>(IOSL-4),$E(IOST)="C" D PAUSE^XUCSUTL
 I 'XUCSEND,$Y>(IOSL-4) D HDR,SHDR
 K XUCSX,XUCSX1,XUCSY,XUCSY1
 Q
