BIREPL5 ;IHS/CMI/MWR - REPORT, ADULT IMM; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;
 ;
S(A) ;
 Q $$STRIP^XLFSTR(A," ")
 ;
P(A) ;
 Q $P(A,"#")_"%,"
 ;----------
CSV(BITOTS,BILINE) ;EP
 ;---> Write Adult Stats for display.
 ;---> Parameters:
 ;     1 - BITOTS (req) 
 ;
 ;     1 - BILINE (ret) Number of lines written to Listman scroll area.
 ;
 I '$D(BITOTS) D ERRCD^BIUTL2(667,.X) D W(.BILINE,X) Q
 ;
 ;
 S X="Total Number of Patients 19 years and older,"
 S X=X_+(BITOTS("PTS19+")) D W(.BILINE,X,2)
 ;
 S X="TETANUS: patients Tdap EVER #,"
 S X=X_+BITOTS("19+TDAPEVER") D W(.BILINE,X)
 S X=$$P(X)
 I 'BITOTS("PTS19+") S X=X_0
 I BITOTS("PTS19+") S X=X_$$S($J((BITOTS("19+TDAPEVER")/BITOTS("PTS19+"))*100,0,1)) I 1
 D W(.BILINE,X)
 ;
 S X="TETANUS: patients Tdap EVER AND [Td OR Tdap in past 10 years] #,"
 S X=X_+BITOTS("19+TDAP&TD10YR") D W(.BILINE,X)
 S X=$$P(X)
 I 'BITOTS("PTS19+") S X=X_0
 I BITOTS("PTS19+") S X=X_$$S($J((BITOTS("19+TDAP&TD10YR")/BITOTS("PTS19+"))*100,0,1)) I 1
 D W(.BILINE,X,1)
 ;
 ;---> HEPB
 ;
 D W(.BILINE," ")
 S X="Total Number of Patients 19-59,"
 S X=X_+BITOTS("PTS19-59") D W(.BILINE,X,1)
 ;
 S X=" HEP B: patients - Series initiated #,"
 S X=X_BITOTS("19-59HEPB1") D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-59") S X=X_$$S($J((BITOTS("19-59HEPB1")/BITOTS("PTS19-59"))*100,0,1)) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X=" HEP B: patients - Dose 2 initiated #,"
 S X=X_+BITOTS("19-59HEPB2") D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-59") S X=X_$$S($J((BITOTS("19-59HEPB2")/BITOTS("PTS19-59"))*100,0,1)) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X=" HEP B: patients - Series completed #,"
 S X=X_+(BITOTS("19-59HEPBC")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-59") S X=X_$J((BITOTS("19-59HEPBC")/BITOTS("PTS19-59"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 ;;---> HPV
 D W(.BILINE," ")
 S X="Total Number of Patients age 19-26 #,"
 S X=X_+BITOTS("PTS19-26") D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("PTS19-26")/BITOTS("PTS19+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 S X=" HPV: patients - Series initiated #,"
 S X=X_+(BITOTS("19-26HPV1")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-26") S X=X_$J((BITOTS("19-26HPV1")/BITOTS("PTS19-26"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X=" HPV: patients - Dose 2 initiated #,"
 S X=X_+(BITOTS("19-26HPV2")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-26") S X=X_$J((BITOTS("19-26HPV2")/BITOTS("PTS19-26"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X=" HPV: patients - Series completed #,"
 S X=X_+(BITOTS("19-26HPVC")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-26") S X=X_$J((BITOTS("19-26HPVC")/BITOTS("PTS19-26"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 ;**
 ;
 ;---> Total patients over 50 and shingrix
 S X="Total Number of Patients 50 years and older #,"
 S X=X_+(BITOTS("PTS50+")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("PTS50+")/BITOTS("PTS19+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 S X=" Shingrix: patients - Series initiated #,"
 S X=X_+(BITOTS("50+SHINGRIX1")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS50+") S X=X_$J((BITOTS("50+SHINGRIX1")/BITOTS("PTS50+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X=" Shingrix: patients - Series completed #,"
 S X=X_+(BITOTS("50+SHINGRIXC")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS50+") S X=X_$J((BITOTS("50+SHINGRIXC")/BITOTS("PTS50+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 ;19-64 lines
 S X="Total Number of Patients age 19-64 #,"
 S X=X_+(BITOTS("PTS19-64")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("PTS19-64")/BITOTS("PTS19+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 S X="PCV13 and PPSV23: patients - fully vaccinated #,"
 S X=X_+(BITOTS("19-64PCV13PPSV23")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-64") S X=X_$J((BITOTS("19-64PCV13PPSV23")/BITOTS("PTS19-64"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X=" PCV20: patients - fully vaccinated #,"
 S X=X_+(BITOTS("19-64PCV20")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-64") S X=X_$J((BITOTS("19-64PCV20")/BITOTS("PTS19-64"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X=" PPSV23 and PCV15: patients - fully vaccinated #,"
 S X=X_+(BITOTS("19-64PCV15PPSV23")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-64") S X=X_$J((BITOTS("19-64PCV15PPSV23")/BITOTS("PTS19-64"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 ;65 and older lines
 S X="Total Number of Patients 65 years and older #,"
 S X=X_+(BITOTS("PTS65+")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("PTS65+")/BITOTS("PTS19+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 S X=" Tetanus: patients w/Td/Tdap in past 10 years #,"
 S X=X_+(BITOTS("65+TDAP/TD10YR")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS65+") S X=X_$J((BITOTS("65+TDAP/TD10YR")/BITOTS("PTS65+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="PCV13 and PPSV23: patients - fully vaccinated #,"
 S X=X_+(BITOTS("65+PCV13PPSV23")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS65+") S X=X_$J((BITOTS("65+PCV13PPSV23")/BITOTS("PTS65+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="PCV20: patients - fully vaccinated #,"
 S X=X_+(BITOTS("65+PCV20")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS65+") S X=X_$J((BITOTS("65+PCV20")/BITOTS("PTS65+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="PPSV23 and PCV15: patients - fully vaccinated #,"
 S X=X_+(BITOTS("65+PCV15PPSV23")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS65+") S X=X_$J((BITOTS("65+PCV15PPSV23")/BITOTS("PTS65+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 ;---> Now write total patients considered who had refusals.
 S X=" Total Patients included who had Refusals on record,"_+BITOTS("REFUSALS")
 D W(.BILINE,X,2)
 ;
 ;
 ;
 S X="* * * NEW GPRA COMPOSITE MEASURE SECTION * * *"
 D W(.BILINE,X,1)
 ;
 ;IHS/CMI/LAB - BI*8.5*29  - added HPV lines patch 29
 ;;---> HPV
 S X="Total Number of Patients ages 19 through 26 years,"
 S X=X_+(BITOTS("PTS19-26"))
 D W(.BILINE,X,1)
 ;
 S X="Received HPV Series complete #,"
 S X=X_+(BITOTS("19-26HPVC")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-26") S X=X_$J((BITOTS("19-26HPVC")/BITOTS("PTS19-26"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 ;composite for 19-49 years
 ;
 S X="Total Number of Patients ages 19 through 49 years #,"
 S X=X_+(BITOTS("PTS19-49")) D W(.BILINE,X,1)
 ;
 S X="Received 1 dose of Tdap ever #,"
 S X=X_+(BITOTS("19-49TDAPEVER")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-49") S X=X_$J((BITOTS("19-49TDAPEVER")/BITOTS("PTS19-49"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap or Td < 10 years #,"
 S X=X_+(BITOTS("19-49TDAP/TD10YR")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-49") S X=X_$J((BITOTS("19-49TDAP/TD10YR")/BITOTS("PTS19-49"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap ever AND Tdap or Td < 10 yrs #,"
 S X=X_+(BITOTS("19-49TDAP&TD10YR")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-49") S X=X_$J((BITOTS("19-49TDAP&TD10YR")/BITOTS("PTS19-49"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received HEP B Series complete #,"
 S X=X_+(BITOTS("19-49HEPBC")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-49") S X=X_$J((BITOTS("19-49HEPBC")/BITOTS("PTS19-49"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 S X="Received ALL of the above (appropriately vaccinated) #,"
 S X=X_+(BITOTS("19-49ALL")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19-49") S X=X_$J((BITOTS("19-49ALL")/BITOTS("PTS19-49"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 ; composite 50-59
 S X="Total Number of Patients ages 50 through 59 years #,"
 S X=X_+(BITOTS("PTS50-59")) D W(.BILINE,X,1)
 ;
 S X="Received 1 dose of Tdap ever #,"
 S X=X_+(BITOTS("50-59TDAPEVER")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59TDAPEVER")/BITOTS("PTS50-59"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap or Td < 10 years #,"
 S X=X_+(BITOTS("50-59TDAP/TD10YR")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59TDAP/TD10YR")/BITOTS("PTS50-59"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap ever AND Tdap or Td < 10 yrs #,"
 S X=X_+(BITOTS("50-59TDAP&TD10YR")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59TDAP&TD10YR")/BITOTS("PTS50-59"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received HEP B Series complete #,"
 S X=X_+(BITOTS("50-59HEPBC")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59HEPBC")/BITOTS("PTS50-59"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received Shingrix series complete #,"
 S X=X_+(BITOTS("50-59SHINC")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59SHINC")/BITOTS("PTS50-59"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 S X="Received ALL of the above (appropriately vaccinated) #,"
 S X=X_+(BITOTS("50-59ALL")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS50-59") S X=X_$J((BITOTS("50-59ALL")/BITOTS("PTS50-59"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 ; composite 60-65
 S X="Total Number of Patients ages 60 through 65 years,"
 S X=X_+(BITOTS("PTS60-65")) D W(.BILINE,X,1)
 ;
 S X="Received 1 dose of Tdap ever #,"
 S X=X_+(BITOTS("60-65TDAPEVER")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS60-65") S X=X_$J((BITOTS("60-65TDAPEVER")/BITOTS("PTS60-65"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap or Td < 10 years #,"
 S X=X_+(BITOTS("60-65TDAP/TD10YR")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS60-65") S X=X_$J((BITOTS("60-65TDAP/TD10YR")/BITOTS("PTS60-65"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap ever AND Tdap or Td < 10 yrs #,"
 S X=X_+(BITOTS("60-65TDAP&TD10YR")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS60-65") S X=X_$J((BITOTS("60-65TDAP&TD10YR")/BITOTS("PTS60-65"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received Shingrix series complete #,"
 S X=X_+(BITOTS("60-65SHINC")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS60-65") S X=X_$J((BITOTS("60-65SHINC")/BITOTS("PTS60-65"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 S X="Received ALL of the above (appropriately vaccinated) #,"
 S X=X_+(BITOTS("60-65ALL")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS60-65") S X=X_$J((BITOTS("60-65ALL")/BITOTS("PTS60-65"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;COMPOSITE 66+
 D MORE
E Q
 ;
 ;
 ;----------
W(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;     3 - BIBLNK (opt) Number of blank lines to add after line sent.
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPL1",$G(BIVAL),$G(BIBLNK))
 ;
 ;--->Set VALMCNT (Listman line count) for errors calls above.
 S VALMCNT=BILINE
 Q
 ;
 ;
C(X,X2,X3) ;
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
 ;
 ;
MORE ;
 ; composite 66+
 S X="Total Number of Patients 66 years and older,"
 S X=X_+(BITOTS("PTS66+")) D W(.BILINE,X,1)
 ;
 S X="Received 1 dose of Tdap ever #,"
 S X=X_+(BITOTS("66+TDAPEVER")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+TDAPEVER")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap or Td < 10 years #,"
 S X=X_+(BITOTS("66+TDAP/TD10YR")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+TDAP/TD10YR")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap ever AND Tdap or Td < 10 yrs #,"
 S X=X_+(BITOTS("66+TDAP&TD10YR")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+TDAP&TD10YR")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received Shingrix series complete #,"
 S X=X_+(BITOTS("66+SHINC")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+SHINC")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 S X="Must meet ONE of the following:"
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of PCV13 AND 1 dose PPSV23 #,"
 S X=X_+(BITOTS("66+PCV13PPSV23")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+PCV13PPSV23")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of PCV20 #,"
 S X=X_+(BITOTS("66+PCV20")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+PCV20")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of PCV15 AND 1 dose of PPSV23 #,"
 S X=X_+(BITOTS("66+PCV15PPSV23")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+PCV15PPSV23")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 of the above - fully vaccinated for Pneumo #,"
 S X=X_+(BITOTS("66+ANYPNEU")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+ANYPNEU")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 S X="Must meet ONE of the following:"
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap AND Tdap/Td <10 years AND Shingrix series complete and 1 dose PCV13 AND 1 dose PPSV23 #,"
 S X=X_+(BITOTS("66+MET1")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+MET1")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap AND Tdap/Td <10 years AND Shingrix series complete and 1 dose PCV20 #,"
 S X=X_+(BITOTS("66+MET2")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+MET2")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 ;
 S X="Received 1 dose of Tdap AND Tdap/Td <10 years AND Shingrix series complete and 1 dose PCV15 AND 1 dose PPSV23 #,"
 S X=X_+(BITOTS("66+MET3")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J((BITOTS("66+MET3")/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,1)
 ;
 S X="Met one of the above (fully vaccinated) #,"
 S X=X_+((BITOTS("66+MET1")+BITOTS("66+MET2")+BITOTS("66+MET3"))) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS66+") S X=X_$J(((BITOTS("66+MET1")+BITOTS("66+MET2")+BITOTS("66+MET3"))/BITOTS("PTS66+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X,2)
 ;
 S X="Total Number of Patients 19 years and older,"
 S X=X_+(BITOTS("PTS19+")) D W(.BILINE,X,1)
 ;
 S X="Total Patients 19 years and older appropriately vaccinated per age recommendations #,"
 S X=X_+(BITOTS("ALLAPP")) D W(.BILINE,X)
 S X=$$P(X)
 I BITOTS("PTS19+") S X=X_$J((BITOTS("ALLAPP")/BITOTS("PTS19+"))*100,0,1) I 1
 E  S X=X_0
 D W(.BILINE,X)
 Q
