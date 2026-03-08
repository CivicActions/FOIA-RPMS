BEHOEPS1 ; IHS/MSC/PLS - EPCS 2FA Utilities;02-Aug-2023 14:14;PLS
 ;;1.1;BEH COMPONENTS;**071001,071004**;Mar 20, 2007;Build 10
 ; Returns a string of data for patient, provider and order
 ; which will be used to generate a digital signature.
INFOFDS(DFN,ORNP,ORIFN) ;EP-
 N OHD,ORDINFO,LP,CNT,STR,LST
 D HASHINFO^ORDEA(.OHD,DFN,ORNP)
 D ORDHINFO^ORDEA(.ORDINFO,+ORIFN)
 S LP=0
 F  S LP=$O(OHD(LP)) Q:'LP  D ADD^BEHOEPS(OHD(LP))
 S LP=0
 F  S LP=$O(ORDINFO(LP)) Q:'LP  D ADD^BEHOEPS(ORDINFO(LP))
 ;
 S LP=0
 F  S LP=$O(LST(LP)) Q:'LP  S STR=$G(STR)_LST(LP)_"!"
 Q +ORIFN_"!"_STR
 ;
 ; Regenerate pending order hash value in APSP DEA ARCHIVE INFO File
REGENHSH ;
 N LP,P0,HASH,ADEA
 S LP=0
 F  S LP=$O(^PS(52.41,LP)) Q:'LP  D
 .S P0=$G(^PS(52.41,LP,0))
 .Q:'$P(P0,U,24)  ; Not a digitally signed order
 .Q:"^NW^HD^RNW^RF^"'[(U_$P(P0,U,3)_U)  ; Exclude DC and DE order types
 .Q:$$RXVER^BEHOEPS(LP)  ;Current Hash value is correct
 .S HASH=$$GPSOHASH^BEHOEPS($P(P0,U,2),$P(P0,U,5),$P(P0,U),LP)
 .S ADEA=$$GETADEA($P(P0,U))  ;Get IEN for APSP DEA ARCHIVE INFO File
 .Q:'ADEA
 .S $P(^APSPDEA(ADEA,0),U,2)=HASH  ;Store HASH
 Q
 ;
 ;Input - PORDER = Order File IEN
GETADEA(PORDER) ;-
 N RES
 S RES=$O(^APSPDEA("B",PORDER,0))
 Q $S(RES>0:RES,1:0)
