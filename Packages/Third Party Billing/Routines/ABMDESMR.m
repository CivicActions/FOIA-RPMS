ABMDESMR ; IHS/SD/SDR - Summarized Claim RX charges ;
 ;;2.6;IHS 3P BILLING SYSTEM;**10,13,21,22,28,29,33,37**;NOV 12, 2009;Build 739
 ;
 ;IHS/DSD/LSL - 09/02/98 - Patch 2 - NOIS NDA-0898-180038
 ;   0.00 charges on HCFA because version 2.0 does not assume 1 for units.  Modify code to set units to 1 if not already defined.
 ;
 ;IHS/SD/SDR V2.5 P8 IM10618/IM11164 Prompt/display provider
 ;IHS/SD/SDR v2.5 p8 task 57 Added code for days supply
 ;IHS/SD/SDR v2.5 p9 task 1 Use new service line provider multiple
 ;IHS/SD/SDR v2.5 p10 IM20645 NDC not printing all the time
 ;IHS/SD/SDR v2.5 p11 NPI
 ;IHS/SD/SDR v2.5 p12 IM25331 Add provider taxonomy to CMS-1500 block 24K
 ;
 ;IHS/SD/SDR 2.6*13 Added check for new export mode 35
 ;IHS/SD/SDR 2.6*21 HEAT168435 Added code for pharmacy (23 mult) modifiers to print on claims; also removed drug description,
 ;    removed dashes from NDC, and added UN and units to shaded line.
 ;IHS/SD/SDR 2.6*22 HEAT329144 Write drug description based on new parameter.  NAM prints description, UNT prints units info.  Default is NAM.
 ;IHS/SD/SDR 2.6*28 CR10648 Put CPT Narrative in array
 ;IHS/SD/SDR 2.6*29 CR10410 Added Medicare non-covered changes
 ;IHS/SD/SDR 2.6*29 CR10888 Fixed units on Charge Summary screen
 ;IHS/SD/SDR 2.6*33 ADO60186 CR12024 Added check for new option in 3P Insurer question PRINT MED NAME ON PAPER CLAIM; fixed UNT option of same
 ;  parameter to put a space, UN, and the units (instead of lots of formatting and extra zeros)
 ;IHS/SD/SDR 2.6*37 ADO89299 changed DEA that prints to stored number (not whatever is stored for provider)
 ;
MED ;EP for Medication Charges
 Q:$P($G(^AUTNINS(ABMP("INS"),2)),U,3)="U"
 Q:$P($G(^ABMNINS(DUZ(2),ABMP("INS"),1,997,0)),U,7)="N"
 I $G(ABMP("VTYP",997)),'$G(ABMPRINT) Q:ABMP("VTYP",997)'=ABMP("EXP")
 S ABMCAT=23 D PCK^ABMDESM1 Q:$G(ABMQUIT)
 S ABMX=0 F ABMS("I")=ABMS("I"):1 S ABMX=$O(@(ABMP("GL")_"23,"_ABMX_")")) Q:'ABMX  S ABMX("X")=ABMX D MED1
 Q
 ;
MED1 ;
 S ABMX(0)=@(ABMP("GL")_"23,"_ABMX("X")_",0)")
 ;S:$D(@(ABMP("GL")_"23,"_ABMX("X")_",2)")) ABMX(2)=@(ABMP("GL")_"23,"_ABMX("X")_",2)")  ;abm*2.6*21 IHS/SD/SDR HEAT168435  ;abm*2.6*28 IHS/SD/SDR CR10648
 S ABMX(2)=$G(@(ABMP("GL")_"23,"_ABMX("X")_",2)"))  ;abm*2.6*28 IHS/SD/SDR CR10648
 S ABMX(3)=$G(@(ABMP("GL")_"23,"_ABMX("X")_",3)"))  ;abm*2.6*28 IHS/SD/SDR CR10648
 S ABMZ("UNIT")=$P(ABMX(0),U,3)
 S:'+ABMZ("UNIT") ABMZ("UNIT")=1
 S ABMX("SUB")=+$FN(ABMZ("UNIT")*$P(ABMX(0),U,4),"T",2)+$P(ABMX(0),U,5)
 S ABMS("TOT")=ABMS("TOT")+ABMX("SUB")
 ;start new abm*2.6*29 IHS/SD/SDR CR10410
 S ABMCNDCK=U_$P(ABMX(2),U,3)_U_$P(ABMX(2),U,4)_U_$P(ABMX(2),U,5)
 D CNCD21CK^ABMDESM1
 ;end new abm*2.6*29 IHS/SD/SDR CR10410/1
 I $P(^ABMDEXP(ABMP("EXP"),0),U)'["UB" G MEDH
 ; ABMS(revn)=Totl Charge^units^Unit Charge^CPT Code^Drug^Rx #
MEDU ;
 S ABMX("R")=$P(ABMX(0),U,2) Q:ABMX("R")=""
 I $D(ABMS(ABMX("R"))) S $P(ABMS(ABMX("R")),U)=$P(ABMS(ABMX("R")),U)+ABMX("SUB")
 E  S ABMS(ABMX("R"))=ABMX("SUB")
 S $P(ABMS(ABMX("R")),U,2)=+$P(ABMS(ABMX("R")),U,2)+ABMZ("UNIT")  ;abm*2.6*29 IHS/SD/SDR CR10888
 Q
 ;
 ; ABMS(#)=Charge^date from^date to^CPT Code^Corr. ICD^units^typ serv^Description^RX #^Provider^Days Supply
MEDH S ABMS(ABMS("I"))=ABMX("SUB")
 S ABMCAT=23 D HDT^ABMDESM1
 ;S $P(ABMS(ABMS("I")),U,4)=$P(ABMX(0),U,29)  ;cpt  ;ABM*2.6*10
 S $P(ABMS(ABMS("I")),U,4)=$P($$CPT^ABMCVAPI($P(ABMX(0),U,29),ABMP("VDT")),U,2)  ;abm*2.6*10
 ;start new abm*2.6*21 IHS/SD/SDR HEAT168435
 S $P(ABMS(ABMS("I")),U,4)=$P(ABMS(ABMS("I")),U,4)_$S($P($G(ABMX(2)),U,3)]"":"   "_$P($G(ABMX(2)),U,3),1:"")_$S($P($G(ABMX(2)),U,4)]"":" "_$P($G(ABMX(2)),U,4),1:"")_$S($P($G(ABMX(2)),U,5)]"":" "_$P($G(ABMX(2)),U,5),1:"")
 ;end new abm*2.6*21 IHS/SD/SDR HEAT168435
 S $P(ABMS(ABMS("I")),"^",5)=$P(ABMX(0),"^",13)
 S $P(ABMS(ABMS("I")),U,6)=ABMZ("UNIT")
 S $P(ABMS(ABMS("I")),U,7)=9
 S ABMX("D")=$P(ABMX(0),U) D DRUG
 S ABMX("C")=$S($P(ABMX(0),U,24)'="":$P(ABMX(0),U,24),1:$P($G(^PSDRUG(+ABMX(0),2)),U,4))
 S $P(ABMS(ABMS("I")),U,8)=$S(ABMX("C")]"":ABMX("C")_" ",1:"")
 ;uncommented below line  ;abm*2.6*22 IHS/SD/SDR HEAT329144
 S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_$S('$P(ABMX(0),U,7)&'$P(ABMX(0),U,8):ABMX("D"),$P(ABMX(0),U,7):$P(^PS(52.6,$P(ABMX(0),U,7),0),U),1:$P(^PS(52.7,$P(ABMX(0),U,8),0),U))  ;abm*2.6*21 IHS/SD/SDR HEAT168435
 ;S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_$S('$P(ABMX(0),U,7)&'$P(ABMX(0),U,8):"",$P(ABMX(0),U,7):$P(^PS(52.6,$P(ABMX(0),U,7),0),U),1:$P(^PS(52.7,$P(ABMX(0),U,8),0),U))  ;abm*2.6*21 HEAT168435  ;abm*2.6*22 IHS/SD/SDR HEAT329144
 ;I ABMP("EXP")=27 S $P(ABMS(ABMS("I")),U,8)="N4"_$P(ABMS(ABMS("I")),U,8)  ;abm*2.6*13 export mode 35  ;abm*2.6*22 IHS/SD/SDR HEAT329144
 I ABMP("EXP")=27!(ABMP("EXP")=35) S $P(ABMS(ABMS("I")),U,8)="N4"_$P(ABMS(ABMS("I")),U,8)  ;abm*2.6*13 export mode 35  ;abm*2.6*21 IHS/SD/SDR HEAT168435  ;abm*2.6*22 IHS/SD/SDR HEAT329144
 ;start new abm*2.6*21 IHS/SD/SDR HEAT168435
 I ((ABMP("EXP")=27!(ABMP("EXP")=35))&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,21)="UNT")) D  ;abm*2.6*22 IHS/SD/SDR HEAT329144
 .;S $P(ABMS(ABMS("I")),U,8)="N4"_$TR($P($P(ABMS(ABMS("I")),U,8)," "),"-")  ;abm*2.6*13 export mode 35  ;N4 with NDC (dashes removed)  ;abm*2.6*22 IHS/SD/SDR HEAT329144
 .S $P(ABMS(ABMS("I")),U,8)=$TR($P($P(ABMS(ABMS("I")),U,8)," "),"-")  ;abm*2.6*13 export mode 35  ;N4 with NDC (dashes removed)  ;abm*2.6*22 IHS/SD/SDR HEAT329144
 .;S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_$$FMT^ABMERUTL(" ",13)_"UN"_$TR($$FMT^ABMERUTL($FN($P(ABMX(0),U,3),",",3),"11NR"),",.")  ;abm*2.6*33 IHS/SD/SDR ADO60186
 .S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_" UN"_$P(ABMX(0),U,3)  ;abm*2.6*33 IHS/SD/SDR ADO60186
 ;end new abm*2.6*21 IHS/SD/SDR HEAT168435
 I $P(ABMX(0),U,9)]"" S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_" "_$P(ABMX(0),U,9)
 ;I ABMP("EXP")'=27 S $P(ABMS(ABMS("I")),U,9)="RX#-"_$S($P(ABMX(0),U,22)'="":$P(^PSRX($P(ABMX(0),U,22),0),U),1:$P(ABMX(0),"^",6))  ;abm*2.6*13 export mode 35
 I ABMP("EXP")'=27&(ABMP("EXP")'=35) S $P(ABMS(ABMS("I")),U,9)="RX#-"_$S($P(ABMX(0),U,22)'="":$P(^PSRX($P(ABMX(0),U,22),0),U),1:$P(ABMX(0),"^",6))  ;abm*2.6*13 export mode 35
 ;
 ;start new abm*2.6*33 IHS/SD/SDR ADO60186
 I ((ABMP("EXP")=35)&($P($G(^ABMNINS(ABMP("LDFN"),ABMP("INS"),1,ABMP("VTYP"),1)),U,21)="BOTH")) D
 .S $P(ABMS(ABMS("I")),U,8)=$TR($P($P(ABMS(ABMS("I")),U,8)," "),"-")_" "  ;N4 with NDC (dashes removed)
 .S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_"UN"_$P(ABMX(0),U,3)_" "
 .S $P(ABMS(ABMS("I")),U,8)=$P(ABMS(ABMS("I")),U,8)_$S($P(ABMX(3),U,2)'="":$P(ABMX(3),U,2),1:ABMX("D"))
 ;
 S ABMDPRV=$O(@(ABMP("GL")_"23,"_ABMX_",""P"",""C"",""D"",0)"))  ;ordering provider
 I +$G(ABMDPRV)'=0 D
 .S ABMDPRV=$P($G(@(ABMP("GL")_"23,"_ABMX_",""P"","_ABMDPRV_",0)")),U)
 .S ABMA("CSUB")=$P($G(^PSDRUG(+ABMX(0),0)),U,3)  ;DEA, SPECIAL HDLG
 .;I (ABMA("CSUB")[2)!(ABMA("CSUB")[3)!(ABMA("CSUB")[4)!(ABMA("CSUB")[5) S $P(ABMS(ABMS("I")),U,13)=$P($G(^VA(200,ABMDPRV,"PS")),U,2)  ;abm*2.6*37 IHS/SD/SDR ADO89299
 .I (ABMA("CSUB")[2)!(ABMA("CSUB")[3)!(ABMA("CSUB")[4)!(ABMA("CSUB")[5) S $P(ABMS(ABMS("I")),U,13)=$P(ABMX(2),U,6)  ;abm*2.6*37 IHS/SD/SDR ADO89299
 ;end new abm*2.6*33 IHS/SD/SDR ADO60186
 ;
 S ABMX(0)=@(ABMP("GL")_"23,"_ABMX("X")_",0)")
 S ABMDPRV=$O(@(ABMP("GL")_"23,"_ABMX_",""P"",""C"",""R"",0)"))
 S:+ABMDPRV'=0 ABMDPRV=$P($G(@(ABMP("GL")_"23,"_ABMX_",""P"","_ABMDPRV_",0)")),U)
 I $G(ABMDPRV)="" S ABMDPRV=$$GETPRV^ABMDFUTL
 I +$G(ABMDPRV)'=0 D
 .Q:'$$K24^ABMDFUTL
 .;I ABMP("EXP")'=27 S $P(ABMS(ABMS("I")),U,9)=$P($G(ABMS(ABMS("I"))),U,9)_";;"_$$K24N^ABMDFUTL(ABMDPRV)  ;abm*2.6*13 export mode 35
 .I ABMP("EXP")'=27&(ABMP("EXP")'=35) S $P(ABMS(ABMS("I")),U,9)=$P($G(ABMS(ABMS("I"))),U,9)_";;"_$$K24N^ABMDFUTL(ABMDPRV)  ;abm*2.6*13 export mode 35
 .E  S $P(ABMS(ABMS("I")),U,9)=$$K24N^ABMDFUTL(ABMDPRV)
 .S $P(ABMS(ABMS("I")),U,11)=$P($$NPI^XUSNPI("Individual_ID",ABMDPRV),U)
 .I $G(ABMP("NPIS"))="N" S $P(ABMS(ABMS("I")),U,9)=$$PTAX^ABMEEPRV(ABMDPRV)
 I "^35^"[("^"_ABMP("EXP")_"^") S $P(ABMS(ABMS("I")),U,12)=$P(ABMX(3),U,2)  ;abm*2.6*28 IHS/SD/SDR CR10648
 Q
 ;
DRUG I ABMX("D")]"" S ABMX("D")=$P($G(^PSDRUG(ABMX("D"),0)),U)
 Q
RX I ABMX("C")]"" S ABMX("C")=$P($G(^PSRX(ABMX("C"),0)),U)
 Q
