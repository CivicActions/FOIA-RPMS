ADSCLAS ;GDIT/IHS/AEF - Post Install to install class
 ;;1.0;DISTRIBUTION MANAGEMENT;**4**;Apr 23, 2020;Build 24
EN Q
 ;
 ; Main entry point
IMPORT(REC,ERR) ;
 ; Returns ERR if there are any errors.
 N EXEC,I,STREAM,STRING,B64,COMP,LOADED,CLASS,DIE,DLAYGO,DR,ERRTEXT,ERRTXT,STR,X,Y,%
 S ERR=0
 I $G(REC)="" Q
 I '$D(^ADSCLS(REC)) Q
 I $G(DT)'?7N.E S DT=$$DT^XLFDT
 ; Change the value of field RPMS STATUS in 9002299.1 to "I"
 K DA S DA=REC,DIE="^ADSCLS(",DR="1.02////I" D ^DIE
 ;
 ; Create a new global-based character stream
 S EXEC="S STREAM=##class(%Stream.GlobalCharacter).%New()" X EXEC
 ;
 ; Copy the XML from the distribution global to a stream
 S I=0
 F  D  Q:B64=""
 . S B64=""
 . F  S I=$O(^ADSCLS(REC,10,I)) Q:'I  S STR=^ADSCLS(REC,10,I,0) Q:STR["SEGMENT END"  S B64=B64_STR_$C(13,10)
 . I B64="" Q
 . S EXEC="S COMP=$System.Encryption.Base64Decode(B64)" X EXEC
 . S EXEC="S STRING=$System.Util.Decompress(COMP)" X EXEC
 . S EXEC="D STREAM.Write(STRING)" X EXEC
 ;
 ; First check that the received classes are OK. Pass "1" in the 5th parameter
 ; so that the import won't actualy happen. Then analyze the value of "ERR"
 S EXEC="D $System.OBJ.LoadStream(STREAM,""ckfsbry/lock=0/journal=0"",.ERR,.LOADED,1)"
 X EXEC
 ; Error processing after the dry run
 I ERR D BGERROR G EXIT
 ;
 ; Actually load and compile the classes.
 S EXEC="D $System.OBJ.LoadStream(STREAM,""ckfsbry/lock=0/journal=0"",.ERR,.LOADED)"
 X EXEC
 ; Error processing after the actual load
 I ERR D BGERROR G EXIT
 ;
 S CLASS="" F  S CLASS=$O(LOADED(CLASS)) Q:CLASS=""  D
 . S DIC="^ADSCLS("_REC_",11,",DIC(0)="L",DLAYGO=1
 . S DA(1)=REC
 . S X=CLASS
 . D ^DIC
 ; Change the value of the field RPMS STATUS in 9002299.1 to "R"
 ; and populate RPMS DATE/TIME INSTALLED
 S DIE="^ADSCLS("
 K DA S DA=REC
 ; Set Status to READY
 W !,"Updating 9002299.1 record"
 D NOW^%DTC
 S DR="1.02////C;1.03////"_%
 D ^DIE
EXIT ;
 Q
 ;
BGERROR ;
 S DIE="^ADSCLS("
 I '$G(REC) Q
 I '$D(^ADSCLS(REC)) Q
 K DA S DA=REC
 ; Set Status to ERROR
 S DR="1.02////E"
 D ^DIE
 Q
 ;
EXPORT ;
 N ERR,EXEC,I,MASK,STREAM,XML,NAME,COMP,B64
 K CLASSES
 W !,"Enter class(es) to distribute, one at a time.  Wildcards OK."
 W !,"E.g, PACKAGE.CLASS.G*.CLS.   Hit <ENTER> when finished"
 S EXEC="F  R !,""Class: "",MASK:60 Q:MASK=""""  S:MASK'?1.E1"".CLS""&(MASK'?1.E1"".cls"")&(MASK'?1.E1"".hl7"")&(MASK'?1.E1"".HL7"") MASK=MASK_"".CLS"" S CLASSES(MASK)="""""
 X EXEC
 Q:'$D(CLASSES)
 ; Create a new global-based character stream
EXPGO ;
 ; Create new record in 9002299.1 with IEN of REC
 ; Populate Name (not sure what it should be), Date/Time, and set status to I
 K DO,DA S DIC=9002299.1,DLAYGO=9002299.1,DIC(0)="L",X=$S($G(NAME)'="":NAME,1:"New Record for "_$H)
 S DIC("DR")=".01////"_X_";1.02////I"
 D ^DIC
 I Y=-1 S ERR=1,ERR(1)="Failed to create a record" D ERROR Q
 S REC=+Y
 ; Populate the new record
 S ERR=0,U="^"
 S EXEC="S STREAM=##class(%Stream.GlobalCharacter).%New()"
 X EXEC
 ; Export a list of classes/routines/etc to the stream as XML
 S EXEC="D $System.OBJ.ExportToStream(.CLASSES,.STREAM,""/mapped=1"",.ERR)"
 X EXEC
 ; ADD ERROR LOG
 I ERR D ERROR Q
 F  S EXEC="S STR=STREAM.Read(1000000)" X EXEC Q:STR=""  D  Q:ERR
 . S EXEC="S COMP=$System.Util.Compress(STR)" X EXEC
 . S EXEC="S B64=$System.Encryption.Base64Encode(COMP)" X EXEC
 . I $L(B64)="" S ERR=1,ERR(1)="Failed to create encrypted stream" D ERROR Q
 . S B64=$TR(B64,$C(10))
 . F I=1:1 SET XML=$P(B64,$C(13),I) Q:XML=""  D POPULATE(REC,XML) Q:ERR
 . I ERR D ERROR
 . D POPULATE(REC,"------------------------- SEGMENT END ------------------------")
 S DIE="^ADSCLS("
 K DA S DA=REC
 ; Set Status to READY
 S DR="1.02////R"
 D ^DIE
 W !,"Record ",REC," created"
 Q
 ;
POPULATE(REC,XML) ;
 S DA(1)=REC
 K DIC S DIC="^ADSCLS("_DA(1)_",10," ;XML Subfile
 S DIC(0)="L",DLAYGO=1 ;LAYGO to the subfile
 S X=XML
 ; S X=$$ENCODE(XML)
 ; Add XML Data as the .01 field
 D FILE^DICN
 I Y=-1 S ERR="Failed to create XML subfield entry" Q
 Q
ERROR ;
 S ERRTEXT=""
 I $D(ERR)=1,ERR'=0 S ERRTXT=ERR
 I $D(ERR)>10 S I="",ERRTXT="" F  S I=$O(ERR(I)) Q:'I  S ERRTXT=ERRTXT_$G(ERR(I))_" "
 W !,!,ERRTXT
 Q
