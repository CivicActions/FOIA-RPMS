BUSAARRP ;GDIT/HS/BEE-BUSA Report Archive option ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**3**;Nov 05, 2013;Build 47
 ;
 Q
 ;
AR ;Archive report front end
 ;
 NEW DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT,PG,ASTDT
 ;
 W !!,"Select the archive status history to display",!
 S DIR(0)="S^A:All History;C:Created files;P:Purged files;V:Verified files;Q:Quit"
 ;
 ;Prompt user for next step
 S DIR("A")="Select the report type"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") G XAR
 S Y=$G(Y) I Y'="A",Y'="C",Y'="P",Y'="V" G XAR
 ;
 ;Record the type
 S RTYPE=Y
 ;
 ;Get records per page
 S PG=$$RPG() I PG=0 G XAR
 ;
 ;Get the archive entry start date
 S ASTDT=$$ASTDT() I ASTDT=0 G XAR
 ;
 ;Run the report
 D DISP(PG,ASTDT,RTYPE)
 ;
XAR Q
 ;
DISP(PG,ASTDT,RTYPE) ;Display the report summary and detail
 ;
 NEW AIEN,CNT,ALST,STOP,SEL,DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT,FIRST,PREV,DATA
 ;
 S (CNT,SEL,STOP,DATA,PREV)=0
 ;
 ;Loop through and display report
 F  D  I STOP Q
 . S FIRST=0
 . ;
 . ;Start where we previously left off
 . I PREV S AIEN=PREV,CNT=$G(ALST("A",PREV))
 . E  S (CNT,AIEN)=0
 . S SEL=0 F  S AIEN=$O(^BUSAAH(AIEN)) Q:'AIEN  D  I SEL!STOP Q
 .. NEW FNAME,ADT,CDT,PDT,VDT,RIEN,LOAD,ARSTS,CUSER
 .. ;
 .. ;Check archive start date
 .. S ADT=$$GET1^DIQ(9002319.13,AIEN_",",.03,"I")
 .. I ASTDT]"",$P(ADT,".")<ASTDT Q
 .. ;
 .. ;Get the status
 .. S ARSTS=$$GET1^DIQ(9002319.13,AIEN_",",.14,"I")
 .. I ARSTS="C",RTYPE'="C",RTYPE'="A" Q
 .. I ARSTS="V",RTYPE'="V",RTYPE'="A" Q
 .. I ARSTS="A",RTYPE'="P",RTYPE'="A" Q
 .. ;
 .. ;Pull information for display
 .. S CDT=$$GET1^DIQ(9002319.13,AIEN_",",.01,"I")
 .. S VDT=$$GET1^DIQ(9002319.13,AIEN_",",.09,"I")
 .. S PDT=$$GET1^DIQ(9002319.13,AIEN_",",.12,"I")
 .. S CUSER=$$GET1^DIQ(9002319.13,AIEN_",",.02,"E")
 .. ;
 .. ;Loop through reloaded entries
 .. S LOAD="",RIEN=0 F  S RIEN=$O(^BUSAAH(AIEN,1,RIEN)) Q:'RIEN  D
 ... ;
 ... NEW DA,IENS,LPDT
 ... ;
 ... ;Look for entries that haven't been purged
 ... S DA(1)=AIEN,DA=RIEN,IENS=$$IENS^DILF(.DA)
 ... ;
 ... ;Get the purge date
 ... S LPDT=$$GET1^DIQ(9002319.131,IENS,.04,"I") Q:LPDT]""
 ... ;
 ... S LOAD="Y"
 .. ;
 .. ;Pull the information for each archive
 .. S FNAME=$$GET1^DIQ(9002319.13,AIEN_",",.11,"I")
 .. ;
 .. ;Print header
 .. I FIRST=0 D
 ... W @IOF
 ... W "#",?5,"FILENAME",?45,"ARCHIVE DATE"
 ... I RTYPE="A" W ?61,"CRT",?68,"VER",?72,"PRG",?76,"LOAD"
 ... I RTYPE="C" W ?60,"CREATED",?69,"USER"
 ... I RTYPE="V" W ?61,"CRT",?68,"VERIFY"
 ... I RTYPE="P" W ?61,"CRT",?68,"VER",?72,"PURGE"
 ... W ! S FIRST=1
 .. ;
 .. S DATA=1
 .. ;
 .. ;Display counter
 .. S CNT=CNT+1 W !,CNT
 .. ;
 .. ;Display filename
 .. W ?5,$E(FNAME,1,38)
 .. ;
 .. ;Display the archive start date
 .. W ?45,$P($TR($$FMTE^XLFDT(ADT,"2ZM"),"@"," "),":",1,3)
 .. ;
 .. ;Display the create date
 .. I (RTYPE="C") W ?60,$$FMTE^XLFDT(CDT,"2ZD")
 .. I (RTYPE'="C") I CDT]"" W ?61,$E(CDT,4,5)_"/"_$E(CDT,2,3)
 .. ;
 .. ;Display the create user
 .. I (RTYPE="C") W ?69,$E(CUSER,1,11)
 .. ;
 .. ;Display the verify date
 .. I RTYPE="V" W ?68,$$FMTE^XLFDT(VDT,"2ZD")
 .. I (RTYPE="A")!(RTYPE="P") I VDT]"" W ?70,"Y"
 .. ;
 .. ;Display the purge date
 .. I RTYPE="P" W ?72,$E(PDT,4,5)_"/"_$E(PDT,2,3)
 .. I (RTYPE="A") I PDT]"" W ?74,"Y"
 .. ;
 .. ;Display whether reloaded
 .. I (RTYPE="A") W ?78,LOAD
 .. ;
 .. ;Assemble array of entries
 .. S ALST("C",CNT)=AIEN
 .. S ALST("A",AIEN)=CNT
 .. ;
 .. ;Prompt for selection
 .. I CNT#PG=0 D
 ... S FIRST=0
 ... I '$O(^BUSAAH(AIEN)) S DIR("A")="Select the ENTRY # to view the detail or enter to exit"
 ... E  S DIR("A")="Select the ENTRY # to view the detail or hit enter to continue"
 ... S DIR(0)="FO^1:10"
 ... W !
 ... D ^DIR
 ... I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) S STOP=1 Q
 ... ;
 ... ;An entry was selected
 ... I Y>0 D  I SEL Q
 .... I '$D(ALST("C",Y)) Q
 .... S SEL=$G(ALST("C",Y))
 ... I 'SEL W !
 ... I '$O(^BUSAAH(AIEN)) S STOP=1
 . ;
 . ;Display final prompt
 . I 'STOP,'SEL,CNT#PG'=0 D
 .. S DIR("A")="Select the ENTRY # to view the detail or enter to exit"
 .. S DIR(0)="FO^1:10"
 .. W !
 .. D ^DIR
 .. I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) S STOP=1 Q
 .. ;
 .. ;An entry was selected
 .. I Y>0 D  Q
 ... I '$D(ALST("C",Y)) Q
 ... S SEL=$G(ALST("C",Y))
 .. S STOP=1
 . I DATA=0 S STOP=1 Q
 . I STOP!'SEL Q
 . ;
 . ;An entry was selected display the detail
 . I SEL D
 .. NEW DA,DIC,DIR,X,Y,DTOUT,DUOUT,DIROUT,LAIEN,LCNT
 .. ;
 .. W !,"ENTRY DETAIL: ",!
 .. S DIC="^BUSAAH(",DA=SEL
 .. D EN^DIQ
 .. ;
 .. S DIR(0)="FO^0:30"
 .. S DIR("A")="Press Enter to Continue"
 .. K DIR("B")
 .. D ^DIR
 .. I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) S STOP=1
 .. ;
 .. ;Determine the first entry on the page
 .. S PREV=0
 .. S LCNT=$G(ALST("A",SEL)) I LCNT="" Q
 .. F  S LCNT=$O(ALST("C",LCNT),-1) Q:LCNT=""  D  Q:PREV
 ... I LCNT#PG=0 S PREV=+$G(ALST("C",LCNT))
 ;
 I DATA=0 W !!,"<No data found for period>" H 4 G XDISP
 ;
XDISP Q
 ;
RPG() ;Return records per page
 ;
 NEW DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 ;Prompt user for records per page
 S DIR(0)="N^2:9999:0"
 S DIR("A")="Enter the records per page to display"
 S DIR("B")=10
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") Q 0
 I Y>0 Q Y
 Q 0
 ;
ASTDT() ;Return archive start date
 ;
 NEW DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 ;Prompt user for start date of audit entries
 S DIR(0)="DO^:"_DT
 S DIR("A")="Enter the archived record start date"
 S DIR("?",1)="A date entry at this prompt will start the display at the first"
 S DIR("?",2)="archive file that contains BUSA records created on or after that"
 S DIR("?",3)="date. Hit enter to start at the first archive file"
 K DIR("B")
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIROUT)]"") Q 0
 I Y>0 Q Y
 Q ""
