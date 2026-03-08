BDMBUL6 ; IHS/CMI/TMJ - Routine to create bulletin; [ 05/11/06  3:52 PM ]
 ;;1.0;DIABETES MANAGEMENT SYSTEM;**6**;OCT 01, 2000
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
SENDER S XMDUZ="Diabetes Management System Coordinator"
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
 ;;PCC Diabetes Management System patch 6 has recently been installed, and
 ;;includes the following modifications/enhancements:
 ;;   
 ;;1. Various technical programming changes.
 ;;
 ;;2. Adds new New General Retrieval Items-
 ;;
 ;;1.  Initial Entry Date
 ;;2.  Inactivation Date
 ;;3.  Risk Factors
 ;;4.  DX Criteria
 ;;5.  Intervention
 ;;6.  Intervention Due Date
 ;;7.  Intervention Result Date
 ;;8.  Intervention Results
 ;;9.  Mlg Address - State
 ;;10. Mlg Address - Zip
 ;;
 ;;3. Letter Education Inserts
 ;;1.  Foot Exam
 ;;2.  Eye Exam
 ;;3.  Dental Exam
 ;;4.  Flu Shot
 ;;5.  Tetanus
 ;;6.  PPD
 ;;7.  A1C Hemoglobin
 ;;8.  Creatinine
 ;;9.  Urine Test
 ;;10. Lipid Panel
 ;;11. Pap Smear
 ;;12. All Education
 ;;13. Nutrition
 ;;14. Exercise
 ;;15. Microalbumin
 ;;16. Text Follow up
 ;;
 ;;The new Text Follow up insert will print the follow up item needed
 ;;and then will automatically print the associated Education text
 ;;for that follow up item.
 ;;
 ;;4. Self Glucose Monitoring Report
 ;;
 ;;5. Fix to Follow-up Report
 ;;
 ;;6. Ability to print a selected Flow Sheet from PM Menu
 ;;
 ;;7. Modified Lister Routines to accommodate DMS GUI Interface
 ;;
 ;;8. New routine BDMKILL to kill of all BDM Variables.
 ;;
 ;;9. Added new menu option to create Taxonomy Setup for both the IHS Standard
 ;;Diabetes Register and the IHS Standard Pre-Diabetes Register.
 ;;
 ;;10.  Removed Diagnosis update from the Register Data Action Item #1 
 ;;under Patient Management.  Replaced Item #20 (Order Entry/Results Dep)
 ;;with the new Action Item called Diagnosis.  
 ;;This new item allows the User to Add/Edit/Delete multiple diagnosis
 ;;(similar to item #2 Complication Action Item).
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
