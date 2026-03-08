XUCMPR17 ;SFIRMFO/JC;Patch 17 Pre-init; ;07/09/96  14:55
 ;;7.3;;Kernel Toolkit;**17**;June 26, 1996
 ;This pre-init removes VPM file 8986.098, which used to
 ;be used for storage of BERNSTEIN RESPONSE TIME DATA. The
 ;DD and all Bernstein data is removed. Patch 17 will replace
 ;this file with a new structure to support the storage of
 ;VPM RESPONSE TIME data.
ENV ;
 W !,"...Checking environment."
 I $$VERSION^XPDUTL("XU")<8 W !,"Kernel 8.0 required." S XPDQUIT=1
 I '$$PATCH^XPDUTL("XU*8.0*35") W !,"Kernel Patch, XU*8.0*35 not detected. Please install this patch before proceeding." S XPDQUIT=1
 Q:$G(XPDQUIT)=1
 I $G(XPDENV) S XUCM=$$PARM^XUCMVPU I XUCM'="",$P(XUCM,"^",10) D
 .W !,"VPM appears to be running and needs to be disabled."
 .S DIC="^XUCM(8986.095,",DIC(0)="AEMQ" D ^DIC Q:Y=-1
 .S DIE=DIC,DA=+Y,DR=".11//" D ^DIE
 Q
DEL ;	
 D BMES^XPDUTL("Deleting file 8986.098 and removing Bernstein RT Data.")
 S DIU="^XUCM(8986.098,",DIU(0)="DT" D EN^DIU2
 D BMES^XPDUTL("Adding metrics, RTM, and RSP.")
 S DIC=8986.4,DIC(0)="LMQ",X="RTM" D ^DIC
 N Z,Z1
 I +Y>0 D
 .S Z=">",Z1="VPM Response Time"
 .S DIE=DIC,DA=+Y,DR=".03///^S X=Z;1///^S X=Z1" D ^DIE
 K DA,Y
 S X="RSP" D ^DIC
 I +Y>0 D
 .S Z1="Response Events/Second"
 .S DIE=DIC,DA=+Y,DR=".03///^S X=Z;1///^S X=Z1" D ^DIE
 Q
