BIREPD4 ;IHS/CMI/MWR - REPORT, ADOLESCENT RATES; AUG 10,2010
 ;;8.5;IMMUNIZATION;**17,26,29,30**;OCT 24,2011;Build 125
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW ADOLESCENT IMMUNIZATION RATES REPORT, WRITE HEADERS, ETC.
 ;;  PATCH 1: Fix to count only one Flu dose per season; do not affect
 ;;           other Vaccine Groups.  CHECKSET+158
 ;;  PATCH 3: Include new "1-Td 1-Men 3-HPV" lines. CHKSET+215
 ;;  PATCH 17: Extensive changes to enhance Adol HPV & Tdap Reporting. GETPATS+31
 ;
 ;
 ;----------
GETPATS(BIBEGDT,BIENDDT,BICC,BIHCF,BICM,BIBEN,BIQDT,BIAGRPS,BISITE,BIUP,BITMP) ;EP
 ;---> Get patients from VA PATIENT File, ^DPT(.
 ;---> Parameters:
 ;     1 - BIBEGDT (req) Begin DOB for this group.
 ;     2 - BIENDDT (req) End DOB for this group.
 ;     3 - BICC    (req) Current Community array.
 ;     4 - BIHCF   (req) Health Care Facility array.
 ;     5 - BICM    (req) Case Manager array.
 ;     6 - BIBEN   (req) Beneficiary Type array.
 ;     7 - BIQDT   (req) Quarter Ending Date.
 ;     8 - BIAGRPS (req) String of Age Groups ("1112,1313,1317").
 ;     9 - BISITE  (req) Site IEN.
 ;    10 - BIUP    (req) User Population/Group (All, Imm, User, Active).
 ;    11 - BITMP   (ret) Stores Patient Totals by Age Group and Sex.
 ;
 ;---> Set begin and end dates for search through PATIENT File.
 ;
 Q:'$G(BIBEGDT)  Q:'$G(BIENDDT)  Q:'$G(BIQDT)  Q:'$G(BIAGRPS)
 ;
 ;---> Start 1 day prior to Begin Date and $O into the desired DOB's.
 N BIDOB S BIDOB=BIBEGDT-1
 F  S BIDOB=$O(^DPT("ADOB",BIDOB)) Q:(BIDOB>BIENDDT!('BIDOB))  D
 .S BIDFN=0
 .F  S BIDFN=$O(^DPT("ADOB",BIDOB,BIDFN)) Q:'BIDFN  D
 ..D CHKSET(BIDFN,.BICC,.BIHCF,.BICM,.BIBEN,BIDOB,BIQDT,.BIVAL,BIAGRPS,BIUP,.BITMP)
 ..;---> Set ^TMP("BIDUL",$J,CURCOM,1,HRCN,BIDFN)=$G(BIVAL) for Patient Roster.
 ..D:$G(BIVAL) STORE^BIDUR1(BIDFN,DT,9,,BIVAL,BISITE)
 ;
 ;
 ;===> Now tally HPV Fully Vac'd Totals.
 ;
 ;********** PATCH 17, v8.5, MAR 01,2019, IHS/CMI/MWR
 ;---> New code to combine tallies below.
 ;---> Simple dose totals for F+M Combined.
 D
 .N N F N=1,2,3 D
 ..S BITMP("STATS",17,N,"1112S")=+$G(BITMP("STATS",17,N,"1112F"))+$G(BITMP("STATS",17,N,"1112M"))
 ..S BITMP("STATS",17,N,"1313S")=+$G(BITMP("STATS",17,N,"1313F"))+$G(BITMP("STATS",17,N,"1313M"))
 ..S BITMP("STATS",17,N,"1317S")=+$G(BITMP("STATS",17,N,"1317F"))+$G(BITMP("STATS",17,N,"1317M"))
 ;
 ;;---> 2 + 3-Dose Female and Male Fully Vac'd totals
 D
 .N N F N="F","M" D
 ..S BITMP("STATS",17,5,1112_N_5)=+$G(BITMP("STATS",17,2,1112_N_2))+$G(BITMP("STATS",17,3,1112_N_3))
 ..S BITMP("STATS",17,5,1317_N_5)=+$G(BITMP("STATS",17,2,1317_N_2))+$G(BITMP("STATS",17,3,1317_N_3))
 ..S BITMP("STATS",17,5,1313_N_5)=+$G(BITMP("STATS",17,2,1313_N_2))+$G(BITMP("STATS",17,3,1313_N_3))
 ;
 D
 .N N F N=2,3,5 D
 ..S BITMP("STATS",17,N,"1112B"_N)=+$G(BITMP("STATS",17,N,"1112F"_N))+$G(BITMP("STATS",17,N,"1112M"_N))
 ..S BITMP("STATS",17,N,"1317B"_N)=+$G(BITMP("STATS",17,N,"1317F"_N))+$G(BITMP("STATS",17,N,"1317M"_N))
 ..S BITMP("STATS",17,N,"1313B"_N)=+$G(BITMP("STATS",17,N,"1313F"_N))+$G(BITMP("STATS",17,N,"1313M"_N))
 ;
 ;X ^O
 Q
 ;
 ;
 ;----------
CHKSET(BIDFN,BICC,BIHCF,BICM,BIBEN,BIDOB,BIQDT,BIVAL,BIAGRPS,BIUP,BITMP) ;EP
 ;---> Check if this patient fits criteria; if so, set DFN
 ;---> in ^TMP("BIREPD1".
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BICC    (req) Current Community array.
 ;     3 - BIHCF   (req) Health Care Facility array.
 ;     4 - BICM    (req) Case Manager array.
 ;     5 - BIBEN   (req) Beneficiary Type array.
 ;     6 - BIDOB   (req) Patient's Date of Birth.
 ;     7 - BIQDT   (req) Quarter Ending Date.
 ;     8 - BIVAL   (ret) 1=Not appropriate/complete, 2=1321 complete.
 ;     9 - BIAGRPS (req) String of Age Groups ("1112,1313,1317").
 ;    10 - BIUP    (req) User Population/Group (All, Imm, User, Active).
 ;    11 - BITMP   (ret) Stores Patient Totals by Age Group and Sex.
 ;
 Q:'$G(BIDFN)
 Q:'$D(BICC)
 Q:'$D(BIHCF)
 Q:'$D(BICM)
 Q:'$D(BIBEN)
 I '$G(BIDOB) S BIDOB=$$DOB^BIUTL1(BIDFN)
 Q:'$G(BIQDT)
 Q:'$G(BIAGRPS)
 Q:$G(BIUP)=""
 ;
 ;---> Don't include this patient in Roster unless set below.
 S BIVAL=0
 ;
 ;---> Filter for standard Patient Population parameter.
 Q:'$$PPFILTR^BIREP(BIDFN,.BIHCF,BIQDT,BIUP)
 ;
 ;---> Quit if Current Community doesn't match.
 Q:$$CURCOM^BIEXPRT2(BIDFN,.BICC)
 ;
 ;---> Quit if Case Manager doesn't match.
 Q:$$CMGR^BIDUR(BIDFN,.BICM)
 ;
 ;---> Quit if Beneficiary Type doesn't match.
 Q:$$BENT^BIDUR1(BIDFN,.BIBEN)
 ;
 ;---> Get patient gender.
 N BISEX S BISEX=$$SEX^BIUTL1(BIDFN)
 Q:((BISEX'="F")&(BISEX'="M"))
 ;
 ;---> Get patient age in years on report date.
 ;V8.5 PATCH 29 - FID-107546 Tdap age check
 N BIAGE
 S BIAGE=+$$AGE^BIUTL1(BIDFN,1,BIQDT)
 Q:'BIAGE  Q:(BIAGE<11)  Q:(BIAGE>18)
 ;
 ;---> Set patient's Age Group for this report; either 1112 or 1317.
 N BIAGRP S BIAGRP=$S(BIAGE<13:1112,1:1317)
 ;
 ;---> Store Patient in appropriate totals.
 ;---> Total patients.
 N Z S Z=$G(BITMP("STATS","TOTLPTS")) S BITMP("STATS","TOTLPTS")=Z+1
 ;---> Total patients in Age Group.
 S Z=$G(BITMP("STATS","TOTLPTS",BIAGRP)) S BITMP("STATS","TOTLPTS",BIAGRP)=Z+1
 ;----> * NOTE! Here's an example where I build column for 13-yr-olds!
 ;---> Duplicate tracking of 13-yr-olds.
 D:BIAGE=13
 .S Z=$G(BITMP("STATS","TOTLPTS",1313)) S BITMP("STATS","TOTLPTS",1313)=Z+1
 ;
 ;
 ;---> Set node for female or male denominators.
 N BISXNOD S BISXNOD=$S(BISEX="F":"TOTLFPTS",1:"TOTLMPTS")
 ;---> Total Female patients.
 S Z=$G(BITMP("STATS",BISXNOD)) S BITMP("STATS",BISXNOD)=Z+1
 ;---> Total female patients in Age Group.
 S Z=$G(BITMP("STATS",BISXNOD,BIAGRP)) S BITMP("STATS",BISXNOD,BIAGRP)=Z+1
 ;---> Duplicate tracking of 13-yr-olds.
 D:BIAGE=13
 .S Z=$G(BITMP("STATS",BISXNOD,1313)) S BITMP("STATS",BISXNOD,1313)=Z+1
 ;
 ;
 ;---> Store for Patient Report Roster (not yet determined if complete 1321).
 S BIVAL=1
 ;
 ;---> RPC to gather Immunization History.
 N BI31,BIDE,BIRETVAL,BIRETERR,I S BI31=$C(31)_$C(31),BIRETVAL=""
 ;---> 30=Vaccine IEN, 55=Vaccine Group IEN, 56=Date of Visit(Fileman).
 F I=30,55,56 S BIDE(I)=""
 ;
 ;---> Fourth parameter=0: Do not return Skin Tests.
 ;---> Fifth parameter=0: Means the components of a combination vaccine will
 ;---> be split out.
 D IMMHX^BIRPC(.BIRETVAL,BIDFN,.BIDE,0,0)
 ;
 ;---> If BIRETERR has a value, store it and quit.
 S BIRETERR=$P(BIRETVAL,BI31,2)
 Q:BIRETERR]""
 ;
 ;---> Add refusals, if any.
 N Z D REFUSAL^BIUTL13(BIDFN,.Z,1) I $O(Z(0)) S BITMP("REFUSALS",BIDFN)="" K Z
 ;
 ;
 ;---> Check for Hx of Chicken Pox (as a reason for contra to Var & MMRV.
 ;---> If HX of Chicken Pox to add to Varicella Stats Line and to 1:3:2:1 line.
 N BIHXX,Z
 D CONTRA^BIUTL11(BIDFN,.Z,2) I ($G(Z(21))=12)!($G(Z(94))=12) D
 .S Z=$G(BITMP("STATS",132,1,BIAGRP)) S BITMP("STATS",132,1,BIAGRP)=Z+1
 .;---> Duplicate tracking of 13-yr-olds.
 .I BIAGE=13 S Z=$G(BITMP("STATS",132,1,1313)) S BITMP("STATS",132,1,1313)=Z+1
 .;---> Also set for 1:3:2:1 line.
 .S BIHXX(132,1,BIAGRP)=""
 ;
 ;********** PATCH 17, v8.5, MAR 01,2019, IHS/CMI/MWR
 ;---> Begin changes to break out 2-dose and 3-dose HPV.
 ;---> BIHPV1=Date of first HPV.
 ;---> BIHPV23 tracks whether 2 doses or 3 are needed to be HPV Fully Vac'd.
 ;---> Default is 3 doses (if 2-dose criteria not met, 3 doses needed).
 ;---> BIHPVFV=flag for HPV Fully Vac'd.
 N BIHPV1,BIHPV23,BIHPVFV
 S BIHPV23=3,BIHPVFV=0
 ;
 ;---> Set BIHX=to a valid Immunization History.
 N BIHX S BIHX=$P(BIRETVAL,BI31,1)
 ;
 ;
 ;---> * * * Add this Patient's History to stats. * * *
 N I,Y
 ;---> Loop through "^"-pieces of Imm History, getting data.
 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;---> Age (A), Dose# (D), Visit Date (J), scratch variable (Q),
 .;---> Vaccine Group IEN (V), Vaccine IEN (W).
 .N A,D,J,Q,V,W
 .S W=$P(Y,"|",2),V=$P(Y,"|",3),J=$P(Y,"|",4)
 .;
 .;---> Select for Vaccine Group IEN's:
 .;---> 4-HEPB, 6-MMR, 7-VAR, 8-Td_B, 9-HEPA, 10-FLU, 16-MEN, 17-HPV
 .Q:'$G(V)
 .D
 ..Q:V=4  Q:V=6  Q:V=7  Q:V=8  Q:V=9  Q:V=10  Q:V=16  Q:V=17  S V=0
 .Q:('V)
 .;
 .;---> Only count Tdap CVX 221, no other Tetanus.
 .Q:((V=8)&(W'=221))
 .;
 .;
 .;---> Quit if this is a Men-B vaccine (not MenACWY).
 .Q:W=266  Q:W=267  Q:W=268
 .;
 .;---> Exclude immunization visits after the Quarter Ending Date, BIQDT.
 .Q:(J>BIQDT)
 .;
 .;---> Quit if V=FLU and Date of Visit is more than 1 year before Report Date.
 .Q:((V=10)&($$FMDIFF^XLFDT(BIQDT,J,1)>365))
 .;**********
 .;
 .;---> Quit if one Flu dose has already been recorded (only want one Flu
 .;---> dose per patient per season).
 .Q:((V=10)&($D(BIHX(10))))
 .;
 .;---> Build local array for setting combinations stats below.
 .;
 .;---> Set Dose# (increment by 1's to assign highest/latest dose#)
 .S D=1,Q=0
 .F  Q:Q  D
 ..I $D(BIHX(V,D)) S D=D+1 Q
 ..S BIHX(V,D)="",Q=1
 .;
 .;---> For Flu count every dose as a "dose #1". Might want to go to dose #2. MWRZZZ
 .I V=10 S D=1
 .;
 .;---> Set each immunization in the STATS array by Vaccine Group (V),
 .;---> Dose (D), and Age Group (BIAGRP).
 .;
 .;
 .;--> Start  *HPV*  *HPV*  *HPV*
 .;
 .;---> If this is HPV, separate female and male by appending sex to age group.
 .I V=17 D  Q
 ..;---> Don't count more than 3 doses.
 ..Q:(D>3)
 ..;---> If this dose was given too early (<9 yrs), kill it and quit.
 ..I (J-BIDOB)<90000 K BIHX(V,D) Q
 ..;
 ..N Z S Z=$G(BITMP("STATS",V,D,BIAGRP_BISEX)) S BITMP("STATS",V,D,BIAGRP_BISEX)=Z+1
 ..S BIHX(V,D,BIAGRP)=""
 ..;---> Duplicate tracking of 13-yr-olds.
 ..D:BIAGE=13
 ...S Z=$G(BITMP("STATS",V,D,1313_BISEX)) S BITMP("STATS",V,D,1313_BISEX)=Z+1
 ..;
 ..;********** PATCH 17, v8.5, MAR 01,2019, IHS/CMI/MWR
 ..;---> Break out 2-dose and 3-dose HPV.
 ..D
 ...;---> If dose #1 is less than 15 yrs, possibly only 2 doses needed to fully vaccinate.
 ...I D=1 N X1,X2 S (X1,BIHPV1)=J,X2=BIDOB D ^%DTC S BIHPV23=$S(X<5478:2,1:3) Q
 ...;---> If first 2 doses are less than 5 months apart, 3 doses needed.
 ...I D=2 N X1,X2 S X1=J,X2=BIHPV1 D ^%DTC S:(X<150) BIHPV23=3 Q
 ..;
 ..;---> If dose 2, and 2 needed; or if dose 3, and 3 needed, set Fully Vac'd node.
 ..I ((D=2)&(BIHPV23=2))!((D=3)&(BIHPV23=3)) D  Q
 ...;
 ...N Z S Z=$G(BITMP("STATS",V,D,BIAGRP_BISEX_BIHPV23))
 ...S BITMP("STATS",V,D,BIAGRP_BISEX_BIHPV23)=Z+1
 ...;---> Duplicate tracking of 13-yr-olds.
 ...D:BIAGE=13
 ....S Z=$G(BITMP("STATS",V,D,1313_BISEX_BIHPV23))
 ....S BITMP("STATS",V,D,1313_BISEX_BIHPV23)=Z+1
 ...;---> Save Fully Vac'd for Composite measures.
 ...S BIHPVFV=1
 ..;
 .;--> End  *HPV*  *HPV*  *HPV*
 .;
 .;---> Okay, not HPV (don't append sex).
 .N Z S Z=$G(BITMP("STATS",V,D,BIAGRP)) S BITMP("STATS",V,D,BIAGRP)=Z+1
 .S BIHX(V,D,BIAGRP)=""
 .;---> Duplicate tracking of 13-yr-olds.
 .D:BIAGE=13
 ..S Z=$G(BITMP("STATS",V,D,1313)) S BITMP("STATS",V,D,1313)=Z+1
 .;
 .;
 .;---> If this is Td and the vaccine was Tdap, add a Tdap line.
 .;---> Substitute Vaccine IEN 221 for Vaccine Group.
 .Q:(W'=221)  Q:$D(BIHX(221))
 .S Z=$G(BITMP("STATS",221,1,BIAGRP)) S BITMP("STATS",221,1,BIAGRP)=Z+1
 .;---> Duplicate tracking of 13-yr-olds.
 .D:BIAGE=13
 ..S Z=$G(BITMP("STATS",221,1,1313)) S BITMP("STATS",221,1,1313)=Z+1
 .;---> Flag to ensure only 1 dose is counted per patient.
 .S BIHX(221)=""
 ;
 ;---> Now calculate vaccine combination stats.
 ;---> NOTE: DO NOT GENERALIZE CODE BELOW (highly iterative).
 ;---> Relies on the following Vaccine Group IEN's in ^BISERT:
 ;---> 4-HEPB, 6-MMR, 7-VAR, 8-Td_B, 9-HEPA, 16-MEN, 17-HPV
 ;
 N K
 ;
 ;---> 1-Td_B, 3-HEPB, 2-MMR, 1-VAR
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(8,1,A))
 .Q:'$D(BIHX(4,3,A))
 .Q:'$D(BIHX(6,2,A))
 .;---> Either 1-VAR or Hx of Chicken Pox will count as "1:3:2:1 Current."
 .Q:(('$D(BIHX(7,1,A)))&('$D(BIHXX(132,1,A))))
 .D COMBO("8|1^4|3^6|2^7|1",A,.BITMP,BIAGE)
 .;---> Store for Patient Report Roster (complete 1321).
 .;S BIVAL=2
 ;
 ;---> 1-Td_B, 3-HEPB, 2-MMR, 1-MEN, 2-VAR
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(8,1,A))
 .Q:'$D(BIHX(4,3,A))
 .Q:'$D(BIHX(6,2,A))
 .Q:'$D(BIHX(16,1,A))
 .;********** PATCH 17, v8.5, MAR 01,2019, IHS/CMI/MWR
 .;---> Either 2-VAR or Hx of Chicken Pox will count as "1:3:2:1:2 Current."
 .;Q:'$D(BIHX(7,2,A))
 .Q:(('$D(BIHX(7,2,A)))&('$D(BIHXX(132,1,A))))
 .D COMBO("8|1^4|3^6|2^16|1^7|2",A,.BITMP,BIAGE)
 .;---> Store for Patient Report Roster (complete 13212).
 .;S BIVAL=2
 ;
 ;W !,BIDFN R ZZZ X ^O
 ;
 ;---> 1-Td_B, 1-MEN
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(8,1,A))
 .Q:'$D(BIHX(16,1,A))
 .D COMBO("8|1^16|1",A,.BITMP,BIAGE)
 .;---> Store for Patient Report Roster (complete 11).
 ;
 ;********** PATCH 3, v8.5, SEP 10,2012, IHS/CMI/MWR
 ;---> Include new "1-Td 1-Men 3-HPV" lines, combined as well as sex specific.
 ;---> 1-Td_B, 1-MEN, 3-HPV (because HPV include BISEX).
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(8,1,A))
 .Q:'$D(BIHX(16,1,A))
 .;---> Use HPV Fully Vac'd (could be 2-dose or 3-dose).
 .;Q:'$D(BIHX(17,3,A))
 .Q:'$G(BIHPVFV)
 .;---> Store both combined and sex specific lines.
 .D COMBO("8|1^16|1^17|3",A,.BITMP,BIAGE)
 .D COMBO("8|1^16|1^17|3",A_BISEX,.BITMP,BIAGE,BISEX)
 .;---> Store for Patient Report Roster (complete 113).
 .S BIVAL=2
 ;**********
 ;
 ;
 ;---> 1-Td_B, 3-HEPB, 2-MMR, 1-MEN, 2-VAR, 3-HPV (because HPV include BISEX).
 F K=1:1 S A=$P(BIAGRPS,",",K) Q:'A  D
 .Q:'$D(BIHX(8,1,A))
 .Q:'$D(BIHX(4,3,A))
 .Q:'$D(BIHX(6,2,A))
 .Q:'$D(BIHX(16,1,A))
 .;
 .;********** PATCH 17, v8.5, MAR 01,2019, IHS/CMI/MWR
 .;---> Either 2-VAR or Hx of Chicken Pox will count as Current.
 .;Q:'$D(BIHX(7,2,A))
 .Q:(('$D(BIHX(7,2,A)))&('$D(BIHXX(132,1,A))))
 .;---> Use HPV Fully Vac'd (could be 2-dose or 3-dose).
 .;Q:'$D(BIHX(17,3,A))
 .Q:'$G(BIHPVFV)
 .D COMBO("8|1^4|3^6|2^16|1^7|2^17|3",A_BISEX,.BITMP,BIAGE,BISEX)
 ;
 Q
 ;
 ;
 ;----------
COMBO(BICOMB,BIAGRP,BITMP,BIAGE,BISEX) ;EP
 ;---> Store Patient vaccine combination for Age Group.
 ;---> Parameters:
 ;     1 - BICOMB (req) Combination number.
 ;     2 - BIAGRP (req) Node/number for this Age Group.
 ;     3 - BITMP  (ret) Stores Patient Totals by Age Group and Sex.
 ;     4 - BIAGE  (opt) Age of patient (if 13, duplicate stats).
 ;     5 - BISEX  (opt) F or M for HPV.
 ;
 ;---> Store Patient in Age Group.
 N Z S Z=$G(BITMP("STATS",BICOMB,BIAGRP))
 S BITMP("STATS",BICOMB,BIAGRP)=Z+1
 ;---> Duplicate tracking of 13-yr-olds.
 D:BIAGE=13
 .;---> If this is the HPV combo, include BISEX.
 .I ((BIAGRP["F")!(BIAGRP["M")) D  Q
 ..S Z=$G(BITMP("STATS",BICOMB,1313_BISEX)) S BITMP("STATS",BICOMB,1313_BISEX)=Z+1
 .;
 .S Z=$G(BITMP("STATS",BICOMB,1313)) S BITMP("STATS",BICOMB,1313)=Z+1
 ;
 Q
