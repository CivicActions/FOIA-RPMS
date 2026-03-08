APCLSILI ; IHS/CMI/LAB - education delimted file for use in excel ;
 ;;1.0;IHS PCC SUITE;**2**;MAR 14, 2008
 ;
 ;
START ;
 ;This report will create a comma delimited output file of all visits on from March 21, 2009
 ;through the date run for which the visit meets this criteria
 ;     clinic is in SURVEILLANCE ILI CLINICS taxonomy
 ;     at least 1 POV is in SURVEILLANCE ILI taxonomy
 ;     visit is AMBULATORY, OBSERVATION, DAY SURGERY OR NURSING HOME (outpatient in service category)
 ;after the file is generated it will call sendto with ZISH SEND PARAMETER SURVEILLANCE ILI SEND
 ;
 ;STOP IF TODAY IS AFTER JUL 1 2009
 Q:DT>3090701  ;AUTO STOP DATE
 ;
 D EXIT
 ;
PROC ;EP - called from xbdbque
 K APCLLOCT
 K ^APCLDATA($J)  ;export global
 S APCLCTAX=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",0))  ;clinic taxonomy
 S APCLDTAX=$O(^ATXAX("B","SURVEILLANCE ILI",0))  ;dx taxonomy
 I 'APCLCTAX D EXIT Q
 I 'APCLDTAX D EXIT Q
 ;
 S APCLSD=3090320.9999  ;start with 3/21/09 visits
 S APCLED=$$FMADD^XLFDT(DT,-1)
 S APCLVTOT=0  ;visit counter
 F  S APCLSD=$O(^AUPNVSIT("B",APCLSD)) Q:APCLSD'=+APCLSD!($P(APCLSD,".")>APCLED)  D
 .S APCLV=0 F  S APCLV=$O(^AUPNVSIT("B",APCLSD,APCLV)) Q:APCLV'=+APCLV  D
 ..Q:'$D(^AUPNVSIT(APCLV,0))  ;no zero node
 ..Q:$P(^AUPNVSIT(APCLV,0),U,11)  ;deleted visit
 ..Q:"AORS"'[$P(^AUPNVSIT(APCLV,0),U,7)  ;just want outpatient
 ..S APCLCLIN=$$CLINIC^APCLV(APCLV,"I")  ;get clinic code
 ..Q:APCLCLIN=""
 ..Q:'$D(^ATXAX(APCLCTAX,21,"B",APCLCLIN))  ;not in clinic taxonomy
 ..S APCLLOC=$P(^AUPNVSIT(APCLV,0),U,6)  Q:APCLLOC=""  ;no location ???
 ..S APCLDATE=$P($P(^AUPNVSIT(APCLV,0),U),".")
 ..S DFN=$P(^AUPNVSIT(APCLV,0),U,5)
 ..Q:DFN=""
 ..Q:'$D(^DPT(DFN,0))
 ..Q:$P(^DPT(DFN,0),U)["DEMO,PATIENT"
 ..S APCLASUF=$P($G(^AUTTLOC(APCLLOC,0)),U,10)
 ..I APCLASUF="" Q  ;no ASUFAC????
 ..S APCLLOCT(APCLASUF,$$JDATE(APCLDATE))=$G(APCLLOCT(APCLASUF,$$JDATE(APCLDATE)))+1   ;total number of visits on this date/location
 ..S G=0
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",APCLV,X)) Q:X'=+X  S T=$P(^AUPNVPOV(X,0),U) I $$ICD^ATXCHK(T,APCLDTAX,9) S G=1
 ..Q:'G  ;no diagnosis
 ..;
 ..;set delimited record
 ..S C=","
 ..S APCLREC=$$UID(DFN)
 ..S $P(APCLREC,",",2)=$S($$HRN^AUPNPAT(DFN,APCLLOC)]"":$$HRN^AUPNPAT(DFN,APCLLOC),1:$$HRN^AUPNPAT(DFN,DUZ(2)))   ;hrn at location of encounter, if none, then hrn at duz(2)
 ..S $P(APCLREC,",",3)=$P(^DPT(DFN,0),U,2)
 ..S $P(APCLREC,",",4)=$$JDATE($P(^DPT(DFN,0),U,3))
 ..S $P(APCLREC,",",5)=$$COMMRES^AUPNPAT(DFN,"C")
 ..S $P(APCLREC,",",6)=$P(^AUTTLOC(APCLLOC,0),U,10)
 ..S $P(APCLREC,",",7)=$$JDATE(APCLDATE)
 ..S $P(APCLREC,",",12)=$S($P($G(^AUPNVSIT(APCLV,11)),U,14)]"":$P($G(^AUPNVSIT(APCLV,11)),U,14),1:$$UIDV^AUPNVSIT(APCLV))
 ..S $P(APCLREC,",",14)=$$JDATE($P(^AUPNVSIT(APCLV,0),U,13))
 ..;povs
 ..S X=0,APCLC=7 F  S X=$O(^AUPNVPOV("AD",APCLV,X)) Q:X'=+X!(APCLC>9)  D
 ...S T=$P(^AUPNVPOV(X,0),U)
 ...Q:'$$ICD^ATXCHK(T,APCLDTAX,9)  ;not one of interest
 ...S APCLC=APCLC+1  ;piece #
 ...S $P(APCLREC,",",APCLC)=$$VAL^XBDIQ1(9000010.07,X,.01)
 ..;temperature
 ..S APCLTEMP=""
 ..S X=0 F  S X=$O(^AUPNVMSR("AD",APCLV,X)) Q:X'=+X  D
 ...Q:$$VAL^XBDIQ1(9000010.01,X,.01)'="TMP"  ;not a temperature
 ...S V=$P(^AUPNVMSR(X,0),U,4)
 ...S APCLTEMP=$S(V>APCLTEMP:V,1:APCLTEMP)
 ..S $P(APCLREC,",",11)=APCLTEMP
 ..S APCLVTOT=APCLVTOT+1
 ..S ^APCLDATA($J,APCLVTOT)=APCLREC
 ;NOW SET TOTAL IN PIECE 13
 S X=0 F  S X=$O(^APCLDATA($J,X)) Q:X'=+X  D
 .S L=$P(^APCLDATA($J,X),",",6),D=$P(^APCLDATA($J,X),",",7)
 .S $P(^APCLDATA($J,X),",",13)=$G(APCLLOCT(L,D))
 .Q
 ;send file
WRITE ; use XBGSAVE to save the temp global (APCLDATA) to a delimited
 ; file that is exported to the IE system
 ;
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN
 S XBGL="APCLDATA",XBMED="F",XBQ="N",XBFLT=1,XBF=$J,XBE=$J
 S XBNAR="ILI SURVEILLANCE EXPORT"
 S APCLASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S XBFN="FLU_"_APCLASU_"_"_$$DATE(DT)_".txt"
 S XBS1="SURVEILLANCE ILI SEND"
 ;
 D ^XBGSAVE
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,"VISIT audit file successfully created",!!
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,"VISIT audit file NOT successfully created",!!
 . W:'$D(ZTQUEUED) !,"File was NOT successfully transferred to the data warehouse",!,"you will need to manually ftp it.",!
 . W:'$D(ZTQUEUED) !,XBFLG(1),!!
 D EXIT
 K ^APCLDATA($J)
 Q
 ;
DATE(D) ;
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
 ;
JDATE(D) ;
 I $G(D)="" Q ""
 NEW A
 S A=$$FMTE^XLFDT(D)
 Q $E(D,6,7)_$$UP^XLFSTR($P(A," ",1))_(1700+$E(D,1,3))
 ;
UID(APCLA) ;Given DFN return unique patient record id.
 I '$G(APCLA) Q ""
 I '$D(^AUPNPAT(APCLA)) Q ""
 ;
 Q $$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)_$E("0000000000",1,10-$L(APCLA))_APCLA
 ;
EXIT ;clean up and exit
 D EN^XBVK("APCL")
 D ^XBFMK
 Q
 ;
EP ;EP - called from option to create search template using ILI logic
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This report will create a search template of visits that meet the "
 W !,"Surveillance ILI criteria.  You will be asked the provide the date"
 W !,"range of visits, a name for the visit search template to be created, and"
 W !,"the device to which the cover page/summary will be printed.",!
 W !,"The visits must meet the following criteria:"
 W !?5," - must be in the date range selected by the user"
 W !?5," - must have a service category of A, O, R or S (outpatient)"
 W !?5," - must have at least one diagnosis that is contained in the "
 W !?8,"SURVEILLANCE ILI taxonomy"
 W !?5," - must be to a clinic in the SURVEILLANCE ILI CLINICS taxonomy"
 W !?5," - the patient's name must not contain 'DEMO,PATIENT' (demo patients"
 W !?8,"skipped)"
 W !
 D EXIT
 S APCLCTAX=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",0))  ;clinic taxonomy
 S APCLDTAX=$O(^ATXAX("B","SURVEILLANCE ILI",0))  ;dx taxonomy
 I 'APCLCTAX W !!,"SURVEILLANCE ILI icd-9 taxonomy missing...cannot continue." D EXIT Q
 I 'APCLDTAX W !!,"SURVEILLANCE ILI CLINICS taxonomy missing...cannot continue." D EXIT Q
 ;
DATES K APCLED,APCLBD
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter Beginning Visit Date"
 D ^DIR G:Y<1 EXIT S APCLBD=Y
 K DIR S DIR(0)="DO^:DT:EXP",DIR("A")="Enter Ending Visit Date"
 D ^DIR G:Y<1 EXIT S APCLED=Y
 ;
 I APCLED<APCLBD D  G DATES
 . W !!,$C(7),"Sorry, Ending Date MUST not be earlier than Beginning Date."
 S APCLSD=$$FMADD^XLFDT(APCLBD,-1)_".9999"
 ;
STMP ;
 S APCLSTMP=""
 D ^APCLSTMV
 I APCLSTMP="" G DATES
 ;
ZIS ;call to XBDBQUE
 S XBRP="PRINT^APCLSILI",XBRC="PROC1^APCLSILI",XBRX="EXIT^APCLSILI",XBNS="APCL"
 D ^XBDBQUE
 D EXIT
 Q
 ;
PROC1 ;
 S APCLJ=$J,APCLH=$H
 S APCLCTAX=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",0))  ;clinic taxonomy
 S APCLDTAX=$O(^ATXAX("B","SURVEILLANCE ILI",0))  ;dx taxonomy
 I 'APCLCTAX D EXIT Q
 I 'APCLDTAX D EXIT Q
 ;
 S APCLVTOT=0,APCLPTOT=0  ;visit counter
 F  S APCLSD=$O(^AUPNVSIT("B",APCLSD)) Q:APCLSD'=+APCLSD!($P(APCLSD,".")>APCLED)  D
 .S APCLV=0 F  S APCLV=$O(^AUPNVSIT("B",APCLSD,APCLV)) Q:APCLV'=+APCLV  D
 ..Q:'$D(^AUPNVSIT(APCLV,0))  ;no zero node
 ..Q:$P(^AUPNVSIT(APCLV,0),U,11)  ;deleted visit
 ..Q:"AORS"'[$P(^AUPNVSIT(APCLV,0),U,7)  ;just want outpatient
 ..S APCLCLIN=$$CLINIC^APCLV(APCLV,"I")  ;get clinic code
 ..Q:APCLCLIN=""
 ..Q:'$D(^ATXAX(APCLCTAX,21,"B",APCLCLIN))  ;not in clinic taxonomy
 ..S APCLLOC=$P(^AUPNVSIT(APCLV,0),U,6)  Q:APCLLOC=""  ;no location ???
 ..S APCLDATE=$P($P(^AUPNVSIT(APCLV,0),U),".")
 ..S DFN=$P(^AUPNVSIT(APCLV,0),U,5)
 ..Q:DFN=""
 ..Q:'$D(^DPT(DFN,0))
 ..Q:$P(^DPT(DFN,0),U)["DEMO,PATIENT"
 ..S APCLASUF=$P($G(^AUTTLOC(APCLLOC,0)),U,10)
 ..I APCLASUF="" Q  ;no ASUFAC????
 ..S APCLLOCT(APCLASUF,$$JDATE(APCLDATE))=$G(APCLLOCT(APCLASUF,$$JDATE(APCLDATE)))+1   ;total number of visits on this date/location
 ..S G=0
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",APCLV,X)) Q:X'=+X  S T=$P(^AUPNVPOV(X,0),U) I $$ICD^ATXCHK(T,APCLDTAX,9) S G=1
 ..Q:'G  ;no diagnosis
 ..;
 ..D SET
 ..Q
 .Q
 K ^XTMP("APCLSILI",APCLJ,APCLH)
 Q
PRINT ;EP - called from xbdbque
 S APCLPG=0
 D HEADER
 W !!,"Search Template Created: ",$P(^DIBT(APCLSTMP,0),U)
 W !!,"Total # of visits meeting criteria and placed in the template:  ",APCLVTOT
 W !!,"Total # of patients for these visits:  ",APCLPTOT,!
 D EOP
 Q
SET ;
 S APCLVTOT=APCLVTOT+1
 S ^DIBT(APCLSTMP,1,APCLV)=""
 Q:$D(^XTMP("APCLSILI",APCLJ,APCLH,"PATS",DFN))
 S APCLPTOT=APCLPTOT+1
 S ^XTMP("APCLSILI",APCLJ,APCLH,"PATS",DFN)=""
 Q
HEADER ;
 I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQ="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W $P(^VA(200,DUZ,0),U,2),?72,"Page ",APCLPG,!
 W ?(80-$L($P(^DIC(4,DUZ(2),0),U))/2),$P(^DIC(4,DUZ(2),0),U),!
 W !,$$CTR("SURVEILLANCE ILI VISIT SEARCH"),!
 W !,$$CTR("DATE RANGE: "_$$FMTE^XLFDT(APCLBD)_"-"_$$FMTE^XLFDT(APCLED),80),!
 W !,$$REPEAT^XLFSTR("-",79)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT["TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
