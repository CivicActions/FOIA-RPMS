BQIULAY3 ;GDIT/HCS/ALA-Layout continued ; 17 Oct 2023  6:05 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**5**;Mar 01, 2021;Build 20
 ;
LAY ; Add new patient entries to 90506.1
 NEW BI,BJ,BK,BN,BQIUPD,ERROR,IEN,ND,NDATA,TEXT,VAL,TTEXT,BJJ
 F BI=1:1 S TEXT=$P($T(ARR+BI),";;",2) Q:TEXT=""  D
 . F BJ=1:1:$L(TEXT,"~") D
 .. S NDATA=$P(TEXT,"~",BJ)
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. I ND=0 D
 ... NEW DIC,X,Y
 ... S DIC(0)="FLQZ",DIC="^BQI(90506.1,",X=$P(VAL,U,1)
 ... D ^DIC
 ... S IEN=+Y
 ... I IEN=-1 K DO,DD D FILE^DICN S IEN=+Y
 .. I ND=1 S BQIUPD(90506.1,IEN_",",1)=VAL Q
 .. I ND=5 S BQIUPD(90506.1,IEN_",",5)=VAL Q
 .. F BK=1:1:$L(VAL,"^") D
 ... S BN=$O(^DD(90506.1,"GL",ND,BK,"")) I BN="" Q
 ... I $P(VAL,"^",BK)'="" S BQIUPD(90506.1,IEN_",",BN)=$P(VAL,"^",BK) Q
 ... I $P(VAL,"^",BK)="" S BQIUPD(90506.1,IEN_",",BN)="@"
 ... ;
 ... S TTEXT=$T(TIP+BI) Q:TTEXT=" Q"  D
 .... S TTEXT=$P(TTEXT,";;",2) I TTEXT="" Q
 .... F BJJ=1:1:$L(TTEXT,"~") D
 ..... S NDATA=$P(TTEXT,"~",BJJ) I NDATA="" Q
 ..... S ^BQI(90506.1,IEN,4,BJJ,0)=NDATA
 ..... S ^BQI(90506.1,IEN,4,0)="^^"_BJJ_"^"_BJJ
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
LTX ; if long tooltip
 NEW TEXT,VAR,NDATA,COD,TCT,BT,BJ,BJJ
 F BT=1:1 S TEXT=$P($T(TIPL+BT),";;",2) Q:TEXT=""  D
 . S VAR=$P(TEXT,"^",1),NDATA=$P(TEXT,"^",2),COD(VAR)=""
 . I $D(@(VAR))=0 S @VAR@(0)=""
 . S TCT=$O(@VAR@(""),-1)
 . F BJ=1:1:$L(NDATA,"~") S TCT=TCT+1,@VAR@(TCT)=$P(NDATA,"~",BJ)
 . S COD(VAR)=TCT
 S VAR="" F  S VAR=$O(COD(VAR)) Q:VAR=""  D
 . S BJJ=COD(VAR),IEN=$O(^BQI(90506.1,"B",VAR,"")) I IEN="" Q
 . K ^BQI(90506.1,IEN,4)
 . F I=1:1:BJJ S ^BQI(90506.1,IEN,4,I,0)=@VAR@(I)
 . S ^BQI(90506.1,IEN,4,0)="^^"_BJJ_"^"_BJJ
 ;
 ; Re-Index File
 K ^BQI(90506.1,"AC"),^BQI(90506.1,"AD")
 NEW DIK
 S DIK="^BQI(90506.1,",DIK(1)=3.01
 D ENALL^DIK
 ;
 Q
 ;
TIP ;  Tooltips
 ;;Most recent LAB test using the following taxonomies: BQI C.TRACH SPECIFIC ~LOINC, BQI C.TRACH NON-SPECIFIC LOINC, BQI CHLAMYDIA CULTURE LOINC, BQI ~CHLAMYDIA NUCLEIC LOINC, and BQI CHLAMYDIA ANTIGEN LOINC.~
 ;;Most recent IPL or POV using taxonomy BKM CHANCROID DXS and SNOMED subset ~PXRM BQI CHANCROID.~
 ;;Most recent LAB test using taxonomy BQI CHANCROID OTHER LOINC.~
 ;;Most recent IPL or POV using taxonomy BKM CHLAMYDIA DXS and SNOMED subset ~PXRM BQI CHLAMYDIA.~
 ;;Most recent LAB test using the following taxonomies: BQI HERPES SIMPLEX ~ANTIBODY LC, BQI HERPES SIMPLEX NUCL LOINC, and BQI HERPES SIMPLEX CULT ~LOINC.~
 ;;Most recent IPL or POV using taxonomy BKM GENITAL HERPES DXS.~
 ;;Most recent IPL or POV using taxonomy BKM GENITAL WARTS DXS.~
 ;;Most recent IPL or POV using taxonomy BQI GONORRHEA DXS and SNOMED subset ~PXRM BQI GONORRHEA.~
 ;;Most recent LAB test using the following taxonomies: BQI GONORRHEA ~NUCLEIC LOINC, BQI GONORRHEA CULTURE LOINC, and BKM GONORRHEA LOINC CODES.~
 ;;
 ;;
 ;;Most recent IPL or POV using taxonomy BQI HIV DXS and SNOMED subset PXRM ~BQI HIV INFECTION OR AIDS.~
 ;;Most recent LAB test using LOINC and site-specified lab taxonomies that~start with 'BQI HIV' (about 16 different taxonomies).~"
 ;;Most recent IPL or POV using taxonomy BKM HEP B DXS.~
 ;;Most recent IPL or POV using taxonomy BKM HEP C DXS and SNOMED Subset ~PXRM BQI HEPATITIS C VIRUS INF.~
 ;;Most recent IPL or POV using taxonomy BKM HPV DXS.~
 ;;Most recent IPL or POV using taxonomy BKM LGV DXS.~
 ;;This is the most recent Syphilis medication given to the patient. ~Syphilis medications are from RXNORM subsets; RXNO BQI BICILLIN (PCN G ~BENZ), RXNO BQI PCN G AQ CRYST INJ, and RXNO BQI PCN G PROCAINE INJ found ~in the V Medication file.~
 ;;Most recent IPL or POV using taxonomy BKM SYPHILIS DXS and SNOMED subset ~PXRM BQI PRIMARY SYPHILIS.~
 ;;Most recent LAB test using the following taxonomies: BQI SYPHILIS TP-AB ~LOINC, BQI SYPHILIS TP-AB TEST TAX, BQI SYPHILIS REAGIN LOINC and BQI ~SYPHILIS REAGIN TEST TAX.~
 ;;Most recent IPL or POV using taxonomy BKM TRICHOMONIASIS DXS.~
 Q
 ;
ARR ; Array
 ;;0|STCHLLB^^Most Recent Chlamydia Lab^^^^^T00030STCHLLB^^^^^^^125~1|S VAL=$$CHL^BQIRGSTI(DFN)~3|60^^^D^13~5|
 ;;0|STCHNDX^^Last Chancroid Dx^^^^^T00030STCHNDX~1|S VAL=$$PROB^BQITUTL1("BKM CHANCROID DXS","PXRM BQI CHANCROID","","D",DFN)~3|60^^^O^1~5|
 ;;0|STCHNLB^^Most Recent Chancroid Lab^^^^^T00030STCHNLB^^^^^^^125~1|S VAL=$$CHN^BQIRGSTI(DFN)~3|60^^^O^17~5|
 ;;0|STCHYDX^^Last Chlamydia Dx^^^^^T00030STCHYDX~1|S VAL=$$PROB^BQITUTL1("BKM CHLAMYDIA DXS","PXRM BQI CHLAMYDIA","","D",DFN)~3|60^^^O^2~5|
 ;;0|STGHELB^^Most Recent Genital Herpes Lab^^^^^T00030STGHELB~1|S VAL=$$GHER^BQIRGSTI(DFN)~3|60^^^O^18~5|
 ;;0|STGNHDX^^Last Genital Herpes Dx^^^^^T00030STGNHDX~1|S VAL=$$PROB^BQITUTL1("BKM GENITAL HERPES DXS","","","D",DFN)~3|60^^^O^3~5|
 ;;0|STGNWDX^^Last Genital Warts Dx^^^^^T00030STGNWDX~1|S VAL=$$PROB^BQITUTL1("BKM GENITAL WARTS DXS","","","D",DFN)~3|60^^^O^4~5|
 ;;0|STGONDX^^Last Gonorrhea Dx^^^^^T00030STGONDX~1|S VAL=$$PROB^BQITUTL1("BQI GONORRHEA DXS","PXRM BQI GONORRHEA","","D",DFN)~3|60^^^O^5~5|
 ;;0|STGONLB^^Most Recent Gonorrhea Lab^^^^^T00030STGONLB^^^^^^^125~1|S VAL=$$GON^BQIRGSTI(DFN)~3|60^^^D^14~5|
 ;;0|STHEPBLB^^Most Recent Hep B Lab^^^^^T00030STHEPBLB^^^^^^^125~1|S VAL=$$HEPB^BQIRGSTI(DFN)~3|60^^^O^19~5|
 ;;0|STHEPCLB^^Most Recent Hep C Lab^^^^^T00030STHEPCLB^^^^^^^125~1|S VAL=$$HEPC^BQIRGSTI(DFN)~3|60^^^O^20~5|
 ;;0|STHIVDX^^Last HIV Dx^^^^^T00030STHIVDX~1|S VAL=$$PROB^BQITUTL1("BQI HIV DXS","PXRM BQI HIV INFECTION OR AIDS","","D",DFN)~3|60^^^O^7~5|
 ;;0|STHIVLB^^Most Recent HIV Lab^^^^^T00030STHIVLB^^^^^^^125~1|S VAL=$$HIV^BQIRGSTI(DFN)~3|60^^^D^15~5|
 ;;0|STHPBDX^^Last Hep B Dx^^^^^T00030STHPBDX~1|S VAL=$$PROB^BQITUTL1("BKM HEP B DXS","","","D",DFN)~3|60^^^O^9~5|
 ;;0|STHPCDX^^Last Hep C Dx^^^^^T00030STHPCDX~1|S VAL=$$PROB^BQITUTL1("BKM HEP C DXS","PXRM BQI HEPATITIS C VIRUS INF","","D",DFN)~3|60^^^O^8~5|
 ;;0|STHPVDX^^Last HPV Dx^^^^^T00030STHPVDX~1|S VAL=$$PROB^BQITUTL1("BKM HPV DXS","","","D",DFN)~3|60^^^O^10~5|
 ;;0|STLGVDX^^Last Lympho Venereum Dx^^^^^T00030STLGVDX~1|S VAL=$$PROB^BQITUTL1("BKM LGV DXS","","","D",DFN)~3|60^^^O^11~5|
 ;;0|STSTRMT^^Syphilis Treatment Done^^^^^D00015STSTRMT~1|S VAL=$$STRMT^BQIRGSTI(DFN)~3|60^^^O^21~5|
 ;;0|STSYPDX^^Last Syphilis Dx^^^^^T00030STSYPDX~1|S VAL=$$PROB^BQITUTL1("BKM SYPHILIS DXS","PXRM BQI PRIMARY SYPHILIS","","D",DFN)~3|60^^^O^6~5|
 ;;0|STSYPLB^^Most Recent Syphilis Lab^^^^^T00030STSYPLB^^^^^^^125~1|S VAL=$$SYP^BQIRGSTI(DFN)~3|60^^^D^16~5|
 ;;0|STTRIDX^^Last Trichomonas Dx^^^^^T00030STTRIDX~1|S VAL=$$PROB^BQITUTL1("BKM TRICHOMONIASIS DXS","","","D",DFN)~3|60^^^O^12~5|
 Q
 ;
TIPL ;
 ;;STSTRMT^This is the most recent Syphilis medication given to the patient. ~Syphilis medications are from RXNORM subsets; RXNO BQI BICILLIN (PCN G ~
 ;;STSTRMT^BENZ), RXNO BQI PCN G AQ CRYST INJ, and RXNO BQI PCN G PROCAINE INJ found ~in the V Medication file.~
 Q
