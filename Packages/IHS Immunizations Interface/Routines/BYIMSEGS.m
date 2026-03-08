BYIMSEGS ;IHS/CIM/THL - IMMUNIZATION DATA EXCHANGE;
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**1,2,3,4,6,7**;AUG 20, 2020;Build 747
 ;
 ;code to supplement fields in the HL7 segments
 ;
MSH ;EP;entry point
 D MSH^BYIMSEG2
 Q
 ;=====
 ;
PID ;EP;
 D PID2
 D PID3
 D PID5
 D PID6
 D PID7
 D PID8
 D PID10
 D PID11
 D PID13
 D PID14
 D PID19
 D PID22
 D PID24
 D PID25
 D PID30
 Q
 ;=====
 ;
PID2 ;PID-2 DFN
 S INA("PID2")=INDA_CS_"IEN^RPMS"
 S INA("PID2",1)=INDA_CS_"IEN^RPMS"
 Q
 ;=====
 ;
PID3 ;PID-3 HRN
 N X,Y,Z
 S X=$$HRN^BYIMIMM3(INDA)
 S Y=""
 S Z=$O(^AUPNMCD("B",INDA,9999999999),-1)
 S:Z Y=$P($G(^AUPNMCD(Z,0)),U,3)
 S:Y]"" X=X_"~"_Y_CS_CS_CS_"MCD"_CS_"MA"
 ;AUPN V99.1 PATCH 26 REQUIRED
 S Y=""
 S Y=$$GETMCR^AGUTL(INDA,DT)
 I $L(Y) S X=X_"~"_Y_CS_CS_CS_"MEDICARE"_CS_"MC"
 S INA("PID3")=X
 S INA("PID3",1)=X
 Q
 ;=====
 ;
PID5 ;PID-5 NAME
 N X,Y,Z
 S X=$P($G(^DPT(INDA,0)),U)
 S Y=$P($P(X,",",2)," ")
 S Z=$P($P(X,",",2)," ",2)
 S X=$P(X,",")
 S INA("PID5")=X_CS_Y_CS_Z_CS_CS_CS_CS_"L"
 S INA("PID5",1)=INA("PID5")
 Q
 ;=====
 ;
PID6 ;PID-6 MMN
 N X,Y,Z
 S X=$P($G(^DPT(INDA,.24)),U,3)
 S Y=$P($P(X,",",2)," ")
 S Z=$P($P(X,",",2)," ",2)
 S X=$P(X,",")
 S INA("PID6")=$S(X]"":(X_CS_Y_CS_Z_CS_CS_CS_CS_"M"),1:"")
 S INA("PID6",1)=INA("PID6")
 Q
 ;=====
 ;
PID7 ;PID-7 DOB
 S INA("PID7")=17000000+$P($G(^DPT(INDA,0)),U,3)
 S INA("PID7",1)=INA("PID7")
 Q
 ;=====
 ;
PID8 ;PID-8 SEX
 S INA("PID8")=$P($G(^DPT(INDA,0)),U,2)
 S INA("PID8",1)=INA("PID8")
 Q
 ;=====
 ;
PID10 ;PID-10 RACE
 S INA("PID10")=$$RACE^BYIMIMM3(INDA)
 S INA("PID10",1)=INA("PID10")
 Q
 ;=====
 ;
PID11 ;PID-11 ADDRESS
 S X=$G(^DPT(+INDA,.11))
 ;PATCH 1 TO INCLUDE COUNTY
 S STATE=+$P(X,U,5)
 S COUNTY=+$P($G(^AUPNPAT(+INDA,11)),U,17)
 S COUNTY=+$P($G(^AUTTCOM(COUNTY,0)),U,2)
 S COUNTY=$P($G(^AUTTCTY(COUNTY,0)),U)
 S INA("PID11")=$P(X,U)_CS_CS_$P(X,U,4)_CS_$P($G(^DIC(5,STATE,0)),U,2)_CS_$P(X,U,6)_CS_"USA"_CS_$S($G(BYIMATYP)]"":BYIMATYP,1:"P")_CS_CS_COUNTY
 ;PATCH 1 END
 S INA("PID11",1)=INA("PID11")
 Q
 ;=====
 ;
PID13 ;PID-13 PHONE HOME
 S INA("PID13")=""
 S INA("PID13",1)=""
 S X=$P($G(^DPT(INDA,.13)),U)
 S X=$TR(X,"()\/- ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
 S:$E(X)=1 X=$E(X,2,99)
 I X'?10N S INA("PID13")=""
 D:X?10N
 .D:BYIMVER>2.4
 ..S INA("PID13")=CS_"PRN"_CS_"PH"_CS_CS_CS_$E(X,1,3)_CS_$E(X,4,10)
 ..S INA("PID13",1)=INA("PID13")
 .D:BYIMVER<2.5
 ..S INA("PID13")="("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_CS_"PRN"_CS_"PH"
 ..S INA("PID13",1)=INA("PID13")
 S X=$P($G(^AUPNPAT(INDA,18)),U,2)
 Q:X=""
 S X="~^NET^Internet^"_X
 S INA("PID13")=INA("PID13")_X
 S INA("PID13",1)=INA("PID13")
 Q
 ;=====
 ;
PID14 ;PID-14 PHONE BUSINESS
 S INA("PID14")=""
 S INA("PID14",1)=""
 S X=$P($G(^DPT(INDA,.13)),U,2)
 S X=$TR(X,"()\/- ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
 S:$E(X)=1 X=$E(X,2,99)
 I X'?10N S INA("PID14",1)="" Q
 D:BYIMVER["2.5"
 .S INA("PID14")=CS_"WPN"_CS_"PH"_CS_CS_CS_$E(X,1,3)_CS_$E(X,4,10)
 .S INA("PID14",1)=INA("PID14")
 D:BYIMVER'["2.5"
 .S INA("PID14")="("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_CS_"WPN"_CS_"PH"
 .S INA("PID14",1)=INA("PID14")
 Q
 ;=====
 ;
PID19 ;PID-19 SSN
 S Y=$TR($P($G(^DPT(INDA,0)),U,9),"-")
 S:Y]"" X=Y_CS_CS_CS_"SSA"_CS_"SS"
 ;S INA("PID19")=X
 ;S INA("PID19",1)=X
 Q
 ;=====
 ;
PID22 ;PID-22 ETHNICITY
 S INA("PID22")=$$ETH^BYIMIMM3(INDA)
 S INA("PID22",1)=INA("PID22")
 Q
 ;=====
 ;
PID24 ;PID-24 MULTIPLE BIRTH INDICATOR
 N X
 S X=$P($G(^AUPNBMSR(INDA,0)),U,11)
 S X=$S(X<2:"N",1:"Y")
 S INA("PID24")=X
 S INA("PID24",1)=X
 Q
 ;=====
 ;
PID25 ;PID-25 BIRTH ORDER
 N X
 S X=$P($G(^AUPNBMSR(INDA,0)),U,11)
 S:'X X=1
 S INA("PID25")=X
 S INA("PID25",1)=X
 Q
 ;=====
 ;
PID30 ;PID-30 PATIENT DEATH INDICATOR
 S INA("PID30")="N"
 S INA("PID30",1)="N"
PIDEND Q
 ;=====
 ;
PD1 ;EP;
 D PD1^BYIMSEG1
PD1END Q
 ;=====
 ;
NK1 ; generate the NK1 segment
 D NKSET
 D NK11
 D NK12
 D NK13
 D NK14
 D NK15
 D NK17
 Q
 ;=====
 ;
NK11 ;subid
 S INA("NK11")="1"
 S INA("NK11",1)="1"
 Q
 ;=====
 ;
NK12 N X,FN,LN,MN
 S X=$P(NK0,U)
 S LN=$P(X,",")
 S FN=$P($P(X,",",2)," ")
 S MN=$P($P(X,",",2)," ",2)
 S:LN="" LN="LASTNAME"
 S:FN="" FN="FIRSTNAME"
 S INA("NK12")=LN_CS_FN_CS_MN_CS_CS_CS_CS_"L"
 S INA("NK12",1)=INA("NK12")
 Q
 ;=====
 ;
NK13 ;GET NOK RELATIONSHIP
 N X,Y
 S INA("NK13")=NKRS_CS_NKR_CS_"HL70063"
 S INA("NK13",1)=INA("NK13")
 Q
 ;=====
 ;
NK14 ;NOK ADDRESS
 S X=$P(NK0,U,3,8)
 S X=$P(X,U)_CS_CS_$P(X,U,4)_CS_$P($G(^DIC(5,+$P(X,U,5),0)),U,2)_CS_$P(X,U,6)_CS_"USA"_CS_"L"
 S INA("NK14")=X
 S INA("NK14",1)=X
 Q
 ;=====
 ;
NK15 ;PHONE NUMBER
 S INA("NK15")=""
 S X=$P(NK0,U,9)
 S X=$TR(X,"()\/- ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz")
 S:$E(X)=1 X=$E(X,2,99)
 I X'?10N S INA("NK15",1)="" Q
 D:BYIMVER["2.5"
 .S INA("NK15")=CS_"PRN"_CS_$S('$G(NK12):"PH",1:"CP")_CS_CS_CS_$E(X,1,3)_CS_$E(X,4,10)
 .S INA("NK15",1)=INA("NK15")
 D:BYIMVER'["2.5"
 .S INA("NK15")="("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_CS_"PRN"_CS_$S('$G(NK12):"PH",1:"CP")
 .S INA("NK15",1)=INA("NK15")
 Q
 ;=====
 ;
NK17 ;CONTACT
 S INA("NK17")="NK^NEXT OF KIN"
 S INA("NK17",1)="NK^NEXT OF KIN"
NK1END Q
 ;=====
 ;
NKSET ;SET NOK SOURCE
 D NKSET^BYIMSEG2
 Q
 ;=====
 ;
PV1 ;EP;FOR PV1 SEGMENT CONTENT
 D PV11
 D PV12
 D PV13
 D PV17
 D PV19
 D PV119
 D PV120
 D PV144
 D PV145
 Q
 ;=====
 ;
PV11 ;PV1-01
 S INA("PV11",1)=1
 Q
 ;=====
 ;
PV12 ;PV1-02
 S INA("PV12",1)="R"
 Q
 ;=====
 ;
PV13 ;PV1-03 PAT LOC
 S INA("PV13",1)=""
 Q
 ;=====
 ;
PV17 ;PV1-07
 S INA("PV17",1)=""
 S P=$$PRIMPROV^APCLV(INDA,"I")
 Q:'P
 S X=$$PROV(P)
 S INA("PV17",1)=X
 Q
 ;=====
 ;
PV19 ;PV1-09
 S INA("PV19",1)=""
 S P=$$PRIMPROV^APCLV(INDA,"I")
 Q:'P
 S X=$$PROV(P)
 S INA("PV19",1)=X
 Q
 ;=====
 ;
PV119 ;PV1-19
 S INA("PV119",1)=INDA_CS_CS_CS_"RPMS"_CS_"MR"
 Q
 ;=====
 ;
PV120 ;PV1-20 VFC
 S INA("PV120",1)=$$VFC^BYIMIMM3(INDA)
 Q
 ;=====
 ;
PV144 ;PV1-44 VISIT DATE
 N X,Y,Z
 S INA("PV144",1)=""
 S X=$P($G(^AUPNVSIT(+$G(INDA),0)),".")
 Q:$L(X)'=7
 S INA("PV144",1)=X+17000000
 Q
 ;=====
 ;
PV145 ;PV1-45 DISCHARGE DATE
 N X,Y,Z
 S INA("PV145",1)=""
 S X=$P($G(^AUPNVSIT(+$G(INDA),0)),".")
 Q:$L(X)'=7
 S INA("PV145",1)=X+17000000
PV1END Q
 ;=====
 ;
ORC ;EP; - for ORC components
 ;ALLOW TO SEND DELETED IMMUNIZATIONS
 I $G(DELX) S INDA=DELX
 Q:'$G(DELX)&'$D(^AUPNVIMM(INDA,0))
 Q:$G(DELX)&'$D(^BIVIMMD(INDA,0))
 D VSET(INDA)
 D ORC1
 D ORC2
 D ORC3
 D ORC5
 D ORC10
 D ORC12
 D ORC17
 Q
 ;=====
 ;
ORC1 ;ORC-1
 S INA("ORC1",INDA)="RE"
 Q
 ;=====
 ;
ORC2 ;ORC-2
 S INA("ORC2",INDA)=""
 S X=$E(INDA_"-"_$P($G(^AUTTLOC($$DUZ^BYIMIMM(),0)),U,10),1,15)
 S Y="IHS"
 S X=X_CS_Y
 S:$G(DELX) INDA=DELX
 S INA("ORC2",INDA)=X
 Q
 ;=====
 ;
ORC3 ;ORC-3
 ;V3.0 PATCH 6 - FID-CONTRAINDICATIONS UPDATE
 N X,Y,Z,ID
 S ID=""
 S:$G(DELX) ID=$P($G(^BIVIMMD(DELX,0)),U,18)
 S INA("ORC3",INDA)=""
 S X=$P(X0,U,18)
 S:ID]"" X=ID
 I X="" D
 .S X="000"
 .S Z=$P($G(^AUTTLOC($$DUZ^BYIMIMM(),0)),U,10)
 .S Z=$E("000000",1,6-$L(Z))_Z
 .S X=Z_X_$E("0000000",1,7-$L(INDA))_INDA
 .S $P(^AUPNVIMM(INDA,0),U,18)=X
 .S ^AUPNVIMM("ASTID",X,INDA)=""
 S X=X_CS_"IHS"
 S INA("ORC3",INDA)=X
 ;V3.0 PATCH 6 - END
 Q
 ;=====
 ;
ORC5 ;
 S INA("ORC5",INDA)="IP"
 Q
 ;=====
 ;
ORC10 ;entered by
 N P,X,Y,Z
 S INA("ORC10",INDA)=""
 S P=+$P(X12,U,17)
 S:'P P=+$P(V0,U,27)
 S:'P P=+$P(V0,U,23)
 Q:'P
 S X=$$PROV(P)
 ;USE NIST OR PARAMETER SPECIFIC CONTENT
 I $D(^BYIMTMP("TC",8,+$P($G(V0),U,5))) D
 .S Y="NIST-PI-12&2.16.840.1.113883.3.72.5.40.7&ISO"
 .S $P(X,U,9)=Y
 S INA("ORC10",INDA)=X
 Q
 ;=====
 ;
ORC12 ;ordering provider
 ;PATCH 5 ORDERING PROVIDER = PRIMARY PROVIDER
 N P,P0,PDA,X,Y,Z
 S INA("ORC12",INDA)=""
 S P=+$P(X12,U,2)
 D:'P
 .S Y=+$P(X0,U,3)
 .S PDA=0
 .F  S PDA=$O(^AUPNVPRV("AD",Y,PDA)) Q:'PDA!P  D
 ..S P0=$G(^AUPNVPRV(P,0))
 ..S:$P(P0,U,4)="P" P=+P0
 S:'P P=+$P(X12,U,4)
 ;PATCH 5 ORDERING PROVIDER = PRIMARY PROVIDER
 Q:'P
 S X=$$PROV(P)
 S INA("ORC12",INDA)=X
 Q
 ;=====
 ;
ORC17 ;setup for ORC17 variable - location
 S BYIMDUZ=$$DUZ^BYIMIMM()
 S X=$P($G(^BYIMPARA(BYIMDUZ,0)),U,7)
 S:X="" X=$P($G(^AUTTLOC(BYIMDUZ,0)),U,10)
 S INA("ORC17",INDA)=X_CS_$E($P($G(^DIC(4,BYIMDUZ,0)),U),1,20)_CS_"HL70362"
ORCEND Q
 ;=====
 ;
RXA ;EP;
 I $G(DELX) S INDA=DELX
 Q:'$G(DELX)&'$D(^AUPNVIMM(INDA,0))
 Q:$G(DELX)&'$D(^BIVIMMD(INDA,0))
 D VSET(INDA)
 D RXA2
 D RXA3
 D RXA4
 D RXA5
 D RXA6
 D RXA7
 D RXA9
 D RXA10
 D RXA11
 D RXA15
 D RXA16
 D RXA17
 D RXA20
 D RXA21
 D RXA22
 Q
 ;=====
 ;
RXA2 ;admin subid
 S INA("RXA2",INDA)=1
 Q
 ;=====
 ;
RXA3 ;admin date/time
 ;V3.0 PATCH 7 - FID-95689  use VISIT date instead of V IMM 1201
 S X=$P(V0,U)
 S X=$$TIMEIO^INHUT10(X)
 S INA("RXA3",INDA)=$P(X,"-")
 ;V3.0 PATCH 7 - FID-9568 END
 Q
 ;=====
 ;
RXA4 ;date/time entered
 ;V3.0 PATCH 7 - FID-95689 use VISIT date instead of V IMM 1201
 S X=$P(V0,U)
 S X=$$TIMEIO^INHUT10(X)
 S INA("RXA4",INDA)=$P(X,"-")
 ;V3.0 PATCH 7 - FID-95689 END
 Q
 ;=====
 ;
RXA5 ;admin code
 N X
 S X=$P(Z0,U,3)
 S:$L(X)=1 X="0"_X
 S INA("RXA5",INDA)=X_CS_$S($P(Z1,U)]"":$P(Z1,U),1:$P(Z0,U,2))_CS_"CVX"
 N CPT,CPT2,ICPT,X1,X2
 S CPT=$P(Z0,U,11)
 S CPT2=$P(Z1,U,15)
 N NDC,NDCN,NDCI
 S NDC=+$P($G(^AUTTIML(+$P(X0,U,5),0)),U,17)
 S NDCI=+$P($G(^BINDC(NDC,0)),U,2)
 S NDC=$P($G(^BINDC(NDC,0)),U)
 S NDCI=$P(Z0,U)
 D:CPT2
 .S X1=$P($P(V0,U),".")
 .S X2=$P($G(^DPT(+$P(X0,U,2),0)),U,3)
 .D D^%DTC
 .S:X>1096 CPT=CPT2
 S:CPT $P(INA("RXA5",INDA),"~",2)=CPT_CS_$P($G(^ICPT(CPT,0)),U,2)_CS_"CPT"
 S:NDC]"" $P(INA("RXA5",INDA),"~",3)=NDC_CS_NDCI_CS_"NDC"
 Q
 ;=====
 ;
RXA6 ;dose
 N X
 S X=+$P(X0,U,11)
 S:$E(X)="." X="0"_X
 S:'X X=$P(Z0,U,18)
 S:'X X=$S($G(BYIMDVOL):BYIMDVOL,1:"")
 S INA("RXA6",INDA)=X
 Q
 ;=====
 ;
RXA7 ;quantity definition
 S INA("RXA7",INDA)=""
 I INA("RXA6",INDA),INA("RXA6",INDA)'>997 S INA("RXA7",INDA)="mL^MilliLiters^UCUM"
 Q
 ;=====
 ;
RXA9 ;admin history
 S INA("RXA9",INDA)=$$HX^BYIMIMM3(INDA,V0,TYPE)
 S:INA("RXA9",INDA) INA("RXA6",INDA)=999,INA("RXA7",INDA)=""
 Q
 ;=====
 ;
RXA10 ;encounter provider
 N X,Y,Z,P,P0
 S INA("RXA10",INDA)=""
 S P=+$P(X12,U,4)
 D:'P
 .S P0=""
 .S Y=+$P($G(^AUPNVIMM(+INDA,0)),U,3)
 .S Z=0
 .F  S Z=$O(^AUPNVPRV("AD",Y,Z)) Q:'Z  D
 ..S P0=$G(^AUPNVPRV(Z,0))
 ..I $P(P0,U,4)="P" S P=+P0
 .I 'P S P=+P0
 Q:'P
 S X=$$PROV(P)
 S INA("RXA10",INDA)=X
 Q
 ;=====
 ;
RXA11 ;location of encounter
 ;PATCH 2 CR-12279 CORRECT EVALUATION OF RXA-11.4
 ;PATCH 3 CR-
 S INA("RXA11",INDA)=""
 N X,Y,Z
 S Z=+$P(V0,U,6)
 I $D(^BYIMPARA($$DUZ^BYIMIMM(),5,Z,0)) S X=$P(^(0),U,2) I X]""
 E  S X=$P($G(^DIC(4,Z,0)),U)
 I $E(X,1,5)="OTHER"!(X=""),$P(V21,U)]"" S X=$P(V21,U)
 S X=U_U_U_$E(X,1,20)
 S INA("RXA11",INDA)=X
 ;PATCH 2 CR-12279 END
 ;PATCH 3 CR- END
 Q
 ;=====
 ;
RXA15 ;immunization lot number
 S INA("RXA15",INDA)=""
 N X,Y,Z
 S X=$P(X0,U,5)
 Q:'X
 S LOT=$P($G(^AUTTIML(X,0)),U,16)
 S:LOT="" LOT=$P($P($G(^AUTTIML(X,0)),U),"*")
 S INA("RXA15",INDA)=$P($G(^AUTTIML(X,0)),U,16)
 S:INA("RXA15",INDA)="" INA("RXA15",INDA)=$P($G(^AUTTIML(X,0)),U)
 Q
 ;=====
 ;
RXA16 ;immunization lot number expiration date
 S INA("RXA16",INDA)=""
 N X,Y,Z
 S X=+$P(X0,U,5)
 Q:'$P($G(^AUTTIML(X,0)),U,9)
 S INA("RXA16",INDA)=$P($G(^AUTTIML(X,0)),U,9)+17000000
 Q
 ;=====
 ;
RXA17 ;immunization manufacturer
 S INA("RXA17",INDA)=""
 N X,Y,Z
 S X=$P(X0,U,5)
 Q:'X
 S X=$P($G(^AUTTIML(X,0)),U,2)
 Q:'X
 S X=$G(^AUTTIMAN(X,0))
 S INA("RXA17",INDA)=$P(X,U,2)_CS_$TR($P(X,U),"&"," ")_CS_"MVX"
 Q
 ;=====
 ;
RXA20 ;completion status
 ;V3.0 PATCH 7 - FID-108411  DEFAULT RXA-20 TO CP
 N X
 S X=$S($P($G(^AUPNVIMM(INDA,0)),U,4)="P":"PA",1:"CP")
 S INA("RXA20",INDA)=X
 ;V3.0 PATCH 7 - FID-108411 END
 Q
 ;=====
 ;
RXA21 ;action code
 ;V3.0 PATCH 6 - FID-75237 IIS CONTRAINDICATION CODES
 N EDIT
 S EDIT="A"
 D:$G(DELX)
 .S EDIT=$P($G(^BIVIMMD(DELX,0)),U,19)
 .S EDIT=$S(EDIT="d":"D",1:"U")
 I $D(^BYIMEXP("D",INDA)),EDIT'="D" S EDIT="U"
 I $G(DELX),EDIT="" S EDIT="D"
 I '$G(DELX),$G(INA("RXA9",INDA)) S EDIT="A"
 S INA("RXA21",INDA)=EDIT
 ;V3.0 PATCH 6 - FID-75237 END
 Q
 ;=====
 ;
RXA22 ;system entry date/time
 S X=$P(X12,U,18)
 S:'X X=$P(V0,U)
 S X=$$TIMEIO^INHUT10(X)
 S INA("RXA22",INDA)=$P(X,"-")
RXAEND Q
 ;=====
 ;
RXR ;EP;
 D RXR^BYIMSEG1
 Q
 ;=====
 ;
QRD ;EP; setup the variables for the QRD segment
 N BYIMDA,BYIMNM,BYIMRN,BYIMASU
 S BYIMDA=$O(INA("QNM",0))
 Q:'BYIMDA
 D QRD1
 D QRD2
 D QRD3
 D QRD4
 D QRD7
 D QRD8
 D QRD9
 D QRD10
 D QRD12
 Q
 ;=====
QRD1 ;
 D NOW^%DTC
 S INA("QRD1")=$P($$TIMEIO^INHUT10(%),"-")
 Q
 ;=====
QRD2 ;
 S INA("QRD2")="R"
 Q
 ;=====
QRD3 ;
 S INA("QRD3")="I"
 Q
 ;=====
QRD4 ;
 S INA("QRD4")=INA("QRD1")_"-"_$P($$HRN^BYIMIMM3(BYIMDA),U)
 Q
 ;=====
QRD7 ;
 S INA("QRD7")="25^RD"
 Q
 ;=====
 ;
QRD8 ;information to build a who string (QRD-8)
 ;support for multiples built in
 N X,Y,Z
 S X=$P($G(^DPT(BYIMDA,0)),U)
 S X=$$PN^INHUT(X)
 S Y=$$HRN^BYIMIMM3(BYIMDA)
 S INA("QRD8")=$P(Y,U)_CS_X
 Q
 ;=====
QRD9 ;
 S INA("QRD9")="VXI"_CS_"VACCINE INFORMATION"_CS_"HL70048"
 Q
 ;=====
QRD10 ;
 S INA("QRD10")=CS_"IIS"
 Q
 ;=====
QRD12 ;
 S INA("QRD12")="T"
QRDEND Q
 ;=====
FHS ;EP;
 D FHS3
 D MSH
 Q
 ;=====
FHS3 ;
 N X
 S X=$P($G(^BYIMPARA($$DUZ^BYIMIMM(),0)),U,7)
 S:X="" X=$P($G(^DIC(4,$$DUZ^BYIMIMM(),0)),U)
 S INA("FSH3")=X
FHSEND Q
 ;=====
 ;
RCP ;setup variables for RCP segment
RCPEND Q
 ;=====
 ;
QPD ;setup variables for QPD segment
QPDEND Q
 ;=====
 ;
VSET(INDA) ;SET VISIT VARIABLES
 I '$G(DELX) S X0=$G(^AUPNVIMM(INDA,0)),X12=$G(^(12)) I 1
 E  S X0=$G(^BIVIMMD(DELX,0)),X12=$G(^(12))
 S VIS=+$P(X0,U,3)
 S Z0=$G(^AUTTIMM(+X0,0))
 S Z1=$G(^AUTTIMM(+X0,1))
 S V0=$G(^AUPNVSIT(VIS,0))
 S V11=$G(^AUPNVSIT(VIS,11))
 S V21=$G(^AUPNVSIT(VIS,21))
 S TYPE=$P(V0,U,7)
 Q
 ;=====
 ;
NPI(PRV) ;
 S NPI=$P($G(^VA(200,+PRV,"NPI")),U)
 Q NPI
 ;=====
 ;
TITLE(P) ;GET PROVIDER'S TITLE/PROVIDER CLASS
 N X,Y,Z
 S X=+$P($G(^VA(200,+$G(P),0)),U,9)
 S X=$P($G(^DIC(3.1,X,0)),U)
 Q X
 ;=====
 ;
PROV(P) ;RETURN PROVIDER COMPONENT INFO
 N X,Y,Z
 S X=$P($G(^VA(200,P,0)),U)
 Q:X="" ""
 S TITLE=$$TITLE(P)
 S NPI=$$NPI(P)
 S Y=$P($P(X,",",2)," ")
 S Z=$P($P(X,",",2)," ",2)
 S X=NPI_CS_$P(X,",")_CS_Y_CS_Z_CS_CS_TITLE_CS_CS_CS_$S(NPI]"":"NPI",1:"")_CS_"L"_CS_CS_CS_$S(NPI]"":"NPI",1:"")
 Q X
 ;=====
 ;
