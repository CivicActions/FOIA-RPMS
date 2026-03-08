BADEALR1 ;IHS/GDIT/GAB - Dentrix HL7 Interface  ;08/15/2025
 ;;1.0;DENTAL/EDR INTERFACE;**10**;FEB 22, 2010;Build 61
 ;;Re-Processes failed Dental Notes
 ;;Adds entries to the ^XTMP("BADEMDM","REPROC") global - data in selected date range
 ;;Purge alerts in ^XTMP("BADEMDM") by purge date
 ;   MSIEN = ^HLB message IEN
 Q
BEGIN ;EP Select dental notes
 D CLEAN S ANS=0
 D CALCTOT
 W !!,"This option allows you to re-process failed dental notes transmitted from EDR",!
 I '$D(^XTMP("BADEMDM","VISDT"))  D  Q
 . W !!,"** There are no failed dental notes that can be re-processed **",!!
 . D PAUSE^BADEUTIL
 S DIR(0)="SO^1:By Author or Signer Name;2:By Provider Name"
 S BADEQ=0 D ^DIR K DIR
 S:Y["^" BADEQ=1 Q:BADEQ
 S ANS=Y Q:'ANS
 ;
START ;
 D PURGE     ;purge old alerts
 D RETRIEVE^BADEALRT   ;get the date range
 Q:$G(BADEQ)
 D PRT2^BADEALRT(ANS)  ;print & select alerts by author/signer or provider
 Q:'ANS!$G(BADEQ)
 D REPROC
 Q
 ;
REPROC  ; Re-process the dental note
 ;Re-process alerts by Author/Signer, date range
 ;^XTMP("BADEMDM","VISDT",3250430,3,20000905,0)="3260430^13^29^DEMO,AUTH^0^^^20250603211417"""
 ;                      Visit Date,CLASS,MSGIEN=PURG^PDFN^PIEN^AUT/SIG^IEN^^^NOTE DT(TXA.6)
 ;^XTMP("BADEMDM","REPROC",3,20000905,0)="3250430^13^29^DEMO,AUTH^0^^^20250603211417 (saved selection)
 ;                        CLASS,MSGIEN    VisDt^PDFN^PIEN^AUTH/SIGN^IEN^^^NOTE DT(TXA.6)
 K DA,Y,ANS2,ERR,UP
 S (MSGB,NUM,TOTL,EDRQ,EDQ,EDRP,UP,IEN,X,USEIT)=0
 S ANS2=$$DIR^XBDIR("Y","Are you ready to begin (Y/N)?","N","","","",1)
 I ANS2'=1 S EDRQ=1 Q
 D CHKNAM Q:EDRQ=1  ; ask for the name (RPMS IEN:EDRPROV; Name:EDRPRVP)
 ;Find the Author/Signer or Provider selected
 F  S NUM=$O(^XTMP("BADEMDM","REPROC",NUM)) Q:NUM=""  D
 . F  S MSGB=$O(^XTMP("BADEMDM","REPROC",NUM,MSGB)) Q:MSGB=""  D
 . . S EDQ=0
 . . S ERR=^XTMP("BADEMDM","REPROC",NUM,MSGB,0)
 . . I ANS=1  D            ;AUTHOR/SIGNER ALERTS
 . . . S IEN=$P($G(ERR),"^",5)  ;check the IEN if transmitted
 . . . I IEN  D     ;there is an IEN use it if valid
 . . . . I '$D(^VA(200,IEN,0)) S EDQ=1 Q
 . . . I 'IEN&('USEIT) S EDQ=1    ;no IEN transmitted and no acceptable user name;
 . . I ANS=2  D            ;PROVIDER ALERTS - IEN is required
 . . . I $P($G(ERR),"^",3)="" S EDQ=1    ;Provider/Dentist IEN in piece 3 is required - or cannot re-process
 . . Q:EDQ=1
 . . S EVDATE="" S EVDATE=$P($G(ERR),"^",8)    ; TXA.6 field/Note event date/time
 . . S PTDFN="" S PTDFN=$P($G(ERR),"^",2)      ; Patient IEN
 . . S VS="" S VS=$P($G(ERR),"^",1)            ; Visit date
 . . S DNUSR="" S DNUSR=$P($G(ERR),"^",4)      ; Author/Signer or Provider Name   ;NUM=Alert Number
 . . I EVDATE&PTDFN S ^XTMP("BADEMDM","PROC",MSGB,0)=EVDATE_"^"_NUM_"^"_PTDFN_"^"_VS_"^"_DNUSR
 . . E  S EDQ=1 Q
 . . S TOTL=TOTL+1
 . . W !,"Re-process HLB MSG Number  ",MSGB
 I TOTL=0  D  Q
 . W !!,"Cannot find any dental notes to be re-processed from your selection!!"
 . W !!,"The name in RPMS must match the name in the dental note.",!
 . W "The name you entered does not match:  ",!
 . W EDRPRVP
 . D PAUSE^BADEUTIL
 W !!,"TOTAL Messages to be re-processed: ",TOTL
 W !,"Make sure you correct all issues before you continue...",!
 K DA,Y,ANS2 S ANS2=$$DIR^XBDIR("Y","Do you wish to continue (Y/N)?","N","","","",1)
 I ANS2'=1 S EDRQ=1 Q
 D TIUPROC(EDRPROV)  ;Re-process the messages found; EDRPROV=IEN Found from user selection
 D CALCTOT  ;Recalculate totals
 Q
 ;
TIUPROC(EDRPR) ; Process the HLB Message Number from ^XTMP("BADEMDM","PROCESS")
 ;EDT= Note Date/Time (TXA.6); VSD=Visit Date; EDRPR=Auth/Sign or Prov IEN
 ;
 S (MSGB,DP)=0
 W !,"BEGIN processing the dental notes selected...",!!
 F  S MSGB=$O(^XTMP("BADEMDM","PROC",MSGB)) Q:MSGB=""  D
 . S EDQ=0
 . S EDT="" S EDT=$P($G(^XTMP("BADEMDM","PROC",MSGB,0)),"^")
 . S CLASS="" S CLASS=$P($G(^XTMP("BADEMDM","PROC",MSGB,0)),"^",2)
 . S PATDFN="" S PATDFN=$P($G(^XTMP("BADEMDM","PROC",MSGB,0)),"^",3)
 . S VSD="" S VSD=$P($G(^XTMP("BADEMDM","PROC",MSGB,0)),"^",4)
 . S DNUSER="" S DNUSER=$P($G(^XTMP("BADEMDM","PROC",MSGB,0)),"^",5)
 . S PTHRN=0 S PTHRN=$$FNDHLA^BADEALR1(MSGB)
 . D FINDNT^BADEALR1(PATDFN,EDT,VSD,PTHRN)   ;does it exist in the TIU Document file
 . I EDQ=1  D   ;Dental note exists
 . . W !,"The Dental Note is already present in EHR and cannot be re-processed"
 . . W !," and will be removed from the alert list"
 . . D REMOVE(CLASS,VSD,MSGB)  ;remove current alert
 . Q:EDQ=1
 . S HLMSGIEN=MSGB
 . D REMOVE(CLASS,VSD,MSGB)
 . D PROC^BADEHL5  ;process the message
 . D FINDNT^BADEALR1(PATDFN,EDT,VSD,PTHRN)  ;was it was processed, could have signer issues
 . I EDQ=1  D    ;processed
 . . D REMOVE(CLASS,VSD,MSGB)
 . . W !!,"Dental note has been re-processed, HLB Message #:  ",MSGB,!
 . I EDQ'=1  D   ;message was not processed
 . . W !,"Unable to process HLB Message #:  ",MSGB
 . . W !,"For Patient HRN# ",PTHRN,?30,"Visit Date:  ",VSD
 . . W !,"Use the PRINT OPTION to view the alert",!
 Q
 ;
REMOVE(NM,VDT,MB) ;  Delete entry & update totals(NM=class;VDT=visit date;MB=HLB entry)
 S INF="" S INF=$G(^XTMP("BADEMDM","VISDT",VDT,NM,MB,0)) Q:'INF
 K ^XTMP("BADEMDM","VISDT",VDT,NM,MB,0)
 S TL=0 S TL=$G(^XTMP("BADEMDM","ALERT","TOTAL",0))
 I TL S ^XTMP("BADEMDM","ALERT","TOTAL",0)=TL-1
 S TL=0 S TL=$G(^XTMP("BADEMDM","ALERT","TOTAL","CLASS",NM,0))
 I TL S ^XTMP("BADEMDM","ALERT","TOTAL","CLASS",NM,0)=TL-1
 Q
 ; 
CHKNAM  ;Select and find the Name (New Person file)
 S EDRPROV="",(EDRQ,EDRPRVP,ENDIT)=0
 W !,"Select a name from the list above (question marks ""??"" = name is NOT in RPMS)",!
 S DIC("A")="Enter the name: ",DIC="^VA(200,",DIC(0)="AEQM" D ^DIC K DIC,DA S:$D(DUOUT) DIRUT=1
 I +Y<1!$D(DIRUT) S EDRQ=1 W !!,"Name cannot be found in RPMS, cannot re-process any dental note(s)",! Q
 S EDRPROV=+Y,EDRPRVP=$P(Y,U,2)       ;EDRPROV =  IEN
 S EDRPRVP=$P(^VA(200,EDRPROV,0),U,1) ;EDRPRVP =  NAME
 W !,"Name found in RPMS:  ",EDRPRVP,!
 K DA,Y,ANS2 S ANS2=$$DIR^XBDIR("Y","Is this the correct name (Y/N)?","N","","","",1)
 I ANS2'=1 S EDRQ=1 W !,"Stopping the reprocess option",! Q
 I ANS2=1 W !,"This name will be used for the dental note reprocessing" S USEIT=EDRPROV
 K DA,Y,ANS3 S ANS3=$$DIR^XBDIR("Y","Do you wish to continue(Y/N)?","N","","","",1)
 I ANS3'=1 S EDRQ=1
 Q
 ;
NOIEN   ;Alerts with no IEN Provider error (1)
 ; No IEN
 W ?5,"Cannot re-process Dental Notes that do not have a Provider IEN in the HL7 message"
 W ?5,"Review the HL7 message and contact IHS IT Support if you need assistance",!
 W ?5,"HLB Message IEN#:  ",MES
 Q
 ;
FINDNT(PAT,EDAT,VS,PHRN)  ;Check for the note in the TIU document file
 ;If found,remove from the temp global
 ; ck "AC" patient x-ref, ck event date/time (TXA.6 field in the MDM-T04 message), is it the same EDR Doc Type
 ; returns G=1 if a note exists
 S (G,EVDT)=0
 Q:'$G(EDAT)
 S EV=$$FMDATE^HLFNC(EDAT)  ;change to Fileman format  (20250418145919 to 3250418.145919)
 S N=0 F  S N=$O(^AUPNVNOT("AC",PAT,N)) Q:N'=+N  D   ;search by "AC" patient x-ref
  . Q:G=1
  . Q:'$D(^AUPNVNOT(N,0))
  . S EVDT=$P($G(^AUPNVNOT(N,12)),"^")
  . Q:$P(^AUPNVNOT(N,0),U,4)                         ;quit if retracted
  . I EV=EVDT  D                                     ;check the event date/time (TXA.6 field)
  . . S Z=$$VAL^XBDIQ1(9000010.28,N,.01)             ;check for the EDR Doc Type
  . . I Z="BADE EDR DEFAULT DENTAL NOTE" S G=1 Q
 I G=1  D
 . S EDQ=1 W !!,"The dental note is in the TIU Document (EHR) file",!,"PATIENT HRN:        Visit Date ",!
 . S Y=VS D DD^%DT  ;change date format
 . W PHRN,?20,Y
 Q
 ;
PURGE  ; Purge/clean out alerts and update the totals
 S (NOFDN,CLS)=0
 I '$D(^XTMP("BADEMDM","VISDT")) S NOFDN=1  D
 . I '$D(ZTQUEUED) W !!,"** There are no dental note alerts that need to be Purged **"
 . D CALCTOT  ;check & reset alert totals
 . D PAUSE^BADEUTIL
 Q:NOFDN=1
 D CKPRG
 I SUM=0&('$D(ZTQUEUED)) D
 . W !!,"There are no dental note alerts that need to be purged",!
 . D PAUSE^BADEUTIL Q
 I '$D(ZTQUEUED) D
 . W "Total dental note alerts to be purged: ",SUM
 . K DA,Y,ANS2 S ANS2=$$DIR^XBDIR("Y","Do you wish to continue (Y/N)?","N","","","",1)
 . I ANS2'=1 W !,"Stopping the purge... ",! K ^XTMP("BADEMDM","PURGE") Q
 D PRG
 I '$D(ZTQUEUED) W !,"Dental note alerts have been purged, TOTAL: ",SUM2
 D CALCTOT ;check the totals and correct if needed
 Q
 ; Check the purge date
CKPRG  ;DTE=Date; AT=Class; MESG=HLB entry
 S (DTE,AT,MESG,SUM,PGDT)=0
 F  S DTE=$O(^XTMP("BADEMDM","VISDT",DTE)) Q:'DTE  D
 . F  S AT=$O(^XTMP("BADEMDM","VISDT",DTE,AT)) Q:'AT  D
 . . F  S MESG=$O(^XTMP("BADEMDM","VISDT",DTE,AT,MESG)) Q:'MESG  D
 . . . S PGDT=$P($G(^XTMP("BADEMDM","VISDT",DTE,AT,MESG,0)),"^",1)
 . . . I DT>PGDT!(DT=PGDT)  D
 . . . . S ^XTMP("BADEMDM","PURGE",DTE,AT,MESG,0)=""
 . . . . S SUM=SUM+1
 . . . . I '$D(ZTQUEUED) W !,"Total : ",SUM,?15,MESG
 Q
PRG  ;  Purge the alerts
 S (DTE,AT,MESG,SUM2,PGDT)=0
 F  S DTE=$O(^XTMP("BADEMDM","PURGE",DTE)) Q:'DTE  D
 . F  S AT=$O(^XTMP("BADEMDM","PURGE",DTE,AT)) Q:'AT  D
 . . F  S MESG=$O(^XTMP("BADEMDM","PURGE",DTE,AT,MESG)) Q:'MESG  D
 . . . D REMOVE(AT,DTE,MESG)
 . . . K ^XTMP("BADEMDM","PURGE",DTE,AT,MESG)
 . . . S SUM2=SUM2+1
 Q
PURGALL  ; Purge all alerts - not a scheduled task
 S (NOFDN,CLS)=0
 W !,"This option deletes/purges ALL dental note alerts",!
 I '$D(^XTMP("BADEMDM","VISDT")) W !!,"** There are no failed Dental Notes to Purge **" Q
 K DA,Y,ANS2 S ANS2=$$DIR^XBDIR("Y","Do you wish to continue (Y/N)?","N","","","",1)
 I ANS2'=1 W !,"Stopping the purge... ",! Q
 K DA,Y,ANS2 S ANS2=$$DIR^XBDIR("Y","Are you sure.. this removes ALL Dental Note Alerts (Y/N)?","N","","","",1)
 I ANS2'=1 W !,"Stopping the purge... ",! Q
 K ^XTMP("BADEMDM","VISDT")
 S ^XTMP("BADEMDM","ALERT","TOTAL",0)=0
 F  S CLS=$O(^XTMP("BADEMDM","ALERT","TOTAL","CLASS",CLS)) Q:CLS=""  D
 . S ^XTMP("BADEMDM","ALERT","TOTAL","CLASS",CLS,0)=0  ; set to 0
 W !,"All dental note alerts have been purged!!",!
 D CALCTOT
 Q
CALCTOT  ;Check/re-calculate totals
 S (ALL,ALL2,DTE,AT,MESG,TL,MATCH,X)=0
 K SM
 I '$D(^XTMP("BADEMDM","ALERT","TOTAL",0)) S ^XTMP("BADEMDM","ALERT","TOTAL",0)=""
 F  S DTE=$O(^XTMP("BADEMDM","VISDT",DTE)) Q:'DTE  D
 . F  S AT=$O(^XTMP("BADEMDM","VISDT",DTE,AT)) Q:'AT  D
 . . F  S MESG=$O(^XTMP("BADEMDM","VISDT",DTE,AT,MESG)) Q:'MESG  D
 . . . S ALL=ALL+1
 . . . I $G(SM(AT)) S SM(AT)=SM(AT)+1
 . . . E  S SM(AT)=1
 F  S X=$O(^XTMP("BADEMDM","ALERT","TOTAL","CLASS",X)) Q:X=""  D
 . K ^XTMP("BADEMDM","ALERT","TOTAL","CLASS",X,0)
 . F  S TL=$O(SM(TL)) Q:TL=""  D
 . . S ^XTMP("BADEMDM","ALERT","TOTAL","CLASS",TL,0)=SM(TL)
 S ALL2=^XTMP("BADEMDM","ALERT","TOTAL",0) I ALL2'=ALL S ^XTMP("BADEMDM","ALERT","TOTAL",0)=ALL
 Q
FNDHLA(HL) ; From the HLB IEN, find the Data in HLA message
 S (PINFO,PHRN)=0
 S MSGA="" S MSGA=$P($G(^HLB(HL,0)),"^",2)
 S PINFO=$P($G(^HLA(MSGA,1,3,0)),"|",4)
 S PHRN=+$E(PINFO,7,12)
 Q PHRN
 ;
UPC(X) ; EP Upper case
 S X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 Q X
 ;
CLEAN ;
 K EDRBD,EDRED,EDRSD,X,Y,DA,EDRQ,BADEQ,ANS,TOT,DATE,ALT,MES,CLS
 K AT,DTE,MESG,TL,SM
 K ^XTMP("BADEMDM","REPROC")
 K ^XTMP("BADEMDM","PROC")
 K ^XTMP("BADEMDM","PURGE")
 Q
