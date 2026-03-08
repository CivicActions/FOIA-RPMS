RA501012 ;IHS/OIT/NST - INSTALL CODE FOR RA*5.0*1012 ; 03 Feb 2025 10:10 AM
 ;;5.0;Radiology/Nuclear Medicine;**1012**;Mar 16, 1998;Build 1
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
 N CALLBACK,ERR,X,MSG,IEN1,IEN2,IENS,BRAFDA,BRAIENS,BRAERR
 D CLEAN^DILF
 ;
 S X=$$ADDRPCS("RPCLST^RA501012","CIAV VUECENTRIC")
 ;
 ; Add RA ALARA TCP REPORT as a subscriber of RA ALARA TCP SERVER RPT
 ;
 K MAGFDA
 S IEN1=$$FIND1^DIC(101,"","BX","RA ALARA TCP SERVER RPT") ; Get [RA ALARA TCP SERVER RPT] IEN
 I 'IEN1 D  Q
 . S MSG(1)="RA ALARA TCP SERVER RPT protocol not found"
 . D BMES^MAGKIDS("Error in Updating: ",.MSG)
 . Q
 ;
 S IEN2=$$FIND1^DIC(101,"","BX","RA ALARA TCP REPORT") ; Get [RA ALARA TCP REPORT] IEN
 I 'IEN2 D  Q
 . S MSG(1)="RA ALARA TCP REPORT not found"
 . D BMES^MAGKIDS("Error in Updating: ",.MSG)
 . Q
 ;
 S IENS="?+1,"_IEN1_","
 S BRAFDA(101.0775,IENS,.01)=IEN2
 D UPDATE^DIE("","BRAFDA","BRAIENS","BRAERR")
 I $D(DIERR) D  Q
 . D MES^MAGKIDS("Error in updating event driver protocol [RA ALARA TCP SERVER RPT].")
 . F I=1:1 Q:'$D(BRAERR("DIERR",1,"TEXT",I))  D
 . . D MES^MAGKIDS(BRAERR("DIERR",1,"TEXT",I))
 . . Q
 . Q
 ;
 ;--- Send the notification e-mail
 D BMES^XPDUTL("Post Install Mail Message: "_$$FMTE^XLFDT($$NOW^XLFDT))
 Q
 ;
 ;***** PRE-INSTALL CODE
PRE ;; NONE
 Q
 ;+++++ LIST OF NEW REMOTE PROCEDURES
 ; have a list in format ;;MAG4 IMAGE LIST
RPCLST ;
 ;;BRANCLNI REQUIRED
 Q 0
 ;
ADDRPCS(RPCNAMES,OPTNAME,FLAGS) ;
 N IENS,MAGFDA,MAGMSG,MAGRC,NAME,OPTIEN,RPCIEN,SILENT,DIERR,X
 ;
 ;=== Validate and prepare parameters
 S FLAGS=$G(FLAGS),SILENT=(FLAGS["S")
 ;--- Single RPC name or a list?
 I $D(RPCNAMES)<10  Q:$G(RPCNAMES)?." " $$IPVE^MAGUERR("RPCNAMES")  D
 . N I,GET
 . ;--- Get the list from the source code
 . S GET=$P(RPCNAMES,"^")_"+I^"_$P(RPCNAMES,"^",2)
 . S GET="S NAME=$$TRIM^XLFSTR($P($T("_GET_"),"";;"",2))"
 . F I=1:1  X GET  Q:NAME=""  S RPCNAMES(NAME)=""
 . Q
 ;--- Name of the menu option (RPC Broker context)
 S OPTIEN=$$LKOPT^XPDMENU(OPTNAME)
 Q:OPTIEN'>0 $$ERROR^MAGUERR(-44,,OPTNAME)
 ;
 ;=== Add the names to the multiple
 D:'SILENT BMES^MAGKIDS("Attaching RPCs to the '"_OPTNAME_"' option...")
 S NAME="",MAGRC=0
 F  S NAME=$O(RPCNAMES(NAME))  Q:NAME=""  D  Q:MAGRC<0
 . D:'SILENT MES^MAGKIDS(NAME)
 . ;--- Check if the remote procedure exists
 . S RPCIEN=$$FIND1^DIC(8994,,"X",NAME,"B",,"MAGMSG")
 . I $G(DIERR)  S MAGRC=$$DBS^MAGUERR("MAGMSG",8994)  Q
 . I RPCIEN'>0  S MAGRC=$$ERROR^MAGUERR(-45,,NAME)  Q
 . ;--- Add the remote procedure to the multiple
 . S IENS="?+1,"_OPTIEN_","
 . S MAGFDA(19.05,IENS,.01)=RPCIEN
 . D UPDATE^DIE(,"MAGFDA",,"MAGMSG")
 . I $G(DIERR)  S MAGRC=$$DBS^MAGUERR("MAGMSG",19.05,IENS)  Q
 . ;---
 . Q
 I MAGRC<0  D:'SILENT MES^MAGKIDS("ABORTED!")  Q MAGRC
 ;
 ;=== Success
 D:'SILENT MES^MAGKIDS("RPCs have been successfully attached.")
 Q 0
