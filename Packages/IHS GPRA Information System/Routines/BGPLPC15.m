BGPLPC15 ; IHS/CMI/LAB - measure I2 ; 02 Feb 2019  11:25 AM
 ;;19.1;IHS CLINICAL REPORTING;**1**;MAY 30, 2019;Build 7
 ;
WAC ;EP
 S (BGPN1,BGPN2,BGPN3,BGPD1)=0
 S (BGPDV,BGPVITAL,BGPNC,BGPPA)=""
 S BGPVALUE=""
 K BGPV
 ;
 I BGPAGEB<3 S BGPSTOP=1 G WACE  ;3 or greater during time period
 I BGPAGEB>16 S BGPSTOP=1 G WACE  ;16 or less during time period
 ;
 ;S BGPDV=$$ENC15(DFN,BGPBDATE,BGPEDATE) I BGPDV="" S BGPSTOP=1 G WACE
 ;GET ALL OUTPATIENT ENCOUNTERS
 ;Let's check all Visits, looping through once
 S G=""  ;return variable
 ;get all visits in date range in BGPV
 D ALLV^APCLAPIU(DFN,BGPBDATE,BGPEDATE,"BGPV")
 ;now loop through and check Face to Face and .17 in visit and check v cpts attached to the visit
 K BGPOV
 S X=0 F  S X=$O(BGPV(X)) Q:X'=+X  S V=$P(BGPV(X),U,5)  D
 .Q:'$P(^AUPNVSIT(V,0),U,9)  ;no dependent entries
 .Q:$P(^AUPNVSIT(V,0),U,11)  ;deleted
 .S D=$$VD^APCLV(V)
 .S Y=$$SNOMEDV(V) I Y]"" S G=1_U_$$DATE^BGPLUTL(D)_" SNOMED: "_Y,BGPOV(V)="" Q
 .;is .17 a cpt we want?
 .S Y=$$VALI^XBDIQ1(9000010,V,.17)
 .I Y,$$OFFCPT15(Y) S G=1_U_$$DATE^BGPLUTL(D)_" CPT: "_$P($$CPT^ICPTCOD(Y),U,2),BGPOV(V)="" Q
 .;now check all V CPTs
 .S Z=0 F  S Z=$O(^AUPNVCPT("AD",V,Z)) Q:Z'=+Z  D
 ..S Y=$P($G(^AUPNVCPT(Z,0)),U,1)
 ..I Y,$$OFFCPT15(Y) S G=1_U_$$DATE^BGPLUTL(D)_" CPT: "_$P($$CPT^ICPTCOD(Y),U,2),BGPOV(V)="" Q
 I G S BGPDV=G
 I BGPDV="" S BGPSTOP=1 G WACE
 ;now what about exclusions?
 I $$HOSPIND^BGPLPC2(DFN,BGPBDATE,BGPEDATE) S BGPSTOP=1 G WACE  ;no hospice pts
 ;PREG?
 I $$PREG^BGPLPC16(DFN,BGPBDATE,BGPEDATE) S BGPSTOP=1 G WACE
 ;
 S BGPD1=1
 ;
 S BGPVAL=""
 S BGPVITAL=$$HWBMIP(DFN,BGPBDATE,BGPEDATE) I $P(BGPVITAL,U,1) S BGPN1=1
 D NC
 I $P(BGPNC,U,1) S BGPN2=1
 D PA
 I $P(BGPPA,U,1) S BGPN3=1
 S BGPVALUE=""
 ;S BGPVALUE="ENC "_$P(BGPDV,U,2)_"|||"  ;hit denominator
 I BGPN1 S BGPVALUE=BGPVALUE_"***N1 "_$P(BGPVITAL,U,2)
 I BGPN2 S:BGPVALUE]"" BGPVALUE=BGPVALUE_";" S BGPVALUE=BGPVALUE_"***N2 NUTR COUN: "_$P(BGPNC,U,2)
 I BGPN3 S:BGPVALUE]"" BGPVALUE=BGPVALUE_";" S BGPVALUE=BGPVALUE_"***N3 PHYS ACT COUN: "_$P(BGPPA,U,2)
 S BGPVALUE="ENC "_$P(BGPDV,U,2)_"|||"_BGPVALUE
 ;
WACE ;
 K V,BGPDV,BGPVAL,BGPV,BGPOV,BGPVITAL,BGPNC,BGPPA
 Q
ENC15(P,BDATE,EDATE) ;EP  - have encounter per CMS122v6
 NEW X,Y,Z,G,BGPV,D
 ;Let's check all Visits, looping through once
 S G=""  ;return variable
 ;get all visits in date range in BGPV
 D ALLV^APCLAPIU(P,BDATE,EDATE,"BGPV")
 ;now loop through and check Face to Face and .17 in visit and check v cpts attached to the visit
 S X=0 F  S X=$O(BGPV(X)) Q:X'=+X!(G)  S V=$P(BGPV(X),U,5)  D
 .Q:'$P(^AUPNVSIT(V,0),U,9)  ;no dependent entries
 .Q:$P(^AUPNVSIT(V,0),U,11)  ;deleted
 .Q:"AORS"'[$P(^AUPNVSIT(V,0),U,7)  ;outpatient only
 .S D=$$VD^APCLV(V)
 .S Y=$$FTOF^BGPLPC2(V) I Y]"" S G=1_U_$$DATE^BGPLUTL(D)_" FTOF: "_Y Q
 .;is .17 a cpt we want?
 .S Y=$$VALI^XBDIQ1(9000010,V,.17)
 .I Y,$$OFFCPT15(Y) S G=1_U_$$DATE^BGPLUTL(D)_" CPT: "_$P($$CPT^ICPTCOD(Y),U,2) Q
 .;now check all V CPTs
 .S Z=0 F  S Z=$O(^AUPNVCPT("AD",V,Z)) Q:Z'=+Z!(G)  D
 ..S Y=$P($G(^AUPNVCPT(Z,0)),U,1)
 ..I Y,$$OFFCPT15(Y) S G=1_U_$$DATE^BGPLUTL(D)_" CPT: "_$P($$CPT^ICPTCOD(Y),U,2) Q
 Q G
SNOMEDV(V) ;EP
 NEW A,B,C
 S A=0,B=""
 F  S A=$O(^AUPNVSIT(V,28,"B",A)) Q:A=""!(B]"")  D
 .I $D(^XTMP("BGPSNOMEDSUBSET",$J,"PXRM BGP IPC OFFICE VISIT",A)) S B=A_" OFF VISIT" Q
 .I $D(^XTMP("BGPSNOMEDSUBSET",$J,"PXRM BGP IPC HOME HEALTH",A)) S B=A_" HOME HEALTH" Q
 I B]"" Q B
 S A=0,B=""
 F  S A=$O(^AUPNVSIT(V,26,"B",A)) Q:A=""!(B]"")  D
 .I $D(^XTMP("BGPSNOMEDSUBSET",$J,"PXRM BGP IPC OFFICE VISIT",A)) S B=A_" OFF VISIT" Q
 .I $D(^XTMP("BGPSNOMEDSUBSET",$J,"PXRM BGP IPC HOME HEALTH",A)) S B=A_" HOME HEALTH" Q
 Q B
OFFCPT15(C) ;EP
 I $$ICD^ATXAPI(C,$O(^ATXAX("B","BGP IPC OFFICE VISIT CPTS",0)),1) Q 1
 I $$ICD^ATXAPI(C,$O(^ATXAX("B","BGP IPC PREVCARE EOV 0-17 CPTS",0)),1) Q 1
 I $$ICD^ATXAPI(C,$O(^ATXAX("B","BGP IPC PREVCARE IOV 0-17 CPTS",0)),1) Q 1
 I $$ICD^ATXAPI(C,$O(^ATXAX("B","BGP IPC HOMEHEALTH VISIT CPTS",0)),1) Q 1
 I $$ICD^ATXAPI(C,$O(^ATXAX("B","BGP IPC PREVCARE IND COUN CPTS",0)),1) Q 1
 I $$ICD^ATXAPI(C,$O(^ATXAX("B","BGP IPC PREVCARE GRP COUN CPTS",0)),1) Q 1
 Q ""
LOINC(A,B) ;EP
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
HWBMIP(P,BDATE,EDATE) ;
 ;has ht, wt and bmip?
 NEW X,Y,Z,H,W,B
 S W=$$LASTITEM^BGPLDU(P,BDATE,EDATE,"MEASUREMENT","WT") I W="" Q ""
 S H=$$LASTITEM^BGPLDU(P,BDATE,EDATE,"MEASUREMENT","HT") I H="" Q ""
 S B=$$LASTITEM^BGPLDU(P,BDATE,EDATE,"MEASUREMENT","BMIP") I B="" Q ""
 Q 1_U_$$DATE^BGPLUTL($P(H,U,2))_" HT "_$P(H,U,4)_" "_$$DATE^BGPLUTL($P(W,U,2))_" WT "_$P(W,U,4)_" "_$$DATE^BGPLUTL($P(B,U,2))_" BMIP "_$P(B,U,4)
NC ;
 S BGPNC=""
 NEW X,Y,Z,V,G
 S G=""
 S V=0 F  S V=$O(BGPOV(V)) Q:V'=+V!(G)  D
 .;cpt
 .S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(G)  D
 ..S C=$P($G(^AUPNVCPT(X,0)),U,1)
 ..I 'C Q
 ..I $$ICD^BGPLUTL2(C,$O(^ATXAX("B","BGP IPC NUTR COUN CPTS",0)),1) S G=1_U_$$DATE^BGPLUTL($$VD^APCLV(V))_" CPT: "_$$VAL^XBDIQ1(9000010.18,X,.01)
 .;NOW CHECK V POV FOR SNOMED
 .S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!(G)  D
 ..S C=$$VAL^XBDIQ1(9000010.07,X,1101) Q:C=""
 ..I $D(^XTMP("BGPSNOMEDSUBSET",$J,"PXRM BGP IPC NUTRITION",C)) S G=1_U_$$DATE^BGPLUTL($$VD^APCLV(V))_" SNOMED: "_C
 .;PATIENT ED
 .S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X!(G)  D
 ..S T=$$VALI^XBDIQ1(9000010.16,X,.01)
 ..Q:'T
 ..S T=$P($G(^AUTTEDT(T,0)),U,2)
 ..I $P(T,"-",2)="DT"!($P(T,"-",2)="N")!($P(T,"-",2)="MNT")!($P(T,"-")="97802")!($P(T,"-")="97803")!($P(T,"-")="97804") S G=1_U_$$DATE^BGPLUTL($$VD^APCLV(V))_U_"Pt Ed: "_T Q
 S BGPNC=G
 Q
PA ;
 S BGPPA=""
 NEW X,Y,Z,V,G
 S G=""
 S V=0 F  S V=$O(BGPOV(V)) Q:V'=+V!(G)  D
 .;NOW CHECK V POV FOR SNOMED
 .S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X!(G)  D
 ..S C=$$VAL^XBDIQ1(9000010.07,X,1101) Q:C=""
 ..I $D(^XTMP("BGPSNOMEDSUBSET",$J,"PXRM BGP IPC PHYS ACT",C)) S G=1_U_$$DATE^BGPLUTL($$VD^APCLV(V))_" SNOMED: "_C
 .;PATIENT ED
 .S X=0 F  S X=$O(^AUPNVPED("AD",V,X)) Q:X'=+X!(G)  D
 ..S T=$$VALI^XBDIQ1(9000010.16,X,.01)
 ..Q:'T
 ..S T=$P($G(^AUTTEDT(T,0)),U,2)
 ..I $P(T,"-",2)="EX"!($P(T,"-")="Z71.89") S G=1_U_$$DATE^BGPLUTL($$VD^APCLV(V))_U_"Pt Ed: "_T Q
 S BGPPA=G
 Q
