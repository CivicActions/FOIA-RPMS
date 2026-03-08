BEDD2P06 ;GDIT/HS/BEE-BEDD VERSION 2.0 Patch 6 ENV/PST ROUTINE ; 08 Nov 2011  12:00 PM
 ;;2.0;IHS EMERGENCY DEPT DASHBOARD;**6**;Jun 04, 2014;Build 9
 ;
 NEW VERSION,X
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D FIX(2)
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D FIX(2)
 ;
 ;Check for BEDD*2.0*5
 I '$$INSTALLD("BEDD*2.0*5") D FIX(2)
 ;
 ;Check for the XML build
 I $T(XML^BEDD2X06)="" D IMES("BEDD v2.0 Patch 6 XML Build",0,""),FIX(2)
 ;
 ;Check for the EHR*1.1*32 build
 I '$$INSTALLD("BEHO*1.1*074003","EHR*1.1*32") D FIX(2)
 ;
 ;Check for AMER*3.0*12 build
 I '$$INSTALLD("AMER*3.0*12") D FIX(2)
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
 D $SYSTEM.OBJ.CompileProject("bedd0200p5","k-u")
 D $SYSTEM.OBJ.CompileProject("bedd0200p6","k-u")
 D $SYSTEM.OBJ.CompileList("csp/bedd/BEDD*.csp","k-u")
 ;
 Q
 ;
INSTALLD(BEDDSTAL,PATCH) ;EP - Determine if patch BEDDSTAL was installed, where
 ; BEDDSTAL is the name of the INSTALL.  E.g "AMER*3.0*11"
 ;
 S PATCH=$G(PATCH)
 ;
 NEW BEDDY,INST
 ;
 S BEDDY=$O(^XPD(9.7,"B",BEDDSTAL,""))
 S INST=$S(BEDDY>0:1,1:0)
 D IMES(BEDDSTAL,INST,PATCH)
 Q INST
 ;
IMES(BEDDSTAL,Y,PATCH) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_$S($G(PATCH)]"":PATCH,1:BEDDSTAL)_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
 ;
FIX(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("This patch must be installed prior to the installation of BEDD*2.0*6",IOM)
 Q
