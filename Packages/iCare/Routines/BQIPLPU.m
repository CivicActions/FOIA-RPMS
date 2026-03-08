BQIPLPU ;GDIT/HCSD/ALA-Panel Autopopulate Utility ; 29 Sep 2015  1:06 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**5**;Mar 01, 2021;Build 20
 ;
SXRF ;EP - Set cross-reference
 I $G(DA)'="",$G(DA(1))'="" S ^BQICARE("AF",X,DA(1),DA)="" Q
 S ^BQICARE("AF",X,D0,D1)=""
 Q
 ;
KXRF ; EP - Kill cross-reference
 I $G(DA)'="",$G(DA(1))'="" K ^BQICARE("AF",X,DA(1),DA) Q
 K ^BQICARE("AF",X,D0,D1)
 Q
 ;
SRXF ;EP - Set cross-reference
 I $G(DA)'="",$G(DA(1))'="" S ^BQICARE("AH",X,DA(1),DA)="" Q
 S ^BQICARE("AH",X,D0,D1)=""
 Q
 ;
KRXF ; EP - Kill cross-reference
 I $G(DA)'="",$G(DA(1))'="" K ^BQICARE("AH",X,DA(1),DA) Q
 K ^BQICARE("AH",X,D0,D1)
 Q
 ;
ORD ; EP - Order the Nightly Autopopulate panels
 NEW USR,PNL,BQPB,BQPE,BQDIF,BQIORD,BQIUP,ORD,ORN,IENS,DA,BQRM,BQIREM
 K ^BQICARE("AF"),^BQICARE("AH")
 S USR=""
 F  S USR=$O(^BQICARE("AC","N",USR)) Q:'USR  D
 . S PNL=""
 . F  S PNL=$O(^BQICARE("AC","N",USR,PNL)) Q:'PNL  D
 .. S BQPB=$P($G(^BQICARE(USR,1,PNL,3)),"^",8)
 .. S BQPE=$P($G(^BQICARE(USR,1,PNL,3)),"^",9)
 .. S BQRM=+$P($G(^BQICARE(USR,1,PNL,3)),"^",12)
 .. S BQDIF=$$FMDIFF^XLFDT(BQPE,BQPB,2)
 .. I 'BQRM S BQIORD(BQDIF,USR,PNL)=""
 .. I BQRM S BQIREM(BQDIF,USR,PNL)=""
 .. S DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 .. S BQIUP(90505.01,IENS,3.1)="@"
 D FILE^DIE("","BQIUP","ERROR")
 ;
 S ORD="",ORN=0
 F  S ORD=$O(BQIORD(ORD),-1) Q:ORD=""  D
 . S USR="" F  S USR=$O(BQIORD(ORD,USR)) Q:USR=""  D
 .. S PNL="" F  S PNL=$O(BQIORD(ORD,USR,PNL)) Q:PNL=""  D
 ... S ORN=ORN+1,DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 ... S BQIUP(90505.01,IENS,3.1)=ORN
 D FILE^DIE("","BQIUP","ERROR")
 ;
 S ORD="",ORN=0
 F  S ORD=$O(BQIREM(ORD),-1) Q:ORD=""  D
 . S USR="" F  S USR=$O(BQIREM(ORD,USR)) Q:USR=""  D
 .. S PNL="" F  S PNL=$O(BQIREM(ORD,USR,PNL)) Q:PNL=""  D
 ... S ORN=ORN+1,DA(1)=USR,DA=PNL,X=ORN D SRXF
 Q
