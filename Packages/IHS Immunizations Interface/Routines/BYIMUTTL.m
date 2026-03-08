BYIMUTTL ;IHS/CIM/THL - IMMUNIZATION DATA EXCHANGE; [ 03/13/2021  11:10 PM ]
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**2**;MAR 15, 2021;Build 493
 ;UTILITY FOR ANALYSIS AND TESTING
 ;
 Q
CV ;EP;CREATE VISIT'S, V IMM'S, QUERIES FOR TESTING
 S BYIMDUZ=$$DUZ^BYIMIMM()
 S ST=$R(10000)
 F JJ=1:100:1000 S DFN=ST+JJ I $G(^DPT(DFN,0))]"",'$D(^DPT(DFN,.35)) D
 .S PIEN(DFN)=""
 .W:'$D(ZTQUEUED) !,DFN
 .D NOW^%DTC
 .S NOW=%
 .S NX=$P(NOW,".")
 .S X=NOW
 .S DIC="^AUPNVSIT("
 .S DIC(0)="L"
 .S DIC("DR")=".02////"_NX_";.03////I;.05////"_DFN_";.06////"_BYIMDUZ_";.07////A;.09////4;.13////"_NX_";.23////"_DUZ
 .D FILE^DICN
 .S VDA=+Y
 .H 4
 .D CI
 H 30
 S QRY=$$QUERY^BYIMAPI(.PIEN,.QRY)
 Q
 ;=====
 ;
CI ;CREATE 4 V IMM ENTRIES FOR EACH PATIENT
 S LX=20,X="" F  S X=$O(^VA(200,"NPI",X)) Q:X=""  S Y=0 F  S Y=$O(^VA(200,"NPI",X,Y)) Q:'Y  S LN=$L($P($G(^VA(200,Y,0)),U)) I LN>LX S LX=LN,PRV=Y
 I '$G(PRV) D
 .S LX=20,X=9999999999 F  S X=$O(^VA(200,X),-1) Q:'X  S LN=$L($P($G(^VA(200,X,0)),U)) I LN>LX S LX=LN,PRV=X
 F X=201,221,301,310 D
 .S LOT=$O(^AUTTIML("C",X,9999999999),-1)
 .S DIC="^AUPNVIMM("
 .S DIC(0)="L"
 .S DIC("DR")=".02////"_DFN_";.03////"_VDA_";.05////"_LOT_";.11////.5;.12////"_NX_";.14////"_$S(X=201:2,X=221:3,X=301:4,1:1)_";.17////"_NX_";1201////"_NX_";1202////"_PRV_";1204////"_PRV_";1216////"_NOW_";1218////"_NOW_";1219////.5"
 .D FILE^DICN
 .S IEN=+Y
 .Q  S I18=$P(^AUTTLOC(BYIMDUZ,0),U,10)_"000"_$E("0000000",1,7-$L(IEN))_IEN
 .S $P(^AUPNVIMM(IEN,0),U,18)=I18
 .S ^AUPNVIMM("ASTID",I18,IEN)=""
 Q
 ;=====
 ;
SEND ;EP;SEND/RE-SEND COVID IMM's
 ;
 ;THIS 'SEND' WILL SEND:
 ;
 ;ALL COVID'S
 ;OR SPECIFIC COVID V IMM'S
 ;AND/OR SPECIFIC PATIENT'S RELATED COVID'S
 ;AND/OR LOC/ASUFAC RELATED COVID'S
 ;AND/OR LOT RELATED COVID'S
 ;
 ;I ^BYIMTMP("SEND")=1 ALL COVID'S WILL BE SENT
 ;
 ;I ^BYIMTMP("SEND","IMM",IMDA)="" THE V IMM WILL BE SENT
 ;
 ;I ^BYIMTMP("SEND","PAT",DFN)="" PATIENT'S COVID V IMM's
 ;  WILL BE SENT
 ;
 ;I ^BYIMTMP("SEND","LOC",LOC IEN)="" LOC. OF ENCOUNTER/ASUFAC
 ;  ASSOCIATED COVID V IMM'S WILL BE SENT
 ;
 ;I ^BYIMTMP("SEND","LOT",LOT IEN)="" LOT ASSOCIATED V IMM WILL BE SENT
 ;
 ;
 Q:'$D(^BYIMTMP("SEND"))
 D NOW^%DTC
 S NOW=%
 ;
 D COVAR
 ;
 ;IF ^BYIMTMP("SEND")=1 SEND ALL COVID's
 ;
 I $G(^BYIMTMP("SEND"))=1 D  Q
 .S IDA=0
 .F  S IDA=$O(COV(IDA)) Q:'IDA  D
 ..S IMDA=0
 ..F  S IMDA=$O(^AUPNVIMM("B",IDA,IMDA)) Q:'IMDA  D SIMM(IMDA)
 ;
 ;SEND COVID's FOR SPECIFIC IDENTIFIED V IMM's
 ;
 I $O(^BYIMTMP("SEND","IMM",0)) D
 .S IMDA=0
 .F  S IMDA=$O(^BYIMTMP("SEND","IMM",IMDA)) Q:'IMDA  D SIMM(IMDA)
 ;
 ;SEND COVID's FOR SPECIFIC PATIENTS
 ;
 I $O(^BYIMTMP("SEND","PAT",0)) D
 .S DFN=0
 .F  S DFN=$O(^BYIMTMP("SEND","PAT",DFN)) Q:'DFN  D
 ..S IMDA=0
 ..F  S IMDA=$O(^AUPNVIMM("AC",DFN,IMDA)) Q:'IMDA  D
 ...Q:'$D(COV(+$G(^AUPNVIMM(IMDA,0))))
 ...D SIMM(IMDA)
 ;
 ;SEND COVID's FOR SPECIFIC LOC. OF ENCOUNTER/ASUFAC
 ;
 I $O(^BYIMTMP("SEND","LOC",0)) D
 .S IDA=0
 .F  S IDA=$O(COV(IDA)) Q:'IDA  D
 ..S IMDA=0
 ..F  S IMDA=$O(^AUPNVIMM("B",IDA,IMDA)) Q:'IMDA  D
 ...S LOC=+$P($G(^AUPNVSIT(+$P($G(^AUPNVIMM(IMDA,0)),U,3),0)),U,6)
 ...Q:'$D(^BYIMTMP("SEND","LOC",LOC))
 ...D SIMM(IMDA)
 ;SEND COVID's FOR SPECIFIC LOT
 ;
 I $O(^BYIMTMP("SEND","LOT",0)) D
 .S IDA=0
 .F  S IDA=$O(COV(IDA)) Q:'IDA  D
 ..S IMDA=0
 ..F  S IMDA=$O(^AUPNVIMM("B",IDA,IMDA)) Q:'IMDA  D
 ...S VDA=+$P($G(^AUPNVIMM(IMDA,0)),U,3)
 ...S LOT=+$P($G(^AUPNVIMM(IMDA,0)),U,5)
 ...Q:'$D(^BYIMTMP("SEND","LOT",LOT))
 ...D SIMM(IMDA)
 Q
 ;=====
 ;
SIMM(IMDA) ;SET 1218 TO 'NOW' FOR V IMM IDENTIFIED AS NEEDING TO BE SENT/RE-SENT
 ;
 D NOW^%DTC
 S NOW=%
 Q:'$$ACT(IMDA)
 S VDA=$P($G(^AUPNVIMM(IMDA,0)),U,3)
 Q:'VDA
 S ^AUPNVSIT("APCIS",$P(NOW,"."),VDA)=""
 S $P(^AUPNVIMM(IMDA,12),U,18)=NOW
 S $P(^AUPNVIMM(IMDA,12),U,19)=.5
 Q
 ;=====
 ;
ACT(IMDA) ;
 ;VDA = AUPNVSIT IEN
 N X,ACT
 S X=0
 S ACT=$P($G(^AUPNVSIT(+$P($G(^AUPNVIMM(IMDA,0)),U,3),0)),U,7)
 I ACT]"","AHIOSR"[ACT S X=1
 Q X
 ;=====
 ;
V1 ;POST INSTALL CALL FOR BYIM UTILITY V1 BUILD
 S $P(^BYIMPARA(+$$DUZ^BYIMIMM,0),U,7)=$P($G(^AUTTLOC(+$$DUZ^BYIMIMM(),1)),U,3)
 K ^BYIMTMP("SEND")
 D RXA114^BYIMCOVD
 D:$O(^BYIMTMP("SEND","LOC",0)) SEND
ZCHK K ^BYIMTMP("CHG","ZIP")
 S VD=DT-(5*10000)
 F  S VD=$O(^AUPNVSIT("B",VD)) Q:'VD  D
 .S VDA=0
 .F  S VDA=$O(^AUPNVSIT("B",VD,VDA)) Q:'VDA  D
 ..S DFN=+$P($G(^AUPNVSIT(VDA,0)),U,5)
 ..Q:'DFN
 ..Q:$P($G(^DPT(DFN,0)),U)=""!$G(^DPT(DFN,.35))
 ..S ZIP=$P($G(^DPT(DFN,.11)),U,6)
 ..S ST=$P($G(^DPT(DFN,.11)),U,5)
 ..I ST<58,ZIP?5N."-".N Q
 ..S ^BYIMTMP("CHG","ZIP",$P(^DPT(DFN,0),U),DFN)=""
 Q
 ;=====
 ;
ZIP ;ADD ZIPS
 D ZCHK
 I $O(^BYIMTMP("CHG","ZIP",""))="" D
 .W !!,"No patients identified with missing ZIP."
 .H 2
 D ZIPE
 Q
 ;=====
 ;
ZIPE ;
 W !!?5,"Add Patient's ZIP:"
 S (QUIT,ZQUIT)=0
 S NM=""
 F  S NM=$O(^BYIMTMP("CHG","ZIP",NM)) Q:NM=""!QUIT  D:'QUIT
 .F  D EZIP Q:ZQUIT
 Q
 ;=====
 ;
EZIP ;EDIT ZIP AND STATE
 S DFN=$O(^BYIMTMP("CHG","ZIP",NM,0))
 I 'DFN S ZQUIT=1 Q
 S ADD=$G(^DPT(DFN,.11))
 D ADD
 D CZIP
 S ADD=$G(^DPT(DFN,.11))
 D ADD
 S DIR(0)="SO^1:Next patient;2:Re-Edit"_NM_";3:Stop ZIP edit"
 S DIR("A")="Which function"
 S DIR("B")="Next patient"
 W !
 D ^DIR
 K DIR
 I Y=1 S ZQUIT=1 K ^BYIMTMP("CHG","ZIP",NM) Q
 I Y=2 G EZIP
 I X[U!(Y=3) S (QUIT,ZQUIT)=1
 Q
 ;=====
 ;
ADD ;DISPLAY ADDRESS
 W !!?5,"PATIENT: ",NM
 W !?5,"Street.: ",$P(ADD,U)
 W !?5,"City...: ",$P(ADD,U,4)
 W !?5,"State..: ",$P($G(^DIC(5,+$P(ADD,U,5),0)),U)
 W !?5,"ZIP....: ",$P(ADD,U,6)
 Q
 ;=====
 ;
IMMID ;EP;TO CHECK FOR MISSING IMM ID'S, FIELD .18
 D NOW^%DTC
 S NOW=%
 D CID
 S IDA=0
 F  S IDA=$O(COV(IDA)) Q:'IDA  D
 .S IMDA=0
 .F  S IMDA=$O(^AUPNVIMM("B",IDA,IMDA)) Q:'IMDA  D
 ..S I0=$G(^AUPNVIMM(IMDA,0))
 ..Q:I0=""
 ..Q:$P(I0,U,18)
 ..D IDSET(IMDA)
 W !!,"Missing UNIQUE immunization ID's have been set for"
 W !,"all COVID V IMMUNIZATION ENTRIES."
 D PAUSE
 Q
 ;=====
 ;
IDSET(IMDA) ;IF IMM ID MISSING FROM .18 CREATE AND SET .18 TO IMM ID
 S X=$P($H,",",2)
 S X=$E("00000",1,5-$L(X))_X
 S X="000"
 S Z=$P($G(^AUTTLOC($$DUZ^BYIMIMM(),0)),U,10)
 S Z=$E("000000",1,6-$L(Z))_Z
 S X=Z_X_$E("0000000",1,7-$L(IMDA))_IMDA
 S $P(^AUPNVIMM(IMDA,0),U,18)=X
 S ^AUPNVIMM("ASTID",X,IMDA)=""
 D SIMM(IMDA)
 S ^BYIMTMP("SEND","IMM",IMDA)=""
 S ^BYIMTMP("CHG","IMM",IMDA,X)=""
 Q
 ;=====
 ;
LOT ;EP;TO CHECK LOT NUMBERS
 D CID
 S QUIT=0
 F  D ELOT Q:QUIT
 S QUIT=0
 Q
 ;=====
 ;
ELOT ;DISPLAY AND EDIT LOTS
 D DLOT
 K DIR
 S DIR(0)="NO^1:"_JJ
 S DIR("A")="Which Number"
 W !
 D ^DIR
 K DIR
 I 'X S QUIT=1 Q
 D EL
 Q
 ;=====
 ;
EL ;EL LOT
 ;S LN=$G(LN(+LN))
 ;Q:LN=""
 S DA=1537 ;S DA=$O(LN(X,""))
 Q:'DA
 S DIE="^AUTTIML("
 S DR=".01LOT NUMBER.....;.02MANUFACTURER...;.04VACCINE........;.09"
 D ^DIE
 Q
 ;=====
 ;
DLOT ;DISPLAY LOTS
 K LN
 I $G(IOF)]"" W @IOF
 W !!?10,"COVID Lot Numbers"
 W !!,"No.",?5,"LOT number",?20,"CVX",?25,"MVX",?30,"Expiration",?42,"External LOT"
 W !,"---",?5,"------------",?20,"---",?25,"---",?30,"----------",?42,"------------"
 S JJ=0
 S LDA=0
 F  S LDA=$O(LOT(LDA)) Q:'LDA  D
 .S JJ=JJ+1
 .S L0=$G(^AUTTIML(LDA,0))
 .Q:L0=""
 .S LOT=$P(L0,U)
 .S IDA=+$P(L0,U,4)
 .S CVX=$P($G(^AUTTIMM(IDA,0)),U,3)
 .S MAN=+$P(L0,U,2)
 .S MVX=$P($G(^AUTTIMAN(MAN,0)),U,2)
 .S EXP=+$P(L0,U,9)
 .I $L(EXP)=7 S EXP=$E(EXP,4,5)_"/"_$E(EXP,6,7)_"/"_($E(EXP,1,3)+1700)
 .E  S EXP=""
 .S XLOT=$P(L0,U,16)
 .W !,JJ
 .W ?5,LOT,?20,CVX,?25,MVX,?30,EXP,?42,XLOT
 .S LN=JJ
 .S $E(LN,5)=LOT
 .S $E(LN,20)=CVX
 .S $E(LN,25)=MVX
 .S $E(LN,30)=EXP
 .S $E(LN,42)=XLOT
 .S LN(JJ)=LN
 .s LN(JJ,LDA)=""
 Q
 ;=====
 ;
CLOTS ;CREATE ARRAY OF COVID LOTS
 S LN="LN"
 F J=1:1 S X=$T(@(LN)+J) Q:X=""  S LOT=$P(X,";;",2) S:LOT]"" COV(LOT)=""
 Q
 ;=====
SLOTS ;CREATE ARRAY OF SITE LOTS
 Q
 ;=====
 ;
UTIL ;EP;USER INTERFACE
 S QUIT=0
 F  D UT1 Q:QUIT
 K QUIT
 Q
 ;=====
 ;
UT1 ;UTIL CHOICES
 I $G(IOF)]"" W @IOF
 W !!?10,"Choose one of the following:"
 K DIR
 S DIR(0)="SO^1:Set 'ASUFAC' codes for the COVID export;2:Evaluate COVID LOT numbers;3:Find and correct Patient's address STATE and ZIP errors;4:Check COVID Immunizations for Unique ID;5:Check Database ID Number"
 S DIR("A")="Which function"
 W !
 D ^DIR
 K DIR
 I X=""!(X["^") S QUIT=1 Q
 I Y=1 D RXA114 Q
 I Y=2 D LOT Q
 I Y=3 D ZIP Q
 I Y=4 D IMMID Q
 I Y=5 D DBID Q
 Q
 ;=====
 ;
PAUSE ;EP;FOR PAUSE READ
 Q:$E($G(IOST),1,2)'="C-"
 W !
 K DIR
 S DIR(0)="E"
 S:'$D(DIR("A")) DIR("A")="Press <ENTER> to continue or '^' to exit..."
 D ^DIR
 K DIR
 S BYIMPAUS=X
 Q
 ;=====
 ;
RXA114 ;RUN RXA114 UPDATE
 D RXA114^BYIMCOVD
 I '$D(ZTQUEUED) D
 .W !!,"ASUFAC update for COVID export files completed and"
 .W !,"Immunization VISIT's with updated ASUFAC information"
 .W !,"have been set to re-export."
 D PAUSE
 Q
 ;=====
 ;
LOTIN ;
 S PATH="c:\users\owner\documents\"
 S FILE="VaccineList.txt"
 K DIR
 S DIR(0)="FO^3:60"
 S DIR("A")="PATH for VaccineList.txt file"
 W !!
 D ^DIR
 Q:X=""!(X[U)
 S PATH=X
 K DIR
 S DIR(0)="FO^3:60"
 S DIR("A")="CDC VIS barcode file name"
 W !!
 D ^DIR
 Q:X=""!(X[U)
 S FILE=X
 S Y=$$OPEN^%ZISH(PATH,FILE,"R")
 Q:Y
 K LOT
 S LINE=0
 F  U IO R X:1 D:X="" CLOSE^%ZISH() Q:X=""  D
 .F J=6,3,7,8,1 S Y=$P(X,$C(9),J)  D:Y]""
 ..S:J=6 LOTX=Y
 ..S:J=3 CVX=Y,DR=".02////"_Y
 ..I J=7 D
 ...I $P(Y,"/"),$P(Y,"/",2),$P(Y,"/",3) D
 ....S EXP=$P(Y,"/",3)-1700
 ....S MON=$S($L(MON)=1:"0",1:"")_$P(Y,"/")
 ....S DAY=$S($L(DAY)=1:"0",1:"")_$P(Y,"/",2)
 ....S EXP=EXP_MON_DAY
 ...E  S EXP=DT+10000
 ...S DR=DR_";.03////"_EXP
 ..I J=8 S MVX=Y,DR=DR_";.04////"_Y
 ..I J=1 S NDC=Y,DR=DR_";.05////"_Y
 .S DIC("DR")=DR
 .S DA=$O(^BYIMLOT("B",X,0))
 .S (DIC,DIE)="^BYIMLOT("
 .I DA D ^DIE Q
 .S DIC(0)="L"
 .S X=LOT
 .D FILE^DICN
 Q
 ;=====
CID ;CREATE LOT ARRAY OF COVID IMMUNIZATION FILE IEN'S
 ;AND V IMM LOT NUMBERS
 D COVAR
 S IDA=0
 F  S IDA=$O(COV(IDA)) Q:'IDA  D
 .S IMDA=0
 .F  S IMDA=$O(^AUPNVIMM("B",IDA,IMDA)) Q:'IMDA  D
 ..S LDA=$P($G(^AUPNVIMM(IMDA,0)),U,5)
 ..S:LDA LOT(LDA)=""
 Q
 ;=====
 ;
CZIP ;CHANGE STATE AND ZIP
 S DR=".115     STATE..;.116     ZIP...."
 S DIE="^DPT("
 S DA=DFN
 W !!
 D ^DIE
 Q
 ;=====
DBID ;CHECK DBID
 I $G(IOF)]"" W @IOF
 S BYIMDUZ=$$DUZ^BYIMIMM()
 W !!?10,"Database ID for: ",$P($G(^DIC(4,BYIMDUZ,0)),U)
 S DBID=$P($G(^AUTTLOC(BYIMDUZ,1)),U,3)
 W !?10,"Database ID....: ",DBID
 W !!,"If the Database ID is blank or wrong, please notify IT"
 D PAUSE
 Q
 ;=====
 ;
COVAR ;SET COM ARRAY OF COVID IMMUNIZATION IEN's
 ;
 S IDA=309
 F  S IDA=$O(^AUTTIMM(IDA)) Q:'IDA  D:$P($G(^(IDA,0)),U)["COVID"
 .S COV(IDA)=""
 Q
 ;=====
 ;
