TIU1022D ;IHS/MSC/MGH - Create new titles;09-Jul-2020 15:12;DU
 ;;1.0;Text Integration Utilities;**1022**;Jun 20, 1997;Build 11
 ; Run this after installing patch 1022
 ; External References
BEGIN ; Create DDEFS
 W !!,"This option creates Document Definitions for patch 1022 "
 D MAIN
 Q
 ;
MAIN ; Create DDEFS for Patient information documents
 ; -- Check for dups created after the install but before this option:
 K ^XTMP("TIU1022","DUPS"),^TMP("TIU1022",$J)
 D SETXTMP                              ;Set the names of the new docs
 N TIUDUPS,TMPCNT,SILENT S TMPCNT=0
 S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)=""
 S TMPCNT=1,^TMP("TIU1022",$J,TMPCNT)="         ***** Document Definitions for HEADERS/FOOTERS *****"
 S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)=""
 S SILENT=1
 D TIUDUPS(.TIUDUPS)                     ;Check for duplicates
 ; -- If potential duplicates exist, quit:
 I $G(TIUDUPS) D  G MAINX
 . S ^XTMP("TIU1022","DUPS")=1
 ; -- Set file data, other data for DDEFS:
 D SETDATA
 N NUM S NUM=0
 F  S NUM=$O(^XTMP("TIU1022","BASICS",NUM)) Q:'NUM  D
 . N IEN,YDDEF,TIUDA
 . ; -- If DDEF was previously created by this patch,
 . ;    say so and quit:
 . S IEN=+$G(^XTMP("TIU1022","BASICS",NUM,"DONE"))
 . I IEN D  Q
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)=^XTMP("TIU1022","FILEDATA",NUM,.04)_" "_^XTMP("TIU1022","BASICS",NUM,"NAME")
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)="    was already created in a previous install."
 . . K ^XTMP("TIU1022","FILEDATA",NUM)
 . . K ^XTMP("TIU1022","DATA",NUM)
 . ; -- If not, create new DDEF:
 . S YDDEF=$$CREATE(NUM)
 . I +YDDEF'>0!($P(YDDEF,U,3)'=1) D  Q
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)="Couldn't create a "_^XTMP("TIU1022","FILEDATA",NUM,.04)_" named "_^XTMP("TIU1022","BASICS",NUM,"NAME")_".",TMPCNT=TMPCNT+1
 . . S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)="    Please contact National RPMS Support for help."
 . S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)=^XTMP("TIU1022","FILEDATA",NUM,.04)_" named "_^XTMP("TIU1022","BASICS",NUM,"NAME")
 . S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)="    created successfully."
 . S TIUDA=+YDDEF
 . ; -- File field data:
 . D FILE(NUM,TIUDA,.TMPCNT)
 . K ^XTMP("TIU1022","FILEDATA",NUM)
 . ; -- Add item to parent:
 . D ADDITEM(NUM,TIUDA,.TMPCNT)
 . K ^XTMP("TIU1022","DATA",NUM)
MAINX ;Exit
 S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)=""
 S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)="                           *************"
 K ^TMP("TIU1022",$J)
 Q
 ;
SETXTMP ; Set up ^XTMP global
 S ^XTMP("TIU1022",0)=3200305_U_DT
 ; -- Set basic data for new DDEFS into ^XTMP.
 ;    Reference DDEFS by NUMBER.
 ;    Number parent-to-be BEFORE child.
 ; -- DDEF Document classes:
 S ^XTMP("TIU1022","BASICS",1,"NAME")="PATIENT RECEIVED HEALTH INFORMATION"
 S ^XTMP("TIU1022","BASICS",1,"INTTYPE")="DC"
 ; -- DDEF:
 S ^XTMP("TIU1022","BASICS",2,"NAME")="PATIENT GENERATED INFORMATION"
 S ^XTMP("TIU1022","BASICS",2,"INTTYPE")="DOC"
 S ^XTMP("TIU1022","BASICS",3,"NAME")="VI_PATIENT GENERATED INFORMATION"
 S ^XTMP("TIU1022","BASICS",3,"INTTYPE")="DOC"
 S ^XTMP("TIU1022","BASICS",4,"NAME")="NO CCDA AVAILABLE ON HIE"
 S ^XTMP("TIU1022","BASICS",4,"INTTYPE")="DOC"
 S ^XTMP("TIU1022","BASICS",5,"NAME")="OUTSIDE PROVIDER REFERRAL/TRANSFER"
 S ^XTMP("TIU1022","BASICS",5,"INTTYPE")="DOC"
 Q
TIUDUPS(TIUDUPS) ; Set array of potential duplicates
 N NUM S (NUM,TIUDUPS)=0
 F  S NUM=$O(^XTMP("TIU1022","BASICS",NUM)) Q:'NUM  D
 . ; -- When looking for duplicates, ignore DDEF if
 . ;      previously created by this patch:
 . Q:$G(^XTMP("TIU1022","BASICS",NUM,"DONE"))
 . ; -- If site already has DDEF w/ same Name & Type as one
 . ;    we are exporting, set its number into array TIUDUPS:
 . N NAME,TYPE,TIUY S TIUY=0
 . S NAME=^XTMP("TIU1022","BASICS",NUM,"NAME"),TYPE=^XTMP("TIU1022","BASICS",NUM,"INTTYPE")
 . F  S TIUY=$O(^TIU(8925.1,"B",NAME,TIUY)) Q:+TIUY'>0  D
 . . I $P($G(^TIU(8925.1,+TIUY,0)),U,4)=TYPE S TIUDUPS(NUM)=+TIUY,TIUDUPS=1
 ; -- Write list of duplicates:
 I +TIUDUPS D
 . W !,"You already have the following Document Definitions exported by this patch."
 . W !,"I don't want to overwrite them. Please change their names so they no longer"
 . W !,"match the exported ones, or if you are not using them, delete them."
 . W !!,"If you are reinstalling this patch, the documents will not be installed again"
 . N NUM S NUM=0
 . F  S NUM=$O(TIUDUPS(NUM)) Q:'NUM  D
 . . W !?5,^XTMP("TIU1022","BASICS",NUM,"NAME")
 Q
 ;
SETDATA ; Set more data for DDEFS (Basic data set in TIUEN1008)
 ; -- DDEF Number 1: REQUEST FOR CORRECTION/AMENDMENT OF PHI
 ; -- DDEF Number 2: APPROVED REQUEST FOR CORRECTION/AMENDMENT OF PHI
 ; -- DDEF Number 3: DENIED REQUEST FOR CORRECTION/AMENDMENT OF PHI
 ; -- Set Print Name, Owner, Status, Exterior Type,
 ;    National, for call to FILE^DIE:
 N TIUI S TIUI=0
 F TIUI=1:1:5 D
 . Q:$D(TIUDUPS(TIUI))
 . S ^XTMP("TIU1022","FILEDATA",TIUI,.03)=^XTMP("TIU1022","BASICS",TIUI,"NAME")
 . S ^XTMP("TIU1022","FILEDATA",TIUI,.06)="CLINICAL COORDINATOR"
 . S ^XTMP("TIU1022","FILEDATA",TIUI,.07)="INACTIVE"
 . S ^XTMP("TIU1022","FILEDATA",TIUI,.04)=$S(TIUI=2:"TITLE",TIUI=3:"TITLE",TIUI=4:"TITLE",TIUI=5:"TITLE",1:"DOCUMENT CLASS")
 . S ^XTMP("TIU1022","FILEDATA",TIUI,.13)="NO"
 ; -- Set Parent:
 ; -- Set PIEN node = IEN of parent if known, or if not,
 ;    set PNUM node = DDEF# of parent
 ;    Parent must exist by the time this DDEF is created:
 S ^XTMP("TIU1022","DATA",1,"PIEN")=3
 S ^XTMP("TIU1022","DATA",1,"MENUTXT")="Health Information received from Patient"
 S ^XTMP("TIU1022","DATA",2,"PNUM")=1
 S ^XTMP("TIU1022","DATA",2,"MENUTXT")="Patient Generated Information"
 S ^XTMP("TIU1022","DATA",3,"PNUM")=1
 S ^XTMP("TIU1022","DATA",3,"MENUTXT")="VI_Patient Generated Information"
 S ^XTMP("TIU1022","DATA",4,"PNUM")=1
 S ^XTMP("TIU1022","DATA",4,"MENUTXT")="No CCDA Available on HIE"
 S ^XTMP("TIU1022","DATA",5,"PNUM")=1
 S ^XTMP("TIU1022","DATA",5,"MENUTXT")="Outside Provider Referral/Transfer"
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
 S X=^XTMP("TIU1022","BASICS",NUM,"NAME")
 ; -- Make sure the DDEF it adds is TIUDA and not another w same name:
 S TIUFISCR=TIUDA ; activates screen on fld 10, Subfld .01 in DD
 D ^DIC I Y'>0!($P(Y,U,3)'=1) K PIEN G ADDX
 ; -- Set Menu Text:
 S MENUTXT=$G(^XTMP("TIU1022","DATA",NUM,"MENUTXT"))
 I $L(MENUTXT) D
 . N DA,DIE,DR
 . N D,D0,DI,DQ
 . S DA(1)=PIEN
 . S DA=+Y,DIE=DIC
 . S DR="4////^S X=MENUTXT"
 . D ^DIE
ADDX ; -- Tell user about adding to parent:
 I '$G(PIEN) D
 . S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)="  Couldn't add entry to parent.  Please contact National VistA Support"
 . S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)="    for help."
 E  S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)="  Entry added to parent."
 Q
PARENT(NUM) ; Return IEN of parent new DDEF should be added to
 N PIEN,PNUM
 ; Parent node has form:
 ; -- PIEN node = IEN of parent if known, or if not,
 ;    PNUM node = DDEF# of parent
 S PIEN=$G(^XTMP("TIU1022","DATA",NUM,"PIEN"))
 ; -- If parent IEN is known, we're done:
 I +PIEN G PARENTX
 ; -- If not, get DDEF# of parent
 S PNUM=$G(^XTMP("TIU1022","DATA",NUM,"PNUM"))
 I 'PNUM Q 0
 ; -- Get Parent IEN from "DONE" node, which was set
 ;    when parent was created:
 S PIEN=+$G(^XTMP("TIU1022","BASICS",PNUM,"DONE"))
PARENTX Q PIEN
 ;
FILE(NUM,TIUDA,TMPCNT) ; File fields for new entry TIUDA
 ; Files ALL FIELDS set in "FILEDATA" nodes of ^XTMP:
 ;   ^XTMP("TIU1022","FILEDATA",NUM,Field#)
 N TIUFPRIV,FDA,TIUERR
 S TIUFPRIV=1
 M FDA(8925.1,TIUDA_",")=^XTMP("TIU1022","FILEDATA",NUM)
 D FILE^DIE("TE","FDA","TIUERR")
 I $D(TIUERR) S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)="  Problem filing data for entry. Please contact National VistA Support."
 E  S TMPCNT=TMPCNT+1,^TMP("TIU1022",$J,TMPCNT)="  Data for entry filed successfully."
 Q
 ;
CREATE(NUM) ; Create new DDEF entry
 N DIC,DLAYGO,DA,X,Y,TIUFPRIV
 S TIUFPRIV=1
 ;S (DIC,DLAYGO)="^TIU(8925.1,"
 ;CACHE won't take global root for DLAYGO; use file number:
 S DIC="^TIU(8925.1,",DLAYGO=8925.1
 S DIC(0)="LX",X=^XTMP("TIU1022","BASICS",NUM,"NAME")
 S DIC("S")="I $P(^(0),U,4)="_""""_^XTMP("TIU1022","BASICS",NUM,"INTTYPE")_""""
 D ^DIC
 ; -- If DDEF was just created, set "DONE" node = IEN
 I $P(Y,U,3)=1 S ^XTMP("TIU1022","BASICS",NUM,"DONE")=+$G(Y)
 Q $G(Y)
