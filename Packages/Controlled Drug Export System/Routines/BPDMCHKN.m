BPDMCHKN ; IHS/CMI/LAB - Export initialization ;
 ;;2.0;CONTROLLED DRUG EXPORT SYSTEM;**1,4,6**;NOV 15, 2011;Build 16
 ;
 ;
 ;
CHECK ;EP
 S BPDMOSIT=$P(^BPDMSITE(BPDMSITE,0),U,1)  ;outpatient site ien
 I '$G(BPDMOSIT) S BPDMQMSG="Outpatient Site is not defined in the PDM SITE PARAMETERS file" W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 S BPDMVER=$P(^BPDMSITE(BPDMSITE,0),U,3)
 I BPDMVER="" S BPDMQMSG="ASAP Version # not defined in Site Parameter File.  This will need to be fixed before continuing." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 S BPDMVERI=$O(^BPDMCTRL("B",BPDMVER,0))
 S BPDMPDMP=$P($G(^BPDMSITE(BPDMSITE,13)),U,6)
 I BPDMPDMP S BPDMPDMP=$P(^BPDMPDMP(BPDMPDMP,0),U,2)
 I $$VAL^XBDIQ1(9002315.01,BPDMSITE,.14)="" S BPDMQMSG="Mail Group to receive error bulletin is missing from site parameters.  Cannot continue" W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I 'BPDMVERI S BPDMQMSG="Version "_BPDMVER_" control table entry missing.  Notify Programmer.  Cannot continue." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 S BPDMSDIR=$P($G(^BPDMSITE(BPDMSITE,11)),U,1) I BPDMSDIR="" S BPDMQMSG="Site Secure Export Directory Name is missing from site parameter file.  Cannot continue." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 S BPDMSTE=$P(^BPDMSITE(BPDMSITE,0),U,4) I BPDMSTE="" S BPDMQMSG="Site file does not have a STATE of location in the site file.  Cannot Continue." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $E(BPDMVER)=3 D V3CHK Q
 I BPDMVER=1995 D V1995CHK Q
 S BPDMFS=$P(^BPDMCTRL(BPDMVERI,0),U,2) I BPDMFS="" S BPDMQMSG="Control table does not have a field separator defined.  Notify programmer." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 S BPDMSS=$P(^BPDMCTRL(BPDMVERI,0),U,3) I BPDMSS="" S BPDMQMSG="Control table does not have a segment separator defined.  Notify programmer." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $P(^BPDMSITE(BPDMSITE,0),U,2)="" S BPDMQMSG="Site file does not contain pharmacy Information Source Name.  Cannot continue" W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $P(^BPDMSITE(BPDMSITE,0),U,5)="" S BPDMQMSG="Site file does not contain the numeric phone number.  This will need to be entered before continuing." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA01",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.06)="" S BPDMQMSG="Site NPI is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA02",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.07)="" S BPDMQMSG="Site NCPDP/NABP Provider ID is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA03",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.08)="" S BPDMQMSG="Site Facility DEA # is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA04",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.09)="" S BPDMQMSG="Site Pharmacy name is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA05",BPDMSTE)=1,$$VAL^XBDIQ1(59,BPDMOSIT,.02)="" S BPDMQMSG="Pharmacy Address is required and it is missing in Outpatient Site file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA07",BPDMSTE)=1,$$VAL^XBDIQ1(59,BPDMOSIT,.07)="" S BPDMQMSG="Pharmacy City is required and it is missing in Outpatient Site file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA08",BPDMSTE)=1,$$VAL^XBDIQ1(59,BPDMOSIT,.08)="" S BPDMQMSG="Facility State is required and it is missing in Outpatient Site file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA09",BPDMSTE)=1,$$VAL^XBDIQ1(59,BPDMOSIT,.05)="" S BPDMQMSG="Facility ZIP CODE is required and it is missing in Outpatient Site file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA10",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.05)="" S BPDMQMSG="Site Phone Number is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA11",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.1)="" S BPDMQMSG="Site Contact Information is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA13",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,1105)="" S BPDMQMSG="State Pharmacy License Number is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("IS","IS03",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.1)="" S BPDMQMSG="IS03 Message is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 Q
V3CHK ;
 S BPDMFS=$P(^BPDMCTRL(BPDMVERI,0),U,2) I BPDMFS="" S BPDMQMSG="Control table does not have a field separator defined.  Notify programmer." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 S BPDMSS=$P(^BPDMCTRL(BPDMVERI,0),U,3) I BPDMSS="" S BPDMQMSG="Control table does not have a segment separator defined.  Notify programmer." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $P(^BPDMSITE(BPDMSITE,0),U,2)="" S BPDMQMSG="Site file does not contain pharmacy Information Source Name.  Cannot continue" W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $P(^BPDMSITE(BPDMSITE,0),U,5)="" S BPDMQMSG="Site file does not contain the numeric phone number.  This will need to be entered before continuing." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA01",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.06)="" S BPDMQMSG="Site NPI is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA02",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.07)="" S BPDMQMSG="Site NCPDP/NABP Provider ID is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA03",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.08)="" S BPDMQMSG="Site Facility DEA # is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA04",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.09)="" S BPDMQMSG="Site Pharmacy name is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA05",BPDMSTE)=1,$$VAL^XBDIQ1(59,BPDMOSIT,.02)="" S BPDMQMSG="Pharmacy Address is required and it is missing in Outpatient Site file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA07",BPDMSTE)=1,$$VAL^XBDIQ1(59,BPDMOSIT,.07)="" S BPDMQMSG="Pharmacy City is required and it is missing in Outpatient Site file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA08",BPDMSTE)=1,$$VAL^XBDIQ1(59,BPDMOSIT,.08)="" S BPDMQMSG="Facility State is required and it is missing in Outpatient Site file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA09",BPDMSTE)=1,$$VAL^XBDIQ1(59,BPDMOSIT,.05)="" S BPDMQMSG="Facility ZIP CODE is required and it is missing in Outpatient Site file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA10",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.05)="" S BPDMQMSG="Site Phone Number is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("PHA","PHA11",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.1)="" S BPDMQMSG="Site Contact Information is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("IS","IS03",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,.1)="" S BPDMQMSG="IS03 Message is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("IR","IR01",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,1301)="" S BPDMQMSG="Unique Information Receiver ID is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 I $$REQ^BPDMUTL("IR","IR02",BPDMSTE)=1,$$VAL^XBDIQ1(9002315.01,BPDMSITE,1302)="" S BPDMQMSG="Information Receiver Entity Name is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 Q
V1995CHK ;
 I $$VAL^XBDIQ1(9002315.01,BPDMSITE,.07)="" S BPDMQMSG="Site NCPDP/NABP Provider ID is required and it is missing in site parameter file." W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 S BPDMBINN=$P($G(^BPDMSITE(BPDMSITE,13)),U,3) I BPDMBINN="" S BPDMQMSG="Site file does not contain pharmacy Bank Identification Number (BIN).  Cannot continue" W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 S BPDMCUID=$P($G(^BPDMSITE(BPDMSITE,13)),U,4) I BPDMCUID="" S BPDMQMSG="Site file does not contain Customer ID to use.  Cannot continue" W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 S BPDMPHID=$P($G(^BPDMSITE(BPDMSITE,13)),U,5) I BPDMPHID="" S BPDMQMSG="Site file does not contain Pharmacy ID to use.  Cannot continue" W:'$D(ZTQUEUED) !,BPDMQMSG S BPDMQFLG=1 Q
 Q
GETSITE ;EP
 Q:$D(BPDM("SCHEDULED"))
 S BPDMSITE=""
 K DIC S DIC="^BPDMSITE(",DIC(0)="AEMQ" D ^DIC K DIC
 I Y'>0 S BPDMQFLG=1 Q  ;CMI/GRL
 ;I Y=-1 S BPDMQFLG=1 Q
 S BPDMSITE=+Y
 Q
 ;
CHKAL ;EP CHECK AL XREF
 S BPDMR("R DATE")=BPDM("RUN BEGIN")  ;cmi/maw 10042018 p4 CR10306
 S BPDMR("R DATE")=$O(^PSRX("AL",BPDMR("R DATE")))
 I BPDMR("R DATE")=""!($P(BPDMR("R DATE"),".")>BPDM("RUN END")) S BPDMQMSG="*** No reportable prescriptions processed during export period. File not created. ***" S BPDMQFLG=1 Q
 Q
ZEROCHK() ;check for zero report
 Q:'$$GET1^DIQ(9002315.01,BPDMSITE,1106,"I") 0 ;quit if not generating zero report
 Q:$G(BPDMRTYP)'=1  ;only check for zero report on regular export
 N BPDMX
 I BPDM("LAST LOG") S BPDMLLB=$P(^BPDMLOG(BPDM("LAST LOG"),0),U)
 Q:$P(BPDMLLB,".")=DT 0
 Q:$P(BPDMLLB,".")>DT 0
 S BPDMLLZ=$P(BPDMLLB,".")+.999999  ;cmi/maw 10/04/2018 p4 CR10306
 S X1=DT,X2=-1 D C^%DTC S BPDMYST=X
 ;check for zero report run today
 S BPDMLZL=$$FNDLST^BPDMDR1N(BPDMOSIT,4)
 S BPDMLLE=$S($G(BPDMLZL):$P($G(^BPDMLOG(BPDMLZL,0)),U,3),1:$P($G(^BPDMLOG(BPDM("LAST LOG"),0)),U,3))
 S X1=$P(BPDMLLE,"."),X2=+1 D C^%DTC S BPDMRST=X
 I $G(BPDMLZL),$P($P(^BPDMLOG(BPDMLZL,0),U),".")=DT Q 0
 I '$D(ZTQUEUED) W !,"Since this is the first run for today, I will now check to see if a Zero Report needs to be generated."
 S BPDMFSTR=1  ;set variable for first run of the day
 S BPDMR("R DATE")=BPDMLLE  ;cmi/maw 10042018 p4 CR10306
 S BPDMR("R DATE")=$O(^PSRX("AL",BPDMR("R DATE")))
 I BPDMR("R DATE")=""!($P(BPDMR("R DATE"),".")>BPDMYST) S BPDMZRO=1
 I $G(BPDMZRO) D ZEROSET^BPDMZERO($S($P(BPDMLLE,".")=BPDMYST:BPDMYST,BPDMRST>BPDMYST:BPDMYST,1:BPDMRST),BPDMYST) Q 1  ;dont run an export but create a zero report
 Q 0
 ;
ZEROCHKN() ;-- check for zero report
 Q:'$$GET1^DIQ(9002315.01,BPDMSITE,1106,"I") 0 ;quit if not generating zero report
 S BPDMLRR=$$FNDLST^BPDMDR1N(BPDMOSIT,1)
 S BPDMLZR=$$FNDLST^BPDMDR1N(BPDMOSIT,4)
 I '$G(BPDMLRR) Q 0
 I '$G(BPDMLZR) S BPDMLZR=BPDMLRR
 S BPDMLRD=$P($G(^BPDMLOG(BPDMLRR,0)),U,3)
 S BPDMLZD=$P($G(^BPDMLOG(BPDMLZR,0)),U,3)
 S BPDMLZDR=$P($G(^BPDMLOG(BPDMLZR,0)),U)
 I $L(BPDMLRD)=7 S BPDMLRD=BPDMLRD_".235959"
 Q:$P(BPDMLRD,".")=DT 0
 Q:$P(BPDMLRD,".")>DT 0
 S X1=DT,X2=-1 D C^%DTC S BPDMYST=X
 I $P(BPDMLRD,".",2)[".24",$P(BPDMLRD,".")=BPDMYST Q 0  ;20220226 patch 6 11986 for duplicates exactly at midnight
 Q:$P(BPDMLRD,".")=BPDMYST 0
 Q:$P(BPDMLZDR,".")=DT 0 ;zero report already run today
 S X1=$P(BPDMLZD,"."),X2=+1 D C^%DTC S BPDMZDT=X
 S X1=$P(BPDMLRD,"."),X2=+1 D C^%DTC S BPDMRDT=X
 S BPDMRST=$S(BPDMZDT>BPDMRDT:BPDMZDT,1:BPDMRDT)
 Q 1
 ;
CONFIRM ;EP -  SEE IF THEY REALLY WANT TO DO THIS
 Q:$D(ZTQUEUED)
 Q:$D(BPDM("SCHEDULED"))
 W !,"The Pharmacy Outpatient Site for this run is ",$$VAL^XBDIQ1(9002315.01,BPDMSITE,.01),"."
 W !,"The ASAP Version # being used is ",BPDMVER,".",!
CFLP ;
 W ! K DIR S DIR(0)="Y",DIR("A")="Do you want to continue",DIR("B")="N" K DA D ^DIR K DIR
 I $D(DIRUT) S BPDMQFLG=1 Q
 I 'Y S BPDMQFLG=99
 Q
 ;
GENLOG ;EP - GENERATE NEW LOG ENTRY
 S ^MAW("BPDMCHKN",$J,$H,BPDMSITE)=BPDMOSIT_U_$$NOW^XLFDT()
 W:'$D(ZTQUEUED) !,"Generating New Log entry.."
 ;S Y=DT X ^DD("DD") S X=""""_Y_"""",DIC="^BPDMLOG(",DIC(0)="L",DLAYGO=9002315.09,DIC("DR")=".02////"_BPDM("RUN BEGIN")_";.03////"_BPDM("RUN END")_";.08///"_BPDMRTYP_";.09///"_BPDMPTYP_";.1////"_BPDMOSIT
 S X=$$FMTE^XLFDT($$NOW^XLFDT()),DIC="^BPDMLOG(",DIC(0)="L",DLAYGO=9002315.09,DIC("DR")=".02////"_BPDM("RUN BEGIN")_";.03////"_BPDM("RUN END")_";.08///"_BPDMRTYP_";.09///"_BPDMPTYP_";.1////"_BPDMOSIT
 D ^DIC K DIC,DLAYGO,DR
 I Y<0 S BPDMQFLG=1 Q
 S BPDM("RUN LOG")=+Y
 D AUDIT(BPDM("RUN LOG"))
 Q
 ;
AUDIT(LOG) ;-- lets put the audit in place
 N FDA,FERR,FIENS
 S FIENS="+2,"_LOG_","
 S FDA(9002315.0991,FIENS,.01)=$$NOW^XLFDT()
 S FDA(9002315.0991,FIENS,.02)=$G(DUZ)
 S FDA(9002315.0991,FIENS,.03)=$G(XQY)
 S FDA(9002315.0991,FIENS,.04)=$S('BPDMQFLG:"S",1:"F")
 D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 Q
 ;
