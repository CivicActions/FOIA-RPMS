BEHOEPS ; IHS/MSC/PLS - EPCS 2FA Utilities;09-Nov-2022 09:49;PLS
 ;;1.1;BEH COMPONENTS;**071001,071002,071004**;Mar 20, 2007;Build 10
EN(ACTION,DFN,ORNP,ORIFN,OETID) ;EP
 Q  ;NOT CURRENTLY USED
 ;
EN1(POIEN) ;EP
 N DRGIEN,OROUT,OHD,PS0,RXHASH,HASH,ORIFN,ADEAIEN,IENS,RXFDA,DSIGARY,LP
 N LST,PROV,STR,ERROR,Y1,PORDER
 S IENS="?+1,"
 S PS0=$G(^PS(52.41,POIEN,0))
 S PROV=$P(PS0,U,5)
 S PORDER=$P(PS0,U,1)
 D HASHINFO^ORDEA(.OHD,$P(PS0,U,2),PROV)
 S OHD(3)="IssuanceDate:"_$$FMTE^XLFDT($P($P(PS0,U,6),"."))
 S OHD(4)="IssuanceInt:"_$P($P(PS0,U,6),".")
 D POINFO(POIEN,.OROUT)
 S LP=0
 F  S LP=$O(OHD(LP)) Q:'LP  D ADD(OHD(LP))
 S LP=0
 F  S LP=$O(OROUT(LP)) Q:'LP  D ADD(OROUT(LP))
 ;
 S LP=0
 F  S LP=$O(LST(LP)) Q:'LP  S STR=$G(STR)_LST(LP)_"!"
 S STR=PORDER_"!"_STR_"!"_$$GET1^DIQ(52.41,POIEN,117,"I")
 S HASH=$$GPSOHASH($P(PS0,U,2),PROV,PORDER,POIEN)
 S ORIFN=$$GET1^DIQ(52.41,POIEN,.01)
 D STORADEA(HASH,ORIFN,.OHD,POIEN,.ADEAIEN)
 S RXFDA(9009036.1,ADEAIEN_",",1)=HASH
 D UPDATE^DIE("","RXFDA","","ERROR")
 D:ADEAIEN GENSPHSH(ADEAIEN)  ;Generate security hash
 Q
 ;
ADD(STR) ;EP-
 S CNT=$G(CNT)+1
 S LST(CNT)=STR
 Q
 ;Update the Digital Signature field of the order
SODSIG(ORIFN,OETID,DIGSIG) ;EP-
 S $P(^OR(100,+ORIFN,8,+OETID,2),U,3)=DIGSIG
 Q
 ; Returns boolean flag representing untampered record
 ; Generated hash equals stored hash
 ; Input: POIEN - IEN to Pending Order File (52.41)
 ; Output: 0 - Hash doesn't match
 ;         1 - Hash matched
RXVER(POIEN) ;Verify Pending Order
 N DRGIEN,OROUT,OHD,PS0,RXHASH,HASH,ORIFN,ADEAIEN,LST,LP,STR,RET
 S ORIFN=$$GET1^DIQ(52.41,POIEN,.01)
 S ADEAIEN=$O(^APSPDEA("B",ORIFN,0))
 Q:'ADEAIEN "0^0^Failed digital signature comparison"
 S PS0=$G(^PS(52.41,POIEN,0))
 S OHD(1)="PatientNumber:"_$P(PS0,U,2)
 S OHD(2)="ProviderNumber:"_$P(PS0,U,5)
 S OHD(3)="IssuanceDate:"_$$FMTE^XLFDT($P($P(PS0,U,6),"."))
 S OHD(4)="IssuanceInt:"_$P($P(PS0,U,6),".")
 D POINFO(POIEN,.OROUT)
 S LP=0
 F  S LP=$O(OHD(LP)) Q:'LP  D ADD(OHD(LP))
 S LP=0
 F  S LP=$O(OROUT(LP)) Q:'LP  D ADD(OROUT(LP))
 ;
 S LP=0
 F  S LP=$O(LST(LP)) Q:'LP  S STR=$G(STR)_LST(LP)_"!"
 S STR=ORIFN_"!"_STR_"!"_$$GET1^DIQ(52.41,POIEN,117,"I")
 S HASH=$$GENHASH(STR)
 ;
 K ^TMP($J,"ORDEA")
 S RET=HASH=$$GET1^DIQ(9009036.1,ADEAIEN,1)
 Q $S(RET:1,1:"0^0^Failed digital hash comparison")
 ;Return Dosage information from Pending Order file in same format as ORDHINFO^ORDEA
PODOSE(POIEN) ;EP-
 N LP,P0,P1,A,RET
 S RET=""  ;p29
 S LP=0
 F  S LP=$O(^PS(52.41,POIEN,1,LP)) Q:'LP  D
 .S P0=^PS(52.41,POIEN,1,LP,0)
 .S P1=^PS(52.41,POIEN,1,LP,1)
 .S A=P0_"|"_$P(P1,U,1)_"|"_$P(P1,U,2)_"|"_$P(P1,U,6)_"|"_$P(P1,U,8)
 .I '$D(RET) S RET="Directions:"_A
 .E  S RET=RET_"~"_A
 Q RET
 ;Return drug information from Pending Order File for hash
 ;Input: Pending Order File IEN
 ;Ouput: ARRAY containing info to hash
POINFO(POIEN,OROUT) ;EP-
 S PS0=$G(^PS(52.41,POIEN,0))
 S DRGIEN=$P(PS0,U,9)
 D DATA^PSS50(DRGIEN,"","","","","ORDEA")
 S OROUT(1)="DrugName:"_^TMP($J,"ORDEA",DRGIEN,.01)
 S OROUT(2)="Quantity:"_$P(PS0,U,10)
 S OROUT(3)=$$PODOSE(POIEN)
 Q
GPSOHASH(PAT,PRV,ORIFN,POIEN) ;EP-
 N STR,X,OHD,OROUT,LP,LST,PS0
 S PS0=$G(^PS(52.41,POIEN,0))
 S OHD(1)="PatientNumber:"_PAT
 S OHD(2)="ProviderNumber:"_PRV
 S OHD(3)="IssuanceDate:"_$$FMTE^XLFDT($P($P(PS0,U,6),"."))
 S OHD(4)="IssuanceInt:"_$P($P(PS0,U,6),".")
 D POINFO(POIEN,.OROUT)
 S LP=0
 F  S LP=$O(OHD(LP)) Q:'LP  D ADD(OHD(LP))
 S LP=0
 F  S LP=$O(OROUT(LP)) Q:'LP  D ADD(OROUT(LP))
 ;
 S LP=0
 F  S LP=$O(LST(LP)) Q:'LP  S STR=$G(STR)_LST(LP)_"!"
 S STR=ORIFN_"!"_STR_"!"_$$GET1^DIQ(52.41,POIEN,117,"I")
 S X=$$GENHASH(STR)
 Q X
GENHASH(STR) ;EP-
 N X
 X "S X=##class(%SYSTEM.Encryption).SHAHash(256,STR)"
 X "S X=$System.Encryption.Base64Encode(X)"
 Q X
 ;
BRKDSIG(STR,ARY) ;EP-Wrap string into an array
 K ARY
 N TMP,LP
 S TMP(0)=STR
 D WRAP^DIKCU2(.TMP,100)
 S LP="" F  S LP=$O(TMP(LP)) Q:LP=""  S ARY(LP+1)=TMP(LP)
 Q
STORADEA(HASH,ORIFN,OHD,POIEN,ADIEN) ;EP-
 N IENS,RXFDA,A,ORINST,DFN,VADM,PS0,DRGIEN,ORDEA,ERROR,IENARY,PORDER
 N SHSH,I
 S ADIEN=0
 S PS0=$G(^PS(52.41,POIEN,0))
 S DRGIEN=$P(PS0,U,9)
 S PORDER=$P(PS0,U,1)
 S IENS="?+1,"
 F I=1:1 Q:'$D(OHD(I))  D
 .I $G(OHD(I))["IssuanceInt" D  Q
 ..S RXFDA(9009036.1,IENS,4)=$P(OHD(I),":",2,99)
 .I $G(OHD(I))["ProviderNumber" D  Q
 ..S RXFDA(9009036.1,IENS,31)=$P(OHD(I),":",2,99)
 .I $G(OHD(I))["ProviderName" D  Q
 ..S RXFDA(9009036.1,IENS,12)=$P(OHD(I),":",2,99)
 .I $G(OHD(I))["DeaNumber" D  Q
 ..S RXFDA(9009036.1,IENS,10)=$P(OHD(I),":",2,99)
 .I $G(OHD(I))["DetoxNumber" D  Q
 ..S RXFDA(9009036.1,IENS,11)=$P(OHD(I),":",2,99)
 .I $G(OHD(I))["ProviderAdd1" D  Q
 ..S RXFDA(9009036.1,IENS,13)=$P(OHD(I),":",2,99)
 .I $G(OHD(I))["ProviderAddress" D  Q
 ..S A=$P(OHD(I),":",2,99)
 ..S RXFDA(9009036.1,IENS,14)=$P(A,U)
 ..S RXFDA(9009036.1,IENS,15)=$P(A,U,2)
 ..S RXFDA(9009036.1,IENS,16)=$P(A,U,3)
 ..S RXFDA(9009036.1,IENS,17)=$P(A,U,4)
 ..S RXFDA(9009036.1,IENS,17.5)=$P(A,U,5)
 .I $G(OHD(I))["PatientAddress" D  Q
 ..S A=$P(OHD(I),":",2,99)
 ..S RXFDA(9009036.1,IENS,21)=$P(A,U)
 ..S RXFDA(9009036.1,IENS,22)=$P(A,U,2)
 ..S RXFDA(9009036.1,IENS,24)=$P(A,U,3)
 ..S RXFDA(9009036.1,IENS,25)=$P(A,U,4)
 ..S RXFDA(9009036.1,IENS,26)=$P(A,U,6)
 ..S RXFDA(9009036.1,IENS,27)=$P(A,U,7)
 D DATA^PSS50(DRGIEN,"","","","","ORDEA")
 S RXFDA(9009036.1,IENS,6)=^TMP($J,"ORDEA",DRGIEN,.01)
 S RXFDA(9009036.1,IENS,29)=DRGIEN
 S RXFDA(9009036.1,IENS,30)=^TMP($J,"ORDEA",DRGIEN,3)
 D POINFO(POIEN,.OROUT)
 S RXFDA(9009036.1,IENS,8)=$P(PS0,U,10)
 S RXFDA(9009036.1,IENS,28)=$P(PS0,U,11)
 S RXFDA(9009036.1,IENS,32)=$$GET1^DIQ(52.41,POIEN,117,"I")
 D
 .N LP,P0,P1,A
 .S LP=0
 .F  S LP=$O(^PS(52.41,POIEN,1,LP)) Q:'LP  D
 ..S P0=^PS(52.41,POIEN,1,LP,0)
 ..S P1=^PS(52.41,POIEN,1,LP,1)
 ..S A=P0_"|"_$P(P1,U,1)_"|"_$P(P1,U,2)_"|"_$P(P1,U,6)_"|"_$P(P1,U,8)
 ..S RXFDA(9009036.19,"+"_(LP+1)_","_IENS,.01)=A
 S DFN=$P(PS0,U,2)
 D DEM^VADPT
 S RXFDA(9009036.1,IENS,18)=VADM(1)
 S RXFDA(9009036.1,IENS,19)=DFN
 S RXFDA(9009036.1,IENS,.01)=ORIFN
 S RXFDA(9009036.1,IENS,99)=$$NOW^XLFDT
 D UPDATE^DIE("","RXFDA","IENARY","ERROR")
 ;IHS/MSC/MGH add audit data
 I '$D(ERROR) D
 .S ADIEN=IENARY(1)
 .D EDIT^APSPCSA(PORDER,"AP")
 E  D EDIT^APSPCSA(PORDER,"AZ")
 K ^TMP($J,"ORDEA")
 Q
 ;
 ;Fires Digital Signature Failed Notification
 ;Uses OE/RR Notification #76
 ;Input: PAT: IEN of Patient
 ;     ORIFN: IEN of Order
 ;       PRV: IEN of Signing User
 ;       MSG: Message Text to display to user
SENDNOTF(PAT,ORIFN,PRV,MSG) ;EP -
 N XQA,XQAID,XQADATA,XQAMSG,PNAM
 S XQA(PRV)=""
 S PNAM=$E($$GET1^DIQ(2,PRV,.01)_"         ",1,9)
 S XQAMSG=PNAM_" "_"("_$$HRN^BEHOPTCX(PRV)_"):"
 S XQAMSG=XQAMSG_$TR($G(MSG),U,"|")
 S XQAID="OR"_","_PAT_","_99007
 S XQADATA=ORIFN_"@"
 S XQATEXT(1,0)="The process of creating a digital signature for order number "_ORIFN
 S XQATEXT(2,0)="failed. A signed prescription order will need to be routed to the"
 S XQATEXT(3,0)="Pharmacy for processing. Please use the Print feature of the "
 S XQATEXT(4,0)="medication component to complete this process."
 D SETUP^XQALERT
 Q
 ;Generates a security hash of a record in the ORDER DEA ARCHIVE INFO file
 ;and stores the hash in field 9999999.03 if field is empty.
GENSOHSH(ORIFN) ;EP-
 Q:'ORIFN
 N X,GBLROOT,STR,QFLG,FDA,FHSH,IEN
 S IEN=$O(^ORPA(101.52,"B",ORIFN,$C(1)),-1)
 Q:'IEN
 S GBLROOT="^ORPA(101.52,"_IEN
 S STR="",FHSH=""
 S X=GBLROOT_")"
 F  S X=$Q(@X) Q:X'[GBLROOT  D  Q:$G(QFLG)
 .I X=(GBLROOT_",0)") S FHSH=$P(@X,U,3),STR=$$ADDSTR($P(@X,U)_FHSH)
 .E  I X=(GBLROOT_",6)") S STR=$$ADDSTR(@X) S QFLG=1
 .E  S STR=$$ADDSTR(@X)
 I '$L($P($G(^ORPA(101.52,IEN,9999999)),U,3)) D
 .S FDA(101.52,IEN_",",9999999.03)=$$GENHASH(STR_$$DSIGTSTR(FHSH))
 .D STRSHSH(.FDA)
 Q
 ;
 ;Generates a security hash of a record in the APSP DEA ARCHIVE file
 ;and stores the hash in field 101 if field is empty.
GENSPHSH(IEN) ;EP-
 Q:'IEN
 N X,GBLROOT,STR,QFLG,FDA,FHSH
 S GBLROOT="^APSPDEA("_IEN
 S STR="",FHSH=""
 S X=GBLROOT_")"
 F  S X=$Q(@X) Q:X'[GBLROOT  D  Q:$G(QFLG)
 .I X=(GBLROOT_",0)") S FHSH=$P(@X,U,2),STR=$$ADDSTR(@X)
 .E  I X=(GBLROOT_",6)") S STR=$$ADDSTR(@X) S QFLG=1
 .E  S STR=$$ADDSTR(@X)
 I '$L($P($G(^APSPDEA(IEN,8)),U,3)) D
 .S FDA(9009036.1,IEN_",",101)=$$GENHASH(STR_$$DSIGTSTR(FHSH))
 .D STRSHSH(.FDA)
 Q
 ;
ADDSTR(X) ;EP-
 Q $S($L(STR):STR_U_X,1:X)
 ;
STRSHSH(FDA) ;EP-
 N ERR
 D UPDATE^DIE("","FDA","","ERR")
 Q
DSIGTSTR(HSH) ;EP-
 N PKI,LP,STR,SIEN
 I $G(HSH)="" Q ""
 ;S PKI=$$FIND1^DIC(8980.2,,"X",HSH)  ;P071004
 S (PKI,SIEN)="" F  S SIEN=$O(^XUSSPKI(8980.2,"B",$E(HSH,1,30),SIEN)) Q:SIEN=""  D  Q:PKI'=""
 .I $P($G(^XUSSPKI(8980.2,SIEN,0)),U)=HSH S PKI=SIEN
 Q:'PKI ""
 S LP=0
 F  S LP=$O(^XUSSPKI(8980.2,PKI,1,LP)) Q:'LP  S STR=$G(STR)_^(LP,0)
 Q $G(STR)
 ;Returns Boolean flag indicating presence of pharmacy signing key in 90460.11
 ; Input: INST = Pointer to File 4
 ;Output: 0-Not Present 1-Present
ISPHMKEY(INST) ;EP-
 N IEN
 Q:'$G(INST) 0
 S IEN=$O(^BEHOEP(90460.11,"B",INST,0))
 Q:'IEN 0
 Q $L($$GET1^DIQ(90460.11,IEN,.08))>0
 ;
 ;Set hard-copy CS orders into the order dea archive file
HARD(ORIFN,SIGNER) ;EP
 N ORY,PT,OHD,ORDFDA,OUT,ERROR,IENS
 S ORY=0
 Q:'+ORIFN
 D CSVALUE^ORDEA(.ORY,+ORIFN)
 I ORY=1 D
 .Q:$D(^ORPA(101.52,"B",+ORIFN))
 .S PT=+$P($G(^OR(100,+ORIFN,0)),"^",2)
 .D HASHINFO^ORDEA(.OHD,PT,SIGNER)
 .D BUILDFDA^ORDEA(+ORIFN,.ORDFDA,.OUT,"",.OHD)
 .S ORDFDA(101.52,IENS,1)=$G(^OR(100,+ORIFN,4))
 .S ORDFDA(101.52,IENS,9999999.01)=$$NOW^XLFDT
 .D UPDATE^DIE("","ORDFDA","","ERROR")
 .D GENSOHSH(+ORIFN)
 Q
 ; Returns a string of data for patient, provider and order
 ; which will be used to generate a digital signature.
INFOFDS(DFN,ORNP,ORIFN) ;EP-
 N OHD,ORDINFO,LP,CNT,STR,LST
 D HASHINFO^ORDEA(.OHD,DFN,ORNP)
 D ORDHINFO^ORDEA(.ORDINFO,+ORIFN)
 S LP=0
 F  S LP=$O(OHD(LP)) Q:'LP  D ADD(OHD(LP))
 S LP=0
 F  S LP=$O(ORDINFO(LP)) Q:'LP  D ADD(ORDINFO(LP))
 ;
 S LP=0
 F  S LP=$O(LST(LP)) Q:'LP  S STR=$G(STR)_LST(LP)_"!"
 Q +ORIFN_"!"_STR
 ;
 ;RPC to return data for Digital Signature creation
GORDIDIG(DATA,DFN,ORNP,ORIFN) ;EP-
 S DATA=$$INFOFDS(DFN,ORNP,ORIFN)
 Q
 ;Store the digital signature in 101.52 and public cert in 8980.2
 ;Input: PAT - Patient IEN
 ;       PRV - Provider IEN
 ;       ORD - Order IEN
 ;     INPUT - DigSig^Hash
STORDSIG(DATA,PAT,PRV,ORD,INPUT) ;EP-
 ;Call SIG^ORWOR1
 N DIGSIG,HASH,CERT,ID,DSIGARY,PKIEN,FDA,ERR,AIEN,HASHB,SERIAL,ODA
 ;Put the digital signature into an array
 S DIGSIG=$P(INPUT,U,1)
 D BRKDSIG(DIGSIG,.DSIGARY)
 S HASH=$P(INPUT,U,2)
 D SIG^ORWOR1(.DATA,ORD,HASH,$L(DIGSIG),100,PRV,.DSIGARY,"",PAT)
 ;Store the data
 I DATA=1 D
 .D GENSOHSH(+ORD)
 .S SERIAL=$P(INPUT,U,3)
 .S CERT=$O(^BEHOEP(90460.12,"B",$E(SERIAL,1,30),""))
 .I +CERT D
 ..S ODA=$O(^ORPA(101.52,"B",+ORD,""))
 ..I +ODA D
 ...N IENS,FDA,ERR
 ...S IENS=ODA_","
 ...S FDA(101.52,IENS,9999999.309)=CERT
 ...D FILE^DIE("","FDA","ERR")
 Q
 ;Generate test string from file entry
GENOASTR() ;EP-
 N OAIEN,STR,OHD,ORD,LP,LST,ORIFN,DEAX
 S OAIEN=$$GETIEN1^BEHORXF3(101.52)
 Q:OAIEN<1 ""
 S ORIFN=$$GVAL(OAIEN,.01)
 S OHD(1)="PatientName:"_$$GVAL(OAIEN,18)
 S OHD(2)="PatientAddress:"_$$GVAL(OAIEN,21)_U_$$GVAL(OAIEN,22)_U_$$GVAL(OAIEN,24)_U_$$GVAL(OAIEN,25)_U_$$FIND1^DIC(5,,,$$GVAL(OAIEN,26))_U_$$GVAL(OAIEN,26)_U_$$GVAL(OAIEN,27)_U
 S OHD(3)="IssuanceDate:"_$$FMTE^XLFDT($$GVAL(OAIEN,4,"I"))
 S OHD(4)="IssuanceInt:"_$$GVAL(OAIEN,4,"I")
 S OHD(5)="ProviderName:"_$$GVAL(OAIEN,12)
 S OHD(6)="ProviderNumber:"_$$GVAL(OAIEN,31,"I")
 S OHD(7)="ProviderAddress:"_$$GVAL(OAIEN,14)_U_$$GVAL(OAIEN,15)_U_$$GVAL(OAIEN,16)_U_$$GVAL(OAIEN,17)_U_$$GVAL(OAIEN,17.5)
 S OHD(8)="ProviderAdd1:"_$$GVAL(OAIEN,13)
 S OHD(9)="DeaNumber:"_$$GVAL(OAIEN,10)
 S DEAX=$$GVAL(OAIEN,11) S:$L(DEAX) OHD(10)="DetoxNumber:"_DEAX
 S ORD(1)="DrugName:"_$$GVAL(OAIEN,6)
 S ORD(2)="Quantity:"_$$GVAL(OAIEN,8)
 S LP=0
 F  S LP=$O(^ORPA(101.52,OAIEN,2,LP)) Q:'LP  D
 .N A
 .S A=^ORPA(101.52,OAIEN,2,LP,0)
 .I '$D(ORD(3)) S ORD(3)="Directions:"_A
 .E  S ORD(3)=ORD(3)_"~"_A
 S LP=0
 F  S LP=$O(OHD(LP)) Q:'LP  D ADD(OHD(LP))
 S LP=0
 F  S LP=$O(ORD(LP)) Q:'LP  D ADD(ORD(LP))
 ;
 S LP=0
 F  S LP=$O(LST(LP)) Q:'LP  S STR=$G(STR)_LST(LP)_"!"
 Q +ORIFN_"!"_STR
 Q STR
 ;Return value from file
GVAL(OAIEN,FLD,FLG) ;EP-
 S FLG=$G(FLG,"E")
 Q $$GET1^DIQ(101.52,OAIEN,FLD,FLG)
