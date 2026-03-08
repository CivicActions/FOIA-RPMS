BREH1P01 ;GDIT/HS/BEE - EHI Patch 1 Env Check and POST INSTALL; JAN 07, 2011
 ;;1.0;RPMS EHI EXPORT;**1**;Jun 15, 2023;Build 4
 ;
 NEW VERSION,X
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D FIX(2)
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D FIX(2)
 ;
 ;Check for BREH 1.0
 I '$$INSTALLD("RPMS EHI EXPORT 1.0") D FIX(2)
 ;
 Q
 ;
 ;Reseting for SAC - Used by KIDS to allow for quitting
 NEW XPDABORT
 ;
 Q
 ;
INSTALLD(BREHSTAL,PATCH) ;EP - Determine if patch BREHSTAL was installed, where
 ; BREHSTAL is the name of the INSTALL.  E.g "DI*22.0*1020"
 ;
 S PATCH=$G(PATCH)
 ;
 NEW BREHY,INST
 ;
 S BREHY=$O(^XPD(9.7,"B",BREHSTAL,""))
 S INST=$S(BREHY>0:1,1:0)
 D IMES(BREHSTAL,INST,PATCH)
 Q INST
 ;
IMES(BREHSTAL,Y,PATCH) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_$S($G(PATCH)]"":PATCH,1:BREHSTAL)_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
 ;
FIX(X)   ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("This patch must be installed prior to the installation of BREH*1.0*1",IOM)
 Q
 ;
POST ;EP - POST INSTALL ACTIONS
 Q
