BPHR21P6 ;GDIT/HCS/BEE-Version 2.1 Patch 6 ; 09 Apr 2020  8:53 AM
 ;;2.1;IHS PERSONAL HEALTH RECORD;**6**;Apr 01, 2014;Build 6
 ;
 NEW VERSION,X
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D FIX(2)
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D FIX(2)
 ;
 ;Check for BPHR*2.1*5
 I '$$INSTALLD("BPHR*2.1*5") D FIX(2)
 ;
 Q
 ;
PRE ;EP
 NEW DA,DIK
 S DIK="^BPHRCLS("
 S DA=0 F  S DA=$O(^BPHRCLS(DA)) Q:'DA  D ^DIK
 Q
 ;
PST ;EP - Postinstall
 ; Import BPHR classes
 K ERR
 D IMPORT^BPHRCLAS(1,.ERR)
 I $G(ERR) Q
 ;
 Q
 ;
INSTALLD(BPHRSTAL,PATCH) ;EP - Determine if patch BEDDSTAL was installed, where
 ; BPHRSTAL is the name of the INSTALL.  E.g "BPHR*2.1*5"
 ;
 S PATCH=$G(PATCH)
 ;
 NEW BPHRY,INST
 ;
 S BPHRY=$O(^XPD(9.7,"B",BPHRSTAL,""))
 S INST=$S(BPHRY>0:1,1:0)
 D IMES(BPHRSTAL,INST,PATCH)
 Q INST
 ;
IMES(BPHRSTAL,Y,PATCH) ;Display message to screen
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_$S($G(PATCH)]"":PATCH,1:BPHRSTAL)_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
 ;
FIX(X)   ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("This patch must be installed prior to the installation of BPHR*2.1*6",IOM)
 Q
