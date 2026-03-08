BQIUSRC ;GDHD/HS/ALA-Update Source ; 23 Nov 2020  9:43 AM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,2,3,4,5,6,7**;Mar 01, 2021;Build 14
 ;
SRC ;EP - Add a source
 NEW BI,BJ,BK,BN,BQIUPD,ERROR,IEN,ND,NDATA,TEXT,VAL,TTEXT,BJJ
 F BI=1:1 S TEXT=$T(NUM+BI) Q:TEXT=" Q"  D
 . S CIEN=$P(TEXT,";;",2)
 . S TEXT=$P($T(ARR0+BI),";;",2) Q:TEXT=""
 . F BJ=1:1:$L(TEXT,"%") D
 .. S NDATA=$P(TEXT,"%",BJ) I NDATA="" Q
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. S ^BQI(90506.5,CIEN,ND)=VAL
 . S TEXT=$P($T(ARR2+BI),";;",2) Q:TEXT=""
 . F BJ=1:1:$L(TEXT,"%") D
 .. S NDATA=$P(TEXT,"%",BJ) I NDATA="" Q
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. S ^BQI(90506.5,CIEN,ND)=VAL
 . S TEXT=$P($T(ARR3+BI),";;",2) Q:TEXT=""
 . F BJ=1:1:$L(TEXT,"%") D
 .. S NDATA=$P(TEXT,"%",BJ) I NDATA="" Q
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. S ^BQI(90506.5,CIEN,ND)=VAL
 ;
 ; Do multiple fields (categories, clinical groups, layout items and tooltips)
 NEW CAT,LAY,REC,CIEN,DATA,CLIN,TEXT,TN,TIP,NDATA
 F BI=1:1 S CAT=$T(CAT+BI) Q:CAT=" Q"  D
 . S TEXT=$P(CAT,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2)
 . S ^BQI(90506.5,CIEN,5,0)="^90506.55^"_TN_"^"_TN
 . S ^BQI(90506.5,CIEN,5,TN,0)=DATA
 F BI=1:1 S CLIN=$T(CLIN+BI) Q:CLIN=" Q"  D
 . S TEXT=$P(CLIN,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2)
 . S ^BQI(90506.5,CIEN,6,0)="^90506.65^"_TN_"^"_TN
 . S ^BQI(90506.5,CIEN,6,TN,0)=DATA
 F BI=1:1 S LAY=$T(LAY+BI) Q:LAY=" Q"  D
 . S TEXT=$P(LAY,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2)
 . S ^BQI(90506.5,CIEN,10,0)="^90506.51I^"_TN_"^"_TN
 . F BJ=1:1:$L(DATA,"~") D
 .. S NDATA=$P(DATA,"~",BJ)
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. S ^BQI(90506.5,CIEN,10,TN,ND)=VAL
 F BI=1:1 S TIP=$T(TIP+BI) Q:TIP=" Q"  D
 . S TEXT=$P(TIP,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2) Q:DATA=""
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2)
 . F BJ=1:1:$L(DATA,"~") D
 .. S NDATA=$P(DATA,"~",BJ) Q:NDATA=""
 .. S ^BQI(90506.5,CIEN,10,TN,4,0)="^90506.514^"_BJ_"^"_BJ_"^"_DT
 .. S ^BQI(90506.5,CIEN,10,TN,4,BJ,0)=NDATA
 ;
 ; Re-Index File
 S DIK="^BQI(90506.5,"
 F DA=27,28,48,56,46,45,52,53,62,63,35 D IX^DIK
 Q
 ;
NUM ;EP - Number of new sources
 ;;62
 ;;63
 Q
 ;
ARR0 ;EP - Source nodes 0,1
 ;;0|Consults DD^CD^^^^^^^Consults (DD) Default^^^^1^^1^^CONS%1|
 ;;0|Suicide Management^SU^^1^^^^^Suicide Management Default^^^^1^1%1|
 Q
 ;
ARR2 ;EP - Source node 2
 ;;%2|DDConsults^Definition Details - Consults^^90505.1231^90505.3231^1
 ;;%2|Suicide Management^Care Mgmt - Suicide Mgmt^^90505.1231^90505.3231^1
 Q
 ;
ARR3 ;EP - Source node 3,4
 ;;%3|BQI GET CARE MGMT LIST~Patient" + (char)29 + "Consults DD"%4|BQI GET CARE MGMT VIEW~~~Consults DD
 ;;%3|BQI GET CARE MGMT LIST~Patient" + (char)29 + "Suicide Management%4|BQI GET CARE MGMT VIEW~~~Suicide Management
 Q
 ;
CAT ;EP - Any Categories
 Q
 ;
CLIN ;EP - Any Clinical Groups
 Q
 ;
LAY ;EP - Any layout items
 ;;27:15\0|LA_015^^Hosp Location^^R^O~1|D EX("LA",RIEN,"HLOC",.RESULT)
 ;;28:1\0|PR_001^^Primary ICD^^R^D^^^^125~1|D EX^BQICMUT5("PR",RIEN,.01,.RESULT)
 ;;28:14\0|PR_014^^Secondary ICD^^R^O^^^^125~1|D EX^BQICMUT5("PR",RIEN,"SECOND",.RESULT)
 ;;48:18\0|VC_018^^Hosp Location^^R^O~1|D DEF^BQICMUT1("VC",RIEN,"HLOC",.RESULT)
 ;;48:19\0|VC_019^^Clinic^^R^O~1|D DEF^BQICMUT1("VC",RIEN,"CLIN",.RESULT)
 ;;27:16\0|LA_016^^Clinic^^R^O~1|D EX("LA",RIEN,"CLIN",.RESULT)
 ;;56:11\0|VS_011^^Primary Provider^^R^D^^^^125~1|D LAY^BQICMUT5("VS",RIEN,"PPROV",.RESULT)
 ;;56:12\0|VS_012^^Secondary Providers^^R^O^^^^125~1|D LAY^BQICMUT5("VS",RIEN,"SPROV",.RESULT)
 ;;56:13\0|VS_013^^Primary ICD Diagnosis^^R^O^^^^125~1|D LAY^BQICMUT5("VS",RIEN,"PDIAG",.RESULT)
 ;;56:14\0|VS_014^^Secondary ICD Diagnosis^^R^O^^^^125~1|D LAY^BQICMUT5("VS",RIEN,"SDIAG",.RESULT)
 ;;53:21\0|ORD_021_DT^^Order Date/Time^^D^O^^S^^125~1|D EX^BQICMUT4("OR",RIEN,"ODATE",.RESULT)
 ;;53:22\0|ORD_022_DT^^Start Date/Time^^D^O^^S^^125~1|D EX^BQICMUT4("OR",RIEN,"SADATE",.RESULT)
 ;;53:23\0|ORD_023_DT^^Stop Date/Time^^D^O^^S^^125~1|D EX^BQICMUT4("OR",RIEN,"SODATE",.RESULT)
 ;;46:8\0|EX_008^^Site Location^^R^O~1|D DEF^BQICMUT1("EX",RIEN,"LOC",.RESULT)
 ;;46:9\0|EX_009^^Hosp Location^^R^O~1|D DEF^BQICMUT1("EX",RIEN,"HLOC",.RESULT)
 ;;45:12\0|MS_012^^Site Location^^R^O~1|D DEF^BQICMUT1("MS",RIEN,"LOC",.RESULT)
 ;;45:13\0|MS_013^^Hosp Location^^R^O~1|D DEF^BQICMUT1("MS",RIEN,"HLOC",.RESULT)
 ;;52:8\0|HF_008^^Site Location^^R^O~1|D DEF^BQICMUT1("HF",RIEN,"LOC",.RESULT)
 ;;52:9\0|HF_009^^Hosp Location^^R^O~1|D DEF^BQICMUT1("HF",RIEN,"HLOC",.RESULT)
 ;;62:1\0|CD_001^^Request Date^^D^D^^S~1|D LAY^BQICMUT6("CD",RIEN,"RDATE",.RESULT)
 ;;62:2\0|CD_002^^To Service/Specialty^^R^D~1|D LAY^BQICMUT6("CD",RIEN,1,.RESULT)
 ;;62:3\0|CD_003^^Reason for Request^^R^D^^^^250~1|D LAY^BQICMUT6("CD",RIEN,"REAS",.RESULT)
 ;;62:4\0|CD_004^^Category^^R^D~1|D LAY^BQICMUT6("CD",RIEN,14,.RESULT)
 ;;62:5\0|CD_005^^Urgency^^R^D~1|D LAY^BQICMUT6("CD",RIEN,5,.RESULT)
 ;;62:6\0|CD_006^^Place of Consultation^^R^O~1|D LAY^BQICMUT6("CD",RIEN,6,.RESULT)
 ;;62:7\0|CD_007^^Attention^^R^D~1|D LAY^BQICMUT6("CD",RIEN,7,.RESULT)
 ;;62:8\0|CD_008^^SNOMED Concept ID^^R^O~1|D LAY^BQICMUT6("CD",RIEN,"SNOM",.RESULT)
 ;;62:9\0|CD_009^^Provisional Diagnosis^^R^D~1|D LAY^BQICMUT6("CD",RIEN,"PDXN",.RESULT)
 ;;62:10\0|RNOTE^^Result Note^^D^D^^A~1|D LAY^BQICMUT6("CD",RIEN,"RNOTE",.RESULT)
 ;;62:11\0|CD_011^^From^^R^O~1|D LAY^BQICMUT6("CD",RIEN,2,.RESULT)
 ;;62:12\0|CD_012^^Ordering Facility^^R^O~1|D LAY^BQICMUT6("CD",RIEN,.05,.RESULT)
 ;;62:13\0|CD_013^^Request Type^^R^O~1|D LAY^BQICMUT6("CD",RIEN,13,.RESULT)
 ;;62:14\0|CD_014^^Sending Provider^^R^O~1|D LAY^BQICMUT6("CD",RIEN,10,.RESULT)
 ;;62:15\0|HIDE_RNOTE^^Hidden Note Link^^R^D~1|D LAY^BQICMUT6("CD",RIEN,"RNOTEH",.RESULT)
 ;;62:16\0|CD_015^^Status^^R^D~1|D LAY^BQICMUT6("CD",RIEN,8,.RESULT)
 ;;63:1\0|SU_001^^Suicide Screening Exam^^R^D~1|D PLAY^BQICMUT6("SU",DFN,"SCRN",.RESULT)
 ;;63:2\0|SU_002^^Suicide Risk Exam^^R^D~1|D PLAY^BQICMUT6("SU",DFN,"RISK",.RESULT)
 ;;63:3\0|SU_003^^Depression Screen Exam^^R^D~1|D PLAY^BQICMUT6("SU",DFN,"DEPR",.RESULT)
 ;;63:4\0|SU_004^^SUD Diagnoses^^R^O^^^^125~1|D PLAY^BQICMUT6("SU",DFN,"SUD",.RESULT)
 ;;35:1\0|RE_001^^Reminder Due^^D^R^^A~1|S RESULT=$$RM^BQIMTCR1(DFN,RIEN,"DUE",.RESULT)
 ;;35:2\0|REMCODE^^Reminder^^R^D~1|S RESULT=$$RM^BQIMTCR1(DFN,RIEN,"CODE",.RESULT)
 ;;35:3\0|RE_003^^Notification Date^^D^D~1|S RESULT=$$RM^BQIMTCR1(DFN,RIEN,.04,.RESULT)
 ;;35:4\0|RE_004^^Notification Method^^R^D~1|S RESULT=$$RM^BQIMTCR1(DFN,RIEN,.03,.RESULT)
 ;;35:5\0|RE_005^^Creator^^R^O~1|S RESULT=$$RM^BQIMTCR1(DFN,RIEN,.05,.RESULT)
 ;;35:6\0|RE_006^^Eligible Provider^^R^O~1|S RESULT=$$RM^BQIMTCR1(DFN,RIEN,.08,.RESULT)
 ;;35:7\0|RE_007^^Completion Date^^D^O^^A~1|S RESULT=$$RM^BQIMTCR1(DFN,RIEN,.11,.RESULT)
 ;;35:8\0|HIDE_REMCODE^^Hide Reminder Code^^R^D~1|S RESULT=$$RM^BQIMTCR1(DFN,RIEN,"HCODE",.RESULT)
 ;;35:9\0|HIDE_REMMETH^^Hide Reminder Notification Method^^R^D~1|S RESULT=$$RM^BQIMTCR1(DFN,RIEN,"HMETH",.RESULT)
 Q
 ;
TIP ;EP - Tooltips
 ;;63:1\Most Recent Suicide Screening Exam or Refusal of Suicide Screening Exam.~
 ;;63:2\Most Recent Suicide Risk Exam or Refusal of Suicide Risk Exam.~
 ;;63:3\Most recent Depression Screening Exam or Refusal of Depression Screening ~Exam.~
 ;;63:4\IPL entries using SNOMED subset PICK BH-SUD.~
 ;;62:9\This is also known as the Clinical Indicator.
 Q
