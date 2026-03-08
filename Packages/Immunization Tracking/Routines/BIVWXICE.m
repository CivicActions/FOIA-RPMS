BIVWXICE ;IHS/CMI/MWR - CALL TO ICE FORECASTER; JUL 01, 2019 [ 06/30/2025  3:01 PM ] ; 27 Aug 2025  11:17 PM
 ;;8.5;IMMUNIZATION;**24,26,29,30,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CALL TO ICE FORCASTING IMMUNIZATIONS.
 ;;  Called from ^BIPATUP.
 ;;  PATCH 24: Update BIDFN.  run+56
 ;;  PATCH 26: Set Supp Text Forecast
 ;;  PATCH 31: RZV vacc evaluation
 ;;
 ;----------
RUN(BIDFN,BIFDT,BIDUZ2,BINF,BICT,BIFORC,BIPROF,BINORP,BIERR) ;EP
 ;---> Entry point to call ICE Forecaster.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN (DFN)
 ;     2 - BIFDT  (opt) Forecast Date.
 ;     3 - BIDUZ2 (opt) User's DUZ(2) for site parameters.
 ;     4 - BINF   (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     5 - BICT   (opt) Array of patient's contraindications BICT(CVX)
 ;     6 - BIFORC (ret) String containing Patient's Imms Due.
 ;     7 - BIPROF (ret) String containing text of Patient's Imm Report.
 ;     8 - BINORP (opt) 1=Do not produce Report/Profile.
 ;     9 - BIERR  (ret) String containing text of the error.
 ;
 ;---> Returned: Vaccine Group Code^Earliest Date^Recommended Date^Overdue Date
 ;
 I '$G(BIDFN) D ERRCD^BIUTL2(301,.BIERR) Q
 I '$D(^DPT(BIDFN,0)) D ERRCD^BIUTL2(301,.BIERR) Q
 S:('$G(BIFDT)) BIFDT=DT
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 ;
 ;---> Check for precise Date of Birth.
 N X S X=$$DOB^BIUTL1(BIDFN)
 I ('$E(X,1,3))!('$E(X,4,5))!('$E(X,6,7)) D ERRCD^BIUTL2(215,.BIERR) Q
 ;
 ;---> Call to the ICE forecaster.
 ;
 N DIQUIET
 N BIEXEC,BIF,BIFF,BIH,BIPARMS,BIXMLV
 ;---> From VA: ; MSC/DKA Make background jobs quiet, foreground verbose
 S BIEXEC="S:'($D(DIQUIET)#10) DIQUIET='($ZJ#2)" X BIEXEC
 S BIPARMS("format")="simple"
 S BIPARMS("patientId")=BIDFN
 ;
 ;---> Check that BI Site Parameters for ICE are set.
 N X,Y,Z S X=$G(^BISITE(BIDUZ2,3))
 S Y=0 F Z=1:1:5 I $P(X,U,Z)="" S Y=1
 I Y D ERRCD^BIUTL2(126,.BIERR) Q
 ;
 ;---> Set local url parameters.
 S BIPARMS("url")=$P(X,U)_"://"_$P(X,U,2)_":"_$P(X,U,3)_"/"_$P(X,U,4)_"/"_$P(X,U,5)
 S BIPARMS("ip")=$P(X,U,2)
 S BIPARMS("port")=$P(X,U,5)
 ;
 N WRK,C0IEVAL
 ;---> Create the VMR to be passed to ICE.
 D EN^BIVWVMR(.WRK,BIDFN,.BIPARMS,.C0IEVAL)
 N ICEIN
 S ICEIN=$NA(^TMP("BI_C0IWRK",$J))
 K @ICEIN
 M @ICEIN=WRK
 ;--------------->  LOOK AT THE ABOVE ARRAY & GLOBAL. NECESSARY???
 ;
 ;---> If BITEST, write the ICE Output XML to a host file.
 I $G(BITEST)=1 D
 .N BID,OK,IOT
 .S BID=$$FMDTOUTC^BIVWUTIL($$NOW^XLFDT)
 .;
 .;********** PATCH 23, v8.5, OCT 24,2011, IHS/CMI/MWR
 .S OK=$$GTF^%ZISH($NA(^TMP("BI_C0IWRK",$J,1)),3,$$DEFDIR^%ZISH,BID_"ice-test"_BIDFN_".xml")
 ;
 S BIPARMS("payload")=ICEIN
 ;
 ;---> BIERRN=BIERR Number in BI TABLE ERROR CODE File.
 ;---> Actual call to ICE Forecaster:
 N BIERRN
 D SOAP^BIVWSOAP(BIFDT,.RETURN,.BIPARMS,,.BIH,.BIF,.BIXMLV,.BIERRN)
 I $G(BIERRN) D ERRCD^BIUTL2(BIERRN,.BIERR) Q
 ;
 D FORECAST(BIDFN,BIFDT,BIDUZ2,.BICT,.BIF,.BIFORC,.BIFF,.BIH)
 ;W !!,BIFORC,! R ZZZ
 ;
 Q:$G(BINORP)
 ;
 D REPORT^BIPATUP2(BIDFN,BIFDT,BIDUZ2,.BINF,.BICT,.BIH,.BIFF,BIXMLV,.BIPROF)
 ;W !!,BIPROF,! R ZZZ
 ;
 Q
 ;
 ;
FORECAST(BIDFN,BIFDT,BIDUZ2,BICT,BIF,BIFORC,BIFF,BIH) ;EP
 ;---> Format forecast data to match TCH.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN (DFN)
 ;     2 - BIFDT  (req) Forecast Date (date used for forecast).
 ;     3 - BIDUZ2 (req) User's DUZ(2) indicating site parameters.
 ;     4 - BICT   (opt) Array of patient's contraindications BICT(CVX)
 ;     5 - BIF    (req) Patient Imm Forecast array from ICE.
 ;     6 - BIFORC (ret) String containing Patient's Imms Due in TCH format.
 ;     7 - BIFF   (ret) Patient Imm Forecast collated by Volume Group BIFF(VG,CVX).
 ;     8 - BIH    (req) Patient Imm History Evaluation from ICE.
 ;
 ;---> Get BIAGE in YRS, MTH, DYS
 N BIAGE,BIYRS,BIMTH,BIDYS
 S BIAGE=$$AGE^BIUTL1(BIDFN,3,BIFDT)
 S BIYRS=+BIAGE
 S BIMTH=$P(BIAGE,U,2)
 S BIDYS=$P(BIAGE,U,3)
 ;
 ;---> First reprocess Forecast to provide CVX and Volume Group, by VG Order.
 N I S I=0
 F  S I=$O(BIF(I)) Q:'I  D
 .N BICVX,BIVG,BIVGO,Y
 .S Y=BIF(I)
 .;---> Set 1st piece=CVX (use VMR Volume Group if necessary).
 .S BICVX=$S($P(Y,U,2):$P(Y,U),1:$$VMRVG^BIUTL2($P(Y,U)))
 .;
 .;---> Get Volume Group Order.
 .S BIVG=$$HL7TX^BIUTL2(BICVX,1),BIVGO=$$VGROUP^BIUTL2(BIVG,4)
 .;V8.5 P31 - FID-98855 quit if RZV complete/not due         
 .I BIVGO=87,BIYRS>18,BIYRS<50,$$RZVCOMP^BIPATUP4(BIDFN) Q
 .S BIFF(BIVGO,BICVX)=BICVX_U_$P(BIF(I),U,3,7)
 .;20230209 76219 p26 maw added for supplemental text
 .I $G(BIF(I,"SUPP"))]"" D
 .. S BIFF(BIVGO,BICVX,"SUPP")=$G(BIF(I,"SUPP"))
 .;20230209 end of mods
 .;
 .;
 .;---> Put 6-wk doses in "RECOMMENDED^DUE_NOW" group. At 2 mths ICE can takeover.
 .;---> Duplicated at DDUE2+17^BIPATUP1.
 .I (BIDYS>41)&(BIDYS<66) D
 ..N G
 ..S G=$$HL7TX^BIUTL2(BICVX,1)
 ..Q:((G'=1)&(G'=2)&(G'=3)&(G'=11)&(G'=15))
 ..S $P(BIFF(BIVGO,BICVX),U,5,6)="RECOMMENDED^DUE_NOW"
 .;
 .;********** PATCH 20, v8.5, NOV 01,2020, IHS/CMI/MWR
 .;---> Fix so that 5th DTaP is not changed to DUE NOW.
 .;---> Put 4th DTaP at 12mths in "RECOMMENDED^DUE_NOW" group.
 .;---> Duplicated at DDUE2+37^BIPATUP1.
 .;I BICVX=107,(BIDYS>364) D
 .;V8.5 PATCH 29 - FID-
 .I BICVX=107,BIDYS>364 D
 ..N C,N,Z
 ..S (C,N,Z)=0
 ..F  S N=$O(BIH(N)) Q:'N  D
 ...N P S P=0
 ...F  S P=$O(BIH(N,P)) Q:'P  D
 ....N Y S Y=$G(BIH(N,P))
 ....N I,M S M=+$P(Y,U)
 ....;F I=1,20,22,28,50,102,106,107,110,120,130,132,146,170,195,198 I M=I D  Q
 ....D:$D(^BIVARR("DT-PEDS",M))
 .....;---> If any DTaP dose is Invalid, STOP--do not intervene (Z=1), too complex.
 .....I $P(Y,U,3)'="VALID" S Z=1 Q
 .....S C=C+1
 ..;W !,C R ZZZ
 ..;---> Quit if already received 4 valid doses.
 ..Q:(C=4)
 ..;---> If this is the 4th dose, and no previous dose was Invalid, and Min is not
 ..;---> after the forecast date, then force Due Now.
 ..I Z=0,C=3,($P(BIFF(BIVGO,BICVX),U,2)'>(BIFDT+17000000)) D
 ...S $P(BIFF(BIVGO,BICVX),U,5,6)="RECOMMENDED^DUE_NOW"
 .;
 .;V8.5 P31 - FID-98855 set RZV due now if pt immune comp and no RZV
 .;
 .;**********
 .;
 .;---> If this CVX is contraindicated, set the 7th pc=1.
 .I $D(BICT(BICVX)) S $P(BIFF(BIVGO,BICVX),U,7)=1
 ;
 ;ZW BIFF R ZZZ
 ;---> Now build TCH/ICE total forecast string.
 ;
 S $P(BIFORC,"^",9)=$$NAME^BIUTL1(BIDFN,0)_" Chart #"_$$HRCN^BIUTL1(BIDFN)_"^"_BIDFN
 S BIFORC=BIFORC_"~~~~~~"
 ;
 N I S I=""
 F  S I=$O(BIFF(I)) Q:(I="")  D
 .N J S J=0
 .F  S J=$O(BIFF(I,J)) Q:'J  D
 ..N BICODE,BITYPE,BIDATR,BIDATO,BIDATM,BISTATUS,BIREASON,BIDOSE,BIOVRD,Y
 ..S Y=BIFF(I,J)
 ..;W !,Y R ZZZ
 ..Q:($P(Y,U,5)="NOT_RECOMMENDED")
 ..Q:($P(Y,U,5)="CONDITIONAL")
 ..;---> Quit if contraindicated.
 ..Q:$P(Y,U,7)
 ..;
 ..;---> Start with CVX, concat dates below.
 ..S BIDOSE=($P(Y,U))
 ..;
 ..;---> Get Min, Rec, and Overdue Dates.
 ..S BIDATM=$P(Y,U,2),BIDATR=$P(Y,U,3),BIDATO=$P(Y,U,4)
 ..;
 ..;
 ..;********** PATCH 20, v8.5, NOV 01,2020, IHS/CMI/MWR
 ..;---> For iCare: If Overdue date is null, ignore it.
 ..;---> If Overdue is before the Forecast Date, set Overdue indicator=1.
 ..;S BIOVRD=$S($$TCHFMDT^BIUTL5(BIDATO)<BIFDT:1,1:0)
 ..S BIOVRD=0 I BIDATO,$$TCHFMDT^BIUTL5(BIDATO)<BIFDT S BIOVRD=1
 ..;**********
 ..;
 ..S BIDOSE=BIDOSE_U_U_BIOVRD_U_BIDATM_U_BIDATR_U_BIDATO
 ..S BIFORC=BIFORC_BIDOSE_"|||"
 ;
 ;W !,"DONE WITH FORECAST." R ZZZ
 Q
 ;
 ; updated, returns entire conversation
POST1(RESULTS,SERVER,PORT,PAGE,DATA) ;
 Q $$ENTRY1(.RESULTS,SERVER,$G(PORT),$G(PAGE),"POST",$G(DATA))
 ;
ENTRY1(RESULTS,SERVER,PORT,PAGE,HTTPTYPE,DATA) ;
 N DONE,XVALUE,XWBICNT,XWBRBUF,XWBSBUF,XWBTDEV,I,TO
 N XWBDEBUG,XWBOS,XWBT,XWBTIME,POP,RESLTCNT,LINEBUF,OVERFLOW
 N $ESTACK,$ETRAP S $ETRAP="D TRAP^XUSBSE2"
 K RESULTS
 ;********** PATCH 19, v8.5, JUN 01,2020, IHS/CMI/MWR
 ;---> To avoid undef below at ENTRY1+32.
 S LINEBUF=""
 ;
 S PAGE=$G(PAGE,"/") I PAGE="" S PAGE="/"
 S HTTPTYPE=$G(HTTPTYPE,"GET")
 S DATA=$G(DATA),PORT=$G(PORT,80)
 D SAVDEV^%ZISUTL("XUSBSE") ;S IO(0)=$P
 D INIT^XWBTCPM
 S TO=$P($G(^BISITE(DUZ(2),15)),"^",5) S:TO="" TO=2
 D OPEN(SERVER,PORT,TO)
 I POP Q "DIDN'T OPEN CONNECTION"
 S XWBSBUF=""
 U XWBTDEV
 D WRITE^XWBRW(HTTPTYPE_" "_PAGE_" HTTP/1.0"_$C(13,10))
 I HTTPTYPE="POST" D
 . D WRITE^XWBRW("Referer: http://"_$$KSP^XUPARAM("WHERE")_$C(13,10))
 . D WRITE^XWBRW("Content-Type: application/x-www-form-urlencoded"_$C(13,10))
 . D WRITE^XWBRW("Cache-Control: no-cache"_$C(13,10))
 . D WRITE^XWBRW("Content-Length: "_$L(DATA)_$C(13,10,13,10))
 . D WRITE^XWBRW(DATA)
 D WRITE^XWBRW($C(13,10))
 D WBF^XWBRW
 S XWBRBUF="",DONE=0,XWBICNT=0
 S OVERFLOW=""
 S XVALUE=$$DREAD^XUSBSE2($C(13,10)) I $G(RESULTS(1))'[200 S XVALUE=$P($G(RESULTS(1))," ",2,5)
 D CLOSE ;I IO="|TCP|80" U IO D ^%ZISC
 I LINEBUF'="" S RESLTCNT=RESLTCNT+1,RESULTS(RESLTCNT)=LINEBUF
 I $G(RESULTS(1))[200 F I=1:1 I RESULTS(I)="" S XVALUE=$G(RESULTS(I+1)) Q
 Q XVALUE
 ;
CLOSE ;
 N TMPD
 D CLOSE^%ZISTCP
 S TMPD=$$FINDEV^%ZISUTL("XUSBSE")
 I TMPD'="" D GETDEV^%ZISUTL(TMPD) I $L(IO),'$D(^%ZISL(3.54,"B",IO)) U IO  Q
 Q
 ;
OPEN(P1,P2,P3) ;Open the device and set the variables
 D CALL^%ZISTCP(P1,P2,P3) Q:POP
 S XWBTDEV=IO
 Q
RZV(BIDFN) ;CHECK FOR RZV VACCS
 N X,Y,Z,I0,D,CVX
 S BIFLU=""
 S X=0
 F  S X=$O(^AUPNVIMM("AC",BIDFN,X)) Q:'X  S I0=$G(^AUPNVIMM(X,0)) D:I0
 .S Y=+I0
 .S V=+$P(I0,U,3)
 .Q:'Y!'V
 .S D=$P($P($G(^AUPNVSIT(V,0)),U),".")
 .S CVX=+$P($G(^AUTTIMM(Y,0)),U,3)
 .Q:'CVX!'D
 .S:$D(^BIVARR("ZOS",CVX)) BIFLU(CVX,9999999-D)=""
 Q
 ;=====
 ;
