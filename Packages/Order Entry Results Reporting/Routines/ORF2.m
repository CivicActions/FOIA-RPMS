ORF2 ; slc/dcm - Purge old orders; ;7/18/95  09:27 [ 04/02/2003   8:51 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**1**;Jul 05, 1995
 ;  MODIFIED FOR KERNEL 8.0 BY JLI(ISC-SF) 6/20/95
 W !,"This option will purge orders from the ORDER file (100) that do not have",!,"an active status type and no activity in the number of grace days specified",!,"when the order was placed.",!!,"OK to proceed" S %=2 D YN^DICN G:%=0 ORF2 Q:%'=1
ENT S OREND=0,ORACTION=7,ORGY="",%ZIS="Q" I '$D(ORTSK) D ^%ZIS Q:POP  I $D(IO("Q")) K IO("Q") S ZTIO=ION,ZTSAVE("OR*")="",ZTRTN="DQ^ORF2" D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED" K ZTSK,ZTIO,ZTSAVE,ZTRTN G END
 ;I $D(IO),$L(IO) U IO W @IOF,!,"LIST OF ORDERS DELETED",! F I=1:1:(IOM-1) W "-"
 S ORIFN=0 D NOW^%DTC S ORSTTIM=% I $P(^ORD(100.99,1,0),"^",6) S ORIFN=$P(^(0),"^",6)
 S ORLASP=$P(^ORD(100.99,1,0),"^",5)
 F  S ORIFN=$O(^OR(100,ORIFN)) Q:ORIFN<1  S OROFN=ORIFN,ORACTION=7 D A S ORIFN=OROFN,$P(^ORD(100.99,1,0),"^",6)=ORIFN
 S $P(^ORD(100.99,1,0),"^",5,6)=ORSTTIM_"^"_0
 S (I,C)=0 F J=0:0 S I=$O(^OR(100,I)) Q:I<1  S C=C+1
 S $P(^OR(100,0),"^",4)=C
 D EN^ORLPURG,ER^ORF5,NOTIF
END K %T,J,ORELECT,OROFN,ORACTION,ORGY,ORIFN,ORVP,ORO,ORSTRT,ORTO,ORIT,OROLOC,ORPK,ORLASP,ORLOG,ORSTS,ORSTTIM,ORTSK,OREND,ORUPCHK,ORNS,ORX,ORX5,X1,X2,ORX3,C,I,IT D ^%ZISC
 Q
DQ I $D(ZTSK) D KILL^%ZTLOAD K ZTSK
 S ORTSK=1 G ENT
P ;S X=ORX,Y=$P(X,"^",2) I $L(Y),+Y>0 S Y=$P(@("^"_$P(Y,";",2)_+Y_",0)"),"^") W !,$P(ORX3,"^",5)_"  "_$P(ORX3,"^")_$S($D(^OR(100,+ORX)):"",1:"  DELETED!")
 Q
A S ORSIFN=ORIFN I '$D(^OR(100,ORIFN,3)) D:$P($P(^(0),"^",7),".")<$P(ORSTTIM,".") DOIT Q
 S ORLOG=$P(^OR(100,ORIFN,0),"^",7),ORNS=$P(^(0),"^",14),X=^OR(100,ORIFN,3),ORSTS=$P(X,"^",3),X1=+X,X2=+$P(X,"^",2),ORIT=$P(X,"^",4),ORSTRT=$P(X,"^",6)
 I ORLOG>ORLASP,$L(ORIT) S IT=$O(^OR(100.1,"B",ORIT,0)) D ASP
 I ORSTRT,ORSTRT>DT K ORSIFN Q
 D C^%DTC I DT>X D PURG D:$D(IO)&('OREND) P S OREND=0
 I $D(^OR(100,ORSIFN,3)) S X1=ORSTTIM,X2=-365 D C^%DTC I $P(^OR(100,ORSIFN,3),"^")<X D DOIT ;get rid of data more than a year old
 K ORSIFN Q
PURG ;;Discontinue use of 100.2 after 1-1-90
 ;;Purge order entries here (ORIFN)
 Q:'$D(ORIFN)  Q:'ORIFN
 Q:'$D(^OR(100,ORIFN,0))
 I $D(^OR(100,ORIFN,2,0)) Q:$O(^(0))  D DOIT Q
 S (ORX,X)=^OR(100,ORIFN,0),ORPK=$S($D(^(4)):^(4),1:""),ORX3=$S($D(^(3)):^(3),1:""),ORELECT=$P(ORX3,"^",10),ORX5=$P(X,"^",5),OROLOC=$P(X,"^",10) I '$L(ORX5) D DOIT Q
 S ORVP=$P(X,"^",2),ORLOG=$P(X,"^",7),ORSTRT=$P(X,"^",8),ORTO=$P(X,"^",11),ORNS=$P(X,"^",14),ORIT=$P(ORX3,"^",4) S:'ORSTRT ORSTRT=$P(ORX3,"^",6)
 D EN^ORF9
 Q
DOIT ;Remove entry from file 100
 Q:'$D(ORIFN)  Q:'ORIFN  Q:'$D(^OR(100,ORIFN,0))  S DA=ORIFN D REMOVE
 Q
P1 ;;from ORX
 Q:'$D(ORIFN)  Q:'$D(^OR(100,+ORIFN,0))
 I $D(^OR(100,+ORIFN,3)),$P(^(3),"^",9) S X=$P(^(3),"^",9) I $O(^OR(100,X,2,0)) S $P(^(0),"^",4)=$P(^(0),"^",4)-1 K ^(ORIFN) I '$O(^(0)) D OUT:ORIFN'=X
 I $D(ORNS),$D(ORAL(ORNS)) K ORAL(ORNS,ORIFN)
 D NOTIF^ORX8(ORIFN,12)
 D NOTIF^ORX8(ORIFN,6)
 K ORCUM(ORIFN) S DA=ORIFN D REMOVE
 K ORSTS,ORIFN Q
ASP I IT,$D(^OR(100.1,IT,0)) S $P(^(0),"^",2)=($P(^(0),"^",2)+1) Q
 S IT=$P(^OR(100.1,0),"^",4) L +^OR(100.1)
ASP1 S IT=IT+1 G:$D(^OR(100.1,IT,0)) ASP1 S ^OR(100.1,IT,0)=ORIT_"^"_1_"^"_ORNS,^OR(100.1,"B",ORIT,IT)=""
 S $P(^(0),"^",3,4)=IT_"^"_($P(^OR(100.1,0),"^",4)+1) L -^OR(100.1) Q
OUT N ORIFN,ORSTS,ORNS S ORZNS=$P(^OR(100,X,0),"^",14),(ORZIFN,ORIFN)=X D P1
 I '$D(^OR(100,ORZIFN)) K ORCUM(ORZIFN),ORAL(ORZNS,ORZIFN)
 K ORZIFN,ORZNS
 Q
REMOVE D KIL^ORDD100,SK^ORDD100,NCNN2^ORDD100,S2^ORDD100,RK^ORDD100,TK^ORDD100,WK^ORDD100,LK^ORDD100A,OK^ORDD100A,EK^ORDD100A,FK^ORDD100A
 K ^OR(100,ORIFN) S $P(^OR(100,0),"^",4)=$P(^OR(100,0),"^",4)-1
 Q
NOTIF ; clean up ^OR(100,"AN" entries without associated alerts in ^VA(200
 S (NIEN,P,N)=0
 F  S P=$O(^OR(100,"AN",P)) Q:P=""  D
 .F  S N=$O(^OR(100,"AN",P,N)) Q:N=""  D
 ..S NIEN=N,PT=$P(P,";"),XQAID="OR,"_PT_","_NIEN
 ..I $D(^XTV(8992,"AXQAN",XQAID))<1 K ^OR(100,"AN",P,N)
 K N,NIEN,P,XQAID
 Q
