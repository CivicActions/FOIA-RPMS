AGMP1P01 ;IHS/SD/TPF - MPI PRE AND POST INSTALL; JAN 07, 2011
 ;;1.0;AGMP;**1**;Apr 30, 2021;Build 28
 ;
 Q
 ;
PRE ;EP - PRE INSTALL
 Q
 ;
POST ;EP - POST INSTALL ACTIONS
 N TRNM,TRIEN,ERR
 ;
 ;LOAD CLASSES
 D BMES^XPDUTL("  Importing AGMPI classes")
 S TRNM=$G(@XPDGREF@("SENT REC"))
 I TRNM="" D BMES^XPDUTL("  Error 'import 1' occurred during post-install.  Install aborted.") Q
 S TRIEN=$O(^AGMPCLS("B",TRNM,""))
 I $G(TRIEN)="" D BMES^XPDUTL("  Error 'import 2' occurred during post-install.  Install aborted.") Q
 D IMPORT(TRIEN,.ERR)
 I $G(ERR) D  Q
 . D BMES^XPDUTL("  Error 'import 3' occurred duing post-install. Install aborted.")
 . F I=1:1 Q:'$D(ERR(I))  D BMES^XPDUTL("  "_ERR(I))
 Q
 ;
 ; Imports the schemas into the AGMPI namespace, because they aren't mapped like regular classes
IMPORT(REC,ERR) ;
 ; Returns ERR if there are any errors.
 N EXEC,I,STREAM,STRING,B64,COMP,LOADED,NS,MPINS
 N @("$NAMESPACE")
 S @("NS=$NAMESPACE")
 S MPINS="AGMPI"_NS
 ; Verify namespace exists
 I @("'##class(%SYS.Namespace).Exists(MPINS)") S ERR=1 G EXIT
 ;
 S ERR=0
 I $G(REC)="" Q
 I '$D(^AGMPCLS(REC)) Q
 I $G(DT)'?7N.E S DT=$$DT^XLFDT
 ; Change the value of field RPMS STATUS in 9002021.02 to "I"
 K DA S DA=REC,DIE="^AGMPCLS(",DR="1.02////I" D ^DIE
 ;
 ; Create a new global-based character stream
 S EXEC="S STREAM=##class(%Stream.GlobalCharacter).%New()" X EXEC
 ;
 ; Copy the XML from the distribution global to a stream
 S I=0
 F  D  Q:B64=""
 . S B64=""
 . F  S I=$O(^AGMPCLS(REC,10,I)) Q:'I  S STR=^AGMPCLS(REC,10,I,0) Q:STR["SEGMENT END"  S B64=B64_STR_$C(13,10)
 . I B64="" Q
 . S EXEC="S COMP=$System.Encryption.Base64Decode(B64)" X EXEC
 . S EXEC="S STRING=$System.Util.Decompress(COMP)" X EXEC
 . S EXEC="D STREAM.Write(STRING)" X EXEC
 ;
 ; Switch to AGMPI namespace to load the schemas
 S @("$NAMESPACE=MPINS")
 ;
 ; First check that the received classes are OK. Pass "1" in the 5th parameter
 ; so that the import won't actualy happen. Then analyze the value of "ERR"
 S EXEC="D $System.OBJ.LoadStream(STREAM,""ckfsbry/lock=0/journal=0"",.ERR,.LOADED,1)"
 X EXEC
 ; Error processing after the dry run
 I ERR S @("$NAMESPACE=NS") G EXIT
 ;
 ; Actually load and compile the classes.
 S EXEC="D $System.OBJ.LoadStream(STREAM,""ckfsbry/lock=0/journal=0"",.ERR,.LOADED)"
 X EXEC
 ; Error processing after the actual load
 I ERR S @("$NAMESPACE=NS") G EXIT
 ;
 ; Switch back to the RPMS namespace to update the file
 S @("$NAMESPACE=NS")
 ;
 S CLASS="" F  S CLASS=$O(LOADED(CLASS)) Q:CLASS=""  D
 . S DIC="^AGMPCLS("_REC_",11,",DIC(0)="L",DLAYGO=1
 . S DA(1)=REC
 . S X=CLASS
 . D ^DIC
 ; Change the value of the field RPMS STATUS in 9002021.02 to "R"
 ; and populate RPMS DATE/TIME INSTALLED
 S DIE="^AGMPCLS("
 K DA S DA=REC
 ; Set Status to READY
 W !,"Updating 9002021.02 record"
 D NOW^%DTC
 S DR="1.02////C;1.03////"_%
 D ^DIE
EXIT ;
 I ERR D
 . D BGERROR^AGMPCLAS
 Q
