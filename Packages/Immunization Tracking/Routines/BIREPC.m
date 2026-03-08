BIREPC ;IHS/CMI/MWR - REPORT, COVID IMM; OCT 15,2010 ; 18 Jan 2022  2:08 PM
 ;;8.5;IMMUNIZATION;**24,25**;OCT 24,2011;Build 22
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW COVID IMMUNIZATION REPORT.
 ;;  PATCH 5: Display new beginning date as July 1.  INIT+20, TEXT1.
 ;
 ;
 ;----------
START ;EP
 ;---> Listman Screen for printing Immunization Due Letters.
 D SETVARS^BIUTL5 N BIRTN
 ;
 ;---> If Vaccine Table is not standard, display Error Text and quit.
 I $D(^BISITE(-1)) D ERRCD^BIUTL2(503,,1) Q
 ;
 D EN
 D EXIT
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for BI LETTER PRINT DU
 D EN^VALM("BI REPORT COVID IMM")
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.  vvv83
 S VALM("TITLE")=$$LMVER^BILOGO
 S VALMSG="Select a left column number to change an item."
 N BILINE,X S BILINE=0
 D WRITE(.BILINE)
 S X=IOUON_"COVID IMMUNIZATION REPORT" D CENTERT^BIUTL5(.X,42)
 D WRITE(.BILINE,X_IOINORM)
 K X
 ;
 ;---> Date.
 D WRITE(.BILINE)
 S:'$G(BIQDT) BIQDT=$G(DT)
 D DATE^BIREP(.BILINE,"BIREPC",1,BIQDT,"Ending Date",,,,1)
 ;
 ;---> Current Community.
 D DISP^BIREP(.BILINE,"BIREPC",.BICC,"Community",2,1,,,36)
 ;
 ;---> Health Care Facility.
 N A,B S A="Health Care Facility",B="Facilities"
 D DISP^BIREP(.BILINE,"BIREPC",.BIHCF,A,3,2,,,36,B) K A,B
 ;
 ;---> Case Manager.
 D DISP^BIREP(.BILINE,"BIREPC",.BICM,"Case Manager",4,3,,,36)
 ;
 ;---> Beneficiary Type.
 S:$O(BIBEN(0))="" BIBEN(1)=""
 D DISP^BIREP(.BILINE,"BIREPC",.BIBEN,"Beneficiary Type",5,4,,,36)
 ;
 ;---> User Population.
 D:($G(BIUP)="")
 .I $$GPRAIEN^BIUTL6 S BIUP="a" Q
 .S BIUP="u"
 ;
 S X="     6 - Patient Population Group...: "
 D
 .I BIUP="r" S X=X_"Registered Patients (All)" Q
 .I BIUP="i" S X=X_"Immunization Register Patients (Active)" Q
 .I BIUP="u" S X=X_"User Population (1 visit, 3 yrs)" Q
 .I BIUP="a" S X=X_"Active Users (2+ visits, 3 yrs)" Q
 D WRITE(.BILINE,X,1)
 K X
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=BILINE
 S BIRTN="BIREPC"
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPC",$G(BIVAL),$G(BIBLNK))
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Enter ""V"" to view this report on screen, ""P"" to print it,"
 W !?5,"or ""H"" to view the Help Text for this report and its parameters."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;----> Explanation of this report.  vvv83
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("COVID IMMUNIZATION REPORT - HELP",.BITEXT)
 Q
 ;
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Correct items in Help Text below to reflect new begin date as July 1.
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;COVID IMMUNIZATION REPORT
 ;;
 ;;This report will provide statistics on the COVID Immunizations. The
 ;;population of patients reviewed are less than 2 years through 75
 ;;years and older.
 ;;
 ;;Criteria:
 ;;COVID-19 vaccine: For all patients, report looks for documentation
 ;;of 1 or 2 doses in a 2-dose series and 1 dose in a 1-dose series.
 ;;It also looks for a 3rd dose for immunocompromised patients and non
 ;;immunocompromised patients. For immunocompromised patients, the data
 ;;is pulled from the following taxonomies: BQI Cancer Dxs, BQI 
 ;;Transplant Dxs, BQI Immune Deficiency Dxs, ATX Immunosuppress 
 ;;RxNorm and ATX Immunosuppress Drugs. This includes any of the
 ;;following CVX codes: 207, 208, 212, 217,218, 219, 221, 225, 226,
 ;;227, 228, 500.
 ;;
 ;;The Total Fully Vaccinated row of the report includes patients
 ;;who have received 2 doses from a 2 dose series and 1 dose from
 ;;a 1-dose series of a COVID-19 vaccine.
 ;;
 ;;There is another row that summarizes the total fully vaccinated
 ;;in two age groups from 0 to 17 years and from 18 to 75+.     
 ;;
 ;;There is an Unvaccinated row that includes patients who have not
 ;;received any doses of a COVID-19 vaccine.
 ;;
 ;;The Booster received row includes patients who have received a 3rd
 ;;dose or 4th dose of a COVID-19 vaccine.
 ;;
 ;;The Contraindications row includes those patients for which a
 ;;reason was documented and does not allow the COVID-19 vaccine to
 ;;forecast for the patient.
 ;;
 ;;The Refusals row includes those patients for which a reason was
 ;;documented, but allows the COVID-19 vaccine to forecast for
 ;;the patient.
 ;;
 ;;There is an Immunocompromised Section included in the report;
 ;;it looks for documentation of the additional dose after completing
 ;;the 1-dose series or 2-dose series and the patient is eligible to
 ;;receive it due to a severely weakened immune system. The
 ;;unvaccinated row in this section includes immunocompromised patients
 ;;only who have not received any dose of the COVID-19 vaccine. If a
 ;;booster dose is warranted, then it will display in this section and
 ;;the general population but will not be culminative. This means if a
 ;;patient receives 5 booster doses, they will count as one patient, in
 ;;their age column, having received one or more boosters.
 ;;
 ;;The patients in this report can be grouped and displayed the
 ;;following ways: 
 ;;Not Current (Not Age Appropriate), Current, or Both Groups.
 ;;Patients who are fully vaccinated (completed the 2-dose series or 1- 
 ;;dose series) are considered "Current". Patients who have not received
 ;;any doses or one dose (from a 2 dose series) are considered "Not Current".
 ;;
 ;;After making changes to either Not Current or Current, the user
 ;;can update the existing report without the need of starting from
 ;;scratch.
 ;;When you select View COVID Report, a prompt appears at the bottom
 ;;of the screen that allows you to display and edit the patient
 ;;included in the report.
 ;;
 ;;
 ;;
 ;;Report Columns
 ;;--------------_
 ;;The "Age in Years" is calculated on the selected Ending Date.
 ;;The columns represent the patient ages in years.
 ;;
 ;;Report Rows
 ;;------------
 ;;The "Denominator" row of the report is the number of patients within
 ;;that age group who are included in the report.
 ;;    NOTE: Any patient who was Inactivated prior to Ending Date
 ;;          selected will not be included in the report.
 ;;
 ;;
 ;;The COVID IMMUNIZATION REPORT screen allows you to adjust the
 ;;report to your needs.
 ;;
 ;;There are 6 items or "parameters" on the screen that you may
 ;;change in order to select for a specific group of patients.
 ;;To change an item, enter its left column number (1-6) at the
 ;;prompt on the bottom of the screen.  Use "?" at any prompt where
 ;;you would like help or more information on the parameter you are
 ;;changing.
 ;;
 ;;Once you have the parameters set to retrieve the group of patients
 ;;you want, select V to View the COVID Report or P to print it.
 ;;
 ;;If it customarily takes a long time for your computer to prepare
 ;;this report, it may be preferable to Print and Queue the report
 ;;to a printer, rather than Viewing it on screen.  (This would avoid
 ;;tying up your screen while the report is being prepared.)
 ;;
 ;;ENDING DATE: The report will compile COVID immunization rates
 ;;on the date chosen.
 ;;
 ;;COMMUNITY: If you select for specific Communities, only patients
 ;;whose Current Community matches one of the Communities selected will
 ;;be included in the report.  "Current Community" refers to Item 6
 ;;on Page 1 of the RPMS Patient Registration.
 ;;
 ;;HEALTH CARE FACILITY: If you select for specific Health Care
 ;;Facilities, only Patients who have active Chart#'s at one or more
 ;;of the selected Facilities will be included in the report.
 ;;
 ;;CASE MANAGER: If you select for specific Case Managers, only
 ;;patients who have the selected Case Managers will be included
 ;;in the report.
 ;;
 ;;BENEFICIARY TYPE: If you select for specific Beneficiary Types,
 ;;only patients whose Beneficiary Type is one of those you select
 ;;will be included in the report.  "Beneficiary Type" refers to
 ;;Item 3 on Page 2 of the RPMS Patient Registration.
 ;;
 ;;PATIENT POPULATION GROUP: You may select one of four patient groups
 ;;to be considered in the report: Registered Patients (All),
 ;;Immunization Register Patients (Active), User Population (1+ visits
 ;;in 3 yrs), or Active Clinical Users (2+ visits in 3 yrs).
 ;;Active Clinical Users is the default.
 ;;
 ;;
 ;;
 D LOADTX("TEXT1",,.BITEXT)
 Q
 ;
 ;
 ;----------
LOADTX(BILINL,BITAB,BITEXT) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> End of job cleanup.
 D KILLALL^BIUTL8(1)
 K ^TMP("BIREPC",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
