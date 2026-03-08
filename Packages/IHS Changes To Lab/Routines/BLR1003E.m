BLR1003E ; IHS/DIR/AAB - Environment check routine for patch LR*5.2*1003 ; [ 06/16/98  11:37 AM ]
 ;;5.2;BLR;**1003**;JUN 01, 1998
 ;
 ;
EN I $D(^TMP("LR*5.2*1002",$J)) S XPDQUIT=1 K ^TMP("LR*5.2*1002",$J)
 Q
