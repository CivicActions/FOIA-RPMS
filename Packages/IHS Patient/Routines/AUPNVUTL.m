AUPNVUTL ; IHS/CMI/LAB - AUPN UTILITIES ; 13 Nov 2019  12:19 PM
 ;;2.0;IHS PCC SUITE;**2,10,11,15,16,17,22,24,29**;MAY 14, 2009;Build 20
SNOMED(N) ;PEP - called from various dds provider narrative
 ;TRANSFORM TO ADD DESCRIPTIVE TEXT FOR SNOMED CODE IF THERE IS A "|" PIECE
 I $G(N)="" Q N
 S N=$P($G(^AUTNPOV(N,0)),U,1)
 I N'["|" Q N  ; no vertical equals no snomed desc id
 I N["| " Q N  ;prenatal v1.0
 I $T(DESC^BSTSAPI)="" Q N  ;no snomed stuff installed
 NEW SDI,SDIT,LAT
 S (SDI,SDIT)=$P(N,"|",2)  ;snomed descriptive id is in piece 2
 S LAT=$P(N,"|",3)  ;laterality text is in piece 3
 I SDI?.AN S SDIT=$P($$DESC^BSTSAPI(SDI_"^^1"),U,2)
 I SDIT="",SDI]"" S SDIT=SDI
 I SDIT="" Q "*"_$P(N,"|",1)  ;not snomed text??  somebody stored a bad descriptive id return "* | " per Susan
 Q SDIT_$S(LAT]"":", "_LAT,1:"")_" | "_$P(N,"|",1)
PNPROB(N) ;PEP - called from various dds provider narrative
 ;TRANSFORM TO ADD DESCRIPTIVE TEXT FOR SNOMED CODE IF THERE IS A "|" PIECE
 ;N must be a valid IEN in AUTNPOV (provider narrative)
 I $G(N)="" Q N
 S N=$P($G(^AUTNPOV(N,0)),U,1)
 I N'["|" Q "*"_N  ; no vertical equals no snomed desc id
 I N["| " Q N  ;prenatal v1.0
 I $T(DESC^BSTSAPI)="" Q "*"_N  ;no snomed stuff installed
 NEW SDI,SDIT,LAT
 S (SDI,SDIT)=$P(N,"|",2)  ;snomed descriptive id is in piece 2
 S LAT=$P(N,"|",3)  ;laterality text is in piece 3
 I SDI?.AN S SDIT=$P($$DESC^BSTSAPI(SDI_"^^1"),U,2)
 I SDIT="" S SDIT=SDI
 I SDIT="" Q "*"_$P(N,"|",1)  ;not snomed text??  somebody stored a bad descriptive id return "* | " per Susan
 Q SDIT_$S(LAT]"":", "_LAT,1:"")_" | "_$P(N,"|",1)
EXFIND(%) ;PEP - RETURN EXAM FINDING TEXT BASED ON SNOMED CODE
  ;NOTE:  only 2 SNOMEDs are supported at this time, this will need to be updated if others are ever added.
  I %=162656002 Q "without abnormal findings"
  I %=71994000 Q "with abnormal findings"
  Q %
AQ(%) ;PEP RETURN HUMAN READABLE LATERALITY ATTRIBUTE/QUALIFIER VALUE
 NEW A,Q,V,A1
 I $G(%)="" Q ""
 S A=$P(%,"|")
 I A="" S V="" G AQQ
 ;S V=$$CONCPT(A)
 S V=$$CVPARM^BSTSMAP1("LAT",A)
 I V="" S V=A  ;if no text just use the code
AQQ ;
 S V=V_"|"
 S Q=$P(%,"|",2)
 I Q="" Q V
 ;S A1=$$CONCPT(Q)
 S A1=$$CVPARM^BSTSMAP1("LAT",Q)
 I A1="" S A1=Q
 Q V_A1
EDNAME(I) ;PEP - RETURN EDUCATION TOPIC TEXT
 ;if the topic contains a snomed display preferred term and then subtopic
 NEW N
 I $G(I)="" Q I
 S N=$P($G(^AUTTEDT(I,0)),U,1)
 I $P($G(^AUTTEDT(I,0)),U,12)="" Q N
 I $T(CONC^BSTSAPI)="" Q N  ;no snomed stuff installed
 NEW SDI,SDIT
 S SDI=$P(N,"-",1)  ;snomed descriptive id is in piece 2
 S SDIT=$$CONCPT(SDI)
 I SDIT="" Q N  ;not snomed text??  somebody stored a bad descriptive id return "* | " per Susan
 Q SDIT_"-"_$P(N,"-",2)
FSOT(X) ;PEP - FINDING SITE OUTPUT TX/COMPUTED FIELD
 ;get each | piece, then each ":" piece and get perferred term
 I $T(CONC^BSTSAPI)="" Q ""
 I $G(X)="" Q ""
 NEW A,B,V,D,E
 S V=""
 F A=1:1 S B=$P(X,"|",A) Q:B=""  D
 .;S D=$P(B,":",1)
 .S E=$P(B,":",2)
 .I V]"" S V=V_", "
 .; V=V_$$CONCPT(D)_":"_$$CONCPT(E)
 .S V=V_$$CONCPT(E)
 Q V
TESTFS ;
 ;
 S X="272741003:7771000|363698007:56459004"
 W $$FSOT(X)
 Q
CONC(X) ;EP 22
 ;CALLED FROM VARIOUS PCC ROUTINES TO GET CONCEPT ID IF BSTS IS INSTALLED
 I $T(CONC^BSTSAPI)="" Q ""
 I $G(X)="" Q ""
 Q $$CONC^AUPNSICD(X_"^^^1")
CONCPT(X) ;PEP - GET CONCEPT PREFERRED TERM
 ;CALLED FROM VARIOUS PCC ROUTINES TO GET CONCEPT ID PREFERRED TERM IF BSTS IS INSTALLED
 I $T(CONC^BSTSAPI)="" Q ""
 I $G(X)="" Q ""
 NEW D,B,E,V,A,B
 Q $P($$CONC^BSTSAPI(X_"^^^1"),U,4)
DESCPT(X) ;PEP - GET DESC ID
 I $T(DESC^BSTSAPI)="" Q ""
 I $G(X)="" Q ""
 I $G(X)'?.AN Q X
 Q $P($$DESC^BSTSAPI(X_"^^1"),U,2)
LOINCT(X) ;EP
 ;put api in here when get it from apelon group
 Q ""
LOINCPT(X) ;EP
 ;put api in here when get it from apelon group
 Q ""
ICD(X,Y,Z) ;PEP - CHECK FOR ICD10
 ;I $T(ICD^ATXAPI)]"" Q $$ICD^ATXAPI(X,Y,Z)
 Q $$ICD^ATXCHK(X,Y,Z)
 ;
ICDDX(C,D,I) ;PEP - CHECK FOR ICD10
 I $G(I)="" S I="I"
 I $T(ICDDX^ICDEX)]"" Q $$ICDDX^ICDEX(C,$G(D),,I)
 Q $$ICDDX^ICDCODE(C,$G(D))
 ;
ICDOP(C,D,I) ;PEP - CHECK FOR ICD10
 I $G(I)="" S I="E"
 I $T(ICDOP^ICDEX)]"" Q $$ICDOP^ICDEX(C,$G(D),,I)
 Q $$ICDOP^ICDCODE(C,$G(D))
 ;
VSTD(C,D) ;EP - CHECK FOR ICD10
 I $T(VSTD^ICDEX)]"" Q $$VSTD^ICDEX(C,$G(D))
 Q $$VSTD^ICDCODE(C,$G(D))
 ;
VSTP(C,D) ;EP - CHECK FOR ICD10
 I $T(VSTP^ICDEX)]"" Q $$VSTP^ICDEX(C,$G(D))
 Q $$VSTP^ICDCODE(C,$G(D))
 ;
ICDD(C,A,D) ;EP - CHECK FOR ICD10
 I $T(ICDD^ICDEX)]"" Q $$ICDD^ICDEX(C,A,$G(D))
 Q $$ICDD^ICDCODE(C,A,$G(D))
CONFSN(C) ;EP - FSN
 ;CALLED FROM VARIOUS PCC ROUTINES TO GET CONCEPT ID FSN IF BSTS IS INSTALLED
 I $T(CONC^BSTSAPI)="" Q ""
 I $G(X)="" Q ""
 Q $P($$CONC^BSTSAPI(X_"^^^1"),U,2)
MC(X) ;EP - called from cross ref
 I $G(X)="" Q ""
 NEW A,B,C
 S A=$O(^AUTTREFR("B",X,0))
 I 'A Q ""
 Q $P($G(^AUTTREFR(A,0)),U,4)
M07(X) ;EP - map .07 to 1.01
 I $G(X)="" Q ""
 NEW A
 S A=$O(^AUTTREFR("AM",X,0))
 I 'A Q ""
 Q $P(^AUTTREFR(A,0),U,1)
 ;
IMP(%) ;EP
 Q $$IMP^ICDEX(%)
REFR(%) ;PEP - REFUSAL REASON TEXT FORM
 I '$G(%) Q ""
 I '$D(^AUPNPREF(%,0)) Q ""
 NEW A,B,C
 S A=$$VAL^XBDIQ1(9000022,%,1.01)
 I A]"" S A=$$CONCPT(A)
 I A]"" Q A
 Q $$VAL^XBDIQ1(9000022,%,.07)
IN6404 ;EP - input transform on .04 V Delivery
 NEW LIST,AUPNX
 K LIST
 S AUPNX=$$SUBLST^BSTSAPI("LIST","EHR LABOR ESTABLISHED")
 ;BUILD INDEX
 S AUPNX=0 F  S AUPNX=$O(LIST(AUPNX)) Q:AUPNX'=+AUPNX  S LIST("B",$P(LIST(AUPNX),U,1))=""
 I $O(LIST(0)),'$D(LIST("B",X)) K X Q
 Q
IN6407 ;EP - input transform on .04 V Delivery
 NEW LIST,AUPNX
 K LIST
 S AUPNX=$$SUBLST^BSTSAPI("LIST","EHR LABOR INDUCTION TYPE")
 ;BUILD INDEX
 S AUPNX=0 F  S AUPNX=$O(LIST(AUPNX)) Q:AUPNX'=+AUPNX  S LIST("B",$P(LIST(AUPNX),U,1))=""
 I $O(LIST(0)),'$D(LIST("B",X)) K X Q
 Q
PCINP(X) ;EP - input tx on procedure field of patient implanted devices
 I $G(X)="" Q
 NEW A,B,C
 S A=$P(X,"|") I A="" K X Q
 I A'="CPT",A'="ICD",A'="SNOMED" K X Q
 S B=$P(X,"|",2) I B="" K X Q
 Q
CURSTAT(I) ;EP - return current status
 I '$G(I) Q ""
 NEW A,B,D
 S (A,B,D)="" F  S D=$O(^AUPNPDEV(I,3,"B",D)) Q:D'=+D  S A=0 F  S A=$O(^AUPNPDEV(I,3,"B",D,A)) Q:A'=+A  S B=A   ;GET LAST ONE BY DATE
 I 'B Q ""
 S A=B_","_I
 Q $$GET1^DIQ(9000091.3,A,.02)
PROCTEXT(I) ;EP - return procedure text on patient implanted devices
 I $G(I)="" Q ""
 I '$D(^AUPNPDEV(I,0)) Q ""
 NEW A,B,C,D
 S C=$P($G(^AUPNPDEV(I,0)),U,9)
 I C="" Q ""
 S A=$P(C,"|")
 I A'="CPT",A'="ICD",A'="SNOMED" Q ""
 S B=$P(C,"|",2)
 I B="" Q ""
 S D=$P(^AUPNPDEV(I,0),U,6) I D="" S D=DT
 I A="CPT" Q $P($$CPT^ICPTCOD(B,D),U,3)
 I A="ICD" Q $P($$ICDOP^ICDEX(B,D),U,5)
 I A="SNOMED" Q $P($$CONC^BSTSAPI(B_"^^^1"),U,4)
 Q ""
 ;
EGASN(X) ;EP - called from trigger on V Delivery
 I $G(X)="" Q ""
 S X=+X
 I X=1 Q 87178007
 I X=2 Q 82118009
 I X=3 Q 74952004
 I X=4 Q 44398003
 I X=5 Q 37005007
 I X=6 Q 86801005
 I X=7 Q 63110000
 I X=8 Q 26690008
 I X=9 Q 931004
 I X=10 Q 38039008
 I X=11 Q 50367001
 I X=12 Q 79992004
 I X=13 Q 62333002
 I X=14 Q 72846000
 I X=15 Q 6678005
 I X=16 Q 15633004
 I X=17 Q 65683006
 I X=18 Q 25026004
 I X=19 Q 54318006
 I X=20 Q 23464008
 I X=21 Q 41438001
 I X=22 Q 65035007
 I X=23 Q 86883006
 I X=24 Q 313179009
 I X=25 Q 72544005
 I X=26 Q 48688005
 I X=27 Q 46906003
 I X=28 Q 90797000
 I X=29 Q 45139008
 I X=30 Q 71355009
 I X=31 Q 64920003
 I X=32 Q 7707000
 I X=33 Q 78395001
 I X=34 Q 13763000
 I X=35 Q 84132007
 I X=36 Q 57907009
 I X=37 Q 43697006
 I X=38 Q 13798002
 I X=39 Q 80487005
 I X=40 Q 46230007
 I X=41 Q 63503002
 I X=42 Q 36428009
 I X>42 Q 433601000124106
 Q ""
