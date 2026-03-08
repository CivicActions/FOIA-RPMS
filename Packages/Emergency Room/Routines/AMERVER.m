AMERVER ; IHS/GDIT/BEE - Save record to V EMERGENCY VISIT RECORD ;  
 ;;3.0;ER VISIT SYSTEM;**8,11,13**;MAR 03, 2009;Build 36
 ;
VER(AMERDFN,AMERPCC) ;Create/Update V EMERGENCY VISIT RECORD entry
 ;
 I $G(AMERDFN)="" Q
 ;
 ;If no VIEN, try to retrieve it
 I $G(AMERPCC)="" D  Q:AMERPCC=""
 . S AMERPCC=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I")
 ;
 NEW ERIEN,ERVIEN,%,VERUPD,ERROR,AUPNVSIT
 ;
 D NOW^%DTC
 ;
 ;Look for existing entry
 S ERIEN=$O(^AUPNVER("AD",AMERPCC,""))
 ;
 ;If no entry create new one
 I ERIEN="" D  Q:ERIEN=""
 . ;
 . NEW DIC,DLAYGO,X,Y
 . ;
 . S DIC(0)="L",DIC="^AUPNVER("
 . S DLAYGO="9000010.29"
 . S X="IHS-114 ER"
 . K DO,DD D FILE^DICN
 . I +Y<0 Q
 . S ERIEN=+Y
 . ;
 . ;Now enter initial fields
 . S VERUPD(9000010.29,ERIEN_",",.02)=AMERDFN  ;PATIENT NAME
 . S VERUPD(9000010.29,ERIEN_",",.03)=AMERPCC   ;VISIT
 . S VERUPD(9000010.29,ERIEN_",",1216)=%  ;DATE ENTERED
 . S VERUPD(9000010.29,ERIEN_",",1217)=DUZ  ;ENTERED BY
 ;
 ;Update Modified By/Date
 S VERUPD(9000010.29,ERIEN_",",1218)=%  ;DATE MODIFIED
 S VERUPD(9000010.29,ERIEN_",",1219)=DUZ  ;LAST MODIFIED BY
 ;
 ;Pull from ER VISIT file if available
 S ERVIEN=$O(^AMERVSIT("AD",AMERPCC,""))
 I ERVIEN]"" D
 . NEW URG,MOT,MOA,ENTBY,DIS,DISP,DISDT,IDISP
 . ;
 . ;Urgency
 . S URG=$$GET1^DIQ(9009080,ERVIEN_",",.24,"I")  ;INITIAL ACUITY
 . S URG=$S(URG=1:"R",URG=2:"E",URG=3:"U",URG=4:"L",URG=5:"N",1:"@")
 . S VERUPD(9000010.29,ERIEN_",",.04)=URG
 . ;
 . ;Method of Transport
 . S (ENTBY,MOA)="",MOT=$$GET1^DIQ(9009080,ERVIEN_",",".25","I") I MOT'="" D
 .. ;
 .. ;MEANS OF ARRIVAL
 .. S MOT=$$GET1^DIQ(9009083,MOT_",",".01","E")
 .. I MOT["WALK" S MOA="W"
 .. I MOT["AMBULANCE" S MOA="A"
 .. S:MOA="" MOA="O"
 .. ;
 .. ;ENTERED ER BY
 .. I MOT["AMBULANCE" S ENTBY="A"
 .. I MOT["WHEEL" S ENTBY="W"
 .. I MOT["STRET"  S ENTBY="S"
 .. ;
 .. S VERUPD(9000010.29,ERIEN_",",.05)=$S(MOA]"":MOA,1:"@")  ;MEANS OF ARRIVAL
 .. S VERUPD(9000010.29,ERIEN_",",.07)=$S(ENTBY]"":ENTBY,1:"@")  ;ENTERED ER BY
 . ;
 . ;DISPOSITION OF CARE
 . S DIS="",(IDISP,DISP)=$$GET1^DIQ(9009080,ERVIEN_",","6.1","I") I DISP'="" D
 .. S DISP=$$GET1^DIQ(9009083,DISP_",",".01","E")
 .. I DISP["HOME" S DIS="D"
 .. E  I DISP["TRANS" S DIS="T"
 .. E  I DISP["ADMIT" S DIS="A"
 .. E  I DISP["REGIS" S DIS="O"
 .. E  I DISP["EXPIRED" S DIS="E"
 .. E  I DISP["DEA" S DIS="E"
 .. ;GDIT/HS/BEE 12/04/2018;BEDD*3.0*4;CR#8262 - Address LWOBS dispositions
 .. ;I DISP["LEFT" S DIS="1"
 .. I (DISP["LEFT")!(DISP="AMA") D
 ... NEW CSTM
 ... S CSTM=""
 ... ;First look for LWOBS entries
 ... I $O(^AMER(2.5,DUZ(2),9,"B",""))]"" D  Q:DIS]""
 .... S CSTM=1 ;Custom LWOBS in use
 .... I $D(^AMER(2.5,DUZ(2),9,"B",IDISP)) S DIS="O"  ;map to other
 ... ;If custom LWOBS not in use next look for words
 ... I 'CSTM,((DISP["LEFT WITHOUT")!(DISP["LWOBS")!(DISP["DNA")) S DIS="O" Q
 ... ;
 ... ;Not an identifiable LWOBS/DNA - map to left AMA
 ... S DIS="1"
 .. ;
 .. I DISP]"",DIS="" S DIS="O"
 .. S VERUPD(9000010.29,ERIEN_",",.11)=$S(DIS]"":DIS,1:"@")
 . ;
 . ;DEPARTURE DATE&TIME
 . S DISDT=$$GET1^DIQ(9009080,ERVIEN_",","6.2","I")
 . S VERUPD(9000010.29,ERIEN_",",".12")=DISP
 . S VERUPD(9000010.29,ERIEN_",",".13")=$S(DISDT]"":DISDT,1:"@")
 ;
 ;Pull from ER ADMISSION if no ER VISIT entry
 I ERVIEN="" D
 . NEW URG,MOT,MOA,ENTBY
 . ;
 . ;Urgency
 . S URG=$$GET1^DIQ(9009081,AMERDFN_",",20,"I")  ;INITIAL ACUITY
 . S URG=$S(URG=1:"R",URG=2:"E",URG=3:"U",URG=4:"L",URG=5:"N",1:"@")
 . S VERUPD(9000010.29,ERIEN_",",.04)=URG
 . ;
 . ;Method of Transport
 . S (ENTBY,MOA)="",MOT=$$GET1^DIQ(9009081,AMERDFN_",","6","I") I MOT'="" D
 .. ;
 .. ;Means of Arrival
 .. S MOT=$$GET1^DIQ(9009083,MOT_",",".01","E")
 .. I MOT["WALK" S MOA="W"
 .. I MOT["AMBULANCE" S MOA="A"
 .. S:MOA="" MOA="O"
 .. ;
 .. ;Entered ER By
 .. I MOT["AMBULANCE" S ENTBY="A"
 .. I MOT["WHEEL" S ENTBY="W"
 .. I MOT["STRET"  S ENTBY="S"
 .. ;
 .. S VERUPD(9000010.29,ERIEN_",",.05)=$S(MOA]"":MOA,1:"@")  ;MEANS OF ARRIVAL
 .. S VERUPD(9000010.29,ERIEN_",",.07)=$S(ENTBY]"":ENTBY,1:"@")  ;ENTERED ER BY
 ;
 ;File the entry
 D FILE^DIE("","VERUPD","ERROR")
 ;
 ;Mark the visit as being modified
 NEW D S AUPNVSIT=AMERPCC D MOD^AUPNVSIT K D
 ;
 Q
 ;
 ;GDIT/HS/BEE 10/05/22;AMER*3.0*13;CR#5100;Handle triage provider, new nurse fields, provider table
NRPRV(AMERDFN,AMERPCC,PROV,NURSE) ;Update V EMERGENCY VISIT RECORD entry Nurses/Providers
 ;
 I $G(AMERDFN)="" Q
 ;
 NEW ERIEN,DA,IENS,DIK,II,TIME,NRS,PRV,TYP
 ;
 ;If no VIEN, try to retrieve it
 I $G(AMERPCC)="" D  Q:AMERPCC=""
 . S AMERPCC=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I")
 ;
 ;Locate existing entry
 S ERIEN=$O(^AUPNVER("AD",AMERPCC,"")) Q:ERIEN=""
 ;
 ;Clear out existing Nurses
 S II=0 F  S II=$O(^AUPNVER(ERIEN,14,II)) Q:'II  S DA(1)=ERIEN,DA=II,DIK="^AUPNVER("_DA(1)_",14," D ^DIK
 ;
 ;Clear out existing Providers
 S II=0 F  S II=$O(^AUPNVER(ERIEN,13,II)) Q:'II  S DA(1)=ERIEN,DA=II,DIK="^AUPNVER("_DA(1)_",13," D ^DIK
 ;
 ;Save current nurse list
 S TIME="" F  S TIME=$O(NURSE(TIME)) Q:TIME=""  D
 . S NRS="" F  S NRS=$O(NURSE(TIME,NRS)) Q:NRS=""  D
 .. S TYP="" F  S TYP=$O(NURSE(TIME,NRS,TYP)) Q:TYP=""  D
 ... ;
 ... NEW NUPD,ERROR,DIC,X,DA,Y
 ... ;
 ... S X=NRS  ;Set the nurse
 ... S DIC("DR")=".02////"_TYP_";.03////"_TIME
 ... S DIC(0)=""
 ... S DA(1)=ERIEN
 ... S DIC="^AUPNVER("_DA(1)_",14,"
 ... K DO,DD D FILE^DICN
 ;
 ;Save current provider list
 S TIME="" F  S TIME=$O(PROV(TIME)) Q:TIME=""  D
 . S PRV="" F  S PRV=$O(PROV(TIME,PRV)) Q:PRV=""  D
 .. S TYP="" F  S TYP=$O(PROV(TIME,PRV,TYP)) Q:TYP=""  D
 ... ;
 ... NEW PUPD,ERROR,DIC,X,DA,Y
 ... ;
 ... S X=PRV  ;Set the nurse
 ... S DIC("DR")=".02////"_TYP_";.03////"_TIME
 ... S DIC(0)=""
 ... S DA(1)=ERIEN
 ... S DIC="^AUPNVER("_DA(1)_",13,"
 ... K DO,DD D FILE^DICN
 ;
 Q
 ;
UTRG(AMERVSIT) ;Update Triage wait and initial information
 ;
 I '$G(AMERVSIT) Q
 ;
 NEW AMERDFN,VIEN,TRIAGE,ITDT,ITBY,ITRG,IERR,TWTG,ADMDT
 ;
 ;Retrieve patient
 S AMERDFN=$$GET1^DIQ(9009080,AMERVSIT_",",.02,"I") Q:'AMERDFN
 S VIEN=$$GET1^DIQ(9009080,AMERVSIT_",",.03,"I") Q:'VIEN
 ;
 ;Retrieve Triage information
 S TRIAGE=$$TRIAGE^AMERMPRV(.AMERP,AMERDFN,VIEN)
 S ITDT=$P(TRIAGE,U)
 S ITBY=$P(TRIAGE,U,2)
 ;
 ;Get admission date
 S ADMDT=$$GET1^DIQ(9009080,AMERVSIT_",",.01,"I")
 ;
 ;Calculate wait
 S TWTG=$$DT^AMERSAV1(ITDT,ADMDT,"M")
 ;
 ;Update ER VISIT
 S ITRG(9009080,AMERVSIT_",",17.11)=$S(ITDT]"":ITDT,1:"@")
 S ITRG(9009080,AMERVSIT_",",17.12)=$S(ITBY]"":ITBY,1:"@")
 S ITRG(9009080,AMERVSIT_",",12.4)=+TWTG
 D FILE^DIE("","ITRG","IERR")
 ;
 Q
 ;
UVEVR(AMERDFN,VIEN) ;Update V EMERGENCY VISIT RECORD based on ER ADMISSION/ER VISIT
 ;
 ;Called from AMER*3.0*13 post install
 ;
 I '$G(AMERDFN) Q
 S VIEN=$G(VIEN)
 ;
 NEW TYPE,AMERP,NAMERP,AMERVSIT,PROV,NURSE
 ;
 ;If no visit, try to pull from ER ADMISSION
 I 'VIEN S VIEN=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I") Q:'VIEN
 ;
 ;Look for ER VISIT
 S AMERVSIT=$O(^AMERVSIT("AD",VIEN,""))
 I AMERVSIT S TYPE="V"
 E  I $D(^AMERADM(AMERDFN)) S TYPE="A"
 E  Q
 ;
 ;Get current entries for visit
 S AMERP=$$GPROV^AMERMPV1(.AMERP,$G(AMERDFN),VIEN)
 ;
 ;Get entries from ER ADMISSION
 I TYPE="A" D UVEVRA(AMERDFN,.NAMERP)
 ;
 ;Get entries from ER VISIT
 I TYPE="V" D UVEVRV(AMERVSIT,.NAMERP)
 ;
 ;Add entries
 I $O(NAMERP(""))]"" D SYNC^AMERMPRV(AMERDFN,VIEN,.PROV,.NURSE,.NAMERP)
 Q
 ;
UVEVRA(AMERDFN,NAMERP) ;Pull nurse providers from ER ADMISSION
 ;
 I '$G(AMERDFN) Q
 ;
 NEW PRV,PTIME
 ;
 ;Get current triage nurse and time
 S PRV=$$GET1^DIQ(9009081,AMERDFN_",",19,"I")
 S PTIME=$$GET1^DIQ(9009081,AMERDFN_",",21,"I")
 I PRV]"",PTIME]"" S NAMERP("TRIAGE NURSE",PTIME,PRV)=""
 ;
 ;Get current triage provider and time
 S PRV=$$GET1^DIQ(9009081,AMERDFN_",",1.01,"I")
 S PTIME=$$GET1^DIQ(9009081,AMERDFN_",",1.02,"I")
 I PRV]"",PTIME]"" S NAMERP("TRIAGE PROVIDER",PTIME,PRV)=""
 ;
 ;Get current primary nurse
 S PRV=$$GET1^DIQ(9009081,AMERDFN_",",1.04,"I")
 S PTIME=$$GET1^DIQ(9009081,AMERDFN_",",1.05,"I")
 I PRV]"",PTIME]"" S NAMERP("PRIMARY NURSE",PTIME,PRV)=""
 ;
 ;Get current ED Provider
 S PRV=$$GET1^DIQ(9009081,AMERDFN_",",18,"I")
 S PTIME=$$GET1^DIQ(9009081,AMERDFN_",",1.03,"I")
 I PRV]"",PTIME]"" S NAMERP("ED PROVIDER",PTIME,PRV)=""
 ;
 Q
 ;
UVEVRV(AMERVSIT,NAMERP) ;Pull nurse providers from ER VISIT
 ;
 I '$G(AMERVSIT) Q
 ;
 NEW PRV,PTIME
 ;
 ;Get current triage nurse and time
 S PRV=$$GET1^DIQ(9009080,AMERVSIT_",",.07,"I")
 S PTIME=$$GET1^DIQ(9009080,AMERVSIT_",",12.2,"I")
 I PRV]"",PTIME]"" S NAMERP("TRIAGE NURSE",PTIME,PRV)=""
 ;
 ;Get current triage provider and time
 S PRV=$$GET1^DIQ(9009080,AMERVSIT_",",17.5,"I")
 S PTIME=$$GET1^DIQ(9009080,AMERVSIT_",",17.6,"I")
 I PRV]"",PTIME]"" S NAMERP("TRIAGE PROVIDER",PTIME,PRV)=""
 ;
 ;Get current primary nurse
 S PRV=$$GET1^DIQ(9009080,AMERVSIT_",",17.8,"I")
 S PTIME=$$GET1^DIQ(9009080,AMERVSIT_",",17.9,"I")
 I PRV]"",PTIME]"" S NAMERP("PRIMARY NURSE",PTIME,PRV)=""
 ;
 ;Get current ED Provider
 S PRV=$$GET1^DIQ(9009080,AMERVSIT_",",.06,"I")
 S PTIME=$$GET1^DIQ(9009080,AMERVSIT_",",17.7,"I")
 I PRV]"",PTIME]"" S NAMERP("ED PROVIDER",PTIME,PRV)=""
 ;
 ;Get discharge nurse
 S PRV=$$GET1^DIQ(9009080,AMERVSIT_",",6.4,"I")
 S PTIME=$$GET1^DIQ(9009080,AMERVSIT_",",6.2,"I")
 I PRV]"",PTIME]"" S NAMERP("DISCHARGE NURSE",PTIME,PRV)=""
 ;
 ;Get discharge provider
 S PRV=$$GET1^DIQ(9009080,AMERVSIT_",",6.3,"I")
 S PTIME=$$GET1^DIQ(9009080,AMERVSIT_",",6.2,"I")
 I PRV]"",PTIME]"" S NAMERP("DISCHARGE PROVIDER",PTIME,PRV)=""
 ;
 Q
