APSPLIQ ;IHS/MSC/MGH - Liquids with metric units;22-Mar-2023 10:51;DU
 ;;7.0;OUTPATIENT PHARMACY;**1025,1026,1027,1033**;DEC 1997;Build 34
 ;Return only valid dosages when drug lookup is done
LIQUID(POI) ;Check to see if drug is a liquid
 N LIQ,FORM
 S LIQ=0
 S FORM=$P($G(^PS(50.7,POI,0)),U,2)
 I +FORM S LIQ=$P($G(^PS(50.606,FORM,9999999)),U,2)
 Q LIQ
 ;Check to see if the units are in the liquid dose parameter
UNITCHK(UNITS,PAR) ;EP
 N LIST,UNIEN,CNT,FOUND
 S FOUND=0
 D GETLST^XPAR(.LIST,"ALL",PAR)
 I +UNITS S UNITS=$P($G(^PS(51.24,UNITS,0)),U,1)
 S CNT=0 F  S CNT=$O(LIST(CNT)) Q:CNT=""!(FOUND=1)  D
 .S LIEN=$P($G(LIST(CNT)),U,2)
 .I LIEN=UNITS S FOUND=1
 Q FOUND
 ;Parse the text sent in
PARSE(TEXT) ;EP Parse the text looking for drug units
 N OK,LEN,PIECE,SEQ,GOOD,BAD,CHAR,PIECE2,PART,X1,X2,STR,UNIT,UNIT2
 S (GOOD,BAD)=0
 S OK=0
 S TEXT=$$UPPER^APSPES5(TEXT)  ;CONVERT TO UPPER CASE
 Q:TEXT="SEE SIG" OK
 S TEXT=$TR(TEXT,",","")  ;remove commas
 S TEXT=$TR(TEXT,"("," ")
 S TEXT=$TR(TEXT,")"," ")
 S PIECE=$L(TEXT," ")    ;Find how many pieces there are
 F X1=1:1:PIECE S PART=$P(TEXT," ",X1) D
 .;Check each piece to see if it has a dash in it.
 .S (UNIT,UNIT2)=0
 .;S PIECE2=$L(PART,"/")  ;Check for special characters in the units
 .;I PIECE2>1 S BAD=1
 .;S PIECE2=$L(PART,"(")
 .;I PIECE2>1 S BAD=1
 .;F X2=1:1:PIECE2 S DASH=$P(PART,"/",X2) D
 .;Now go character by character looking for non-numeric
 .S STR=""
 .F CNT=1:1:$L(PART) D
 ..S CHAR=$E(PART,CNT,CNT)
 ..I '+CHAR&(CHAR'=0)&(CHAR'=".")  S STR=STR_CHAR
 .S UNIT=$$UNITCHK(STR,"APSP LIQUID METRIC UNITS")
 .I UNIT=1 S GOOD=1
 .S UNIT2=$$UNITCHK(STR,"APSP RESTRICTED LIQUID TERMS")
 .I UNIT2=1 S BAD=1
 I GOOD=1&(BAD=0) S OK=0
 I BAD=1 S OK=1
 I BAD=0&(GOOD=0) S OK=2
 Q OK
CHKLIQ(RET,OI,TEXT,IO) ;RPC call to return liquid data
 N ORWPSOI,ORLIQ,DG
 S RET=0
 S IO=+$G(IO)
 S DG=$S('IO:"OUTPATIENT MEDICATIONS",1:$P($G(^ORD(100.98,IO,0)),U,1))
 I DG="OUTPATIENT MEDICATIONS" D
 .S ORWPSOI=+$P($G(^ORD(101.43,+OI,0)),U,2)
 .S ORLIQ=$$LIQUID^APSPLIQ(ORWPSOI)
 .I +ORLIQ S RET=$$PARSE(TEXT)
 Q
ZEROS(RET,TEXT) ;Return if there are leading or trailing zeros that should not be there
 N CNT,CNT2,DIGIT,PRE,POST,ZERO,PERIOD,PIECE,PART,X1
 K RET
 S RET=0,ERR=0,CNT2=0
 S TEXT=$$UPPER^APSPES5(TEXT)  ;CONVERT TO UPPER CASE
 ;S PIECE=$L(TEXT," ")    ;Find how many pieces there are
 ;F X1=1:1:PIECE S PART=$P(TEXT," ",X1) D
 S (PRE,POST,PERIOD)=""
 S CNT2=0
 S ZERO=0
 F CNT=1:1:$L(TEXT) D
 .S DIGIT=$E(TEXT,CNT,CNT)
 .I +DIGIT!(DIGIT="0")!(DIGIT=".")!(DIGIT=",") D
 ..S CNT2=CNT2+1
 ..I CNT2=1&(DIGIT="0") S ZERO=1
 ..I CNT2=1&(DIGIT=".") S ERR=ERR+1 S RET(ERR)="A fractional number '"_TEXT_"' must have a number to the left of the decimal."
 ..I ZERO=1&(CNT2=2)&(DIGIT'=".") D
 ...S ERR=ERR+1 S RET(ERR)="A number '"_TEXT_"' may not lead with a zero unless it is immediately followed"
 ...S ERR=ERR+1 S RET(ERR)=" by a decimal point."
 ..I DIGIT="." S PERIOD=1  ;Q
 ..I PERIOD="" S PRE=PRE_DIGIT
 ..E  I +PERIOD S POST=POST_DIGIT
 .E  D
 ..I POST'="" D
 ...I $E(POST,$L(POST),$L(POST))="0" S ERR=ERR+1 S RET(ERR)="A fractional number '"_TEXT_"' may not have a trailing zero"
 ..S (PRE,POST,PERIOD,ZERO)=""
 ..S CNT2=0
 I POST'="" D
 .I $E(POST,$L(POST),$L(POST))="0" S ERR=ERR+1 S RET(ERR)="A fractional number '"_TEXT_"' may not have a trailing zero"
 .E  I $E(POST,$L(POST))="." S ERR=ERR+1 S RET(ERR)="A fractional number '"_TEXT_"' may not end with a period"
 Q
IVSOL(X) ;Input transform on IV solution
 N GOOD,ERR,LOOP
 S GOOD=1
 K:X[""""!($A(X)=45)!(X'?.N0.1".".N)!(X>9999)!(X<.01) X
 I $G(X) D
 .D ZEROS(.ERR,X)
 .I $D(ERR)>1 D
 ..S GOOD=0
 ..N LOOP S LOOP=""
 ..F  S LOOP=$O(ERR(LOOP)) Q:'+LOOP  W !,$G(ERR(LOOP))
 ..K X
 .E  D
 ..S X=X_"ML"
 ..D EN^DDIOL(" ML","","?0")
 Q
 ;
SYRSIZE ;Input transform on Syringe Size (53.1/Syringe Size)
 N ERR,LP,LP1,LST,VAL,MSG,MCNT  ;,GOOD
 ;S GOOD=1,
 Q:'$D(X)
 S MCNT=0
 K:$L(X)>100!($L(X)<1) X
 I $L($G(X)) D
 .D FNUM(.LST,X)
 .S LP1=0 F  S LP1=$O(LST(LP1)) Q:'LP1  D
 ..D ZEROS(.ERR,LST(LP1))
 ..I $D(ERR) D
 ...S LP=0 F  S LP=$O(ERR(LP)) Q:'LP  D
 ....S MCNT=MCNT+1,MSG(MCNT)=ERR(LP)
 .I $D(MSG)>1 D
 ..;S GOOD=0
 ..N LP S LP=""
 ..F  S LP=$O(MSG(LP)) Q:'LP  W !,$G(MSG(LP))
 ..K X
 Q
 ;
ISNCHAR(X) ;Check character
 Q $S(X?.N!(X="."):1,1:0)
 ;
FNUM(ARY,X) ;Build array of numbers from string
 N I,L,S,V,C,LP
 S V=X,S=""
 S L=$L(X)
 F I=1:1:L D
 .S C=$E(V,I)
 .I $$ISNCHAR(C) S S=S_C
 .E  I $L(S) D ADD(S) S S=""
 I $L(S) D ADD(S)
 Q
ADD(VAL) ;Add to array
 S LP=$G(LP)+1
 S ARY(LP)=VAL
 Q
