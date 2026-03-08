AMER2A ; IHS/ANMC/GIS -ISC - OVERFLOW FROM AMER2 ;  
 ;;3.0;ER VISIT SYSTEM;**6,10,13,14**;MAR 03, 2009;Build 4
 ;
QD20 ; CLINIC TYPE
 N AMERLINE,%
 I '$D(AMERMAND),'$D(AMEREFLG),'$D(^TMP("AMER",$J,2,20)),'$D(AMERBCH) D
 .S %="",$P(%,"~",80)="",AMERLINE=%
 .;GDIT/HS/BEE;AMER*3.0*14;FEATURE#89183;08/04/2023;Display PPN
 .;W @IOF,"ER ADMISSION FOR ",$P(^DPT(AMERDFN,0),U),"    ^ = back up    ^^ = quit"
 .W @IOF,"ER ADMISSION FOR ",$E($$PPN^AMERUTIL(AMERDFN,0),1,44)," ^=back up ^^=quit"
 .W !,"Questions preceded by a '*' are MANDATORY.  Enter '??' to see choices."
 .W !,AMERLINE,!
 .Q
QD20A ;
 N AMERPCC,AMERLOC,AMERCLN,AMERTYP,ERR
 S X=""
 ;GDIT/HS/BEE 05/10/2018;CR#10213;AMER*3.0*10;Pull default clinic and use
 ;S DIC("A")="*Clinic type (EMERGENCY or URGENT): " K DIC("B")
 S DIC("A")="*Clinic type: " K DIC("B")
 ;S DIC("B")="EMERGENCY MEDICINE"
 ;IHS/OIT/SCR 2/20/09 - DEFAULT TO WALK IN CLINIC THAT IS IDENTIFIED IN ERS SITE PREFERENCES FILE
 ;S AMERLOC=0,AMERLOC=$O(^AMER(2.5,AMERLOC))
 S AMERLOC=$G(DUZ(2))
 I '$D(^AMER(2.5,AMERLOC,0)) D
 .W !,"SITE PARAMETERS have not been set up in the ERS PARAMETER option"
 .W !,"Please contact your ERS Supervisors to complete this option before using the EMERGENCY ROOM system"
 .S X="^^"
 .Q
 I AMERLOC'="" D
 .;
 .;GDIT/HS/BEE 05/10/2018;CR#10213;AMER*3.0*10;Pull default clinic and use
 .S DIC("B")=""
 .S AMERCLN=$$GET1^DIQ(9009082.5,AMERLOC_",",.06,"I") I AMERCLN]"" D
 ..S DIC("B")=$$GET1^DIQ(9009083,AMERCLN,.01,"E")
 .;If not defined use first one with 30
 .I DIC("B")="" D
 ..S AMERCLN=$O(^AMER(3,"B",30,""))
 ..I AMERCLN]"" S DIC("B")=$$GET1^DIQ(9009083,AMERCLN,.01,"E")
 .;
 .;I AMERCLN'="" D
 .;.S AMERTYP=$P(^SC(AMERCLN,0),"^",7)  ;THIS STOP CODE NUMBER - POINTER TO STOP CODE FILE (30 OR 60)
 .;.S DIC("B")=AMERTYP
 .;.S AMERPCC=$$EXISTING^AMERPCC(AMERDFN)
 .;.S:AMERPCC>0 DIC("B")=$$GET1^DIQ(9000010,AMERPCC,.08)
 .S AMERPCC=$$EXISTING^AMERPCC(AMERDFN)
 .I AMERPCC>0 D
 ..S AMERCLN=$$GETCLN(AMERPCC) ;Pull Hospital Location
 ..I AMERCLN]"" S DIC("B")=$$GET1^DIQ(9009083,AMERCLN,.01,"E")  ;Get AMER clinic text
 ..I $D(^TMP("AMER",$J,2,20)) S %=+^(20),DIC("B")=$P(^AMER(3,%,0),U)  ;clinic code
 ..S DIC="^AMER(3,"
 ..;GDIT/HS/BEE 05/10/2018;CR#10213;AMER*3.0*10;Filter out inactive
 ..;S DIC("S")="I $P(^(0),U,2)="_$$CAT^AMER0("CLINIC TYPE")
 ..S DIC("S")="I '$P(^(0),U,5),$P(^(0),U,2)="_$$CAT^AMER0("CLINIC TYPE")
 ..S DIC(0)="AEQ"
 ..D ^DIC K DIC
 ..I X=U,'$D(AMERBCH),'$D(AMEREFLG) S X="^^"
 ..I X=U,$D(AMEREFLG) S AMERTFLG=""
 ..I X=U Q
 ..Q
 .Q
 ;
 ;GDIT/HS/BEE 05/10/2018;CR#10213/10423;AMER*3.0*10;Save updated clinic and hospital location
 ;Need to update clinic and hospital location if overrides on file and possibly create new appt
 I +Y,AMERPCC>0 S ERR=$$CKHLOC^AMERBSD(AMERPCC,+Y)
 ;
 S AMERRUN=21
 D OUT^AMER I $D(AMERQUIT) Q
 Q
 ;
QD21 ; PROVIDER
 I $G(AMERTRG)=1 D  Q
 .S Y=-1
 .Q
 ;
 ;GDIT/HS/BEE;Feature#73115/75284;AMER*3.0*13;Multiple nurse/provider handling
 ;Make call to new multi-nurse handler
 NEW AMERV,II
 S AMERV=$$NPRC^AMERMPRV(AMERDFN,"","ED PROVIDER","",0)
 ;
 ;Retrieve latest data from V file and save in ^TMP
 S Y=""
 I +AMERV D
 . S (Y,^TMP("AMER",$J,2,21))=$P(AMERV,U)  ;ED Provider
 . S ^TMP("AMER",$J,2,51)=$P(AMERV,U,2)  ;ED Provider time
 ;
 I $G(AMERV)="" F II=1,2 D
 . K ^TMP("AMER",$J,II,21)
 . K ^TMP("AMER",$J,II,51)
 ;
 S X=$S(AMERV="^":"^",AMERV="^^":"^^",1:"")
 S AMERRUN=24
 I $G(^TMP("AMER",$J,2,21))="" S AMERRUN=27 F II=1,2 K ^TMP("AMER",$J,II,25)
 ;
 D OUT^AMER I $D(AMERQUIT) Q
 Q
 ;
QD22 ; TRIAGE NURSE
 ;
 ;GDIT/HS/BEE;Feature#73115/75284;AMER*3.0*13;Multiple nurse/provider handling
 ;Make call to new multi-nurse handler
 NEW AMERV,II,AMERLOC,AMERTRG
 ;
 S AMERLOC=$G(DUZ(2))
 I '$D(^AMER(2.5,AMERLOC,0)) D  D OUT^AMER S AMERQUIT="" Q
 .W !,"SITE PARAMETERS have not been set up in the ERS PARAMETER option"
 .W !,"Please contact your ERS Supervisors to complete this option before using the EMERGENCY ROOM system"
 .S X="^^"
 ;
QD22A ;Prompt for triage nurse
 ;See if using triage provider
 S AMERTRG=+$$GET1^DIQ(9009082.5,AMERLOC_",",.08,"I")
 I $G(^TMP("AMER",$J,2,26))]"" S AMERTRG=0  ;Not required if they have entered a triage provider
 ;
 S AMERV=$$NPRC^AMERMPRV(AMERDFN,"","TRIAGE NURSE",AMERTRG,0)
 ;
 ;Retrieve latest data from V file and save in ^TMP
 S Y=""
 I +AMERV D
 . S (Y,^TMP("AMER",$J,2,22))=$P(AMERV,U)  ;triage nurse
 . S ^TMP("AMER",$J,2,24)=$P(AMERV,U,2)  ;triage nurse time
 ;
 I $G(AMERV)="" F II=1,2 D
 . K ^TMP("AMER",$J,II,22)
 . K ^TMP("AMER",$J,II,24)
 ;
 S X=$S(AMERV="^":"^",AMERV="^^":"^^",1:"")
 S AMERRUN=25
 ;
 ;Required - if not using triage provider (though it could have been entered in BEDD)
 I X="",'$D(^TMP("AMER",$J,2,22)),'$D(^TMP("AMER",$J,2,26)),AMERTRG D  G QD22A
 . W !!,"<The triage nurse must be entered>" H 3
 ;
 D OUT^AMER I $D(AMERQUIT) Q
 ;
 ;Skip triage provider if not enabled and one not on file (from BEDD)
 I AMERTRG,'$D(^TMP("AMER",$J,2,26)) S AMERRUN=22
 Q
 ;
QD23 ; INITIAL TRIAGE
 S DIR("B")=$G(^TMP("AMER",$J,2,23))
 S DIR("?")="Enter a number from 1 to 5"
 S DIR("?",1)="This is a site-specified value that indicates severity of visit"
 S DIR(0)="N^1:5:0",DIR("A")="*Enter the Emergency Severity Index assessment" KILL DA D ^DIR KILL DIR
 S AMERRUN=51
 D OUT^AMER I X=U Q
 ;
 ;Save now
 I Y D
 . NEW AUPDT,ERR
 . S AUPDT(9009081,AMERDFN_",",20)=Y
 . D FILE^DIE("","AUPDT","ERR")
 Q
 ;
QD24 ; TRIAGE TIME
 ;GDIT/HS/BEE;Feature#73115/75284;AMER*3.0*13;Code no longer used
 Q
 I $D(^TMP("AMER",$J,2,24)) S Y=^(24) X ^DD("DD") S DIR("B")=Y
 ;IHS/OIT/SCR 01/20/09 field no longer manditory
 ;S DIR(0)="DO^::ER",DIR("A")="What time did the patient see the triage nurse",DIR("?")="Enter an exact date and time in Fileman format (e.g. T@1PM)" D ^DIR K DIR
 S DIR(0)="D^::ER",DIR("A")="*What time did the patient see the triage nurse",DIR("?")="Enter an exact date and time in Fileman format (e.g. T@1PM)" D ^DIR K DIR
 I Y,$$TCK($G(^TMP("AMER",$J,1,2)),Y,1,"admission") K Y G QD24
 I Y,$$TVAL($G(^TMP("AMER",$J,1,2)),Y,2) K Y G QD24
 I Y="" S Y=-1
 D OUT^AMER I X?1."^" Q
 ;
 I $G(AMERTRG) S AMERRUN=25,AMERFIN=27 Q
 ;
 I '$D(^TMP("AMER",$J,2,21)),'$G(^TMP("AMER",$J,1,21)),'$D(AMEREFLG) S AMERFIN=28,AMERSTRT=1,AMERRUN=27 Q
 I '$D(^TMP("AMER",$J,2,21)) S AMERRUN=25 Q
 Q
 ;
QD25 ;Medical Screening Exam Time
 NEW TRIDT,AMERP,DIR
 ;
QD25A ;
 ;IHS/OIT/SCR 10/31/08 DON'T ASK DOC TIME IF WE ARE USING TRIAGE OPTION
 I $G(AMERTRG)=1 D  Q
 .S Y=-1
 .Q
 ;
 ;Retrieve triage info
 S AMERP=$$TRIAGE^AMERMPRV(.AMERP,AMERDFN,"")
 S TRIDT=$P(AMERP,U)
 ;IHS/OIT/SCR 11/21/08 don't default the doc time in OUT
 ;I $D(^TMP("AMER",$J,2,25)) S Y=^(25) X ^DD("DD") S DIR("B")=Y
 S DIR(0)="D^::ER",DIR("A")="*Enter Medical Screening Exam Time"
 S DIR("?")="Enter an exact date and time in Fileman format (e.g. T@1PM)"
 I $G(^TMP("AMER",$J,2,25))]"" S DIR("B")=$$FMTE^XLFDT(^TMP("AMER",$J,2,25),"2ZM")
 E  I $O(AMERP("ED PROVIDER",""))]"" S DIR("B")=$$FMTE^XLFDT($O(AMERP("ED PROVIDER","")),"2ZM")
 E  S DIR("B")=""
 D ^DIR
 I Y,$$TCK($G(^TMP("AMER",$J,1,2)),Y,1,"admission") K Y G QD25A
 I Y,$$TCK(TRIDT,Y,1,"triage") K Y G QD25A
 I Y,$$TVAL($G(^TMP("AMER",$J,1,2)),Y,4) K Y G QD25A
 I Y="" S Y=-1
 Q:Y=-1
 ;
 ;Save into ER ADMISSION
 I Y D
 . NEW AUPD,ERR
 . S AUPD(9009081,AMERDFN_",",22)=Y
 . D FILE^DIE("","AUPD","ERR")
 ;
 S AMERRUN=27
 D OUT^AMER I X?1."^" Q
 Q
 ;
 ;GDIT/HS/BEE;Feature#73115/75284;AMER*3.0*13;Multiple nurse/provider handling
QD26 ; Triage Provider
 ;
 ;Make call to new multi provider/nurse handler
 NEW AMERV,II
 S AMERV=$$NPRC^AMERMPRV(AMERDFN,"","TRIAGE PROVIDER","",0)
 ;
 ;Retrieve latest data from V file and save in ^TMP
 S Y=""
 I +AMERV D
 . S (Y,^TMP("AMER",$J,2,26))=$P(AMERV,U)  ;triage nurse
 . S ^TMP("AMER",$J,2,27)=$P(AMERV,U,2)  ;triage nurse time
 ;
 I $G(AMERV)="" F II=1,2 D
 . K ^TMP("AMER",$J,II,26)
 . K ^TMP("AMER",$J,II,27)
 ;
 S X=$S(AMERV="^":"^",AMERV="^^":"^^",1:"")
 ;
 ;Check for either triage nurse or provider
 S AMERRUN=22
 I X="",$G(^TMP("AMER",$J,2,22))="",$G(^TMP("AMER",$J,2,26))="" D
 . S AMERRUN=21
 . W !!,"<Either a triage nurse or triage provider must be entered>" H 3
 ;
 D OUT^AMER I $D(AMERQUIT) Q
 Q
 ;
QD27 ; Triage Provider Time
 Q
 ;
QD28(AMERPCC) ; Decision to admit date/time - AMER*3.0*6
 NEW DIR,DECDT,PCCUPD,ERROR,AMVDT
 ;
QD28E ;Pull current date/time from PCC
 I $G(AMERPCC)="" S AMERPCC=$$GET1^DIQ(9009081,DFN_",",1.1,"I")
 I AMERPCC="" S AMERRUN=1 Q
 S DECDT=$$GET1^DIQ(9000010,AMERPCC,1116,"E")
 S:$G(DECDT)]"" DIR("B")=DECDT
 S AMVDT=$$GET1^DIQ(9000010,AMERPCC_",",.01,"I")  ;Get visit date
 ;
 ;Prompt for date
 S DIR(0)="DO^::ER",DIR("A")="Enter the decision to admit date/time",DIR("?")="Enter an exact date and time in Fileman format (e.g. T@1PM)" D ^DIR K DIR
 ;
 ;Perform validation
 I Y,$$TCK(AMVDT,Y,1,"admission") K Y G QD28E
 ;
 ;Save the new value
 I +Y>0 S PCCUPD(9000010,AMERPCC_",",1116)=Y
 ;
 ;Handle deletes
 I Y="" S PCCUPD(9000010,AMERPCC_",",1116)="@"
 ;
 ;File entry in PCC
 I $D(PCCUPD) D FILE^DIE("","PCCUPD","ERROR")
 ;
 I '$G(^TMP("AMER",$J,1,21)),'$D(AMEREFLG) S AMERFIN=28,AMERSTRT=1,AMERRUN=$S('$D(AMERTRG):1,$D(AMERTRG):30,1:1) Q
 I '$D(AMERTRG) S AMERRUN=1
 Q
 ;
TCK(Z,T,X,A) ; ENTRY POINT FROM AMER2
 ; TIME CHECK WHERE Z=TIME,T=COMPARISON TIME,X=1:AFTER,X=0:BEFORE AND A=NARRATIVE
 N %,Y
 I $G(Z)=""!($G(A)="") Q ""
 S Y=Z X ^DD("DD")
 I X,T'<Z Q 0
 I 'X,T<Z Q 0
 W !!,*7,"Sorry, this time must be ",$S(X:"AFTER",1:"BEFORE")," the time of ",A,": ",Y,!,"Please try again...",! Q 1
 ;
TVAL(Z,T,H) ; ENTRY POINT FROM AMER2 and multiple editing routines
 ; VALIDATE THE TIME WHERE Z=TIME,T=COMPARISON TIME AND H=MAX HOURS ALLOWED
 N A,B,C,D,X,%H,%T,%Y,%,E,F,Y
 S Y=Z X ^DD("DD")
 S X=Z D H^%DTC S A=%H,B=%T
 S X=T D H^%DTC S C=%H,D=%T
 S E=C-A*60*60*24+D
 S F=(E-B)\(3600)
 I F<H Q 0
 S %=2 W !!,*7,"This means a really long delay since the time of admission: ",Y,!,"Are you sure" D YN^DICN W !
 I %=1 Q 0
 Q 1
 ;
 ;GDIT/HS/BEE 05/10/2018;CR#10213;AMER*3.0*10;Save updated clinic and hospital location
SYNCCL(AMERDA,AMERPCC) ;Sync the ER VISIT clinic with the PCC clinic
 ;
 ;Original code from SYNCHPCC^AMERPCC - Copied here to address routine size issue
 ; GET THE EXTERNAL VALUE FOR "CLINIC TYPE" IN VISIT FILE AND SET IT TO EMERGENCY IF IT ISN'T ALREADY URGENT CARE
 ;S AMERCLN=$P($G(^AMERVSIT(AMERDA,0)),U,4)  ; AMERCLN IS A POINTER TO ER OPTIONS FILE 
 ;I AMERCLN'="" D
 ;.S AMERCLN=$P($G(^AMER(3,AMERCLN,0)),U,1)  ; AMERCLN IS A WORD - 30: EMERGENCY MEDICINE "80: URGENT CARE"
 ;.S AMERVVAL=$$CLINIC^APCLV(AMERPCC,"E")
 ;.I (AMERVVAL'=AMERCLN) D
 ;..S AMERPNTR=$O(^DIC(40.7,"B",AMERCLN,0))
 ;..S:AMERPNTR'="" AMERVDR=$S(AMERVDR'="":AMERVDR_";",1:""),AMERVDR=AMERVDR_".08////"_AMERPNTR
 ;..Q
 ;
 I +$G(AMERDA)=0 Q
 I +$G(AMERPCC)=0 Q
 ;
 NEW ECEIEN,ECPIEN,EHPIEN,PCIEN,PHIEN
 ;
 ;Get ERS clinic pointer to ER OPTIONS
 S ECEIEN=$$GET1^DIQ(9009080,AMERDA_",",.04,"I")
 ;
 ;Get ERS clinic pointer associated IEN for PCC and associated hospital location IEN
 S (ECPIEN,EHPIEN)="" I +ECEIEN D
 . NEW CLN,HLI
 . ;
 . ;Clinic
 . S CLN=$$GET1^DIQ(9009083,+ECEIEN_",",5,"I")  ;Get clinic code
 . I CLN]"" S ECPIEN=$O(^DIC(40.7,"C",CLN,""))
 . ;
 . ;Hospital Location
 . S HLI=$O(^AMER(2.5,DUZ(2),8,"B",+ECEIEN,"")) I HLI D
 .. S EHPIEN=$P($G(^AMER(2.5,DUZ(2),8,HLI,0)),U,2)
 . S:EHPIEN="" EHPIEN=$G(^AMER(2.5,DUZ(2),"SD"))  ;If blank, pull original value
 ;
 ;Get PCC Clinic and Hospital Location
 S PCIEN=$$GET1^DIQ(9000010,AMERPCC_",",.08,"I")
 S PHIEN=$$GET1^DIQ(9000010,AMERPCC_",",.22,"I")
 ;
 ;If ER VISIT is blank or not equal to PCC copy from PCC
 I PCIEN,(('ECEIEN)!(ECPIEN'=PCIEN)) D  Q
 . NEW AMERUPD,ERROR,ENCPIEN,CODE
 . S CODE=$$GET1^DIQ(40.7,PCIEN_",",1,"I") Q:'CODE
 . S ENCPIEN=$O(^AMER(3,"B",CODE,"")) Q:'ENCPIEN
 . S AMERUPD(9009080,AMERDA_",",.04)=ENCPIEN
 . D FILE^DIE("","AMERUPD","ERROR")
 ;
 ;If PCC is blank copy from ER VISIT
 I 'PCIEN,ECPIEN D
 . NEW AMERUPD,ERROR
 . S AMERUPD(9000010,AMERPCC_",",.08)=ECPIEN
 . S AMERUPD(9000010,AMERPCC_",",.22)=EHPIEN
 . D FILE^DIE("","AMERUPD","ERROR")
 ;
 Q
 ;
 ;GDIT/HS/BEE 07/12/2018;CR#10423;AMER*3.0*10
GETCLN(AUPNVSIT) ;Return the ER Clinic for the PCC hospital location
 ;
 I $G(AUPNVSIT)="" Q ""
 ;
 NEW HLOC,CLN,DIV
 ;
 S DIV=$$GET1^DIQ(9000010,AUPNVSIT_",",".06","I") S:DIV="" DIV=$G(DUZ(2)) I DIV="" Q ""
 ;
 S CLN=""
 S HLOC=$$GET1^DIQ(9000010,AUPNVSIT_",",.22,"I") I HLOC]"" D
 . NEW CIEN
 . S CIEN=0 F  S CIEN=$O(^AMER(2.5,DIV,8,CIEN)) Q:'CIEN  D  Q:CLN
 .. NEW ECLN,EHLOC,DA,IENS
 .. S DA(1)=DIV,DA=CIEN,IENS=$$IENS^DILF(.DA)
 .. S EHLOC=$$GET1^DIQ(9009082.58,IENS_",",".02","I")
 .. I HLOC'=EHLOC Q
 .. S ECLN=$$GET1^DIQ(9009082.58,IENS_",",".01","I") Q:ECLN=""
 .. S CLN=ECLN
 ;
 ;If no clinic resort to pre-patch 10 logic
 I CLN="" D
 . NEW CLINIC
 . ;
 . S CLINIC=$$GET1^DIQ(9000010,AUPNVSIT_",",.08,"I")
 . I CLINIC]"" S CLINIC=$$GET1^DIQ(40.7,CLINIC_",",1,"I")
 . I CLINIC]"" S CLN=$O(^AMER(3,"B",CLINIC,""))
 ;
 Q CLN
 ;
ACT(PRV) ;Return if a provider is active and has PROVIDER key
 NEW TERM
 S TERM=$$GET1^DIQ(200,PRV_",","9.2","I")
 I TERM]"",TERM<DT Q 0  ;Terminated user
 I $$GET1^DIQ(200,PRV_",",7,"I")=1 Q 0  ;Disuser
 ;
 ;Are they a provider?
 I '$D(^XUSEC("PROVIDER",PRV)) Q 0
 Q 1
 ;
NEW ;Initialize variables
 NEW AMEROPT
 Q
