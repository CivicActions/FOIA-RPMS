MAGIB196 ;IHS/WOIFO/NST - INSTALL CODE FOR BMAG*196 ; 06 June 2024 10:10 AM
 ;;3.0;IMAGING;**196**;05 May 2022
 ;; Per VHA Directive 2004-038, this routine should not be modified.
 ;; +---------------------------------------------------------------+
 ;; | Property of the US Government.                                |
 ;; | No permission to copy or redistribute this software is given. |
 ;; | Use of unreleased versions of this software requires the user |
 ;; | to execute a written test agreement with the VistA Imaging    |
 ;; | Development Office of the Department of Veterans Affairs,     |
 ;; | telephone (301) 734-0100.                                     |
 ;; |                                                               |
 ;; | The Food and Drug Administration classifies this software as  |
 ;; | a medical device.  As such, it may not be changed in any way. |
 ;; | Modifications to this software may result in an adulterated   |
 ;; | medical device under 21CFR820, the use of which is considered |
 ;; | to be a violation of US Federal Statutes.                     |
 ;; +---------------------------------------------------------------+
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
 N CALLBACK
 D CLEAR^MAGUERR(1)
 ;
 S X=$$ADDRPCS^MAGIB196("RPCLST^MAGIB196","CIAV VUECENTRIC")
 ;
 ;--- Send the notification e-mail
 D BMES^XPDUTL("Post Install Mail Message: "_$$FMTE^XLFDT($$NOW^XLFDT))
 I $$CP^MAGKIDS("MAG NOTIFICATION","$$NOTIFY^MAGKIDS1")<0 D ERROR Q
 Q
 ;
 ;***** PRE-INSTALL CODE
PRE ;; NONE
 Q
 ;+++++ LIST OF NEW REMOTE PROCEDURES
 ; have a list in format ;;MAG4 IMAGE LIST
RPCLST ;
 ;;BMAG IMAGE INFO ADVANCED
 ;;MAG3 CPRS TIU NOTE
 ;;MAG3 LOOKUP ANY
 ;;MAG4 FILTER DELETE
 ;;MAG4 FILTER DETAILS
 ;;MAG4 FILTER GET LIST
 ;;MAG4 FILTER SAVE
 ;;MAG4 GET IMAGE INFO
 ;;MAG4 INDEX GET EVENT
 ;;MAG4 INDEX GET ORIGIN
 ;;MAG4 INDEX GET SPECIALTY
 ;;MAG4 INDEX GET TYPE
 ;;MAGGRPT
 ;;MAGN CPRS IMAGE LIST
 ;;TIU DOCUMENTS BY CONTEXT
 ;;TIU GET RECORD TEXT
 Q 0
 ;
ADDRPCS(RPCNAMES,OPTNAME,FLAGS) ;
 N IENS,MAGFDA,MAGMSG,MAGRC,NAME,OPTIEN,RPCIEN,SILENT
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
