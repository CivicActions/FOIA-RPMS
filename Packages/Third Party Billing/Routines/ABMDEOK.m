ABMDEOK ; IHS/SD/SDR - Approve Claim for Billing ;   
 ;;2.6;IHS 3P BILLING SYSTEM;**9,19,29,30,34,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/ASDS/SDH 03/12/01 2.4*9 NOIS XJG-0500-160047 Remove the post pre-payment on the fly functionality
 ;IHS/ASDS/SDH 09/26/01 2.4*9 NOIS NDA-1199-180065 Modified to add prompts for Unbillable secondary stuff
 ;
 ;IHS/SD/SDR 2.5*9 IM19585 Added code to check status of active insurer; change to initiated if complete
 ;
 ;IHS/SD/SDR 2.6*19 HEAT193348 Made change to stop duplicate bill from creating in A/R.  If the 3P Bill entry
 ;  thought it was incomplete for some reason, it would delete the 3P Bill without checking for the A/R Bill.  The
 ;  A/R Bill would have created when the 3P Claim was approved.  Updated the statuses of the 3P Bill check to include
 ;  approved.
 ;IHS/SD/SDR 2.6*29 CR10696 Added check for high bill amount
 ;IHS/SD/SDR 2.6*30 CR8901 Removed code that was changing the status of insurers.
 ;IHS/SD/SDR 2.6*34 ADO60709 Put code back from p30.  If a bill was cancelled, not exported, and re-approved to the same
 ;  insurer a second time the insurer status wasn't getting reset.  The code I added back fixes this and stops programming
 ;  errors:
 ;  a. 837P error is <UNDEF>60+6^ABME5SBR
 ;  b. 837I error is <UNDEF>30+4^ABME5DMG
 ;  c. ADA-2012 error is <UNDEF>SEL+4^ABMDE2X
 ;IHS/SD/SDR 2.6*37 ADO76009 Added check for PI multiple to make sure it's the correct insurer entry to reset the status of
 ;
 ;*************************************
 ;
ERR ;
 I $P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,5) D  G XIT
 . W !!,*7,"  =========================================================================== "
 . W !,"    Fatal ERRORS Exist a Bill can not be Generated until they are Resolved!    "
 . W !,"  =========================================================================== ",!
 . D HLP^ABMDERR
 ;
UNBIL ;
 I $P($G(^AUTNINS($P(^ABMDCLM(DUZ(2),ABMP("CDFN"),0),U,8),1)),U,7)=4 D  G XIT
 . W !!,*7,"  =========================================================================== "
 . W !,"    Primary Insurer is Designated as UNBILLABLE and thus can not be billed!    "
 . W !,"  =========================================================================== ",!
 . D HLP^ABMDERR
 ;
 D ^ABMDESM
 K ABMLOC
 ;start new code abm*2.6*9 NOHEAT - ensure UFMS is setup
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)="" D  Q
 .W !!,"* * UFMS SETUP MUST BE DONE BEFORE ANY BILLING FUNCTIONS CAN BE USED! * *",!
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 ;end new code
 I $P($G(^ABMDPARM(DUZ(2),1,4)),U,15)=1 D  Q:+$G(ABMUOPNS)=0
 .S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 .I +$G(ABMUOPNS)=0 D  Q
 ..W !!,"* * YOU MUST SIGN IN TO BE ABLE TO PERFORM BILLING FUNCTIONS! * *",!
 ..S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q:($G(ABMSFLG)=1)
 I $G(ABMP("TOT"))'>0 D
 . S ABMP("TOT")=ABMP("TOT")+$G(ABMP("WO"))+$G(ABMP("CO"))
 ;
BGEN ;
 S ABMULMT=$$UPPERLMT  ;abm*2.6*29 IHS/SD/SDR CR10696
 I ABMULMT=1 Q  ;stop if they said no, don't acknowledge bill amount  ;abm*2.6*29 IHS/SD/SDR CR10696
 W !
 S DIR(0)="Y"
 S DIR("A")="Do You Wish to APPROVE this Claim for Billing"
 S DIR("?")="If Claim is accurate and Transfer to Accounts Receivable File is Desired"
 D ^DIR
 K DIR
 G:$D(DIRUT)!$D(DIROUT)!(Y'=1) XIT
 I Y=1,+$G(ABM("W"))'=0 D ADJMNT
 I Y=1,+$G(ABM("W"))'=0 S ABMULMT=$$UPPERLMT  ;abm*2.6*29 IHS/SD/SDR CR10696
 I Y=1,+$G(ABM("W"))'=0 I ABMULMT=1 Q  ;stop if they said no, don't acknowledge bill amount  ;abm*2.6*29 IHS/SD/SDR CR10696
 ;
BIL ;
 S DA=0
 S DIK="^ABMDBILL(DUZ(2),"
 F  S DA=$O(^ABMDTMP(ABMP("CDFN"),DA)) Q:'DA  D  K ^ABMDTMP(ABMP("CDFN"),DA)
 .Q:'$D(^ABMDBILL(DUZ(2),DA,0))
 .Q:+$P(^ABMDBILL(DUZ(2),DA,0),U)'=ABMP("CDFN")
 .;Q:"BTPC"[$P(^ABMDBILL(DUZ(2),DA,0),U,4)  ;abm*2.6*19 IHS/SD/SDR HEAT193348
 .Q:"ABTPC"[$P(^ABMDBILL(DUZ(2),DA,0),U,4)  ;approved, billed, transferred, partial payment, or complete - skip  ;abm*2.6*19 IHS/SD/SDR HEAT193348
 .W !!,*7,"Bill Number ",$P(^ABMDBILL(DUZ(2),DA,0),U)
 .W " was previously created from this claim"
 .W !,"but was not completed. It is now being removed!..."
 .D ^DIK
 W !!,"Transferring Data...."
 ;if active insurer and status is complete, make it initiated
 ;abm*2.6*34 IHS/SD/SDR ADO60709 - put the below section of code back in
 ;start old abm*2.6*30 IHS/SD/SDR CR8901
 S I=0
 F  S I=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I)) Q:'I  D
 .I ($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)),U)=ABMP("INS")!($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)),U,11)=ABMP("INS"))),"CB"[($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)),U,3)) D
 ..I ((+$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)),U,8)'=0)&($P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0)),U,8)'=$P($G(^ABMDCLM(DUZ(2),ABMP("CDFN"),0)),U,26))) Q  ;not the right entry  ;abm*2.6*37 IHS/SD/SDR ADO76009
 ..S DA(1)=ABMP("CDFN")
 ..S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 ..S DA=I
 ..S DR=".03////I"
 ..D ^DIE
 ..K DR
 ;end old abm*2.6*30 IHS/SD/SDR CR8901
 D ^ABMDEBIL
 I '$D(ABMP("BDFN")) D  G XIT
 .K DIR
 .S DIR(0)="EO"
 .D ^DIR
 ;
 S ABMP("OVER")=""
 S DIE="^ABMDCLM(DUZ(2),"
 S DA=ABMP("CDFN")
 S DR=".04////U"
 D ^DIE
 K DR
 N I
 S I=0
 F  S I=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I)) Q:'I  D
 .Q:$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),13,I,0),"^",3)'="I"
 .S DA(1)=DA
 .S DIE="^ABMDCLM(DUZ(2),"_DA(1)_",13,"
 .S DA=I
 .S DR=".03////B"
 .D ^DIE
 .K DR
 K ^ABMDTMP(ABMP("CDFN"))
 I $E($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U),$L($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U)))="A" D
 . I $O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,0)) D
 .. S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),11,0))
 .. I $D(^AUPNVSIT(DA,0)) D
 ... S DIE="^AUPNVSIT("
 ... S DR="1101////"_ABMP("TOT")
 ... D ^ABMDDIE
 ;
XIT ;
 Q
 ;
 ;*******************************
EOP ;
 W $$EN^ABMVDF("IOF")
 Q
 ;
 ;*******************************
ADJMNT ;
 Q:$G(ABMSPLFG)=1  ;flag that transactions are split (see ^ABMPPFLR)
 S EXP=""
 S ABMCNT=0
 F  S EXP=$O(ABMP("EXP",EXP)) Q:EXP=""  S ABMCNT=ABMCNT+1
 Q:ABMCNT>1
 F  D  Q:ABMFLAG=1
 .S ABMFLAG=0
 .W !!,"CURRENT ADJUSTMENTS:"
 .I $G(ABMP("WO")) D
 ..W !,"         Write-off:  ",$G(ABMP("WO"))
 .I $G(ABMP("DED")) D
 ..W "                  Deductible:  ",$G(ABMP("DED"))
 .I $G(ABMP("NONC")) D
 ..W !,"      Non-covered:  ",$G(ABMP("NONC"))
 .I $G(ABMP("COI")) D
 ..W "              Co-insurance:  ",$G(ABMP("COI"))
 .I $G(ABMP("GRP")) D
 ..W !,"Grouper allowance:  ",$G(ABMP("GRP"))
 .I $G(ABMP("PENS")) D
 ..W !,"        Penalties:  ",$G(ABMP("PENS"))
 .I $G(ABMP("REF")) D
 ..W !,"           Refund:  ",$G(ABMP("REF"))
 .S DIR(0)="Y"
 .S DIR("A")="Include any adjustments in billed amount?"
 .S DIR("B")="Y"
 .K Y
 .D ^DIR K DIR
 .I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) S ABMFLAG=1 Q
 .I Y'=1 S ABMFLAG=1 Q
 .I Y=1 D
 ..S DIR(0)="N^::2"
 ..S DIR("A")="Write-off Amount to bill"
 ..S DIR("B")=$G(ABMP("WO"))
 ..K Y
 ..D ^DIR K DIR
 ..I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) S ABMFLAG=1 Q
 ..S ADJ=Y
 ..I ADJ>0 D
 ...S BILL=$G(ABMP("EXP",ABMP("EXP")))
 ...W !!,"Ok, I will add $",ADJ," to $",BILL," for a total billed amount of $",ADJ+BILL
 ...S DIR(0)="Y"
 ...S DIR("A")="OK?"
 ...S DIR("B")="Y"
 ...K Y
 ...D ^DIR K DIR
 ...I $D(DTOUT)!$D(DIROUT)!$D(DIRUT)!$D(DUOUT) S ABMFLAG=1 Q
 ...I Y=1 S ABMP("EXP",ABMP("EXP"))=$G(ABMP("EXP",ABMP("EXP")))+ADJ,ABMFLAG=1,ABMP("WO")=ABMP("WO")-ADJ
 Q
 ;
 ;start new abm*2.6*29 IHS/SD/SDR CR10696
UPPERLMT() ; EP
 ;returns 0 to continue approve
 ;        1 to quit and go back into claim
 S ABMULMT=0
 S ABMPULMT=+$P($G(^ABMDPARM(DUZ(2),1,2)),U,15)  ;SITM upper limit
 S ABMEULMT=0
 ;
 I $D(ABMP("EXP")) D  ;if there are export modes (meaning NOT from ADMG option
 .S ABMI=0
 .F  S ABMI=$O(ABMP("EXP",ABMI)) Q:'ABMI  D
 ..S ABMEULMT=+$P($G(^ABMDEXP(ABMI,1)),U,6)
 ..S ABMBAMT=$G(ABMP("EXP",ABMI))
 ..D ULMTCK  ;does checks and sets flags
 ..I ABMUBFLG'="" D ULMTMSG
 I '$D(ABMP("EXP")) D
 .D ULMTCK
 .I ABMUBFLG'="" D ULMTMSG
 W !
 S ABMULMT=0
 Q:(ABMUBFLG="") ABMULMT  ;quit if neither check failed
 S DIR(0)="Y"
 S DIR("A")="Do you acknowledge the amount"
 S DIR("B")="N"
 D ^DIR
 K DIR
 I $D(DIRUT)!$D(DIROUT)!(Y'=1) S ABMULMT=1
 Q ABMULMT
 ;
ULMTCK ; EP
 S ABMUBFLG=""
 I (('ABMEULMT)&('ABMPULMT)) Q  ;neither is populated - stop here and continue approval process
 ;changed below during internal testing abm*2.6*29; felt that equals shouldn't drop the message
 ;I ((ABMEULMT>0)&(ABMBAMT>ABMEULMT!(ABMBAMT=ABMEULMT))) S ABMUBFLG="E"
 I ((ABMEULMT>0)&(ABMBAMT>ABMEULMT)) S ABMUBFLG="E"
 I ((ABMUBFLG="")&(ABMPULMT>0)) D
 .;I ((ABMBAMT>ABMPULMT)!(ABMBAMT=ABMPULMT)) S ABMUBFLG="P"
 .I ((ABMBAMT>ABMPULMT)) S ABMUBFLG="P"
 Q
ULMTMSG ; EP
 S ABMUBAMT=$S(ABMUBFLG="E":ABMEULMT,1:(ABMPULMT))  ;just in case both are populated, export mode first
 W !!,$$EN^ABMVDF("RVN"),"WARNING: The "_$S((+$G(ABMI)'=0):$P(^ABMDEXP(ABMI,0),U)_" ",1:"")_"amount billed ($"_$FN(ABMBAMT,",",2)_") exceeds the"
 W !?4,"UPPER BILL AMOUNT ($"_$FN(ABMUBAMT,",",2)_") set ",$S((ABMUBFLG="E"):"for this Export Mode",1:"in the SITM option")
 W $$EN^ABMVDF("RVF")
 Q
 ;end new abm*2.6*29 IHS/SD/SDR CR10696
