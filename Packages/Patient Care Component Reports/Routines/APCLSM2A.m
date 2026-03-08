APCLSM2A ;ihs/cmi/maw - 2015 CHIT Continuation
 ;;3.0;IHS PCC REPORTS;**32**;FEB 05, 1997;Build 9
 ;
 Q
 ;
PV1(EV,V,P) ;-- setup the JVN PV1 segment
 N NPI,AUTH,AUTH,LOCI,ES,PC,DDT
 S ES="&"
 S PC=$S($P($G(^AUPNVSIT(V,0)),U,7)="H":"I",$P($G(^AUPNVSIT(V,0)),U,8)=30:"E",1:"O")
 S LOCI=$P($G(^AUPNVSIT(V,0)),U,6)
 S NPI=$G(^DIC(4,LOCI,"NPI"))
 S AUTH=$P($G(^DIC(4,LOCI,0)),U)
 D SET(.ARY,"PV1",0)
 D SET(.ARY,1,1)
 D SET(.ARY,PC,2)  ;2015 chit
 D SET(.ARY,V,19,1)
 D SET(.ARY,$E(AUTH,1,20),19,4,1)  ;2015 chit
 D SET(.ARY,NPI,19,4,2)  ;2015 chit
 D SET(.ARY,"NPI",19,4,3)  ;2015 chit
 D SET(.ARY,"VN",19,5)
 I EV="A03" D
 . N DDSP,VER
 . S DDSP="01"
 . I $$GET1^DIQ(2,P,.351,"I") S DDSP="20"
 . ;S VER=$O(^AUPNVER("AD",V,0))
 . S VER=$O(^AMERVSIT("AD",V,0))
 . I VER D
 .. N DED
 .. ;S DED=$P($G(^AUPNVER(VER,0)),U,11)
 .. S DED=$E($$GET1^DIQ(9009080,VER,6.1),1)
 .. S DDSP=$S(DED="A":"09",DED="D":20,DED="E":20,1:"01")
 .. S DDT=$$FMTHL7^XLFDT($$GET1^DIQ(9009080,VER,6.2,"I"))
 . D SET(.ARY,DDSP,36)
 . D SET(.ARY,$S($G(DDT):DDT,1:$$FMTHL7^XLFDT($$GET1^DIQ(9000010,V,.01,"I"))),45)
 D SET(.ARY,$$FMTHL7^XLFDT($$GET1^DIQ(9000010,V,.01,"I")),44)
 ;need to set PV1-45 for discharge date here
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
PV2(V,PT) ;-- setup the PV2 segment
 ;this may need to be changed to look at the admitting dx in ADT
 Q:'$G(V)
 N HVST,VINP,DXI,DX,DXE,IVDT,ADMT
 ;find H visit here
 S IVDT=(9999999-$P(^AUPNVSIT(V,0),U))
 S EVDT=IVDT+2
 S HVST=$$FNDH(IVDT,EVDT,PT)
 I '$G(HVST),$P($G(^AUPNVSIT(V,0)),U)="H" S HVST=V  ;2015 chit
 ;Q:'HVST  mu2
 I 'HVST D  Q  ;2015 chit
 . N CCE
 . S CCE=$$GET1^DIQ(9000010,V,1401)
 . I $E(CCE,4,4)="." D  ;2015 chit this is for a coded chief complaint thats not allowed
 .. S DXI=$O(^ICD9("AB",CCE_" ",0))
 .. Q:'DXI
 .. S DXD=$$ICDDX^ICDEX(CCE,DT,30,"")
 .. S DXE=$P($G(DXD),U,4)
 .. ;get dx and setup
 . D SET(.ARY,"PV2",0)
 . I $G(DXI) D SET(.ARY,CCE,3,1)  ;2015 chit
 . D SET(.ARY,$E($S($G(DXE)]"":DXE,1:CCE),1,40),3,2)  ;2015 chit
 . I $G(DXI) D SET(.ARY,"I10C",3,3)  ;2015 chit
 . S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 ;find the admit here and get admitting dx
 S ADMT=$O(^DGPM("AVST",PT,HVST,0))
 Q:'ADMT
 ;S VINP=$O(^AUPNVINP("AD",HVST,0))
 ;Q:'VINP
 ;S DXI=$$GET1^DIQ(9000010.02,VINP,.12,"I")
 ;S DX=$$GET1^DIQ(9000010.02,VINP,.12)
 S DXI=$O(^ICD9("AB",$P($G(^DGPM(ADMT,0)),U,10)_" ",0))
 S DX=$$GET1^DIQ(405,ADMT,.1,"I")
 ;I $G(DXI) S DXE=$$GET1^DIQ(80,DXI,3)
 N ICDT,ICDATA,ICDIEN
 S ICDATA=$$ICDDX^APCLSILU(DX,VDATE)
 S ICDT=$P(ICDATA,U,20)  ;get the icd type based on the code
 S ICDIEN=$P(ICDATA,U)
 S DX=$P(ICDATA,U,2)
 S DXE=$P(ICDATA,U,4)
 I '$G(ICDIEN) D
 . N CD
 . S CD=$$GET1^DIQ(405,ADMT,.1,"I")
 . Q:CD=""
 . S DX=CD
 . S DXE=$P($$LOOKTABM("","SCT",CD,"^"),"^",2)
 . S ICDT="SCT"
 I $P(DX,".",2)="" S DX=$TR(DX,".")
 D SET(.ARY,"PV2",0)
 D SET(.ARY,DX,3,1)  ;mu2
 D SET(.ARY,DXE,3,2)
 ;D SET(.ARY,"I9CDX",3,3)
 D SET(.ARY,$S(ICDT="30":"I10C",ICDT="SCT":"SCT",1:"I9CDX"),3,3)  ;p30  mu2
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
FNDH(VDT,EDT,P) ;-- find the next H visit within 48 hours
 N VDA
 S VDA=VDT F  S VDA=$O(^AUPNVSIT("AAH",P,VDA)) Q:'VDA  D
 . S VIEN=0 F  S VIEN=$O(^AUPNVSIT("AAH",P,VDA,VIEN)) Q:'VIEN  D
 .. I VDA<EDT S VIN=VIEN Q
 Q $G(VIN)
 ;
OBXFV(V,CNT) ;-- setup the FACILITY VISIT OBX
 N CL,CLC,CD,DSC,LDSC
 S CL=$P($G(^AUPNVSIT(V,0)),U,8)
 S CLC=$$GET1^DIQ(40.7,CL,1)
 S CD=""
 ;we will need to do a more dynamic clinic map here
 I CLC=80 S CD="261QU0200X"  ;urgent care
 I CLC=30 S CD="261QE0002X"  ;er
 I CLC="" S CD="1021-5" ;inpatient facility
 Q:CD=""
 I CLC'="" S DSC=$$LOOKTABM("","NUCC",CD,HLECH)
 I CLC="" S DSC=$$LOOKTABM("","HSLOC",CD,"^")  ;2015 chit
 S LDSC=$$LOOKTABM("","PHINQUESTION","SS003","^")  ;2015 chit
 D SET(.ARY,"OBX",0)
 D SET(.ARY,CNT,1)
 D SET(.ARY,"CWE",2)
 ;D SET(.ARY,"SS003",3,1)  ;mu2
 ;D SET(.ARY,"PHINQUESTION",3,3)  ;mu2
 D SET(.ARY,$P(LDSC,U),3,1)  ;2015 chit
 D SET(.ARY,$P(LDSC,U,2),3,2)  ;2015 chit
 D SET(.ARY,$P(LDSC,U,3),3,3)  ;2015 chit
 D SET(.ARY,CD,5,1)
 D SET(.ARY,$P(DSC,U,2),5,2)
 ;D SET(.ARY,"NUCC",5,3)  ;mu2
 D SET(.ARY,$S(CLC="":"HSLOC",1:"HCPTNUCC"),5,3)  ;2015 chit
 I CLC'="" D SET(.ARY,$S(CLC=80:"Urgent Care Center",1:"Emergency Care"),5,9)
 D SET(.ARY,"F",11)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
OBXLOC(V) ;-- setup the LOCATION OBX 2015 chit
 N CL,CLC,CD,DSC,LDSC,ADM
 S ADM=$O(^DGPM("AVISIT",V,0))
 I ADM,$P($G(^DGPM(ADM,0)),U,7)="" Q  ;work around for location since one A01 has it on 4.1 but not 3.4
 S OBXCNT=OBXCNT+1
 S CD="1028-0"
 S DSC=$$LOOKTABM("","HSLOC",CD,"^")  ;2015 chit
 S LDSC=$$LOOKTABM("","LN","56816-2","^")  ;2015 chit
 D SET(.ARY,"OBX",0)
 D SET(.ARY,OBXCNT,1)
 D SET(.ARY,"CWE",2)
 ;D SET(.ARY,"SS003",3,1)  ;mu2
 ;D SET(.ARY,"PHINQUESTION",3,3)  ;mu2
 D SET(.ARY,$P(LDSC,U),3,1)  ;2015 chit
 D SET(.ARY,$P(LDSC,U,2),3,2)  ;2015 chit
 D SET(.ARY,$P(LDSC,U,3),3,3)  ;2015 chit
 D SET(.ARY,CD,5,1)
 D SET(.ARY,$P(DSC,U,2),5,2)
 D SET(.ARY,"HSLOC",5,3)  ;2015 chit
 D SET(.ARY,"F",11)
 D SET(.ARY,$$FMTHL7^XLFDT($$GET1^DIQ(9000010,V,.01,"I")),14)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
OBXUNIT(P,V,CNT) ;-- setup units
 Q:$P($G(^DPT(P,0)),U)'["UNKNOWN"  ;this will need to change once we identify what an unknown patient is
 ;Q:$$GET1^DIQ(40.7,$P($G(^AUPNVSIT(V,0)),U,8),1)=80
 D SET(.ARY,"OBX",0)
 D SET(.ARY,CNT,1)
 D SET(.ARY,"NM",2)
 D SET(.ARY,"21612-7",3,1)
 D SET(.ARY,"LN",3,3)
 D SET(.ARY,"UNK",6,1)
 D SET(.ARY,"NULLFL",6,3)
 D SET(.ARY,"F",11)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
OBXAGE(P,V,CNT) ;-- setup the visit OBX
 ;Q:$$GET1^DIQ(40.7,$P($G(^AUPNVSIT(V,0)),U,8),1)=30
 N AGE,DSC,ADSC,ADOB
 S DSC=$$LOOKTABM("","LN","21612-7","^")
 S AGE=$$AGE(P,3)
 D SET(.ARY,"OBX",0)
 D SET(.ARY,CNT,1)
 D SET(.ARY,"NM",2)
 ;D SET(.ARY,"21612-7",3,1) ;mu2
 ;D SET(.ARY,"LN",3,3)  ;mu2
 ;2015 chit start
 D SET(.ARY,$P(DSC,"^"),3,1)
 D SET(.ARY,$P(DSC,"^",2),3,2)
 D SET(.ARY,$P(DSC,"^",3),3,3)
 S AGEU=$$AGEU(AGE)
 I AGEU="mo" S AGE=$$AGE(P,2)
 I AGEU="d" S AGE=$$AGE(P,3)
 I AGEU="a" S AGE=$$AGE(P,1)
 S ADOB=$P($G(^DPT(P,0)),U,3)
 I ADOB=2000101 D  ;2015 chit this is our DOB for unknown DOB
 . D SET(.ARY,"UNK",6,1)
 . D SET(.ARY,"Unknown",6,2)
 . D SET(.ARY,"NULLFL",6,3)
 I ADOB'=2000101 D
 . D SET(.ARY,AGE,5)
 . S ADSC=$$LOOKTABM("","UCUM",AGEU,"^")
 . D SET(.ARY,$P(ADSC,"^",1),6,1)
 . D SET(.ARY,$P(ADSC,"^",2),6,2)
 . D SET(.ARY,$P(ADSC,"^",3),6,3)
 ;2015 chit end
 D SET(.ARY,"F",11)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
AGEU(AG) ;-- determine units based on age
 I AG<30 Q "d"
 I AG<365 Q "mo"
 Q "a"
 ;
OBXWT(P,V,CNT) ;-- setup the visit OBX
 N WT,DSC,WDSC
 S DSC=$$LOOKTABM("","LN","3141-9","^")
 S WT=$P($$LASTITEM^APCLAPIU(P,"WT","MEASUREMENT",3180101,DT,"A"),U,3)
 D SET(.ARY,"OBX",0)
 D SET(.ARY,CNT,1)
 D SET(.ARY,"NM",2)
 D SET(.ARY,$P(DSC,"^"),3,1)  ;2015 chit
 D SET(.ARY,$P(DSC,"^",2),3,2)  ;2015 chit
 D SET(.ARY,$P(DSC,"^",3),3,3)  ;2015 chit
 D SET(.ARY,WT,5)
 S WDSC=$$LOOKTABM("","UCUM","[lb_av]","^")
 D SET(.ARY,$P(WDSC,"^",1),6,1)
 D SET(.ARY,$P(WDSC,"^",2),6,2)
 D SET(.ARY,$P(WDSC,"^",3),6,3)
 D SET(.ARY,"F",11)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
OBXHT(P,V,CNT) ;-- setup the visit OBX
 N HT,DSC,HDSC
 S DSC=$$LOOKTABM("","LN","8302-2","^")
 S HT=$P($$LASTITEM^APCLAPIU(P,"HT","MEASUREMENT",3180101,DT,"A"),U,3)
 D SET(.ARY,"OBX",0)
 D SET(.ARY,CNT,1)
 D SET(.ARY,"NM",2)
 D SET(.ARY,$P(DSC,"^"),3,1)  ;2015 chit
 D SET(.ARY,$P(DSC,"^",2),3,2)  ;2015 chit
 D SET(.ARY,$P(DSC,"^",3),3,3)  ;2015 chit
 D SET(.ARY,HT,5)
 S HDSC=$$LOOKTABM("","UCUM","[in_us]","^")
 D SET(.ARY,$P(HDSC,"^",1),6,1)
 D SET(.ARY,$P(HDSC,"^",2),6,2)
 D SET(.ARY,$P(HDSC,"^",3),6,3)
 D SET(.ARY,"F",11)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
OBXTOB(P,V,CNT) ;-- setup the visit OBX
 N AGE,DSC,TOB,HFI,HF,HFE,OK
 ;S TOBE=$$LASTHF^APCLAPIU(P,"TOBACCO (SMOKING)",,,"A")
 S HFI=0 F  S HFI=$O(^AUPNVHF("AD",V,HFI)) Q:'HFI  D
 . S HF=$P($G(^AUPNVHF(HFI,0)),U)
 . I $$GET1^DIQ(9999999.64,HF,.03)["TOB" S OK=HF
 . I $G(OK) S TOB=$$GET1^DIQ(9999999.64,HF,.01)
 Q:$G(TOB)=""
 S DSC=$$LOOKTABM("","LN","72166-2","^")
 ;S TOB=$P(TOBE,U,2)
 D SET(.ARY,"OBX",0)
 D SET(.ARY,CNT,1)
 D SET(.ARY,"CWE",2)
 D SET(.ARY,$P(DSC,"^"),3,1)  ;2015 chit
 D SET(.ARY,$P(DSC,"^",2),3,2)  ;2015 chit
 D SET(.ARY,$P(DSC,"^",3),3,3)  ;2015 chit
 I $G(TOB)["NEVER" D
 . S TDSC=$$LOOKTABM("","SCT","266919005","^")
 . D SET(.ARY,$P(TDSC,"^",1),5,1)
 . D SET(.ARY,$P(TDSC,"^",2),5,2)
 . D SET(.ARY,$P(TDSC,"^",3),5,3)
 I $G(TOB)["UNKNOWN" D
 . S TDSC=$$LOOKTABM("","SCT","266927001","^")
 . D SET(.ARY,$P(TDSC,"^",1),5,1)
 . D SET(.ARY,$P(TDSC,"^",2),5,2)
 . D SET(.ARY,$P(TDSC,"^",3),5,3)
 I $G(TOB)["LIGHT" D
 . S TDSC=$$LOOKTABM("","SCT","428061000124105","^")
 . D SET(.ARY,$P(TDSC,"^",1),5,1)
 . D SET(.ARY,$P(TDSC,"^",2),5,2)
 . D SET(.ARY,$P(TDSC,"^",3),5,3)
 D SET(.ARY,"F",11)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
OBXCC(V,CNT) ;-- setup the chief complaint OBX
 N LN,CCI,CC,EC,ECE,ECI,VPOVI,CCE,DSC
 ;S VPOVI=$O(^AUPNVPOV("AD",V,0))
 ;S CCI=$$GET1^DIQ(9000010,V,1107,"I")
 ;S CC=$$GET1^DIQ(80,$$GET1^DIQ(9000010.07,VPOVI,.01,"I"),3)
 ;S LN=$$GET1^DIQ(9000010,V,1401)
 S CCE=$$GET1^DIQ(9000010,V,1401)
 Q:$G(CCE)=""
 Q:$E(CCE,4,4)="."  ;dont do a cc obx if a coded cc
 S OBXCNT=OBXCNT+1
 ;I $G(CCE)]"" S CCI=$O(^ICD9("AB",CCE_" ",0))
 ;I $G(CCI) S CC=$$GET1^DIQ(80,CCI,3)
 ;S ECI=$$GET1^DIQ(9000010.07,VPOVI,.09,"I")
 ;S EC=$$GET1^DIQ(80,CCI,.01)
 ;S ECE=$$GET1^DIQ(80,CCI,3)
 S DSC=$$LOOKTABM("","LN","8661-1","^")  ;2015 chit
 D SET(.ARY,"OBX",0)
 D SET(.ARY,CNT,1)
 ;D SET(.ARY,"CWE",2)  ;mu2
 D SET(.ARY,"TX",2)  ;2015 chit
 ;D SET(.ARY,"8661-1",3,1)  ;this is the chief complaint loinc code
 D SET(.ARY,$P(DSC,"^"),3,1)  ;2015 chit
 D SET(.ARY,$P(DSC,"^",2),3,2)  ;2015 chit
 ;I $G(CCI) D  mu2
 ;. D SET(.ARY,EC,5,1)
 ;. D SET(.ARY,ECE,5,2)
 ;. D SET(.ARY,"I9CDX",5,3)
 ;D SET(.ARY,"LN",3,3)  ;mu2
 D SET(.ARY,$P(DSC,"^",3),3,3)  ;2015 chit
 ;D SET(.ARY,$G(CCE),5,9)  ;mu2
 D SET(.ARY,$G(CCE),5,1)  ;2015 chit
 D SET(.ARY,"F",11)
 S X=$$ADDSEG^HLOAPI(.HLST,.ARY,.ERR)
 Q
 ;
LOOKTABM(TYPE,TAB,VAL,ECH) ;-- find the value and description in the HL7 tables
 N DESC,IENI,GBL
 S GBL="^APCLMUT"
 I TYPE="" S GBL="^APCLMUT"
 S IENI=$O(@GBL@("AVAL",TAB,VAL,0))
 Q:'IENI
 S DESC=$P($G(@GBL@(IENI,0)),U,3)
 Q VAL_ECH_DESC_ECH_TYPE_TAB
 ;
SET(ARY,V,F,C,S,R) ;EP
 D SET^HLOAPI(.ARY,.V,.F,.C,.S,.R)
 Q
AGE(DFN,BIZ,BIDT) ;EP
 ;---> Return Patient's Age.
 ;---> Parameters:
 ;     1 - DFN  (req) IEN in PATIENT File.
 ;     2 - BIZ  (opt) BIZ=1,2,3  1=years, 2=months, 3=days.
 ;                               2 will be assumed if not passed.
 ;     3 - BIDT (opt) Date on which Age should be calculated.
 ;
 N BIDOB,X,X1,X2  S:$G(BIZ)="" BIZ=2
 Q:'$G(DFN) "NO PATIENT"
 S BIDOB=$$DOB(DFN)
 Q:'BIDOB "Unknown"
 ;2015 chit still use age on date of death
 ;I '$G(BIDT)&($$DECEASED(DFN)) D  Q X
 ;.S X="DECEASED: "_$$TXDT1^BIUTL5(+^DPT(DFN,.35))
 S:'$G(DT) DT=$$DT^XLFDT
 S:'$G(BIDT) BIDT=DT
 Q:BIDT<BIDOB "NOT BORN"
 ;
 ;---> Age in Years.
 N BIAGEY,BIAGEM,BID1,BID2,BIM1,BIM2,BIY1,BIY2
 S BIM1=$E(BIDOB,4,7),BIM2=$E(BIDT,4,7)
 S BIY1=$E(BIDOB,1,3),BIY2=$E(BIDT,1,3)
 S BIAGEY=BIY2-BIY1 S:BIM2<BIM1 BIAGEY=BIAGEY-1
 S:BIAGEY<1 BIAGEY="<1"
 Q:BIZ=1 BIAGEY
 ;
 ;---> Age in Months.
 S BID1=$E(BIM1,3,4),BIM1=$E(BIM1,1,2)
 S BID2=$E(BIM2,3,4),BIM2=$E(BIM2,1,2)
 S BIAGEM=12*BIAGEY
 I BIM2=BIM1&(BID2<BID1) S BIAGEM=BIAGEM+12
 I BIM2>BIM1 S BIAGEM=BIAGEM+BIM2-BIM1
 I BIM2<BIM1 S BIAGEM=BIAGEM+BIM2+(12-BIM1)
 S:BID2<BID1 BIAGEM=BIAGEM-1
 Q:BIZ=2 BIAGEM
 ;
 ;---> Age in Days.
 S X1=BIDT,X2=BIDOB
 D ^%DTC
 Q X
 ;
DOB(DFN) ;EP
 ;---> Return Patient's Date of Birth in Fileman format.
 ;---> Parameters:
 ;     1 - DFN   (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "NO PATIENT"
 Q:'$P($G(^DPT(DFN,0)),U,3) "NOT ENTERED"
 Q $P(^DPT(DFN,0),U,3)
 ;
DECEASED(DFN,BIDT) ;EP
 ;---> Return 1 if patient is deceased, 0 if not deceased.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;     2 - BIDT (opt) If BIDT=1 return Date of Death (Fileman format).
 ;
 Q:'$G(DFN) 0
 N X S X=+$G(^DPT(DFN,.35))
 Q:'X 0
 Q:'$G(BIDT) 1
 Q X
 ;
GL(IN,EV,PT,VDD) ;-- write out the batch to a global for saving in APCLSLAB
 K ^APCLTMP($J)
 N BDA,BDO,HLODAT,MSH,MSGP,MSG,BT,BT1,BT2,BT3
 S APCLCNT=0
 S MSG=$P($G(^HLB(IN,0)),U,2)
 D REST(MSG)
 D WRITE(EV,PT,VDD)
 Q
 ;
REST(M) ;-- write out the remainder of the segments to the global
 N MDA,DATA,MCNT
 S MCNT=0
 S MDA=0 F  S MDA=$O(^HLA(M,1,MDA)) Q:'MDA  D
 . S DATA=$G(^HLA(M,1,MDA,0))
 . Q:DATA=""
 . I $E(DATA,1,3)="NSH" D
 .. S $E(DATA,1,4)="MSH"
 .. S $P(DATA,HLFS,2)="^~\&"
 . D SETGL(DATA)
 Q
 ;
SETGL(D) ;-- set the temp global
 S APCLCNT=APCLCNT+1
 S ^APCLTMP($J,APCLCNT)=D
 Q
 ;
WRITE(E,P,VD) ; use XBGSAVE to save the temp global (APCLDATA) to a delimited
 ; file that is exported to the IE system
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN,APCLFN
 S XBGL="APCLTMP",XBMED="F",XBQ="N",XBFLT=1,XBF=$J,XBE=$J
 S XBNAR="MU2 HL7 EXPORT"
 S APCLASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S (XBFN,APCLDFN)="MU2_"_E_"_"_$$HRN^AUPNPAT(P,DUZ(2))_"_"_$$DATET(VD)_".txt"
 S XBS1="SURVEILLANCE MU2 SEND"
 ;
 D ^XBGSAVE
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,"MU2 HL7 file successfully created",!!
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,"MU2 HL7 file NOT successfully created",!!
 K ^APCLTMP($J),APCLCNT
 K ^APCLDATA($J)
 Q
 ;
DATET(D) ;EP
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)_$E(D,8,11)
 ;
