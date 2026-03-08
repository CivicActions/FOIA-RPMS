BDMDO18 ; IHS/CMI/LAB - 2025 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**18**;JUN 14, 2007;Build 147
 ;
 ;
HT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,BDMARRY,H,E,D,W
 S E=$O(^AUTTMSR("B","HT",0))
 S H=""
 S D=0 F  S D=$O(^AUPNVMSR("AA",P,E,D)) Q:D'=+D!(H]"")  D
 .S W=0 F  S W=$O(^AUPNVMSR("AA",P,E,D,W)) Q:W'=+W!(H]"")  D
 ..Q:'$D(^AUPNVMSR(W,0))
 ..Q:$P($G(^AUPNVMSR(W,2)),U,1)  ;entered in error
 ..S H=$P(^AUPNVMSR(W,0),U,4)
 ..S BDMARRAY(1)=$$VD^APCLV($P(^AUPNVMSR(W,0),U,3))
 I H="" Q H
 I H["?" Q ""
 S H=$J(H,5,2)
 Q $$STRIP^XLFSTR(H," ")
 ;
WT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,E,BDMW,X,BDMN,BDM,BDMD,BDMZ,BDMX,ICD,BDMVF
 K BDM S BDMW="" S BDMX=P_"^LAST 24 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(BDMX,"BDM(")
 S BDMN=0 F  S BDMN=$O(BDM(BDMN)) Q:BDMN'=+BDMN!(BDMW]"")  D
 .S BDMVF=+$P(BDM(BDMN),U,4)
 .Q:$P($G(^AUPNVMSR(BDMVF,2)),U,1)  ;entered in error
 .S BDMZ=$P(BDM(BDMN),U,5)
 .I '$D(^AUPNVPOV("AD",BDMZ)) S BDMW=$P(BDM(BDMN),U,2) Q
 .S BDMD=0,G=0 F  S BDMD=$O(^AUPNVPOV("AD",BDMZ,BDMD)) Q:'BDMD!(G=1)  D
 ..S ICD=$$VALI^XBDIQ1(9000010.07,BDMD,.01) D  ;cmi/anch/maw 9/12/2007 csv
 ...I $$ICD^BDMUTL(ICD,"BGP PREGNANCY DIAGNOSES 2",9) S G=1  ;cmi/maw 05/15/2014 p8
 .I 'G S BDMW=$P(BDM(BDMN),U,2)
 Q BDMW
BMI(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,W,H,B,D,%DT,X
 S %=""
 D  Q %
 .S W=$$WT(P,BDATE,EDATE) Q:W=""  S W=W\1  ;S W=W+.5,W=$P(W,".")
 .S HDATE=$P(^DPT(P,0),U,3)
 .S H=$$HT(P,HDATE,EDATE) I H="" Q
 .;S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 .S H=H*H,%=(W/H)*703,%=$J(%,5,1)
 .Q
 Q
CREAT(P,BDATE,EDATE,F) ;EP
 G CREAT^BDMDO1C
CHOL(P,BDATE,EDATE,F) ;EP
 G CHOL^BDMDO1C
HDL(P,BDATE,EDATE,F) ;EP
 G HDL^BDMDO1C
LDL(P,BDATE,EDATE,F) ;EP
 G LDL^BDMDO1C
TRIG(P,BDATE,EDATE,F) ;EP
 G TRIG^BDMDO1C
URIN(P,BDATE,EDATE) ;EP
 G URIN^BDMDO1H
PROTEIN(P,BDATE,EDATE) ;EP
 G PROTEIN^BDMDO1C
MICRO(P,BDATE,EDATE) ;EP
 G MICRO^BDMDO1C
HGBA1C(P,BDATE,EDATE) ;EP
 G HGBA1C^BDMDO1D
SEMI(P,BDATE,EDATE) ;EP
 G SEMI^BDMDO1C
TBTD3(P,EDATE) ;EP - AUDIT EXPORT FILE
 I $P($$TBDX(P,EDATE),U,1)'=2 Q ""  ;POPULATE ONLY IF TBDX IS NO
 Q $E($$PPD(P,EDATE))  ;1, 2 or 3
TBTR2(P,EDATE) ;EP
 I $P($$TBDX(P,EDATE),U,1)'=2 Q ""  ;POPULATE ONLY IF TBDX IS NO
 I $E($$PPD(P,EDATE),U,1)=3 Q ""
 Q $E($P($$PPD(P,EDATE),"||",2))  ;1, 2 or 3
TBINH(P,EDATE) ;EP
 I $P($$TBDX(P,EDATE),U,1)=1 Q $E($$TBTX^BDMDO12(P,EDATE))
 I $E($P($$PPD(P,EDATE),"||",2))=1 Q $E($$TBTX^BDMDO12(P,EDATE))
 Q ""
TBDX(P,EDATE) ;EP - ANY DX OF TB?
 NEW BDMS,E,X
 K BDMS
 ;CHECK HF
 S BDMS=$$LASTHF^BDMSMU(P,"C003","A",$$DOB^AUPNPAT(P),EDATE)
 I $G(BDMS) Q 1_U_$$DATE^BDMS9B1($P(BDMS,U,3))_"  HF: "_$P(BDMS,U,2)
PPDSPL ;CHECK PL
 N T S T=$O(^ATXAX("B","DM AUDIT TUBERCULOSIS DXS",0))
 I 'T Q ""
 N X,Y,I,G,S,DD
 S I=""
 S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  D
 .S G="",S=""
 .Q:'$D(^AUPNPROB(X,0))
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .S Y=$P(^AUPNPROB(X,0),U)
 .I $$ICD^BDMUTL(Y,$P(^ATXAX(T,0),U),9) S G=1  ;got a hit
 .;now check SNOMED
 .I 'G S S=$$VAL^XBDIQ1(9000011,X,80001) I S]"",$$SNOMED^BDMUTL(2025,"PXRM BQI TUBERCULOSIS",S) S G=1
 .I 'G Q
 .S D=$$VALI^XBDIQ1(9000011,X,.13)  ;DATE OF ONSET
 .;I DOO IS AFTER EDATE QUIT
 .I D,D]EDATE Q
 .S I=1_U_"  Problem List: "_$$VAL^XBDIQ1(9000011,X,.01)_$S(S]"":" ("_S_")",1:"")
 I I Q I
 ;check povs
 K BDMS S X=P_"^FIRST DX [DM AUDIT TUBERCULOSIS DXS" S E=$$START1^APCLDF(X,"BDMS(")
 I $D(BDMS(1)) Q 1_U_$$DATE^BDMS9B1($P(BDMS(1),U))_"  POV: "_$P(BDMS(1),U,3)
 ;CHECK V POV SNOMED
 S I=""
 S S="" F  S S=$O(^AUPNVPOV("ASNC",P,S)) Q:S=""  D
 .I '$$SNOMED^BDMUTL(2025,"PXRM BQI TUBERCULOSIS",S) Q
 .S D=0 F  S D=$O(^AUPNVPOV("ASNC",P,S,D)) Q:D=""  D
 ..S Y=9999999-D
 ..Q:Y>EDATE
 ..S I=1_U_$$DATE^BDMS9B1(D)_"  POV: "_S
 I I Q I
 Q "2^No"
PPD(P,EDATE,F) ;EP
 ;f 1=tb test done
 ;f 2=tb result
 S F=$G(F)
 ;RETURN 1^1  Skin Test||1  Positive
 NEW BDM,X,E,G,BDATE,Y,%DT,D,R,R1,R2,ED,LD,LR
 S LD="",LR=""
 S X=EDATE,%DT="P" D ^%DT S ED=Y
 K BDM
 ;get, in reverse order all skin tests and lab tests for TB testing  (BDM(inverse date,#)=ST or LAB^ien^result^reading
 S X=$O(^AUTTSK("B","PPD",0))
 S D=9999999-ED-1,C=0 F  S D=$O(^AUPNVSK("AA",P,X,D)) Q:D=""  D
 .S G=0 F  S G=$O(^AUPNVSK("AA",P,X,D,G)) Q:G'=+G  D
 ..Q:'$D(^AUPNVSK(G,0))
 ..S C=C+1 S BDM($P(D,"."),C)="ST"_U_G_U_$P(^AUPNVSK(G,0),U,5)_U_$S($P(^AUPNVSK(G,0),U,4)="D":"",$P(^AUPNVSK(G,0),U,4)="O":"",1:$P(^AUPNVSK(G,0),U,4))
 S BDMC=0
 S BDMLT=$O(^ATXLAB("B","DM AUDIT TB LAB TESTS",0))
 S BDMOT=$O(^ATXAX("B","DM AUDIT TB TEST LOINC",0))
 S G="",E=9999999-ED S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...Q:$$UP^XLFSTR($P(^AUPNVLAB(X,0),U,4))["CANC"
 ...I BDMLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(BDMLT,21,"B",$P(^AUPNVLAB(X,0),U))) D
 ....S C=C+1,BDM(D,C)="LAB^"_X_U_$P(^AUPNVLAB(X,0),U,4),G=1
 ...Q:'BDMOT
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC^BDMDO1C(J,BDMOT)
 ...S C=C+1,BDM(D,C)="LAB^"_X_U_$P(^AUPNVLAB(X,0),U,4),G=1
 ...Q
 ;now get latest and use it
 S (D,C)=0,G=""
 S D=$O(BDM(D))  ;LAST DATE
 I 'D Q "3  No test documented||"
 ;get any on that day with a result
 S C=0 F  S C=$O(BDM(D,C)) Q:C'=+C!(G]"")  D
 .I $P(BDM(D,C),U,1)="LAB",$P(BDM(D,C),U,3)]"" S G=BDM(D,C)
 .I $P(BDM(D,C),U,1)="ST",$P(BDM(D,C),U,4)]""!($P(BDM(D,C),U,3)]"") S G=BDM(D,C)
 I F="I" Q (9999999-D)  ;if want date quit on date of last
 I G="" Q $S($P(G,U,1)="ST":"1 - Skin test (PPD) ",1:"2 - Blood Test ")_$$DATE^BDMS9B1((9999999-D))_"||3 - No result documented"
 S C="" D  Q C
 .S C=$S($P(G,U,1)="ST":"1 - Skin test (PPD) ",1:"2 - Blood Test ")_$$DATE^BDMS9B1((9999999-D))
 .;GET RESULT VALUE
 .I $P(G,U,1)="LAB" S R=$P(G,U,3) D  Q
 ..I $E($$UP^XLFSTR(R))="P" S C=C_"||1 - Positive "_$$VD^APCLV($P(^AUPNVLAB($P(G,U,2),0),U,3),"S")_" lab result: "_R Q
 ..I $E($$UP^XLFSTR(R))="N" S C=C_"||2 - Negative "_$$VD^APCLV($P(^AUPNVLAB($P(G,U,2),0),U,3),"S")_" lab result: "_R Q
 ..S C=C_"||3 - No result documented "_$$VD^APCLV($P(^AUPNVLAB($P(G,U,2),0),U,3),"S") Q
 .I $P(G,U,1)="ST" D  Q
 ..S R=$P(G,U,3),R1=$P(G,U,4)
 ..I R]"",R>9 S C=C_"||1 - Positive "_$$VD^APCLV($P(^AUPNVSK($P(G,U,2),0),U,3),"S")_" Reading: "_R_" Result: "_R1 Q
 ..I R]"",R<10 S C=C_"||2 - Negative "_$$VD^APCLV($P(^AUPNVSK($P(G,U,2),0),U,3),"S")_" Reading: "_R_" Result: "_R1 Q
 ..I R1]"",R1="P" S C=C_"||1 - Positive "_$$VD^APCLV($P(^AUPNVSK($P(G,U,2),0),U,3),"S")_" Reading: "_R_" Result: "_R1 Q
 ..I R1]"",R1="N" S C=C_"||2 - Negative "_$$VD^APCLV($P(^AUPNVSK($P(G,U,2),0),U,3),"S")_" Reading: "_R_" Result: "_R1 Q
 ..S C=C_"||3 - No result documented "_$$VD^APCLV($P(^AUPNVSK($P(G,U,2),0),U,3),"S") Q
 Q
 ;
LASTNP(P,EDATE) ;EP - last negative ppd
 I $$TBTR2(P,EDATE)'=2 Q ""
 Q $$PPD(P,EDATE,"I")
 ;
FGLUCOSE(P,BDATE,EDATE,F) ;EP
 G FGLUCOSE^BDMDO1D
G75(P,BDATE,EDATE,F) ;EP
 G G75^BDMDO1D
 ;
STV(X,T,D) ;EP - strip hgba1c before epi export
 I X="" Q X  ;no value in X so don't bother
 I X="?" Q ""
 I '$G(T) S T=12
 S D=$G(D)
 NEW A,B,L
 S X=$$STRIP^XLFSTR(X,",")  ;STRIP COMMAS
 S L=$L(X)
 I $E(X)?1N S X=+X
 F B=1:1:L S A=$E(X,B) Q:A=""  I A'?1N,A'?1"." S X=$$STRIP^XLFSTR(X,A) S B=B-1
 I X="" Q ""
 I X["." S X=$J(X,T,D)
 S X=$$STRIP^XLFSTR(X," ")
 Q X
 ;Q $E(X,1,T)
STE(X,T,D) ;EP - strip hgba1c before epi export
 I X="" Q X  ;no value in X so don't bother
 I X="?" Q ""
 NEW A,B,L
 S L=$L(X)
 F B=1:1:L S A=$E(X,B) Q:A=""  I A'?1N,A'?1".",X'?1"+",X'?1"-",X'?1">",X'?1"<" S X=$$STRIP^XLFSTR(X,A) S B=B-1
 I X="" Q ""
 I $G(D),X["." S X=$J(X,T,D)
 S X=$$STRIP^XLFSTR(X," ")
 Q $E(X,1,T)
AS(X) ;EP
 I $E(X)="<" S X=$E(X,2,99),X=X-1 Q X
 I $E(X)=">" S X=$E(X,2,99),X=X+1 Q X
 Q X
 ;
PRES(P,TAX,ED) ;EP
 ;GO THROUGH 52 FOR PATIENT
 NEW BDMD,G,Z,R,D,E,T,F,I,BDMMEDS1,Y,%,K,V
 S BDMD=$$FMADD^XLFDT(ED,-(6*31)) ;DATE OF EXPIRATION NEEDS TO BE GREATER THAN THIS AND DAYS SUPPLY * REFILLS NEEDS TO BE GREATER THAN THIS ADDED TO ISSUE DATE
 S Z=0,G="" F  S Z=$O(^PS(55,P,"P",Z)) Q:Z'=+Z!(G="X")  D
 .S R=$P(^PS(55,P,"P",Z,0),U,1)
 .Q:'$D(^PSRX(R,0))  ;bad xref
 .Q:$E($P(^PSRX(R,0),U,1))'="X"  ;not an external med
 .S D=$P(^PSRX(R,0),U,6)
 .Q:'D  ;no drug??
 .Q:'$D(^ATXAX(TAX,21,"B",D))  ;not a drug we care about
 .S E=$P($G(^PSRX(R,2)),U,6)
 .I E,E<BDMD Q  ;expires too soon
 .S Y=$P(^PSRX(R,0),U,8)  ;DAYS SUPPLY
 .S F=$P(^PSRX(R,0),U,9)  ;# REFILLS
 .S T=Y*(F+1)  ;total days supply
 .S I=$P(^PSRX(R,0),U,13)  ;ISSUE DATE
 .Q:I>ED  ;issued after audit year
 .Q:$$FMADD^XLFDT(I,T)<BDMD  ;days supply doesn't get to date
 .S G="X"
 I G]"" Q G
 ;NOW CHECK FOR E H R OUTSIDE MED IN V MED IN PAST 10 YEARS
EHROUT ;
 ;any EHR outside meds?
 K BDMMEDS1 S K=0,R=""
 S X=P_"^ALL MEDS ["_$P(^ATXAX(TAX,0),U,1)_";DURING "_$$FMADD^XLFDT(ED,-3650)_"-"_ED S E=$$START1^APCLDF(X,"BDMMEDS1(")
 I '$D(BDMMEDS1) Q ""
 S X=0 F  S X=$O(BDMMEDS1(X)) Q:X'=+X!(R]"")  S Y=+$P(BDMMEDS1(X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .Q:$P($G(^AUPNVMED(Y,11)),U,8)=""  ;NOT AN EHR OUTSIDE MED
 .Q:$$UP^XLFSTR($P($G(^AUPNVMED(Y,11)),U))["RETURNED TO STOCK"
 .S %=$P(^AUPNVMED(Y,0),U,8)  ;discontinued date
 .I %]"",%<$$FMADD^XLFDT($$FMADD^XLFDT(ED,-186)) Q  ;if discontinued before 6M of report period
 .S V=$P(^AUPNVMED(Y,0),U,3)
 .Q:'V
 .Q:'$D(^AUPNVSIT(V,0))
 .S R="X"  ;1_U_"Statin: "_$$DATE^BGP8UTL($P($P(^AUPNVSIT(V,0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,Y,.01)_" (EHR OUTSIDE)"
 Q R
PRESD(P,TAX,ED,DAYS) ;EP
 ;GO THROUGH 52 FOR PATIENT
 NEW BDMD,G,Z,R,D,E,T,F,I
 S BDMD=$$FMADD^XLFDT(ED,-DAYS) ;DATE OF EXPIRATION NEEDS TO BE GREATER THAN THIS AND DAYS SUPPLY * REFILLS NEEDS TO BE GREATER THAN THIS ADDED TO ISSUE DATE
 S Z=0,G="" F  S Z=$O(^PS(55,P,"P",Z)) Q:Z'=+Z!(G)  D
 .S R=$P(^PS(55,P,"P",Z,0),U,1)
 .Q:'$D(^PSRX(R,0))  ;bad xref
 .Q:$E($P(^PSRX(R,0),U,1))'="X"  ;not an external med
 .S D=$P(^PSRX(R,0),U,6)
 .Q:'D  ;no drug??
 .Q:'$D(^ATXAX(TAX,21,"B",D))  ;not a drug we care about
 .S E=$P($G(^PSRX(R,2)),U,6)
 .I E,E<BDMD Q  ;expires too soon
 .S Y=$P(^PSRX(R,0),U,8)  ;DAYS SUPPLY
 .S F=$P(^PSRX(R,0),U,9)  ;# REFILLS
 .S T=Y*(F+1)  ;total days supply
 .S I=$P(^PSRX(R,0),U,13)  ;ISSUE DATE
 .Q:I>ED
 .Q:$$FMADD^XLFDT(I,T)<BDMD  ;days supply doesn't get to date
 .S G="1  Yes  "_$$DATE^BDMS9B1(I)_" "_$E($P(^PSDRUG(D,0),U,1),1,30)_"("_T_" days supply)"
 I $E(G)=1 Q G
EHROUTD ;
 ;any EHR outside meds?
 K BDMMEDS1 S K=0,R=""
 S X=P_"^ALL MEDS ["_$P(^ATXAX(TAX,0),U,1)_";DURING "_$$FMADD^XLFDT(ED,-3650)_"-"_ED S E=$$START1^APCLDF(X,"BDMMEDS1(")
 I '$D(BDMMEDS1) Q ""
 S X=0 F  S X=$O(BDMMEDS1(X)) Q:X'=+X!(R]"")  S Y=+$P(BDMMEDS1(X),U,4) D
 .Q:'$D(^AUPNVMED(Y,0))
 .Q:$P($G(^AUPNVMED(Y,11)),U,8)=""  ;NOT AN EHR OUTSIDE MED
 .Q:$$UP^XLFSTR($P($G(^AUPNVMED(Y,11)),U))["RETURNED TO STOCK"
 .S %=$P(^AUPNVMED(Y,0),U,8)  ;discontinued date
 .I %]"",%<$$FMADD^XLFDT($$FMADD^XLFDT(ED,-186)) Q  ;if discontinued before 6M of report period
 .S V=$P(^AUPNVMED(Y,0),U,3)
 .Q:'V
 .Q:'$D(^AUPNVSIT(V,0))
 .S D=$P(^AUPNVMED(Y,0),U,1)
 .S R="1  Yes  "_$$DATE^BDMS9B1($$VD^APCLV(V))_" "_$E($P(^PSDRUG(D,0),U,1),1,30)_" (EHR OUTSIDE)"
 Q R
