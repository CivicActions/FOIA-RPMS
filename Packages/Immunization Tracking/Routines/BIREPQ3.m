BIREPQ3 ;IHS/CMI/MWR - REPORT, QUARTERLY IMM; OCT 15, 2010
 ;;8.5;IMMUNIZATION;**31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW QUARTERLY IMMUNIZATION REPORT.
 ;;  PATCH 2: Fix header at 16-18mths to say 4-PCV.  MNEED+24
 ;
 ;
 ;----------
AGETOT(BILINE,BICC,BIHCF,BICM,BIBEN,BIQDT,BIHPV,BIUP,BIPOP) ;EP
 ;---> Write Age Total line.
 ;---> Parameters:
 ;     1 - BILINE (req) Line number in ^TMP Listman array.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BICM   (req) Case Manager array.
 ;     5 - BIBEN  (req) Beneficiary Type array.
 ;     6 - BIQDT  (req) Quarter Ending Date.
 ;     7 - BIHPV  (req) 1=include Hep A.
 ;     8 - BIUP   (req) User Population/Group (Registered, Imm, User, Active).
 ;     9 - BIPOP  (ret) BIPOP=1 if error.
 ;
 S BIPOP=0
 ;---> Check for required Variables.
 I '$G(BIQDT) D ERRCD^BIUTL2(623,.X) D WRITERR^BIREPQ2(BILINE,X) S BIPOP=1 Q
 ;
 ;---> Gather and sort patients.
 N N S N=0
 F I="3-4","5-6","7-15","16-18","19-23","24-27" D
 .;---> For each age range, get Begin and End Dates (DOB's).
 .D AGEDATE^BIAGE(I,BIQDT,.BIBEGDT,.BIENDDT)
 .S N=N+1
 .D GETPATS^BIREPQ4(BIBEGDT,BIENDDT,N,.BICC,.BIHCF,.BICM,.BIBEN,BIQDT,BIHPV,BIUP)
 ;
 ;---> Count patients.
 N BIAGRP,BITOT S BITOT=0
 F I=1:1:6 D
 .N M,N S M=0,N=0,BIAGRP(I)=0
 .F  S N=$O(^TMP("BIREPQ1",$J,"PATS",I,N)) Q:'N  D
 ..S BIAGRP(I)=BIAGRP(I)+1,BITOT=BITOT+1
 .S BITMP("STATS","TOTAL",I)=BIAGRP(I)
 S BITMP("STATS","TOTAL","ALL")=BITOT
 ;
 ;---> Write Age Totals line.
 N X
 ;N X S X=" Age Total|"
 I BISPD'="CSV" D
 .S X=" # in Age |"
 .F I=1:1:6 S X=X_$J(BIAGRP(I),7)_"   "
 .S X=$E(X,1,$L(X)-2)_"|"_$J(BITOT,7)
 I BISPD="CSV" D
 .S X="# in Age"
 .F I=1:1:6 S X=X_","_BIAGRP(I)
 .S X=X_","_BITOT
 D WRITE(.BILINE,X)
 I BISPD'="CSV" D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
 ;
 ;
 ;----------
MNEED(BILINE,BIHPV) ;EP
 ;---> Write Minimum Needs lines.
 ;---> Parameters:
 ;     1 - BILINE (req) Line number in ^TMP Listman array.
 ;     2 - BIHPV  (req) 1=Include Varicella & Pneumo.
 ;
 S:'$D(BILINE) BILINE=0
 I BISPD="CSV" D  Q
 .S X="Minimun Needs,1-DTaP|1-Polio|1-HIB|1-HEPB"_$S($G(BIHPV):"|1-PCV",1:"")
 .S X=X_",2-DTaP|2-Polio|2-HIB|2-HEPB"_$S($G(BIHPV):"|2-PCV",1:"")
 .S X=X_",3-DTaP|2-Polio|2-HIB|2-HEPB"_$S($G(BIHPV):"|3-PCV",1:"")
 .S X=X_",3-DTaP|2-Polio|3-HIB|2-HEPB"_$S($G(BIHPV):"|4-PCV",1:"")_"|1-MMR|"_$S($G(BIHPV):"|1-VAR",1:"")
 .S X=X_",4-DTaP|3-Polio|3-HIB|3-HEPB"_$S($G(BIHPV):"|4-PCV",1:"")_"|1-MMR|"_$S($G(BIHPV):"|1-VAR",1:"")
 .S X=X_",4-DTaP|3-Polio|3-HIB|3-HEPB"_$S($G(BIHPV):"|4-PCV",1:"")_"|1-MMR|"_$S($G(BIHPV):"|1-VAR",1:"")
 .D WRITE(.BILINE,X)
 S X=" Minimum  |    1-DTaP    2-DTaP   3-DTaP   3-DTaP    4-DTaP"
 S X=X_"    4-DTaP|"
 D WRITE(.BILINE,X)
 S X=" Needs    |    1-POLIO   2-POLIO  2-POLIO  2-POLIO"
 S X=X_"   3-POLIO   3-POLI|"
 D WRITE(.BILINE,X)
 S X="          |    1-HIB     2-HIB    2-HIB    3-HIB     3-HIB"
 S X=X_"     3-HIB |"
 D WRITE(.BILINE,X)
 S X="          |    1-HEPB    2-HEPB   2-HEPB   2-HEPB    3-HEPB"
 S X=X_"    3-HEPB|"
 D WRITE(.BILINE,X)
 D:$G(BIHPV)
 .;
 .;********** PATCH 2, v8.4, OCT 15,2010, IHS/CMI/MWR
 .;---> Fix header at 16-18mths to say 4-PCV.
 .;S X="          |    1-PCV     2-PCV    3-PCV    3-PCV "
 .S X="          |    1-PCV     2-PCV    3-PCV    4-PCV "
 .;**********
 .;
 .S X=X_"    4-PCV     4-PCV |"
 .D WRITE(.BILINE,X)
 ;S X="          |    1-ROTA    2-ROTA   3-ROTA   3-ROTA    3-ROTA"
 ;S X=X_"    3-ROTA|"
 ;D WRITE(.BILINE,X)
 S X="          |                                1-MMR     1-MMR   "
 S X=X_"  1-MMR |"
 D WRITE(.BILINE,X)
 D:$G(BIHPV)
 .S X="          |                                1-VAR     1-VAR   "
 .S X=X_"  1-VAR |"
 .D WRITE(.BILINE,X)
 ;D:$G(BIHPV)   ;Never include Hep A.
 ;.S X="          |                                                  "
 ;.S X=X_"  1-HEPA|"
 ;.D WRITE(.BILINE,X)
 D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
 ;
 ;
 ;----------
APPROP(BILINE) ;EP
 ;---> Write Appropriate for Age lines.
 ;---> Parameters:
 ;     1 - BILINE (req) Line number in ^TMP Listman array.
 ;
 ;---> Numbers of appropriate line.
 N BITOT,X S BITOT=0
 I BISPD'="CSV" D
 .S X=" Approp.  |"
 .F BIAGRP=1:1:6 D
 ..N Y S Y=$G(BITMP("STATS","APPRO",BIAGRP)) S:Y="" Y=0
 ..S X=X_$J(Y,7)_"   ",BITOT=BITOT+Y
 .S X=$E(X,1,$L(X)-2)_"|"_$J(BITOT,7)
 I BISPD="CSV" D
 .S X="Approp. for Age #"
 .F BIAGRP=1:1:6 D
 ..N Y S Y=$G(BITMP("STATS","APPRO",BIAGRP)) S:Y="" Y=0
 ..S X=X_","_Y,BITOT=BITOT+Y
 .S X=X_","_+BITOT_","
 D WRITE(.BILINE,X)
 D MARK^BIW(BILINE,3,"BIREPQ1")
 ;
 ;---> Percentage of appropriate line.
 I BISPD'="CSV" D
 .S X=" for Age  |",BITOT=0
 .F BIAGRP=1:1:6 D
 ..N Y S Y=$G(BITMP("STATS","APPRO",BIAGRP)) S:Y="" Y=0
 ..N Z S Z=$G(BITMP("STATS","TOTAL",BIAGRP)) S:'Z Y=0,Z=1
 ..N BIPERC S BIPERC="    "_$J((100*Y/Z),3,0)_"%"
 ..S X=X_BIPERC_"  ",BITOT=BITOT+Y
 I BISPD="CSV" D
 .S X="Approp. for Age %"
 .S BITOT=0
 .F BIAGRP=1:1:6 D
 ..N Y S Y=$G(BITMP("STATS","APPRO",BIAGRP)) S:Y="" Y=0
 ..N Z S Z=$G(BITMP("STATS","TOTAL",BIAGRP)) S:'Z Y=0,Z=1
 ..N BIPERC S BIPERC=$J((100*Y/Z),3,0)
 ..S X=X_","_$$STRIP^XLFSTR(BIPERC," "),BITOT=BITOT+Y
 ;
 N Y S Y=BITOT S:Y="" Y=0
 N Z S Z=$G(BITMP("STATS","TOTAL","ALL")) S:'Z Y=0,Z=1
 I BISPD'="CSV" S X=$E(X,1,$L(X)-2)_"|    "_$J((100*Y/Z),3,0)_"%"
 I BISPD="CSV" S X=X_","_$$STRIP^XLFSTR($J((100*Y/Z),3,0)," ")
 D WRITE(.BILINE,X)
 I BISPD'="CSV" D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
 ;
 ;
 ;----------
VGRP(BILINE,BIVGRP) ;EP
 ;---> Write Stats lines for each Vaccine Group.
 ;---> Parameters:
 ;     1 - BILINE (req) Line number in ^TMP Listman array.
 ;     2 - BIVGRP (req) IEN of Vaccine Group.
 ;
 ;---> Write a line for each Dose of this Vaccine Group.
 N BIDOSE,BIMAXD S BIMAXD=$$VGROUP^BIUTL2(BIVGRP,6)
 N BIDOSE F BIDOSE=1:1:BIMAXD D
 .;
 .;---> BIX=text of the line to write.
 .;---> Write the Dose#-Vaccine Group in left margin.
 .N BIX
 .I BISPD'="CSV" S BIX="  "_BIDOSE_"-"_$$VGROUP^BIUTL2(BIVGRP,5) S BIX=$$PAD^BIUTL5(BIX,10)_"|"
 .I BISPD="CSV" S BIX=BIDOSE_"-"_$$VGROUP^BIUTL2(BIVGRP,5)_" #"
 .;
 .;---> Now loop through the 6 age groups, concating subtotals.
 .N BIAGRP,BISUBT S BISUBT=0
 .F BIAGRP=1:1:6 D
 ..N Y S Y=$G(BITMP("STATS",BIVGRP,BIDOSE,BIAGRP))
 ..I BISPD'="CSV" S BIX=BIX_$J(Y,7)_"   ",BISUBT=BISUBT+Y
 ..I BISPD="CSV" S BIX=BIX_","_+Y,BISUBT=BISUBT+Y
 .;
 .I BISPD'="CSV" S BIX=$E(BIX,1,$L(BIX)-2)_"|"_$J(BISUBT,7)
 .I BISPD="CSV" S BIX=BIX_","_+BISUBT_","
 .D WRITE(.BILINE,BIX)
 .I BIDOSE=1 D MARK^BIW(BILINE,BIMAXD+1,"BIREPQ1")
 I BISPD'="CSV" D WRITE(.BILINE,$$SP^BIUTL5(79,"-"))
 Q
 ;
 ;
 ;----------
WRITE(BILINE,BIVAL,BIBLNK) ;EP
 ;---> Write lines to ^TMP (see documentation in ^BIW).
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line# written.
 ;     2 - BIVAL  (opt) Value/text of line (Null=blank line).
 ;
 Q:'$D(BILINE)
 D WL^BIW(.BILINE,"BIREPQ1",$G(BIVAL),$G(BIBLNK))
 Q
