BDWMSH ; cmi/anchorage/maw - BHL IHS MSH Supplement ;
 ;;1.0;IHS DATA WAREHOUSE;**11**;JAN 24, 2006;Build 14
 ;
 ;this routine will supplement data in the MSH segment
 ;Copied from BHLMSH
 ;
EN ;-- entry point
 D NOW^%DTC
 S INA("EVDT")=%
 S INA("ENC")=CS_RS_SCS_ESC
 S INA("MT")=$P($G(^INTHL7M(BHLMIEN,0)),U,6)
 S INA("ET")=$P($G(^INTHL7M(BHLMIEN,0)),U,2)
 S INA("MET")=INA("MT")_CS_INA("ET")
 S INA("ACA")=$P($G(^INTHL7M(BHLMIEN,0)),U,10)
 S INA("APA")=$P($G(^INTHL7M(BHLMIEN,0)),U,11)
 S INA("VER")=$P($G(^INTHL7M(BHLMIEN,0)),U,4)
 S INA("PRID")=$P($G(^INTHL7M(BHLMIEN,0)),U,3)
 I '$$PROD^XUPROD() S INA("PRID")="T"  ;IHS/CMI/LAB bdw patch 11
 I $$PROD^XUPROD() S INA("PRID")="P"   ;IHS/CMI/LAB bdw patch 11
 S INA("SAP")=$P($G(^INTHL7M(BHLMIEN,7)),U)
 S INA("SF")=$S($G(INA("SF"))]"":INA("SF"),1:$P($G(^INTHL7M(BHLMIEN,7)),U,2))  ;maw 3/3/2006 p14
 S INA("RAP")=$P($G(^INTHL7M(BHLMIEN,7)),U,3)
 S INA("RF")=$P($G(^INTHL7M(BHLMIEN,7)),U,4)
 Q
