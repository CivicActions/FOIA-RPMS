BARADJRM ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**30**;OCT 26, 2005;Build 55
 ; IHS/SD/CPC - v1.8 p30 - updated SARs to May 2020
 ; CLONED FROM BARADJR7
 ;
 ; *********************************************************************
EN ; EP
 D RPMSREA                   ; Create RPMS Reasons
 D CHNGREA                   ; Change RPMS Reasons
 D STND                      ; Create new StanJdard Adj
 D CLAIM                     ; Create new Claim Status Codes
 D ^BARVKL0
 Q
 ; ********************************************************************
 ;
RPMSREA ;
 ; Create new Adjustment Reasons in A/R TABLE ENTRY
 S BARD=";;"
 S BARCNT=0
 D BMES^XPDUTL("Adding New Adjustment Reasons to A/R Table Entry file...")
 F  D RPMSREA2 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 Q
 ; ********************************************************************
 ;
RPMSREA2   ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@1+BARCNT),BARD,2,4)
 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 K DIC,DA,X,Y
 S DIC="^BARTBL("
 S DIC(0)="LZE"
 S DINUM=$P(BARVALUE,BARD)
 S X=$P(BARVALUE,BARD,2)
 S DIC("DR")="2////^S X=$P(BARVALUE,BARD,3)"
 K DD,DO
 D MES^XPDUTL($P(BARVALUE,BARD)_"  "_$P(BARVALUE,BARD,2))
 D FILE^DICN
 Q
 ; ********************************************************************
CHNGREA    ; EP
 ; Change category of these reasons to Non-Payment
 S BARD=";;"
 S BARCNT=0
 F  D CHNGREA2 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 Q
 ; ********************************************************************
CHNGREA2  ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@4+BARCNT),BARD,2,4)
 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 K DIC,DA,X,Y,DIE
 S DIE="^BARTBL("
 S DA=$P(BARVALUE,BARD)
 S DR=".01////^S X=$P(BARVALUE,BARD,2)"
 S DR=DR_";2////^S X=$P(BARVALUE,BARD,3)"
 D ^DIE
 Q
 ; ********************************************************************
STND   ;
 ; Create entries in A/R EDI STND CLAIM ADJ REASONS to accomodate
 ; Standard codes added between 6/02 and 9/03.
 S BARD=";;"
 S BARCNT=0
 D BMES^XPDUTL("Updating Standard Adjustment Reasons in A/R EDI STND CLAIM ADJ REASONS file...")
 F  D STND2 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 Q
 ; ********************************************************************
STND2  ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@2+BARCNT),BARD,2,6)
 S BARVALUE=BARVALUE_$P($T(@5+BARCNT),BARD,2)
 Q:BARVALUE="END"!(BARVALUE="ENDEND")
STND3  ;
 ;look for existing entry
 K DIC,DA,X,Y
 S DIC="^BARADJ("
 S DIC(0)="M"
 S X=$P(BARVALUE,BARD)
 D ^DIC
 I +Y>0 D  Q  ;if existing entry found - edit it
 .D MES^XPDUTL($P(BARVALUE,BARD)_$S($L($P(BARVALUE,BARD))=2:"   ",$L($P(BARVALUE,BARD))=1:"    ",1:"  ")_$E($P(BARVALUE,BARD,2),1,65))
 .K DIC,DIE
 .S DIE="^BARADJ("
 .S DA=+Y
 .S DR=".02///^S X=$P(BARVALUE,BARD,2)"              ; Short Desc
 .S DR=DR_";.03////^S X=$P(BARVALUE,BARD,3)"   ; RPMS Cat
 .S DR=DR_";.04////^S X=$P(BARVALUE,BARD,4)"   ; RPMS Type
 .S DR=DR_";101////^S X=$P(BARVALUE,BARD,5)"    ; Long Desc
 .D ^DIE
 ;create new entry if none found
 K DIC,DA,X,Y
 S DIC="^BARADJ("
 S DIC(0)="LZE"
 S X=$P(BARVALUE,BARD)                                     ; Stnd Code
 S DIC("DR")=".02///^S X=$P(BARVALUE,BARD,2)"              ; Short Desc
 S DIC("DR")=DIC("DR")_";.03////^S X=$P(BARVALUE,BARD,3)"   ; RPMS Cat
 S DIC("DR")=DIC("DR")_";.04////^S X=$P(BARVALUE,BARD,4)"   ; RPMS Type
 S DIC("DR")=DIC("DR")_";101////^S X=$P(BARVALUE,BARD,5)"    ; Long Desc
 K DD,DO
 D MES^XPDUTL($P(BARVALUE,BARD)_$S($L($P(BARVALUE,BARD))=2:"   ",$L($P(BARVALUE,BARD))=1:"    ",1:"  ")_$E($P(BARVALUE,BARD,2),1,65))
 D FILE^DICN
 Q
 ; ********************************************************************
CLAIM   ;
 ; Populate A/R EDI CLAIM STATUS CODES to accomodate new codes added
 ; between 6/02 and 9/03. Inactivate necessary codes.
 S BARCNT=0
 F  D CLAIM2 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 S BARCNT=0
 F BARVALUE=8,10,11,13,14,28,69,70 D CLAIM3
 Q
 ; ********************************************************************
CLAIM2   ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@3+BARCNT),BARD,2,4)
 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 K DIC,DA,X,Y
 S DIC="^BARECSC("
 S DIC(0)="LZE"
 S X=$P(BARVALUE,BARD)                        ;Status Cd
 S DIC("DR")="11///^S X=$P(BARVALUE,BARD,2)"  ;Description
 K DD,DO
 D FILE^DICN
 Q
 ; ********************************************************************
CLAIM3   ;
 K DIC,DA,X,Y
 S DIC="^BARECSC("
 S DIC(0)="XZQ"
 S X=BARVALUE
 K DD,DO
 D ^DIC
 Q:+Y<1
 K DA,DIE,DR
 S DA=+Y
 S DIE=DIC
 S DR=".02///Y"
 D ^DIE
 Q
 ; ********************************************************************
MODIFY   ; EP
 ; Change PENDING to NON PAYMENT
 S BARD=";;"
 S BARCNT=0
 F  D MODIFY2 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 Q
 ; *********************************************************************
MODIFY2   ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@4+BARCNT),BARD,2)
 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 K DIC,DA,X,Y,DR
 S DIC="^BARADJ("
 S DIC(0)="Z"
 S X=$P(BARVALUE,BARD)  ;Stnd Code
 K DD,DO
 D ^DIC
 Q:'+Y
 ;
 S DIE=DIC
 S DA=+Y
 S DR=".03////^S X=4"
 D ^DIE
 Q
 ;
 ; *********************************************************************
 ; IEN;;NAME;;TABLE TYPE
 ; *********************************************************************
1 ;; A/R Table Entry file - Adds
 ;;346;;Precert does not apply to prv;;4
 ;;347;;Submit to Vision Plan;;4
 ;;348;;Not Med/Forwarded to Vision;;4
 ;;349;;Prov not elig to recv pmt;;4
 ;;350;;Not Med/Forwarded to Behv Hlth;;4
 ;;351;;Submit to Behv Hlth Plan;;4
 ;;430;;Public Health Hazard COVID-19;;4;;
 ;;END
 ;
 ; ********************************************************************
 ; STND CODE ;; SHORT DESC ;; RPMS CAT ;; RPMS TYP ;; LONG DESC
 ; ********************************************************************
2 ;;
 ;;4;;Procedure code is inconsistent with modifier used;;4;;604;;The procedure code is inconsistent with the modifier used. Usage: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if pre
 ;;8;;Procedure code is not consistent with the provider type/specialty;;4;;608;;The procedure code is inconsistent with the provider type/specialty (taxonomy). Usage: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Ser
 ;;16;;Claim/service lacks information or has submission/billing error(s).;;4;;616;;Claim/service lacks information or has submission/billing error(s). At least one Remark Code must be provided (may be comprised of either the NCPDP Reject R
 ;;24;;Charges covered under cap agreement/managed care;;4;;624;;Charges are covered under a capitation agreement/managed care plan.
 ;;45;;Charges exceed fee schedule/max allow or contracted/legislated fee arrangement;;4;;645;;Charge exceeds fee schedule/max allowable or contracted/legislated fee arrangement. Usage: This adj amt cannot equal the total service or claim c
 ;;49;;Routine service done in conjunction with another routine/preventive exam;;4;;20;;This is a non-covered service because it is a routine/preventive exam or a diagnostic/screening procedure done in conjunction with a routine/preventive 
 ;;50;;Payer considers services not medically necessary;;4;;169;;These are non-covered services because this is not deemed a 'medical necessity' by the payer. Usage: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Servi
 ;;58;;Treatment rendered inappropriate or invalid date of service;;4;;658;;Treatment was deemed by the payer to have been rendered in an inappropriate or invalid place of service. Refer to the 835 Healthcare Policy Identification Segment (
 ;;70;;Cost outlier - Adjustment to compensate for additional costs;;4;;670;;Cost outlier - Adjustment to compensate for additional costs.
 ;;100;;Payment made to patient/insured/responsible party;;4;;23;;Payment made to patient/insured/responsible party.
 ;;115;;Procedure postponed or cancelled;;4;;715;;Procedure postponed, cancelled, or delayed.
 ;;139;;Contracted funding agreement - Subscriber employed by the provider of services;;4;;739;;Contracted funding agreement - Subscriber is employed by the provider of services. Use only with Group Code CO.
 ;;172;;Payment adjusted when performed/billed by a provider of this specialty;;4;;772;;Payment is adjusted when performed/billed by a provider of this specialty. Usage: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 S
 ;;179;;Patient has not met the required waiting requirements;;4;;779;;Patient has not met the required waiting requirements. Usage: Refer to the 835 Healthcare Policy Identification Segment (loop 2110 Service Payment Information REF), if p
 ;;192;;Non Standard adjustment code from paper remittance advice;;4;;792;;Non standard adjustment code from paper remittance. This code is only used when the non-standard code cannot be reasonably mapped to an existing Claims Adjustment Re
 ;;197;;Precertification / authorization / notification absent;;4;;797;;Precertification / authorization / notification / pre-treatment absent.
 ;;198;;Precertification / authorization exceeded;;4;;798;;Precertification / notification / authorization / pre-treatment exceeded.
 ;;219;;Based on extent of injury;;4;;949;;Based on extent of injury. If adj is at the Claim Level, the payer must send Loop 2100 Other Claim Related Info REF qualifier 'IG'. If adj is at the Line Level, the payer must send loop 2110 Servic
 ;;270;;Benefit not available under medical plan. Submit to dental plan.;;4;;320;;Claim received by the medical plan, but benefits not available under this plan. Submit these services to the patient's dental plan for further consideration. 
 ;;280;;Claim received by medical plan. Submit to pharmacy plan for consideration.;;4;;330;;Claim received by the medical plan, but benefits not available under this plan. Submit these services to the patient's Pharmacy plan for further con
 ;;290;;Claim recd by dental plan but benefit not available. Claim forwarded to medical.;;4;;340;;Claim received by the dental plan, but benefits not available under this plan. Claim has been forwarded to the patient's medical plan for furt
 ;;291;;Claim recd by medical plan but benefit not available. Claim forwarded to dental.;;4;;341;;Claim received by the medical plan, but benefits not available under this plan. Claim has been forwarded to the patient's dental plan for furt
 ;;292;;Claim recd by medical plan but benefit not available. Claim forwarded to Rx.;;4;;342;;Claim received by the medical plan, but benefits not available under this plan. Claim has been forwarded to the patient's pharmacy plan for furthe
 ;;B7;;Provider not certified/eligible to be paid for proc/service on date of service;;4;;857;;This provider was not certified/eligible to be paid for this procedure/service on this date of service. Usage: Refer to the 835 Healthcare Policy
 ;;B12;;Services not documented in patient's medical records;;4;;862;;Services not documented in patient's medical records.
 ;;296;;Precert/authorization may be valid but does not apply to provider;;4;;346;;Precertification/authorization/notification/pre-treatment number may be valid but does not apply to the provider.
 ;;297;;Claim received by medical plan. Submit to vision plan for consideration.;;4;;347;;Claim received by the medical plan, but benefits not available under this plan. Submit these services to the patient's vision plan for further conside
 ;;298;;Claim received by medical plan. Claim forwarded to vision plan;;4;;348;;Claim received by the medical plan, but benefits not available under this plan. Claim has been forwarded to the patient's vision plan for further consideration.
 ;;299;;Billing provider not elig to receive payment for services billed;;4;;349;;The billing provider is not eligible to receive payment for the service billed.
 ;;300;;Claim received by medical plan. Claim forwarded to behavioral health plan;;4;;350;;Claim received by the Medical Plan, but benefits not available under this plan. Claim has been forwarded to the patient's Behavioral Health Plan for 
 ;;301;;Claim received by medical plan. Submit to bhvrl hlth plan for consideration;;4;;351;;Claim received by the Medical Plan, but benefits not available under this plan. Submit these services to the patient's Behavioral Health Plan for f
 ;;END
 ;
 ; ********************************************************************
 ; CLAIM STATUS CODE ;; DESCRIPTION
 ; ********************************************************************
3 ;; - A/R EDI Claim Status Codes file - Adds
 ;;END
 ;
 ; ********************************************************************
 ; STANDARD CODE ;; RPMS REASON
 ; ********************************************************************
4 ;;A/R Table Entry file - Edits
 ;;351;;Submit to Behv Hlth Plan;;4
 ;;604;;Proc code inconsist w/mod;;4
 ;;779;;Pymt Adj Pt Waiting Req Not Met;;4
 ;;END
 ;
 ;; ********************************************************************
 ; Section 2 Overflow lines (>240 char)
 ; ********************************************************************
5 ;;
 ;;sent.
 ;;vice Payment Information REF), if present.
 ;;eason Code, or Remittance Advice Remark Code that is not an ALERT.)
 ;;
 ;;harge amount and must not duplicate provider's prior adjustment amounts.
 ;;exam. 
 ;;ce Payment Information REF), if present.
 ;;loop 2110 Service Payment Information REF), if present.
 ;;
 ;;
 ;;
 ;;
 ;;ervice Payment Information REF), if present.
 ;;resent.
 ;;ason Code, specifically Deductible, Coins and Co-payment.
 ;;
 ;;
 ;;e Payment info REF.
 ;;Notes: Use CARC 291 if the claim was forwarded.
 ;;sideration. Notes: Use CARC 292 if the claim was forwarded.
 ;;her consideration. Notes: Use CARC 254 if the claim was not forwarded.
 ;;her consideration. Notes: Use CARC 270 if the claim was not forwarded.
 ;;r consideration. Notes: Use CARC 280 if the claim was not forwarded.
 ;; Identification Segment (loop 2110 Service Payment Information REF), if present.
 ;;
 ;;
 ;;ration.
 ;;
 ;;
 ;;further consideration.
 ;;urther consideration.
 ;;END
