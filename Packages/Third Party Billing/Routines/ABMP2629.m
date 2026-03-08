ABMP2629 ; IHS/SD/SDR - 3P BILLING 2.6 Patch 29 POST INSTALL ;  
 ;;2.6;IHS Third Party Billing;**29**;NOV 12, 2009;Build 562
 ;
 ;IHS/SD/SDR 2.6*29 CR10860 Correct fee table entries that end with 'F'; they were being stored like a string (i.e., "14.70")
 ;  with a trailing zero, causing the LSFE to have a programing error as well as <UNDEF>ONE+47^ABMFEAPI in the claim generator.
 ;
POST ;EP
 D BMES^XPDUTL("Fixing HCPCS section of Fee Tables containing Category III codes...")
 S ABMFT=0
 F  S ABMFT=$O(^ABMDFEE(ABMFT))  Q:'ABMFT  D
 .S ABMCIEN=""
 .F  S ABMCIEN=$O(^ABMDFEE(ABMFT,13,ABMCIEN)) Q:ABMCIEN=""  D
 ..I $D(^ABMDFEE(ABMFT,13,ABMCIEN,0))=0 Q  ;skip if there's no data at zero node; it's a subfile header
 ..I +ABMCIEN=0 Q  ;skip if it's an alpha char (x-ref entry)
 ..I ABMCIEN=+ABMCIEN Q  ;skip if it's numeric already (valid entry)
 ..D MES^XPDUTL("Correcting FT# "_ABMFT_" CPT "_$P($G(^ICPT($P($G(^ABMDFEE(ABMFT,13,ABMCIEN,0)),U),0)),U)_" ("_ABMCIEN_")")
 ..M ^ABMDFEE(ABMFT,13,+ABMCIEN)=^ABMDFEE(ABMFT,13,ABMCIEN)  ;correct entry
 ..;remove bad entry
 ..K ^ABMDFEE(ABMFT,13,"B",$P(^ABMDFEE(ABMFT,13,ABMCIEN,0),U),ABMCIEN)
 ..K ^ABMDFEE(ABMFT,13,"C",ABMCIEN)
 ..K ^ABMDFEE(ABMFT,13,ABMCIEN)
 ..;re-index corrected entry
 ..S DA(1)=ABMFT
 ..S DA=+ABMCIEN
 ..S DIK="^ABMDFEE("_DA(1)_",13,"
 ..D IX^DIK
 Q
