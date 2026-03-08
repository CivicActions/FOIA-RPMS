XUSBUSAD ;GDIT/HS/BEE - Description of EPCS log formats to BUSA; 11/29/2011
 ;;8.0;KERNEL;**1019**;Jan 28, 1997;Build 8
 ;
 ;This routine is custom to IHS and is not an original VHA routine. 
 ;It is being released in patch XUS*8.0*1019 as part of the suite
 ;of changes relating to EPCS.
 ;
 ;XUSBUSAD describes the formating utilized by some calls found in XUSBUSA and
 ;in other non-KERNEL EPCS related routines. For the EPCS project it was 
 ;necessary to file information into BUSA that could be readily filtered 
 ;and reported on. To accomplish this, a specific format was decided upon.
 ;EPCS related BUSA entries will contain BUSA AUDIT LOG SUMMARY file 
 ;ENTRY DESCRIPTION fields that are formatted as follows:
 ;
 ;BUSA AUDIT LOG SUMMARY (#9002319.01) file, ENTRY DESCRIPTION (#1) field format:
 ;
 ;  "|" Piece   Value
 ;  1           External Description of Event
 ;  2           TYPE~x (opt) - Where x is L (Login), O (Option), K (Key), M (Menu),
 ;                             C (Credential), P (Pharmacy), X (Prescribing), 
 ;                             PP (Provider Profile), S (Services), G (General)
 ;  3           RSLT~x (opt) - Where x is S (Success), F (Failure)
 ;  4           NAMSP~x (opt) - Where x is the namespace of the option package, 
 ;                              routine name, or the key name
 ;  5           OPTION (opt) - The IEN of the File 19 entry, if option tracking
 ;  6           EP~x (opt) - Where x is E (EPCS), P (Pharmacy), EP (Both) 
 ;  7           EPCSxxx (opt) - EPCS followed by the appropriate Event Code
 ;  8+          Fields available for custom application information storage
 ;
 ;Routine XUSBUSA 
 ;
 ;This routine contains API calls which are now being utilized by other 
 ;KERNEL routines and triggers/cross references on KERNEL file fields. Some
 ;API calls (tag LOG in particular) are being utilized by non-KERNEL routines.
 ;Many calls in this routine allow information such as user RPMS login 
 ;success/failure actions, RPMS options accessed, security key allocations
 ;and primary/secondary menu allocations to be recorded as entries in BUSA.
 ;
 ;*Because the DUZ variable may not always be available and BUSA
 ;requires that DUZ be populated, the DUZ variable, if not defined
 ;will temporarily be set to the USER parameter (if defined).  If not defined
 ;it will temporarily be set to the new 'XUS,PROXY USER' user account that is
 ;was delivered with XU*8.0*1019.
 ;time of the BUSA log entry request.
 ;
 ;As mentioned, XUSBUSA contains the LOG API/tag that is utilized by a 
 ;number of applications outside of KERNEL.  The LOG API acts as an
 ;intermediary between XUSBUSA/other applications and the $$LOG^BUSAAPI API. 
 ;Calling $$LOG^XUSBUSA instead of $$LOG^BUSAPI will enable the following:
 ;
 ;1) Entries will be saved in BUSA regardless of whether BUSA is turned on or off
 ;2) A hash value will be recorded in the saved BUSA entry
 ;3) An alternate user DUZ can be passed in to utilize if DUZ is not defined. Further,
 ;   if neither value is specified, the entry will get saved under "XUS,PROXY USER"
 ;
 ;The $$LOG^XUSBUSA API call has the following parameters:
 ;
 ;LOG(TYPE,CAT,ACTION,CALL,DESC,DETAIL,USER) ;PEP - Create HASHed BUSA log entry
 ;
 ;Input Parameters:
 ;  TYPE - (Optional) - The type of entry to log (R:RPC Call;W:Web Service
 ;         Call;A:API Call;O:Other)
 ;         (Default - A)
 ;   CAT - (Required) - The category of the event to log (S:System Event;
 ;         P:Patient Related;D:Definition Change;
 ;         O:Other Event)
 ;ACTION - (Required for CAT="P") - The action of the event to log
 ;         (A:Additions;D:Deletions;Q:Queries;P:Print;
 ;         E:Changes;C:Copy)
 ;  CALL - (Required) - Free text entry describing the call which 
 ;         originated the audit request (Maximum length
 ;         200 characters)
 ;         Examples could be an RPC value or calling
 ;         routine
 ;  DESC - (Required) - Free text entry describing the call action
 ;         (Maximum length 250 characters)
 ;         Examples could be 'Patient demographic update',
 ;         'Copied iCare panel to clipboard' or 'POV Entry'
 ;DETAIL - Array of patient/visit records to log. Required for patient 
 ;         related events. Optional for other event types
 ;         Format: DETAIL(#)=DFN^VIEN^EVENT DESCRIPTION^NEW VALUE^ORIGINAL VALUE
 ;  USER - User to log activity for if DUZ is not defined
 ;
 Q
