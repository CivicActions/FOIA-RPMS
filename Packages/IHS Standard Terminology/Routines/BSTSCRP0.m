BSTSCRP0 ;GDIT/HS/BEE-SNOMED Concept export/report - Cont ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**4**;Dec 01, 2016;Build 10
 ;
 ;GDIT/HS/BEE;01/06/2023;FEATURE#86636;Reports For Comparison of BSTS Subsets to DTS subsets
 ;New reports for patch 4
 ;
 ;*Using direct global references where possible to speed up compile time
 ;
CCOMP(RANGE,CGBL,TMAX) ;Compile Concept report data
 ;
 NEW BEG,END,CONCID,QUIT,CIEN,REC,X,CCNT,NODE0
 ;
 ;Establish begin and end
 I RANGE="ALL" S BEG="",END=""
 E  S BEG=$P(RANGE,U)-1,END=$P(RANGE,U,2)
 ;
 ;Loop through all SNOMED concepts in range
 S TMAX=0,CCNT=0
 S CONCID=BEG,QUIT=0 F  S CONCID=$O(^BSTS(9002318.4,"C",36,CONCID)) D  Q:QUIT
 . I CONCID="" S QUIT=1 Q
 . I END,CONCID>END S QUIT=1 Q
 . I CCNT#1000=0 U 0 W "."
 . ;
 . NEW TRMARY,TCNT,PRE,FSN,INT
 . ;
 . ;Now loop through term IENs
 . S TCNT=0
 . S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"C",36,CONCID,CIEN)) Q:CIEN=""  D
 .. ;
 .. ;Concept identified - Concept ID
 .. S NODE0=$G(^BSTS(9002318.4,CIEN,0))
 .. S REC=$P(NODE0,U,2)
 .. ;
 .. ;Status
 .. S X=+$P(NODE0,U,16)
 .. S $P(REC,U,2)=$S(X:"I",1:"A")
 .. ;
 .. ;Loop through terms
 .. S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"C",36,CIEN,TIEN),-1) Q:TIEN=""  D
 ... ;
 ... ;Get term information
 ... S NODE0=$G(^BSTS(9002318.3,TIEN,0))
 ... S DESCID=$P(NODE0,U,2) Q:DESCID=""
 ... S TYPE=$P(NODE0,U,9) Q:TYPE=""
 ... S IT=$P(NODE0,U,12)
 ... S TERM=$P($G(^BSTS(9002318.3,TIEN,1)),U)
 ... S TACT=$P(NODE0,U,13)
 ... ;
 ... ;First log interface term
 ... I IT D
 .... ;
 .... ;If the first one, save and quit
 .... I '$D(INT) D  Q
 ..... S INT("TERM")=TERM
 ..... S INT("DESCID")=DESCID
 ..... S INT("TACT")=TACT
 .... ;
 .... ;One already on file, if inactive and new is active, make new interface term
 .... ;and current in terms array
 .... I TACT=0,$G(INT("TACT"))=1 D  Q
 ..... S TRMARY($G(INT("DESCID")),"I")=$G(INT("TERM"))_U_$S($G(INT("TACT")):"I",1:"A") ;Move inactive to terms
 ..... S TCNT=TCNT+1
 ..... S INT("TERM")=TERM
 ..... S INT("DESCID")=DESCID
 ..... S INT("TACT")=TACT
 .... ;
 .... ;Active already on file or new inactive, save in array
 .... S TRMARY(DESCID,"I")=TERM_U_$S($G(PRE("TACT")):"I",1:"A")
 .... S TCNT=TCNT+1
 ... ;
 ... ;Found a preferred term
 ... I TYPE="P" D  Q
 .... ;
 .... ;If the first one, save and quit
 .... I '$D(PRE) D  Q
 ..... S PRE("TERM")=TERM
 ..... S PRE("DESCID")=DESCID
 ..... S PRE("TACT")=TACT
 .... ;
 .... ;One already on file, if inactive and new is active, make new preferred
 .... ;and current in terms array
 .... I TACT=0,$G(PRE("TACT"))=1 D  Q
 ..... S TRMARY($G(PRE("DESCID")),"P")=$G(PRE("TERM"))_U_$S($G(PRE("TACT")):"I",1:"A") ;Move inactive to terms
 ..... S TCNT=TCNT+1
 ..... S PRE("TERM")=TERM
 ..... S PRE("DESCID")=DESCID
 ..... S PRE("TACT")=TACT
 .... ;
 .... ;Active already on file, save in array
 .... S TRMARY(DESCID,"P")=TERM_U_$S(TACT:"I",1:"A")
 .... S TCNT=TCNT+1
 ... ;
 ... ;Found a FSN
 ... I TYPE="F" D  Q
 .... ;
 .... ;If the first one, save and quit
 .... I '$D(FSN) D  Q
 ..... S FSN("TERM")=TERM
 ..... S FSN("DESCID")=DESCID
 ..... S FSN("TACT")=TACT
 .... ;
 .... ;One already on file, if inactive and new is active, make new FSN
 .... ;and current in terms array
 .... I TACT=0,$G(FSN("TACT"))=1 D  Q
 ..... S TRMARY($G(FSN("DESCID")),"F")=$G(FSN("TERM"))_U_$S($G(FSN("TACT")):"I",1:"A")  ;MOve inactive to terms
 ..... S TCNT=TCNT+1
 ..... S FSN("TERM")=TERM
 ..... S FSN("DESCID")=DESCID
 ..... S FSN("TACT")=TACT
 .... ;
 .... ;Active already on file, save in array
 .... S TRMARY(DESCID,"F")=TERM_U_$S(TACT:"I",1:"A")
 .... S TCNT=TCNT+1
 ... ;
 ... ;Save the synonym
 ... I TYPE="S",'IT D
 .... S TRMARY(DESCID,"S")=TERM_U_$S(TACT:"I",1:"A")
 .... S TCNT=TCNT+1
 .. ;
 .. ;Record maximum terms found
 .. S:TCNT>TMAX TMAX=TCNT
 .. ;
 .. ;Populate PRE/FSN/INT
 .. S $P(REC,U,3)=$G(FSN("DESCID"))
 .. S $P(REC,U,4)=$G(FSN("TERM"))
 .. S $P(REC,U,5)=$S($G(FSN("TACT")):"I",'$D(FSN("TACT")):"",1:"A")
 .. S $P(REC,U,6)=$G(PRE("DESCID"))
 .. S $P(REC,U,7)=$G(PRE("TERM"))
 .. S $P(REC,U,8)=$S($G(PRE("TACT")):"I",'$D(PRE("TACT")):"",1:"A")
 .. S $P(REC,U,9)=$G(INT("DESCID"))
 .. S $P(REC,U,10)=$G(INT("TERM"))
 .. S $P(REC,U,11)=$S($G(INT("TACT")):"I",'$D(INT("TACT")):"",1:"A")
 .. ;
 .. ;Update counter and output
 .. S CCNT=CCNT+1,@CGBL@(CCNT)=REC
 .. M @CGBL@(CCNT,"T")=TRMARY
 ;
 Q
 ;
SCOMP(RANGE,CGBL) ;Compile subset report data
 ;
 NEW RSUB,CIEN,REC,QUIT,CSUB,SUB
 ;
 ;Loop through range
 S RSUB="" F  S RSUB=$O(RANGE(RSUB)) Q:RSUB=""  D
 . ;
 . ;Handle exact subset
 . I $E(RSUB,$L(RSUB))'="*" D  Q
 .. ;
 .. ;Loop through that subset's entries
 .. S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"E",15,RSUB,CIEN)) Q:CIEN=""  D
 ... ;
 ... ;See if concept data already pulled
 ... S REC=""
 ... I $D(@CGBL@("C",CIEN)) S REC=$G(@CGBL@("C",CIEN))
 ... E  S REC=$$CONC(CIEN,CGBL)
 ... ;
 ... ;Set up entry for output
 ... I REC]"" S @CGBL@("O",CIEN,RSUB)=REC
 . ;
 . ;Handle partial subsets (ending in "*")
 . S (CSUB,SUB)=$E(RSUB,1,$L(RSUB)-1)
 . S QUIT=0
 . F  S SUB=$O(^BSTS(9002318.4,"E",15,SUB)) D  Q:QUIT
 .. I SUB="" S QUIT=1 Q
 .. I CSUB'="",$E(SUB,1,$L(CSUB))'=CSUB S QUIT=1 Q
 .. I 'RANGE,SUB="IHS PROBLEM ALL SNOMED" Q  ;Only include IHS PROBLEM ALL SNOMED if specified
 .. ;
 .. ;Found a matching subset - get entries
 .. S CIEN="" F  S CIEN=$O(^BSTS(9002318.4,"E",15,SUB,CIEN)) Q:CIEN=""  D
 ... ;
 ... ;See if concept data already pulled
 ... S REC=""
 ... I $D(@CGBL@("C",CIEN)) S REC=$G(@CGBL@("C",CIEN))
 ... E  S REC=$$CONC(CIEN,CGBL)
 ... ;
 ... ;Set up entry for output
 ... I REC]"" S @CGBL@("O",CIEN,SUB)=REC
 ;
 Q
 ;
CONC(CIEN,CGBL) ;Retrieve information for a concept
 ;
 NEW NODE,CREC,X,TIEN,DESCID,TYPE,IT,TERM,TACT,INT,PRE,FSN
 ;
 ;Concept identified - Concept ID
 S NODE0=$G(^BSTS(9002318.4,CIEN,0))
 S CREC=$P(NODE0,U,2)
 ;
 ;Status
 S X=+$P(NODE0,U,16)
 S $P(CREC,U,2)=$S(X:"I",1:"A")
 ;
 ;Loop through terms
 S TIEN="" F  S TIEN=$O(^BSTS(9002318.3,"C",36,CIEN,TIEN),-1) Q:TIEN=""  D
 . ;
 . ;Get term information
 . S NODE0=$G(^BSTS(9002318.3,TIEN,0))
 . S DESCID=$P(NODE0,U,2) Q:DESCID=""
 . S TYPE=$P(NODE0,U,9) Q:TYPE=""
 . S IT=$P(NODE0,U,12)
 . S TERM=$P($G(^BSTS(9002318.3,TIEN,1)),U)
 . S TACT=$P(NODE0,U,13)
 . ;
 . ;First log interface term
 . I IT D
 .. ;
 .. ;If the first one, save and quit
 .. I '$D(INT) D  Q
 ... S INT("TERM")=TERM
 ... S INT("DESCID")=DESCID
 ... S INT("TACT")=TACT
 .. ;
 .. ;One already on file, if inactive and new is active, make new interface term
 .. I TACT=0,$G(INT("TACT"))=1 D  Q
 ... S INT("TERM")=TERM
 ... S INT("DESCID")=DESCID
 ... S INT("TACT")=TACT
 .. ;
 . ;Found a preferred term
 . I TYPE="P" D  Q
 .. ;
 .. ;If the first one, save and quit
 .. I '$D(PRE) D  Q
 ... S PRE("TERM")=TERM
 ... S PRE("DESCID")=DESCID
 ... S PRE("TACT")=TACT
 .. ;
 .. ;One already on file, if inactive and new is active, make new preferred
 .. I TACT=0,$G(PRE("TACT"))=1 D  Q
 ... S PRE("TERM")=TERM
 ... S PRE("DESCID")=DESCID
 ... S PRE("TACT")=TACT
 . ;
 . ;Found a FSN
 . I TYPE="F" D  Q
 .. ;
 .. ;If the first one, save and quit
 .. I '$D(FSN) D  Q
 ... S FSN("TERM")=TERM
 ... S FSN("DESCID")=DESCID
 ... S FSN("TACT")=TACT
 .. ;
 .. ;One already on file, if inactive and new is active, make new FSN
 .. I TACT=0,$G(FSN("TACT"))=1 D  Q
 ... S FSN("TERM")=TERM
 ... S FSN("DESCID")=DESCID
 ... S FSN("TACT")=TACT
 ;
 ;Populate PRE/FSN/INT
 S $P(CREC,U,3)=$G(FSN("DESCID"))
 S $P(CREC,U,4)=$G(FSN("TERM"))
 S $P(CREC,U,5)=$S($G(FSN("TACT")):"I",'$D(FSN("TACT")):"",1:"A")
 S $P(CREC,U,6)=$G(PRE("DESCID"))
 S $P(CREC,U,7)=$G(PRE("TERM"))
 S $P(CREC,U,8)=$S($G(PRE("TACT")):"I",'$D(PRE("TACT")):"",1:"A")
 S $P(CREC,U,9)=$G(INT("DESCID"))
 S $P(CREC,U,10)=$G(INT("TERM"))
 S $P(CREC,U,11)=$S($G(INT("TACT")):"I",'$D(INT("TACT")):"",1:"A")
 ;
 ;Save for later references
 S @CGBL@("C",CIEN)=CREC
 ;
 ;Define current entry
 Q CREC
