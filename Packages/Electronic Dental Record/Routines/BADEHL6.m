BADEHL6 ;IHS/OIT/GAB - Dentrix HL7 inbound interface  ;08/15/2020
 ;;1.0;DENTAL/EDR INTERFACE;**7,8,10**;FEB 22, 2010;Build 61
 ;;/IHS/OIT/GAB PATCH 8 - Dental Note update
 ;;/IHS/GDIT/GAB PATCH 10 - Add Alert types (Provider, Author and Signer) to re-process dental notes; updated alerts
 ;;Process Inbound T04 Segments to create TIU Notes in RPMS
 ; Written in conjunction with BADEHL5 for Processing Inbound Dentrix MDM-T04 Message Types
 ;
 ; NTITLE:  Added in Parameter File 
 ;
PID ; EP: Process PID Segment, called from BADEHL5, stored in SEGPID
 S SEGIEN=$$FSEGIEN(.DATA,"PID")
 I 'SEGIEN S BADERR="Missing PID Segment in the Dental Note Message" Q
 M SEGPID=DATA(SEGIEN)
 S DFN=$$GET^HLOPRS(.SEGPID,2)
 I DFN="" S BADERR="Missing DFN/Patient IEN in the Dental Note Message Segment" Q
 ; Get the ASUFAC number
 N ASUFAC,HRCN,FAC
 S X=$$GET^HLOPRS(.SEGPID,3)     ;get the ASUFAC+HRN 
 S X1=$$GET^HLOPRS(.SEGPID,4)    ;get other HRN's for other divisions
 I X="" S BADERR="Missing ASUFAC in PID segment" Q
 S ASUFAC=$E(X,1,6)
 S IEN=$$HRCNF^BADEUTIL(X)
 I IEN="" S BADERR="Missing HRCN in PID segment in the Dental Note" Q
 ; Check if patient has been merged
 S DFN=$$MRGTODFN^BADEUTIL(DFN)
 I '$D(^DPT(DFN)) S BADERR="Patient IEN: "_DFN_" in the Dental Note message not in RPMS" Q
 S (APCDPAT,BADIN("PAT"))=DFN
 ;check last name
 S HLNAME=$$GET^HLOPRS(.SEGPID,5,1) I '$D(HLNAME) S BADERR="Patient last name for IEN: "_DFN_" is not present in the Dental Note" Q
 S NAME=$$GET1^DIQ(2,DFN,.01) I '$D(NAME) S BADERR="Patient IEN: "_DFN_" in the Dental Note is not present in RPMS" Q
 S LNAME=$P(NAME,",",1) I '$D(LNAME) S BADERR="Patient IEN: "_DFN_" in the Dental Note is not present in RPMS" Q
 I LNAME'=HLNAME S BADERR=" Last name for patient IEN: "_DFN_" does not match RPMS patient in the Dental Note" Q
 Q
PV1 ; EP: Process Patient Visit Info (PV1 segment), stored in SEGPV1
 S SEGIEN=$$FSEGIEN(.DATA,"PV1")
 I 'SEGIEN S BADERR="Missing PV1 Segment in the Dental Note" Q
 E  M SEGPV1=DATA(SEGIEN)
 Q
 ;
TXA ; EP: Process TXA SEGMENT, store in SEGTXA
 S SEGIEN=$$FSEGIEN(.DATA,"TXA")
 I 'SEGIEN S BADERR="Missing TXA Segment information in the Dental Note" Q
 E  M SEGTXA=DATA(SEGIEN)
 D CKTXA   ;check for a finalized note
 Q
 ;
CKTXA ;Check for valid TXA segment17; "LA" = a completed note
 S STYPE=""
 S STYPE=$$GET^HLOPRS(.SEGTXA,17)    ;GET MSG SEG 17
 I STYPE="" S BADERR="No STATUS in TXA Segment of the Dental Note" Q
 I STYPE'="LA" S BADERR="Dental Note Message does not contain LA IN TXA-17 SEGMENT" Q
 Q
 ;
OBX ; EP: Process OBX SEGMENT, store in local array TIUX(contains the notes)
 S FIRST=$$FSEGIEN(.DATA,"OBX")
 I 'FIRST S BADERR="Missing OBX Segment information" Q
 S (OBXCNT,SEGCNT,NOTEXT,SCOUNT)=0
 S COUNT=1
 K OBXTXT
 S TEST=""
 N I,J,K,L S (I,J,K,L)=0
 S SEGIEN=FIRST-1     ;start at First Line of OBX Segment, loop thru & move all OBX lines to SEGOBX
 F  S SEGIEN=$O(DATA(SEGIEN)) Q:SEGIEN=""  D
 .Q:'SEGIEN
 .Q:SEGIEN="HDR"
 .M SEGOBX(SEGIEN)=DATA(SEGIEN)
 .S OBXCNT=OBXCNT+1
 ;Loop thru SEGOBX array & remove all invalid lines but text data; 
 ;1st line created with dashes for TIU Note creation
 S OBXTXT("TEXT",1,0)="------------------------------------------------------------------------------"
 S SEGIEN=FIRST-1
 F  S SEGIEN=$O(SEGOBX(SEGIEN)) Q:SEGIEN=""  D
 .S COUNT=COUNT+1
 .F  S I=$O(SEGOBX(SEGIEN,I)) Q:I=""  D
 ..F  S J=$O(SEGOBX(SEGIEN,I,J)) Q:J=""  D
 ...F  S K=$O(SEGOBX(SEGIEN,I,J,K)) Q:K=""  D
 ....F  S L=$O(SEGOBX(SEGIEN,I,J,K,L)) Q:L=""  D
 .....S NOTEXT=0       ;if NOTEXT=1, do not process
 .....S TEST=$P($G(SEGOBX(SEGIEN,I,J,K,L)),U,1)
 .....I TEST="TX"!(TEST="CN")!(TEST="OBX") S NOTEXT=1
 .....I TEST=COUNT S NOTEXT=1
 .....S SCOUNT=SCOUNT+1
 .....;I NOTEXT=0&&(I="6")&&(SCOUNT>0) M OBXTXT("TEXT",COUNT,0)=SEGOBX(SEGIEN,I,J,K,L)
 .....;/IHS/GDIT/GAB **10** comment above and added below to correct XINDEX results
 .....I (NOTEXT=0)&(I="6")&(SCOUNT>0) M OBXTXT("TEXT",COUNT,0)=SEGOBX(SEGIEN,I,J,K,L)
 M TIUX=OBXTXT
 K OBXTXT,SEGOBX ;/IHS/OIT/GAB PATCH 8 Added OBXTXT
 Q
 ;
TITLE  ;EP called from BADEHL5
 ; Process TIU note information in the TXA segment
 ;Note: Doctype is set from the incoming message by Dentrix
 S (PNTITLE,NTITLE,Y,SIGNIEN,SIGIEN,LNM,FNM,MID)=""
 S ALRTYP=0  ;/IHS/GDIT/GAB **10** Added for the alert type
 S (I,DTOK)=0
 S DOCTYPE=$$GET^HLOPRS(.SEGTXA,2)
 I DOCTYPE="" S BADERR="No DOC type in HL7 message" Q
 I DOCTYPE'="CN" S BADERR="Incorrect DOC type in OBX Segment" Q
 S NTITLE=$$GET^XPAR("ALL","BADE EDR DEFAULT DENTAL NOTE")   ;note title IEN in PARAMETER DEFINITION file
 I NTITLE="" S BADERR="No Default Dental Note Title for EDR in RPMS" Q
 S J=0 F  S J=$O(^TIU(8925.1,"B",J)) Q:J=""  D
 .F  S I=$O(^TIU(8925.1,"B",J,I)) Q:I=""  D
 ..;I I=NTITLE&&($D(^TIU(8925.1,"AT","DOC",I))) S Y=I_U_J Q
 ..;IHS/GDIT/GAB **10** comment above and added below to correct XINDEX results
 ..I (I=NTITLE)&($D(^TIU(8925.1,"AT","DOC",I))) S Y=I_U_J Q
 S PNTITLE=Y    ;IEN of Note Title in RPMS^Name of TIU NOTE Title (IEN^NOTETITLE)
 I PNTITLE="" S BADERR="No Dental Note Title for EDR in RPMS" Q
 S TXARES(1)=NTITLE  ;IEN of Note Title in RPMS
 ;Author of Note in TXA(9) segment
 ;Who authored the note in Dentrix; can be a dentist, dental assistant or hygienist
 S (AUTHLNM,AUTHFNM,AUTHMID,AUTHIEN,PROVID,LOCATE,LOCATION)=""
 S AUTHIEN=$$GET^HLOPRS(.SEGTXA,9,1)      ;author IEN    (dentists who are already setup in RPMS)
 S AUTHLNM=$$GET^HLOPRS(.SEGTXA,9,2)      ;author last name 
 S AUTHFNM=$$GET^HLOPRS(.SEGTXA,9,3)      ;author first name
 S AUTHMID=$$GET^HLOPRS(.SEGTXA,9,4)      ;author middle initial
 D CKSIGNER(AUTHLNM,AUTHFNM,AUTHMID,AUTHIEN)
 I $L(BADERR) S ALRTYP=2  ;/IHS/GDIT/GAB **10** Set alert type for reprocessing
 Q:$L(BADERR)
 I $G(SIGNID)="" S BADERR="Dental note author/signer is not setup in RPMS",ALRTYP=2 Q
 ;/IHS/GDIT/GAB **10** Added above line, comment the below line, add alert type
 ;I $G(SIGNID)="" S BADERR="Author of the dental note is not valid in RPMS" Q
 S PROVID=SIGNID
 S TXARES(2)=PROVID,DUZ(0)=$P(^VA(200,1,0),U,4)  ;set DUZ(0) to IEN=1 (Adam,Adam)
 ;Visit Location
 S LOCATION=$$GET^HLOPRS(.SEGPV1,3,1) ;get the location from PV1 segment
 I $G(LOCATION)="" S BADERR="Location not found in the PV1 Segment of the Dental Note Message" Q
 S LOCATE=$O(^AUTTLOC("C",LOCATION,""))
 I LOCATE="" S BADERR="ASUFAC:  "_LOCATION_" cannot be found in RPMS to create the dental note" Q
 S DUZ(2)=LOCATE    ;set DUZ(2) = the incoming location from HL7 PV1 segment
 ;Episode Date/Time (Activity Date/Time) from TXA4
 S ACTDT=""
 S ACTDT=$$GET^HLOPRS(.SEGTXA,4,1) I ACTDT="" S BADERR="No Activity Date/time in the Dental Note Message" Q
 S ACTDT=$$DATECK^BADEHL7(ACTDT)
 S ACTDT=$$HL7TFM^XLFDT(ACTDT)
 S TXARES(3)=ACTDT   ;Activity Date/Time=Date/Time Signed
 ;Entry Date/Time (Origination Date/Time) - Date Note was Entered
 S TXARES(6)=$$GET^HLOPRS(.SEGTXA,6)
 I TXARES(6)="" S BADERR="No Entry Date/Time in the Dental Note Message" Q
 S TXARES(6)=$$HL7TFM^XLFDT(TXARES(6))
 ;Reference Date/Time (Edit Date/Time) - Date/Time last edited (in this case date finalized note signed)
 S TXARES(7)=$$GET^HLOPRS(.SEGTXA,8)
 I TXARES(7)="" S BADERR="No Edit date/time in the Dental Note Message" Q
 S TXARES(7)=$$HL7TFM^XLFDT(TXARES(7))
 ;Document Status
 I STYPE="LA" S STYPE="COMPLETED"    ;set to completed status in ^TIU(8925.6)
 S TXARES(5)=STYPE
 ;Signer of Note (TXA segment - TXA22) ;
 S (SIGNFNM,SIGNLNM,SIGNMID,SIGNIEN,LNM,FNM,MID,SIGIEN)=""
 S SIGNIEN=$$GET^HLOPRS(.SEGTXA,22,1)  ;signor IEN
 S SIGNLNM=$$GET^HLOPRS(.SEGTXA,22,2)  ;set to signers last name in the message
 S SIGNFNM=$$GET^HLOPRS(.SEGTXA,22,3)  ;set to signers first name
 S SIGNMID=$$GET^HLOPRS(.SEGTXA,22,4)  ;set to signers middle initial if present
 D CKSIGNER(SIGNLNM,SIGNFNM,SIGNMID,SIGNIEN)   ;check the signer info needed for the note creation
 I $L(BADERR) S ALRTYP=3  ;/IHS/GDIT/GAB **10** Set alert type for reprocessing
 Q:$L(BADERR)
 I $G(SIGNID)="" S BADERR="Dental note author/signer is not setup in RPMS",ALRTYP=3 Q
 ;/IHS/GDIT/GAB **10** Added above line, comment the below line, for alert type print & re-process
 ;I $G(SIGNID)="" S BADERR="Signer of the dental note is not valid in RPMS" Q
 S TXARES(8)=SIGNID
 D SIGNDT Q:$L(BADERR)
 S TIUPARNT=""
 Q
 ;
CKSIGNER(LNM,FNM,MID,SIGIEN)   ;Verify Author/Signer of the note in RPMS
 ;if IEN is present use it (Dentists), if no IEN use Dental hygienist/assistant's name as Author/Signer of the Note
 S (HL7NAM,USTITLE,SIGNID,PROLN)=""
 ;If the IEN is present (Dentist IEN exists) ck for valid information to create the note
 I $G(LNM)=""!($G(FNM)="") S BADERR="Missing Author/Signer first or lastname" Q
 S HL7NAM=LNM_","_FNM
 I $G(SIGIEN)'=""  D
 .I '$D(^VA(200,SIGIEN,0)) S BADERR="Author/Signer IEN is not in RPMS,IEN#: "_SIGIEN_"" Q
 .S PROLN=$P(^VA(200,SIGIEN,0),",",1) I $G(PROLN)="" S BADERR="Author/Signer does not have a last name in RPMS,IEN#: "_SIGIEN_"" Q
 .;/IHS/GDIT/GAB **10** added above 2 lines, commented next 3 lines for alert print & re-process
 .;I '$D(^VA(200,SIGIEN,0)) S BADERR="Author/Signer IEN "_SIGIEN_" is not valid in RPMS" Q
 .;S PROLN=$P(^VA(200,SIGIEN,0),",",1) I $G(PROLN)="" S BADERR="Author/Signer IEN: "_SIGIEN_" does not have a last name in RPMS" Q
 .;I PROLN'=LNM S BADERR="Author/Signer IEN: "_SIGIEN_" last name does not match in RPMS" Q
 .S USTITLE=$$VAL^XBDIQ1(200,SIGIEN,8)
 .I $G(USTITLE)="" S BADERR="Author/Signer TITLE is missing in RPMS,IEN#: "_SIGIEN_"" Q
 .S USTITLE=$$UP^XLFSTR(USTITLE) I USTITLE'["DENT" S BADERR="Author/Signer TITLE not a Dentist, Dental Hygienist/Assistant in RPMS,IEN#: "_SIGIEN_"" Q
 ;/IHS/GDIT/GAB **10** added above 2 lines, commented next 2 lines for alert print & re-process
 ;.I $G(USTITLE)="" S BADERR="Author/Signer TITLE with IEN#: "_SIGIEN_" was not found in RPMS" Q
 ;.I USTITLE'["DENT" S BADERR="Author/Signer with IEN: "_SIGIEN_" does not have a valid TITLE for the Dental Note" Q
 ;If the IEN is NOT present use the name transmitted as the author/signer (Dental hygienists/assistants)
 I $G(SIGIEN)=""  D
 .I $G(MID)'="" S HL7NAM=LNM_","_FNM_" "_MID
 .K Y,DIC S DIC="^VA(200,",DIC(0)="MZ",X=HL7NAM D ^DIC
 .I Y=-1 S BADERR="Author/Signer name cannot be found in RPMS" Q
 .;I Y=-1 S BADERR="Author/Signer name in Dental Note cannot be found in RPMS" Q  ;/IHS/GDIT/GAB **10** replace this line with above line
 .S SIGIEN=$P(Y,"^")
 .I $G(SIGIEN)="" S BADERR="Author/Signer name cannot be found in RPMS" Q
 .;/IHS/GDIT/GAB **10** added above line, commented below line for alert print & re-process
 .;I $G(SIGIEN)="" S BADERR="Author/Signer for the dental note in TXA segment cannot be found in RPMS" Q
 .S USTITLE=$$VAL^XBDIQ1(200,SIGIEN,8)
 .I $G(USTITLE)="" S BADERR="Author/Signer TITLE is missing in RPMS,IEN#: "_SIGIEN_"" Q
 .S USTITLE=$$UP^XLFSTR(USTITLE) I USTITLE'["DENT" S BADERR="Author/Signer TITLE not a Dentist, Dental Hygienist/Assistant in RPMS, IEN#: "_SIGIEN_"" Q
 .;/IHS/GDIT/GAB **10** added above 2 lines, commented below 2 lines for alert print & re-process
 .;I $G(USTITLE)="" S BADERR="No TITLE for Author/Signer of the dental note with IEN#: "_SIGIEN_"" Q
 .;I USTITLE'["DENT" S BADERR="Author/Signer TITLE for IEN: "_SIGIEN_" is not a Dentist, Dental Hygienist/Assistant in RPMS" Q
 Q:$L(BADERR)
CKINACT ;check for an inactive or termination date for the author/signer of the note
 I $P($G(^VA(200,SIGIEN,0)),U,11)'=""  S BADERR="Author/Signer has a termination date in RPMS,IEN#: "_SIGIEN_"" Q
 I $P($G(^VA(200,SIGIEN,"PS")),U,4)'="" S BADERR="Author/Signer is inactive in RPMS,IEN#: "_SIGIEN_"" Q
 ;/IHS/GDIT/GAB **10** Added 2 lines above and commented 2 lines below for alert type print & re-process
 ;I $P($G(^VA(200,SIGIEN,0)),U,11)'=""  S BADERR="Author or Signer IEN: "_SIGIEN_" has a termination date in RPMS" Q
 ;I $P($G(^VA(200,SIGIEN,"PS")),U,4)'="" S BADERR="Author or Signer IEN: "_SIGIEN_" is inactive in RPMS" Q
CKESIG ;check the electronic signature and initials needed for the TIU NOTE
 S (BTITLE,BNAME)=""
 I $P($G(^VA(200,SIGIEN,20)),"^",4)="" S BADERR="Author/Signer needs an Electronic Signature Code,IEN#: "_SIGIEN_"" Q
 S BTITLE=$P($G(^VA(200,SIGIEN,20)),"^",3) I BTITLE="" S BADERR="Author/Signer needs a Signature Block Title,IEN#: "_SIGIEN_"" Q
 S BNAME=$P($G(^VA(200,SIGIEN,20)),"^",2) I BNAME="" S BADERR="Author/Signer needs a Signature Block Printed Name,IEN#: "_SIGIEN_"" Q
 ;/IHS/GDIT/GAB **10** Added 3 lines above and commented 3 lines below for alert re-process
 ;I $P($G(^VA(200,SIGIEN,20)),"^",4)="" S BADERR="Author/Signer IEN#: "_SIGIEN_" needs an Electronic Signature Code in order to process the dental note" Q
 ;S BTITLE=$P($G(^VA(200,SIGIEN,20)),"^",3) I BTITLE="" S BADERR="Author/Signer IEN#: "_SIGIEN_" needs a Signature Block Title in order to process the dental note" Q
 ;S BNAME=$P($G(^VA(200,SIGIEN,20)),"^",2) I BNAME="" S BADERR="Author/Signer IEN#: "_SIGIEN_" needs a Signature Block Printed Name in order to process the dental note" Q
 S SIGNID=SIGIEN
 Q
SIGNDT ; Set the rest of the TXA Array
 S SIGDT=""
 S SIGDT=$$GET^HLOPRS(.SEGTXA,22,15)
 I SIGDT="" S BADERR="No Activity Date/time in the Dental Note Message" Q
 S TXARES(11)=$$HL7TFM^XLFDT(SIGDT)
 S TXARES(12)=SIGNID    ;Signer IEN
 Q
FSEGIEN(SRC,SEG) ;Segment item
 N LP,RES
 S (LP,RES)=0
 F  S LP=$O(SRC(LP)) Q:'LP  D  Q:RES
 .I $G(SRC(LP,"SEGMENT TYPE"))=SEG S RES=LP
 Q RES
ACK(HLMSGIEN,DFN,BADERR) ; Log Alert if error (BADERR)and send to RPMS Dental Mail group
 N STR
 I $L(BADERR) D
 .S STR="" I $L(DFN) S STR=$E($P($G(^DPT(DFN,0)),U,1),1,15)_" ["_DFN_"]"
 .S BADERR="EDR ALERT: "_BADERR_" "_STR
 .I $G(ALRTYP) D ADDALRT^BADEHL5(HLMSGIEN,ALRTYP,BADERR,DFN) ;/IHS/GDIT/GAB **10** for Dental Note Re-processing
 .D NOTIF(HLMSGIEN,BADERR)
 N PARMS,ACK,ERR
 I BADERR=""  S PARMS("ACK CODE")="AA",MSHMSG="Transaction successful"
 I BADERR'="" S PARMS("ACK CODE")="AR",MSHMSG=BADERR
 S:PARMS("ACK CODE")'="AA" PARMS("ERROR MESSAGE")=BADERR
 I '$$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR) D NOTIF(HLMSGIEN,ERR) Q
 Q
NOTIF(MSGIEN,MSG) ;Send a alert to a mail group
 N XQA,XQAID,XQDATA,XQAMSG
 S XQAMSG="Msg: "_MSGIEN_" "_$G(MSG)
 S XQAID="ADEN,"_DFN_","_50
 S XQDATA="Message Number="_MSGIEN
 S XQA("G.RPMS DENTAL")=""
 D SETUP^XQALERT
 Q
