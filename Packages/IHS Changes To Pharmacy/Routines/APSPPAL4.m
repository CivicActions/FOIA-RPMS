APSPPAL4 ;IHS/MSC/PLS - Pickup Activity Log Support ;21-Feb-2025 08:58;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1035**;Sep 23, 2004;Build 39
 ;FID 99319
EN(APSPPKRX,APSPPKIE) ; -- main entry point for APSP PICKUP LOG EDIT
 N APSIENS
 S APSIENS=APSPPKIE_","_APSPPKRX_","
 D EN^VALM("APSP PICKUP LOG EDIT")
 Q
 ;
HDR ; -- header code
 K VALMHDR
 S VALMHDR(1)=$$GETPREF^AUPNSOGI(DFN,"E",1)
 S VALMHDR(2)="Rx #: "_$P($G(RX),U,2)
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=$$BLDLST(APSPPKRX,APSPPKIE)
 Q
 ;
BLDLST(RX,PKIEN) ;-
 N IENS,DATA,MSG,PHN
 K @VALMAR
 S IENS=PKIEN_","_RX_","
 D GETS^DIQ(52.999999951,IENS,"**","IE","DATA","MSG")
 N LN
 S LN=0
 D SETARR($$LN()," (1) Pickup Date/Time: "_$$GETVAL(.01,"E"),0)
 D SETARR($$LN(),"     Rx Fill Ref: "_$$GETVAL(.02,"E")_"            Dispense Type: "_$$GETVAL(.03,"E"),0)
 D SETARR($$LN(),"         Person Type: "_$$GETVAL(.04,"E"),0)
 D SETARR($$LN()," (2)    ID Qualifier: "_$$GETVAL(.07,"E"),0)
 D SETARR($$LN()," (3) ID Jurisdiction: "_$$GETVAL(.06,"E"),0)
 D SETARR($$LN()," (4)       ID Number: "_$$GETVAL(.08,"E"),0)
 D SETARR($$LN(),"** Pickup Person Information **",0)
 D SETARR($$LN()," (5)    Relationship: "_$$GETVAL(.05,"E")_"     (6) DOB: "_$$GETVAL(2.03,"E"),0)
 D SETARR($$LN()," (7)      First Name: "_$$GETVAL(2.02,"E"),0)
 D SETARR($$LN(),"           Last Name: "_$$GETVAL(2.01,"E"),0)
 D SETARR($$LN()," (8)       Address 1: "_$$GETVAL(3.01,"E"),0)
 D SETARR($$LN(),"           Address 2: "_$$GETVAL(3.02,"E"),0)
 D SETARR($$LN(),"                City: "_$$GETVAL(4.01,"E"),0)
 D SETARR($$LN(),"               State: "_$$GETVAL(4.02,"E"),0)
 D SETARR($$LN(),"                 ZIP: "_$$GETVAL(4.03,"E"),0)
 S PHN=$$GETVAL(4.04,"E")
 S PHN=$S($L(PHN):$E(PHN,1,3)_"-"_$E(PHN,4,6)_"-"_$E(PHN,7,10),1:"")
 D SETARR($$LN()," (9)    Phone Number: "_PHN,0)
 Q LN
 ;
LN() S LN=LN+1
 Q LN
 ;
GETVAL(FLD,FLG) ;
 Q $G(DATA(52.999999951,IENS,FLD,FLG))
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 S VALMBCK="Q" Q
 ;
EXPND ; -- expand code
 Q
 ;
 ; Set line into array
SETARR(LINE,TEXT,IEN) ;EP-
 S @VALMAR@(LINE,0)=TEXT
 S:$G(IEN) @VALMAR@("IDX",LINE,LINE)=""
 S @VALMAR@(LINE,"PKPIEN")=LINE_U_IEN
 Q
 ;
SELFLD ;
 N DIRUT,DUOUT,DTOUT,DIR,IENS,DA,DIE
 S IENS=APSIENS
 S DA=+IENS,DA(1)=$P(IENS,",",2)
 S DIE="^PSRX("_DA(1)_",""ZPAL"","
 S DIR("A")="Select Field(s) to Edit by number"
 S DIR(0)="LO^1:9" D ^DIR
 Q:$D(DTOUT)!($D(DUOUT))!($D(DIRUT))
EDTSEL N LST,FLD,OUT,UPDATE D KV S OUT=0,UPDATE=0
 I +Y S LST=Y D FULL^VALM1 D  ;G DSPL
 .F FLD=1:1:$L(LST,",") Q:$P(LST,",",FLD)']""!(OUT)  N Y D @(+$P(LST,",",FLD)) D CHKOUT
 E  S VALMBCK="" Q
 ;
DSPL D INIT
 S VALMSG=$S(UPDATE:"Record Updated.",1:"")
 S VALMBCK="R" Q
 ;
CHKOUT ;
 I $D(DIRUT)!($D(DUOUT))!($D(DTOUT))!($D(Y)) S OUT=1
 E  I $G(X)'=U S UPDATE=1
 D KV
 Q
KV ;
 K DIRUT,DUOUT,DTOUT,DIR
 Q
 ;
1 ;
 D KV
 N %DT,DIR,EDT
 N RXN
 S RXN=+$P(IENS,",",2)
 ;S DR=".01"
 ;D ^DIE
 ;S %DT="AERXTP"
 ;S %DT("B")=$$GETFLD(.01,"E")
 ;S %DT("-NOW")
 ;D ^%DT
 ;I Y>0
 S EDT=$$GEDTFDP(IENS)  ;Get earliest date for selected dispense
 S DA=+IENS
 S DIR("?",1)="   Enter value using MO/DD/YEAR@TIME format"
 S DIR("?",2)="  "
 S DIR("?",3)="   Enter a time which is less than or equal to <NOW>,"
 S DIR("?",4)="   equal to or greater than the Fill Date of the"
 S DIR("?")="   selected dispense("_$$FMTE^XLFDT(EDT,"5Z")_")"_"."
 S DIR("A")="Pickup Date/Time"
 S DIR("B")=$$GET1^DIQ(52.999999951,IENS,.01)
 S DIR(0)="D^"_EDT_":NOW:EXPR"
 D ^DIR
 I Y D
 .N FDA,MSG
 .S FDA(52.999999951,IENS,.01)=Y
 .D FILE^DIE("K","FDA","MSG")
 .I '$D(MSG) S UPDATE=1
 K Y
 Q
X2 ;
 D KV
 S DR=".02"
 D ^DIE
 Q
X3 ;
 D KV
 S DR=".03"
 D ^DIE
 Q
X4 ;
 D KV
 S DR=".04"
 D ^DIE
 Q
2 ;
 D KV
 S DR=".07R"
 D ^DIE
 Q
3 ;
 D KV
 S DR=".06R"
 D ^DIE
 Q
4 ;
 D KV
 S DR=".08R"
 D ^DIE
 Q
5 ;
 D KV
 S DR=".05"
 D ^DIE
 Q
6 ;
 D KV
 S DR="2.03"
 D ^DIE
 Q
7 ;
 D KV
 S DR="2.01;2.02"
 D ^DIE
 Q
8 ;
 D KV
 S DR="3.01;3.02;4.01;4.02;4.03"
 D ^DIE
 Q
9 ;
 D KV
 S DR="4.04"
 D ^DIE
 Q
 ;Return Earliest Date for a given dispense
GEDTFDP(IENS) ;
 N DAT,MSG,DSP,RES,RXN,OFDT
 S RXN=+$P(IENS,",",2)
 D GETS^DIQ(52.999999951,IENS,"**","I","DAT","MSG")
 S OFDT=$$GET1^DIQ(52,RXN,22,"I")
 S DSP=$G(DAT(52.999999951,IENS,.02,"I"))
 I 'DSP D
 .S RES=$$GET1^DIQ(52,RXN,22,"I")  ;Prescription Fill Date
 E  D
 .S RES=$$GET1^DIQ(52.1,DSP_","_RXN_",",.01,"I")
 S:RES="" RES=OFDT
 Q RES
