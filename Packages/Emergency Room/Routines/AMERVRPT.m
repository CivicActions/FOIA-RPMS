AMERVRPT ;GDIT/HS/BEE - AMER/BEDD Cleanup Report ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**11**;MAR 03, 2009;Build 27
 ;
 Q
 ;
EN ;EP - AMER/BEDD Record Cleanup Report
 NEW BEGDT,%ZIS,POP
 ;
 S BEGDT=$$GETDT("Select the Earliest Date to Report On","Report begin date") Q:'BEGDT
 ;
 ;Run the report
 W !!,"This report requires a 132 character wide printer device",!
 ;
 S POP=0,%ZIS="Q",%ZIS("A")="Print report on which device: "
 D ^%ZIS Q:POP
 ;
 ;Queue the report
 I $D(IO("Q")) D  Q
 . NEW ZTRTN,ZTIO,ZTDESC,ZTSAVE,ZTSK,ZTQUEUED,ZTREQ,ZTSTOP
 . ;
 . S ZTRTN="COMP^AMERVRPT"
 . S ZTIO=ION
 . S ZTDESC="Print AMER/BEDD Record Cleanup Report"
 . S ZTSAVE("BEGDT")=""
 . D ^%ZTLOAD
 . W !!,$S($D(ZTSK):"Request queued!",1:"Unable to queue job.  Request cancelled!")
 . D ^%ZISC
 ;
 ;Print the report
 D COMP
 ;
 Q
 ;
COMP ;EP - TASKMAN ENTRY POINT
 ;
 NEW STS,COL,COVERCOL,BEI,RPTNAME,STOP,PGNUM,PIEN,OUT,SCNT,RDT,RIEN
 ;
 U IO
 ;
 S RPTNAME="AMER/BEDD RECORD CLEANUP REPORT"
 ;
 ;Set up column header
 S BEI=1,COL(BEI)=" "
 ;
 ;List report date
 S BEI=BEI+1,COL(BEI)="From Report Date: "_$$FMTE^XLFDT($G(BEGDT))
 S BEI=BEI+1,COL(BEI)=" "
 ;
 ;Column headers
 S BEI=BEI+1,(COL(BEI),COVERCOL(BEI))=$$LJ^XLFSTR("CNT",6," ")_" "_$$LJ^XLFSTR("FIX DATE",14," ")_"  "_$$LJ^XLFSTR("PATIENT",25," ")_"  "_$$LJ^XLFSTR("VISIT",14,"")
 S (COL(BEI),COVERCOL(BEI))=COVERCOL(BEI)_"  "_$$LJ^XLFSTR("GLOBAL",12," ")_"  "_$$LJ^XLFSTR("ENTRY",8," ")_"  "_$$LJ^XLFSTR("ERR",3," ")_"  "_$$LJ^XLFSTR("DEL",3," ")
 S BEI=BEI+1,(COL(BEI),COVERCOL(BEI))=$$LJ^XLFSTR("MESSAGE",130," ")
 ;
 ;Copy first/subsequent page headers
 M COVERCOL=COL
 ;
 ;Display Header
 S STOP=$$HEADER(RPTNAME,.PGNUM,.COL,.COVERCOL) Q:STOP
 ;
 ;Loop through ^XTMP entries
 S RDT=BEGDT F  S RDT=$O(^XTMP("AMERUPD","D",RDT)) Q:'RDT  Q:STOP  S RIEN="" F  S RIEN=$O(^XTMP("AMERUPD","D",RDT,RIEN)) Q:'RIEN  D  Q:STOP
 . NEW FDT,FILE,ENTRY,N0,N1,ERR,PAT,VDT,MSG,DEL
 . ;
 . S N0=$G(^XTMP("AMERUPD",RIEN,0))
 . S N1=$G(^XTMP("AMERUPD",RIEN,1))
 . S FDT=$$FMTE^XLFDT($P(N0,U),"2ZM")
 . S FILE=$P(N0,U,3)
 . S ENTRY=$P(N0,U,4)
 . S ERR=$P(N0,U,5)
 . S PAT=$P(N0,U,7) S:PAT PAT=$$GET1^DIQ(2,PAT_",",.01,"E")
 . S VDT=$P(N0,U,8) S:VDT]"" VDT=$$FMTE^XLFDT($$GET1^DIQ(9000010,VDT_",",.01,"I"),"2ZM")
 . S MSG=$P(N1,U,1,99)
 . S DEL=$P(N0,U,6) S DEL=$S(DEL:"Y",1:"N")
 . ;
 . ;Page break check
 . I $Y'<IOSL S STOP=$$HEADER(RPTNAME,.PGNUM,.COL,.COVERCOL) Q:STOP
 . ;
 . ;Display line check
 . W !,$$LJ^XLFSTR(RIEN,6," ")_" "_$$LJ^XLFSTR(FDT,"14"," ")_"  "_$$LJ^XLFSTR(PAT,"25T"," ")_"  "_$$LJ^XLFSTR(VDT,14," ")_"  "_$$LJ^XLFSTR(FILE,12," ")_"  "_$$LJ^XLFSTR(ENTRY,8," ")_"  "_$$LJ^XLFSTR(ERR,3," ")_"  "_$$LJ^XLFSTR(DEL,3," ")
 . ;
 . ;Page break
 . I $Y'<IOSL S STOP=$$HEADER(RPTNAME,.PGNUM,.COL,.COVERCOL) Q:STOP
 . ;
 . W !,$$LJ^XLFSTR(MSG,"130"," ")
 . ;
 . ;Page break check
 . I $Y'<IOSL S STOP=$$HEADER(RPTNAME,.PGNUM,.COL,.COVERCOL) Q:STOP
 . ;
 . W !
 ;
 I $G(IOST)'["C-" D ^%ZISC
 ;
 S:$D(ZTQUEUED) ZTREQ="@"
 ;
 Q
 ;
HEADER(TITLE,PAGE,HEADER,HEADER2) ;EP - OUTPUT THE REPORT'S HEADER
 ;PARAMETERS: TITLE  => THE TITLE OF THE REPORT
 ;            PAGE   => (REFERENCE) PAGE NUMBER
 ;            HEADER => (REFERENCE) COLUMN NAMES, FORMATTED AS:
 ;                      COLUMN(LINE_NUMBER)=TEXT
 ;                      NOTE: LINE_NUMBER STARTS AT ONE
 ;RETURNS: 0 => USER WANTS TO CONTINUE PRINTING
 ;         1 => USER DOES NOT WANT TO CONTINUE PRINTING
 I $D(ZTQUEUED),($$S^%ZTLOAD) D  Q 1
 .S ZTSTOP=$$S^%ZTLOAD("Received stop request"),ZTSTOP=1
 N X,END
 S PAGE=+$G(PAGE)+1
 I PAGE>1 D  Q:$G(END) 1
 .I $E(IOST,1,2)="C-" S X=$$CONTINUE,END='$T!(X="^") Q:$G(END)
 .W @IOF
 N NOW,INDEX
 S NOW=$$UP^XLFSTR($$HTE^XLFDT($H)),NOW=$P(NOW,"@",1)_"  "_$P($P(NOW,"@",2),":",1,2)
 W $$LJ^XLFSTR($E(TITLE,1,46),47," ")_NOW_"   PAGE "_PAGE,!
 I $G(PAGE)'=1 S INDEX=0 F  S INDEX=$O(HEADER(INDEX)) Q:'INDEX  W HEADER(INDEX),!
 I $G(PAGE)=1 S INDEX=0 F  S INDEX=$O(HEADER2(INDEX)) Q:'INDEX  W HEADER2(INDEX),!
 W $$REPEAT^XLFSTR("-",(IOM-1)),!
 Q 0
 ;
CONTINUE() ;EP - PROMPT THE USER
 ;RETURNS: ^ IF USER QUIT OR TIMED OUT
 ;         OTHERWISE, THE VALUE OF VARIABLE Y
 N DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 S DIR(0)="Y"_U
 S DIR("A")="Press RETURN to continue or '^' to exit: ",DIR("B")="YES"
 D ^DIR
 Q:$D(DIRUT) U
 Q Y
 ;
GETDT(TITLE,PROMPT) ;EP - Prompt the user for a date
 ;
 NEW DIR,X,X1,X2,Y,DTOUT,DUOUT,DIRUT,DIROUT,RET,RDT
 ;
 S X1=DT,X2=-30 D C^%DTC
 S X=$$FMTE^XLFDT(X,"5D")
 ;
 W !!,TITLE,!
 S DIR(0)="D",DIR("B")=X,DIR("A")=PROMPT
 D ^DIR
 I +Y'?7N Q ""
 Q +Y
 ;
FIX ;EP - Run AMER/BEDD cleanup routine
 ;
 NEW DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT,BACK
 ;
 W @IOF
 W !!,"This option will loop through the AMER application ER ADMISSION and ER VISIT"
 W !,"files as well as the BEDD BEDD.EDVISIT class entries and identifies and"
 W !,"attempts to fix any issues found with entries not lining up with PCC"
 W !,"information."
 W !!
 ;
 S DIR(0)="Y"
 S DIR("B")="Y"
 S DIR("A")="Continue running the AMER record cleanup"
 ;
 D ^DIR
 ;
 ;Quit if not Yes
 I '+$G(Y) Q
 ;
 W !!,"This process could take some time to run. Would you like to queue"
 W !,"it off in the background or run it in the foreground?"
 W !!
 ;
 S DIR(0)="S^F:FOREGROUND;B:BACKGROUND"
 S DIR("A")="Select one of the following: "
 S DIR("B")="BACKGROUND"
 ;
 D ^DIR
 ;
 ;Quit if failure
 I $G(Y)'="B",$G(Y)'="F" Q
 S BACK=Y
 ;
 W !!
 I BACK="B" D  Q:'Y
 . S DIR(0)="Y"
 . S DIR("B")="Y"
 . S DIR("A")="Kick off the background process now"
 . D ^DIR
 ;
 ;Run in foreground
 I BACK="B" D  Q
 . W !!,"Kicking off the record cleanup utility background process..."
 . D DAILY^AMERVFIX(2)
 ;
 ;Run in background
 I BACK="F" D  Q
 . W !!,"Running record cleanup utility..."
 . D DAILY^AMERVFIX(1)
 . W !!,"Record cleanup utility has completed running..."
 ;
 Q
