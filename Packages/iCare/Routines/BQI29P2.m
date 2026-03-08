BQI29P2 ;GDIT/HCSD/ALA-iCare Version 2.9 Patch 2 ; 05 Nov 2021  12:04 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**2**;Mar 01, 2021;Build 13
 ;
PRE ;
 Q
 ;
POS ;EP - Post-install
 D ^BQIETX
 D ^BQIUSRC
 D ^BQIULAY
 D LTAX^BQITAXXU
 ;
 ;inactivate three codes and update patients
 S $P(^BQI(90505.3,550,0),"^",3)=1
 S $P(^BQI(90505.3,551,0),"^",3)=1
 S $P(^BQI(90505.3,536,0),"^",3)=1
 ;
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,NOW
 S NOW=$$NOW^XLFDT(),ZTDTH=DT_".19"
 I $$FMDIFF^XLFDT(ZTDTH,NOW,2)<60 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,5)
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 S ZTDESC="Fix Immunocompromised",ZTRTN="IMMU^BQI29P2",ZTIO=""
 D ^%ZTLOAD
 Q
 ;
IMMU ;
 ; Immunocompromised Conditions
 D IMCO^BQINIGH4
 Q
