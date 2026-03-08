BCCDHIE ;GDIT/HS/AM-CCD HIE subroutines; 04 Aug 2017  11:25 PM
 ;;2.0;CCDA;**1,3**;Aug 12, 2020;Build 139
 ;
 Q
 ;
 ; Upload documents for a given date range
HIEDTRNG ;
 N DIR,Y,X,SDATE,EDATE,EXEC,SUCCESS
 W !!,"This option uploads CCDA documents for a given date/time range. It should be"
 W !,"used only when instructed to by the support team.",!
 ; Verify we have a DUZ
 I '$G(DUZ) W !,"Required FileMan variables are not set up." Q
HIEDTRG1 ; Ask user for start date/time
 S DIR(0)="D^::ERTX",DIR("A")="START DATE/TIME"
 D ^DIR
 I X="^" Q
 I Y=-1 W !,"Invalid timestamp" G HIEDTRG1
 S SDATE=Y
HIEDTRG2 ; Ask user for end date/time
 S DIR(0)="D^::ERTX",DIR("A")="END DATE/TIME"
 D ^DIR
 I X="^" Q
 I Y=-1 W !,"Invalid timestamp" G HIEDTRG2
 S EDATE=Y
 ; Get the documents
 S EXEC="S SUCCESS=##class(BCCD.Xfer.PushQueueDateRange).FindPatients(DUZ,SDATE,EDATE)" X EXEC
 ; Check if there were too many results or if there was an error
 I SUCCESS="-1^Max results" W !!,"The selected date range will result in too many documents. Please enter a",!,"smaller range.",! G HIEDTRG1
 I +SUCCESS=-1 W !!,$P(SUCCESS,"^",2),! G HIEDTRG1
 ; Display message and restart
 W !,SUCCESS," visit"_$S(SUCCESS=1:"",1:"s")_" queued." Q
 ;
 ; Export an HIE document for a given patient and visit
EXPORT ;
 N CCDRUN,AUPNLK,DIC,DFN,ELG,RET,EXEC
 ; Check for required Fileman variables
 I '$G(DUZ)!'$G(DTIME)!'$G(DT)!($G(U)="") W !,"Required Fileman variables are not defined" Q
 I '$G(DUZ(2)) W !,"DUZ(2) must have a value" Q
 ;
 I '$$HASALL^BCCDPAT Q
 S CCDRUN=$O(^BCCDS(90310.02,"B","CCD",""))
 I '$$CHECK^BCCDPAT(CCDRUN) Q
 ;
 ; Get patient
 W !
 S AUPNLK("ALL")=1
 S DIC="^AUPNPAT(",DIC(0)="AEMQZ",DIC("A")="ENTER NAME, SSN, DOB OR CHART#: "
 D SET^AUPNLKZ
 D ^AUPNLK
 D RESET^AUPNLKZ
 I Y<0 Q
 S DFN=+Y
 I 'DFN W !,"Please select one patient" Q
 I '$D(^DPT(DFN)) W !,"No VA patient record" Q
 I '$D(^AUPNPAT(DFN)) W !,"No patient record" Q
 S EXEC="S ELG=##class(BCCD.Xfer.PushQueue).Eligible(DFN)" X EXEC
 I 'ELG W !,"This patient is not eligible for CCD transmission" Q
 ;
 ; Get visit(s)
 S VISIT=$$SELVST(DFN)
 I VISIT="" W !,"No visits for the patient" Q
 ;
 ; Queue the request
 S RET=$$QUEUE("HIE",DFN,VISIT)
 I RET=1 W !!,"A document request has been scheduled for patient ",$P($G(^DPT(DFN,0)),U),!!
 I RET=-1 W !!,"No eligible visit can be found for this patient.  Request could not be queued."
 I RET=0 W !!,"A document request could not be submitted. Please contact Support.",!!
 Q
 ;
 ; Select visit(s) for a given patient
SELVST(DFN) ;
 I '$G(DFN) Q ""
 N VDT,VIEN,VLIST,DIR,DTOUT,DUOUT,DIRUT,DIROUT
 S VLIST=0,DIR(0)=""
 ;
 ; Loop backwards by date. If date changes, go get the next date.
 S VDT="" F  S VDT=$O(^AUPNVSIT("AA",DFN,VDT)) Q:VDT=""  D
 . S VIEN="" F  S VIEN=$O(^AUPNVSIT("AA",DFN,VDT,VIEN)) Q:VIEN=""  D
 .. ; Skip deleted visits
 .. I $$GET1^DIQ(9000010,VIEN_",",".11","I") Q
 .. ;
 .. ; Skip non-provider service categories
 .. S SCAT=$$GET1^DIQ(9000010,VIEN_",",".07","I")
 .. I SCAT'="A",SCAT'="O",SCAT'="S",SCAT'="R",SCAT'="I",SCAT'="H" Q
 .. ;
 .. ; Skip non-eligible visits
 . . I @("'##class(BCCD.Xfer.PushQueue).EligibleVisit(VIEN)") Q
 .. ;
 .. ; Add visits to the list
 .. S VLIST=VLIST+1
 .. S VLIST(VLIST,1)="Visit - "_VIEN_" - "_(26999999-$P(VDT,"."))_"."_$P(VDT,".",2)_$E("0000",1,4-$L($P(VDT,".",2)))_" - "_SCAT
 .. S VLIST(VLIST,2)=VIEN
 .. S DIR(0)=DIR(0)_";"_VLIST_":"_VLIST(VLIST,1)
 ;
 ; If no visits, quit with null
 I VLIST=0 Q ""
 ;
 ; If one visit, quit with that visit
 I VLIST=1 Q $G(VLIST(1,2))
 ;
 ; Prompt for visit and build list
 W !
 N VISITS
 S VISITS=""
 S DIR("A")="VISIT: "
 S DIR(0)="SAO^"_$E(DIR(0),2,99999)
 F  D  Q:Y=""
 . D ^DIR
 . I $D(DIRUT)!(Y="") S Y="" Q
 . I '$D(VLIST(Y)) S Y="" Q
 . I $D(VISITS(Y)) Q
 . S VISITS=VISITS_";"_VLIST(Y,2),VISITS(Y)=""
 I VISITS'="" S VISITS=$E(VISITS,2,99999)
 Q VISITS
 ;
 ; Queue a document request. TYPE, DFN, and VIEN are required for all documents.
 ; PATH is required for DP and CR. FILENAME is required for CR.
QUEUE(TYPE,DFN,VIEN,PATH,FILENAME) ;
 N CCD,AUDIT,SC,I,EXEC,STPCODES
 I $G(TYPE)="" Q 0
 I $G(DFN)="" Q 0
 S EXEC="set STPCODES=$s($g(TYPE)=""HIE"":##class(BCCD.Xfer.CCDMain).#EMPLOYEEHEALTHSTOPCODES,1:"""")" X EXEC
 I $G(VIEN)="" S VIEN=$$PRVVST^BCCDUTIL(DFN,"","","",STPCODES)
 I VIEN="" Q -1
 I $G(TYPE)="HIE",@("'##class(BCCD.Xfer.PushQueue).EligibleVisit(VIEN)") Q -1
 ; Do not set Status until everything else is set. Otherwise, the processor will start
 ; processing an incomplete request.
 S EXEC="set CCD=##class(BCCD.Xfer.Queue).%New()" X EXEC
 S EXEC="set AUDIT=##class(BCCD.Audit.AuditLog).%New()" X EXEC
 S EXEC="set CCD.PatientId=DFN,CCD.RequestTimestamp=$zdt($h,3,1)" X EXEC
 S EXEC="set CCD.DocType="""_TYPE_""",CCD.AuditLog=AUDIT" X EXEC
 S EXEC="set CCD.PushFlag=$case(TYPE,""HIE"":1,""CR"":1,""DP"":1,:0)" X EXEC
 I TYPE="DP" S EXEC="set CCD.DirectoryPath="""_$G(PATH)_"""" X EXEC
 I TYPE="CR" S EXEC="set CCD.DirectoryPath="""_$G(PATH)_""",CCD.FileName="""_$G(FILENAME)_"""" X EXEC
 F I=1:1 S X=$P(VIEN,";",I) Q:X=""  S EXEC="do CCD.VisitId.Insert(X)" X EXEC
 ; Save now so it assigns a Queue ID, which is needed for the audit log
 S EXEC="set SC=CCD.%Save()" X EXEC
 I SC'=1 Q 0
 S EXEC="set CCD.Status=""R""" X EXEC
 S EXEC="set AUDIT.QueueId=CCD.%Id(),AUDIT.PatientId=CCD.PatientId" X EXEC
 S EXEC="set AUDIT.DocType=CCD.DocType,AUDIT.Status=CCD.Status" X EXEC
 S EXEC="set AUDIT.Source=""BCCDHIE"",AUDIT.RequestTimestamp=CCD.RequestTimestamp" X EXEC
 S EXEC="set AUDIT.RequestorDUZ=$g(DUZ),AUDIT.RequestorName=$$GET1^DIQ(200,DUZ_"","",.01,""E"")" X EXEC
 F I=1:1 S X=$P(VIEN,";",I) Q:X=""  S EXEC="do AUDIT.VisitId.Insert(X)" X EXEC
 S EXEC="set SC=AUDIT.%Save()" X EXEC
 S EXEC="set SC=CCD.%Save()" X EXEC
 Q SC=1
 ;
