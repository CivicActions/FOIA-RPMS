BEDDVFIX ;GDIT/HS/BEE-BEDD Visit Clean Up Routine ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;**4**;Jun 04, 2014;Build 19
 ;
 ;This routine is included in the BEDD XML 2.0 Patch 4 install and is not in the KIDS
 ;GDIT/HS/BEE - This routine is included in the BEDD 2.0 Patch 4 XML
 ;
 Q
 ;
 ;Daily AMER/BEDD cleanup
DAILY(BYPASS) ;EP - Review AMER/BEDD files and clean up any issues
 ;
 S BYPASS=$G(BYPASS)
 ;
 ;See if run for the day
 Q:'$G(DUZ(2))
 Q:'$D(^AMER(2.5,DUZ(2),0))
 I +$G(DUZ(2)),'BYPASS Q:$$GET1^DIQ(9009082.5,DUZ(2)_",",.07,"I")'<DT
 ;
 ;Run the cleanup routine
 D
 . NEW MSG,REC
 . D DAILY^AMERVFIX(BYPASS)
 . S MSG="Daily BEDDVFIX routine kicked off"
 . D AUD(" "," ","B01"," ",MSG," ",.REC)
 ;
 Q
 ;
 ;Loop through BEDD entries and fix if necessary
CLEAN(PI) ;EP - Called by AMERFIX
 ;
 S PI=+$G(PI)
 ;
 ;Moved to new routine to reduce routine size
 D CLEAN^BEDDVFX1(PI)
 Q
 ;
 ;Update BEDD entry based on ER VISIT entry
VST(AMERDFNO,AMERPCCO,AMERVSIT,PCVISIT,PI,DEL) ;EP - Called by BVST^AMERFIX
 ;
 ;AMERDFN,AMVIEN,AMERVSIT,PCVISIT,PI,DEL
 ;
 ;Input parameter
 ; AMERDFN - Patient DFN
 ; AMERPCCO - Original VIEN on file in ER VISIT
 ; AMERVSIT - Pointer to ER VISIT entry
 ; PCVISIT - New VIEN|New DFN|Merged Visit|M or V|New Visit Date/Time
 ;       PI - Initial post install run
 ;      DEL - Mark the BEDD entry as deleted
 ;
 I '$G(AMERDFNO) Q  ;Quite if no original DFN
 ;
 NEW OBJID,AMERPCCN,AMERDFNN,AMERDFN
 ;
 S AMERPCCO=$G(AMERPCCO)
 S AMERPCCN=$P($G(PCVISIT),"|")
 S AMERDFNN=$P($G(PCVISIT),"|",2)
 S AMERVSIT=$G(AMERVSIT)
 S PI=+$G(PI)
 S DEL=+$G(DEL)
 ;
 ;Look up OBJID - Original DFN
 S AMERDFN=AMERDFNO
 S OBJID=$$GETOBJ(AMERDFNO,AMERVSIT,AMERPCCO,AMERPCCN,PI,"V")
 ;
 ;If not found - Looked in merged DFN
 I OBJID="",AMERDFNN D  Q:OBJID=""
 . S OBJID=$$GETOBJ(AMERDFNN,AMERVSIT,AMERPCCO,AMERPCCN,PI,"V")
 . S:OBJID]"" AMERDFN=AMERDFNN
 ;
 ;Look for BEDD delete request
 I DEL D  Q
 . NEW BED,%,STS,REC
 . ;
 . ;Get the entry
 . S BED=##CLASS(BEDD.EDVISIT).%OpenId(OBJID,0)
 . ;
 . ;Skip if bad entry
 . I '$ISOBJECT(BED) D  Q
 .. NEW REC
 .. D AUD("BEDD.EDVISIT",OBJID,"B44",1,"BEDD.EDVISIT entry: "_OBJID_" - Corrupt OBJID",AMERDFN_"|"_AMERPCCO,.REC)
 . ;
 . ;Mark as deleted
 . S BED.Deleted=1
 . D NOW^%DTC
 . S BED.DeletedDtTm=%
 . S BED.DCFlag=1
 . S STS=BED.%Save()
 . D AUD("BEDD.EDVISIT",OBJID,"B45",1,"BEDD.EDVISIT entry: "_OBJID_" - Marked as deleted",AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 ;Look for update
 I (AMERPCCO!AMERPCCN)!(AMERDFNN) D  Q
 . NEW BED,STS,DISDT
 . ;
 . ;Get the entry
 . S BED=##CLASS(BEDD.EDVISIT).%OpenId(OBJID,0)
 . ;
 . ;Skip if bad entry
 . I '$ISOBJECT(BED) D  Q
 .. NEW REC
 .. D AUD("BEDD.EDVISIT",OBJID,"B46",1,"BEDD.EDVISIT entry: "_OBJID_" - Corrupt OBJID",AMERDFN_"|"_AMERPCCO,.REC)
 . ;
 . ;Make sure visit is discharged
 . I BED.DCFlag'=1 D
 .. NEW REC
 .. S REC("DCFlag")=BED.DCFlag
 .. S BED.DCFlag=1
 .. D AUD("BEDD.EDVISIT",OBJID,"B47",0,"BEDD.EDVISIT entry: "_OBJID_" - Visit marked as discharged",AMERDFN_"|"_AMERPCCO,.REC)
 . ;
 . S DISDT=$$GET1^DIQ(9009080,AMERVSIT_",",6.2,"I") I DISDT]"" D
 .. NEW DISDH,REC
 .. S DISDH=$$FMTH^XLFDT(DISDT)
 .. I BED.DCDtH=$P(DISDH,","),BED.DCTmH=$P(DISDH,",",2) Q
 .. S REC("DCDtH")=BED.DCDt,REC("DCTmH")=BED.DCTmH
 .. D AUD("BEDD.EDVISIT",OBJID,"B48",0,"BEDD.EDVISIT entry: "_OBJID_" - Discharge Dt/Tm changed from "_BED.DCDtH_","_BED.DCTmH_" to "_$P(DISDH,",")_","_$P(DISDH,",",2),AMERDFN_"|"_AMERPCCO,.REC)
 .. S BED.DCDtH=$P(DISDH,","),BED.DCTmH=$P(DISDH,",",2)
 . ;
 . ;Update to the new visit IEN
 . I BED.VIEN'=AMERPCCN D
 .. NEW REC
 .. S REC("VIEN")=BED.VIEN
 .. D AUD("BEDD.EDVISIT",OBJID,"B49",0,"BEDD.EDVISIT entry: "_OBJID_" - PCC visit changed from "_BED.VIEN_" to "_AMERPCCN,AMERDFN_"|"_AMERPCCO,.REC)
 .. S BED.VIEN=AMERPCCN
 . ;
 . ;Save changes
 . S STS=BED.%Save()
 ;
 Q
 ;
RIDX(ADLRH,OBJID,AMERDFN,VIEN) ;Remove duplicate indexes
 ;
 NEW ADT,EDT,MSG
 ;
 I '$D(^BEDD.EDVISITI("ArrIdx",ADLRH,OBJID)) D
 . S ^BEDD.EDVISITI("ArrIdx",ADLRH,OBJID)=$lb("",ADLRH)
 . S MSG="Visit date change - created entry ^BEDD.EDVISITI(""ArrIdx"","_ADLRH_","_OBJID_")=$lb("""","_ADLRH_")"
 . S REC=""
 . D AUD("BEDD.EDVISIT",OBJID,"B66",0,MSG,AMERDFN_"|"_VIEN,.REC)
 ;
 S ADT=ADLRH-20,EDT=ADLRH+20 F  S ADT=$O(^BEDD.EDVISITI("ArrIdx",ADT)) Q:'ADT!(ADT>EDT)  D
 . NEW MSG,REC
 . I '$D(^BEDD.EDVISITI("ArrIdx",ADT,OBJID)) Q
 . I ADT=ADLRH Q
 . S REC("ArrIdx")="^BEDD.EDVISITI(""ArrIdx"","_ADT_","_OBJID_")="_$G(^BEDD.EDVISITI("ArrIdx",ADT,OBJID))
 . S MSG="Visit date change - removed entry ^BEDD.EDVISITI(""ArrIdx"","_ADT_","_OBJID_")"
 . D AUD("BEDD.EDVISIT",OBJID,"B64",0,MSG,AMERDFN_"|"_VIEN,.REC)
 . K ^BEDD.EDVISITI("ArrIdx",ADT,OBJID)
 ;
 Q
 ;
CIDX(ADLRH,OBJID,AMERDFN,VIEN) ;Remove duplicate indexes
 ;
 NEW ADT,EDT
 ;
 I '$D(^BEDD.EDVISITI("CIDtIIdx",ADLRH,OBJID)) D
 . S ^BEDD.EDVISITI("CIDtIIdx",ADLRH,OBJID)=$lb("",ADLRH)
 . S MSG="Visit date change - created entry ^BEDD.EDVISITI(""CIDtIIdx"","_ADLRH_","_OBJID_")=$lb("""","_ADLRH_")"
 . S REC=""
 . D AUD("BEDD.EDVISIT",OBJID,"B67",0,MSG,AMERDFN_"|"_VIEN,.REC)
 ;
 S ADT=ADLRH-20,EDT=ADLRH+20 F  S ADT=$O(^BEDD.EDVISITI("CIDtIIdx",ADT)) Q:'ADT!(ADT>EDT)  D
 . NEW MSG,REC
 . I '$D(^BEDD.EDVISITI("CIDtIIdx",ADT,OBJID)) Q
 . I ADT=ADLRH Q
 . S REC("CIDtIIdx")="^BEDD.EDVISITI(""CIDtIIdx"","_ADT_","_OBJID_")="_$G(^BEDD.EDVISITI("CIDtIIdx",ADT,OBJID))
 . S MSG="Visit date change - removed entry ^BEDD.EDVISITI(""CIDtIIdx"","_ADT_","_OBJID_")"
 . D AUD("BEDD.EDVISIT",OBJID,"B65",0,MSG,AMERDFN_"|"_VIEN,.REC)
 . K ^BEDD.EDVISITI("CIDtIIdx",ADT,OBJID)
 ;
 Q
 ;
 ;Update BEDD entry based on ER ADMISSION entry
 ;
ADM(AMERPCCO,AMERDFNO,PCVISIT,PI,DEL) ;EP - Called by BADM^AMERFIX
 ;
 ;Input parameter
 ; AMERPCCO - Original VIEN on file in ER ADMISSION
 ; AMERDFNO - Origianl Patient DFN
 ; PCVISIT - New VIEN|New DFN|Merged Visit|M or V|New Visit Date/Time
 ;       PI - Initial post install run
 ;      DEL - ER ADMISSION entry deleted
 ;
 I '$G(AMERDFNO) Q  ;Quite if no original DFN
 ;
 NEW OBJID,AMERPCCN,AMERDFNN,AMERDFN
 ;
 S AMERPCCO=$G(AMERPCCO)
 S AMERPCCN=$P($G(PCVISIT),"|")
 S AMERDFNN=$P($G(PCVISIT),"|",2)
 S PI=+$G(PI)
 S DEL=+$G(DEL)
 ;
 ;Look up OBJID - Original DFN
 S AMERDFN=AMERDFNO
 S OBJID=$$GETOBJ(AMERDFNO,"",AMERPCCO,AMERPCCN,PI,"A")
 ;
 ;If not found - Looked in merged DFN
 I OBJID="",AMERDFNN D  Q:OBJID=""
 . S OBJID=$$GETOBJ(AMERDFNN,"",AMERPCCO,AMERPCCN,PI,"A")
 . S:OBJID]"" AMERDFN=AMERDFNN
 ;
 ;If not a delete and no object, need to create one
 I 'DEL,OBJID="" D  Q:OBJID=""
 . ;
 . ;First look for new entry
 . I AMERDFNN,$D(^AMERADM(AMERDFNN)),AMERPCCN D  Q
 .. S OBJID=$$NEW^BEDDUTW(AMERDFNN,AMERPCCN)
 .. I OBJID D AUD("BEDD.EDVISIT",OBJID,"B61",0,"BEDD.EDVISIT entry: "_OBJID_" - Created entry",AMERDFN_"|"_AMERPCCO,.REC)
 . ;
 . ;Second look for original entry
 . I AMERDFNO,$D(^AMERADM(AMERDFNO)),AMERPCCN D  Q
 .. S OBJID=$$NEW^BEDDUTW(AMERDFNO,AMERPCCN)
 .. I OBJID D AUD("BEDD.EDVISIT",OBJID,"B62",0,"BEDD.EDVISIT entry: "_OBJID_" - Created entry",AMERDFN_"|"_AMERPCCO,.REC)
 ;
 ;Look for ER ADMISSION delete - Need to mark BEDD entry as deleted as well
 I DEL D  Q
 . NEW BED,%,STS,REC
 . ;
 . ;Get the entry
 . S BED=##CLASS(BEDD.EDVISIT).%OpenId(OBJID,0)
 . ;
 . ;Skip if bad entry
 . I '$ISOBJECT(BED) D  Q
 .. NEW REC
 .. D AUD("BEDD.EDVISIT",OBJID,"B50",1,"BEDD.EDVISIT entry: "_OBJID_" - Corrupt OBJID",AMERDFN_"|"_AMERPCCO,.REC)
 . ;
 . ;Mark as deleted
 . S BED.Deleted=1
 . D NOW^%DTC
 . S BED.DeletedDtTm=%
 . S BED.DCFlag=1
 . S STS=BED.%Save()
 . D AUD("BEDD.EDVISIT",OBJID,"B51",1,"BEDD.EDVISIT entry: "_OBJID_" - Marked as deleted",AMERDFN_"|"_AMERPCCO,.REC)
 ;
 ;Look for update
 I (AMERPCCO!AMERPCCN)!AMERDFNN D  Q
 . NEW BED,STS
 . ;
 . ;Get the entry
 . S BED=##CLASS(BEDD.EDVISIT).%OpenId(OBJID,0)
 . ;
 . ;Skip if bad entry
 . I '$ISOBJECT(BED) D  Q
 .. NEW REC
 .. D AUD("BEDD.EDVISIT",OBJID,"B52",1,"BEDD.EDVISIT entry: "_OBJID_" - Corrupt OBJID",AMERDFN_"|"_AMERPCCO,.REC)
 . ;
 . ;Update to the new DFN IEN
 . I AMERDFNN,BED.PtDFN'=AMERDFNN D
 .. NEW REC
 .. S REC("PtDFN")=BED.PtDFN
 .. D AUD("BEDD.EDVISIT",OBJID,"B53",0,"BEDD.EDVISIT entry: "_OBJID_" - PtDFN changed from "_BED.PtDFN_" to "_AMERDFNN,AMERDFN_"|"_AMERPCCO,.REC)
 .. S BED.PtDFN=AMERDFNN
 .. S STS=BED.%Save()
 . ;
 . ;Update to the new visit IEN
 . I AMERPCCN'=BED.VIEN D
 .. NEW REC
 .. S REC("VIEN")=BED.VIEN
 .. D AUD("BEDD.EDVISIT",OBJID,"B54",0,"BEDD.EDVISIT entry: "_OBJID_" - PCC visit changed from "_BED.VIEN_" to "_AMERPCCN,AMERDFN_"|"_AMERPCCO,.REC)
 .. S BED.VIEN=AMERPCCN
 .. S STS=BED.%Save()
 Q
 ;
GETOBJ(AMERDFN,AMERVST,AMERPCCO,AMERPCCN,PI,AV) ;Return the BEDD OBJID for the ER ADMISSION or ER VISIT
 ;
 ;Input parameter:
 ; AMERDFN - Patient DFN
 ; AMERVST - ER VISIT IEN
 ; AMERPCCO - Original Visit IEN
 ; AMERPCCN - New Visit IEN
 ; PI - Post install run (looks through all of BEDD)
 ; AV - Look in ER ADMISSION (A) or ER VISIT (V)
 ;
 NEW OBJID,EARLYDT,ARRDT,OBJ,IOBJ
 ;
 ;First look up by visit
 S (IOBJ,OBJID)=""
 S AMERVST=$G(AMERVST)
 ;
 ;First look up by original VIEN
 I AMERPCCO F  S IOBJ=$O(^BEDD.EDVISITI("ADIdx",AMERPCCO,IOBJ)) Q:IOBJ=""  S OBJID=$$VOBJ(IOBJ,AMERDFN,AMERPCCO,AMERVST) Q:OBJID
 ;
 ;Second look up by new VIEN
 I AMERPCCN,'OBJID F  S IOBJ=$O(^BEDD.EDVISITI("ADIdx",AMERPCCN,IOBJ))  Q:IOBJ=""  S OBJID=$$VOBJ(IOBJ,AMERDFN,AMERPCCO,AMERVST) Q:OBJID
 ;
 ;If not found, look back 30 days for a visit match
 ;(or to beginning for post install run)
 S EARLYDT=$H-30 S:PI EARLYDT=-1000000000000000
 I 'OBJID S ARRDT=$H+2 F  S ARRDT=$O(^BEDD.EDVISITI("ArrIdx",ARRDT),-1) Q:(ARRDT="")!(ARRDT<EARLYDT)  D  Q:OBJID
 . S OBJ="" F  S OBJ=$O(^BEDD.EDVISITI("ArrIdx",ARRDT,OBJ),-1) Q:(OBJ="")  D  Q:OBJID
 .. NEW ED,BDT,VDT
 .. ;
 .. ;Get the entry
 .. S ED=##CLASS(BEDD.EDVISIT).%OpenId(OBJ,0)
 .. ;
 .. ;Skip if bad entry
 .. I '$ISOBJECT(ED) D  Q
 ... NEW REC
 ... D AUD("BEDD.EDVISIT",OBJID,"B55",1,"BEDD.EDVISIT entry: "_OBJID_" - Corrupt OBJID",AMERDFN_"|"_AMERPCCO,.REC)
 .. ;
 .. ;Skip if already deleted
 .. I ED.Deleted=1 Q
 .. ;
 .. ;Quit if not patient
 .. I ED.PtDFN'=AMERDFN Q
 .. ;
 .. ;If ER ADMISSION Quit if visit already discharged
 .. I AV="A",ED.DCFlag=1 Q
 .. ;
 .. ;Get the visit arrive date/time
 .. S BDT=$$HTFM^XLFDT(ED.CIDt_","_ED.CITm) Q:BDT=""
 .. ;
 .. ;Compare against ER ADMISSION Timestamp
 .. S VDT=""
 .. I AV="A" S VDT=$$GET1^DIQ(9009081,AMERDFN_",",1,"I")
 .. I AV="V" S VDT=$$GET1^DIQ(9009080,AMERVST_",",.01,"I")
 .. I BDT'=VDT Q
 .. S OBJID=$$VOBJ(OBJ,AMERDFN,AMERPCCO,AMERVST)
 ;
 Q OBJID
 ;
VOBJ(OBJID,AMERDFN,AMERPCCO,AMERVSIT) ;Return if a valid object ID
 ;
 I OBJID="" Q ""
 ;
 NEW ED,BAMVST
 ;
 ;Get the entry
 S ED=##CLASS(BEDD.EDVISIT).%OpenId(OBJID,0)
 ;
 ;Skip if bad entry
 I '$ISOBJECT(ED) D  S OBJID="" Q ""
 . NEW REC
 . D AUD("BEDD.EDVISIT",OBJID,"B56",1,"BEDD.EDVISIT entry: "_OBJID_" - Corrupt OBJID",AMERDFN_"|"_AMERPCCO,.REC)
 ;
 ;Skip if already deleted
 I ED.Deleted=1 S OBJID=""
 ;
 ;Check for ER VISIT
 S BAMVST=ED.AMERVSIT
 I AMERVSIT]"",BAMVST]"",AMERVSIT'=BAMVST S OBJID=""
 ;
 Q OBJID
 ;
 ;This call will update the PtDFN field in a specified BEDD.EDVISIT entry
DFN(AMERDFNO,AMERVST,AMERPCCO,AMERPCCN,AMERDFNN,PI,AV) ;EP - Update BEDD.EDVISIT PtDFN entry
 ;
 NEW OBJID,BED,STS,REC
 ;
 S AMERDFNO=$G(AMERDFNO)
 S AMERVST=$G(AMERVST)
 S AMERPCCO=$G(AMERPCCO)
 S AMERPCCN=$G(AMERPCCN)
 S AMERDFNN=$G(AMERDFNN) I 'AMERDFNN  D  Q
 . NEW REC
 . D AUD("BEDD.EDVISIT","","B57",0,"PtDFN update issue - no new DFN supplied",AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 ;First look up by original DFN
 S OBJID=$$GETOBJ(AMERDFNO,AMERVST,AMERPCCO,AMERPCCN,PI,AV)
 ;
 ;Second look up by new DFN
 I 'OBJID S OBJID=$$GETOBJ(AMERDFNN,AMERVST,AMERPCCO,AMERPCCN,PI,AV)
 ;
 ;File audit entry if entry not found
 I 'OBJID D  Q
 . NEW REC
 . D AUD("BEDD.EDVISIT",OBJID,"B58",0,"PtDFN update issue (Not found) - Could not update from "_AMERDFNO_" to "_AMERDFNN,AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 ;Get the entry
 S BED=##CLASS(BEDD.EDVISIT).%OpenId(OBJID,0)
 ;
 ;Skip if bad entry
 I '$ISOBJECT(BED) D  Q
 . NEW REC
 . D AUD("BEDD.EDVISIT",OBJID,"B59",0,"PtDFN update issue (OBJECT error) - Could not update from "_AMERDFNO_" to "_AMERDFNN,AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 ;Update to the new DFN IEN
 S REC("PtDFN")=BED.PtDFN
 D AUD("BEDD.EDVISIT",OBJID,"B60",0,"Entry: "_OBJID_" - PtDFN changed from "_BED.PtDFN_" to "_AMERDFNN,AMERDFNO_"|"_AMERPCCO,.REC)
 S BED.PtDFN=AMERDFNN
 S STS=BED.%Save()
 ;
 Q
 ;
AUD(FILE,ENTRY,ACT,DEL,MSG,INFO,REC) ;File audit ^XTMP entry
 ;
 NEW STS
 ;
 S STS=$$AUD^AMERVFIX("BEDDVFIX",FILE,ENTRY,ACT,DEL,MSG,$G(INFO),.REC)
 Q
 ;
ERR ;
 D ^%ZTER
 Q
