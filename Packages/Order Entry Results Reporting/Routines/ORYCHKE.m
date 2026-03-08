ORYCHKE ;SLC/DAN Environmental check for installations ;15-May-2017 15:20;DU
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**280,306,1017**;Dec 17, 1997;Build 48
 ;This routine will check to see if the user is in a production account
 ;if they are then the user will not be allowed to install this
 ;patch/build/bundle
 ;
 ;IHS/MSC/MGH Added for EPCS from CPRS 29
 I $$PROD^XUPROD D
 .W !,"You are attempting to install this software into your production account.",!,"At this time, this software is not ready for a production install."
 .W !!,"Please verify the account you're attempting to install into and",!,"if you believe you're correct, contact Ron Massey or Tana Defa.",!!,"INSTALLATION ABORTED!"
 .S XPDABORT=1
 Q
