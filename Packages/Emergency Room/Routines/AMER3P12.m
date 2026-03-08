AMER3P12 ;GDIT/HS/BEE - AMER v3.0 Patch 12 ENV Check/PST Check ; 07 Oct 2013  11:33 AM
 ;;3.0;ER VISIT SYSTEM;**12**;MAR 03, 2009;Build 3
 ;
 ;Check for AMER*3.0*11
 I '$$INSTALLD("AMER*3.0*11") D FIX(2)
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D FIX(2)
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D FIX(2)
 ;
 Q
 ;
INSTALLD(AMERSTAL) ;EP - Determine if patch AMERSTAL was installed, where
 ; AMERSTAL is the name of the INSTALL.  E.g "AMER*3.0*11"
 ;
 NEW AMERY,INST
 ;
 S AMERY=$O(^XPD(9.7,"B",AMERSTAL,""))
 S INST=$S(AMERY>0:1,1:0)
 D IMES(AMERSTAL,INST)
 Q INST
 ;
IMES(AMERSTAL,Y) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_$S($G(PATCH)]"":PATCH,1:AMERSTAL)_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
 ;
FIX(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("This patch must be installed prior to the installation of AMER*3.0*12",IOM)
 Q
