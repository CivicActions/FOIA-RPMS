ADS1P03 ;IHS/GDIT/AEF-ADS Version 1.0 Patch 3 Post Install
 ;;1.0;DISTRIBUTION MANAGEMENT;**3**;Apr 23, 2020;Build 15
 ;
ENV ;EP - Environmental Checking Routine
 ;
 N VERSION,EXEC,BMWDT,LIEN
 ;
 ;Check for ADS*1.0*2
 I '$$INSTALLD("ADS*1.0*2") D BMES^XPDUTL("Version 1.0 Patch 2 of ADS is required!") S XPDQUIT=2 Q
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
 ;
POST ;EP - Post install entry point
 ;Run the Sign-On Log data extract from 1-1-2020 to now
 ;
 N FDA,IEN
 ;
 ;Update parameters file:
 D BMES^XPDUTL("Updating ADS Parameters file...")
 ;Create initial entry 1 if it does not exist:
 I '$D(^ADSPARM(1)) D
 . S IEN(1)=1
 . S FDA(9002292,"+1,",.01)=1
 . D UPDATE^DIE("","FDA","IEN","ERR")
 . K FDA
 ;Update fields:
 S FDA(9002292,"1,",11.3)=1         ;turn on switch
 S FDA(9002292,"1,",11.4)=5         ;set extract day of week to THURSDAY
 D UPDATE^DIE("","FDA","IEN","ERR")
 ;
 ;Run initial SO extract:
 D RUNEXT
 ;
 Q
RUNEXT ;
 ;----- RUN INITIAL SIGN-ON EXTRACT FROM 1-1-2020
 ;
 N ADS,BEG,DATE,END,X,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK
 ;
 D BMES^XPDUTL("Scheduling initial Sign-on Log extract...")
 ; 
 ;Get beginning, ending dates:
 ;S BEG=$$FMADD^XLFDT(DT,-183)  ;6 MONTHS AGO, FOR ALPHA TESTING
 S BEG=$$FMADD^XLFDT(DT,-30)    ;1 MONTH AGO
 S BEG=$$FMADD^XLFDT(BEG,-1)_".99999999"
 S END=$$FMADD^XLFDT(DT-1)_".99999999"
 S ADS("DTS")=BEG_U_END
 ;
 ;Get Thursday date:
 S DATE=DT
 S X=DATE D DW^%DTC
 I X'="THURSDAY" D
 . F  S DATE=$$FMADD^XLFDT(DATE,1),X=DATE D DW^%DTC Q:X="THURSDAY"
 I DATE'=DT S DATE=DATE_".18"
 E  D
 . I DATE=DT S DATE=$$NOW^XLFDT
 . I $E($P(DATE,".",2),1,2)<18 S $P(DATE,".",2)=18
 ;
 ;Queue the extract:
 S ZTRTN="DQ^ADS1P03"
 S ZTDESC="Initial Sign-on Log Extract"
 S ZTSAVE("ADS(")=""
 S ZTDTH=DATE
 S ZTIO=""
 D ^%ZTLOAD
 I $D(ZTSK) D
 . D BMES^XPDUTL("TASK #"_ZTSK_" queued to run on "_$$FMTE^XLFDT(DATE))
 Q
DQ ;----- QUEUED JOB STARTS HERE
 ;Called from RUNEXT above with ADS array set
 ;
 D DOIT^ADSSOL(.ADS)
 ;
 Q
INSTALLD(ADSSTAL) ;EP - Determine if patch ADSSTAL was installed, where
 ; ADSSTAL is the name of the INSTALL.  E.g "XU*8.0*1019"
 ;
 N ADSY,INST
 ;
 S INST=0
 ;Get install IEN from Install file:
 S ADSY=$O(^XPD(9.7,"B",ADSSTAL,""))
 ;
 ;Check if install completed:
 I ADSY>0 D
 . Q:$P($G(^XPD(9.7,ADSY,0)),U,9)='3
 . S INST=1
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
