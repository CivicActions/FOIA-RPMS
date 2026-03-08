BIVWVMR ;IHS/CMI/MWR - Immunizations Forecasting Routine ; 26 Jul 2016  09:31 AM
 ;;8.5;IMMUNIZATION;**18**;JUN 15,2020;Build 28
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**216**;Aug 12, 1996;Build 4
 ;
 Q
 ;
EN(WRK,DFN,PARMS,RETURN) ;
 K WRK
 N C0ARY,G,C0IPOA,CPTMAP,CVXMAP,CPTIMAP,CVXIMAP
 D PAYOUTAV^BIVWVMR
 D GET^BIVWUTIL("WRK","TPAYOUTC^BIVWVMR")
 D PAYOUTDV^BIVWVMR
 D GET^BIVWUTIL("WRK","TPAYOUTE^BIVWVMR")
 M ^TMP("BI_C0IWRK",$J)=WRK
 K WRK(0)
 Q
 ;
TEST1 ;
 S DFN=$$PAT^BIVWICE()
 K WRK
 D PAYOUTAV
 D PAYOUTBV(.RETURN)
 D GET^BIVWUTIL("WRK","TPAYOUTC^BIVWVMR")
 D GET^BIVWUTIL("WRK","TPAYOUTE^BIVWVMR")
 M ^TMP("BI_C0IWRK",$J)=WRK
 I $G(BITEST)=1 S OK=$$GTF^%ZISH($NA(^TMP("BI_C0IWRK",$J,1)),3,$$DEFDIR^%ZISH,"ice-test"_DFN_".xml")
 Q
 ; get patient DFN
 ; get patient VPR demographics for sex and DOB
 ; call VPR to get patient Immunizaitons
 ;
 ; begin building SOAP request XML
 ; loop through immunizations array and generate XML pieces
 ; call build to put all the pieces together into one XML array
 ; base64 encode the XML array
 ;
TENVOUT ; build SOAP envelope
 ;;<S:Envelope xmlns:S="http://www.w3.org/2003/05/soap-envelope">
 ;;<S:Body>
 ;;<ns2:evaluateAtSpecifiedTime xmlns:ns2="http://www.omg.org/spec/CDSS/201105/dss">
 ;;<interactionId scopingEntityId="gov.nyc.health" interactionId="123456"/>
 ;;<specifiedTime>@@hl7OutTime@@</specifiedTime>
 ;;<evaluationRequest clientLanguage="" clientTimeZoneOffset="">
 ;;<kmEvaluationRequest>
 ;;<kmId scopingEntityId="org.nyc.cir" businessId="ICE" version="1.0.0"/>
 ;;</kmEvaluationRequest>
 ;;<dataRequirementItemData>
 ;;<driId itemId="cdsPayload">
 ;;<containingEntityId scopingEntityId="gov.nyc.health" businessId="ICEData" version="1.0.0.0"/>
 ;;</driId>
 ;;<data>
 ;;<informationModelSSId scopingEntityId="org.opencds.vmr" businessId="VMR" version="1.0"/>
 ;;<base64EncodedPayload>@@outPayload@@</base64EncodedPayload>
 ;;</data>
 ;;</dataRequirementItemData>
 ;;</evaluationRequest>
 ;;</ns2:evaluateAtSpecifiedTime>
 ;; </S:Body>
 ;; </S:Envelope>
 Q
ENVOUTV ; create beginning of envelop - Called? MWRZZ, BIFDT replace DT?
 K C0IARY
 S C0IARY("hl7OutTime")=$$FMDTOCDA^BIVWUTIL(DT)
 D GETNMAP^BIVWUTIL("WRK","TENVOUT^BIVWVMR","C0IARY")
 Q
TPAYOUTA ; First part of payload message with Sex and DOB and a UUID variables
 ;;<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
 ;;<ns4:cdsInput xmlns:ns2="org.opencds" xmlns:ns3="org.opencds.vmr.v1_0.schema.vmr" xmlns:ns4="org.opencds.vmr.v1_0.schema.cdsinput" xmlns:ns5="org.opencds.vmr.v1_0.schema.cdsoutput">
 ;;<templateId root="2.16.840.1.113883.3.795.11.1.1"/>
 ;;<cdsContext>
 ;;<cdsSystemUserPreferredLanguage code="en" codeSystem="2.16.840.1.113883.6.99" displayName="English"/>
 ;;</cdsContext>
 ;;<vmrInput>
 ;;<templateId root="2.16.840.1.113883.3.795.11.1.1"/>
 ;;<patient>
 ;;<templateId root="2.16.840.1.113883.3.795.11.2.1.1"/>
 ;;<id root="@@UUID0@@"/>
 ;;<demographics>
 ;;<birthTime value="@@DOB@@"/>
 ;;<gender code="@@genderCode@@" codeSystem="2.16.840.1.113883.5.1" displayName="@@genderName@@" originalText="@@genderCode@@"/>
 ;;</demographics>
 ;;<clinicalStatements>
 Q
 ;
PAYOUTAV ; setting payload variables sex, DOB and UUID for the first section (PAYOUTA)
 K C0IPOA
 S X=$$GET1^DIQ(2,DFN,"DOB","I")
 S C0IPOA("UUID0")=$$UUID^BIVWUTIL
 S C0IPOA("DOB")=$$FMDTOCDA^BIVWUTIL(X)
 S C0IPOA("genderCode")=$$GET1^DIQ(2,DFN,"SEX","I")
 I C0IPOA("genderCode")="M" S C0IPOA("genderName")="Male"
 I C0IPOA("genderCode")="F" S C0IPOA("genderName")="Female"
 I C0IPOA("genderCode")="U" S C0IPOA("genderName")="Undifferentiated"
 D GETNMAP^BIVWUTIL("WRK","TPAYOUTA^BIVWVMR","C0IPOA")
 Q
 ;
PAYOUTB ;
 ;;;Disease an immunity section which is optional. the DISEASE_DOCUMENTED and IS_IMMUNE
 ;;;Cycle through 6 diseases using reminders to check for prior diagnosis
 ;;;Hep A: B15.9
 ;;;Hep B: B19.10
 ;;;Measles: B05.9
 ;;;Mumps: B26.9
 ;;;Rubella: B06.9
 ;;;Varicella: B01.9
 ;;;First Tag for this section if any prior diagnoses are available
 ;;<observationResults>
 Q
 ;
PAYOUTM ;
 ;;;Populate this section for each disease found leading to immunity
 ;;<observationResult>
 ;;<templateId root="2.16.840.1.113883.3.795.11.6.3.1"/>
 ;;<id root="@@UUIDA@@"/>
 ;;<observationFocus code="@@codeICD9@@" codeSystem="2.16.840.1.113883.6.103" displayName="@@codeName@@" originalText="@@codeICD9@@"/>
 ;;<observationFocus code="@@codeICD10@@" codeSystem="2.16.840.1.113883.6.90" displayName="@@codeName@@" originalText="@@codeICD10@@"/>
 ;;<observationEventTime low="@@timeProblem@@" high="@@timeProblem@@"/>
 ;;<observationValue>
 ;;<concept code="DISEASE_DOCUMENTED" codeSystem="2.16.840.1.113883.3.795.12.100.8" displayName="Disease Documented" originalText="DISEASE_DOCUMENTED"/>
 ;;</observationValue>
 ;;<interpretation code="IS_IMMUNE" codeSystem="2.16.840.1.113883.3.795.12.100.9" displayName="Is Immune" originalText="IS_IMMUNE"/>
 ;;</observationResult>
 Q
 ;
PAYOUTN ;
 ;;;Finishes off the disease section if there is one
 ;;</observationResults>
 Q
PAYOUTBV(RETURN) ;
 ; RETURN is passed by reference and is populated with the results of Reminders
 ;  and rubrics to tie the ICE return results to the VistA Patient Record
 ;
 ;Placeholder for logic and variables for populating the DISEASE_DOCUMENTED and IS_IMMUNE
 ;Diseases Hep A, Hep B, Measles, Mumps, Rubella, Varicella only as of 5/2014,
 ;If N is 0 after using reminders to test for the diseases in the taxonomies, then skip this section
 ;If more than one of these present, use the needed disease tags to write this part of the message
 ;
 N IENHEPA,IENHEPB,IENMEASL,IENVARIC,IENMUMPS,IENRUBEL
 N RCODE,RNAME ; rubric code and name
 S (IENHEPA,IENHEPB,IENMEASL,IENVARIC,IENMUMPS,IENRUBEL)=""
 N FILE,IENS,FLAGS,REMNAME,INDEX,SCREEN,EMSG
 S FILE=811.9
 S IENS=""
 S FLAGS="OQ"
 S INDEX="B"
 S SCREEN=""
 S EMSG=""
 N N,HEPA,HEPB,VARICEL,MUMPS,MEASLES,RUBELLA
 S (N,HEPA,HEPB,VARICEL,MUMPS,MEASLES,RUBELLA)=0
 K ^TMP("PXRHM",$J)
 N REMNAME S REMNAME="VIMM-HEPATITIS B DIAGNOSIS"
 S IENHEPB=$$FIND1^DIC(FILE,IENS,FLAGS,REMNAME,INDEX,SCREEN,EMSG)
 I IENHEPB="" Q  ; reminder not found, skip this part
 K REMNAME
 S RCODE="070.30"
 S RNAME="Hep B"
 I $$EN^BIVWPXRM(DFN,IENHEPB,.RETURN,"hadHepB",RCODE,RNAME) S N=N+1 S HEPB=1
 K ^TMP("PXRHM",$J)
 N REMNAME S REMNAME="VIMM-HEPATITIS A DIAGNOSIS"
 S IENHEPA=$$FIND1^DIC(FILE,IENS,FLAGS,REMNAME,INDEX,SCREEN,EMSG)
 K REMNAME
 S RCODE="B15.9"
 S RNAME="Hep A"
 I $$EN^BIVWPXRM(DFN,IENHEPA,.RETURN,"hadHepA",RCODE,RNAME) S N=N+1 S HEPA=1
 K ^TMP("PXRHM",$J)
 N REMNAME S REMNAME="VIMM-VARICELLA DIAGNOSIS"
 S IENVARIC=$$FIND1^DIC(FILE,IENS,FLAGS,REMNAME,INDEX,SCREEN,EMSG)
 K REMNAME
 S RCODE="B01.9"
 S RNAME="Varicella"
 I $$EN^BIVWPXRM(DFN,IENVARIC,.RETURN,"hadVaricella",RCODE,RNAME) S N=N+1 S VARICEL=1
 K ^TMP("PXRHM",$J)
 N REMNAME S REMNAME="VIMM-MUMPS DIAGNOSIS"
 S IENMUMPS=$$FIND1^DIC(FILE,IENS,FLAGS,REMNAME,INDEX,SCREEN,EMSG) ; D MAIN^PXRM(DFN,267,0)
 K REMNME
 S RCODE="B26.9"
 S RNAME="Mumps"
 I $$EN^BIVWPXRM(DFN,IENMUMPS,.RETURN,"hadMumps",RCODE,RNAME) S N=N+1 S MUMPS=1
 K ^TMP("PXRHM",$J)
 N REMNAME S REMNAME="VIMM-MEASLES DIAGNOSIS"
 S IENMEASL=$$FIND1^DIC(FILE,IENS,FLAGS,REMNAME,INDEX,SCREEN,EMSG)
 K REMNAME
 S RCODE="B05.9"
 S RNAME="Measles"
 I $$EN^BIVWPXRM(DFN,IENMEASL,.RETURN,"hadMeasles",RCODE,RNAME) S N=N+1 S MEASLES=1
 K ^TMP("PXRHM",$J)
 N REMNAME S REMNAME="VIMM-RUBELLA DIAGNOSIS"
 S IENRUBEL=$$FIND1^DIC(FILE,IENS,FLAGS,REMNAME,INDEX,SCREEN,EMSG)
 K REMNAME
 S RCODE="B06.9"
 S RNAME="Rubella"
 I $$EN^BIVWPXRM(DFN,IENRUBEL,.RETURN,"hadRubella",RCODE,RNAME) S N=N+1 S RUBELLA=1
 K ^TMP("PXRHM",$J)
 I N=0 Q
 E  D
 .D GETNMAP^BIVWUTIL("WRK","PAYOUTB^BIVWVMR","C0IPOA")
 .I HEPB=1 D HEPB
 .I HEPA=1 D HEPA
 .I VARICEL=1 D VARICEL
 .I MUMPS=1 D MUMPS
 .I MEASLES=1 D MEASLES
 .I RUBELLA=1 D RUBELLA
 .D GETNMAP^BIVWUTIL("WRK","PAYOUTN^BIVWVMR","C0IPOA")
 .K ^TMP("PXRHM",$J)
 Q
 ;
PDATE(INDX) ; extrinsic which returns the date to use for the problem
 ; INDX is passed by value and is the index into the findings ie "hadHepB"
 N C0FIND,RTN
 S C0FIND=$O(RETURN("findings","B",INDX,""))
 I C0FIND'="" D  ;
 . N C0DATE
 . S C0DATE=$G(RETURN("findings",C0FIND,"dateOfOnset"))
 . I C0DATE="" S C0DATE=$G(RETURN("findings",C0FIND,"date"))
 . S RTN=$$FMDTOCDA^BIVWUTIL(C0DATE)
 E  S RTN=$$FMDTOCDA^BIVWUTIL(DT)
 Q RTN
 ;
HEPB ;
 S C0IPOA("UUIDA")=$$UUID^BIVWUTIL
 S C0IPOA("timeProblem")=$$PDATE("hadHepB")
 S C0IPOA("codeICD10")="B19.10"
 S C0IPOA("codeName")="Unspecified viral hepatitis B without hepatic coma"
 D GETNMAP^BIVWUTIL("WRK","PAYOUTM^BIVWVMR","C0IPOA")
 K C0IPOA("UUIDA")
 K C0IPOA("timeProblem")
 K C0IPOA("codeICD10")
 K C0IPOA("codeName")
 Q
 ;
HEPA ;
 S C0IPOA("UUIDA")=$$UUID^BIVWUTIL
 S C0IPOA("timeProblem")=$$PDATE("hadHepA")
 S C0IPOA("codeICD10")="B15.9"
 S C0IPOA("codeName")="Hepatitis A without hepatic coma"
 D GETNMAP^BIVWUTIL("WRK","PAYOUTM^BIVWVMR","C0IPOA")
 K C0IPOA("UUIDA")
 K C0IPOA("timeProblem")
 K C0IPOA("codeICD10")
 K C0IPOA("codeName")
 Q
 ;
VARICEL ;
 S C0IPOA("UUIDA")=$$UUID^BIVWUTIL
 S C0IPOA("timeProblem")=$$PDATE("hadVaricella")
 S C0IPOA("codeICD9")="052.9"
 S C0IPOA("codeICD10")="B01.9"
 S C0IPOA("codeName")="Varicella without mention of complication"
 S C0IPOA("codeName")="Varicella without complication"
 D GETNMAP^BIVWUTIL("WRK","PAYOUTM^BIVWVMR","C0IPOA")
 K C0IPOA("UUIDA")
 K C0IPOA("timeProblem")
 K C0IPOA("codeICD10")
 K C0IPOA("codeName")
 Q
 ;
TPAYOUTC ;
 ;;; only one line that is fixed for substance administration
 ;;<substanceAdministrationEvents>
 Q
 ;
TPAYOUTD ;
 ;;; this section loops through the immunizations
 ;;<substanceAdministrationEvent>
 ;;<templateId root="2.16.840.1.113883.3.795.11.9.1.1"/>
 ;;<id root="@@UUID1@@"/>
 ;;<substanceAdministrationGeneralPurpose code="384810002" codeSystem="2.16.840.1.113883.6.5"/>
 ;;<substance>
 ;;<id root="@@UUID2@@"/>
 ;;<substanceCode code="@@CVXCode@@" codeSystem="2.16.840.1.113883.12.292" displayName="@@CVXName@@" originalText="@@ORIGName@@"/>
 ;;</substance>
 ;;<administrationTimeInterval low="@@admDate@@" high="@@admDate@@"/>
 ;;</substanceAdministrationEvent>
 Q
 ;
 ;---> This version includes "<isValid value" (not in the above call).
TPAYOUT2 ;
 ;;; this section loops through the immunizations
 ;;<substanceAdministrationEvent>
 ;;<templateId root="2.16.840.1.113883.3.795.11.9.1.1"/>
 ;;<id root="@@UUID1@@"/>
 ;;<substanceAdministrationGeneralPurpose code="384810002" codeSystem="2.16.840.1.113883.6.5"/>
 ;;<substance>
 ;;<id root="@@UUID2@@"/>
 ;;<substanceCode code="@@CVXCode@@" codeSystem="2.16.840.1.113883.12.292" displayName="@@CVXName@@" originalText="@@ORIGName@@"/>
 ;;</substance>
 ;;<administrationTimeInterval low="@@admDate@@" high="@@admDate@@"/>
 ;;<isValid value="@@DoseOvrd@@"/>
 ;;</substanceAdministrationEvent>
 Q
 ;
PAYOUTDV ;
 ; Variable and code for the looping IMMUNIZATIONS section
 ; Need UUID x 2, CVX code, name from CVX Short name, administration date
 ;(need really only one eve thought it asks for high and low - use the same variable)
 D GETPAT^BIVWEXTR(.G,DFN,"immunization")
 ;
 ;---> Example of 2 immunizations in Hx.
 ;---> Array of Imm Hx gathered in local array G("results","immunizations"):
 ;---> G("results","immunizations",1,"immunization","administered@value")=3100801
 ;---> G("results","immunizations",1,"immunization","cvx@value")=20
 ;---> G("results","immunizations",1,"immunization","encounter@value")=2747
 ;---> G("results","immunizations",1,"immunization","id@value")=3085
 ;---> G("results","immunizations",1,"immunization","name@value")="DTAP"
 ;--->
 ;---> G("results","immunizations",2,"immunization","administered@value")=3100302
 ;---> G("results","immunizations",2,"immunization","cvx@value")=9
 ;---> G("results","immunizations",2,"immunization","encounter@value")=2748
 ;---> G("results","immunizations",2,"immunization","id@value")=3086
 ;---> G("results","immunizations",2,"immunization","name@value")="TD (ADULT)"
 ;--->
 ;---> G("results","immunizations@total")=2
 ;---> G("results@timeZone")="-0800"
 ;
 ;
 I G("results","immunizations@total")=0 Q
 E  D
 .N T S T=G("results","immunizations@total")
 .I T=1 D  ;
 ..N GTMP
 ..M GTMP=G("results","immunizations")
 ..K G("results","immunizations")
 ..M G("results","immunizations",1)=GTMP
 ..K GTMP
 .N I S I=""
 .F I=1:1:T D
 ..D OUTLOG^BIVWUTIL("I is "_I)
 ..N ADMDATE,CPTIMM,CVXCODE,CVXNAME,IMMIEN,IMMNAME,VIMMIEN
 ..S C0IPOA("UUID1")=$$UUID^BIVWUTIL
 ..S C0IPOA("UUID2")=$$UUID^BIVWUTIL
 ..S C0IPOA("CVXCode")=""
 ..S C0IPOA("CVXName")=""
 ..S C0IPOA("ORIGName")=""
 ..S C0IPOA("admDate")=""
 ..;
 ..;---> Get Dose Override for this V Imm.
 ..N BIVIMM,BIDOVR,BIDOVR1 S BIVIMM=$G(G("results","immunizations",I,"immunization","id@value"))
 ..S BIDOVR=$P($G(^AUPNVIMM(BIVIMM,0)),U,8)
 ..S BIDOVR1=$S(+BIDOVR=0:"",BIDOVR<5:"false",1:"true")
 ..S C0IPOA("DoseOvrd")=BIDOVR1
 ..;
 ..; id@value is the IEN of the V IMMUNIZATION file (VIMMIEN)
 ..; name@value is the NAME from the IMMUNIZATION file (IMMNAME)
 ..; We will use the VIMMIEN to get the IEN of the IMMUNIZATION file
 ..; (although we could use the "B" cross-reference on the IMMNAME).
 ..;
 ..; From there, we get the .03 CVX CODE field (CVXCODE)
 ..;S VIMMIEN=$G(G("results","immunizations",I,"immunization","id@value"))
 ..;S IMMIEN=$$GET1^DIQ(9000010.11,VIMMIEN,.01,"I")
 ..;S CVXCODE=$$GET1^DIQ(9999999.14,IMMIEN,.03)
 ..;
 ..;---> Comment out above 3 lines and use CVX value already in the G array.
 ..S CVXCODE=$G(G("results","immunizations",I,"immunization","cvx@value"))
 ..;
 ..;---> If CVX Code is a single digit, prepend a zero.
 ..I CVXCODE<10 S CVXCODE="0"_CVXCODE
 ..;
 ..S IMMNAME=$G(G("results","immunizations",I,"immunization","name@value"))
 ..S CVXNAME=IMMNAME ; Both of these fields are currently ignored by ICE.
 ..S ADMDATE=$G(G("results","immunizations",I,"immunization","administered@value"))
 ..S C0IPOA("CVXCode")=CVXCODE
 ..S C0IPOA("CVXName")=CVXNAME
 ..S C0IPOA("ORIGName")=IMMNAME
 ..S C0IPOA("admDate")=$$FMDTOCDA^BIVWUTIL(ADMDATE)
 ..D:CVXCODE="" OUTLOG^BIVWUTIL("ERROR - CVXCODE is null")
 ..D
 ...;---> If Dose Override has null value, then call Payout without "<isValid".
 ...I BIDOVR1="" D GETNMAP^BIVWUTIL("WRK","TPAYOUTD^BIVWVMR","C0IPOA") Q
 ...;---> Include "<isValid".
 ...D GETNMAP^BIVWUTIL("WRK","TPAYOUT2^BIVWVMR","C0IPOA")
 ;b
 Q
 ;
OUTLOG(ZTXT) ; add text to the log
 I '$D(C0LOGLOC) S C0LOGLOC=$NA(^TMP("BI_C0I",$J,"LOG"))
 N LN S LN=$O(@C0LOGLOC@(""),-1)+1
 S @C0LOGLOC@(LN)=ZTXT
 Q
 ;
TPAYOUTE ;
 ;;;fixed end portion of payload
 ;;</substanceAdministrationEvents>
 ;;</clinicalStatements>
 ;;</patient>
 ;;</vmrInput>
 ;;</ns4:cdsInput>
 Q
 ;
