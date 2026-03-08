BAR1834C ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**34**;OCT 26, 2005;Build 139
 ;IHS/SD/SDR 1.8*34 ADO60913 updated SARs and Remark Codes to April 2022
 ;
 ;***************************
EN ; EP
 D STND
 D ^BARVKL0
 Q
 ;**************************
STND   ;
 ;Create entries in A/R EDI Remark Codes
 S BARD=";;"
 S BARCNT=0
 D BMES^XPDUTL("Adding Remark Codes in A/R EDI Remark Code file...")
 F  D STND2 Q:BARVALUE="END"!(BARVALUE="ENDEND")!(BARVALUE="ENDENDEND")
 Q
 ;****************************
STND2  ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@1+BARCNT),BARD,2,6)
 S BARVALUE=BARVALUE_$P($T(@2+BARCNT),BARD,2)
 S BARVALUE=BARVALUE_$P($T(@3+BARCNT),BARD,2)
 Q:BARVALUE="END"!(BARVALUE="ENDEND")!(BARVALUE="ENDENDEND")
STND3  ;
 ;look for existing entry
 K DIC,DA,X,Y
 S DIC="^BARMKCD("
 S DIC(0)="L"
 S X=$P(BARVALUE,BARD,2)
 S DINUM=$P(BARVALUE,BARD)
 S DIC("DR")=".01///^S X=$P(BARVALUE,BARD,2)"        ;Code
 S DIC("DR")=DIC("DR")_";.02////^S X=$P(BARVALUE,BARD,3)"   ;Short Desc
 K DD,DO
 D FILE^DICN
 I Y<0 S (Y,X,DA)=+$O(^BARMKCD("B",$P(BARVALUE,BARD,2),0))  ;if the entry already exists
 I X=0 Q  ;failed entry for some reason; don't continue to stop any programming errors
 K BARLDESC
 S BARLDESC=""
 D LDESC^BARP1834($P(BARVALUE,BARD,4),DA,.BARLDESC)
 K ^BARMKCD(+DA,1)
 D WP^DIE(90056.23,+Y_",",101,"","BARLDESC")
 D MES^XPDUTL($P(BARVALUE,BARD,2)_$S($L($P(BARVALUE,BARD,3))=2:"   ",$L($P(BARVALUE,BARD,3))=1:"    ",1:"  ")_$E($P(BARVALUE,BARD,3),1,65))
 Q
 ;******************************
 ;ADD REMARK CODES
 ;IEN ;; REMARK CODE ;; SHORT DESC ;;  LONG DESC
 ;*****************************
1 ;;
 ;;1110;;N834;;Jurisdiction exempt from sales and health tax charges.;;Jurisdiction exempt from sales and health tax charges.
 ;;1111;;N835;;Unrelated svc/proc/treatment is reduced. Balance is patient's responsibility.;;Unrelated Service/procedure/treatment is reduced. The balance of this charge is the patient's responsibility.
 ;;1112;;N836;;Provider W9 or Payee Registration not on file.;;Provider W9 or Payee Registration not on file.
 ;;1113;;N837;;Alert: Missing modifier was added.;;Alert: Missing modifier was added.
 ;;1114;;N838;;Alert: deductible or member liability applied to prior plan year.;;Alert: Service/procedure postponed due to a federal, state, or local mandate/disaster declaration. Any amounts applied to deductible or member liability will be
 ;;1115;;N839;;Proc code added/changed because the level of service exceeds compensable cond.;;The procedure code was added/changed because the level of service exceeds the compensable condition(s).
 ;;1116;;N840;;Worker's compensation claim filed with a different state.;;Worker's compensation claim filed with a different state.
 ;;1117;;N841;;Alert: North Dakota Administrative Rule 92-01-02-50.3.;;Alert: North Dakota Administrative Rule 92-01-02-50.3.
 ;;1118;;N842;;Alert: Patient cannot be billed for charges.;;Alert: Patient cannot be billed for charges.
 ;;1119;;N843;;Missing/incomplete/invalid Core-Based Statistical Area (CBSA) code.;;Missing/incomplete/invalid Core-Based Statistical Area (CBSA) code.
 ;;1120;;N844;;Claim processed in accordance w/NE Legisl LB997 Out Of Netwk Emerg Med Care Act;;This claim, or a portion of this claim, was processed in accordance with the Nebraska Legislative LB997 July 24, 2020 - Out of Network Emergency
 ;;1121;;N845;;Alert: Nebraska Legislative LB997 Jul 24, 20-Out of Network Emerg Med Care Act.;;Alert: Nebraska Legislative LB997 July 24, 2020 - Out of Network Emergency Medical Care Act.
 ;;1122;;N846;;National Drug Code (NDC) supplied does not correspond to the HCPCs/CPT billed.;;National Drug Code (NDC) supplied does not correspond to the HCPCs/CPT billed.
 ;;1123;;N847;;National Drug Code (NDC) billed is obsolete.;;National Drug Code (NDC) billed is obsolete.
 ;;1124;;N848;;National Drug Code (NDC) billed cannot be associated with a product.;;National Drug Code (NDC) billed cannot be associated with a product.
 ;;1125;;N849;;Missing Tooth Clause: Tooth missing prior to the member effective date.;;Missing Tooth Clause: Tooth missing prior to the member effective date.
 ;;1126;;N850;;Missing/incomp/invalid narrative explaining/describing this service/treatment.;;Missing/incomplete/invalid narrative explaining/describing this service/treatment.
 ;;1127;;N851;;Payment reduced because services were furnished by a therapy assistant.;;Payment reduced because services were furnished by a therapy assistant.
 ;;1128;;N852;;The pay-to and rendering provider tax identification numbers (TINs) do not match;;The pay-to and rendering provider tax identification numbers (TINs) do not match
 ;;1129;;N853;;The number of modalities performed per session exceeds our acceptable maximum.;;The number of modalities performed per session exceeds our acceptable maximum.
 ;;1130;;N854;;Alert: you must exhaust all appeal levels with your primary other health ins.;;Alert: If you have primary other health insurance (OHI) coverage that has denied services, you must exhaust all appeal levels with your primary OHI
 ;;1131;;N855;;Cvg is subject to the exclusive jurisdiction of ERISA (1974), U.S.C. SEC 1001.;;This coverage is subject to the exclusive jurisdiction of ERISA (1974), U.S.C. SEC 1001.
 ;;1132;;N856;;Cvg not subject to the exclusive jurisdiction of ERISA (1974), U.S.C. SEC 1001.;;This coverage is not subject to the exclusive jurisdiction of ERISA (1974), U.S.C. SEC 1001.
 ;;1133;;N857;;Claim has been adjusted/reversed. Refund any collected copayment to the member.;;This claim has been adjusted/reversed. Refund any collected copayment to the member.
 ;;1134;;N858;;Payment amounts are eligible for dispute following the state's appeal process.;;Alert: State regulations relating to an Out of Network Medical Emergency Care Act were applied to the processing of this claim. Payment amounts are
 ;;1135;;N859;;Payment amounts are eligible for dispute persuant to Federal resolution process.;;Alert: The Federal No Surprise Billing Act was applied to the processing of this claim. Payment amounts are eligible for dispute pursuant to any
 ;;1136;;N860;;Alert: The Federal No Surprise Billing Ac Tqpa was used to calc the member cost.;;Alert: The Federal No Surprise Billing Act Qualified Payment Amount (QPA) was used to calculate the member cost share(s).
 ;;1137;;N861;;Alert: Mismatch between sub'd Pt Liab/Share and the amt on record for recipient.;;Alert: Mismatch between the submitted Patient Liability/Share of Cost and the amount on record for this recipient.
 ;;1138;;N862;;Alert: Member cost share is in compliance with the No Surprises Act.;;Alert: Member cost share is in compliance with the No Surprises Act, and is calculated using the lesser of the QPA or billed charge.
 ;;1139;;N863;;Alert: This clm is subject to the NSA. Amt pd is the final out-of-network rate.;;Alert: This claim is subject to the No Surprises Act (NSA). The amount paid is the final out-of-network rate and was calculated based on an All Pa
 ;;1140;;N864;;Alert: Claim is subject to No Surprises Act provisions that apply to emerg svcs;;Alert: This claim is subject to the No Surprises Act provisions that apply to emergency services.
 ;;1141;;N865;;Alert: Claim is subject to No Surprises Act for nonemerg svcs by nonpart prov.;;Alert: This claim is subject to the No Surprises Act provisions that apply to nonemergency services furnished by nonparticipating providers during
 ;;1142;;N866;;Alert: Claim is subject to the No Surprises Act for nonpart prov of air amb svc.;;Alert: This claim is subject to the No Surprises Act provisions that apply to services furnished by nonparticipating providers of air ambulance s
 ;;1143;;N867;;Alert: Cost sharing based on a specified state law in accord w No Surprises Act.;;Alert: Cost sharing was calculated based on a specified state law, in accordance with the No Surprises Act.
 ;;1144;;N868;;Alert: Cost sharing based on All-Payer Model Agmt in accord w No Surprises Act.;;Alert: Cost sharing was calculated based on an All-Payer Model Agreement, in accordance with the No Surprises Act.
 ;;1145;;N869;;Alert: Cost sharing based on qualifying pmt amt in accord w No Surprises Act.;;Alert: Cost sharing was calculated based on the qualifying payment amount, in accordance with the No Surprises Act.
 ;;1146;;N870;;Alert: Cost sharing based on billed amt-billed amt lower than qualifying pmt amt;;Alert: In accordance with the No Surprises Act, cost sharing was based on the billed amount because the billed amount was lower than the qualifyi
 ;;1147;;N871;;Alert: This pymt calc'd on a specified state law in accord w No Surprises Act.;;Alert: This initial payment was calculated based on a specified state law, in accordance with the No Surprises Act.
 ;;1148;;N872;;Alert: This final pmt calc'd on a spec state law in accord w No Surprises Act.;;Alert: This final payment was calculated based on a specified state law, in accordance with the No Surprises Act.
 ;;1149;;N873;;Alert: This final pmt calc'd on All-Payer Model Agmt in acc w No Surprises Act.;;Alert: This final payment was calculated based on an All-Payer Model Agreement, in accordance with the No Surprises Act.
 ;;1150;;N874;;Alert: This final pmt determined thru open negot in accord w No Surprises Act.;;Alert: This final payment was determined through open negotiation, in accordance with the No Surprises Act.
 ;;1151;;N875;;Alert: This final pmt was selected by a Federal Indep Dispute Resolution Entity.;;Alert: This final payment equals the amount selected as the out-of-network rate by a Federal Independent Dispute Resolution Entity, in accordance
 ;;1152;;N876;;Alert: This item or svc is covered. Prov/fac may initiate open negot if desired.;;Alert: This item or service is covered under the plan. This is a notice of denial of payment provided in accordance with the No Surprises Act. Th
 ;;1153;;N877;;Alert: This pmt is in accord w No Surprises Act. Prov/fac may init open negot.;;Alert: This initial payment is provided in accordance with the No Surprises Act. The provider or facility may initiate open negotiation if they des
 ;;1154;;N878;;Alert: Notice/consent not provided/obtained consistent with applicable Fed law.;;Alert: The provider or facility specified that notice was provided and consent to balance bill obtained, but notice and consent was not provided a
 ;;1155;;N879;;Alert: The notice/consent to balance bill is not permitted for these services. ;;Alert: The notice and consent to balance bill, and to be charged out-of-network cost sharing, that was obtained from the patient with regard to th
 ;;1156;;N880;;Orig clm closed,changes in sub'd data. Adj clm will be proc'd under new clm nbr.;;Original claim closed due to changes in submitted data. Adjustment claim will be processed under a new claim number.
 ;;1157;;N881;;Client Obligation, patient resp for Home & Community Based Services (HCBS);;Client Obligation, patient responsibility for Home & Community Based Services (HCBS)
 ;;1158;;N882;;Alert: The out-of-network pmt and cost sharing amts based on plan's allowance.;;Alert: The out-of-network payment and cost sharing amounts were based on the plan's allowance because the provider or facility obtained the patient
 ;;1159;;N883;;Alert: Processed according to state law;;Alert: Processed according to state law
 ;;1160;;N884;;Alert: The No Surprises Act may apply to this clm. Please contact payer.;;Alert: The No Surprises Act may apply to this claim. Please contact payer for instructions on how to submit information regarding whether or not the item
 ;;1161;;N885;;Alert: Clm not processed in accord w/No Surprises Act. You may appeal w/payer.;;Alert: This claim was not processed in accordance with the No Surprises Act cost-sharing or out-of-network payment requirements. The payer disagree
 ;;END
 ;
 ;
 ;**************************************
 ;Section 2 Overflow lines (>240 char)
 ;**************************************
2 ;;
 ;;
 ;;
 ;;
 ;;
 ;; applied to the prior plan year from which the procedure was cancelled.
 ;;
 ;;
 ;;
 ;;
 ;;
 ;; Medical Care Act.
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;; before we can consider your claim for reimbursement.  Start: 07/01/2021
 ;;
 ;;
 ;;
 ;; eligible for dispute following the state's documented appeal/ grievance/ arbitration process.
 ;; Federal documented appeal/ grievance/ dispute resolution process(es).
 ;;
 ;;
 ;;
 ;;yer Model Agreement, in accordance with the NSA.
 ;;
 ;; a patient visit to a participating facility.
 ;;ervices.
 ;;
 ;;
 ;;
 ;;ng payment amount.
 ;;
 ;;
 ;;
 ;;
 ;; with the No Surprises Act.
 ;;e provider or facility may initiate open negotiation if they desire to negotiate a higher out-of-network rate than the amount paid by the patient in cost sharing.
 ;;ire to negotiate a higher out-of-network rate.
 ;;nd obtained in a manner consistent with applicable Federal law. Thus, cost sharing and the total amount paid have been calculated based on the requirements under the No Surprises Act, and balance billing is prohibited.
 ;;e billed services, is not permitted for these services. Thus, cost sharing and the total amount paid have been calculated based on the requirements under the No Surprises Act, and balance billing is prohibited.
 ;;
 ;;
 ;;'s consent to waive the balance billing protections under the No Surprises Act.
 ;;
 ;; or service was furnished during a patient visit to a participating facility.
 ;;s with your determination that those requirements apply. You may contact the payer to find out why it disagrees. You may appeal this adverse determination on behalf of the patient through the payer's internal appeals
 ;;END
3 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;; and external review processes.
 ;;END
