ACHSPRE ; IHS/ADC/GTH - PREINIT, CHK RQMNTS, DEL PKG, ETC. ; [ 03/12/1999  1:58 PM ]
 ;;3.0;CONTRACT HEALTH MGMT SYSTEM;**3,7**;SEP 17, 1997
 ;;ACHS*3*3 PRE INSTALL DOES NOT WORK ON DOS BASED MACHINES
 ;;ACHS*3*7 PRE INSTALL DOES NOT WORK ON DOS/NT BASED MACHINES
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
 W !!,$$C^XBFUNC("Need HFS interface to Kernel (^%ZISH)....."_$J("",25)),!?20
 S ACHS=1
 ;ACHS*3*3 PRE INSTALL DOES NOT WORK ON DOS BASED MACHINES
 ;SET ACHSRCHK TO LOOK IN %ZISH OR ZISHMSMD BASED ON CONTENT OF ^%ZOSF("OS")
 ;S ACHSRCHK="'$L($T(@X"_$S($G(^%ZOSF("OS"))["UNIX":"^%ZISH",1:"ZISHMSMD")_"))" ;ACHS*3*7
 S ACHSRCHK="'$L($T(@X"_$S($G(^%ZOSF("OS"))["UNIX":"^%ZISH",1:"^ZISHMSMD")_"))" ;ACHS*3*7
 ;F X="OPEN","DEL","SEND","LIST","STATUS" W X," " I '$L($T(@X^%ZISH)) W !,$$C^XBFUNC($J("",30)_X_"^%ZISH not Present") S ACHS=0
 F X="OPEN","DEL","SEND","LIST","STATUS" W X," " I @ACHSRCHK W !,$$C^XBFUNC($J("",30)_X_"^%ZISH not Present") S ACHS=0
 I 'ACHS D SORRY Q
 W !,$$C^XBFUNC($J("",37)_"5 Entry Points OK")
 ;
 S X=$G(^DIC(9.4,$O(^DIC(9.4,"C","XB",0)),"VERSION"))
 W !!,$$C^XBFUNC("Need XB/ZIB, v 3.0.....XB/ZIB "_X_" Present")
 I X<3 D SORRY Q
 ;
 S X=$T(+2^AUPNPAT)
 S X=$S($P(X,";",3)>92.2:"Looks OK",$P(X,";",5)[3:"Looks OK",1:"")
 W !!,$$C^XBFUNC("Need AUPN, at least v 93.2 thru Patch 3....."_X)
 I '$L(X) D SORRY Q
 ;
 KILL ^TMP("ACHSPOST",$J)
 ;
 S X="ACHS",Y="ACHR"
 I '$D(^DIC(19,"C",X)),'($E($O(^DIC(19,"B",Y)),1,4)=X),'($E($O(^DIC(19.1,"B",Y)),1,4)=X) W !!,$$C^XBFUNC("NEW INSTALL."),! S ^TMP("ACHSPOST",$J,"NEW INSTALL")=1 Q
 ;
 I '$D(^DIC(9.4,"C","ACHS")) G ENVOK
VERSION ;
 NEW DA,DIC
 S X="ACHS",DIC="^DIC(9.4,",DIC(0)="",D="C"
 D IX^DIC
 I Y<0 D  Q
 . W !!,$$C^XBFUNC("You Have More Than One Entry In The")
 . W !,$$C^XBFUNC("PACKAGE File with an ""ACHS"" prefix.")
 . W !,$$C^XBFUNC("One entry needs to be deleted.")
 . W !,$$C^XBFUNC("Please FIX IT! Before Proceeding."),!
 . D SORRY
 .Q
 ;
 S DA=+Y
 W !!,$$C^XBFUNC("CHS version '"_$G(^DIC(9.4,DA,"VERSION"))_"' currently installed")
 ;
 S %=$G(^DIC(9.4,DA,"VERSION"))
 I %,%<1.5 D  Q
 . W !,$$C^XBFUNC("This Version of Contract Health Management Cannot Be Installed Unless")
 . W !,$$C^XBFUNC("Version 1.5 Or Higher Has Been Previously Installed.")
 . W !,$$C^XBFUNC("A postinit to 1.5 converts dd numbers.")
 . D SORRY
 . I $$DIR^XBDIR("E","Press RETURN...")
 .Q
 ;
ENVOK ; If this is just an environ check, end here.
 W !!,$$C^XBFUNC("ENVIRONMENT OK.")
 I '$D(DIFQ),'$$DIR^XBDIR("E","","","","","",1) KILL DIFQ,^TMP("ACHSPOST",$J) Q
 E  I '$D(DIFQ) Q
 ;
V168 ;
 I $G(DA),$G(^DIC(9.4,DA,"VERSION"))=1.68 S ^TMP("ACHSPOST",$J,1.68)="" W $$C^XBFUNC("You currently have version 1.68 installed."),$$C^XBFUNC("Don't forget to run ^ACHSYPOS to update medical priorities.")
 ;
PKDEL ; Delete current CHS tmplts, optns, help frms, bultns, funcs.
 ;
 ; S XBPKNSP="ACHS"
 ; D START^XBPKDEL
 ; I '$D(DIFQ) W !,$$C^XBFUNC("I really need to re-arrange your menus."),!,$$C^XBFUNC("Please re-start the init.") KILL ^TMP("ACHSPOST",$J) Q
 ; W !,$$C^XBFUNC("Package deleted."),!,$$C^XBFUNC("Now to install the new one..."),!
 I $D(DIFQ),'$$DIR^XBDIR("E","","","","","",2) KILL DIFQ
 Q
 ;
SORRY ;
 KILL DIFQ
 W *7,!,$$C^XBFUNC("Sorry....")
 Q
 ;
