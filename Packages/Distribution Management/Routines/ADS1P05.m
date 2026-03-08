ADS1P05 ;IHS/GDIT/AEF-ADS Version 1.0 Patch 5 Post Install
 ;;1.0;DISTRIBUTION MANAGEMENT;**5**;Apr 23, 2020;Build 14
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT,LIEN
 ;
 ;Check for ADS*1.0*4
 I '$$INSTALLD("ADS*1.0*4") D BMES^XPDUTL("Version 1.0 Patch 4 of ADS is required!") S XPDQUIT=2 Q
 ;
 ;Check for BSTS*2.0*1 - Needed for logging call
 I '$$INSTALLD("BSTS*2.0*1") D BMES^XPDUTL("Version 2.0 Patch 1 of BSTS is required!") S XPDQUIT=2 Q
 ;
 ;Check for XU*8.0*1020
 I '$$INSTALLD("XU*8.0*1020") D BMES^XPDUTL("Version 8.0 Patch 1020 of XU is required!") S XPDQUIT=2 Q
 ;
 ;Check for DI*2.2*1020
 I '$$INSTALLD("DI*22.0*1020") D BMES^XPDUTL("Version 22.0 Patch 1020 of DI is required!") S XPDQUIT=2 Q
 ;
 Q
PRE ;PRE INSTALL
 ;
 N DA,DIK,II
 ;
 ;Clear existing transport global entries:
 S II=0 F  S II=$O(^ADSCLS(II)) Q:'II  S DA=II,DIK="^ADSCLS(" D ^DIK
 ;
 Q
POST ;POST INSTALL
 ;
 ;Install class:
 D CLS
 ;
 Q
CLS ;
 ;----- INSTALL CLASS
 ;
 N ADSUPD,DIR,DIROUT,DIRUT,DTOUT,DUOUT,ERR,ERROR,I,TRIEN,TRNM,Y
 ;
 D BMES^XPDUTL("Importing ADS classes")
 ;
 ;Get the latest IEN:
 S TRNM=$O(^ADSCLS("B",""),-1)
 I TRNM="" D  Q
 . D BMES^XPDUTL(" ERROR - Unable to locate ADS CLASS TRANSPORT FILE entry during post insall.  Install aborted.")
 . S XPDABORT=1
 S TRIEN=$O(^ADSCLS("B",TRNM,""))
 I $G(TRIEN)=""  D  Q
 . D BMES^XPDUTL(" ERROR - No ADS CLASS TRANSPORT FILE entry on file, install aborted,")
 . S XPDABORT=1
 D IMPORT^ADSCLAS(TRIEN,.ERR)
 I $G(ERR) D  Q
 . D BMES^XPDUTL(" ERROR - There was an error during the ADS CLASS TRANSPORT FILE import, install aborted.")
 . F I=1:1 Q:'$D(ERR(I))  D BMES^XPDUTL(" "_ERR(I))
 . S XPDABORT=1
 ;
 Q
INSTALLD(ADSSTAL) ;EP - Determine if patch ADSSTAL was installed, where
 ; ADSSTAL is the name of the INSTALL.  E.g "XU*8.0*1019"
 ;
 N ADSY,INST
 ;
 S INST=0
 ;
 ;Find install entry and check if completed:
 S ADSY=0
 F  S ADSY=$O(^XPD(9.7,"B",ADSSTAL,ADSY)) Q:'ADSY  D
 . S:$P($G(^XPD(9.7,ADSY,0)),U,9)=3 INST=1
 ;
 ;Display message:
 D IMES(ADSSTAL,INST)
 ;
 Q INST
 ;
IMES(ADSSTAL,Y) ;Display message to screen
 ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_ADSSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 Q
