RA501013 ;IHS/OIT/NST - INSTALL CODE FOR RA*5.0*1013 ; 10 Jul 2025 10:10 AM
 ;;5.0;Radiology/Nuclear Medicine;**1013**;Mar 16, 1998;Build 1
 ;;
 Q
 ;
 ;+++++ INSTALLATION ERROR HANDLING
ERROR ;
 S:$D(XPDNM) XPDABORT=1
 ;--- Display the messages and store them to the INSTALL file
 D DUMP^MAGUERR1(),ABTMSG^MAGKIDS()
 Q
 ;
 ;***** POST-INSTALL CODE
POS ;
 N X
 D CLEAN^DILF
 ;
 ; Skip adding it in post install S X=$$ADDDCODE("DIAGLIST^RA501013")  ; Add diagnostic codes
 ;
 ;--- Send the notification e-mail
 D BMES^XPDUTL("Post Install Mail Message: "_$$FMTE^XLFDT($$NOW^XLFDT))
 Q
 ;
 ;***** PRE-INSTALL CODE
PRE ;; NONE
 Q
 ;
ADDDCODE(DCODES) ; Add diagnostic codes to DIAGNOSTIC CODES file (#78.3)
 N BRAERR,BRAIEN,BRAFDA,BRAMSG,BRARC,CODES,DCODE,I,GET,NAME,X,IEN,IENS
 ;
 D BMES^XPDUTL("   Adding diagnostic codes to DIAGNOSTIC CODES file (#78.3) ...")
 ;
 ;--- Get the list from the source code
 S GET=$P(DCODES,"^")_"+I^"_$P(DCODES,"^",2)
 S GET="S NAME=$$TRIM^XLFSTR($P($T("_GET_"),"";;"",2))"
 F I=1:1  X GET  Q:NAME=""  S CODES($P(NAME,"^"))=NAME
 ;
 S IEN="",BRARC=0
 F  S IEN=$O(CODES(IEN))  Q:IEN=""  D  Q:BRARC<0
 . ;--- Check if the diagnostic code exists
 . I $D(^RA(78.3,IEN)) D  Q
 . .  D MES^XPDUTL(IEN_":   "_$P(CODES(IEN),"^",2)_" found")
 . Q
 . ;
 . ;--- Add diagnostic code
 . K BRAFDA
 . S IENS="+1,"
 . S BRAIEN(1)=IEN
 . S BRAFDA(78.3,IENS,.01)=$P(CODES(IEN),"^",2)
 . S BRAFDA(78.3,IENS,2)=$P(CODES(IEN),"^",3)
 . S BRAFDA(78.3,IENS,3)=$P(CODES(IEN),"^",4)
 . S BRAFDA(78.3,IENS,4)=$P(CODES(IEN),"^",5)
 . D UPDATE^DIE("E","BRAFDA","BRAIEN","BRAERR")
 . I $D(BRAERR("DIERR",1,"TEXT")) D  Q
 . . S BRARC=-1
 . . D MES^XPDUTL("   Error adding diagnostic code "_IEN_": "_$P(CODES(IEN),"^",2))
 . . F I=1:1 Q:'$D(BRAERR("DIERR",1,"TEXT",I))  D
 . . . D MES^XPDUTL("   "_BRAERR("DIERR",1,"TEXT",I))
 . . . Q
 . . Q
 . Q
 I BRARC<0  D MES^XPDUTL("   ABORTED!")  Q BRARC
 ;
 ;=== Success
 D MES^XPDUTL("   Diagnositc codes have been successfully added.")
 Q 0
 ;
DIAGLIST  ; DIAGNOSTIC CODES list e.g.;;2000^BI-RADS^NEGATIVE^NO^no 
 ;;2000^BI-RADS^^Y^n
 ;;2001^LI-RADS^^N^n
 ;;2002^US LI-RADS^^N^n
 ;;2003^PI-RADS^^N^n
 ;;2004^TI-RADS^^N^n
 Q 0
