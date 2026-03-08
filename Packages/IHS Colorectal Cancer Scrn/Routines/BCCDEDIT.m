BCCDEDIT ;GDIT/HS/AM-Edit Site Parameters ; 18 Sep 2013  8:27 AM
 ;;2.0;CCDA;**1,2**;Aug 12, 2020;Build 119
 ;
EN ; Entry point
 N DA,DR,DIE,Y,X,MT,CCDAOK,SPACE,PATSPC,NEEDSPC,XYZ,DIC,OK,SPIEN
 L +^BCCDEDIT:0 E  W !,"Someone else is editing site parameters" Q
 W !,"Now editing CCDA parameters:",!
 S DA=$O(^BCCDS(90310.01,0)) I 'DA G EXIT
 S DR=".06"
 S DIE="^BCCDS(90310.01," D ^DIE
 G EXIT:$D(Y)
 S SPIEN=DA
 ;
 ;S DIC="^BCCDS(90310.02,",DIC(0)="AEMNZ" D ^DIC
 ;S DA=+Y I DA=-1 Q
 S DA=$$FIND1^DIC(90310.02,,"X","CCD")
 I DA="" Q
 W !!,"Now editing ",$P(^BCCDS(90310.02,DA,0),U)," (",$P(^BCCDS(90310.02,DA,0),U,3),")-specific parameters:",!
 S DR="[BCCD SITE PARAMS]"
 S DIE="^BCCDS(90310.02," D ^DIE
 ;
 ;Do not perform space check if not enabled
 I $$GET1^DIQ(90310.02,DA_",",.05,"I")'="Y" Q
 ;
 ;Do not perform space check if REPOSITORY LOCATION is null
 I $G(^BCCDS(90310.02,DA,1))="" Q
 ;
 ;Do not perform space check if TIME TO RUN NIGHTLY TASK is null
 I $$GET1^DIQ(90310.01,SPIEN_",",.06,"I")="" Q
 ;
 ;Perform space check only if LAST PUSH DATE TIME is null, i.e. if
 ;documents for all patients will be uploaded.
 I $$GET1^DIQ(90310.02,DA_",",.02,"I")'="" Q
 ;
 ;Perform space check
 S OK=0 D CHK
 I 'OK W !!,"Not enough available space. Setting ENABLED field to ""NO""" H 2 S DR=".05///^S X=""NO""" D ^DIE
 ;
EXIT ;
 L -^BCCDEDIT
 Q
 ;
 ;BCCD*1.0*7;CR#6407;New clinical menu option
CLIN ;EP - BCCD EDIT CLINICAL PARAMETERS
 NEW DA,DR,DIE
 L +^BCCDEDIT:0 E  W !,"Someone else is editing site parameters" G CEXIT
 W !!,"NOW EDITING CCDA CLINICAL PARAMETERS:",!
 ;
 ;Look for entry and edit
 S DA=$$FIND1^DIC(90310.02,,"X","CCD")
 I DA="" Q
 S DR="[BCCD CLINICAL PARAMS]"
 S DIE="^BCCDS(90310.02," D ^DIE
 ;
CEXIT ;
 L -^BCCDEDIT
 Q
 ;
CHK ;EP - check space
 S PATSPC=52
 S CCDAOK=1 W !,"Checking free space..." S SPACE=$$SPACE()
 I SPACE>PATSPC W "OK" S OK=1 Q
 W !,!,"There are ",$P(SPACE,U,3)," patients and ",$P(SPACE,U,2)\1024," MB of free disk space in the CCDA"
 W !,"database (",$J($P(SPACE,U),"",3)," KB per patient).  The CCDA database needs ",PATSPC," KB of"
 W !,"free disk space per patient, "
 S NEEDSPC=$P(SPACE,U,3)*PATSPC-$P(SPACE,U,2)
 W NEEDSPC\1024," MB more than you currently have."
 I $P(SPACE,U,6)<0 D
 . W !,!,"Your system doesn't have enough free space on file system to allow this"
 . W !,"to proceed. Contact Support to assist you with expanding file system."
 I $P(SPACE,U,6)>0 D
 . S XYZ=$P(SPACE,U,4)+NEEDSPC\1024
 . W !,!,"You must change the value of the ""Maximum Size"" field in the ""Database "
 . W !,"Properties"" screens in Ensemble's Management Portal to at least ",XYZ," MB "
 . W !," before you can enable CCD generation"
 Q
 ;
SPACE(NS) ;
 ; check if enough space 
 N FS,PATFS,PATCT,EXEC,DIR,TSC,METMS,METSC,METFS,METDFS,METDS,METCS,ES,PATCT,PATFS
 S FS=0,PATFS=0,PATCT=0
 I $G(NS)="" S EXEC="S NS=##class(%SYSTEM.SYS).NameSpace()" X EXEC
 I NS'?1"CCDA".E S NS="CCDA"_NS
 S EXEC="S DIR=##class(%SYS.Namespace).GetGlobalDest(NS),DIR=$P(DIR,""^"",2,99)" X EXEC
 ; set up monitor
 S EXEC="Set MET=##class(%Monitor.System.Freespace).%New()" X EXEC
 S EXEC="S TSC=MET.Initialize()" X EXEC
 I $G(TSC)'=1 W !,"Space check monitor failed to initialize" G QS
 S METMS=0,METCS=0,METFS=0,METDFS=0,METDS=0
 S EXEC="F  S TSC=MET.GetSample() Q:'TSC  I MET.Directory=DIR S METMS=MET.MaxSize,METCS=MET.CurSize,METFS=MET.FreeSpace,METDS=MET.DiskFreeSpace" X EXEC
 I METCS=0 W !,"Space check monitor failed to find Cache Namespace with directory ",DIR G QS
 ; if unlimited cache.dat, then expansion space is FreeDiskSpace
 I METMS=-1 S ES=METDS
 ; if limited cache.dat, then ExpansionSpace is smaller of FreeDiskSpace and (MaxSpace-CurrentSpace)
 I METMS'=-1 S ES=METMS-METCS S:METDS<ES ES=METDS
 ; then limit is Expansion Space+FreeSpaceInCurrentFile
 S FS=ES+METFS
 S PATCT=$P(^AUPNPAT(0),U,3) I PATCT=0 G QS
 S PATFS=FS/PATCT
QS ;
 S EXEC="S TSC=MET.Shutdown()" X EXEC
 K MET
 ; return space per person (in K), total space (in K), patient count, 
 ; current used space, current free space in database, maximum space, and disk space
 Q (PATFS*1024)_U_(FS*1024)_U_PATCT_U_(METCS*1024)_U_(METFS*1024)_U_(METMS*1024)_U_(METDS*1024)
 ;
TDSCREEN(Y,CTYPE,NTYPE,IE) ;Screen out duplicates
 ;
 ;This tag is called by the screen logic for the BCCD MESSAGE TYPE file, CLINICAL NOTES multiple,
 ;INCLUDE TITLE/DOCUMENT CLASS and EXCLUDE TITLE/DOCUMENT CLASS fields. It prevents Titles or Document
 ;Classes from being defined in both the include and exclude fields.
 ;
 ;Input:
 ;Y  - The IEN of the 8925.1 entry
 ;CTYPE - The CCDA document type
 ;NTYPE - The note type
 ;IE - The bucket to look in: Include (I) or Exclude (E)
 ;
 NEW IEIEN
 ;
 ;Validation
 I +$G(Y)=0 Q 0
 I +$G(CTYPE)=0 Q 0
 I +$G(NTYPE)=0 Q 0
 I $G(IE)'="I",$G(IE)'="E" Q 0
 S IEIEN=$S(IE="I":1,1:2)
 ;
 ;Look for entry
 I $D(^BCCDS(90310.02,CTYPE,5,NTYPE,IEIEN,"B",Y)) Q 1
 ;
 Q 0
 ;
 ;Mumps cross references sets/kills for file 90310.02 Inclusion/Exclusion entries
ISET S ^BCCDS(90310.02,"I",+$G(DA(2)),+$G(DA(1)),+$G(X),+$G(DA))=""
 Q
 ;
IKILL K ^BCCDS(90310.02,"I",+$G(DA(2)),+$G(DA(1)),+$G(X),+$G(DA))
 Q
 ;
ESET S ^BCCDS(90310.02,"E",+$G(DA(2)),+$G(DA(1)),+$G(X),+$G(DA))=""
 Q
 ;
EKILL K ^BCCDS(90310.02,"E",+$G(DA(2)),+$G(DA(1)),+$G(X),+$G(DA))
 Q
 ;
INCHLP(DA) ;File 90310.02 Inclusion field executable help text
 ;
 I $O(DA(""))="" Q
 ;
 NEW DA0,DA1,DA2,ILIST,NNAME,NTYPE,NIEN
 ;
 ;Display the inclusion entries for the current note type
 S DA1=$G(DA(1)) Q:DA1=""
 S DA2=$G(DA(2)) Q:DA2=""
 S DA0=0 F  S DA0=$O(^BCCDS(90310.02,DA2,5,DA1,1,DA0)) Q:'DA0  D
 . S NIEN=$G(^BCCDS(90310.02,DA2,5,DA1,1,DA0,0)) Q:NIEN=""
 . S NNAME=$$GET1^DIQ(8925.1,NIEN_",",.01,"E") Q:NNAME=""
 . S NTYPE=$$GET1^DIQ(8925.1,NIEN_",",.04,"E") Q:NTYPE=""
 . S ILIST(NNAME_"  <"_NTYPE_">")=""
 ;
 I $O(ILIST(""))="" Q
 W !!,"List of current INCLUDE TITLE/DOCUMENT CLASS:",!
 S NNAME="" F  S NNAME=$O(ILIST(NNAME)) Q:NNAME=""  W !,NNAME
 W !
 ;
 Q
 ;
EXCHLP(DA) ;File 90310.02 SITE NOTE EXCLUSION field executable help text
 ;
 I $O(DA(""))="" Q
 ;
 NEW DA0,DA1,ILIST,NNAME,NTYPE,NIEN
 ;
 ;Display the site note exclusion entries
 S DA1=$G(DA(1)) Q:DA1=""
 S DA0=0 F  S DA0=$O(^BCCDS(90310.02,DA1,6,DA0)) Q:'DA0  D
 . S NIEN=$G(^BCCDS(90310.02,DA1,6,DA0,0)) Q:NIEN=""
 . S NNAME=$$GET1^DIQ(8925.1,NIEN_",",.01,"E") Q:NNAME=""
 . S NTYPE=$$GET1^DIQ(8925.1,NIEN_",",.04,"E") Q:NTYPE=""
 . S ILIST(NNAME_"  <"_NTYPE_">")=""
 ;
 I $O(ILIST(""))="" Q
 W !!,"List of current SITE NOTE EXCLUSIONS:",!
 S NNAME="" F  S NNAME=$O(ILIST(NNAME)) Q:NNAME=""  W !,NNAME
 W !
 ;
 Q
 ;
VALTIME ;Validate that the time doesn't include a date and isn't ambiguous, i.e. that times between 1:00 and 5:59 either have a leading zero or specify AM/PM 
 N TM
 S TM=$TR(X,"apm","APM")
 I TM[" "!(TM["@") K X Q  ; Verify the time doesn't include a date
 S TM=$TR(TM,":")
 I TM="" K X Q
 I 'TM Q  ; Allow things like NOW and NOON
 I TM>559 Q  ; Allow times 6:00 and later
 I $E(TM)="0" Q  ; A leading 0 means AM, which is okay
 I TM["A"!(TM["P") Q  ; Specifying AM or PM is okay
 K X  ; Anything else is ambiguous, so disallow it
 Q
