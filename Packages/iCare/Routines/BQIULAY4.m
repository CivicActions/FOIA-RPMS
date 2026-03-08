BQIULAY4 ;GDIT/HCS/ALA-Layout continued ; 17 Oct 2023  6:05 PM
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
 ;;The most recent result and date of the ALT lab test from taxonomy DM ~AUDIT ALT TAX.~
 ;;The most recent result and date of a Hep C Antibody lab using taxonomy ~BQI HCV ANTIBODY TAX.~
 ;;The most recent result and date of AST lab using taxonomy DM AUDIT AST ~TAX.~
 ;;The first Hepatitis C diagnosis in either the Problem file or the Purpose ~of Visit file.~
 ;;
 ;;The most recent Fibrocan procedure from taxonomy BQI FIBROSCAN CPT PROC.~
 ;;The most recent result and date of a Hep C Genotype lab using taxonomy ~BQI HEP C GENOTYPE TESTS.~
 ;;
 ;;If the patient has completed the Hep B series of immunizations.~
 ;;This is the curent HCV status from Health Factors.~
 ;;The most recent result and date of a HIV lab using taxonomy BGP HIV TEST ~TAX.~
 ;;The most recent Liver Ultrasound test using taxonomy BQI LIVER ULTRASOUND ~CPT.~
 ;;The most recent result and date of a Platelet lab from taxonomy BQI ~PLATELET TAX.~
 ;;If the patient was pregnant after the first Hepatitis C diagnosis.~
 ;;The most recent result and date of a Hep C RNA lab using taxonomy BQI HCV ~RNA TAX.~
 ;;The most recent result and date of a Hep C Viral Load lab using taxonomy ~BQI HCV VIRAL LOAD TAX.~
 Q
 ;
ARR ; Array
 ;;0|HCALT^^ALT Test^^^^^T00030HCALT~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Lab^D^4~5|S VAL=$$HLB^BQIRGHPC(DFN,STVW),DATE=$P(VAL,U,2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCANTI^^HCV Antibody Test^^^^^T00030HCANTI~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Lab^D^1~5|S VAL=$$HLB^BQIRGHPC(DFN,STVW),DATE=$P(VAL,U,2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCAST^^AST Test^^^^^T00030HCAST~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Lab^D^3~5|S VAL=$$HLB^BQIRGHPC(DFN,STVW),DATE=$P(VAL,U,2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCDOO^^First Hep C Dx^^^^^T00030HCDOO~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^^O^14~5|S VAL=$$DOO^BQIRGHPC(DFN),DATE=$P(VAL,"^",2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCFIB4^^FIB-4 Calculation^^^^^T00030HCFIB4~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^^O^16~5|S VAL=$$FIB4^BQIRGHPC(DFN)
 ;;0|HCFIBRO^^Fibroscan^^^^^T00030HCFIBRO~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Procedure^D^9~5|S VAL=$$FIB^BQIRGHPC(DFN),DATE=$P(VAL,U,2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCGENO^^HCV Genotype Test^^^^^T00030HCGENO~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Lab^D^7~5|S VAL=$$HLB^BQIRGHPC(DFN,STVW),DATE=$P(VAL,U,2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCHEPA^^Hep A^^^^^T00030HCHEPA~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Immunization^D^12~5|S VAL=$$HEPA^BQIRGHEP(DFN,DT)
 ;;0|HCHEPB^^Hep B^^^^^T00030HCHEPB~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Immunization^D^11~5|S VAL=$$HEPB^BQIRGDMS(DFN)
 ;;0|HCHFST^^Current HCV Status^^^^^T00050HCHFST~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^^O^13~5|S VAL=$$HF^BQICMUT1(DFN,1,"HCV STATUS","C")
 ;;0|HCHIV^^HIV Test^^^^^T00030HCHIV~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Lab^D^8~5|S VAL=$$HLB^BQIRGHPC(DFN,STVW),DATE=$P(VAL,U,2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCLIVER^^Liver Ultrasound^^^^^T00030HCLIVER~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Procedure^D^10~5|S VAL=$$LU^BQIRGHPC(DFN),DATE=$P(VAL,U,2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCPLAT^^Platelet Test^^^^^T00030HCPLAT~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Lab^D^5~5|S VAL=$$HLB^BQIRGHPC(DFN,STVW),DATE=$P(VAL,U,2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCPREG^^Pregnant After DX^^^^^T00015HCPREG~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^^O^15~5|S VAL=$$EPRG^BQIRGHPC(DFN),DATE=$P(VAL,"^",2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCRNA^^HCV RNA Test^^^^^T00030HCRNA~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Lab^D^2~5|S VAL=$$HLB^BQIRGHPC(DFN,STVW),DATE=$P(VAL,U,2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 ;;0|HCVIRAL^^HCV Viral Load Test^^^^^T00030HCVIRAL~1|S VAL=$$DSP^BQIRGASU(DFN,STVW)~3|38^^Lab^D^6~5|S VAL=$$HLB^BQIRGHPC(DFN,STVW),DATE=$P(VAL,U,2),VISIT=$P(VAL,U,3),OTHER=$P(VAL,U,4),VAL=$P(VAL,U,1)
 Q
 ;
TIPL ;
 ;;HCFIB4^The FIB-4 calculation is based on the values of the ALT, AST and Platelet ~lab tests and the age of the patient. The calculation will look at the ~most recent lab values in the past 2 years. Optimally the three labs 
 ;;HCFIB4^would be on the same day but if they are not, they should be within 30 ~days of each other.~
 Q
