BQICACCD ;GDIT/HS/ALA-CANES CCD Export ; 06 Dec 2019  4:18 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**3**;Mar 01, 2021;Build 32
 ;
EN ;EP
 S CASE="" F  S CASE=$O(^BQI(90507.6,"V",CASE)) Q:CASE=""  D
 . S TYP="" F  S TYP=$O(^BQI(90507.6,"V",CASE,TYP)) Q:TYP=""  D
 .. I TYP="P" D PROB Q
 .. S VIS="" F  S VIS=$O(^BQI(90507.6,"V",CASE,TYP,VIS)) Q:VIS=""  D
 ... S DFN="" F  S DFN=$O(^BQI(90507.6,"V",CASE,TYP,VIS,DFN)) Q:DFN=""  D
 .... I $$DEMO^APCLUTL(DFN,"E")=1 Q
 .... S CMN=$O(^BQI(90507.6,"V",CASE,TYP,VIS,DFN,"")),ALTYP=$O(^BQI(90507.6,"V",CASE,TYP,VIS,DFN,CMN,""))
 .... S CTN=$O(^BQI(90507.6,"V",CASE,TYP,VIS,DFN,CMN,ALTYP,""))
 .... S DX=$O(^BQI(90507.6,"V",CASE,TYP,VIS,DFN,CMN,ALTYP,CTN,""))
 .... S DATA=$G(^BQI(90507.6,CMN,1,ALTYP,1,CTN,1,DX,0))
 .... I DATA="" S DATA=$G(^BQI(90507.6,CMN,1,ALTYP,1,CTN,2,DX,0))
 .... S GRP="",CAT=$P(^BQI(90507.6,CMN,1,ALTYP,1,CTN,0),U,1)
 .... S RIEN=$P(DATA,U,3),DATE=$P(DATA,U,2),DXN=$P(DATA,U,1),VISIT=$P(DATA,U,6),VFILE=$P(DATA,U,5)
 .... I VISIT="" S VISIT=RIEN
 .... I $D(^BQI(90507.7,"AC",DFN,CASE,RIEN)) Q
 .... I $D(^BQI(90507.7,"AC",DFN,CASE,VISIT)) Q
 .... S OK=$$PROC(DFN,VISIT,CASE) I 'OK Q
 .... HANG 1
 .... D EXP
 ;
 D DUO
 ;D sendto
 Q
 ;
PROB ;EP
 S PROB="" F  S PROB=$O(^BQI(90507.6,"V",CASE,TYP,PROB)) Q:PROB=""  D
 . S DFN="" F  S DFN=$O(^BQI(90507.6,"V",CASE,TYP,PROB,DFN)) Q:DFN=""  D
 .. I $$DEMO^APCLUTL(DFN,"E")=1 Q
 .. S CMN=$O(^BQI(90507.6,"V",CASE,TYP,PROB,DFN,"")),ALTYP=$O(^BQI(90507.6,"V",CASE,TYP,PROB,DFN,CMN,""))
 .. S CTN=$O(^BQI(90507.6,"V",CASE,TYP,PROB,DFN,CMN,ALTYP,""))
 .. S DX=$O(^BQI(90507.6,"V",CASE,TYP,PROB,DFN,CMN,ALTYP,CTN,""))
 .. S DATA=$G(^BQI(90507.6,CMN,1,ALTYP,1,CTN,1,DX,0))
 .. I DATA="" S DATA=$G(^BQI(90507.6,CMN,1,ALTYP,1,CTN,2,DX,0))
 .. S GRP="",CAT=$P(^BQI(90507.6,CMN,1,ALTYP,1,CTN,0),U,1)
 .. S RIEN=$P(DATA,U,3),DATE=$P(DATA,U,2),DXN=$P(DATA,U,1),VISIT=$P(DATA,U,6),VFILE=$P(DATA,U,5)
 .. I VISIT="" S VISIT=$O(^AUPNVSIT("AC",DFN,""),-1) I VISIT="" Q
 .. I $D(^BQI(90507.7,"AC",DFN,CASE,RIEN)) Q
 .. I $D(^BQI(90507.7,"AC",DFN,CASE,VISIT)) Q
 .. S OK=$$PROC(DFN,VISIT,CASE) I 'OK Q
 .. HANG 1
 .. D EXP
 Q
 ;
DUO ; EP - Already generated HL7 file
 NEW DIC,EXIEN,RC,OK,DFN,VISIT,Y,X,CASE,BQIDET,FILE
 S DIC(0)="X",DLAYGO=90507.7,DIC="^BQI(90507.7,",X=DT D ^DIC
 S EXIEN=+Y
 I EXIEN=-1!($O(^BQI(90507.7,EXIEN,10,0))="") D  Q
 . D LAB
 . I $D(^XTMP("BQICAVAL")),$D(^BQI(90507.7,"B",DT)) K ^XTMP("BQICAVAL") D SEND Q
 . D NOF
 . D NOFF
 S RC=0 F  S RC=$O(^BQI(90507.7,EXIEN,10,RC)) Q:'RC  D
 . S DFN=$P(^BQI(90507.7,EXIEN,10,RC,0),"^",1),VISIT=$P(^(0),"^",2),CASE=$P(^(0),"^",7),FILE=$P(^(0),"^",9)
 . I $$DEMO^APCLUTL(DFN,"E")=1 Q
 . I FILE=9000011 S VISIT=$O(^AUPNVSIT("AC",DFN,""),-1) I VISIT="" Q
 . S OK=$$PROC(DFN,VISIT,CASE) I 'OK Q
 . HANG 1
 . S BQIDET(1)=DFN_"^"_VISIT
 . S RES=$$LOG^BUSAAPI("A","P","P","Case Report Audit API Call","BQI: Case Reporting Export for "_CASE,"BQIDET")
 ;
 D LAB
 ;
 D SEND
 Q
 ;
LAB ; Labs
 ; With all the new lab taxonomies no longer need to do Lab
 Q
 D LAB^BQICAVAL
 ; Process lab data
 NEW DFN,TYP,VDATE,CAES,RIEN,VFILE,LAB,VISIT,OK,BQIDET,RES,STAT
 S DFN=""
 F  S DFN=$O(^XTMP("BQICAVAL",DFN)) Q:DFN=""  D
 . I $$DEMO^APCLUTL(DFN,"E")=1 Q
 . S TYP=""
 . F  S TYP=$O(^XTMP("BQICAVAL",DFN,TYP)) Q:TYP=""  D
 .. S VDATE="",CASE=$P(^BQI(90507.8,TYP,0),"^",1)
 .. F  S VDATE=$O(^XTMP("BQICAVAL",DFN,TYP,"LB",VDATE)) Q:VDATE=""  D
 ... S RIEN=""
 ... F  S RIEN=$O(^XTMP("BQICAVAL",DFN,TYP,"LB",VDATE,RIEN)) Q:RIEN=""  D
 .... S VFILE=$P(^XTMP("BQICAVAL",DFN,TYP,"LB",VDATE,RIEN),U,2)
 .... S LAB=$P(^XTMP("BQICAVAL",DFN,TYP,"LB",VDATE,RIEN),U,1)
 .... S VISIT=$S(VFILE=9000010.25:$P($G(^AUPNVMIC(RIEN,0)),U,3),1:$P($G(^AUPNVLAB(RIEN,0)),U,3))
 .... S STAT=$$GET1^DIQ(VFILE,RIEN_",",1109,"I")
 .... I VISIT="" S VISIT=RIEN
 .... I $D(^BQI(90507.7,"AC",DFN,CASE,VISIT)) Q
 .... I $D(^BQI(90507.7,"AC",DFN,CASE,RIEN)) Q
 .... HANG 1
 .... S OK=$$PROC(DFN,VISIT,CASE) I 'OK Q
 .... I STAT="R"!(STAT="M")!(STAT="D") D EXP1
 .... S BQIDET(1)=DFN_"^"_VISIT
 .... S RES=$$LOG^BUSAAPI("A","P","P","Case Report Audit API Call","BQI: Case Reporting Export for "_CASE,"BQIDET")
 Q
 ;
PROC(DFN,VIEN,CASE) ;EP
 ; Input: DFN  - Patient IEN
 ;        VIEN - Visit IEN
 ;        CASE - Case Trigger
 ; Output: 
 ;   1: Successful
 ;  -1: No Visit
 ;   0: Queuing error
 NEW CCD,AUDIT,SC,EXEC,PATH,ASUFAC,FLNM,TEXT,COUNTY,COMM,CTYP,CCAT,CSN,CDISP,CCASE
 S PATH=$P($G(^AUTTSITE(1,1)),"^",2)
 I PATH="" S PATH=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 S ASUFAC=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S FLNM=$S('$$PROD^XUPROD():"CASEZ",1:"CASE")_"_"_ASUFAC_"_"_$$DATE(DT)_$P($$NOW^XLFDT(),".",2)_"_"_DFN_VIEN_".xml"
 S CCASE=CASE
 ; processing a request.
 S EXEC="set CCD=##class(BCCD.Xfer.Queue).%New()" X EXEC
 S EXEC="set AUDIT=##class(BCCD.Audit.AuditLog).%New()" X EXEC
 S EXEC="set CCD.PatientId=DFN,CCD.RequestTimestamp=$zdt($h,3,1)" X EXEC
 S EXEC="set CCD.PushFlag=1,CCD.DocType=""CR"",CCD.AuditLog=AUDIT" X EXEC
 S EXEC="set CCD.CaseReporting=##class(BCCD.Xfer.CaseReporting).%New()" X EXEC
 S CTYP="",CSN=$O(^BQI(90507.8,"B",CASE,"")) D
 . I CSN'="" D
 .. S CCAT=$$GET1^DIQ(90507.8,CSN_",",2.01,"E"),CDISP=$$GET1^DIQ(90507.8,CSN_",",.03,"E")
 .. S CTYP=CCAT_" - "_CDISP,CCASE=CASE_" - "_CTYP
 . I CSN="" S CCASE=CASE_" - Behavioral Health"
 S EXEC="set CCD.CaseReporting.Trigger="""_CCASE_"""" X EXEC
 S EXEC="set CCD.CaseReporting.Version="""_$P(^BQI(90508,1,0),"^",9)_"""" X EXEC
 S COUNTY=$$COUN^BQIULPT(DFN)
 S EXEC="set CCD.CaseReporting.County="""_COUNTY_"""" X EXEC
 S COMM=$$GET1^DIQ(9000001,DFN_",",1117,"E") I COMM="" S COMM=$$COMM^BQICALRT()
 S EXEC="set CCD.CaseReporting.CommunityOfResidence="""_COMM_"""" X EXEC
 S EXEC="set CCD.CaseReporting.Asufac="""_ASUFAC_"""" X EXEC
 S EXEC="set CCD.DirectoryPath="""_PATH_"""" X EXEC
 S EXEC="set CCD.FileName="""_FLNM_"""" X EXEC
 S EXEC="do CCD.VisitId.Insert(VIEN)" X EXEC
 S EXEC="set SC=CCD.%Save()" X EXEC
 I SC'=1 Q 0
 S EXEC="set AUDIT.QueueId=CCD.%Id(),AUDIT.PatientId=CCD.PatientId" X EXEC
 S EXEC="set AUDIT.DocType=CCD.DocType,AUDIT.Status=CCD.Status" X EXEC
 S EXEC="set AUDIT.Source=""BCCDDPT"",AUDIT.RequestTimestamp=CCD.RequestTimestamp" X EXEC
 S EXEC="set AUDIT.RequestorDUZ=$G(DUZ),AUDIT.RequestorName=$$GET1^DIQ(200,$G(DUZ)_"","",.01,""E"")" X EXEC
 S EXEC="do AUDIT.VisitId.Insert(VIEN)" X EXEC
 ; Do not set the status until everything else is set. Otherwise, the processor will start
 S EXEC="set CCD.Status=""R""" X EXEC
 ;S EXEC="set SC=AUDIT.%Save()" X EXEC
 S EXEC="set SC=CCD.%Save()" X EXEC
 Q 1
 ;
SXRF ;EP
 NEW CAS,DFN,FIL,TYP
 S CAS=$P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),0),"^",1)
 S DFN=$P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),1,DA,0),"^",4)
 S FIL=$P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),1,DA,0),"^",5)
 S TYP=$S(FIL=9000011:"P",1:"V")
 I DFN=""!(FIL="") Q
 S ^BQI(90507.6,"V",CAS,TYP,X,DFN,DA(3),DA(2),DA(1),DA)=""
 Q
 ;
SXRL ;EP
 NEW CAS,DFN,FIL,TYP
 S CAS=$P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),0),"^",1)
 S DFN=$P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),2,DA,0),"^",4)
 S FIL=$P(^BQI(90507.6,DA(3),1,DA(2),1,DA(1),2,DA,0),"^",5)
 S TYP=$S(FIL=9000011:"P",1:"V")
 I DFN=""!(FIL="") Q
 S ^BQI(90507.6,"V",CAS,TYP,X,DFN,DA(3),DA(2),DA(1),DA)=""
 Q
 ;
KXRF ;EP
 Q
 ;
DATE(D) ;
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
 ;
SEND ;
 NEW PATH,ASUFAC,FLNM
 D ZIP
 ; Successful
 I 'X D FTP Q
 ; Unsuccessful
 ;I X S ^ARLCCD($$NOW^XLFDT(),"SEND")="NOF" D NOF,FTP
 I X D NOF,FTP
 Q
 ;
FTP ;EP do the sendto
 ; with BCOM, no longer need to do SENDTO
 Q
 S XBFN=ZPFL
 S XBS1="CANE SURVEILLANCE SEND"
 S XBUF=PATH
 ;
 S XBFLG=$$SENDTO1^ZISHMSMU(XBS1,PATH_XBFN)
 S XBFLG(1)=$P(XBFLG,"^",2)
 S XBFLG=+XBFLG
 ;
 NEW DIC,EXIEN,RC,OK,DFN,VISIT,Y,X,DLAYGO
 S DIC(0)="LX",DLAYGO=90507.7,DIC="^BQI(90507.7,",X=DT D ^DIC
 S EXIEN=+Y
 I XBFLG'=0 D
 . I XBFLG(1)="" S BQIUPD(90507.7,EXIEN_",",.03)=1
 . I XBFLG(1)'="" S BQIUPD(90507.7,EXIEN_",",.03)=0
 . D FILE^DIE("I","BQIUPD","ERROR")
 ;
 K XBFLG,XBFN,XBS1,XBUF,ZISHC,ZISHDA1,ZPFL
 Q
 ; 
ZIP ;EP Zip up files
 HANG 60
 K PATH,ASUFAC,FLNM,ZPFL,EXEC,ZVER,TARNM,EXEC1
 S ZVER=$$VERSION^%ZOSV(1)
 S PATH=$P($G(^AUTTSITE(1,1)),"^",2)
 I PATH="" S PATH=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 I ZVER'["UNIX" S PATH=PATH_$S($E(PATH,$L(PATH),$L(PATH))'="\":"\",1:"")
 S ASUFAC=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S FLNM=$S('$$PROD^XUPROD():"CASEZ",1:"CASE")_"_"_ASUFAC_"_"_$$DATE(DT)_"*.xml"
 I ZVER'["UNIX" D
 . S ZPFL=$S('$$PROD^XUPROD():"CASEZ",1:"CASE")_"_"_ASUFAC_"_"_$$DATE(DT)_".zip"
 . S EXEC="S X=$$JOBWAIT^%HOSTCMD(""%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe Compress-Archive ""_PATH_FLNM_"" ""_PATH_ZPFL)"
 . X EXEC
 ;
 I ZVER["UNIX" D
 . NEW BQXX
 . S ZPFL=$S('$$PROD^XUPROD():"CASEZ",1:"CASE")_"_"_ASUFAC_"_"_$$DATE(DT)_".tar.gz"
 . S TARNM=$S('$$PROD^XUPROD():"CASEZ",1:"CASE")_"_"_ASUFAC_"_"_$$DATE(DT)_".tar"
 . ;S EXEC="S X=$$JOBWAIT^%HOSTCMD(""tar -cvf ""_PATH_TARNM_"" ""_PATH_FLNM)"
 . ;S EXEC="S X=$$JOBWAIT^%HOSTCMD(""tar -cvf ""_TARNM_"" -C ""_PATH_"" ""_FLNM)"
 . S BQXX="cd "_PATH_" ; tar -cvf "_TARNM_" -C "_PATH_" "_FLNM
 . S EXEC="S X=$$JOBWAIT^%HOSTCMD(BQXX)"
 . X EXEC
 . S EXEC1="S X=$$JOBWAIT^%HOSTCMD(""gzip ""_PATH_TARNM)"
 . X EXEC1
 ;tar -cvf test.tar -C /usr4i/PUB/ CASEZ_232101_20200713*.xml
 ;cd /usr4i/PUB/ ; tar -cvf CASEZ_232101_20200729.tar -C /usr4i/PUB CASEZ_232101_20200729*.xml
 Q
 ;
NOF ;EP No files
 NEW PATH,ASUFAC,CNT,FLNM,X,ZVER
 S ZVER=$$VERSION^%ZOSV(1)
 S PATH=$P($G(^AUTTSITE(1,1)),"^",2)
 I PATH="" S PATH=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 ;S PATH=PATH_$S($E(PATH,$L(PATH),$L(PATH))'="\":"\CASE\",1:"CASE\")
 I ZVER'["UNIX" S PATH=PATH_$S($E(PATH,$L(PATH),$L(PATH))'="\":"\",1:"")
 S ASUFAC=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 NEW HSFN,EXEC
 S HSFN=$S('$$PROD^XUPROD():"CASEZ",1:"CASE")_"_"_ASUFAC_"_"_$$DATE(DT)_".txt"
 S CNT=0
 D OPEN^%ZISH("BQICAFIL",PATH,HSFN,"W")
 U IO W "$no new cases identified"
 D CLOSE^%ZISH("BQICAFIL")
 S FLNM=$S('$$PROD^XUPROD():"CASEZ",1:"CASE")_"_"_ASUFAC_"_"_$$DATE(DT)_"*.txt"
 I ZVER'["UNIX" D
 . S ZPFL=$S('$$PROD^XUPROD():"CASEZ",1:"CASE")_"_"_ASUFAC_"_"_$$DATE(DT)_".zip"
 . S EXEC="S X=$$JOBWAIT^%HOSTCMD(""%SystemRoot%\system32\WindowsPowerShell\v1.0\powershell.exe Compress-Archive ""_PATH_FLNM_"" ""_PATH_ZPFL)"
 . X EXEC
 ;
 I ZVER["UNIX" D
 . S ZPFL=$S('$$PROD^XUPROD():"CASEZ",1:"CASE")_"_"_ASUFAC_"_"_$$DATE(DT)_".tar.gz"
 . S TARNM=$S('$$PROD^XUPROD():"CASEZ",1:"CASE")_"_"_ASUFAC_"_"_$$DATE(DT)_".tar"
 . ;S EXEC="S X=$$JOBWAIT^%HOSTCMD(""tar -cvf ""_PATH_TARNM_"" ""_PATH_FLNM)"
 . ;S EXEC="S X=$$JOBWAIT^%HOSTCMD(""tar -cvf ""_TARNM_"" -C ""_PATH_"" ""_FLNM)"
 . S BQXX="cd "_PATH_" ; tar -cvf "_TARNM_" -C "_PATH_" "_FLNM
 . S EXEC="S X=$$JOBWAIT^%HOSTCMD(BQXX)"
 . X EXEC
 . S EXEC1="S X=$$JOBWAIT^%HOSTCMD(""gzip ""_PATH_TARNM)"
 . X EXEC1
 Q
 ;
EXP ;EP - Save exported data
 S DIC(0)="LX",DLAYGO=90507.7,DIC="^BQI(90507.7,",X=DT D ^DIC
 S EXIEN=+Y
 S DA(1)=EXIEN,DIC="^BQI(90507.7,"_DA(1)_",10,",DLAYGO=90507.701,X=DFN
 K DO,DD D FILE^DICN
 S DA=+Y,IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.701,IENS,.02)=VISIT,BQIUPD(90507.701,IENS,.03)=$P(^BQI(90507.6,CMN,1,ALTYP,0),"^",1)
 S BQIUPD(90507.701,IENS,.05)=GRP,BQIUPD(90507.701,IENS,.06)=DXN
 S BQIUPD(90507.701,IENS,.07)=CAT,BQIUPD(90507.701,IENS,.08)=DATE
 S BQIUPD(90507.701,IENS,.09)=VFILE,BQIUPD(90507.701,IENS,.1)=RIEN
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
EXP1 ;EP - Save lab exported data
 S DIC(0)="LX",DLAYGO=90507.7,DIC="^BQI(90507.7,",X=DT D ^DIC
 S EXIEN=+Y
 S DA(1)=EXIEN,DIC="^BQI(90507.7,"_DA(1)_",10,",DLAYGO=90507.701,X=DFN
 K DO,DD D FILE^DICN
 S DA=+Y,IENS=$$IENS^DILF(.DA)
 S BQIUPD(90507.701,IENS,.02)=VISIT,BQIUPD(90507.701,IENS,.03)=$P(^BQI(90507.8,TYP,2),"^",1)
 S BQIUPD(90507.701,IENS,.05)=$P(^BQI(90507.8,TYP,0),"^",3)
 S BQIUPD(90507.701,IENS,.07)=$P(^BQI(90507.8,TYP,0),"^",1),BQIUPD(90507.701,IENS,.08)=VDATE
 S BQIUPD(90507.701,IENS,.09)=VFILE,BQIUPD(90507.701,IENS,.1)=RIEN
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
NOFF ;EP - Save No file exported
 NEW DIC,EXIEN,BQIUPD
 S DIC(0)="LX",DLAYGO=90507.7,DIC="^BQI(90507.7,",X=DT D ^DIC
 S EXIEN=+Y
 S BQIUPD(90507.7,EXIEN_",",.04)=0
 D FILE^DIE("","BQIUPD","ERROR")
 Q
