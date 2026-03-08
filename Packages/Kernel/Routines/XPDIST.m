XPDIST ;SFISC/RSD - site tracking; [ 07/29/2004   9:01 AM ]
 ;;8.0;KERNEL;**66,108,185,233**;Jul 10, 1995
 ;Returns ""=failed, XMZ=sent
 ;D0=ien in file 9.7, XPY=national site tracking^address(optional)
EN(D0,XPY) ;send message
 N %,DIFROM,XPD,XPD0,XPD1,XPD2,XPDV,XPDTEXT,XPZ,XMDUZ,XMSUB,XMTEXT,XMY,XMZ,X,Z,Y
 ;Get data needed
 I '$D(^XPD(9.7,$G(D0),0)) D BMES^XPDUTL(" INSTALL file entry missing") Q ""
 S XPD0=^XPD(9.7,D0,0),XPD1=$G(^(1)),XPD2=$G(^(2))
 I '$P(XPD0,U,2) D BMES^XPDUTL(" No link to PACKAGE file") Q ""
 S XPD=$P($G(^DIC(9.4,+$P(XPD0,U,2),0)),U),XPDV=$$VER^XPDUTL($P(XPD0,U))
 I XPD="" D BMES^XPDUTL(" PACKAGE file entry missing") Q ""
 ;XPZ(1)=start, XPZ(2)=completion date/time, XPZ(3)=run time
 S XPZ(1)=$P(XPD1,U),XPZ(2)=$P(XPD1,U,3),XPZ(3)=$$FMDIFF^XLFDT(XPZ(2),XPZ(1),3),XPZ(1)=$$FMTE^XLFDT(XPZ(1)),XPZ(2)=$$FMTE^XLFDT(XPZ(2))
 D LOCAL
 Q $$FORUM()
 ;
FORUM() ;send to Server on FORUM
 Q:$G(XPY)="" ""
 S:XPY XMY("S.A5CSTS@FORUM.VA.GOV")="",XMY("ESSRESOURCE@MED.VA.GOV")=""
 S:$L($P(XPY,U,2)) XMY($P(XPY,U,2))=""
 K ^TMP($J)
 ;Quit if not VA production primary domain
 I $G(^XMB("NETNAME"))'[".VA.GOV" D BMES^XPDUTL(" Not a VA primary domain") Q ""
 X ^%ZOSF("UCI") S %=^%ZOSF("PROD")
 S:%'["," Y=$P(Y,",")
 I Y'=% D BMES^XPDUTL(" Not a production UCI") Q ""
 ;Message for server
 S XPDTEXT(1,0)="PACKAGE INSTALL"
 S XPDTEXT(2,0)="SITE: "_$G(^XMB("NETNAME"))
 S XPDTEXT(3,0)="PACKAGE: "_XPD
 S XPDTEXT(4,0)="VERSION: "_XPDV
 S XPDTEXT(5,0)="Start time: "_XPZ(1)
 S XPDTEXT(6,0)="Completion time: "_XPZ(2)
 S XPDTEXT(7,0)="Run time: "_XPZ(3)
 S XPDTEXT(8,0)="DATE: "_DT
 S XPDTEXT(9,0)="Installed by: "_$P($G(^VA(200,+$P(XPD0,U,11),0)),U)
 S XPDTEXT(10,0)="Install Name: "_$P(XPD0,U)
 S XPDTEXT(11,0)="Distribution Date: "_$P(XPD1,U,4)
 S XPDTEXT(12,0)=XPD2
 S XMDUZ=$S($P(XPD0,U,11):+$P(XPD0,U,11),1:.5),XMTEXT="XPDTEXT(",XMSUB=$P(XPD0,U)_" INSTALLATION"
 D ^XMD
 K ^TMP($J)
 Q "#"_$G(XMZ)
 ;
LOCAL ;Send a message to local mail group
 S X=$$MAILGRP^XPDUTL(XPD) Q:X=""
 K ^TMP($J),XMY
 S XMY(X)="" D GETENV^%ZOSV
 ;Message for users
 S XPDTEXT(1,0)="PACKAGE INSTALL"
 S XPDTEXT(2,0)="SITE: "_$G(^XMB("NETNAME"))
 S XPDTEXT(3,0)="PACKAGE: "_XPD
 S XPDTEXT(4,0)="VERSION: "_XPDV
 S XPDTEXT(5,0)="Start time: "_XPZ(1)
 S XPDTEXT(6,0)="Completion time: "_XPZ(2)
 S XPDTEXT(7,0)="Enviroment: "_Y
 S XPDTEXT(8,0)="Installed by: "_$P($G(^VA(200,+$P(XPD0,U,11),0)),U)
 S XPDTEXT(9,0)="Install Name: "_$P(XPD0,U)
 S XPDTEXT(10,0)="Distribution Date: "_$$FMTE^XLFDT($P(XPD1,U,4))
 S XMDUZ=$S($P(XPD0,U,11):+$P(XPD0,U,11),1:.5),XMTEXT="XPDTEXT(",XMSUB=$P(XPD0,U)_" INSTALLATION"
 D ^XMD
 K XMTEXT
 Q
