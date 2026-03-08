BADEALRT ;IHS/GDIT/GAB - Dentrix HL7 Interface  ;08/15/2025
 ;;1.0;DENTAL/EDR INTERFACE;**10**;FEB 22, 2010;Build 61
 ;;Adds and retrieves dental note alerts in the ^XTMP("BADEMDM") global 
 ;;For provider,author or signer processing problems
 ;;Prints and selects failed Dental Notes based on date range and type
 ;;ERRCLS is the list of alerts
 ;;Called from BADEHL5 (ADDALRT)
 Q
ADD(MSIEN,ERR,PDFN,VDAT,VPRO,VNAM,VIEN,ATYP,TXA6) ;EP  Adds data to the ^XTMP("BADEMDM") global for dental note alerts
 ;      MSIEN = ^HLB message IEN
 ;        ERR = Alert Message
 ;       PDFN = Patient DFN (IEN)
 ;       VDAT = Visit Date (example: 20250603)
 ;       VPRO = Provider IEN
 ;       VNAM = Author/Signer Name (HL7NAM=Demo,John)
 ;       VIEN = Author/Signer IEN
 ; ATYP/CLASS = Alert/Class (from the Alert message - see ERRCLS list below)
 ;       TXA6 = Dental Note Entry Date/Time
 ;   
 ;  VPRO,VNAM,or VIEN is set to 0 if no data
 ;  S ^XTMP("BADEMDM","VISDT",VSDT,CLASS,MSIEN,0)=""_PURGDT_"^"_PDFN_"^"_VPRO_"^"_VNAM_"^"_VIEN_"^"""
 ;
 K PURGDT,TDAY,X,X1,X2
 S (VD,CLASS,TOTAL,TOTAL2)=0
 I VDAT>8 S VD=$E(VDAT,1,8)
 S VD=$$FMDATE^HLFNC(VD)   ;example VD=3250603
 S X1=VD,X2=180 ; GAB - add a PURGE DATE; currently uses T+180 (6 months); add a parameter/option?
 D C^%DTC
 S PURGDT=X
 S CLASS=$$RETNUM(ERR)
 I $G(CLASS) D SET
 Q
 ;
RETNUM(ERR)  ;Returns error# from the list
 S (LINE,ET)=""
 S (STP,TYP)=0
 F I=1:1 S LINE=$T(ERRCLS+I) Q:LINE=" Q"!STP=1  D
 . Q:STP=1
 . S ET=$P(LINE,";;",3)
 . I ERR[ET  D
 . . S STP=1
 . . S TYP=$P(LINE,";;",2)  ;set the number
 Q TYP
 ;
RETCLAS(CLAS)  ;Returns the class from the error#
 S (LINE,ET)=""
 S (STP,CL)=0
 F I=1:1 S LINE=$T(ERRCLS+I) Q:LINE=" Q"!STP=1  D
 . Q:STP=1
 . S ET=$P(LINE,";;",2)
 . I ET=CLAS  D
 . . S STP=1
 . . S CL=$P(LINE,";;",3)  ;set the class
 Q CL
 ;
SET  ;Set ^XTMP("BADEMDM")
 S VSDT=VDAT,STP=0
 I VSDT>8 S VSDT=$E(VSDT,1,8),VSDT=$$FMDATE^HLFNC(VSDT) ;change to fileman date format
 I '$G(VSDT) Q
 S ^XTMP("BADEMDM",0)=PURGDT_"^"_DT_"^"_"BADE Failed Dental Notes Queue"  ;update the 0 node purge date
 S ^XTMP("BADEMDM","VISDT",VSDT,CLASS,MSIEN,0)=""_PURGDT_"^"_PDFN_"^"_VPRO_"^"_VNAM_"^"_VIEN_"^"
 I $G(TXA6) S $P(^XTMP("BADEMDM","VISDT",VSDT,CLASS,MSIEN,0),"^",8)=TXA6
 S TOTAL=$G(^XTMP("BADEMDM","ALERT","TOTAL","CLASS",CLASS,0))   ;total for the class
 S TOTAL=TOTAL+1
 S ^XTMP("BADEMDM","ALERT","TOTAL","CLASS",CLASS,0)=TOTAL  ;Total based on alert classification
 ;S ^XTMP("BADEMDM","ALERT","CLASS",CLASS,0)=MSIEN
 ; Total number of Alerts
 S TOTAL2=$G(^XTMP("BADEMDM","ALERT","TOTAL",0))
 S TOTAL2=TOTAL2+1
 S ^XTMP("BADEMDM","ALERT","TOTAL",0)=TOTAL2   ;Total of all Alerts
 Q
 ;
RETRIEVE  ;EP from Option - retrieve alerts from temp global
 S BADEQ=0
 I '$D(^XTMP("BADEMDM","VISDT")) W !!,"** There are no failed dental notes that can be re-processed **",!! S BADEQ=1 Q
 D PRINT^BADEALRT   ;print alert totals
 W !!,"These alerts are related to the Provider or Author/Signer of the Dental Note"
BYDAT   ;Find and print alert types by Date Range (not to exceed 6 months)
 K EDRBD,EDRED,EDRSD,X,X1,X2,TFAR
BD   ;get start date
 W !!,"Select a date range (up to 180 days)",!
 W ! S DIR(0)="D^:"_DT_":EP",DIR("A")="Enter beginning Visit Date " D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) D END S BADEQ=1 Q
 S EDRBD=Y
ED   ;get ending date
 W ! S DIR(0)="D^"_EDRBD_":"_DT_":EP",DIR("A")="Enter ending Visit Date"  D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S EDRED=Y
 S X1=EDRBD,X2=-1 D C^%DTC S EDRSBD=X  ;EDRSBD=day before begin date for the search example: 3250218 (no time stamp)
 S X1=EDRED,X2=+1 D C^%DTC S EDRSED=X  ;EDRSED=day before end date for the search
 S X1=EDRBD,X2=180 D C^%DTC S TFAR=X    ;Only check for past 6 months/180 days
 I EDRED>TFAR W !,"The date range is greater than 180 days, please try again!!!" G BYDAT
 W !
 Q
 ;
PRINT  ;Print totals for all Alert types
 D CALCTOT^BADEALR1  ; ensure totals are correct
 I '$D(^XTMP("BADEMDM","VISDT")) W !!,"** There are no failed dental notes **",!! S BADEQ=1 Q
 S (CLS,STP)=0,(TOTCL,TOT)=""
 W !!,"Alert Type",?62,"TOTAL",!
 W "--------------------------------------------------------------------",!
 F  S CLS=$O(^XTMP("BADEMDM","ALERT","TOTAL","CLASS",CLS)) Q:CLS=""  D
 . S TOTCL=^XTMP("BADEMDM","ALERT","TOTAL","CLASS",CLS,0)
 . S (TLINE,AT)=""
 . S (STP,TYP)=0
 . F P=1:1 S TLINE=$T(ERRCLS+P) Q:TLINE=" Q"!STP=1  D
 . . Q:STP=1
 . . S AT=$P(TLINE,";;",2)
 . . I CLS=AT  D
 . . . S STP=1
 . . . S CHOP=$P(TLINE,";;",3),CHOP=$E(CHOP,1,60)
 . . . W !,CHOP
 . . . W ?63,TOTCL
 S ALL=0,ALL=^XTMP("BADEMDM","ALERT","TOTAL",0)
 W !!,"TOTAL of ALL Dental Note Alerts",?63,ALL
 W !!
 D PAUSE^BADEUTIL
 Q
 ;
PRT  ;Print the visit dates & alert types from ^XTMP("BADEMDM","VISDT")
 Q:$G(BADEQ)
 S ALRT1=1,DATE=1
 S (ALT,MES,TOT,STOT,MATCH,FULALT,DATA)=0
 S FUNC=""
 W !,"VISIT DATE",?12,"ALERT",?58,"Info on Issue",!
 W "--------------------------------------------------------------------------",!!
 F  S DATE=$O(^XTMP("BADEMDM","VISDT",DATE)) Q:'DATE  D
 . I DATE>EDRSBD&(DATE<EDRSED)  D
 . . S Y=DATE X ^DD("DD")
 . . F  S ALT=$O(^XTMP("BADEMDM","VISDT",DATE,ALT)) Q:'ALT  D
 . . .F  S MES=$O(^XTMP("BADEMDM","VISDT",DATE,ALT,MES)) Q:'MES  D
 . . . .S TOT=TOT+1
 . . . .S FULALT=$$RETCLAS^BADEALRT(ALT)
 . . . .W Y,?12,$E(FULALT,1,42)
 . . . .S DATA=0,DATA=^XTMP("BADEMDM","VISDT",DATE,ALT,MES,0)
 . . . .I DATA  D
 . . . . .S FUNC=$S(ALT=1!(ALT=5)!(ALT=6):"NOIEN",(ALT<5):"BYPROV",(ALT=7)!(ALT=8):"BYAUS1",ALT>8:"BYAUS2",1:"")
 . . . . .I FUNC'="" S MATCH=1 D @FUNC
 I MATCH=0 W !,"** There are no alerts that match this date range **",!! S BADEQ=1 Q
 W !!,"-------------------------END OF LIST-------------------------------------",!!
 W !!,"TOTAL number of alerts by date range:   ",TOT
 D PAUSE^BADEUTIL
 Q
 ;
PRT2(SEL) ;Prints the alerts by date range & type, save to ^XTMP("BADEMDM","REPROC",ALT,MES) for reprocessing
 ; ^XTMP("BADEMDM","REPROC",ALT,MES)="3250603^13^29^DEMO,JONATHON^0^^^20250603211235"
 ;                                  VisDT^PatDFN^PROVIEN^VNAM^VIEN^^^TXA6  (VNAM: auth/sign name; TXA6: entry date/time)
 ; SEL=1 Author/Signer alerts; SEL=2 Provider alerts
 Q:$G(BADEQ)
 S ALRT1=1,DATE=1
 S (ALT,MES,TOT,STOT,MATCH,FULALT,DATA)=0
 S FUNC=""
 W !,"VISIT DT",?12,"TYPE",?56,"NAME,IEN or MSG#"
 W !,"-------------------------------------------------------------------------",!
 F  S DATE=$O(^XTMP("BADEMDM","VISDT",DATE)) Q:'DATE  D
 . I DATE>EDRSBD&(DATE<EDRSED)  D
 . . F  S ALT=$O(^XTMP("BADEMDM","VISDT",DATE,ALT)) Q:'ALT  D
 . . . F  S MES=$O(^XTMP("BADEMDM","VISDT",DATE,ALT,MES)) Q:'MES  D
 . . . . S DATA=^XTMP("BADEMDM","VISDT",DATE,ALT,MES,0)
 . . . . I DATA  D
 . . . . . S FUNC=""
 . . . . . I SEL=2&(ALT<5) D
 . . . . . . S FUNC=$S(ALT=1:"NOIEN",ALT<5:"BYPROV",1:"")
 . . . . . I SEL=1&(ALT>4) D
 . . . . . . S FUNC=$S(ALT=1!(ALT=5)!(ALT=6):"NOIEN",ALT<5:"BYPROV",(ALT=7)!(ALT=8):"BYAUS1",ALT>8:"BYAUS2",1:"")
 . . . . . I FUNC'="" S MATCH=1 D ADDIT
 ;
 I MATCH=0 W !,"** There are no alerts that match this date range **",! S BADEQ=1 Q
 W !!,"-----------------------------END OF LIST---------------------------------",!
 D PAUSE^BADEUTIL
 I TOT=0  W !,"** There are no alerts that can be re-processed **",!
 W !!,"Alerts that show the MSG# (Message number), CANNOT BE PROCESSED DUE TO:"
 W !,"No Provider (IEN) Number or Author/Signer name was transmitted"
 W !,"You can review the HLB entry or contact IHS IT Support for assistance",!
 Q:TOT=0
 W !,"TOTAL number of alerts by date range that can be re-processed :   ",TOT
 W !!,"Correct any issues before re-processing or the note(s) will not process",!
 W !,"Make sure the RPMS user:"
 W !,"(1) has a Title starting with Dent"
 W !,"(2) has Electronic signature fields: Code, Block Title & Printed Name"
 W !,"(3) is not Terminated or Inactivated",!
 W !,"If you get another alert, use the Print (PRT) option"
 D PAUSE^BADEUTIL
 Q
 ;
ADDIT  ;Prints and Adds selected message data to the temp global for re-processing
 ;
 S FULALT=$$RETCLAS^BADEALRT(ALT)
 S Y=DATE X ^DD("DD")
 W Y,?12,$E(FULALT,1,44)
 D @FUNC
 Q:ALT=1!(ALT=5)!(ALT=6)
 S TOT=TOT+1
 S ^XTMP("BADEMDM","REPROC",ALT,MES,0)=DATA
 S $P(^XTMP("BADEMDM","REPROC",ALT,MES,0),"^",1)=DATE
 Q
 ;
NOIEN   ;Alerts with no IEN (1,5,6):  MESSAGES THAT CANNOT BE RE-PROCESSED
 ;(1) Provider IEN not in HL7 message (TXA.5 IEN required) or (5) Missing Auth/Signer Name in message 
 ;OR (8) IEN transmitted but not found in RPMS (not a common issue)
 W ?57,"HLB Msg#:",MES,!
 Q
 ;
BYPROV  ;Alerts by Provider error (2-4); IEN=Piece 3 in ^XTMP("BADEMDM" global: CAN BE RE-PROCESSED
 ;Prov IEN in HL7 message, but has an issue (Title,Electronic Sig code, etc.)
 D FINDNM(3)
 Q
 ;
BYAUS1 ;Alerts by Author/Signer (7-8); Name present in ^XTMP("BADEMDM", RE-PROCESS After Entry added in RPMS
 ;Author/Signer name cannot be found in RPMS
 W ?57,$P($G(DATA),"^",4),!
 Q
 ;
BYAUS2 ;Alerts by Author/Signer (9-16); IEN present in RPMS: CAN BE RE-PROCESSED
 ;Author/Signer name and RPMS IEN present, other issues (Title,Term/inact date,signature fields)
 D FNDIEN
 Q
 ;
FINDNM(P) ;From the IEN, find the name
 S (NIE,NME)=""
 S NIE=$P($G(DATA),"^",P)
 I NIE'=""  D
 . S NME=$P($G(^VA(200,NIE,0)),"^")
 . I $D(NME) W ?57,NME,!
 I '$D(NME) W ?57,NIE," No Name:",! W "IEN#:",NME
 Q
FNDIEN  ;From the Name, make sure the IEN exists
 S (NIE,NME)=""
 S NME=$P($G(DATA),"^",4)
 I NME'=""  D
 . S NME=$$UPC^BADEALR1(NME)
 . S NIE=$$FIND1^DIC(200,"","BX",NME,"","","ER")
 . W ?57,NME,!
 Q
END ;
 K EDRBD,EDRED,EDRSD,X,DD0,BD,ANS,ANS2,ANS3,EDRQ
 K MSIEN,ERR,PDFN,VDAT,VPRO,VNAM,VIEN,ATYP
 K NIE,NME,DATA,MES,FULALT,TOT
 D CLEAN^BADEALR1
 Q
 ;Error Class 1,5,6 below cannot be re-processed
ERRCLS ;list of errors (Prov,Auth,Signer)
 ;;1;;Provider IEN# is missing in the note;;1^
 ;;2;;Provider NAME is not present in RPMS;;1^IEN^
 ;;3;;Provider TITLE was not found in RPMS;;1^IEN^NM
 ;;4;;Provider TITLE is not a DENTIST;;1^IEN^NM
 ;;5;;Missing Author/Signer first or lastname;;^^
 ;;6;;Author/Signer IEN is not in RPMS;;^IEN^NM
 ;;7;;Author/Signer name cannot be found in RPMS;;^^NM
 ;;8;;Dental note author/signer is not setup in RPMS;;^^NM
 ;;9;;Author/Signer does not have a last name in RPMS;;^IEN^NM
 ;;10;;Author/Signer TITLE not a Dentist, Dental Hygienist/Assistant;;^IEN^NM
 ;;11;;Author/Signer TITLE is missing;;^IEN^NM
 ;;12;;Author/Signer has a termination date in RPMS;;^IEN^NM
 ;;13;;Author/Signer is inactive in RPMS;;^IEN^NM
 ;;14;;Author/Signer needs an Electronic Signature Code,IEN#;;^IEN^NM
 ;;15;;Author/Signer needs a Signature Block Title;;^IEN^NM
 ;;16;;Author/Signer needs a Signature Block Printed Name;;^IEN^NM
 Q
