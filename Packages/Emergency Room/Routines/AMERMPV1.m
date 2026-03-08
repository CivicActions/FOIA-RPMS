AMERMPV1 ;GDIT/HS/BEE - Multiple Prov/Nurse Entry - Overflow ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**13**;MAR 03, 2009;Build 36
 ;
 Q
 ;
NHELP(NP) ;
 ;
 NEW DIR,X,Y,NLST,IEN,NNAM,NCNT,QUIT,HYP,DTOUT,DUOUT,DIROUT
 ;
 S $P(HYP,"-",80)="-"
 S DIR(0)="Y"
 S DIR("B")="YES"
 S DIR("A")="Would you like to see a list of "_$S($G(NP)="N":"nurses",1:"providers")_" assigned to the ED"
 S DIR("?")=$S($G(NP)="N":"Nurses",1:"Providers")_" assigned to the ED will possess security key "_$S($G(NP)="N":"AMERZNURSE",1:"AMERZPROVIDER")
 W !
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT)!('$G(Y)) Q
 ;
 ;Get list
 S IEN=0 F  S IEN=$O(^XUSEC($S($G(NP)="N":"AMERZNURSE",1:"AMERZPROVIDER"),IEN)) Q:IEN=""  D
 . S NNAM=$$GET1^DIQ(200,IEN_",",.01,"E")
 . I NNAM]"",$D(^VA(200,"AK.PROVIDER",$P($G(^VA(200,+IEN,0)),U),IEN)) D
 .. S NLST(NNAM)=IEN_U_$$GET1^DIQ(200,IEN_",",1)_U_$$GET1^DIQ(200,IEN_",",8)
 ;
 ;Display the list
 I $O(NLST(""))="" W !!,"There are no "_$S($G(NP)="N":"nurses",1:"providers")_" assigned to the ED with security key "_$S($G(NP)="N":"AMERZNURSE",1:"AMERZPROVIDER") Q
 ;
 W !!,$S($G(NP)="N":"NURSE",1:"PROVIDER"),?32,"INI ",?40,"TITLE",!,HYP
 S (QUIT,NCNT)=0,NNAM="" F  S NNAM=$O(NLST(NNAM)) Q:NNAM=""  D  Q:QUIT
 . W !,$E(NNAM,1,30),?32,$E($P(NLST(NNAM),U,2),1,3),?40,$E($P(NLST(NNAM),U,3),1,35)
 . S NCNT=NCNT+1 I NCNT#10=0 S QUIT=$$CONT() S:$O(NLST(NNAM))="" QUIT=1 Q
 . ;
 . ;Check for last one
 . I $O(NLST(NNAM))="" S QUIT='$$CONT() Q
 Q
 ;
CONT() ;
 NEW DIR,X,Y
 S DIR(0)="E"
 D ^DIR
 I $G(Y) Q 0
 Q 1
 ;
FMTE(FMDT,FORM) ;EP - Conv FMan to Standard External Dt/Time
 S:$G(FORM)="" FORM="5ZM"
 Q $TR($$FMTE^XLFDT(FMDT,FORM),"@"," ")
 ;
GPROV(AMERP,AMERDFN,VIEN) ;Return an array of providers for a visit
 ;
 ;Input:
 ;AMERDFN - Patient DFN
 ;VIEN - Visit IEN (Discharges only)
 ;
 ;Output:
 ;AMERP(TYPE,FMANDT,PROVID)=XDATE^XPROVIDER
 ;
 I +$G(AMERDFN)<1 Q 0
 S VIEN=$G(VIEN)
 ;
 K AMERP
 ;
 NEW EVIEN,PIEN,Y
 ;
 ;Look for the visit IEN
 I 'VIEN D
 . S VIEN=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I")
 I +VIEN<1 Q 0
 ;
 ;Loop through V EMERGENCY MANAGEMENT RECORD and retrieve nurses
 S EVIEN=$O(^AUPNVER("AD",VIEN,"")) I EVIEN="" Q 0
 S PIEN=0 F  S PIEN=$O(^AUPNVER(EVIEN,14,PIEN)) Q:'PIEN  D
 . ;
 . NEW PVIEN,XPNAME,XPTYPE,PDATE,DA,IENS
 . ;
 . ;Retrieve information for nurse
 . S DA(1)=EVIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S PVIEN=$$GET1^DIQ(9000010.2914,IENS,.01,"I") Q:PVIEN=""
 . S XPNAME=$$GET1^DIQ(200,PVIEN_",",.01,"E") I XPNAME="" D  Q:XPNAME=""
 .. S XPNAME=$$GET1^DIQ(200,PVIEN_",",.01,"I")
 .. I XPNAME="" S XPNAME=PVIEN
 . S XPTYPE=$$GET1^DIQ(9000010.2914,IENS,".02","E") Q:XPTYPE=""
 . S PDATE=$$GET1^DIQ(9000010.2914,IENS,".03","I") Q:PDATE=""
 . ;
 . ;Set up return array
 . S AMERP(XPTYPE,PDATE,PVIEN)=$$FMTE(PDATE)_U_XPNAME
 ;
 ;Loop through V EMERGENCY MANAGEMENT RECORD and retrieve providers
 S PIEN=0 F  S PIEN=$O(^AUPNVER(EVIEN,13,PIEN)) Q:'PIEN  D
 . ;
 . NEW PVIEN,XPNAME,XPTYPE,PDATE,DA,IENS
 . ;
 . ;Retrieve information for provider
 . S DA(1)=EVIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S PVIEN=$$GET1^DIQ(9000010.2913,IENS,.01,"I") Q:PVIEN=""
 . S XPNAME=$$GET1^DIQ(200,PVIEN_",",.01,"E") I XPNAME="" D  Q:XPNAME=""
 .. S XPNAME=$$GET1^DIQ(200,PVIEN_",",.01,"I")
 .. I XPNAME="" S XPNAME=PVIEN
 . S XPTYPE=$$GET1^DIQ(9000010.2913,IENS,".02","E") Q:XPTYPE=""
 . S PDATE=$$GET1^DIQ(9000010.2913,IENS,".03","I") Q:PDATE=""
 . ;
 . ;Set up return array
 . S AMERP(XPTYPE,PDATE,PVIEN)=$$FMTE(PDATE)_U_XPNAME
 ;
 Q $S($O(AMERP(""))]"":1,1:0)
 ;
GETP(AMERDFN,VIEN,TYPE,AMERARY) ;Return the latest provider information for type
 ;
 I +$G(AMERDFN)<1 Q ""
 I $G(TYPE)="" Q ""
 S VIEN=$G(VIEN)
 ;
 K AMERARY,AMERP
 ;
 NEW PDATE,PIEN
 ;
 ;Get a list of all providers/nurses
 S AMERP=$$GPROV(.AMERP,AMERDFN,VIEN)
 ;
 ;Get the latest for the type
 S (AMERARY,PDATE)="" F  S PDATE=$O(AMERP(TYPE,PDATE)) Q:PDATE=""  D
 . S PIEN="" F  S PIEN=$O(AMERP(TYPE,PDATE,PIEN)) Q:PIEN=""  D
 .. S AMERARY(PDATE,PIEN)=""
 .. S AMERARY=PIEN_U_PDATE_U_$P(AMERP(TYPE,PDATE,PIEN),U)_U_$P(AMERP(TYPE,PDATE,PIEN),U,2)
 ;
 Q AMERARY
 ;
SADM(AMERDFN,APROV,ANURSE) ;Sync ER ADMISSION entry
 ;
 NEW TIME,PRV,TYP,ARY,AMERUPD,ERROR
 ;
 ;Loop through nurses first
 S TIME="" F  S TIME=$O(ANURSE(TIME)) Q:TIME=""  D
 . S PRV="" F  S PRV=$O(ANURSE(TIME,PRV)) Q:PRV=""  D
 .. S TYP="" F  S TYP=$O(ANURSE(TIME,PRV,TYP)) Q:TYP=""  D
 ... ;
 ... ;Triage nurse
 ... I TYP="TR" S ARY("TrgN")=PRV,ARY("TrgNow")=TIME Q
 ... ;
 ... ;Primary nurse
 ... I TYP="PR" S ARY("PrmNurse")=PRV,ARY("PrmNurseDTM")=TIME Q
 ;
 ;Now loop through providers
 S TIME="" F  S TIME=$O(APROV(TIME)) Q:TIME=""  D
 . S PRV="" F  S PRV=$O(APROV(TIME,PRV)) Q:PRV=""  D
 .. S TYP="" F  S TYP=$O(APROV(TIME,PRV,TYP)) Q:TYP=""  D
 ... ;
 ... ;Triage provider
 ... I TYP="TR" S ARY("TrgP")=PRV,ARY("TrgPDtTm")=TIME Q
 ... ;
 ... ;ED provider
 ... I TYP="ED" S ARY("AdmPrv")=PRV,ARY("EDPvDtm")=TIME Q
 ;
 ;Pull from ER ADMISSION if blank
 ;I $G(ARY("TrgN"))="" S ARY("TrgN")=$$GET1^DIQ(9009081,AMERDFN_",",19,"I")
 ;I $G(ARY("TrgNow"))="" S ARY("TrgNow")=$$GET1^DIQ(9009081,AMERDFN_",",21,"I")
 ;I $G(ARY("PrmNurse"))="" S ARY("PrmNurse")=$$GET1^DIQ(9009081,AMERDFN_",",1.04,"I")
 ;I $G(ARY("PrmNurseDTM"))="" S ARY("PrmNurseDTM")=$$GET1^DIQ(9009081,AMERDFN_",",1.05,"I")
 ;I $G(ARY("AdmPrv"))="" S ARY("AdmPrv")=$$GET1^DIQ(9009081,AMERDFN_",",18,"I")
 ;I $G(ARY("EDPvDtm"))="" S ARY("EDPvDtm")=$$GET1^DIQ(9009081,AMERDFN_",",1.03,"I")
 ;I $G(ARY("TrgP"))="" S ARY("TrgP")=$$GET1^DIQ(9009081,AMERDFN_",",1.01,"I")
 ;I $G(ARY("TrgPDtTm"))="" S ARY("TrgPDtTm")=$$GET1^DIQ(9009081,AMERDFN_",",1.02,"I")
 ;
 S AMERUPD(9009081,AMERDFN_",",19)=$S($G(ARY("TrgN"))]"":ARY("TrgN"),1:"@")
 S AMERUPD(9009081,AMERDFN_",",21)=$S($G(ARY("TrgNow"))]"":ARY("TrgNow"),1:"@")
 S AMERUPD(9009081,AMERDFN_",",1.04)=$S($G(ARY("PrmNurse"))]"":ARY("PrmNurse"),1:"@")
 S AMERUPD(9009081,AMERDFN_",",1.05)=$S($G(ARY("PrmNurseDTM"))]"":ARY("PrmNurseDTM"),1:"@")
 S AMERUPD(9009081,AMERDFN_",",1.01)=$S($G(ARY("TrgP"))]"":ARY("TrgP"),1:"@")
 S AMERUPD(9009081,AMERDFN_",",1.02)=$S($G(ARY("TrgPDtTm"))]"":ARY("TrgPDtTm"),1:"@")
 S AMERUPD(9009081,AMERDFN_",",18)=$S($G(ARY("AdmPrv"))]"":ARY("AdmPrv"),1:"@")
 S AMERUPD(9009081,AMERDFN_",",1.03)=$S($G(ARY("EDPvDtm"))]"":ARY("EDPvDtm"),1:"@")
 D FILE^DIE("","AMERUPD","ERROR")
 ;
 Q
 ;
SVIS(AMERDFN,VIEN,APROV,ANURSE) ;Sync ER ADMISSION entry
 ;
 NEW TIME,PRV,TYP,ARY,AMERUPD,ERROR,AMERVSIT
 ;
 I '$G(VIEN) Q
 ;
 ;Retrieve ER VISIT pointer
 S AMERVSIT=$O(^AMERVSIT("AD",VIEN,"")) I AMERVSIT="" Q
 ;
 ;Loop through nurses first
 S TIME="" F  S TIME=$O(ANURSE(TIME)) Q:TIME=""  D
 . S PRV="" F  S PRV=$O(ANURSE(TIME,PRV)) Q:PRV=""  D
 .. S TYP="" F  S TYP=$O(ANURSE(TIME,PRV,TYP)) Q:TYP=""  D
 ... ;
 ... ;Triage nurse
 ... I TYP="TR" S ARY("TrgN")=PRV,ARY("TrgNow")=TIME Q
 ... ;
 ... ;Primary nurse
 ... I TYP="PR" S ARY("PrmNurse")=PRV,ARY("PrmNurseDTM")=TIME Q
 ;
 ;Now loop through providers
 S TIME="" F  S TIME=$O(APROV(TIME)) Q:TIME=""  D
 . S PRV="" F  S PRV=$O(APROV(TIME,PRV)) Q:PRV=""  D
 .. S TYP="" F  S TYP=$O(APROV(TIME,PRV,TYP)) Q:TYP=""  D
 ... ;
 ... ;Triage provider
 ... I TYP="TR" S ARY("TrgP")=PRV,ARY("TrgPDtTm")=TIME Q
 ... ;
 ... ;ED provider
 ... I TYP="ED" S ARY("AdmPrv")=PRV,ARY("EDPvDtm")=TIME Q
 ;
 ;Pull from ER ADMISSION if blank
 ;I $G(ARY("TrgN"))="" S ARY("TrgN")=$$GET1^DIQ(9009080,AMERDFN_",",.07,"I")
 ;I $G(ARY("TrgNow"))="" S ARY("TrgNow")=$$GET1^DIQ(9009080,AMERDFN_",",12.2,"I")
 ;I $G(ARY("PrmNurse"))="" S ARY("PrmNurse")=$$GET1^DIQ(9009080,AMERDFN_",",17.8,"I")
 ;I $G(ARY("PrmNurseDTM"))="" S ARY("PrmNurseDTM")=$$GET1^DIQ(9009080,AMERDFN_",",17.9,"I")
 ;I $G(ARY("AdmPrv"))="" S ARY("AdmPrv")=$$GET1^DIQ(9009080,AMERDFN_",",.06,"I")
 ;I $G(ARY("EDPvDtm"))="" S ARY("EDPvDtm")=$$GET1^DIQ(9009080,AMERDFN_",",17.7,"I")
 ;I $G(ARY("TrgP"))="" S ARY("TrgP")=$$GET1^DIQ(9009080,AMERDFN_",",17.5,"I")
 ;I $G(ARY("TrgPDtTm"))="" S ARY("TrgPDtTm")=$$GET1^DIQ(9009080,AMERDFN_",",17.6,"I")
 ;
 S AMERUPD(9009080,AMERVSIT_",",.07)=$S($G(ARY("TrgN"))]"":ARY("TrgN"),1:"@")
 S AMERUPD(9009080,AMERVSIT_",",12.2)=$S($G(ARY("TrgNow"))]"":ARY("TrgNow"),1:"@")
 S AMERUPD(9009080,AMERVSIT_",",17.8)=$S($G(ARY("PrmNurse"))]"":ARY("PrmNurse"),1:"@")
 S AMERUPD(9009080,AMERVSIT_",",17.9)=$S($G(ARY("PrmNurseDTM"))]"":ARY("PrmNurseDTM"),1:"@")
 S AMERUPD(9009080,AMERVSIT_",",17.5)=$S($G(ARY("TrgP"))]"":ARY("TrgP"),1:"@")
 S AMERUPD(9009080,AMERVSIT_",",17.6)=$S($G(ARY("TrgPDtTm"))]"":ARY("TrgPDtTm"),1:"@")
 S AMERUPD(9009080,AMERVSIT_",",.06)=$S($G(ARY("AdmPrv"))]"":ARY("AdmPrv"),1:"@")
 S AMERUPD(9009080,AMERVSIT_",",17.7)=$S($G(ARY("EDPvDtm"))]"":ARY("EDPvDtm"),1:"@")
 D FILE^DIE("","AMERUPD","ERROR")
 ;
 Q
