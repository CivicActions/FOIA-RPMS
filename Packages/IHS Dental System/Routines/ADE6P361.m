ADE6P361 ;IHS/OIT/GAB - ADE V6.0 PATCH 36 [ 10/20/2021  8:37 AM ]
 ;;6.0;ADE IHS DENTAL;**36**;March 25, 1999;Build 86
 ;IHS/OIT/GAB 10/2021 Patch 36 ADA-CDT code updates for 2022
 ;Addition of ADA-CDT 2022 Codes; 24 new codes added + 9 updated codes
 ;
ADDCDT36 ;EP
 D UPDATE^ADEUPD36(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P361","SETX^ADE6P361")
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
ADDADA ;code^Level of care^RVU^Syn^^Description/Nomen^Mnem^Op Site Prompt (either "n" or leave blank) / next line is the descriptor
 ;;D0606^1^1.45^TEST, VIRAL^^Test for public health pathogen^TEVL^n
 ;;molecular testing for a public health related pathogen, including coronavirus.
 ;;D1701^1^1.45^CVDPFVAC1^^Pfizer Covid-19 vacc, 1st dose^VPF1^n
 ;;SARSCOV2 COVID-19 VAC mRNA 30mcg/0.3mL IM DOSE 1.
 ;;D1702^1^1.45^CVDPFVAC2^^Pfizer Covid-19 vacc, 2nd dose^VPF2^n
 ;;SARSCOV2 COVID-19 VAC mRNA 30mcg/0.3mL IM DOSE 2.
 ;;D1703^1^1.45^CVDMDVAC1^^Moderna Covid-19 vacc, 1st dose^VMD1^n
 ;;SARSCOV2 COVID-19 VAC mRNA 100mcg/0.5mL IM DOSE 1.
 ;;D1704^1^1.45^CVDMDVAC2^^Moderna Covid-19 vacc, 2nd dose^VMD2^n
 ;;SARSCOV2 COVID-19 VAC mRNA 100mcg/0.5mL IM DOSE 2.
 ;;D1705^1^1.45^CVDAZVAC1^^AstraZenecaCovid-19vacc, dose1st^VAZ1^n
 ;;SARSCOV2 COVID-19 VAC rS-ChAdOx1 5x1010 VP/.5mL IM DOSE 1.
 ;;D1706^1^1.45^CVDAZVAC2^^AstraZenecaCovid-19vacc, dose2nd^VAZ2^n
 ;;SARSCOV2 COVID-19 VAC rS-ChAdOx1 5x1010 VP/.5mL IM DOSE 2.
 ;;D1707^1^1.45^CVDJANVAC^^Janssen Covid-19 vaccine admin^VJN^n
 ;;SARSCOV2 COVID-19 VAC Ad26 5x1010 VP/.5mL IM SINGLE DOSE.
 ;;D3911^5^0.50^ENDO_TEMP_SEAL^^Intraorifice barrier^ENTS^
 ;;Not to be used as a final restoration.
 ;;D3921^5^4.00^ROOT_PRESERV^^Decoronation & submerg, erupted tooth root^RBNK^
 ;;Intentional removal of coronal tooth structure for preservation of the root and surrounding bone.
 ;;D4322^3^6.80^TTH_SPLNT_INT^^Splint - intra-coronal^TSPI^
 ;;Additional procedure that physically links individual teeth or prosthetic crowns to provide stabilization and additional strength.
 ;;D4323^3^6.00^TTH_SPLNT_EXT^^Splint - extra-coronal^TSPE^
 ;;Additional procedure that physically links individual teeth or prosthetic crowns to provide stabilization and additional strength.
 ;;D5227^5^17.00^IM_FLX_RPD_MX^^Imd maxil partl-flexible base^IFRX^
 ;;immediate maxillary partial denture - flexible base (including any clasps, rests and teeth).
 ;;D5228^5^17.00^IM_FLX_RPD_MN^^Imd mand partial-flexible base^IFRN^
 ;;immediate mandibular partial denture - flexible base (including any clasps, rests and teeth).
 ;;D5725^5^14.90^REBAS_CAST_RPD^^Rebase hybrid prosthesis^RBCR^n
 ;;Replacing the base material connected to the framework.
 ;;D5765^5^8.00^SOFT_RELIN_DN^^Soft liner,remov dentr-indirect^SRCD^n
 ;;A discrete procedure provided when the dentist determines placement of the soft liner is clinically indicated.
 ;;D6198^5^9.00^REM_IMP_PART^^Remove interim implant component^RMIP^
 ;;Removal of implant component (e.g., interim abutment; provisional implant crown) originally placed for a specific clinical purpose and period of time determined by the dentist.
 ;;D7298^5^9.00^REM_TANCH_DEV^^Remove screw retained plate,requires flap^RMAD^n
 ;;removal of temporary anchorage device [screw retained plate], requiring flap.
 ;;D7299^5^9.00^REM_TDVC_WF^^Remove temp anchor device, requires flap^RDWF^n
 ;;removal of temporary anchorage device, requiring flap.
 ;;D7300^5^6.00^REM_TDVC_WOF^^Remove temp anchor device, w/o flap^RDNF^n
 ;;removal of temporary anchorage device without flap.
 ;;D9912^1^0.50^PREV_PT_SCRN^^Pre-visit patient screening^PVPS^n
 ;;Capture and documentation of a patients health status prior to or on the scheduled date of service to evaluate risk of infectious disease transmission if the patient is to be treated within the dental practice.
 ;;D9947^5^10.00^CUS_SLPAP_DV^^Custom sleep apnea appl fabricate & place^SLPD^n
 ;;custom sleep apnea appliance fabrication and placement.
 ;;D9948^1^1.20^ADJ_SLPAP_DV^^Adj custom sleep apnea appliance^ASLD^n
 ;;adjustment of custom sleep apnea appliance.
 ;;D9949^1^3.40^REP_SLPAP_DV^^Repair custom sleep apnea appliance^RPSD^n
 ;;repair of custom sleep apnea appliance.
 ;;D0180^3^1.00^PERIO EVAL^^Comprehensive perio eval - New/established Pt^PERE^n
 ;;D2971^5^0.50^ADNCRPROC_RPD^^Add'l prc-new crn undr exs dent^CPUR^
 ;;D6012^5^25.00^ENDOSTEAL IMP^^Plcmnt of intrm impl: endosteal^PLINIMP^
 ;;D6051^5^5.70^INTABUT^^Interim implant abutment placement^INTABUT^
 ;;D6100^5^12.90^REMOVE IMPLANT^^Surg removal of implant body^IMPR^
 ;;D7292^5^29.50^PLATE W/FLAP^^Place temp anch screw plate requires flap^TAPF^n
 ;;D7293^5^20.00^ANCHOR W/FLAP^^Placement: temp anchorage_includes flap^TAIF^n
 ;;D7294^5^13.30^ANCHOR W/O FLAP^^Placement: temp anchorage_without flap^TAWF^n
 ;;D9997^1^3.00^DCM SPE HC NDS^^DCM: special health care needs^DCMS^n
 ;;***END***
