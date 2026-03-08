BGOVIMM5 ;IHS/MSC/MGH  BGO - IMMUNIZATION mgt;14-Feb-2023 10:51;PLS
 ;;1.1;BGO COMPONENTS;**27,28,33**;Mar 20, 2007
 ;;IHS/MSC/MGH changes to immunization return
 ;Retrieve all from state registries
STATEPRO(RET,DFN,STATE) ;State data
 N CNT,NAME,DOB,SEX,ST,X1,RSP,ERRCNT
 S CNT=0,ERRCNT=0
 S RET=$$TMPGBL^BGOUTL("PRO")
 I STATE="" S CNT=CNT+1 S @RET@(CNT)="E^No state was sent for processing" Q
 S STATE=$$UPPER(STATE)
 I STATE="CA" D
 .S ST=$O(^DIC(5,"B","CALIFORNIA",""))
 E  S ST=$O(^DIC(5,"C",STATE,""))
 I +ST S ST=$P($G(^DIC(5,ST,0)),U,1)
 E  S ST=STATE
 S NAME=$E($$GET1^DIQ(2,DFN,.01),1,25)
 S DOB=$$GET1^DIQ(2,DFN,.03)
 S AGE=$$GET1^DIQ(2,DFN,.033)
 S SEX=$$GET1^DIQ(2,DFN,.02)
 S HRCN=$$HRCN(DFN,$G(DUZ(2)))
 S X1=27-$L(NAME)
 S NAME=NAME_$$BLANK(X1)
 S CNT=CNT+1
 S @RET@(CNT)="Patient: "_NAME_"DOB: "_DOB_" ("_AGE_")  SEX: "_SEX_" HRCN: "_HRCN
 S CNT=CNT+1 S @RET@(CNT)=""
 S CNT=CNT+1
 S @RET@(CNT)="The State immunization history and forecast are presented for reference"
 S CNT=CNT+1
 S @RET@(CNT)="purposes and may not be identical to information found in RPMS."
 S CNT=CNT+1
 S @RET@(CNT)="Users can refer to State information to identify and update any"
 S CNT=CNT+1
 S @RET@(CNT)="immunizations missing from RPMS, but should always make clinical"
 S CNT=CNT+1
 S @RET@(CNT)="immunization decisions using the RPMS forecaster, which was designed"
 S CNT=CNT+1
 S @RET@(CNT)="in accordance with IHS immunization policy and best practice."
 S CNT=CNT+1
 S CNT=CNT+1,@RET@(CNT)=""
 S RSP=$$RESPONSE^BYIMAPI(DFN,.RSP,ST)
 D ERROR(.RET,DFN,ST,.ERRCNT) ;(Check to see if there is data or an error on this patient)
 I 'ERRCNT D
 .D FORECAST(.RET,DFN,ST,.RSP)
 .D IMMS(.RET,DFN,ST,.RSP)
 Q             ;
FORECAST(RET,DFN,ST,RSP) ;Get forecaster for selected state
 N PIEN,SEL,IMIEN,CNT2,IMM,VGRP,EARLY,SCHED,ARR2,IMDTE,INTDTE,NODE,RDATE,IMMNAME,DOB,DTERR,DTDONE
 Q:ST=""
 S CNT=CNT+1
 S @RET@(CNT)=""
 S CNT=CNT+1
 S @RET@(CNT)="---FORECAST-----------------------------------------------------------"
 S PDTE=9999999,PIEN=0,IMIEN=0,CNT2=0
 S PDTE=$O(RSP(DFN,ST,PDTE),-1) Q:'+PDTE  D
 .S CNT=CNT+1
 .S @RET@(CNT)="State Forecaster for "_ST_" for: "_$$FMTE^XLFDT($$NOW^XLFDT)_" Date run: "_$$FMTE^XLFDT($P(PDTE,".",1))
 .S PIEN=0 F  S PIEN=$O(RSP(DFN,ST,PDTE,"FORECAST",PIEN)) Q:'+PIEN  D
 ..F  S IMIEN=$O(RSP(DFN,ST,PDTE,"FORECAST",PIEN,IMIEN)) Q:'+IMIEN  D
 ...S NODE=$G(RSP(DFN,ST,PDTE,"FORECAST",PIEN,IMIEN))
 ...S IMDTE=$P(NODE,U,5)
 ...S EARLY=$P(NODE,U,4)
 ...S SCHED=$P(NODE,U,8)
 ...S LATE=$P(NODE,U,6)
 ...S CVX=$P(NODE,U,1)
 ...Q:$D(ARR2(CVX))
 ...S ARR2(CVX)=""
 ...I +CVX S CVXIEN=$O(^AUTTIMM("C",CVX,""))
 ...;Group of the state registry
 ...I +CVXIEN D
 ....S IMM=$$GET1^DIQ(9999999.14,CVXIEN,.01,"I")
 ....S IMMNAME=$$GET1^DIQ(9999999.14,CVXIEN,.02)
 ....I IMMNAME="" S IMMNAME=$P(NODE,U,2)
 ...E  S IMMNAME=$P(NODE,U,2)
 ...S X1=14-$L(IMMNAME)
 ...S IMMNAME=IMMNAME_$$BLANK(X1)
 ...S VGRP=$$GET1^DIQ(9999999.14,IMM,.09)
 ...S CNT2=CNT2+1
 ...S SEL=$P(NODE,U,3)
 ...S SEL1=$E(SEL,1,1)
 ...S SEL=$S(SEL1="D":"Due",SEL1="O":"Overdue",SEL1="L":"Future",SEL1="F":"Finished",SEL1="C":"Complete",1:SEL)
 ...S X1=10-$L(SEL)
 ...S SEL=SEL_$$BLANK(X1)
 ...I IMDTE'="" D
 ....I IMDTE'["/" D
 .....S IMDTE=$E(IMDTE,5,6)_"/"_$E(IMDTE,7,8)_"/"_$E(IMDTE,1,4)
 ....E  S IMDTE=$$BLANK(8)
 ...I EARLY'="" D
 ....I EARLY'["/" D
 .....S EARLY=$E(EARLY,5,6)_"/"_$E(EARLY,7,8)_"/"_$E(EARLY,1,4)
 ....E  S EARLY=$$BLANK(8)
 ...I LATE'="" D
 ....I LATE'["/" D
 .....S LATE=$E(LATE,5,6)_"/"_$E(LATE,7,8)_"/"_$E(LATE,1,4)
 ....E  S LATE=$$BLANK(8)
 ...I CNT2=1 D
 ....S CNT=CNT+1
 ....S @RET@(CNT)="Schedule: "_SCHED
 ....S CNT=CNT+1
 ....S @RET@(CNT)=""
 ....S CNT=CNT+1
 ....S @RET@(CNT)=" Imm           Status     Due Date      Earliest Date  Overdue"
 ....S CNT=CNT+1
 ....S @RET@(CNT)=" ---           ------     ----------    -------------  ----------"
 ...S CNT=CNT+1
 ...S @RET@(CNT)=$J(IMMNAME,15)_$J(SEL,11)_$J(IMDTE,10)_$J(EARLY,14)_$J(LATE,14)
 Q
IMMS(RET,DFN,ST,RXP) ;Display the immunizations
 N PIEN,SEL,IMIEN,CNT2,IMM,VGRP,SCHED,ARR2,IMDTE,INTDTE,NODE,RDATE,IMMNAME,DTERR,DTDONE
 N CVX,CVXIEN,IMMDTE,IMMNAME,STATR,STATC,GRP,X1
 Q:ST=""
 S CNT=CNT+1
 S @RET@(CNT)=""
 S CNT=CNT+1
 S @RET@(CNT)="---IMM HISTORY --------------------------------------------------------------"
 S PDTE=9999999,PIEN=0,IMIEN=0,CNT2=0
 S PDTE=$O(RSP(DFN,ST,PDTE),-1) Q:'+PDTE  D
 .S PIEN=0 F  S PIEN=$O(RSP(DFN,ST,PDTE,"IMMS",PIEN)) Q:'+PIEN  D
 ..F  S IMIEN=$O(RSP(DFN,ST,PDTE,"IMMS",PIEN,IMIEN)) Q:'+IMIEN  D
 ...S NODE=$G(RSP(DFN,ST,PDTE,"IMMS",PIEN,IMIEN))
 ...S CNT2=CNT2+1
 ...S CVX=$P(NODE,U,1)
 ...I +CVX D
 ....S CVXIEN=$O(^AUTTIMM("C",+CVX,""))
 ....;Group of the state registry
 ....S GRP=$$GET1^DIQ(9999999.14,CVXIEN,.09)
 ....S X1=3-$L(CVX)
 ....S CVX=CVX_$$BLANK(X1)
 ....S X1=6-$L(GRP)
 ....S GRP=GRP_$$BLANK(X1)
 ...S IMMNAME=$E($P(NODE,U,2),1,14)
 ...S X1=14-$L(IMMNAME)
 ...S IMMNAME=IMMNAME_$$BLANK(X1)
 ...S IMMDTE=$P(NODE,U,3)
 ...I IMMDTE'="" S IMMDTE=$E(IMMDTE,5,6)_"/"_$E(IMMDTE,7,8)_"/"_$E(IMMDTE,1,4)
 ...S STATR=$P(NODE,U,14)
 ...S STATR=$S(STATR="Y":"Valid",STATR="N":"Not Valid",1:"")
 ...S REASON=$P(NODE,U,15)
 ...I REASON'="" S STATR=STATR_"-"_REASON
 ...S STATC=$P(NODE,U,16)
 ...S STATC=$S(STATC="CP":"Complete",STATC="RE":"Refused",STATC="NA":"Not administered",STATC="PA":"Partially administered",1:"")
 ...S X1=16-$L(STATC)
 ...S STATC=STATC_$$BLANK(X1)
 ...I CNT2=1 D
 ....S CNT=CNT+1
 ....S @RET@(CNT)="  Date       CVX     Vaccine       Group     Complete Status   Status Reason"
 ....S CNT=CNT+1
 ....S @RET@(CNT)="----------   ---  --------------   ------    ---------------  ---------------"
 ...S CNT=CNT+1
 ...S @RET@(CNT)=$J(IMMDTE,10)_$J(CVX,6)_$J(IMMNAME,18)_$J(GRP,7)_$J(STATC,16)_$J(STATR,15)
 Q
ERROR(RET,DFN,ST,ERRCNT) ;Check for errors
 N STRING,PIEN,STLIST,X1
 I $P(RSP,U,1)=-1 D
 .S ERRCNT=1,CNT=CNT+1
 .S @RET@(CNT)=$P(RSP,U,2)_" for "_ST Q
 S PIEN=99999999,IMIEN=0,FOUND=0,REGDTE=0
 ;Check for errors on this state first
 S PIEN=9999999
 S PIEN=$O(RSP(DFN,ST,PIEN),-1) Q:'+PIEN  D
 .I $D(RSP(DFN,ST,PIEN,"ERROR"))>0 D
 ..S HL7="" F  S HL7=$O(RSP(DFN,ST,PIEN,"ERROR",HL7)) Q:'+HL7  D
 ...S STR=$G(RSP(DFN,ST,PIEN,"ERROR",HL7))
 ...S CNT=CNT+1
 ...S ERRCNT=ERRCNT+1
 ...S @RET@(CNT)=STR_" for "_ST_". "
 Q
UPPER(DRG) ;Convert lower case to upper case
 Q $TR(DRG,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
BLANK(NOB) ;Add a number of blanks
 N BLANK
 S BLANK="" F I=1:1:NOB S BLANK=BLANK_" "
 Q BLANK
HRCN(DFN,SITE) ;EP; IHS/MSC/MGH return chart number
 Q $P($G(^AUPNPAT(DFN,41,SITE,0)),U,2)
DTERUN(RET,DFN) ;Return the latest date the forecaster ran
 S RET=+$O(^BYIMRT("RSP",DFN,9999999.999),-1)
 S RET=$$FMTE^XLFDT(RET)
 S RET=$P(RET,"@",1)
 I RET=0 S RET="No state data found"
 Q
FOREON(RET) ;Check to see if the state forecaster is on Patch 28 IHS/MSC/MGH
 N IR,LOOK
 S RET=1
 D GETLST^XPAR(.LST,"ALL","BGO IMM REGISTRY ON")
 S IR=0 F  S IR=$O(LST(IR)) Q:'+IR  D
 .S LOOK=$G(LST(IR))
 .I $P(LOOK,U,1)="F"&($P(LOOK,U,2)=0) D
 ..S RET=0
 Q
 ; Get immunization history
 ;  INP = Patient IEN[1]^Record Types[2]
 ;  RET returned as a list of records in one of the following formats:
 ;  For immunizations:
 ;    I^Imm Name[2]^Visit Date[3]^V File IEN[4]^Other Location[5]^Group[6]^Imm IEN[7]^Lot[8]^
 ;     Reaction[9]^VIS Date[10]^Age[11]^Visit Date[12]^Provider IEN~Name[13]^Inj Site[14]^
 ;     Volume[15]^Visit IEN[16]^Visit Category[17]^Full Name[18]^Location IEN~Name[19]^
 ;     Visit Locked[20]^Event Date/Time[21]^Dose Override[22]^VPED IEN[23]^VFC eligibility[24]^
 ;     Manufacturer[25]^Admin Notes[26]^Registry[27]^VIS Date[28]^Ordering Provider IEN[29]
 ;  For forecast:
 ;    F^Imm Name[2]^Status[3]
 ;  For contraindications:
 ;    C^Contra IEN[2]^Imm Name[3]^Reason[4]^Date[5]
 ;  For refusals:
 ;    R^Refusal IEN[2]^Type IEN[3]^Type Name[4]^Item IEN[5]^Item Name[6]^Provider IEN[7]^
 ;     Provider Name[8]^Date[9]^Locked[10]^Reason[11]^Comment[12]
GET(RET,INP) ;EP
 N BIRESULT,DFN,DLM,HX,ELE,CNT,VIEN,DOB,BIPDSS,VIMM,TYPE,P,A,I,J,K,X,V,VFC,ADMIN
 N XREF,FNUM,OFF,BIPDSSA,OR,LOT,LOTIEN,MANUF
 S RET=$$TMPGBL^BGOUTL
 S DFN=+INP,INP=$P(INP,U,2)
 Q:'DFN
 S:INP="" INP="IFCR"
 S BIPDSS=""
 S DLM=$C(31,31),HX="",V="|",CNT=0
 S XREF=$$VFPTXREF^BGOUTL2,OFF=$S($G(DUZ("AG"))="I":0,1:9999999)
 D:INP["F" IMMFORC^BIRPC(.HX,DFN,"","","",.BIPDSS)
 S P=$P(HX,DLM,2),V="|"
 S:'$L(P) P=$P(HX,DLM)
 I $L(P) F I=1:1:$L(P,U) D:$L($P(P,U,I)) ADD("F^"_$P(P,U,I))
 S HX=""
 D:INP["C" CONTRAS^BIRPC5(.HX,DFN)
 S P=$P(HX,DLM,2)
 S:'$L(P) P=$P(HX,DLM)
 I $L(P) F I=1:1:$L(P,U) D:$L($P(P,U,I)) ADD("C^"_$P(P,U,I))
 S HX="",P=1
 ;MSC/MGH - 07/08/09 - Branching for compatibility with Vista and RPMS
 I DUZ("AG")="I" D
 .;IHS/MSC/MGH patch 6 added field 77 VFC
 .;IHS/MSC/MGH patch 10 field 69 aded
 .;IHS/MSC/MGH patch 13 field 85 added
 .F I=4,21,24,36,27,30,33,44,51,57,60,61,67,68,76,35,9,34,0,0,65,77,69,87,90,95 S P=P+1 S:I ELE(I)=P
 .D:INP["I" IMMHX^BIRPC(.HX,DFN,.ELE,0)
 .S P=$P(HX,DLM,2),V="|"
 .I $L(P) D ADD("I^"_P) Q   ; Error
 .S HX=$P(HX,DLM)
 .F I=1:1 S P=$P(HX,U,I) Q:P=""  D
 ..Q:$P(P,V)'="I"
 ..S A="I",J=0,K=1
 ..F  S J=$O(ELE(J)) Q:'J  S K=K+1,$P(A,V,ELE(J))=$P(P,V,K)
 ..S VIMM=+$P(A,V,4),VIEN=$P(A,V,16),TYPE=$P(A,V,7),VFC=$P(A,V,23),OR=$P(A,V,22)
 ..S ADMIN=$P(A,V,25)
 ..S LOT=$P(A,V,8)
 ..S VCX=$P(A,V,20)
 ..S X=$P(A,V,27)
 ..S:$L(X) $P(A,V,29)=X_"~"_$$EXTERNAL^DILFD(9000010.11,1202,,X)
 ..S $P(A,V,28)=$P(A,V,26)
 ..S $P(A,V,26)=""
 ..I LOT'="" D
 ...S LOTIEN=$O(^AUTTIML("B",LOT,""))
 ...S MANUF=$$GET1^DIQ(9999999.41,LOTIEN,.02)
 ...I MANUF'="" S $P(A,V,26)=MANUF
 ..;IHS/MSC/MGH call added for INVALID DOSE
 ..S BIPDSSA=0
 ..I $$PDSS^BIUTL8($P(A,V,4),$P(A,V,24),BIPDSS) D
 ...S Z=$P(A,V,2),BIPDSSA=1
 ...S $P(A,V,2)=Z_"--INVALID SEE IMMSERVE--"
 ..I OR'="" D
 ...S Z=$P(A,V,2)
 ...S OR=$S(OR=1:"INVALID--BAD STORAGE",OR=2:"INVALID--DEFECTIVE",OR=3:"INVALID--EXPIRED",OR=4:"INVALID--ADMIN ERROR",OR=5:"FORCED VALID",1:"@")
 ...S $P(A,V,2)=Z_"-- "_OR
 ...;End patch 10 changes
 ..S:$P(A,V,10)="NO DATE" $P(A,V,10)=""
 ..S X=$P(A,V,14)
 ..S:$L(X) $P(A,V,14)=X_"~"_$$EXTERNAL^DILFD(9000010.11,.09,,X)
 ..D GI1(13,200),GI1(19,9999999.06)
 ..;IHS/MSC/MGH Patch 11 Add leading zero
 ..I $E($P(A,V,15),1,1)="." S $P(A,V,15)="0"_$P(A,V,15)
 ..S $P(A,V,20)=$$ISLOCKED^BEHOENCX(VIEN)
 ..S $P(A,V,21)=$P($G(^AUPNVIMM(VIMM,12)),U)
 ..S $P(A,V,23)=$$FNDPED^BGOVIMM(VIEN,$$IMMCPT^BGOVIMM2(TYPE,VIEN))
 ..;S $P(A,V,24)=$S(VFC=0:"Unknown",VFC=1:"Not Eligible",VFC=2:"Medicaid",VFC=3:"Uninsured",VFC=4:"Am Indian/AK Native",VFC=5:"Federally Qualified",VFC=6:"State-specific Elig",VFC=7:"Local-specific Elig",1:"")
 ..;Next line changed for patch 13
 ..S $P(A,V,24)=$$GET1^DIQ(9002084.83,VFC,.02)
 ..S $P(A,V,27)="RPMS"
 ..D ADD(A)
 E  D
 .N REC,LP,X,Y,Z,FNUM
 .S FNUM=9000010.11,OFF=9999999
 .S LP="" F  S LP=$O(^AUPNVIMM("C",DFN,LP)) Q:'LP  D
 ..S X=$G(^AUPNVIMM(LP,0))
 ..Q:$P(X,U,2)'=DFN
 ..S $P(X,U,8,99)=$P($G(^AUPNVIMM(LP,9999999)),U,8,99)
 ..S Y=$G(^AUTTIMM(+X,0))
 ..Q:'$L(Y)
 ..S VIEN=+$P(X,U,3)
 ..S Z=$G(^AUPNVSIT(VIEN,0))
 ..Q:'$L(Z)
 ..S REC="I"
 ..S REC=REC_U_$P(Y,U,2) ; Imm Short
 ..S REC=REC_U_$$FMTDATE^BGOUTL(+Z)  ; Visit Date
 ..S REC=REC_U_LP   ; V File IEN
 ..S REC=REC_U_$P($G(^AUPNVSIT(VIEN,21)),U)   ; Other Loc
 ..S REC=REC_U_$$GET1^DIQ(FNUM,LP,.09)  ; Group
 ..S REC=REC_U_+X   ; Imm IEN
 ..S REC=REC_U_$$GET1^DIQ(9999999.41,+$P(X,U,5),.01)  ; Lot
 ..S REC=REC_U_$$GET1^DIQ(FNUM,LP,.06)  ; Reaction
 ..S REC=REC_U_$$ENTRY^CIAUDT($P(X,U,12)) ; VIS Date
 ..S DOB=$$GET1^DIQ(2,DFN,.03,"I")
 ..S REC=REC_U_$$GETAGE^BGOVSK(+Z,DOB)  ; Age
 ..S REC=REC_U_$$ENTRY^CIAUDT(+Z,0)  ; Visit Date
 ..S REC=REC_U_$$GI2($P($G(^AUPNVIMM(LP,12)),U,4),200)  ; Provider
 ..S REC=REC_U_$P(X,U,9)_"~"_$$GET1^DIQ(FNUM,LP,.09+OFF)  ; Inj Site
 ..S REC=REC_U_$P(X,U,11)  ; Volume
 ..S REC=REC_U_VIEN   ; Visit IEN
 ..S REC=REC_U_$P(Z,U,7)  ; Visit Cat
 ..S REC=REC_U_$P(Y,U)    ; Full Name
 ..S REC=REC_U_$$GI2($P(Z,U,6),9999999.06)  ; Location
 ..S REC=REC_U_$$ISLOCKED^BEHOENCX(VIEN)  ; Visit Loc
 ..D ADD(REC)
 I INP["R" D
 .N ARRAY,CNT2,Z,STR,SAVE,SAVE2,DATA
 .S CNT2=0,ARRAY="DATA"
 .D REFGET^BGOUTL2(.ARRAY,DFN,9999999.14,.CNT2)
 .S Z=0 F  S Z=$O(@ARRAY@(Z)) Q:Z=""  D
 ..S STR=$G(@ARRAY@(Z))
 ..S SAVE=$P(STR,U,13),SAVE2=$P(STR,U,11)
 ..I SAVE'="" S $P(STR,U,11)=SAVE,$P(STR,U,13)=SAVE2
 ..D ADD(STR)
 Q
 ; Add record to output
ADD(X) S CNT=CNT+1,@RET@(CNT)=$TR(X,"|",U)
 Q
GI1(PC,FN) ;EP
 N X
 S X=+$P(A,V,PC)
 S:X $P(A,V,PC)=X_"~"_$$GET1^DIQ(FN,X,.01)
 Q
GI2(PC,FN) ;EP
 Q $S(PC:PC_"~"_$$GET1^DIQ(FN,PC,.01),1:"")
