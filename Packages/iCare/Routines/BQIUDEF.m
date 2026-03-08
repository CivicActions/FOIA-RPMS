BQIUDEF ;GDIT/HCSD/ALA-VDEF definitions ; 16 Jun 2021  8:41 AM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**5**;Mar 01, 2021;Build 20
 ;
DEF ;EP - Add a definition
 NEW BI,BJ,BK,BN,BQIUPD,ERROR,IEN,ND,NDATA,TEXT,VAL,TTEXT,BJJ,DIK,DA,CIEN
 NEW PSUBF,PSUBT,SN,DIC
 F BI=1:1 S TEXT=$T(NUM+BI) Q:TEXT=" Q"  D
 . S CIEN=$P(TEXT,";;",2)
 . S TEXT=$P($T(ARR0+BI),";;",2) Q:TEXT=""
 . F BJ=1:1:$L(TEXT,"%") D
 .. S NDATA=$P(TEXT,"%",BJ) I NDATA="" Q
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. S ^BQI(90506.3,CIEN,ND)=VAL
 . S TEXT=$P($T(ARR1+BI),";;",2) Q:TEXT=""
 . F BJ=1:1:$L(TEXT,"%") D
 .. S NDATA=$P(TEXT,"%",BJ) I NDATA="" Q
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. S ^BQI(90506.3,CIEN,ND)=VAL
 . S TEXT=$P($T(ARR2+BI),";;",2) Q:TEXT=""
 . F BJ=1:1:$L(TEXT,"%") D
 .. S NDATA=$P(TEXT,"%",BJ) I NDATA="" Q
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. S ^BQI(90506.3,CIEN,ND)=VAL
 ;
 ; Do multiple fields (parameters, layout items and sublayout items)
 NEW PTEXT,ND,LAY,REC,CIEN,DATA,CLIN,TEXT,TN,TIP,NDATA
 F BI=1:1 S PTEXT=$T(PARM0+BI) Q:PTEXT=" Q"  D
 . S TEXT=$P(PTEXT,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),ND=$P(REC,":",2)
 . S ^BQI(90506.3,CIEN,ND,0)=DATA
 F BI=1:1 S PTEXT=$T(PARM+BI) Q:PTEXT=" Q"  D
 . S TEXT=$P(PTEXT,";;",2)
 . ; VN_":"_ND_":"_N
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),ND=$P(REC,":",2),TN=$P(REC,":",3)
 . S ^BQI(90506.3,CIEN,ND,TN,0)=DATA
 F BI=1:1 S PTEXT=$T(LAY0+BI) Q:PTEXT=" Q"  D
 . S TEXT=$P(PTEXT,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1)
 . S ^BQI(90506.3,CIEN,10,0)=DATA
 F BI=1:1 S LAY=$T(LAY+BI) Q:LAY=" Q"  D
 . S TEXT=$P(LAY,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2),ND=$P(REC,":",3)
 . S ^BQI(90506.3,CIEN,10,TN,ND)=DATA
 F BI=1:1 S PTEXT=$T(SUBF0+BI) Q:PTEXT=" Q"  D
 . S TEXT=$P(PTEXT,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2)
 . S ^BQI(90506.3,CIEN,10,TN,5,0)=DATA
 F BI=1:1 S PTEXT=$T(SUBT0+BI) Q:PTEXT=" Q"  D
 . S TEXT=$P(PTEXT,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2)
 . S ^BQI(90506.3,CIEN,10,TN,10,0)=DATA
 ;
 F BI=1:1 S PSUBF=$T(SUBF+BI) Q:PSUBF=" Q"  D
 . S TEXT=$P(PSUBF,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2),SN=$P(REC,":",3)
 . S ^BQI(90506.3,CIEN,10,TN,5,SN,0)=DATA
 F BI=1:1 S PSUBT=$T(SUBT+BI) Q:PSUBT=" Q"  D
 . S TEXT=$P(PSUBT,";;",2)
 . S REC=$P(TEXT,"\",1),DATA=$P(TEXT,"\",2)
 . S CIEN=$P(REC,":",1),TN=$P(REC,":",2),SN=$P(REC,":",3)
 . S ^BQI(90506.3,CIEN,10,TN,10,SN,0)=VAL
 ;
 S ^BQI(90506.3,0)="ICARE FILE DEFINITION^90506.3^86^84"
 ; Re-Index File
 S DIK="^BQI(90506.3,"
 F DA=87 D IX^DIK
 Q
 ;
NUM ;EP - Number of new sources
 ;;87
 Q
 ;
ARR0 ;EP - File definition node 0
 ;;0|Update Provider^90360.1^^BQI PATIENT PROVIDERS^^O^^^^^^BQI BATCH UPDATE PROVIDER
 Q
 ;
ARR1 ;EP - File definition node 1
 ;;%1|
 Q
 ;
ARR2 ;EP - File definition nodes 2,8
 ;;%2|%8|BQI VFILE DATA VALIDATION
 Q
 ;
PARM0 ;EP 
 ;;87:4\^90506.35^2^2
 Q
 ;
PARM ;EP
 ;;87:4:1\0|BQIPROV^I^1
 ;;87:4:2\0|BQIPRCAT^I^2
 Q
 ;
LAY0 ;EP
 ;;87\~0^90506.31I^1^1
 Q
 ;
LAY ;EP
 ;;87:1:0\Provider Category^T00030BQIPRCAT^^S^1^^BQIPRCAT^^^^^S
 ;;87:1:1\T^^^^A^R
 ;;87:1:2\^^90360.3^N^^^^^A
 ;;87:1:3\.01^E
 ;;87:1:4\
 ;;87:1:6\I $P(~(0),U,2)="MA"
 ;;87:1:7\
 ;;87:1:8\
 ;;87:1:9\
 ;;87:2:0\Provider Name^T00055BQIPROV^^S^2^^BQIPROV^^^^^S^^Y
 ;;87:2:1\T^^^^B^O
 ;;87:2:2\^^200^Y^N^N
 ;;87:2:3\.03^E
 ;;87:2:4\
 ;;87:2:6\I +$P($G(~(0)),U,11)'>0,$P(~(0),U,11)'>DT,$D(~VA(200,"AK.PROVIDER",$P($G(~(0)),U),+Y))
 ;;87:2:7\
 ;;87:2:8\
 ;;87:2:9\
 Q
 ;
SUBF0 ;EP
 Q
 ;
SUBF ;EP
 Q
 ;
SUBT0 ;EP
 Q
 ;
SUBT ;EP
 Q
