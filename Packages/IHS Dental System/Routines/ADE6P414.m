ADE6P414 ;IHS/GDIT/GAB - ADE V6.0 PATCH 41 [ 12/2024  8:37 AM ]
 ;;6.0;ADE IHS DENTAL;**41**;March 25, 1999;Build 57
 ;IHS/GDIT/GAB Patch 41: ADA-CDT code updates for 2025
 ;Modify fields for One Code (9170)
 ;
MODCDT41 ;EP
 D UPDATE^ADEUTL2(9999999.31,".01,.06,,.02,8801",1101,"?+1,","MODADA^ADE6P414","SETX^ADE6P414")
 Q
 ;
SETX ;EP
 S ADEN=$P($P(ADEX,U),"D",2),$P(ADEX,U)=ADEN,$P(ADEX,U,6)=$TR($P(ADEX,U,6),"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q
 ;
MODADA ; Code^Synonym^^Desc^Mnemonic   /   Recommended Use on next line (field 1101)
 ;;D9170^UrgCareEn^^Urgent Care Encounter^UrCE^
 ;;Urgent Care Encounter (Report without any exam)
 ;;***END***
