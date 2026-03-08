BIENVCHK ;IHS/CMI/MWR - ENVIRONMENTAL CHECK FOR KIDS; ; 10 Jun 2025  12:10 AM
 ;;8.5;IMMUNIZATION;**27,28,29,30,31**;OCT 24,2011;Build 137
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  ENVIRONMENTAL CHECK ROUTINE FOR KIDS INSTALLATION.
 ;;  PATCH 26: Check environment for Imm v8.5 Patch 26.
 ;
 ;
 ;----------
START ;EP
 ;
 F X="XP01","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 N X,Z
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 S X="Checking Environment for the installation of "_$P($T(+2),";",4)_" v"_$P($T(+2),";",3)
 S Z=$P($P($T(+2),";",5),"**",2)
 S:Z X=X_", Patch "_Z_"."
 W !!,$$CJ^XLFSTR(X,IOM),!
 ;
 N BIQUIT S BIQUIT=0,XPDQUIT=0
 ;
 ;---> REQUIREMENTS
 ;
 ;---> Kernel v8.0 patch 1018 (XU*8.0*1018) or later.
 D CHECK("KERNEL","XU","8.0",1018,.BIQUIT)
 ;
 ;---> VA FileMan v22.0 patch 1018 (DI*22.0*1018) or later.
 D CHECK("VA FILEMAN","DI","22.0",1018,.BIQUIT)
 ;;
 ;********** PATCH 21, v8.5, APR 01,2021, IHS/CMI/MWR
 ;---> Per Brian Everett, DTS:
 ;---> IHS STANDARD TERMINOLOGY (BSTS) v2.0 patch 1.
 ;D CHECK("IHS STANDARD TERMINOLOGY","BSTS","2.0",1,.BIQUIT)
 ;
 ;********** PATCH 27, v8.5, AUG 01,2022, ihs/cmi/maw
 ;---> Immunization v8.5 patch 24 (BI*8.5*24) or later.
 ;D CHECK("IMMUNIZATION","BI","8.5",27,.BIQUIT)
 ;
 ;********** PATCH 28, v8.5, AUG 01,2022, ihs/cmi/maw
 ;---> Immunization v8.5 patch 24 (BI*8.5*24) or later.
 D CHECK("IMMUNIZATION","BI","8.5",30,.BIQUIT)
 ;
 ;
 ;I '$$VCHK("AUT","98.1",2) S BIQUIT=2
 ;S X=$$LAST("IHS DICTIONARIES (POINTERS)","98.1")
 ;
 ;---> XB/ZIB v3.0 patch 11.
 ;I '$$VCHK("XB","3.0",2) S BIQUIT=2
 ;S X=$$LAST("IHS/VA UTILITIES","3.0")
 ;
 ;---> IHS PCC REPORTS v3.0 patch 29.
 ;I '$$VCHK("APCL","3.0",2) S BIQUIT=2
 ;S X=$$LAST("IHS PCC REPORTS","3.0")
 ;
 ;---> PCC Suite v2.0 patch 2.
 ;I '$$VCHK("BJPC","2.0",2) S BIQUIT=2
 ;S X=$$LAST("IHS PCC SUITE","2.0")
 ;
 ;---> IHS Clinical Reporting System v9.0 patch 1.
 ;I '$$VCHK("BGP","9.0",2) S BIQUIT=2
 ;S X=$$LAST("IHS CLINICAL REPORTING","9.0")
 ;
 ;---> Check environment for previous load of Taxonomy v5.1.
 ;I '$$VCHK("ATX","5.1",2) S BIQUIT=2
 ;.S X=$$LAST("TAXONOMY","5.1")
 ;
 ;
 ;---> Check for multiple BI entries in the Package File.
 N DA,DIC
 S X="BI",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0,$D(^DIC(9.4,"C","BI")) D  S BIQUIT=2
 .W !!,$$CJ^XLFSTR("You Have More Than One Entry In The",IOM)
 .W !,$$CJ^XLFSTR("PACKAGE File with a ""BI"" prefix.",IOM)
 .W !,$$CJ^XLFSTR("One entry needs to be deleted.",IOM)
 .W !,$$CJ^XLFSTR("Please do this before Proceeding.",IOM),!!
 .Q
 ;
 ;---> Do not allow KIDS installation to be queued (at DEVICE: prompt).
 S XPDNOQUE=1
 ;---> Do not ask "DISABLE Options...etc.?" question.
 S XPDDIQ("XPZ1")=0
 ;---> Do not ask "MOVE routines to other CPUs?" question.
 S XPDDIQ("XPZ2")=0
 ;
 I BIQUIT D SORRY(BIQUIT) Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 ;I '$$DIR^XBDIR("E","","","","","",1) D SORRY(2) Q
 Q
 ;
 ;
 ;----------
CHECK(BIPKG,BIPRE,BIVER,BIPAT,BIQUIT) ;EP Check the version and patch level of this package.
 ;---> Parameters:
 ;     1 - BIPKG  (req)  Package in the PACKAGE File.
 ;     2 - BIPRE  (req)  Package Prefix in the PACKAGE File.
 ;     3 - BIVER  (req)  Package Version in the PACKAGE File.
 ;     4 - BIPAT  (req)  Package Last Patch in the PACKAGE File.
 ;     5 - BIQUIT (ret)  Package Last Patch in the PACKAGE File.
 ;
 I ($G(BIPKG)="")!($G(BIPRE)="")!($G(BIVER)="")!($G(BIPAT)="") D  Q
 .W !!,"Package parameters missing, check routine BIENVCHK!"
 .W $$DIR^XBDIR("E","Press RETURN")
 .S BIQUIT=2
 ;
 N BIQUIT1 S BIQUIT1=0
 ;
 ;---> Check Package version.
 I '$$VCHK(BIPRE,BIVER,2) S BIQUIT1=2
 ;
 ;---> Check Package patch level.
 ;
 ;*********************
 ;---> Just for patch 20.
 ;I $$VER^BILOGO'="8.5*20" S BIPAT=1
 ;
 ;*********************
 D
 .S X=$$LAST(BIPKG,BIVER)
 .;
 .;---> Special check for BI, since mix of patches (20+ and 1000+).
 .I BIPKG="IMMUNIZATION",($P($$VER^BILOGO,"*",2)<BIPAT) D  S BIQUIT1=2  Q
 ..W !,$$CJ^XLFSTR(BIPKG_" v"_BIVER_" patch "_BIPAT_" is NOT INSTALLED!",IOM),!
 .;
 .;---> All other packages.
 .I ($P(X,U)'=BIPAT)&($P(X,U)'>BIPAT) D  S BIQUIT1=2  Q
 ..W !,$$CJ^XLFSTR(BIPKG_" v"_BIVER_" patch "_BIPAT_" is NOT INSTALLED!",IOM),!
 .;
 .W !,$$CJ^XLFSTR(BIPKG_" v"_BIVER_" patch "_BIPAT_"... Patch "_BIPAT_" is present.",IOM),!
 ;
 I BIQUIT1 S BIQUIT=BIQUIT1
 Q
 ;
 ;
SORRY(X) ;
 K DIFQ S XPDQUIT=X
 D:'$D(ZTQUEUED)
 .W !!,$$CJ^XLFSTR("Sorry, the installation has been discontinued.",IOM)
 .W !,$$CJ^XLFSTR("No changes have been made.",IOM),!
 .W $$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(ABMPRE,ABMVER,ABMQUIT) ; Check versions needed.
 ;
 NEW ABMV
 S ABMV=$$VERSION^XPDUTL(ABMPRE)
 I ABMV="" S ABMV=0
 W !,$$CJ^XLFSTR("Need at least "_ABMPRE_" v"_ABMVER_"... "_ABMPRE_" v"_ABMV_" is present",IOM)
 I ABMV<ABMVER W !,$$CJ^XLFSTR("*** NEEDS TO BE INSTALLED ***",IOM) Q 0
 Q 1
 ;
LAST(PKG,VER) ;EP - returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"B",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
