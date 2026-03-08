BDMDJ19 ; IHS/CMI/LAB - 2022 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**15**;JUN 14, 2007;Build 95
 ;
 ;
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the 2022 Audit. ",!,"Please enter the device for printing.",!
ZIS ;
 S XBRC="",XBRP="TAXCHK^BDMDJ19",XBNS="",XBRX="XIT^BDMDJ19"
 D ^XBDBQUE
 D XIT
 Q
TAXCHK ;EP - called by gui
 ;D HOME^%ZIS
 K BDMQUIT
GUICHK ;EP
 NEW A,BDMX,I,Y,Z,J,BDMY,BDMT
 K A
 S BDMYR=$O(^BDMTAXS("B",2022,0))
 S BDMT=0 F  S BDMT=$O(^BDMTAXS(BDMYR,11,BDMT)) Q:BDMT'=+BDMT  D
 .S BDMY=$G(^BDMTAXS(BDMYR,11,BDMT,0))
 .I '$G(BDMIPRE) Q:'$P(^BDMTAXS(BDMYR,11,BDMT,0),U,6)
 .I $G(BDMIPRE) Q:'$P(^BDMTAXS(BDMYR,11,BDMT,0),U,7)
 .S BDMTN=$P(BDMY,U,1)
 .S BDMFILE=$P(BDMY,U,2)
 .Q:BDMFILE=""
 .Q:'$D(^DIC(BDMFILE,0))
 .S BDMTYPE=$P(^DIC($P(BDMY,U,2),0),U)
 .S Y=BDMTYPE_" taxonomy "
 .I BDMFILE'=60 D
 ..I '$D(^ATXAX("B",BDMTN)) S A(BDMTN)=Y_"^is Missing" Q
 ..S I=$O(^ATXAX("B",BDMTN,0))
 ..I '$D(^ATXAX(I,21,"B")) S A(BDMTN)=Y_"^has no entries "
 .I BDMFILE=60 D
 ..I '$D(^ATXLAB("B",BDMTN)) S A(BDMTN)=Y_"^is Missing " Q
 ..S I=$O(^ATXLAB("B",BDMTN,0))
 ..I '$D(^ATXLAB(I,21,"B")) S A(BDMTN)=Y_"^has no entries "
 ..;check for panels and warn
 ..I '$P(^ATXLAB(I,0),U,11) D
 ...S BDMY=0 F  S BDMY=$O(^ATXLAB(I,21,"B",BDMY)) Q:BDMY'=+BDMY  D
 ....I $O(^LAB(60,BDMY,2,0)) S A(BDMTN)=Y_"^contains a panel test: "_$P(^LAB(60,BDMY,0),U)_" and should not."
 I '$D(A) W !,"All taxonomies are present.",! K A,BDMX,BDMT,BDMY,Y,I,Z D DONE Q
 W !!,"In order for the 2022 DM AUDIT Report to find all necessary data, several",!,"taxonomies must be established.  The following taxonomies are missing or have",!,"no entries:"
 S BDMX="" F  S BDMX=$O(A(BDMX)) Q:BDMX=""!($D(BDMQUIT))  D
 .;I $Y>(IOSL-2) D PAGE Q:$D(BDMQUIT)
 .W !,$P(A(BDMX),U)," [",BDMX,"] ",$P(A(BDMX),U,2)
 .Q
DONE ;
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of taxonomy check.  HIT RETURN" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
XIT ;EP
 K BDM,BDMX,BDMQUIT,BDMLINE,BDMJ,BDMX,BDMTEXT,BDM
 K X,Y,J
 Q
LASTHF(P,C,BDATE,EDATE,F) ;EP - get last factor in category C for patient P
 I '$G(P) Q ""
 I $G(C)="" Q ""
 I $G(F)="" S F=""
 S C=$O(^AUTTHF("B",C,0)) ;ien of category passed
 I '$G(C) Q ""
 NEW H,D,O S H=0 K O
 F  S H=$O(^AUTTHF("AC",C,H))  Q:'+H  D
 .  Q:'$D(^AUPNVHF("AA",P,H))
 .  S D="" F  S D=$O(^AUPNVHF("AA",P,H,D)) Q:D'=+D  D
 .. Q:(9999999-D)>EDATE  ;after time frame
 .. Q:(9999999-D)<BDATE  ;before time frame
 .. S O(D)=$O(^AUPNVHF("AA",P,H,D,""))
 .  Q
 S D=$O(O(0))
 I D="" Q D
 I F="F" Q $P(^AUTTHF($P(^AUPNVHF(O(D),0),U),0),U)
 ;
 Q 1
 ;;
BANNER ;EP - banner for 2014 audit menu
 S BDMTEXT="TEXTD",BDM("VERSION")="2.0 (Patch 13)"
 F BDMJ=1:1 S BDMX=$T(@BDMTEXT+BDMJ),BDMX=$P(BDMX,";;",2) Q:BDMX="QUIT"!(BDMX="")  S BDMLINE=BDMJ
PRINT D ^XBCLS W:$D(IOF) @IOF
 F BDMJ=1:1:BDMLINE S BDMX=$T(@BDMTEXT+BDMJ),BDMX=$P(BDMX,";;",2) W !?80-$L(BDMX)\2,BDMX K BDMX
 W !?80-(8+$L(BDM("VERSION")))/2,"Version ",BDM("VERSION")
  G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S BDM("SITE")=$P(^DIC(4,$S($G(BDMDUZ2):BDMDUZ2,1:DUZ(2)),0),"^") W !!?80-$L(BDM("SITE"))\2,BDM("SITE")
 D XIT
 Q
TEXTD ;EP
 ;;****************************************
 ;;**     DIABETES MANAGEMENT SYSTEM     **
 ;;**   2022 Diabetes Audit Report Menu  **
 ;;****************************************
 ;;QUIT
PAGE ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT="" Q
 Q
BMIEPI(H,W) ;EP ;
 NEW %
 I H="" Q ""
 I W="" Q ""
 I 'H Q ""
 ;S W=W*.45359,H=(H*.0254),H=(H*H),%=(W/H),%=$J(%,4,1)
 S H=H*H,%=W/H,%=%*703,%=$$STRIP^XLFSTR($J(%,5,1)," ")
 Q %
SHINGRIX(P,BDATE,EDATE,NR) ;EP
 NEW BGPOPNU,BGPG,X,E,R,BD,ED,G,%,BGPX,BGPSHIN,RED,RBD
 S BGPOPNU=""
 S BD=BDATE
 S ED=EDATE
 S EDATE=$$FMTE^XLFDT(EDATE)
 S BDATE=$$FMTE^XLFDT(BDATE)
 ;get all immunizations
 S C="187"
 D GETIMMS^BGP7D32(P,ED,C,.BGPX)
 ;go through and set into array if 60 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPSHIN(X)=""
 ;now get cpts
 S RED=9999999-ED,RBD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S RED=$O(^AUPNVSIT("AA",P,RED)) Q:RED=""!($P(RED,".")>RBD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,RED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) I $$ICD^ATXAPI(Y,$O(^ATXAX("B","BGP ZOSTER SHINGRIX CPTS",0)),1) S BGPSHIN(9999999-$P(RED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) I $$ICD^ATXAPI(Y,$O(^ATXAX("B","BGP ZOSTER SHINGRIX CPTS",0)),1) S BGPSHIN(9999999-$P(RED,"."))=""
 ;now check to see if they are all spaced days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPSHIN(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<56 K BGPSHIN(X) Q
 .S Y=X
 ;now count them and see if there are 2 of them
 S BGPSHIN=0,X=0 F  S X=$O(BGPSHIN(X)) Q:X'=+X  S BGPSHIN=BGPSHIN+1
 I BGPSHIN>1 Q "1  Yes"_U_1
 I $G(NR) Q "2  No"
 ;CONTRA/REFUSAL
 ;LOOK FOR CONTRAINDICATION FIRST
 K BDMREF
 S S(187)=""
 S G="",Z="" F  S Z=$O(S(Z)) Q:Z=""  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S S=$P(^BIPC(X,0),U,3)
 .Q:S=""
 .Q:'$D(^BICONT(S,0))
 .Q:$P(^BICONT(S,0),U,1)["Refusal"
 .S T=$P(^BIPC(X,0),U,4)
 .Q:T=""
 .S BDMREF(9999999-T)=1_U_$$DATE^BDMS9B1(T)_U_$$VAL^XBDIQ1(9002084.11,X,.03)
 ;NMI, PROV DISCONTINUED, CONSIDERED AND NOT DONE 
 S BDMCVX="",G="" F  S BDMCVX=$O(S(BDMCVX)) Q:BDMCVX=""  D
 .S G=$$REFUSAL^BDMDJ17(P,9999999.14,$O(^AUTTIMM("C",BDMCVX,0)),$$DOB^AUPNPAT(P),DT,"N")
 .I G I '$D(BDMREF(9999999-$P(G,U,7))) S BDMREF((9999999-$P(G,U,7)))=1_U_$P(G,U,3)_U_$P(G,U,5)
 .S G=$$REFUSAL^BDMDJ17(P,9999999.14,$O(^AUTTIMM("C",BDMCVX,0)),$$DOB^AUPNPAT(P),DT,"P")
 .I G I '$D(BDMREF(9999999-$P(G,U,7))) S BDMREF((9999999-$P(G,U,7)))=1_U_$P(G,U,3)_U_$P(G,U,5)
 .S G=$$REFUSAL^BDMDJ17(P,9999999.14,$O(^AUTTIMM("C",BDMCVX,0)),$$DOB^AUPNPAT(P),DT,"U")
 .I G I '$D(BDMREF(9999999-$P(G,U,7))) S BDMREF((9999999-$P(G,U,7)))=1_U_$P(G,U,3)_U_$P(G,U,5)
 S X=$O(BDMREF(0)) I X Q "  Contraindication: "_$P(BDMREF(X),U,3)_" "_$P(BDMREF(X),U,2)
 ;NOW CHECK REFUSAL IN PAST YEAR ONLY
 S BD=$$FMADD^XLFDT(DT,-365)
 S ED=DT
 S G="",Z="" F  S Z=$O(S(Z)) Q:Z=""  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S S=$P(^BIPC(X,0),U,3)
 .Q:S=""
 .Q:'$D(^BICONT(S,0))
 .Q:$P(^BICONT(S,0),U,1)'["Refusal"
 .S T=$P(^BIPC(X,0),U,4)
 .Q:T<BD
 .Q:T>ED
 .S BDMREF(9999999-T)=1_U_$$DATE^BDMS9B1(T)_U_$$VAL^XBDIQ1(9002084.11,X,.03)
 ;NMI, PROV DISCONTINUED, CONSIDERED AND NOT DONE 
 S BDMCVX="",G="" F  S BDMCVX=$O(S(BDMCVX)) Q:BDMCVX=""  D
 .S G=$$REFUSAL^BDMDJ17(P,9999999.14,$O(^AUTTIMM("C",BDMCVX,0)),BD,DT,"R")
 .I G I '$D(BDMREF(9999999-$P(G,U,7))) S BDMREF((9999999-$P(G,U,7)))=1_U_$P(G,U,3)_U_$P(G,U,5)
 S X=$O(BDMREF(0)) I X Q $P(BDMREF(X),U,3)_" "_$P(BDMREF(X),U,2)
 Q "2  No"
ANIMCONT(P,C,ED) ;EP - ANApHYLAXIS/IMMUNE CONTRAINDICATION
 NEW X,Y,R,D,G
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .;Q:$P(^BIPC(X,0),U,4)<BD
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G=D_U_"Contra Anaphylaxis"
 .I $P(^BICONT(R,0),U,1)="Immune Deficiency" S G=D_U_"Contra: Immune Deficiency"
 .;I $P(^BICONT(R,0),U,1)["Immune Deficient" S G=D_U_"Contra: Immune Deficient"
 Q G
