BILETPR4 ;IHS/CMI/MWR - PRINT PATIENT LETTER; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**25**;OCT 24, 2011;Build 22
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PRINT INDIVIDUAL PATIENT LETTERS.
 ;;  PATCH 1: Add ability to print a second street address line.  PRINT+23
 ;
 ;
 ;----------
PRINT(BIDFN,IO,IOST,BIERR) ;EP
 ;---> Print patient letter.
 ;---> Parameters:
 ;     1 - BIDFN (req) Patient's IEN (DFN).
 ;     2 - IO    (req) Output Device $I.
 ;     3 - IOST  (req) Subtype Name.
 ;     4 - BIERR (ret) Error Code, if any.
 ;
 ;---> CodeChange for v7.1 - IHS/CMI/MWR 12/01/2000:
 ;---> To eliminate control chars from printouts.
 ;D FULL^VALM1
 N BICRT S BICRT=$S(($E(IOST)="C")!(IOST["BROWSER"):1,1:0)
 ;
 I '$G(BIDFN) S BIERR=201 Q
 I '$D(^DPT(BIDFN,0)) S BIERR=203 Q
 I '$D(^TMP("BILET",$J)) S BIERR=637 Q
 ;
 ;
 U IO
 ;---> To eliminate control chars from printouts.
 I BICRT D FULL^VALM1 W @IOF
 ;
 ;********** PATCH 1, SEP 21,2006, IHS/CMI/MWR
 ;---> Several line changes follow to allow printing of second street
 ;---> address line, if it is on the form letter and if the patient
 ;---> has data.  Otherwise, skip printing that line (do not print blank).
 ;
 ;---> Loop through ^TMP("BILET",$J, writing lines of letter.
 N N S N=0
 F  S N=$O(^TMP("BILET",$J,N)) Q:'N  D  Q:BIPOP
 .;
 .;---> Set BILINE=text of a line in the letter.
 .N BILINE S BILINE=^TMP("BILET",$J,N,0)
 .N BIBLNKL,BISTRT2 S BISTRT2=0,BIBLNKL=$$PAD^BIUTL5(" ",80," ")
 .;
 .;---> Won't fit on the bottom of this page, do formfeed.
 .I N>1 I $Y+5>IOSL D  Q:BIPOP  W @IOF
 ..D:BICRT DIRZ^BIUTL3(.BIPOP)
 .;
 .;---> If line contains Functions, process them.
 .D:BILINE["|"
 ..;---> BIPCS=number of "|"-pieces in this line.
 ..S BIPCS=$L(BILINE,"|")
 ..N BILINE1 S BILINE1=""
 ..F I=1:1:BIPCS D
 ...N X S X=$P(BILINE,"|",I)
 ...;
 ...;---> If this is an even piece, it should contain a function.
 ...D:'(I#2)
 ....Q:X=""
 ....I X="BI MAILING ADD-STREET 2" S BISTRT2=1
 ....;---> Look up function by name.
 ....N Z S Z=$O(^DD("FUNC","B",X,0))
 ....Q:'Z
 ....S X=$G(^DD("FUNC",Z,1))
 ....Q:X=""
 ....X X
 ....;---> If "Street 2" is blank, pad it in case more follows on that line.
 ....I X=""&$G(BISTRT2) S X="                         "
 ...S BILINE1=BILINE1_X
 ..;
 ..;---> Reset line with functions processed.
 ..S BILINE=BILINE1
 .;
 .;---> If this is a "Street-2" line but it's entirely blank, don't print it.
 .I ($G(BISTRT2))&(BIBLNKL[BILINE) Q
 .;---> Okay, print.
 .W !,BILINE
 ;
 W:'BICRT @IOF D:(BICRT&('BIPOP)) DIRZ^BIUTL3()
 Q
 ;
CONTRAS ;EP = called from BILETPR1
 ;---> Retrieve and store Contraindications in WP ^TMP global.
 ;---> Parameters:
 ;     1 - BILINE (ret) Last line written into ^TMP array.
 ;     2 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     3 - BIGBL  (opt) ^TMP global node to write to (def="BILET").
 ;
 S:$G(BIGBL)="" BIGBL="BILET"
 N BIRETVAL,BIRETERR,I S BIRETVAL=""
 ;
 ;---> RPC to retrieve Contraindications.
 D CONTRAS^BIRPC5(.BIRETVAL,BIDFN)
 ;
 ;---> If BIRETERR has a value, display it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 I BIRETERR]"" D  Q
 .D WRITE^BILETPR1(.BILINE,"     "_BIRETERR,BIGBL)
 .D WRITE^BILETPR1(.BILINE,,BIGBL)
 ;
 ;---> Set BICONT=to a string of Contraindications for this patient.
 N BICONT S BICONT=$P(BIRETVAL,BI31,1)
 Q:BICONT=""
 ;
 ;---> Build Listmanager array from BICONT string.
 ;
 N J S J=1
 F I=1:1 S Y=$P(BICONT,U,I) Q:Y=""  D
 .;---> Build display line for this Contraindication.
 .N V S V="|",X="     "
 .S:J X=X_"* Contraindications:",J=0 S X=$$PAD^BIUTL5(X,28)
 .;
 .;---> Display "Vaccine:  Date  Reason"
 .;---> Quit if Reason is a "Refusal."  Also, if it's the first line of Contras
 .;---> reset J so that "Contraindications:" header displays on the next one.
 .I Y["Refusal" D  Q
 ..I I=1 S J=1
 .S X=X_$P(Y,V,2)_":",X=$$PAD^BIUTL5(X,40)_$P(Y,V,4)
 .S X=$$PAD^BIUTL5(X,53)_$P(Y,V,3)
 .;---> Set formatted Contraindication line and index in ^TMP.
 .D WRITE^BILETPR1(.BILINE,X,BIGBL)
 Q
 ;
