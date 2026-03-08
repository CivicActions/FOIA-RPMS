BIPOST ;IHS/CMI/MWR - POST-INIT ROUTINE; ; 07 May 2025  1:35 PM [ 06/12/2025  12:05 PM ]
 ;;8.5;IMMUNIZATION;**27,28,29,30,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PATCH 3: Set MenCY-Hib (148) and Flu-nasal4 (149) and all Skin Tests
 ;;           in the Vaccine Table to Inactive.   START+30
 ;;  PATCH 3: Set all Skin Tests in the Skin Test table to Inactive, except
 ;;           PPD and Tetanus. START+38
 ;;  PATCH 4, v8.5: Update Source options in Imm Lot File.  START+9
 ;;  PATCH 5, v8.5: Remove dash from Eligibility Codes.
 ;;  PATCH 5, v8.5: Add SNOMED Codes to all Contraindications.
 ;;  PATCH 5, v8.5: Restandardize Vaccine Table, with updates from BITN.
 ;;  PATCH 6, v8.5: Restandardize Vaccine Table, with updates from BITN.
 ;;  PATCH 8: Changes to Set Mening C CVX 103 vaccine to Inactive.  START+55
 ;;  PATCH 9:  Restandardize Vaccine Table, with updates from BITN. START+49
 ;;            Changes to force specified vaccines active.  START+52
 ;;            Update Taxonomies.  START+142
 ;;  PATCH 10: Restandardize Vaccine Table, with updates from BITN. START+49
 ;;            Changes to force specified vaccines active.  START+56
 ;;            Update BI TABLE DATA ELEMENTS File.  START+154
 ;;  PATCH 12: Restandardize Vaccine Table, with updates from BITN.
 ;;  PATCH 13: Restandardize Vaccine Table, with updates from BITN (and BIMAN below).
 ;;  PATCH 14: Make old Rabies CVX 18 inactive.
 ;;            Set High Risk parameter selection = zero/none.
 ;;  PATCH 15: Restandardize Vaccine Table, make CVX 186 Active.  START+54
 ;;  PATCH 16: Add new vaccines & manufacturers, restandardize Vaccine Table, START
 ;;  PATCH 17: Set Short Name for MENING Vaccine Group to "MENACWY". START+46
 ;;            Add Men-B Vaccine Group.  START+49
 ;;  PATCH 18: ICE changes.
 ;;  PATCH 19: Upload new NDC entries from CDC.
 ;;  PATCH 21: Vaccine Table updates, DTS installation.
 ;;  PATCH 22: COMMENT OUT PREVIOUS TASKS.
 ;;  PATCH 23: Update display comments, remove vaccine table update text
 ;;  PATCH 24: Update display comments
 ;;  PATCH 25: Rebuild BIEXPDD, change BI MAILING ADD-STREET-2 to BI MAILING ADD-STREET 2 in ^BILET and ^BILETS
 ;;  PATCH 26: Remove external dates in V IMMUNIZATION
 ;;  PATCH 27: Remove history section from due letters
 ;;  PATCH 28: ADD SDV FILE 9002084.98
 ;;  PATCH 29: 
 ;
 ;
 ;----------
START ;EP
 ;---> Update software after KIDS installation.
 ;
 D SETVARS^BIUTL5 S BIPOP=0
 D VIMM
 D V85P27
 D EXIT
 Q
 ;=====
 Q
V85P27 ;VERSION 8.5 PATCH 27  
 ;NO POST INSTALL FOR P27
 Q
 ;=====
OLDBLDS ;OLD BUILD CODE
 ;
 ;---> Update "Last Version Fully Installed" Field in BI SITE PARAMETER File.
 N N S N=0 F  S N=$O(^BISITE(N)) Q:'N  D
 .S $P(^BISITE(N,0),"^",15)=$$VER^BILOGO
 Q
 ;
 ;----------
EXIT ;EP
 D TEXT1
 W " v"_$P($T(+2),";",3)_" p"_$P($P($T(+2),";",5),"**",2)_"."
 D TEXT2,DIRZ^BIUTL3()
 D KILLALL^BIUTL8(1)
 Q
 ;
 ;
 ;----------
 ;put the following back into TEXT1 if needed
 ;- This concludes the BI Vaccine Table Update program. -
TEXT1 ;EP
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;        
 ;;
 ;;                       * CONGRATULATIONS! *
 ;;
 ;;          You have successfully installed Immunization
 W @IOF
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;                            * NOTE!!! *
 ;;
 ;;       NOTE: Be sure to install the ICE Forecaster per the
 ;;       ICE Installation Instructions distributed with this patch.
 ;;
 ;;                            * NOTE!!! *
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 ;;
 W @IOF
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 ;---> Print text at specified line label.
 ;
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
IMMPATH ;EP
 ;---> Update path for new Immserve files.
 N N,X,Y S Y=$$VERSION^%ZOSV(1) D
 .I Y["Windows" S X="C:\Program Files\Immserve852\" Q
 .I Y["UNIX" S X="/usr/local/immserve852/"
 ;
 S N=0
 F  S N=$O(^BISITE(N)) Q:'N  D
 .S $P(^BISITE(N,0),"^",18)=X
 Q
 ;
 ;
 ;----------
REINDEX ;EP
 ;---> Not called.  Programmer to use if KIDS fails to index these files.
 ;
 N DIK
 ;S DIK="^BISERT(" D IXALL^DIK
 F DIK="^BINFO(","^BILETS(","^BIVT100(","^BIERR(","^BINFO(","^BIEXPDD(","^BISERT(","^BICONT(" D
 .D IXALL^DIK
 Q
 ;
 ;
KEYS ;EP
 ;---> Clean up subordinate keys (there should be none).
 N X,Y
 F X="BIZ EDIT PATIENTS","BIZ MANAGER","BIZMENU" D
 .S Y=$O(^DIC(19.1,"B",X,0)) K @("^DIC(19.1,"""_Y_""",3)")
 Q
 ;
 ;
REINDLS ;EP
 ;---> Reindex BI LETTER SAMPLE File.
 N X,Y
 S DIK="^BILETS("
 D IXALL^DIK
 S DIK="^BIMAN("
 D IXALL^DIK
 Q
 ;
 ;
 ;********** PATCH 21, v8.5, APR 01,2021, IHS/CMI/MWR
DTSPOST ;EP - Post Installation Code
 ;---> Per Brian Everett, DTS, for p21 DTS Install.
 ;
 ;Compile class process
 ;
 N TRIEN,EXEC,ERR,CURR,TYP,FREQ,OPTION,OPTN,SDATM,ERROR
 ;
 ;For each build, set this to the 9002084.71 file entry to load
 S TRIEN=1
 ;
 ;Import BI class
 K ERR
 I $G(TRIEN)'="" D IMPORT^BICLASS(TRIEN,.ERR)
 I $G(ERR) Q
 ;
 ;Run the task to update the local content
 D TASK^BIAPIDTS
 ;
 ;Schedule the task to run on a daily basis
 S OPTION="BI DTS UPDATE",FREQ="1D" ; BI DTS UPDATE TASK
 S OPTN=$$DTSFIND(OPTION) Q:OPTN'>0
 I OPTN>0 D
 . I $O(^DIC(19.2,"B",OPTN,""))'="" Q  ; If already scheduled, do not schedule again.
 . S SDATM=$$FMADD^XLFDT(DT,1)_".23" ; Schedule the task for 2300 hours (11PM).
 . D RESCH^XUTMOPT(OPTION,SDATM,"",FREQ,"L",.ERROR)
 Q
 ;
 ;
 ;********** PATCH 21, v8.5, APR 01,2021, IHS/CMI/MWR
DTSFIND(X) ;EP Find an Option
 ;---> Per Brian Everett, DTS, for p21 DTS Install.
 ;---> Find an option.
 S X=$O(^DIC(19,"B",X,0)) I X'>0 Q -1
 Q X
 ;**********
VIMM ;-- 88884 remove external dates from V IMM 1201
 N VDA,VDAT
 S VDA=0 F  S VDA=$O(^AUPNVIMM(VDA)) Q:'VDA  D
 . S VDAT=$P($G(^AUPNVIMM(VDA,12)),U)
 . I VDAT["/" S $P(^AUPNVIMM(VDA,12),U)=""
 Q
 ;
V85P28 ;EP; VERSION 8.5 PATCH 28   
 S X=$$ADD^XPDMENU("BI MENU-MANAGER","BI TABLE SPLIT DOSE VACCINE","SDV",40)
 Q
 ;=====
 ;
V85P29 ;EP; VERSION 8.5 PATCH 29
V85P31 ;EP; VERSION 8.5 PATCH 31
 S X19="INCLUDE RISK FACTORS^NJ4,0^^0;19^K:(X>99999999999)!(X<0)!(X?.E1"".""1N.N.U) X"
 S GBL=U_"DD("_"9002084.02,.19,0)"
 S @GBL=X19
 L +^BIVARR:10 E  Q -1
 S X=""
 F  S X=$O(^BIVARR(X)) Q:X=""  K ^BIVARR(X)
 D VARR^BIUTL3
 L -^BIVARR
 Q
 ;=====
 ;
V85P30 ;EP; VERSION 8.5 PATCH 30
 N X,Y,Z,DA,DIE,DIC
 S (DA,DA(1))=$O(^DIC(19,"B","BI MENU-MANAGER",0))
 Q:'DA
 S X=+$O(^DIC(19,"B","BI PT WITH 70",0))
 Q:$D(^DIC(19,DA,10,"B",X))
 S DIC="^DIC(19,"_DA_",10,"
 S DIC(0)="L"
 S DIC("DR")="2////GR70"
 D FILE^DICN
 Q
 ;=====
 ;
