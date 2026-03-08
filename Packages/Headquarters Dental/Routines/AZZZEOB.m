AZZZEOB ; IHS/ADC/GTH - PROCESS EOBRS (1/6) - SELECT INPUT MEDIA ; [ 05/22/1998  2:12 PM ]
 ;;3.0;CONTRACT HEALTH MGMT SYSTEM;**10**;SEP 17, 1997
 ;
 I ACHSISAO G A3
 I $D(^ACHS(9,DUZ(2),"FY",ACHSCFY,"W",+ACHSFYWK(DUZ(2),ACHSCFY),0)),+$P(^(0),U,2)>0 W *7,!?10,"CHS Registers are Closed -- EOBR Posting CANCELLED",! D RTRN^ACHS G ENDX
A3 ;
 S ACHSPAR=$S(ACHSISAO=0:$$PARM^ACHS(2,14),ACHSISAO=1:$$AOP^ACHS(2,6))
A3A ;
 W !!,"Your PRINT EOBR parameter is: ",ACHSPAR,"."
 I ACHSPAR="Y" W ! S %ZIS("A")="Print EOBRs on what device:" D ^%ZIS I POP S IOP=$I D ^%ZIS G ENDX
 S ACHSEOIO=IO,ACHSPAR=$S('ACHSISAO:$$PARM^ACHS(2,15),ACHSISAO=1:"")
 W !!,"Your UPDATE DOCUMENT FROM EOBR parameter is :  ",ACHSPAR,".",!
 S ACHSFCSQ=+$P(^ACHSF(DUZ(2),2),U,21)
S0 ;
 I '$O(^ACHSEOBR("0"))!('ACHSISAO) G S1
 W *7,!!,"The '^ACHSEOBR(' work global is about to be killed.",!!,"Are you sure previously processed EOBRs were sent to your facilities",!,"via the EOBR OUT Area option?"
 S Y=$$DIR^XBDIR("Y","","N")
 G ENDX:$D(DUOUT)!$D(DTOUT)!('Y)
S1 ;
 W !
 I ACHSISAO D REPORT^AZZZEOB0 G ENDX:$D(DUOUT)!$D(DTOUT)!$D(DIRUT),S2
 S %ZIS="OPQ",%ZIS("A")="SELECT PRINTER FOR PROCESSING REPORT:"
 D ^%ZIS
 S:$D(IO("Q")) ACHSIO("Q")=IO("Q")
 I POP S IOP=$I D ^%ZIS G ENDX
 I ^%ZIS(1,IOS,"TYPE")="HFS",$L($G(IOPAR)) S ZTIO("IOPAR")=IOPAR
 ;S ACHSERPT="D",ZTIO=IO,IOP=$I ; ACHS*3*3 ZTIO=IO IS WRONG
 S ACHSERPT="D",ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL,IOP=$I ; ACHS*3*3 REPLACE IO WITH ION;IOST;IOM;IOSL
 D ^%ZIS
 U IO
S2 ;
 I ^%ZOSF("OS")["DSM" G DSM^AZZZEOBH
 I 'ACHSISAO S ACHSMEDY="F",ACHSMEDA="EB"_$$ASF^ACHS(DUZ(2))_"." G SUF
 S ACHSMEDY="F",ACHSAEND=""
 D ^AZZZEOBS
 G ABEND:ACHSAEND=1,ENDX:ACHSAEND=2
 KILL ACHSAEND
 G CONT1
 ;
SUF ;
 D FACSRCH^AZZZEOBB
 U IO(0)
 I '$O(ACHSUFLS(0)) W !!,*7,"No EOBR Files Available for Processing",! D RTRN^ACHS G ENDX
 S Y=$$DIR^XBDIR("NO^1:"_$O(ACHSUFLS(9999),-1)_":3","Enter the Number of the Facility EOBR File you want to Process","","","","",1)
 G ENDX:$D(DUOUT)!($D(DIRUT))!('Y)
 I +$$PARM^ACHS(2,21)=0 G SEQOK
 I +$P(^ACHSF(DUZ(2),2),U,21)=999 S $P(^ACHSF(DUZ(2),2),U,21)=0
 I $P(^ACHSF(DUZ(2),2),U,21)+1=+$P(ACHSUFLS(ACHSK(Y))," ",3) G SEQOK
 U IO(0)
 W !,*7,"Wrong Facility Sequence Selected for EOBR file ",!
 G ENDX:$$DIR^XBDIR("E"),SUF
SEQOK ;
 S ACHSEOBD=$P(ACHSUFLS(ACHSK(Y))," ",2),ACHSSEQN=+$P(ACHSUFLS(ACHSK(Y))," ",3)
SEQOK1 ;
 I '$D(^ACHSF(DUZ(2),17,"B",ACHSEOBD)) G CONT
 U IO(0)
 W *7,!
 I $$DIR^XBDIR("E","FI EOBR FILE has already been PROCESSED -- ENTER <RETURN> to Continue")
 D CLOSEALL^ACHS
 G SUF
 ;
CONT ;
 S ACHSMEDA=$P(ACHSUFLS(ACHSK(Y))," ",1)
 S Y=$$DIR^XBDIR("Y","Process file '"_$$IM^ACHS_ACHSMEDA_"' (Y/N)","N","","","",1)
 G ENDX:+Y=0!($D(DUOUT))!($D(DIRUT))!($D(DTOUT))
CONT1 ;
 I 'ACHSISAO,$$PARM^ACHS(2,15)="Y",$$E^ACHSJCHK("ACHS") D  G:'Y ENDX
 . U IO(0)
 . W !!!!,*7,$$C^XBFUNC("The compiled menu indicates CHS Users are Active -- EOBR'S CANNOT BE POSTED")
 . W !!,$$C^XBFUNC("You can Exercise the"),!,$$C^XBFUNC("'Clean old Job Nodes in XUTL'"),!
 . W $$C^XBFUNC("option (usually) on the site mgr's menu and try again."),!!
 . S DIR(0)="Y",DIR("A")="OR, if you're sure no CHS users are active, you can continue",DIR("B")="N",DIR("?")="You must enter 'Y' to continue."
 . D ^DIR
 . KILL DIR
 .Q
 S ^ACHSUSE("EOBR")=""
 KILL ^ACHSEOBR ; Work global.
 S ^ACHSEOBR("0")="",(ACHSCTR,ACHSCTR(1))=0
 I $$OPEN^%ZISH($S(ACHSISAO:$$AOP^ACHS(2,1),1:$$IM^ACHS),ACHSMEDA,"R") S ACHSEMSG="M10" D ERROR^ACHSTCK1 G ENDX
 I 'ACHSISAO D SAVDCR("B")
 U IO(0)
 W !
RDHDR ;EP
 D ^AZZZEOB1
 G:ACHSTERR ABEND
 I ACHSISAO D AREA^AZZZEOBB G XIT
 I 'ACHSISAO D FAC^AZZZEOBB,SAVDCR("E")
XIT ;
 S ACHSRPT=2
 I ACHSISAO S ACHSRPT=1
 G ENDX:ACHSERPT="N"
 I ACHSERPT="S" D REPORT^AZZZEOBC G:ACHSERR ABEND D HOME^%ZIS U IO G ENDX
 I '$D(ACHSIO("Q")) S (ACHSEOIO,IOP)=ZTIO S:$L($G(ZTIO("IOPAR"))) %ZIS("IOPAR")=ZTIO("IOPAR") KILL ZTIO D ^%ZIS,START^AZZZEOB6,HOME^%ZIS U IO G ENDX
 S %DT="R",X="NOW"
 D ^%DT
 S ZTDTH=Y+.0002
 S:$L($G(ZTIO("IOPAR"))) IOPAR=ZTIO("IOPAR")
 S ZTRTN="START^AZZZEOB6",ZTDESC="CHS EOBR Processing Report, for "_$P(^AUTTLOC(DUZ(2),0),U,2)_"."
 F %="ACHSRPT","ACHSEOBD","ACHSISAO" S ZTSAVE(%)=""
 D ^%ZTLOAD
 G:'$D(ZTSK) ABEND
ENDX ;EP
 S IONOFF=""
 D CLOSEALL^ACHS,KILL^AZZZEOBB
 KILL DIR
 W !!
 D RTRN^ACHS
 Q
 ;
ABEND ;EP
 G ENDX
 ;
SAVDCR(S) ;EP - Save DCR amounts for EOB Summary Report
 ; S = "B" for begin values, "E" for end values.
 NEW Y
 S Y=0
 F  S Y=$O(ACHSFYWK(DUZ(2),Y)) Q:'Y  S ^ACHSEOBR("DCR",Y,S)=^ACHS(9,DUZ(2),"FY",Y,"W",ACHSFYWK(DUZ(2),Y),1)
 Q
 ;
