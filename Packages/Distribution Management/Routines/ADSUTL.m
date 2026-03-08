ADSUTL ;IHS/GDIT/AEF - ADS UTILITY ROUTINE
 ;;1.0;DISTRIBUTION MANAGEMENT;**3,5,6**;Apr 23, 2020;Build 8
 ;New routine
 ;
 ;Feature #81455:
 ;The ADSLRPT and ADSFAC routines exceeded 15k so some code was 
 ;moved here.
 ;
DESC ; ROUTINE DESCRIPTION
 ;;
 ;;This routine contains utility subroutines used by the ADS package.
 ;;
 ;;$$END
 N I,X F I=1:1 S X=$P($T(DESC+I),";;",2) Q:X["$$END"  D EN^DDIOL(X)
 Q
CNTR(TEXT,WIDTH) ;
 ;----- CENTER TEXT IN WIDTH
 ;Code moved here from ADSLRPT ;Feature #81455
 ;
 N RET,RL,TL
 ;
 ;Handle no breaking
 S:WIDTH>132 WIDTH=132
 ;
 S TL=$L(TEXT)\2
 ;
 S $P(RET," ",WIDTH)=" "
 S RL=$L(RET)\2
 S $E(RET,(RL-TL)+1,(RL-TL)+$L(TEXT))=TEXT
 Q RET
 ;
SD() ;----- ASK SUMMARY/DETAIL
 ;Code moved here from ADSLRPT ;Feature #81455
 ;
 N DIR,DIROUT,DIRUT,X,Y
 ;
 S Y=""
 S DIR(0)="SO^S:Summary;D:Detail"
 S DIR("A")="Display log summary or detail"
 S DIR("B")="Summary"
 D ^DIR
 S Y=$G(Y)
 ;I Y'="S",Y'="D" Q
 Q Y
WIDTH() ;
 ;----- ASK REPORT WIDTH
 ;Code moved here from ADSLRPT ;Feature #81455
 ;
 N DIR,DIROUT,DIRUT,X,Y
 ;
 W !!,"Choose the report page width. Note that the report will display much better"
 W !,"when exported or in 132 character wide mode",!
 S DIR(0)="SO^S:Standard (80);W:Wide (132);E:Export (No Breaks)"
 S DIR("A")="Select the report page width"
 S DIR("B")="Wide (132)"
 D ^DIR
 S Y=$G(Y)
 I Y'="S",Y'="W",Y'="E" Q WIDTH=""
 I Y="S" S WIDTH=80
 E  I Y="W" S WIDTH=132
 E  S WIDTH=99999
 Q WIDTH
FACILITY() ;
 ;----- GET DEFAULT FACILITY SITE #
 ;Code moved from ADSFAC and modified
 ;
 N FAC
 S FAC=$P($$SITE^VASITE(),U,3)
 I FAC="" S FAC="*Unknown*"
 Q FAC
 ;
MCNTR(SITE) ;
 ;----- RETURN FIRST MEDICAL CENTER NAME FOR INSTITUTION
 ;Moved from ADSFAC
 ;
 I $G(SITE)="" Q ""
 ;
 NEW RET,MCIEN,QUIT
 ;
 S (RET,MCIEN)="" F  S MCIEN=$O(^DG(40.8,"AD",SITE,MCIEN)) Q:MCIEN=""  D  Q:RET]""
 . NEW MNAME
 . S MNAME=$$GET1^DIQ(40.8,MCIEN_",",.01,"E") ;Medical Center Name
 . Q:MNAME=""
 . S RET=MNAME
 ;
 Q RET
ASSOC(SITE,RTIEN) ;
 ;----- RETURN ASSOCIATION INFORMATION
 ;Moved code from ADSFAC
 ;
 I $G(SITE)="" Q ""
 ;
 NEW RET,AIEN
 ;
 S RTIEN=$G(RTIEN)
 ;
 S RET=""
 ;
 S AIEN=0 F  S AIEN=$O(^DIC(4,SITE,7,AIEN)) Q:'AIEN  D  Q:RET]""
 . NEW ASSOC,PASSOC,DA,IENS,REC,IASSOC
 . S DA(1)=SITE,DA=AIEN,IENS=$$IENS^DILF(.DA)
 . S IASSOC=$$GET1^DIQ(4.014,IENS,1,"I") Q:IASSOC=""
 . S ASSOC=$$GET1^DIQ(4.014,IENS,.01,"E") Q:ASSOC'="PARENT FACILITY"
 . S PASSOC=$$GET1^DIQ(4.014,IENS,1,"E") Q:PASSOC=""
 . S REC=ASSOC_"~"_PASSOC_$S(RTIEN:"~"_IASSOC,1:"")
 . S RET=RET_$S(RET]"":"&",1:"")_REC
 ;
 Q RET
SITE() ;
 ;----- GET SITE ASUFAC AND DBID
 ;Moved code from ADSFAC
 ;Returns ASUFAC^DBID^RPMSLOC^GUID^DOMAIN
 ;EXAMPLE:
 ;202101^99999^2549^580A389D-7E49-46F0-B7FB-E4EAB34350B6^FACILITY-X-HQ.ABQ.IHS.GOV
 ;
 N ADOM,ASUFAC,DBID,GUID,RSIEN,RSLOC
 ;
 ;Get location from RPMS SITE
 S RSIEN=$O(^AUTTSITE(0)) I RSIEN="" Q ""
 S RSLOC=$$GET1^DIQ(9999999.39,RSIEN_",",.01,"I") I RSLOC="" Q ""
 ;
 ;Get site ASUFAC and DBID
 S ASUFAC=$$GET1^DIQ(9999999.06,RSLOC_",",.12,"E")
 S DBID=$$GET1^DIQ(9999999.06,RSLOC_",",.32,"E")
 ;
 ;-- Begin new code; IHS/GDIT/AEF ADS*1.0*6 FID110314
 ;Get GUID:
 S GUID=##Class(%SYS.System).InstanceGUID()
 ;
 ;Get Domain name:
 S ADOM=$$GET1^DIQ(8989.3,"1,",.01,"I")
 I ADOM S ADOM=$$GET1^DIQ(4.2,ADOM_",",.01,"E")
 ;
 ;Return values
 Q ASUFAC_U_DBID_U_RSLOC_U_GUID_U_ADOM
 ;-- End new code; IHS/GDIT/AEF/ADS*1.0*6 FID110314
 ;
FMTE(X) ;
 ;----- CONVERT FM DATE/TIME TO 'MMM DD, CCYY HH:MM:SS' FORMAT
 ;
 ;Will return the date/time in MAY 26, 2022 17:22:23 format.
 ;(will append :00 if there are no minutes after the hour,
 ;this is what DTS needs).
 Q $$FMTE^BSTSUTIL(X)
 ;
UPDTLOG(ADSDT,TYPE,CNT) ;IHS/GDIT/AEF ADS*1.0*6 FID107834 - NEW SUBROUTINE
 ;----- UPDATE THE ADS EXPORT LOG FILE
 ;
 N ERR,FDA,IEN
 ;
 ;Update the ADS EXPORT LOG file:
 S FDA(9002292.1,"+1,",.01)=ADSDT
 S FDA(9002292.1,"+1,",.02)=TYPE
 S FDA(9002292.1,"+1,",.03)=CNT
 D UPDATE^DIE("","FDA","IEN","ERR")
 Q
