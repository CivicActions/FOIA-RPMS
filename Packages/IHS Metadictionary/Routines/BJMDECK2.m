BJMDECK2 ;VNGT/HS/AM-Pre- and Post-Install Routine; 5 Aug 2011
 ;;1.0;CDA/C32;**1,2**;May 27, 2011
 ;
PRE ;
 N BVER,PKG,IVER,PKGIEN,EXEC
 ; Grab the build's package version
 S BVER=$$VER^XPDUTL(XPDNM),PKG=$$PKG^XPDUTL(XPDNM)
 ; See what the installed version is
 S IVER=$$VERSION^XPDUTL(PKG)
 ; If the installed version is blank, then set the package's CURRENT VERSION
 ; to the build's version
 I IVER="" D  Q:$D(XPDABORT)
 . S PKGIEN=$O(^DIC(9.4,"C",PKG,0)) S:PKGIEN'>0 PKGIEN=$O(^DIC(9.4,"B",PKG,0))
 . I 'PKGIEN S XPDABORT=1 D BMES^XPDUTL("Unable to update package version.  Contact OIT for support") Q
 . D PKGVER^XPDIP(PKGIEN,BVER)
 ;
 ; Run the pre-install task in the Ensemble namespace
 S EXEC="S SC=##class(BJMD.Install.PreInstallTask).RunTask()" X EXEC
 Q
 ;
POST ;
 N ERR,TRNM,TRIEN,EXEC
 ; Import the classes
 S TRNM=@XPDGREF@("SENT REC"),TRIEN=$O(^BJMDCLS("B",TRNM,""))
 I $G(TRIEN)'="" D IMPORT^BJMDCLAS(TRIEN,.ERR)
 ;
 ; Run the post-install task in the Ensemble namespace
 S EXEC="S SC=##class(BJMD.Install.PostPatchTask).RunTask()" X EXEC
 Q
 ;
