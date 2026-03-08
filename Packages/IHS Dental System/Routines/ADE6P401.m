ADE6P401 ;IHS/OIT/GAB - ADE V6.0 PATCH 40 [ 11/05/2023  8:37 AM ]
 ;;6.0;ADE IHS DENTAL;**40**;March 25, 1999;Build 10
 ;IHS/OIT/GAB 11/2023 Patch 40 ADA-CDT code updates for 2024
 ;Addition of ADA-CDT 2024 Codes; 14 new codes added
 ;
ADDCDT40 ;EP
 D UPDATE^ADEUPD40(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P401","SETX^ADE6P401")
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
ADDADA ;code^Level of care^RVU^Syn^^Description/Nomen^Mnem^Op Site Prompt (either "n" or leave blank) / next line is the descriptor
 ;;D0396^5^1.25^3D_Prnt_Tth^^3D printing of a 3D dental surface scan^3DTP^n
 ;;3D printing of a 3D dental surface scan
 ;;D1301^2^0.70^Immun_Counsel^^Immunization counseling^ImRC^n
 ;;A review of a patients vaccine and medical history, and discussion of the vaccine benefits, risks, and consequences of not obtaining the vaccine
 ;;D2976^3^1.20^Band_stabil_Tth^^Band stabilization - per tooth^BdSt^
 ;;A band cemented around molar after a multi-surface restoration, to add support/resistance to fracture until patient is ready for full cuspal restore
 ;;D2989^3^2.10^Tth_restor^^Excavation tooth to determine restorability^TExc^
 ;;Excavation of a tooth resulting in the determination of non-restorability
 ;;D2991^2^1.50^Hydrox_appl^^Appl hydroxyapatite regen medicament - per th^HdxA^
 ;;Preparation of tooth surfaces and topical application of a scaffold to guide hydroxyapatite regeneration
 ;;D6089^5^0.50^Imp_screw_tight^^Access/retorquing implnt screw_per screw^ImpS^
 ;;Access/retorquing loose implnt screw - per screw
 ;;D7284^3^5.00^ExcBiop_salglnd^^Excisional biopsy of minor salivary glands^BSGd^n
 ;;Excisional biopsy of minor salivary glands
 ;;D7939^5^5.40^Osteo_rob_asst^^Index osteotomy using dyna robotic assist^OsRb^n
 ;;A guide is stabilized to the teeth and/or the bone to allow for virtual guidance of osteotomy
 ;;D9938^9^2.90^Fab_Aesth_appl^^Fab custom remv clr plstic temp aesth appl^TAeF^
 ;;Fabrication of a custom removable clear plastic temporary aesthetic appliance
 ;;D9939^9^0.50^Plc_Aesth_appl^^Plmnt custom remv clr plstc temp aesth appl^TAeP^
 ;;Placement of a custom removable clear plastic temporary aesthetic appliance
 ;;D9954^5^10.00^OAT_Repos_devc^^Fab/del (OAT) morning repositioning device^OATD^
 ;;Fabrication and delivery of oral appliance therapy (OAT) morning repositioning device
 ;;D9955^1^1.20^OAT_Adj_vst^^Oral appliance therapy (OAT) titration visit^OATA^n
 ;;Oral appliance therapy (OAT) titration visit
 ;;D9956^5^1.00^Slp_Apn_tst^^Administration of home sleep apnea test^OATT^n
 ;;Administration of home sleep apnea test
 ;;D9957^2^0.30^Slp_Apn_scrn^^Screening sleep related breathing disorders^ScSA^n
 ;;Screening sleep related breathing disorders
 ;;***END***
