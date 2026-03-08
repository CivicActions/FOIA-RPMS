BADEHL5 ;IHS/OIT/GAB - Dentrix HL7 inbound interface  ;08/15/2020
 ;;1.0;DENTAL/EDR INTERFACE;**7,8,10**;FEB 22, 2010;Build 61
 ;;/IHS/OIT/GAB PATCH 8 Added Variables to Clean Function
 ;;/IHS/GDIT/GAB PATCH 10: Add functionality to re-process dental notes
 ;;Process an incoming MDM-T04 Message Type (Dental Progress/Clinical Note)
 ;This routine will read in an incoming HL7 message (MDM-T04) and file a progress note for Dental
 ;Routines Used for this update:  BADEHL5,BADEHL6,BADEHL7,BADEHL8 (BADEALRT in Patch 10)
 ;Input: Message IEN (MIEN) - from ^HLB("QUEUE","IN"
 ;Output: SEGPID,SEGPV1,SEGTXA,TIUX(array of Message Data)
 ;Creates a visit if none found and adds a corresponding entry in the TIU Document file for viewing in EHR
 ;and adds the basic data to the V Note file
 ;
PARSE(DATA,MIEN,HLMSTATE)  ;EP
 N SEG,CNT
 Q:'$$STARTMSG^HLOPRS(.HLMSTATE,MIEN)
 M DATA("HDR")=HLMSTATE("HDR")
 S CNT=0
 F  Q:'$$NEXTSEG^HLOPRS(.HLMSTATE,.SEG)  D
 .S CNT=CNT+1
 .M DATA(CNT)=SEG
 Q
PROC ;EP CALLED FROM TSK^BADECTRL (Taskman Scheduled Task)
 D CLEAN
 S (BADERR,MSHMSG,SEGIEN,FIRST,DOCTYPE)=""
 S (APCDTOPR,APCDTPNT)=""
 S TIUERR=0
 S ALRTYP=0  ;/IHS/GDIT/GAB **10** Added for the alert type
 S U="^"
 Q:'$G(HLMSGIEN)
 D PARSE(.DATA,HLMSGIEN,.HLMSTATE)
 ;Process the Message Segments
PID ;Process the PID segment(Patient Information) & move to local array
 D PID^BADEHL6     ;set DFN, ASUFAC, Patient information
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q
PV1 ;Process the PV1 segment(Patient Visit Information) & move to local array
 D PV1^BADEHL6
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q
TXA ;Process the TXA segment and move local array - (Dental Note data) and check for finalized note ("LA")
 D TXA^BADEHL6
 I $L(BADERR) D ACK(HLMSGIEN,"",BADERR) Q
OBX ; Process the segment, move to TIUX and create the clinical note
 D OBX^BADEHL6      ;create local variables and local array
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q
 D ADD              ;create visit if none found
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q
 D TITLE^BADEHL6    ;get the dental data to create the note
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q
 I TIUPARNT'="" S HASADD=1
 E  S HASADD=0
 S APCDALVR("APCDTNQ")="DENTAL/ORAL HEALTH VISIT"
 I VTYPE="NEW" D PRV("P")   ;add the provider
 I VTYPE="ADD" D CHECKPRV   ;is the provider in the visit, add if not
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q
 D TIUSTUFF
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q
 D CLEAN
 Q
 ;
ADD ;  Visit Information: visit date/time, location and provider
 S (VISDT,PATLOC,PROVNAM,PROVNAM2,PNAME,PLNAME,PIEN,PROV,PROVIEN,PARLOC)=""
 S HOSLOC2=0
 S VISDT=$$GET^HLOPRS(.SEGTXA,4,1)
 I VISDT="" S BADERR="Missing Visit Date in TXA Segment for Message IEN: "_HLMSGIEN D ACK(HLMSGIEN,DFN,BADERR) Q
 ; Use the default time in the parameter file; or use 1138 as default
 I $L(VISDT)>8 S VISDT=$E(VISDT,1,8)
 I $L(VISDT)=8 D
 .S VTIME=$$GET^XPAR("ALL","BADE EDR DEFAULT TIME")
 .S:VTIME="" VTIME=1138   ;If no default time, set one
 .S VISDT=VISDT_VTIME
 .S Y=$$FMDATE^HLFNC(VISDT)
 I $P(Y,".")>$$DT^XLFDT S BADERR="Future visit date not allowed" Q
 S BADIN("VISIT DATE")=Y
 D DD^%DT S EXDAT=Y   ;External format
 ;get the Location/ASUFAC from the PV1 Segment
 S ASUFAC2=$$GET^HLOPRS(.SEGPV1,3,1)     ;get the assigned patient location, point of care
 I ASUFAC2="" S BADERR="Missing Location in PV1 Segment: " Q
 I $L(ASUFAC2) S ASUFAC=ASUFAC2
 ;
CKASUFAC   ;check the Bade EDR Defaults with the incoming HL7 message
 I +HOSLOC2=0 D
 .S LOC=$O(^AUTTLOC("C",ASUFAC,"")) I '$L(LOC) S BADERR="No location (in ^AUTTLOC) for this ASUFAC: "_ASUFAC Q
 .S PARLOC=+$$GET^XPAR("DIV.`"_LOC_"^SYS","BADE EDR DEFAULT CLINIC") I 'PARLOC S BADERR=" There is no default clinic for this ASUFAC: "_ASUFAC Q
 .S LOCA=+$P($G(^SC(PARLOC,0)),U,4) I LOCA'=LOC S BADERR="This ASUFAC, location and the DEFAULT CLINIC is incorrect "_ASUFAC Q
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q
 I LOC>0 D
 .S DUSER=$$DUSER^BADEUTIL(LOC)
 .S:DUSER DUZ=DUSER
 S DUZ(2)=LOCA       ; utilized code from bade v1.0
 ;
CKPROV  ;find the provider, use the IEN in TXA5 SEGMENT
 ;TXA segment field 5: 1st piece is the Provider IEN
 ;Use field 5 as the Primary Provider for the visit
 S (PIEN,PROVNAM,PLAST,PFIRST,PTI)=""
 S PIEN=$$GET^HLOPRS(.SEGTXA,5,1)       ;primary activity provider IEN
 I PIEN="" S BADERR="Provider IEN# is missing in the note" S ALRTYP=1 Q
 ;/IHS/GDIT/GAB **10** Added above line, commented the below line, added Provider alert type
 ;I PIEN="" S BADERR="Primary Activity Provider IEN# was not found in the TXA5 Dental Note Message" Q
 S PROV=PIEN
 S PROVNAM=$P($G(^VA(200,PROV,0)),"^",1)  ;provider name
 I PROVNAM="" S BADERR="Provider NAME is not present in RPMS,IEN#: "_PROV_"" S ALRTYP="1^PROV" Q
 ;/IHS/GDIT/GAB **10** Added above line, commented the below line, added Provider alert type
 ;I PROVNAM="" S BADERR="Provider name for IEN: "_PROV_" is not present in RPMS" Q
 S PTI=$$VAL^XBDIQ1(200,PROV,8)           ;provider title
 I $G(PTI)="" S BADERR="Provider TITLE was not found in RPMS,IEN#: "_PROV_"" S ALRTYP=1 Q
 I PTI'["D" S BADERR="Provider TITLE is not a DENTIST,IEN#: "_PROV_"" S ALRTYP=1 Q
 ;/IHS/GDIT/GAB **10** commented the next two lines, added above two lines - updated alert and added type
 ;I $G(PTI)="" S BADERR="Author/Signer TITLE with IEN#: "_PROV_" was not found in RPMS" Q
 ;I PTI'["D" S BADERR="Author/Signer with IEN: "_PROV_" does not have a DENTIST TITLE for the Dental Note" Q
 S BADIN("PROVIDER")=PROV
VISIT ; set the visit variables and create a visit if none present
 S IEN=0,ZIEN=0
 S BADIN("PAT")=DFN
 S BADIN("TIME RANGE")=-1       ;Match on date, not time
 S BADIN("SRV CAT")="A"         ;Ambulatory
 S BADIN("VISIT TYPE")=$S($P($G(^APCCCTRL(DUZ(2),0)),U,4)]"":$P(^(0),U,4),1:"I") ;visit type from PCC Master Control file
 D SCODE^BADEUTIL               ;Stop Code
 I ZIEN=0 S BADERR="Missing RPMS Clinic Stop Code for Dental" D ACK(HLMSGIEN,DFN,BADERR) Q
 S BADIN("CLINIC CODE")=ZIEN
 S BADIN("HOS LOC")=PARLOC
 S BADIN("SITE")=DUZ(2)
 S BADIN("USR")=DUZ
 S BADIN("APCDOPT")=$$GETOPT()
 S BADIN("NEVER ADD")=1
 S FVST=$$FNDVST(.BADIN)
 I 'FVST D
 .S FVST=$$MAKEVST(.BADIN) ; FAILED TO FIND MATCH
 .S VTYPE="NEW"
 E  D
 .S VTYPE="ADD"
 I 'FVST S BADERR=" Unable to create visit for message " D ACK(HLMSGIEN,DFN,BADERR) Q
 S APCDVSIT=FVST
 S VISITIEN=APCDVSIT
 N MSHMSG,MSA
 Q
TIUSTUFF ; Complete the Processing of the TIU Note
 S SCAT="A"
 N LOC1
 I '$D(VISITIEN) S BADERR="Visit IEN is not defined " Q
 I $D(VISITIEN),+VISITIEN D
 .S VSITDT=$P(^AUPNVSIT(+VISITIEN,0),U),VID=+VISITIEN,VLOC=$P(^AUPNVSIT(+VISITIEN,0),U,22)
 .S VSTR=LOC_";"_VISDT_";"_SCAT_";"_VISITIEN
 I DFN="" S BADERR="Patient DFN is not defined" Q
 ;DFN: Patient IEN;PNTITLE=Title Name;VLOC=Location;VID=Visit ID created; TIUX=array of data
 D MAKE^BADEHL7(0,$G(DFN),$G(PNTITLE),$G(VSITDT),$G(VLOC),$G(VID),.TIUX,$G(VSTR),"",1)
 I $L(BADERR) D ACK(HLMSGIEN,DFN,BADERR) Q
 Q
CHECKPRV ;Check to see if the provider in the message is already on this visit
 ;If not, add the provider
 N VPRV,MATCH,PRVIEN,PRIM
 S PRIM="P"
 S MATCH=0
 S VPRV="" F  S VPRV=$O(^AUPNVPRV("AD",APCDVSIT,VPRV)) Q:VPRV=""  D
 .S PRVIEN=$P($G(^AUPNVPRV(VPRV,0)),U,1)
 .I $P($G(^AUPNVPRV(VPRV,0)),U,4)="P" S PRIM="S"
 .I PROV=PRVIEN S MATCH=1
 I MATCH=0 D PRV(PRIM)
 Q
PRV(PRIMARY) ;Store the provider
 N APCDALVR
 S APCDALVR("APCDVSIT")=APCDVSIT
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDTPRO")="`"_PROV
 S APCDALVR("APCDTPS")=PRIMARY
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.06 (ADD)]" D EN^APCDALVR
 I APCDALVR("APCDATMP")="" S BADERR="ERROR:  Provider Not added to Visit" D ACK(HLMSGIEN,DFN,BADERR) Q
 Q
FSEGIEN(SRC,SEG) ;Segment item
 N LP,RES
 S (LP,RES)=0
 F  S LP=$O(SRC(LP)) Q:'LP  D  Q:RES
 .I $G(SRC(LP,"SEGMENT TYPE"))=SEG S RES=LP
 Q RES
ACK(HLMSGIEN,PDFN,BADERR) ;Send acknowledgement
 N STR
 I BADERR'="" D
 .S STR="" I $L(PDFN) S STR=$E($P($G(^DPT(PDFN,0)),U,1),1,15)_" ["_PDFN_"]"
 .S BADERR="EDR ALERT: "_BADERR_" "_STR
 .I $G(ALRTYP) D ADDALRT(HLMSGIEN,ALRTYP,BADERR,PDFN) ;/IHS/GDIT/GAB **10** for Dental Note Re-processing
 .D NOTIF(HLMSGIEN,BADERR)
 N PARMS,ACK,ERR
 I BADERR=""  S PARMS("ACK CODE")="AA",MSHMSG="Transaction successful"
 I BADERR'="" S PARMS("ACK CODE")="AR",MSHMSG=BADERR
 S:PARMS("ACK CODE")'="AA" PARMS("ERROR MESSAGE")=BADERR
 I '$$ACK^HLOAPI2(.HLMSTATE,.PARMS,.ACK,.ERR) D NOTIF(HLMSGIEN,ERR) Q
 Q
 ;Notification on errors
NOTIF(MSGIEN,MSG) ;Send a alert to a mail group
 N XQA,XQAID,XQDATA,XQAMSG
 S XQAMSG="Msg: "_MSGIEN_" "_$G(MSG)
 S XQAID="ADEN,"_DFN_","_50
 S XQDATA="Message Number="_MSGIEN
 S XQA("G.RPMS DENTAL")=""
 D SETUP^XQALERT
 ;
ADDALRT(MSGIEN,ALRTYP,MSG,PDFN) ;  /IHS/GDIT/GAB **10** Added for re-processing dental notes
 ;SIGIEN is from CKSIGNER in BADEHL6 (author/signer IEN may not be present in MDM HL7 message)
 ;ALRTYP=1 Provider error, ALRTYP=2/3 Author/Signer error
 S TXA6=$$GET^HLOPRS(.SEGTXA,6)   ;Note creation date/time
 I $G(ALRTYP) D
 . I ALRTYP=1&(PIEN="") D ADD^BADEALRT(MSGIEN,MSG,PDFN,VISDT,0,0,0,ALRTYP,TXA6) Q     ;No provider IEN
 . I ALRTYP=1 D ADD^BADEALRT(MSGIEN,MSG,PDFN,VISDT,PROV,0,0,ALRTYP,TXA6) Q            ;Provider IEN
 . I ALRTYP=2!(ALRTYP=3) D
 . . I $G(SIGIEN) D ADD^BADEALRT(MSGIEN,MSG,PDFN,VISDT,PROV,0,SIGIEN,ALRTYP,TXA6) Q    ;Auth/Sign has an IEN
 . . I '$G(SIGIEN)  D
 . . . I $D(HL7NAM) D ADD^BADEALRT(MSGIEN,MSG,PDFN,VISDT,PROV,HL7NAM,0,ALRTYP,TXA6) Q  ;Auth/Sign no IEN, but has name
 . . . I '$G(HL7NAM) D ADD^BADEALRT(MSGIEN,MSG,PDFN,VISDT,PROV,0,0,ALRTYP,TXA6)        ;Auth/Sign no IEN, no NAME
 Q
 ; Return Option IEN used to Create
GETOPT() ; EP
 N RET
 S RET=$$FIND1^DIC(19,,"O","BADE EDR MAIN MENU")
 Q $S(RET:RET,1:"")
 ; Return whether an existing visit can be used or need to create one
OPT(IEN) ;Check to see if the option in the visit matches the dental option
 N MATCH,OPT
 S MATCH=0
 S OPT=$$GETOPT()
 I $P($G(^AUPNVSIT(IEN,0)),U,24)=OPT S MATCH=1
 Q MATCH
 ;
FNDVST(CRIT) ;EP
 N IEN,EFLG,OUT,RET
 S RET=0
 D GETVISIT^BSDAPI4(.CRIT,.OUT)
 Q:'OUT(0) 0  ; No visits were found
 S IEN=0,EFLG=0
 F  S IEN=$O(OUT(IEN)) Q:'IEN  D  Q:EFLG
 .I OUT(IEN)="ADD" D
 ..N X
 ..S X="CIANBEVT" X ^%ZOSF("TEST") I $T D BRDCAST^CIANBEVT("PCC."_DFN_".VST",IEN)
 .I $$OPT(IEN) S EFLG=1,RET=IEN Q
 Q $S(RET:RET,OUT(0)=1:$O(OUT(0)),1:0)
 ;
MAKEVST(CRIT) ;EP
 N RET,OUT
 K CRIT("NEVER ADD")
 S CRIT("FORCE ADD")=1
 D GETVISIT^BSDAPI4(.CRIT,.OUT)
 Q:'OUT(0) OUT(0)
 S RET=+$O(OUT(0))
 I OUT(RET)="ADD" D
 .N X
 .S X="CIANBEVT" X ^%ZOSF("TEST") I $T D BRDCAST^CIANBEVT("PCC."_DFN_".VST",RET)
 Q RET
CLEAN ;  Clean up the variables
 K DATA,ARY,SEGPID,SEGPV1,SEGTXA,SEGOBX,TIUX,OBXRES,PIDRES,OBXTXT,EDRTXT,ERR,RET,DFN,NAME,APTIME,LOC,OUT
 K PNAME,PLNAME,POV,PROV,PROVIEN,PROVFN,PROVLN,PROVMN,VTYPE,SIGIEN,SIGNID
 K DRG,DCODE,DCODEQ,PVDIEN,DSPNUM,BADIN,APCDALVR,APCDTNOV,APCDVSIT,SCODE,SEGIEN,SURGDES,TCODE,TYPE,VTYPE
 K APCDPAT,APCDTNOU,APCDTOS,APCDTSUR,APCDTFEE,APCDTCDT,APCDTPRV,APCDTEPR,APCDTPNT,APCDTEXK,APCDTSC,APCDTOPR,PARLOC
 K HLNAME,HFNAME,LNAME,NAME,DOB,HLDOB,BADERR,BADEWARN,X,Y,IEN,ASUFAC,ASUFAC2,CCODE,CODEIEN,DESC,VTIME,EXKEY,HOSLOC,MOD
 K PRVNPI,MSHMSG,FIRST,DOCTYPE,PIEN,PFNM
 K X1,LP,RES
 Q   ;/IHS/OIT/GAB PATCH 8: Added above line
