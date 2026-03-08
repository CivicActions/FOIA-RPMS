APSPESC4 ;IHS/MSC/PLS - SureScripts Refill Request;15-Mar-2021 10:07;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1027,1028**;Sep 23, 2004;Build 50
 Q
 ;
FMTDUELN(DS,DP,AR) ;EP-
 N LINE,HDS,HDP,HAR,BR
 S BR="<br/>"
 S (LINE,HDS,HDP,HAR)=""
 I $L(DS) D
 .S HDS="<span style=""color:blue;font-style:italic;"">Svc: </span>"_DS
 I $L(DP) D
 .S HDP="<span style=""color:blue;font-style:italic;"">Prof: </span>"_DP
 I $L(AR) D
 .S HAR="<span style=""color:blue;"">Comment: </span>"_AR
 ;S LINE=$S($L(HDS):HDS,1:"")_$S($L(HDP):$S($L(HDS):"  "_HDP,1:HDP))
 S LINE=$S($L(HDS):HDS,1:"")
 S LINE=LINE_$S($L(HDP):$S($L(LINE):"  "_HDP,1:HDP),1:"")
 S LINE=LINE_$S($L(HAR):$S($L(LINE):"  "_HAR,1:HAR),1:"")
 Q $S($L(LINE):"<br/><b>"_LINE_"</b>",1:"")
 ; Return Person Class Subset
SPTYCODE(DATA) ;EP-
 D SSPERCLS(.DATA)
 Q
 N LP,IEN
 D GETLST^XPAR(.DATA,"ALL","APSP SS PERSON CLASS SUBSET","I")
 S LP=0 F  S LP=$O(DATA(LP)) Q:'LP  D
 .S IEN=DATA(LP)
 .S $P(DATA(LP),U,2,3)=$$GET1^DIQ(8932.1,IEN,.01)_U_$$GET1^DIQ(8932.1,IEN,6)  ;TERM_X12 Code
 Q
 ; Return list of person codes
SSPERCLS(DATA) ;-
 N C,I,NOD0,DNM,LP,CG
 S LP=0
 S I=0 F  S I=$O(^APSPSSPC(I)) Q:'I  D
 .S NOD0=^APSPSSPC(I,0)
 .I $P(NOD0,U,5),$P(NOD0,U,5)<$$FMADD^XLFDT($$DT^XLFDT(),1) Q  ;Inactive
 .S DNM=$P(NOD0,U,2)
 .S CG=$S($L($P(NOD0,U,4)):$P(NOD0,U,4),1:"Unspecified")
 .I DNM="" S DNM=$P(NOD0,U)
 .;S ARY("C",CG,+$P(^APSPSSPC(I,0),U,3),I)=""
 .S ARY("N",CG,DNM,I)=$P(NOD0,U,6)
 S C="" F  S C=$O(ARY("N",C)) Q:C=""  D
 .S DNM="" F  S DNM=$O(ARY("N",C,DNM)) Q:DNM=""  D
 ..S I=0 F  S I=$O(ARY("N",C,DNM,I)) Q:'I  D
 ...S LP=LP+1
 ...S DATA(LP)=I_U_C_U_DNM_U_ARY("N",C,DNM,I)
 Q
 ; Return state license for user
GETSTLIC(DATA,USR,STATE) ;-
 N SIEN,DAT,LP
 S DATA=""
 S SIEN=$$GSTIEN(STATE)
 Q:'SIEN
 S LP=0
 S LP=$O(^VA(200,USR,"PS1","B",SIEN,LP)) Q:'LP  D  Q:$L(DATA)
 .S DAT=$G(^VA(200,USR,"PS1",LP,0))
 .Q:$P(DAT,U,3)<$$DT^XLFDT()  ;Skip inactive
 .S DATA=$P(DAT,U,2)
 Q
GSTIEN(STATE) ;-
 I $L(STATE)=2 Q $O(^DIC(5,"C",STATE,""))
 I 'STATE Q +$O(^DIC(5,"B",STATE,0))
 E  I $D(^DIC(5,STATE,0)) Q STATE
 Q 0
STATE() ;Get the institution's state
 N STATE
 S STATE=$P($G(^DIC(4,+$$SITE^VASITE(),0)),U,2)
 Q STATE
STDEA(PRV,STATE) ;Get DEA# from state
 N DEA,SIEN
 S DEA=""
 Q:'$G(PRV) DEA
 I '+STATE D
 .S DEA=$$GET1^DIQ(200,PRV,53.2)
 I +STATE D
 .S SIEN=$O(^VA(200,PRV,"PS2","B",STATE,""))
 .I +SIEN D
 ..S DEA=$P($G(^VA(200,PRV,"PS2",SIEN,0)),U,2)
 .E  D
 ..S DEA=$$GET1^DIQ(200,PRV,53.2)
 Q DEA
