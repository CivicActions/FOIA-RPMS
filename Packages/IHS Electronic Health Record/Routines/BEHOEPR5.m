BEHOEPR5 ;GDIT/HS/BEE - EPCS Provider Certificate Name Report;25-Feb-2019 13:41;PLS
 ;;1.1;BEH COMPONENTS;**070001**;Mar 20, 2007;Build 12
 ;
 ; Code to generate an EPCS Provider Certificate Name Report
 ;
 Q
 ;
EN ;EP - EPCS Provider Certificate Name Report
 N DISINC,PROVARRY,SAVE,CSTS
 ;
 ;Return terminated users?
 S DISINC=$$DISPRMPT^BEHOEP3 Q:$G(DISINC)="^"
 ;
 ;Get the user list
 S PROVARRY=$$PROVNAME(DISINC) Q:PROVARRY="^"
 ;
 ;Get the status to report on
 S CSTS=$$GSTATUS() Q:CSTS=""
 ;
 ;Save input parameters
 S SAVE("CSTS")=""
 S SAVE("PROVARRY")=""
 S SAVE("DISINC")=""
 ;
 ;Run the report
 W !!,"This report requires a 132 character wide printer device",!
 D DEVICE^ORUTL("COMP^BEHOEPR5","EPCS Provider Certificate Name Report","Q",.SAVE)
 Q
 ;
COMP ;EP - TASKMAN ENTRY POINT
 ;
 NEW STS,COL,COVERCOL,BEI,RPTNAME,STOP,PGNUM,PIEN,OUT,SCNT
 ;
 S RPTNAME="EPCS PROVIDER CERTIFICATE NAME REPORT"
 ;
 ;Set up column header
 S BEI=1,COL(BEI)=" "
 ;
 ;List users
 I PROVARRY="ALL" S BEI=BEI+1,COL(BEI)="For User(s): ALL "_$S('DISINC:"Active",1:"")_" Users"
 E  D
 . NEW II,PC
 . F II=1:1:$L(PROVARRY,U) D
 .. NEW PDUZ,PN
 .. S PDUZ=$P(PROVARRY,U,II),PN=$$GET1^DIQ(200,PDUZ_",",.01,"E") Q:PDUZ=""
 .. S PC=$G(PC)+1
 .. I PC#2=1 S BEI=BEI+1,COL(BEI)=$S(PC=1:"For User(s): ",1:"                 ")_PN Q
 .. S COL(BEI)=COL(BEI)_", "_PN
 ;
 ;List Verification Status
 S BEI=BEI+1,COL(BEI)="Certificate Verification Status: "_$S(CSTS="L":"ALL",CSTS="A":"ACTIVE",CSTS="P":"PROPOSED",CSTS="R":"RETIRED",1:"")
 S BEI=BEI+1,COL(BEI)=" "
 ;
 S BEI=BEI+1,(COL(BEI),COVERCOL(BEI))=$$LJ^XLFSTR("",35," ")_"  "_$$LJ^XLFSTR("",35," ")_"  "_$$LJ^XLFSTR("CERTIFICATE",28," ")_"  "_$$LJ^XLFSTR("EXP",8," ")_"  "_$$LJ^XLFSTR("VERIFY",8," ")_"  "_$$LJ^XLFSTR("CERT",7," ")
 S BEI=BEI+1,(COL(BEI),COVERCOL(BEI))=$$LJ^XLFSTR("RPMS NAME",35," ")_"  "_$$LJ^XLFSTR("CERTIFICATE NAME",35," ")_"  "_$$LJ^XLFSTR("ISSUER",28," ")_"  "_$$LJ^XLFSTR("DATE",8," ")_"  "_$$LJ^XLFSTR("STATUS",8," ")_"  "_$$LJ^XLFSTR("STATUS",7," ")
 ;
 ;Copy first/subsequent page headers
 M COVERCOL=COL
 ;
 ;Display Header
 S STOP=$$HEADER^BEHOEP3(RPTNAME,.PGNUM,.COL,.COVERCOL) Q:STOP
 ;
 ;Loop through BEH EPCS CERTIFICATE STATUS assemble output
 S (SCNT,PIEN)=0 F  S PIEN=$O(^BEHOEP(90460.12,PIEN)) Q:'PIEN  D
 . NEW PRV,VSTAT,VESTAT,PNAME,CNAME,EXPDT,CSTAT,LINE,PNAME,CISSUER
 . ;
 . ;Filter users
 . S PRV=$$GET1^DIQ(90460.12,PIEN_",",.03,"I") Q:PRV=""
 . S PNAME=$$GET1^DIQ(90460.12,PIEN_",",.03,"E") Q:PNAME=""
 . I PROVARRY'="ALL",PROVARRY'[(U_PRV_U) Q
 . ;
 . ;Filter inactives
 . I 'DISINC,'$$ACTIVE^XUSER(PRV) Q
 . ;
 . ;Filter verify statuses
 . S VSTAT=$$GET1^DIQ(90460.12,PIEN_",",.02,"I")
 . I CSTS'="L",VSTAT'=CSTS Q
 . ;
 . ;Pull report information
 . S PNAME=$$GET1^DIQ(200,PRV,.01,"E")  ;User Name
 . S CNAME=$$GET1^DIQ(90460.12,PIEN_",",4.01,"E")  ;Certificate Name
 . S EXPDT=$$FMTE^XLFDT($$GET1^DIQ(90460.12,PIEN_",",.06,"I"),"2ZD")   ;Expiration Date
 . S VESTAT=$$GET1^DIQ(90460.12,PIEN_",",.02,"E")
 . S CSTAT=$$GET1^DIQ(90460.12,PIEN_",",.04,"E")   ;Certificate Status
 . S CISSUER=$$GET1^DIQ(90460.12,PIEN_",",4.02,"E")  ;Certificate Issuer
 . S LINE=$$LJ^XLFSTR(PNAME,"35T"," ")_"  "_$$LJ^XLFSTR(CNAME,"35T"," ")_"  "_$$LJ^XLFSTR(CISSUER,"28T"," ")_"  "_$$LJ^XLFSTR(EXPDT,8," ")_"  "_$$LJ^XLFSTR(VESTAT,8," ")_"  "_$$LJ^XLFSTR(CSTAT,7," ")
 . S SCNT=SCNT+1,OUT(PNAME,SCNT)=LINE
 ;
 ;Display the report
 S (STOP,PNAME)="" F  S PNAME=$O(OUT(PNAME)) Q:PNAME=""  D  Q:STOP
 . S SCNT="" F  S SCNT=$O(OUT(PNAME,SCNT)) Q:SCNT=""  D  Q:STOP
 .. ;
 .. ;Page break
 .. I $Y'<IOSL S STOP=$$HEADER^BEHOEP3(RPTNAME,.PGNUM,.COL,.COVERCOL) Q:STOP
 .. ;
 .. ;Print one line
 .. W !,OUT(PNAME,SCNT)
 ;
 S:$D(ZTQUEUED) ZTREQ="@"
 ;
 Q
 ;
PROVNAME(DISINC) ; EP - Select users by name
 ;
 N X,Y,SCR,DIR,DTOUT,DUOUT,DIRUT,DIROUT,QUIT,PRV,P
 ;
 W !!,"Enter the list of users to be included in the report."
 W !,"Hit ENTER at the first user to include ALL users.",!
 ;
 ;Get list of user
 S PRV="",QUIT=0 F  Q:QUIT  D
 .S DIR(0)="PO^200:EMQZ"
 .S DIR("A")="Select "_$S($O(PRV(0)):"Another ",1:"")_"User Name"
 .I 'DISINC S SCR="I ($D(^XUSEC(""PROVIDER"",+Y))&($$ACTIVE^XUSER(+Y)))"
 .E  S SCR="I $D(^XUSEC(""PROVIDER"",+Y))"
 .S DIR("S")=SCR
 .D ^DIR
 .;
 .;Handle "^" and timeouts
 .I $G(DTOUT)!$G(DUOUT) S PRV="^",QUIT=1
 .;
 .;Handle ALL
 .I Y<0 S QUIT=1 Q
 .;
 .;Save entry
 .I +Y>0 S PRV(+Y)=$P(Y,U,2)
 ;
 ;Handle quits
 I PRV="^" Q ""
 ;
 ;Handle ALL
 I PRV="",'$O(PRV(0)) Q "ALL"
 ;
 ;Assemble list
 S P="" F  S P=$O(PRV(P)) Q:P=""  S PRV=PRV_U_P
 S:PRV]"" PRV=PRV_U
 ;
 Q PRV
 ;
GSTATUS() ;EP - Prompt the user for verification status
 ;
 NEW DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT,RET
 ;
 W !!,"Enter the certificate verification status to display",!
 S DIR(0)="S^R:RETIRED;A:ACTIVE;P:PROPOSED;L:ALL",DIR("B")="ALL",DIR("A")="Which certificate verification status would you like to display"
 D ^DIR
 S RET=$S(Y="":"",("RAPL"[Y):Y,1:"")
 Q RET
