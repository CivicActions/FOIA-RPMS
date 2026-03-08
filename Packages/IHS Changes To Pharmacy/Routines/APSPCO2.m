APSPCO2 ; IHS/MSC/MGH - List Manager Complete Orders-Cont ;20-Apr-2023 16:45;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1023,1030,1034**;Sep 23, 2004;Build 37
 ;=================================================================
 ;IHS/MSC/MGH Moved from APSPCO due to size issues
 ; Add patient to array
ADDPT(DFN,INST,ORDCNT,LOCNM) ;EP-
 N LINE,PTLOCK
 ;Exclude patient if LOCFLG enabled and not part of location array list.
 Q:$$NOLOC^APSPCO(DFN)
 S VALMCNT=VALMCNT+1
 D UPDCOL^APSPCO(APSPORPT)
 S LINE=$$SETFLD^VALM1(VALMCNT,"","ITEM")
 S LINE=$$SETFLD^VALM1($$HRN^AUPNPAT(DFN,$S(INST:INST,1:DUZ(2))),LINE,"HRN")
 ;IHS/MSC/MGH added in chk for hardcopy order - p1023
 ;IHS/MSC/PLS - p1034
 ;S LINE=$$SETFLD^VALM1($S($$PTLOCK^APSPCO(DFN):"*",1:"")_$S(HC=1:"+",1:"")_$$GET1^DIQ(2,DFN,.01),LINE,"PATIENT")
 S LINE=$$SETFLD^VALM1($S($$PTLOCK^APSPCO(DFN):"*",1:"")_$S(HC=1:"+",1:"")_$$GETPREF^AUPNSOGI(DFN,"E",1),LINE,"PATIENT")
 S LINE=$$SETFLD^VALM1($$FMTE^XLFDT($$DOB^AUPNPAT(DFN),"5Z"),LINE,"DOB")
 S LINE=$$SETFLD^VALM1(ORDCNT,LINE,"ORDDT")
 S LINE=$$SETFLD^VALM1(LOCNM,LINE,"HOSPLOC")
 D SETARR^APSPCO(VALMCNT,LINE,DFN)
 Q
CONTREF ;-
 W !!!!! D CONTREF1 S VALMBCK=""
 Q
CONTREF1 ;-
 N STOP F  D  Q:$G(STOP)
 .D UPDLST^APSPCO
 .D MSG^VALM10("In continuous update mode: press Q to Quit")
 .N X S X=$$READ^XGKB(1,10) D MSG^VALM10(" ")
 .I '$G(DTOUT),X]"","Qq^^"[X S STOP=1
 .N Y F  R Y:0 Q:'$T
 Q
 ;
TOGORPT ;-Moved here because of space
 N PNM,IEN,PTOCNT,DFN,LD,RI,HC,DRUG,CS,DIG,NOD0,PICKUP
 S PNM=""  ;,LOCFLG=0
 ;Reset LOCFLG on when APSPORPT for patient list
 ;S LOCFLG=$S('APSPORPT:LOCFLG,1:0)
 S (VALMCNT,PTOCNT,DFN)=0
 D CLEAN^VALM10
 ;S APSPSORT="Patient Name"
 S APSPSORT=$S(APSPORPT:"Patient Name",1:"Order Date")
 D UPDCOL^APSPCO(APSPORPT)
 I 'APSPORPT D
 .;D CHGCAP^VALM("ORDDT","Order Date")
 .S LD=0 F  S LD=$O(^PS(52.41,"AD",LD)) Q:'LD  D
 ..S RI=0 F  S RI=$O(^PS(52.41,"AD",LD,RI)) Q:'RI  D
 ...Q:(APSPINS'="*")&(RI'=APSPINS)
 ...S IEN=0 F  S IEN=$O(^PS(52.41,"AD",LD,RI,IEN)) Q:'IEN  D
 ....D:$L($G(^PS(52.41,IEN,0))) ADDITEM^APSPCO(IEN,APSPINS)
 E  D
 .;D CHGCAP^VALM("ORDDT","Order Count")
 .N LOCNM
 .S LOCNM=""
 .F  S PNM=$O(^PS(52.41,"PN",PNM)) Q:PNM=""  D  I PTOCNT>0 D ADDPT^APSPCO(DFN,APSPINS,PTOCNT,LOCNM)
 ..S DFN=0,PTOCNT=0
 ..S IEN=0  F  S IEN=$O(^PS(52.41,"PN",PNM,IEN)) Q:'IEN  D
 ...Q:'$L($G(^PS(52.41,IEN,0)))
 ...Q:(APSPINS'="*")&(+$G(^PS(52.41,IEN,"INI"))'=APSPINS)  ;check institution
 ...Q:"DEDC"[$P($G(^PS(52.41,IEN,0)),U,3)   ;="DC"  ;Discontinued or Discontinued (Edit)
 ...S NOD0=$G(^PS(52.41,IEN,0))
 ...;IHS/MSC/PLS - p1034
 ...S EDT=$$VALUE^ORCSAVE2(+NOD0,"EARLIEST")
 ...Q:+$P(EDT,".")>$$DT^XLFDT()
 ...S PTOCNT=PTOCNT+1
 ...;IHS/MSC/MGH EPCS changes
 ...S DRUG=$P(^PS(52.41,IEN,0),U,9),HC=0
 ...;S NOD0=$G(^PS(52.41,IEN,0))
 ...S PICKUP=$$VALUE^ORCSAVE2(+NOD0,"PICKUP")
 ...I +DRUG D
 ....S CS=$P($G(^PSDRUG(DRUG,0)),U,3)
 ....S DIG=$P(^PS(52.41,IEN,0),U,24)
 ....I +CS>1&(+CS<6)&(+DIG=0)&(PICKUP'="C") S HC=1
 ...;END CHANGES
 ...S LOCNM=$$GET1^DIQ(44,$P(^PS(52.41,IEN,0),U,13),.01)
 ...S:'DFN DFN=$P(^PS(52.41,IEN,0),U,2)
 S VALMBCK="R"
 I 'APSPFRST D
 .D FIRST^VALM4
 .D RE^VALM4
