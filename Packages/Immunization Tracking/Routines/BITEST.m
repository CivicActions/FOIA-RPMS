BITEST ;IHS/CMI/MWR - TEST SPEED OF FORECASTING.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**21**;APR 01,2021;Build 10
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  TEST SPEED OF IMMSERVE FORECASTING.
 ;
START ;
 N BIPOP
 F  D TEST Q:$G(BIPOP)
 Q
 ;
 ;
TEST ;EP
 ;---> Multiple calls to ICE.
 D SETVARS^BIUTL5 N BIDFN
 D TITLE^BIUTL5("ICE/TCH FORECASTER PERFORMANCE TEST")
 D PATLKUP^BIUTL8(.BIDFN,,DUZ(2),.BIPOP)
 I $G(BIDFN)<1 S BIPOP=1
 Q:$G(BIPOP)
 L +^BIP(BIDFN):0 I '$T D ERRCD^BIUTL2(212,,1) Q
 ;
 I '$G(DT)!'$G(DUZ(2)) W !!,"   Error: Local variable not set." D DIRZ^BIUTL3() Q
 ;
 ;* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 ;---> Temporarily select Forecaster:
 ;W !,"   " D DIE^BIFMAN(9002084.02,.34,DUZ(2),.BIPOP) Q:BIPOP
 ;* * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 N BIQ S BIQ="     Enter the number of times you wish the forecast to be calculated."
 D DIR^BIFMAN("N^1:10000",.Y,.BIPOP,"  Number of iterations",1000,BIQ)
 ;
 ;---> TCH
 ;S $P(^BISITE(DUZ(2),0),U,34)=1
 ;
 N I,BIJ,K S BIJ=Y
 ;
 ;Q:$G(BIPOP)
 ;
 ;
 ;S K=BIJ/50 S:(BIJ<50) K=1 S:(BIJ<100) K=2
 ;N BISTART S BISTART=$H,BISTART=$P(BISTART,",",2)
 ;W !!,"  Beginning TCH ",BIJ," iterations:"
 ;W !!,"     |"
 ;F I=1:1:BIJ W:(I#K=0) "."
 ;W "|",!,"     |"
 ;
 ;---> Begin Test.
 ;F I=1:1:BIJ W:(I#K=0) "." D
 ;.N I,IO,BIJ
 ;.D IMMFORC^BIRPC(,BIDFN,DT,,DUZ(2))
 ;
 ;---> Release any locks on the patient.
 ;L
 ;---> Report Total Time.
 ;W "|",!!,"  ",BIJ," Iterations: ",$P($H,",",2)-BISTART," seconds",!
 ;
 ;
ICE ;---> ICE
 S $P(^BISITE(DUZ(2),0),U,34)=0
 ;
 S K=BIJ/50 S:(BIJ<50) K=1 S:(BIJ<100) K=2
 N BISTART S BISTART=$H,BISTART=$P(BISTART,",",2)
 W !,"  Beginning ICE ",BIJ," iterations:"
 W !!,"     |"
 F I=1:1:BIJ W:(I#K=0) "."
 W "|",!,"     |"
 ;
 ;---> Begin Test.
 F I=1:1:BIJ W:(I#K=0) "." D
 .N I,IO,BIJ
 .D IMMFORC^BIRPC(,BIDFN,DT,,DUZ(2))
 ;
 ;---> Release any locks on the patient.
 L
 ;---> Report Total Time.
 W "|",!!,"  ",BIJ," ICE Iterations: ",$P($H,",",2)-BISTART," seconds",!
 D DIRZ^BIUTL3(.BIPOP)
 ;
 Q
 ;
 ;
 ;* * * OLD * * *
 ;
 ;----------
BEGIN ;EP
 N BIERR,BIFORC,BIHX,BIPROF,BITTTB,BITTTE
 ;
 ;---> Build a sample Immunization History.
 S BIHX="0^12172005^0^0^0^0^0^0^R^I^I^1^1^1^1^1^1^1^1^0^1^1^1^IHS_10^0^0"
 S BIHX=BIHX_"^HOGU,SYLVIA  Chart#: 00-00-20^20^09202003^U"
 S BIHX=BIHX_"^0^0^0^0^0^0^0^0^0^0^0^1^0^0^0^0^0^5^2022^49^0^0^0"
 S BIHX=BIHX_"^09212003^0^2085^3^0^0^0^01012004^0^2033^3^0^0^0"
 S BIHX=BIHX_"^01012004^0^2033^3^0^0^0^10112005^0^2086^83^0^0^0^01012004"
 S BIHX=BIHX_"^0^2084^50^0^0^0^01012004^0^"
 ;
 ;
 ;---> Ensure correct call to $$DEL^%ZISH.
 N X S X=$E("BIXQY0",3,6) I '$D(@X) N @X S @X="A"
 ;
 ;---> Multiple calls to ImmServe and get Forecast and Profile.
 W !!," Begin..."
 N BISTART S BISTART=$H,BISTART=$P(BISTART,",",2)
 N I
 F I=1:1:1000 D
 .D RUN^BIXCALL(BIHX,.BIPROF,.BIFORC,.BIERR)
 ;
 ;---> Report Total Time.
 W !," Seconds: ",$P($H,",",2)-BISTART
 Q
