AMER3 ; IHS/ANMC/GIS - MORE DISCHARGE QUESTIONS ;  
 ;;3.0;ER VISIT SYSTEM;**6,13**;MAR 03, 2009;Build 36
 ;
QD10 ; ER PROCEDURES
 N AMERNONE S AMERNONE=$$OPT^AMER0("NONE","ER PROCEDURES")
 ; W "Type '??' to see choices"
 S AMEROPT=""
 I $D(^TMP("AMER",$J,2,10,AMERNONE))!('$D(^TMP("AMER",$J,2,10))) S DIC("B")="NONE" G DIC
 D PREV(10)
DIC S DIC("A")="Enter "_$S($O(^TMP("AMER",$J,2,10,0)):"another ",1:"")_"procedure: "
 S DIC="^AMER(3,",DIC(0)="AEQ",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("ER PROCEDURES")
 D ^DIC K DIC
 I $P(Y,U,2)="NONE" K ^TMP("AMER",$J,2,10) S ^TMP("AMER",$J,2,10,AMERNONE)=Y Q
 I X?2."^" S DIROUT=""
 D OUT^AMER I $D(AMERQUIT) Q
 I "^"[$E(X) S Y="" Q
 I $D(^TMP("AMER",$J,2,10,+Y)) D REM(10,Y) Q:$D(AMERQUIT)  G DIC
 S ^TMP("AMER",$J,2,10,+Y)=Y I +Y'=AMERNONE K ^(AMERNONE)
 G DIC
 ;
REM(X,Y) W !,*7,$P(Y,U,2)," has already been selected. Want to cancel it"
 S %=2 D YN^DICN S:%Y?2."^" DIROUT="" D OUT^AMER I $D(AMERQUIT) Q
 I "Nn"[$E(%Y) Q
 K ^TMP("AMER",$J,2,X,+Y) W !,$P(Y,U,2)," cancelled...",!!
 Q
 ;
PREV(X) ; ENTRY POINT FROM AMER31
 W !,"You have already selected =>",!
 F %=0:0 S %=$O(^TMP("AMER",$J,2,X,%)) Q:'%  W ?3,$P(^(%),U,2),!
 W !
 Q
 ;
QD11 ; FINAL DIAGNOSES
 D QD11^AMER31
 Q
 ;
QD12 ; FINAL TRIAGE CATEGORY
 S DIR("B")=$G(^TMP("AMER",$J,2,12))
 S DIR("?")="Enter a number from 1 to 5"
 S DIR("?",1)="This is a site-specified value that indicates severity of visit"
 S DIR(0)="N^1:5:0",DIR("A")="*Enter final acuity assessment from provider" KILL DA D ^DIR KILL DIR
 D OUT^AMER
 Q
 ;
QD14 ; DISPOSITION AND SCHEDULING
 N AMERDISP   ;IHS/OIT/SCR 10/10/08
 S DIC("A")="*Disposition: " K DIC("B")
 I $G(^TMP("AMER",$J,2,14))>0 S %=+^(14),DIC("B")=$P(^AMER(3,%,0),U)
 ;I $D(^TMP("AMER",$J,2,14)) S %=+^(14),DIC("B")=$P(^AMER(3,%,0),U) ;IHS/OIT/SCR 10/10/08
 I $D(AMERDOA) S DIC("B")="DEATH"
 I $D(AMERDNA) D
 .;IHS/OIT/SCR 01/20/09 - OPTION  MAY BE 'LEFT WITHOUT BEING SEEN' OR 'LEFT WITHOUT BEING DISCHARGED'
 .S DIC="^AMER(3,",DIC(0)="",X="LEFT WITHOUT"
 .D ^DIC
 .I Y>0 S DIC("B")=$P(Y,"^",2)
 .E  S DIC("B")=""
 .Q
 S DIC="^AMER(3,",DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("DISPOSITION"),DIC(0)="AEQ"
 D ^DIC K DIC D OUT^AMER I $D(AMERQUIT) Q
 I Y=-1 Q
 S AMERDISP=+Y
 I AMERDISP=$$OPT^AMER0("REGISTERED IN ERROR","DISPOSITION") D  Q
 .D EN^DDIOL("Using this DISPOSITION will cause the entire VISIT to be deleted!!","","!")
 .D EN^DDIOL("This DISPOSITION can not be changed!!","","!")
 .S DIR(0)="Y",DIR("A")="Do you still wish use this DISPOSITION"
 .S DIR("B")="YES"
 .D ^DIR
 .I Y=0 D
 ..S AMERRUN=13
 ..S ^TMP("AMER",$J,2,14)=""
 ..Q
 .I Y=1 S AMERRUN=95
 .Q
 Q:AMERRUN=95
 ;I +Y=$$OPT^AMER0("HOME","DISPOSITION") S AMERRUN=15 D SCHEDULE Q
 I AMERDISP'=$$OPT^AMER0("TRANSFER TO ANOTHER FACILITY","DISPOSITION") S AMERRUN=15
 I AMERDISP'=$$OPT^AMER0($P($G(^AMER(3,AMERDISP,0)),U),"DISPOSITION") K ^TMP("AMER",$J,2,15)
 S Y=AMERDISP
 Q
 ;
QD15 ; OTHER FACILITIES
 ;W "If location lookup fails, try entering 'OTHER'"  - IHS/OIT/SCR 10/09/08 commented out
 S DIR("A")="Where is patient being transferred" K DIR("B")
 I $D(^TMP("AMER",$J,2,15)) S %=+^(15),DIR("B")=$P(^AMER(2.1,%,0),U)
 ;S DIR(0)="P^9009082.1:EMZ" D ^DIR K DIR
 S DIR(0)="PO^9009082.1:OEMZ" D ^DIR K DIR  ;SCR/CNI/OIT - MAKE RESPONSE OPTIONAL
 D OUT^AMER
 Q
 ;
QD16 ; DISCHARGE INSTRUCTIONS
 NEW FIIEN,CNT,FI,DIR,%,INS
 ;
 ;Get the default entry
 I $G(^TMP("AMER",$J,2,16))]"" S %=+^(16) S:%]"" DIR("B")=$$GET1^DIQ(9009083,%_",",.01,"I")
 ;
 S CNT=0
 S DIR(0)="SO^"
 S FIIEN=$O(^AMER(2,"B","FOLLOW UP INSTRUCTIONS",""))
 S FI="" F  S FI=$O(^AMER(3,"AC",FIIEN,FI)) Q:FI=""  D
 . NEW INSNM
 . S CNT=CNT+1
 . S INSNM=$$GET1^DIQ(9009083,FI_",",".01","I") Q:INSNM=""
 . S INS(CNT)=INSNM_U_FI
 . S DIR(0)=DIR(0)_$S(CNT>1:";",1:"")_CNT_":"_INSNM
 . I INSNM="RTC PRN, INSTRUCTIONS GIVEN",'$D(DIR("B")) S DIR("B")=INSNM
 ;
 S DIR("A")="Follow up instructions"
 D ^DIR
 ;
 ;Process invalid entries
 I +Y<1,X'="@" S X="^",Y="^" D OUT^AMER Q
 ;
 ;Handle proper selection
 I +Y>0 S Y=$P(INS(+Y),U,2)
 ;
 I X="@" S X="",Y=""
 D OUT^AMER
 Q
 ;
QD17 ; DISCHARGE PHYSICIAN
 NEW DIR,AMERP,DPDT,DIEN,DFDPV,DEPDT,NAMERP
 ;
 ;Get current entries for visit
 S AMERP=$$GPROV^AMERMPV1(.AMERP,$G(AMERDFN),"")
 ;
 ;Get the departure date/time
 S DEPDT=$$GDEPDT($G(AMERDFN))
 ;
 ;Get current (could have entered and ^^)
 S (DFDPV,DPDT)="" F  S DPDT=$O(AMERP("DISCHARGE PROVIDER",DPDT)) Q:DPDT=""  D
 . S DIEN="" F  S DIEN=$O(AMERP("DISCHARGE PROVIDER",DPDT,DIEN)) Q:DIEN=""  D
 .. S DFDPV=DIEN
 ;
 S DIR("A")="*(PRIMARY)Provider who signed PCC form: " K DIR("B")
 I DFDPV]"" S ^TMP("AMER",$J,2,17)=DFDPV
 I '$D(^TMP("AMER",$J,2,17)) S %=$G(^TMP("AMER",$J,2,21)) I %]"" S ^TMP("AMER",$J,2,17)=%
 I $D(^TMP("AMER",$J,2,17)) S %=+^(17),DIR("B")=$P($G(^VA(200,%,0)),U)
 S DIR("?")="^D NHELP^AMERMPV1(""P"")"
 S DIR="^VA(200,",DIR(0)="PO^200:AEQM"
 S DIR("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 D ^DIR
 ;
 ;If one entered and we have departure time update V EVR
 I +Y>0,DEPDT]"" D
 . ;
 . NEW PROV,NURSE,NAMERP
 . ;
 . ;Clear out current
 . D DRESET(AMERDFN,"P")
 . ;
 . ;Discharge provider
 . S NAMERP("DISCHARGE PROVIDER",DEPDT,+Y)=""
 . ;
 . ;Update V EVR
 . D SYNC^AMERMPRV(AMERDFN,"",.PROV,.NURSE,.NAMERP)
 ;
 D OUT^AMER
 Q
 ;
QD18 ; DISCHARGE NURSE
 NEW AMERP,DNDT,DIEN,DFDNR,DEPDT,NAMERP
 ;
 ;Get current entries for visit
 S AMERP=$$GPROV^AMERMPV1(.AMERP,$G(AMERDFN),"")
 ;
 ;Get the departure date/time
 S DEPDT=$$GDEPDT($G(AMERDFN))
 ;
 ;Get current (could have entered and ^^)
 S (DFDNR,DNDT)="" F  S DNDT=$O(AMERP("DISCHARGE NURSE",DNDT)) Q:DNDT=""  D
 . S DIEN="" F  S DIEN=$O(AMERP("DISCHARGE NURSE",DNDT,DIEN)) Q:DIEN=""  D
 .. S DFDNR=DIEN
 ; 
 S DIC("A")="*Discharge nurse: " K DIC("B")
 I DFDNR]"" S ^TMP("AMER",$J,2,18)=DFDNR
 I $D(^TMP("AMER",$J,2,18)) S %=+^(18),DIC("B")=$P($G(^VA(200,%,0)),U)
 S DIC="^VA(200,",DIC(0)="AEQM"
 ; Screening so that only valid PCC providers identified
 S DIC("?")="^D NHELP^AMERMPV1(""N"")"
 S DIC("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 D ^DIC K DIC
 D OUT^AMER
 ;
 ;If one entered and we have departure time update V EVR
 I +Y>0,DEPDT]"" D
 . ;
 . NEW NAMERP,PROV,NURSE
 . ;
 . ;Clear out current
 . D DRESET(AMERDFN,"N")
 . ;
 . ;Discharge provider
 . S NAMERP("DISCHARGE NURSE",DEPDT,+Y)=""
 . ;
 . ;Update V EVR
 . D SYNC^AMERMPRV(AMERDFN,"",.PROV,.NURSE,.NAMERP)
 ;
 I $D(AMERDOA) D
 .S %=$$OPT^AMER0("NONE","ER PROCEDURES"),^TMP("AMER",$J,2,10,%)=%_U_"NONE"
 .S ^TMP("AMER",$J,1,6)=^TMP("AMER",$J,2,17)
 .S ^TMP("AMER",$J,1,7)=Y
 .S ^TMP("AMER",$J,2,12)=$G(^TMP("AMER",$J,1,9))
 .S %=$$OPT^AMER0("DEATH","DISPOSITION"),^TMP("AMER",$J,2,14)=%_"^DEATH"
 .Q
 Q
 ;
QD19 ; TIME OF DEPARTURE
 ;
 NEW DIR,DEPDT
 ;
 ;Get the departure date/time
 S DEPDT=$$GDEPDT($G(AMERDFN))
 ;
 I DEPDT]"" S ^TMP("AMER",$J,2,19)=DEPDT
 I $D(^TMP("AMER",$J,2,19)) S Y=^(19) X ^DD("DD") S DIR("B")=Y
 I '$T S DIR("B")="NOW"
 ;IHS/OIT/SCR 10/10/08 - Mark question mandatory
 ;S DIR(0)="DO^::ER",DIR("A")="What time did the patient depart from the ER",DIR("?")="Enter an exact date and time in Fileman format (e.g. 1/3/90@1PM)" D ^DIR K DIR
 S DIR(0)="DO^::ER",DIR("A")="*What time did the patient depart from the ER"
 S DIR("?")="Enter an exact date and time in Fileman format (e.g. 1/3/90@1PM)" D ^DIR K DIR
 I Y,$$TCK^AMER2A($G(^TMP("AMER",$J,1,2)),Y,1,"admission") K Y G QD19
 I Y,$$TCK^AMER2A($G(^TMP("AMER",$J,2,24)),Y,1,"triage") K Y G QD19
 I Y,$$TCK^AMER2A($G(^TMP("AMER",$J,2,25)),Y,1,"the provider visit") K Y G QD19
 I Y,$$TVAL^AMER2A($G(^TMP("AMER",$J,1,2)),Y,6) K Y G QD19
 I Y="" S Y=-1
 ;GDIT/HS/BEE 10/05/22;AMER*3.0*13;CR#5100;Save DP and DN to V EVR
 I +Y>0 D
 . NEW DPTIME
 . S DPTIME=+Y
 . ;
 . NEW Y,PROV,NURSE,NAMERP
 . ;
 . ;Remove existing from V EVR
 . D DRESET(AMERDFN,"NP")
 . ;
 . ;Add new entries
 . ;
 . ;Discharge provider
 . I $P($G(^TMP("AMER",$J,2,17)),U) S NAMERP("DISCHARGE PROVIDER",+DPTIME,+$P($G(^TMP("AMER",$J,2,17)),U))=""
 . ;
 . ;Discharge nurse
 . I $P($G(^TMP("AMER",$J,2,18)),U) S NAMERP("DISCHARGE NURSE",+DPTIME,+$P($G(^TMP("AMER",$J,2,18)),U))=""
 . ;
 . ;Update V EVR
 . I $O(NAMERP(""))]"" D SYNC^AMERMPRV(AMERDFN,"",.PROV,.NURSE,.NAMERP)
 . ;
 . ;Update V EVR Departure Date/Time
 . D SDEPDT(AMERDFN,DPTIME)
 ;
 D OUT^AMER
 S AMERRUN=99
 Q
 ;
SCHEDULE ; APPOINTMENT STUB
 Q
 ;
DRESET(AMERDFN,NP,VIEN) ;Clear DP and DN
 ;
 I '$G(AMERDFN) Q
 I '$D(^AMERADM(AMERDFN)),$G(VIEN)="" Q
 ;
 NEW ERIEN,PTYP,PDTM,PIEN,Y
 ;
 ;Get the VIEN
 S:$G(VIEN)="" VIEN=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I") Q:'VIEN
 ;
 ;Locate existing entry
 S ERIEN=$O(^AUPNVER("AD",VIEN,"")) Q:ERIEN=""
 ;
 ;Providers
 I NP["P" S PDTM="" F  S PDTM=$O(^AUPNVER(ERIEN,13,"ATT","DC",PDTM)) Q:'PDTM  D
 . S PIEN=0 F  S PIEN=$O(^AUPNVER(ERIEN,13,"ATT","DC",PDTM,PIEN)) Q:'PIEN  D
 .. NEW DA,DIK
 .. S DA(1)=ERIEN,DA=PIEN,DIK="^AUPNVER("_DA(1)_",13," D ^DIK
 ;
 ;Nurse
 I NP["N" S PDTM="" F  S PDTM=$O(^AUPNVER(ERIEN,14,"ANT","DC",PDTM)) Q:'PDTM  D
 . S PIEN=0 F  S PIEN=$O(^AUPNVER(ERIEN,14,"ANT","DC",PDTM,PIEN)) Q:'PIEN  D
 .. NEW DA,DIK
 .. S DA(1)=ERIEN,DA=PIEN,DIK="^AUPNVER("_DA(1)_",14," D ^DIK
 ;
 Q
 ;
GDEPDT(AMERDFN) ;Return the departure date/time from V EVR
 ;
 I '$G(AMERDFN) Q
 I '$D(^AMERADM(AMERDFN)) Q
 ;
 NEW VIEN,ERIEN,PTYP,PDTM,PIEN,Y
 ;
 ;Get the VIEN
 S VIEN=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I") Q:'VIEN
 ;
 ;Locate existing entry
 S ERIEN=$O(^AUPNVER("AD",VIEN,"")) Q:ERIEN=""
 ;
 ;Return the departure date/time
 Q $$GET1^DIQ(9000010.29,ERIEN_",",.13,"I")
 ;
 ;
SDEPDT(AMERDFN,DEPDT) ;Return the departure date/time from V EVR, VISIT
 ;
 I '$G(AMERDFN) Q
 I '$D(^AMERADM(AMERDFN)) Q
 ;
 NEW VIEN,ERIEN,UPVEVR,UERR,Y
 ;
 ;Get the VIEN
 S VIEN=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I") Q:'VIEN
 ;
 ;Locate existing entry
 S ERIEN=$O(^AUPNVER("AD",VIEN,"")) Q:ERIEN=""
 ;
 ;Update the departure date/time in V EVR
 S UPVEVR(9000010.29,ERIEN_",",.13)=$S($G(DEPDT)]"":DEPDT,1:"@")
 S UPVEVR(9000010,VIEN_",",.18)=$S($G(DEPDT)]"":DEPDT,1:"@")
 D FILE^DIE("","UPVEVR","UERR")
 Q
