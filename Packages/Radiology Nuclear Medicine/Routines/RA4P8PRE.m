RA4P8PRE ; IHS/HQW/SCR - PREINIT, CHK RQMNTS ; [ 07/25/2001  2:47 PM ]
 ;;4.0;RADIOLOGY;**PATCH 8 **;JULY 17,2001
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY Q
 ;
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
ENVOK ; If this is just an environ check, end here.
 W !!,$$C^XBFUNC("ENVIRONMENT OK.") Q
 ;
SORRY ;
 W *7,!,$$C^XBFUNC("Sorry....")
 Q
 ;
