BCCDCLAS ;GDIT/HS/AM-Post Install ; 18 Apr 2013  12:51 PM
 ;;1.0;CCDA;**1,2**;Feb 21, 2014;Build 16
EN Q
 ;
 ; Main entry point
IMPORT(REC,ERR) ;
 ; Returns ERR if there are any errors.
 N EXEC,I,STREAM,STRING,B64,COMP,LOADED
 S ERR=0
 I $G(REC)="" Q
 I '$D(^BCCDCLS(REC)) Q
 I $G(DT)'?7N.E S DT=$$DT^XLFDT
 ; Change the value of field RPMS STATUS in 90310.03 to "I"
 K DA S DA=REC,DIE="^BCCDCLS(",DR="1.02////I" D ^DIE
 ;
 ; Create a new global-based character stream
 S EXEC="S STREAM=##class(%Stream.GlobalCharacter).%New()" X EXEC
 ;
 ; Copy the XML from the distribution global to a stream
 S I=0
 F  D  Q:B64=""
 . S B64=""
 . F  S I=$O(^BCCDCLS(REC,10,I)) Q:'I  S STR=^BCCDCLS(REC,10,I,0) Q:STR["SEGMENT END"  S B64=B64_STR_$C(13,10)
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
 . S DIC="^BCCDCLS("_REC_",11,",DIC(0)="L",DLAYGO=1
 . S DA(1)=REC
 . S X=CLASS
 . D ^DIC
 ; Change the value of the field RPMS STATUS in 90310.03 to "R"
 ; and populate RPMS DATE/TIME INSTALLED
 S DIE="^BCCDCLS("
 K DA S DA=REC
 ; Set Status to READY
 W !,"Updating 90310.03 record"
 D NOW^%DTC
 S DR="1.02////C;1.03////"_%
 D ^DIE
EXIT ;
 Q
 ;
BGERROR ;
 ;W !,"Class import process errored out with error ",$G(ERR)
 ;W !,"Please contact IHS National."
 ; Change the value of the field RPMS STATUS in 90310.03 to "E"
 ; S ERRTEXT=""
 S DIE="^BCCDCLS("
 I '$G(REC) Q
 I '$D(^BCCDCLS(REC)) Q
 K DA S DA=REC
 ; Set Status to ERROR
 S DR="1.02////E"
 D ^DIE
 ; Patch 2: Removed code that filed error into non-existent 90310.02;2 field - GCD 2/09/2015
 Q
 ;
