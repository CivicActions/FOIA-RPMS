BLR1010P ; IHS/HQT/MJL - LR*5.2*1010 PATCH POST INIT ROUTINE ; 
 ;;5.2;LR;**1010**;MAR 01, 2001
EN ;
 ; This intializes the DAYS TO KEEP TRANSACTIONS field in the BLR MASTER CONTROL file to equal
 ; the GRACE PERIOD FOR ORDERS field in the LABORATORY SITE file if it's set, otherwise it
 ; will be set to 90.
 ;
 I '$P($G(^BLRSITE($P(^AUTTSITE(1,0),U,1),0)),U,8) S BLRX=$P($G(^LAB(69.9,1,0)),U,9) S:'BLRX BLRX=90 S $P(^BLRSITE($P(^AUTTSITE(1,0),U,1),0),U,8)=BLRX
 Q
