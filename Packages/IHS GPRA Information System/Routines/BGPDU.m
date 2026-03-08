BGPDU ; IHS/CMI/LAB - gpra utility calls ;  [ 07/25/02  12:45 PM ]
 ;;1.0;IHS GPRA REPORTING;**1**;JUN 12, 2002
 ;
 ;
WH(P,BDATE,EDATE,T,F) ;EP
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through procedures in a date range for this patient, check proc type
 NEW D,X,Y,G,V
 S (G,V)=0 F  S V=$O(^BWPCD("C",P,V)) Q:V=""!(G)  D
 .Q:'$D(^BWPCD(V,0))
 .I $P(^BWPCD(V,0),U,4)'=T Q
 .S D=$P(^BWPCD(V,0),U,12)
 .Q:D<BDATE
 .Q:D>EDATE
 .S G=1
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S D=$P(^BWPCD(G,0),U,12) Q D
 I F=4 S D=$P(^BWPCD(G,0),U,12) Q $$FMTE^XLFDT(D)
 Q ""
CPT(P,BDATE,EDATE,T,F) ;EP - return ien of CPT entry if patient had this CPT
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(F) S F=1
 I $G(EDATE)="" Q ""
 I $G(BDATE)="" S BDATE=$$FMADD^XLFDT(EDATE,-365)
 ;go through visits in a date range for this patient, check cpts
 NEW D,BD,ED,X,Y,D,G,V
 S ED=9999999-EDATE,BD=9999999-BDATE,G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V!(G)  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(G)  D
 ...I $$ICD^ATXCHK($P(^AUPNVCPT(X,0),U),T,1) S G=X
 ...Q
 ..Q
 .Q
 I 'G Q ""
 I F=1 Q $S(G:1,1:"")
 I F=2 Q G
 I F=3 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $P($P($G(^AUPNVSIT(V,0)),U),".")
 I F=4 S V=$P(^AUPNVCPT(G,0),U,3) I V Q $$FMTE^XLFDT($P($P($G(^AUPNVSIT(V,0)),U),"."))
 Q ""
CPTI(P,BDATE,EDATE,CPTI) ;EP - did patient have this cpt (ien) in date range
 I '$G(P) Q ""
 I $G(CPTI)="" Q ""
 I $G(BDATE)="" Q ""
 I $G(EDATE)="" Q ""
 I '$D(^AUPNVCPT(CPTI)) Q ""
 I '$D(^AUPNVCPT("AA",P)) Q ""  ;no cpts for this patient
 NEW D,BD,ED,X,Y,D,G,V
 S ED=9999999-EDATE-1,BD=9999999-BDATE,G=""
 F  S ED=$O(^AUPNVCPT("AA",P,CPTI,ED)) Q:ED=""!($P(ED,".")>BD)!(G)  S G=1
 Q G
BANNER ;EP
V ; GET VERSION
 S BGP("VERSION")="1.0  April, 2002"
 S BGPTEXT="TEXT",BGPLINE=3 G PRINT
 F BGPJ=1:1 S BGPX=$T(@BGPTEXT+BGPJ),BGPX=$P(BGPX,";;",2) Q:BGPX="QUIT"!(BGPX="")  S BGPLINE=BGPJ
PRINT W:$D(IOF) @IOF
 F BGPJ=1:1:BGPLINE S BGPX=$T(@BGPTEXT+BGPJ),BGPX=$P(BGPX,";;",2) W !?80-$L(BGPX)\2,BGPX K BGPX
 W !?80-(8+$L(BGP("VERSION")))/2,"Version ",BGP("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S BGP("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(BGP("SITE"))\2,BGP("SITE")
XIT ;
 K BGPJ,BGPX,BGPTEXT,BGPLINE,BGP("SITE"),BGP("VERSION")
 Q
TEXT ;
 ;;*******************************************************
 ;;** Indian Health Service GPRA Data Reporting System  **
 ;;*******************************************************
 ;;QUIT
SIGCPTS ;;
 ;;45330
 ;;45331
 ;;45332
 ;;45333
 ;;45334
 ;;45336
 ;;45337
 ;;45338
 ;;45339
 ;;45341
 ;;45342
 ;;45345
 ;;
COLOCPTS ;;
 ;;45355
 ;;45360
 ;;45361
 ;;45362
 ;;45363
 ;;45364
 ;;45365
 ;;45366
 ;;45367
 ;;45368
 ;;45369
 ;;45370
 ;;45371
 ;;45372
 ;;45378
 ;;45379
 ;;45380
 ;;45382
 ;;45383
 ;;45384
 ;;45385
 ;;45387
 ;;
