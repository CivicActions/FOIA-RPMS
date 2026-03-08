LRXO0 ; IHS/DIR/AAB - Process Lab actions ;
 ;;5.2;LR;**1002**;JUN 01, 1998
 ;
 ;;5.2;LAB SERVICE;**100,128**;Sep 27, 1994
EN ;This is the default protocol for lab tests ORPCL
 Q:'$D(ORACTION)  Q:'$D(ORGY)  S DFN=+ORVP
 S LRDPF=+$P(@("^"_$P(ORVP,";",2)_"0)"),"^",2)_"^"_$P(ORVP,";",2) D END^LRDPA I LRDFN<1&(ORACTION'=7) W " LAB FILE NOT CONSISTENT WITH PATIENT FILE. CANNOT PLACE ORDER!" S XQORPOP=1 G END
 N LREND S LREND=0 D:$D(ORPK) PATCK(ORPK) I LREND S XQORPOP=1 G END
 I ORACTION=1 D EN^LROR6 Q  ;Edit
 I ORACTION=2 D EN^LROR7 Q  ;Renew
 I ORACTION=3 D EN^LROR8 Q  ;Flag
 I ORACTION=4 D EN1^LROR8 Q  ;Hold
 I ORACTION=6 D C^LROR3 Q  ;DC/Cancel
 I ORACTION=7 D P^LROR3 Q  ;Purge
 I ORACTION=8 D STAT^LROR1 Q  ;Detailed Display
 I ORGY=9 ;Release (Lab uses Transaction code field instead)
 I ORGY=10 D EN2^LROR8 Q  ;Verify
 I ORGY=0 D EN^LRXO1 Q  ;Add
 Q
END K DFN,LRDFN,LRDPF
 Q
PATCK(ORPK) ;Check patient match
 Q:'$G(ORPK)  S LRODT=+ORPK,LRSN=$P(ORPK,"^",2)
 I 'LRODT!('LRSN) Q
 I $D(^LRO(69,LRODT,1,LRSN,0)),+^(0)'=LRDFN D
 . I '$G(ZTQUEUED) W !!,"Incorrect pointer to Lab file (wrong patient). Unable to continue.",! D READ^ORUTL
 . S LREND=1
 Q
