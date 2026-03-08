ABMDVSTA ; IHS/SD/SDR - PCC Visit Stuff (Cont.) ;     
 ;;2.6;IHS 3P BILLING SYSTEM;**38**;NOV 12, 2009;Build 756
 ;IHS/SD/SDR 2.6*38 ADO97221 Check V Lab file for entries so a claim will generate if there are just labs on a visit; between p36
 ;   and now it was skipping lab only visits (no claim created); Also updated check for BILLED POS to make sure there were meds
 ;   on visit
 ;**********************
START ;
 S (ABMMF,ABMCF,ABMTF,ABMDF)=1
 K ABMBPOS
 S ABMLF=0
 S ABMVMIEN=0
 S ABMVMC=0
 F  S ABMVMIEN=$O(^AUPNVMED("AD",ABMVDFN,ABMVMIEN)) Q:+ABMVMIEN=0  D
 .S ABMVMC=ABMVMC+1
 I (($P($G(^AUTNINS(ABMP("INS"),2)),U,3)="P")!(ABMVMC=0)) S ABMMF=0  ;if BILLED POS or there are no meds
 ;
 S ABMVLIEN=0
 F  S ABMVLIEN=$O(^AUPNVLAB("AD",ABMVDFN,ABMVLIEN)) Q:+ABMVLIEN=0  D  Q:ABMLF=1  ;if any one resulted lab w/CPT stop checking
 .I +$P($G(^AUPNVLAB(ABMVLIEN,14)),U,2)'=0 S ABMLF=1
 .I "OAD"'[$P($G(^AUPNVLAB(ABMVLIEN,11)),U,9) S ABMLF=1
 ;
 S X=$$CPT^AUPNCPT(ABMVDFN)
 I +$O(AUPNCPT(0))=0 S ABMCF=0
 ;
 I +$O(^AUPNVDEN("AD",ABMVDFN,0))=0 S ABMDF=0
 ;
 I +$O(^AUPNVTC("AD",ABMVDFN,0))=0 S ABMTF=0
 ;
 S ABMPSFLG=1
 I +$G(ABMHIEN)'=0 I $P($G(^AUPNVINP(ABMHIEN,0)),U,15)'="" S ABMPSFLG=0
 ;
 Q
