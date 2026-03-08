AMHBAN ; IHS/CMI/LAB - Banner for BH ; 09 Jul 2021  5:16 PM
 ;;4.0;IHS BEHAVIORAL HEALTH;**1,2,3,4,5,6,7,8,9,19,11,12**;JUN 02, 2010;Build 46
 ;
EP ;
V ; GET VERSION
 ;S AMH("VERSION")="",AMH("VERSION")=$O(^DIC(9.4,"C","AMH",AMH("VERSION"))),AMH("VERSION")=^DIC(9.4,AMH("VERSION"),"VERSION")
 S AMH("VERSION")="4.0 (patch 12)"
 I $G(AMHTEXT)="" S AMHTEXT="TEXT",AMHLINE=3 G PRINT
 S AMHTEXT="TEXT"_AMHTEXT
 F AMHJ=1:1 S AMHX=$T(@AMHTEXT+AMHJ),AMHX=$P(AMHX,";;",2) Q:AMHX="QUIT"!(AMHX="")  S AMHLINE=AMHJ
PRINT W:$D(IOF) @IOF
 F AMHJ=1:1:AMHLINE S AMHX=$T(@AMHTEXT+AMHJ),AMHX=$P(AMHX,";;",2) W !?80-$L(AMHX)\2,AMHX K AMHX
 W !?80-(8+$L(AMH("VERSION")))/2,"Version ",AMH("VERSION")
SITE G XIT:'$D(DUZ(2)) G:'DUZ(2) XIT S AMH("SITE")=$P(^DIC(4,DUZ(2),0),"^") W !!?80-$L(AMH("SITE"))\2,AMH("SITE")
XIT ;
 K DIC,DA,X,Y,%Y,%,AMHJ,AMHX,AMHTEXT,AMHLINE
 Q
 ;
RPTS ;EP CALLED FROM ENTRY ACTION OF REPORTS MENU OPTION
 W !!?32,"**SPECIAL NOTE**",!!
 W ?15,"**Q-Man and PCC MGT Reports operate off PCC Files**",!
 W ?10,"**Therefore, reflecting only those BH visits passed to PCC**",!
 Q
TEXT ;mental health / social services banner
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**********************************************
 ;;QUIT
TEXTR ;reports menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**                  Reports                 **
 ;;**********************************************
 ;;QUIT
TEXTX ;export utility
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**              Export Utility              **
 ;;**********************************************
 ;;QUIT
TEXTG ;data entry more menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**     Data Entry Menu Display Options      **
 ;;**********************************************
 ;;QUIT
TEXTE ;data entry menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**             Data Entry Menu              **
 ;;**********************************************
 ;;QUIT
TEXTI ;data entry menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**             IPV/DV Reports               **
 ;;**********************************************
 ;;QUIT
TEXTC ;activity contact counts
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**         Activity Workload Reports        **
 ;;**********************************************
 ;;QUIT
TEXTP ;program activity time
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**             Patient Listings             **
 ;;**********************************************
 ;;QUIT
TEXTA ;age and sex reports
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**         Problem Specific Reports         **
 ;;**********************************************
 ;;QUIT
TEXTT ;tables menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**         Print BH Standard Tables         **
 ;;**********************************************
 ;;QUIT
TEXTB ;encounter/contact reports
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**         Encounter/Record Reports         **
 ;;**********************************************
 ;;QUIT
TEXTM ;manager utilities
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**            Manager Utilities             **
 ;;**********************************************
 ;;QUIT
TEXTF ;freq menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**       Frequency (Top Ten) Reports        **
 ;;**********************************************
 ;;QUIT
TEXTD ;patient treatment plan menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**          Patient Treatment Plans         **
 ;;**********************************************
 ;;QUIT
TEXTH ;data entry menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**         Alcohol Screening Reports        **
 ;;**********************************************
 ;;QUIT
TEXTJ ;data entry menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**       Depression Screening Reports       **
 ;;**********************************************
 ;;QUIT
TEXTN ;data entry menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**          SDOH Screening Reports          **
 ;;**********************************************
 ;;QUIT
TEXTK ;data entry menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**             Screening Reports            **
 ;;**********************************************
 ;;QUIT
TEXTL ;data entry menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**              Suicide Reports             **
 ;;**********************************************
 ;;QUIT
TEXTS ;data entry menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**      Suicide Risk Assessment Reports     **
 ;;**********************************************
 ;;QUIT
TEXTU ;data entry menu
 ;;**********************************************
 ;;**       IHS Behavioral Health System       **
 ;;**      Drug Use Risk Screening Reports     **
 ;;**********************************************
 ;;QUIT
TEXTV ;data entry menu
 ;;***************************************************
 ;;**         IHS Behavioral Health System          **
 ;;**  Alcohol and Drug Use Risk Screening Reports  **
 ;;***************************************************
 ;;QUIT
COPYINFO ;EP called from option
 W !!,"*DSM and DSM-5-TR are registered trademarks of the American Psychiatric"
 W !,"Association, and are used with permission herein. Use of these terms is"
 W !,"prohibited without permission of the American Psychiatric Association."
 W !,"Use of this trademark does not constitute endorsement of this product by"
 W !,"the American Psychiatric Association."
 W !!,"*Reprinted with permission from the Diagnostic and Statistical Manual of"
 W !,"Mental Disorders, Fifth Edition, Text Revision.  Copyright 2022, "
 W !,"American Psychiatric Association.  All Rights Reserved.  Unless authorized"
 W !,"in writing by the APA, no part may be reproduced or used in a manner "
 W !,"inconsistent with the APA's copyright. This prohibition applies to "
 W !,"unauthorized uses or reproductions in any form.  The American Psychiatric"
 W !,"Association is not affiliated with and is not endorsing this product.",!!
 K DIR
 S DIR(0)="E",DIR("A")="Press Enter to Continue" D ^DIR
 K DIR
 Q
