XUSBUSA ;GDIT/HS/BEE - Record User Login/Option Utilization to BUSA; 11/29/2011
 ;;8.0;KERNEL;**1019,1020**;Jan 28, 1997;Build 8
 ;
 ;This routine is custom to IHS and is not an original VHA routine. 
 ;It is being released in patch XUS*8.0*1019 as part of the suite
 ;of changes relating to EPCS.
 ;IHS/OIT/FBD - XU*8.0*1020 - Modified $$SLOG and $$FLOG APIs to include optional 'calling application' parameter
 ;
 ;Documentation for this routine can be found in routine XUSBUSAD
 ;
 Q
 ;
SLOG(CALL,USER,APP) ;PEP - Audit Successful User Login  
 ;XU*8.0*1020 - APP parameter (calling application) added to call list
 ;
 ;Input:
 ;CALL - The routine making the API call
 ;USER - The IEN (DUZ value) of the user who logged in
 ;APP (Optional) - Free text identifying the application generating the call  ;XU*8.0*1020
 ;
 ;Input validation
 S CALL=$S($G(CALL)="":"XUS",1:CALL)
 S USER=$G(USER)
 S APP=$G(APP)  ;XU*8.0*1020
 ;
 ;Filter out BMXNet logins to avoid auto service logins
 ;I $G(BMXZ(2,"CAPI"))="XUS AV CODE" Q  ;XU*8.0*1020 - COMMENTED OUT TO DISABLE FILTERING OF BMX LOGINS
 ;
 NEW DESC,STS,EP,EVENT
 ;
 ;Get EP type
 S EP=$$EP($S(+$G(DUZ):DUZ,1:USER))
 ;
 ;Format Description
 ;S DESC="XU: Successful System Login|TYPE~L|RSLT~S|||"  ;XU*8.0*1020 - ORIGINAL LINE - COMMENTED OUT
 S DESC="XU: Successful System Login"  ;XU*8.0*1020 - FIRST PART OF ORIGINAL DESCRIPTION
 S:APP]"" DESC=DESC_" by "_APP  ;XU*8.0*1020 - IF SPECIFIED, APPEND CALLING APPLICATION INFO TO DESCRIPTION
 S DESC=DESC_"|TYPE~L|RSLT~S|||"  ;XU*8.0*1020 - SECOND PART OF ORIGINAL DESCRIPTION
 S:EP]"" $P(DESC,"|",6)=EP
 ;
 ;Get Event Code
 S EVENT=""
 S EVENT=$S(EP["EP~EP":"EPCS144",EP["EP~P":"EPCS142",EP["EP~E":"EPCS140",1:"")
 S:EVENT]"" $P(DESC,"|",7)=EVENT
 ;
 ;Log the entry to BUSA
 S STS=$$LOG("A","S","",CALL,DESC,"",USER)
 ;
 Q
 ;
FLOG(CALL,USER,ATTEMPT,APP) ;PEP - Audit Unsuccessful User Login Attempt  
 ;XU*8.0*1020 - APP parameter (calling application) added to call list
 ;
 ;Input:
 ;CALL (optional) - Routine making the API call (Default - XUS)
 ;USER (optional) - IEN (DUZ value) of the user who tried to log in
 ;ATTEMPT (optional) - Failed log in attempt number 
 ;APP (Optional) - Free text identifying the application generating the call  ;XU*8.0*1020
 ;
 ;Input validation
 S CALL=$S($G(CALL)="":"XUS",1:CALL)
 S USER=$G(USER)
 S ATTEMPT=$G(ATTEMPT)
 S APP=$G(APP)  ;XU*8.0*1020
 ;
 NEW DESC,ACVC,STS,EP,EVENT
 ;
 ;Get EP type
 S EP=$$EP($S(+$G(DUZ):DUZ,1:USER))
 ;
 ;Format Description
 S ACVC="Access Code" S:+$G(USER) ACVC="Verify Code Attempt "_$G(ATTEMPT)
 ;S DESC="XU: Failed System Login Attempt - Invalid "_ACVC_"|TYPE~L|RSLT~F|||";XU*8.0*1020 - ORIGINAL LINE - COMMENTED OUT
 S DESC="XU: Failed System Login Attempt"  ;XU*8.0*1020 - FIRST PART OF ORIGINAL DESCRIPTION
 S:APP]"" DESC=DESC_" by "_APP  ;XU*8.0*1020 - IF SPECIFIED, APPEND CALLING APPLICATION INFO TO DESCRIPTION
 S DESC=DESC_" - Invalid "_ACVC_"|TYPE~L|RSLT~F|||"  ;XU*8.0*1020 - SECOND PART OF ORIGINAL DESCRIPTION
 S:EP]"" $P(DESC,"|",6)=EP
 ;
 ;Get Event Code
 S EVENT=""
 S EVENT=$S(EP["EP~EP":"EPCS145",EP["EP~P":"EPCS143",EP["EP~E":"EPCS141",1:"")
 S:EVENT]"" $P(DESC,"|",7)=EVENT
 ;
 ;Log the failed login attempt to BUSA
 S STS=$$LOG("A","S","",CALL,DESC,"",USER)
 ;
 Q
 ;
OSLOG(CALL,OPTION,FAIL) ;PEP - Log Entry of Option Selected or Access Denied
 ;
 ;Input:
 ;CALL - The routine making the API call
 ;OPTION - The IEN pointer to the file 19 entry selected
 ;FAIL - 1 if access denied
 ;
 ;Input validation
 I '+$G(OPTION) Q  ;No Option IEN
 S CALL=$S($G(CALL)="":"XQ",1:CALL)
 S FAIL=+$G(FAIL)
 ;
 NEW DESC,ONAM,NAMSP,PKG,STS
 ;
 ;Option name
 S ONAM=$P($G(^DIC(19,OPTION,0)),U,2)
 ;
 ;Namespace
 ;
 ;First look for package
 S NAMSP=""
 S PKG=$$GET1^DIQ(19,OPTION_",",12,"I")
 I PKG]"" S NAMSP=$$GET1^DIQ(9.4,PKG_",",1,"E")
 ;
 ;If no package get run routine
 I NAMSP="" D
 . S NAMSP=$$GET1^DIQ(19,OPTION_",",25,"E")
 . I $L(NAMSP,U)>1 S NAMSP=$P(NAMSP,U,2)
 ;
 ;Format Description 
 I 'FAIL S DESC="XU: Selected Option "
 E  S DESC="XU: Denied Access to Option "
 S DESC=DESC_ONAM_"|TYPE~O|RSLT~"_$S('FAIL:"S",1:"F")_"|NAMSP~"_NAMSP_"|"_OPTION_"|"
 ;
 ;Check for pharmacy option
 I ($E(NAMSP,1,2)="PS")!($E(NAMSP,1,4)="APSP") D
 . S $P(DESC,"|",6)="EP~P"
 . I 'FAIL S $P(DESC,"|",7)="EPCS154"
 . E  S $P(DESC,"|",7)="EPCS155"
 ;
 ;Log the entry to BUSA
 S STS=$$LOG("A","S","",CALL,DESC,"","")
 ;
 Q
 ;
KYLOG(XQAL,XQDA,KEY,USER,CALL) ;Log Security Key Activity
 ;
 ;Input:
 ;XQAL - 1 if Allocation/Delegation
 ;XQDA - 1 if Delegate/Remove Delegation
 ;KEY - Key
 ;USER - User DUZ
 ;
 ;Input validation
 ;
 NEW ACT,STS,USERNM,EP,EVTC,EVENT
 ;
 S USERNM=$S($G(USER)]"":$P($G(^VA(200,USER,0)),U),1:"")
 ;
 ;Set E/P value
 S (EVENT,EVTC,EP)="" I (KEY="ORES")!(KEY="ORELSE") S EP="EP~E"
 I (KEY="XUEPCSEDIT") S EP="EP~E",EVTC="EPCS120,EPCS121,EPCS122,EPCS123"
 I (KEY="XUZEPCSVERIFY") S EP="EP~E",EVTC="EPCS124,EPCS125,EPCS126,EPCS127"
 I (KEY="PSORPH") S EP="EP~P",EVTC="EPCS132,EPCS133,EPCS136,EPCS137"
 I (KEY="PSDRPH") S EP="EP~P",EVTC="EPCS130,EPCS131,EPCS134,EPCS135"
 ;
 ;Determine action
 S ACT="XU: "_$S(XQAL&XQDA:"Delegated",XQAL:"Allocated",XQDA:"Removed delegated",1:"Deallocated")_" key "_KEY
 S ACT=ACT_$S(XQAL:" to ",1:" from ")_USERNM
 ;
 ;Define event
 I EVTC]"" D
 . I ACT["Allocated" S EVENT=$P(EVTC,",")
 . I ACT["Delegated" S EVENT=$P(EVTC,",",2)
 . I ACT["Deallocated" S EVENT=$P(EVTC,",",3)
 . I ACT["Removed" S EVENT=$P(EVTC,",",4)
 ;
 ;Format Description 
 S DESC=ACT_"|TYPE~K|RSLT~S|NAMSP~"_KEY_"||"_EP,$P(DESC,"|",8)=USER,$P(DESC,"|",7)=EVENT
 ;
 ;Log the entry to BUSA
 S STS=$$LOG("A","S","",$G(CALL),DESC,"","")
 ;
 Q
 ;
MNLOG(PS,MENU,USER,CALL,ACT) ;Log Menu Allocation/Removal
 ;
 ;Input:
 ;PS - P (Primary Menu), S (Secondary Menu)
 ;MENU - Pointer to file 19
 ;USER - User action was taken on
 ;ACT - Action performed: 0 (Add), 1 (Delete)
 ;CALL - Calling routine
 ;
 S PS=$S($G(PS)="P":"P",1:"S")
 S MENU=+$G(MENU) I MENU=0 Q
 S USER=+$G(USER) I USER=0 Q
 S CALL=$G(CALL)
 S ACT=$S($G(ACT)="1":"1",1:"")
 ;
 NEW DESC,STS,NAMSP,EVENT
 ;
 S DESC="XU: "_$S(ACT=1:"Removed ",1:"Assigned ")
 S DESC=DESC_$S(PS="P":"Primary",1:"Secondary")_" Menu "_$P($G(^DIC(19,MENU,0)),U)
 S DESC=DESC_$S(ACT=1:" from",1:" to")_" user "_$P($G(^VA(200,USER,0)),U)
 ;
 ;Find Namespace
 S NAMSP=$$GET1^DIQ(19,MENU_",",12,"I") ;First look for package
 I NAMSP]"" S NAMSP=$$GET1^DIQ(9.4,NAMSP_",",1,"E")
 I NAMSP="" D
 . S NAMSP=$$GET1^DIQ(19,MENU_",",25,"E") ;If no package get run routine
 . I $L(NAMSP,U)>1 S NAMSP=$P(NAMSP,U,2)
 I NAMSP="" S NAMSP=$P($G(^DIC(19,MENU,0)),U) ;If blank use option name
 S DESC=DESC_"|TYPE~M|RSLT~S|NAMSP~"_NAMSP
 ;
 ;Log the event
 S EVENT=""
 I ($E(NAMSP,1,2)="PS")!($E(NAMSP,1,4)="APSP") D
 . S $P(DESC,"|",6)="EP~P"
 . I PS="P",'ACT S EVENT="EPCS150"
 . E  I PS'="P",'ACT S EVENT="EPCS151"
 . E  I PS="P",ACT S EVENT="EPCS152"
 . E  I PS'="P",ACT S EVENT="EPCS153"
 S $P(DESC,"|",7)=EVENT
 ;
 ;Log the entry to BUSA
 S STS=$$LOG^XUSBUSA("A","S","",CALL,DESC,"","")
 Q
 ;
LOG(TYPE,CAT,ACTION,CALL,DESC,DETAIL,USER) ;PEP - Create HASHed BUSA log entry
 ;
 ;The input parameters are documented in routine XUSBUSAD
 ;
 NEW %,HASH,STS,AUTHORD,EP
 ;
 ;Validate input:
 S TYPE=$G(TYPE)
 S CAT=$G(CAT)
 S ACTION=$G(ACTION)
 S CALL=$G(CALL)
 S DESC=$G(DESC)
 S USER=$G(USER)
 ;
 ;Initialize DUZ if not defined or set to null
 I '$D(DUZ)!($G(DUZ)=0) N DUZ
 ;
 ;Set DUZ if null
 I $G(DUZ)="" D  I DUZ="" Q 0
 . ; 
 . ;First look for passed in user
 . I +$G(USER) S DUZ=USER Q
 . ;
 . ;Next look for "XUS,PROXY USER"
 . S DUZ=$O(^VA(200,"B","XUS,PROXY USER",""))
 ;
 ;Determine EPCS/Pharmacy
 S EP=$P(DESC,"|",6) I EP'["EP~" S $P(DESC,"|",6)=$$EP(DUZ)
 S:$L(DESC,"|")=6 $P(DESC,"|",7)=""  ;Add final pipe for filtering
 ;
 ;Log entry to BUSA
 I $T(BYPSLOG^BUSAAPI)="" Q 0  ;BUSA v1.0 not installed
 I $T(BYPSLOG^BUSAAPI)'["HASH" S STS=$$BYPSLOG^BUSAAPI(TYPE,CAT,ACTION,CALL,DESC,.DETAIL)  ;BUSA*1.0*1 not installed
 I $T(BYPSLOG^BUSAAPI)["HASH" S STS=$$BYPSLOG^BUSAAPI(TYPE,CAT,ACTION,CALL,DESC,.DETAIL,1)  ;BUSA*1.0*1 installed
 ;
 Q STS
 ;
EP(DUZ) ;Return whether E, P, or EP
 NEW EP
 I $G(DUZ)="" Q ""
 S EP=""
 I $D(^XUSEC("PSORPH",DUZ)),$D(^XUSEC("PSDRPH",DUZ)) S EP="P"
 I $$GET1^DIQ(200,DUZ_",",53.1,"I") D
 . I $D(^XUSEC("ORES",DUZ)) S EP="E"_EP Q
 . I $D(^XUSEC("ORELSE",DUZ)),EP'["P" S EP="E"
 S:EP]"" EP="EP~"_EP
 Q EP
 ;
 ;PRIMARY MENU OPTION - SET
SPM ;'AAUD201' Cross Reference in file 200, field 201
 ;
 NEW USER,VAL
 ;
 S USER=$G(DA)
 S VAL=$G(X)
 ;
 I '$G(VAL) Q  ;Menu
 I '$G(USER) Q  ;User getting menu
 I '$G(DUZ) Q  ;Set user
 ;
 ;Log to BUSA
 NEW D0,DA,X,DO,D1,DINUM D MNLOG("P",VAL,USER,"200/201 XREF",0)
 ;
 Q
 ;
 ;PRIMARY MENU OPTION - DELETE
DPM ;'AAUD201' Cross Reference in file 200, field 201
 ;
 NEW USER,VAL
 ;
 S USER=$G(DA)
 S VAL=$G(X)
 ;
 I '$G(VAL) Q  ;Menu
 I '$G(USER) Q  ;User getting menu
 I '$G(DUZ) Q  ;Set user
 ;
 ;Log to BUSA
 NEW D0,DA,X,DO,D1,DINUM D MNLOG("P",VAL,USER,"200/201 XREF",1)
 ;
 Q
 ;
 ;SECONDARY MENU OPTIONS - SET
SSM ;'AAUD203' Cross Reference in subfile 200.03, field .01
 ;
 NEW USER,VAL
 ;
 S USER=$G(DA(1))
 S VAL=$G(X)
 ;
 I '$G(VAL) Q  ;Menu
 I '$G(USER) Q  ;User getting menu
 I '$G(DUZ) Q  ;Set user
 ;
 ;Log to BUSA
 NEW D0,DA,X,DO,D1,DINUM D MNLOG("S",VAL,USER,"200/203 XREF",0)
 ;
 Q
 ;
 ;SECONDARY MENU OPTIONS - DELETE
DSM ;'AAUD203' Cross Reference in subfile 200.03, field .01
 ;
 NEW USER,VAL
 ;
 S USER=$G(DA(1))
 S VAL=$G(X)
 ;
 I '$G(VAL) Q  ;Menu
 I '$G(USER) Q  ;User getting menu
 I '$G(DUZ) Q  ;Set user
 ;
 ;Log to BUSA
 NEW D0,DA,X,DO,D1,DINUM D MNLOG("S",VAL,USER,"200/203 XREF",1)
 ;
 Q
 ;
 ;KEYS - SET
SKY ;'AAUD51' Cross Reference in subfile 200.051, field .01
 ;
 NEW USER,VAL
 I '$D(XQAL) NEW XQAL S XQAL=1
 I '$D(XQDA) NEW XQDA S XQDA=0
 ;
 S USER=$G(DA(1))
 S VAL=$G(X)
 ;
 I '$G(VAL) Q  ;Menu
 I '$G(USER) Q  ;User getting menu
 I '$G(DUZ) Q  ;Set user
 ;
 ;Log to BUSA 
 NEW D0,DA,X,DO,DIC,Y,D1,DINUM
 D KYLOG(XQAL,XQDA,$P($G(^DIC(19.1,VAL,0)),U),USER,"200/51 XREF")
 Q
 ;
 ;KEYS - DELETE
DKY ;'AAUD51' Cross Reference in subfile 200.051, field .01
 ;
 NEW USER,VAL
 I '$D(XQAL) NEW XQAL S XQAL=0
 I '$D(XQDA) NEW XQDA S XQDA=0
 ;
 S USER=$G(DA(1))
 S VAL=$G(X)
 ;
 I '$G(VAL) Q  ;Menu
 I '$G(USER) Q  ;User getting menu
 I '$G(DUZ) Q  ;Set user
 ;
 ;Log to BUSA 
 NEW D0,DA,X,DO,DIC,Y,D1,DINUM
 D KYLOG(XQAL,XQDA,$P($G(^DIC(19.1,VAL,0)),U),USER,"200/51 XREF")
 Q
 ;
 ;DELEGATE KEYS - SET
SDKY     ;'AAUD52' Cross Reference in subfile 200.052, field .01
 ;
 NEW USER,VAL
 I '$D(XQAL) NEW XQAL S XQAL=1
 I '$D(XQDA) NEW XQDA S XQDA=0
 ;
 S USER=$G(DA(1))
 S VAL=$G(X)
 ;
 I '$G(VAL) Q  ;Menu
 I '$G(USER) Q  ;User getting menu
 I '$G(DUZ) Q  ;Set user
 ;
 ;Log to BUSA 
 NEW D0,DA,X,DO,DIC,Y,D1,DINUM
 D KYLOG(XQAL,XQDA,$P($G(^DIC(19.1,VAL,0)),U),USER,"200/52 XREF")
 Q
 ;
 ;DELEGATE KEYS - DELETE
DDKY     ;'AAUD52' Cross Reference in subfile 200.052, field .01
 ;
 NEW USER,VAL
 I '$D(XQAL) NEW XQAL S XQAL=0
 I '$D(XQDA) NEW XQDA S XQDA=0
 ;
 S USER=$G(DA(1))
 S VAL=$G(X)
 ;
 I '$G(VAL) Q  ;Menu
 I '$G(USER) Q  ;User getting menu
 I '$G(DUZ) Q  ;Set user
 ;
 ;Log to BUSA 
 NEW D0,DA,X,DO,DIC,Y,D1,DINUM
 D KYLOG(XQAL,XQDA,$P($G(^DIC(19.1,VAL,0)),U),USER,"200/52 XREF")
 Q
 ;
 ;Changed Access Code
SAC ;'AAUD2' Cross Reference in file 200, field 2
 ;
 NEW DESC,STS
 S DESC="XU: Changed access code of user "_$$GET1^DIQ(200,$S(+$G(DDSDA):+DDSDA,+$G(DA):+DA,1:+$G(DUZ)),.01,"E")_"|TYPE~C|RSLT~S|NAMSP~XU"
 ;
 ;Log the entry to BUSA
 S STS=$$LOG^XUSBUSA("A","S","","200/2 XREF",DESC,"","")
 Q
 ;
 ;Deleted Access Code
DAC ;'AAUD2' Cross Reference in file 200, field 2
 ;
 NEW DESC,STS
 S DESC="XU: Deleted access code of user "_$$GET1^DIQ(200,$S(+$G(DDSDA):+DDSDA,+$G(DA):+DA,1:+$G(DUZ)),.01,"E")_"|TYPE~C|RSLT~S|NAMSP~XU"
 ;
 ;Log the entry to BUSA
 S STS=$$LOG^XUSBUSA("A","S","","200/2 XREF",DESC,"","")
 Q
 ;
 ;Changed Verify Code
SVC ;'AAUD11' Cross Reference in file 200, field 11
 ;
 NEW DESC,STS
 S DESC="XU: Changed verify code of user "_$$GET1^DIQ(200,$S(+$G(DDSDA):+DDSDA,+$G(DA):+DA,1:+$G(DUZ)),.01,"E")_"|TYPE~C|RSLT~S|NAMSP~XU"
 ;
 ;Log the entry to BUSA
 S STS=$$LOG^XUSBUSA("A","S","","200/11 XREF",DESC,"","")
 Q
 ;
 ;Deleted Verify Code
DVC(CALL) ;'AAUD11' Cross Reference in file 200, field 11
 ;
 S:$G(CALL)="" CALL="200/11 XREF"
 ;
 NEW DESC,STS
 S DESC="XU: Deleted verify code of user "_$$GET1^DIQ(200,$S(+$G(DDSDA):+DDSDA,+$G(DA):+DA,1:+$G(DUZ)),.01,"E")_"|TYPE~C|RSLT~S|NAMSP~XU"
 ;
 ;Log the entry to BUSA
 S STS=$$LOG^XUSBUSA("A","S","",CALL,DESC,"","")
 Q
 ;
 ;Failed attempt at changing verify code
FVC(USER,TYP) ;Called from CHK1^XUS2 on failed verify code change
 ;
 I +$G(USER)=0 Q
 S TYP=+$G(TYP)
 ;
 NEW DESC,STS
 ;
 S DESC="XU: Failed attempt at changing verify code for user "_$$GET1^DIQ(200,+USER,.01,"E")
 S DESC=DESC_$S(TYP=1:"-Incorrect current code entered",1:"-Invalid new code entered")_"|TYPE~C|RSLT~F|NAMSP~XU"
 ;
 ;Log the entry to BUSA
 S STS=$$LOG^XUSBUSA("A","S","","XUS2",DESC,"","")
 Q
 ;
 ;Failed attempt at changing access code
FAC(USER,TYP) ;Called from ^XUS2
 ;
 I +$G(USER)=0 Q
 S TYP=+$G(TYP)
 ;
 NEW DESC,STS
 ;
 S DESC="XU: Failed attempt at changing access code for user "_$$GET1^DIQ(200,+USER,.01,"E")
 S DESC=DESC_$S(TYP=1:"-Incorrect current code entered",1:"-Invalid new code entered")_"|TYPE~C|RSLT~F|NAMSP~XU"
 ;
 ;Log the entry to BUSA
 S STS=$$LOG^XUSBUSA("A","S","","XUS2",DESC,"","")
 Q
 ;
 ;AUTHORIZED TO WRITE MED ORDERS
AMO ;'AAUD531' Cross Reference in file 200, field 53.1 - Set
 ;
 NEW DESC,STS
 S DESC="XU: Authorized To Write Medical Orders for user "_$$GET1^DIQ(200,$S(+$G(DDSDA):+DDSDA,+$G(DA):+DA,1:+$G(DUZ)),.01,"E")_"|TYPE~K|RSLT~S|NAMSP~XU||EP~E|EPCS128"
 ;
 ;Log the entry to BUSA
 S STS=$$LOG^XUSBUSA("A","S","","200/53.1 XREF",DESC,"","")
 ;
 Q
 ;
 ;AUTHORIZED TO WRITE MED ORDERS
NMO ;'AAUD531' Cross Reference in file 200, field 53.1 - Kill
 ;
 NEW DESC,STS
 S DESC="XU: Not Authorized To Write Medical Orders for user "_$$GET1^DIQ(200,$S(+$G(DDSDA):+DDSDA,+$G(DA):+DA,1:+$G(DUZ)),.01,"E")_"|TYPE~K|RSLT~S|NAMSP~XU||EP~E|EPCS129"
 ;
 ;Log the entry to BUSA
 S STS=$$LOG^XUSBUSA("A","S","","200/53.1 XREF",DESC,"","")
 ;
 Q
