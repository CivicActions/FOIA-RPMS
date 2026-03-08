BDWHBHL1 ; IHS/CMI/LAB - BDWH Driver Cont ; 20 Feb 2019  11:23 AM
 ;;1.0;IHS DATA WAREHOUSE;**6**;JAN 23, 2006;Build 60
 ;       
 ;
BULL ;EP - called from BDWHBHL to send bulletin
 NEW XMSUB,XMDUZ,XMTEXT,XMY,BDWC,BDWBUL
 KILL BDWBUL
 S XMY(DUZ)=""
 D WRITEMSG
SUBJECT S XMSUB="* PRESCRIPTION EXPORT PROCESSING COMPLETE *"
SENDER S XMDUZ="Prescription Export System"
 S XMTEXT="BDWHBUL("
 D ^XMD
 KILL BDWHBUL
 Q
 ;
WRITEMSG ;
 S BDWC=0
 S X="*********** Prescription EXPORT SYSTEM *************" D SET
 S X="This message is to inform you that the process has completed" D SET
 S X="and the file has been written to the export directory for" D SET
 S X=BDWDESC D SET
 S X=" " D SET
 I $G(BDWSFLG) D
 .S X="The autoftp to the data warehouse FAILED." D SET
 .S X="You will need to manually ftp the file named "_BDWPAFN D SET
 .S X="to the data warehouse." D SET
 Q
 ;;  
SET ;
 S BDWC=BDWC+1
 S BDWBUL(BDWC)=X
 Q
AUTOSEND ;EP
 S BDWSFLG=$$SENDTO1^ZISHMSMU("DATA WAREHOUSE SEND",BDWPAFN)
 S BDWSFLG(1)=$P(BDWSFLG,"^",2)
 S BDWSFLG=+BDWSFLG
 Q:$D(ZTQUEUED)
 I BDWSFLG'=0 D
 . W:'$D(ZTQUEUED) !,"Prescription HL7 file was NOT successfully transferred to the data warehouse",!,"you will need to manually ftp it.",!
 . W:'$D(ZTQUEUED) !,BDWSFLG(1),!!
 ;
 Q
 ;
