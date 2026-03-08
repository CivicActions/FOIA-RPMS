ADE6P411 ;IHS/GDIT/GAB - ADE V6.0 PATCH 41 [ 07/2024  8:37 AM ]
 ;;6.0;ADE IHS DENTAL;**41**;March 25, 1999;Build 57
 ;IHS/GDIT/GAB Patch 41: ADA-CDT code updates for 2025
 ;Adds 10 new dental procedures to the ADA Code file
 ;Updates 9710 (per DOH)
 ;
 Q
ADDCDT41 ;EP
 D UPDATE^ADEUTL2(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P411","SETX^ADE6P411")
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
ADDADA ;code^Level of care^RVU^Syn^^Description/Nomen^Mnem^Op Site Prompt (either "n" or leave blank) / next line is the descriptor
 ;;D2956^1^3.50^Rmv_Ind_Rest^^Removal indir rest natural tooth^RIRT^
 ;;Removal of an indirect restoration on a natural tooth. Not to be used for a temporary or provisional restoration.
 ;;D6180^3^5.00^Imp_Sup_HybPros^^Imp main full arch fxd hybrd prosth^ISHD^
 ;;Implant maintenance procedures when a full arch fixed hybrid prosthesis is not removed, including cleansing of prosthesis and abutments.
 ;;D6193^5^2.00^Rep_Imp_screw^^Replacement of implant screw^RISC^
 ;;Replacement of an implant screw
 ;;D7252^5^4.00^Par_Rmv_Tth_Imp^^Partial extract immediate imp plmnt^PEIP^
 ;;Section root vertically, extracting palatal root. Buccal section root retained stabilize prior immediate implt plcmnt.  AKA Socket Shield Technique.
 ;;D7259^5^9.50^NerveDissection^^Nerve Dissection^NrvD^
 ;;Involves the separation or isolation of a nerve from surrounding tissues. Performed to gain access to and protect nerves during surgical procedures.
 ;;D8091^5^95.00^CompOrtho_Osurg^^Compreh orth treat, orthognath surg^COOs^n
 ;;Treatment of craniofacial syndromes or orthopedic discrepancies that require multiple phases of orthodontic treatment
 ;;D8671^5^2.70^Ortho_TX_wOsurg^^Periodic ortho trtmnt assoc orthognath surg^PO^n
 ;;Periodic orthodontic treatment visit associated with orthognathic surgery.
 ;;D9913^5^0.90^Admin_Neuromod^^Administration of neuromodulators^Neur^n
 ;;Administration of neuromodulators. Examples include: Dopamine,Serotonin,Acetylcholine,Histamine,Norepinephrine,Nitric Oxide, and Cannabinoids.
 ;;D9914^9^3.80^Dermal_Fillers^^Administration of dermal fillers^AdDF^n
 ;;Administration of dermal fillers.
 ;;D9959^5^1.0^Unsp_SLAp_ByRpt^^Unspec slp apnea servi proc,by rpt^USpA^n
 ;;Unspecified sleep apnea services procedure, by report.
 ;;***END***
