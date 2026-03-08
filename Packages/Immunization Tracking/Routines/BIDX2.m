BIDX2 ;IHS/CMI/MWR - RISK FOR FLU & RZV, CHECK FOR DIAGNOSES.; [ 07/11/2025  10:37 PM ] ; 19 Aug 2025  3:23 PM
 ;;8.5;IMMUNIZATION;**31**;OCT 24,2011;Build 137
 ;;
 ;;  PATCH 31 RZV EVALUATION
 ;
 ;
RISKRZV(BIDFN,BIFDT,BIYRS,BIRISKF,BIRPROF) ;PEP - Return whether considered immunocompromised, 1=Yes, 0=No.
 ;Determine if this patient is considered to be immunocompromised.
 ;With RZV med taxonomoes
 ;
 ;Parameters:
 ;  BIDFN   (req) Patient IEN.
 ;  BIFDT   (opt) Forecast Date (date used for forecast).
 ;  BIRISKF (ret) 1 = Patient immunocompromised;
 ;                0 = Not immunoc
 ;  BIRPROF (ret) Risk profile array
 ;
 ;Input checking
 S BIRISKF=0
 S:'$G(BIFDT) BIFDT=$G(DT)
 ;
 I '$G(BIDFN) G RZOUT
 I BIYRS<19!(BIYRS>49) G RZOUT
 ;
 NEW BIIBD,TXDIEN,TXRIEN,BIIDT,VPVIEN,ICD,SMD,IDRUG,RX,BIIDFDT
 ;
 ;Check for daily ^XTMP("BI_RISKC") build - quit if couldn't check
 I $$UPDTC^BIDX()=-1 G RZOUT
 ;
 ;Get drug look back date - 90 days
 S BIDFDT=$$FMADD^XLFDT(BIFDT,-90)
 S BIIDFDT=9999999-BIDFDT ;determine inverse date
 ;
 ;Get start date (back 3 year from forecast date)
 S $E(BIFDT,2,3)=$E(BIFDT,2,3)-3
 S:$E(BIFDT,5,7)="229" $E(BIFDT,5,7)="228"
 S BIIBD=9999999-BIFDT ;determine inverse date
 ;
 ;Check ICD10/SNOMED in V POV
 S BIIDT=0
 F  S BIIDT=$O(^AUPNVPOV("AA",BIDFN,BIIDT)) Q:(BIIDT="")!(BIIDT>BIIBD)!BIRISKF  D
 .S VPVIEN=0
 .F  S VPVIEN=$O(^AUPNVPOV("AA",BIDFN,BIIDT,VPVIEN)) Q:'VPVIEN!BIRISKF   D
 ..;
 ..;First look for ICD10
 ..S ICD=$P($G(^AUPNVPOV(VPVIEN,0)),U)
 ..I ICD,$D(^XTMP("BI_RISKC","DXTAX",ICD)) D  Q
 ...S BIRISKF=1,BIRPROF(+$$BIRPROF^BIPATUP3(187))=1 Q
 ..;
 ..;Next look for SNOMED
 ..S SMD=$P($G(^AUPNVPOV(VPVIEN,11)),U)
 ..I SMD,$D(^XTMP("BI_RISKC","DXSUB",SMD)) D
 ...S BIRISKF=1,BIRPROF(+$$BIRPROF^BIPATUP3(187))=1
 ;
 I BIRISKF G RZOUT
 ;
 ;NOW CHECK PROBLEM LIST
 S PRIEN=0
 F  S PRIEN=$O(^AUPNPROB("AC",BIDFN,PRIEN)) Q:PRIEN'=+PRIEN!BIRISKF  D
 .Q:'$D(^AUPNPROB(PRIEN,0))  ;no zero node
 .Q:$P(^AUPNPROB(PRIEN,0),U,12)=""
 .Q:"ID"[$P(^AUPNPROB(PRIEN,0),U,12)  ;no deleted or inactive
 .I $P($G(^AUPNPROB(PRIEN,2)),U,2)]"" Q
 .;Look for ICD
 .S ICD=$P($G(^AUPNPROB(PRIEN,0)),U)
 .I ICD,$D(^XTMP("BI_RISKC","DXTAX",ICD)) D  Q
 ..S BIRISKF=1,BIRPROF(+$$BIRPROF^BIPATUP3(187))=1
 .;now SNOMED
 .S SMD=$P($G(^AUPNPROB(PRIEN,800)),U)
 .I SMD,$D(^XTMP("BI_RISKC","DXSUB",SMD)) D
 ..S BIRISKF=1,BIRPROF(+$$BIRPROF^BIPATUP3(187))=1
 I BIRISKF G RZOUT
 ;
 ;Check medications
 ;Retrieve drug/RxNorm taxonomy IENs
 S TXDIEN=$O(^ATXAX("B","BI RZV IMMUNOSUPPRESS DRUGS",0))
 S TXRIEN=$O(^ATXAX("B","BI RZV IMMUNOSUPPRESS RXNORM",0))
 ;
 ;Check for drug/RxNorm in V MEDICATION
 S BIIDT=0
 F  S BIIDT=$O(^AUPNVMED("AA",BIDFN,BIIDT)) Q:(BIIDT="")!(BIIDT>BIIDFDT)!BIRISKF  D
 .S VPVIEN=0
 .F  S VPVIEN=$O(^AUPNVMED("AA",BIDFN,BIIDT,VPVIEN)) Q:'VPVIEN!BIRISKF  D
 ..;First look for drug IEN
 ..S IDRUG=$P($G(^AUPNVMED(VPVIEN,0)),U) Q:IDRUG=""
 ..I TXDIEN,$D(^ATXAX(TXDIEN,21,"B",IDRUG)) D  Q
 ...S BIRISKF=1,BIRPROF(+$$BIRPROF^BIPATUP3(187))=1
 ..;
 ..;Next look for RxNorm
 ..S RX=$P($G(^PSDRUG(IDRUG,999999924)),U,4)
 ..I RX,TXRIEN,$D(^ATXAX(TXRIEN,21,"B",RX)) D
 ...S BIRISKF=1,BIRPROF(+$$BIRPROF^BIPATUP3(187))=1
 ;
RZOUT Q
 ;=====
 ;
IMMUNRZV(BIDFN,BIFDT) ;EP - Return whether considered immunocompromised, 1=Yes, 0=No.
 ;Determine if this patient is considered to be immunocompromised.
 ;Parameters:
 ; 1 - BIDFN   (req) Patient IEN.
 ; 2 - BIFDT   (opt) Forecast Date (date used for forecast).
 ; 4 - BIRISKF (ret) 1=Patient is immunocompromised; otherwise 0.
 ;
 ;Input checking
 S BIRISKF=0
 I '$G(BIDFN) Q 0
 S:'$G(BIFDT) BIFDT=$G(DT)
 ;
 NEW BIIBD,TXDIEN,TXRIEN,BIIDT,VPVIEN,ICD,SMD,IDRUG,RX,BIDFDT,BIIDFDT,PRIEN
 ;
 ;Check for daily ^XTMP("BI_RISKC") build - quit if couldn't check
 I $$UPDTC^BIDX()=-1 Q 0
 ;
 ;Get start date (back 3 years from forecast date)
 S $E(BIFDT,2,3)=$E(BIFDT,2,3)-3
 S:$E(BIFDT,5,7)="229" $E(BIFDT,5,7)="228"
 S BIIBD=9999999-BIFDT ;determine inverse date
 ;
 ;Check ICD10/SNOMED in V POV
 S BIIDT=0
 F  S BIIDT=$O(^AUPNVPOV("AA",BIDFN,BIIDT)) Q:(BIIDT="")!(BIIDT>BIIBD)!BIRISKF  D
 .S VPVIEN=0
 .F  S VPVIEN=$O(^AUPNVPOV("AA",BIDFN,BIIDT,VPVIEN)) Q:'VPVIEN!BIRISKF  D
 ..;
 ..;First look for ICD10
 ..S ICD=$P($G(^AUPNVPOV(VPVIEN,0)),U)
 ..I ICD,$D(^XTMP("BI_RISKC","DXTAX",ICD)) D  Q
 ...S BIRISKF=1,BIRPROF(+$$BIRPROF^BIPATUP3(187))=1
 ..;
 ..;Next look for SNOMED
 ..S SMD=$P($G(^AUPNVPOV(VPVIEN,11)),U)
 ..I SMD,$D(^XTMP("BI_RISKC","DXSUB",SMD)) D
 ...S BIRISKF=1,BIRPROF(+$$BIRPROF^BIPATUP3(187))=1
 ;
 I BIRISKF Q BIRISKF
 ;NOW CHECK PROBLEM LIST
 S PRIEN=0
 F  S PRIEN=$O(^AUPNPROB("AC",BIDFN,PRIEN)) Q:PRIEN'=+PRIEN!BIRISKF  D
 .Q:'$D(^AUPNPROB(PRIEN,0))  ;no zero node
 .Q:$P(^AUPNPROB(PRIEN,0),U,12)=""
 .Q:"ID"[$P(^AUPNPROB(PRIEN,0),U,12)  ;no deleted or inactive
 .I $P($G(^AUPNPROB(PRIEN,2)),U,2)]"" Q
 .;Look for ICD
 .S ICD=$P($G(^AUPNPROB(PRIEN,0)),U)
 .I ICD,$D(^XTMP("BI_RISKC","DXTAX",ICD)) D  Q
 ..S BIRISKF=1,BIRPROF(+$$BIRPROF^BIPATUP3(187))=1
 .;now SNOMED
 .S SMD=$P($G(^AUPNPROB(PRIEN,800)),U)
 .I SMD,$D(^XTMP("BI_RISKC","DXSUB",SMD)) D
 ..S BIRISKF=1,BIRPROF(+$$BIRPROF^BIPATUP3(187))=1
 Q BIRISKF
 ;=====
 ;
RZVFLU(BIDFN) ;EP;SET BIFLU ARRAY FOR RZV VACCS
 N X,Y,Z,I0,D,CVX
 S BIFLU=""
 S X=0
 F  S X=$O(^AUPNVIMM("AC",BIDFN,X)) Q:'X  S I0=$G(^AUPNVIMM(X,0)) D:I0
 .S Y=+I0
 .S V=+$P(I0,U,3)
 .Q:'Y!'V
 .S D=$P($P($G(^AUPNVSIT(V,0)),U),".")
 .S CVX=+$P($G(^AUTTIMM(Y,0)),U,3)
 .Q:'CVX!'D
 .S:$D(^BIVARR("ZOS",CVX)) BIFLU(CVX,9999999-D)=""
 Q
 ;=====
 ;
