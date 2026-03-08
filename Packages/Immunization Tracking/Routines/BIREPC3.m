BIREPC3 ;IHS/CMI/MWR - REPORT, COVID IMM; OCT 15,2010
 ;;8.5;IMMUNIZATION;**24**;OCT 24,2011;Build 15
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW COVID IMMUNIZATION REPORT.
 ;
 ;
 ;----------
AGETOT(BILINE,BICC,BIHCF,BICM,BIBEN,BIQDT,BIPOP,BIUP,BIDNOM,BIDNOMH) ;EP
 ;---> Write Age Total line.
 ;---> Parameters:
 ;     1 - BILINE  (req) Line number in ^TMP Listman array.
 ;     2 - BICC    (req) Current Community array.
 ;     3 - BIHCF   (req) Health Care Facility array.
 ;     4 - BICM    (req) Case Manager array.
 ;     5 - BIBEN   (req) Beneficiary Type array.
 ;     6 - BIQDT   (req) Quarter Ending Date.
 ;     7 - BIPOP   (ret) BIPOP=1 if error.
 ;     8 - BIUP    (req) User Population/Group (Registered, Imm, User, Active).
 ;     9 - BIDNOM  (ret) Denominator line for General Population.
 ;    10 - BIDNOMH (ret) Denominator line for High Risk and Pregnancy.
 ;
 S BIPOP=0
 S:$G(BIUP)="" BIUP="u"
 ;---> Check for required Variables.
 I '$G(BIQDT) D ERRCD^BIUTL2(622,.X) D WRITERR^BIREPC2(BILINE,X) S BIPOP=1 Q
 ;
 ;---> Get COVID immunization data for patients, by Age Group.
 N N S N=0
 ;F I="0-23","24-143","144-215","216-599","600-779","780-899","900-1500" D
 F I="0-23","24-59","60-143","144-215","216-599","600-779","780-1500" D
 .;---> For each age range, get Begin and End Dates (DOB's).
 .D AGEDATE^BIAGE(I,BIQDT,.BIBEGDT,.BIENDDT)
 .S N=N+1
 .D GETPATS^BIREPC4(BIBEGDT,BIENDDT,N,.BICC,.BIHCF,.BICM,.BIBEN,BIQDT,BIUP)
 ;
 ;---> Total patients by Age Group.
 N BIAGRP,BIHRTOT,BIPRGTOT,BITOT S (BIHRTOT,BIPRGTOT,BITOT)=0
 F I=1:1:7 D
 .N M,N S M=0,N=0,BIAGRP(I)=0,BIAGRPR(I)=0
 .F  S N=$O(^TMP("BIREPC1",$J,"PATS",I,N)) Q:'N  D
 ..S BIAGRP(I)=BIAGRP(I)+1 S BITOT=BITOT+1
 ..;---> Get High Risk and Pregnancy totals.
 ..N X S X=^TMP("BIREPC1",$J,"PATS",I,N)
 ..;---> Only get High Risk for Adult Age Groups.
 ..I X[1 I I>3 S BIAGRPR(I)=BIAGRPR(I)+1 S BIHRTOT=BIHRTOT+1
 ..;---> Pregnancy denominator.
 ..I X[2 S BIPRGTOT=BIPRGTOT+1
 .;
 .S BITMP("STATS","TOTAL",I)=BIAGRP(I)
 .I I>3 S BITMP("STATS","HRISK",I)=BIAGRPR(I)
 ;
 S BITMP("STATS","TOTAL","ALL")=BITOT
 S BITMP("STATS","HRTOTAL","ALL")=BIHRTOT
 S BITMP("STATS","PRGTOT","ALL")=BIPRGTOT
 ;
 ;
 ;---> TOTAL POPULATION: Consolidate Fully Immunized, set under "Series"=5.
 N BIAGRP
 F BIAGRP=1:1:7 D
 .N Y,Z
 .S Y=$G(BITMP("STATS",0,1,1,BIAGRP))
 .S Z=$G(BITMP("STATS",0,2,2,BIAGRP))
 .S BITMP("STATS",0,5,1,BIAGRP)=Y+Z
 ;
 ;---> TOTOL POP: Fully Immunized Age Clusters: Peds/Adols and Adults under "Series"=5.
 N N,Z S Z=0 F N=1,2,3,4 S Z=Z+BITMP("STATS",0,5,1,N)
 S BITMP("STATS",0,5,"PEDSC")=Z
 S Z=0 F N=1,2,3,4 S Z=Z+BITMP("STATS","TOTAL",N)
 S BITMP("STATS","TOTAL","PEDSC")=Z
 ;
 S Z=0 F N=5,6,7 S Z=Z+BITMP("STATS",0,5,1,N)
 S BITMP("STATS",0,5,"ADULTSC")=Z
 S Z=0 F N=5,6,7 S Z=Z+BITMP("STATS","TOTAL",N)
 S BITMP("STATS","TOTAL","ADULTSC")=Z
 ;
 ;---> HIGH RISK: Consolidate Fully Immunized under "Series"=5.
 F BIAGRPR=4:1:7 D
 .N Y,Z
 .S Y=$G(BITMP("STATS",1,1,1,BIAGRPR))
 .S Z=$G(BITMP("STATS",1,2,2,BIAGRPR))
 .S BITMP("STATS",1,5,1,BIAGRPR)=Y+Z
 ;
 ;---> HIGH RISK: Consolidate Age Categories Adults under "Series"=6.
 ;S Z=0 F N=4,5,6,7 S Z=Z+BITMP("STATS",1,5,1,N)
 ;S BITMP("STATS",1,5,"ADULTSC")=Z
 ;S Z=0 F N=4,5,6,7 S Z=Z+BITMP("STATS","TOTAL",N)
 ;S BITMP("STATS","TOTAL","ADULTSC")=Z
 ;
 ;
 ;---> PREGNANCY: Consolidate Fully Immunized under "Series"=5.
 F BIAGRPR=4:1:7 D
 .N Y,Z
 .S Y=$G(BITMP("STATS",7,1,1,1))
 .S Z=$G(BITMP("STATS",7,2,2,1))
 .S BITMP("STATS",7,5,1,1)=Y+Z
 ;---> Uncomment <break> here to examine Report array.
 ;b
 ;
 ;---> Set Denominator line for Total Population.
 N X S X=" Denominator |"
 F I=1:1:7 S X=X_$J($G(BITMP("STATS","TOTAL",(I))),6)_"  "
 S BIDNOM=$E(X,1,$L(X)-2)_" |"_$J(BITOT,7)
 ;
 ;---> Set Denominator line for High Risk/Immunocompromised and Pregnancy.
 N X S X=" Denominator |  "
 F I=4:1:7 S X=X_$J($G(BITMP("STATS","HRISK",(I))),6)_"  "
 S BIDNOMH=$E(X,1,$L(X)-2)_" |  "_$J($G(BITMP("STATS","HRTOTAL","ALL")),7)
 S BIDNOMH=BIDNOMH_"  |    "_$J($G(BITMP("STATS","PRGTOT","ALL")),7)
 ;
 Q
 ;
 ;
 ;----------
VGRP(BILINE,BIDNOM,BIDNOMH) ;EP
 ;---> Write Stats lines for COVID Group.
 ;---> Parameters:
 ;     1 - BILINE  (req) Line number in ^TMP Listman array.
 ;     2 - BIDNOM  (req) Denominator line for General Population.
 ;     3 - BIDNOMH (ret) Denominator line for High Risk and Pregnancy.
 ;
 ;---> Write Denominator Line for General Population.
 D WRITE(.BILINE,$G(BIDNOM)),DASHLINE(.BILINE)
 ;
 ;---> Write lines for 2-Dose Series.
 D VGRP1(.BILINE,2,1)
 D VGRP1(.BILINE,2,2)
 ;
 ;---> Write line for 1-Dose Series.
 D VGRP1(.BILINE,1,1)
 ;
 ;---> Write line for Total Patients who have completed a series.
 D VGRP1(.BILINE,5,1,1)
 ;
 ;---> Write line for consolidated NORMAL Age Clusters.
 D VGRP4(.BILINE,0),DASHLINE(.BILINE)
 ;
 ;---> Write line for Received Booster.
 D VGRP1(.BILINE,4,1)
 ;
 ;---> Write line for Unvaccinated.
 D VGRP1(.BILINE,0,0),DASHLINE(.BILINE)
 ;
 ;
 ;---> Contraindications.
 D VGRP3(.BILINE,1)
 ;---> Refusals.
 D VGRP3(.BILINE,0)
 ;
 ;
 ;---> Start HIGH RISK STATS HERE *
 ;
 S X=$$SP^BIUTL5(13)_"|    * IMMUNOCOMPROMISED Section *"
 D WRITE(.BILINE,X),DASHLINE(.BILINE)
 S X=$$SP^BIUTL5(13)_"|      Age in years on "
 S X=X_$$SLDT2^BIUTL5(BIQDT)_"             |"
 D WRITE(.BILINE,X)
 ;
 S X="             |"_$$SP^BIUTL5(45,"-")_"|    Pregnancy*"
 D WRITE(.BILINE,X)
 ;
 S X="             |   12-17   18-49   50-64     65+ |    Totals |    Any Age"
 S X=$$PAD^BIUTL5(X)
 D WRITE(.BILINE,X),DASHLINE(.BILINE)
 ;---> Write Denominator Line for General Population.
 D WRITE(.BILINE,$G(BIDNOMH)),DASHLINE(.BILINE)
 ;
 ;---> Write lines for 2-Dose Series.
 D VGRP2(.BILINE,2,1)
 D VGRP2(.BILINE,2,2)
 ;
 ;---> Write line for 1-Dose Series.
 D VGRP2(.BILINE,1,1)
 ;
 ;---> Write line for Fully Vaccinated.
 D VGRP2(.BILINE,5,1)
 ;
 ;---> Write line for Received Additional Dose.
 D VGRP2(.BILINE,3,1)
 ;
 ;---> Write line for Received Booster.
 D VGRP2(.BILINE,4,1)
 ;
 ;---> Write line for consolidated High Risk Adult Category.
 ;---> Unless PEDS is included, this Age Cluster is already displayed in
 ;---> Totals column.
 ;D VGRP4(.BILINE,1),DASHLINE(.BILINE)
 ;
 ;---> Write line for Unvaccinated.
 D VGRP2(.BILINE,0,0)
 ;
 ;---> Added note.
 S X=" *NOTE: Patients in the Immunocompromised and Pregnancy sections of the report"
 D WRITE(.BILINE,X)
 S X="        are included in the statistics of the Adult General Population section."
 D WRITE(.BILINE,X),DASHLINE(.BILINE)
 S X=" *NOTE: The Pregnancy section of the report is not yet functional."
 D WRITE(.BILINE,X),DASHLINE(.BILINE)
 ;
 Q
 ;
 ;
VGRP1(BILINE,BISER,BIDOSE,BINOLAB) ;EP
 ;---> Write report lines for Normal (not High Risk) population.
 ;---> BIX=text of the line to write.
 N BIX D
 .I BISER=0 S BIX=" Unvaccinated" Q
 .I BISER=1 S BIX=" Completed 1-" Q
 .I BISER=4 S BIX=" Boosters" Q
 .I BISER=5 S BIX=" Total Fully" Q
 .S BIX=" 1st of a "_BISER_"-" I BIDOSE=2 S BIX=" Completed 2-"
 S BIX=$$PAD^BIUTL5(BIX,13)_"|"
 ;
 ;---> Now loop through the Age Groups, concating subtotals.
 N BIAGRP,BISUBT S BISUBT=0
 F BIAGRP=1:1:7 D
 .;---> BITMP(Normal, Series, Dose, Age Group)
 .N Y S Y=+$G(BITMP("STATS",0,BISER,BIDOSE,BIAGRP))
 .;---> Write stats for each Age Group, and total.
 .S BIX=BIX_$J(Y,6)_"  " S BISUBT=BISUBT+Y
 ;
 S BIX=$E(BIX,1,$L(BIX)-2)_" |"_$J(BISUBT,7)
 D WRITE(.BILINE,BIX)
 ;I BIDOSE=1 D MARK^BIW(BILINE,BIMAXD+2,"BIREPC1")
 I BIDOSE=1 D MARK^BIW(BILINE,2+2,"BIREPC1")
 ;
 ;---> *** NOW WRITE PERCENTAGES LINE:
 N BIX D
 .I BISER=0 S BIX=" " Q
 .I BISER=4 S BIX=" Received" Q
 .I BISER=5 S BIX=" Vaccinated" Q
 .;I BISER=5 S BIX=" Completed" Q
 .S BIX=" Dose Series "
 S BIX=$$PAD^BIUTL5(BIX,13)_"|"
 ;
 ;---> Now loop through the Age Groups, writing percentages.
 F BIAGRP=1:1:7 D
 .;---> BITMP(Normal, Series, Dose, Age Group)
 .N Y S Y=$G(BITMP("STATS",0,BISER,BIDOSE,BIAGRP)) S:Y="" Y=0
 .N Z S Z=$G(BITMP("STATS","TOTAL",BIAGRP)) S:'Z Y=0,Z=1
 .S BIX=BIX_"   "_$J((100*Y/Z),3,0)_"% "
 ;
 ;---> Now write total percentage.
 N Y S Y=BISUBT S:Y="" Y=0
 N Z S Z=$G(BITMP("STATS","TOTAL","ALL")) S:'Z Y=0,Z=1
 S BIX=$$PAD^BIUTL5(BIX,69)_"|    "_$J((100*Y/Z),3,0)_"%"
 D WRITE(.BILINE,BIX),DASHLINE(.BILINE,$G(BINOLAB))
 ;
 Q
 ;
 ;
VGRP2(BILINE,BISER,BIDOSE) ;EP
 ;---> Write report lines for High Risk population.
 ;---> BIX=text of the line to write.
 N BIX D
 .I BISER=0 S BIX=" Unvaccinated" Q
 .I BISER=1 S BIX=" Completed 1-" Q
 .I BISER=3 S BIX=" Additional" Q
 .I BISER=4 S BIX=" Boosters" Q
 .I BISER=5 S BIX=" Total Fully" Q
 .S BIX=" 1st of a "_BISER_"-" I BIDOSE=2 S BIX=" Completed 2-"
 S BIX=$$PAD^BIUTL5(BIX,13)_"|  "
 ;
 ;---> Now loop through the Age Groups, concating subtotals.
 N BIAGRP,BISUBT S BISUBT=0
 F BIAGRP=4:1:7 D
 .;---> BITMP(Risk, Series, Dose, Age Group)
 .N Y S Y=+$G(BITMP("STATS",1,BISER,BIDOSE,BIAGRP))
 .;---> Write stats for each Age Group, and total.
 .S BIX=BIX_$J(Y,6)_"  " S BISUBT=BISUBT+Y
 ;
 S BIX=$E(BIX,1,$L(BIX)-2)_" |  "_$J(BISUBT,7)_"  |"
 ;
 ;---> Append Pregnancy stats: BITMP(7, Series, Dose, 1)
 N Y S Y=+$G(BITMP("STATS",7,BISER,BIDOSE,1))
 S BIX=BIX_"    "_$J(Y,7)
 ;
 D WRITE(.BILINE,BIX)
 I BIDOSE=1 D MARK^BIW(BILINE,2+2,"BIREPC1")
 ;
 ;---> *** NOW WRITE PERCENTAGES LINE:
 N BIX D
 .I BISER=0 S BIX=" " Q
 .I BISER=3 S BIX=" Dose Rcvd" Q
 .I BISER=4 S BIX=" Received" Q
 .I BISER=5 S BIX=" Vaccinated" Q
 .S BIX=" Dose Series "
 S BIX=$$PAD^BIUTL5(BIX,13)_"|  "
 ;
 ;---> Now loop through the Age Groups, writing percentages.
 F BIAGRP=4:1:7 D
 .;---> BITMP(High Risk, Series, Dose, Age Group)
 .N Y S Y=$G(BITMP("STATS",1,BISER,BIDOSE,BIAGRP)) S:Y="" Y=0
 .N Z S Z=$G(BITMP("STATS","HRISK",BIAGRP)) S:'Z Y=0,Z=1      ;IHS/CMI/LAB - used to say TOTAL not HRISK
 .S BIX=BIX_"   "_$J((100*Y/Z),3,0)_"% "
 ;
 ;---> Now write total percentage.
 N Y S Y=BISUBT S:Y="" Y=0
 N Z S Z=$G(BITMP("STATS","HRTOTAL","ALL")) S:'Z Y=0,Z=1
 S BIX=$$PAD^BIUTL5(BIX,47)_"|      "_$J((100*Y/Z),3,0)_"% |"
 ;
 ;---> Append Pregnancy percentages.
 N Y S Y=$G(BITMP("STATS",7,BISER,BIDOSE,1)) S:Y="" Y=0
 N Z S Z=$G(BITMP("STATS","PRGTOT","ALL")) S:'Z Y=0,Z=1
 S BIX=BIX_"        "_$J((100*Y/Z),3,0)_"% "
 D WRITE(.BILINE,BIX),DASHLINE(.BILINE)
 ;
 Q
 ;
 ;
VGRP3(BILINE,BIC) ;EP
 ;---> Write report lines for Contraindications and Refusals.
 ;---> Parameters:
 ;     1 - BILINE (req) Line number in ^TMP Listman array.
 ;     2 - BIC    (opt) For Contras, BIC=1; otherwise Refusals.
 N BIX
 S BIX=$S(BIC=1:" Contra-",1:" Refusals")
 S BIX=$$PAD^BIUTL5(BIX,13)_"|"
 ;
 ;---> Now loop through the Age Groups, concating subtotals.
 N BIAGRP,BISUBT S BISUBT=0
 F BIAGRP=1:1:7 D
 .;---> BITMP
 .N Y,Z S Z=$S(BIC=1:"Z_CONTRAS",1:"Z_REFUSALS")
 .S Y=+$G(BITMP("STATS",Z,BIAGRP))
 .;---> Write stats for each Age Group, and total.
 .S BIX=BIX_$J(Y,6)_"  " S BISUBT=BISUBT+Y
 ;
 S BIX=$E(BIX,1,$L(BIX)-2)_" |"_$J(BISUBT,7)
 D WRITE(.BILINE,BIX)
 D MARK^BIW(BILINE,4,"BIREPC1")
 ;
 ;---> *** NOW WRITE PERCENTAGES LINE:
 S BIX=$S(BIC=1:" indications",1:"")
 S BIX=$$PAD^BIUTL5(BIX,13)_"|"
 ;
 ;---> Now loop through the Age Groups, writing percentages.
 F BIAGRP=1:1:7 D
 .;---> BITMP(Normal, Series, Dose, Age Group)
 .N Y,J
 .S J=$S(BIC=1:"Z_CONTRAS",1:"Z_REFUSALS")
 .S Y=$G(BITMP("STATS",J,BIAGRP)) S:Y="" Y=0
 .N Z S Z=$G(BITMP("STATS","TOTAL",BIAGRP)) S:'Z Y=0,Z=1
 .S BIX=BIX_"   "_$J((100*Y/Z),3,0)_"% "
 ;
 ;---> Now write total percentage.
 N Y S Y=BISUBT S:Y="" Y=0
 N Z S Z=$G(BITMP("STATS","TOTAL","ALL")) S:'Z Y=0,Z=1
 S BIX=$$PAD^BIUTL5(BIX,69)_"|    "_$J((100*Y/Z),3,0)_"%"
 D WRITE(.BILINE,BIX),DASHLINE(.BILINE)
 ;
 Q
 ;
 ;
VGRP4(BILINE,BIRISK) ;EP
 ;---> Write report lines for Consolidated Age Categories.
 ;---> Parameters:
 ;     1 - BILINE (req) Line number in ^TMP Listman array.
 ;     2 - BIRISK (opt) BIRISK=1: High Risk; otherwise Normal.
 N BIX S:'$G(BIRISK) BIRISK=0
 S BIX=" By Category |"
 ;
 N W,X,Y,Z
 D
 .S Y=$G(BITMP("STATS",BIRISK,5,"ADULTSC")) S:Y="" Y=0
 .S Z=$G(BITMP("STATS","TOTAL","ADULTSC")) S:'Z Y=0,Z=1
 .Q:BIRISK
 .S W=$G(BITMP("STATS",BIRISK,5,"PEDSC")) S:W="" W=0
 .S X=$G(BITMP("STATS","TOTAL","PEDSC")) S:'X W=0,X=1
 ;
 D
 .I 'BIRISK S BIX=BIX_"   Ages 0-17 yrs:"_$J(W,7)_" |"
 .S BIX=BIX_"   Ages 18-75+ yrs:  "_$J(Y,7)_" |"
 D WRITE(.BILINE,BIX)
 ;---> *** NOW WRITE PERCENTAGES LINE:
 S BIX="             |"
 I 'BIRISK S BIX=BIX_"                     "_$J((100*W/X),3,0)_"%|"
 S BIX=BIX_"                         "_$J((100*Y/Z),3,0)_"%|"
 D WRITE(.BILINE,BIX)
 D MARK^BIW(BILINE,4,"BIREPC1")
 ;
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
 D WL^BIW(.BILINE,"BIREPC1",$G(BIVAL),$G(BIBLNK))
 Q
 ;
 ;
DASHLINE(BILINE,BINOLAB) ;EP
 ;---> Write a dashed line.
 ;---> Parameters:
 ;     1 - BILINE  (ret) Last line# written.
 ;     2 - BINOLAB (opt) 1: Don't separate label lines.
 ;
 I $G(BINOLAB) D  Q
 .N X S X="             |" S X=$$PAD^BIUTL5(X,79,"-") D WRITE(.BILINE,X)
 ;
 D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
