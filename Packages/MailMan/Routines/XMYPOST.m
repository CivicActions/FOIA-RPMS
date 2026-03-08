XMYPOST ;(WASH ISC)/CAP-XM POST INIT ;10/18/93  18:29 ;
VER ;;7.1;Mailman;**1003**;OCT 27, 1998
VER ;;7.1;MailMan;;Jun 02, 1994
 D PRE^XMYPRE ;SET UP INITIAL POSTMASTER BASKET
 ;
 G GO:$O(^DIC(4.2,0))
 W !!,"There are no DOMAIN FILE entries."
 W !,"Please enter DOMAINS (local and parent),"
 W !,"then 'DO GO^XMYPOST' to initialize network." Q
GO D POST,OPT^XMYPRE,GO^XMP,INIT^XMC2
 G NOO:'$D(^DD(3.7,0,"VR")) S XMVER=+^("VR")
 W !!,"Data in your system indicates that you are installing this",!,"package over Version "_XMVER_" of MailMan.",!!
 I XMVER<3.1 D ^XMYPOST0 ;Converts structure 3.09 and previous versions
 I XMVER<3.2 D ^XMYPOST3 I $D(^XMB("PURGE"))#10=1 S X=^XMB("PURGE"),^XMB(1,1,.1,0)="^4.302DA^1^1",^(1,0)=X,^XMB(1,1,.1,"B",+X,1)="" K ^XMB("PURGE")
 I XMVER<7 D ^XMYPOST4
 I XMVER<7.1 D ^XMYPOST5
 I XMVER<7.2 D ENT71^XMYPOST5
NO D PM S ^DD(3.7,0,"VR")=$P($T(VER),";",3)
 ;
 ;Imaging package installation
 D ^%T W !!,"POSTINIT complete successfully !!!",!!
 ;
 K DIC,DIK,XMVER,I,J,DA,DIE,DLAYGO,DR,XMVER,XMVER0
 W !!,"PLEASE CHECK DOMAIN FILE, SET 'FLAG' FIELD TO 'S' FOR"
 W !,"THOSE DOMAINS YOU WISH COMMUNICATIONS TO BE OPEN TO."
 W !,"(ISC's have the 'FLAG' fields set to 'S' [send] already.)",!!
 W !!!,"The XMAUTOPURGE option probably needs to be rescheduled."
 W !,"Also the new 'IN-BASKET-PURGE' may be scheduled.  Please"
 W !,"check the KERNEL SITE PARAMETER file for:  MESSAGE RETENTION"
 W !,"DAYS (used by the 'IN-BASKET-PURGE') and if the background"
 W !,"filer needs some adjustment check the BACKGROUND FILER HANG TIME"
 W !,"field."
 W !!,"The defaults for these are 30 days and 5 seconds, which should"
 W !,"be appropriate under most circumstances."
 ;
 W !!,"Please review your scheduling of the MAINTENANCE options listed below."
 W !!?4,"Option",?38,"Recommended Rescheduling Frequency"
 W !!?4,"XMAUTOPURGE",?38,"WEEKLY"
 W !?4,"XMCLEAN",?38,"DAILY"
 W !?4,"XMMGR-DISK-MANY-MESSAGE-MAINT",?38,"MONTHLY"
 W !?4,"XMMGR-LARGE-MESSAGE-REPORT",?38,"MONTHLY"
 W !?4,"XMMGR-PURGE-AI-XREF",?38,"QUARTERLY"
 W !?4,"XMPURGE-BY-DATE",?38,"ACCORDING TO SITE POLICY"
 W !?4,"XMUT-CHKFIL",?38,"MONTHLY"
 ;
 W !!!,"***** IMPORTANT INFORMATION FOR VAX INSTALLATIONS !!! *****"
 W !!,"Network Mail requires that the PACK option be ON for the outgoing"
 W !,"Mini-engine/IDCU ports.  See help under DSM 'Command=USE Device:PACK'"
 W !,"(Enter ? at the '>' in programming mode).",!!
 Q
PM ;Set up POSTMASTER Mail Group
 N A,B Q:$O(^XMB(3.8,"B","POSTMASTER",0))
 W !!,"I found no POSTMASTER Mail Group, so I am setting one up !"
 W !,"The person that ran this INIT will be a member as well as"
 W !,"the Postmaster.  Please add other local members.",!!
 S A(.5)="",A(DUZ)="",A=$$MG^XMBGRP("POSTMASTER",0,DUZ,1,.A,.B,0)
 Q
POST ;VERSION 3.1 POST INIT
 Q:$D(^XMB(4.6,"B","SWPKERNEL"))
 S DIC="^XMB(4.6,",DIC("DR")=".01////SWPKERNEL",DIC(0)="FI" D FILE^DICN
 S Y=$O(^XMB(4.6,"B","SWPKERNEL",0)),^XMB(4.6,Y,1,0)="^4.61^7^7^"_DT
 F X=1:1:7 S ^XMB(4.6,Y,1,X,0)=$P("S^W 2^S^L CODE:^S MAIL-BOX SWP^L 220^MAIL",U,X)
 S ^XMB(4.6,Y,2,0)="^4.62^1^1^"_DT,^XMB(4.6,Y,2,1,0)="SWP means Sliding Window Protocol.  SWP is a bit slower than 3BSCP, faster than SCP & 1SCP and more likely to succeed than 3BSCP."
O I '$D(^%ZOSF("LPC")),$D(^("OS")) S Y=^("OS") I Y["DSM",Y'["VAX" S X="ERR^XMYPOST",@^%ZOSF("TRAP"),X=$ZC(%LPC,X),^XMB(1,1,"LPC")="S Y=$ZC(%LPC,X)"
P S:$D(^%ZOSF("TRAP")) X="ERR^ZU",@^%ZOSF("TRAP") D POST^XMYPOST2
 Q
ERR S ^XMB(1,1,"LPC")="S Y=$ZC(LPC,X)" G P
KSP D KSP^XMYPOST2 ;Used by option XMCHRIS
 Q
NOO ;Virgin install stuff
 D VIRGIN^XMYPOST5 G NO
