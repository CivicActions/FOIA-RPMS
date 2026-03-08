BARBL1 ; IHS/SD/LSL - AGE DAY LETTER AND LIST PART 2 ; 07/30/2008
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**39**;OCT 26, 2005;Build 231
 ;IHS/SD/SDR 1.8*39 ADO109260 Added delimited option if 'bill detail' selected
 ;************************************
DELIMPRT ;** deque for print
 W !!,"Hold on please, the file is writing..."
 D OPEN^%ZISH("BARF",BARPATH,BARFNM,"W")
 U IO
 S BARPG("HDR")="Over "_BARAGE_" days"
 D BARHDR
 ;start new bar*1.8*39 IHS/SD/SDR ADO 109260
 I '$D(^TMP("BAR",$J)) D  Q
 .W !!,"THERE IS NO DATA TO PRINT",!
 .D CLOSE^%ZISH("BARF")
 ;end new bar*1.8*39 IHS/SD/SDR ADO109260
 S BARACDA=0
 F  S BARACDA=$O(^TMP("BAR",$J,"BLAGE",BARACDA)) Q:BARACDA'>0  S BARTOT=^(BARACDA) Q:$G(BARQUIT)  D
 .K BARA
 .D ENP^XBDIQ1(90050.02,BARACDA,".01;1:1.99","BARA(","N")
 .I BARSUM="D" D LIST
 D CLOSE^%ZISH("BARF")
 Q
 ;
LIST ;** list bills
 NEW BARTMP1,BARTMP2,BARSSN
 S BARBLDA=0,BARSVAL=0
 F  S BARSVAL=$O(^TMP("BAR",$J,"BLAGE",BARACDA,BARSVAL)) Q:BARSVAL=""  D
 .F  S BARBLDA=$O(^TMP("BAR",$J,"BLAGE",BARACDA,BARSVAL,BARBLDA)) Q:BARBLDA'>0  Q:$G(BARQUIT)  D
 ..K BARB
 ..D ENP^XBDIQ1(90050.01,BARBLDA,".01;101;102;108;13;15;7.2;701;702","BARB(","I")
 ..S BARPIEN=$P(^BARBL(DUZ(2),BARBLDA,1),U)  ;PDFN
 ..S BARDOB=$$GET1^DIQ(2,BARPIEN,".03","E")  ;patient DOB
 ..S BARSSN=$P($G(^DPT(BARPIEN,0)),U,9)  ;patient SSN
 ..W !
 ..W $G(BARB(108))_U  ;visit location
 ..I $G(BARA(.01))'="" D
 ...W $G(BARA(1.08))_U  ;VP insurer type
 ...W $G(BARA(.01),"UNKNOWN")_U  ;A/R account
 ...W $G(BARA(1.01))_U  ;VP address
 ...W $G(BARA(1.04))_U  ;VP city
 ...W $G(BARA(1.05))_U  ;VP state
 ...W $G(BARA(1.06))_U  ;VP zip
 ...W $G(BARA(1.07))_U  ;VP phone
 ..I $G(BARA(.01))="" D
 ...W U_"UNKNOWN"_U_U_U_U_U_U  ;if no insurer type, account, address, city, state, zip, phone
 ..W BARB(701)_U  ;policy holder
 ..W BARB(702)_U  ;policy#
 ..W BARB(101)_U  ;patient
 ..W BARSSN_U  ;SSN
 ..W BARDOB_U  ;DOB
 ..W BARB(.01)_U  ;A/R Bill#
 ..W $$FMDT(BARB(102,"I"))_U  ;DOS
 ..W $J(BARB(13),10,2)_U  ;Amount Billed
 ..W $J(BARB(15),10,2)_U  ;Balance
 Q
 ;**********************************************
FMDT(X) ;
 ; cvt fmdt to mm/dd/yyyy
 S X=$$SDT^BARDUTL(X)
 Q X
 ;**********************************************
BARHDR ;EP
 ; write page header
 W "WARNING: Confidential Patient Information, Privacy Act Applies"
 W !,"Age Day Letter Bill Detail Report"
 W !,BARPG("HDR")
 W "  "_$$SDT^BARDUTL(DT)
 ;
BARHD ;EP
 ; Write column header / message
 W !
 W "Visit Location^Insurer Type^A/R Account^A/R Account Address^A/R Account City^A/R Account State^A/R Account Zip^A/R Account Phone^Policy Holder^Policy #^Patient^PT. SS #^DOB^Claim #^DOS^Amt Bld^Balance^Comments"
 Q
 ;**********************************************
 ;
EBARPG ;
 K BARPG("LINE"),BARPG("PG"),BARPG("HDR"),BARPG("DT")
 Q
 ;**********************************************
EXIT ;clean up and quit
 K DIC,BARSAC,BARSBY,BARA,BARB,BARPG,BARAC,BARACDA,BARAGE,BARBLDS
 K BARCNT,BARFDA,BARJOB,BARL,BARLT,BARQUIT,BARSVAL,BARSVC,BART,BARTOT
 W $$EN^BARVDF("IOF")
 Q
 ;EOR
