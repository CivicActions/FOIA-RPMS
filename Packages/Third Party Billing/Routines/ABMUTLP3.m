ABMUTLP3 ; IHS/SD/SDR - PAYER UTILITIES ;      
 ;;2.6;IHS 3P BILLING SYSTEM;**31**;NOV 12, 2009;Build 615
 ;new routine abm*2.6*31
 ;IHS/SD/SDR 2.6*31 CR8848 Created GENDER tag to retrieve gender from Medicare/Railroad/Medicaid eligibility files
 ;
 ;******************************************
GENDER ;EP
 I ((ABME("ITYPE")="R")&($P($G(^AUTNINS(ABME("INS"),0)),U)["RAILROAD")) D
 .S ABMT("IEN")=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0)),U,5)
 .Q:'ABMT("IEN")
 .S ABMP("SEX",ABME("INS#"))=$P($G(^AUPNRRE(ABMP("PDFN"),11,ABMT("IEN"),0)),U,8)
 ;
 I ((ABME("ITYPE")="R")&($P($G(^AUTNINS(ABME("INS"),0)),U)["MEDICARE")) D
 .S ABMT("IEN")=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,I,0)),U,4)
 .Q:'ABMT("IEN")
 .S ABMP("SEX",ABME("INS#"))=$P($G(^AUPNMCR(ABMP("PDFN"),11,ABMT("IEN"),0)),U,8)
 ;
 I ((ABME("ITYPE")="D")!(ABME("ITYPE")="K")) D  ;ABMCDNUM
 .Q:+$G(ABMCDNUM)=0
 .S ABMP("SEX",ABME("INS#"))=$P($G(^AUPNMCD(ABMCDNUM,0)),U,7)
 ;
 ;default to VA Patient file gender
 I $G(ABMP("SEX",ABME("INS#")))="" S ABMP("SEX",ABME("INS#"))=$P($G(^DPT(ABMP("PDFN"),0)),U,2)
 Q
