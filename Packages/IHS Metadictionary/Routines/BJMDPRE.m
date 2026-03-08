BJMDPRE ;VNGT/HS/ALA-Pre Install ; 09 Jul 2012  11:55 AM
 ;;1.0;CDA/C32;**1,3**;May 27, 2011
 ;
EN ;
 N BVER,PKG,IVER,PKGIEN
 ; Update the package's version number if necessary (e.g. if this is a new installation)
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
 Q
