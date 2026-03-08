BDW10P6 ;ihs/cmi/maw - BDW Patch 6
 ;;1.0;IHS DATA WAREHOUSE;**6**;JAN 23, 2006;Build 60
 ;
ENV ;-- environment check
 I '$$INSTALLD("GIS*3.01*16") D SORRY(2)
 I '$$INSTALLD("BDW*1.0*5") D SORRY(2)
 I '$$INSTALLD("XU*8.0*1018") D SORRY(2)
 I '$$INSTALLD("DI*22.0*1018") D SORRY(2)
 ;I '$$INSTALLD("AG*7.1*13") D SORRY(2)
 Q
 ;
INSTALLD(BDGSTAL) ;EP - Determine if patch BDGSTAL was installed, where
 ; BDGSTAL is the name of the INSTALL.  E.g "AG*6.0*11".
 ;
 NEW BDGY,DIC,X,Y
 S X=$P(BDGSTAL,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 D IMES Q 0
 S DIC=DIC_+Y_",22,",X=$P(BDGSTAL,"*",2)
 D ^DIC
 I Y<1 D IMES Q 0
 I $P(BDGSTAL,"*",3)="" D IMES Q 1
 S DIC=DIC_+Y_",""PAH"",",X=$P(BDGSTAL,"*",3)
 D ^DIC
 S BDGY=Y
 D IMES
 Q $S(BDGY<1:0,1:1)
IMES ;
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_BDGSTAL_""" is"_$S(Y<1:" *NOT*",1:"")_" Present.",IOM))
 Q
SORRY(X) ;
 KILL DIFQ
 I X=3 S XPDQUIT=2 Q
 S XPDQUIT=X
 W *7,!,$$CJ^XLFSTR("Sorry....FIX IT!",IOM)
 Q
PRE ;
 ;change option names to remove HOPE
 D RENAME^XPDMENU("BDWH HOPE GENERATE TXS","BDWH PRESCRIPTION GENERATE TXS")
 D RENAME^XPDMENU("BDWH DISPLAY HOPE EXPORT LOG","BDWH DISP PRESCRIPTION LOG")
 D RENAME^XPDMENU("BDWH HOPE PARAMETER EDIT","BDWH PRESRIPTION PARM EDIT")
 D RENAME^XPDMENU("BDWH QUEUE HOPE EXPORT","BDWH QUEUE PRESCRIPTION EXPORT")
 D RENAME^XPDMENU("BDWH RESET HOPE LOG","BDWH RESET PRESCRIPTION LOG")
 Q
 ;
POST ;post init
 N SEGCHK,SEG,MESS
 K DIC,DA,DR,D0,DO
 D PRIO
 D GIS
 S SEG=$O(^INTHL7S("B","HL IHS DW1ALPMR OBX IFC",0))
 Q:'SEG
 S SEGCHK=$$CHKSEG(SEG)
 I SEGCHK D
 . D CLNSEG(SEG)
 . D UPDSEG(SEG)
 . S MESS=$O(^INTHL7M("B","HL IHS DW1 A08",0))
 . I MESS D COMPILE^BHLU(MESS)
 . D RXPORT
 . D CLNADW
 D FIXMENU  ;ADD BDWHMENU to BDWMENU, add order to others
 D ASKPARM1
 Q
 ;
PRIO ;-- set the priority on HL IHS DW1HOPE O01 OUT CHILD and PARENT to 5
 N TT,TTP
 S TT=$O(^INRHT("B","HL IHS DW1HOPE O13 OUT CHILD",0))
 Q:'TT
 S TTP=$O(^INRHT("B","HL IHS DW1HOPE O13 OUT PARENT",0))
 Q:'TTP
 F I=TT,TTP S DIE="^INRHT(",DA=I,DR=".14///5;.16///5" D ^DIE
 Q
 ;
FIXMENU ;
 S X=$$ADD^XPDMENU("BDWMENU","BDWHMENU","PREX",97)
 S X=$$ADD^XPDMENU("BDWMENU","BDW REFLAG PATIENT FOR EXPORT","RPE",91)
 S X=$$ADD^XPDMENU("BDWMENU","BDW INT MARK VISIT FOR EXPORT","UXP",92)
 ;fix misspelled option text
 NEW DA,DIE,DR
 S DA=$O(^DIC(19,"B","BDW INT MARK VISIT FOR EXPORT",0))
 I DA S DIE="^DIC(19,",DR="1///Search Visits and Mark Unexported Visits" D ^DIE K DA,DIE,DR
 Q
ASKPARM ;EP
 ;If there is nothing in the multiple, stuff all outpatient site entries
 ;and default to NO
 NEW BDWS,BDWC
 Q:'$D(^BDWSITE(1,0))
 Q:'$O(^PS(59,0))  ;NO PHARMACIES
 D
 .S BDWS=0,BDWC=0 F  S BDWS=$O(^PS(59,BDWS)) Q:BDWS'=+BDWS  D
 ..Q:$$VAL^XBDIQ1(59,BDWS,2004)]""
 ..;ADD TO MULTIPLE AND CALL FILEMAN TO REINDEX WHOLE ENTRY
 ..Q:$D(^BDWSITE(1,21,BDWS,0))  ;already there
 ..S ^BDWSITE(1,21,BDWS,0)=BDWS_U_0
 ..S ^BDWSITE(1,21,"B",BDWS,BDWS)=""
 ..S BDWC=BDWC+1
 .S ^BDWSITE(1,21,0)="^90212.121P^"_BDWS_"^"_BDWC  ;7^2"
 S DA=1,DIK="^BDWSITE(" D IXALL^DIK
 D EN^DDIOL(" ")
 D EN^DDIOL(" ")
 D EN^DDIOL("For each Pharmacy in the Pharmacy Outpatient Site file you must respond")
 D EN^DDIOL("as to whether the pharmacy wants to enable prescription data to be")
 D EN^DDIOL("exported to the national reporting database at the National ")
 D EN^DDIOL("Data Warehouse to support the HOPE and other opioid initiatives.")
 D EN^DDIOL(" ")
 D EN^DDIOL("If you are NOT sure, please set the parameter to NO - Do not enable the export.")
 S DIR(0)="E",DIR("A")="Press ENTER to continue" KILL DA D ^DIR KILL DIR
 S DA=1,DDSFILE=90212.1,DR="[BDWH HOPE PARAMETER EDIT]" D ^DDS K DA,DDS,DR
 Q
 ;
CHKSEG(SEGI) ;-- lets check the fields in the HL IHS DW1ALPMR OBX IFC segment
 N FDA
 S FDA=0 F  S FDA=$O(^INTHL7S(SEGI,1,FDA)) Q:'FDA!($G(FXSG))  D
 . I '$P($G(^INTHL7S(SEGI,1,FDA,0)),U) S FXSG=1
 Q $G(FXSG)
 ;
CLNSEG(SEGI) ;update the segment
 N SDA
 S SDA=0 F  S SDA=$O(^INTHL7S(SEGI,1,SDA)) Q:'SDA  D
 . K ^INTHL7S(SEGI,1,SDA,0)
 K ^INTHL7S(SEGI,1,0)
 K ^INTHL7S(SEGI,1,"AS")
 K ^INTHL7S(SEGI,1,"B")
 Q
 ;
UPDSEG(SEGI) ;update the segment
 N I,FLDI,FSEQ
 F I="HL IHS DW1ALPMR OBX IFC-1","HL IHS DW1ALPMR OBX IFC-2","HL IHS DW1ALPMR OBX IFC-5" D
 . S FLDI=$O(^INTHL7F("B",I,0))
 . Q:'FLDI
 . S FSEQ=$P(I,"-",2)
 . N FDA,FIENS,FERR
 . S FIENS="+2,"_SEGI_","
 . S FDA(4010.01,FIENS,.01)=FLDI
 . S FDA(4010.01,FIENS,.02)=FSEQ
 . D UPDATE^DIE("","FDA","FIENS","FERR(1)")
 Q
 ;
RXPORT ;-- mark IFC for export
 N RDA,RIEN,ST
 S RDA=3150430.9999 F  S RDA=$O(^AUPNVSIT("B",RDA)) Q:'RDA  D
 . S RIEN=0 F  S RIEN=$O(^AUPNVSIT("B",RDA,RIEN)) Q:'RIEN  D
 .. Q:'$O(^AUPNVIF("AD",RIEN,0))
 .. S ^AUPNVSIT("ADWO",DT,RIEN)=""
 S ST=$O(^BDWSITE("B",DUZ(2),0))
 Q:'ST
 S ^BDWSITE(ST,9999999)=1
 Q
 ;
CLNADW ;clean up duplicates in ADWO
 N ADA,AIEN
 S ADA=0 F  S ADA=$O(^AUPNVSIT("ADWO",ADA)) Q:'ADA  D
 . S AIEN=0 F  S AIEN=$O(^AUPNVSIT("ADWO",ADA,AIEN)) Q:'AIEN  D
 .. I $D(^TMP("BDWH",$J,AIEN)) K ^AUPNVSIT("ADWO",ADA,AIEN) Q
 .. S ^TMP("BDWH",$J,AIEN)=1
 K ^TMP("BDWH",$J)
 Q
 ;
GIS ;-- run the importer
 D MPORT^BHLU
 K ^INXPORT
 Q
 ;
ASKPARM1 ;EP
 ;If there is nothing in the multiple, stuff all outpatient site entries
 ;and default to NO
 NEW BDWS,BDWC,Y,DIR,DA,X,Z,BDWI
 Q:'$D(^BDWSITE(1,0))
 Q:'$O(^PS(59,0))  ;NO PHARMACIES
 D
 .S BDWS=0,BDWC=0 F  S BDWS=$O(^PS(59,BDWS)) Q:BDWS'=+BDWS  D
 ..Q:$$VAL^XBDIQ1(59,BDWS,2004)]""
 ..;ADD TO MULTIPLE AND CALL FILEMAN TO REINDEX WHOLE ENTRY
 ..Q:$D(^BDWSITE(1,21,BDWS,0))  ;already there
 ..S ^BDWSITE(1,21,BDWS,0)=BDWS_U_0
 ..S ^BDWSITE(1,21,"B",BDWS,BDWS)=""
 ..S BDWC=BDWC+1
 .S ^BDWSITE(1,21,0)="^90212.121P^"_BDWS_"^"_BDWC  ;7^2"
 S DA=1,DIK="^BDWSITE(" D IXALL^DIK
 ;D EN^DDIOL(" ")
 ;D EN^DDIOL(" ")
 D EN^DDIOL("For each Pharmacy in the Pharmacy Outpatient Site file you must provide")
 D EN^DDIOL("a response as to whether the pharmacy will enable prescription data")
 D EN^DDIOL("to be exported to the national reporting database at the National ")
 D EN^DDIOL("Data Warehouse to support the Heroin, Opioids and Pain Efforts (HOPE)")
 D EN^DDIOL("and other opioid initiatives.")
 D EN^DDIOL(" ")
 D EN^DDIOL("Enabling this data export will assist local sites with extracting")
 D EN^DDIOL("data to create opioid surveillance strategy to monitor local opioid")
 D EN^DDIOL("and leverage utilization of timely, actionable data to inform")
 D EN^DDIOL("strategies and interventions.")
 D EN^DDIOL(" ")
 D EN^DDIOL("Federal sites MUST set the parameter to YES - Enable the export.")
 D EN^DDIOL("Tribal and Urban sites must verify with site leadership/Health Director")
 D EN^DDIOL("prior to setting the parameter to Yes.")
 D EN^DDIOL(" ")
 D EN^DDIOL("If you are NOT sure, please set the parameter to NO - Do not enable export.")
 S DIR(0)="E",DIR("A")="Press ENTER to continue" KILL DA D ^DIR KILL DIR
 ;
W ;
 D EN^DDIOL("PHARMACY OUTPATIENT SITE",,"!?4")
 D EN^DDIOL("ENABLE PRESCRIPTION EXPORT?",,"?36")
 ;D EN^DDIOL("------------------------",,"!?5")
 ;D EN^DDIOL("---------------------------",,"?36")
 ;D EN^DDIOL("","","!")
 K BDWS
 S BDWC=0
 S X=0 F  S X=$O(^BDWSITE(1,21,X)) Q:X'=+X  D
 .S BDWC=BDWC+1
 .S BDWS(BDWC)=X
 .S Y=$P(^BDWSITE(1,21,X,0),U,2)
 .S $P(BDWS(BDWC),U,2)=Y
 .S Y=$S(Y:"YES, ENABLE EXPORT",1:"NO, DO NOT ENABLE EXPORT")
 .S Z=""
 .S $E(Z,2)=BDWC_") "_$P(^PS(59,X,0),U,1),$E(Z,37)=Y
 .D EN^DDIOL(Z,"","!")
 ;ASK WHICH ONE TO EDIT
W1 ;
 ;D EN^DDIOL("","","!")
 K DIR
 S DIR(0)="S^E:Edit a Pharmacy's Parameter Setting;Q:Quit"
 S DIR("A")="Which action",DIR("B")="E" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I Y="Q" Q
 ;GET WHICH ONE
 S BDWI=""
 S DIR(0)="N^1:"_BDWC_":0",DIR("A")="Edit Which one" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G W
 S BDWI=Y
 S DA=$P(BDWS(BDWI),U,1)
 D EN^DDIOL($P(^PS(59,DA,0),U,1),,"!!")
 S DA(1)=1,DR=".02"
 S DIE="^BDWSITE("_DA(1)_",21,",DIE("NO^")=1
 D ^DIE
 K DIE,DA
 G W
