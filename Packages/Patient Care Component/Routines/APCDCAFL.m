APCDCAFL ; IHS/CMI/LAB - ; 28 Sep 2021  8:49 AM
 ;;2.0;IHS PCC SUITE;**2,5,11,16,26**;MAY 14, 2009;Build 48
 ;
START ;
 D XIT
 I '$D(IOF) D HOME^%ZIS
 D TERM^VALM0
 W @(IOF),!!
 D INFORM
 I $P(^APCCCTRL(DUZ(2),0),U,12)="" W !!,"The EHR/PCC Coding Audit Start Date has not been set",!,"in the PCC Master Control file." D  D XIT Q
 .W !!,"Please see your Clinical Coordinator or PCC Manager."
 .S DIR(0)="E",DIR("A")="Press Enter" KILL DA D ^DIR KILL DIR
 .Q
 ;
VD ;
 S (APCDBD,APCDED)=""
DATES ;K APCDED,APCDBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Resolved Date"
 D ^DIR G:Y<1 XIT S APCDBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Resolved Date"
 D ^DIR G:Y<1 VD  S APCDED=Y
 ;
 I APCDED<APCDBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 ;
PROV ;
 K APCDQ
 S APCDPRVT=""
 K APCDPRVS
 S DIR(0)="S^A:ALL Providers;S:Selected set or Taxonomy of Providers;O:ONE Provider",DIR("A")="Include Which Providers",DIR("B")="A"
 S DIR("A")="Enter a code indicating which providers are of interest",DIR("B")="A" K DA D ^DIR K DIR,DA
 G:$D(DIRUT) DATES
 S APCDPRVT=Y
 I APCDPRVT="A" G PROCESS
 D @(APCDPRVT_"PRV")
 G:$D(APCDQ) PROV
PROCESS ;
RTYPE ;how to sort list of visits
 S APCDRTYP=""
 S DIR(0)="S^1:Individual Provider Listings Only;2:Summary Page Only;3:Both",DIR("A")="Select Report Type",DIR("B")="3" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G PROV
 S APCDRTYP=Y
 I APCDRTYP=2 G ZIS
PAGE ;
 S APCDSPAG=0
 S DIR(0)="Y",DIR("A")="Do you want each provider's listing on a separate page",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G RTYPE
 S APCDSPAG=Y
ZIS ;call xbdbque
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to ",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) G RTYPE
 I $G(Y)="B" D BROWSE,XIT Q
 S XBRC="DRIVER^APCDCAFL",XBRP="PRINT^APCDCAFL",XBRX="XIT^APCDCAFL",XBNS="APCD"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRINT^APCDCAFL"")"
 S XBNS="APCD",XBRC="DRIVER^APCDCAFL",XBRX="XIT^APCDCAFL",XBIOP=0 D ^XBDBQUE
 Q
 ;
DRIVER ;EP entry point for taskman
 S APCDBT=$H,APCDJOB=$J
 K ^XTMP("APCDCAFL",APCDJOB,APCDBT)
 S APCDV=0 F  S APCDV=$O(^AUPNCANT(APCDV)) Q:APCDV'=+APCDV  D
 .;WAS ANY PROVIDER ON THIS VISIT?
 .S APCDPI=0,G=0 F  S APCDPI=$O(^AUPNCANT(APCDV,12,APCDPI)) Q:APCDPI'=+APCDPI!(G)  D
 ..S P=$P(^AUPNCANT(APCDV,12,APCDPI,0),U,1)
 ..Q:'P
 ..I $D(APCDPRVS),'$D(APCDPRVS(P)) Q
 ..S G=1
 .Q:'G
 .;ANY RESOLVED DEF IN THIS TIME WINDOW?
 .S APCDPI=0,APCDRES="" F  S APCDPI=$O(^AUPNCANT(APCDV,12,APCDPI)) Q:APCDPI'=+APCDPI!(APCDRES)  D
 ..S R=$P($G(^AUPNCANT(APCDV,12,APCDPI,0)),U,3)  ;date resolved
 ..I R="" Q
 ..I R<APCDBD Q
 ..I R>APCDED Q
 ..S APCDRES=1
 .Q:'APCDRES  ;nothing resolved in this time period
 .;are all resolved?
 .S APCDPI=0,APCDRES="" F  S APCDPI=$O(^AUPNCANT(APCDV,12,APCDPI)) Q:APCDPI'=+APCDPI  D
 ..S R=$P($G(^AUPNCANT(APCDV,12,APCDPI,0)),U,3)  ;date resolved
 ..I R="" S APCDRES=1 Q
 .Q:APCDRES  ;NOT ALL RESOLVED
 .;SET XTMP FOR EACH PROVIDER
 .S APCDPI=0 F  S APCDPI=$O(^AUPNCANT(APCDV,12,APCDPI)) Q:APCDPI'=+APCDPI  D
 ..S P=$P(^AUPNCANT(APCDV,12,APCDPI,0),U,1)
 ..Q:'P
 ..I $D(APCDPRVS),'$D(APCDPRVS(P)) Q
 ..Q:$D(^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV",P,APCDV))  ;already counted this visit
 ..S ^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV",P,APCDV)=""
 ..S $P(^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV","SUMMARY",P),U,1)=$P($G(^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV","SUMMARY",P)),U,1)+1
 S APCDET=$H
 Q
XIT ;
 K DIR
 D EN^XBVK("APCD")
 D ^XBFMK
 D KILL^AUPNPAT
 D EN^XBVK("AMQQ")
 Q
 ;
D(D) ;
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
CTR(X,Y) ;EP
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
INFORM ;
 W !,$$CTR($$LOC)
 W !!,$$CTR("PCC/EHR CODING AUDIT")
 W !!,"This report will list all resolved incomplete charts for a provider(s)",!,"in a date range."
 W !,"The date resolved in the chart deficiency item will be used.  All deficiencies "
 W !,"on the visit must be resolved in order to be included in this report."
 W !,"If more than one provider has a deficiency documented on the visit that visit"
 W !,"will show on both provider's reports.",!
 Q
OPRV ;one clinic
 S DIC="^VA(200,",DIC(0)="AEMQ",DIC("A")="Which PROVIDER: " D ^DIC K DIC
 I Y=-1 S APCDQ="" Q
 S APCDPRVS(+Y)=""
 Q
SPRV ;
 S X="PRIMARY PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCDPRVS(")
 I '$D(APCDPRVS) S APCDQ="" Q
 I $D(APCDPRVS("*")) S APCDPRVT="A" K APCDPRVS W !!,"**** all PROVIDERS will be included ****",! Q
 Q
 ;----------
PRINT ;EP - called from xbdbque
 S APCD80S="-------------------------------------------------------------------------------"
 S APCDPG=0
 K APCDQUIT
 D PRINT1
DONE ;
 I $D(APCDQUIT) G XIT1
 I $E(IOST)="C",IO=IO(0) S DIR(0)="E" D ^DIR K DIR
 W:$D(IOF) @IOF
XIT1 ; Clean up and exit
 K ^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV")
 D EN^XBVK("APCD")
 Q
SH ;
 W !!?10,"Resolved Charts for ",$$GET1^DIQ(200,APCDPROV,.01)
 Q
PRINT1 ;
 K APCDQUIT
 I APCDRTYP=2 G SUMPAGE
 I 'APCDSPAG D HEAD
 I '$D(^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV")) W !!,"There are no resolved charts (visits) in that time period for those providers." Q
 S APCDPROV=0 F  S APCDPROV=$O(^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV",APCDPROV)) Q:APCDPROV'=+APCDPROV!($D(APCDQUIT))  D
 .I APCDSPAG D HEAD Q:$D(APCDQUIT)  D SH
 .I 'APCDSPAG,$Y>(IOSL-3) D HEAD Q:$D(APCDQUIT)
 .I 'APCDSPAG D SH
 .S APCDV="" F  S APCDV=$O(^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV",APCDPROV,APCDV)) Q:APCDV=""!($D(APCDQUIT))  D
 ..I $Y>(IOSL-5) D HEAD Q:$D(APCDQUIT)  D SH
 ..W !,$E($$VAL^XBDIQ1(9000010,APCDV,.05),1,21)
 ..S APCDVR=^AUPNVSIT(APCDV,0) S:'$P(APCDVR,U,6) $P(APCDVR,U,6)=0
 ..S P=$P(APCDVR,U,5)
 ..S APCDHRN="" S APCDHRN=$$HRN^AUPNPAT(P,$P(APCDVR,U,6),2)
 ..S APCDHRN="" S APCDHRN=$$HRN^AUPNPAT(P,DUZ(2))
 ..W ?22,APCDHRN
 ..W ?29,$$DATE($$VALI^XBDIQ1(9000010,APCDV,.01)),?40,$P(APCDVR,U,7)
 ..S APCDC=0,APCDI=0 F  S APCDI=$O(^AUPNCANT(APCDV,12,APCDI)) Q:APCDI'=+APCDI!($D(APCDQUIT))  D
 ...S APCDC=APCDC+1
 ...I $Y>(IOSL-3) D HEAD Q:$D(APCDQUIT)  D SH
 ...I APCDC>1 W !
 ...S APCDIENS=APCDI_","_APCDV W ?43,$E($$GET1^DIQ(9000095.12,APCDIENS,.02),1,20)
 ...W ?64,$$DATE($P(^AUPNCANT(APCDV,12,APCDI,0),U,3))
 I APCDRTYP=1 Q
 I $D(APCDQUIT) Q
 D SUMPAGE
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
HEAD ;EP;HEADER
 I 'APCDPG G HEAD1
HEAD2 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W !,$$FMTE^XLFDT($$NOW^XLFDT),?40,$P(^VA(200,DUZ,0),U,2),?70,"Page: ",APCDPG
 W !,$$CTR("Confidential Patient Data Covered by Privacy Act",80)
 W !,$$CTR("Resolved Charts by Provider",80)
 W !,$$CTR("Date Range: "_$$DATE(APCDBD)_"-"_$$DATE(APCDED),80)
 I $G(APCDSUM) W !,$$CTR("SUMMARY PAGE",80)
 W !,$TR($J(" ",80)," ","-")
 I '$G(APCDSUM) W !!,"Patient",?22,"HRCN",?29,"Visit Date",?40,"SC",?43,"Deficiencies",?64,"Date Resolved"
 I $G(APCDSUM) W !!,"PROVIDER",?26,"RESOLVED CHARTS"
 W !,APCD80S
 Q
SUMPAGE ;
 S APCDSUM=1,APCDTOT=""
 D HEAD
 I '$D(^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV")) W !!,"There are no pending deficiencies that meet the report criteria." Q
 S APCDS=0 F  S APCDS=$O(^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV","SUMMARY",APCDS)) Q:APCDS'=+APCDS!($D(APCDQUIT))  D
 .I $Y>(IOSL-4) D HEAD Q:$D(APCDQUIT)
 .S S=^XTMP("APCDCAFL",APCDJOB,APCDBT,"PROV","SUMMARY",APCDS)
 .S $P(APCDTOT,U,1)=$P(APCDTOT,U,1)+$P(S,U,1)
 .;S $P(APCDTOT,U,2)=$P(APCDTOT,U,2)+$P(S,U,2)
 .W !,$E($P(^VA(200,APCDS,0),U),1,25),?27,+$P(S,U,1)
 .Q
 Q
