BPDMUTL ;IHS/CMI/LAB - PDM UTILITY; ; 27 Dec 2011  8:46 AM
 ;;2.0;CONTROLLED DRUG EXPORT SYSTEM;**1,2,3,4,5,6,7**;NOV 15, 2011;Build 51
 ;(c) Cimarron Medical Informatics, 2008
 ;
 ;This routine will perform some repetitive utility functions
 ;
 Q
 ;
NAME(X) ;EP - Format Names
 I X="" Q ""
 ;
 S X(1)=$P(X,",")
 I BPDMVER="3.0" S X(1)=$E(X(1),1,15)
 ;
 S X(2)=$P($P(X,",",2)," ")
 I BPDMVER="3.0" S X(2)=$E(X(2),1,12)
 I BPDMVER="1995" S X(2)=$E(X(2),1,15)
 ;
 S X(3)=$P($P(X,",",2)," ",2,99)
 I BPDMVER="3.0" S X(3)=$E(X(3),1,12)
 ;
 S X=X(1)_"^"_X(2)_"^"_X(3)
 ;
 Q X
 ;
 ;
COND(D,T,S) ;EP - is this a drug we want to export.
 I $P(^PSDRUG(D,0),U)["(ORX)" Q 0
 I $P(^PSDRUG(D,0),U,3)[2 Q 1
 I $P(^PSDRUG(D,0),U,3)[3 Q 1
 I $P(^PSDRUG(D,0),U,3)[4 Q 1
 I $$VALI^XBDIQ1(9002315.01,S,.12)=1,$P(^PSDRUG(D,0),U,3)[5 Q 1
 I T,$D(^ATXAX(T,21,"B",D)) Q 1
 Q 0
 ;
SSNAM(Y) ;EP - Format Names to SSN^LAST^FIRST
 ;
 I Y="" Q ""
 S Y(1)=$$GET1^DIQ(200,Y,9)
 S Y=$$GET1^DIQ(200,Y,.01)
 S Y(2)=$$NAME(Y)
 S X=Y(1)_"^"_Y(2)
 K Y(1),Y(2)
 Q X
 ;
GETPHONE(P) ;EP - GET PHONE # PAT17
 NEW Y
 S Y=$$VAL^XBDIQ1(2,DFN,.131)
 I Y?.AP S Y=""
 I Y]"" Q $$PHONE(Y)
 S Y=$$VAL^XBDIQ1(9000001,DFN,1801)
 I Y?.AP S Y=""
 I Y]"" Q $$PHONE(Y)
 Q $$PHONE("0000000000")
 ;
 ;
PHONE(X) ;EP - Format Phone Numbers
 S Y=$P(X,"X")
 ;
 ;strip the extra characters
 S Y=$TR(Y,"-")
 S Y=$TR(Y," ")
 S Y=$TR(Y,")")
 S Y=$TR(Y,"(")
 ;
 ;Strip out any leading non-numeric characters
 F  Q:$E(Y,1)?1N  Q:$L(Y)=0  S Y=$E(Y,2,99)
 ;
 ;Strip out any remaining non-numeric characters
 S I=0 F  S I=I+1 Q:$E(Y,I)=""  Q:$L(Y)=0  I $E(Y,I)'?1N S Y=$E(Y,1,I-1)_$E(Y,I+1,99) S I=I-1
 ;
 ;If null or all alpha characters, then quit
 I $L(Y)=0 Q ""
 ;
 ;If we begin with a 1 then strip it
 I $E(Y,1)=1 S Y=$E(Y,2,99)
 ;
 ;We only want the first 10 digits
 S Y=$E(Y,1,10)
 ;
 Q Y
 ;
 ;If seven digits but no dash, then add the dash and quit
 I $L(Y)=7 S Y=$E(Y,1,3)_"-"_$E(Y,4,7) Q Y
 ;
 I $L(Y)=10 S Y="("_$E(Y,1,3)_")"_$E(Y,4,6)_"-"_$E(Y,7,10) Q Y
 ;
 ;There must be something wrong with the format, so let's capture it
 S ^BHLRXUTL(DT,$H)=Y
 ;
 ;There must be something wrong with the format so return null
 Q ""
 ;
 ;
LZERO(V,L) ;EP - left zero fill
 ;
 ;Left zero fill using the value (V) for a length (L)
 ;
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
 ;
CUSTID(P,T,D) ;
 I T="S" Q $$VAL^XBDIQ1(2,P,.09)
 I T="H" Q $$PAT03(P,D)
 I T="T" Q $$GETPHONE(P)
 Q $$VAL^XBDIQ1(2,P,.09)
 ;
PAT03(P,D) ;EP
 I '$G(P) Q ""
 I '$G(D) Q ""
 NEW F,A,H
 S F=$P($G(^PS(59,D,"INI")),U,1)
 I F="" Q ""
 S A=$P($G(^AUTTLOC(F,0)),U,10)
 I A="" Q ""
 S H=$$HRN^AUPNPAT(P,F)
 I H="" Q ""
 S H=$$LZERO(H,6)
 Q A_H
 ;
PAT12(P)  ;Patient address ... cannot be PO Box
 I '$G(P) Q ""
 S M=$E($$VAL^XBDIQ1(2,DFN,.111),1,30)
 I M="" Q "NOT ON FILE"
 I M["BOX",BPDMPDMP="RH" S M=$E($$VAL^XBDIQ1(2,DFN,.112),1,30)
 I M="" Q "NOT ON FILE"
 Q M
 ;
RXNORMC(N,S,T) ;EP - DSP19 RXNORM CODE FROM NDC CODE
 I N="" Q ""
 I '$$REQ("DSP","DSP19",T) Q ""
 NEW X
 S X=$$RXNORM^APSPFNC1(N,1)
 I X="" Q ""
 Q $P(X,U,1)
 ;
RXNORMQ(N,S,T) ;EP - DSP18 RXNORM QUALIFIERS
 I N="" Q ""
 I '$$REQ("DSP","DSP18",T) Q ""
 NEW X,Q
 S X=$$RXNORM^APSPFNC1(N,1)
 I X="" Q ""
 S Q=$P(X,U,2)
 I Q="" Q ""
 I Q="SCD" Q "01"
 I Q="SBD" Q "02"
 I Q="GPCK" Q "03"
 I Q="BPCK" Q "04"
 Q ""
 ;
DSP07(S,D) ;EP - dsp07
 I '$D(^BPDMSITE(S,12,D,0)) Q "01"
 Q "06"
DSP08(S,D,N) ;EP - DSP08
 I '$D(^BPDMSITE(S,12,D,0)) Q N
 Q "99999999999"
PRE08(P,T)  ;EP - PRE08
 N PH
 I '$$REQ("PRE","PRE08",T) Q ""
 S PH=$$GET1^DIQ(200,P,.132,"I")
 Q $$PHONE(PH)
 ;
ISEN(O) ;EP
 Q $E($$VAL^XBDIQ1(9002315.01,O,.02),1,60)
 ;
USID(O) ;EP - get phone number of pharmacy 10 characters
 Q $TR($$VAL^XBDIQ1(9002315.01,O,.05),"-","")
 ;
IREN(O) ;EP - get information receiver name, e.g. HID, RelayHealth, AAI
 Q $E($$VAL^XBDIQ1(9002315.01,O,1302),1,60)
 ;
URID(O) ;EP - get information receiver id
 Q $$VAL^XBDIQ1(9002315.01,O,1301)
 ;
DATE(D) ;EP - convert date to CCYYMMDD
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
 ;
TIME() ;EP
 N TIME,LEN,I,ZERO,APP
 S TIME=$P($$NOW^XLFDT(),".",2)
 S APP=""
 S LEN=$L(TIME)
 I LEN=4 Q TIME
 I LEN=6 Q TIME
 S ZERO=(6-LEN)
 F I=1:1:ZERO S APP=APP_"0"
 S TIME=TIME_APP
 Q TIME
 ;
PLN(S,T) ;EP - s is site parameter ien, T is state ien
 I '$$REQ("PHA","PHA13",T) Q ""
 Q $$VAL^XBDIQ1(9002315.01,S,1105)
NPI(S,T) ;EP - s is site parameter ien, T is state ien
 I '$$REQ("PHA","PHA01",T) Q ""
 Q $$VAL^XBDIQ1(9002315.01,S,.06)
 ;
NCPDP(S,T) ;EP - s is site parameter ien, T is state ien
 I '$$REQ("PHA","PHA02",T) Q ""
 Q $$VAL^XBDIQ1(9002315.01,S,.07)
 ;
DEAFAC(S,T) ;EP - s is site parameter ien, T is state ien
 I '$$REQ("PHA","PHA03",T) Q ""
 Q $$VAL^XBDIQ1(9002315.01,S,.08)
 ;
REQ(T,I,S) ;EP  T segment ID, I is field ID, S is State ien
 ;ihs/cmi/maw 09132018 patch 4 CR9950
 I $G(BPDMZRO) Q $$REQZ(T,I,S)  ;check zero report
 N VER
 S VER=$P($G(^BPDMSITE(BPDMSITE,0)),U,3)
 I VER=4.2 Q $$REQ42(T,I,S)
 I VER="4.2A" Q $$REQ42A(T,I,S)
 I VER="4.2B" Q $$REQ42B^BPDMUTL1(T,I,S)
 NEW J,K,R
 S J=$O(^BPDMREC("B",T,0))
 I 'J Q ""
 S K=$O(^BPDMREC(J,11,"B",I,0))
 I 'K Q ""
 S R=$P($G(^BPDMREC(J,11,K,12,S,0)),U,2)
 I R="N" Q 0
 I R="RWA" Q 2
 Q 1
 ;----------
REQ42(T,I,S) ;EP  T segment ID, I is field ID, S is State ien
 NEW J,K,R
 S J=$O(^BPDMRECA("B",T,0))
 I 'J Q ""
 S K=$O(^BPDMRECA(J,11,"B",I,0))
 I 'K Q ""
 S R=$P($G(^BPDMRECA(J,11,K,12,S,0)),U,2)
 I R="N" Q 0
 I R="RWA" Q 2
 Q 1
 ;----------
REQ42A(T,I,S) ;EP  T segment ID, I is field ID, S is State ien
 NEW J,K,R
 S J=$O(^BPDMRECB("B",T,0))
 I 'J Q ""
 S K=$O(^BPDMRECB(J,11,"B",I,0))
 I 'K Q ""
 S R=$P($G(^BPDMRECB(J,11,K,12,S,0)),U,2)
 I R="N" Q 0
 I R="RWA" Q 2
 Q 1
 ;
REQZ(T,I,S) ;EP  T segment ID, I is field ID, S is State ien
 NEW J,K,R
 S J=$O(^BPDMZERO("B",T,0))
 I 'J Q ""
 S K=$O(^BPDMZERO(J,11,"B",I,0))
 I 'K Q ""
 S R=$P($G(^BPDMZERO(J,11,K,12,S,0)),U,2)
 I R="N" Q 0
 I R="RWA" Q 2
 Q 1
 ;
DW(R) ;EP - date written
 Q $$DATE($$VALI^XBDIQ1(52,R,1))
SIG(R,S,T) ;EP - return sig1 field from file 52
 I '$$REQ("DSP","DSP23",T) Q ""  ;if not required for this state skip it
 NEW A,C,C1,C2,V,J
 S V=$P($G(^BPDMSITE(S,0)),U,3)
 S A=0,J=""
 F  S A=$O(^PSRX(R,"SIG1",A)) Q:A'=+A  D
 .I J]"",$E(J,$L(J))'=" " S J=J_" "
 .S J=J_$P($G(^PSRX(R,"SIG1",A,0)),U,1)
 Q $E(J,1,200)
 ;
TXTYPE(R,S,T) ;EP - return  DSP24
 I '$$REQ("DSP","DSP24",T) Q ""  ;if not required for this state skip it
 ;check for non opiod and set to 99
 N DSP24,DRG,VADC,NDC,OK,TAXN,TAXD
 S DSP24="99"
 S OK=0
 S DRG=$P($G(^PSRX(R,0)),U,6)
 I 'DRG Q DSP24
 S VADC=$$GET1^DIQ(50,DRG,25)
 S NDC=$P($G(^PSDRUG(DRG,2)),U,4)
 S TAXN=$O(^ATXAX("B","BGP PQA OPIOID NDC",0))
 S TAXD=$O(^ATXAX("B","BGP PQA OPIOID MEDS",0))
 I VADC]"",VADC="CN101" S OK=1
 I NDC]"",TAXN]"",$D(^ATXAX(TAXN,21,"B",NDC)) S OK=1
 I DRG]"",TAXD]"",$D(^ATXAX(TAXD,21,"B",DRG)) S OK=1
 I 'OK Q DSP24
 I '$D(^DD(52,9999999.41,0)) Q DSP24
 NEW %
 S %=$$VAL^XBDIQ1(52,R,9999999.41)
 I %]"" Q "02"
 Q "01"
 ;
DSP25(R,S,T) ;EP
 I '$$REQ("DSP","DSP25",T) Q ""
 I $G(BPDMVER)="4.2B" Q $TR($$VAL^XBDIQ1(52,R,9999999.22),".","")  ;20211012 maw changed for 4.2B
 Q $$VAL^XBDIQ1(52,R,9999999.22)
 ;
 ;
PRE09(R,S,T) ;EP
 I '$D(^DD(52,9999999.41,0)) Q ""
 I '$$REQ("PRE","PRE09",T) Q ""
 Q $$VAL^XBDIQ1(52,R,9999999.41)
 ;
DATEFILL(P,R,PFI,PART) ;EP
 ;if part="02", regular prescription/refill
 ;if part="01" - GET data from partial multiple
 ;20240729 maw fully modified in p7
 N PUD
 S PUD=""
 ;S D=""
 I PART="01" D  Q PUD
 .I '$G(PFI) Q
 .S PUD=$$DATE^BPDMUTL($P($G(^PSRX(P,"P",PFI,0)),U,1))
 I $G(BPDMSTAT)="02" Q $G(BPDMOFD)  ;20241010 if RTS return orig fill dt
 I $G(R)>0 S PUD=$P($G(^PSRX(P,1,R,0)),U)  ;refill date
 I $G(R)>0,'$G(PUD),$G(BPDMOFD) Q $G(BPDMOFD)  ;20240715 refill date from log
 I $G(PUD)="" S PUD=$P($G(^PSRX(P,2)),U,2)  ;fill date
 I $G(PUD)="" Q $G(BPDMOFD)
 Q $$DATE^BPDMUTL(PUD)
 ;
DSP22(P,R,PFI,PART,RELAY,S,T) ;EP
 I '$$REQ("DSP","DSP22",T) Q ""
 ;if part="02", regular prescription/refill
 ;if part="01" - GET data from partial multiple
 NEW D
 I $G(RELAY)=1 Q 0
 S D=""
 I PART="01" D  Q D
 .I '$G(PFI) Q
 .S D=$P($G(^PSRX(P,"P",PFI,0)),U,4)
 S D=$$VAL^XBDIQ1(52,P,7)
 Q D
QUANTITY(P,R,PFI,PART,RELAY) ;EP
 ;if part="02", regular prescription/refill
 ;if part="01" - GET data from partial multiple
 NEW D
 I $G(RELAY)=1 Q 0
 S D=""
 I PART="01" D  Q D
 .I '$G(PFI) Q
 .S D=$P($G(^PSRX(P,"P",PFI,0)),U,4)
 S D=$$VAL^XBDIQ1(52,P,7)
 Q D
DAYS(P,R,PFI,PART) ;EP
 ;if part="02", regular prescription/refill
 ;if part="01" - GET data from partial multiple
 NEW D
 S D=""
 I PART="01" D  Q D
 .I '$G(PFI) Q
 .S D=$P($G(^PSRX(P,"P",PFI,0)),U,10)
 S D=$$VAL^XBDIQ1(52,P,8)
 Q D
COMPOUND(D) ;EP
 I $P(^PSDRUG(BPDMDRUG,0),U,3)[0!($P(^PSDRUG(BPDMDRUG,0),U,3)["M") Q 2
 Q 1
TXF(R) ;EP
 NEW O,B,A,N
 S N=""
 S O=$P($G(^PSRX(R,"OR1")),U,2)
 I O="" Q "01"
 S A=0 F  S A=$O(^OR(100,O,8,A)) Q:A'=+A!(N]"")  D
 .Q:'$D(^OR(100,O,8,A,0))
 .S B=$P(^OR(100,O,8,A,0),U,12)
 .Q:B=""
 .S N=B
 I N=1 Q "01"
 I N=2 Q "02"
 I N=3 Q "02"
 I N=4 Q "99"
 I N=5 Q "99"
 I N=6 Q "99"
 I N=7 Q "99"
 I N=8 Q "05"
 I N=9 Q "99"
 I N=10 Q "99"
 I N=11 Q "99"
 Q "99"
 ;
PHARMID(S) ;EP
 NEW Y
 S Y=$P($G(^BPDMSITE(S,13)),U,5)
 I Y="N" Q $$VAL^XBDIQ1(9002315.01,S,.07)
 I Y="D" Q $$VAL^XBDIQ1(9002315.01,S,.08)
 Q $TR($$VAL^XBDIQ1(9002315.01,S,.07),"-","")  ;v4.2b
PHARMNPI(R,F,S,PFI,PART) ;EP
 NEW P,N
 S (N,P)=""
 I PART="01" D  D:N="" NPIDEF Q N
 .I '$G(PFI) Q
 .S P=$P($G(^PSRX(R,"P",PFI,0)),U,5)
 .I P="" Q
 .S N=$$VAL^XBDIQ1(200,P,41.99)
 .I N="" Q
 I 'F D  D:N="" NPIDEF Q N
 .S P=$$VALI^XBDIQ1(52,R,23)
 .I P="" Q
 .S N=$$VAL^XBDIQ1(200,P,41.99)
 ;refill
 S P=$P($G(^PSRX(R,1,F,0)),U,5)
 I P="" D NPIDEF Q N
 S N=$P($G(^VA(200,P,"NPI")),U,1)
 I N="" D NPIDEF
 Q N
 ;
NPIDEF ;
 I P="" Q  ;no person
 S C=$$VALI^XBDIQ1(200,P,53.5)  ;class
 I C="" Q
 S C=$P($G(^DIC(7,C,9999999)),U,2)  ;class code
 I C="09" Q
 I C=67 Q
 I C=30 Q
 S D=$P(^BPDMSITE(S,0),U,13)
 I D="" Q
 S N=$$VAL^XBDIQ1(200,D,41.99)
 Q
PROVDEA(P,S) ;EP provider dea
 ;use dea from file 200
 ;if it isn't there use facility dea and put suffix as 2nd piece
 NEW D,SUFFIX
 S D="",SUFFIX=""
 S D=$$VAL^XBDIQ1(200,BPDMPROV,53.2)
 I D]"" Q D
 S D=$$VAL^XBDIQ1(9002315.01,S,.08)
 S SUFFIX=$$VAL^XBDIQ1(200,BPDMPROV,53.3)
 I SUFFIX="" Q ""
 Q D_U_SUFFIX
STATELIC(R,F,S,PFI,PART,SP) ;EP
 ;state licensing number if found in file 200 for the pharmacist
 NEW P,I,D,L,C
 S (P,L)=""
 I PART="01" D  D:L="" SLDEF Q L
 .I '$G(PFI) S P="" Q
 .S P=$P($G(^PSRX(R,"P",PFI,0)),U,5)  ;P is pharmacist of record
 .I P="" Q
 .S I=$O(^VA(200,P,"PS1","B",S,0))
 .I I="" Q
 .S L=$P($G(^VA(200,P,"PS1",I,0)),U,2)
 I 'F D  D:L="" SLDEF Q L
 .S P=$$VALI^XBDIQ1(52,R,23)  ;pharmcist of record in P
 .I P="" Q
 .S I=$O(^VA(200,P,"PS1","B",S,0))
 .I I="" S L="" Q
 .S L=$P($G(^VA(200,P,"PS1",I,0)),U,2)
 ;refill
 S P=$P($G(^PSRX(R,1,F,0)),U,5)
 I P="" D SLDEF Q L
 S I=$O(^VA(200,P,"PS1","B",S,0))
 I I="" D SLDEF Q L
 S L=$P($G(^VA(200,P,"PS1",I,0)),U,2)
 Q L
SLDEF ;
 I '$G(SP) Q
 I P="" Q  ;no person
 S C=$$VALI^XBDIQ1(200,P,53.5)  ;class
 I C="" Q
 S C=$P($G(^DIC(7,C,9999999)),U,2)  ;class code
 I C="09" Q  ;pharmacist should have license
 I C=67 Q  ;CLINICAL PHARMACY SPECIALIST should have license
 I C=30 Q  ;PHARMACY PRACTITIONER should have license
 S D=$P(^BPDMSITE(SP,0),U,13)
 I D="" Q
 S I=$O(^VA(200,D,"PS1","B",S,0))
 I I="" Q ""
 S L=$P($G(^VA(200,D,"PS1",I,0)),U,2)
 Q
PRESLIC(P,S) ;EP
 ;state licensing number if found in file 200 for the pharmacist
 NEW I,J,PN
 S PN=""
 S I=$O(^VA(200,P,"PS1","B",S,0))
 I $G(I) D  Q PN
 . S PN=$P($G(^VA(200,P,"PS1",I,0)),U,2)
 ;20220307 81486 patch 6
 I '$G(I) D  Q PN
 . S I=$O(^VA(200,P,"PS1","B",0))
 . Q:I=""
 . S J=$O(^VA(200,P,"PS1","B",I,0))
 . Q:J=""
 . S PN=$P($G(^VA(200,P,"PS1",J,0)),U,2)
 Q PN
PHARMNAM(R,F) ;EP
 ;get pharmacist
 NEW P
 I 'F D  Q P
 .S P=$$VALI^XBDIQ1(52,R,23)
 .I P="" Q
 .S P=$$NAME($P(^VA(200,P,0),U,1))
 ;refill
 S P=$P($G(^PSRX(R,1,F,0)),U,5)
 I P="" Q P
 Q $$NAME($P($G(^VA(200,P,0)),U,1))
 ;
DSP13(PART,PFI) ;EP
 ;PART - BPDMPART  01=PARTIAL, 02 NOT PARTIAL
 ;PFI - PARTIAL IEN
 I $G(PART)="" S PART="02"
 I PART="02" Q "00"
 ;PARTIAL
 I '$G(PFI) Q "00"
 I $L(PFI)=1 Q "0"_PFI
 Q PFI
PHARM(R,F) ;EP
 ;get pharmacist
 NEW P
 I 'F D  Q P
 .S P=$$VALI^XBDIQ1(52,R,23)
 .I P="" S P="NO PHARMACIST" Q  ;cmi/maw 2.0p4
 .S P=$P($G(^VA(200,P,0)),U,1)
 ;refill
 S P=$P($G(^PSRX(R,1,F,0)),U,5)
 I P="" S P="NO PHARMACIST" Q P  ;cmi/maw 2.0p4
 Q $P($G(^VA(200,P,0)),U,1)
 ;
RTS(P,R,F) ;EP
 NEW T
 S T=""
 I $G(R) D  Q T  ;refill
 .I $P($G(^PSRX(P,1,R,0)),U,16)]"" S T=1
 I $G(F) D  Q T
 .I $P($G(^PSRX(P,"P",F,0)),U,16)]"" S T=1
 I $P($G(^PSRX(P,2)),U,15)]"" Q 1
 Q 0
 ;
TCN(L) ;EP
 Q $$VALI^XBDIQ1(9002315.09,L,.1)_"-"_$$LZERO(L,6)
 ;
FN(O,L,T) ;EP
 NEW FN,F,E
 S (FN,F,E)=""
 ;get 1st piece, if blank get Pharmacy DEA#, if blank get pharmacy name
 S F=$P($G(^BPDMSITE(O,11)),U,3)
 I F="" S F=$P(^BPDMSITE(O,0),U,8)
 I F="" S F=$P(^BPDMSITE(O,0),U,2)
 S F=$$STRIP^XLFSTR(F," ")
 I F="" S F="pdm_"_$$VAL^XBDIQ1(9002315.01,O,.01)  ;_$S(T="T":"T",1:"")
 I $G(F)]"" S F=F_"_"_$E(DT,4,7)_$E(DT,2,3)  ;CMI/GRL
 S E=$S(T="T":"T",1:"")_$$VAL^XBDIQ1(9002315.01,O,1104)  ;CMI/GRL
 I E="" S E=$S(T="T":"T",1:"")_".dat"  ;CMI/GRL
 S FN=F_"_"_L_E
 I $G(BPDMVER)="4.2",$P($$GET1^DIQ(9002315.01,BPDMSITE,1306)," ")["OPTIMUM" D
 . S FN=$$GET1^DIQ(9002315.01,BPDMSITE,.08)_$$D(L)_E
 Q FN
 ;
D(LOG) ;--setup date by log
 N DATI,DAT
 S DATI=$P($G(^BPDMLOG(LOG,0)),U)
 S DAT=$E(DATI,4,5)_$E(DATI,6,7)_$E(DATI,2,3)
 Q $G(DAT)
 ;
DDUC(D) ;EP drug dosage units code for drug D
 I $D(D)="" Q ""
 NEW X,Y
 S X=$$VAL^XBDIQ1(50,D,9999999.145)
 I X="ML" Q "02"
 I X="VI" Q "02"
 I X="SZ" Q "02"
 I X="GM" Q "03"
 I X="GR" Q "03"
 Q "01"
BANNER ;EP
V ; GET VERSION
 NEW BPDMV,BPDML,BPDMJ,BPDMX
 S BPDMV="1.0"
 I $G(BPDMTEXT)="" S BPDMTEXT="TEXT",BPDML=5 G PRINT
 S BPDMTEXT="TEXT"_BPDMTEXT
 F BPDMJ=1:1 S BPDMX=$T(@BPDMTEXT+BPDMJ),BPDMX=$P(BPDMX,";;",2) Q:BPDMX="QUIT"!(BPDMX="")  S BPDML=BPDMJ
PRINT W:$D(IOF) @IOF
 F BPDMJ=1:1:BPDML S BPDMX=$T(@BPDMTEXT+BPDMJ),BPDMX=$P(BPDMX,";;",2) W !,$$CTR^BPDMDR(BPDMX,80)
 W !,$$CTR^BPDMDR("Version "_BPDMV)
SITE W !!,$$CTR^BPDMDR($$LOC^BPDMDR())
 K BPDMTEXT
 Q
TEXT ;
 ;;****************************************************************
 ;;**   Controlled Prescription Drug Monitoring Export System    **
 ;;**                Version 2.0 (Sep 2024)                    **
 ;;****************************************************************
 ;;QUIT
 ;
