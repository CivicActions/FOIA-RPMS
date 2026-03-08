BIUTL13 ;IHS/CMI/MWR - UTIL: PATIENT INFO; AUG 10,2010
 ;;8.5;IMMUNIZATION;**26**;OCT 24,2011;Build 33
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
REFUSAL(BIDFN,A,BIDATE) ;EP
 ;REFUSALS FROM NMI
 ;IHS/CMI/LAB - PATCH 26 add refusals from NMI file called from reports
 ;first get BI
 NEW %,Z,I,D,N,X,I,BIPC
 K A
 S N=0 F  S N=$O(^BIPC("B",BIDFN,N)) Q:'N  D
 .;---> If bad xref, kill it and quit.
 .I '$D(^BIPC(N,0)) K ^BIPC("B",BIDFN,N) Q
 .;---> BIPC=zero node of a Patient's Contraindication.
 .S BIPC=^BIPC(N,0)
 .;---> Set X=Reason pointer (to ^BICONT), Y=Date of Contraindication.
 .S X=$P(BIPC,U,3),Y=$P(BIPC,U,4)
 .;---> If the call is to return an array of Refusals, do so and quit.=
 .I (X=11)!(X=16) D
 ..S Z=$P(BIPC,U,2) I Z S Z=$G(^AUTTIMM(Z,0)),Z=$P(Z,U,3)
 ..I Z S A(Z)=X S:$G(BIDATE) A(Z)=A(Z)_U_Y
 ..Q
 .Q
NMI ;now nmi file refusals
 S %=0 F  S %=$O(^AUPNPREF("AA",BIDFN,9999999.14,%)) Q:%'=+%  D
 .S D=0 F  S D=$O(^AUPNPREF("AA",BIDFN,9999999.14,%,D)) Q:D'=+D  D
 ..S I=0 F  S I=$O(^AUPNPREF("AA",BIDFN,9999999.14,%,D,I)) Q:I'=+I  D
 ...Q:'$$REF(I)  ;not a refusal so skip
 ...S Z=$$VAL^XBDIQ1(9999999.14,%,.03)  ;get cvx code
 ...I Z S A(Z)=11 S:$G(BIDATE) A(Z)=A(Z)_U_$P($P(^AUPNPREF(I,0),U,3),".")
 Q
 ;
REF(E) ;EP is this a refusal
 ;Suryam email on 01/23/23 used 5 SNOMED code fro 1.01
 I $$VAL^XBDIQ1(9000022,E,.07)="R" Q 1
 NEW C
 S C=$$VAL^XBDIQ1(9000022,E,1.01)
 I C="443390004" Q 1
 I C="309846006" Q 1
 I C="385661002" Q 1
 I C="107724000" Q 1
 I C="419808006" Q 1
 Q 0
