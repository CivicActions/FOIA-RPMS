BQIRMDR2 ;GDHS/HCD/ALA-Forecaster Reminders ; 05 Feb 2016  3:28 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,3**;Mar 01, 2021;Build 32
 ;
 ;
IFR ; EP - Immunization Forecaster
 S BQIUPD(90508,"1,",4.19)=$$NOW^XLFDT()
 D FILE^DIE("","BQIUPD","ERROR")
 D PTLS^BQIRMIZ
 S BQIUPD(90508,"1,",4.2)=$$NOW^XLFDT()
 D FILE^DIE("","BQIUPD","ERROR")
 NEW RCAT,RCLIN,IN,IMM,TEXT,CODE,HDR,RIEN
 S RCAT="IZ Forecaster",RCLIN="Immunizations"
 I $G(SOURCE)="" S SOURCE="Reminders"
 S IMM=""
 F  S IMM=$O(^BIPDUE("C",IMM)) Q:IMM=""  D
 . ;S IMM=$P(^BIPDUE(IMN,0),"^",2)
 . ; if forecast was not updated with active patients logic in PTLS, quit
 . ;I $P(^BIPDUE(IMN,0),"^",6)<DT Q
 . ; If not enabled for forecaster, quit
 . I $P(^BITN(IMM,0),U,16)=1 Q
 . S TEXT=$P(^BITN(IMM,0),U,2)
 . S CODE="IZ_"_TEXT
 . S HDR="T00050"_CODE
 . S RIEN="",RIEN=$O(^BQI(90506.1,"B",CODE,RIEN))
 . I RIEN'="" D  Q
 .. I $P(^BQI(90506.1,RIEN,0),"^",10)="" Q
 .. D REA^BQIRMDR1
 . D FILE^BQIRMZDR
 Q
 ;
FRC ;EP - update forecaster
 NEW RCAT,RCLIN,IN,IMM,TEXT,CODE,HDR,RIEN
 S RCAT="IZ Forecaster",RCLIN="Immunizations"
 I $G(SOURCE)="" S SOURCE="Reminders"
 S IMM=""
 F  S IMM=$O(^BIPDUE("C",IMM)) Q:IMM=""  D
 . ; If not enabled for forecaster, quit
 . I $P(^BITN(IMM,0),U,16)=1 Q
 . S TEXT=$P(^BITN(IMM,0),U,2)
 . S CODE="IZ_"_TEXT
 . S HDR="T00050"_CODE
 . S RIEN="",RIEN=$O(^BQI(90506.1,"B",CODE,RIEN))
 . I RIEN'="" D  Q
 .. I $P(^BQI(90506.1,RIEN,0),"^",10)="" Q
 .. D REA^BQIRMDR1
 . D FILE^BQIRMZDR
 Q
 ;
IZ(BQRDFN,BQIIJB) ;EP
 K VALUE,FRN,IMN,RCDUE,OVDUE,RCDUE,OVDUE,REMDUE,REMLAST,CODE
 S SUB=$S(BQIIJB="N":"BQIRMFORN",1:"BQIRMFORW")
 S IMN="" F  S IMN=$O(^XTMP(SUB,BQRDFN,IMN)) Q:IMN=""  D
 . S (REMDUE,REMLAST,REMNEXT)=""
 . S VALUE=$G(^XTMP(SUB,BQRDFN,IMN))
 . S REMLAST=$P(VALUE,"^",1),REMDUE=$P(VALUE,"^",2),REMNEXT=$P(VALUE,"^",3)
 . D CHK(IMN)
 . S CODE="IZ_"_$P(^BITN(IMN,0),U,2)
 . D FIL^BQIRMZDR
 K VALUE,FRN,IMN,RCDUE,OVDUE,RCDUE,OVDUE,REMDUE,REMLAST,CODE
 Q
 ;
CHK(IMN) ;EP
 NEW RCAT,RCLIN,IN,IMM,TEXT,CODE,HDR,RIEN
 S RCAT="IZ Forecaster",RCLIN="Immunizations"
 I $G(SOURCE)="" S SOURCE="Reminders"
 ; If not enabled for forecaster, quit
 I $P(^BITN(IMN,0),U,16)=1 Q
 S TEXT=$P(^BITN(IMN,0),U,2)
 S CODE="IZ_"_TEXT
 S HDR="T00050"_CODE
 S RIEN="",RIEN=$O(^BQI(90506.1,"B",CODE,RIEN))
 I RIEN'="" D  Q
 . D REA^BQIRMDR1
 D FILE^BQIRMZDR
 Q
