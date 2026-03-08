AMER3P13 ;GDIT/HS/BEE - AMER v3.0 Patch 13 ENV Check/PRE/POST ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**13**;MAR 03, 2009;Build 36
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D FIX(2)
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D FIX(2)
 ; 
 ;Check for AMER*3.0*12
 I '$$INSTALLD("AMER*3.0*12") D FIX(2)
 ;
 ;Check for BJPC*2.0*20
 I '$$INSTALLD("BJPC*2.0*20") D FIX(2)
 ;
 Q
 ;
PRE ;Pre-installation logic
 ;
 NEW II,DA,DIK
 ;
 ;Clear out ER INPUT MAP
 S II=0 F  S II=$O(^AMER(2.3,II)) Q:'II  S DA=II,DIK="^AMER(2.3," D ^DIK
 ;
 Q
 ;
POST ;Post-installation logic
 ;
 ;Job off task to convert existing AMER data to new fields and V EMERGENCY VISIT RECORD entries
 D BMES^XPDUTL("Kicking off background process to update V EMERGENCY VISIT RECORD entries from past ED visits")
 ;
 D TSKAMER
 ;
 Q
 ;
TSKAMER ;
 N %
 ;
 D NOW^%DTC
 S ZTIO=""
 S ZTRTN="AMERP^AMER3P13",ZTDESC="AMER - Patch 13 - Post Install - Convert ER VISIT data"
 S ZTDTH=$$FMADD^XLFDT($$NOW^XLFDT(),,,1)
 D ^%ZTLOAD
 ;
 Q
 ;
AMERP ;Task called from AMER p13 post install
 ;
 NEW AMERVSIT,ACNT,%
 ;
 ;Set up update temp global
 S ^XTMP("AMER_P13_INSTALL",0)=$$FMADD^XLFDT($P($$NOW^XLFDT,"."),60)_U_$P($$NOW^XLFDT,".")_U_"AMER P13 INSTALL CHANGES"
 S (^XTMP("AMER_P13_INSTALL","CNT"),ACNT)=$G(^XTMP("AMER_P13_INSTALL","CNT"))+1
 ;
 D NOW^%DTC
 S ^XTMP("AMER_P13_INSTALL",ACNT,"START")=%
 ;
 ;Fill in initial triage time/by, primary nurse and time and ED Provider time
 S AMERVSIT=0 F  S AMERVSIT=$O(^AMERVSIT(AMERVSIT)) Q:'AMERVSIT  D
 . ;
 . S ^XTMP("AMER_P13_INSTALL",ACNT,"CURRENT")="V"_AMERVSIT
 . NEW AMERDFN,VIEN,ITBY,ITDT,EDDT,EDP,PRMN
 . ;
 . ;Initial triage time/by and missing triage nurse or triage nurse time (LWOBS)
 . S ITBY=$$GET1^DIQ(9009080,AMERVSIT_",",17.12,"I")
 . S ITDT=$$GET1^DIQ(9009080,AMERVSIT_",",17.11,"I")
 . ;
 . ;Initial info will only be blank on first patch install
 . I ITBY="",ITDT="" D
 .. ;
 .. NEW AMERUP,AMERER
 .. ;
 .. ;Pull from triage nurse information
 .. S ITBY=$$GET1^DIQ(9009080,AMERVSIT_",",.07,"I")
 .. S ITDT=$$GET1^DIQ(9009080,AMERVSIT_",",12.2,"I")
 .. ;
 .. ;Handle LWOBS where not both triage nurse/triage nurse time may be entered
 .. I ITBY]"",ITDT="" S ITDT="NULL"
 .. I ITDT]"",ITBY="" S ITBY="NULL"
 .. ;
 .. I ITBY]"",ITDT]"" D
 ... S ^XTMP("AMER_P13_INSTALL",ACNT,"V",AMERVSIT,17.12)=U_ITBY
 ... S ^XTMP("AMER_P13_INSTALL",ACNT,"V",AMERVSIT,17.11)=U_ITDT
 ... S AMERUP(9009080,AMERVSIT_",",.07)=ITBY  ;Resave TN - could now be NULL
 ... S AMERUP(9009080,AMERVSIT_",",12.2)=ITDT  ;Resave TNT - could now be NULL
 ... S AMERUP(9009080,AMERVSIT_",",17.12)=$S(ITBY="":"@",1:ITBY)
 ... S AMERUP(9009080,AMERVSIT_",",17.11)=$S(ITDT="":"@",1:ITDT)
 .. D FILE^DIE("","AMERUP","AMERER")
 . ;
 . ;ED Provider time
 . S EDP=$$GET1^DIQ(9009080,AMERVSIT_",",.06,"I")
 . S EDDT=$$GET1^DIQ(9009080,AMERVSIT_",",17.7,"I")
 . ;
 . ;EDDT will be null on first patch install
 . I EDP]"",EDDT="" D
 .. ;
 .. NEW AMERUP,AMERER
 .. ;
 .. ;Pull from original MSET field
 .. S EDDT=$$GET1^DIQ(9009080,AMERVSIT_",",12.1,"I")
 .. ;
 .. ;For LWOBS MSET could be null, default to NULL
 .. S:EDDT="" EDDT="NULL"  ;Need something for V EVR
 .. ;
 .. I EDDT]"" D
 ... S ^XTMP("AMER_P13_INSTALL",ACNT,"V",AMERVSIT,17.7)=U_EDDT
 ... S AMERUP(9009080,AMERVSIT_",",17.7)=$S(EDDT="":"@",1:EDDT)
 ... D FILE^DIE("","AMERUP","AMERER")
 . ;
 . ;Get the visit
 . S VIEN=$$GET1^DIQ(9009080,AMERVSIT_",",.03,"I")
 . ;
 . ;Get the patient
 . S AMERDFN=$$GET1^DIQ(9009080,AMERVSIT_",",.02,"I")
 . ;
 . ;Primary Nurse - if not there (which will occur for first patch install) pull from BEDD
 . S PRMN=$$GET1^DIQ(9009080,AMERVSIT_",",17.8,"I") I PRMN="",$T(PRMN^BEDDUTW1)]"",VIEN D
 .. NEW VDT,PRM,PIEN,FIEN,PRMNDT
 .. ;
 .. ;See if BEDD has one
 .. S PRMN=$$PRMN^BEDDUTW1(VIEN) Q:PRMN=""
 .. ;
 .. ;Visit date and time
 .. S VDT=$$GET1^DIQ(9000010,VIEN_",",.01,"I")
 .. ;
 .. ;Try to get primary nurse time from ER VISIT
 .. S PRMNDT=$$GET1^DIQ(9009080,AMERVSIT_",",17.9,"I")
 .. ;
 .. ;If no time, put in NULL
 .. S:PRMNDT="" PRMNDT="NULL"
 .. ;
 .. ;If nurse and time save it
 .. I PRMN,PRMNDT]"" D
 ... ;
 ... NEW AMERUP,AMERER
 ... S AMERUP(9009080,AMERVSIT_",",17.8)=PRMN
 ... S AMERUP(9009080,AMERVSIT_",",17.9)=PRMNDT
 ... S ^XTMP("AMER_P13_INSTALL",ACNT,"V",AMERVSIT,17.8)=U_PRMN
 ... S ^XTMP("AMER_P13_INSTALL",ACNT,"V",AMERVSIT,17.9)=U_PRMNDT
 ... D FILE^DIE("","AMERUP","AMERER")
 .. ;
 .. ;Save to V PROVIDER
 .. Q:'VDT
 .. ;
 .. ;Make primary if no ED provider, DP or DN
 .. S PRM="P"
 .. I $$GET1^DIQ(9009080,AMERVSIT_",",.06,"I") S PRM="S"
 .. I $$GET1^DIQ(9009080,AMERVSIT_",",6.3,"I") S PRM="S"
 .. I $$GET1^DIQ(9009080,AMERVSIT_",",6.4,"I") S PRM="S"
 .. ;
 .. ;See if already there
 .. Q:'AMERDFN
 .. S (PIEN,FIEN)="" F  S PIEN=$O(^AUPNVPRV("AD",VIEN,PIEN)) Q:'PIEN  D  Q:FIEN
 ... NEW PROV
 ... S PROV=$$GET1^DIQ(9000010.06,PIEN_",",.01,"I") I PRMN'=PROV Q
 ... S FIEN=PIEN
 .. ;
 .. ;Add new/update
 .. D SAVE^AMERPRV(VIEN,AMERDFN,PRMN,PRM,+FIEN,VDT)
 . ;
 . ;Run sync to copy fields into V EMERGENCY VISIT RECORD
 . S AMERDFN=$$GET1^DIQ(9009080,AMERVSIT_",",.02,"I") Q:'AMERDFN
 . Q:'VIEN
 . D UVEVR^AMERVER(AMERDFN,VIEN)
 ;
 ;Loop through ER ADMISSION and update primary nurse, ED Provider Time
 I '$G(ZTQUEUED) W !!,"Updating new ED provider time field in ER ADMISSION",!
 S AMERDFN=0 F  S AMERDFN=$O(^AMERADM(AMERDFN)) Q:'AMERDFN  D
 . ;
 . S ^XTMP("AMER_P13_INSTALL",ACNT,"CURRENT")="A"_AMERDFN
 . ;
 . NEW EDP,EDPT,MSET,AMERUP,ERR,VIEN,PRMN,ITBY,ITDT,AMERUP,AMERER
 . ;
 . ;Triage by/time 
 . S ITBY=$$GET1^DIQ(9009081,AMERDFN_",",19,"I")
 . S ITDT=$$GET1^DIQ(9009081,AMERDFN_",",21,"I")
 . ;
 . ;Process if we have one or the other or both
 . I (ITBY]"")!(ITDT]"") D
 .. ;
 .. ;Handle where not both triage nurse/triage nurse time may be entered
 .. I ITBY]"",ITDT="" S ITDT="NULL"
 .. I ITDT]"",ITBY="" S ITBY="NULL"
 .. ;
 .. I ITBY]"",ITDT]"" D
 ... S ^XTMP("AMER_P13_INSTALL",ACNT,"A",AMERDFN,19)=U_ITBY
 ... S ^XTMP("AMER_P13_INSTALL",ACNT,"A",AMERDFN,21)=U_ITDT
 ... S AMERUP(9009081,AMERDFN_",",19)=ITBY  ;Resave TN - could now be NULL
 ... S AMERUP(9009081,AMERDFN_",",21)=ITDT  ;Resave TNT - could now be NULL
 . ;
 . ;Get the provider
 . S EDP=$$GET1^DIQ(9009081,AMERDFN_",",18,"I") I EDP]"" D
 .. ;
 .. ;Get the new ED Provider time (in case patch installed before)
 .. S EDPT=$$GET1^DIQ(9009081,AMERDFN_",",1.03,"I") Q:EDPT]""
 .. ;
 .. ;Get the MSET
 .. S MSET=$$GET1^DIQ(9009081,AMERDFN_",",22,"I")
 .. ;
 .. ;If no MSET, use NULL
 .. S:MSET="" MSET="NULL"
 .. ;
 .. ;Update ED Provider Time with MSET
 .. S AMERUP(9009081,AMERDFN_",",1.03)=MSET
 .. S ^XTMP("AMER_P13_INSTALL",ACNT,"A",AMERDFN,1.03)=U_MSET
 . ;
 . ;Get the visit
 . S VIEN=$$GET1^DIQ(9009081,AMERDFN_",",1.1,"I")
 . ;
 . ;Primary Nurse - if not there pull from BEDD
 . S PRMN=$$GET1^DIQ(9009081,AMERDFN_",",1.04,"I") I PRMN="",$T(PRMN^BEDDUTW1)]"",VIEN D
 .. NEW VDT,PRM,PIEN,FIEN,PRMNDT
 .. ;
 .. ;See if BEDD has one
 .. S PRMN=$$PRMN^BEDDUTW1(VIEN) Q:PRMN=""
 .. ;
 .. ;Visit date and time
 .. S VDT=$$GET1^DIQ(9000010,VIEN_",",.01,"I")
 .. ;
 .. ;Try to get primary nurse time from ER ADMISSION
 .. S PRMNDT=$$GET1^DIQ(9009081,AMERDFN_",",1.05,"I")
 .. ;
 .. ;If no time use NULL
 .. S:PRMNDT="" PRMNDT="NULL"
 .. ;
 .. ;If nurse and time save it
 .. I PRMN,PRMNDT]"" D
 ... ;
 ... S AMERUP(9009081,AMERDFN_",",1.04)=PRMN
 ... S AMERUP(9009081,AMERDFN_",",1.05)=PRMNDT
 ... S ^XTMP("AMER_P13_INSTALL",ACNT,"A",AMERDFN,1.04)=U_PRMN
 ... S ^XTMP("AMER_P13_INSTALL",ACNT,"A",AMERDFN,1.05)=U_PRMNDT
 .. ;
 .. ;Save to V PROVIDER
 .. Q:'VDT
 .. ;
 .. ;Make primary if no ED provider
 .. S PRM="P"
 .. I $$GET1^DIQ(9009081,AMERDFN_",",.06,"I") S PRM="S"
 .. ;
 .. ;See if already there
 .. Q:'AMERDFN
 .. S (PIEN,FIEN)="" F  S PIEN=$O(^AUPNVPRV("AD",VIEN,PIEN)) Q:'PIEN  D  Q:FIEN
 ... NEW PROV
 ... S PROV=$$GET1^DIQ(9000010.06,PIEN_",",.01,"I") I PRMN'=PROV Q
 ... S FIEN=PIEN
 .. ;
 .. ;Add new/update
 .. D SAVE^AMERPRV(VIEN,AMERDFN,PRMN,PRM,+FIEN,VDT)
 . ;
 . ;File if updates
 . I $O(AMERUP(""))]"" D FILE^DIE("","AMERUP","ERR")
 . ;
 . ;Run sync to copy fields into V EMERGENCY VISIT RECORD
 . Q:'VIEN
 . D UVEVR^AMERVER(AMERDFN,VIEN)
 ;
 ;Mark finished
 D NOW^%DTC
 S ^XTMP("AMER_P13_INSTALL",ACNT,"COMPLETE")=%
 ;
 Q
 ;
INSTALLD(AMERSTAL) ;EP - Determine if patch AMERSTAL was installed, where
 ; AMERSTAL is the name of the INSTALL.  E.g "AMER*3.0*12"
 ;
 NEW AMERY,INST
 ;
 S AMERY=$O(^XPD(9.7,"B",AMERSTAL,""))
 S INST=$S(AMERY>0:1,1:0)
 D IMES(AMERSTAL,INST)
 Q INST
 ;
IMES(AMERSTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_AMERSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed.",IOM))
 Q
 ;
FIX(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("This patch must be installed prior to the installation of AMER*3.0*12",IOM)
 Q
