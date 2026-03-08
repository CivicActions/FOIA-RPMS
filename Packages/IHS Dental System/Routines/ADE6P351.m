ADE6P351 ;IHS/OIT/GAB - ADE V6.0 PATCH 35 [ 11/21/20  8:37 AM ]
 ;;6.0;ADE*6.0*35;;March 25, 1999;Build 82
 ;IHS/OIT/GAB 11/2020 Patch 35 ADA-CDT code updates for 2021
 ;Addition of ADA-CDT 2021 Codes; 28 new codes added
 ;
ADDCDT35 ;EP
 D UPDATE^ADEUPD35(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P351","SETX^ADE6P351")
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
ADDADA ;code^Level of care^RVU^Syn^^Nomen^Mnem^Op Site Prompt (either "n" or leave blank) / next line is the descriptor
 ;;D0604^1^1.30^Antgn tst path^^antigen testing for pathogen, includes CVD-19^AGTP^n
 ;;antigen testing for a public health related pathogen, including coronavirus
 ;;D0605^1^1.30^Antbd tst path^^antibody testing for pathogen, include CVD-19^ABTP^n
 ;;antibody testing for a public health related pathogen, including coronavirus
 ;;D0701^3^1.30^Pano Cptr^^panoramic radiographic image - capture only^PXCP^n
 ;;panoramic radiographic image - image capture only
 ;;D0702^5^1.30^2D Ceph Cptr^^2-D cephalometric image - image capture only^2CXC^n
 ;;2-D cephalometric radiographic image - image capture only
 ;;D0703^5^0.50^2D Photo Cptr^^2-D oral/facial int/extraoral photo - capture^2DPC^n
 ;;2-D oral/facial photographic image obtained intra-orally or extra-orally - image capture only
 ;;D0704^5^5.00^3D Photo Cptr^^3-D photographic image - image capture only^3DPC^n
 ;;3-D photographic image - image capture only
 ;;D0705^5^0.60^ExO Post X Cptr^^extraoral post x-ray film - capture only^EPXC^
 ;;Image limited to exposure of complete posterior teeth in both dental arches. This is a unique image that is not derived from another image.
 ;;D0706^3^0.50^InO Occ X Cptr^^intraoral - occlusal x-ray - capture only^IOXC^
 ;;intraoral - occlusal radiographic image - image capture only
 ;;D0707^1^0.40^InO Peri X Cptr^^intraoral - periapical x-ray - capture only^IPXC
 ;;intraoral - periapical radiographic image - image capture only
 ;;D0708^1^0.40^InO Bw X Cptr^^intraoral - bitewing x-ray - capture only^IBXC^n
 ;;Image axis may be horizontal or vertical.
 ;;D0709^3^1.80^InO FMS X Cptr^^intraoral - FMS x-rays - image capture only^IFXC^n
 ;;A radiographic survey of the whole mouth, usually consisting of 14-22 images (periapical and posterior bitewing as indicated) intended to 
 ;;display the crowns and roots of all teeth, periapical areas and alveolar bone.
 ;;D1321^2^0.70^Pt Couns HR Sub^^Pt counseling for high-risk substance use^PCHD^n
 ;;Counseling services may include patient education about adverse oral, behavioral, and systemic effects associated with high-risk substance use 
 ;;and administration routes. This includes ingesting, injecting, inhaling and vaping. Substances used in a high-risk manner may include but are 
 ;;not limited to alcohol, opioids, nicotine, cannabis, methamphetamine and other pharmaceuticals or chemicals.
 ;;D1355^3^0.80^Car Pv Med Appl^^Caries preventive med application-per tooth^CPMA^
 ;;For primary prevention or remineralization. Medicaments applied do not include topical fluorides.
 ;;D2928^5^6.00^Prefab Porc Crn^^Prefab Porcelain/C crown - Perm^PFCC^
 ;;prefabricated porcelain/ceramic crown - permanent tooth
 ;;D3471^4^9.10^Surg Rt Rep Ant^^Surgical repair of root resorption - anterior^SRRA^
 ;;For surgery on root of anterior tooth. Does not include placement of restoration.
 ;;D3472^4^10.50^Surg Rt Rep Pre^^Surgical repair of root resorption - premolar^SRRP^
 ;;For surgery on root of premolar tooth. Does not include placement of restoration.
 ;;D3473^5^11.70^Surg Rt Rep Mol^^Surgical repair of root resorption - molar^SRRM^
 ;;For surgery on root of molar tooth. Does not include placement of restoration.
 ;;D3501^4^4.70^SurRtExpw/oRp,A^^Surg expose root surface w/o repair-anterior^SREA^
 ;;Exposure of root surface followed by observation and surgical closure of the exposed area.
 ;;Not to be used for or in conjunction with apicoectomy or repair of root resorption.
 ;;D3502^4^4.70^SurRtExpw/oRp,P^^Surg expose root surface w/o repair-premolar^SREP^
 ;;Exposure of root surface followed by observation and surgical closure of the exposed area. Not to be used for or in conjunction with apicoectomy or 
 ;;repair of root resorption.
 ;;D3503^4^4.70^SurRtExpw/oRp,M^^Surg expose root surface w/o repair-molar^SREM^
 ;;Exposure of root surface followed by observation and surgical closure of the exposed area. Not to be used for or in conjunction with apicoectomy or repair of root resorption.
 ;;D5995^5^2.40^Per Med Car Max^^Periodontal med carrier-lab processed-max^PMCX^
 ;;A custom fabricated, laboratory processed carrier for the maxillary arch that covers the teeth and alveolar mucosa.
 ;;Used as a vehicle to deliver prescribed medicaments for sustained contact with the gingiva, alveolar mucosa, and into the periodontal sulcus or pocket.
 ;;D5996^5^2.40^Per Med Car Mnd^^Periodontal med carrier-lab processed-mand^PMCN^
 ;;A custom fabricated, laboratory processed carrier for the mandibular arch that covers the teeth and alveolar mucosa.
 ;;Used as a vehicle to deliver prescribed medicaments for sustained contact with the gingiva, alveolar mucosa, and into the periodontal sulcus or pocket.
 ;;D6191^5^9.00^SPr Abt, Plac^^semi-precision abutment - placement^SPBP^
 ;;This procedure is the initial placement, or replacement, of a semi-precision abutment on the implant body.
 ;;D6192^5^9.00^SPr Att, Plac^^semi-precision attachment - placement^SPTP^
 ;;This procedure involves the luting of the initial, or replacement, semi-precision attachment to the removable prosthesis.
 ;;D7961^4^6.70^Fac Frenectomy^^buccal / labial frenectomy (frenulectomy)^FFRN^
 ;;buccal / labial frenectomy (frenulectomy)
 ;;D7962^4^6.70^Lin Frenectomy^^lingual frenectomy (frenulectomy)^LFRN^
 ;;lingual frenectomy (frenulectomy)
 ;;D7993^5^95.00^CF Imp ExO, Pl^^Surgical place craniofacial implant-extraoral^CFIP^
 ;;Surgical placement of a craniofacial implant to aid in retention of an auricular, nasal, or orbital prosthesis.
 ;;D7994^5^40.00^Zyg Imp ExO, Pl^^Surgical placement: zygomatic implant^ZYIP^
 ;;An implant placed in the zygomatic bone and exiting through the max mucosal tissue providing support and attachment of a maxillary dental prosthesis.
 ;;***END***
