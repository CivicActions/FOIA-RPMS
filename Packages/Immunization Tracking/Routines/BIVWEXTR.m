BIVWEXTR ;IHS/CMI/MWR - Patient extract and DOM PROCESSING ROUTINES ; 26 Jul 2016  08:28 AM
 ;;8.5;IMMUNIZATION;**18**;JUN 15,2020;Build 28
 ;;1.0;PCE PATIENT CARE ENCOUNTER;**216**;Aug 12, 1996;Build 4
 ;
 ; This software was funded in part by Oroville Hospital, and was
 ; created with help from Oroville's doctors and staff.
 ;
 Q
 ;
 ; here are the types that are supported:
 ;demographics;reactions;problems;vitals;labs;meds;immunizations;observation;
 ;visits;appointments;documents;procedures;consults;flags;factors;skinTests;
 ;exams;education;insurance
 ;
GETPAT(RTN,ZPATID,ZTYP,START,STOP) ; get patient data
 ;---> ZTYP="immunization"
 N JJOHARY
 S START=$G(START)
 S STOP=$G(STOP)
 ;
 ;---> Gets Imm Hx, loads into ^TMP("BI_VPR",$J):
 D GET^BIVWVPRD(.JJOHARY,ZPATID,ZTYP,START,STOP)
 ; ^TMP("BI_VPR",$J,2)="<immunizations total='3' >"
 ;                  3)="<immunization>"
 ;                  4)="<administered value='3191117' />"
 ;                  5)="<cvx value='88' />"
 ;                  6)="<encounter value='3391' />" ;IEN Visit
 ;                  7)="<id value='3990' />"        ;IEN V Imm
 ;                  8)="<name value='INFLUENZA, NOS' />"
 ;                  9)="</immunization>
 ;
 ;
 S JJOHDID=$$PARSE(JJOHARY,ZPATID_"-"_ZTYP)
 K RTN
 N ZDOM S ZDOM=$NA(^TMP("MXMLDOM",$J,JJOHDID))
 D DOMO3("RTN",,,ZDOM)
 ;D DOMO(1,"/","RTN","GIDX","GARY",,"/results/"_ZTYP_"/")
 K GIDX,GARY,@JJOHARY
 ;
 Q
 ;
TREE(WHERE,PREFIX,DOCID,ZOUT,ZARY) ; show a tree starting at a node in MXML.
 ; node is passed by name
 ;
 I '$D(ZARY) S ZARY="GARY"
 I '$D(@ZARY) S @ZARY=""
 I $G(PREFIX)="" S PREFIX="/" ; starting prefix
 I '$D(KBAIJOB) S KBAIJOB=$J
 N NODE S NODE=$NA(^TMP("MXMLDOM",KBAIJOB,DOCID,WHERE))
 N TXT S TXT=$$CLEAN($$ALLTXT(NODE))
 N G S G=PREFIX
 N GT S GT=PREFIX_"/"_@NODE
 N GT1 S GT1=1
 I $D(@ZARY@(GT)) D  ;
 . S GT1=$O(@ZARY@(GT,""),-1)+1
 ;i txt'="",txt'=" " d  ;
 S @ZARY@(GT1,GT)=TXT
 S @ZARY@(GT,GT1)=TXT
 W !,GT_" "_TXT
 D ONEOUT(ZOUT,PREFIX_@NODE_" "_TXT)
 N BIZI S BIZI=""
 F  S BIZI=$O(@NODE@("A",BIZI)) Q:BIZI=""  D  ;
 . S @ZARY@(GT1,G,@NODE_"@"_BIZI)=$G(@NODE@("A",BIZI))
 . W !,PREFIX_"/"_@NODE_"@"_BIZI_"="_$G(@NODE@("A",BIZI))
 . D ONEOUT(ZOUT,PREFIX_"/"_@NODE_"@"_BIZI_"="_$G(@NODE@("A",BIZI)))
 F  S BIZI=$O(@NODE@("C",BIZI)) Q:BIZI=""  D  ;
 . D TREE(BIZI,PREFIX_"/"_@NODE,DOCID,ZOUT)
 Q
 ;
DOMO3(ZARY,WHAT,WHERE,ZDOM,LVL) ; simplified domo
 ; zary is the return array
 ; what is the tag to begin with starting at where, a node in the zdom
 ; multiple is the index to be used for a muliple entry 0 is a singleton
 ;
 I '$D(ZDOM) S ZDOM=$NA(^TMP("MXMLDOM",$J,$O(^TMP("MXMLDOM",$J,"AAAAA"),-1)))
 I '$D(WHERE) S WHERE=1
 I $G(WHAT)="" S WHAT=@ZDOM@(WHERE)
 I '$D(LVL) S LVL=0 N ZNUM S ZNUM=0 ; first time
 ;
 N TXT S TXT=$$CLEAN($$ALLTXT($NA(@ZDOM@(WHERE))))
 I TXT'="" I TXT'=" " D  ;
 . S @ZARY@(@ZDOM@(WHERE))=TXT
 ;
 N BIZI S BIZI=""
 F  S BIZI=$O(@ZDOM@(WHERE,"A",BIZI)) Q:BIZI=""  D  ;
 . S @ZARY@(WHAT_"@"_BIZI)=@ZDOM@(WHERE,"A",BIZI)
 F  S BIZI=$O(@ZDOM@(WHERE,"C",BIZI)) Q:BIZI=""  D  ;
 . N MULT S MULT=$$ISMULT(WHERE,ZDOM)
 . ;i '$d(znum) n znum s znum(where)=0
 . I MULT>0 S ZNUM(WHERE)=$G(ZNUM(WHERE))+1
 . I $G(C0DEBUG) I MULT>0 D  ;
 . . W !,"where ",WHERE," what ",WHAT," zi ",BIZI," lvl ",LVL,!
 . . ZWR ZNUM
 . ;B
 . I MULT=0 D DOMO3($NA(@ZARY@(WHAT)),@ZDOM@(WHERE,"C",BIZI),BIZI,ZDOM,LVL+1)
 . I MULT>0 D DOMO3($NA(@ZARY@(WHAT,ZNUM(WHERE))),@ZDOM@(WHERE,"C",BIZI),BIZI,ZDOM,LVL+1)
 . ;D DOMO3($NA(@ZARY@(WHAT,ZNUM(WHERE))),@ZDOM@(WHERE,"C",BIZI),BIZI,ZDOM,LVL+1)
 Q
 ;
ISMULT(ZIDX,ZDOM) ; extrinsic which returns one if the node contains multiple
 ; children with the same tag
 N ZTAGS,ZZI,ZJ,RTN S ZZI="" S RTN=0
 F  S ZZI=$O(@ZDOM@(ZIDX,"C",ZZI)) Q:RTN=1  Q:ZZI=""  D  ;
 . S ZJ=@ZDOM@(ZIDX,"C",ZZI)
 . I $D(ZTAGS(ZJ)) S RTN=1
 . S ZTAGS(ZJ)=""
 Q RTN
 ;
TESTMULT ;
 N ZDOM
 S ZDOM=$NA(^TMP("MXMLDOM",$J,1))
 N GI,GJ S GI=""
 F  S GI=$O(@ZDOM@(GI)) Q:GI=""  D  ;
 . ;i $$ismult(gi,zdom) b  ;
 . I $$ISMULT(GI,ZDOM) D APPERROR^%ZTER("<DEBUG-ISMULT>"),UNWIND^%ZTER ; MSC/DKA
 Q
 ;
FINDNXT(TAG,ZND) ; private extrinsic which returns a node id of tag
 I '$D(ZDOM) S ZDOM=$NA(^TMP("MXMLDOM",$J,$O(^TMP("MXMLDOM",$J,"AAAAA"),-1)))
 ;i @zdom@(znd)=tag q znd ; easy case
 N GI,DONE,RSLT S GI="" S DONE=0
 F  S GI=$O(@ZDOM@(ZND,"C",GI)) Q:DONE  Q:GI=""  D  ;
 . I @ZDOM@(ZND,"C",GI)=TAG S DONE=1 S RSLT=GI
 Q:DONE RSLT
 F  S GI=$O(@ZDOM@(ZND,"C",GI)) Q:DONE  Q:GI=""  D  ;
 . S RSLT=$$FINDNXT(TAG,GI)
 . I RSLT'="" S DONE=1
 Q:DONE RSLT
 ;i $d(@zdom@(znd,"P")) d  ;
 ;. s rslt=$$findnxt(tag,@zdom@(znd,"P")) ; check the parent if any
 Q RSLT
 ;
ONEOUT(ZBUF,ZTXT) ; adds a line to zbuf
 N BIZI S BIZI=$O(@ZBUF@(""),-1)+1
 S @ZBUF@(BIZI)=ZTXT
 Q
 ;
ALLTXT(WHERE) ; extrinsic which returns all text lines from the node .. concatinated
 ; together
 N ZTI S ZTI=""
 N ZTR S ZTR=""
 F  S ZTI=$O(@WHERE@("T",ZTI)) Q:ZTI=""  D  ;
 . S ZTR=ZTR_$G(@WHERE@("T",ZTI))
 Q ZTR
 ;
CLEAN(STR) ; extrinsic function; returns string - gpl borrowed from the CCR package
 ;; Removes all non printable characters from a string.
 ;; STR by Value
 N TR,I
 F I=0:1:31 S TR=$G(TR)_$C(I)
 S TR=TR_$C(127)
 N BIZR S BIZR=$TR(STR,TR)
 S BIZR=$$LDBLNKS(BIZR) ; get rid of leading blanks
 QUIT BIZR
 ;
LDBLNKS(ST) ; extrinsic which removes leading blanks from a string
 N POS F POS=1:1:$L(ST)  Q:$E(ST,POS)'=" "
 Q $E(ST,POS,$L(ST))
 ;
ADDNARY(ZXP,ZVALUE) ; ADD AN NHIN ARRAY VALUE TO ZNARY
 ;
 ; IF ZATT=1 THE ARRAY IS ADDED AS ATTRIBUTES
 ;
 N ZZI,ZZJ,ZZN
 S ZZI=$P(ZXP,"/",1) ; FIRST PIECE OF XPATH ARRAY
 I ZZI="" Q  ; DON'T ADD THIS ONE .. PROBABLY THE //results NODE
 S ZZJ=$P(ZXP,ZZI_"/",2) ; REST OF XPATH ARRAY
 S ZZJ=$TR(ZZJ,"/",".") ; REPLACE / WITH .
 I ZZI'["]" D  ; A SINGLETON
 . S ZZN=1
 E  D  ; THERE IS AN [x] OCCURANCE
 . S ZZN=$P($P(ZZI,"[",2),"]",1) ; PULL OUT THE OCCURANCE
 . S ZZI=$P(ZZI,"[",1) ; TAKE OUT THE [X]
 I ZZJ'="" D  ; TIME TO ADD THE VALUE
 . S @ZNARY@(ZZI,ZZN,ZZJ)=ZVALUE
 Q
 ;
PARSE(INXML,INDOC) ;CALL THE MXML PARSER ON INXML, PASSED BY NAME
 ; INDOC IS PASSED AS THE DOCUMENT NAME - DON'T KNOW WHERE TO STORE THIS NOW
 ; EXTRINSIC WHICH RETURNS THE DOCID ASSIGNED BY MXML
 ;Q $$EN^MXMLDOM(INXML)
 Q $$EN^MXMLDOM(INXML,"W")
 ;
ISMULTZ(ZOID) ; RETURN TRUE IF ZOID IS ONE OF A MULTIPLE ; MSC/DKA Renamed this to ISMULTZ
 N ZN
 ;I $$TAG(ZOID)["entry" B
 S ZN=$$NXTSIB(ZOID)
 I ZN'="" Q $$TAG(ZOID)=$$TAG(ZN) ; IF TAG IS THE SAME AS NEXT SIB TAG
 Q 0
 ;
FIRST(ZOID) ;RETURNS THE OID OF THE FIRST CHILD OF ZOID
 Q $$CHILD^MXMLDOM(JJOHDID,ZOID)
 ;
PARENT(ZOID) ;RETURNS THE OID OF THE PARENT OF ZOID
 Q $$PARENT^MXMLDOM(JJOHDID,ZOID)
 ;
ATT(RTN,NODE) ;GET ATTRIBUTES FOR ZOID
 S HANDLE=JJOHDID
 K @RTN
 D GETTXT^MXMLDOM("A")
 Q
 ;
TAG(ZOID) ; RETURNS THE XML TAG FOR THE NODE
 ;
 N X,Y
 S Y=""
 S X=$G(JJOHCBK("TAG")) ;IS THERE A CALLBACK FOR THIS ROUTINE
 I X'="" X X ; EXECUTE THE CALLBACK, SHOULD SET Y
 I Y="" S Y=$$NAME^MXMLDOM(JJOHDID,ZOID)
 Q Y
 ;
NXTSIB(ZOID) ; RETURNS THE NEXT SIBLING
 Q $$SIBLING^MXMLDOM(JJOHDID,ZOID)
 ;
DATA(ZT,ZOID) ; RETURNS DATA FOR THE NODE
 ;N ZT,ZN S ZT=""
 ;S C0SDOM=$NA(^TMP("MXMLDOM",$J,JJOHDID))
 ;Q $G(@C0SDOM@(ZOID,"T",1))
 S ZN=$$TEXT^MXMLDOM(JJOHDID,ZOID,ZT)
 Q
