BCQMUTL ; IHS/OIT/FBD - MAPPER UTILITIES ;09/11/2024 07:49;FS
 ;;1.0;IHS CODE MAPPING;**12,13**;OCT 01, 2025;Build 91
 ;
TXICU(V) ;EP - IS THIS ADMISSION A TRANSFER TO AN ICU?
 I $G(V)="" Q 0
 ;did this admission tx to a ward that is an ICU
 NEW X,Y,Z,D
 S D=$O(^DGPM("AVISIT",V,0))
 I D="" Q 0  ;no admission data to look at
 ;check each icu ward and whether the patient transferred into it
 S Y=0,X=0
 F  S X=$O(^DIC(42.1,X)) Q:X'=+X!(Y)  D
 .S W=$O(^BDGWD("B",X,0))
 .I W="" Q
 .I $$GET1^DIQ(9009016.5,W,101,"I")'=1 Q  ;NOT AN ICU
 .I $$FINDWARD($P(^AUPNVSIT(V,0),U,5),D,X,2) S Y=1
 Q Y
FINDWARD(DF,ADM,WARD,TT) ;-- find out if the ward is what they are looking for based on data
 N WDA,WIEN,TRAN,WD,RES
 S RES=0
 S WDA=0 F  S WDA=$O(^DGPM("APCA",DF,ADM,WDA)) Q:'WDA!($G(RES))  D
 . S WIEN=0 F  S WIEN=$O(^DGPM("APCA",DF,ADM,WDA,WIEN)) Q:'WIEN!($G(RES))  D
 .. S TRAN=$P($G(^DGPM(WIEN,0)),U,2)
 .. Q:TRAN'=TT
 .. S WD=$$GET1^DIQ(405,WIEN,.06,"I")
 .. I WD[WARD S RES=WD Q
 Q $G(RES)
 ;
ICU(V) ;EP - IS THE WARD AN ICU
 I $G(V)="" Q 0
 NEW D,W
 S D=$O(^DGPM("AVISIT",V,0))
 I D="" Q 0
 S W=$$GET1^DIQ(405,D,.06,"I")
 I W="" Q 0
 S W=$O(^BDGWD("B",W,0))
 I W="" Q 0
 S W=$$GET1^DIQ(9009016.5,W,101,"I")
 Q W
FACTYPE(V) ;EP - RETURN FACILITY TYPE
 Q $$GET1^DIQ(4,V,13)
HOSP(V) ;EP - IS THIS A HOSPITAL FACILITY TYPE?
 I $G(V)="" Q 0
 I '$D(^AUPNVSIT(V,0)) Q 0
 NEW A
 S A=$P(^AUPNVSIT(V,0),U,6)
 I 'A Q 0
 I '$D(^DIC(4,A,0)) Q 0
 S A=$$FACTYPE(A)
 I A="HOSPITAL" Q 1
 Q 0
ISAMBU(V) ;EP - IS THIS A AMBULATORY SERVICE CATEGORY?
 I $G(V)="" Q 0
 I '$D(^AUPNVSIT(V,0)) Q 0
 NEW A
 S A=$P(^AUPNVSIT(V,0),U,7)
 I 'A Q 0
 I A="A" Q 1
 Q 0
NURSEVAL(CLIN,PROV,TIU) ;EP - IS THIS A NURSE VISIT?
 I 'TIU Q 0  ;no tiu note
 I CLIN=45 Q 1
 I CLIN=79 Q 1
 I CLIN="B4" Q 1
 I PROV="01" Q 1
 I PROV="05" Q 1
 I PROV=13 Q 1
 I PROV=14 Q 1
 I PROV=32 Q 1
 Q 0
 ;
NHBRL(V) ;EP- IS THERE BOTH RIGHT AND LEFT NEWBORN HEARING?
 I '$G(V) Q ""
 NEW X,Y,Z,BCQMR,BCQML
 S (BCQMR,BCQML)=0
 S X=0 F  S X=$O(^AUPNVXAM("AD",V,X)) Q:X'=+X  D
 .I $$GET1^DIQ(9999999.15,$$GET1^DIQ(9000010.13,X,.01,"I"),.02)="39" S BCQMR=1
 .I $$GET1^DIQ(9999999.15,$$GET1^DIQ(9000010.13,X,.01,"I"),.02)="38" S BCQML=1
 I BCQMR+BCQML=2 Q 1
 Q 0
ESTIM(V) ;EP - IS THIS AN ESTIMATE?
 ;does a ";" piece of V contain qualifier "estimated"
 NEW X,Y,Z
 S Z=0
 F X=1:1 S Y=$P(V,";",X) Q:Y=""  I $$UP^XLFSTR(Y)="ESTIMATED" S Z=1
 Q Z
H72(V) ;EP - WAS THIS H visit adm date w/in 72 hours of a discharge date
 I $G(V)="" Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 I $P(^AUPNVSIT(V,0),U,7)'="H" Q ""
 NEW X,Y,Z,A,P,D,G
 S P=$P(^AUPNVSIT(V,0),U,5)
 S G=0
 S A=$$VDTM^APCLV(V)  ;get visit/admit date& time
 S D=0 F  S D=$O(^AUPNVSIT("AAH",P,D)) Q:D=""  S X=0 F  S X=$O(^AUPNVSIT("AAH",P,D,X)) Q:X=""!(G)  D
 .Q:X=V  ;same visit
 .S E=$$DDTM^APCLV(X)  ;get disharge date/time
 .S Y=$$FMDIFF^XLFDT(A,E,2)
 .Q:Y>259200
 .Q:Y<0
 .S G=1
 .Q
 Q G
AGEV(V) ;EP - age of patient on this visit
 I $G(V)="" Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""  ;no visit
 NEW P,A
 S P=$P(^AUPNVSIT(V,0),U,5)
 I 'P Q ""
 Q $$AGE^AUPNPAT(P,$$VD^APCLV(V))
BWTV(V) ;EP - birth weight is detected (same date as DOB for patient) on this visit
 I $G(V)="" Q ""
 I $$ESTIM(V)'=0 Q "" ;IF AN ESTIMATE EXIST?
 ;add a mapping to LOINC 8339-4 when a birth weight is detected (same date as DOB for patient)
 ;and when the Estimated Gestational Age is NOT available.
 I '$D(^AUPNVSIT(V,0)) Q ""  ;no visit
 NEW P,I,A,IEN,WT
 S P=$P(^AUPNVSIT(V,0),U,5) ;Patient
 I 'P Q ""
 ;WT > 0 V Measurement IEN without ENTERED IN ERROR
 S I="",IEN="",WT=$O(^AUTTMSR("B","WT","")) F  S I=$O(^AUPNVMSR("AD",V,I)) Q:'I  D
 .I $D(^AUPNVMSR(I,0)),'$D(^AUPNVMSR(I,2)),+$P(^AUPNVMSR(I,0),U,4)>0,+$P(^AUPNVMSR(I,0),U,1)=WT S IEN=I
 I 'IEN Q 0
 S A=$P($P(^AUPNVSIT(V,0),",",1),".",1)
 I 'A Q ""
 Q $$GET1^DIQ(2,P_",",.03,"I")=A
CHKMODV(V,C,M) ;EP - GQ,GT or 95 modifier or no modifiers at all for the visit
 I $G(V)="" Q ""
 I $G(M)="" S M=1 ;M should be 0 to go for a 'No Modifiers' Check
 I '$D(^AUPNVSIT(V,0)) Q ""  ;no visit
 I '$D(^AUPNVCPT("AD",V)) Q ""  ;no vcpt
 NEW I,M1,M2,MGQ,MGT,M95,IEN
 S I=$O(^AUPNVCPT("AD",V,"")) ; V CPT IEN
 I 'I,'$D(^AUPNVCPT(I,0)) Q 0
 S I="",IEN="" F  S I=$O(^AUPNVCPT("AD",V,I)) Q:'I  D
 .I $D(^AUPNVCPT("B",C,I)) S IEN=I
 I 'IEN Q 0
 S M1=$P(^AUPNVCPT(IEN,0),U,8),M2=$P(^AUPNVCPT(IEN,0),U,9)
 I 'M1,'M2,'M Q 1
 I 'M Q 0 ;No Modifiers Failed
 S MGQ=$O(^DIC(81.3,"B","GQ","")),MGT=$O(^DIC(81.3,"B","GT","")),M95=$O(^DIC(81.3,"B","95","")) ;Modifiers Ref. data
 I (M1=MGQ)!(M1=MGT)!(M1=M95)!(M2=MGQ)!(M2=MGT)!(M2=M95) Q 1  ;Needed at least one of the following modifiers
 Q 0
CHKMODV2(V,C,M) ;EP - 50, LT, RT modifier or no modifiers at all for the visit
 I $G(V)="" Q 0
 I $G(M)="" Q 0
 I '$D(^AUPNVSIT(V,0)) Q ""  ;no visit
 I '$D(^AUPNVCPT("AD",V)) Q ""  ;no vcpt
 NEW I,IEN,M1,M2,M3
 S I=$O(^AUPNVCPT("AD",V,"")) ; V CPT IEN
 I 'I,'$D(^AUPNVCPT(I,0)) Q 0
 S I="",IEN="" F  S I=$O(^AUPNVCPT("AD",V,I)) Q:'I  D
 .I $D(^AUPNVCPT("B",C,I)) S IEN=I
 I 'IEN Q 0
 S M1=$P(^AUPNVCPT(IEN,0),U,8),M2=$P(^AUPNVCPT(IEN,0),U,9),M3=$P(^AUPNVCPT(IEN,0),U,10)
 S M=$O(^DIC(81.3,"B",M,"")) ;Modifiers Ref. data
 I (M1=M)!(M2=M)!(M3=M) Q 1  ;Needed at least one of the following modifiers
 Q 0
EKGFINDL() ;PEP - return EKG finding loinc
 Q "8601-7"
