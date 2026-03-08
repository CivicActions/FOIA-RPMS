BADEHL8 ;IHS/OIT/GAB - Dentrix HL7 inbound interface  ;08/15/2020
 ;;1.0;DENTAL/EDR INTERFACE;**7,10**;FEB 22, 2010;Build 61
 ; Process Inbound T04 Segments to create TIU Notes in RPMS
 ; Written in conjunction with BADEHL5 for Processing Inbound Dentrix MDM-T04 Message Types
 ; /IHS/GDIT/GAB **10** Update field 1301 - Date of Note to TXARES(6)
 ; 
 ;TXARES(3) : Activity Date/Time - date of visit/procedure (TXA.4)
 ;TXARES(5) : Status (should be completed "LA")
 ;TXARES(6) : Note Origination Date/Time  (TXA.6)
 ;TXARES(7) : Note Finalization Date/Time
 ;TXARES(8) : Author IEN
 ;TXARES(11): Signature Date/Time     (TXA.8)
 ;TXARES(12): Signed By /Signer
 ;TXARES(13): Signature Block Name
 ;TXARES(14): Signature Block Title for the Signer of the Note
 ;
TITLE(TITLENM) ;EP:  GET NOTE TITLE FROM DOCUMENT TYPE
 N I,UPPER,LOWER,DCTIEN,TITLENM2
 S Y=""
 I $G(TITLENM)="" Q "-1^No document title defined"
 S TITLENM2=$$UPPER^TIULS(TITLENM)
 S I=0 F  S I=$O(^TIU(8925.1,"B",TITLENM2,I)) Q:'I  D
 . I $D(^TIU(8925.1,"AT","DOC",I)) S Y=I_U_TITLENM
 I Y="" S I=0 F  S I=$O(^TIU(8925.1,"D",TITLENM,I)) Q:'I  D
 . I $D(^TIU(8925.1,"AT","DOC",I)) S Y=I_U_TITLENM
 S:Y="" Y="-1^Note title does not exist"
 Q Y
STUFREC(TIUDA,TIUREC,DFN,PARENT,TITLE,TIU) ; load TIUREC for create
 N TIUREQCS,TIUSCAT,TIUSTAT,TIUCPF,TIUST
 S TIUST=$G(TXARES(5))
 S TIUSTAT="",TIUSTAT=$O(^TIU(8925.6,"B",TIUST,TIUSTAT))
 I +$G(PARENT)'>0 D
 . S TIUREC(.02)=$G(DFN),TIUREC(.03)=$P($G(TIU("VISIT")),U)
 . S TIUREC(.05)=$S(+$G(TIUSTAT):TIUSTAT,1:5)
 . S TIUREC(.07)=$G(TXARES(3))           ;activity date/time
 . S TIUREC(.08)=$P($G(TIU("LDT")),U)
 . S TIUREC(1402)=$P($G(TIU("TS")),U)
 . S TIUREC(1404)=$P($G(TIU("SVC")),U)
 I +$G(PARENT)>0 D
 . S TIUREC(.02)=+$P($G(^TIU(8925,+PARENT,0)),U,2)
 . S TIUREC(.03)=+$P($G(^TIU(8925,+PARENT,0)),U,3)
 . S TIUREC(.05)=$S(+$G(TIUREC(.05)):+$G(TIUREC(.05)),+TIUSTAT:TIUSTAT,1:5)
 . S TIUREC(.06)=PARENT,TIUREC(.07)=$G(TXARES(3))
 . S TIUREC(.08)=$P(TIU("LDT"),U)
 . S TIUREC(1402)=$P($G(^TIU(8925,+PARENT,14)),U,2)
 . S TIUREC(1404)=$P($G(^TIU(8925,+PARENT,14)),U,4)
 S TIUREC(.04)=$$DOCCLASS^TIULC1(TITLE)
 S TIUSCAT=$S(+$L($P($G(TIU("CAT")),U)):$P($G(TIU("CAT")),U),+$L($P($G(TIU("VSTR")),";",3)):$P($G(TIU("VSTR")),";",3),1:"")
 S TIUREC(.13)=TIUSCAT
 S TIUREC(1202)=PROVID
 S TIUREC(1204)=SIGNID
 S TIUREC(1205)=$P($G(TIU("LOC")),U)
 S TIUREC(1211)=$P($G(TIU("VLOC")),U)
 S TIUREC(1201)=$G(TXARES(6))
 ;S TIUREC(1301)=$S($G(TXARES(7))]"":$G(TXARES(7)),1:$$NOW^XLFDT)  ;/IHS/GDIT/GAB **10** Update to TXA.6 field; added next line to use TXARES(6)
 S TIUREC(1301)=$G(TXARES(6))
 S TIUREC(1303)="U"
 I $G(TXARES(11))'="" D
 .S TIUREC(1501)=$G(TXARES(11))
 .S TIUREC(1502)=$G(TXARES(12))
 .S TIUREC(1503)=$G(TXARES(13))
 .S TIUREC(1504)=$G(TXARES(14))
 .S TIUREC(1505)=$G(TXARES(15))
 I $G(ZCSRES(1))'="" D
 .S TIUREC(1208)=$G(ZCSRES(1))
 .S TIUREC(1507)=$G(ZCSRES(2))
 .S TIUREC(1508)=$G(ZCSRES(3))
 .;S TIUREC(1509)=$G(ZCSRES(4))
 .S TIUREC(1510)=$G(ZCSRES(5))
 .S TIUREC(1511)=$G(ZCSRES(6))
 I $S(+$G(TIUREC(1208)):1,+$G(TIUREQCS):1,1:0) S TIUREC(1506)=0
 I $G(ZDELRES(1))'="" D
 .S TIUREC(1611)=$G(ZDELRES(1))
 .S TIUREC(1610)=$G(ZDELRES(2))
 .S TIUREC(1612)=$G(ZDELRES(3))
 Q
