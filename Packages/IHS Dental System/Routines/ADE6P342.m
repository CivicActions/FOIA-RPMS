ADE6P342 ;IHS/OIT/GAB - ADE V6.0 PATCH 34 [ 11/22/2019 8:37 AM ]
 ;;6.0;ADE*6.0*34;;March 25, 1999;Build 68
 ;IHS/OIT/GAB 11/2019 Patch 34 ADA-CDT code updates for 2020
 ;Modification of 2020 ADA-CDT Codes - Update the .02 field (Nomenclature) and 1101 (Descriptor/Use Field)
MODCDT34 ;EP
 D UPDATE^ADEUPD34(9999999.31,".01,,.02",1101,"?+1,","MODADA^ADE6P342","SETX^ADE6P342")
 Q
 ;
SETX ;EP
 I $G(ADERPEAT) D  Q:ADERPEAT
 .S:ADERPEAT=1 ADECURX=ADEX,ADERPEAT=2
 .S ADEN=$O(^AUTTADA("B",ADEN)) I ADEN'?1N.N!(ADEN]ADEEND) S ADERPEAT=0,ADEX=ADECURX,ADEN="" Q
 .S ADEX=ADESVX,$P(ADEX,U)=ADEN,ADERPEAT=2
 Q:ADEDONE
 I $P(ADEX,U)["-" D  Q:'ADERPEAT
 .S ADERPEAT=1,ADESVX=ADEX,ADESTART=$P($P($P(ADEX,U),"-"),"D",2),ADEEND=$P($P($P(ADEX,U),"-",2),"D",2),ADEN=$O(^AUTTADA("B",ADESTART),-1)
 .S ADEN=$O(^AUTTADA("B",ADEN)) I ADEN'?1N.N!(ADEN]ADEEND) S ADERPEAT=0,ADEN="" Q
 .S $P(ADEX,U)=ADEN
 I 'ADERPEAT S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN
 S $P(ADEX,U,3)=$TR($P(ADEX,U,3),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S:ADERPEAT ADESVX=ADEX
 Q
 ;
MODADA ;  Code^^Nomenclature    /   Descriptor on next line
 ;;NOMENCLATURE=RPMS Description Field (.02) & DESCRIPTOR=RPMS Use Field IN THE ADA CODE FILE
 ;;D1510^^space maintainer - fixed, unilateral - per quadrant
 ;;Excludes a distal shoe space maintainer
 ;;D1520^^space maintainer - removable, unilateral - per quadrant
 ;;D1575^^distal shoe space maintainer - fixed, unilateral - per quadrant
 ;;Fabrication and delivery of fixed appliance extending subgingivally and distally to guide the eruption of the first permanent molar.
 ;;Does not include ongoing follow-up or adjustments, or replacement appliances, once the tooth has erupted.
 ;;D2794^^crown - titanium and titanium alloys
 ;;D5213^^maxillary partial denture - cast metal framework with resin denture bases (including retentive/clasping materials, rests and teeth)
 ;;D5214^^mandibular partial denture - cast metal framework with resin denture bases (including retentive/clasping materials, rests and teeth)
 ;;D5221^^immediate maxillary partial denture - resin base (including retentive/clasping materials, rests and teeth)
 ;;Includes limited follow-up care only; does not include future rebasing/relining procedure(s).
 ;;D5222^^immediate mandibular partial denture - resin base (including retentive/clasping materials, rests and teeth)
 ;;Includes limited follow-up care only; does not include future rebasing/relining procedure(s).
 ;;D5223^^immediate maxillary partial denture - cast metal framework with resin denture bases (including retentive/clasping materials, rests and teeth)
 ;;Includes limited follow-up care only; does not include future rebasing/relining procedure(s).
 ;;D5224^^immediate mandibular partial denture - cast metal framework with resin denture bases (including retentive/clasping materials, rests and teeth)
 ;;Includes limited follow-up care only; does not include future rebasing/relining procedure(s).
 ;;D6066^^implant supported crown - porcelain fused to high noble alloys
 ;;A single metal-ceramic crown restoration that is retained, supported and stabilized by an implant.
 ;;D6067^^implant supported crown - high noble alloys
 ;;A single metal crown restoration that is retained, supported and stabilized by an implant.
 ;;D6076^^implant supported retainer for FPD - porcelain fused to high noble alloys
 ;;A metal-ceramic retainer for a fixed partial denture that gains retention, support and stability from an implant.
 ;;D6077^^implant supported retainer for metal FPD - high noble alloys
 ;;A metal retainer for a fixed partial denture that gains retention, support and stability from an implant.
 ;;D6094^^abutment supported crown - titanium and titanium alloys
 ;;A single crown restoration that is retained, supported and stabilized by an abutment on an implant.
 ;;D6194^^abutment supported retainer crown for FPD - titanium and titanium alloys
 ;;A retainer for a fixed partial denture that gains retention, support and stability from an abutment on an implant.
 ;;D6214^^pontic - titanium and titanium alloys
 ;;D6794^^retainer crown - titanium and titanium alloys
 ;;***END***
