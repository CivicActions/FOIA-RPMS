BMCRRSP ; IHS/PHXAO/TMJ - Secondary Providers By User Created/Timeframe [ 11/18/2003  11:36 AM ]
 ;;2.0;REFERRED CARE INFO SYSTEM;**2**;JAN 20, 2004
 ;BMC*2.0*2 11.12.03 IHS/ITSC/FCJ ADDED SECTION TO ASK REF TYPE
 ;
 ;
 ;Patch #1 - New Report for Secondary Provider Workload
 ;
 W !?10,"********  SECONDARY PROVIDER LETTERS BY DATE OF RECORDING  ********",!
 W !!,"This report will print a list of all Secondary Provider Letters that were ",!,"initiated in a date range entered by the user.",!
 W !,"This report allows User to Select and report for a INDIVIDUAL FACILITY Only!!",!
 W !,"This report also allows the User to Select a particular USER WHO CREATED",!,"the Letter ",!
 W !,"Inhouse Referrals are NOT included.",!
ASK ;
 W ! S DIC="^AUTTLOC(",DIC("A")="Enter Facility Name: ",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G XIT
 S BMCFAC=+Y
 ;
ASK1 ;Restrict to a Certain User who created the Letter
 S BMCCREV=0
 W ! S DIR(0)="Y0",DIR("A")="Would you like to Restrict Report to a particular User Who Created the Letter",DIR("B")="NO"
 S DIR("?")="To RESTRICT Report to a particular User - Answer Yes."
 D ^DIR K DIR
 G:$D(DIRUT) ASK
 I 'Y G BD
REV ;User Who Created
 S BMCCREV=0
 S DIC="^VA(200,",DIC(0)="AEQM",DIC("A")="Enter the Name of the User: "
 D ^DIC K DIC
 Q:$D(DIRUT)
 G:Y=0 BD
 S BMCCREV=+Y
 ;
 ;
 ;
BD ;get beginning date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning Letter Date Range" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G ASK
 S BMCBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BMCBD_"::EP",DIR("A")="Enter ending Letter Date Range"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BMCED=Y
 S X1=BMCBD,X2=-1 D C^%DTC S BMCSD=X
 ;BMC*2.0*2 11.12.03 IHS/ITSC/FCJ ADDED NEXT SECTION TO ASK REF TYPE
ASKT ;ASK REFERRAL TYPE
 S DIR(0)="S^C:CHS;I:IHS (ANOTHER FACILTIY);O:OTHER;A:ALL (Excluding IN-HOUSE Referrals)"
 S DIR("B")="C",DIR("A")="Enter the Referral type or A for All"
 D ^DIR
 G:(Y="^")!(Y="") ASK
 S BMCCTYP=Y
 ;BMC*2.0*2 11.12.03 IHS/ITSC/FCJ END OF CHANGES
ZIS ;call to XBDBQUE
 K BMCOPT
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) XIT
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRRSPP",XBRC="^BMCRRSP1",XBRX="XIT^BMCRRSP",XBNS="BMC"
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRRSPP"")"
 S XBRC="^BMCRRSP1",XBRX="XIT^BMCRRSP",XBIOP=0 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR20 ; IHS/PHX/TMJ 11/25/98 Kill off Additional Local variables
 K BMCBD,BMCBT,BMCBTH,BMCCOL,BMCD,BMCDA,BMCDATE,BMCED,BMCET,BMCFILE,BMCG,BMCHRN,BMCIOM,BMCJOB,BMCNODE,BMCODAT,BMCOPT,BMCP,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCWP,BMCX,BMCC
 ;BMC*2.0*2 11.12.03 IHS/ITSC/FCJ ADDED BMCCTYP TO NXT LINE
 K BMCLOCC,BMCLOCI,BMCLOCP,BMCLOCPP,BMCCREV,BMCCTYP ;BMC*2.0*2
 D KILL^AUPNPAT
 K %,C,D0,DA,DFN,DI,DIC,DIQ,DIR,DIRUT,DIWF,DIWL,DIWR,DR,DTOUT,F,I,X,Y,Z
 Q
