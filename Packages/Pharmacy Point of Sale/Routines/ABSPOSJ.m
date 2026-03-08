ABSPOSJ ;IHS/GDIT/AEF - the input in 9002335.591 moves to 9002335.59 [ 04/28/2000  5:35 PM ]
 ;;1.0;PHARMACY POINT OF SALE;**54**;JUN 01, 2001;Build 131
 ; (c) 2000 Informatix Laboratories Corporation
 Q
MOREINS ; not yet
 ; Situation:  if some have insurance and others don't,
 ; for each one that doesn't, look for insurance info on another
 ; claim for the same visit, and copy that same insurance info to
 ; this visit.
 Q
SUBMIT(N591,ECHO)       ; submit the claims in ^ABSPEC(9002335.591,N591)
 ; at this point, <F1>E (or the equivalent) as been hit
 ; go through the claims one at a time, trying to submit them
 I '$D(ECHO) S ECHO=1
 I $G(ECHO) W "Submitting claims to Point of Sale processing...",! H 1
 N N5912 S N5912=0
 F  S N5912=$O(^ABSPEC(9002335.591,N591,2,N5912)) Q:'N5912  D
 . D SUBMIT1(N591,N5912,ECHO)
 I $G(ECHO) W "Done",! H 1
 Q
WAITFOR()          Q 10*60 ; 
OKAY ; Is it okay to submit this claim? (avoiding resubmits of paid
 ; claims, claims in progress)
 ; Returns 1 if okay, maybe 1^remark
 ; Returns 0^reason if not okay
 N STAT59 S STAT59=$P($G(^ABSPEC(9002335.59,RXI,0)),U,2)
 I STAT59=""!(STAT59=99) G CHECK57
 N NOW,%,%H,%I,X D NOW^%DTC S NOW=%
 N TIME S TIME=$P(^ABSPEC(9002335.59,RXI,0),U,8) ; last update
 N TIMEDIFI S TIMEDIFI=$$TIMEDIFI^ABSBPOS(TIME,NOW)
 ;  5. submitted, incomplete, last update long ago
 ;                      - allow it to be resubmitted
 ;  6. submitted, incomplete, last update not so long ago
 ;                      - refuse - no, you may not do this
 I TIMEDIFI<$$WAITFOR Q "0^IN PROGRESS - LAST UPDATE "_$$TIMEDIF^ABSPOSUD(TIME,NOW)_" AGO"  ;ABSP*1.0*54
CHECK57 ; check records of completed claim submissions
 ;  1. never before submitted through point of sale - easy
 I '$D(^ABSPEC(9002335.57,"RXIRXR",RXI,RXR)) G PAST57
 N N57 S N57=$O(^ABSPEC(9002335.57,"RXIRXR",RXI,RXR,""),-1)
 N CATEG S CATEG=$$CATEG^ABSPOSUC(N57)   ;ABSP*1.0*54
 ;  2. submitted, rejected - yes, allow it again
 I CATEG="E REJECTED" Q 1_U_"PREVIOUSLY REJECTED"
 ;  3. submitted, paid or duplicate paid - refuse,
 ;     offer to reverse the claim instead
 I CATEG="E PAYABLE"!(CATEG="E DUPLICATE") Q 0_U_"MUST REVERSE PAID CLAIM BEFORE RESUBMITTING"
 ;  4. paper claim - refuse,
 ;     offer to reverse the claim instead
 I CATEG="PAPER" Q 0_U_"MARKED FOR PAPER CLAIM - MUST REVERSE IT FIRST"
 ;  Passed all the tests
 Q 1
SUBMIT1(N591,N5912,ECHO) ;
 N RXI,RXR,DATE,PAT,DRUGNAME,NDC,PREAUTH,PRICING
 D SETVARS ; the ones listed in the preceding line
 F  Q:$$LOCK  W:ECHO "."
 N OKAY S OKAY=$$OKAY I OKAY D
 . I RXI S OKAY=$$SUBMIT59 ; actually submit it into file .59
 . ; E  I 'RXI then put something in V CPT or wherever?
 . ; or put in into .59 anyway
 D UNLOCK
 I 'OKAY,ECHO D
 . W "Problem with " D BRIEF W ! ; BRIEF uses N591,N5912,the SETVARS
 . W ?5,$P(OKAY,U,2)
 Q:$Q OKAY Q
BRIEF ;W "`",RXI," ",$P(^DPT(PAT,0),U)," ",DRUGNAME Q
 W "`",RXI," ",$P(^DPT(PAT,0),U)_$$PPN1^ABSPUTL(PAT)," ",DRUGNAME Q    ;IHS/GDIT/AEF 3240110 - ABSP*1.0*54 FID 77888
SETVARS N R0 S R0=^ABSPEC(9002335.591,N591,2,N5912,R0)
 S RXI=$P(R0,U),NDC=$P(R0,U,3),PAT=$P(R0,U,4)
 S DRUGNAME=$P(R0,U,5),PREAUTH=$P(R0,U,6),DATE=$P(R0,U,7),RXR=$P(R0,U,8)
 S PRICING=$G(^ABSPEC(9002335.591,N591,2,N5912,5))
 I $E(RXI)="`" D  ; it's `ien
 . S RXI=$E(RXI,2,$L(RXI)) S:RXR="" RXR=0
 E  D
 . I RXI I 0/0 ; want to guarantee that numeric means ^PSRX pointer
 . ; so from here on in we can say   I RXI then it's ^PSRX(RXI)
 . ;  and I 'RXI then it's not in ^PSRX
 . S RXR="" ; no prescription, it was a visit lookup
 Q
LOCK L +(^ABSPEC(9002335.57),^ABSPEC(9002335.59)):5 Q $T
UNLOCK L -^ABSPEC(9002335.57),-^ABSPEC(9002335.59) Q
SUBMIT59 ;
 Q 1
TIMEDIFF ;
 Q 0
PAST57 ;
 Q
