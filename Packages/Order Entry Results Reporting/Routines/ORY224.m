ORY224 ; slc/REV - Post-init for patch OR*3*224 ; Aug 6, 2003@11:02:31 [6/17/04 12:59pm]
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**224**;Dec 17, 1997
 ;
PRE ;initiate pre-init processes
 ;
 Q
 ;
POST ;initiate post-init processes
 ;
 N VER
 ;
 S VER=$P($T(VERSION^ORY224),";",3)
 ;D MAIL
 ;
 Q
 ;
MAIL ; send bulletin of installation time
 N COUNT,DIFROM,I,START,TEXT,XMDUZ,XMSUB,XMTEXT,XMY
 S COUNT=0
 S XMSUB="Version "_$P($T(VERSION),";;",2)_" Installed"
 S XMDUZ="CPRS PACKAGE"
 F I="G.CPRS GUI INSTALL@ISC-SLC.VA.GOV",DUZ S XMY(I)=""
 S XMTEXT="TEXT("
 ;
 S X=$P($T(VERSION),";;",2)
 D LINE("Version "_X_" has been installed.")
 D LINE(" ")
 D LINE("Install complete:  "_$$FMTE^XLFDT($$NOW^XLFDT()))
 ;
 D ^XMD
 Q
 ;
LINE(DATA) ; set text into array
 S COUNT=COUNT+1
 S TEXT(COUNT)=DATA
 Q
 ;
VERSION ;;24.27
