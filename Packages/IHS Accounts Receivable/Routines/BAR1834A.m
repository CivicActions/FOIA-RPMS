BAR1834A ; IHS/SD/LSL - CREATE ENTRY IN A/R EDI STND CLAIM ADJ REASON ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**34**;OCT 26, 2005;Build 139
 ;IHS/SD/SDR 1.8*34 ADO60913 updated SARs and Remark Codes to April 2022
 ;
 ;***************************
EN ; EP
 D RPMSADJ  ;add A/R TABLE ENTRY/IHS entries needed for new SARs
 D STND   ;Create new Standard Adjustment Reasons SARs
 D ^BARVKL0
 Q
 ;**************************
RPMSADJ   ;
 ;Create entries in A/R TABLE ENTRY/IHS file
 S BARD=";;"
 S BARCNT=0
 D BMES^XPDUTL("Adding entries to A/R TABLE ENTRY/IHS file...")
 F  D RPMSADJ2 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 Q
 ;****************************
RPMSADJ2   ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@3+BARCNT),BARD,2,4)
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
 ;**************************
STND   ;
 ;Create entries in A/R EDI STND CLAIM ADJ REASONS to accomodate
 S BARD=";;"
 S BARCNT=0
 D BMES^XPDUTL("Adding Standard Adjustment Reasons in A/R EDI STND CLAIM ADJ REASONS file...")
 F  D STND2 Q:BARVALUE="END"!(BARVALUE="ENDEND")
 Q
 ;****************************
STND2  ;
 S BARCNT=BARCNT+1
 S BARVALUE=$P($T(@1+BARCNT),BARD,2,6)
 S BARVALUE=BARVALUE_$P($T(@2+BARCNT),BARD,2)
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
 .S DR=".02///^S X=$P(BARVALUE,BARD,2)"        ;Short Desc
 .S DR=DR_";.03////^S X=$P(BARVALUE,BARD,3)"   ;RPMS Cat
 .S DR=DR_";.04////^S X=$P(BARVALUE,BARD,4)"   ;RPMS Type
 .S DR=DR_";101////^S X=$P(BARVALUE,BARD,5)"   ;Long Desc
 .D ^DIE
 ;create new entry if none found
 K DIC,DA,X,Y
 S DIC="^BARADJ("
 S DIC(0)="LZE"
 S X=$P(BARVALUE,BARD)                                     ;Stnd Code
 S DIC("DR")=".02///^S X=$P(BARVALUE,BARD,2)"              ;Short Desc
 S DIC("DR")=DIC("DR")_";.03////^S X=$P(BARVALUE,BARD,3)"  ;RPMS Cat
 S DIC("DR")=DIC("DR")_";.04////^S X=$P(BARVALUE,BARD,4)"  ;RPMS Type
 S DIC("DR")=DIC("DR")_";101////^S X=$P(BARVALUE,BARD,5)"  ;Long Desc
 K DD,DO
 D MES^XPDUTL($P(BARVALUE,BARD)_$S($L($P(BARVALUE,BARD))=2:"   ",$L($P(BARVALUE,BARD))=1:"    ",1:"  ")_$E($P(BARVALUE,BARD,2),1,65))
 D FILE^DICN
 Q
 ;******************************
 ;Add SARs
 ;STND CODE ;; SHORT DESC ;; RPMS CAT ;; RPMS TYP ;; LONG DESC
 ;*****************************
1 ;;
 ;;302;;Precert/notification/authorization/pre-treatment time limit has expired.;;4;;352;;Precertification/notification/authorization/pre-treatment time limit has expired.
 ;;303;;Patient responsibility not covered for Qualified Medicare and Medicaid Benef.;;4;;353;;Prior payer's (or payers') patient responsibility (deductible, coinsurance, co-payment) not covered for Qualified Medicare and Medicaid Beneficiari
 ;;304;;Benefits not avail under medical plan. Submit to patient's hearing plan.;;4;;354;;Claim received by the medical plan, but benefits not available under this plan. Submit these services to the patient's hearing plan for further consider
 ;;305;;Benefits not avail under medical plan. Claim forwarded to pt's hearing plan.;;4;;355;;Claim received by the medical plan, but benefits not available under this plan. Claim has been forwarded to patient's hearing plan for further consi
 ;;P30;;Payment denied for exacerbation when supporting doc not complete. Prop/Cas only.;;4;;356;;Payment denied for exacerbation when supporting documentation was not complete. To be used for Property and Casualty only.
 ;;P31;;Payment denied for exacerbation when treatment exceeds time allowed. Prop/Cas.;;4;;432;;Payment denied for exacerbation when treatment exceeds time allowed. To be used for Property and Casualty only.
 ;;P32;;Payment adjusted due to Apportionment.;;4;;433;;Payment adjusted due to Apportionment.
 ;;END
 ;
 ;
 ;**************************************
 ;Section 2 Overflow lines (>240 char)
 ;**************************************
2 ;;
 ;;
 ;;es. (Use only with Group Code CO).
 ;;ation.
 ;;deration.
 ;;
 ;;
 ;;
 ;;END
 ; ********************************
 ; A/R TABLE ENTRY/IHS adds
 ; IEN;;NAME;;TABLE TYPE
 ; *******************************
3 ;;
 ;;352;;Precert/auth time expired;;4
 ;;353;;Pt resp not cvrd for QMB;;4
 ;;354;;Submit to pt's hearing plan.;;4
 ;;355;;Clm forwarded to hearing plan.;;4
 ;;356;;Pmt Den-Supporting Doc Not Cmp;;4
 ;;432;;Pmt Denied-Trtmt Exceeds Time;;4
 ;;433;;Pmt adj due to Apportionment;;4
 ;;431;;AR BALANCE RECONCILIATION-UFMS;;3
 ;;END
