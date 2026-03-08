BAR1834B ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**34**;OCT 26, 2005;Build 139
 ;IHS/SD/SDR 1.8*34 ADO60913 updated SARs and Remark Codes to April 2022
 ;
 ;***************************
RMK   ;
 ;Edit entries in A/R EDI Remark Codes
 S BARD=";;"
 S BARCNT=0
 D BMES^XPDUTL("Editing Remark Codes in A/R EDI Remark Code file...")
 F  D RMK2 Q:BARVALUE="END"!(BARVALUE="ENDEND")!(BARVALUE="ENDENDEND")
 Q
 ;****************************
RMK2  ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@3+BARCNT),BARD,2,6)
 S BARVALUE=BARVALUE_$P($T(@4+BARCNT),BARD,2)
 S BARVALUE=BARVALUE_$P($T(@5+BARCNT),BARD,2)
 Q:BARVALUE="END"!(BARVALUE="ENDEND")!(BARVALUE="ENDENDEND")
RMK3  ;
 ;look for existing entry
 K DIC,DA,X,Y
 S DIE="^BARMKCD("
 S DA=$P(BARVALUE,BARD)
 S DR=".02////^S X=$P(BARVALUE,BARD,3)"   ;Short Desc
 D ^DIE
 K BARLDESC
 S BARLDESC=""
 D LDESC^BARP1834($P(BARVALUE,BARD,4),$P(BARVALUE,BARD,2),.BARLDESC)
 K ^BARMKCD(+DA,1)
 D WP^DIE(90056.23,DA,101,"","BARLDESC")
 D MES^XPDUTL($P(BARVALUE,BARD,2)_$S($L($P(BARVALUE,BARD,3))=2:"   ",$L($P(BARVALUE,BARD,3))=1:"    ",1:"  ")_$E($P(BARVALUE,BARD,3),1,65))
 Q
 ;******************************
 ;EDIT REMARK CODES
 ;IEN ;; REMARK CODE ;; SHORT DESC ;;  LONG DESC
 ;*****************************
3 ;;
 ;;140;;M140;;Srvc not cvrd til after pat 50 birthday, ie, no cvrg prior day after 50 birthday;;Service not covered until after the patient's 50th birthday, i.e., no coverage prior to the day after the 50th birthday
 ;;163;;MA19;;Info not sent to Medigap-incorrect/invalid info submitted. Subm to 2ndry payer.;;Alert: Information was not sent to the Medigap insurer due to incorrect/invalid information you submitted concerning that insurer. Please verify yo
 ;;172;;MA28;;Receipt of this notice by phys/suplr is for info only. See RA for details.;;Alert: Receipt of this notice by a physician or supplier who did not accept assignment is for information only and does not make the physician or suppli
 ;;189;;MA45;;As previously advised, portion/all of pymt is being held in a special account.;;Alert: As previously advised, a portion or all of your payment is being held in a special account.
 ;;218;;MA74;;This pymt replaces earlier pymt for this clm that was lost, damaged or returned.;;Alert: This payment replaces an earlier payment for this claim that was either lost, damaged or returned.
 ;;288;;N10;;Adjstmt based on findings of a review org/peer review. See RA for details.;;Adjustment based on the findings of a review organization/professional consult/manual adjudication/medical advisor/dental advisor/peer review.
 ;;401;;N123;;Split svc represents a portion of the units from the originally submitted svc.;;Alert: This is a split service and represents a portion of the units from the originally submitted service.
 ;;402;;N124;;Pmt denied. Info not substantiate need for this more extensive service/item;;Payment has been denied for the/made only for a less extensive service/item because the information furnished does not substantiate the need for the (m
 ;;1106;;N830;;Charge[s] for svc processed in accord w Fed/State Bal/ No Surprise Billing regs.;;Alert: The charge[s] for this service was processed in accordance with Federal/ State, Balance Billing/ No Surprise Billing regulations. As such,
 ;;END
4 ;;
 ;;
 ;;ur information and submit your secondary claim directly to that insurer.
 ;;er a party to the determination. No additional rights to appeal this decision, above those rights already provided for by regulation/instruction, are conferred by receipt of this notice.
 ;;
 ;;
 ;;
 ;;
 ;;ore extensive) service/item. The patient is liable for the charges for this service/item as you informed the patient in writing before the service/item was furnished that we would not pay for it, and the patient agreed to pay.
 ;; any amount identified with OA, CO, or PI cannot be collected from the member and may be considered provider liability or be billable to a subsequent payer. Any amount the provider collected over the identified PR amount must be refunded t
 ;;END
5 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;o the patient within applicable Federal/State timeframes. Payment amounts are eligible for dispute pursuant to any Federal/State documented appeal/grievance process(es).
 ;;END
