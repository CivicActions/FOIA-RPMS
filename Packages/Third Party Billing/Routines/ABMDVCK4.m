ABMDVCK4 ; IHS/SD/SDR - extension of claim generator ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**36**;NOV 12, 2009;Build 698
 ;
 Q
 ;IHS/SD/SDR 2.6*36 ADO75940 New routine; builds list of parent/satellite relationships
 ;   so when checking if the visit location is setup is it checking where the visit should be
 ;   creating based on the A/R Parent/Satellite Setup file and the 3P Parm 'Use A/R Parent/Satellite
 ;   Setup' prompt
 ;IHS/SD/SDR 2.6*36 76302 Added check for In Hospital visits and if they have an admission or not; don't create claim if there's an admission
 ;
START ;PEP - build list of parent/satellite relationships (CR75940)
 K ABMPSLST
 S ABM1=0
 F  S ABM1=$O(^BAR(90052.05,ABM1)) Q:'ABM1  D
 .S ABM2=0
 .S ABMUSEPS=+$P($G(^ABMDPARM(ABM1,1,4)),U,9)  ;Use A/R Parent/Satellite Setup
 .F  S ABM2=$O(^BAR(90052.05,ABM1,ABM2)) Q:'ABM2  D
 ..S ABMSDT=$P($G(^BAR(90052.05,ABM1,ABM2,0)),U,6)  ;satellite start date
 ..Q:+ABMSDT=0  ;no start date - skip
 ..S ABMEDT=$P($G(^BAR(90052.05,ABM1,ABM2,0)),U,7)  ;satellite end date
 ..I ABMUSEPS=0 S ABMPSLST(ABM2,ABM2,ABMSDT)=ABMEDT
 ..I ABMUSEPS=1 S ABMPSLST(ABM2,ABM1,ABMSDT)=ABMEDT
 Q
 ;
INHOSP ;Check for Hospitalization to go with In Hospital (CR76302)
 ;Check for hospitalization prior to (or on same day) as the "I" visit
 Q:'$D(^AUPNVSIT("AI",ABMVDFN))
 S ABMHFND=0,ABMFFND=0
 N ABMPDFN
 S ABMPDFN=$P(ABMP("V0"),U,5)
 S ABMFND=0
 S ABMVDH=(9999999-$P(ABMP("VDT"),".")),ABMSVD=(ABMVDH-1)_".9999",ABMHDFN=""
 F  S ABMSVD=$O(^AUPNVSIT("AAH",ABMPDFN,ABMSVD)) Q:ABMSVD'=+ABMSVD!(+$P(ABMSVD,".")<ABMVDH)!(+ABMSVD=0)  D PROC2
 I ABMFND>1 Q
 I 'ABMFND Q
 I ABMFND=1 S ABMHFND=1
 Q
PROC2 ;
 S ABMHDFN=0 F  S ABMHDFN=$O(^AUPNVSIT("AAH",ABMPDFN,ABMSVD,ABMHDFN)) Q:ABMHDFN'=+ABMHDFN  I ABMHDFN]"",$D(^AUPNVSIT(ABMHDFN,0)),'$P(^(0),U,11),$P(^(0),U,9) D CHECK
 Q
CHECK ;
 S ABMFFND=1  ;this is an admission
 S ABMHVR=^AUPNVSIT(ABMHDFN,0)
 S ABMHDAT=+$P(ABMHVR,U),ABMHTYP=$P(ABMHVR,U,3),ABMHLOC=$P(ABMHVR,U,6)
CHKHOSP ; Check corresponding V Hospitalization for discharge date
 S ABMINPD="",ABMINPD=$S(ABMITYP="C":$O(^AUPNVCHS("AD",ABMHDFN,"")),1:$O(^AUPNVINP("AD",ABMHDFN,"")))
 Q:ABMINPD=""
 S:ABMITYP="C" ABMDCD=$P(^AUPNVCHS(ABMINPD,0),U,7)
 S:ABMITYP'="C" ABMDCD=$P(^AUPNVINP(ABMINPD,0),U)
 I ABMDCD'<ABMP("VDT") S ABMFND=ABMFND+1,ABMHOSP(ABMHDFN)=""
 Q
