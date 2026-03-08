BUSAAPIR ;GDIT/HS/BEE-IHS USER SECURITY AUDIT Utility API Program 2 ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;**4**;Nov 05, 2013;Build 71
 ;
 Q
 ;
 ;BUSA*1.0*4;GDIT/HS/BEE 06/09/2021;Feature 60284;New routine - Remediation API (CHECK)
 ;
CHECK(BUSATYPE,BUSAREC,BUSAR) ;PEP - Check entry for remediation
 ;
 ;This API call accepts a remediation type and record and returns whether there
 ;is a remediation rule defined for that record
 ;
 ;Input:
 ;BUSATYPE - Remediation type - should either be a BUSA remediation Type
 ;                              or Other Type of Type is Other
 ;BUSAREC - Remediation record - the record to look up in the specified type
 ;BUSAR - Rule Array - An array of Remediation Rules. If the BUSATYPE is already defined
 ;        in the array then it will not be pulled from the remediation rules. This is
 ;        useful if the API call is going to be made a number of times in succession.
 ;        The parameter variable in the originating call should be initialized prior to
 ;        the first time this API is called.
 ;
 ;Return array:
 ;BUSAR(BUSATYPE,RULE)=""
 ;    where: BUSATYPE - Any of the BUSATYPE entries that have been called from the source call
 ;           RULE - The rule(s) in place for that type
 ;
 ;Function return:
 ; 0 - No remediation entry on file
 ; 1 - Submitted type/record has been remediated
 ;
 ;Data validation
 I $G(BUSATYPE)="" Q 0
 I $G(BUSAREC)="" Q 0
 ;
 NEW BUSARET,BUSADESC,BUSARL
 ;
 S BUSARET=0
 ;
 ;For BUSATYPE 'BUSA Reports - Entry Description' get entry description
 S BUSADESC=""
 I BUSATYPE="BUSA Reports - Entry Description" S BUSADESC=$G(^BUSAS(BUSAREC,1))
 ;
 ;Retrieve the rules for the Type
 I '$D(BUSAR(BUSATYPE)) D RRULES(BUSATYPE,.BUSAR)
 ;
 ;Check for remediated entry
 S BUSARL="" F  S BUSARL=$O(BUSAR(BUSATYPE,BUSARL)) Q:BUSARL=""  D  I BUSARET Q
 . ;
 . ;Special handling for BUSATYPE 'BUSA Reports - Entry Description'
 . I BUSATYPE="BUSA Reports - Entry Description" D  Q
 .. I BUSADESC=BUSAREC S BUSARET=1
 . ;
 . NEW BUSATOTP,BUSAPC,BUSARULE
 . ;
 . S BUSATOTP=$L(BUSARL,",")
 . ;
 . ;Look at each rulle
 . F BUSAPC=1:1:BUSATOTP S BUSARULE=$P(BUSARL,",",BUSAPC) D  Q:BUSARET
 .. ;
 .. ;Allow for leading space
 .. I $E(BUSARULE,1)=" " S BUSARULE=$E(BUSARULE,2,99999)
 .. ;
 .. I BUSARULE="" Q
 .. ;
 .. ;Look for single match
 .. I BUSARULE'[":" D  Q
 ... I BUSAREC=BUSARULE S BUSARET=1
 .. ;
 .. ;Look for range
 .. I BUSARULE[":" D  Q
 ... ;
 ... NEW BUSASTRT,BUSAEND,BUSAAN
 ... ;
 ... S BUSASTRT=$P(BUSARULE,":")
 ... S BUSAEND=$P(BUSARULE,":",2)
 ... ;
 ... S BUSAAN=0
 ... I ($TR(BUSAREC,"0123456789")]"")!((BUSASTRT'="")&($TR(BUSASTRT,"0123456789")]""))!((BUSAEND'="")&($TR(BUSAEND,"0123456789")]"")) S BUSAAN=1
 ... ;
 ... ;Check range - Numeric
 ... I BUSAAN=0 D  Q
 .... I BUSASTRT'="",BUSAEND'="",BUSAREC'<BUSASTRT,BUSAREC'>BUSAEND S BUSARET=1 Q
 .... ;
 .... ;Only start
 .... I BUSASTRT'="",BUSAEND="",BUSAREC'<BUSASTRT S BUSARET=1 Q
 .... ;
 .... ;Only end
 .... I BUSASTRT="",BUSAEND'="",BUSAREC'>BUSAEND S BUSARET=1
 ... ;
 ... ;Check range - alpha numeric
 ... I BUSAAN=1 D
 .... I BUSASTRT'="",BUSAEND'="",BUSASTRT']BUSAREC,BUSAREC']BUSAEND S BUSARET=1 Q
 .... ;
 .... ;Only start
 .... I BUSASTRT'="",BUSAEND="",BUSASTRT']BUSAREC S BUSARET=1 Q
 .... ;
 .... ;Only end
 .... I BUSASTRT="",BUSAEND'="",BUSAREC']BUSAEND S BUSARET=1
 ;
 Q BUSARET
 ;
RRULES(BUSATYPE,BUSAR) ;Retrieve the remediation rules for the specified Type
 ;
 NEW BUSABIEN,BUSAITYP
 ;
 ;Define subscript
 S BUSAITYP=" "_$$UP^XLFSTR(BUSATYPE)
 ;
 ;Set top level entry to handle no rules for type faster
 S BUSAR(BUSATYPE)=""
 ;
 ;First look in Type array
 S BUSABIEN="" F  S BUSABIEN=$O(^BUSA.RemediaBD3B.RecordHistoryI("CurVerDelTypeIdx",1,1,0,BUSAITYP,BUSABIEN)) Q:BUSABIEN=""  D
 . ;
 . NEW BUSARREC,BUSARULE,BUSAEXEC
 . ;
 . S BUSARREC="",BUSARULE=""
 . S BUSAEXEC="S BUSARULE=##CLASS(BUSA.Remediation.DataModels.RecordHistory).%OpenId(BUSABIEN)" X BUSAEXEC
 . S BUSAEXEC="I $ISOBJECT(BUSARULE) S BUSARREC=BUSARULE.RemediatedRecords" X BUSAEXEC
 . ;
 . ;Save in array
 . I BUSARREC'="" S BUSAR(BUSATYPE,BUSARREC)=""
 ;
 ;Second look in OtherType array
 S BUSABIEN="" F  S BUSABIEN=$O(^BUSA.RemediaBD3B.RecordHistoryI("CurVerDelTypeOtherIdx",1,1,0,BUSAITYP,BUSABIEN)) Q:BUSABIEN=""  D
 . ;
 . NEW BUSARREC,BUSARULE,BUSAEXEC
 . ;
 . S BUSARREC="",BUSARULE=""
 . S BUSAEXEC="S BUSARULE=##CLASS(BUSA.Remediation.DataModels.RecordHistory).%OpenId(BUSABIEN)" X BUSAEXEC
 . S BUSAEXEC="I $ISOBJECT(BUSARULE) S BUSARREC=BUSARULE.RemediatedRecords" X BUSAEXEC
 . ;
 . ;Save in array
 . I BUSARREC'="" S BUSAR(BUSATYPE,BUSARREC)=""
 ;
 Q
