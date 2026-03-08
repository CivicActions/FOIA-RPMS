BLRPRE48 ; IHS/MSC/MKK - RPMS COVID-19 AG Lab Patch LR*5.2*1048 Pre/Install/Post Routine ; 11-Mar-2020 14:45 ; MKK
 ;;5.2;IHS LABORATORY;**1048**;NOV 01, 1997;Build 5
 ;
ENVICHEK ; EP - Environment Checker
 NEW BLRVERN,BLRVERN2,CP,ERRARRAY,ROWSTARS,RPMS,RPMSVER,TODAY,WOTCNT
 ;
 Q:$$ENVIVARS()="Q"
 ;
 D ENVHEADR^BLRKIDS2(CP,RPMSVER,RPMS),BLANK
 ;
 D NEEDIT^BLRKIDS2(CP,"LR","5.2",1046,.ERRARRAY),BLANK  ; Lab Pre-Requisite - LR*5.2*1046 - LOINC COVID-19 update
 ;
 I XPDABORT>0 D SORRYEND^BLRKIDS2(.ERRARRAY,CP)   Q     ; ENVIRONMENT HAS ERROR(S)
 ;
 D BOKAY^BLRKIDS2("ENVIRONMENT")
 ;
 Q
 ;
ENVIVARS() ; EP - Setup the Environment variables
 D SETEVARS
 ;
 S TODAY=$$DT^XLFDT
 S WOTCNT=$$WOTCNT(BLRVERN)
 S ROWSTARS=$TR($J("",65)," ","*")     ; Row of asterisks
 ;
 S ^XTMP(BLRVERN,0)=$$HTFM^XLFDT(+$H+90)_"^"_TODAY_"^IHS Lab Patch "_CPSTR
 M ^XTMP(BLRVERN,TODAY,WOTCNT,"DUZ")=DUZ
 S ^XTMP(BLRVERN,TODAY,WOTCNT,"BEGIN")=$$NOW^XLFDT
 ;
 S XUMF=1
 ;
 I $G(XPDNM)="" D SORRY^BLRKIDS2(CP,"XPDNM not defined or 0.")  Q "Q"
 ;
 S RPMS=$P(XPDNM,"*",1)      ; RPMS Module
 S RPMSVER=$P(XPDNM,"*",2)   ; RPMS Version
 ;
 I +$G(DUZ)<1 D SORRY^BLRKIDS2(CP,"DUZ UNDEFINED OR 0.")  Q "Q"
 I $$GET1^DIQ(200,DUZ,"NAME")="" D SORRY^BLRKIDS2(CP,"Installer cannot be identified!")  Q "Q"
 ;
 S XPDNOQUE=1        ; No Queuing Allowed
 ;
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0,XPDDIQ(X,"B")="NO"
 ;
 S XPDABORT=0        ; KIDS install Flag
 ;
 D HOME^%ZIS         ; Reset/Initialize IO variables
 D DTNOLF^DICRW      ; Set DT variable without a Line Feed
 ;
 Q "OK"
 ;
 ;
POST ; EP - Post-Install
 NEW BLRVERN,BLRVERN2,CP,CPSTR,PATCHNUM,TODAY,WOTCNT
 ;
 D SETEVARS
 ;
 D BLANK
 D BMES^XPDUTL("Laboratory Patch "_CPSTR_" POST INSTALL begins at "_$$UP^XLFSTR($$HTE^XLFDT($H,"5MPZ"))_".")
 D BLANK
 ;
 S TODAY=$$DT^XLFDT
 S WOTCNT=$$WOTCNT(BLRVERN)
 ;
 ; Put Post Install Routine Call here <<<----
 D MAIN^BLRCVDCB("ABBOTT")  ;this can be changed based on the lab used and test setup
 D ADDTX("BDW COVID-19 DIAGNOSTIC TESTS","_COVID-19 AG(Abbott BinaxNOW)")
 ;
 D BLANK
 D BMES^XPDUTL("Laboratory Patch "_CPSTR_" POST INSTALL ends at "_$$UP^XLFSTR($$HTE^XLFDT($H,"5MPZ"))_".")
 D BLANK
 ;
 D POSTMAIL(BLRVERN,CPSTR)
 ;
 S ^XTMP(BLRVERN,TODAY,WOTCNT,"END")=$$NOW^XLFDT
 Q
 ;
ADDTX(TAX,TSTN)  ;--add test to BDW COVID-19 DIAGNOSTIC TESTS lab taxonomy
 N BLRTIEN,BLETXIEN
 S TSTI=$O(^LAB(60,"B",TSTN,0))
 I 'TSTI Q  ;test didnt get created for some reason
 S BLRTIEN=$O(^ATXLAB("B",TAX,0))
 I 'BLRTIEN Q  ;oops, something went wrong
 W !,"Adding tests to the "_TAX_" taxonomy..."
 I $D(^ATXLAB(BLRTIEN,21,"B",TSTI)) Q  ;already has this test
 ;ADD LAB TEST TO TAXONOMY
 S X=TSTI
 S DA(1)=BLRTIEN
 S DIC="^ATXLAB("_DA(1)_",21,"
 S DIC(0)="L" K DD,DO
 S:'$D(^ATXLAB(DA(1),21,0)) ^ATXLAB(DA(1),21,0)="^9002228.02101PA"
 D FILE^DICN
 S BLRTXIEN=+Y
 Q:'$G(BLRTXIEN)
 N FDA,FERR,FIENS
 S FIENS="+3,"_BLRTXIEN_","_BLRTIEN_","
 S FDA(9002228.210112,FIENS,.01)="POSITIVE"
 D UPDATE^DIE("","FDA","FIENS","FERR(3)")
 S FDA(9002228.210113,FIENS,.01)="NEGATIVE"
 D UPDATE^DIE("","FDA","FIENS","FERR(3)")
 S FDA(9002228.210114,FIENS,.01)="INVALID"
 D UPDATE^DIE("","FDA","FIENS","FERR(3)")
 Q
 ;
 ; ========================= UTILITIES FOLLOW ==========================
 ;
SETEVARS ; EP - SET standard "Enviroment" VARiables.
 S (CP,PATCHNUM)=$P($T(+2),"*",3)
 S CPSTR="LR*5.2*"_CP
 D SETBLRVS
 Q
 ;
SETBLRVS(TWO) ; EP - Set the BLRVERN variable(s)
 K BLRVERN,BLRVERN2
 ;
 S BLRVERN=$P($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=$G(TWO)
 Q
 ;
XTMPHEAD ; EP - Initialize XTMP for this patch
 NEW BLRVERN,BLRVERN2,PTCHNAME
 D SETBLRVS
 S PTCHNAME=$$TRIM^XLFSTR($P($P($P($T(+1),";",2),"-",2),"Pre"),"LR"," ")
 S ^XTMP(BLRVERN,0)=$$FMADD^XLFDT($$DT^XLFDT,30)_U_$$DT^XLFDT_U_PTCHNAME
 Q
 ;
BLANK ; EP - Blank Line
 D MES^XPDUTL("")
 Q
 ;
MESCNTR(STR) ; EP - Center a line and use XPDUTL to display it
 D MES^XPDUTL($$CJ^XLFSTR(STR,IOM))
 Q
 ;
WOTCNT(BLRVERN) ; EP - Counter for ^XTMP
 NEW CNT,TODAY
 ;
 S TODAY=$$DT^XLFDT
 ;
 S CNT=1+$G(^XTMP(BLRVERN,0,TODAY))
 S ^XTMP(BLRVERN,0,TODAY)=CNT
 Q $TR($J(CNT,3)," ","0")
 ;
INITSCR ; EP - Initialize screen. Cloned from INIT^XPDID
 N X,XPDSTR
 I IO'=IO(0)!(IOST'["C-VT") S XPDIDVT=0 Q
 I $T(PREP^XGF)="" S XPDIDVT=0 Q
 D PREP^XGF
 S XPDIDVT=1,X="IOSTBM",XPDSTR=""
 D ENDR^%ZISS
 S IOTM=3,IOBM=IOSL-4
 W @IOSTBM
 D FRAME^XGF(IOTM-2,0,IOTM-2,IOM-1) ; Top line
 D IOXY^XGF(IOTM-2,0)
 Q
 ;
POSTMAIL(BLRVERN,CPSTR) ; EP - Post Install MailMan Message
 Q:+$G(DEBUG)   ; No MailMan messages during debugging
 ;
 NEW STR
 ;
 S STR(1)=" "
 S STR(2)=$J("",10)_"POST INSTALL of "_BLRVERN_" Routine."
 S STR(3)=" "
 S STR(4)=$J("",15)_"Laboratory Patch "_CPSTR_" INSTALL completed."
 S STR(5)=" "
 ;
 ; Send E-Mail to LMI Mail Group & Installer
 D MAILALMI^BLRUTIL3("Laboratory Patch "_CPSTR_" INSTALL complete.",.STR,BLRVERN)
 ;
 Q
