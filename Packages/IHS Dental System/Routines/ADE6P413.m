ADE6P413 ;IHS/GDIT/GAB - ADE V6.0 PATCH 41 [ 12/2024  8:37 AM ]
 ;;6.0;ADE IHS DENTAL;**41**;March 25, 1999;Build 57
 ;IHS/GDIT/GAB Patch 41: ADA-CDT code updates for 2025
 ;Addition of Mnemonic fields (8801) for 5 specific codes
 ;
ADDNM41 ;EP
 S ADEOPS="",ADENOD="",MNE="",CODE="",ADEDIK="^AUTTADA("
 F ADEOPS=1:1 S ADENOD=$P($T(MODADA+ADEOPS),";;",2,3) Q:ADENOD="***END***"  S MNE=$P(ADENOD,";;",2),CODE=$P(ADENOD,";;") D WR
 K ADEOPS,ADENOD,MNE,CODE
 Q
 ;
WR ;EP
 S CODE=$P($P(CODE,"^"),"D",2),CODE=$O(^AUTTADA("B",CODE,""))
 I CODE'="" S DA=CODE,DIE=ADEDIK,DR="8801////"_MNE D ^DIE
 Q
 ;
MODADA ;  Code;;Mnemonic
 ;;D2955;;PRMV
 ;;D7250;;RRTR
 ;;D8090;;COrA
 ;;D9210;;LAnT
 ;;D9212;;TNLA
 ;;***END***
