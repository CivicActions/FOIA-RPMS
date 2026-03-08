BRACOMP ;IHS/CMI/DAY - Report to Compare Exam with V Rad ; 14 Aug 2017  2:38 PM
 ;;5.0;Radiology/Nuclear Medicine;**1007**;Nov 01, 2010;Build 14
 ;
 W !!,"This Report will look at the current Radiology Procedure in the",!
 W "Radiology package, and compare it with the value stored in the",!
 W "V RADIOLOGY file in the Patient Care Component (PCC)",!!
 ;
 K %DT
 S %DT("A")="Enter a Beginning Exam Date: "
 S %DT="APEX"
 D ^%DT
 I X="" Q
 S BRABEG=Y
 ;
 K %DT
 S %DT("A")="Enter an Ending Exam Date: "
 S %DT="APEX"
 D ^%DT
 I X="" Q
 S X1=Y,X2=1 D C^%DTC
 S BRAEND=Y
 ; 
 I BRABEG>BRAEND W !!,"End Date Must be later than Begin Date",!! H 5 Q
 ;
 W !!
 W "This Report may take several minutes to run",!
 ;
 S XBNS="BRA",XBRP="EN^BRACOMP",XBRX="XIT^BRACOMP"
 D ^XBDBQUE
 ;
 Q
 ;
 ;
EN ;EP - Entry Point for Processing
 ;
 U IO
 D HEADER
 ;
 S BRAEXIT=0
 ;
 S BRADFN=0
 F  S BRADFN=$O(^RADPT(BRADFN)) Q:'BRADFN  D  Q:BRAEXIT=1
 .;
 .S BRADTI=0
 .F  S BRADTI=$O(^RADPT(BRADFN,"DT",BRADTI)) Q:'BRADTI  D  Q:BRAEXIT=1
 ..;
 ..;Check Dates
 ..S BRADATI=$P($G(^RADPT(BRADFN,"DT",BRADTI,0)),U)
 ..I BRADATI<BRABEG Q
 ..I BRADATI>BRAEND Q
 ..;
 ..S BRACNI=0
 ..F  S BRACNI=$O(^RADPT(BRADFN,"DT",BRADTI,"P",BRACNI)) Q:'BRACNI  D  Q:BRAEXIT=1
 ...;
 ...;Check if Status is Cancelled
 ...S BRAZERO=$G(^RADPT(BRADFN,"DT",BRADTI,"P",BRACNI,0))
 ...S BRASTAI=$P(BRAZERO,U,3)
 ...S BRAOK=0
 ...I $$GET1^DIQ(72,BRASTAI,.01)="EXAMINED" S BRAOK=1
 ...I $$GET1^DIQ(72,BRASTAI,.01)="TRANSCRIBED" S BRAOK=1
 ...I $$GET1^DIQ(72,BRASTAI,.01)="COMPLETE" S BRAOK=1
 ...I BRAOK=0 Q
 ...;
 ...S BRAPRCI=$P(BRAZERO,U,2)
 ...;
 ...;Is there a PCC node
 ...S BRAZERO=$G(^RADPT(BRADFN,"DT",BRADTI,"P",BRACNI,"PCC"))
 ...S BRAVRI=$P(BRAZERO,U,2)
 ...;
 ...;Get V Rad procedure
 ...S BRAVPRCI=0
 ...I BRAVRI S BRAVPRCI=$P($G(^AUPNVRAD(BRAVRI,0)),U)
 ...;
 ...;Compare
 ...I BRAVPRCI=BRAPRCI Q
 ...;
 ...U IO
 ...;
 ...S BRANAME=$$GET1^DIQ(2,BRADFN,.01)
 ...S BRANAME=$E(BRANAME,1,25)
 ...S BRAHRN=$$HRN^AUPNPAT(BRADFN,DUZ(2))
 ...S BRAHRN="("_BRAHRN_")"
 ...S BRADATE=$E(BRADATI,4,7)_$E(BRADATI,2,3)
 ...S BRACASE=$P(^RADPT(BRADFN,"DT",BRADTI,"P",BRACNI,0),U)
 ...S BRAACCN=BRADATE_"-"_BRACASE
 ...;
 ...I $Y>(IOSL-5) D  Q:BRAEXIT=1
 ....;
 ....I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR K DIR
 ....I $D(DUOUT) S BRAEXIT=1 Q
 ....;
 ....D HEADER
 ...;
 ...W BRANAME
 ...W " ",BRAHRN
 ...W ?38,"RAD: ",$E($$GET1^DIQ(71,BRAPRCI,.01),1,35),!
 ...W BRAACCN
 ...W ?38,"PCC: ",$E($$GET1^DIQ(71,BRAVPRCI,.01),1,35),!
 ...W !
 ;
 Q
 ;
 ;
HEADER ;EP - Print Header
 ;
 W @IOF
 W !
 W "Patient (HRN)",?38,"Radiology Procedure",!
 W "Accession Number",?38,"PCC Procedure",!
 F I=1:1:77 W "-"
 W !
 Q
 ;
 ;
XIT ;EP - EOJ processing
 ;
 X ^%ZIS("C")
 I $E(IOST)="C" K DIR S DIR(0)="E" D ^DIR K DIR
 D EN^XBVK("BRA")
 ;
 Q
 ;
 ;
