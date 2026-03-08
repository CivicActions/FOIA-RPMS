ABSPOSBB ; IHS/FCS/DRS - POS billing - new ;        [ 03/14/2003  11:18 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**6,7,11,14,19,22,28,31,36,37,38,39,46,48,56**;JUN 1, 2001;Build 131
 ;When a transaction completes, POSTING^ABSPOSBB is called
 ; (the transaction completion happens in ^ABSPOSU)
 ; [Indirectly - via background job (ABSPOSBD)
 ;  Transaction completion merely sets flag (ABSPOSBC)]
 ;You get ABSP57, ptr into ^ABSPTL(ABSP57, from whence comes all trans details
 ;Your posting rtn is called by $$
 ;The result is stuffed into Field .15, POSTED TO A/R (FT field)
 ;
 ;IHS/OIT/RAM 1.0*48 HEAT#135473 CR07534 pass insurer info to 3PB
 ;IHS/SD/SDR 1.0*56 ADO74017 Changed to send complete RX# (was only 7)
 Q
POSTING ; EP - for _all_ billing interfaces w/ABSP57
 ;Based on billing interface, call right rtn
 N X S X=$$ARSYSTEM^ABSPOSB
 N RESULT
 I X=0 D
 .S RESULT=$$POST^ABSPOSBW
 E  I X=1 D
 .S RESULT=""  ;none
 E  I X=2 D
 .S RESULT=$$POST^ABSPOSBT  ;ANMC nightly checker
 E  I X=3 D
 .S RESULT=$$THIRD  ;IHS Third Party Billing
 E  I X=4 D
 .S RESULT=$$POST^ABSPOSBP  ;PAC Patient Accounts Component (BBM*)
 E  I X=99 D
 .S RESULT=$$POST^ABSPOSBQ  ;other A/R (needs to fill in ABSPOSBQ)
 E  D
 .S RESULT=""
 .;not supported billing system interface
 ;Flag 9002313.57 entry as processed by billing
 I RESULT]"" D
 .N FDA,IEN,MSG
 .S FDA(9002313.57,ABSP57_",",.15)=RESULT
 .D FILE^DIE(,"FDA","MSG")
 .I $D(MSG) D LOG^ABSPOSL2("F^ABSPOSBX",.MSG) ;IHS/OIT/RAM 6.12.2017 LOG IF ERROR OCCURS
 Q
 ;******************************
THIRD()  ;IHS Third Party Billing
 N TX
 S TX=ABSP57
 N INSDFN,AMT,PATDFN,RXI,PRV,VDATE,CLINIC,LOC,ACCT,DISP,UNIT,QTY
 N DRUG,NDC,RXR,CAT,INSNAM,VSTDFN,DA
 N VMEDDFN
 N ABSPOST ;IHS/OIT/SCR p36
 N ABSPQUIT,ABSPRJCT ;IHS/OIT/SCR p37
 N ABSPARAM   ;IHS/OIT/SCR 052610 p39 added to keep rejects from going to 3PB
 S ABSPARAM=$$GET1^DIQ(9002313.99,1,170.02,"I")
 S VSTDFN=$P($G(^ABSPTL(TX,0)),U,7)  ;Visit IEN
 Q:'VSTDFN ""  ;No visit on this trans
 S RXR=$$GET1^DIQ(9002313.57,TX,9,"I")  ;RX IEN refill Mult
 S RXI=$$GET1^DIQ(9002313.57,TX,1.11,"I")  ;RX IEN
 S INSDFN=$$GET1^DIQ(9002313.57,TX,1.06,"I")  ;Insurer IEN
 I 'INSDFN QUIT ""  ;No ins on trans
 ;Get VMEDDFN
 I RXR D
 .S VMEDDFN=$P($G(^PSRX(RXI,1,RXR,999999911)),U)  ;refill
 E  D
 .S VMEDDFN=$P($G(^PSRX(RXI,999999911)),U)  ;first fill
 ;CAT Should be E PAYABLE, E CAPTURED, E REJECTED
 ;Non-electronic ones will usually return as PAPER
 S CAT=$$CATEG^ABSPOSUC(TX,1)  ;Trans cat
 ;Posting of paper clms, next couple of lines
 ;Special only for assistance in setting up Training curriculum
 ;though it could be turned on for any site which so wishes
 ;The "-22" in next line is memorial to Great File Number Fiasco of Two Thousand Aught One
 ;I paper clms, posting of paper clms allowed, G POSTIT, else quit
 I CAT="PAPER" D POSTIT:$$GET1^DIQ(9002335.99-22,"1,",235.04,"I") Q ""
 ;I paper clms and posting of paper clms allowed, D REVERSIT
 I CAT="PAPER REVERSAL" D  Q DA
 .S DA=""
 .I $$GET1^DIQ(9002313.99,"1,",235.04,"I") D REVERSIT
 I CAT'?1"E ".E Q ""  ;Not electronic clms
 ;I CAT["REJECTED" Q ""  ;Rejected clm
 ;IHS/OIT/SCR p37 START send add'l REJECTED info to 3PB
 ;I CAT["REJECTED" D  Q ""
 S ABSPQUIT=0
 I CAT["REJECTED" D
 .;I CAT="E REJECTED" D VMEDSTAT(VMEDDFN,2)  ;2 = POS Rejected
 .D VMEDSTAT(VMEDDFN,2)  ;2 = POS Rejected
 .I ABSPARAM'="Y" S ABSPQUIT=1 Q  ;IHS/OIT/SCR p39 if parm is not 'Y' DON'T SEND
 .S ABSPQUIT=1 Q  ;IHS/OIT/SCR p39 don't send ANY reject info to 3PB until ok'd by federal lead - THEN remove this line  
 .I ABSPARAM="Y" D
 ..N ABSPRSP,ABSPPOS,ABSPREJS,ABSPCNT
 ..S ABSPRSP=$P($G(^ABSPTL(TX,0)),U,5)
 ..S ABSPPOS=$P($G(^ABSPTL(TX,0)),U,9)
 ..D REJTEXT^ABSPOS03(ABSPRSP,ABSPPOS,.ABSPREJS)
 ..;This populates ABSPREJS(n) w/code:text format of ea rejection for this position in response
 ..S ABSPRJCT("RJCTIME")=$P($G(^ABSPR(ABSPRSP,0)),"^",2)
 ..S ABSPCNT=0
 ..F  S ABSPCNT=$O(ABSPREJS(ABSPCNT)) Q:(ABSPCNT=""!ABSPQUIT)  D
 ...S ABSPRJCT(ABSPCNT,"CODE")=$P(ABSPREJS(ABSPCNT),":",1)
 ...I ABSPRJCT(ABSPCNT,"CODE")="85" S ABSPQUIT=1 ;85 Claim Not Processed
 ...I ABSPRJCT(ABSPCNT,"CODE")="95" S ABSPQUIT=1 ;95 Time Out
 ...I ABSPRJCT(ABSPCNT,"CODE")="96" S ABSPQUIT=1 ;96 Scheduled Downtime
 ...I ABSPRJCT(ABSPCNT,"CODE")="97" S ABSPQUIT=1 ;97 Payer Unavailable
 ...I ABSPRJCT(ABSPCNT,"CODE")="98" S ABSPQUIT=1 ;98 Connection to Payer is Down
 ...I ABSPRJCT(ABSPCNT,"CODE")="R8" S ABSPQUIT=1 ;R8 Syntax Error
 ...S ABSPRJCT(ABSPCNT,"REASON")=$P(ABSPREJS(ABSPCNT),":",2)
 ;IHS/OIT/RCS p46 Category 'E OTHER' should not be sent 
 I CAT="E OTHER" S ABSPQUIT=1 ;Considered an error
 Q:ABSPQUIT 0  ;DON'T SEND UN-PROCESSED REJECTIONS TO 3PB; return used update FT .14 field in ABSPT
 ;IHS/OIT/SCR p37 END send add'l REJECTED info to 3PB
 I CAT["DUPLICATE" D  Q:'$$TIMEOUT ""
 .I CAT="E DUPLICATE" D VMEDSTAT(VMEDDFN,1)  ;1 = POS Billed
 I CAT["REVERSAL ACCEPTED" D REVERSIT Q DA  ;Post reversal to A/R
 I CAT="E CAPTURED" D VMEDSTAT(VMEDDFN,2)  ;2 POS Rejected
 I CAT="E PAYABLE" D VMEDSTAT(VMEDDFN,1)  ;1 POS Billed
 ;IHS/OIT/SCR p36 start ;Create 3PB Bill
 S ABSPOST=$$POSTIT(.ABSPRJCT)
 Q ABSPOST
 ;IHS/OIT/SCR p36 end
REVERSIT  ;
 N PRVTX,DIE,DR
 S PRVTX=$$PREVIOUS(TX)  ;Prev trans for RX & refill
 I 'PRVTX S DA="" Q  ;No prev trans
 S DA=$P($G(^ABSPTL(PRVTX,0)),U,15)  ;A/R bill [DUZ(2),IEN]
 Q:'DA  ;A/R bill not specified
 S RXI=$P(^ABSPTL(PRVTX,1),U,11)  ;RX IEN
 S ABSPRX=$$GET1^DIQ(52,RXI,.01)  ;RX#
 Q:'ABSPRX  ;No RX
 ; if posted ABSPWOFF will be DUZ(2),IEN (DA) of A/R bill; else null
 S ABSP("CREDIT")=$$GET1^DIQ(9002313.57,PRVTX,505)  ;$$ to reverse
 S ABSP("ARLOC")=DA  ;A/R Bill loc
 S ABSP("TRAN TYPE")=43  ;Adj
 S ABSP("ADJ CAT")=3  ;W/O
 S ABSP("ADJ TYPE")=135  ;Billed in error
 S ABSP("USER")=$$GET1^DIQ(9002313.57,PRVTX,13)  ;User who entered tran
 N LOC,VISDT
 S LOC=$$GET1^DIQ(9000010,VSTDFN,.06,"I")  ;Loc of Encounter
 S VISDT=$P($P(^AUPNVSIT(VSTDFN,0),U,1),".",1)  ;Visit Dt
 D LOG^ABSPOSL("Reversing transaction "_ABSP57_".")
 ;IHS/OIT/SCR p31 START; pass RXREASON for cancellation
 N ABSPRXRN
 S ABSPRXRN=$$GET1^DIQ(9002313.57,TX,404)  ;RXREASON in ABSP LOG OF TRANS
 S ABSCAN=$$CAN^ABMPSAPI(ABSP("ARLOC"),ABSPRXRN)
 ;Cancel bill in 3PB, pass 'reason' from Pharmacy 7.0
 ;IHS/OIT/SCR p31 END
 D SETFLAG^ABSPOSBC(ABSP57,0)  ;clear "needs billing" flag
 ;S DA=ABSPWOFF
 S DA=ABSP("ARLOC")
 Q
POSTIT(ABSPRJCT)  ;ABSP*1.0T7*6 ;entire paragraph new
 N ABSPOST ;IHS/OIT/SCR p36
 N ABSPCNT ;IHS/OIT/SCR p37
 N ABSPINS ;IHS/OIT/RAM 5.18.2017 p48 CR07534
 S ABSP(.21)=$$GET1^DIQ(9002313.57,TX,505)  ;Total price
 S ABSP(.23)=ABSP(.21)
 S ABSP(.05)=$$GET1^DIQ(9002313.57,TX,5,"I")  ;PDFN
 S ABSP(.71)=$P($P(^AUPNVSIT(VSTDFN,0),U,1),".",1)  ;Vst Dt
 S ABSP(.72)=ABSP(.71)
 S ABSP(.1)=$$GET1^DIQ(9000010,VSTDFN,.08,"I")  ;Clinic Stop IEN
 S ABSP(.03)=$$GET1^DIQ(9000010,VSTDFN,.06,"I")  ;Loc of Enc
 I ABSP(.03)="" D  Q ""  ;IHS/OIT/SCR p36 if no loc of Enc, don't pass to 3PB
 .D SETFLAG^ABSPOSBC(ABSP57,0)  ;clear "needs billing" flag'
 .Q
 S ABSP(.08)=INSDFN
 S ABSP(.58)=$$GET1^DIQ(9002313.57,TX,1.09)  ;Prior Auth
 S ABSP(.14)=$$GET1^DIQ(9002313.57,TX,13,"I")  ;User
 S ABSP(11,.01)=VSTDFN  ;VDFN IHS/OIT/SCR p37
 S ABSP(41,.01)=$S(RXI:$$GET1^DIQ(52,RXI,4,"I"),1:"")  ;Provider
 S ABSP(23,.01)=$$GET1^DIQ(9002313.57,TX,"1.11:DRUG","I")  ;Drug File IEN
 S ABSP(23,.03)=$$GET1^DIQ(9002313.57,TX,501)  ;Qty
 S ABSP(23,.04)=$$GET1^DIQ(9002313.57,TX,502)  ;Unit Price
 S ABSP(23,.05)=$$GET1^DIQ(9002313.57,TX,504)  ;Dispensing Fee
 S ABSP(23,.07)=$$GET1^DIQ(9002313.57,TX,507)  ;Incentive Amt
 S ABSP(23,19)=$$GET1^DIQ(9002313.57,TX,10403)  ;New/Refill code
 S RXI=$$GET1^DIQ(9002313.57,TX,1.11,"I")
 S ABSP(23,.06)=$$GET1^DIQ(52,RXI,.01)  ;RX
 S ABSP(23,14)=$$GET1^DIQ(9002313.57,TX,10401)  ;Dt filled
 S ABSP(23,20)=$$GET1^DIQ(9002313.57,TX,10405)  ;Days supply
 ;IHS/OIT/RAM 5.18.2017 p48 start CR07534 Pass Insurer Info to 3PB
 S ABSPINS=$$GETINSINFO(TX) ;Gather all insurance info for xfer to 3PB
 ;Just in case more info needs to be returned than PRVT multiple, uncomment any needed info from possibilities below
 ;I +$P(ABSPINS,U,1)>0 S ABSP(13,.01)=$P(ABSPINS,U,1) ;Insurer ptr from 701/702/703 field of ^ABSPTL
 ;I +$P(ABSPINS,U,4)>0 S ABSP(13,.04)=$P(ABSPINS,U,4) ;Medicare multiple from 601/602/603 field of ^ABSPTL
 ;I +$P(ABSPINS,U,5)>0 S ABSP(13,.05)=$P(ABSPINS,U,5) ;Railroad multiple from 601/602/603 field of ^ABSPTL
 ;I +$P(ABSPINS,U,6)>0 S ABSP(13,.06)=$P(ABSPINS,U,6) ;Medicaid Eligible ptr from 601/602/603 field of ^ABSPTL
 ;I +$P(ABSPINS,U,7)>0 S ABSP(13,.07)=$P(ABSPINS,U,7) ;Medicaid multiple from 601/602/603 field of ^ABSPTL
 I +$P(ABSPINS,U,8)>0 S ABSP(13,.08)=$P(ABSPINS,U,8) ;Private Insurance multiple from 601/602/603 field of ^ABSPTL
 ;IHS/OIT/RAM 5.18.2017 CR07534 End new detailed above 
 ;IHS/OIT/SCR p37 send reject info
 I $G(ABSPRJCT("RJCTIME")) D
 .S ABSPCNT=0
 .S ABSP(73,"REJDATE")=$G(ABSPRJCT("RJCTIME"))
 .F  S ABSPCNT=$O(ABSPRJCT(ABSPCNT)) Q:ABSPCNT="RJCTIME"  D
 ..S ABSP(73,ABSPCNT,"CODE")=ABSPRJCT(ABSPCNT,"CODE")
 ..S ABSP(73,ABSPCNT,"REASON")=ABSPRJCT(ABSPCNT,"REASON")
 ..Q
 .Q
 ;IHS/OIT/SCR p39 START next 4 lines for COB payer indicator fld
 N ABSP59,ABSPPTYP
 S ABSP59=$$GET1^DIQ(9002313.57,TX,.01)
 S ABSPPTYP=$E($P(ABSP59,".",2),1,1)
 S ABSP(99,0)=$S(ABSPPTYP=2:"S",ABSPPTYP=3:"T",1:"")  ;COB payer indicator, NULL for primary, S for secondary, T for tertiary 
 S ABSP("OTHIDENT")=RXI
 ;start old absp*1.0*56 IHS/SD/SDR ADO74017
 ;S:$L(RXI)>7 ABSP("OTHIDENT")=$E(RXI,$L(RXI)-6,$L(RXI))
 ;S ABSP("OTHIDENT")=$$NFF^ABSPECFM($G(ABSP("OTHIDENT")),7)
 ;end old absp*1.0*56 IHS/SD/SDR ADO74017
 D LOG^ABSPOSL("Posting transaction "_ABSP57_".")
 S ABSPOST=$$EN^ABMPSAPI(.ABSP) ; Call 3PB API
 D SETFLAG^ABSPOSBC(ABSP57,0) ; clear "needs billing" flag
 S DA=ABSPOST
UPDT ;
 Q DA
ZW(%) D ZW^ABSPOSB(%)
 Q
PREVIOUS(N57) ;EP
 ;Get Prev trans for this RX and Refill
 ;N57 TX=Log of Trans file IEN (A/R Posting)
 N RXI,RXR
 S RXI=$P(^ABSPTL(N57,1),U,11)  ;RX IEN
 S RXR=$P(^ABSPTL(N57,1),U)  ;IEN Refill mult of RX
 I RXI=""!(RXR="") Q ""  ;if either value is blank Q
 Q $O(^ABSPTL("NON-FILEMAN","RXIRXR",RXI,RXR,N57),-1)
LAST57(RXI,RXR) ;EP -
 Q $O(^ABSPTL("NON-FILEMAN","RXIRXR",RXI,RXR,""),-1)
TIMEOUT() ;Timed out payable claims?
 ;Following 5.1 conversion, EDS/OK Medicaid had problems w/their connection timing out w/WebMD. EDS/OK Medicaid 
 ;would process clm, BUT POS would time out response from WebMD (EV-16). When the clm is resubmitted in
 ;POS, if payable, OK Medicaid would respond w/duplicate. Dups don't normally pass to ABM/BAR, so we had to 
 ;add extra code to look for this condition
 ;
 ;Here's what we check when response is duplicate:
 ; *We check to make sure previous claim did not post to A/R
 ; *We check to make sure previous claim was not reversed
 ; *We make sure previous claim timed out with EV-16
 ; *We check version for 5.1
 ;we now check for processor timeout; if all this checks out, we want to post it to ABM,BAR
 N ABSPENT,ABSPREC,ABSPRC,ABSPRP,ABSPMSG
 N PRCTO  ;processor timeout
 S ABSPENT=$P($G(^ABSPTL(TX,0)),U)  ;entry# to use in b xref
 S ABSPREC=$O(^ABSPTL("B",ABSPENT,TX),-1)  ;get prev trans
 Q:ABSPREC="" ""  ;we don't have record of dup clm, quit
 Q:$P($G(^ABSPTL(ABSPREC,0)),U,15)'="" ""  ;already posted
 Q:$P($G(^ABSPTL(ABSPREC,4)),U)'="" ""  ;prev one reversed
 S ABSPRC=$P($G(^ABSPTL(TX,0)),U,5)  ;current trans
 Q:$P($G(^ABSPR(ABSPRC,100)),U,2)'[5 ""  ;not 5.1 trans
 S ABSPRP=$P($G(^ABSPTL(ABSPREC,0)),U,5)  ;prev response
 Q:ABSPRP="" ""  ;no prev response -quit
 Q:$P($G(^ABSPR(ABSPRP,100)),U,2)'[5 ""  ;not 5.1 trans
 S ABSPMSG=$P($G(^ABSPR(ABSPRP,504)),U)  ;msg
 S PRCTO=0
 S PRCTO=$$PROCTMOT(ABSPRP,ABSPREC)  ;processor time out?
 Q:(($G(ABSPMSG)'["EV16")&('PRCTO)) ""  ;not time out
 ;from this point, looks like time out that needs posting
 Q 1
PROCTMOT(ABSPRP,ABSPREC) ;check to see if processor timed out; this is different response from switch time out
 ; ABSPPIC-rx order within response
 ; ABSPRXR-rej codes per rx
 ; ABSPTIMO-time out ind for resp
 ; ABSPRP-prev resp IEN (passed in)
 ; ABSPREC-prev log of tran IEN
 N ABSPTIMO,ABSPRXR,ABSPPIC
 Q:(ABSPRP="")!(ABSPREC="")  ;must have to process
 S (ABSPTIMO,ABSPRXR)=0  ;assume no tm out/init loop to 0
 S ABSPPIC=$$GET1^DIQ(9002313.57,ABSPREC,14,"I")  ;pos in prv clm/resp
 I ABSPPIC="" Q ABSPTIMO  ;avoid undef
 F  S ABSPRXR=$O(^ABSPR(ABSPRP,1000,ABSPPIC,511,ABSPRXR)) Q:'+ABSPRXR  D
 .S:$P($G(^ABSPR(ABSPRP,1000,ABSPPIC,511,ABSPRXR,0)),U)=95 ABSPTIMO=1
 Q ABSPTIMO
VMEDSTAT(VMEDDFN,STAT) ;
 ;Populates V MEDICATION (#9000010.14) POINT OF SALE BILLING STATUS (#1106) field
 ;NULL=NOT POS Billed
 ;1=POS Billed
 ;2=POS Rejected
 Q:VMEDDFN=""  ;quit if no vmed file ptr
 Q:'$D(^DD(9000010.14,1106))  ;quit if no fld 1106 in vmed file
 S DIE=9000010.14,DA=VMEDDFN,DR="1106///^S X=STAT"
 D ^DIE
 Q
GETINSINFO(TX) ;IHS/OIT/RAM p48 new rtn to gather all insurer info
 N BEG,END,I,I2,I3,ABSPPINNO,ABSPPINDATA,ABSPINSIEN,ABSPPINTYPE,ABSPELIGIEN,ABSPMULT,ABSPRETURN,ABSPTODAY  ;IHS/OIT/RAM 07534 p48 New parm to hold temp insurance info for 3PB
 S ABSPPINDATA=""  ;verify that "no data" is empty on entry
 S ABSPRETURN=""  ;verify that return value is initialized, return "nothing" if no data
 D NOW^%DTC S ABSPTODAY=X ;Get today's FM date-useful if we have to manually find correct Medicaid Multiple
 ;
 ;Very little documentation on PINS pieces; here's how (I think) they work: 
 ;There are 5 types of PINS insurers: "CAID" (Medicaid),"PRVT"(Private Insurance),"CARE"(Medicare),"SELF PAY" & "RR"(rarely used.)
 ;2nd piece is IEN in ^AUPNMCD, ^AUPNPRVT, ^AUPNMCR, [[ NO GLOBAL ]], & ^AUPNRRE (respective above)
 ;3rd piece is "Multiple" as ea primary node can have multiple subnodes, this value is correct subnode for record
 ;* Warning! * There is currently a bug in ABSP that does _not_ save Medicaid multiple. Patch code below will need to account for that and manually generate correct info
 ;also, not sure if this is 'expected behaviour' but it seems that 'active' insurance is always in PINS 1; but sometimes PINS piece number will point to an empty 2/3/4. Possibly another bug.
 S ABSPPINNO=$$GET1^DIQ(9002313.57,TX,1.08)  ;PINS Piece Number, determine which insurer (primary/secondary/tertiary) we're working with
 I ABSPPINNO=1 S ABSPPINDATA=$$GET1^DIQ(9002313.57,TX,601),ABSPINSIEN=$$GET1^DIQ(9002313.57,TX,701,"I")  ;Ptr to #1-will be the case most of time
 I ABSPPINNO=2 S ABSPPINDATA=$$GET1^DIQ(9002313.57,TX,602),ABSPINSIEN=$$GET1^DIQ(9002313.57,TX,702,"I")  ;Ptr to #2-will probably be broken, but we need to take into account
 I ABSPPINNO=3 S ABSPPINDATA=$$GET1^DIQ(9002313.57,TX,603),ABSPINSIEN=$$GET1^DIQ(9002313.57,TX,703,"I")  ;Ptr to #3-will probably be broken, but we need to take into account
 ;if 1>ABSPPINNO>3, leave ABSPPINDATA empty and don't add info to 3PB. may change if we need to add 'broken' value to 3PB
 W "ABSPPINNO: ",ABSPPINNO," ABSPPINSIEN: ",ABSPINSIEN,!
 I ABSPPINDATA'="" D  ;Only add data if there is actual ABSP PIN data available
 .I +ABSPINSIEN>0 S $P(ABSPRETURN,U,1)=ABSPINSIEN  ;Return the current insurer IEN
 .S ABSPPINTYPE=$P(ABSPPINDATA,",",1)  ;Separate PIN type for further analysis
 .S ABSPELIGIEN=$P(ABSPPINDATA,",",2)  ;Get Elig IEN (not used for "SELF PAY", only passed w/Medicaid
 .S ABSPMULT=$P(ABSPPINDATA,",",3)  ;And multiple IEN -reminder: currently broken for Medicaid
 .I ABSPPINTYPE="RR" S $P(ABSPRETURN,U,5)=ABSPMULT
 .I ABSPPINTYPE="CARE" S $P(ABSPRETURN,U,4)=ABSPMULT
 .I ABSPPINTYPE="PRVT" S $P(ABSPRETURN,U,8)=ABSPMULT
 .I ABSPPINTYPE="CAID" D
 ..;IHS/OIT/RAM Acct for when Medicaid pointer is fixed; if not find data manually
 ..I +ABSPELIGIEN>0 S $P(ABSPRETURN,U,6)=ABSPELIGIEN  ;If Elig IEN exists, populate .06 field
 ..I ABSPMULT?7N S $P(ABSPRETURN,U,7)=ABSPMULT  ;If Medicaid multiple correct (a 7-digit FileMan date) populate field
 ..E  D  ;If not, go find correct multiple
 ...S I="",GO=1 F  S I=$O(^AUPNMCD(ABSPELIGIEN,11,I),-1) Q:I=""!('GO)  D
 ....S BEG=$P($G(^AUPNMCD(ABSPELIGIEN,11,I,0)),U,1),END=$P($G(^AUPNMCD(ABSPELIGIEN,11,I,0)),U,2)
 ....W "ABSPTODAY: ",ABSPTODAY," TESTING: ",I," BEG: ",BEG," END: ",END,!
 ....I (BEG<=ABSPTODAY)&(+END=0) W "FLERM.",! S GO=0,$P(ABSPRETURN,U,7)=I Q  ;If "Today" is after begin dt and there is no end dt, this is an eligible multiple, store it, exit loop
 ....I (BEG<=ABSPTODAY)&(ABSPTODAY<END) S GO=0,$P(ABSPRETURN,U,7)=I Q  ; If "Today" is between eligible dts, this is an eligible multiple, store it, exit loop
 ;That should be all of available data to send 3PB; let's clean up, finish
 ;RETURN DATA IS IN SAME FORM/ORDER AS 13 MULTIPLE NEEDS IN FILE 9002274.3:
 ;.01/INSURER; .04/MEDICARE MULTIPLE; .05/RAILROAD MULTIPLE; .06/MEDICAID ELIG PTR
 ;.07/MEDICAID MULTIPLE; .08/PRIVATE INSURANCE MULTIPLE
 Q ABSPRETURN
 ;IHS/OIT/RAM CR07534 End new
