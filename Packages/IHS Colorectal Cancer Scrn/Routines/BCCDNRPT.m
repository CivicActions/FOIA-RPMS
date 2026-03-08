BCCDNRPT ;GDIT/HS/BEE-BCCD Notes Definition Report ; 15 Oct 2021  9:28 AM
 ;;2.0;CCDA;**1**;Aug 12, 2020;Build 106
 ;
 Q
 ;
EN ;Front end for BCCD Notes Definition Report
 ;
 NEW %ZIS,POP
 ;
 ;Run the report
 W !!,"This report will display the 'Edit CCDA Clinical Site Parameters' option current"
 W !,"definition for the clinical notes sections on the CCDA documents. These settings"
 W !,"determine what TIU note titles show up in each section.",!
 ;
 S POP=0,%ZIS="Q",%ZIS("A")="Print report on which device: "
 D ^%ZIS Q:POP
 ;
 ;Queue the report
 I $D(IO("Q")) D  Q
 . NEW ZTRTN,ZTIO,ZTDESC,ZTSAVE,ZTSK,ZTQUEUED,ZTREQ,ZTSTOP
 . ;
 . S ZTRTN="COMP^BCCDNRPT"
 . S ZTIO=ION
 . S ZTDESC="Print BCCD Notes Definition Report"
 . D ^%ZTLOAD
 . W !!,$S($D(ZTSK):"Report queued!",1:"Unable to queue job.  Report request cancelled!")
 . D ^%ZISC
 ;
 ;Print the report
 D COMP
 ;
 Q
 ;
COMP ;EP - Taskman Entry Point ;
 ;
 NEW COL,RPTNAME,STOP,PGNUM,HYPHEN,ULINE,TXTTYPE,PGEXC,IN,NTYPE
 ;
 S $P(HYPHEN,"-",80)="-"
 ;
 U IO
 ;
 S RPTNAME="BCCD Notes Definition Report"
 ;
 ;Set up column header
 S COL(1)=" "
 ;
 ;List report date
 S COL(2)="'Edit CCDA Clinical Site Parameters' Option Clinical Note-TIU Notes Setup"
 ;
 ;Display Header
 S STOP=$$HEADER(RPTNAME,.PGNUM,.COL) Q:STOP
 ;
 ;Loop through the note definition
 F NTYPE="D","C","H","P","I" D  Q:STOP
 . NEW NIEN,DIEN,TXTTYPE2
 . ;
 . ;Get note name
 . S TXTTYPE2=""
 . I NTYPE="D" S TXTTYPE="Discharge Summary/Hospital Course",TXTTYPE2="(in Discharge Summary/Hospital Course Notes sections)"
 . I NTYPE="C" S TXTTYPE="Consultation Note (in Consultation Notes section)"
 . I NTYPE="H" S TXTTYPE="History and Physical Note (in History and Physical Notes section)"
 . I NTYPE="P" S TXTTYPE="Procedures Note (in Procedures section)"
 . I NTYPE="I" S TXTTYPE="Hospital Discharge Instructions (in Hospital Discharge Instructions section)"
 . S ULINE=$E(HYPHEN,1,$L(TXTTYPE))
 . I TXTTYPE2]"" S ULINE=$E(HYPHEN,1,$L(TXTTYPE2))
 . ;
 . ;Page break check
 . I $Y'<IOSL S STOP=$$HEADER(RPTNAME,.PGNUM,.COL) Q:STOP
 . ;
 . ;See if any definition defined for that type
 . S NIEN=$O(^BCCDS(90310.02,1,5,"B",NTYPE,""))
 . ;
 . ;Display the title
 . W !,TXTTYPE
 . I TXTTYPE2]"" W !,TXTTYPE2
 . W !,ULINE
 . ;
 . ;Look for inclusion entries for that type
 . W !,"  Included Documents:"
 . I NIEN="" W !,"    No Included Documents defined for this note type"
 . E  D
 .. I '$O(^BCCDS(90310.02,1,5,NIEN,1,0)) W !,"    No Included Documents defined for this note type",! Q
 .. ;
 .. ;Display inclusions
 .. S DIEN=0 F  S DIEN=$O(^BCCDS(90310.02,1,5,NIEN,1,DIEN)) Q:'DIEN  D  Q:STOP
 ... NEW DA,IENS,NOTE,INOTE,CLASS
 ... S DA(2)=1,DA(1)=NIEN,DA=DIEN,IENS=$$IENS^DILF(.DA)
 ... S INOTE=$$GET1^DIQ(90310.251,IENS,.01,"I") Q:INOTE=""
 ... D GETCL(INOTE,.STOP,.PGEXC,NTYPE,0,.CLASS)
 .. W !
 . Q:STOP
 . W !,"  Excluded Documents:"
 . I NIEN="" W !,"    No Excluded Documents defined for this note type"
 . E  D
 .. I '$O(^BCCDS(90310.02,1,5,NIEN,2,0)) W !,"    No Excluded Documents defined for this note type",! Q
 .. ;
 .. ;Display exclusions
 .. S DIEN=0 F  S DIEN=$O(^BCCDS(90310.02,1,5,NIEN,2,DIEN)) Q:'DIEN  D  Q:STOP
 ... NEW DA,IENS,NOTE,INOTE,CLASS
 ... S DA(2)=1,DA(1)=NIEN,DA=DIEN,IENS=$$IENS^DILF(.DA)
 ... S INOTE=$$GET1^DIQ(90310.252,IENS,.01,"I") Q:INOTE=""
 ... D GETCL(INOTE,.STOP,.PGEXC,NTYPE,1,.CLASS)
 .. W !
 . Q:STOP
 ;
 G:STOP END
 ;
 ;Progress Note
 S TXTTYPE="Progress Note (in Progress Notes Section)"
 S ULINE=$E(HYPHEN,1,$L(TXTTYPE))
 W !!,TXTTYPE
 W !,ULINE
 W !,?2,"All TIU Note Title(s) except:"
 S PGEXC="" F  S PGEXC=$O(PGEXC(PGEXC)) Q:PGEXC=""  D  Q:STOP
 . W !,?4,PGEXC," which is in "
 . S TYP="" F IN=1:1 S TYP=$O(PGEXC(PGEXC,TYP)) Q:TYP=""  D
 .. I IN'=1 W ", "
 .. W $S(TYP="C":"Consultation Notes",TYP="H":"History and Physical Notes",TYP="D":"Discharge Summary Notes",TYP="P":"Procedures Notes",TYP="G":"General Exclusions",TYP="I":"Hospital Discharge Instructions",1:"")
 . I $Y'<IOSL S STOP=$$HEADER(RPTNAME,.PGNUM,.COL) Q:STOP
 Q:STOP
 ;
 ;Display General Exclusions
 W !!,"General Exclusions:"
 W !,$E(HYPHEN,1,19)
 I '$O(^BCCDS(90310.02,1,6,0)) W !,"  No General Exclusions defined"
 E  S DIEN=0 F  S DIEN=$O(^BCCDS(90310.02,1,6,DIEN)) Q:'DIEN  D  Q:STOP
 . NEW DA,IENS,NOTE,INOTE,CLASS
 . S DA(1)=1,DA=DIEN,IENS=$$IENS^DILF(.DA)
 . S INOTE=$$GET1^DIQ(90310.26,IENS,.01,"I") Q:INOTE=""
 . D GETCL(INOTE,.STOP,.PGEXC,"G",0,.CLASS)
 Q:STOP
 ;
 ;Page break
 I $Y'<IOSL S STOP=$$HEADER(RPTNAME,.PGNUM,.COL) Q:STOP
 ;
 ;Display Imaging Narrative
 S TXTTYPE="Imaging Narrative (in Recent Test Results section)"
 S ULINE=$E(HYPHEN,1,$L(TXTTYPE))
 W !!,TXTTYPE
 W !,ULINE
 W !,"The imaging impression is a short description or summary of a patient's exam"
 W !,"results report.  For legal purposes, it is strongly recommended that an "
 W !,"impression always be entered for every patient imaging report."
 I $Y'<IOSL S STOP=$$HEADER(RPTNAME,.PGNUM,.COL) Q:STOP
 ;
 ;Display Laboratory Report Narrative
 S TXTTYPE="Laboratory Report Narrative (in Recent Test Results section)"
 S ULINE=$E(HYPHEN,1,$L(TXTTYPE))
 W !!,TXTTYPE
 W !,ULINE
 W !,"The lab comment is a short description or summary of the reference laboratory"
 W !,"results and/or comments from the laboratory department."
 I $Y'<IOSL S STOP=$$HEADER(RPTNAME,.PGNUM,.COL) Q:STOP
 ;
 I 'STOP W !!,"<End of Report>"
 ;
END ;Close the device
 I $G(IOST)'["C-" D ^%ZISC
 S:$D(ZTQUEUED) ZTREQ="@"
 ;
 ;Prompt to continue
 I 'STOP,$G(IOST)["C-" S X=$$CONTINUE
 ;
 Q
 ;
GETCL(INOTE,STOP,PGEXC,TYP,EXC,CLASS) ;Get items in class
 ;
 I $G(INOTE)="" Q
 S EXC=+$G(EXC)
 S CLASS=$G(CLASS)
 ;
 NEW NTYPE,NOTE,CIEN,IIEN,CL
 ;
 S CL=4
 I TYP="G" S CL=2
 ;
 ;Display Title
 S NTYPE=$$GET1^DIQ(8925.1,INOTE_",",".04","I") I NTYPE'="DOC",NTYPE'="DC" Q
 S NOTE=$$GET1^DIQ(8925.1,INOTE_",",".01","E") Q:NOTE=""
 I $Y'<IOSL S STOP=$$HEADER(RPTNAME,.PGNUM,.COL) Q:STOP
 I NTYPE="DOC" D  Q
 . W !,?CL,NOTE,$$CDSP(CLASS)
 . I 'EXC S PGEXC(NOTE,TYP)=""
 . I EXC K PGEXC(NOTE,TYP)
 ;
 ;Display class
 S CLASS=CLASS_$S(CLASS="":"",1:"^")_NOTE
 S CIEN=0 F  S CIEN=$O(^TIU(8925.1,INOTE,10,CIEN)) Q:'CIEN  D  Q:STOP
 . NEW DA,IENS
 . S DA(1)=INOTE,DA=CIEN,IENS=$$IENS^DILF(.DA)
 . S IIEN=$$GET1^DIQ(8925.14,IENS,".01","I") Q:IIEN=""
 . S NTYPE=$$GET1^DIQ(8925.1,IIEN_",",".04","I") I NTYPE'="DOC",NTYPE'="DC" Q
 . S NOTE=$$GET1^DIQ(8925.1,IIEN_",",".01","E")
 . ;
 . ;Title
 . I $Y'<IOSL S STOP=$$HEADER(RPTNAME,.PGNUM,.COL) Q:STOP
 . I NTYPE="DOC" D  Q
 .. W !,?CL,NOTE,$$CDSP(CLASS)
 .. I 'EXC S PGEXC(NOTE,TYP)=""
 .. I EXC K PGEXC(NOTE,TYP)
 . ;
 . ;Class
 . D GETCL(IIEN,.STOP,.PGEXC,TYP,EXC,.CLASS)
 ;
 Q
 ;
CDSP(CLASS) ;Display class
 ;
 Q:$G(CLASS)="" ""
 ;
 NEW CT,CL,CLS
 ;
 S CLS=""
 F CT=$L(CLASS,"^"):-1:1 S CL=$P(CLASS,U,CT) I CL]"" S CLS=CLS_" which is in "_CL_" (class)"
 Q CLS
 ;
HEADER(TITLE,PAGE,HEADER) ;EP - OUTPUT THE REPORT'S HEADER
 ;PARAMETERS: TITLE  => THE TITLE OF THE REPORT
 ;    PAGE   => (REFERENCE) PAGE NUMBER
 ;    HEADER => (REFERENCE) COLUMN NAMES, FORMATTED AS:
 ;      COLUMN(LINE_NUMBER)=TEXT
 ;      NOTE: LINE_NUMBER STARTS AT ONE
 ;RETURNS: 0 => USER WANTS TO CONTINUE PRINTING
 ; 1 => USER DOES NOT WANT TO CONTINUE PRINTING
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
 W $$REPEAT^XLFSTR("-",(IOM-1)),!
 Q 0
 ;
CONTINUE() ;EP - PROMPT THE USER
 ;RETURNS: ^ IF USER QUIT OR TIMED OUT
 ; OTHERWISE, THE VALUE OF VARIABLE Y
 N DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 S DIR(0)="FO"
 K DIR("B")
 S DIR("A")="Press RETURN to continue or '^' to exit"
 W !
 D ^DIR
 I $D(DUOUT)!$D(DTOUT)!$D(DIROUT) Q U
 Q Y
 ;
NCHK ;Input transform on 90310.25 .01 field
 ;
 ;Make sure they entered a value
 I $G(X)="" Q
 ;
 ;Check if that note entry is already defined
 I $O(^BCCDS(90310.02,1,5,"B",X,""))]"" D  Q
 . W !!,"This note type is already defined. Cannot add another duplicate",!
 . K X
 ;
 Q
