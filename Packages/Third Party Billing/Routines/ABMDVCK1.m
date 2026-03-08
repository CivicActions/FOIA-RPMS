ABMDVCK1 ; IHS/SD/SDR - PCC VISIT CHECK - PART 2 ;    
 ;;2.6;IHS Third Party Billing System;**2,10,31**;NOV 12, 2009;Build 615
 ;Original;TMD;
 ;
 ;IHS/SD/SDR v2.6 CSV
 ;IHS/SD/SDR 2.6*2 3PMS10003A modified to call ABMFEAPI
 ;IHS/SD/SDR 2.6*31 CR11832 Updated VTYP to look at new multiple 3P Visit Type Hospital Location.  It will continue
 ;  to check if the visit type is setup for the insurer first, then try to match BOTH the hospital location and clinic,
 ;  then just the hospital location, then check the clinic (like a default; what it did before this patch)
 ;
 ; *********************************************************************
 ;         
VTYP(ABMVDFN,SERVCAT,ABMINS,ABMCLN)        ;EP -  to get visit type
 ;This is an extrinsic function
 N VTYP
 I 'ABMVDFN Q ""
 ;If visit in dental file type=998, other wise 131
 ;
VAR ;
 S ABMHOSLC=+$P($G(^AUPNVSIT(ABMVDFN,0)),U,22)  ;abm*2.6*31 IHS/SD/SDR CR11832
 S VTYP=$S($D(^AUPNVDEN("AD",ABMVDFN)):998,1:131)
 S ABM("LOCK")=0
 ;If the visit is in the V hospitalization file set type to 111
 I +$O(^AUPNVINP("AD",ABMVDFN,"")),$D(^AUPNVINP($O(^AUPNVINP("AD",ABMVDFN,"")),0)) S VTYP=111
 ;Begin mods for inpat lt 30 days
 I VTYP=131,SERVCAT="H" S VTYP=111
 ;End mods
 ;If not in hosp file go thru insurance file
 N QUIT
 ;
 ;
 ;start old abm*2.6*31 IHS/SD/SDR CR11832
 ;E  I SERVCAT'="S" D
 ;.;Note that the visit type must be in the insurer file for this to set the visit type
 ;.S QUIT=0
 ;.S ABM=0
 ;.F  S ABM=$O(^ABMNINS(DUZ(2),ABMINS,1,ABM)) Q:'ABM  D  Q:QUIT
 ;..I ABM=131 Q
 ;..Q:'ABMCLN
 ;..S D1=0
 ;..F  S D1=$O(^ABMDVTYP(ABM,1,D1)) Q:'D1  D  Q:QUIT
 ;...I +^ABMDVTYP(ABM,1,D1,0)=ABMCLN D
 ;....S VTYP=ABM
 ;....S QUIT=1
 ;end old start new abm*2.6*31 IHS/SD/SDR CR11832
 ;
 ;
 ;loop through VTs 3 times - 1. check for HospLoc AND Clin; 2. Just HospLoc; 3. Clinic (default; like it does now)
 S QUIT=0
 E  I SERVCAT'="S" D
 .S ABM=0
 .F  S ABM=$O(^ABMNINS(DUZ(2),ABMINS,1,ABM)) Q:'ABM  D  Q:QUIT
 ..I ABM=131 Q
 ..I ('ABMHOSLC)&('+$G(ABMCLN)) Q
 ..I (($D(^ABMDVTYP(ABM,3,"B",ABMHOSLC))<1)!($D(^ABMDVTYP(ABM,1,"B",+$G(ABMCLN)))<1)) Q
 ..S VTYP=ABM
 ..S QUIT=1
 .;
 .Q:QUIT
 .S ABM=0
 .F  S ABM=$O(^ABMNINS(DUZ(2),ABMINS,1,ABM)) Q:'ABM  D  Q:QUIT
 ..I ABM=131 Q
 ..I ('ABMHOSLC) Q
 ..I $D(^ABMDVTYP(ABM,3,"B",ABMHOSLC))<1 Q
 ..S VTYP=ABM
 ..S QUIT=1
 .;
 .Q:QUIT
 .S ABM=0
 .F  S ABM=$O(^ABMNINS(DUZ(2),ABMINS,1,ABM)) Q:'ABM  D  Q:QUIT
 ..I ABM=131 Q
 ..I ('ABMCLN) Q
 ..I $D(^ABMDVTYP(ABM,1,"B",ABMCLN))<1 Q
 ..S VTYP=ABM
 ..S QUIT=1
 ;end new abm*2.6*31 IHS/SD/SDR CR11832
 ;
 ;
 I SERVCAT="S" S VTYP=831
 ;If type is still 131 check to see if it is surgery
 I "A"[SERVCAT,VTYP=131 D OPCK
 ;I $P($G(^AUTNINS(+ABMINS,2)),U)="R" D  ;abm*2.6*10 HEAT73780
 I $$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,+ABMINS,".211","I"),1,"I")="R" D  ;abm*2.6*10 HEAT73780
 .S ABMLOC=$P($G(^AUPNVSIT(ABMVDFN,0)),"^",6)
 .Q:$P($G(^ABMDPARM(+ABMLOC,1,5)),U)'=1
 .S VTYP=999
 .K ABMLOC
 Q VTYP
 ;
 ; *********************************************************************
 ;This code is only reached if VTYP=131
OPCK ;EP for checking if ambulatory surgery
 N C,ASC
 D SURGTAB
 S ABM=0
 F  S ABM=$O(^AUPNVPRC("AD",ABMVDFN,ABM)) Q:'ABM  D  Q:VTYP'=131
 .;What we need to find is if from the ICD code we can determine visit
 .;type.
 .;From the CPT code we should be able to tell if it is surgery
 .;If one of the ASC codes from 1 - 8 exists it should be amb surg
 .;CPT from 10000-70000 is surgery.
 .Q:'$D(^AUPNVPRC(ABM,0))
 .S ABM("CPT")=$O(^ICPT("I",+^AUPNVPRC(ABM,0),""))
 .Q:'ABM("CPT")
 .S ASC=$P($$IHSCPT^ABMCVAPI(ABM("CPT"),ABMP("VDT")),U,6)  ;CSV-c
 .I ASC>0,ASC<9 D OPSURG
 .Q
 Q
 ;
 ; *********************************************************************
OPSURG ;
 ;I $D(^ABMNINS(DUZ(2),ABMINS,1,831,0)),+$P(^(0),U,5),'+$P($G(^ABMDFEE($P(^(0),U,5),11,ABM("CPT"),0)),U,2) Q  ;abm*2.6*2 3PMS10003A
 I $D(^ABMNINS(DUZ(2),ABMINS,1,831,0)),+$P(^(0),U,5),'+$P($$ONE^ABMFEAPI($P(^(0),U,5),11,ABM("CPT"),ABMP("VDT")),U) Q  ;abm*2.6*2 3PMS10003A
 S VTYP=831
 Q
 ;
 ; *********************************************************************
SURGTAB ;EP - Create CPT table if needed
 I '$D(ABMCPTTB("SURGERY")) D
 .S ABM=$O(^ABMDCPT("D","SURGERY",""))
 .S Y=^ABMDCPT(ABM,0)
 .S ABMCPTTB("SURGERY","L")=$P(Y,U,4)
 .S ABMCPTTB("SURGERY","H")=$P(Y,U,5)
 K Y
 Q
