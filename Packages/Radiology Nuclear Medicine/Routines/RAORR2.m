RAORR2 ; IHS/ADC/PDW -VERIFY A REQUEST FROM OERR 24MAY91 ;   [ 11/23/2001  9:31 AM ]
 ;;4.0;RADIOLOGY;**11**;NOV 20, 1997
 ;
 K RAERR
 I $S('$D(ORPK):1,'ORPK:1,'$D(ORVP):1,'$L(ORVP):1,'$D(^RAO(75.1,ORPK,0)):1,1:0) S RAERR=1 G FAIL
 S RAIPROC=$P(^RAO(75.1,ORPK,0),U,2) I 'RAIPROC S RAERR=1 G FAIL
 I '$D(^RAO(75.1,"AP",+ORVP,RAIPROC)) S RAERR=1 G FAIL
 S RATIME=$O(^RAO(75.1,"AP",+ORVP,RAIPROC,0))
 I $P(RATIME,".")>(9999999-DT) S RAERR=2 G FAIL
 ;
 ;START changes to incorporate VA patch IHS/HQW/SCR - 9/5/01 **11**
 ;
 ;S (RARDT,RAROIFN)=0  ;cmnt'd out IHS/HQW/SCR - 9/5/01 **11**
 ;F  S RARDT=$O(^RAO(75.1,"AP",+ORVP,RAIPROC,RARDT)) Q:'RARDT!($D(RAERR))  I RARDT'=RATIME F  S RAROIFN=$O(^RAO(75.1,"AP",+ORVP,RAIPROC,RARDT,RAROIFN)) Q:'RAROIFN!($D(RAERR))  I $D(^RAO(75.1,RAROIFN,0)) S RAO(0)=^(0) D STATUS
 ;Above line cmnt'd out IHS/HQW/SCR - 9/5/01 **11**
 ;K RAERR,RAIPROC,RAO(0),RARDT,RAROIFN,RATIME Q ;cmnt'd out IHS/HQW/SCR-9/5/01**11**
 ;
 S RAS3=+ORVP,X=RAIPROC,RAQUIT=1   ;IHS/HQW/SCR - 9/5/01 **11**
 D ORDPRC1^RAUTL2,STATUS:'$D(RAQUIT)  ;IHS/HQW/SCR - 9/5/01 **11**
 K RAERR,RAIPROC,RAO(0),RARDT,RAROIFN,RATIME,RAQUIT,X,RAMDV   ;IHS/HQW/SCR - 9/5/01 **11**
 Q   ;IHS/HQW/SCR - 9/5/01 **11**
STATUS ;
 ;I $P(RAO(0),U,5)=5 S RAERR=3 D FAIL Q   ;cmnt'd out IHS/HQW/SCR - 9/5/01 **11**
 ;I $P(RAO(0),U,5)=11 S RAERR=4 D FAIL Q
 S RAERR=3 D FAIL H 1 Q
 Q
 ;
 ;END changes to incorporate VA patch  ;IHS/HQW/SCR - 9/5/01 **11**
FAIL ;
 W !,$P($T(ERR+RAERR),";;",2),! I RAERR=1 S OREND=1
 Q
ERR ;
 ;Error messages if the order fails the verify process(ORGY=10)
 ;;Invalid or missing information needed to verify the order.
 ;;Request Date for this order is in the past. May want to cancel the order.
 ;;There is an order on file for this procedure with a status of Pending. May want to cancel this order.
 Q
