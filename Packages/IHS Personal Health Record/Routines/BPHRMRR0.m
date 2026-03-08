BPHRMRR0 ;GDIT/HS/BEE-PHR Medication Refill Request ; 20 Aug 2013  9:54 AM
 ;;2.1;IHS PERSONAL HEALTH RECORD;**3,6**;Apr 01, 2014;Build 6
 ;
TSK ;EP - Run task to pull queued medication refill requests from PHR
 ;
 NEW FAC,LIEN,TSKDTM,SUCCESS,ERRMSG,OPSITE,SLIST
 ;
 ;GDIT/HS/BEE:BPHR*2.1*6,FEATURE#97411;05;13;24;Log Refill Task Call
 S (TSKDTM,LIEN)=""
 D
 . NEW DA,UPD,X,DIC,Y
 . ;
 . ;Get current date/time
 . S (TSKDTM,X)=$$NOW^XLFDT()
 . S DIC(0)="L",DIC="^BPHRMTSK("
 . K DO,DD D FILE^DICN
 . S LIEN=+Y
 I LIEN="" Q
 ;
 ;GDIT/HS/BEE;BPHR*2.1*6;FEATURE#114584;Now loop through OUTPATIENT SITE entries
 ;Loop through REGISTRATION PARAMETERS and get each Station Number 
 ;S (ERRMSG,SUCCESS)="",FAC=0 F  S FAC=$O(^AGFAC(FAC)) Q:'FAC  D
 S (ERRMSG,SUCCESS)="",OPSITE=0 F  S OPSITE=$O(^PS(59,OPSITE)) Q:'OPSITE  D
 . NEW STA,FIEN,DA,X,DIC,Y,IENS,SITE,MUPD,ERR,STS
 . ;
 . ;GDIT/HS/BEE;BPHR*2.1*6;i3;line out of date since switch to file 59 loop
 . ;GDIT/HS/BEE:BPHR*2.1*6,FEATURE#97411;REQ#114206;Only process OFFICIAL REGITERING FACILITY entries
 . ;I $$GET1^DIQ(9009061,FAC_",",20,"I")'="Y" Q
 . ;
 . ;Skip inactives
 . I $$GET1^DIQ(59,OPSITE_",",2004)]"" Q
 . ;
 . ;GDIT/HS/BEE:BPHR*2.1*6,FEATURE#97411;05;13;24;Log each facility call
 . ;S (X,SITE)=$$GET1^DIQ(9009061,FAC_",",.01,"I") Q:SITE=""
 . S (X,SITE)=$$GET1^DIQ(59,OPSITE_",",100,"I") Q:SITE=""
 . ;
 . ;Skip duplicates
 . I $D(SLIST(SITE)) Q
 . S SLIST(SITE)=""
 . ;
 . S DA(1)=LIEN,DIC(0)="L",DIC="^BPHRMTSK("_DA(1)_",1,"
 . K DO,DD D FILE^DICN
 . S FIEN=+Y
 . ;
 . ;Determine the station
 . ;S STA=$$GET1^DIQ(4,FAC_",",99,"I") Q:STA=""
 . S STA=$$GET1^DIQ(4,SITE_",",99,"I") Q:STA=""
 . S DA(1)=LIEN,DA=FIEN,IENS=$$IENS^DILF(.DA)
 . D FAUD(IENS,.02,STA)
 . ;
 . ;Query PHR to retrieve refill requests
 . S STS=$$QRY(LIEN,FIEN,IENS,TSKDTM,SITE,IENS,STA)
 . ;
 . ;Track error message
 . I $P(STS,U)=-1 S ERRMSG=$P(STS,U,2)
 . ;
 . ;Track any success
 . I STS=1 S SUCCESS=1
 . ;
 . ;Update master counts
 . S MUPD(90670.3,LIEN_",",.02)=$$GET1^DIQ(90670.3,LIEN_",",.02,"I")+$$GET1^DIQ(90670.31,IENS,.03,"I")
 . D FILE^DIE("","MUPD","ERR")
 ;
 ;Update error message if no success
 I 'SUCCESS,ERRMSG]"" D
 . NEW UPD,ERR
 . S UPD(90670.3,LIEN_",",2.01)=ERRMSG
 . D FILE^DIE("","UPD","ERR")
 ;
 Q
 ;
QRY(LIEN,FIEN,FIENS,TSKDTM,SITE,IENS,STA) ;Query PHR for refill requests for one station
 ; Input Parameter
 ;  STA - Station Number to process
 ;
 ; Output - None
 ;
 I '+$G(STA) Q "-1^Missing Station ID"
 ;
 I $G(DT)="" D DT^DICRW
 ;
 NEW BPHRP,QFL,TRY,FAIL,RETRY,MAX,CONNEC,STS,RX,PROD,OK,RESULT,BPHRIEN,%,BPHRUPD,ERROR,RCNT
 NEW BPHRR
 ;
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BPHRMRR0 D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 ;
 S PROD=$$PROD^XUPROD()
 I 'PROD S DA=1
 I PROD S DA=2
 S BPHRIEN=DA
 ;
 ; Get web service information
 K BPARRAY
 D GETS^DIQ(90670.2,DA_",","**","E","BPARRAY")
 S BPHRP("MURLROOT")=$G(BPARRAY(90670.2,DA_",",6.01,"E"))
 S BPHRP("MSPATH")=$G(BPARRAY(90670.2,DA_",",6.02,"E"))
 S BPHRP("USER")=$G(BPARRAY(90670.2,DA_",",.07,"E"))
 S BPHRP("PASS")=$G(BPARRAY(90670.2,DA_",",.08,"E"))
 ;
 ; Pass Station ID
 S BPHRP("STA")=STA
 ;
 ;Get the patch and version
 S BPHRP("VP")=$$VRNPCH()
 ;
 S BPHRP("SSL")=$G(BPARRAY(90670.2,DA_",",2.01,"E"))
 S RETRY=$G(BPARRAY(90670.2,DA_",",4.01,"E"))
 S MAX=$G(BPARRAY(90670.2,DA_",",4.02,"E"))
 S CONNEC=$G(BPARRAY(90670.2,DA_",",.12,"E"))
 S BPHRP("LIEN")=LIEN
 S BPHRP("FIEN")=FIEN
 ;
 ; Returns data
 S QFL=0,TRY=0,FAIL=0,OK=0,RESULT=""
 F  D  Q:OK  Q:QFL
 . NEW EXEC
 . ;
 . ;Audit the call attempt
 . D FAUD(FIENS,.04,$$NOW^XLFDT())
 . ;
 . ;Make the request
 . S EXEC="S STS=##class(BPHR.MedRefReqWebServiceCalls).MRefRequest(.BPHRP,.BPHRR)" X EXEC
 . ;
 . ;Log success
 . I $P($G(STS),U,1)=1 D  Q
 .. D FAUD(FIENS,.05,$$NOW^XLFDT())
 .. S OK=1
 . ;
 . ;Log failure
 . I $P($G(STS),U,1)=0 D
 .. D FAUD(FIENS,.06,$$NOW^XLFDT())
 .. D FAUD(FIENS,1.01,$P(STS,U,2))
 .. S TRY=TRY+1 I TRY>RETRY S FAIL=FAIL+1,TRY=0
 .. I FAIL>MAX S $P(RESULT,U,1)=-1,$P(RESULT,U,2)=$P($G(STS),U,2),QFL=1 Q
 .. HANG CONNEC
 ;
 ;GDIT/HS/BEE:BPHR*2.1*6,FEATURE#97411;05;13;24;Log Refill Task Call - Save counts
 D FAUD(FIENS,.03,+$G(BPHRR("COUNT")))
 ;
 I QFL Q RESULT
 ;
 ;Loop through Rx list and process refills
 S (RCNT,QFL)=0,RX="" F  S RX=$O(^TMP("BPHRMRR0",$J,RX)) Q:RX=""  D  Q:QFL
 . ;
 . NEW %,DTPROC,RIEN,DFN
 . ;
 . ;Retrieve DFN
 . S DFN=$P($G(^TMP("BPHRMRR0",$J,RX)),U,3)
 . ;
 . ;Process each one
 . S RIEN=$$REFILL(LIEN,FIEN,SITE,STA,RX,DFN)
 . S RCNT=RCNT+1
 . I RIEN=-1 Q
 . ;
 . ;Log the task date/time
 . D AUD(RIEN,.13,TSKDTM)
 . ;
 . ;Send update to PHR
 . D NOW^%DTC S %=%_"000000"
 . S DTPROC="20"_$E(%,2,3)_"-"_$E(%,4,5)_"-"_$E(%,6,7)_" "_$E(%,9,10)_":"_$E(%,11,12)_":"_$E(%,13,14)
 . S BPHRP("UPD")=$G(^TMP("BPHRMRR0",$J,RX))_"^"_DTPROC
 . S TRY=0,FAIL=0,OK=0
 . F  D  Q:OK  Q:QFL
 .. ;
 .. ;Log the processed attempt time
 .. D AUD(RIEN,2.01,$$NOW^XLFDT())
 .. ;
 .. ;Attempt to make the processed call
 .. S EXEC="S STS=##class(BPHR.MedRefReqWebServiceCalls).MRefProcessed(.BPHRP,.BPHRR)" X EXEC
 .. ;
 .. ;Log success
 .. I $P($G(STS),U,1)=1 D  S OK=1 Q
 ... D AUD(RIEN,2.02,$$NOW^XLFDT())  ;Log success
 ... D AUD(RIEN,2.03,"@")   ;Clear failure
 ... S OK=1
 .. ;
 .. ;Handle failure
 .. I $P($G(STS),U,1)=0 D
 ... D AUD(RIEN,2.03,$$NOW^XLFDT())  ;Log failure
 ... D AUD(RIEN,2.04,$$GET1^DIQ(90670.4,RIEN_",",2.04,"I")+1)
 ... S TRY=TRY+1 I TRY>RETRY S FAIL=FAIL+1,TRY=0
 ... I FAIL>MAX S $P(RESULT,U,1)=-1,$P(RESULT,U,10)=$P($G(STS),U,2),QFL=1 Q
 ... HANG CONNEC
 ;
 ;Update the MEDREFILL LAST RUN field
 D NOW^%DTC
 S BPHRUPD(90670.2,BPHRIEN_",",6.03)=%
 ;
 ;Put entry in history
 I RCNT>0 D
 . NEW DIC,DA,X,Y,DLAYGO
 . S X=%,DIC(0)="LX"
 . I '$D(^BPHR(90670.2,BPHRIEN,7,0)) S ^BPHR(90670.2,BPHRIEN,7,0)="^90670.27DA^0^0"
 . S DA(1)=BPHRIEN,DIC="^BPHR(90670.2,"_DA(1)_",7,",DLAYGO=90670.27
 . K DO,DD D FILE^DICN
 . I '+Y Q
 . S DA=+Y,IENS=$$IENS^DILF(.DA)
 . S BPHRUPD(90670.27,IENS,".02")=STA
 . S BPHRUPD(90670.27,IENS,".03")=RCNT
 ;
 D FILE^DIE("","BPHRUPD","ERROR")
 ;
 Q 1
 ;
REFILL(LIEN,FIEN,SITE,STA,RX,DFN) ;Place the refill request
 ;
 NEW RIEN,PORDNUM,LACT,PARM1,RFIEN,SYCLN,RET,RXIEN,MWC,UPD,UPD1,ERR,POOIEN,RXDFN,CANC,EXP,CLN
 ;
 ;GDIT/HS/BEE:BPHR*2.1*6,FEATURE#97411;05;13;24;Log each facility call
 S RIEN=""
 D
 . NEW X,DIC,Y
 . S X=$$NOW^XLFDT()
 . S DIC(0)="L",DIC="^BPHRMREQ("
 . K DO,DD D FILE^DICN
 . S RIEN=+Y
 I RIEN="" Q -1
 S UPD1(90670.4,RIEN_",",.03)=LIEN
 S UPD1(90670.4,RIEN_",",.04)=SITE
 S UPD1(90670.4,RIEN_",",.05)=STA
 S UPD1(90670.4,RIEN_",",.08)=RX
 D FILE^DIE("","UPD1","ERR")
 ;
 I '$G(RX) D AUD(RIEN,3.01,"Missing Rx#") Q -1
 ;
 ;Get RXIEN
 S RXIEN=$O(^PSRX("B",RX,"")) I RXIEN="" D AUD(RIEN,3.01,"Rx#"_RX_" not found in PRESCRIPTION file") Q -1
 ;
 ;Verify DFN matches
 I '$G(DFN) D AUD(RIEN,3.01,"Downloaded request for Rx#"_RX_" does not contain patient DFN") Q -1
 S RXDFN=$$GET1^DIQ(52,RXIEN_",",2,"I") I DFN'=RXDFN D AUD(RIEN,3.01,"DFN Mismatch: Downloaded Rx#"_RX_" has a DFN of "_DFN_" but local prescription has a DFN of "_RXDFN) Q -1
 ;
 ;Save warning if canceled
 S CANC=$$GET1^DIQ(52,RXIEN_",",26.1,"I") I CANC,CANC<DT D AUD(RIEN,3.01,"Prescription has a cancel date of "_$$FMTE^XLFDT(CANC,"5D"))
 ;
 ;Save warning if expired
 S EXP=$$GET1^DIQ(52,RXIEN_",",26,"I") I EXP,EXP<DT D AUD(RIEN,3.01,"Prescription has an expiration date of "_$$FMTE^XLFDT(EXP,"5D"))
 ;
 ;Retrieve the PLACER ORDER #
 S PORDNUM=$$GET1^DIQ(52,RXIEN_",",39.3,"I") I '$G(PORDNUM) D AUD(RIEN,3.01,"PLACER ORDER # missing from Rx entry") Q -1
 ;
 ;Get last action
 S LACT=$O(^OR(100,PORDNUM,8,"A"),-1)
 ;
 S PARM1=PORDNUM_$S(LACT]"":";",1:"")_LACT
 ;
 ;Mail/Window/Clinic
 S MWC=$$GET1^DIQ(52,RXIEN_",",11,"I") S:MWC="" MWC="M"
 ;
 ;Get last refill info
 S RFIEN=$O(^PSRX(RXIEN,1,"A"),-1)
 I RFIEN D
 . NEW DA,IENS,RMWC
 . S DA(1)=RXIEN,DA=RFIEN,IENS=$$IENS^DILF(.DA)
 . S RMWC=$$GET1^DIQ(52.1,IENS,2,"I")
 . S:RMWC]"" MWC=RMWC
 ;
 ;Patient
 S DFN=$$GET1^DIQ(52,RXIEN_",",2,"I")
 ;
 ;Clinic (location)
 S CLN=$$GET1^DIQ(52,RXIEN_",",5,"I")
 ;
 ;Put the refill on the queue
 D REFILL^ORWPS1(.RET,PARM1,MWC,DFN,.5,CLN)
 S POOIEN="" I PORDNUM S POOIEN=$O(^PS(52.41,"B",PORDNUM,""))
 ;
 ;Save the request entry
 S UPD(90670.4,RIEN_",",.02)=DFN
 S UPD(90670.4,RIEN_",",.03)=LIEN
 S UPD(90670.4,RIEN_",",.04)=SITE
 S UPD(90670.4,RIEN_",",.05)=STA
 S UPD(90670.4,RIEN_",",.06)=PORDNUM
 S UPD(90670.4,RIEN_",",.07)=RXIEN
 S UPD(90670.4,RIEN_",",.08)=RX
 S UPD(90670.4,RIEN_",",.09)=MWC
 S UPD(90670.4,RIEN_",",.1)=CLN
 S UPD(90670.4,RIEN_",",.11)=LACT
 S UPD(90670.4,RIEN_",",.12)=POOIEN
 I POOIEN D
 . S UPD(90670.4,RIEN_",",1.01)=$$GET1^DIQ(52.41,POOIEN_",",2,"I")
 . S UPD(90670.4,RIEN_",",1.02)=$$GET1^DIQ(52.41,POOIEN_",",5,"I")
 . S UPD(90670.4,RIEN_",",1.03)=$$GET1^DIQ(52.41,POOIEN_",",8,"I")
 . S UPD(90670.4,RIEN_",",1.04)=$$GET1^DIQ(52.41,POOIEN_",",11,"I")
 . S UPD(90670.4,RIEN_",",1.05)=$$GET1^DIQ(52.41,POOIEN_",",15,"I")
 . S UPD(90670.4,RIEN_",",1.06)=$$GET1^DIQ(52.41,POOIEN_",",25,"I")
 . S UPD(90670.4,RIEN_",",1.07)=$$GET1^DIQ(52.41,POOIEN_",",19,"I")
 . S UPD(90670.4,RIEN_",",1.08)=$$GET1^DIQ(52.41,POOIEN_",",21,"I")
 . S UPD(90670.4,RIEN_",",1.09)=$$GET1^DIQ(52.41,POOIEN_",",22,"I")
 . S UPD(90670.4,RIEN_",",1.1)=$$GET1^DIQ(52.41,POOIEN_",",100,"I")
 . S UPD(90670.4,RIEN_",",1.11)=POOIEN
 D FILE^DIE("","UPD","ERR")
 ;
 Q RIEN
 ;
VRNPCH() ;Return the version and patch of BPHR
 ;
 NEW VERSION,PATCH,RET
 ;
 S VERSION=$TR(($$VERSION^XPDUTL("BPHR")_"00")*100,".")
 S VERSION=$E(VERSION,1,3)
 S PATCH=$O(^XPD(9.7,"B","BPHRZ"),-1)
 S PATCH=+$P(PATCH,"*",3) S:$L(PATCH)=1 PATCH="0"_PATCH
 Q VERSION_"."_PATCH
 ;
AUD(RIEN,FLD,VALUE) ;Log audit entry
 ;
 NEW UPD,ERR
 ;
 S UPD(90670.4,RIEN_",",FLD)=VALUE
 D FILE^DIE("","UPD","ERR")
 Q
 ;
FAUD(IENS,FLD,VALUE) ;Log audit entry
 ;
 NEW UPD,ERR
 ;
 S UPD(90670.31,IENS,FLD)=VALUE
 D FILE^DIE("","UPD","ERR")
 Q
 ;
ERR ;EP - Error Trap
 D ^%ZTER
 Q
