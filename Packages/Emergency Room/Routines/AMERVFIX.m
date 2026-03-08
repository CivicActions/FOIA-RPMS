AMERVFIX ;GDIT/HS/BEE - Clean up AMER visits ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**11**;MAR 03, 2009;Build 27
 ;
 Q
 ;
 ;Daily AMER cleanup routine
DAILY(BYPASS) ;EP - Review AMER (and BEDD) files/clean up issues
 ;
 NEW EXEC,BIEN,LOC,PI
 ;
 ;If no BEDD cleanup routine yet and BEDD getting used
 ;wait to run until BEDDp4 installed
 S BIEN="",EXEC="S BIEN=$G(^BEDD.EDVISITD)" X EXEC
 I $T(CLEAN^BEDDVFIX)="",BIEN>10 Q
 ;
 ;Lock so only one can run
 L +^AMER(2.5):2 E  Q
 ;
 S BYPASS=$G(BYPASS)
 S PI=0 S:BYPASS PI=1
 S LOC=0 F  S LOC=$O(^AMER(2.5,LOC)) Q:'LOC  D
 . ;
 . ;See if run for day
 . I 'BYPASS Q:$$GET1^DIQ(9009082.5,LOC_",",.07,"I")'<DT
 . ;
 . ;Task cleanup routine
 . I BYPASS'=1 D
 .. NEW MSG,REC
 .. D TASK(LOC,PI)
 .. S MSG="Daily AMERVFIX routine tasked off"
 .. D AUD("AMERVFIX"," "," ","A01",0,MSG," ",.REC)
 . ;
 . ;Run cleanup in foreground
 . I BYPASS=1 D
 .. NEW MSG,REC
 .. D CLEAN
 .. S MSG="Daily AMERVFIX routine run in foreground"
 .. D AUD("AMERVFIX","AMERVFIX","FORE","A02",0,MSG,"|",.REC)
 . ;
 . ;Mark as completed for day so it doesn't get rerun
 . I 'BYPASS,$D(^AMER(2.5,LOC,0)) D
 .. NEW UPD,ERROR
 .. S UPD(9009082.5,LOC_",",.07)=DT
 .. D FILE^DIE("","UPD","ERROR")
 ;
 ;Unlock entry
 L -^AMER(2.5)
 ;
 Q
 ;
TASK(LOC,PI) ;EP - Queue cleanup task to run
 ;
 NEW ZTRTN,ZTIO,ZTDTH,ZTSK,ZTSAVE,ZTDESC
 ;
 ;Queue process off in background
 S ZTRTN="CLEAN^AMERVFIX",ZTDESC="AMER - Run AMER visit cleanup utility"
 ;
 S ZTSAVE("LOC")=""
 S ZTSAVE("PI")=""
 S ZTIO=""
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 D ^%ZTLOAD
 ;
 Q
 ;
CLEAN ;EP - Run cleanup routine
 ;
 ;Input var: LOC-Calling User's DUZ(2)
 ;           PI-First time run
 ;
 NEW AMERDFN,AMERVSIT,X1,X2,X,VDATE
 ;
 ;Define location
 S LOC=$S($G(LOC)]"":LOC,1:+$G(DUZ(2)))
 ;
 D NOW^%DTC
 ;
 ;Check if first time run
 S PI=+$G(PI) S:$G(^XTMP("AMERUPD",0))="" PI=1
 ;
 ;Mark as completed for day
 I $D(^AMER(2.5,LOC,0)) D
 . NEW UPD,ERROR
 . S UPD(9009082.5,LOC_",",.07)=DT
 . D FILE^DIE("","UPD","ERROR")
 ;
 ;Set up Monitoring Global
 S X1=DT,X2=60 D C^%DTC
 S ^XTMP("AMERUPD",0)=X_U_DT_U_"AMER/BEDD file updates/fixes"
 ;
 ;Loop through ER ADMISSION and look for issues
 S AMERDFN=0 F  S AMERDFN=$O(^AMERADM(AMERDFN)) Q:'AMERDFN  D PCADM(AMERDFN,PI)
 ;
 ;Loop through ER VISIT and look for issues
 S X1=DT,X2=-30 D C^%DTC S VDATE=X S:PI VDATE=""
 F  S VDATE=$O(^AMERVSIT("B",VDATE)) Q:'VDATE  S AMERVSIT=0 F  S AMERVSIT=$O(^AMERVSIT("B",VDATE,AMERVSIT)) Q:'AMERVSIT  D PCVST(AMERVSIT,PI)
 ;
 ;Run BEDD cleanup
 I $T(CLEAN^BEDDVFIX)]"" D CLEAN^BEDDVFIX(PI)
 Q
 ;
PCADM(AMERDFN,PI) ;Process one ER ADMISSION entry
 ;
 NEW AMVIEN,AMVDT,PCVISIT,DEL,STS,PMRG
 ;
 S (PMRG,DEL)=""
 ;
 ;Get visit date
 S AMVDT=$$GET1^DIQ(9009081,AMERDFN_",",1,"I")
 ;
 ;Retrieve PCC visit pointer
 S AMVIEN=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I")
 ;
 ;Check visit - return VISIT|Merged DFN|Merged Visit|Code|New visit date/time
 S PCVISIT=$$CKVISIT(AMVIEN,AMERDFN,AMVDT)
 S:$P(PCVISIT,"|",4)="D" DEL=1
 ;
 ;Look for DFN change and update ER ADMISSION and BEDD.EDVISIT
 I 'DEL,$P(PCVISIT,"|",2) S PMRG=$$AMGDFN(AMVIEN,AMERDFN,PCVISIT)
 S:PMRG="-1" $P(PCVISIT,"|",6)=1  ;Merge failed
 ;
 ;If match, check/update BEDD and quit
 I 'DEL,AMVIEN]"",$P(PCVISIT,"|")=AMVIEN D BADM(AMVIEN,AMERDFN,PCVISIT,1,0) Q
 ;
 ;Remove admission entry if no visit
 I DEL!($P(PCVISIT,"|")="") D  Q
 . NEW REC,MSG
 . ;
 . ;First Update BEDD
 . D BADM(AMVIEN,AMERDFN,PCVISIT,1,1)
 . ;
 . ;Audit entry
 . M REC(AMERDFN)=^AMERADM(AMERDFN)
 . I $P(PCVISIT,"|",4)="D" S MSG="Associated PCC visit ("_AMVIEN_") was deleted - removed ER ADMISSION entry"
 . E  S MSG="Could not find PCC visit - removed ER ADMISSION entry"
 . D AUD("AMERVFIX","AMERADM",AMERDFN,"A10",1,MSG,AMERDFN_"|"_AMVIEN,.REC)
 . ;
 . ;Now remove entry
 . NEW DA,DIK
 . S DIK="^AMERADM(",DA=AMERDFN
 . D ^DIK
 ;
 ;If new visit found, update entry
 I AMVIEN'=$P(PCVISIT,"|") D  Q
 . NEW UPD,ERROR,REC,MSG
 . ;
 . ;Audit entry
 . M REC(AMERDFN)=^AMERADM(AMERDFN)
 . S MSG="Updated VIEN in ER ADMISSION entry from "_AMVIEN_" to "_$P(PCVISIT,"|")
 . I $P(PCVISIT,"|",4)="M" S MSG="PCC visit merge - "_MSG
 . D AUD("AMERVFIX","AMERADM",AMERDFN,"A11",0,MSG,AMERDFN_"|"_AMVIEN,.REC)
 . ;
 . S UPD(9009081,AMERDFN_",",1.1)=$P(PCVISIT,"|") ;Update visit
 . S UPD(9009081,AMERDFN_",",1)=$P(PCVISIT,"|",5) ;Update timestamp
 . D FILE^DIE("","UPD","ERROR")
 . ;
 . ;Update BEDD
 . D BADM(AMVIEN,AMERDFN,PCVISIT,1,0)
 ;
 Q
 ;
BADM(AMVIEN,AMERDFN,PCVISIT,PI,DEL) ;Check/Update BEDD if installed
 ;
 ;Update BEDD Object Entry
 I $T(ADM^BEDDVFIX)]"" D ADM^BEDDVFIX(AMVIEN,AMERDFN,PCVISIT,PI,DEL)
 Q
 ;
PCVST(AMERVSIT,PI) ;Process one ER VISIT entry
 ;
 NEW AMVDT,AMERDFN,PCVISIT,AMVIEN,DEL,PMRG
 ;
 S (PMRG,DEL)=""
 ;
 ;Get visit date
 S AMVDT=$$GET1^DIQ(9009080,AMERVSIT_",",.01,"I")
 ;
 ;Get visit DFN
 S AMERDFN=$$GET1^DIQ(9009080,AMERVSIT_",",.02,"I")
 ;
 ;Get VIEN
 S AMVIEN=$$GET1^DIQ(9009080,AMERVSIT_",",.03,"I")
 ;
 ;Check visit - return VISIT|Merged DFN|Merged Visit|Code|New visit date/time
 S PCVISIT=$$CKVISIT(AMVIEN,AMERDFN,AMVDT)
 S:$P(PCVISIT,"|",4)="D" DEL=1
 ;
 ;Look for DFN change and update ER VISIT and BEDD.EDVISIT
 I 'DEL,$P(PCVISIT,"|",2) S PMRG=$$VMGDFN(AMVIEN,AMERDFN,AMERVSIT,PCVISIT)
 S:PMRG="-1" $P(PCVISIT,"|",6)=1  ;Merge failed
 ;
 ;If match, check BEDD and quit
 I 'DEL,AMVIEN]"",$P(PCVISIT,"|")=AMVIEN D BVST(AMVIEN,AMERDFN,AMERVSIT,PCVISIT,1,0) Q
 ;
 ;If no visit remove if corrupt and also mark BEDD deleted
 I DEL!($P(PCVISIT,"|")="") D
 . I (AMVDT="")!(AMERDFN="")!(AMVIEN="") D
 .. NEW DIK,DA,REC,MSG
 .. ;
 .. ;Audit entry
 .. M REC(AMERVSIT)=^AMERVSIT(AMERVSIT)
 .. I $P(PCVISIT,"|",3)="D",AMVIEN S MSG="Associated PCC visit ("_AMVIEN_") was deleted - removed ER VISIT entry"
 .. E  I AMVIEN S MSG="Could not find PCC visit ("_AMVIEN_") - removed ER VISIT entry"
 .. E  S MSG="No PCC visit in ER VISIT entry - removed entry"
 .. D AUD("AMERVFIX","AMERVSIT",AMERVSIT,"A12",1,MSG,AMERDFN_"|"_AMVIEN,.REC)
 .. ;
 .. ;Remove entry
 .. S DIK="^AMERVSIT(",DA=AMERVSIT D ^DIK
 .. ;
 .. ;Update BEDD
 .. D BVST(AMVIEN,AMERDFN,AMERVSIT,PCVISIT,1,1)
 ;
 ;If new visit found, update entry
 I AMVIEN'=$P(PCVISIT,"|") D  Q
 . NEW UPD,ERROR,REC
 . ;
 . ;Audit entry
 . M REC(AMERVSIT)=^AMERVSIT(AMERVSIT)
 . D AUD("AMERVFIX","AMERVSIT",AMERVSIT,"A13",0,"Updated VIEN in ER VISIT entry from "_AMVIEN_" to "_$P(PCVISIT,"|"),AMERDFN_"|"_AMVIEN,.REC)
 . ;
 . ;Update entry
 . S UPD(9009080,AMERVSIT_",",.03)=$P(PCVISIT,"|") ;Update visit
 . S UPD(9009080,AMERVSIT_",",.01)=$P(PCVISIT,"|",5) ;Update timestamp
 . D FILE^DIE("","UPD","ERROR")
 . ;
 . ;Update BEDD
 . D BVST(AMVIEN,AMERDFN,AMERVSIT,PCVISIT,1,0)
 ;
 Q
 ;
BVST(AMVIEN,AMERDFN,AMERVSIT,PCVISIT,PI,DEL) ;Check/Update BEDD if installed
 ;
 ;(AMVIEN,AMERDFN,AMERVSIT,PCVISIT,1,0
 I $T(VST^BEDDVFIX)]"" D VST^BEDDVFIX(AMERDFN,AMVIEN,AMERVSIT,PCVISIT,PI,DEL)
 Q
 ;
CKVISIT(AMVIEN,AMERDFN,AMVDT) ;Check PCC for validity
 ;
 ;Returns
 ;VIEN|MERGED DFN|MERGED VIEN|CODE|VDT
 ;where CODE:
 ;D - Deleted visit
 ;M - Merged visit
 ;
 I $G(AMERDFN)="" Q ""
 ;
 NEW APMERGE,AVMERGE,AVMDT
 ;
 S (APMERGE,AVMERGE)=""
 ;
 ;If no visit, undefined PCC visit, or BEDD/PCC DFNs do not match try to locate one
 I (AMVIEN="")!('$D(^AUPNVSIT(+$G(AMVIEN),0)))!(AMERDFN'=$$GET1^DIQ(9000010,+AMVIEN_",",.05,"I")) D  Q:AMVIEN="" ""
 . S AMVIEN=$$FINDV(AMERDFN,AMVDT,AMVIEN)
 . S APMERGE=$P(AMVIEN,U,2)  ;Pull patient merged to
 . S AMVIEN=$P(AMVIEN,U)  ;Returned PCC visit
 ;
 ;Look for merged visit
 S AVMERGE=$$GET1^DIQ(9000010,AMVIEN_",",.37,"I")
 I AVMERGE]"" S AMVIEN=AVMERGE
 ;
 ;Look for deleted visit (not merged)
 I AVMERGE="",$$GET1^DIQ(9000010,AMVIEN_",",.11,"I") Q "|"_APMERGE_"||"_"D"
 ;
 ;Get merge to date
 S AVMDT="" S:AVMERGE]"" AVMDT=$$GET1^DIQ(9000010,AVMERGE_",",.01,"I")
 ;
 ;Return visit information
 Q (AMVIEN_"|"_APMERGE_"|"_AVMERGE_"|"_$S(AVMERGE]"":"M",1:"")_"|"_AVMDT)
 ;
FINDV(AMDFN,AMVDT,AVIEN) ;Find visit based on existing visit, DFN and visit date/time
 ;
 NEW MDFN,VDFN
 ;
 I '$G(AMDFN) Q ""
 S AVIEN=$G(AVIEN)
 ;
 ;Get Merged To DFN
 S MDFN=$$GET1^DIQ(2,AMDFN_",",".082","I")
 ;
 ;If visit passed in look for merged patient
 S VDFN="" S:AVIEN VDFN=$$GET1^DIQ(9000010,AVIEN_",",".05","I")
 I AVIEN,MDFN,MDFN=VDFN S AVIEN=AVIEN_U_MDFN Q AVIEN
 ;
 ;If visit and DFN doesn't match, return merged to patient
 I AVIEN,VDFN S AVIEN=AVIEN_U_VDFN Q AVIEN
 ;
 ;Remaining lookups require date
 I AVIEN="",$G(AMVDT)="" Q ""
 ;
 ;Look up by visit date/time - original DFN
 I AVIEN="" S AVIEN=$$VDT(AMVDT,AMDFN)
 ;
 ;Second look in scheduling - original DFN
 I AVIEN="" S AVIEN=$$SCH(AMVDT,AMDFN)
 ;
 ;Third look up by visit date/time - merged DFN
 I AVIEN="",MDFN S AVIEN=$$VDT(AMVDT,AMDFN) S:AVIEN]"" AVIEN=AVIEN_U_MDFN
 ;
 ;Fourth look in scheduling - merged DFN
 I AVIEN="",MDFN S AVIEN=$$SCH(AMVDT,AMDFN) S:AVIEN]"" AVIEN=AVIEN_U_MDFN
 ;
 Q AVIEN
 ;
VDT(AMVDT,AMDFN) ;Lookup in VISIT by visit date
 ;
 I $G(AMVDT)="" Q ""
 I $G(AMDFN)="" Q ""
 ;
 NEW VIEN,FVIEN
 ;
 S (FVIEN,VIEN)="" F  S VIEN=$O(^AUPNVSIT("B",AMVDT,VIEN)) Q:VIEN=""  D  Q:FVIEN
 . NEW VDFN
 . S VDFN=$$GET1^DIQ(9000010,VIEN_",",.05,"I") Q:VDFN=""
 . S:VDFN=AMDFN FVIEN=VIEN
 Q FVIEN
 ;
SCH(AMVDT,AMDFN) ;Looup in appointments by visit date
 ;
 I $G(AMVDT)="" Q ""
 I $G(AMDFN)="" Q ""
 ;
 NEW OPENC,FVIEN
 ;
 S FVIEN=""
 S OPENC=$P($G(^DPT(AMDFN,"S",AMVDT,0)),U,20)
 I OPENC]"" S FVIEN=$$GET1^DIQ(409.68,OPENC_",",.05,"I")
 ;
 Q FVIEN
 ;
AUD(RTN,FILE,ENTRY,ACT,DEL,MSG,INFO,REC) ;EP - Log fix/update activity
 ;
 S RTN=$G(RTN) I RTN="" Q "0^No routine"
 S FILE=$G(FILE) I FILE="" Q "0^No file"
 S ENTRY=$G(ENTRY) I ENTRY="" Q "0^No entry"
 S ACT=$G(ACT) I ACT="" Q "0^No action"
 S DEL=+$G(DEL)
 S MSG=$G(MSG) I MSG="" Q "0^No message"
 S INFO=$G(INFO) I INFO="" Q "0^No info"
 ;
 NEW COUNT,%
 ;
 ;Update counter
 S (COUNT,^XTMP("AMERUPD","COUNT"))=$G(^XTMP("AMERUPD","COUNT"))+1
 ;
 ;Create entry
 D NOW^%DTC
 S ^XTMP("AMERUPD",COUNT,0)=%_U_RTN_U_FILE_U_ENTRY_U_ACT_U_DEL_U_$P(INFO,"|")_U_$P(INFO,"|",2)
 S ^XTMP("AMERUPD",COUNT,1)=MSG
 M ^XTMP("AMERUPD",COUNT,"R")=REC
 S ^XTMP("AMERUPD","D",%,COUNT)=""
 ;
 Q 1
 ;
AMGDFN(AMERPCCO,AMERDFNO,PCVISIT) ;Patient Merge - Move ER ADMISSION entry, Update BEDD.EDVISIT
 ;
 NEW DIK,DA,PMRG,DIC,X,DLAYGO,DINUM,AMERDFNN,AMERPCCN
 ;
 S AMERPCCO=$G(AMERPCCO)
 S AMERDFNO=$G(AMERDFNO)
 S AMERPCCN=$P($G(PCVISIT),"|")
 ;
 S AMERDFNN=$P($G(PCVISIT),"|",2) I 'AMERDFNN D  Q "-1"
 . NEW REC,MSG
 . S MSG="Missing Patient Merge To Value"
 . D AUD("AMERVFIX","AMERADM",AMERDFNO,"A14",0,MSG,AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 ;First make sure merged to patient isn't already in ER
 I $D(^AMERADM(AMERDFNN,0)) D  Q "-1"
 . NEW REC,MSG
 . S MSG="Merged to patient "_AMERDFNN_" already in ED. Cannot merge from "_AMERDFNO
 . D AUD("AMERVFIX","AMERADM",AMERDFNO,"A15",0,MSG,AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 ;Make copy of current entry
 M PMRG=^AMERADM(AMERDFNO)
 ;
 ;Delete current entry and index
 S DIK="^AMERADM(",DA=AMERDFNO D IX2^DIK
 S DIK="^AMERADM(",DA=AMERDFNO D ^DIK
 ;
 ;Set up To entry
 S DIC="^AMERADM(",DIC(0)="L",X=AMERDFNN,DINUM=X
 S X=AMERDFNN,DIC="^AMERADM(",DIC(0)="Z",DLAYGO=9009081
 K DO,DD D FILE^DICN
 ;
 ;Merge information
 S $P(PMRG(0),U)=AMERDFNN  ;Update To in ER ADMISSION entry
 M ^AMERADM(AMERDFNN)=PMRG
 ;
 ;Re-index entry
 S DIK="^AMERADM(",DA=AMERDFNN D IX1^DIK
 ;
 ;Return failure
 I '$D(^AMERADM(AMERDFNN)) D  Q "-1"
 . NEW REC,MSG
 . S MSG="Patient merge - Unable to merge patient "_AMERDFNO_" to "_AMERDFNN
 . D AUD("AMERVFIX","AMERADM",AMERDFNO,"A16",0,MSG,AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 ;Update BEDD
 D BDFN(AMERDFNO,"",AMERPCCO,AMERPCCN,AMERDFNN,1,"A")
 ;
 I $D(^AMERADM(AMERDFNN)) D  Q 1
 . NEW REC,MSG
 . S MSG="Merged ER Admission entry "_AMERDFNO_" to "_AMERDFNN
 . D AUD("AMERVFIX","AMERADM",AMERDFNO,"A17",0,MSG,AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 Q "-1"
 ;
BDFN(AMERDFNO,AMERVSIT,AMERPCCO,AMERPCCN,AMERDFNN,PI,AV) ;Check/Update BEDD if installed
 ;
 ;Update BEDD Object Entry
 I $T(DFN^BEDDVFIX)]"" D DFN^BEDDVFIX(AMERDFNO,AMERVSIT,AMERPCCO,AMERPCCN,AMERDFNN,PI,AV)
 ;
 Q
 ;
VMGDFN(AMERPCCO,AMERDFNO,AMERVSIT,PCVISIT) ;Patient Merge - Move ER VISIT entry, Update BEDD.EDVISIT
 ;
 NEW DIK,DA,PMRG,DIC,X,DLAYGO,DINUM,AMERDFNN,AMERPCCN,EDDFN,RET
 ;
 S AMERPCCO=$G(AMERPCCO)
 S AMERDFNO=$G(AMERDFNO)
 S AMERVSIT=$G(AMERVSIT) I 'AMERVSIT D  Q "-1"
 . NEW REC,MSG
 . S MSG="Missing Patient Merge To ER VISIT pointer"
 . D AUD("AMERVFIX","AMERVSIT",AMERVSIT,"A18",0,MSG,AMERDFNO_"|"_AMERPCCO,.REC)
 S AMERPCCN=$P($G(PCVISIT),"|")
 S AMERDFNN=$P($G(PCVISIT),"|",2) I 'AMERDFNN D  Q "-1"
 . NEW REC,MSG
 . S MSG="Missing Patient Merge To Value"
 . D AUD("AMERVFIX","AMERVSIT",AMERVSIT,"A19",0,MSG,AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 ;First make sure ER VISIT entry is defined
 I '$D(^AMERVSIT(AMERVSIT,0)) D  Q "-1"
 . NEW REC,MSG
 . S MSG="ER VISIT entry '"_AMERVSIT_"' not found. Cannot merge patient from "_AMERDFNO_" to "_AMERDFNN
 . D AUD("AMERVFIX","AMERVSIT",AMERVSIT,"A20",0,MSG,AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 ;Get current DFN in entry
 S EDDFN=$$GET1^DIQ(9009080,AMERVSIT_",",".02","I")
 ;
 ;See if update is needed
 S RET=1
 I EDDFN'=AMERDFNN D  Q:RET="-1" RET
 . NEW AMERUPD,ERROR,REC,MSG
 . S AMERUPD(9009080,AMERVSIT_",",.02)=AMERDFNN
 . D FILE^DIE("","AMERUPD","ERROR")
 . I $D(ERROR) D  Q
 .. S MSG="Could not merge patient from "_AMERDFNO_" to "_AMERDFNN_" in ER VISIT entry '"_AMERVSIT_"'"
 .. D AUD("AMERVFIX","AMERVSIT",AMERVSIT,"A21",0,MSG,AMERDFNO_"|"_AMERPCCO,.REC)
 .. S RET="-1"
 . ;
 . ;Record change
 . S REC("DFN")=AMERDFNO
 . S MSG="Merged patient from "_AMERDFNO_" to "_AMERDFNN_" in ER VISIT entry '"_AMERVSIT_"'"
 . D AUD("AMERVFIX","AMERVSIT",AMERVSIT,"A22",0,MSG,AMERDFNO_"|"_AMERPCCO,.REC)
 ;
 ;Update BEDD
 D BDFN(AMERDFNO,"",AMERPCCO,AMERPCCN,AMERDFNN,1,"V")
 ;
 Q 1
