ADSPKG ;GDIT/HS/KJH-ADS Package Version Report ; 17 Nov 2020  3:00 PM
 ;;1.0;DISTRIBUTION MANAGEMENT;**1,6**;Apr 23, 2020;Build 8
EN ;
 NEW %,%H,%I,%T,%ZIS,DA,DR,DIC,DIE,DIR,DIFROM,DLAYGO,DTOUT,DUOUT,IOP,POP,X,Y,NOW,NOWH,NOWFM
 NEW ADSUPD,ERROR,IEN,STRING,FACILITY,STARTDT,X1,X2,X
 K ^TMP("ADSPKG",$J)
 ;
 ; Retrieve last date exported
 S STARTDT=$$GET1^DIQ(9002290,"1,",.06,"I") ; Get START date from most recent report.
 I STARTDT]"" S X1=STARTDT,X2=-1 D C^%DTC S STARTDT=X ; Use DATE-1 so we catch any installs after the last report completed.
 D FACILITY,PKG
 I $D(ZTQUEUED) D EN1,FILE Q
 E  D
 . W !
 . K DIR
 . S DIR("A")="Display all packages",DIR("B")="YES",DIR(0)="Y"
 . S DIR("A",1)="NOTE: Answering NO at the display all packages prompt will show only"
 . S DIR("A",2)="      the package info that will be sent via the next nightly report."
 . S DIR("A",3)=" "
 . D ^DIR
 . I $D(DTOUT)!$D(DUOUT) Q  ; User entered an "^" to exit. Do not RUN the report.
 . I Y=1 S STARTDT="" ; Set STARTDT="" if user answered YES.
 . D DISPLAY
 . Q
 Q
DISPLAY ; Loop through the earlier compiled package data and display all info found.
 N CNT,AZNMSPC,LATEST,AZIEN,AZVER,PATCH
 K IOP,%ZIS,DTOUT,DUOUT
 W !! S %ZIS="PM" D ^%ZIS
 I POP Q
 U IO
 S CNT=0,AZNMSPC="",AZIEN="",AZVER="",PATCH=""
 F  S AZNMSPC=$O(^TMP("ADSPKG",$J,AZNMSPC)) Q:AZNMSPC=""  D  I $D(DTOUT)!$D(DUOUT) Q  ; User entered an "^" to exit.
 . S LATEST=$G(STARTDT)
 . F  S LATEST=$O(^TMP("ADSPKG",$J,AZNMSPC,LATEST)) Q:LATEST=""  D  I $D(DTOUT)!$D(DUOUT) Q  ; User entered an "^" to exit.
 .. F  S AZIEN=$O(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN)) Q:AZIEN=""  D  I $D(DTOUT)!$D(DUOUT) Q  ; User entered an "^" to exit.
 ... F  S AZVER=$O(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER)) Q:AZVER=""  D  I $D(DTOUT)!$D(DUOUT) Q  ; User entered an "^" to exit.
 .... F  S PATCH=$O(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH)) Q:PATCH=""  D DISPLAY1 I $D(DTOUT)!$D(DUOUT) Q  ; User entered an "^" to exit.
 .... Q
 ... Q
 .. Q
 . Q
 I $D(DTOUT)!$D(DUOUT) Q  ; User entered an "^" to exit.
 I CNT#(IOSL-4)'=0 D
 . D ^%ZISC
 . K DIR
 . S DIR(0)="E"
 . D ^DIR
 . Q
 Q
DISPLAY1 ;
 N STRING,FILL
 I CNT#(IOSL-4)=0 D
 . W @IOF
 . D EN^DDIOL("NSP  PACKAGE NAME                          VERSION   DATE        PATCH#")
 . D EN^DDIOL("---  ------------                          -------   ----        ------")
 . Q
 S STRING="",$P(FILL," ",40)=" "
 S STRING=STRING_$E($G(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH,"PNS"))_FILL,1,5)
 S STRING=STRING_$E($G(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH,"PN"))_FILL,1,38)
 S STRING=STRING_$E($G(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH,"VER"))_FILL,1,10)
 S STRING=STRING_$E($G(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH,"LPD"))_FILL,1,12)
 S STRING=STRING_$E($G(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH,"LP"))_FILL,1,15)
 D EN^DDIOL(STRING)
 S CNT=CNT+1
 I CNT#(IOSL-4)=0 D
 . D ^%ZISC
 . K DIR
 . S DIR(0)="E"
 . D ^DIR
 . I $D(DTOUT)!$D(DUOUT) Q  ; User entered an "^" to exit.
 . Q
 Q
FILE ; Update last date sent.
 N ADSUPD,ERROR
 S ADSUPD(9002290,"1,",.06)=DT ; Also update last export date in Configuration file.
 D FILE^DIE("","ADSUPD","ERROR")
 Q
EN1 ; Output text to BSTS contains the following data delimited by "|" symbols, in this order:
 ;  1 - FACILITY  - Facility (4 digit Facility or Site Number - for comparison with other tables)
 ;  2 - "PNS"     - Package Namespace
 ;  3 - "PN"      - Package Name
 ;  4 - "VER"     - Version
 ;  5 - "LP"      - Latest Patch
 ;  6 - "LPD"     - Latest Patch Date
 ;  7 - "SASUFAC" - Site ASUFAC
 ;  8 - "SDBID"   - Site DBID
 ;  9 - Site GUID
 ; 10 - Site Domain Name
 ;
 N AZNMSPC,LATEST,AZIEN,AZVER,PATCH,SINFO,SASUFAC,SDBID
 N ADSDT,CNT S ADSDT=$$NOW^XLFDT,CNT=0   ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINE
 ;
 ;Get the site ASUFAC and DBID
 S SINFO=$$SITE()
 S SASUFAC=$P(SINFO,U)  ;Site ASUFAC
 S SDBID=$P(SINFO,U,2)  ;Site DBID
 ;
 ; Loop through the earlier compiled package data and send all info found.
 S AZNMSPC="",AZIEN="",AZVER="",PATCH=""
 F  S AZNMSPC=$O(^TMP("ADSPKG",$J,AZNMSPC)) Q:AZNMSPC=""  D
 . S LATEST=$G(STARTDT)
 . F  S LATEST=$O(^TMP("ADSPKG",$J,AZNMSPC,LATEST)) Q:LATEST=""  D
 .. F  S AZIEN=$O(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN)) Q:AZIEN=""  D
 ... F  S AZVER=$O(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER)) Q:AZVER=""  D
 .... F  S PATCH=$O(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH)) Q:PATCH=""  D EN11
 .... Q
 ... Q
 .. Q
 . Q
 ;IHS/GDIT/AEF ADS*1.0*6 FID107834; New lines below
 ;Update ADS EXPORT LOG file:
 D UPDTLOG^ADSUTL(ADSDT,"PKG",CNT)
 Q
EN11 ;
 I $T(LOG^BSTSAPIL)="" Q  ; Check for existence of the send routine and quit if not found. (BSTS not installed.)
 N STRING
 S STRING=""
 S STRING=STRING_FACILITY_"|"
 S STRING=STRING_$G(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH,"PNS"))_"|"
 S STRING=STRING_$G(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH,"PN"))_"|"
 S STRING=STRING_$G(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH,"VER"))_"|"
 S STRING=STRING_$G(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH,"LP"))_"|"
 S STRING=STRING_$G(^TMP("ADSPKG",$J,AZNMSPC,LATEST,AZIEN,AZVER,PATCH,"LPD"))_"|"
 S STRING=STRING_SASUFAC_"|"
 S STRING=STRING_SDBID_"|" ;IHS/GDIT/AEF ADS*1.0*6 FID110314 Added "|"
 S STRING=STRING_$P($$SITE^ADSUTL,U,4)_"|" ;GUID ;IHS/GDIT/AEF ADS*1.0*6 FID110314
 S STRING=STRING_$P($$SITE^ADSUTL,U,5) ;DOMAIN NAME ;IHS/GDIT/AEF ADS*1.0*6 FID110314
 S STRING=$TR(STRING,"'")
 ; NOTE: The number "42" in the next line is an assigned value in the BSTS logs for the ADS utility.
 D LOG^BSTSAPIL("PKG",42,"VER",$$TFRMT^ADSRPT(STRING))
 S CNT=CNT+1   ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINE
 Q
FACILITY ; Get the default facility (site #)
 S FACILITY=$P($$SITE^VASITE(),U,3)
 I FACILITY="" S FACILITY="*Unknown*"
 Q
PKG ; Loop through the PACKAGE file and compile info after the START date.
 N AZFM,AZIEN,AZPKGNM,AZNMSPC,AZVER,AZLP
 S AZFM="",AZIEN=""
 F  S AZFM=$O(^DIC(9.4,"B",AZFM)) Q:AZFM=""  F  S AZIEN=$O(^DIC(9.4,"B",AZFM,AZIEN)) Q:AZIEN=""  D PKGINFO
 D BMW,EHR,BPRM ; Additional packages that are not in the standard package file.
 Q
PKGINFO ; Get information from the PACKAGE file.
 N Y
 S Y=^DIC(9.4,AZIEN,0)
 S AZPKGNM=$P(Y,U,1) I AZPKGNM="" Q
 S AZNMSPC=$P(Y,U,2) I AZNMSPC="" Q
 ; Following namespace is a "special case". We need to have the "current version" (7.2) plus the previous one (7.1) at this time.
 I AZNMSPC="AG" D  Q
 . S AZVER="7.2" D PKGINFO1
 . S AZVER="7.1" D PKGINFO1
 . Q
 S AZVER=$P($G(^DIC(9.4,AZIEN,"VERSION")),U) I AZVER="" Q
 D PKGINFO1
 Q
PKGINFO1 ;
 N VERIEN,LATEST,PATCH,SUBIEN,Y
 S VERIEN=$O(^DIC(9.4,AZIEN,22,"B",AZVER,""))
 I 'VERIEN Q  ; Current version not found. Do not send this record.
 S Y=^DIC(9.4,AZIEN,22,VERIEN,0),LATEST=+$P(Y,U,3),PATCH=0 ; Initial Package install date.
 D PKGINFO2
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,AZIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . S Y=$G(^DIC(9.4,AZIEN,22,VERIEN,"PAH",SUBIEN,0)),LATEST=+$P(Y,U,2),PATCH=$P(Y,U,1)
 . D PKGINFO2
 Q
PKGINFO2 ;
 N LDT
 S LDT=$P(LATEST,".",1)
 S PATCH=+$$FMT($P(PATCH," ",1))
 S ^TMP("ADSPKG",$J,AZNMSPC,LDT,AZIEN,AZVER,PATCH,"PNS")=AZNMSPC
 S ^TMP("ADSPKG",$J,AZNMSPC,LDT,AZIEN,AZVER,PATCH,"PN")=AZPKGNM
 S ^TMP("ADSPKG",$J,AZNMSPC,LDT,AZIEN,AZVER,PATCH,"VER")=AZVER
 S ^TMP("ADSPKG",$J,AZNMSPC,LDT,AZIEN,AZVER,PATCH,"LP")=$S(PATCH=0:"",1:PATCH)
 S ^TMP("ADSPKG",$J,AZNMSPC,LDT,AZIEN,AZVER,PATCH,"LPD")=$S(LATEST=0:"",1:$$FMTE^XLFDT(LATEST,"5ZD"))
 Q
BMW ;
 ;BEGIN MODIFICATIONS - IHS/GDIT/AEF ADS*1.0*6 FID91294
 N X,Y,%DT
 N AZIEN,AZNMSPC,AZPKGNM,AZVER,LATEST,PATCH   ;3241031
 ;
 I $G(^BMW("GenDate"))="" Q
 I $G(^BMW("Version"))="" Q
 ;
 S AZIEN=1
 S AZNMSPC="BMW"
 ;S AZPKGNM="BMW (fm2class version "_^BMW("fm2class","Version")_")"
 S AZPKGNM="RPMS/Ensemble Cache Classes Database File"   ;3241030
 ;S AZVER=$P(^BMW("Version"),".",1)
 ;S PATCH=$P(^BMW("Version"),".",2)
 S AZVER=^BMW("Version")   ;3241030
 S PATCH=""   ;3241030
 ;S X=$P(^BMW("GenDate")," ",1),%DT="SN" D ^%DT
 ;S LATEST=Y
 ;
 ;Update BMW in ADS PARAMETERS file if new version:  3241031
 I ^BMW("Version")'=$$GET1^DIQ(9002292,"1,",13.1,"E") D
 . N ERR,FDA,IEN
 . S FDA(9002292,"1,",13.1)=^BMW("Version")
 . S FDA(9002292,"1,",13.2)=DT
 . S FDA(9002292,"1,",13.3)=$$GET1^DIQ(9002292,"1,",13.1,"I")
 . S FDA(9002292,"1,",13.4)=$$GET1^DIQ(9002292,"1,",13.2,"I")
 . D UPDATE^DIE("","FDA","IEN","ERR")
 ;
 S LATEST=$$GET1^DIQ(9002292,1,13.2,"I")  ;3241031
 D PKGINFO2
 ;
 ;END MODIFICATIONS - IHS/GDIT/AEF ADS*1.0*6 FID91294
 ;
 Q
BPRM ;
 ;
 ;Only send if BPRM is not yet found - to handle possible future addition of BPRM to the Package file
 I $D(^TMP("ADSPKG",$J,"BPRM")) Q
 ;
 S AZIEN=1   ;3241031
 ;
 NEW EXEC,BPEXIST
 S EXEC="SET BPEXIST=##class(%Dictionary.CompiledClass).%ExistsId(""BMW.BSF.SP.AgSetPatientGenderIdentity"")"
 X EXEC
 I BPEXIST=1 D
 . S AZNMSPC="BPRM"
 . S AZPKGNM="PRACTICE MANAGEMENT APPLICATION SUITE"
 . S AZVER="INSTALLED"
 . S PATCH=""
 . S LATEST=0
 . D PKGINFO2
 Q
EHR ;
 N X,ADSA,AZIEN
 S ADSA="EHR",AZNMSPC="EHR",AZPKGNM="RPMS EHR"
 F  S ADSA=$O(^XPD(9.7,"B",ADSA)) Q:ADSA'["EHR"  S AZIEN=$O(^XPD(9.7,"B",ADSA,""),-1) D
 . S X=^XPD(9.7,AZIEN,0),LATEST=$P(X,U,3),X=$P(X,U,1)
 . I X'["*" Q
 . S AZVER=$P(X,"*",2),PATCH=$P(X,"*",3)
 . D PKGINFO2
 . Q
 Q
FMT(X) ; Format patch# to only use the "numeric" portion.
 S X=$G(X)
 NEW RET,I,C
 S RET=""
 F I=1:1:$L(X) S C=$E(X,I) I (C?1N)!(C=".") S RET=RET_C
 Q RET
SITE() ;Get the site ASUFAC and DBID
 ;
 NEW RSIEN,RSLOC,ASUFAC,DBID
 ;
 ;Get the location from RPMS SITE
 S RSIEN=$O(^AUTTSITE(0)) I RSIEN="" Q ""
 S RSLOC=$$GET1^DIQ(9999999.39,RSIEN_",",.01,"I") I RSLOC="" Q ""
 ;
 ;Get the site ASUFAC and DBID
 S ASUFAC=$$GET1^DIQ(9999999.06,RSLOC_",",.12,"E")
 S DBID=$$GET1^DIQ(9999999.06,RSLOC_",",.32,"E")
 ;
 ;Return the values
 Q ASUFAC_U_DBID
