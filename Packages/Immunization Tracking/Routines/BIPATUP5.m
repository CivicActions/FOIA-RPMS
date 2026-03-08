BIPATUP5 ;IHS/CMI/MWR - UPDATE PATIENT DATA 2; OCT 15, 2010
 ;;8.5;IMMUNIZATION;**26,29,30**;OCT 24,2011;Build 125
 Q
 ;
HSUPP ;EP;-- historical supplemental text
 N S1,S2,S3,S4
 D BRKSPS^BIUTL12(BIHSUP,.S1,.S2,.S3,.S4)
 ;---> Now add line to the report.
 S BILN=BILN+1,BIRP(BILN)="Supplemental Text:"
 S BILN=BILN+1,BIRP(BILN)="------------------"
 S BILN=BILN+1,BIRP(BILN)=S1
 ;---> If reason was too long, write subsequent lines.
 I S2]"" S BILN=BILN+1,BIRP(BILN)=S2
 I S3]"" S BILN=BILN+1,BIRP(BILN)=S3
 I S4]"" S BILN=BILN+1,BIRP(BILN)=S4
 Q
 ;
FSUPP ;EP;-- forecast supplemental text
 N BIFSUP,BISTXT
 S BIFSUP=$G(BIFF(I,J,"SUPP"))
 N S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12
 D BRKSPS^BIUTL12(BIFSUP,.S1,.S2,.S3,.S4,.S5,.S6,.S7,.S8,.S9,.S10,.S11,.S12)
 S BILN=BILN+1,BIRP(BILN)=""
 S BILN=BILN+1,BIRP(BILN)="Supplemental Text:"
 S BILN=BILN+1,BIRP(BILN)="------------------"
 N II
 F II=1:1:12 D  Q:$G(BISTXT)=""
 . S BISTXT="S"_II
 . S BISTXT=@BISTXT
 . Q:BISTXT=""
 . S BILN=BILN+1,BIRP(BILN)=BISTXT
 S BILN=BILN+1,BIRP(BILN)=""
 Q
 ;
FSUPPN ;EP;-- forecast supplemental text
 N BISTXT,BIPSUPV,BILN
 S BILN=0
 N C,I
 S C=0,I=""
 F  S I=$O(BIFSUP(I)) Q:(I="")  D
 .N J
 .S J=0
 .F  S J=$O(BIFSUP(I,J)) Q:'J  D
 ..I $G(BIFSUP(I,J,"SUPP"))]"" D   ;FSUPP^BIPATUP5
 ...S BIFSUPV=$G(BIFSUP(I,J,"SUPP"))
 ...N S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12
 ...D BRKSPS^BIUTL12(BIFSUPV,.S1,.S2,.S3,.S4,.S5,.S6,.S7,.S8,.S9,.S10,.S11,.S12)
 ...S BILN=BILN+1,BIRP(BILN)=""
 ...S BILN=BILN+1,BIRP(BILN)="Supplemental Text:"
 ...S BILN=BILN+1,BIRP(BILN)="------------------"
 ...N II
 ...F II=1:1:12 D  Q:$G(BISTXT)=""
 .... S BISTXT="S"_II
 .... S BISTXT=@BISTXT
 .... Q:BISTXT=""
 .... S BILN=BILN+1,BIRP(BILN)=BISTXT
 S BILN=BILN+1,BIRP(BILN)=""
 N K
 S K=0
 F  S K=$O(BIRP(K)) Q:'K  D
 .S BIPROF=BIPROF_BIRP(K)_"|||"
 Q
 ;
VACLINE(Y,BIFDT,BIDUZ2,BITDEVL,BITDNXT,BINF,Z,C,BI,BJ) ;EP
 ;---> Format Vaccine due line.
 ;---> Parameters:
 ;     1 - Y       (req) Vaccine due data line (CVX, 3 Dates, status...)
 ;     2 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     3 - BIDUZ2  (req) User's DUZ(2) indicating site parameters.
 ;     4 - BITDEVL (req) Tdap evaluation
 ;     5 - BITDNXT (req) Tdap next due early, recommend, overdue
 ;     6 - BINF    (opt) Array of Vaccine Grp IEN'S not forecasted.
 ;     7 - Z       (ret) Formated report line.
 ;     8 - C       (ret) Count (flag for more than "None.")
 ;     9 - BI      (opt) Vaccine Group subscript in BIFF array
 ;    10 - BJ      (opt) CVX subscript in BIFF array
 ;                       (to reset Due now to Due in Future).
 ;
 N BICVX,BIDTDUE
 S BIFDTICE=BIFDT+17000000 ;FORECAST DATE IN YYYYMMDD/HL7 FORMAT
 S BICVX=$P(Y,U)     ;CVX CODE
 S BIDTDUE=$P(Y,U,2) ;DATE EARLIEST
 S BIDTRDT=$P(Y,U,3) ;DATE RECOMMEND
 S BIDTPDT=$P(Y,U,4) ;DATE PAST DUE
 S BIDTREC=$P(Y,U,5) ;RECOMMENDATION
 S BIDTWHN=$P(Y,U,6) ;DESCRIPTION WHEN DUE
 S BICON=$P(Y,U,7)   ;CONTRAINDICATION
 S BIVG=$$HL7TX^BIUTL2(BICVX,1)
 S BIVGO=$$VGROUP^BIUTL2(BIVG,4)
 ;I BIVGO=8,$G(BITDNXT(10)) S BICVX=139
 S Z=" | "_$$PAD^BIUTL5($$HL7TX^BIUTL2(BICVX,2),13),C=1
 ;
 ;---> * * * Contraindications, display and quit. * * *
 I BICON D  Q
 .S Z=Z_"* Contraindicated due to patient history."
 ;
 ;---> Do not forecast MMR or Varicella if Patient is 19 yrs or older.
 I $D(^BIVARR("MMRV",BICVX)),BINMV D  Q
 .S Z=Z_"* Series assumed completed."
 ;
 ;---> * * * Volume Group Turned Off * * *
 ;---> See if Site specified to not forecast this Vaccine Group
 I $D(BINF($$HL7TX^BIUTL2(BICVX,1))) D  Q
 .S Z=Z_"* Forecasting for this Vaccine Group is turned off."
 ;
 ;---> * * * Td/Tdap Filter * * *
 ;---> Do not forecast Td-Adult <10 yrs to complete childhood series.
 I BINMV,$D(^BIVARR("GRP",1,BICVX))!$D(^BIVARR("GRP",8,BICVX)) D  Q
 .;---> Get date next Td is due.
 .S:BITDNXT(10)>BIDTDUE BIDTDUE=BITDNXT(10)
 .I 'BITDLST,'BIDTDUE S BIDTDUE=DT+17000000
 .;---> If it's due, quit here and process normal line.
 .N J
 .F J=5,10,27 I '$G(BITDNXT(J)) S BITDNXT(J)=BIDTDUE
 .I BIDTDUE<BIFDTICE D
 ..N J
 ..F J=2 S ($P(Y,U,J),$P(BIFF(BI,BJ),U,J))=BITDNXT(5)
 ..F J=3 S ($P(Y,U,J),$P(BIFF(BI,BJ),U,J))=BIDTDUE
 ..F J=4 S ($P(Y,U,J),$P(BIFF(BI,BJ),U,J))=BITDNXT(27)
 .;--> Due in Future. If in Due Now loop, move to Due in Future loop.
 .I $P(Y,U,5)="RECOMMENDED",BIDTDUE>(BIFDTICE-1) D  Q
 ..N J
 ..F J=2 S ($P(Y,U,J),$P(BIFF(BI,BJ),U,J))=BITDNXT(5)
 ..F J=3 S ($P(Y,U,J),$P(BIFF(BI,BJ),U,J))=BIDTDUE
 ..F J=4 S ($P(Y,U,J),$P(BIFF(BI,BJ),U,J))=BITDNXT(27)
 ..S ($P(Y,U,5),$P(BIFF(BI,BJ),U,5))="FUTURE_RECOMMENDED"
 ..S ($P(Y,U,6),$P(BIFF(BI,BJ),U,6))="DUE_IN_FUTURE"
 ..S Z=""
 .I $P(Y,U,5)="FUTURE_RECOMMENDED",BIDTDUE>$P(Y,U,2) D
 ..N J
 ..F J=2 S ($P(Y,U,J),$P(BIFF(BI,BJ),U,J))=BITDNXT(5)
 ..F J=3 S ($P(Y,U,J),$P(BIFF(BI,BJ),U,J))=BIDTDUE
 ..F J=4 S ($P(Y,U,J),$P(BIFF(BI,BJ),U,J))=BITDNXT(27)
 .N BIST
 .S BIST=$P(Y,U,6)
 .S:BITDEVL]"" BIST=BITDEVL
 .S BIST=$S(BIST[" assumed":BIST,BIST="DUE_NOW":"Due now         ",BIST="DUE_IN_FUTURE":"Due in future   ",1:BIST)
 .S Z=Z_BIST
 .S:Z'[" assumed" Z=Z_$$DF^BIPATUP2($P(Y,U,2))_"   "_$$DF^BIPATUP2($P(Y,U,3))_"    "_$$DF^BIPATUP2($P(Y,U,4))
 .I Z[" assumed" D
 ..S Z=Z_$S($P(Y,U,3)<(DT+17000000):"NOW",1:$$DF^BIPATUP2($P(Y,U,3)))
 ;
 ;---> * * * Flu Season Date Range * * *
 I (BICVX=88)!$D(^BIVARR("INFLU",BICVX)),($$OUTFLU^BIPATUP3(BIFDT,BIDUZ2)) D  Q
 .S Z=Z_"* Due, but not within site parameter Flu Season Dates."
 ;
 ;---> Status and Dates.
 N BIST
 S BIST=$P(Y,U,6)
 S BIST=$S(BIST="DUE_NOW":"Due now         ",BIST="DUE_IN_FUTURE":"Due in future   ",1:BIST)
 S Z=Z_BIST_$$DF^BIPATUP2(BIDTDUE)_"   "_$$DF^BIPATUP2(BIDTRDT)_"    "_$$DF^BIPATUP2(BIDTPDT)
 Q
 ;=====
 ;
