BQICAXRF ;GDIT/HS/ALA-VSAC OID Cross-References ; 19 Mar 2024  12:54 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**7**;Mar 01, 2021;Build 14
 ;;
 ;
SKL ;EP - Subset Kill
 K ^BQI(90507.8,"SOID",X,DA(2),DA(1),DA)
 Q
 ;
SST ; EP - Subset Set
 S ^BQI(90507.8,"SOID",X,DA(2),DA(1),DA)=""
 Q
 ;
RKL ; EP - Rxnorm kill
 K ^BQI(90507.8,"MOID",X,DA(2),DA(1),DA)
 Q
 ;
RST ; EP -Rxnorm set
 S ^BQI(90507.8,"MOID",X,DA(2),DA(1),DA)=""
 Q
 ;
TKL ; EP - Taxonomy kill
 K ^BQI(90507.8,"TOID",X,DA(2),DA(1),DA)
 Q
 ;
TST ; EP - Taxonomy set
 S ^BQI(90507.8,"TOID",X,DA(2),DA(1),DA)=""
 Q
 ;
LKL ; EP - LOINC kill
 K ^BQI(90507.8,"LOID",X,DA(2),DA(1),DA)
 Q
 ;
LST ; EP - LOINC Set
 S ^BQI(90507.8,"LOID",X,DA(2),DA(1),DA)=""
 Q
