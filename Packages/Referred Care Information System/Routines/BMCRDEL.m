BMCRDEL ; IHS/PHXAO/TMJ - REFERRAL DELETE ;      
 ;;4.0;REFERRED CARE INFO SYSTEM;**15**;JAN 09, 2006;Build 168
 ;IHS/OIT/FCJ ADDED ABILITY TO DELETE SEC REF
 ;4.0*15 4.20.2023 IHS.OIT.FCJ ADD PREFERRED NAME FOR SCREEN DISPLAYS
 ;
PRIM ;FILTER FOR PRIMARY REFERRAL AND CLOSED
 S DIC("S")="I $$FILTER^BMCFLTR(0,0,0)"
 S DIC("A")="Select RCIS REFERRAL by Patient or by Referral Date or #: "
 S BMCTYPR="P"
REF ;REFERRAL DELETE
 S DIC="^BMCREF(",DIC(0)="AEMQS"   ;BMC*4.0*15 ADDED "S" TO DIC(0)
 D GETREF
 I Y<1 W !!,"No REFERRAL selected!" D EOJ Q
 I BMCTYPR="P",$D(^BMCREF("S",$P(^BMCREF(BMCRIEN,0),U,2))) D  D EOJ Q
 .W !!,"Primary Referral cannot be Deleted, because a Secondary Ref exists.",!
 .S DIR(0)="E",DIR("A")="Press any key to continue" D ^DIR K DIR
 D DSPLY
 D DELETE
 D EOJ
 Q
SECREF ;EP; DELETE SECONDARY REFERRAL
 S BMCTYPR="S"
 ;S DIC="^BMCREF(",DIC(0)="AEMQS",DIC("S")="I $$FILTER^BMCFLTR(0,0,1)"   ;BMC*4.0*15 SET IN REF
 S DIC("S")="I $$FILTER^BMCFLTR(0,0,1)"          ;BMC*4.0*15
 S DIC("A")="Select Secondary RCIS REFERRAL by Patient or by Referral Date: "
 G REF
 Q
 ;
GETREF ; GET REFERRAL IEN - Do Not Display Closed Referrals
 W !!
 S BMCQ=1
 D DIC^BMCFMC
 Q:Y<1
 S BMCRIEN=+Y
 S BMCQ=0
 Q
 ;
DSPLY ;
 S BMCRDSP=BMCRIEN D START2^BMCRDSP
 W !!,"THE ABOVE REFERRAL AND RELATED ENTRIES WILL BE REMOVED FOREVER !!!"
 Q
 ;
DELETE ; DELETE VISIT AND RELATED V FILES
 W !,"Sure you want to delete" S %=2 D YN^DICN S %Y=$E(%Y)
 Q:"Nn"[%Y
 S BMCRDLT=BMCRDSP D ^BMCRDLT
 I $D(^BMCREF(BMCRDSP,0)) D MSG
 Q
 ;
EOJ ; EOJ HOUSE KEEPING
 K %,%DT,%X,%Y,C,DIYS,X,Y
 K BMCTYPR,BMCRIEN,BMCRDSP,BMCRDLT
 Q
 ;
MSG ;No Delete of Referral Message 
 W !!,?10,"The Selected Referral was NOT deleted.......",!,?10,"This Referral either contains required Contract Health Service Data!!",!
 W ?10,"OR the Referral has been CLOSED & the PCC Visit Link Created!",!!
 H 5 Q
 Q
