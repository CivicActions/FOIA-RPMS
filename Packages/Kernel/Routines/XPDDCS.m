XPDDCS ;SFISC/RSD - Display Checksum for a package ;05/14/2001  13:30 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**2,44,108,202**;Jul 10, 1995
EN1 ;Verify checksums in Transport Global
 N D0,DIC,X,XPD,XPDS,XPDST,XPDT,Y,Z
 ;S DIC="^XPD(9.7,",DIC(0)="AEQMZ",DIC("S")="I $D(^XTMP(""XPDI"",Y))"
 ;D ^DIC Q:Y<0
 S XPDS="I $D(^XTMP(""XPDI"",Y))"
 S XPDST=$$LOOK^XPDI1(XPDS) Q:XPDST'>0
 S XPD("XPDT")="",XPD("XPDST")="",X="XUTMDEVQ"
 ;during Virgin install, XUTMDEVQ might not exists
 X ^%ZOSF("TEST") E  D  Q
 .S IOSL=99999,IOM=80,IOF="#",IOST="",$Y=0 D LST1(9.7)
 S Y="LST1^XPDDCS(9.7)",Z="Checksum Print"
 D EN^XUTMDEVQ(Y,Z,.XPD)
 Q
EN2 ;print from build (system)
 N D0,DIC,XPD,XPDT,XPDST,Y,Z
 ;S DIC="^XPD(9.6,",DIC(0)="AEQMZ"
 ;D ^DIC Q:Y<0
 S XPDST=$$LOOK^XPDB1() Q:XPDST'>0
 S XPD("XPDT")="",Y="LST1^XPDDCS(9.6)",Z="Checksum Print"
 D EN^XUTMDEVQ(Y,Z,.XPD)
 Q
 ;
LST1(FILE) ;Print group
 N XPDI S XPDI=0
 F  S XPDI=$O(XPDT(XPDI)) Q:XPDI'>0  S D0=+XPDT(XPDI) D PNT(FILE)
 Q
 ;
PNT(XPDFIL) ;print
 N XPD0,XPDC,XPDDT,XPDE,XPDI,XPDJ,XPDPG,XPDQ,XPDUL,X
 Q:'$D(^XPD(XPDFIL,D0,0))  S XPD0=^(0),XPDPG=1,$P(XPDUL,"-",IOM)="",XPDDT=$$HTE^XLFDT($H,"1PM")
 W:$E(IOST,1,2)="C-" @IOF D HDR
 W !
 S XPDI="",(XPDQ,XPDE)=0
 ;XPDFIL=9.7  use transport global exists
 I XPDFIL=9.7 D
 .I '$D(^XTMP("XPDI",D0)) W !!," ** Transport Global doesn't exist **" S XPDQ=1 Q
 .;check for missing nodes in transport global
 .I '$D(^XTMP("XPDI",D0,"BLD"))="" W !!," **Transport Global corrupted, please reload **" S XPDQ=1 Q
 .F XPDC=0:1 S XPDI=$O(^XTMP("XPDI",D0,"RTN",XPDI)) Q:XPDI=""  S XPDJ=$G(^(XPDI)) D  Q:XPDQ
 ..I XPDJ="" W !," **Transport Global corrupted, please reload **" S XPDQ=1 Q
 ..;if deleting at site, there is no checksum
 ..I +XPDJ=1 S XPDC=XPDC-1 Q
 ..D SUM(XPDI,$NA(^XTMP("XPDI",D0,"RTN",XPDI)),$P(XPDJ,U,3))
 ..S XPDQ=$$CHK(4)
 ;check build file
 E  D
 .F XPDC=0:1 S XPDI=$O(^XPD(9.6,D0,"KRN",9.8,"NM","B",XPDI)) Q:XPDI=""  S XPDJ=$O(^(XPDI,0)) D  Q:XPDQ
 ..Q:'$D(^XPD(9.6,D0,"KRN",9.8,"NM",+XPDJ,0))  S XPDJ=$P(^(0),U,4)
 ..;quit if no checksum, routine wasn't loaded
 ..I XPDJ="" S XPDC=XPDC-1 Q
 ..N DIF,XCNP,%N
 ..S X=XPDI,DIF="^TMP($J,""RTN"",XPDI,",XCNP=0
 ..X ^%ZOSF("TEST") E  W !,XPDI,?10,"Doesn't Exist" Q
 ..X ^%ZOSF("LOAD")
 ..D SUM(XPDI,$NA(^TMP($J,"RTN",XPDI)),XPDJ)
 ..S XPDQ=$$CHK(4)
 Q:XPDQ
 W !!?3,XPDC," Routine checked, ",XPDE," failed.",!
 Q
 ;
 ;XPDR=routine name, Z=global root, XPD=check sum
SUM(XPDR,Z,XPD) ;check checksum
 N Y
 ;first char. is the sum tag used in XPDRSUM
 I XPD'?1U1.N W !,XPDR,?10,"ERROR in Checksum" S XPDE=XPDE+1 Q
 S @("Y=$$SUM"_$E(XPD)_"^XPDRSUM(Z)"),XPD=$E(XPD,2,255)
 I Y'=XPD W !,XPDR,?10,"Calculated "_$C(7)_Y_", should be "_XPD S XPDE=XPDE+1
 Q
 ;
CHK(Y) ;Y=excess lines, return 1 to exit
 Q:$Y<(IOSL-Y) 0
 I $E(IOST,1,2)="C-" D  Q:'Y 1
 .N DIR,I,J,K,X
 .S DIR(0)="E" D ^DIR
 S XPDPG=XPDPG+1
 W @IOF D HDR
 Q 0
 ;
HDR W !,"PACKAGE: ",$P(XPD0,U),"     ",XPDDT,?70,"PAGE ",XPDPG,!,XPDUL,!
 Q
