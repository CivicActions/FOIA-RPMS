BRNP06 ;IHS/GDIT/AEF - ENV/PRE/POST INITS FOR PATCH 6
 ;;2.0;IHS RELEASE OF INFORMATION;**6**;APR 10, 2003;Build 11
 ;NEW ROUTINE WITH PATCH 6
 ;
ENV ;EP - ENVIRONMENT CHECK
 ;
 N PKG,VERS
 ;
 D ^XBKVAR
 D HOME^%ZIS
 S XPDQUIT=0
 ;
 ;Prevent 'Disable Options' and 'Move Routines' questions:
 S XPDDIQ("XPZ1")=0,XPDIQ("XPZ2")=0
 ;
 ;Check for current version:
 S PKG="IHS RELEASE OF INFORMATION"
 S VERS=$$VERSION^XPDUTL(PKG)
 I VERS<2 D
 . D BMES^XPDUTL("You must first install IHS RELEASE OF INFORMATION V2.0")
 . S XPDQUIT=2
 Q:XPDQUIT
 ;
 ;Check for BRN*2.0*5:
 I '$$INSTALLD("BRN*2.0*5") D
 . D BMES^XPDUTL("Version 2.0 Patch 5 of IHS RELEASE OF INFORMATION is required!")
 . S XPDQUIT=2
 ;
 Q
INSTALLD(X) ;EP - DETERMINE IF PATCH X WAS INSTALLED
 ;WHERE X IS THE NAME OF THE INSTALL. I.E. "XU*8.0*1019"
 ;
 N INST,Y
 S INST=0
 ;
 ;Find install entry and check if completed:
 S Y=0
 F  S Y=$O(^XPD(9.7,"B",X,Y)) Q:'Y  D
 . S:$P($G(^XPD(9.7,Y,0)),U,9)=3 INST=1
 ;
 ;Display message:
 D IMES(X,INST)
 ;
 Q INST
IMES(X,INST) ;Display message to screen
 ;
 D MES^XPDUTL("Patch """_X_""" is"_$S(INST<1:" *NOT*",1:"")_" installed"_$S(INST<1:"",1:" - *OK*"))
 Q
 ;
 ;----------------------------------------------------------------------
 ;
PRE ;EP - PRE INSTALLATION
 ;
 N DIU
 ;
 ;Remove the ROI DISCLOSURE REASON #90264.07 DD and data:
 ;(It will be put back during installation)
 S DIU=90264.07
 S DIU(0)="D"
 D EN^DIU2
 ;
 Q
 ;
 ;----------------------------------------------------------------------
 ;
POST ;EP - POST INSTALLATION
 ;
 ;NOTE: Be sure to make a back up copy of the ^BRNREC global before
 ;repointing the PURPOSE #.07 field in the ROI Listing Record file
 ;and running the conversion!
 ;
 D CONV
 ;
 Q
 ;
 ;----------------------------------------------------------------------
 ;
CONV ;EP - CONVERSION
 ;----- CONVERT PURPOSE FIELD FROM SOC TO POINTER TO ROI DISCLOSURE
 ;      PURPOSE FILE
 ;
 N CNT,IEN
 ;
 D BMES^XPDUTL("Converting pointers...")
 ;
 ;Quit if conversion has already been run:
 I $D(^BRNPARM("P6CONV")) D  Q
 . D BMES^XPDUTL("Conversion has previously been run!")
 ;
 ;Loop thru ROI LISTING RECORD file and set pointer:
 S CNT=0
 S IEN=0
 F  S IEN=$O(^BRNREC(IEN)) Q:'IEN  D
 . Q:$D(^BRNREC(IEN,"P6CONV"))
 . D SET(IEN,.CNT)
 ;
 ;Message number of records converted:
 D BMES^XPDUTL(CNT_" Records converted!")
 ;
 ;Set conversion node in parameter file:
 ;This is to keep the records from being "converted" again in case
 ;this subroutine is inadvertently run again.
 S ^BRNPARM("P6CONV")=DT
 ;
 Q
SET(IEN,CNT) ;
 ;----- SET THE PURPOSE POINTER
 ;
 N FDA,NPURP,OPURP
 ;
 Q:$D(^BRNREC(IEN,"P6CONV"))
 ;
 ;Get old purpose:
 S OPURP=$$GET1^DIQ(90264,IEN_",",.07,"I")
 I OPURP']"" D
 . ;Set scratch global in case anyone wants to know:
 . S ^BRNP06("BRNP06",$J,"ERR","NULLPURP",IEN)=""
 Q:OPURP']""
 ;
 ;Get new purpose:
 S NPURP=$O(^BRNPURP("C",OPURP,0))
 I 'NPURP D
 . ;Set scratch global in case anyone wants to know:
 . S ^BRNP06("BRNP06",$J,"ERR","NOCONVERT",IEN)=""
 Q:'NPURP
 ;
 ;Set PURPOSE field with new purpose:
 S FDA(90264,IEN_",",.07)=NPURP
 D UPDATE^DIE("","FDA","IEN","ERR")
 ;
 ;Set conversion node in record:
 ;This is to keep the record from being "converted" again in case
 ;this subroutine is inadvertently run again.
 S ^BRNREC(IEN,"P6CONV")=DT
 ;
 ;Set count:
 S CNT=CNT+1
 I '(CNT#100) W "."
 ;
 Q
