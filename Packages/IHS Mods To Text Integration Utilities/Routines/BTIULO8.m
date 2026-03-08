BTIULO8 ;IHS/ITSC/LJF - IHS OBJECTS ADDED IN PATCHES;22-Sep-2021 13:43;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1002,1006,1012,1013,1024**;NOV 04, 2004;Build 3
 ;1006 Updated family history object
 ;
TODAYRAD(PAT,PROV) ;EP; returns all radiology exams taken today;PATCH 1002 new code
 ; If PROV=1, include providers (ordering and encounter)
 NEW VDT,END,VISIT,COUNT,TIUX,LINE,TIUA
 K ^TMP("BTIULO",$J)
 ;
 ; for each visit patient had today, find all exams
 S VDT=9999999-DT,END=VDT_".2359"
 F  S VDT=$O(^AUPNVSIT("AA",PAT,VDT)) Q:'VDT  Q:VDT>END  D
 . S VISIT=0 F  S VISIT=$O(^AUPNVSIT("AA",PAT,VDT,VISIT)) Q:'VISIT  D
 . . S TIUX=0,LINE="" F  S TIUX=$O(^AUPNVRAD("AD",VISIT,TIUX)) Q:'TIUX  D
 . . . K TIUA D ENP^XBDIQ1(9000010.22,TIUX,".01;.05;1202;1204","TIUA(")
 . . . S LINE=TIUA(.01)                                     ;exam name
 . . . I TIUA(.05)]"" S LINE=LINE_" ("_TIUA(.05)_")"        ;abnormal vs normal
 . . . I +$G(PROV)&(TIUA(1202)]"") S LINE=LINE_" ["_TIUA(1202)_"/"_TIUA(1204)_"]"   ;providers
 . . . S COUNT=$G(COUNT)+1 S ^TMP("BTIULO",$J,COUNT,0)=LINE
 ;
 I '$D(^TMP("BTIULO",$J)) Q "No Radiology Exams Found for Today"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
TODAYIMM(PAT,PROV) ;EP; returns all immunizations given today;PATCH 1002 new code
 NEW VDT,END,VISIT,COUNT,TIUX,LINE,TIUA
 K ^TMP("BTIULO",$J)
 ;
 ; for each visit patient had today, find all immunizations
 S VDT=9999999-DT,END=VDT_".2359"
 F  S VDT=$O(^AUPNVSIT("AA",PAT,VDT)) Q:'VDT  Q:VDT>END  D
 . S VISIT=0 F  S VISIT=$O(^AUPNVSIT("AA",PAT,VDT,VISIT)) Q:'VISIT  D
 . . S TIUX=0,LINE="" F  S TIUX=$O(^AUPNVIMM("AD",VISIT,TIUX)) Q:'TIUX  D
 . . . K TIUA D ENP^XBDIQ1(9000010.11,TIUX,".01;.04;1204","TIUA(")
 . . . S LINE=TIUA(.01)                                              ;immunization name
 . . . I TIUA(.04)]"" S LINE=LINE_" ("_TIUA(.04)_")"                 ;series
 . . . I +$G(PROV)&(TIUA(1204)]"") S LINE=LINE_" ["_TIUA(1204)_"]"   ;encounter provider
 . . . S COUNT=$G(COUNT)+1 S ^TMP("BTIULO",$J,COUNT,0)=LINE
 ;
 I '$D(^TMP("BTIULO",$J)) Q "No Immunizations Found for Today"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
FAMHX(PAT,DATE) ;EP; returns multi-line listing of patient's family history;PATCH 1002 new code
 ; If DATE=1, return date each item obtained
 NEW COUNT,TIUX,TIUY,TIUZ,TIUA,LINE,TIUA,REL,RELIEN,RELNAME,CODE
 K ^TMP("BTIULO",$J)
 S COUNT=0
 ; for this patient, find all family history entries
 S REL=0,LINE="" F  S REL=$O(^AUPNFHR("AA",PAT,REL)) Q:REL=""  D
 .S TIUX=0 F  S TIUX=$O(^AUPNFHR("AA",PAT,REL,TIUX)) Q:TIUX=""  D
 ..D ENP^XBDIQ1(9000014.1,TIUX,".01:.06","TIUZ(")
 ..S LINE=TIUZ(.01)_"["_TIUZ(.03)_"] "_TIUZ(.04)
 ..S COUNT=$G(COUNT)+1 S ^TMP("BTIULO",$J,COUNT,0)=LINE
 ..S LINE=""
 ..I TIUZ(.05)'="" S LINE="     Deceased: "_TIUZ(.05)
 ..I TIUZ(.06)'="" S LINE=LINE_" Cause of death: "_TIUZ(.06)
 ..I LINE'="" S COUNT=$G(COUNT)+1 S ^TMP("BTIULO",$J,COUNT,0)=LINE
 ..S TIUY=0 F  S TIUY=$O(^AUPNFH("AE",TIUX,TIUY)) Q:'TIUY  D
 ...D ENP^XBDIQ1(9000014,TIUY,".01:.14","TIUA(")
 ...S CODE=TIUA(.14) I CODE="" S CODE=TIUA(.01)    ;SNOMED CODE patch 1012
 ...S LINE="     DX: "_TIUA(.04)_" ["_CODE_"]"     ;prov narrative Patch 1012[SNOMED code]
 ...I $G(DATE) S LINE=LINE_" - "_TIUA(.03)   ;date noted
 ...S COUNT=$G(COUNT)+1 S ^TMP("BTIULO",$J,COUNT,0)=LINE
 ;
 I '$D(^TMP("BTIULO",$J)) Q "No Family History Found for Patient"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
LASTCOV(DFN,TIUCOVIM,TIUCNT,TIUDATE,BRIEF) ;EP; returns last # of of a specific Covid Immunization
 ; TIUCOVIM  = Immunization codes separated by ^ then generic name at end after ;
 ;             example TIUIMM="202^207^208^213;Covid Vax"
 ; TIUCNT    = # of results to return
 ; TIUDATE=1 = return date immunization taken
 ; IHS/CIA/MGH Parameter BRIEF added to remove caption from display
 N I,X,D,TIUDE,TIUANS,TIUCODE,TIUDATA,DATE,CNT,ARR,SHRTNAME
 Q:'$G(DFN) ""  Q:'$G(TIUCOVIM) ""
 ; -- set all codes sent into array
 F I=1:1 S X=$P(TIUCOVIM,U,I) Q:'X  S TIUCODE(+X)=""
 ; -- set data elements to return
 F I=4,25,56 S TIUDE(I)=""
 ; -- get imm hx from imm app
 D IMMHX^BIRPC(.TIUDATA,DFN,.TIUDE)
 ; -- evaluate results
 S D="|" F I=1:1 S X=$P(TIUDATA,U,I) Q:X=""  D
 .Q:$P(X,D)'="I"                           ;not immunization
 .Q:'$D(TIUCODE($P(X,D,3)))                ;not in imm set sent
 .S DATE=$P(X,D,4),ARR(DATE,$P(X,D,2))=""
 K ^TMP("BTIULO",$J)
 ; loop thru array backwards to display most recent first
 S (CNT,DATE)="" F  S DATE=$O(ARR(DATE),-1) Q:'DATE!(CNT'<TIUCNT)  D
 .S SHRTNAME="" F  S SHRTNAME=$O(ARR(DATE,SHRTNAME)) Q:SHRTNAME=""!(CNT'<TIUCNT)  D
 ..S CNT=CNT+1,^TMP("BTIULO",$J,CNT,0)=SHRTNAME_$S($G(TIUDATE):" : "_$$FMTE^XLFDT(DATE),1:"")
 ; -- return results
 I '$D(^TMP("BTIULO",$J)) S ^TMP("BTIULO",$J,1,0)="No Covid Immunization Found"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
