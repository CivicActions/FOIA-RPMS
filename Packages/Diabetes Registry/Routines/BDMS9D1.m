BDMS9D1 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ; 31 Oct 2022  2:02 PM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,4,8,9,15,16,17,18,19**;JUN 14, 2007;Build 159
 ;
 ;
EP ;EP - called from component
 Q:'$G(BDMSPAT)
 I $$PLTAX^BDMSMU(BDMSPAT,"SURVEILLANCE DIABETES") Q  ;has diabetes
 S X=$$LASTITEM^BDMSMU(BDMSPAT,"[SURVEILLANCE DIABETES","DX")
 I X>$$FMADD^XLFDT(DT,-366) Q  ;if date of last dm dx is w/in past year then quit
 I $E(IOST)="C",IO=IO(0) W !! S DIR("A")="PREDIABETES CARE SUMMARY WILL NOW BE DISPLAYED (^ TO EXIT, RETURN TO CONTINUE)",DIR(0)="E" D ^DIR I $D(DIRUT) S BDMSQIT=1 Q
 D EP2(BDMSPAT)
W ;write out array
 W:$D(IOF) @IOF
 K BDMQUIT
 S BDMX=0 F  S BDMX=$O(^TMP("APCHS",$J,"DCS",BDMX)) Q:BDMX'=+BDMX!($D(BDMQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(BDMQUIT)
 .W !,^TMP("APCHS",$J,"DCS",BDMX)
 .Q
 I $D(BDMQUIT) S BDMSQIT=1
 D EOJ
 Q
 ;
EOJ ;
 K BDMX,BDMQUIT,BDMY,BDMSDFN,BDMSBEG,BDMSTOB,BDMSUPI,BDMSED,BDMTOBN,BDMTOB,BDMSTEX
 K N,%,T,F,X,Y,B,C,E,F,H,L,N,P,T,W
 Q
HEADER ;
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BDMQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 W !,BDMSHDR,!
 W !,"Prediabetes Patient Care Summary - continued"
 W !,"Patient: ",$P(^DPT(BDMSPAT,0),U),"  HRN: ",$$HRN^AUPNPAT(BDMSPAT,DUZ(2)),!
 Q
EP2(BDMSDFN) ;PEP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("APCHS",$J,"DCS"
 K ^TMP("APCHS",$J,"DCS")
 S ^TMP("APCHS",$J,"DCS",0)=0
 ;I '$D(BDMSCVD) S BDMSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 D EN^XBNEW("EP21^BDMS9D1","BDMSDFN")
 Q
EP21 ;
 S BDMSPAT=BDMSDFN
 D SETARRAY
 K ^XTMP("BDMTAX",BDMJOB,BDMBTH)
 Q
SETARRAY ;set up array containing dm care summary
 ;CHECK TO SEE IF START1^APCLDF EXISTS
 S BDMJOB=$J,BDMBTH=$H
 I '$D(BDMSCVD) S BDMSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 S X="APCLDF" X ^%ZOSF("TEST") I '$T Q
 S X="PREDIABETES PATIENT CARE SUMMARY                 Report Date:  "_$$FMTE^XLFDT(DT) D S(X)
 S X="Patient: "_$$GETPREF^AUPNSOGI(BDMSDFN,"E",1),$E(X,68)="HRN: "_$$HRN^AUPNPAT(BDMSDFN,DUZ(2)) D S(X,1)
 I $$DOD^AUPNPAT(BDMSDFN)]"" S X="DATE OF DEATH: "_$$DATE^BDMS9B1($$DOD^AUPNPAT(BDMSDFN)) D S(X,1),S(" ")
 S X="Age:  "_$$AGE^BDMAPIU(BDMSDFN,1,DT)_" (DOB "_$$DATE^BDMS9B1($$DOB^AUPNPAT(BDMSDFN))_")",$E(X,40)="Sex: "_$$VAL^XBDIQ1(2,BDMSDFN,.02) D S(X)
 S X="CLASS/BEN: "_$$VAL^XBDIQ1(9000001,BDMSDFN,1111),$E(X,40)="Designated PCP: "_$E($$DPCP^BDMS9B1(BDMSDFN),1,25) D S(X)
 S (BDMIGT,BDMIFG,BDMPREDM)=""
 S X="Diagnosis" D S(X,1)
 S X=" Problem List (Date of Diagnosis)" D S(X)
 S X="" S (Y,BDMIFG)=$$IFG(BDMSDFN) I $P(Y,U)=1 S $E(X,3)="Impaired Fasting Glucose " S $E(X,30)=$S($P(Y,U,2):"("_$$FMTE^XLFDT($P(Y,U,2))_")",1:"(Date of Onset not recorded)") D S(X)
 S X="" S (Y,BDMIGT)=$$IGT(BDMSDFN) I $P(Y,U)=1 S $E(X,3)="Impaired Glucose Tolerance " S:$P(Y,U)=1 $E(X,30)=$S($P(Y,U,2):"("_$$FMTE^XLFDT($P(Y,U,2))_")",1:"(Date of Onset not recorded)") D S(X)
 S X="" S (Y,BDMPREDM)=$$PREDM(BDMSDFN) I $P(Y,U)=1 S $E(X,3)="Prediabetes " S:$P(Y,U)=1 $E(X,30)=$S($P(Y,U,2):"("_$$FMTE^XLFDT($P(Y,U,2))_")",1:"(Date of Onset not recorded)") D S(X)
 S X=" Diagnosis first recorded in PCC (Used as POV):" D S(X,1)
 S X="" I $P(BDMIFG,U,3) S X="  Impaired Fasting Glucose",$E(X,32)=$$FMTE^XLFDT($P(BDMIFG,U,3)) D S(X)
 S X="" I $P(BDMIGT,U,3) S X="  Impaired Glucose Tolerance",$E(X,32)=$$FMTE^XLFDT($P(BDMIGT,U,3)) D S(X)
 S X="" I $P(BDMPREDM,U,3) S X="  Prediabetes",$E(X,32)=$$FMTE^XLFDT($P(BDMPREDM,U,3)) D S(X)
 ;patch 18 add if DM is a diagnosis
 S BDMDMDX=""
 S BDMDMDX=$$LASTITEM^BDMSMU(BDMSDFN,"[SURVEILLANCE DIABETES","DX")
 I BDMDMDX S X="",X="PLEASE NOTE: Diabetes has been used as a diagnosis in PCC: "_$$FMTE^XLFDT(BDMDMDX) D S(X,1)
 I $$PLTAX^BDMSMU(BDMSDFN,"SURVEILLANCE DIABETES",,,"I") S X="",X="PLEASE NOTE:  Diabetes is listed as an active problem on the problem list." D S(X)
 D GETHWB^BDMS9B1(BDMSDFN)
 S X="BMI: "_BDMX("BMI"),$E(X,12)="Last Height:  "_$$STRIP^XLFSTR($J(BDMX("HT"),5,2)," ")_$S(BDMX("HT")]"":" inches",1:""),$E(X,43)=BDMX("HTD") D S(X,1)
 S X="",$E(X,12)="Last Weight:  "_$S(BDMX("WT")]"":BDMX("WT")\1,1:"")_$S(BDMX("WT")]"":" lbs",1:""),$E(X,43)=BDMX("WTD") D S(X)
 ;tobacco
 S BDMTOBC="",BDMTOBS=$$TOBACCO^BDMDL1S(BDMSDFN,$$DOB^AUPNPAT(BDMSDFN),DT)
 D S("Tobacco Use:",1)
 S X="   Last Screened: "_$$DATE^BDMS9B1($P(BDMTOBS,U,3)) D S(X)
 S X="   Current Status: "_$P($P($G(BDMTOBS),U,2),"  ",2,99) D S(X)
 ;COUNSELED?
 S X="",$E(X,7)="Tobacco cessation counseling/education received in the past year: " D
 .I $E(BDMTOBS),$E(BDMTOBS)'=1 S X=X_"N/A" D S(X) Q
 .S Y=$$CESS^BDMDL11(BDMSDFN,$$FMADD^XLFDT(DT,-365),DT)
 .I $E(Y)=1 D S(X) D S("         "_$P(Y,"  ",2,999)) Q
 .I $E(Y)=2 S X=X_"No" D S(X) Q
 ;HTN/BP
 S X="HTN Diagnosed ever:  "_$P($$HTNDX^BDMDL13(BDMSDFN,DT),"  ",2) D S(X,1)
 ;
 S B=$$BP(BDMSDFN)
 S X="Last 3 BP:      "_$P($G(BDMX(1)),U,2),$E(X,26)=$$DATE^BDMS9B1($P($G(BDMX(1)),U)) D S(X)
 S X="(non ER)" I $D(BDMX(2)) S $E(X,17)=$P(BDMX(2),U,2),$E(X,26)=$$DATE^BDMS9B1($P(BDMX(2),U)) D S(X)
 S X="" I $D(BDMX(3)) S X="",$E(X,17)=$P(BDMX(3),U,2),$E(X,26)=$$DATE^BDMS9B1($P(BDMX(3),U)) D S(X)
 ;
 ;STATIN
 S Y=$$STATIN^BDMDL16(BDMSDFN,$$FMADD^XLFDT(DT,-(6*31)),DT)
 S X="Statin prescribed (in past 6 months):"
 I $E(Y)=2 S $E(X,40)=$P(Y,"  ",2,99) D S(X,1)
 I $E(Y)=1 D S(X) S X="   "_$P(Y,"  ",2,99) D S(X,1)
 I $E(Y)=3 D S(X) S X="   Statin Note: "_$P(Y,"  ",2,99) D S(X,1)
 ;LAB
L ;
 S X="Laboratory Results (most recent):",$E(X,55)="RPMS LAB TEST NAME" D S(X,1)
 S X=" A1C:" S Y=$$HBA1C^BDMS9B2(BDMSDFN),$E(X,28)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 I $P(Y,"|||",4)]"" S X="   Note: "_$P(Y,"|||",4) D S(X)
 S X=" Next most recent A1C:" S Y=$$NLHGB^BDMS9B2(BDMSDFN),$E(X,28)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S X=" Last Fasting Glucose:" S Y=$$FGLUCOSE(BDMSDFN),$E(X,28)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S X=" Last 75 GM 2 hour Glucose:" S Y=$$GM75(BDMSDFN),$E(X,28)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S Y=$$ACRATIO^BDMS9B2(BDMSDFN)
 S X=" Quantitative UACR:",$E(X,28)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S X=" Total Cholesterol:" S Y=$$TCHOL^BDMS9B2(BDMSDFN),$E(X,28)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X,1)
 S X=" LDL Cholesterol:" S Y=$$CHOL^BDMS9B2(BDMSDFN),$E(X,28)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S X=" HDL Cholesterol:" S Y=$$HDL^BDMS9B2(BDMSDFN),$E(X,28)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S X=" Triglycerides:" S Y=$$TRIG^BDMS9B2(BDMSDFN),$E(X,28)=$P(Y,"|||"),$E(X,44)=$$DATE^BDMS9B1($P(Y,"|||",2)),$E(X,55)=$P(Y,"|||",3) D S(X)
 S Z=0
EDUCD D S(" ")
 S BDMSBEG=$$FMADD^XLFDT(DT,-365)
 S X="Education Provided (in past yr): " D S(X)
 S X="  Last Dietitian Visit (ever):  "_$$DIETV^BDMS9B3(BDMSDFN) D S(X)
 S X=""
 K BDMX
 D EDUC^BDMS9B2
 I $D(BDMX) D
 .S %="" F  S %=$O(BDMX(%)) Q:%=""  D S("   "_BDMX(%))
 K BDMX,BDMY,%
 D EDUCREF^BDMS9B2 I $D(BDMX) S X="In the past year, the patient has refused the following Diabetes education:" D S(X) D
 .S %="" F  S %=$O(BDMX(%)) Q:%=""  S X="  "_%_"     "_BDMX(%) D S(X)
 K BDMR,BDMY,%
 S X=$P(^DPT(BDMSDFN,0),U),$E(X,35)="DOB: "_$$DOB^AUPNPAT(BDMSDFN,"S"),$E(X,55)="Chart #"_$$HRN^AUPNPAT(BDMSDFN,DUZ(2),2) D S(X,1)
 Q
S(Y,F,C,T) ;set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP("APCHS",$J,"DCS",0),U)+1,$P(^TMP("APCHS",$J,"DCS",0),U)=%
 S ^TMP("APCHS",$J,"DCS",%)=X
 Q
CMSMAN(P,F) ;EP - return CASE MANAGER in register
 I $G(F)="" S F="E"
 I '$G(P) Q ""
 NEW R,N,D,D1,Y,X,G S R=0,N="",D="" F  S N=$O(^ACM(41.1,"B",N)) Q:N=""!(D]"")  S R=0 F  S R=$O(^ACM(41.1,"B",N,R)) Q:R'=+R!(D]"")  I N["PREDIAB" D
 .S (G,X)=0,(D,Y)="" F  S X=$O(^ACM(41,"C",P,X)) Q:X'=+X!(D]"")  I $P(^ACM(41,X,0),U,4)=R D
 ..S D=$P($G(^ACM(41,X,"DT")),U,6) I D]"" S D=$P(^VA(200,D,0),U)
 Q $G(D)
 ;
IGT(P,EDATE) ;
 ;return doo from problem list^first dx pcc
 I '$G(EDATE) S EDATE=DT
 NEW X,Y,I,BDMY,%,R,T,G
 K R
 S T=$O(^ATXAX("B","DM AUDIT IGT DXS",0))
 S G=""
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNPROB(X,0))  ;bad xref
 .Q:$P(^AUPNPROB(X,0),U,12)="D"  ;deleted
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)  ;not a dx we want
 .S D=$P(^AUPNPROB(X,0),U,13)
 .I D Q:D>EDATE
 .S R(9999999-D)=X
 ;now get earliest or ""
 I '$D(R) G IGTPCC
 S G=1
 S %=$O(R(0))
 S %=9999999-%
 S:'% %=""
 S $P(G,U,2)=%
 ;
IGTPCC ;
 K BDMY S %=P_"^FIRST DX [DM AUDIT IGT DXS",E=$$START1^APCLDF(%,"BDMY(")
 I '$D(BDMY(1)) Q G
 I $P(BDMY(1),U,1)>EDATE Q G
 S $P(G,U,3)=$P(BDMY(1),U,1)
 Q G
PREDM(P,EDATE) ;
 ;return doo from problem list^first dx pcc
 I '$G(EDATE) S EDATE=DT
 NEW X,Y,I,BDMY,%,R,T,G
 K R
 S T=$O(^ATXAX("B","DM AUDIT PREDIABETES DXS",0))
 S G=""
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNPROB(X,0))  ;bad xref
 .Q:$P(^AUPNPROB(X,0),U,12)="D"  ;deleted
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)  ;not a dx we want
 .S D=$P(^AUPNPROB(X,0),U,13)
 .I D Q:D>EDATE
 .S R(9999999-D)=X
 ;now get earliest or ""
 I '$D(R) G PREDMPCC
 S G=1
 S %=$O(R(0))
 S %=9999999-%
 S:'% %=""
 S $P(G,U,2)=%
 ;
PREDMPCC ;
 K BDMY S %=P_"^FIRST DX [DM AUDIT PREDIABETES DXS",E=$$START1^APCLDF(%,"BDMY(")
 I '$D(BDMY(1)) Q G
 I $P(BDMY(1),U,1)>EDATE Q G
 S $P(G,U,3)=$P(BDMY(1),U,1)
 Q G
IFG(P,EDATE) ;
 I '$G(EDATE) S EDATE=DT
 ;return doo from problem list^first dx pcc
 NEW X,Y,I,BDMY,%,R,T,G
 K R
 S T=$O(^ATXAX("B","BGP IMPAIRED FASTING GLUCOSE",0))
 S G=""
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNPROB(X,0))  ;bad xref
 .Q:$P(^AUPNPROB(X,0),U,12)="D"  ;deleted
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)  ;not a dx we want
 .S D=$P(^AUPNPROB(X,0),U,13)
 .I D Q:D>EDATE
 .S R(9999999-D)=X
 ;now get earliest or ""
 I '$D(R) G IFGPCC
 S G=1
 S %=$O(R(0))
 S %=9999999-%
 S:'% %=""
 S $P(G,U,2)=%
 ;
IFGPCC ;
 K BDMY S %=P_"^FIRST DX [BGP IMPAIRED FASTING GLUCOSE",E=$$START1^APCLDF(%,"BDMY(")
 I '$D(BDMY(1)) Q G
 I $P(BDMY(1),U,1)>EDATE Q G
 S $P(G,U,3)=$P(BDMY(1),U,1)
 Q G
 ;
BP(P) ;last 3 BPs - NON ER
 NEW BDMD,BDMC
 K BDMX
 S BDMX="",BDMD="",BDMC=0
 S T=$O(^AUTTMSR("B","BP",""))
 F  S BDMD=$O(^AUPNVMSR("AA",P,T,BDMD)) Q:BDMD=""!(BDMC=3)  D
 .S M=0 F  S M=$O(^AUPNVMSR("AA",P,T,BDMD,M)) Q:M'=+M!(BDMC=3)  D
 ..S V=$P($G(^AUPNVMSR(M,0)),U,3) Q:'V
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:$$CLINIC^APCLV(V,"C")=30
 ..S BDMC=BDMC+1,BDMX(BDMC)=(9999999-BDMD)_U_$P(^AUPNVMSR(M,0),U,4)
 ..Q
 .Q
 I '$D(BDMX(1)) S BDMX(1)="None recorded"
BPX ;
 K BDMD,BDMC
 Q BDMX
FGLUCOSE(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT FASTING GLUCOSE TESTS",0)),LT="DM AUDIT FASTING GLUC LOINC" I 'T Q "<Taxonomy Missing>"
 Q $$LAB^BDMS9B2(P,T,LT)
GM75(P) ;
 I '$G(P) Q ""
 NEW T S T=$O(^ATXLAB("B","DM AUDIT 75GM 2HR GLUCOSE",0)),LT="DM AUDIT 75GM 2HR LOINC" I 'T Q "<Taxonomy Missing>"
 Q $$LAB^BDMS9B2(P,T,LT)
