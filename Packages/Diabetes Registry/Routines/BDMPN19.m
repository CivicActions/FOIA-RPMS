BDMPN19 ; IHS/CMI/LAB - 2003 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**17**;JUN 14, 2007;Build 138
 ;
 ;
 W:$D(IOF) @IOF
 W !!,"Checking for Taxonomies to support the 2024 Prediabetes Assessment of Care ",!,"Report.  Please enter the device for printing.",!
ZIS ;
 S XBRC="",XBRP="TAXCHK^BDMPN19",XBNS="",XBRX="XIT^BDMPN19"
 D ^XBDBQUE
 D XIT
 Q
TAXCHK ;EP - called by gui
 ;D HOME^%ZIS
 K BDMQUIT
GUICHK ;EP
 NEW A,BDMX,I,Y,Z,J,BDMY,BDMT
 K A
 S BDMYR=$O(^BDMTAXS("B",2024,0))
 S BDMT=0 F  S BDMT=$O(^BDMTAXS(BDMYR,11,BDMT)) Q:BDMT'=+BDMT  D
 .S BDMY=$G(^BDMTAXS(BDMYR,11,BDMT,0))
 .Q:'$P(^BDMTAXS(BDMYR,11,BDMT,0),U,7)
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
 W !!,"In order for the 2024 Prediabetes Assessment of Care Report to find ",!,"all necessary data, several taxonomies must be established.  The following",!,"taxonomies are missing or have no entries:",!
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
