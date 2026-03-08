RAAFCV ;IHS/HQW/SCR - ATS conversion ;[ 11/23/2001  9:02 AM ]
 ;;4.0;RADIOLOGY;**10**;NOV 20, 1997
 ;
 ;HISC/CAH-Allergy data conversion; 12/28/93 13:05
 ;
 ;This routine performs the ATS file update required for completion
 ;of Radiology patch 10. ENQ^RAAFCV is called from ^RA410CNV
 ;which is intended to be a post-init routine for RA*4.0*10 called
 ;only after the **MOCK** conversion has completed. ^RA410MCK is the
 ;pre-init routine for RA*4.0*10 that sets flags that indicate the
 ;**MOCK** ATS conversion has completed.
 ;
 ;This is original VA code, modified to write to screen instead of
 ;sending a mail bulletin at completion. The conversion is not 
 ;tasked for IHS RA*4.0*10 
EN ;     
 I '$D(DUZ) W *7,!,"Sorry, cannot proceed unless DUZ is defined" Q
 I $G(DUZ(0))'="@" W *7,!,"Sorry, you do not have programmer access.",! Q
 S X="GMRARAD" X ^%ZOSF("TEST") I '$T D  Q
 . W *7,!,"WARNING:  Allergy Tracking System Patch GMRA*3*4 is not installed!",!,"Make sure the Allergy Tracking System and all patches through GMRA*3*4 are",!,"installed before proceeding with this conversion.",!! Q
 W !,"This routine will start up a background task to convert Radiology contrast",!,"medium allergy data to the Allergy Tracking System."
 W !!,"Beginning conversion of Radiologic contrast media allergy data to the",!,"Allergy Tracking System. You will receive a mail message at completion.",!
 S RADUZ=DUZ,ZTRTN="ENQ^RAAFCV",ZTDTH=$H,ZTSAVE("RADUZ")=RADUZ,ZTDESC="Rad/NucMed Allergy Conversion",ZTIO="" K ZTSK D ^%ZTLOAD D HOME^%ZIS
 W ! W:$D(ZTSK) "  Task Number ",ZTSK W:'$D(ZTSK) !,*7,"Error - Task Man will not queue this request"
 K ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE,ZTSK,RADUZ
 Q
ENQ ;EP
 ;Entry point for IHS patch 10 ATS conversion. NOT tasked. IHS/HQW/SCR 10/25/01 **10**
 ;
 ;Entry point for tasked conversion job.
 ;This routine steps through every Radiology Patient in file 70. If the
 ; .05 Contrast Medium Allergy field is set to "Y", an Allergy Tracking
 ; function is called to add this allergy to ATS.  Conversely, this
 ; same patient is looked up in ATS, and, if Contrast medium allergy
 ; exists, it will be marked in Radiology.
 ;
 ;
 S RACNT=0,RADUZ=DUZ   ;IHS/HQW/SCR 10/25/01 **10**
 S RAAF18="1^RA*4*10 CONVERSION TO ATS" S GMRACAUS="RADIOLOGICAL/CONTRAST MEDIA",GMRADRCL=$O(^PS(50.605,"B","DX100",0))_";PS(50.605,"
 ;S RAZTSK=$G(ZTSK) 
 S DFN=0 F  S DFN=$O(^RADPT(DFN)) Q:DFN'>0  D
 .Q:$D(^RA("IHSPATCH10","VA_ATS_CONVERSION",DFN))  ;already processed  
 .S RAX1=-1,RAX=$G(^RADPT(DFN,0)) I $E($P(RAX,U,5),U,1)="Y" S RAX1=$$RADD^GMRARAD(DFN,"h","Y",1)  ; convert Radiology into ATS
 .S GMRADA=0 I $D(^GMR(120.8,"B"))&(RAX1'>0) F  S GMRADA=$O(^GMR(120.8,"B",DFN,GMRADA)) Q:GMRADA'>0  I $$RALLG^GMRARAD(GMRADA) Q  ;find any Radiology allergies in ATS
 .I GMRADA>0 D ALLERGY^RAUTL3(DFN,"Y") ; if Rad allergy in ATS, set into Radiology
 .S ^RA("IHSPATCH10","VA_ATS_CONVERSION",DFN)="",RACNT=RACNT+1 ;mark this DFN "done" IHS/HQW/SCR 10/25/01 **10**
 .W:(RACNT#100=0) "."  ;IHS/HQW/SCR 10/25/01 **10**
 S ^RA("IHSPATCH10","VA_ATS_CONVERSION",0)="DONE"  ;IHS/HQW/SCR 10/25/01 **10**
 D BULL
 K RAZTSK,DFN,RADUZ,X,X1,XMY,XMDUZ,XMSUB,XMTEXT,R,RAX,RAX1,GMRADA,GMRACAUS,GMRADRCL,RAAF18
 Q
BULL ;
 ;This sub-routine has been modified to write to screen as well as
 ;sending a mail message to user for IHS patch 10 
 ;IHS/HQW/SCR 10/25/01 **10**
 ;
 D BMES^XPDUTL("**CONTRAST MEDIA ALLERGY data conversion COMPLETED SUCCESSFULLY.***")  ;IHS/HQW/SCR 10/25/01 **10**
 ;
 ;Send Mail message to user signed on
 N DIFROM
 S XMY(RADUZ)="",XMDUZ=.5,XMSUB="Radiology Allergy Data Conversion"
 S R(1)="Contrast Media Allergy data conversion completed successfuly."
 S XMTEXT="R(" D ^XMD Q
 ;
 Q
