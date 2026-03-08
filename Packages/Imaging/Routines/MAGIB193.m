MAGIB193 ;IHS/WOIFO/JSL - INSTALL CODE FOR BMAG*193 ; 18 July 2022 10:10 AM
 ;;3.0;IMAGING;**193**;05 May 2022
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
 ;--- Link new remote procedures to the EHR context option
 ;   Add rpc 'BMAG FILTER SAVE USER DEFAULT' to the 'CIAV VUECENTRIC' Option RPC multiple
 S CALLBACK="$$ADDRPCS^"_$NA(MAGKIDS1("RPCLST^"_$T(+0),"CIAV VUECENTRIC"))
 I $$CP^MAGKIDS("MAG ATTACH RPCS",CALLBACK)<0 D ERROR Q
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
 ;;BMAG FILTER SAVE USER DEFAULT
 ;;MAG3 LOOKUP ANY
 ;;MAG4 FILTER DETAILS
 ;;MAG4 FILTER GET LIST
 ;;MAGGUSERKEYS 
 Q 0
 ;
