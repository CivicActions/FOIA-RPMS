TIU1023D ;IHS/MSC/MGH - Create new titles;19-Jan-2021 13:53;DU
 ;;1.0;Text Integration Utilities;**1023**;Jun 20, 1997;Build 12
 ; Run this after installing patch 1023
 ; External References
BEGIN ; Create DDEFS
 W !!,"This option creates Document Definitions for patch 1023 "
 D MAIN
 Q
 ;
MAIN ; Create DDEFS for Patient information documents
 ; -- Check for dups created after the install but before this option:
 K ^XTMP("TIU1023","DUPS"),^TMP("TIU1023",$J)
 D SETXTMP                              ;Set the names of the new docs
 N TIUDUPS,TMPCNT,SILENT S TMPCNT=0
 S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)=""
 S TMPCNT=1,^TMP("TIU1023",$J,TMPCNT)="         ***** Document Definitions for HEADERS/FOOTERS *****"
 S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)=""
 S SILENT=1
 D TIUDUPS(.TIUDUPS)                     ;Check for duplicates
 ; -- If potential duplicates exist, quit:
 N CNT S CNT=0
 S I=0
 F  S I=$O(TIUDUPS(I)) Q:'+I  D
 .N TIEN
 .S CNT=CNT+1
 .S TIEN=$G(TIUDUPS(I))
 .I +TIEN D
 ..I $$GET1^DIQ(8925.1,TIEN,.04,"I")="DOC"&($$GET1^DIQ(8925.1,TIEN,.01)="COVID-19 VACCINE POLICY ORDER") D
 ...N FDA,ERR
 ...S FDA(8925.1,TIEN_",",4.9)="D EN^BTIUIMSN(DFN,TIUDA,713404003,3289271014,""Z23."")"
 ...D FILE^DIE(,"FDA","ERR")
 ..S ^XTMP("TIU1023","BASICS",I,"DONE")=TIEN
 I +CNT D  G MAINX
 . S ^XTMP("TIU1023","DUPS")=1
 ; -- Set file data, other data for DDEFS:
 D SETDATA
 N NUM S NUM=0
 F  S NUM=$O(^XTMP("TIU1023","BASICS",NUM)) Q:'NUM  D
 . N IEN,YDDEF,TIUDA
 . ; -- If DDEF was previously created by this patch,
 . ;    say so and quit:
 . S IEN=+$G(^XTMP("TIU1023","BASICS",NUM,"DONE"))
 . I IEN D  Q
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)=^XTMP("TIU1023","FILEDATA",NUM,.04)_" "_^XTMP("TIU1023","BASICS",NUM,"NAME")
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)="    was already created in a previous install."
 . . K ^XTMP("TIU1023","FILEDATA",NUM)
 . . K ^XTMP("TIU1023","DATA",NUM)
 . ; -- If not, create new DDEF:
 . S YDDEF=$$CREATE(NUM)
 . I +YDDEF'>0!($P(YDDEF,U,3)'=1) D  Q
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)="Couldn't create a "_^XTMP("TIU1023","FILEDATA",NUM,.04)_" named "_^XTMP("TIU1023","BASICS",NUM,"NAME")_".",TMPCNT=TMPCNT+1
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)="    Please contact National RPMS Support for help."
 . S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)=^XTMP("TIU1023","FILEDATA",NUM,.04)_" named "_^XTMP("TIU1023","BASICS",NUM,"NAME")
 . S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)="    created successfully."
 . S TIUDA=+YDDEF
 . ; -- File field data:
 . D FILE(NUM,TIUDA,.TMPCNT)
 . K ^XTMP("TIU1023","FILEDATA",NUM)
 . ; -- Add item to parent:
 . D ADDITEM(NUM,TIUDA,.TMPCNT)
 . K ^XTMP("TIU1023","DATA",NUM)
MAINX ;Exit
 S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)=""
 S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)="                           *************"
 K ^TMP("TIU1023",$J)
 Q
 ;
SETXTMP ; Set up ^XTMP global
 S ^XTMP("TIU1023",0)=3201125_U_DT
 ; -- Set basic data for new DDEFS into ^XTMP.
 ;    Reference DDEFS by NUMBER.
 ;    Number parent-to-be BEFORE child.
 ; -- DDEF Document classes:
 S ^XTMP("TIU1023","BASICS",1,"NAME")="CLINICAL REMINDER DIALOG IMMUNIZATIONS"
 S ^XTMP("TIU1023","BASICS",1,"INTTYPE")="DC"
 ; -- DDEF:
 S ^XTMP("TIU1023","BASICS",2,"NAME")="COVID-19 VACCINE POLICY ORDER"
 S ^XTMP("TIU1023","BASICS",2,"INTTYPE")="DOC"
 Q
TIUDUPS(TIUDUPS) ; Set array of potential duplicates
 N NUM S (NUM,TIUDUPS)=0
 F  S NUM=$O(^XTMP("TIU1023","BASICS",NUM)) Q:'NUM  D
 . ; -- When looking for duplicates, ignore DDEF if
 . ;      previously created by this patch:
 . Q:$G(^XTMP("TIU1023","BASICS",NUM,"DONE"))
 . ; -- If site already has DDEF w/ same Name & Type as one
 . ;    we are exporting, set its number into array TIUDUPS:
 . N NAME,TYPE,TIUY S TIUY=0
 . S NAME=^XTMP("TIU1023","BASICS",NUM,"NAME"),TYPE=^XTMP("TIU1023","BASICS",NUM,"INTTYPE")
 . F  S TIUY=$O(^TIU(8925.1,"B",NAME,TIUY)) Q:+TIUY'>0  D
 . . I $P($G(^TIU(8925.1,+TIUY,0)),U,4)=TYPE S TIUDUPS(NUM)=+TIUY,TIUDUPS=1
 ; -- Write list of duplicates:
 I +TIUDUPS D
 . W !,"You already have the following Document Definitions exported by this patch."
 . W !,"I don't want to overwrite them. See the notes file for details."
 . W !!,"If you are reinstalling this patch, the documents will not be installed again"
 . N NUM S NUM=0
 . F  S NUM=$O(TIUDUPS(NUM)) Q:'NUM  D
 . . W !?5,^XTMP("TIU1023","BASICS",NUM,"NAME")
 Q
 ;
SETDATA ; Set more data for DDEFS (Basic data set in TIUEN1008)
 ; -- DDEF Number 1: COVID-19 VACCINE POLICY ORDER
 ; -- Set Print Name, Owner, Status, Exterior Type,
 ;    National, for call to FILE^DIE:
 N TIUI S TIUI=0
 F TIUI=1:1:2 D
 . Q:$D(TIUDUPS(TIUI))
 . S ^XTMP("TIU1023","FILEDATA",TIUI,.03)=^XTMP("TIU1023","BASICS",TIUI,"NAME")
 . S ^XTMP("TIU1023","FILEDATA",TIUI,.06)="CLINICAL COORDINATOR"
 . S ^XTMP("TIU1023","FILEDATA",TIUI,.07)="INACTIVE"
 . S ^XTMP("TIU1023","FILEDATA",TIUI,.04)=$S(TIUI=2:"TITLE",1:"DOCUMENT CLASS")
 . S ^XTMP("TIU1023","FILEDATA",TIUI,.13)="NO"
 . I TIUI=2 D
 ..S ^XTMP("TIU1023","FILEDATA",TIUI,4.9)="D EN^BTIUIMSN(DFN,TIUDA,713404003,3289271014,""Z23."")"
 ..S ^XTMP("TIU1023","FILEDATA",TIUI,1501)="IMMUNIZATION NOTE"
 ; -- Set Parent:
 ; -- Set PIEN node = IEN of parent if known, or if not,
 ;    set PNUM node = DDEF# of parent
 ;    Parent must exist by the time this DDEF is created:
 S ^XTMP("TIU1023","DATA",1,"PIEN")=3
 S ^XTMP("TIU1023","DATA",1,"MENUTXT")="Reminder Dialog Immunizations"
 S ^XTMP("TIU1023","DATA",2,"PNUM")=1
 S ^XTMP("TIU1023","DATA",2,"MENUTXT")="Covid-19 Vaccine Document"
 Q
 ;
ADDITEM(NUM,TIUDA,TMPCNT) ; Add DDEF to Parent; Set item fields
 N PIEN,MENUTXT,TIUFPRIV,TIUFISCR
 N DIE,DR
 S TIUFPRIV=1
 S PIEN=$$PARENT(NUM)
 I 'PIEN!'$D(^TIU(8925.1,PIEN,0))!'$D(^TIU(8925.1,TIUDA,0)) K PIEN G ADDX
 N DA,DIC,DLAYGO,X,Y
 N I,DIY
 S DA(1)=PIEN
 S DIC="^TIU(8925.1,"_DA(1)_",10,",DIC(0)="LX"
 S DLAYGO=8925.14
 ;S X="`"_TIUDA
 ; -- If TIUDA is say, x, and Parent has x as IFN in Item subfile,
 ;    code finds item x under parent instead of creating a new item,
 ;    so don't use "`"_TIUDA:
 S X=^XTMP("TIU1023","BASICS",NUM,"NAME")
 ; -- Make sure the DDEF it adds is TIUDA and not another w same name:
 S TIUFISCR=TIUDA ; activates screen on fld 10, Subfld .01 in DD
 D ^DIC I Y'>0!($P(Y,U,3)'=1) K PIEN G ADDX
 ; -- Set Menu Text:
 S MENUTXT=$G(^XTMP("TIU1023","DATA",NUM,"MENUTXT"))
 I $L(MENUTXT) D
 . N DA,DIE,DR
 . N D,D0,DI,DQ
 . S DA(1)=PIEN
 . S DA=+Y,DIE=DIC
 . S DR="4////^S X=MENUTXT"
 . D ^DIE
ADDX ; -- Tell user about adding to parent:
 I '$G(PIEN) D
 . S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)="  Couldn't add entry to parent.  Please contact National VistA Support"
 . S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)="    for help."
 E  S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)="  Entry added to parent."
 Q
PARENT(NUM) ; Return IEN of parent new DDEF should be added to
 N PIEN,PNUM
 ; Parent node has form:
 ; -- PIEN node = IEN of parent if known, or if not,
 ;    PNUM node = DDEF# of parent
 S PIEN=$G(^XTMP("TIU1023","DATA",NUM,"PIEN"))
 ; -- If parent IEN is known, we're done:
 I +PIEN G PARENTX
 ; -- If not, get DDEF# of parent
 S PNUM=$G(^XTMP("TIU1023","DATA",NUM,"PNUM"))
 I 'PNUM Q 0
 ; -- Get Parent IEN from "DONE" node, which was set
 ;    when parent was created:
 S PIEN=+$G(^XTMP("TIU1023","BASICS",PNUM,"DONE"))
PARENTX Q PIEN
 ;
FILE(NUM,TIUDA,TMPCNT) ; File fields for new entry TIUDA
 ; Files ALL FIELDS set in "FILEDATA" nodes of ^XTMP:
 ;   ^XTMP("TIU1023","FILEDATA",NUM,Field#)
 N TIUFPRIV,FDA,TIUERR
 S TIUFPRIV=1
 M FDA(8925.1,TIUDA_",")=^XTMP("TIU1023","FILEDATA",NUM)
 D FILE^DIE("TE","FDA","TIUERR")
 I $D(TIUERR) S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)="  Problem filing data for entry. Please contact National VistA Support."
 E  S TMPCNT=TMPCNT+1,^TMP("TIU1023",$J,TMPCNT)="  Data for entry filed successfully."
 Q
 ;
CREATE(NUM) ; Create new DDEF entry
 N DIC,DLAYGO,DA,X,Y,TIUFPRIV
 S TIUFPRIV=1
 ;S (DIC,DLAYGO)="^TIU(8925.1,"
 ;CACHE won't take global root for DLAYGO; use file number:
 S DIC="^TIU(8925.1,",DLAYGO=8925.1
 S DIC(0)="LX",X=^XTMP("TIU1023","BASICS",NUM,"NAME")
 S DIC("S")="I $P(^(0),U,4)="_""""_^XTMP("TIU1023","BASICS",NUM,"INTTYPE")_""""
 D ^DIC
 ; -- If DDEF was just created, set "DONE" node = IEN
 I $P(Y,U,3)=1 S ^XTMP("TIU1023","BASICS",NUM,"DONE")=+$G(Y)
 Q $G(Y)
