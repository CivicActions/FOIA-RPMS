BTIULO12 ;IHS/MSC/JSM - IHS OBJECTS ADDED IN PATCHES ;13-Feb-2025 13:24
 ;;1.0;TEXT INTEGRATION UTILITIES;**1006,1009,1010,1012,1016,1029,1030**;NOV 10, 2004;Build 40
 ; IHS/MSC/JSM updated GETORD to update HOLD status to BEHORX LABEL HOLD STATUS XPAR (Feature 106931)
 ;              and add legend to end of list at TMORDER
 ; IHS/MSC/MIR 02/13/2025 added STHOLD in TORDER+1, TORDER+11, GETORD+22 (Feature 119124 p1030)
TORDER(DFN,TARGET) ;EP Orders for today
 NEW X,I,CNT,RESULT,STHOLD S STHOLD=0
 S CNT=0
 D GETORD(.RESULT,DFN)
 K @TARGET
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .I $G(RESULT(I))'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Orders."
 ;IHS/MSC/JSM p1029 Added next line if there are orders to display
 E  I STHOLD S @TARGET@(CNT+1,0)=" ",@TARGET@(CNT+2,0)="(*) behind the status of the medication indicates pharmacy may be contacted about available fills of this medication"
 Q "~@"_$NA(@TARGET)
GETORD(RETURN,DFN) ;Get list of orders
 K RETURN
 NEW VDT,END,ORLIST,ORD,HDR,HLF,LOC,X,Y,C,ORDER,OLDOR,NEWORD,HOLDSTTS
 S C=0,OLDOR=0
 K ^TMP("ORR",$J)
 ;Get all orders for today
 S VDT=DT,END=VDT_".2359"
 I '$L($T(EN^ORQ1)) Q
 D EN^ORQ1(DFN_";DPT(",1,2,"",VDT,END,1)
 I '$D(ORLIST) S RETURN(1)="" Q
 F X=0:0 S X=$O(^TMP("ORR",$J,ORLIST,X)) Q:'X  K ORD M ORD=^(X) D
 . S Y=$P($G(^OR(100,+ORD,0)),U,10)
 . I $P(ORD,U,7)="canc" Q
 . S ORDER=+ORD
 . Q:ORDER=OLDOR
 . S OLDOR=ORDER
 . S C=C+1
 . F Y=0:0 S Y=$O(ORD("TX",Y)) Q:'Y  D
 .. I $E(ORD("TX",Y),1)="<" Q
 .. I $E(ORD("TX",Y),1,4)="Hold" D  ;IHS/MSC/JSM Added XPAR setting for Hold p1029
 ... S HOLDSTTS=$$GET^XPAR("ALL","BEHORX LABEL HOLD STATUS",,"E")_"*"
 ... S:HOLDSTTS="*" HOLDSTTS="Active*"
 ... S ORD("TX",Y)=HOLDSTTS_$E(ORD("TX",Y),5,999),STHOLD=1  ; MIR added STHOLD Feature 119124
 .. ;I $E(ORD("TX",Y),1,6)="Change" Q
 .. I $E(ORD("TX",Y),1,6)="Change" S ORD("TX",Y)=$E(ORD("TX",Y),8,999)
 .. ;I $E(ORD("TX",Y),1,3)="to " Q
 .. I $E(ORD("TX",Y),1,3)="to " D
 ... K RETURN(C)
 ... S NEWORD=$E(ORD("TX",Y),4,999)
 ... S RETURN(C)="  "_NEWORD
 .. E  S RETURN(C)=$G(RETURN(C))_"  "_$P(ORD("TX",Y)," Quantity:")
 I C=0 S RETURN(1)=""
 K ^TMP("ORR",$J)
 Q
ORDTYPE(DFN,TARGET,TYPE) ;EP Orders for today depending on the type
 NEW X,I,CNT,RESULT
 S CNT=0
 D GETORD2(.RESULT,DFN,TYPE)
 K @TARGET
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .I $G(RESULT(I))'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Orders."
 Q "~@"_$NA(@TARGET)
GETORD2(RETURN,DFN,TYPE) ;Get list of orders
 K RETURN
 NEW VDT,END,ORLIST,ORD,HDR,HLF,LOC,X,Y,C,ORACT,ACT,NATURE,CODE
 S C=0
 K ^TMP("ORR",$J)
 ;Get all orders for today
 S VDT=DT,END=VDT_".2359"
 I '$L($T(EN^ORQ1)) Q
 D EN^ORQ1(DFN_";DPT(",1,2,"",VDT,END,1)
 I '$D(ORLIST) S RETURN(1)="" Q
 F X=0:0 S X=$O(^TMP("ORR",$J,ORLIST,X)) Q:'X  K ORD M ORD=^(X) D
 . S CODE=""
 . S Y=$P($G(^OR(100,+ORD,0)),U,10)
 . I $P(ORD,U,7)="canc" Q
 . S ORACT=$P($P(ORD,U,1),";",2)
 . S ACT=$G(^OR(100,+ORD,8,ORACT,0))
 . S NATURE=$P(ACT,U,12)
 . I NATURE'="" S CODE=$P($G(^ORD(100.02,NATURE,0)),U,2)
 . Q:CODE'=TYPE
 .F Y=0:0 S Y=$O(ORD("TX",Y)) Q:'Y  D
 .. I $E(ORD("TX",Y),1)="<" Q
 .. I $E(ORD("TX",Y),1,6)="Change" Q
 .. I $E(ORD("TX",Y),1,3)="to " S ORD("TX",Y)=$E(ORD("TX",Y),4,999)   ;I
 .. S C=C+1
 .. S RETURN(C)=$G(RETURN(C))_"  "_$P(ORD("TX",Y)," Quantity:")
 I C=0 S RETURN(1)=""
 K ^TMP("ORR",$J)
 Q
PRELAN(DFN) ;Preferred language
 N PRILAN,PRETER,PREFLAN,PROF,LANDT,IEN
 S PREFLAN="Not recorded"
 S LANDT=9999999 S LANDT=$O(^AUPNPAT(DFN,86,LANDT),-1)
 Q:LANDT="" PREFLAN
 S IEN=LANDT_","_DFN
 S PREFLAN=$$GET1^DIQ(9000001.86,IEN,.04)
 Q PREFLAN
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
 ;IHS/MSC/MGH Added patch 1010
PHN(DFN,TARGET,NUM) ;Return PHN data
 N CNT,CT,VDT,PHN,VPHN,FNUM,LONG,LVL,NSG,PSYCH,REC,SHORT,VDATE
 S CT=0,CNT=0,PHN=""
 S NUM=NUM-1
 I NUM="" S NUM=1
 S FNUM=9000010.32
 F  S PHN=$O(^AUPNVPHN("AA",DFN,PHN)) Q:PHN=""  D
 .S VDT=0
 .F  S VDT=$O(^AUPNVPHN("AA",DFN,PHN,VDT)) Q:'VDT  D
 ..S VPHN=""
 ..F  S VPHN=$O(^AUPNVPHN("AA",DFN,PHN,VDT,VPHN)) Q:'VPHN!(CNT>NUM)  D
 ...S REC=$G(^AUPNVPHN(VPHN,0))
 ...S CNT=CNT+1
 ...S LVL=$$GET1^DIQ(FNUM,VPHN,.05)
 ...S TYPE=$$GET1^DIQ(FNUM,VPHN,.06)
 ...S PSYCH=$G(^AUPNVPHN(VPHN,21))
 ...S NSG=$G(^AUPNVPHN(VPHN,22))
 ...S SHORT=$G(^AUPNVPHN(VPHN,23))
 ...S LONG=$G(^AUPNVPHN(VPHN,24))
 ...S VDATE=9999999-VDT
 ...S VDATE=$$FMTDATE^BGOUTL(VDATE)
 ...I CNT>1 D
 ....S CT=CT+1
 ....S @TARGET@(CT,0)=""
 ...S CT=CT+1
 ...S @TARGET@(CT,0)="Visit Date: "_VDATE
 ...I LVL'="" D
 ....S CT=CT+1
 ....S @TARGET@(CT,0)="Level of Intervention: "_LVL
 ...I TYPE'="" D
 ....S CT=CT+1
 ....S @TARGET@(CT,0)="Type of Decision Making: "_TYPE
 ...I PSYCH'="" D
 ....S CT=CT+1
 ....S @TARGET@(CT,0)="Psycho/Social/Envron: "_PSYCH
 ...I NSG'="" D
 ....S CT=CT+1
 ....S @TARGET@(CT,0)="Nursing DX: "_NSG
 ...I SHORT'="" D
 ....S CT=CT+1
 ....S @TARGET@(CT,0)="Short Term Goals: "_SHORT
 ...I LONG'="" D
 ....S CT=CT+1
 ....S @TARGET@(CT,0)="Long Term Goals: "_LONG
 I CT=0 S @TARGET@(1,0)="No PHNs for this patient."
 Q "~@"_$NA(@TARGET)
 ;New object for current PHN Patch 1016
VPHN(DFN,TARGET) ;Return PHN for the visit context patch 1016
 N X,VST,VDT,CNT,RESULT,PHN,FNUM,LONG,LVL,NSG,PSYCH,REC,SHORT,VDATE
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 S CNT=0
 S FNUM=9000010.32
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S PHN="" F  S PHN=$O(^AUPNVPHN("AD",VST,PHN)) Q:PHN=""  D
 .S REC=$G(^AUPNVPHN(PHN,0))
 .S LVL=$$GET1^DIQ(FNUM,PHN,.05)
 .S TYPE=$$GET1^DIQ(FNUM,PHN,.06)
 .S PSYCH=$G(^AUPNVPHN(PHN,21))
 .S NSG=$G(^AUPNVPHN(PHN,22))
 .S SHORT=$G(^AUPNVPHN(PHN,23))
 .S LONG=$G(^AUPNVPHN(PHN,24))
 .S VDATE=$$GET1^DIQ(9000010.32,PHN,.03)
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)="Visit Date: "_VDATE
 .I LVL'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)="Level of Intervention: "_LVL
 .I TYPE'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)="Type of Decision Making: "_TYPE
 .I PSYCH'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)="Psycho/Social/Envron: "_PSYCH
 .I NSG'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)="Nursing DX: "_NSG
 .I SHORT'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)="Short Term Goals: "_SHORT
 .I LONG'="" D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)="Long Term Goals: "_LONG
 I CNT=0 S @TARGET@(1,0)="No PHN for this visit."
 Q "~@"_$NA(@TARGET)
