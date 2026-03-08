RAHLCV1 ;IHS/HQW/SCR - Continuation of VA routine RAHLCV   [ 11/21/2001  2:38 PM ]
 ;;4.0;RADIOLOGY;**10**;Nov 20, 1997
 ;
 ;This routine is a VA routine called by RAHLCV that performs the 
 ;HL7 conversion needed to install RA patch 11.
 ;
 ;HISC/CAH;Continuation of RAHLCV HL7 conversion rtn
 ;;4.0;RADIOLOGY;**25**;Feb 24, 1992
 ;
OPTDEL ;EP - called by RAHLCV
 ;Delete old Radiology HL7 options
 K RAOPT S RAXNAME="RAHL" F  S RAXNAME=$O(^DIC(19,"B",RAXNAME)) Q:RAXNAME]"RAHLZZ"  S RAOPTIEN=$O(^DIC(19,"B",RAXNAME,0)) Q:RAOPTIEN'?1N.N  S RAOPT(RAOPTIEN)=RAXNAME
 I '$D(RAOPT) D MSG9B Q
 I $D(RAOPT) S RAIEN=0 F  S RAIEN=$O(RAOPT(RAIEN)) Q:RAIEN'?1N.N  D  
 .S RAXNAME=RAOPT(RAIEN)
 .I $D(^DIC(19,"AD",RAIEN)) D  
 .. S RAX=0 F  S RAX=$O(^DIC(19,"AD",RAIEN,RAX)) Q:RAX'>0  D  
 ... S RAY=0  F  S RAY=$O(^DIC(19,"AD",RAIEN,RAX,RAY)) Q:RAY'>0  D  
 .... S RAZ=$P($G(^DIC(19,RAX,0)),"^"),DA(1)=RAX,DA=RAY
 .... S DIK="^DIC(19,"_DA(1)_",10," D ^DIK K DA,DIK
 .... W "." I RAZ'["RAHL" D MSG9C
 .... Q
 ... Q
 .. Q
 . K DA,DIK,RAX,RAY,RAZ S DA=RAIEN,DIK="^DIC(19,"
 . I $D(^VA(200,"AP",DA)) S RAUSER=0 F  S RAUSER=$O(^VA(200,"AP",DA,RAUSER)) Q:'RAUSER  S RAUSER1=$P($G(^VA(200,RAUSER,0)),U,1) I $L(RAUSER1) D MSG9D
 . I $D(^VA(200,"AD",DA)) S RAUSER=0 F  S RAUSER=$O(^VA(200,"AD",DA,RAUSER)) Q:'RAUSER  S RAUSER1=$P($G(^VA(200,RAUSER,0)),U,1) I $L(RAUSER1) D MSG9E
 . D ^DIK K DA,DIK
 D MSG9A W "." K DIK,DA,RAOPT,RAXNAME,RAOPTIEN Q
 ;
MSG1 ;EP - called by RAHLCV
 S RAMSG="Conversion of File 77.1 to File 771 not attempted: File 77.1 doesn't exist." D MSGSET Q
MSG2 ;EP - called by RAHLCV
 S RAMSG="No Radiology entry in File 77.1 to convert." D MSGSET Q
MSG2A ;EP - called by RAHLCV
 S RAMSG="RADIOLOGY application entry added to File 771." D MSGSET Q
MSG3 ;EP - called by RAHLCV
 S RAMSG="You already have a Radiology entry in File 771" D MSGSET Q
MSG4 ;EP - called by RAHLCV
 S RAMSG="ERROR: Could not convert all Msgs Used in File 77.1 to matching entry in File 771.2 - Compare file 771.2 entries to File 77.1 printout and use FileMan to add missing Msgs." D MSGSET Q
MSG4A ;EP - called by RAHLCV
 S RAMSG="Conversion of File 77.1 entries to File 771 completed." D MSGSET Q
MSG5 ;EP - called by RAHLCV
 S RAMSG="No entries in File 77.2 to convert." D MSGSET Q
MSG6 ;EP - called by RAHLCV
 S RAMSG="File 77.2 entry "_RANAME_" already exists in file 770." D MSGSET Q
MSG7 ;EP - called by RAHLCV
 S RAMSG="ERROR: File 77.2 entry "_RANAME_" cannot be moved to file 770 - missing identifier(s)." D MSGSET Q
MSG8 ;EP - called by RAHLCV
 S RAMSG="Conversion of File 77.2 entries to File 770 completed." D MSGSET Q
MSG9 ;EP - called by RAHLCV
 S RAMSG="Deletion of old Radiology HL7 files (77-77.6) completed." D MSGSET Q
MSG9A ;EP - called by RAHLCV
 S RAMSG="Old Radiology HL7 options deleted." D MSGSET Q
MSG9B ;EP - called by RAHLCV
 S RAMSG="No Old Radiology HL7 options to delete." D MSGSET Q
MSG9C ;EP - called by RAHLCV
 S RAMSG="  Option "_RAZ_" no longer has "_RAXNAME_" as an item." D MSGSET Q
MSG9D ;EP - called by RAHLCV
 S RAMSG="  *"_RAUSER1_" had "_RAXNAME_" as a primary menu option. Please edit/change this user's primary menu option." D MSGSET Q
MSG9E ;EP - called by RAHLCV
 S RAMSG="  *"_RAUSER1_" had "_RAXNAME_" as a secondary menu option. Please review this user's secondary menu options." D MSGSET Q
MSG10 ;EP - called by RAHLCV
 S RAMSG="Rad HL7 to DHCP HL7 Conversion completed." D MSGSET Q
MSGSET ;
 S ERCNT=ERCNT+1,^TMP($J,"RAHLCV",ERCNT)=RAMSG Q
