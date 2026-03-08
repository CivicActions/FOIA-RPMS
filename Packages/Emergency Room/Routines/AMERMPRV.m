AMERMPRV ;GDIT/HS/BEE - Allow multiple nurse/provider entry ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**13,14**;MAR 03, 2009;Build 4
 ;
 Q
 ;
NPRC(AMERDFN,VIEN,TYPE,REQ,AUD) ;Process nurse/provider field
 ;
 ;AMERDFN - Patient DFN
 ;VIEN - Visit IEN (null for current admits)
 ;TYPE - Nurse/Provider Type
 ;REQ - 1 if field is required
 ;AUD - Audit entry #
 NEW NDISP,HYPHEN,NLST,QUIT,ACTION,EDENTRY,TILDE,AMERP,NP,AMERV
 ;
 S $P(HYPHEN,"-",80)="-"
 S $P(TILDE,"~",80)="~"
 S VIEN=$G(VIEN)
 S AMERDFN=$G(AMERDFN)
 S TYPE=$G(TYPE)
 ;
 ;Check if required
 S REQ=+$G(REQ)
 ;
 ;Check if auditing entry
 S AUD=+$G(AUD)
 ;
 ;Get nurse prompt display
 S NDISP="",NP=""
 I TYPE="TRIAGE NURSE" S NDISP="Triage nurse",NP="N"
 I TYPE="TRIAGE PROVIDER" S NDISP="Triage Provider",NP="P"
 I TYPE="PRIMARY NURSE" S NDISP="Primary Nurse",NP="T"
 I TYPE="ED PROVIDER" S NDISP="ED Provider",NP="P"
 Q:NDISP="" ""
 ;
NPRMPT ;Prompt for nurse/provider
 ;
 ;Reset variables
 S (ACTION,QUIT,EDENTRY)=""
 ;
 ;Form feed
 D HDR
 W TYPE," ENTRY"
 ;
 ;Clear out existing
 S AMERV="" F  S AMERV=$O(AMERV(AMERV)) Q:AMERV=""  K AMERV(AMERV)
 S NLST="" F  S NLST=$O(NLST(NLST)) Q:NLST=""  K NLST(NLST)
 S AMERP="" F  S AMERP=$O(AMERP(AMERP)) Q:AMERP=""  K AMERP(AMERP)
 ;
 ;Get current entries for visit
 S AMERP=$$GPROV^AMERMPV1(.AMERP,$G(AMERDFN),VIEN)
 ;
 ;Display current list
 I $O(AMERP(TYPE,""))]"" D
 . NEW NTIME,NIEN
 . W !!,"Current entry/entries on file for visit:",!
 . W !,"#",?5,"Nurse/Provider",?40,"Date/Time Seen"
 . W !,$E(HYPHEN,1,53)
 . S NTIME="" F  S NTIME=$O(AMERP(TYPE,NTIME),-1) Q:NTIME=""  D
 .. S NIEN="" F  S NIEN=$O(AMERP(TYPE,NTIME,NIEN)) Q:NIEN=""  D
 ... NEW PNAME
 ... S PNAME=$$GET1^DIQ(200,NIEN_",",.01,"E") S:PNAME="" PNAME=NIEN
 ... S NLST=NLST+1,NLST(NLST)=NTIME_U_NIEN
 ... W !,NLST,?5,PNAME,?40,$$FMTE^XLFDT(NTIME,"2ZM")
 ;
 ;Prompt for add/edit/delete if records on file
 W !
 I $O(AMERP(TYPE,""))]"" D
 . NEW DIR,DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DA
 . S QUIT=""
 . S DIR(0)="SAO^A:Add;E:Edit;D:Delete",DIR("A")="(A)dd new, (E)dit existing, (D)elete existing "_NDISP_": "
 . D ^DIR
 . I $D(DIROUT) S QUIT="^^" Q
 . I $D(DTOUT) S QUIT="^" Q
 . I $D(DUOUT) S QUIT="^" Q
 . ;
 . ;If user hit enter, return latest one
 . I Y="" S QUIT=$$GETP^AMERMPV1($G(AMERDFN),VIEN,TYPE,.AMERV) Q
 . ;
 . ;Handle action
 . I (Y="A")!(Y="E")!(Y="D") S ACTION=Y
 . I ACTION="" S QUIT="^" Q
 . Q:ACTION="A"
 . ;
 . ;Prompt for entry to edit/delete
 . S DIR(0)="NO^1:"_$O(NLST(""),-1)_":0",DIR("A")="Enter the entry # to "_$S(ACTION="E":"edit",1:"delete")_": "
 . D ^DIR
 . I $D(DIROUT) S QUIT="^^" Q
 . I $D(DTOUT) S QUIT="^" Q
 . I $D(DUOUT) S QUIT="^" Q
 . I Y="" S QUIT="AGAIN"
 . I '$D(NLST(+Y)) W "??" H 2 S QUIT="AGAIN"
 . S EDENTRY=+Y
 E  S ACTION="A"
 I QUIT="AGAIN" G NPRMPT
 I QUIT]"" Q QUIT
 ;
 ;Handle deletes
 I ACTION="D",EDENTRY D
 . NEW DPIEN,DPDATE
 . NEW DIR,DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DA,PROV,NURSE
 . ;
 . ;Prompt to verify
 . S DIR(0)="Y",DIR("B")="NO",DIR("A")="Are you sure you want to remove this entry: "
 . D ^DIR
 . I $D(DIROUT) S QUIT="^^" Q
 . I $D(DTOUT) S QUIT="^" Q
 . I $D(DUOUT) S QUIT="AGAIN" Q
 . I Y'=1 S QUIT="AGAIN" Q
 . ;
 . ;Delete the entry and sync
 . S DPIEN=$P($G(NLST(EDENTRY)),U,2)
 . S DPDATE=$P($G(NLST(EDENTRY)),U)
 . I DPIEN]"",DPDATE]"" D
 .. D DELP^AMERPRV(AMERDFN,TYPE,DPIEN,DPDATE,VIEN)
 .. I AUD,VIEN D AUD(AUD,VIEN,TYPE,DPIEN,DPDATE,"","D")  ;Audit entry
 .. D SYNC(AMERDFN,VIEN,.PROV,.NURSE,"")
 .. S QUIT="AGAIN"
 I QUIT="AGAIN" G NPRMPT
 I QUIT]"" Q QUIT
 ;
 ;Handle edits
 I ACTION="E",EDENTRY D
 . NEW PIEN,PDATE,ODATE,PROV,NURSE
 . S PIEN=$P($G(NLST(EDENTRY)),U,2)
 . S (ODATE,PDATE)=$P($G(NLST(EDENTRY)),U)
 . W !!,NDISP,": ",$$GET1^DIQ(200,PIEN_",",".01","E"),!
 . ;
 . ;Prompt for the new date/time seen
 . S QUIT=$$PDATE(AMERDFN,.PDATE)
 . I QUIT'="1" Q
 . ;
 . ;Update the entry and sync
 . I PIEN,PDATE]"" D
 .. D EDTP^AMERPRV(AMERDFN,VIEN,TYPE,PIEN,ODATE,PDATE)
 .. I AUD,VIEN,ODATE'=PDATE D AUD(AUD,VIEN,TYPE,PIEN,ODATE,PDATE,"E")  ;Audit entry
 .. D SYNC(AMERDFN,VIEN,.PROV,.NURSE,"")
 .. S QUIT="AGAIN"
 I QUIT="AGAIN" G NPRMPT
 I QUIT]"" Q QUIT
 ;
 ;Handle adds
 I ACTION="A" D
 . NEW DIR,X,Y,NPRV,PROV,NURSE,NTIME,NIEN,PDATE,NAMERP
 . S QUIT=""
 . S DIR("A")=$S(REQ:"*",1:"")_NDISP K DIR("B")
 . S DIR("?")="^D NHELP^AMERMPV1(NP)"
 . S DIR="^VA(200,",DIR(0)="PO^200:AEQM"
 . S DIR("S")="I $D(^VA(200,""AK.PROVIDER"",$P($G(^VA(200,+Y,0)),U),+Y))"
 . W !,TILDE,!! D ^DIR
 . I $D(DIROUT) S QUIT="^^" Q
 . I $D(DUOUT),$O(AMERP(TYPE,""))]"" S QUIT="AGAIN" Q
 . I $D(DUOUT) S QUIT="^" Q
 . I $G(Y)<1,$O(AMERP(TYPE,""))]"" S QUIT="AGAIN" Q
 . I $G(Y)<1 S QUIT=1 Q
 . ;
 . ;Save new value
 . S NPRV=+Y
 . ;
 . ;Now prompt for a time
 . S QUIT=$$PDATE(AMERDFN,.PDATE)
 . I QUIT'="1" Q
 . ;
 . ;Save new entry in array and audit
 . S NAMERP(TYPE,PDATE,NPRV)=""
 . I AUD,VIEN D AUD(AUD,VIEN,TYPE,NPRV,"",PDATE,"A")  ;Audit entry
 . ;
 . ;Now perform the save and Sync
 . D SYNC(AMERDFN,VIEN,.PROV,.NURSE,.NAMERP)
 . S QUIT="AGAIN"
 ;
 I QUIT=1 QUIT ""  ;picked add, none entered, none on file
 I QUIT="AGAIN" G NPRMPT
 I QUIT]"" Q QUIT
 ;
 G NPRMPT
 ;
PDATE(AMERDFN,PDATE,BY) ;Prompt for date/time seen
 ;
 I '$G(AMERDFN) Q ""
 S PDATE=$G(PDATE)
 S BY=$G(BY)
 ;
 NEW QUIT,ADMDT
 NEW DIR,DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DA
 ;
 S QUIT=""
 ;
 ;Prompt for the new date/time seen
 F  D  Q:QUIT]""
 . S ADMDT=$$GET1^DIQ(9009081,AMERDFN_",",1,"I")
 . S DIR(0)="D^::ER",DIR("A")="*Enter the date/time that this patient was seen"_$S(BY]"":" by "_BY,1:"")
 . S DIR("B")=""
 . I PDATE]"" S DIR("B")=$$FMTE^XLFDT(PDATE,"2ZM")
 . E  S DIR("B")=$$FMTE^XLFDT($$NOW^XLFDT,"2ZM")
 . D ^DIR
 . I $D(DIROUT) S QUIT="^^" Q
 . I $D(DTOUT) S QUIT="^" Q
 . I $D(DUOUT) S QUIT="AGAIN" Q
 . I Y="" W !!,"<This information is required>" H 3 Q
 . ;
 . ;Must be after admit date
 . I Y<ADMDT W !!,"<Must be after admission date/time of "_$$FMTE^XLFDT(ADMDT,"2ZM")_">" H 3 Q
 . I Y>($$NOW^XLFDT) W !!,"<Must not be a future date>" H 3 Q
 . ;
 . ;Return information
 . S PDATE=Y,QUIT="1"
 ;
 S:QUIT="" QUIT="AGAIN"
 Q QUIT
 ;
TRIAGE(AMERP,AMERDFN,VIEN) ;Return triage nurse/provider information
 ;
 ;Returns Array AMERP - Array of all nurse/provider information
 ;
 ;Function Returns
 ;Piece
 ;1 - Earliest Triage D/T
 ;2 - Earliest Triage User (could be nurse or provider)
 ;3 - Latest Triage D/T
 ;4 - Latest Triage User (could be nurse or provider)
 ;5 - Earliest Triage Nurse D/T
 ;6 - Earliest Triage Nurse
 ;7 - Latest Triage Nurse D/T
 ;8 - Latest Triage Nurse
 ;9 - Earliest Triage Provider D/T
 ;10 - Earliest Triage Provider
 ;11 - Latest Triage Provider D/T
 ;12 - Latest Triage Provider
 ;
 S AMERDFN=$G(AMERDFN)
 S VIEN=$G(VIEN)
 ;
 NEW TYP,TDT,TDU,ETD,ETU,LTD,LTU,ETND,ETN,LTND,LTN,ETPD,ETP,LTPD,LTP
 ;
 ;Reset list
 S TYP="" F  S TYP=$O(AMERP(TYP)) Q:TYP=""  K AMERP(TYP)
 ;
 ;Get a list of all providers/nurses
 S AMERP=$$GPROV^AMERMPV1(.AMERP,AMERDFN,VIEN)
 ;
 NEW TDT,TDU,ETD,ETU,LTD,LTU,ETND,ETN,LTND,LTN,ETPD,ETP,LTPD,LTP
 ;
 S (ETD,ETU,LTD,LTU,ETND,ETN,LTND,LTN,ETPD,ETP,LTPD,LTP)=""
 ;
 S TDT="" F  S TDT=$O(AMERP("TRIAGE NURSE",TDT)) Q:TDT=""  S TDU="" F  S TDU=$O(AMERP("TRIAGE NURSE",TDT,TDU)) Q:TDU=""  D
 . I ETD="" S ETD=TDT,ETU=TDU
 . I LTD="" S LTD=TDT,LTU=TDU
 . I ETND="" S ETND=TDT,ETN=TDU
 . I LTND="" S LTND=TDT,LTN=TDU
 . I ETD>TDT S ETD=TDT,ETU=TDU ;Earlier triage
 . I LTD<TDT S LTD=TDT,LTU=TDU ;Later triage
 . I ETND>TDT S ETND=TDT,ETN=TDU ;Earlier nurse
 . I LTND<TDT S LTND=TDT,LTN=TDU ;Later nurse
 ;
 S TDT="" F  S TDT=$O(AMERP("TRIAGE PROVIDER",TDT)) Q:TDT=""  S TDU="" F  S TDU=$O(AMERP("TRIAGE PROVIDER",TDT,TDU)) Q:TDU=""  D
 . I ETD="" S ETD=TDT,ETU=TDU
 . I LTD="" S LTD=TDT,LTU=TDU
 . I ETPD="" S ETPD=TDT,ETP=TDU
 . I LTPD="" S LTPD=TDT,LTP=TDU
 . I ETD>TDT S ETD=TDT,ETU=TDU ;Earlier triage
 . I LTD<TDT S LTD=TDT,LTU=TDU ;Later triage
 . I ETPD>TDT S ETPD=TDT,ETP=TDU ;Earlier nurse
 . I LTPD<TDT S LTPD=TDT,LTP=TDU ;Later nurse
 ;
 Q ETD_U_ETU_U_LTD_U_LTU_U_ETND_U_ETN_U_LTND_U_LTN_U_ETPD_U_ETP_U_LTPD_U_LTP
 ;
HDR ;Print page header
 NEW AMERLINE
 S $P(AMERLINE,"~",80)="~"
 ;GDIT/HS/BEE;AMER*3.0*14;FEATURE#89183;08/04/2023;Display PPN
 ;W @IOF,"ER ADMISSION FOR ",$P(^DPT(AMERDFN,0),U),"    ^ = back up    ^^ = quit"
 W @IOF,"ER ADMISSION FOR ",$E($$PPN^AMERUTIL(AMERDFN,0),1,44)," ^=back up ^^=quit"
 W !,"Questions preceded by a '*' are MANDATORY.  Enter '??' to see choices."
 W !,AMERLINE,!!
 Q
 ;
SYNC(AMERDFN,VIEN,PROV,NURSE,NAMERP) ;Sync with V EMERGENCY VISIT RECORD, ER ADMISSION, ER VISIT, V PROVIDER
 ;
 ;This process will add any new records to V ER and sync V ER with ER ADMISSION/ER VISIT/V PROVIDER
 ;
 ;ER VISIT updates will have VIEN
 ;ER ADMISSION updates will not have a VIEN
 ;
 NEW TYP,AMERP,ADMVIS,AMERVSIT,Y
 ;
 ;If no visit, try to pull from ER ADMISSION
 I 'VIEN S VIEN=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I") Q:'VIEN
 ;
 ;Look for ER VISIT
 S AMERVSIT=$O(^AMERVSIT("AD",VIEN,""))
 I AMERVSIT S ADMVIS="V"
 E  I $D(^AMERADM(AMERDFN)) S ADMVIS="A"
 E  Q
 ;
 ;Get current entries for visit
 S AMERP=$$GPROV^AMERMPV1(.AMERP,$G(AMERDFN),VIEN)
 ;
 ;Merge in new entry
 I $O(NAMERP(""))]"" M AMERP=NAMERP
 ;
 ;Assemble PROV/NURSE arrays
 S TYP="" F  S TYP=$O(AMERP(TYP)) Q:TYP=""  D
 . ;
 . NEW PN,PTYP
 . S PTYP="",PN=""
 . I TYP="ED PROVIDER" S PN="P",PTYP="ED"
 . E  I TYP="TRIAGE PROVIDER" S PN="P",PTYP="TR"
 . E  I TYP="PRIMARY PROVIDER" S PN="P",PTYP="PR"
 . E  I TYP="DISCHARGE PROVIDER" S PN="P",PTYP="DC"
 . E  I TYP="TRIAGE NURSE" S PN="N",PTYP="TR"
 . E  I TYP="PRIMARY NURSE" S PN="N",PTYP="PR"
 . E  I TYP="OTHER NURSE" S PN="N",PTYP="OT"
 . E  I TYP="DISCHARGE NURSE" S PN="N",PTYP="DC"
 . I PTYP="" Q
 . S NTIME="" F  S NTIME=$O(AMERP(TYP,NTIME)) Q:NTIME=""  D
 .. S NIEN="" F  S NIEN=$O(AMERP(TYP,NTIME,NIEN)) Q:NIEN=""  D
 ... I PN="P" S PROV(NTIME,NIEN,PTYP)=""
 ... I PN="N" S NURSE(NTIME,NIEN,PTYP)=""
 ;
 ;Re-Save the entries (since there might be an addition)
 D NRPRV^AMERVER($G(AMERDFN),$G(VIEN),.PROV,.NURSE)
 ;
 ;Update ER ADMISSION
 I ADMVIS="A" D SADM^AMERMPV1(AMERDFN,.PROV,.NURSE)
 ;
 ;Update ER VISIT
 I ADMVIS="V" D
 . NEW AMERVSIT
 . D SVIS^AMERMPV1(AMERDFN,VIEN,.PROV,.NURSE)
 . S AMERVSIT=$O(^AMERVSIT("AD",+$G(VIEN),"")) Q:AMERVSIT=""
 . D UTRG^AMERVER(AMERVSIT)
 ;
 ;Synchronize V PROVIDER
 D SYNC^AMERPRV(VIEN)
 Q
 ;
AUD(AMERAIEN,VIEN,TYPE,PIEN,ODATE,PDATE,EVNT) ;Audit add/edit/delete
 ;
 I $G(VIEN)="" Q
 I $G(TYPE)="" Q
 I $G(PIEN)="" Q
 I $G(EVNT)="" Q
 ;
 NEW AMERVST,NOW,AMERSTRG,PROV,PFLD,AMERNEW,AMEROLD,AMERSTRG
 ;
 ;Get ER VISIT
 S AMERVST=$O(^AMERVSIT("AD",VIEN,"")) Q:AMERVST=""
 ;
 ;Define fields
 S PFLD=""
 I TYPE="TRIAGE NURSE" S PFLD=".07|12.2"
 I TYPE="TRIAGE PROVIDER" S PFLD="17.5|17.6"
 I TYPE="ED PROVIDER" S PFLD=".06|17.7"
 I TYPE="PRIMARY NURSE" S PFLD="17.8|17.9"
 Q:PFLD=""
 ;
 ;Edits
 I EVNT="E" D  Q
 . S PROV=$$GET1^DIQ(200,PIEN_",",.01,"E")
 . S AMEROLD=$S(PROV]"":PROV,1:"")_$S($G(ODATE)]"":" ("_$$FMTE^AMERMPV1(ODATE,"2ZM")_")",1:"")
 . S AMERNEW=$S(PROV]"":PROV,1:"")_$S($G(PDATE)]"":" ("_$$FMTE^AMERMPV1(PDATE,"2ZM")_")",1:"")
 . S AMERSTRG=$$EDAUDIT^AMEREDAU($P(PFLD,"|",2),AMEROLD,AMERNEW,TYPE_" TIME")
 . Q:AMERSTRG="^"
 . D:AMERSTRG]"" MULTAUDT^AMEREDAU(AMERSTRG,AMERAIEN)
 ;
 ;Deletes
 I EVNT="D" D  Q
 . S PROV=$$GET1^DIQ(200,PIEN_",",.01,"E")
 . S AMEROLD=$S(PROV]"":PROV,1:"")_$S($G(ODATE)]"":" ("_$$FMTE^AMERMPV1(ODATE,"2ZM")_")",1:"")
 . S AMERNEW=""
 . ;
 . ;Audit deleted nurse/provider name
 . S AMERSTRG=$$EDAUDIT^AMEREDAU($P(PFLD,"|",1),AMEROLD,AMERNEW,TYPE)
 . Q:AMERSTRG="^"
 . D:AMERSTRG]"" MULTAUDT^AMEREDAU(AMERSTRG,AMERAIEN)
 . ;
 . ;Audit deleted nurse/provider time
 . S $P(AMERSTRG,";")=$P(PFLD,"|",2)
 . S $P(AMERSTRG,";",6)=TYPE_" TIME"
 . D:AMERSTRG]"" MULTAUDT^AMEREDAU(AMERSTRG,AMERAIEN)
 ;
 ;Adds
 I EVNT="A" D  Q
 . S PROV=$$GET1^DIQ(200,PIEN_",",.01,"E")
 . S AMEROLD=""
 . S AMERNEW=$S(PROV]"":PROV,1:"")_$S($G(PDATE)]"":" ("_$$FMTE^AMERMPV1(PDATE,"2ZM")_")",1:"")
 . ;
 . ;Audit added nurse/provider name
 . S AMERSTRG=$$EDAUDIT^AMEREDAU($P(PFLD,"|",1),AMEROLD,AMERNEW,TYPE)
 . Q:AMERSTRG="^"
 . D:AMERSTRG]"" MULTAUDT^AMEREDAU(AMERSTRG,AMERAIEN)
 . ;
 . ;Audit added nurse/provider time
 . S $P(AMERSTRG,";")=$P(PFLD,"|",2)
 . S $P(AMERSTRG,";",6)=TYPE_" TIME"
 . D:AMERSTRG]"" MULTAUDT^AMEREDAU(AMERSTRG,AMERAIEN)
 ;
 Q
