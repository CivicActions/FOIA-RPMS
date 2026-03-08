BIVVPRE ;IHS/CMI/MWR - PRE-INIT ROUTINE; MAR 01, 2021 ; 20 Mar 2025  3:02 PM
 ;;8.5;IMMUNIZATION;**1028**;OCT 24, 2011;Build 84
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PRE-INIT TO REMOVE PREVIOUS ^DD's, RPC's, Forms, List Templates,
 ;
 ;-----------
MAIN ;EP
 ;---> Pre-init program.
 ;
 D SETVARS^BIUTL5 S BIPOP=0
 ;S BIPTITL="v"_$$VER^BILOGO_" PRE-INIT PROGRAM"
 ;
 ;---> Delete all old IZ TABLE VIS BARCODES entries.
 ;D ZGBL^BIUTL8("^BYIMVIS")
 ;
 ;---> Delete all previous entries in IZ TABLE VIS BARCODES File.
 ;---> Per Tom Love.
 D ZGBL^BIUTL8("^BYIMVIS")
 ;
1025 ;IHS/CMI/LAB - patch 1025
 ;set filenumber to null to try to clean up the mess
 ;S $P(^BITT(0),U,2)=""
 ;S $P(^BITO(0),U,2)=""
 ;
 ;
 Q
