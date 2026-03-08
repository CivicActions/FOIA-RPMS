BSTSCRPT ;GDIT/HS/BEE-SNOMED Concept export/report ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**4**;Dec 01, 2016;Build 10
 ;
 ;GDIT/HS/BEE;01/06/2023;FEATURE#86636;Reports For Comparison of BSTS Subsets to DTS subsets
 ;New reports for patch 4
 ;
 ;*Using direct global references where possible to speed up compile time
 ;
EN ;EP - Main entry point
 ;
 NEW DIR,X,Y,DIR,DA,DTOUT,DUOUT,DIRUT,DIROUT,BST,RTYPE,RANGE,DEVICE,EXEC,CGBL,TMAX,EXPORT
 ;
 ;Determine which report to run
 W @IOF
 K BST
 S BST(1)="BSTS Report/Export"
 S BST(2)=" "
 S BST(3)="This option allows you to generate different report data exports for BSTS."
 S BST(4)="The following report data exports are available: "
 S BST(5)=" "
 S BST(6)="SNOMED Concept Listing"
 S BST(7)="Provides an export of all (or a range of) SNOMED Concepts in local BSTS"
 S BST(8)="cache and information relating to each concept"
 S BST(9)=" "
 S BST(10)="SNOMED Subset Listing"
 S BST(11)="Provides an export of all (or a specified list of) subsets and the"
 S BST(12)="SNOMED concepts that they contain."
 S BST(13)=" "
 S BST(14)="Please choose the report/export that you would like to run."
 S BST(15)=" "
 D EN^DDIOL(.BST)
 S DIR("A")="Select the report to run"
 S DIR(0)="SO^C:SNOMED Concept Listing;S:SNOMED Subset Listing"
 D ^DIR
 I Y'="C",Y'="S" G XEN
 S RTYPE=Y
 ;
 ;Get ranges based on report type
 S RANGE=""
 I RTYPE="C" S RANGE=$$CRANGE()
 I RTYPE="S" S RANGE=$$SRANGE(.RANGE)
 I $G(RANGE)="" G XEN
 ;
 ;If SNOMED Concept Listing prompt
 I RTYPE="S" S EXPORT="R"
 E  S EXPORT=$$EXPORT()
 I EXPORT="" G XEN
 ;
 S DEVICE=$$DEVICE()
 I 'DEVICE G XEN
 ;
 ;Prompt if they want to continue
 W !
 S DIR(0)="Y",DIR("B")="NO"
 S DIR("A")="Would you like to continue: "
 D ^DIR
 S Y=$G(Y)
 I Y'=1 D ^%ZISC G XEN
 ;
 ;Reset scratch global
 ;
 ;Define temporary schema import global
 S EXEC="S CGBL=$NA(^||BSTSJ($J))" X EXEC
 K @CGBL
 ;
 ;Compile Report
 U 0 W !,"Compiling report data. This could take several minutes to complete"
 I RTYPE="C" D CCOMP^BSTSCRP0(RANGE,CGBL,.TMAX)
 E  D SCOMP^BSTSCRP0(.RANGE,CGBL)
 ;
 U 0
 I RTYPE="C" D
 . I $O(@CGBL@(""))="" W !!,"No data found"
 . E  D
 .. W !!,"Now outputing compiled data. This could also take several minutes"
 .. D COUT(CGBL,.TMAX,EXPORT)
 ;
 I RTYPE="S" D
 . I $O(@CGBL@("O",""))="" W !!,"No data found"
 . E  D
 .. W !!,"Now outputing compiled data. This could also take several minutes"
 .. D SOUT(CGBL)
 ;
 ;Close file
 D ^%ZISC
 ;
XEN Q
 ;
CRANGE() ;Return SNOMED concept range (or ALL)
 ;
 ;Returns the starting and ending SNOMED concept id range or ALL
 ;
 NEW DIR,X,Y,DIR,DA,DTOUT,DUOUT,DIRUT,DIROUT,RET
 ;
 S DIR("A")="Enter the starting Concept Id to include or (A)LL for all concepts"
 S DIR(0)="F^1:20"
 W ! D ^DIR
 S Y=$TR(Y,"al","AL")
 I $E(Y,1)="A" Q "ALL"
 I Y'?1N.N Q ""
 S RET=Y
 ;
 S DIR("A")="Enter the ending Concept Id to include in the listing"
 S DIR(0)="F^1:20"
 W ! D ^DIR
 I Y'?1N.N Q ""
 S RET=RET_U_Y
 ;
 Q RET
 ;
SRANGE(RANGE) ;Return a list of SNOMED subsets to return
 ;
 NEW DIR,X,Y,DIR,DA,DTOUT,DUOUT,DIRUT,DIROUT,RET,BST
 ;
 S BST(1)=" "
 S BST(2)="Enter a SNOMED subset name to include in the export"
 S BST(3)="You can enter a partial name followed by a '*' to get a group of subsets"
 S BST(4)="For example, if you enter SRCH* all subsets starting with SRCH will be"
 S BST(5)="included in the export. Enter '*' to get all concepts in all subsets."
 S BST(6)=" "
 D EN^DDIOL(.BST)
 ;
SRANGE1 ;Prompt for subset(s) to include
 S DIR("A")="Enter the subset to include"
 S DIR(0)="FO^1:32"
 W ! D ^DIR
 I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) S Y="-1" G SRANGE2
 I Y="",$O(RANGE(""))]"" G SRANGE2
 I Y]"",Y'[U S RANGE(Y)=""
 ;
 G SRANGE1
 ;
SRANGE2 ;Check for "IHS PROBLEM ALL SNOMED"
 ;
 I Y="-1" Q ""
 ;
 ;Prompt to include all if "*" entered
 NEW FOUND,RNG,ALL
 ;
 S ALL="IHS PROBLEM ALL SNOMED"
 ;
 I $O(RANGE(""))]"" S RANGE=0
 ;
 S FOUND=0
 ;
 S RNG="" F  S RNG=$O(RANGE(RNG)) Q:RNG=""  D  Q:FOUND
 . I RNG="*" S FOUND=1 Q
 . I ALL=RNG S RANGE=1
 . I $E(ALL,1,$L(RNG))=RNG,ALL'=RNG S FOUND=1
 ;
 ;If found "*" see if they want "IHS PROBLEM ALL SNOMED" entries
 I FOUND D
 . S DIR("A")="Would you like to include 'IHS PROBLEM ALL SNOMED' subset entries: "
 . S DIR(0)="Y",DIR("B")="NO"
 . D ^DIR
 . I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) S RANGE="" Q
 . S Y=$G(Y)
 . I Y'=1 S RANGE=0
 . E  S RANGE=1
 ;
 Q $G(RANGE)
 ;
EXPORT() ;Return whether to return in report or export format
 ;
 ;Returns "R" for report format, "E" for export format
 ;
 NEW DIR,X,Y,DIR,DA,DTOUT,DUOUT,DIRUT,DIROUT,BST
 ;
 S BST(1)=" "
 S BST(2)=" "
 S BST(3)="THIS REPORT CAN BE EXPORTED IN THE FOLLOWING TWO DIFFERENT FORMATS:"
 S BST(4)=" "
 S BST(5)="  *Report format - Better for loading data into Excel to filter and sort on."
 S BST(6)="  *Export format - Better for loading into a database for custom querying."
 S BST(7)=" "
 ;
 S DIR("A")="Enter the starting Concept Id to include or (A)LL for all concepts"
 S DIR(0)="F^1:20"
 D EN^DDIOL(.BST)
 S DIR("A")="Select the report format to use"
 S DIR(0)="SO^R:Report format;E:Export format"
 D ^DIR
 I Y'="R",Y'="E" Q ""
 Q Y
 ;
DEVICE() ;Open the device for output
 ;
 NEW BST,POP
 ;
 S BST(1)=" "
 S BST(2)="Select the output device for the report/export data"
 S BST(3)=" "
 S BST(4)="This report is best output to an external file. To output the data to a file"
 S BST(5)="enter HFS at the 'Device: ' prompt and then enter the path and file name at"
 S BST(6)="the 'HOST FILE NAME:' prompt."
 S BST(7)=" "
 D EN^DDIOL(.BST)
 ;
 D ^%ZIS
 I $G(POP) Q 0
 Q 1
 ;
COUT(CGBL,TMAX,RTYPE) ;Output the concept report
 ;
 I $G(CGBL)="" Q
 I '$G(TMAX) Q
 I $G(RTYPE)'="R",$G(RTYPE)'="E" Q
 ;
 NEW CCNT,NREC,REC,TTYPE,DESCID
 ;
 ;Output header
 U IO W "ConceptId",U,"Concept Status",U,"FSN DESCR ID",U,"FSN",U,"FSN Status",U,"PT DESCR ID",U,"PT NAME",U,"PT Status"
 W U,"IF TERM DESCR ID",U,"IF TERM",U,"IF Status",U
 I RTYPE="E" D
 . W "Term DESCR ID",U,"Term",U,"Term Type",U,"Term Status"
 I RTYPE="R" D
 . NEW CNT
 . ;
 . ;Output terms
 . F CNT=1:1:TMAX W "Term "_CNT_" DESCR ID",U,"Term "_CNT,U,"Term "_CNT_" Type",U,"Term "_CNT_" Status" W:CNT'=TMAX U
 ;
 ;Loop through compiled data and output
 S CCNT=0 F  S CCNT=$O(@CGBL@(CCNT)) Q:CCNT=""  D
 . ;
 . NEW TCNT,OUT
 . ;
 . S REC=$G(@CGBL@(CCNT))
 . ;
 . ;Assemble terms
 . S OUT=0
 . S TCNT=11
 . S DESCID="" F  S DESCID=$O(@CGBL@(CCNT,"T",DESCID)) Q:DESCID=""  D
 .. S TTYPE="" F  S TTYPE=$O(@CGBL@(CCNT,"T",DESCID,TTYPE)) Q:TTYPE=""  D
 ... ;
 ... I RTYPE="E" D
 .... S NREC=REC
 .... S $P(NREC,U,12)=DESCID
 .... S $P(NREC,U,13)=$P($G(@CGBL@(CCNT,"T",DESCID,TTYPE)),U)
 .... S $P(NREC,U,14)=TTYPE
 .... S $P(NREC,U,15)=$P($G(@CGBL@(CCNT,"T",DESCID,TTYPE)),U,2)
 .... ;
 .... ;Output the record if Export
 .... S OUT=1
 .... U IO W !,NREC
 ... I RTYPE="R" D
 .... S TCNT=TCNT+1,$P(REC,U,TCNT)=DESCID
 .... S TCNT=TCNT+1,$P(REC,U,TCNT)=$P($G(@CGBL@(CCNT,"T",DESCID,TTYPE)),U)
 .... S TCNT=TCNT+1,$P(REC,U,TCNT)=TTYPE
 .... S TCNT=TCNT+1,$P(REC,U,TCNT)=$P($G(@CGBL@(CCNT,"T",DESCID,TTYPE)),U,2)
 . ;
 . I RTYPE="R"!'OUT U IO W !,REC
 ;
 Q
 ;
SOUT(CGBL) ;Output the subset report
 ;
 I $G(CGBL)="" Q
 ;
 NEW CIEN,REC,REC,SUB
 ;
 ;Output header
 U IO W "Subset",U,"ConceptId",U,"Concept Status",U,"FSN DESCR ID",U,"FSN",U,"FSN Status",U,"PT DESCR ID",U,"PT Name",U,"PT Status"
 U IO W U,"IF DESCR ID",U,"IF Name",U,"IF Status"
 ;
 ;Loop through compiled data and output
 S CIEN="" F  S CIEN=$O(@CGBL@("O",CIEN)) Q:CIEN=""  S SUB="" F  S SUB=$O(@CGBL@("O",CIEN,SUB)) Q:SUB=""  D
 . ;
 . NEW TCNT,OUT
 . ;
 . S REC=SUB_U_$G(@CGBL@("O",CIEN,SUB))
 . ;
 . ;Output the record
 . U IO W !,REC
 ;
 Q
