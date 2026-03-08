AMERPRV ;GDIT/HS/BEE - SYNCHRONIZE AMER PROVIDERS WITH PCC ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**11,13,16**;MAR 03, 2009;Build 14
 ;
 Q
 ;
SYNC(AUPNVSIT) ;EP - Sync AMER with PCC
 ;
 ;Input variable:
 ; AUPNVSIT - Visit IEN
 ;
 NEW AMERVSIT,DFN
 ;
 ;Make sure PCC visit is valid
 I $G(AUPNVSIT)="" Q  ;Missing visit
 I '$D(^AUPNVSIT(AUPNVSIT)) Q  ;Invalid visit
 S AMERVSIT=$O(^AMERVSIT("AD",AUPNVSIT,""))
 ;
 ;Get DFN
 S DFN=$$GET1^DIQ(9000010,AUPNVSIT,.05,"I") Q:DFN=""
 ;
 ;Determine if patient still in ED or discharged
 I AMERVSIT]"" D DISCH(AMERVSIT,AUPNVSIT,DFN) Q  ;Discharged
 D ADM(AUPNVSIT,DFN)  ;Still admitted
 ;
 Q
 ;
ADM(AUPNVSIT,DFN) ;Sync providers - still in ED
 ;
 NEW TRGN,PRMP,PRMN,PRMY,CPRM,PVIEN,PVLIST,SPRV,PRMLST,TRGNT,PRMPT,VDT,CIEN
 ;GDIT/HS/BEE 10/05/22;AMER*3.0*13;CR#5100;Handle triage provider, new nurse fields, provider table
 NEW TRGP,TRGPT,PRMNDT,AMERP
 ;
 ;Locate current primary on visit
 S (CPRM,PVIEN,CIEN)="" F  S PVIEN=$O(^AUPNVPRV("AD",AUPNVSIT,PVIEN)) Q:'PVIEN  D
 . NEW PS,PRV
 . S PRV=$$GET1^DIQ(9000010.06,PVIEN_",",.01,"I") Q:PRV=""
 . S PVLIST(PRV)=PVIEN
 . S PS=$$GET1^DIQ(9000010.06,PVIEN_",",.04,"I") I PS'="P" Q
 . S CPRM=$$GET1^DIQ(9000010.06,PVIEN_",",.01,"I") Q:CPRM=""
 . S PRMLST(PVIEN)=CPRM
 ;
 ;Visit date and time
 S VDT=$$GET1^DIQ(9000010,AUPNVSIT_",",.01,"I")
 ;
 ;Triage nurse and time
 S TRGN=$$GET1^DIQ(9009081,DFN_",",19,"I")
 S TRGNT=$$GET1^DIQ(9009081,DFN_",",21,"I")
 ;
 ;GDIT/HS/BEE 10/05/22;AMER*3.0*13;CR#5100;Handle triage provider
 ;Triage provider and time
 S TRGP=$$GET1^DIQ(9009081,DFN_",",1.01,"I")
 S TRGPT=$$GET1^DIQ(9009081,DFN_",",1.02,"I")
 ;
 ;Primary nurse - new fields implemented in BEDD patch 6
 S PRMN=$$GET1^DIQ(9009081,DFN_",",1.04,"I")
 S PRMNDT=$$GET1^DIQ(9009081,DFN_",",1.05,"I")
 ;If blank look for BEDD patch 4
 I PRMN="",$T(PRMN^BEDDUTW1)]"" S PRMN=$$PRMN^BEDDUTW1(AUPNVSIT),PRMNDT=VDT
 ;
 ;Primary provider and time
 S PRMP=$$GET1^DIQ(9009081,DFN_",",18,"I")
 S PRMPT=$$GET1^DIQ(9009081,DFN_",",1.03,"I")
 ;
 ;Save each entry - have to handle case where same provider could be in
 ;multiple roles
 S PRMY=""
 I PRMP]"" S PRMY=PRMP,SPRV(PRMP)="" D SAVE(AUPNVSIT,DFN,PRMP,PRMY,+$G(PVLIST(PRMP)),PRMPT)
 I PRMN]"",'$D(SPRV(PRMN)) S SPRV(PRMN)="" D SAVE(AUPNVSIT,DFN,PRMN,$S(PRMY="":PRMN,1:""),+$G(PVLIST(PRMN)),PRMNDT) S:PRMY="" PRMY=PRMN
 ;GDIT/HS/BEE 10/05/22;AMER*3.0*13;CR#5100;Handle triage provider
 I TRGP]"",'$D(SPRV(TRGP)) S SPRV(TRGP)="" D SAVE(AUPNVSIT,DFN,TRGP,$S(PRMY="":TRGP,1:""),+$G(PVLIST(TRGP)),TRGPT) S:PRMY="" PRMY=TRGP
 I TRGN]"",'$D(SPRV(TRGN)) S SPRV(TRGN)="" D SAVE(AUPNVSIT,DFN,TRGN,$S(PRMY="":TRGN,1:""),+$G(PVLIST(TRGN)),TRGNT) S:PRMY="" PRMY=TRGN
 ;
 ;Process entries in V EMERGENCY VISIT RECORD
 D PROV(AUPNVSIT,DFN,.SPRV,.PVLIST)
 ;
 ;Make original primary now secondary if different
 S PVIEN="" F  S PVIEN=$O(PRMLST(PVIEN)) Q:PVIEN=""  D
 . S CPRM=PRMLST(PVIEN)
 . I CPRM'=PRMY,PRMY]"" D
 .. NEW PVUP,ERR
 .. S PVUP(9000010.06,PVIEN_",",.04)="S"
 .. D FILE^DIE("","PVUP","ERR")
 ;
 Q
 ;
DISCH(AMERVSIT,AUPNVSIT,DFN) ;Sync providers - discharged
 ;
 NEW TRGN,PRMP,PRMN,PRMY,CPRM,PVIEN,PVLIST,DSCHP,DSCHN,SPRV,PRMLST,TRGNT,PRMPT,VDT,CIEN
 ;GDIT/HS/BEE 10/05/22;AMER*3.0*13;CR#5100;Handle triage provider and primary nurse fields
 NEW TRGP,TRGPT,PRMNDT
 ;
 ;Locate current primary on visit
 S (CPRM,PVIEN,CIEN)="" F  S PVIEN=$O(^AUPNVPRV("AD",AUPNVSIT,PVIEN)) Q:'PVIEN  D
 . NEW PS,PRV
 . S PRV=$$GET1^DIQ(9000010.06,PVIEN_",",.01,"I") Q:PRV=""
 . S PVLIST(PRV)=PVIEN
 . S PS=$$GET1^DIQ(9000010.06,PVIEN_",",.04,"I") I PS'="P" Q
 . S CPRM=$$GET1^DIQ(9000010.06,PVIEN_",",.01,"I") Q:CPRM=""
 . S PRMLST(PVIEN)=CPRM
 ;
 ;Visit date and time
 S VDT=$$GET1^DIQ(9000010,AUPNVSIT_",",.01,"I")
 ;
 ;Triage nurse and time
 S TRGN=$$GET1^DIQ(9009080,AMERVSIT_",",.07,"I")
 S TRGNT=$$GET1^DIQ(9009080,AMERVSIT_",",12.2,"I")
 ;
 ;GDIT/HS/BEE 10/05/22;AMER*3.0*13;CR#5100;Handle triage provider
 S TRGP=$$GET1^DIQ(9009080,AMERVSIT_",",17.5,"I")
 S TRGPT=$$GET1^DIQ(9009080,AMERVSIT_",",17.6,"I")
 ;
 ;Primary nurse - new fields implemented in BEDD patch 7
 S PRMN=$$GET1^DIQ(9009080,AMERVSIT_",",17.8,"I")
 S PRMNDT=$$GET1^DIQ(9009080,AMERVSIT_",",17.9,"I")
 ;If blank look for BEDD patch 4
 I PRMN="",$T(PRMN^BEDDUTW1)]"" S PRMN=$$PRMN^BEDDUTW1(AUPNVSIT),PRMNDT=VDT
 ;
 ;Primary provider and time
 S PRMP=$$GET1^DIQ(9009080,AMERVSIT_",",.06,"I")
 S PRMPT=$$GET1^DIQ(9009080,AMERVSIT_",",17.7,"I")
 ;
 ;Discharge nurse
 S DSCHN=$$GET1^DIQ(9009080,AMERVSIT_",",6.4,"I")
 ;
 ;Discharge provider
 S DSCHP=$$GET1^DIQ(9009080,AMERVSIT_",",6.3,"I")
 ;
 ;Save each entry - have to handle case where same provider could be in
 ;multiple roles
 S PRMY=""
 I DSCHP]"" S PRMY=DSCHP,SPRV(DSCHP)="" D SAVE(AUPNVSIT,DFN,DSCHP,PRMY,+$G(PVLIST(DSCHP)),VDT)
 I DSCHN]"",'$D(SPRV(DSCHN)) S SPRV(DSCHN)="" D SAVE(AUPNVSIT,DFN,DSCHN,$S(PRMY="":DSCHN,1:""),+$G(PVLIST(DSCHN)),PRMNDT) S:PRMY="" PRMY=DSCHN
 I PRMP]"",'$D(SPRV(PRMP)) S SPRV(PRMP)="" D SAVE(AUPNVSIT,DFN,PRMP,$S(PRMY="":PRMP,1:""),+$G(PVLIST(PRMP)),PRMPT) S:PRMY="" PRMY=PRMP
 I PRMN]"",'$D(SPRV(PRMN)) S SPRV(PRMN)="" D SAVE(AUPNVSIT,DFN,PRMN,$S(PRMY="":PRMN,1:""),+$G(PVLIST(PRMN)),VDT) S:PRMY="" PRMY=PRMN
 I TRGP]"",'$D(SPRV(TRGP)) S SPRV(TRGP)="" D SAVE(AUPNVSIT,DFN,TRGP,$S(PRMY="":TRGP,1:""),+$G(PVLIST(TRGP)),VDT) S:PRMY="" PRMY=TRGP
 I TRGN]"",'$D(SPRV(TRGN)) S SPRV(TRGN)="" D SAVE(AUPNVSIT,DFN,TRGN,$S(PRMY="":TRGN,1:""),+$G(PVLIST(TRGN)),TRGNT) S:PRMY="" PRMY=TRGN
 ;
 ;Process entries in V EMERGENCY VISIT RECORD
 D PROV(AUPNVSIT,DFN,.SPRV,.PVLIST)
 ;
 ;Make original primary now secondary if different
 S PVIEN="" F  S PVIEN=$O(PRMLST(PVIEN)) Q:PVIEN=""  D
 . S CPRM=PRMLST(PVIEN)
 . I CPRM'=PRMY,PRMY]"" D
 .. NEW PVUP,ERR
 .. S PVUP(9000010.06,PVIEN_",",.04)="S"
 .. D FILE^DIE("","PVUP","ERR")
 ;
 Q
 ;
TRAUMA(AUPNVSIT,DFN,PRV,TIME) ;Add trauma provider as V PROVIDER
 ;
 NEW PIEN,PFND,PCNT,PRMY,D
 ;
 I +$G(AUPNVSIT)=0 Q
 I +$G(PRV)=0 Q
 ;
 ;See if provider already added
 S (PCNT,PFND,PIEN)=0 F  S PIEN=$O(^AUPNVPRV("AD",AUPNVSIT,PIEN)) Q:'PIEN  D  Q:PFND
 . S PCNT=PCNT+1
 . I PRV'=$$GET1^DIQ(9000010.06,PIEN_",",.01,"I") Q
 . S PFND=PRV
 Q:PFND
 ;
 ;If this is the first entry, make primary
 S PRMY="" I 'PCNT S PRMY=1
 ;
 ;Create the V PROVIDER entry
 D SAVE(AUPNVSIT,DFN,PRV,PRMY,"",TIME)
 ;
 Q
 ;
SAVE(AUPNVSIT,DFN,PRV,PRMY,PVIEN,TIME) ;Process one provider
 ;
 I +$G(AUPNVSIT)=0 Q
 I +$G(DFN)=0 Q
 I +$G(PRV)=0 Q
 I '$D(^VA(200,PRV,0)) Q
 ;
 NEW PVUP,ERR,ADD,PIEN,FIEN
 ;
 ;Determine whether primary or secondary
 I PRMY]"" S PRMY="P"
 E  S PRMY="S"
 ;
 ;Create new entry
 I '+$G(PVIEN) S ADD=$$ADDPRV^AMERPCC1(AUPNVSIT,PRV,TIME,DFN,PRMY,"")
 ;
 ;Find the entry IEN
 S (PIEN,FIEN)="" F  S PIEN=$O(^AUPNVPRV("AD",AUPNVSIT,PIEN)) Q:'PIEN  D  Q:FIEN
 . NEW PROV
 . S PROV=$$GET1^DIQ(9000010.06,PIEN_",",.01,"I") I PRV'=PROV Q
 . S FIEN=PIEN
 ;
 ;Update primary/secondary
 S PVUP(9000010.06,FIEN_",",.04)=PRMY
 D FILE^DIE("","PVUP","ERR")
 ;
 Q
 ;
PROV(VIEN,DFN,SPRV,PVLIST) ;Put providers in V EMERGENCY VISIT RECORD into V PROVIDER
 ;
 ;VIEN - Visit IEN
 ;DFN - Patient DFN
 ;
 NEW EVIEN,PIEN,NIEN,PLIST,PTYPE,PPROV,PDATE
 ;
 ;Verify a visit and DFN passed in
 I +$G(VIEN)<1 Q
 I +$G(DFN)<1 Q
 ;
 ;Loop through V EMERGENCY MANAGEMENT RECORD and retrieve nurses
 S EVIEN=$O(^AUPNVER("AD",VIEN,"")) I EVIEN="" Q 0
 S NIEN=0 F  S NIEN=$O(^AUPNVER(EVIEN,14,NIEN)) Q:'NIEN  D
 . ;
 . NEW NVIEN,NNAME,NTYPE,NDATE,DA,IENS
 . ;
 . ;Retrieve information for nurse
 . S DA(1)=EVIEN,DA=NIEN,IENS=$$IENS^DILF(.DA)
 . S NVIEN=$$GET1^DIQ(9000010.2914,IENS,.01,"I") Q:NVIEN=""
 . S NDATE=$$GET1^DIQ(9000010.2914,IENS,".03","I") Q:NDATE=""
 . S NTYPE=$$GET1^DIQ(9000010.2914,IENS,".02","E") Q:NTYPE=""
 . ;
 . ;Set up return array
 . S PLIST(NTYPE,NDATE,NVIEN)=""
 ;
 ;Loop through V EMERGENCY MANAGEMENT RECORD and retrieve providers
 S PIEN=0 F  S PIEN=$O(^AUPNVER(EVIEN,13,PIEN)) Q:'PIEN  D
 . ;
 . NEW PVIEN,PNAME,PTYPE,PDATE,DA,IENS,T,D,P
 . ;
 . ;Retrieve information for provider
 . S DA(1)=EVIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S PVIEN=$$GET1^DIQ(9000010.2913,IENS,.01,"I") Q:PVIEN=""
 . S PDATE=$$GET1^DIQ(9000010.2913,IENS,".03","I") Q:PDATE=""
 . S PTYPE=$$GET1^DIQ(9000010.2913,IENS,".02","E") Q:PTYPE=""
 . ;
 . ;Set up return array
 . S PLIST(PTYPE,PDATE,PVIEN)=""
 ;
 ;Create V PROVIDER entries if not already defined
 S PTYPE="" F  S PTYPE=$O(PLIST(PTYPE)) Q:PTYPE=""  D
 . S PDATE="" F  S PDATE=$O(PLIST(PTYPE,PDATE)) Q:PDATE=""  D
 .. S PPROV="" F  S PPROV=$O(PLIST(PTYPE,PDATE,PPROV)) Q:PPROV=""  D
 ... I '$D(SPRV(PPROV)) S SPRV(PPROV)="" D SAVE(VIEN,DFN,PPROV,"",+$G(PVLIST(PPROV)),PDATE)
 ;
 Q
 ;
FMTE(FMDT,FORM) ;EP - Conv FMan to Standard External Dt/Time
 S:$G(FORM)="" FORM="5ZM"
 Q $TR($$FMTE^XLFDT(FMDT,FORM),"@"," ")
 ;
DELP(AMERDFN,DTYPE,DPIEN,DPDATE,VIEN) ;Delete a nurse/provider entry from V EMERGENCY VISIT RECORD
 ;
 I +$G(AMERDFN)<1 Q
 I $G(DTYPE)="" Q
 I +$G(DPIEN)<1,$G(DPIEN)'="NULL" Q
 I $G(DPDATE)="" Q
 S VIEN=$G(VIEN)
 ;
 NEW EVIEN,PIEN
 ;
 ;Look for the visit IEN
 I 'VIEN D
 . S VIEN=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I")
 I +VIEN<1 Q
 ;
 ;Look in nurses
 S EVIEN=$O(^AUPNVER("AD",VIEN,"")) I EVIEN="" Q 0
 S PIEN=0 F  S PIEN=$O(^AUPNVER(EVIEN,14,PIEN)) Q:'PIEN  D
 . ;
 . NEW PVIEN,XPTYPE,PDATE,DA,IENS,DIK
 . ;
 . ;Retrieve information for nurse
 . S DA(1)=EVIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S PVIEN=$$GET1^DIQ(9000010.2914,IENS,.01,"I") I PVIEN'=DPIEN Q
 . S XPTYPE=$$GET1^DIQ(9000010.2914,IENS,".02","E") I XPTYPE'=DTYPE Q
 . S PDATE=$$GET1^DIQ(9000010.2914,IENS,".03","I") I PDATE'=DPDATE Q
 . ;
 . ;Found a match - remove
 . S DIK="^AUPNVER("_DA(1)_",14," D ^DIK
 ;
 ;Look in providers
 S PIEN=0 F  S PIEN=$O(^AUPNVER(EVIEN,13,PIEN)) Q:'PIEN  D
 . ;
 . NEW PVIEN,XPTYPE,PDATE,DA,IENS,DIK
 . ;
 . ;Retrieve information for provider
 . S DA(1)=EVIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S PVIEN=$$GET1^DIQ(9000010.2913,IENS,.01,"I") I PVIEN'=DPIEN Q
 . S XPTYPE=$$GET1^DIQ(9000010.2913,IENS,".02","E") I XPTYPE'=DTYPE Q
 . S PDATE=$$GET1^DIQ(9000010.2913,IENS,".03","I") I PDATE'=DPDATE Q
 . ;
 . ;Found a match - remove
 . S DIK="^AUPNVER("_DA(1)_",13," D ^DIK
 ;
 Q
EDTP(AMERDFN,VIEN,ETYPE,EPIEN,OPDATE,NPDATE) ;Edit a nurse/provider entry from V EMERGENCY VISIT RECORD
 ;
 I +$G(AMERDFN)<1 Q
 I $G(ETYPE)="" Q
 I +$G(EPIEN)<1 Q
 I $G(OPDATE)="" Q
 I $G(NPDATE)="" Q
 S VIEN=$G(VIEN)
 ;
 NEW EVIEN,PIEN
 ;
 ;Look for the visit IEN
 I 'VIEN D
 . S VIEN=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I")
 I +VIEN<1 Q
 ;
 ;
 ;Look in nurses
 S EVIEN=$O(^AUPNVER("AD",VIEN,"")) I EVIEN="" Q 0
 S PIEN=0 F  S PIEN=$O(^AUPNVER(EVIEN,14,PIEN)) Q:'PIEN  D
 . ;
 . NEW PVIEN,XPTYPE,PDATE,DA,IENS,EUPD,ERR
 . ;
 . ;Retrieve information for nurse
 . S DA(1)=EVIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S PVIEN=$$GET1^DIQ(9000010.2914,IENS,.01,"I") I PVIEN'=EPIEN Q
 . S XPTYPE=$$GET1^DIQ(9000010.2914,IENS,".02","E") I XPTYPE'=ETYPE Q
 . S PDATE=$$GET1^DIQ(9000010.2914,IENS,".03","I") I PDATE'=OPDATE Q
 . ;
 . ;Found a match - edit date/time
 . S EUPD(9000010.2914,IENS,".03")=NPDATE
 . D FILE^DIE("","EUPD","ERR")
 ;
 ;Look in providers
 S PIEN=0 F  S PIEN=$O(^AUPNVER(EVIEN,13,PIEN)) Q:'PIEN  D
 . ;
 . NEW PVIEN,XPTYPE,PDATE,DA,IENS,DIK
 . ;
 . ;Retrieve information for provider
 . S DA(1)=EVIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S PVIEN=$$GET1^DIQ(9000010.2913,IENS,.01,"I") I PVIEN'=EPIEN Q
 . S XPTYPE=$$GET1^DIQ(9000010.2913,IENS,".02","E") I XPTYPE'=ETYPE Q
 . S PDATE=$$GET1^DIQ(9000010.2913,IENS,".03","I") I PDATE'=OPDATE Q
 . ;
 . ;Found a match - edit date/time
 . S EUPD(9000010.2913,IENS,".03")=NPDATE
 . D FILE^DIE("","EUPD","ERR")
 ;
 Q
