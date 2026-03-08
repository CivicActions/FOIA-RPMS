BQINIGH3 ;GDIT/HS/ALA-Nightly job continued ; 26 Apr 2013  11:07 AM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**1,3,5**;Mar 01, 2021;Build 20
 ;
JBC ;EP - Job off Immunization updates
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 S ZTDESC="Update Childhood Immunizations",ZTRTN="IMM^BQINIGH3",ZTIO=""
 D ^%ZTLOAD
 Q
 ;
IMM ;EP
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQI1POJB D UNWIND^%ZTER"
 ;
 ;  Set the DATE/TIME DXN CATEGORY STARTED field
 NEW DA,DATA,NDFN
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",9.04)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",9.07)=1
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 ;
 S NDFN=0
 F  S NDFN=$O(^XTMP("BQINIGHT",NDFN)) Q:'NDFN  D
 . I $$AGE^BQIAGE(NDFN,"")>17 Q
 . D IRPT^BQIIMINT(NDFN)
 ;
 ;  Set the DATE/TIME DXN CATEGORY STOPPED field
 NEW DA,BQTSK
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",9.06)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",9.07)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 Q
 ;
IJB(IPDATE) ;EP - IPC Job check
 NEW ZTSK,IJOB
 S IJOB=$P($G(^BQI(90508,1,11)),U,4)
 ; If IPC job is blank set up task
 I IJOB="" D INJ Q
 ;
 ; check on IPC monthly job
 I IJOB'="" D
 . S ZTSK=IJOB D STAT^%ZTLOAD
 . I $G(ZTSK(2))'["Pending" D
 .. I $G(ZTSK(2))["Running" Q
 .. I $G(ZTSK(2))["Finished" S $P(^BQI(90508,1,11),U,4)="" Q
 .. I $G(ZTSK(2))["Undefined" D  Q
 ... I $P($G(^BQI(90508,1,11)),U,3)="",'$D(^%ZTSK(ZTSK)) S $P(^BQI(90508,1,11),U,4)="" Q
 ... I $P($G(^BQI(90508,1,11)),U,3)'="" S IPDATE=$P($G(^BQI(90508,1,11)),U,5) D INJ
 .. I $G(ZTSK(2))["Inactive"!($G(ZTSK(2))["Interrupted") D
 ... S IPDATE=$P($G(^BQI(90508,1,11)),U,5) D INJ
 Q
 ;
INJ ;EP - New IPC job
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,BQIUPD
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 S ZTDESC="IPC Monthly Compile",ZTRTN="EN^BQIIPMNU",ZTIO="",ZTSAVE("BQDATE")=$G(IPDATE)
 D ^%ZTLOAD
 S BQIUPD(90508,"1,",11.04)=ZTSK
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
POV ;EP - Set up POV table
 NEW DN,CD,NN,CNT
 K ^XTMP("BQIPOV")
 S ^XTMP("BQIPOV",0)=$$FMADD^XLFDT(DT,7)_U_DT_U_"POV Table Values"
 S DN=0,II=0
 F  S DN=$O(^AUPNVPOV("B",DN)) Q:DN=""  D
 . I $G(^ICD9(DN,0))="" Q
 . S NN="",CNT=0 F  S NN=$O(^AUPNVPOV("B",DN,NN)) Q:NN=""  D
 .. NEW VIS
 .. S VIS=$P($G(^AUPNVPOV(NN,0)),"^",3) I VIS="" Q
 .. I $G(^AUPNVSIT(VIS,0))="" Q
 .. Q:"DXCT"[$P(^AUPNVSIT(VIS,0),U,7)
 .. S CNT=CNT+1
 . S II=II+1,^XTMP("BQIPOV",II)=DN_U_$$VST^ICDCODE(DN,"",80)_U_$$CODEC^ICDCODE(DN,80)_U_CNT
 . S ^XTMP("BQIPOV","Z",CNT,DN)=$$VST^ICDCODE(DN,"",80)_U_$$CODEC^ICDCODE(DN,80)
 Q
 ;
SNO ;EP - Set up SNOMED table
 D SN^BQISNOMS
 Q
 ;
JBB(TYP) ;EP - Job off counts
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,BQIUPD
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 S ZTDESC="Count Compile",ZTRTN=TYP_"^BQINIGH3",ZTIO=""
 D ^%ZTLOAD
 Q
 ;
WK ;EP - Weekly IPC job
 NEW ZTDTH,ZTDESC,ZTRTN,ZTIO,ZTSAVE,BQIUPD
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,3)
 S ZTDESC="IPC Weekly Compile",ZTRTN="EN^BQIIPWKL",ZTIO=""
 D ^%ZTLOAD
 S BQIUPD(90508,"1,",11.06)=ZTSK
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
REM ;EP - populate Reminder Panels
 S BQINIGHT=1
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 NEW ORD,LKSUCC
 S ORD=""
 F  S ORD=$O(^BQICARE("AH",ORD)) Q:ORD=""  D
 . S USR=""
 . F  S USR=$O(^BQICARE("AH",ORD,USR)) Q:USR=""  D
 .. S PNL=""
 .. F  S PNL=$O(^BQICARE("AH",ORD,USR,PNL)) Q:'PNL  D
 ... ;  For each panel, check current status, if currently running, quit
 ... S CSTA=+$$CSTA^BQIPLRF(USR,PNL) I CSTA Q
 ... ; Check what tasks are running
 ... ;D ^BQISYTSK
 ... S LKSUCC=0 D LOC(USR,PNL) I 'LKSUCC Q
 ... ; repopulate
 ... D POP^BQIPLPP("",USR,PNL,"",USR)
 ... ; Reset description
 ... NEW DA,IENS
 ... S DA(1)=USR,DA=PNL,IENS=$$IENS^DILF(.DA)
 ... K DESC
 ... ;D PEN^BQIPLDSC(USR,PNL,.DESC)
 ... D DESC^BQIPDSCM(USR,PNL,.DESC)
 ... D WP^DIE(90505.01,IENS,5,"","DESC")
 ... K DESC
 ... ; clear status
 ... D STA^BQIPLRF(USR,PNL)
 ... ; unlock panel
 ... D ULK^BQIPLRF(USR,PNL)
 ... ; unlock any panels that are filters
 ... D CPFLU^BQIPLUTL(USR,PNL)
 ... ; unlock any owning panels
 ... S PLIDEN=USR_$C(26)_$P(^BQICARE(USR,1,PNL,0),"^",1)
 ... I $D(^BQICARE("AD",PLIDEN)) D PFILU^BQIPLUTL(USR,PNL,PLIDEN)
 ;
 NEW DA,BQTSK
 S DA=$O(^BQI(90508,0)) I 'DA Q
 S BQIUPD(90508,DA_",",3.2)=$$NOW^XLFDT()
 S BQIUPD(90508,DA_",",3.21)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 K BQIUPD
 F BQTSK="BQIAHOC","BQIBDP","BQIDCAPH","BQIDCASN","BQIPLLK","BQIPLPP","BQIPQMAN" K ^TMP(BQTSK,UID)
 F BQTSK="BQIAHOC","BQIBDP","BQIDCAPH","BQIDCASN","BQIPLLK","BQIPLPP","BQIPQMAN" K ^TMP(UID,BQTSK)
 K BQINIGHT
 Q
 ;
FIX ; Fix panels
 NEW DA,IENS,BQIUPD
 S DA(1)=USR,DA=""
 F  S DA=$O(^BQICARE("AC","N",USR,DA)) Q:DA=""  D
 . S IENS=$$IENS^DILF(.DA)
 . S BQIUPD(90505.01,IENS,.06)="@"
 D FILE^DIE("","BQIUPD","ERROR")
 Q
 ;
LOC(USR,PNL) ;EP
 K PLIDEN
 S LOCK=$$LCK^BQIPLRF(USR,PNL)
 ; If not able to lock panel, clear status, send notification and go to next one
 I 'LOCK D  Q
 . D STA^BQIPLRF(USR,PNL)
 . D NNOTF^BQIPLRF(USR,PNL)
 . ;
 . ; Check if locked panel has panel filters
 . NEW PLSUCC,SUBJECT,LOCK,POWNR,PPLIEN
 . S PLSUCC=$$CPFL^BQIPLUTL(USR,PNL)
 . ; If panel contains panel filters and were not successful in being locked,
 . ;  clear status, send notification and go to next panel in list
 . I 'PLSUCC D  Q
 .. D STA^BQIPLRF(USR,PNL)
 .. D ULK^BQIPLRF(USR,PNL)
 .. S SUBJECT="Unable to lock panel(s) that are filters for panel: "_$P(^BQICARE(USR,1,PNL,0),U,1)
 .. S LOCK="0^"_$P(PLSUCC,U,2),POWNR=$P(PLSUCC,U,4),PPLIEN=$P(PLSUCC,U,5)
 .. I $P(PLSUCC,U,3)'="" S BMXSEC=$P(PLSUCC,U,3),SUBJECT=""
 .. D NNOTF^BQIPLRF(USR,PNL,SUBJECT)
 . ;
 . ; Check if panel is a panel filter
 . S PLIDEN=USR_$C(26)_$P(^BQICARE(USR,1,PNL,0),"^",1)
 . I $D(^BQICARE("AD",PLIDEN)) D  Q:LFLG
 .. S LFLG=0 D PFILL^BQIPLUTL(USR,PNL,PLIDEN)
 .. ; If not able to lock any of the owning panels, unlock owning panel, clear status, unlock panel and quit
 .. I LFLG D PFILU^BQIPLUTL(USR,PNL,PLIDEN),STA^BQIPLRF(USR,PNL),ULK^BQIPLRF(USR,PNL)
 . ; Set status to currently running
 . D STA^BQIPLRF(USR,PNL,1)
 S LKSUCC=1
 Q
 ;
NTIT ;EP - Set Note title cross-references
 S TNN=+$P($G(^BQI(90508,1,"VISIT")),"^",4)
 F  S TNN=$O(^TIU(8925,TNN)) Q:'TNN  D
 . S $P(^BQI(90508,1,"VISIT"),"^",4)=TNN
 . S VISIT=$P($G(^TIU(8925,TNN,0)),"^",3) I VISIT="" Q
 . S ST=$P($G(^TIU(8925,TNN,0)),"^",5) I ST="" Q
 . I ST'="" S STAT=$P($G(^TIU(8925.6,ST,0)),"^",1)
 . I STAT'="" S ^XTMP("BQINTSTAT",STAT)=ST_"^"_STAT
 . S LOC=$P($G(^AUPNVSIT(VISIT,0)),"^",6)
 . I LOC'="" S ^XTMP("BQINTDIV",LOC)=LOC_"^"_$P($G(^DIC(4,LOC,0)),"^",1)
 S ^XTMP("BQINTDIV",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Notes Division List"
 S ^XTMP("BQINTSTAT",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Notes Status List"
 K TNN,VISIT,ST,STAT,LOC
 Q
