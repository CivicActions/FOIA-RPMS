BSTSAPIL ;GDIT/HS/BEE-Standard Terminology Activity Logging ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**1,3,5,6,7**;Dec 01, 2016;Build 8
 ;
 Q
 ;
SELSTR ;Return list of concept selections
 ;
 NEW FRDT,TODT,ESERV,SRV,SIEN,SNUM,RNAME,EXEC,ENSPACE,BSTSWS,SERVERS
 NEW SPACE,STS,POP,CT,BSTSRPT,ICNT,SRMAX,SCNT
 ;
 S $P(SPACE," ",80)=" "
 ;
 W !!,"DISPLAY BSTS SELECTED CONCEPTS"
 ;
 ;Get From Date
 S FRDT=$$DATE^BSTSDSP("From Date","T-7") Q:'FRDT
 ;
 ;Get To Date
 S TODT=$$DATE^BSTSDSP("To Date","T",FRDT) Q:'TODT
 ;
 ;Get the namespace
 S ENSPACE=$$GNAM() Q:'ENSPACE
 ;
 ;Get maximum search results to display
 S SRMAX=$$SMAX^BSTSSTA() Q:'SRMAX
 ;
 ;S ENSPACE=36
 ;
 ;Get the server information
 S ESERV=$$WSERVER^BSTSWSV(.SERVERS,"") Q:'ESERV
 S SRV=$O(SERVERS(0)) Q:'SRV
 M BSTSWS=SERVERS(SRV)
 ;
 ;Get the site
 S SIEN=$O(^AUTTSITE(0)) Q:'+SIEN
 S SNUM=$$GET1^DIQ(9999999.39,SIEN_",",.01,"I") Q:SNUM=""
 ;
 ;Get search results
 S BSTSWS("FRDT")=$P($$FMTE^BSTSUTIL(FRDT),":",1,2)_" 00:00"
 S BSTSWS("TODT")=$P($$FMTE^BSTSUTIL(TODT),":",1,2)_" 23:59"
 S BSTSWS("ENSPACE")=ENSPACE
 S BSTSWS("ESITE")=SNUM
 S BSTSWS("EPROD")=$$PROD^XUPROD()
 S RNAME="",EXEC="S RNAME=$"_"ZNSPACE" X EXEC
 S BSTSWS("RNAME")=RNAME
 ;
 ;Pull the search list
 S STS=$$SLCNT^BSTSCMCL(.BSTSWS,.RES)
 ;
 ;Get device
 W !
 S POP="" D ^%ZIS I POP Q
 U IO
 ;
 ;Display results
 S (SCNT,CT)=0,CT=CT+1,BSTSRPT(CT)="BSTS CONCEPT SELECTION HISTORY: "_$$FMTE^XLFDT(FRDT,"2ZD")_" TO "_$$FMTE^XLFDT(TODT,"2ZD")_" - "_SRMAX_" MOST FREQUENTLY USED"
 S CT=CT+1,BSTSRPT(CT)=" "
 S ICNT="" F  S ICNT=$O(^TMP("BSTSCMCL",$J,ICNT)) Q:ICNT=""  D  I (SCNT+1)>SRMAX Q
 . ;
 . NEW NODE,CONCID,DESCID,SUBSET,CTERM,COUNT
 . ;
 . S NODE=$G(^TMP("BSTSCMCL",$J,ICNT))
 . S CONCID=$P($P(NODE,U),"|")
 . S DESCID=$P($P(NODE,U),"|",3)
 . S SUBSET=$P($P(NODE,U),"|",2)
 . S CTERM="" S CTERM=$P($$DESC^BSTSAPI(DESCID_U_ENSPACE),U,2)
 . I CTERM="" S CTERM=$P($$CONC^BSTSAPI(CONCID_U_ENSPACE),U,4)
 . S COUNT=$P(NODE,U,2) S:COUNT COUNT=SPACE_COUNT,COUNT=$E(COUNT,$L(COUNT)-5,$L(COUNT))
 . S CT=CT+1,BSTSRPT(CT)="TERM: "_$E(CTERM_SPACE,1,58)_" COUNT: "_COUNT
 . S CT=CT+1,BSTSRPT(CT)="CONCID: "_$E(CONCID_SPACE,1,16)_$S(SUBSET]"":" SUBSET: "_SUBSET,1:"")
 . S CT=CT+1,BSTSRPT(CT)=" "
 . S SCNT=SCNT+1
 ;
 ;Check for no results
 I SCNT=0 D
 . S CT=CT+1,BSTSRPT(CT)="No results found.  This could be because SELECTION LOGGING is disabled or the"
 . S CT=CT+1,BSTSRPT(CT)="report date range is too far in the past and the selection history has been"
 . S CT=CT+1,BSTSRPT(CT)="purged from the DTS server. *Note also that the current day's selection"
 . S CT=CT+1,BSTSRPT(CT)="history does not get sent until later in the evening so it will not be"
 . S CT=CT+1,BSTSRPT(CT)="immediately available."
 ;
 S CT=CT+1,BSTSRPT(CT)=" "
 S CT=CT+1,BSTSRPT(CT)="<END OF REPORT>"
 ;
 ;Display the report
 D EN^DDIOL(.BSTSRPT)
 ;
 ;Close the device
 D ^%ZISC
 ;
 I $D(IOST),IOST["C-",'$D(DIRUT),'$D(DTOUT) D
 . NEW DIR,X,Y
 . W ! S DIR(0)="E",DIR("A")="Press 'Return to continue'" D ^DIR
 ;
 Q
 ;
SEARCH(BSTSWS) ;Log search strings
 ;
 ;If search logging is enabled, this tag puts the search on a queue
 ;to send to DTS
 ;
 ;Quit if search logging disabled
 Q:'$$LENABLE()
 ;
 NEW %
 ;
 D NOW^%DTC
 ;
 ;Log the entry
 D LOG("SRCH",$G(BSTSWS("NAMESPACEID")),"SEARCH",$G(BSTSWS("SEARCH")))
 ;
 Q
 ;
STATUS() ;Log daily status message
 ;
 NEW CDSET,%,DOW
 ;
 ;Get day of week - Send on Monday
 D NOW^%DTC
 S DOW=$$DOW^XLFDT(%,1)
 I DOW'=1 Q
 ;
 F CDSET=36,1552,5180,32771,32772,32773,32774,32777,32779,32780 D
 . ;
 . NEW CDIEN,VRSN
 . ;
 . S CDIEN=$O(^BSTS(9002318.1,"B",CDSET,"")) Q:'CDIEN
 . ;
 . ;Record version
 . S VRSN=$$GET1^DIQ(9002318.1,CDIEN_",",.04,"E") D LOG("VRSN",CDSET,"VERSION",VRSN)
 ;
 Q
 ;
CENABLE() ;Return TRUE if ENABLE concept selection logging is on
 ;
 ;GDIT/HS/BEE;FEATURE#111545;BSTS*2.0*7;Remove logging
 Q 0
 ;
 NEW PRI,PIEN,WIEN
 ;
 ;Get first priority entry
 S PRI=$O(^BSTS(9002318,"C","")) Q:'PRI 0
 S PIEN=$O(^BSTS(9002318,"C",PRI,1,""))
 ;
 ;Determine whether search logging is on
 S WIEN=$P($G(^BSTS(9002318,1,1,PIEN,0)),U) Q:'WIEN 0
 Q $$GET1^DIQ(9002318.2,WIEN_",",4.05,"I")
 ;
LENABLE() ;Return TRUE if ENABLE SEARCH LOGGING is on
 ;
 ;GDIT/HS/BEE;FEATURE#111545;BSTS*2.0*7;Remove logging
 Q 0
 ;
 NEW PRI,PIEN,WIEN
 ;
 ;Get first priority entry
 S PRI=$O(^BSTS(9002318,"C","")) Q:'PRI 0
 S PIEN=$O(^BSTS(9002318,"C",PRI,1,""))
 ;
 ;Determine whether search logging is on
 S WIEN=$P($G(^BSTS(9002318,1,1,PIEN,0)),U) Q:'WIEN 0
 Q $$GET1^DIQ(9002318.2,WIEN_",",.16,"I")
 ;
PLOG() ;Process log entries
 ;
 ;Quit if link is down
 I '$$DTSON^BSTSUTL0() Q
 ;
 ;GDIT/HS/BEE;02/27/2024;FEATURE#87021;Add locking logic to prevent more than one process from running at a time
 ;See if the process is already running - Quit if it is
 L +^XTMP("BSTSAPIL",1):5 E  Q
 ;
 ;GDIT/HS/BEE;02/27/2024;FEATURE#87022;Add logic to stop the process if a flag is set remotely by another process
 ;Clear out the abort flag
 K ^XTMP("BSTSPROCQ","PLOG_ABORT")
 ;
 NEW LIEN,QUIT
 ;
 ;Process each log entry
 ;GDIT/HS/BEE;02/27/2024;FEATURE#87022;Add logic to stop the process if a flag is set remotely by another process
 ;S LIEN="" F  S LIEN=$O(^XTMP("BSTSPROCQ","L",LIEN)) Q:LIEN=""  D
 S QUIT=0,LIEN="" F  S LIEN=$O(^XTMP("BSTSPROCQ","L",LIEN)) Q:LIEN=""  D  Q:$G(^XTMP("BSTSPROCQ","PLOG_ABORT"))  Q:QUIT
 . ;
 . NEW ENODE,ETYPE,ENAME,EVALUE,ENSPACE,EDTTM,BSTSWS,SRV,SERVERS,SITE,SIEN,RNAME,EXEC,SNUM
 . NEW RES,STS,ESERV
 . ;
 . ;Event Type
 . S ENODE=$G(^XTMP("BSTSPROCQ","L",LIEN))
 . S ETYPE=$P(ENODE,U) Q:ETYPE=""
 . ;
 . ;Event Date/Time
 . S EDTTM=$P(ENODE,U,2) Q:EDTTM=""
 . S EDTTM=$P($$FMTE^BSTSUTIL(EDTTM),":",1,2) Q:EDTTM=""
 . ;
 . ;Namespace
 . S ENSPACE=$P(ENODE,U,3) S:ENSPACE="" ENSPACE="null"
 . ;
 . ;Event Name
 . S ENAME=$P(ENODE,U,4) S:ENAME="" ENAME="null"
 . ;
 . ;Event Value
 . S EVALUE=$$ESC^BSTSUTL0($P(ENODE,U,5)) S:EVALUE="" EVALUE="null"
 . ;
 . ;Get the server information
 . S ESERV=$$WSERVER^BSTSWSV(.SERVERS,"") Q:'ESERV
 . S SRV=$O(SERVERS(0)) Q:'SRV
 . M BSTSWS=SERVERS(SRV)
 . ;
 . ;Get the site
 . S SIEN=$O(^AUTTSITE(0)) Q:'+SIEN
 . S SITE=$$GET1^DIQ(9999999.39,SIEN_",",.01,"E") Q:SIEN=""
 . S SNUM=$$GET1^DIQ(9999999.39,SIEN_",",.01,"I") Q:SNUM=""
 . ;
 . ;Log the DTS event
 . S BSTSWS("ETYPE")=ETYPE
 . S BSTSWS("EDTTM")=EDTTM
 . S BSTSWS("ENSPACE")=ENSPACE
 . S BSTSWS("ENAME")=ENAME
 . S BSTSWS("EVALUE")=EVALUE
 . S BSTSWS("ESITE")=SITE_"|"_SNUM
 . S BSTSWS("EPROD")=$$PROD^XUPROD()
 . S RNAME="",EXEC="S RNAME=$"_"ZNSPACE" X EXEC
 . S BSTSWS("RNAME")=RNAME
 . ;
 . ;Log the event
 . S STS=$$ELOG^BSTSCMCL(.BSTSWS,.RES)
 . ;
 . ;If success, remove entry
 . I +STS=1 K ^XTMP("BSTSPROCQ","L",LIEN)
 . ;
 . ;If failure quit
 . I 'STS S QUIT=1
 ;
 ;GDIT/HS/BEE;02/27/2024;FEATURE#87022;Add logic to stop the process if a flag is set remotely by another process
 ;Clear out the abort flag
 K ^XTMP("BSTSPROCQ","PLOG_ABORT")
 ;
 ;GDIT/HS/BEE;02/27/2024;FEATURE#87021;Add locking logic to prevent more than one process from running at a time
 ;Unlock to show process finished
 L -^XTMP("BSTSAPIL",1)
 ;
 Q
 ;
LOG(ETYPE,ENSPACE,ENAME,EVALUE) ;Put entry on the log queue
 ;
 ;Must have log event type
 I $G(ETYPE)="" Q
 ;
 NEW %
 ;
 ;Get the current date/time
 D NOW^%DTC
 ;
 ;Log the entry
 L +^XTMP("BSTSPROCQ","L"):2 E  Q
 S ^XTMP("BSTSPROCQ","L")=$G(^XTMP("BSTSPROCQ","L"))+1
 S ^XTMP("BSTSPROCQ","L",^XTMP("BSTSPROCQ","L"))=ETYPE_U_%_U_$G(ENSPACE)_U_$G(ENAME)_U_$G(EVALUE)
 L -^XTMP("BSTSPROCQ","L")
 ;
 Q
 ;
LGHST ;Return list of DTS log history
 ;
 NEW FRDT,TODT,ESERV,SRV,SIEN,SNUM,RNAME,EXEC,ENSPACE,BSTSWS,SERVERS
 NEW SPACE,STS,POP,CT,BSTSRPT,ICNT,SRMAX,SCNT,DIRUT,DTOUT
 ;
 S $P(SPACE," ",80)=" "
 ;
 W !!,"DISPLAY BSTS DTS LOG HISTORY"
 ;
 ;Get From Date
 S FRDT=$$DATE^BSTSDSP("From Date","T-7") Q:'FRDT
 ;
 ;Get To Date
 S TODT=$$DATE^BSTSDSP("To Date","T",FRDT) Q:'TODT
 ;
 ;Get maximum search results to display
 S SRMAX=$$SMAX^BSTSSTA() Q:'SRMAX
 ;
 S ENSPACE=36
 ;
 ;Get the server information
 S ESERV=$$WSERVER^BSTSWSV(.SERVERS,"") Q:'ESERV
 S SRV=$O(SERVERS(0)) Q:'SRV
 M BSTSWS=SERVERS(SRV)
 ;
 ;Get the site
 S SIEN=$O(^AUTTSITE(0)) Q:'+SIEN
 S SNUM=$$GET1^DIQ(9999999.39,SIEN_",",.01,"I") Q:SNUM=""
 ;
 ;Get search results
 S BSTSWS("FRDT")=$P($$FMTE^BSTSUTIL(FRDT),":",1,2)_" 00:00"
 S BSTSWS("TODT")=$P($$FMTE^BSTSUTIL(TODT),":",1,2)_" 23:59"
 S BSTSWS("ENSPACE")=ENSPACE
 S BSTSWS("ESITE")=SNUM
 S BSTSWS("EPROD")=$$PROD^XUPROD()
 S RNAME="",EXEC="S RNAME=$"_"ZNSPACE" X EXEC
 S BSTSWS("RNAME")=RNAME
 ;
 ;Pull the search list
 S STS=$$LHIST^BSTSCMCL(.BSTSWS,.RES)
 ;
 ;Get device
 W !
 S POP="" D ^%ZIS I POP Q
 U IO
 ;
 ;Display results
 S (SCNT,CT)=0,CT=CT+1,BSTSRPT(CT)="BSTS DTS LOG HISTORY: "_$$FMTE^XLFDT(FRDT,"2ZD")_" TO "_$$FMTE^XLFDT(TODT,"2ZD")_" - LATEST "_SRMAX_" EVENTS LOGGED"
 S CT=CT+1,BSTSRPT(CT)=" "
 S CT=CT+1,BSTSRPT(CT)=$E("ID"_SPACE,1,10)_$E("EVENT DATE"_SPACE,1,17)_$E("EVENT TYPE"_SPACE,1,15)_$E("CODESET"_SPACE,1,10)_$E("EVENT NAME"_SPACE,1,12)_$E("VALUE"_SPACE,1,15)
 S CT=CT+1,BSTSRPT(CT)=" "
 S ICNT="" F  S ICNT=$O(^TMP("BSTSCMCL",$J,ICNT)) Q:ICNT=""  D  I (SCNT+1)>SRMAX Q
 . ;
 . NEW NODE
 . ;
 . S NODE=$G(^TMP("BSTSCMCL",$J,ICNT))
 . S CT=CT+1,BSTSRPT(CT)=$E($P(NODE,U)_SPACE,1,10)_$E($$FMTE^XLFDT($$DTS2FMDT^BSTSUTIL($P(NODE,U,3)),"5")_SPACE,1,17)_$E($P(NODE,U,4)_SPACE,1,15)_$E($P(NODE,U,2)_SPACE,1,10)_$E($P(NODE,U,5)_SPACE,1,12)_$E($P(NODE,U,6)_SPACE,1,15)
 . S SCNT=SCNT+1
 ;
 I SCNT D
 . S CT=CT+1,BSTSRPT(CT)=" "
 . S CT=CT+1,BSTSRPT(CT)="EVENT TYPE LEGEND"
 . S CT=CT+1,BSTSRPT(CT)=" "
 . S CT=CT+1,BSTSRPT(CT)="EVENT TYPE     DESCRIPTION"
 . S CT=CT+1,BSTSRPT(CT)="INST           BSTS patch installed"
 . S CT=CT+1,BSTSRPT(CT)="UPDS           Update process started"
 . S CT=CT+1,BSTSRPT(CT)="UPDE           Update process finished"
 . S CT=CT+1,BSTSRPT(CT)="VRSN           Current DTS version"
 ;
 ;Check for no results
 I SCNT=0 D
 . S CT=CT+1,BSTSRPT(CT)="No results found.  This could be because the link to the DTS server"
 . S CT=CT+1,BSTSRPT(CT)="is currently down."
 ;
 S CT=CT+1,BSTSRPT(CT)=" "
 S CT=CT+1,BSTSRPT(CT)="<END OF REPORT>"
 ;
 ;Display the report
 D EN^DDIOL(.BSTSRPT)
 ;
 ;Close the device
 D ^%ZISC
 ;
 I $D(IOST),IOST["C-",'$D(DIRUT),'$D(DTOUT) D
 . NEW DIR,X,Y
 . W ! S DIR(0)="E",DIR("A")="Press 'Return to continue'" D ^DIR
 ;
 Q
 ;
GNAM() ;EP - Prompt the user for verification status
 ;
 NEW DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT,RET
 ;
 W !!,"Enter the codeset to retrieve",!
 S DIR(0)="S^R:RxNorm;S:SNOMED",DIR("B")="SNOMED",DIR("A")="Enter the codeset to return"
 D ^DIR
 S RET=$S(Y="":"",("RS"[Y):Y,1:"")
 S RET=$S(RET="R":1552,1:36)
 Q RET
 ;
PRLOG(TGRTN,START,SCHED,NMIEN,END,TYPE,TASK) ;Log the BSTS process
 ;
 NEW %,NEXT,ENDDT
 ;
 D NOW^%DTC
 ;
 S TGRTN=$G(TGRTN) Q:TGRTN=""
 S START=$G(START) Q:START=""
 S SCHED=$G(SCHED) S:SCHED="" SCHED=START
 S NMIEN=$G(NMIEN) Q:NMIEN=""
 S ENDDT=$G(END) S:ENDDT="" ENDDT=%
 S TYPE=$G(TYPE)
 S TASK=$G(TASK)
 ;
 ;Create local log entry
 L +^XTMP("BSTSPROCQ","CTR"):1 E  Q
 S (NEXT,^XTMP("BSTSPROCQ","CTR"))=$G(^XTMP("BSTSPROCQ","CTR"))+1
 L -^XTMP("BSTSPROCQ","CTR")
 S ^XTMP("BSTSPROCQ","P",NEXT,"RTN")=TGRTN
 S ^XTMP("BSTSPROCQ","P",NEXT,"NMIEN")=NMIEN
 S ^XTMP("BSTSPROCQ","P",NEXT,"TYPE")=TYPE
 S ^XTMP("BSTSPROCQ","P",NEXT,"SCHED")=SCHED
 S ^XTMP("BSTSPROCQ","P",NEXT,"START")=START
 S ^XTMP("BSTSPROCQ","P",NEXT,"TASK")=TASK
 S ^XTMP("BSTSPROCQ","P",NEXT,"END")=ENDDT
 S ^XTMP("BSTSPROCQ","PD",START,NEXT)=""
 S ^XTMP("BSTSPROCQ","PP",TGRTN,NEXT)=""
 ;
 Q
 ;
TEST ;TESTING - Place bad entries on log queue for testing
 ;
 NEW ASCII,XX
 ;
 F ASCII=0:1:255 D
 . S XX="585101|16061|CIHA HOSPITAL|63.04:497521|63.04|ASCIITEST|BAD CHARACTER TESTING CHEM, HEM, TOX, RIA, SER, etc.|497521|"_ASCII_"|"_$C(ASCII)_"PROTCR|51663||4|FEB 29, 2024 22:12:29"
 . D LOG("BSTS",80,"TEST",XX)
 ;
 Q
