BMCRR14 ; IHS/PHXAO/TMJ - list patients for which medical and/or cost data has not been received ;   
 ;;4.0;REFERRED CARE INFO SYSTEM;**16**;JAN 09, 2006;Build 168
 ;MENU OPTION: RRR-Referral Review Report - By Time Period
 ;4.0*16 2.15.2024 IHS.OIT.FCJ Format for CSV
 ;
 ;
 W !?10,"********  REVIEW LISTING BY DATE OF SERVICE  ********",!
 W !!,"This report will print a list of all Primary referrals that were initiated in a",!,"date range entered by the user.  This report can be used by the"
 W !,"CHS or Managed Care Committee to review the referrals.",!
 W !,"Inhouse Referrals are NOT included.",!
BD ;get beginning date
 W !! S DIR(0)="D^::EP",DIR("A")="Enter beginning Referral Initiated Date" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G XIT
 S BMCBD=Y
ED ;get ending date
 W ! S DIR(0)="D^"_BMCBD_"::EP",DIR("A")="Enter ending Referral Initiation Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S BMCED=Y
 S X1=BMCBD,X2=-1 D C^%DTC S BMCSD=X
ZIS ;call to XBDBQUE
 K BMCOPT,DA
 S BMCCSV=""     ;BMC*4.0*16
 ;SPLIT NXT LINE ADDED CSV FORMAT;BMC*4.0*16
 ;S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen;C:CSV Output",DIR("A")="Do you wish to",DIR("B")="P"
 S DIR("??")="^D CSV^BMCHELP"     ;BMC*4.0*16
 W ! D ^DIR K DIR
 I $D(DIRUT) S BMCQUIT="" Q
 S BMCOPT=Y
 G:$G(BMCQUIT) XIT
 I $G(BMCOPT)="B" D BROWSE,XIT Q
 S XBRP="^BMCRR14P",XBRC="^BMCRR141",XBRX="XIT^BMCRR14",XBNS="BMC"
 I $G(BMCOPT)="C" D XPRTCSV,XIT Q   ;BMC*4.0*16
 D ^XBDBQUE
 D XIT
 Q
BROWSE ;
 S XBRP="VIEWR^XBLM(""^BMCRR14P"")"
 S XBRC="^BMCRR141",XBRX="XIT^BMCRR14",XBIOP=0 D ^XBDBQUE
 Q
XPRTCSV ;Export data to CSV file Format(Excel);BMC*4.0*16
 ;print a comma delimited report
 S BMCCSV=1
 S BMCSPRTR=","
 D ^XBDBQUE
 Q
XIT ;EP - CALLED FROM BMCRR14
 K BMCBD,BMCBT,BMCBTH,BMCCOL,BMCD,BMCDA,BMCDATE,BMCED,BMCET,BMCFILE,BMCG,BMCHRN,BMCIOM,BMCJOB,BMCNODE,BMCODAT,BMCOPT,BMCP,BMCPG,BMCPN,BMCQUIT,BMCRCNT,BMCREF,BMCRREC,BMCSD,BMCWP,BMCX,BMCC
 K BMCLOCC,BMCLOCI,BMCLOCP,BMCLOCPP
 D KILL^AUPNPAT
 K %,C,D0,DA,DFN,DI,DIC,DIQ,DIR,DIRUT,DIWF,DIWL,DIWR,DR,DTOUT,F,I,X,Y,Z
 Q
