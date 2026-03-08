BIUTL3 ;IHS/CMI/MWR - UTIL: ZTSAVE, ASKDATE, DIRZ.; MAY 10, 2010 ; 09 Jun 2025  10:51 PM [ 06/12/2025  11:12 AM ]
 ;;8.5;IMMUNIZATION;**21,29,30,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: SAVE ANY AND ALL BI VARIABLES FOR QUEUEING TO TASKMAN,
 ;;  ASK DATE RANGE, DIRZ (PROMPT TO CONTINUE).
 ;;  PATCH 2: Add more variables to save: BIDELIM, BIU19.
 ;;  PATCH 5: Add more variables to save: BITOTPTS, BITOTFPT, BITOTMPT ZSAVES+77
 ;;  PATCH 21: Add "A" to DIR(0)   DIRZ+19
 ;
 ;
 ;----------
ZSAVES ;EP
 ;---> Single central calling point for saving BI local
 ;---> variables and arrays in ZTSAVE for queuing to Taskman.
 ;---> Any of the BI variables listed below, if defined,
 ;---> will be stored in the ZTSAVE array.
 ;---> To add additional variables or arrays, simply document
 ;---> in the list and add to appropriate FOR loop below.
 ;
 ;---> Variables:
 ;
 ;        ZTSAVE  (ret) Taskman array of saved variables and arrays.
 ;
 ;     Single:
 ;     -------
 ;        BIACT   (opt) All or ACTIVE Only in Patient Errors.
 ;        BIAG    (opt) Age Range in months.
 ;        BIAGRP  (opt) Node/number for this Age Group.
 ;        BIAGRPS (opt) Age Groups in Two-Year-Old Report.
 ;        BIBEGDT (opt) Begin date of report.
 ;        BICOLL  (opt) Order of Lot Number listing, 1-4.
 ;        BICPTI  (opt) 1=Include CPT Coded Visits, 0=Ignore CPT (default).
 ;        BIDAR   (opt) Adolescent Report Age Range: "11-18^1" (years).
 ;        BIDED   (opt) Include Deceased Patients (0=no, 1=yes).
 ;        BIDELIM (opt) Delimiter (1="^", 2="2 spaces").
 ;        BIDFN   (opt) Patient's IEN in VA PATIENT File #2.
 ;        BIDLOC  (opt) Date-Location Line of letter.
 ;        BIDLOT  (opt) Display report by Lot Number (VAC).
 ;        BIENDDT (opt) End date of report.
 ;        BIFDT   (opt) Forecast/Clinic date.
 ;        BIFH    (opt) F=report on Flu Vaccine Group, H=H1N1 group.
 ;        BIHIST  (opt) Include Historical (Vac Acct Report).
 ;        BIHPV   (opt) 1=include HepA, Pneumo & Var, 0=exclude.
 ;        BILET   (opt) IEN of Letter in BI LETTER File.
 ;        BIMD    (opt) Minimum Interval days since last letter.
 ;        BINFO   (opt) Additional Information for each patient (no longer used).
 ;        BIORD   (opt) Order of listing.
 ;        BIPG    (opt) Patient Group (see calling routine).
 ;        BIQDT   (opt) Quarter Ending Date.
 ;        BIRDT   (opt) Date Range for Received Imms (form BEGDATE:ENDDATE).
 ;        BIRPDT  (opt) Report Date in View List (if passed from reports).
 ;        BISITE  (opt) IEN of Site.
 ;        BISUBT  (opt) Subtitle String for Lot Order in BILOT.
 ;        BITAR   (opt) Two-Yr-Old Report Age Range.
 ;        BITOTPTS(opt) Total Number of Patients.
 ;        BITOTFPT(opt) Total Number of Female Patients.
 ;        BITOTMPT(opt) Total Number of Male Patients.
 ;        BIU19   (opt) Include Adults (19 yrs & over).
 ;        BIUP    (opt) User Population/Group (Registered, User, Active).
 ;        BIVFC   (opt) VFC Eligibility for Imm Visits.
 ;        BIYEAR  (opt) Report Year.
 ;
 ;     Arrays:
 ;     -------
 ;        BIBEN   (opt) Beneficiary Type array.
 ;        BICC    (opt) Current Community array.
 ;        BICM    (opt) Case Manager array.
 ;        BIDPRV  (opt) Designated Provider array.
 ;        BIHCF   (opt) Health Care Facility array.
 ;        BILOT   (opt) Lot Number array.
 ;        BIMMD   (opt) Immunization Due array.
 ;        BIMMR   (opt) Immunization Received array.
 ;        BIMMRF  (opt) Immunization Received Filter array.
 ;        BIMMLF  (opt) Lot Number Filter array.
 ;        BINFO   (opt) Additional Information for each patient.
 ;        BIVT    (opt) Visit Type array.
 ;
 ;---> Save local variables for queueing Due List/Letters.
 K ZTSAVE N BISV
 ;
 F BISV="ACT","AG","AGRP","AGRPS","BEGDT","COLL","CPTI","DAR","DED","DELIM","DFN" D
 .S BISV="BI"_BISV
 .I $D(@(BISV)) S ZTSAVE(BISV)=""
 ;
 F BISV="DLOC","DLOT","ENDDT","FDT","FH","HIST","HPV","LET","MD","NFO","ORD" D
 .S BISV="BI"_BISV
 .I $D(@(BISV)) S ZTSAVE(BISV)=""
 ;
 F BISV="PG","QDT","RDT","RPDT","SITE","SUBT","T","TAR","TOTPTS","TOTFPT","TOTFMPT" D
 .S BISV="BI"_BISV
 .I $D(@(BISV)) S ZTSAVE(BISV)=""
 ;
 F BISV="U19","UP","VFC","YEAR" D
 .S BISV="BI"_BISV
 .I $D(@(BISV)) S ZTSAVE(BISV)=""
 ;
 ;---> Save local arrays for queueing Due List/Letters.
 F BISV="BEN","CC","CM","DPRV","HCF","LOT","MMD","MMLF","MMR","MMRF","VT" D
 .S BISV="BI"_BISV
 .D:$D(@BISV)
 ..N N S N=0 F  S N=$O(@(BISV_"("""_N_""")")) Q:N=""  D
 ...S ZTSAVE(BISV_"("""_N_""")")=""
 Q
 ;
 ;
 ;----------
ASKDATES(BIB,BIE,BIPOP,BIBDF,BIEDF,BISAME,BITIME) ;EP
 ;---> Ask date range.
 ;---> Parameters:
 ;     1 - BIB    (ret) Begin Date, Fileman format.
 ;     2 - BIE    (ret) End Date, Fileman format.
 ;     3 - BIPOP  (ret) BIPOP=1 If quit, fail, DTOUT, DUOUT.
 ;     4 - BIBDF  (opt) Begin Date default, Fileman format.
 ;     5 - BIEDF  (opt) End Date default, Fileman format.
 ;     6 - BISAME (opt) Force End Date default=Begin Date.
 ;     7 - BITIME (opt) Ask times.
 ;
 ;---> Example:
 ;        D ASKDATES^BIUTL3(.BIBEGDT,.BIENDDT,.BIPOP,"T-365","T")
 ;
 S BIPOP=0 N %DT,Y
 W !!,"   *** Date Range Selection ***"
 ;
 ;---> Begin Date.
 S %DT="APEX"_$S($G(BITIME):"T",1:"")
 S %DT("A")="   Begin with DATE: "
 I $G(BIBDF)]"" S Y=BIBDF D DD^%DT S %DT("B")=Y
 D ^%DT K %DT
 I Y<0 S BIPOP=1 Q
 ;
 ;---> End Date.
 S (%DT(0),BIB)=Y K %DT("B")
 S %DT="APEX"_$S($D(BITIME):"T",1:"")
 S %DT("A")="   End with DATE:   "
 I $G(BIEDF)]"" S Y=BIEDF D DD^%DT S %DT("B")=Y
 I $D(BISAME) S Y=BIB D DD^%DT S %DT("B")=Y
 D ^%DT K %DT
 I Y<0 S BIPOP=1 Q
 S BIE=Y
 Q
 ;
 ;
 ;----------
DATE(BIDT,BIPOP,BIDFLT,BIPRMPT,BITIME) ;EP
 ;---> Ask Date.
 ;---> Parameters:
 ;     1 - BIDT    (ret) Selected Date, Fileman format.
 ;     2 - BIPOP   (ret) BIPOP=1 If quit, fail, DTOUT, DUOUT.
 ;     3 - BIDFLT  (opt) Default, Fileman format.
 ;     4 - BIPRMPT (opt) Prompt.
 ;     5 - BITIME  (opt) Ask times.
 ;
 ;---> EXAMPLE:
 ;        D DATE^BIUTL3(.BIDT,.BIPOP,DT)
 ;
 S BIPOP=0 N %DT,Y
 S %DT="APEX"_$S($G(BITIME):"T",1:"")
 S:$G(BIPRMPT)="" BIPRMPT="   Enter DATE: "
 S %DT("A")=BIPRMPT
 I $G(BIDFLT)]"" S Y=BIDFLT D DD^%DT S %DT("B")=Y
 D ^%DT K %DT
 I Y<0 S BIPOP=1 Q
 S BIDT=Y
 Q
 ;
 ;
 ;----------
LOCKED ;EP
 D EN^DDIOL("Another user is editing this entry.  Please, try again later.",,"!?5")
 D DIRZ()
 Q
 ;
 ;
 ;----------
DIRZ(BIPOP,BIPRMT,BIPRMT1,BIPRMT2,BIPRMTQ,BINLF) ;EP - Press RETURN to continue.
 ;---> Call to ^DIR, to Press RETURN to continue.
 ;---> Parameters:
 ;     1 - BIPOP   (ret) BIPOP=1 if DTOUT or DUOUT
 ;     2 - BIPRMT  (opt) Prompt other than "Press RETURN..."
 ;     3 - BIPRMT1 (opt) Prompt other than "Press RETURN..."
 ;     4 - BIPRMT2 (opt) Prompt other than "Press RETURN..."
 ;     5 - BIPRMTQ (opt) Response to "?" other than standard
 ;     6 - BINLF   (opt) If BINLF=1, no linefeed before prompt.
 ;
 ;---> Example: D DIRZ^BIUTL3(.BIPOP)
 ;
 N DDS,DIR,DIRUT,X,Y,Z
 D
 .I $G(BIPRMT)="" D  Q
 ..S DIR("A")="   Press ENTER/RETURN to continue or ""^"" to exit"
 .S DIR("A")=BIPRMT
 .I $G(BIPRMT1)]"" S DIR("A",1)=BIPRMT1
 .I $G(BIPRMT2)]"" S DIR("A",2)=BIPRMT2
 I $G(BIPRMTQ)]"" S DIR("?")=BIPRMTQ
 ;********** PATCH 21, v8.5, APR 01,2021, IHS/CMI/MWR
 ;---> Add "A" to DIR(0) so that nothing is added to the prompt, if supplied.
 ;---> Also add "no linefeed" option.
 W:('$G(BINLF)=1) !
 S DIR(0)="EA"
 D ^DIR W !
 S BIPOP=$S($D(DIRUT):1,Y<1:1,1:0)
 Q
 ;
 ;
 ;----------
NOW1 ;EP
 ;---> S BITTTS=Start time.
 N %,Y,X D NOW^%DTC S BITTTS=%
 Q
 ;
 ;
 ;----------
NOW2 ;EP
 ;---> S BITTTE=End time.
 N %,Y,X D NOW^%DTC S BITTTE=%
 ;
 ;---> Compare times.
 S Y=BITTTE X ^DD("DD") W !!?5,"End  : ",$P(Y,"@",2)
 S Y=BITTTS X ^DD("DD") W !?5,"Begin: ",$P(Y,"@",2)
 D DIRZ()
 K BITTTE,BITTTS
 Q
VARR ;EP;TO CREATE VACCINE CVX ARRAYS FOR IMM/DUE EVALUATION
 ;V8.5 PATCH 29 - FID-107546 Adjust Td,NOS forecast
 K VARR
 N X,Y,Z,CVX,NAM,GRP
 S X=0
 F  S X=$O(^AUTTIMM(X)) Q:'X  S Y=^(X,0) D V1
 Q
 ;=====
 ;
V1 ;EVAL EACH VACCINE
 S NAM=$P(Y,U,1,9)
 S CVX=+$P(Y,U,3)
 S GRP=+$P(Y,U,9)
 I NAM["COV" D
 .S ^BIVARR("COV",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"COV",X)=NAM
 .S:NAM["NOS" ^BIVARR("COV","NOS",CVX,GRP,X)=NAM
 I NAM["DT"!(NAM["Td") D
 .I NAM'["Td",NAM'["ADULT" D
 ..S ^BIVARR("DT",CVX,GRP,X)=NAM
 ..S ^BIVARR("GRP",GRP,CVX,"DT",X)=NAM
 ..S:NAM["NOS" ^BIVARR("DT","NOS",CVX,GRP,X)=NAM
 .I NAM["Td",NAM'["Tdap" D
 ..S ^BIVARR("TD",CVX,GRP,X)=NAM
 ..S ^BIVARR("GRP",GRP,CVX,"TD",X)=NAM
 ..S:NAM["NOS" ^BIVARR("TD","NOS",CVX,GRP,X)=NAM
 .I NAM["Tdap" D
 ..S ^BIVARR("TDAP",CVX,GRP,X)=NAM
 ..S ^BIVARR("GRP",GRP,CVX,"TDAP",X)=NAM
 ..S:NAM["NOS" ^BIVARR("TDAP","NOS",CVX,GRP,X)=NAM
 I NAM["HEP A"!(NAM["Hep A")!(NAM["HepA") D
 .S ^BIVARR("HEP A",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"HEP A",X)=NAM
 .S:NAM["NOS" ^BIVARR("HEP A","NOS",CVX,GRP,X)=NAM
 I NAM["HEP B"!(NAM["Hep B")!(NAM["HepB") D
 .S ^BIVARR("HEP B",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"HEP B",X)=NAM
 .S:NAM["NOS" ^BIVARR("HEP B","NOS",CVX,GRP,X)=NAM
 I NAM["HIB" D
 .S ^BIVARR("HIB",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"HIB",X)=NAM
 .S:NAM["NOS" ^BIVARR("HIB","NOS",CVX,GRP,X)=NAM
 I NAM["HPV" D
 .S ^BIVARR("HPV",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"HPV",X)=NAM
 .S:NAM["NOS" ^BIVARR("HPV","NOS",CVX,GRP,X)=NAM
 I NAM["INFLU"!(NAM["Influ")!(NAM["influ")!(NAM["H1N1") D
 .S ^BIVARR("INFLU",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"INFLU",X)=NAM
 .S:NAM["NOS" ^BIVARR("INFLU","NOS",CVX,GRP,X)=NAM
 I NAM["H1N1" D
 .S ^BIVARR("H1N1",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"H1N1",X)=NAM
 .S:NAM["NOS" ^BIVARR("H1N1","NOS",CVX,GRP,X)=NAM
 I NAM["IPV"!(NAM["OPV")!(NAM["POLIO") D
 .S ^BIVARR("POLIO",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"POLIO",X)=NAM
 .S:NAM["NOS" ^BIVARR("POLIO","NOS",CVX,GRP,X)=NAM
 I NAM["MEN"!(NAM["Meni") D
 .S ^BIVARR("MEN",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"MEN",X)=NAM
 .S:NAM["NOS" ^BIVARR("MEN","NOS",CVX,GRP,X)=NAM
 .D:NAM["Men-A"
 ..S ^BIVARR("MEN-A",CVX,GRP,X)=NAM
 ..S ^BIVARR("GRP",GRP,CVX,"MEN-A",X)=NAM
 ..S:NAM["NOS" ^BIVARR("MEN-A","NOS",CVX,GRP,X)=NAM
 .D:NAM["Men-B"!(NAM["Men B")!(NAM["Group B,")
 ..S ^BIVARR("MEN-B",CVX,GRP,X)=NAM
 ..S ^BIVARR("GRP",GRP,CVX,"MEN-B",X)=NAM
 ..S:NAM["NOS" ^BIVARR("MEN-B","NOS",CVX,GRP,X)=NAM
 I NAM["MM"!(NAM["VARI")!(NAM["MEAS") D
 .S ^BIVARR("MMRV",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"MMRV",X)=NAM
 .S:NAM["NOS" ^BIVARR("MMRV","NOS",CVX,GRP,X)=NAM
 I NAM["PNEU"!(NAM["Pneu") D
 .S ^BIVARR("PNEU",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"PNEU",X)=NAM
 .S:NAM["NOS" ^BIVARR("PNEU","NOS",CVX,GRP,X)=NAM
 I NAM["ROTA" D
 .S ^BIVARR("ROTA",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"ROTA",X)=NAM
 .S:NAM["NOS" ^BIVARR("ROTA","NOS",CVX,GRP,X)=NAM
 I NAM["RSV" D
 .S ^BIVARR("RSV",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"RSV",X)=NAM
 .S:NAM["NOS" ^BIVARR("RSV","NOS",CVX,GRP,X)=NAM
 I NAM["ZOS"!(NAM["Zos") D
 .S ^BIVARR("ZOS",CVX,GRP,X)=NAM
 .S ^BIVARR("GRP",GRP,CVX,"ZOS",X)=NAM
 .S:NAM["NOS" ^BIVARR("ZOS","NOS",CVX,GRP,X)=NAM
 I NAM'["COV",NAM'["DT",NAM'["Td",NAM'["HEP A",NAM'["Hep A",NAM'["HepA",NAM'["HEP B",NAM'["Hep B",NAM'["HepB",NAM'["HIB",NAM'["HPV",NAM'["INFLU",NAM'["Influ",NAM'["influ",NAM'["H1N1" D
 .I NAM'["H1N1",NAM'["IPV",NAM'["OPV",NAM'["POLIO",NAM'["MEN",NAM'["Meni",NAM'["MM",NAM'["VARI",NAM'["MEAS",NAM'["PNEU",NAM'["Pneu",NAM'["ROTA",NAM'["RSV",NAM'["ZOS",NAM'["Zos" D
 ..S ^BIVARR("IEN",X,CVX,GRP)=NAM
 Q
 Q
 ;=====
 ;
GR ;FIND PATIENT WITH GREATER THAN IMMUNIZATIONS
 K ^BITMP("GR")
 S K=0
 S QUIT=0
 ;F GR=70,60,50 Q:QUIT  D GR1
 D GR1
 D SHOW
 D PAUSE^BYIMIMM6
 Q
 ;=====
 ;
GR1 ;
 S DFN=9999999999
 F  S DFN=$O(^AUPNVIMM("AC",DFN),-1) Q:'DFN!QUIT  D
 .S (J,IDA)=0
 .F  S IDA=$O(^AUPNVIMM("AC",DFN,IDA)) Q:'IDA!QUIT  D
 ..S J=J+1
 ..Q:J<71
 ..S:'$D(^BITMP("GR",DFN)) K=K+1
 ..S ^BITMP("GR",DFN)=J
 ..S:K>19 QUIT=1
 Q
 ;=====
 ;
PCNT(DFN) ;COUNT PATIENT'S IMMUNIZATIONS
 N CNT,X
 S CNT=0
 S X=0
 F  S X=$O(^AUPNVIMM("AC",DFN,X)) Q:'X  S CNT=CNT+1
 Q CNT
 ;=====
 ;
SHOW ;SHOW PTS WITH >70 IMMUNIZATIONS
 N NAM,DFN
 W @IOF
 W !?5,"Patients with greater than 70 immunizations"
 W !?5,"-------------------------------------------"
 W !!?35,"No. of"
 W !?5,"NAME",?35,"Imms"
 W !?5,"----------------------------  -----"
 N X,Y,Z,DFN
 S DFN=0
 F  S DFN=$O(^BITMP("GR",DFN)) Q:'DFN  D
 .S NAM=$P($G(^DPT(DFN,0)),U)
 .S NAM(NAM)=DFN
 S NAM=""
 F  S NAM=$O(NAM(NAM)) Q:NAM=""  D
 .S DFN=NAM(NAM)
 .S CNT=$$PCNT(DFN)
 .W !?5,NAM,?35,CNT
 Q
 ;=====
END ;
