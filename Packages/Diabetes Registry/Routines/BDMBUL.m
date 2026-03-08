BDMBUL ; IHS/CMI/GRL - Routine to create bulletin; [ 02/16/05  1:45 PM ]
 ;;1.0;DIABETES MANAGEMENT SYSTEM;**2,3,4,5**;OCT 01, 2000
 ;;
 ;;Here's how to make this work:
 ;;
 ;;1. Create your message in subroutine WRITEMSG
 ;;2. Identify recipients in GETRECIP by setting appropriate key
 ;;3. Make changes in SUBJECT and SENDER as desired
 ;;4. Callthis routine on completion of patch or upgrade
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR ZERO.",! Q
 D HOME^%ZIS,DT^DICRW
 ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,DIFROM
 KILL ^TMP($J,"BDMBUL")
 D WRITEMSG,GETRECIP
 ;Change following lines as desired
SUBJECT S XMSUB="* * * IMPORTANT RPMS INFORMATION * * *"
SENDER S XMDUZ="Diabetes Management System Coordinator" ;IHS/CMI/TMJ PATCH #5
 S XMTEXT="^TMP($J,""BDMBUL"",",XMY(1)="",XMY(DUZ)=""
 I $E(IOST)="C" W !,"Sending Mailman message to holders of the"_" "_BDMKEY_" "_"security key."
 D ^XMD
 KILL ^TMP($J,"BDMBUL"),BDMKEY
 Q
 ;
WRITEMSG ;
 F %=3:1 S X=$P($T(WRITEMSG+%),";",3) Q:X="###"  S ^TMP($J,"BDMBUL",%)=X
 Q
 ;;  
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;+     This message is intended to advise you of changes,        +
 ;;+     upgrades or other important RPMS information
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;PCC Diabetes Management System patch 5 has recently been installed, and
 ;;includes the following modifications/enhancements:
 ;;   
 ;;1. Various technical programming changes.
 ;;
 ;;2. Adds new status of NON-COMPLIANT.
 ;;
 ;;3. Synchronizes all PROVIDER references to use either the NEW PERSON
 ;;   file depending on the data definition of the NAME field of
 ;;   the PATIENT file.
 ;;
 ;;4. Allows for various reports to combine Type 1 and Type 2 diabetes.
 ;;
 ;;5. Synchronizes follow-up items with the DM AUDIT criteria.
 ;;
 ;;6. Synchronizes Lab & Immunization Items with DM AUDIT criteria.
 ;;
 ;;7. Now reflects the 2003 Audit and future 2005 Audit criteria.
 ;;
 ;;8. Adds new Menu Option (Edit Primary Care Provider) under the
 ;;   Register Maintenance Menu Option.
 ;;
 ;;9.  Diagnosis is no longer a required field on the Edit
 ;;    Register Data Screen under the Patient Management Option.
 ;;
 ;;10. Added CASE MGR to the Register Data Screen under the
 ;;    Patient Management Option.
 ;;
 ;;11. Allows a User to change the diagnosis on the Register Data
 ;;    Screen.  In the past both the previous and new diagnosis
 ;;    were displayed.
 ;;
 ;;12. Reversed the display of the Problem Number and the Date of Onset
 ;;    on the DMU Screen so that the User realizes they must have
 ;;    an active problem number before entering Date of Onset.
 ;;
 ;;
 ;;
 ;;For additional information contact your RPMS site manager, Area Office RPMS or
 ;;the ITSC HELP DESK at ITSCHELP@mail.ihs.gov (505) 248-4371.
 ;;
 ;;  
 ;;+++++++++++++++++++++ End of Announcement +++++++++++++++++++++++
 ;;###
 ;
GETRECIP ;
 ;* * * Define key below to identify recipients * * *
 ;
 S CTR=0,BDMKEY="BDMZMENU"
 F  S CTR=$O(^XUSEC(BDMKEY,CTR)) Q:'CTR  S Y=CTR S XMY(Y)=""
 Q
