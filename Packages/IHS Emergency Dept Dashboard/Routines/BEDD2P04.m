BEDD2P04 ;GDIT/HS/BEE-BEDD VERSION 2.0 Patch 4 ENV/PST ROUTINE ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;**4**;Jun 04, 2014;Build 19
 ;
 NEW VERSION,X
 ;
 ;Check for AMER*3.0*11
 ;I '$$INSTALLD("AMER*3.0*11") D BMES^XPDUTL("Version 3.0 Patch 11 of AMER is required!") S XPDQUIT=2 Q
 ;
 ;Check for BEDD*2.0*3
 I '$$INSTALLD("BEDD*2.0*3") D BMES^XPDUTL("Version 2.0 Patch 3 of BEDD is required!") S XPDQUIT=2 Q
 ;
 ;Check for the XML build
 I $T(XML^BEDD2X04)="" D BMES^XPDUTL("The BEDD XML build bedd0200.04.xml must first be installed!") S XPDQUIT=2 Q
 ;
 Q
 ;
ENT ;Post install entry point
 ;
 NEW SC
 ;
 ;Force recompile of project
 D $SYSTEM.OBJ.CompileProject("bedd0200","k-u")
 D $SYSTEM.OBJ.CompileProject("bedd0200p1","k-u")
 D $SYSTEM.OBJ.CompileProject("bedd0200p2","k-u")
 D $SYSTEM.OBJ.CompileProject("bedd0200p3","k-u")
 D $SYSTEM.OBJ.CompileProject("bedd0200p4","k-u")
 D $SYSTEM.OBJ.CompileList("csp/bedd/BEDD*.csp","k-u")
 ;
 ;Run cleanup routine
 D DAILY^BEDDVFIX(2)
 ;
 Q
 ;
INSTALLD(BEDDSTAL) ;EP - Determine if patch BEDDSTAL was installed, where
 ;BEDDSTAL is the name of the INSTALL.  E.g "AMER*3.0*10"
 ;
 NEW DIC,X,Y,D
 S X=$P(BEDDSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",22,",X=$P(BEDDSTAL,"*",2)
 D ^DIC
 I Y<1 Q 0
 S DIC=DIC_+Y_",""PAH"",",X=$P(BEDDSTAL,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
