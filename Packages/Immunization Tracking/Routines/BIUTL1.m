BIUTL1 ;IHS/CMI/MWR - UTIL: PATIENT DEMOGRAPHICS; MAY 10, 2010 [ 01/31/2025  8:16 PM ]
 ;;8.5;IMMUNIZATION;**2,29,30**;OCT 24,2011;Build 125
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  RETRIEVE PATIENTS FOR DUE LISTS & LETTERS.
 ;;  PATCH 2: Add YY option to DOBF.  DOBF
 ;
 ;----------
NAME(DFN,ORDER) ;EP
 ;---> Return text of Patient Name.
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;     2 - ORDER (opt) ""/0=Last,First   2=First Only
 ;                        1=First Last   3=Last Only
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q:'$D(^DPT(DFN,0)) "Unknown"
 N X S X=$P(^DPT(DFN,0),U)
 Q:'$G(ORDER) X
 S X=$$FL(X)
 Q:ORDER=1 X
 Q:ORDER=2 $P(X," ")
 Q:ORDER=3 $P(X," ",2)
 Q "UNKNOWN ORDER"
 ;
 ;
 ;----------
FL(X) ;EP
 ;---> Switch First and Last Names.
 Q $P($P(X,",",2)," ")_" "_$P(X,",")
 ;
 ;
 ;----------
DOB(DFN) ;EP
 ;---> Return Patient's Date of Birth in Fileman format.
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q:'$P($G(^DPT(DFN,0)),U,3) "NOT ENTERED"
 Q $P(^DPT(DFN,0),U,3)
 ;
 ;
 ;********** PATCH 2, v8.5, MAY 15,2012, IHS/CMI/MWR
 ;---> Add BIYY option/parameter to DOBF
 ;----------
DOBF(DFN,BIDT,BINOA,BISL,BIADT,BIYY) ;EP
 ;---> Date of Birth formatted "09-Sep-1994 (35 Months)"
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;     2 - BIDT  (opt) Date on which Age should be calculated.
 ;     3 - BINOA (opt) 1=No age (don't append age).
 ;     4 - BISL  (opt) 1=Slash Date Format: MM/DD/YYYY
 ;     5 - BIADT (opt) 1=Append "on BIDT" to age.
 ;     6 - BIYY  (opt) 1=2-digit year.
 ;
 N X,Y
 S X=$$DOB($G(DFN))
 Q:'X X
 S X=$S($G(BISL):$$SLDT2^BIUTL5(X,+$G(BIYY)),1:$$TXDT1^BIUTL5(X))
 Q:$G(BINOA) X
 S Y=$$AGEF(DFN,$G(BIDT))
 S:Y["DECEASED" Y="DECEASED"
 S X=X_" ("_Y
 I $G(BIADT),$G(BIDT) S X=X_" on "_$$SLDT2^BIUTL5(BIDT,+$G(BIYY))
 S X=X_")"
 Q X
 ;**********
 ;
 ;----------
AGE(DFN,BIZ,BIDT) ;EP
 ;V8.5 PATCH 29 - FID-107546 Tdap age check
 ;---> Return Patient's Age.
 ;---> Parameters:
 ;     1 - DFN  (req) IEN in PATIENT File.
 ;     2 - BIZ  (opt) BIZ=1,2,3  1=years, 2=months, 3=days.
 ;                               2 will be assumed if not passed.
 ;     3 - BIDT (opt) Date on which Age should be calculated.
 ;
 N X,Y,X1,X2,AGE
 S:'$G(DT) DT=$$DT^XLFDT
 S:'$G(BIDT) BIDT=DT
 S AGE=""
 S:'$G(DFN) AGE="NO PATIENT"
 S BIDOB=$$DOB(DFN)
 S:'BIDOB AGE="Unknown"
 I $$DECEASED(DFN) S AGE="DECEASED: "_$$TXDT1^BIUTL5(+^DPT(DFN,.35))
 S:BIDT<BIDOB AGE="NOT BORN"
 ;
 S X1=BIDT
 S X2=BIDOB
 D D^%DTC
 S D=$S(X>209:30.4,1:30)
 S M=X\D
 S:M<1 M="<1"
 S D=$S(X>2190:365.25,1:365)
 S Y=X\D
 S:Y<1 Y="<1"
 S:AGE="" AGE=Y_U_M_U_X
 Q AGE
 ;
 ;----------
AGEF(DFN,BIDT) ;EP
 ;V8.5 PATCH 29 - FID-107546 Tdap age check
 ;---> Age formatted "35 Months" or "23 Years"
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - BIDT (opt) Date on which Age should be calculated.
 ;
 N AGE,Y
 S Y=""
 S:'$G(BIDT) BIDT=DT
 S AGE=$$AGE(DFN,1,BIDT)
 S:$E(AGE)?1U Y=AGE
 ;
 ;---> If over 60 months, return years.
 I $P(AGE,U,2)>60 S Y=+AGE_$S(Y=1:" year",1:" yrs")
 ;
 ;---> If under 1 month return days.
 I $E(AGE)'?1U,$P(AGE,U,2)<1 S Y=+$P(AGE,U,3)_$S(Y=1:" day",1:" days")
 ;
 ;---> Return months
 I $E(AGE)'?1U,$P(AGE,U,2)<61 S Y=+$P(AGE,U,2)_$S(Y=1:" mth",1:" mths")
 Q Y
 ;
 ;----------
DECEASED(DFN,BIDT) ;EP
 ;---> Return 1 if patient is deceased, 0 if not deceased.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - BIDT (opt) If BIDT=1 return Date of Death (Fileman format).
 ;
 Q:'$G(DFN) 0
 N X S X=+$G(^DPT(DFN,.35))
 Q:'X 0
 Q:'$G(BIDT) 1
 Q X
 ;
 ;----------
SEX(DFN,PRON) ;EP
 ;---> Return "F" is patient is female, "M" if male.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - PRON (opt) Pronoun: 1=he/she, 2=him/her,3=his,her
 ;
 Q:'$G(DFN) ""
 Q:'$D(^DPT(DFN,0)) ""
 N X S X=$P(^DPT(DFN,0),U,2)
 Q:'$G(PRON) X
 I PRON=1 Q $S(X="F":"she",1:"he")
 I PRON=2 Q $S(X="F":"her",1:"him")
 I PRON=3 Q $S(X="F":"her",1:"his")
 Q X
 ;
 ;----------
SEXW(DFN) ;EP
 ;---> Return Patient sex: "Female"/"Male".
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:$$SEX(DFN)="M" "Male"
 Q:$$SEX(DFN)="F" "Female"
 Q "Unknown"
 ;
 ;----------
ACTIVE(DFN) ;PEP - Return Patient's Active Status in Immunization Package.
 ;---> Return text of Patient's Active Status.
 ;---> $$ACTIVE^BIUTL1(DFN) will return values of either:
 ;---> "Deceased","Inactive", or "Active".
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 N X
 S X=$$DECEASED(DFN)
 Q:X>0 "Deceased"
 S X=$$INACT(DFN)
 Q:X "Inactive"
 Q:X]"" X
 Q "Active"
 ;
 ;----------
INACT(DFN,TEXT) ;PEP - Return date this patient became Inactive in Immunization.
 ;---> Return date this patient became Inactive.
 ;---> $$INACT^BIUTL1(DFN) will return values of either:
 ;---> "NO PATIENT","UNKNOWN", "NOT IN REGISTER", DATE INACTIVE, or null.
 ;
 ;---> NOTE: If $$INACT^BIUTL1(DFN)="" then the Patient is Active.
 ;
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - TEXT (opt) If TEXT=1, return text of date.
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q:'$D(^DPT(DFN,0)) "UNKNOWN"
 Q:'$D(^BIP(DFN,0)) "NOT IN REGISTER"
 N X S X=$P(^BIP(DFN,0),U,8)
 Q:'X ""
 Q:'$G(TEXT) X
 Q $$TXDT1^BIUTL5(X)
 ;
 ;----------
INACTRE(DFN,BICODE) ;EP
 ;---> Return Reason for Inactive.
 ;---> Parameters:
 ;     1 - DFN    (req) Patient's IEN (DFN).
 ;     2 - BICODE (opt) If BICODE=1 return Code rather than text.
 ;
 Q:'$G(DFN) ""
 N X,Y,Z S X=$P($G(^BIP(DFN,0)),U,16)
 Q:(X="") ""
 S Y=$P($G(^DD(9002084,.16,0)),U,3)
 S Z=$P($P(Y,X_":",2),";")
 S:Z="" Z="Not Recorded"
 Q Z
 ;
 ;----------
INACTUSR(DFN,Z) ;EP
 ;---> Return User who made this Patient Inactive.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - Z    (opt) If Z=1 return IEN of user.
 ;
 Q:'$G(DFN) ""
 N X S X=$P($G(^BIP(DFN,0)),U,23)
 Q:$G(Z) X
 Q $$PERSON(X)
 ;
 ;----------
INACTREG(DFN,DUZ2) ;EP
 ;---> Return 1 if patient does not have an Active Chart in
 ;---> RPMS Patient Registration at this site DUZ(2).
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - DUZ2 (req) IEN of site DUZ(2) to check for Active Chart.
 ;
 Q:'$G(DFN) 1
 Q:'$G(DUZ2) 1
 Q:'$D(^AUPNPAT(DFN,41,DUZ2,0)) 1
 ;
 ;********** PATCH 1, SEP 21,2006, IHS/CMI/MWR
 ;---> Correct test for Active Chart at site DUZ2.
 ;Q:$P($D(^AUPNPAT(DFN,41,DUZ2,0)),"^",3) 1
 Q:$P(^AUPNPAT(DFN,41,DUZ2,0),"^",3) 1
 ;**********
 ;
 Q 0
 ;
 ;----------
ENTERED(DFN,BIA,BIT) ;EP
 ;---> Return date this patient was entered.
 ;---> Parameters:
 ;     1 - DFN (req) Patient's IEN (DFN).
 ;     2 - BIA (opt) If BIA="", return Date Entered.
 ;                   If BIA=1, return 1 if Automatically entered during Scan.
 ;     3 - BIT (opt) If BIT=1, return text of Date or Auto field.
 ;
 Q:'$G(DFN) ""
 Q:'$D(^BIP(DFN,0)) ""
 N X,Y
 S Y=$S($G(BIA):22,1:21)
 S X=$P(^BIP(DFN,0),U,Y)
 Q:$G(BIA) $S($G(BIT):$S(X:"Automatically",1:"Manually"),1:X)
 Q:'$G(BIT) X
 Q $$TXDT1^BIUTL5(X)
 ;
 ;----------
MOVEDLOC(DFN) ;EP
 ;---> Return Location where patient moved is receiving treatment elsewhere.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) ""
 Q $P($G(^BIP(DFN,0)),U,12)
 ;
 ;----------
LASTLET(DFN,TEXT) ;EP
 ;---> Return Fileman date of the last letter sent to this patient.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - TEXT (opt) If TEXT=1, return text of date.
 ;
 Q:'$G(DFN) 0
 Q:'$D(^DPT(DFN,0)) "None"
 Q:'$D(^BIP(DFN,0)) "Not in Register"
 N X S X=$P(^BIP(DFN,0),U,14)
 Q:'X "None"
 Q:'$G(TEXT) X
 Q $$TXDT1^BIUTL5(X)
 ;
 ;----------
NAMAGE(DFN) ;EP
 ;V8.5 PATCH 29 - FID-107546 Tdap age check
 ;---> Return Patient Name concatenated with age.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q $$NAME(DFN)_" ("_$P($$AGE(DFN),U,2)_"y/o)"
 ;
 ;----------
SSN(DFN) ;EP
 ;---> Return Social Security Number (SSN).
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 N X
 Q:'$G(DFN) "NO PATIENT"
 Q:'$D(^DPT(DFN,0)) "Unknown"
 S X=$P(^DPT(DFN,0),U,9)
 Q:X']"" "Unknown"
 Q X
 ;
 ;----------
HRCN(DFN,DUZ2,BIX) ;EP
 ;---> Return IHS Health Record Number.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - DUZ2 (opt) User's Site/Location IEN.  If no DUZ2
 ;                    provided, function will look for DUZ(2).
 ;     3 - BIX  (opt) If BIX=1 return HRCN with no dashes.
 ;
 ;  vvv83
 S:'$G(DUZ2) DUZ2=$G(DUZ(2))
 Q:'$G(DFN)!('$G(DUZ2)) "No Value"
 Q:'$D(^AUPNPAT(DFN,41,DUZ2,0)) "Not Here"
 Q:'+$P(^AUPNPAT(DFN,41,DUZ2,0),"^",2) "No Rec#"
 N Y S Y=$P(^AUPNPAT(DFN,41,DUZ2,0),"^",2)
 Q:$G(BIX) Y
 Q:'+Y Y
 Q:'$$DASH(DUZ2) Y
 I $L(Y)=7 D  Q Y
 .S Y=$TR("123-45-67",1234567,Y)
 S Y=$E("00000",0,6-$L(Y))_Y
 S Y=$TR("12-34-56",123456,Y)
 Q Y
 ;
 ;----------
DASH(BIDUZ2) ;EP
 ;---> Return 1 if Site Parameter says return Chart#s with dashes.
 ;---> Parameters:
 ;     1 - BIDUZ2 (req) User's DUZ(2)
 ;
 Q +$P($G(^BISITE(+$G(BIDUZ2),0)),U,12)
 ;
 ;----------
HPHONE(DFN) ;EP
 ;---> Return patient's home phone number.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "No Patient"
 Q:'$D(^DPT(DFN,.13)) "Unknown"
 Q:$P(^DPT(DFN,.13),U)="" "Unknown"
 Q $P(^DPT(DFN,.13),U)
 ;
 ;
 ;********** PATCH 1, SEP 21,2006, IHS/CMI/MWR
 ;---> Add ability to retrieve 2nd and 3rd Street Address lines.
 ;----------
STREET(DFN,Z) ;EP
 ;---> Return patient's street address.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - Z    (opt) If Z=2 return Line 2 of patient's address.
 ;                    If Z=3 return Line 3 of patient's address.
 ;
 N X S X=$S($G(Z)=2:2,$G(Z)=3:3,1:1)
 Q:'$G(DFN) "No Patient"
 Q:'$D(^DPT(DFN,.11)) "Unknown"
 ;---> Only return "Unknown" for the first line.
 Q:$P(^DPT(DFN,.11),U,X)="" $S(X=1:"Unknown",1:"")
 Q $P(^DPT(DFN,.11),U,X)
 ;
 ;----------
CITY(DFN) ;EP
 ;---> Return patient's city.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "No Patient"
 Q:'$D(^DPT(DFN,.11)) "Unknown"
 Q:$P(^DPT(DFN,.11),U,4)="" "Unknown"
 Q $P(^DPT(DFN,.11),U,4)
 ;
 ;----------
STATE(DFN) ;EP
 ;---> Return patient's state.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "No Patient"
 Q:'$D(^DPT(DFN,.11)) "No State"
 Q:$P(^DPT(DFN,.11),U,5)="" "No State"
 Q $P(^DIC(5,$P(^DPT(DFN,.11),U,5),0),U,2)
 ;
 ;----------
ZIP(DFN) ;EP
 ;---> Return patient's zipcode.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "No Patient"
 Q:'$D(^DPT(DFN,.11)) "No Zip"
 Q:$P(^DPT(DFN,.11),U,6)="" "No Zip"
 Q $P(^DPT(DFN,.11),U,6)
 ;
 ;----------
CTYSTZ(DFN) ;EP
 ;---> Return patient's city, state zip.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "No Patient"
 Q $$CITY(DFN)_", "_$$STATE(DFN)_"  "_$$ZIP(DFN)
 ;
 ;----------
CMGR(DFN,TEXT,ORDER) ;EP
 ;---> Return patient's Case Manager.
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;     2 - TEXT  (opt) If TEXT=1, return text of Case Manager.
 ;     3 - ORDER (opt) ""/0=Last,First  1=First Last
 ;
 N Y
 Q:'$G(DFN) "No Patient"
 Q:'$D(^BIP(DFN,0)) "Unknown"
 S Y=$P(^BIP(DFN,0),U,10)
 Q:'$G(TEXT) Y
 Q $$PERSON(Y,$G(ORDER))
 ;
 ;----------
DPRV(DFN,TEXT,ORDER) ;EP
 ;---> Return patient's Designated Provider.
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;     2 - TEXT  (opt) If TEXT=1, return text of Case Manager.
 ;     3 - ORDER (opt) ""/0=Last,First  1=First Last
 ;
 N Y,Z
 Q:'$G(DFN) "No Patient"
 Q:'$D(^BIP(DFN,0)) "Unknown"
 Q:'$L($T(^BDPAPI)) "No BDP Pkg"
 D ALLDP^BDPAPI(DFN,"DESIGNATED PRIMARY PROVIDER",.Y)
 S Z=$P($G(Y("DESIGNATED PRIMARY PROVIDER")),U,2)
 Q:'$G(TEXT) Z
 Q $$PERSON(Z,$G(ORDER))
 ;
 ;----------
PERSON(X,ORDER) ;EP
 ;---> Return person's name from File #200.
 ;---> Parameters:
 ;     1 - X     (req) Person's IEN in New Person File #200.
 ;     2 - ORDER (opt) ""/0=Last,First   1=First Last
 ;
 Q:'X "Unknown"
 Q:'$D(^VA(200,X,0)) "Unknown"
 N Y S Y=$P(^VA(200,X,0),U)
 Q:'$G(ORDER) Y
 Q $$FL(Y)
 ;
 ;----------
PARENT(DFN,BIX) ;EP
 ;---> Return Patient's Parent/Guardian name as stored in the
 ;---> Immunization database.
 ;---> Parameters:
 ;     1 - DFN (req) Patient's IEN (DFN).
 ;     2 - BIX (opt) If BIX=1, return text for letter address
 ;                   (return text "Parent/Guardian of" if no data).
 N Y
 D
 .I '$G(DFN) S Y="" Q
 .S Y=$P($G(^BIP(DFN,0)),U,9)
 ;---> If no Parent/Guardian in Immunization, check Patient Reg.
 ;S:Y="" Y=?
 Q:'$G(BIX) Y
 Q:Y="" "Parent/Guardian of"
 Q Y_", for"
 ;
 ;----------
INELIG(BIDFN) ;EP
 ;---> Return 1 if patient is Ineligible in RPMS Patient Registration.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(BIDFN) 0
 Q:$P($G(^AUPNPAT(BIDFN,11)),"^",12)="I" 1
 Q 0
 ;
 ;----------
CONSENT(BIDFN) ;EP
 ;---> Return 1 if patient or guardian consented to participation in the state
 ;---> registry.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(BIDFN) ""
 Q $P($G(^BIP(BIDFN,0)),"^",24)
 ;=====
 ;
PTS2CHK ;EP;FIND PATIENTS TO CHECK
 K ^BITMP("PTS2CHK")
 N AGE,AGES,AGEF,NAM,DOB,P2CA,P2CP,CNT,QUIT,DFN
 S QUIT=0
 F  D P2C Q:QUIT
 Q
 ;=====
 ;
P2C ;
 W @IOF
 W !?10,"Patients Selected:"
 W !?10,"Age",?15,"Patient",?42,"DOB",?52,"DFN"
 W !?10,"---",?15,"-------------------------",?42,"--------",?52,"------"
 S AGE=0
 F  S AGE=$O(P2CA(AGE)) Q:'AGE  D
 .S J=0
 .S PT=0
 .F  S PT=$O(P2CA(AGE,PT)) Q:'PT!(J>5)  D
 ..S J=J+1
 ..S NAM=$P(^DPT(PT,0),U,1,3)
 ..W !?10,AGE,?15,$E($P(NAM,U),1,25),?42,$P(NAM,U,3)+17000000,?52,PT
 K DIR
 S DIR(0)="NO^1:99"
 S DIR("A")="Select an age to check"
 W !
 D ^DIR
 K DIR
 I 'Y S QUIT=1 Q
 K P2CA,P2CP
 S CNT=0
 S AGE=Y*10000
 S AGES=DT-(AGE+30)
 S AGEF=DT-(AGE-30)
 S DFN=$O(^DPT(9999999999),-1)-$R(999)
 F  S DFN=$O(^DPT(DFN),-1) Q:'DFN!(CNT>5)  D:'$D(^BITMP("PTS2CHK",Y,DFN))
 .S DOB=$P(^DPT(DFN,0),U,3)
 .S DOB=$P(^DPT(DFN,0),U,3)
 .I DOB>AGES,DOB<AGEF,'$G(^DPT(DFN,.35)),$D(^AUPNVIMM("AC",DFN)) S HRN=$G(^AUPNPAT(DFN,41,DUZ(2),0)) I HRN,$P(HRN,U,3)="" S P2CA(Y,DFN)=DFN,P2CP(DFN)=Y,CNT=CNT+1
 M ^BITMP("PTS2CHK")=P2CA
 Q
 ;=====
 ;
