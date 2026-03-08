ADSTASK ;IHS/GDIT/AEF - Various tasked jobs
 ;;1.0;DISTRIBUTION MANAGEMENT;**6**;Apr 23, 2020;Build 8
 ;
 ;IHS/GDIT/AEF ADS*1.0*6 FID107605
 ;New routine
 ;Code is moved here from ADSFAC because ADSFAC exceeded SAC size limit
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;;This routine is used to queue various background export tasks. 
 ;; 
 ;;$$END
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
TASK ;EP - Front end for ADS nightly export task
 ;IHS/GDIT/AEF ADS*1.0*6 FID107605 - Update report processing
 ;This routine is rewritten to queue each job as a separate background
 ;job. 
 ;It is done this way so that if one report bombs, then the rest of the
 ;reports will still run since they are queued separately.
 ;Each job will be queued to start 15 minutes later than the previous one.
 ;
 ;This tag is called by the TASK^ADSFAC routine.
 ;
 ;It runs the following ADS exports:
 ;- ASUFAC export
 ;- ADS Package Version Report
 ;- IZ Parameters
 ;- Sign-on Log export   ;IHS/GDIT/AEF 3/25/2022;ADS*1.0*3 Feature#84254
 ;- Routine Checksums    ;IHS/GDIT/AEF 9/19/2022;ADS*1.0*4 Feature#82446
 ;- Data Dictionary Checksums ;IHS/GDIT/AEF 7/18/23;ADS*1.0*5 Feature#80489
 ;
 N NOW15
 ;
 S NOW15=$$NOW^XLFDT
 ;
 ;Start background ADS Monitor:
 D QUE("ADS MONITOR","START^ADSMON",NOW15)
 ;
 ;Queue ASUFAC export:
 D QUE("ADS ASUFAC EXTRACT","EN^ADSFAC",NOW15)
 ;
 ;Queue LICENSE export:
 S NOW15=$$FMADD^XLFDT(NOW15,,,15)
 D QUE("ADS LICENSE EXPORT","EN^ADSRPT",NOW15)
 ;
 ;Queue Package Version export:
 S NOW15=$$FMADD^XLFDT(NOW15,,,15)
 D QUE("ADS PACKAGE VERSION EXPORT","EN^ADSPKG",NOW15)
 ;
 ;Queue IZ Parameters export:
 ;D EN^ADSIZPR
 S NOW15=$$FMADD^XLFDT(NOW15,,,15)
 D QUE("ADS IZ PARAMETERS EXPORT","EN^ADSIZPR",NOW15)
 ;
 ;Queue Sign-On Log export:
 ;IHS/GDIT/AEF 3/25/2022;ADS*1.0*3 Feature #83894 - Sign-on data to DTS
 S NOW15=$$FMADD^XLFDT(NOW15,,,15)
 D QUE("ADS SIGN-ON LOG EXPORT","AUTO^ADSSOL",NOW15)
 ;
 ;Queue Routine Checksum export:
 ;IHS/GDIT/AEF 9/19/2022;ADS*1.0*4 Feature #82446 - Routine checksum
 ;comparison.
 S NOW15=$$FMADD^XLFDT(NOW15,,,15)
 D QUE("ADS ROUTINE CHECKSUM EXPORT","AUTO^ADSRTNCS",NOW15)
 ;
 ;Queue Data Dictionary Checksum export:
 ;IHS/GDIT/AEF 7/18/2023;ADS*1.0*5 Feature #80489 - Data Dictionary Checksum
 ;comparison
 S NOW15=$$FMADD^XLFDT(NOW15,,,15)
 D QUE("ADS DATA DICTIONARY CHECKSUM EXPORT","AUTO^ADSDDCS",NOW15)
 ;
 ;Run the statistics export:
 D AUTO^ADSSTAT
 ;
 Q
QUE(ZTDESC,ZTRTN,ZTDTH) ;
 ;----- QUEUE THE BACKGROUND JOB
 ;
 N DESC,TIME,ZTIO,ZTSK
 ;
 S DESC=ZTDESC
 S TIME=ZTDTH
 S ZTIO=""
 D ^%ZTLOAD
 I '$D(ZTQUEUED) W !,"Task "_ZTSK_" "_DESC_" queued"_" for "_TIME
 ;
 Q
