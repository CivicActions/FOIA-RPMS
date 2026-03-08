BIAPIDTS ;GDIT/HS/BEE-BI API DTS Calls ; 24 Feb 2021  9:54 AM
 ;;8.5;IMMUNIZATION;**21**;APR 01,2021;Build 10
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;; FROM BRIAN EVERETT.
 ;
 ;This routine contains BI API calls to the DTS server
 ;
 ;This routine contains the following API calls:
 ;$$CHKLOT^BIAPIDTS - Returns whether a passed in CVX/Lot# is valid
 ;$$CVX^BIAPIDTS(RET,CALL,UPDATE) - Returns a list of valid CVX codes
 ;$$LIST^BIAPIDTS(RET,ICVX,CALL,UPDATE) - Returns a list of valid CVX/Lot#s
 ;$$LOG^BIAPIDTS(CVX,LOT,MVX,MSG,USER) - Logs an unknown lot entry to DTS (to generate email)
 ;
 Q
 ;
LOG(CVX,LOT,MVX,MSG,USER) ;EP Create log entry for DTS to create alert email
 ;
 ;Calling this API will cause a log entry to be generated and sent to the DTS server
 ;which will in turn cause an alert email to be sent. This API should be called when
 ;a user enters a new lot # in BI that is not in the list of available IHS lots.
 ;
 ;Input variables:
 ;  CVX (required): CVX code of the new lot entry
 ;  LOT (required): LOT number of the new lot entry
 ;  MVX (required): The manufacturer of the lot
 ;  MSG (optional): Optional message to include in email [ex. "State lot"]
 ; USER (optional): DUZ of user who created the lot entry. If null, DUZ of
 ;                  the current user is used
 ;
 ;Function return:
 ;1 - Log message generated
 ;0^Error Message - Log message was not generated
 ;
 ;Validation
 I $G(CVX)="" Q "0^INVALID CVX"
 I $G(LOT)="" Q "0^INVALID LOT"
 I $G(MVX)="" Q "0^INVALID MVX"
 S MSG=$G(MSG)
 S USER=$G(USER) S:USER="" USER=DUZ
 ;
 NEW ASUFAC,STR,PNAME
 ;
 S ASUFAC=$$ASUFAC()
 ;
 ;Get the user
 S PNAME=$$GET1^DIQ(200,USER_",",.01,"E")
 ;
 ;Assemble the output
 ;Format("|" delimited):
 ;1 - ASUFAC
 ;2 - User Name
 ;3 - CVX Code
 ;4 - LOT #
 ;5 - MVX
 ;6 - Message
 ;
 S STR=ASUFAC_"|"_PNAME_"|"_CVX_"|"_LOT_"|"_MVX_"|"_MSG
 ;
 ;Log the entry
 D LOG^BSTSAPIL("BILOT",42,"BILOT",$$TFRMT(STR))
 ;
 ;Transmit now
 D PLOG^BSTSAPIL
 ;
 Q 1
 ;
CHKLOT(RET,ICVX,ILOT,CALL) ;EP Check if passed in CVX/Lot# is valid
 ;
 ;Call will return whether passed in CVX/Lot# combination is valid
 ;
 ;Input variables:
 ;   ICVX (required): CVX code to look up
 ;   ILOT (required): Lot# to look up
 ;   CALL (optional): 1 to look locally first (default is remote call first)
 ;
 ;Return value:
 ;RET = Valid^Mfg^Date
 ; where: Valid = 1 - Valid CVX/Lot# combination, 0 - Invalid CVX/Lot# combination
 ;          Mfg = If valid, the manufacturer
 ;         Date = If valid, the date
 ;
 ;Function return:
 ; 0 - No result [DTS call failed and no local result on file]
 ; 1 - Local result returned
 ; 2 - Successful remote (DTS) call [could be with no result]
 ;
 K RET S RET=""
 S ICVX=$G(ICVX) I ICVX="" S RET=0 Q 0
 S ILOT=$G(ILOT) I ILOT="" S RET=0 Q 0
 S CALL=$G(CALL)
 ;
 NEW STS
 ;
 ;Parameter set to look local first
 I CALL D LLCHECK(.RET,ICVX,ILOT) I +RET Q 1
 ;
 ;If no local first check (or local didn't return result, make DTS call)
 S STS=$$RLCHECK(.RET,ICVX,ILOT) I +STS=2 Q 2
 ;
 ;No result (DTS call failed and already looked local and could not find result)
 I CALL S RET=0 Q 0
 ;
 ;Return local results
 D LLCHECK(.RET,ICVX,ILOT) I +RET Q 1
 ;
 ;No result found in DTS or local
 S RET=0
 ;
 Q 0
 ;
CVX(RET,CALL,UPDATE) ;EP Return a list of valid CVX codes
 ;
 ;Call to retrieve list of valid CVX codes
 ;
 ;Input variables:
 ;   CALL (optional): 1 to look locally first (default is remote call),
 ;                    if UPDATE is set remote call will always be made
 ; UPDATE (optional): 1 to update local data
 ;
 ;Return array:
 ;RET(CVX)="" - Array of valid CVX codes
 ;
 ;Function return:
 ; 0 - No results [DTS call failed and no local results on file]
 ; 1 - Local results returned
 ; 2 - Successful remote (DTS) call
 ;
 S CALL=$G(CALL)
 S UPDATE=+$G(UPDATE)
 ;
 ;If an update, always perform DTS lookup
 I UPDATE S CALL=""
 ;
 NEW STS
 ;
 K RET
 ;
 ;Look for results locally
 I CALL D LCVX(.RET) I $O(RET(""))'="" Q 1
 ;
 ;If not local (or local didn't return results, make DTS call)
 S STS=$$RCVX(.RET,UPDATE) I +STS=2 Q 2
 ;
 ;No results (DTS call failed and already looked local and could not find results)
 I CALL Q 0
 ;
 ;Return local results
 D LCVX(.RET) I $O(RET(""))'="" Q 1
 ;
 ;No results found in DTS or local
 Q 0
 ;
LIST(RET,ICVX,CALL,UPDATE) ;EP Return a list of valid Lots
 ;
 ;Call to retrieve list of valid CVX/Lot#s
 ;
 ;Input variables:
 ;   ICVX (optional): Return lots for CVX value (blank for all CVX)
 ;   CALL (optional): 1 to look locally first (default is remote call),
 ;                    if UPDATE is set remote call will always be made
 ; UPDATE (optional): 1 to update local data
 ;
 ;Return array:
 ;RET("L",LOT#,CVX)=Mfg^Date
 ;RET("C",CVX,LOT#)=Mfg^Date
 ;
 ;Function return:
 ; 0 - No results [DTS call failed and no local results on file]
 ; 1 - Local results returned
 ; 2 - Successful remote (DTS) call
 ;
 S CALL=$G(CALL)
 S ICVX=$G(ICVX)
 S UPDATE=+$G(UPDATE)
 ;
 ;If an update, always perform DTS lookup
 I UPDATE S CALL=""
 ;
 NEW STS
 ;
 K RET
 ;
 ;Look for results locally
 I CALL D LLIST(.RET,ICVX) I $O(RET(""))'="" Q 1
 ;
 ;If not local (or local didn't return results, make DTS call)
 S STS=$$RLIST(.RET,ICVX,UPDATE) I +STS=2 Q 2
 ;
 ;No results (DTS call failed and already looked local and could not find results)
 I CALL Q 0
 ;
 ;Return local results
 D LLIST(.RET,ICVX) I $O(RET(""))'="" Q 1
 ;
 ;No results found in DTS or local
 Q 0
 ;
RCVX(RET,UPDATE) ;Return list of CVX codes from DTS server
 ;
 NEW STS,EXEC,TRY,RESULT
 ;
 ;If UPDATE set to 1 update local data
 S UPDATE=$G(UPDATE)
 ;
 ;Clear scratch global
 K ^TMP("BI_DTS",$J)
 ;
 F TRY=1:1:3 S STS="",EXEC="S STS=##class(BI.DTS.WebServiceCalls).GetCVX(.RESULT)" X EXEC Q:+STS
 ;
 ;Look for results from DTS call
 I +STS D  Q 2
 . ;
 . ;If update set up local cache definition
 . I UPDATE D
 .. NEW X1,X2,X,%
 .. D NOW^%DTC
 .. S X1=DT,X2=60 D C^%DTC
 .. S ^XTMP("BI_DTS",0)=X_U_DT_U_"BI - DTS CVX/LOT# Information"
 .. ;
 .. ;Clear old values
 .. K ^XTMP("BI_DTS","CVX")
 .. ;
 .. ;Insert run timestamp
 .. S ^XTMP("BI_DTS","CVX")=%
 . ;
 . ;Loop through list from DTS and process
 . NEW CNT,CVX
 . S CNT="" F  S CNT=$O(^TMP("BI_DTS",$J,CNT)) Q:CNT=""  D
 .. S CVX=$G(^TMP("BI_DTS",$J,CNT)) Q:CVX=""
 .. S RET(CVX)=""
 .. ;
 .. ;Update local cache
 .. I UPDATE S ^XTMP("BI_DTS","CVX",CVX)=""
 ;
 ;Call failed
 Q 0
 ;
LCVX(RET) ;Return list of CVX codes stored locally
 ;
 NEW CVX
 ;
 S CVX="" F  S CVX=$O(^XTMP("BI_DTS","CVX",CVX)) Q:CVX=""  S RET(CVX)=""
 ;
 Q
 ;
RLIST(RET,ICVX,UPDATE) ;Return list of CVX/Lot#s from DTS server
 ;
 NEW STS,EXEC,TRY,RESULT
 ;
 ;If UPDATE set to 1 update local data
 S UPDATE=$G(UPDATE)
 ;
 ;Clear scratch global
 K ^TMP("BI_DTS",$J)
 ;
 F TRY=1:1:3 S STS="",EXEC="S STS=##class(BI.DTS.WebServiceCalls).GetLotList(.RESULT)" X EXEC Q:+STS
 ;
 ;Look for results from DTS call
 I +STS D  Q 2
 . NEW CNT
 . ;
 . ;If update set up local cache definition
 . I UPDATE D
 .. NEW X1,X2,X,%
 .. D NOW^%DTC
 .. S X1=DT,X2=60 D C^%DTC
 .. S ^XTMP("BI_DTS",0)=X_U_DT_U_"BI - DTS CVX/LOT# Information"
 .. ;
 .. ;Clear old values
 .. K ^XTMP("BI_DTS","LOT")
 .. ;
 .. ;Set run timestamp
 .. S ^XTMP("BI_DTS","LOT")=%
 . ;
 . ;Loop through results
 . S CNT="" F  S CNT=$O(^TMP("BI_DTS",$J,CNT)) Q:CNT=""  D
 .. NEW NODE,CVX,LOT,MFG,EDATE,X,Y,CCVX
 .. S NODE=$G(^TMP("BI_DTS",$J,CNT))
 .. S MFG=$P(NODE,"|")  ;Mfg
 .. S CVX=$P(NODE,"|",2)  ;CVX
 .. S LOT=$P(NODE,"|",3)  ;Lot
 .. S EDATE="",X=$P(NODE,"|",4) D ^%DT S:Y'=-1 EDATE=Y
 .. I LOT]"",CVX]"" D
 ... ;
 ... ;Save updates
 ... I UPDATE D
 .... S ^XTMP("BI_DTS","LOT",CVX,LOT)=MFG_U_EDATE
 ... ;
 ... ;Filter output on optional input CVX
 ... I $G(ICVX)]"",ICVX'=CVX Q
 ... ;
 ... ;Define results
 ... S RET("L",LOT,CVX)=MFG_U_EDATE
 ... S RET("C",CVX,LOT)=MFG_U_EDATE
 ... Q
 .. Q
 . Q
 ;
 Q 0
 ;
LLIST(RET,ICVX) ;Return list of CVX codes stored locally
 ;
 ;Loop through local cache
 S CVX="" F  S CVX=$O(^XTMP("BI_DTS","LOT",CVX)) Q:CVX=""  D
 . ;
 . ;Quit if not passed in CVX
 . I ICVX]"",CVX'=ICVX Q
 . ;
 . ;Return Lot#
 . S LOT="" F  S LOT=$O(^XTMP("BI_DTS","LOT",CVX,LOT)) Q:LOT=""  D
 .. S NODE=$G(^XTMP("BI_DTS","LOT",CVX,LOT))
 .. S RET("L",LOT,CVX)=NODE
 .. S RET("C",CVX,LOT)=NODE
 ;
 Q
 ;
RLCHECK(RET,ICVX,ILOT) ;Perform DTS call to see if CVX/Lot# are valid
 ;
 NEW STS,EXEC,TRY,RESULT,PARMS
 ;
 S RET=""
 ;
 I $G(ICVX)="" S RET=0 Q 0
 I $G(ILOT)="" S RET=0 Q 0
 ;
 ;Clear scratch global
 K ^TMP("BI_DTS",$J)
 ;
 S PARMS("CVX")=ICVX
 S PARMS("LOT")=ILOT
 ;
 F TRY=1:1:3 S STS="",EXEC="S STS=##class(BI.DTS.WebServiceCalls).CheckCVXLot(.PARMS,.RESULT)" X EXEC Q:+STS
 ;
 ;Look for result from DTS call - should be only one
 I +STS D  Q 2
 . NEW CNT
 . S CNT="" F  S CNT=$O(^TMP("BI_DTS",$J,CNT)) Q:CNT=""  D  Q:RET]""
 .. NEW NODE,CVX,LOT,MFG,EDATE,X,Y,X1,X2
 .. S NODE=$G(^TMP("BI_DTS",$J,CNT))
 .. S MFG=$P(NODE,"|")  ;Mfg
 .. S CVX=$P(NODE,"|",2)  ;CVX
 .. S LOT=$P(NODE,"|",3)  ;Lot
 .. S EDATE="",X=$P(NODE,"|",4) D ^%DT S:Y'=-1 EDATE=Y
 .. I LOT]"",CVX]"" D
 ... S RET="1"_U_MFG_U_EDATE
 ... ;
 ... ;Update local cache definition for entry
 ... S X1=DT,X2=60 D C^%DTC
 ... S ^XTMP("BI_DTS",0)=X_U_DT_U_"BI - DTS CVX/LOT# Information"
 ... S ^XTMP("BI_DTS","LOT",CVX,LOT)=MFG_U_EDATE
 ... Q
 .. Q
 . ;
 . ;Entry found
 . Q:RET]""
 . ;
 . ;No entry found
 . S RET=0
 ;
 ;DTS call failed
 ;
 Q 0
 ;
LLCHECK(RET,ICVX,ILOT) ;Return list of CVX codes stored locally
 ;
 I $G(ICVX)="" S RET=0 Q
 I $G(ILOT)="" S RET=0 Q
 ;
 NEW NODE
 ;
 ;Retrieve entry
 S NODE=$G(^XTMP("BI_DTS","LOT",ICVX,ILOT))
 ;
 I NODE]"" S RET="1^"_NODE Q
 S RET=0
 Q
 ;
TASK ;EP - Front end for BI DTS local data compile process
 ;
 ;This tag is called by the ADS SITE INFORMATION EXPORT TASK option
 ;
 ;It runs BI API calls in update mode which will update the local
 ;CVX code list and available Lot#s
 ;
 NEW RET,STS
 ;
 ;Update the local CVX code list
 S STS=$$CVX^BIAPIDTS(.RET,,1)
 ;
 ;Update the local Lot# code list
 S STS=$$LIST^BIAPIDTS(.RET,,,1)
 ;
 Q
 ;
ASUFAC() ;Get site ASUFAC
 ;
 NEW RSIEN,RSLOC,ASUFAC
 ;
 ;Get location from RPMS SITE
 S RSIEN=$O(^AUTTSITE(0)) I RSIEN="" Q ""
 S RSLOC=$$GET1^DIQ(9999999.39,RSIEN_",",.01,"I") I RSLOC="" Q ""
 ;
 ;Get site ASUFAC and DBID
 S ASUFAC=$$GET1^DIQ(9999999.06,RSLOC_",",.12,"E")
 Q ASUFAC
 ;
TFRMT(MSG) ;Convert message so it can be sent to DTS
 ;
 ;The DTS web service call cannot accept messages with apostrophes. Any apostrophe found
 ;in a message must have an additional one added to it so it won't confuse the stored
 ;procedure logic
 ;
 NEW RET,CHR,VAL
 ;
 S RET=""
 ;
 F CHR=1:1:$L(MSG) S VAL=$E(MSG,CHR) D
 . I VAL'="'" S RET=RET_VAL Q
 . ;
 . ;Apostrophe found - need to add another (if not already added)
 . I $E(MSG,CHR+1)="'" S RET=RET_"'" Q   ;Already have two (the next character)
 . I $E(RET,$L(RET))="'" S RET=RET_"'" Q   ;Already have two (the last character)
 . ;
 . ;No double ' - need to add
 . S RET=RET_"''" Q
 ;
 Q RET
