APCDFCPC ; IHS/CMI/LAB - QA AUDIT ON ICD CODING ;
 ;;2.0;IHS PCC SUITE;**26**;MAY 14, 2009;Build 48
 ;
START ; 
 S APCDSITE="" S:$D(DUZ(2)) APCDSITE=DUZ(2)
 I '$D(DUZ(2)) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER!!",!! K APCDSITE Q
 I 'DUZ(2) W $C(7),$C(7),!!,"SITE NOT SET IN DUZ(2) - NOTIFY SITE MANAGER",!! K APCDSITE Q
 W:$D(IOF) @IOF
 S APCDLHDR="CPT CODING AUDIT FOR SELECTED SET OF VISITS"
 W !?((80-$L(APCDLHDR))/2),APCDLHDR
 W !!,"This report will list the CPT codes for visits that you select."
 W !,"The CPT Code and CPT narrative will be displayed so that coding"
 W !,"can be reviewed."
 W !,"You will be able to select visits by the following items:"
 W !?5,"- Visit date or Date Last Modified"
 W !?5,"- Service Category"
 W !?5,"- Clinic"
 W !?5,"- Operator who last marked the visit as reviewed complete"
 W !?10,"or last modified the CPT entry"
 W !?5,"- Visits marked as Reviewed/Complete or All Visits"
 W !?10,"NOTE:  since Hospital, Telephone, Chart Review visits don't need"
 W !?10,"to be marked as reviewed/complete in the coding queue, select all"
 W !?10,"visits if you want those included."
 W !?5,"- Visit by CPT code"
 S APCDJOB=$J,APCDBT=$H
 K ^XTMP("APCDFCPC",APCDJOB,APCDBT)
DLMVD ;RUN BY DATE LAST MODIFIED OR VISIT DATE?
 S APCDSITE="" S:$D(DUZ(2)) APCDSITE=DUZ(2)
 I '$D(DUZ(2)) S APCDSITE=+^AUTTSITE(1,0)
 S DIR(0)="S^1:Date Visit Last Modified;2:Visit Date",DIR("A")="Run Report by",DIR("B")="1" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S Y=$E(Y),APCDPROC=$S(Y=1:"M",Y=2:"V",1:Y),APCDPROD=$S(Y=1:"Last Modified",1:"Visit"),APCDXREF=$S(Y=1:"ADLM",2:"B")
GETDATES ;
BD ;get beginning date
 W ! S DIR(0)="D^:DT:EP",DIR("A")="Enter Beginning "_APCDPROD_" Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G DLMVD
 S APCDBD=Y
ED ;get ending date
 W ! S DIR(0)="DA^"_APCDBD_":DT:EP",DIR("A")="Enter Ending "_APCDPROD_" Date: " S Y=APCDBD D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCDED=Y
 S X1=APCDBD,X2=-1 D C^%DTC S APCDSD=X
SC ;
 W !
 K APCDSCT
 K APCDSC,APCDSCT W ! S DIR(0)="YO",DIR("A")="Include ALL Visit Service Categories",DIR("B")="Yes"
 S DIR("?")="If you wish to include all visit service categories (Ambulatory,Hospitalization,etc) answer Yes.  If you wish to list visits for only one service category enter NO." D ^DIR K DIR
 G:$D(DIRUT) BD
 I Y=1 G CLN
SC1 ;enter sc
 S X="SERVICE CATEGORY",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G XIT
 D PEP^AMQQGTX0(+Y,"APCDSCT(")
 I '$D(APCDSCT) G SC
 I $D(APCDSCT("*")) K APCDSCT
CLN ;
 W !
 S APCDCLN="",DIR("A")="Include which Visits",DIR(0)="S^R:One Clinic;A:All Clinics",DIR("B")="A",DIR("?")="" D ^DIR K DIR
 I $D(DIRUT) G SC
 I Y="A" G PROV
 S DIC="^DIC(40.7,",DIC(0)="AEQM",DIC("A")="Clinic: "
 D ^DIC K DIC,DA
 G:Y=-1 CLN
 S APCDCLN=+Y
 ;
 ;
PROV ;
 W !
 S APCDPROV=""
 S DIR(0)="S^O:Visits completed by or w/CPT last modified by one Operator;A:All visits, don't limit by operator",DIR("A")="Include which Visits",DIR("B")="O" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G CLN
 I Y="A" G RV
 S DIC="^VA(200,",DIC(0)="AEQM",DIC("A")="Which CODER/OPERATOR: " D ^DIC K DIC
 I $D(DTOUT)!(Y=-1) G PROV
 S APCDPROV=+Y
 ;
RV ;
 S APCDRVC=""
 S DIR(0)="S^R:Only Visits Marked as Reviewed/Complete;A:All visits regardless of Coding Status",DIR("A")="Include which Visits",DIR("B")="R" KILL DA D ^DIR K DIR
 I $D(DIRUT) G PROV
 S APCDRVC=Y
ICD ;
 W !
 K ^XTMP("APCDFCPC",APCDJOB,APCDBT,"DECPT"),DA,DIR,DTOUT,DIRUT,Y,X,DIC
 S DIR(0)="Y",DIR("A")="Do you wish to include only a subset of CPT codes",DIR("B")="NO",DIR("?")="If you wish to limit the search of CPT's to a subset of CPT Codes, enter Y" D ^DIR K DIR
 G:$D(DIRUT) RAND
 I Y=0 S ^XTMP("APCDFCPC",APCDJOB,APCDBT,"DECPT","ALL")="" G RAND
 K AMQQTAXN
 K ^UTILITY("AMQQ TAX",$J)
 K DIC,X,Y,DD S X="CPT CODE",DIC="^AMQQ(5,",DIC(0)="EQXM",D="B",DIC("S")="I $P(^(0),U,14)" D MIX^DIC1 K DIC,DA,DINUM,DICR I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" Q
 S APCLQMAN=+Y
 D PEP^AMQQGTX0(APCLQMAN,"^XTMP(""APCDFCPC"",APCDJOB,APCDBT,""DECPT"",")
 I '$D(^XTMP("APCDFCPC",APCDJOB,APCDBT,"DECPT")) W !!,$C(7),"** No CPTs, selected, all will be included." Q
 I $D(^XTMP("APCDFCPC",APCDJOB,APCDBT,"DECPT","*")) K ^XTMP("APCDFCPC",APCDJOB,APCDBT,"DECPT") W !!,"*** All items selected, if you want all then do not select this item." Q
RAND ;
 W !
 S APCDMAX="",DIR("A")="Include which Visits",DIR(0)="S^R:Random Sample of Visits;A:All visits",DIR("B")="A",DIR("?")="If you want ALL Visits in this date range displayed Answer Y, if you want a random sample answer NO." D ^DIR K DIR
 I $D(DIRUT) G ICD
 I Y="A" S APCDRSM=0 G ZIS
 S DIR(0)="N^1:100:",DIR("A")="How many randomized visits do you want" D ^DIR K DIR
 I $D(DIRUT) G RAND
 S APCDMAX=Y,APCDRSM=1
ZIS W !! S %ZIS="PQM" D ^%ZIS
 I POP G XIT
 I $D(IO("Q")) G TSKMN
DRIVER ; entry point for taskman
ZTSK ;
 D PROCESS
 S APCDDT=$$FMTE^XLFDT(DT)
 U IO
 D PRINT
 I $D(ZTQUEUED) S ZTREQ="@"
 K ^XTMP("APCDFCPC",APCDJOB,APCDBT)
 D XIT
 Q
ERR W $C(7),$C(7),!,"Must be a valid date and be Today or earlier. Time not allowed!" Q
TSKMN ;
 S ZTIO=""
 S ZTIO=$S($D(ION):ION,1:IO) I $D(IOST)#2,IOST]"" S ZTIO=ZTIO_";"_IOST
 I $G(IO("DOC"))]"" S ZTIO=ZTIO_";"_$G(IO("DOC"))
 I $D(IOM)#2,IOM S ZTIO=ZTIO_";"_IOM I $D(IOSL)#2,IOSL S ZTIO=ZTIO_";"_IOSL
 K ZTSAVE F %="APCD*" S ZTSAVE(%)=""
 S ZTCPU=$G(IOCPU),ZTRTN="DRIVER^APCDFCPC",ZTDTH="",ZTDESC="PCC DE QA CPT" D ^%ZTLOAD D XIT Q
 ;
 ;
XIT ;
 D ^%ZISC
 I '$D(ZTSK) S IOP="HOME" D ^%ZIS U IO(0)
 K DIC,%DT,IO("Q"),X,Y,POP,DIRUT,ZTSK,ZTIO
 D EN^XBVK("APCD")
 Q
PROCESS ;
 ;
M ; Run by posting date
 S APCDVCNT=0,APCDODAT=APCDSD_".9999"
 F  S APCDODAT=$O(^AUPNVSIT(APCDXREF,APCDODAT)) Q:APCDODAT=""!((APCDODAT\1)>APCDED)  D V1
 Q
V1 ;
 S APCDVDFN=0
 F  S APCDVDFN=$O(^AUPNVSIT(APCDXREF,APCDODAT,APCDVDFN)) Q:APCDVDFN'=+APCDVDFN  D PROC
 Q
PROC ;
 S APCDVREC=^AUPNVSIT(APCDVDFN,0)
 Q:'$P(APCDVREC,U,9)
 Q:$P(APCDVREC,U,11)
 Q:'$D(^AUPNVCPT("AD",APCDVDFN))  ;NO VCPT
 I $D(APCDSCT),'$D(APCDSCT($P(^AUPNVSIT(APCDVDFN,0),U,7))) Q  ;SERVICE CATEGORY CHECK
 I APCDCLN]"",APCDCLN'=$P(APCDVREC,U,8) Q  ;CLINIC CHECK
 I APCDPROV,'$$PROVCHK(APCDVDFN,APCDPROV) Q
 I APCDRVC="R" Q:'$$RC(APCDVDFN)
 D CHKCPT
 Q
RC(V) ;
 I $$VALI^XBDIQ1(9000010,V,1111)="R" Q 1
 ; NEW H
 ;S H=$O(^AUPNVINP("AD",V,0))
 ;I 'H Q ""
 ;I '$$VALI^XBDIQ1(9000010.02,H,.15) Q 1
 Q ""
PROVCHK(V,P) ;
 I $$LASTRC(V,P) Q 1  ;was this person the one last marked it rev/compl
 I $$CPTLM(V,P) Q 1
 Q ""
CPTLM(V,P) ;WAS ANY CPT LAST MODIFIED BY THIS CODER
 NEW X,G
 S (X,G)=0
 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(G)  D
 .Q:$$VALI^XBDIQ1(9000010.18,X,1219)'=P
 .S G=1
 Q G
 ;
LASTRC(V,P) ;EP
 I '$D(^AUPNVSIT(V,0)) Q ""
 I '$D(^AUPNVCA("AD",V)) Q ""
 NEW X,G
 S G=""
 S X=0 F  S X=$O(^AUPNVCA("AD",V,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCA(X,0))
 .Q:$P(^AUPNVCA(X,0),U,4)'="R"
 .S G=$P(^AUPNVCA(X,0),U,5)  ;USER
 I G=P Q 1
 Q ""
CHKCPT ;
 I $D(^XTMP("APCDFCPC",APCDJOB,APCDBT,"DECPT","ALL")) D CNT Q
 S (APCD1,APCD2)=0 F  S APCD1=$O(^AUPNVCPT("AD",APCDVDFN,APCD1)) Q:APCD1'=+APCD1  S APCDICDP=$P(^AUPNVCPT(APCD1,0),U) I $D(^XTMP("APCDFCPC",APCDJOB,APCDBT,"DECPT",APCDICDP)) S APCD2=APCD2+1
 I APCD2>0 D CNT
 Q
CNT ;
 S APCDVCNT=APCDVCNT+1,^XTMP("APCDFCPC",APCDJOB,APCDBT,"DEQAV",APCDVCNT,APCDVDFN)=""
 Q
 ;
 ;
PRINT ;
 S APCD80D="-------------------------------------------------------------------------------"
 S Y=APCDBD D DD^%DT S APCDBDD=Y S Y=APCDED D DD^%DT S APCDEDD=Y
 I APCDMAX="" S APCDMAX=APCDVCNT
 I APCDMAX>APCDVCNT S APCDMAX=APCDVCNT
 S APCDPG=0 D HEAD
 I APCDMAX=0 S APCDPG=0 W !,"No Visits to report!",! G DONE
 S APCDGOT=APCDVCNT/APCDMAX S APCDGOT=$J(APCDGOT,$L($P(APCDGOT,".")),0)
 I '$D(^XTMP("APCDFCPC",APCDJOB,APCDBT)) W !,"No visits to report",! G DONE
 K APCDQUIT
 S APCDVDFN="" F APCDX=1:APCDGOT:APCDVCNT S APCDVDFN=$O(^XTMP("APCDFCPC",APCDJOB,APCDBT,"DEQAV",APCDX,"")) Q:APCDVDFN=""!($D(APCDQUIT))  I $D(^AUPNVSIT(APCDVDFN,0)) S APCDVREC=^(0) D CPT
 G:$D(APCDQUIT) DONE
 ;I $Y>(IOSL-11) D HEAD G:$D(APCDQUIT) DONE
DONE ;
 I '$D(APCDQUIT),$E(IOST)="C",IO=IO(0) S DIR(0)="E" D ^DIR K DIR
 K ^XTMP("APCDFCPC",APCDJOB,APCDBT)
 ;W:$D(IOF) @IOF
 Q
CPT ;
 S APCDCPTC=0,APCDCPT="" K APCDCPTA
 F  S APCDCPT=$O(^AUPNVCPT("AD",APCDVDFN,APCDCPT)) Q:APCDCPT=""  I $D(^AUPNVCPT(APCDCPT,0)) D CPT1
 D WRT
 Q
CPT1 ;
 I $D(^XTMP("APCDFCPC",APCDJOB,APCDBT,"DECPT","ALL")) S APCDCPTC=APCDCPTC+1,APCDCPTA(APCDCPTC)=APCDCPT Q
 I $D(^XTMP("APCDFCPC",APCDJOB,APCDBT,"DECPT",$P(^AUPNVCPT(APCDCPT,0),U))) S APCDCPTC=APCDCPTC+1,APCDCPTA(APCDCPTC)=APCDCPT
 Q
WRT ;
 I $Y>(IOSL-6) D HEAD Q:$D(APCDQUIT)
 S Y=+APCDVREC D DD^%DT S APCDDATE=Y
 S APCDPAT=$P(APCDVREC,U,5) Q:APCDPAT=""
 ;S APCDHRN=$S($D(^AUPNPAT(APCDPAT,41,DUZ(2),0)):$P(^AUPNPAT(APCDPAT,41,DUZ(2),0),U,2),1:"NONE")
 S APCDHRN=$$HRN^AUPNPAT(APCDPAT,$P(APCDVREC,U,6),2)
 I APCDHRN="" S APCDHRN=$$HRN^AUPNPAT(APCDPAT,DUZ(2),2)
 I APCDHRN="",$O(^AUPNPAT(APCDPAT,41,0)) S APCDHRN=$$HRN^AUPNPAT(APCDPAT,$O(^AUPNPAT(APCDPAT,41,0)),2)
 I APCDHRN="" S APCDHRN="NONE"
 W !,APCDHRN,?12,APCDDATE,?31,$E($$CLINIC^APCLV(APCDVDFN,"E"),1,15),?47,$$VALI^XBDIQ1(9000010,APCDVDFN,.07),?52,$$COMPBY(APCDVDFN),!
 S APCDCPTN=0 F  S APCDCPTN=$O(APCDCPTA(APCDCPTN)) Q:APCDCPTN=""!($D(APCDQUIT))  D
 .I $Y>(IOSL-4) D HEAD Q:$D(APCDQUIT)
 .S APCDCPTD=APCDCPTA(APCDCPTN)
 .W ?1,$$VAL^XBDIQ1(9000010.18,APCDCPTD,.01),?11,$$VAL^XBDIQ1(9000010.18,APCDCPTD,.24),?18,"Last Modified By: ",$E($$VAL^XBDIQ1(9000010.18,APCDCPTD,1219),1,24),!
 .W ?1,"[",$E($$VAL^XBDIQ1(9000010.18,APCDCPTD,.019),1,75),"]",!
 .;K ^UTILITY($J,"W")
 .; S DIWL=0,DIWR=78
 .; D ^DIWP
 .;S APCDUDA="" F  S APCDUDA=$O(^UTILITY($J,"W",APCDUDA)) Q:APCDUDA=""  D
 .;. S APCDVDA=0 F  S APCDVDA=$O(^UTILITY($J,"W",APCDUDA,APCDVDA)) Q:'APCDVDA!(APCDUDA="")  W ?1,$G(^UTILITY($J,"W",APCDUDA,APCDVDA,0)),!
 .;W ?1,"[",$E($P($$ICDDX^ICDEX(+^AUPNVCPT(APCDCPTD,0),$$VD^APCLV(APCDVDFN)),U,4),1,75),"]",!
 Q
COMPBY(V) ;last one marked reviewed/complete or "Not Yet Marked Complete"
 I '$G(V) Q ""
 I '$D(^AUPNVSIT(V,0)) Q ""
 I '$D(^AUPNVCA("AD",V)) Q ""
 NEW X,G
 S G=""
 S X=0 F  S X=$O(^AUPNVCA("AD",V,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVCA(X,0))
 .Q:$P(^AUPNVCA(X,0),U,4)'="R"
 .S G=$P(^AUPNVCA(X,0),U,5)  ;USER
 I 'G Q ""
 Q $E($P($G(^VA(200,G,0)),U,1),1,27)
 ;
HEAD I 'APCDPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCDQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCDPG=APCDPG+1
 W $$CTR(APCDLHDR,80),?72,"Page ",APCDPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W ?15,APCDPROD_" Dates:  "_APCDBDD_" - "_APCDEDD,!
 I APCDPROV D
 .S APCDLENG=$L($P(^VA(200,APCDPROV,0),U))+19
 .W ?(80-APCDLENG)/2,"Data Entry Operator:  ",$P(^VA(200,APCDPROV,0),U),!
 I 'APCDPROV W $$CTR("All Operators/Coders"),!
 W $$CTR("Service Categories: ") D
 .I $D(APCDSCT) S X="",C=0 F  S X=$O(APCDSCT(X)) Q:X=""  S C=C+1 W:C>1 ", " W X
 .I '$D(APCDSCT) W "All"
 .W !
 W $$CTR("Clinic:  "_$S(APCDCLN]"":$P(^DIC(40.7,APCDCLN,0),U),1:"ALL")),!
 I APCDRVC="R" W $$CTR("Only visit marked reviewed/complete are included"),!
 W "Total Visits Found: ",APCDVCNT D
 .I $G(APCDRSM)=1 W "          Total Number of Random Visits Selected:  ",APCDMAX
 .W !
 W !?2,"HR#",?12,"Visit Date/Time",?31,"Clinic",?47,"SC",?52,"Reviewed/Completed By",!
 W ?1,"CPT",?11,"",!?1,"[CPT Description]",!
 W APCD80D,!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
