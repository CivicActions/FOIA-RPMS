APCDCAF9 ; IHS/CMI/LAB - INITIALIZE VARS ;
 ;;2.0;IHS PCC SUITE;**26,27**;MAY 14, 2009;Build 64
 ;
 ;
 ;
HELPSC ;EP
 D EN^DDIOL("Enter any of the following that you want excluded")
 D EN^DDIOL("from the coding queue:")
 D EN^DDIOL(" ")
 Q
EHRESP ;EP
 I $D(IOF) W @IOF
 W !!,"EHR Coding Queue Parameter Update",!
 NEW APCDA,APCDSITE
 K DIC
 S DIC="^APCDSITE(",DIC(0)="AEMQ",DIC("B")=$P(^DIC(4,DUZ(2),0),U)
 D ^DIC K DIC
 I Y=-1 D ^XBFMK Q
 S APCDSITE=+Y
 D EDIT
 W !!,"You have the option of seeing all visits in the coding queue"
 W !,"regardless of how they were created.  You can see all visits or"
 W !,"limit the list of visits in the coding queue to only those"
 W !,"on which a provider has been entered.  If you choose to only"
 W !,"see visits on which a provider was entered then you will not"
 W !,"see visits that were created by an ancillary package.  Most,"
 W !,"if not all visits created by EHR users will have provider."
 W !! S DIE="^APCDSITE(",DA=APCDSITE,DR=".28Include all visits in the coding queue list?" D ^DIE K DIE,DR,DA
 W ! S DIE="^APCDSITE(",DA=APCDSITE,DR=".29Default Response for 'Is Coding Complete?' in Data Entry" D ^DIE K DIE,DR,DA
 W ! S DIE="^APCDSITE(",DA=APCDSITE,DR=".32Require Chart Deficiency Reason on Visits marked as Incomplete?" D ^DIE K DIE,DR,DA
 W ! S DIE="^APCDSITE(",DA=APCDSITE,DR=".39Send a Notification to a provider for a chart deficiency?" D ^DIE K DIE,DR,DA
 W ! S DIE="^APCDSITE(",DA=APCDSITE,DR=".38Number of days to chart w/ deficiencies is delinquent" D ^DIE K DIE,DR,DA
 W !!
 S DIR(0)="S^N:DO NOT DISPLAY PRIMARY/SECONDARY DX WARNING;Y:YES, DISPLAY PRIMARY/SECONDARY DX WARNING",DIR("A")="PRIMARY/SECONDARY DIAGNOSIS WARNING STATUS"
 S DIR("B")=$$VALI^XBDIQ1(9001001.2,APCDSITE,.41) KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G XIT
 S APCDA=Y,DIE="^APCDSITE(",DA=APCDSITE,DR=".41///"_APCDA D ^DIE K DIE,DR,DA
XIT ;
 D ^XBFMK K APCDSITE,APCDA
 Q
DISPSC ;
 W !!,"Service Category exclusions:  If you would like to exclude"
 W !,"visits with a particular service category from the list of"
 W !,"visits displayed in the coding queue you must enter those"
 W !,"service categories to the list below.  For example, if you"
 W !,"do not wish to have I - In Hospital visits in the list then"
 W !,"you should add 'I' to the list."
 W !,"Please note:  If you leave the list blank (empty) then all"
 W !,"direct (non-CHS) visits will display in the coding queue."
 W !,"Historical EVENT visits never display in the coding queue.",!!
 W !,"Your site is currently set up to exclude visits with the"
 W !,"following service categories from the coding queue:"
 I '$O(^APCDSITE(APCDSITE,13,0)) W !!,"None selected, All visit service categories will be included",!,"in the coding queue." Q
 S X=0 F  S X=$O(^APCDSITE(APCDSITE,13,X)) Q:X'=+X  W !?10,$P(^APCDSITE(APCDSITE,13,X,0),U)," - ",$$EXTSET^XBFUNC(9000010,.07,$P(^APCDSITE(APCDSITE,13,X,0),U))
 Q
EDIT ;
 D DISPSC
 S DIR(0)="S^A:Add another service category to the list;R:Remove a service category from the list;Q:Quit - list looks good"
 S DIR("A")="Do you wish to",DIR("B")="Q" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y="Q" Q
 I Y="A" D ADD
 I Y="R" D REMOVE
 G EDIT
ADD ;add to list of service categories
 K DIR
 S DIR(0)="S^A:AMBULATORY;H:HOSPITALIZATION;I:IN HOSPITAL;C:CHART REVIEW;T:TELECOMMUNICATIONS;D:DAY SURGERY;O:OBSERVATION;R:NURSING HOME;N:NOT FOUND;M:TELEMEDICINE"
 S DIR("A")="Add which one" K DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y="" Q
 S APCDA=Y
 I $D(^APCDSITE(APCDSITE,13,"B",APCDA)) W !,"That one is already on the list.",! Q
 D ^XBFMK
 S X=APCDA,DA(1)=APCDSITE,DIC("P")=$P(^DD(9001001.2,1301,0),U,2),DIC(0)="L",DIC="^APCDSITE("_APCDSITE_",13,"
 K DD,D0 D FILE^DICN
 I Y=-1 W !!,"adding service category failed." H 2 Q
 Q
REMOVE ;
 I '$O(^APCDSITE(APCDSITE,13,0)) W !!,"There are none to remove!" Q
 K DIR
 K APCDX S APCDY=""
 S X=0 F  S X=$O(^APCDSITE(APCDSITE,13,X)) Q:X'=+X  D
 .;W !?10,$P(^APCDSITE(APCDSITE,13,X,0),U)," - ",$$EXTSET^XBFUNC(9000010,.07,$P(^APCDSITE(APCDSITE,13,X,0),U))
 .S APCDV=$P(^APCDSITE(APCDSITE,13,X,0),U)
 .S APCDY=APCDY_$S($D(APCDX):";",1:"")_APCDV_":"_$$EXTSET^XBFUNC(9000010,.07,APCDV)
 .S APCDX(APCDV)=X
 S DIR("A")="Remove which one",DIR(0)="S^"_APCDY K DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y="" Q
 S APCDA=Y
 D ^XBFMK
 S DIE="^APCDSITE("_APCDSITE_",13,",DA(1)=APCDSITE,DA=APCDX(APCDA),DR=".01///@" D ^DIE
 Q
CAH(L) ;EP
 I '$G(L) Q 0
 Q $P($G(^APCDSITE(L,0)),U,33)
