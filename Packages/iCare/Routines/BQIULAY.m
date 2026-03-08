BQIULAY ;GDHD/HS/ALA-Update Layout ; 10 Nov 2021  1:10 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,2,3,4,5,6,7**;Mar 01, 2021;Build 14
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
 ;;
 ;;Calls the Immunization Forecaster to determine what may be due for a ~patient.~
 ;;SUD diagnoses (IPL/POV) from SNOMED subset PICK BH-SUD in the past 12 ~months.~
 ;;Number of telemedicine visits in the past year.~
 ;;Location and date of telemedicine visits in the past year.~
 ;;Number of prenatal clinic visits in the past year. Prenatal clinics are ~defined in iCare Site Parameters.~
 ;;Prenatal clinic visits and date in the past year. Prenatal clinics are~defined in iCare Site Parameters.~
 ;;Number of prenatal radiology visits in the past year. Prenatal radiology ~clinics are defined in iCare Site Parameters.~
 ;;The clinic and date of any prenatal radiology visits in the past year. ~Prenatal radiology clinics are defined in iCare Site Parameters.~
 ;;Number of Emergency Department visits in the past year.~
 ;;Emergency room visits in the past year.~
 ;;Number of labor and delivery acute visits in the past year. L&D clinics ~are defined in iCare Site Parameters.~
 ;;Labor and delivery clinic visits in the past year. L&D clinics are ~defined in iCare Site Parameters.~
 ;;Total number of prenatal clinic appointments in the past year that were ~No Show.~
 ;;The Prenatal Visit Clinics that were No Shows.~
 ;;Total number of prenatal radiology appointments in the past year that ~were No Show.~
 ;;The Prenatal Radiology Clinics that were No Shows.~
 ;;Total number of prenatal consults in the past year. Consults defined in ~iCare Site Parameters.~
 ;;Prenatal consults in the past year. Consults defined in iCare Site ~Parameters.~
 ;;Total number of prenatal referrals in the past year. Referrals defined in ~the iCare Site Parameters.~
 ;;Prenatal referrals in the past year. Referrals defined in iCare Site ~Parameters.~
 ;;Total number of prenatal clinic appointments in the past year that were ~cancelled by the patient.~
 ;;The Prenatal Visit Clinics that were Patient Cancelled.~
 ;;Total number of prenatal radiology appointments in the past year that ~were patient cancelled.~
 ;;The Prenatal Radiology Clinics that were Patient Cancelled.~
 ;;A pregnant patient can choose to get RSV vaccine during weeks 32 through ~36 of their pregnancy. If a patient has gotten a RSVbv immunization in ~that timeframe based on their Definitive Estimated Delivery Date, it will ~show YES.~
 ;;
 Q
 ;
ARR ; Array
 ;;0|PCELL^^Patient Cell Phone^^2^.134^^T00020PCELL~1|~3|1^^Demographics^O^104~5|
 ;;0|IMDUE^^Immunizations Due^^^^^T01024IMDUE^^^^^^^150~1|S VAL=$$IMDUE^BQIULP1(DFN)~3|1^^Other Patient Data^O^105~5|
 ;;0|PGSUDX^^SUD Diagnoses^^^^^T01024PGSUDX~1|S VAL=$$DXN^BQIRGPG1(DFN)~3|36^^^O^31~5|
 ;;0|PGTELMN^^# Telemedicine Visits^^^^^I00010PGTELMN~1|S VAL=$$OTVIS^BQIRGPG1(DFN,"TELM",1)~3|36^^^O^32~5|
 ;;0|PGTELMV^^Telemedicine Visits^^^^^T01024PGTEMV~1|S VAL=$$OTVIS^BQIRGPG1(DFN,"TELM","")~3|36^^^O^33~5|
 ;;0|PGPRNVN^^# of Prenatal Visits^^^^^I00010PGPRNVN~1|S VAL=$$PRVIS^BQIRGPG1(DFN,"BQIPGVST",1)~3|36^^^O^34~5|
 ;;0|PGPRNVV^^Prenatal Clinic Visits^^^^^T01024PGPRNVV~1|S VAL=$$PRVIS^BQIRGPG1(DFN,"BQIPGVST","")~3|36^^^O^35~5|
 ;;0|PGPRNRN^^# of Prenatal Radiology Visits^^^^^I00010PGPRNRN~1|S VAL=$$PRVIS^BQIRGPG1(DFN,"BQIPGRD",1)~3|36^^^O^36~5|
 ;;0|PGPRNRV^^Prenatal Radiology Visits^^^^^T01024PGPRNRV~1|S VAL=$$PRVIS^BQIRGPG1(DFN,"BQIPGRD","")~3|36^^^O^37~5|
 ;;0|PGPRNEN^^# of ED Visits^^^^^I00010PGPRNEN~1|S VAL=$$OTVIS^BQIRGPG1(DFN,"ER",1)~3|36^^^O^38~5|
 ;;0|PGPRNEV^^ED Visits^^^^^T01024PGPRNEV~1|S VAL=$$OTVIS^BQIRGPG1(DFN,"ER","")~3|36^^^O^39~5|
 ;;0|PGPRLDN^^# of L&D Visits^^^^^I00010PGPRLDN~1|S VAL=$$PRVIS^BQIRGPG1(DFN,"BQIPGLD",1)~3|36^^^O^40~5|
 ;;0|PGPRLDV^^L&D Visits^^^^^T01024PGPRLDV~1|S VAL=$$PRVIS^BQIRGPG1(DFN,"BQIPGLD","")~3|36^^^O^41~5|
 ;;0|PGPRNS^^# Prenatal Clinic No Shows^^^^^I00010PGPRNS~1|S VAL=$$APT^BQIRGPG1(DFN,"NS","BQIPGVST","")~3|36^^^O^42~5|
 ;;0|PGPRNSCL^^No Shows by Prenatal Clinic^^^^^T01024PGPRNSCL~1|S VAL=$$APT^BQIRGPG1(DFN,"NS","BQIPGVST",1)~3|36^^^O^43~5|
 ;;0|PGPRNSRD^^# Prenatal Radiology No Shows^^^^^I00010PGPRNSRD~1|S VAL=$$APT^BQIRGPG1(DFN,"NS","BQIPGRD","")~3|36^^^O^44~5|
 ;;0|PGPRNSRC^^No Shows by Prenatal Radiology^^^^^T01024PGPRNSRC~1|S VAL=$$APT^BQIRGPG1(DFN,"NS","BQIPGRD",1)~3|36^^^O^45~5|
 ;;0|PGPRCON^^# Prenatal Consults^^^^^I00010PGPRCON~1|S VAL=$$CONS^BQIRGPG1(DFN,1)~3|36^^^O^46~5|
 ;;0|PGPRCONS^^Prenatal Consults^^^^^T01024PGPRCONS~1|S VAL=$$CONS^BQIRGPG1(DFN,"")~3|36^^^O^47~5|
 ;;0|PGPRREF^^# Prenatal Referrals^^^^^I00010PGPRREF~1|S VAL=$$REFRS^BQIRGPG1(DFN,1)~3|36^^^O^48~5|
 ;;0|PGPRREFS^^Prenatal Referrals^^^^^T01024PGPRREFS~1|S VAL=$$REFRS^BQIRGPG1(DFN,"")~3|36^^^O^49~5|
 ;;0|PGPRPC^^# Prenatal Clinic Patient Cancels^^^^^I00010PGPRPC~1|S VAL=$$APT^BQIRGPG1(DFN,"PC","BQIPGVST","")~3|36^^^O^50~5|
 ;;0|PGPRPCCL^^Patient Cancels by Prenatal Clinic^^^^^T01024PGPRPCCL~1|S VAL=$$APT^BQIRGPG1(DFN,"PC","BQIPGVST",1)~3|36^^^O^51~5|
 ;;0|PGPRPCRD^^# Prenatal Radiology Patient Cancels^^^^^I00010PGPRPCRD~1|S VAL=$$APT^BQIRGPG1(DFN,"PC","BQIPGRD","")~3|36^^^O^52~5|
 ;;0|PGPRPCRC^^Patient Cancels by Prenatal Radiology^^^^^T01024PGPRPCRC~1|S VAL=$$APT^BQIRGPG1(DFN,"PC","BQIPGRD",1)~3|36^^^O^53~5|
 ;;0|PGPRRSV^^Prenatal RSV Immunization^^^^^T00010PGPRRSV~1|S VAL=$$RSV^BQIRGPG(DFN)~3|36^^^O^54~5|
 ;;0|PGCTRIM^^Current Trimester^^^^^T00010PGCTRIM~1|S VAL=$$TRIM^BQIRGPG(DFN)~3|36^^^O^55~5|
 Q
 ;
TIPL ; Long Tooltips (>255 characters)
 Q
