XUCS6R ;CLARKSBURG/SO PRINT SYSTEM CONFIG PARMS ;2/9/96  13:17 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**6,13**;Apr 25, 1995
 I '$D(^XUCS(8987.2,0))#2 Q
GETIO ; Get I/O Device
 S XUCSEND=0,%ZIS="MQ" D ^%ZIS I POP S POP=0 D HOME^%ZIS G XIT
 I $D(IO("Q")) D  G XIT
 . S ZTRTN="DEQUE^XUCS6R",ZTDESC="MSM-RTHIST SYSTEM CONFIG. PARMS PRINT"
 . S %DT="AEFRX",%DT("A")="Queue for what Date/Time: ",%DT("B")="Now",%DT(0)="NOW" D ^%DT K %DT
 . I +Y'<0 S ZTDTH=Y D ^%ZTLOAD,HOME^%ZIS
 . K ZTRTN,ZTDESC,ZTDTH,IO("Q")
 . Q
 U IO D:$E(IOST)="C" WAIT^DICD
DEQUE ; Sort & Print Report
 S XUCSEND=0 K ^TMP($J) D SORT,PRINT
XIT ; Common eXIT point
 I '$D(ZTQUEUED),$E(IOST)="P" D ^%ZISC
 K XUCSEND,XUCSHDR,XUCSPG,XUCSRDT,XUCSX1,XUCSX2,XUCSVG,XUCSITEH
 K ^TMP($J)
 Q
SORT ; Sort By Vol. Groups
 S XUCSX1="" F  S XUCSX1=$O(^XUCS(8987.2,"B",XUCSX1)) Q:XUCSX1=""  D
 . S XUCSX2=0,XUCSX2=$O(^XUCS(8987.2,"B",XUCSX1,+XUCSX2))
 . I $D(^XUCS(8987.2,+XUCSX2,2))#2,^XUCS(8987.2,+XUCSX2,2)]"" S ^TMP($J,XUCSX1)=^XUCS(8987.2,+XUCSX2,2)
 . K XUCSX2,XUCSX3
 . Q
 Q
PRINT ; Print the report
 S XUCSVG="" F  S XUCSVG=$O(^TMP($J,XUCSVG)) Q:XUCSVG=""  S XUCSX2=^TMP($J,XUCSVG) D  I $E(IOST)="C" W !!! D PAUSE G XIT:XUCSEND
 . D HDR
 . W !,"Buffer Cache Size: ",$P(XUCSX2,"~",1),?42,"** Dispatch Parameters **"
 . W !,?2,"** Disk I/O Threshholds **",?45,"Slice Size: ",$P(XUCSX2,"~",14)
 . W !,?5,"Begin Burst Flush: ",$P(XUCSX2,"~",2),?45,"RunQ Slice: ",$P(XUCSX2,"~",15)
 . W !,?5,"Stop Burst Flush: ",$P(XUCSX2,"~",3),?45,"Q1 -> Q2 Threshold: ",$P(XUCSX2,"~",16)
 . W !,?5,"Flush Panic Level: ",$P(XUCSX2,"~",4),?45,"Q2 -> Q3 Threshold: ",$P(XUCSX2,"~",17)
 . W !,?5,"Flush Interval (sec.): ",$P(XUCSX2,"~",5),?40,"STAP Size: ",$P(XUCSX2,"~",18)
 . W !,?5,"Flush Quantity: ",$P(XUCSX2,"~",6),?40,"STACK Size: ",$P(XUCSX2,"~",19)
 . W !,?5,"I/O Capacity (iolevel): ",$P(XUCSX2,"~",7)
 . W !,?5,"I/O Flush level (fllevel): ",$P(XUCSX2,"~",8)
 . W !,"Dasd I/O Delay: ",$P(XUCSX2,"~",9)
 . W !,"Dasd Fsync: ",$P(XUCSX2,"~",10)
 . W !,"Term I/O Delay: ",$P(XUCSX2,"~",11)
 . W !,"Maximum Partitions: ",$P(XUCSX2,"~",12)
 . W !,"Maximum Concurrent Partitions: ",$P(XUCSX2,"~",13)
 . ;W !,?42,"** Dispatch Parameters **"
 . ;W !,?45,"Slice Size: ",$P(XUCSX2,"~",14)
 . ;W !,?45,"RunQ Slice: ",$P(XUCSX2,"~",15)
 . ;W !,?45,"Q1 -> Q2 Threshhold: ",$P(XUCSX2,"~",16)
 . ;W !,?45,"Q2 -> Q3 Threshhold: ",$P(XUCSX2,"~",17)
 . ;W !,?40,"STAP Size: ",$P(XUCSX2,"~",18)
 . ;W !,?40,"STACK Size: ",$P(XUCSX2,"~",19)
 . K XUCSX2
 . Q
 Q
HDR ; Report Header(s)
 I $D(XUCSHDR),$E(IOST)="P",$Y>2,$Y<(IOSL-18) DO  G SHDR
 . N X
 . W !
 . S X="",$P(X,"-",IOM)="" W !,X
 . Q
 I '$D(XUCSHDR) S XUCSHDR=1,XUCSPG=0 D NOW^%DTC S Y=% D DD^%DT S XUCSRDT=$P(Y,"@")_"@"_$P($P(Y,":",1,2),"@",2) W:$E(IOST)="C" @IOF
 I XUCSPG>0 W @IOF
 S XUCSPG=XUCSPG+1
 W !,"Sys. Config. Parms.",?40,"Date: ",XUCSRDT,"  Page: ",XUCSPG
 N X
 S X="",$P(X,"-",IOM)="" W !,X
SHDR D SITEH^XUCSUTL3 W !,?5,XUCSITEH
 Q
PAUSE ; C- subtype
 S DIR(0)="E" D ^DIR K DIR I $D(DTOUT)!($D(DUOUT)) S XUCSEND=1 Q
 Q
