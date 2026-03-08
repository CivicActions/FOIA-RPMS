RA410PRE ; IHS/HQW/SCR - Enviroment Check  ; [ 01/23/2002  7:48 AM ]
 ;;4.0;RADIOLOGY;**10,12**;NOV. 20, 1997
 ;
 ;This routine checks versions before installation of patch 10
 ;Patch 10 is a conversion patch and needs to be loaded prior to any
 ;future patches. 
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY Q
 ;
 I $G(DUZ(0))'="@" W !,"You must be in programmer mode to perform this install." D SORRY Q
 D HOME^%ZIS,DT^DICRW
 S X=$P(^VA(200,DUZ,0),U)
 W !,$$C^XBFUNC("Hello, "_$P(X,",",2)_" "_$P(X,",")),!!,$$C^XBFUNC("Checking Environment for Version "_$P($T(+2),";",3)_" of "_$P($T(+2),";",4)_".")
 ;
 S X=$G(^DD("VERSION"))
 W !!,$$C^XBFUNC("Need at least FileMan 21.....FileMan "_X_" Present")
 I X<21 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))
 W !!,$$C^XBFUNC("Need at least Kernel 7.1.....Kernel "_X_" Present")
 I X<7.1 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XB",0)),"VERSION"))
 W !!,$$C^XBFUNC("Need XB/ZIB, v 3.0.....XB/ZIB "_X_" Present")
 I X<3 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","RA",0)),"VERSION"))
 W !!,$$C^XBFUNC("Need RADIOLOGY, v 4.0.....RADIOLOGY v "_X_" present")
 I X<4 D SORRY Q
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","DG",0)),"VERSION"))
 W !!,$$C^XBFUNC("Need MAS v 5.0.....MAS v "_X_" present")
 I X<5 D SORRY Q
 ;
 S RATSNUM=$O(^DIC(9.4,"C","GMRA",0))   ;IHS/HQW/SCR 2/21/2 **12**
 I RATSNUM="" W !!,$$C^XBFUNC("Allergy Tracking is not installed") D SORRY Q  ;IHS/HQW/SCR 2/21/2 **12**
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","GMRA",0)),"VERSION"))
 W !!,$$C^XBFUNC("Need GMRA v 3.0...GMRA v "_X_" present")
 I $E(X)<3 D SORRY Q
 ;
 I $D(^RAH(77))!$D(^RAH(77.1))!$D(^RAH(77.1)) D BMES^XPDUTL("**WARNING** Possible Radiology HL7 data found. Install will be aborted."),BMES^XPDUTL("To schedule a supported install please call: RPMS support center 1-888-830-7280")
 ;
ENVOK ; If this is just an environment check, end here.
 W !!,$$C^XBFUNC("ENVIRONMENT OK.")
 I $G(XPDENV)=1 S XPDDIQ("XPZ1")=0,XPDDIQ("XPZ2")=0
 ;If conversions have completed quit
 I $G(^RA("IHSPATCH10",0))="CONVERSIONS COMPLETED" Q
 S ^RA("IHSPATCH10",0)=""
 Q
 ;
SORRY ;
 S XPDABORT=1  ;Abort all transport globals in distibution and kill
 ;them from ^XTMP
 W *7,!!,$$C^XBFUNC("Please install current versions before installing this distribution")
 W *7,!,$$C^XBFUNC("Installation of Radiology v4.0 patch 10 has been aborted.")
 Q
