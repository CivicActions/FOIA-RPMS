ADE6P371 ;IHS/OIT/GAB - ADE V6.0 PATCH 37 [ 12/02/2022  8:37 AM ]
 ;;6.0;ADE IHS DENTAL;**37**;March 25, 1999;Build 6
 ;IHS/OIT/GAB 12/2022 Patch 37 ADA-CDT code updates for 2023
 ;Addition of ADA-CDT 2023 Codes; 29 new codes added
 ;
ADDCDT37 ;EP
 D UPDATE^ADEUPD37(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P371","SETX^ADE6P371")
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
ADDADA ;code^Level of care^RVU^Syn^^Description/Nomen^Mnem^Op Site Prompt (either "n" or leave blank) / next line is the descriptor
 ;;D0372^5^5.60^IOTOM_FMS^^intraoral tomosynthesis-full mouth series^TFMS^n
 ;;A radiographic survey of the whole mouth intended to display the crowns and roots of all teeth, periapical areas, interproximal areas and alveolar bone including edentulous areas.
 ;;Includes diagnostic interpretation of the image[s].
 ;;D0373^5^0.46^IOTOM_BW^^intraoral tomosynthesis-bitewing radio image^TBTW^
 ;;A radiographic survey of the crowns of several adjacent [posterior] teeth to display the interproximal areas and alveolar bone; may include edentulous areas.
 ;;Includes diagnostic interpretation of the image[s].
 ;;D0374^5^0.45^IOTOM_PA^^intraoral tomosynthesis-periapi radio image^TPAX^
 ;;A radiographic survey of an individual (and/or adjacent) anterior or posterior tooth/teeth to display the crowns, roots and alveolar bone; may include edentulous areas.
 ;;Includes diagnostic interpretation of the image[s].
 ;;D0387^5^1.80^IOTOM_FMS_CAP^^intraoral tomo-comp series of radio-cap only^TFMC^n
 ;;A radiographic survey of the whole mouth intended to display the crowns and roots of all teeth, periapical areas, interproximal areas and alveolar bone including edentulous areas.
 ;;Does not include diagnostic interpretation of the image[s].
 ;;D0388^5^0.40^IOTOM_BW_CAP^^intraoral tomo-bitewing radio image-cap only^TBWC^
 ;;A radiographic survey of the crowns of several adjacent [posterior] teeth to display the interproximal areas and alveolar bone; may include edentulous areas.
 ;;Does not include diagnostic interpretation of the image[s].
 ;;D0389^5^0.40^IOTOM_PA_CAP^^intraoral tomo-periapi radio image-cap only^TPAC^
 ;;A radiographic survey of an individual (and/or adjacent) anterior or posterior tooth/teeth to display the crowns, roots and alveolar bone; may include edentulous areas.
 ;;Does not include diagnostic interpretation of the image[s].
 ;;D0801^5^5.00^3DSCN_TTH_DIR^^3D dental surface scan - direct^3DSD^n
 ;;A surface scan of the patient's dentition.
 ;;D0802^5^5.00^3DSCN_TTH_IND^^3D dental surface scan - indirect^3DSI^n
 ;;A surface scan of a diagnostic cast.
 ;;D0803^5^5.00^3DSCN_FAC_DIR^^3D facial surface scan - direct^3FSD^n
 ;;A surface scan of the patient's facial features (exterior skin).
 ;;D0804^5^5.00^3DSCN_FAC_IND^^3D facial surface scan - indirect^3FSI^n
 ;;A surface scan of constructed facial features.
 ;;D1708^2^1.45^CVDPFVAC3^^Pfizer Covid-19 vacc, 3rd dose^VPF3^n
 ;;Pfizer-BioNTech Covid-19 vaccine administration - third dose
 ;;D1709^2^1.45^CVDPFVACB^^Pfizer Covid-19 vacc, booster dose^VPFB^n
 ;;Pfizer-BioNTech Covid-19 vaccine administration - booster dose
 ;;D1710^2^1.45^CVDMDVAC3^^Moderna Covid-19 vacc, 3rd dose^VMD3^n
 ;;Moderna Covid-19 vaccine administration - third dose
 ;;D1711^2^1.45^CVDMDVACB^^Moderna Covid-19 vacc, booster dose^VMDB^n
 ;;Moderna Covid-19 vaccine administration - booster dose
 ;;D1712^2^1.45^CVDJNVACB^^Janssen Covid-19 booster dose^VJNB^n
 ;;Janssen Covid-19 vaccine administration - booster dose
 ;;D1713^2^1.45^CVDPFVCP1^^Pfizer Covid-19 vacc, pediatric 1st dose^VPP1^n
 ;;Pfizer-BioNTech Covid-19 vaccine administration, pediatric - first dose
 ;;D1714^2^1.45^CVDPFVCP2^^Pfizer Covid-19 vacc, pediatric 2nd dose^VPP2^n
 ;;Pfizer-BioNTech Covid-19 vaccine administration, pediatric - second dose
 ;;D1781^2^1.45^HPV_VAC_1^^vac admin-human papillomavirus-Dose 1^HPV1^n
 ;;Gardasil 9 0.5mL intramuscular vaccine injection
 ;;D1782^2^1.45^HPV_VAC_2^^vac admin-human papillomavirus-Dose 2^HPV2^n
 ;;Gardasil 9 0.5mL intramuscular vaccine injection.
 ;;D1783^2^1.45^HPV_VAC_2^^vac admin-human papillomavirus-Dose 3^HPV3^n
 ;;Gardasil 9 0.5mL intramuscular vaccine injection.
 ;;D4286^5^3.00^RMV_NR_BAR^^removal of non-resorbable barrier^RNRB^
 ;;Removal of non-resorbable barrier
 ;;D6105^1^2.20^RMV_IMP_SIMPLE^^rmvl impt bdy w/o bone rmvl / flap elev^RIMS^
 ;;Removal of implant body not requiring bone removal or flap elevation
 ;;D6106^5^2.00^GTR_RB_IMP^^guided tiss regen-resorb barrier, per implt^GTRR^
 ;;Use for for peri-implant defects & implant placement. DNI flap entry/closure; debridement;
 ;;osseous contouring; bone grafts; biologic materials.
 ;;D6107^5^3.00^GTR_NRB_IMP^^guided tiss regen-nonlresorb bar, per implt^GTRN^
 ;;Use for for peri-implant defects & implant placement. DNI flap entry/closure; debridement;
 ;;osseous contouring; bone grafts; biologic materials.
 ;;D6197^5^0.50^REST_IMP_ACC^^rplc rest_screw-rtned implt access_per implt^RIAC^
 ;;Replacement of restorative material used to close an access opening of a screw-retained implant supported prosthesis, per implant
 ;;D7509^1^12.00^MARS_ODCYST^^marsupialization of odontogenic cyst^MARS^
 ;;Surgical decompression of a large cystic lesion by creating a long-term open pocket or pouch.
 ;;D7956^5^1.50^GTR_RB_EDNT^^GTR_edent area-resrb membrane, per site^GTRE^
 ;;Use for ridge augmentation, sinus lift, and/or after tooth extraction.  
 ;;DNI flap entry / closure; debridement; osseous contouring; bone grafts; biologic materials.
 ;;D7957^5^2.10^GTR_NRB_EDNT^^GTR_edent area-nonresorb membrane, per site^GTNE^
 ;;Use for ridge augmentation, sinus lift, and/or after tooth extraction.  DNI flap entry / closure; debridement; osseous contouring; bone grafts; biologic materials.
 ;;D9953^5^6.00^REL_CSAD_LAB^^reline custom sleep apnea appl (indirect)^RLSL^
 ;;Resurface dentition side of appliance with new soft or hard base material.
 ;;***END***
