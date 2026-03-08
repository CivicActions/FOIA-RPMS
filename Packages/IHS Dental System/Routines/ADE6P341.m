ADE6P341 ;IHS/OIT/GAB - ADE V6.0 PATCH 34 [ 11/21/19  8:37 AM ]
 ;;6.0;ADE*6.0*34;;March 25, 1999;Build 68
 ;IHS/OIT/GAB 11/2019 Patch 34 ADA-CDT code updates for 2020
 ;Addition of ADA-CDT 2020 Codes; 37 new codes added
 ;
ADDCDT34 ;EP
 D UPDATE^ADEUPD34(9999999.31,".01,.05,501,.06,,.02,8801,.09",1101,"?+1,","ADDADA^ADE6P341","SETX^ADE6P341")
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
ADDADA ;code^Level of care^RVU^Syn^^Nomen^Mnem^Op Site Prompt (either "n" or leave blank) / next line is the descriptor
 ;;D0419^5^1.00^MEAS SALIV FLOW^^assessment of salivary flow by measurement^MSFA^n
 ;;This procedure is for identification of low salivary flow in patients at risk for hyposalivation and xerostomia, as well as effectiveness of pharmacological
 ;;agents used to stimulate saliva production.
 ;;D1551^1^0.75^RECEM BI SM, MX^^re-cement or re-bond bilateral space maintainer - maxillary^BSMX^
 ;;D1552^1^0.75^RECEM BI SM, MN^^re-cement or re-bond bilateral space maintainer - mandibular^BSMN^
 ;;D1553^1^0.75^RECEM UNI SM^^re-cement or re-bond unilateral space maintainer - per quadrant^RSMU^
 ;;D1556^3^0.50^RMOV SM, UNI^^removal of fixed unilateral space maintainer - per quadrant^RVSU^
 ;;D1557^3^0.50^RMOV SM, BI, MX^^removal of fixed bilateral space maintainer - maxillary^RVSX^
 ;;Procedure performed by dentist or practice that did not originally place the appliance.
 ;;D1558^3^0.50^RMOV SM, BI, MN^^removal of fixed bilateral space maintainer - mandibular^RVSN^
 ;;Procedure performed by dentist or practice that did not originally place the appliance.
 ;;D2753^4^20.00^POR/MET CRN, TI^^crown - porcelain fused to titanium and titanium alloys^CPFT^
 ;;D5284^9^10.00^UNI RPD, FLX B^^removable unilateral partial denture - one piece flexible base (including clasps and teeth) - per quadrant^RUPF^
 ;;D5286^9^10.00^UNI RPD, RES B^^removable unilateral partial denture - one piece resin (including clasps and teeth) - per quadrant^RUPR^
 ;;D6082^5^21.00^IMP SUP PF CN B^^implant supported crown - porcelain fused to predominantly base alloys^ICPB^
 ;;A single metal-ceramic crown restoration that is retained, supported and stabilized by an implant.
 ;;D6083^5^21.00^IMP SUP PF CN N^^implant supported crown - porcelain fused to noble alloys^ICPN^
 ;;A single metal-ceramic crown restoration that is retained, supported and stabilized by an implant.
 ;;D6084^5^21.00^IMP SUP PF CN T^^implant supported crown - porcelain fused to titanium and titanium alloys^ICPT^
 ;;A single metal-ceramic crown restoration that is retained, supported and stabilized by an implant.
 ;;D6086^5^21.00^IMP SUP ME CN B^^implant supported crown - predominantly base alloys^ICMB^
 ;;A single metal crown restoration that is retained, supported and stabilized by an implant.
 ;;D6087^5^21.00^IMP SUP ME CN N^^implant supported crown - noble alloys^ICMN^
 ;;A single metal crown restoration that is retained, supported and stabilized by an implant.
 ;;D6088^5^21.00^IMP SUP ME CN T^^implant supported crown - titanium and titanium alloys^ICMT^
 ;;A single metal crown restoration that is retained, supported and stabilized by an implant.
 ;;D6097^5^21.00^ABT SUP PF CN T^^abutment supported crown - porcelain fused to titanium and titanium alloys^ACPT^
 ;;A single metal-ceramic crown restoration that is retained, supported, and stabilized by an abutment on an implant.
 ;;D6098^5^21.00^IMP SUP PF RE B^^implant supported retainer - porcelain fused to predominantly base alloys^IRPB^
 ;;A metal-ceramic retainer for a fixed partial denture that gains retention, support, and stability from an abutment on an implant.
 ;;D6099^5^21.00^IMP SUP PF RE N^^implant supported retainer for FPD - porcelain fused to noble alloys^IRPN^
 ;;A metal-ceramic retainer for a fixed partial denture that gains retention, support, and stability from an implant.
 ;;D6120^5^21.00^IMP SUP PF RE T^^implant supported retainer - porcelain fused to titanium and titanium alloys^IRPT^
 ;;A metal-ceramic retainer for a fixed partial denture that gains retention, support, and stability from an implant.
 ;;D6121^5^21.00^IMP SUP PF RE B^^implant supported retainer for metal FPD - predominantly base alloys^IRPB^
 ;;A metal retainer for a fixed partial denture that gains retention, support, and stability from an implant.
 ;;D6122^5^21.00^IMP SUP ME RE N^^implant supported retainer for metal FPD - noble alloys^IRMN^
 ;;A metal retainer for a fixed partial denture that gains retention, support, and stability from an implant.
 ;;D6123^5^21.00^IMP SUP ME RE T^^implant supported retainer for metal FPD - titanium and titanium alloys^IRMT^
 ;;A metal retainer for a fixed partial denture that gains retention, support, and stability from an implant.
 ;;D6195^5^21.00^ABT SUP PF RE T^^abutment supported retainer - porcelain fused to titanium and titanium alloys^ARPT^
 ;;A metal-ceramic retainer for a fixed partial denture that gains retention, support, and stability from an abutment on an implant.
 ;;D6243^5^21.00^PON, PFM, TI^^pontic - porcelain fused to titanium and titanium alloys^PPFT^
 ;;D6753^5^21.00^RET CRN PFM, TI^^retainer crown - porcelain fused to titanium and titanium alloys^RPFT^
 ;;D6784^5^21.00^RET CRN 3/4, TI^^retainer crown 3/4 - titanium and titanium alloys^R34T^
 ;;D7922^1^2.00^INTR SOC HEM MA^^placement of intra-socket biological dressing to aid in hemostasis or clot stabilization, per site^ISHM^
 ;;This procedure can be performed at time and/or after extraction to aid in hemostasis. The socket is packed with a hemostatic agent to aid in hemostasis and or clot stabilization.
 ;;D8696^1^3.25^REP MAX APP FUN^^repair of orthodontic appliance - maxillary^RPXA^
 ;;Does not include bracket and standard fixed orthodontic appliances.  It does include functional appliances and palatal expanders.
 ;;D8697^1^3.25^REP MAN APP FUN^^repair of orthodontic appliance - mandibular^RPNA^
 ;;Does not include bracket and standard fixed orthodontic appliances.  It does include functional appliances and palatal expanders.
 ;;D8698^1^4.00^REC FX RET MAX^^re-cement or re-bond fixed retainer - maxillary^RCXR^
 ;;D8699^1^4.00^REC FX RET MAN^^re-cement or re-bond fixed retainer - mandibular^RCNR^
 ;;D8701^1^5.00^REP MAX FXD RET^^repair of fixed retainer, includes reattachment - maxillary^RPXR^
 ;;D8702^1^5.00^REP MAN FXD RET^^repair of fixed retainer, includes reattachment - mandibular^RPNR^
 ;;D8703^4^5.10^RPL MAX RET^^replacement of lost or broken retainer - maxillary^RLXR^
 ;;D8704^4^5.10^RPL MAN RET^^replacement of lost or broken retainer - mandibular^RLNR^
 ;;D9997^1^3.00^DCM SPE HC NDS^^dental case management - patients with special health care needs^DCMS^n
 ;;Special treatment considerations for patients/individuals with physical, medical, developmental or cognitive conditions resulting in substantial functional limitations,
 ;;which require that modifications be made to delivery of treatment to provide comprehensive oral health care services.
 ;;***END***
