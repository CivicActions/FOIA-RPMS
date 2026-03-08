BEHOEPIC ;GDIT/HS/BEE - EPCS Integrity Checking Compile;09-Nov-2022 09:54;PLS
 ;;1.1;BEH COMPONENTS;**070001,070003,070005**;Mar 20, 2007;Build 10
 ;
 Q
 ;
TASK ;EP - Entry point from BEHO Print/Compile Daily Summary Reports
 ;
 ;Log the entry to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","Started BEHO AUDIT SUMMARY NIGHTLY TASK for date: "_$$FMTE^XLFDT(DT)_"|TYPE~G|RSLT~S|||EP~EP|EPCS100|","","")
 ;
 ;Generate EPCS audit summary report and send via MailMan
 D EPCS
 ;
 ;Generate pharmacy audit summary report and send via MailMan
 D APSP
 ;
 ;Perform integrity check compile
 D COMP
 ;
 ;Log entry to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","Completed BEHO AUDIT SUMMARY NIGHTLY TASK for date: "_$$FMTE^XLFDT(DT)_"|TYPE~G|RSLT~S|||EP~EP|EPCS101|","","")
 ;
 Q
 ;
COMP ;Perform integrity check compile
 ;
 ;Quit if compile is currently running
 L +^XTMP("BEHOEPIC",0):1 E  Q
 ;
 NEW X1,X2,X,%H,TWOYRS,YR,BUSAIEN,BUSADT
 ;
 ;Get future date for ^XTMP
 S X1=DT,X2=60 D C^%DTC
 ;
 ;Update top level
 S ^XTMP("BEHOEPIC",0)=X_U_DT_U_"BEHO Audit Summary Integrity Compile"
 ;
 ;Get 2 years in past or first BUSAp1 Install
 S X1=DT,X2=-730 D C^%DTC S TWOYRS=X
 S BUSAIEN=$O(^XPD(9.7,"B","BUSA*1.0*1",""))
 S BUSADT="" I BUSAIEN]"" S BUSADT=$P($$GET1^DIQ(9.7,BUSAIEN_",",17,"I"),".")
 S:BUSADT>TWOYRS TWOYRS=BUSADT
 ;
 ;Perform BUSA Integrity Comp
 ;GDIT/HS/BEE 04192021;Moved to overflow routine
 ;D BIBUSA(TWOYRS)
 D BIBUSA^BEHOEPC1(TWOYRS)
 ;
 ;Perform CS Order Integrity Comp
 ;GDIT/HS/BEE 04192021;Moved to overflow routine
 ;D OICOMP(TWOYRS)
 D OICOMP^BEHOEPC1(TWOYRS)
 ;
 ;Perform Pharmacy Order Integrity Comp
 D POCOMP(TWOYRS)
 ;
 ;Perform EPCS Hash Check Comp
 D HASHSVC
 ;
 ;Signal that process has completed
 L -^XTMP("BEHOEPIC",0)
 ;
 Q
 ;
POCOMP(TWOYRS) ;Perform Pharmacy Order Integrity Comp
 ;
 NEW FDT,FDTTM,FIEN,IEN,PVIEN,PRCDT,ECT,%,DECNT,LSTDT,STS,TOCNT,TECNT,TOT
 ;
 ;Log process start to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","Pharmacy Order Integrity Compile Started|TYPE~G|RSLT~S|||EP~P|EPCS106|","","")
 ;
 ;Get timestamp
 D NOW^%DTC
 ;
 ;Get first APSP DEA ARCHIVE INFO timestamp
 S FDTTM=$O(^APSPDEA("ADT",TWOYRS)) G XPO:FDTTM=""
 S FDT=$P(FDTTM,".")
 ;
 ;Now retrieve corresponding IEN for entry
 S FIEN=$O(^APSPDEA("ADT",FDTTM,"")) G XPO:FIEN=""
 ;
 ;Reset header, bad date and missing IEN storage location
 S ^XTMP("BEHOEPIC","P")=%_U_U_$G(DUZ)_U_DT_U_FDT_U
 K ^XTMP("BEHOEPIC","P",9999999)
 ;
 ;Now loop through ^APSPDEA from that point forward to look for issues
 S (TOT,DECNT,TOCNT,TECNT,ECT)=0,IEN=FIEN-1,LSTDT="" F  S PVIEN=IEN,IEN=$O(^APSPDEA(IEN)) Q:'IEN  D
 . NEW PDT,RDTTM,RDSC,NH,OHSH,EPCS,EP,N8
 . ;
 . ;Pull entire zero node to save global hits
 . S N8=$G(^APSPDEA(IEN,8))
 . ;
 . ;Get timestamp - flag if blank
 . ;GDIT/HS/BEE 04192021;Add remediation check
 . ;S RDTTM=$P(N8,U),PDT=$P(RDTTM,".") I PDT="" S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","P",9999999,"P",ECT)=IEN_U_"E^Timestamp is missing from APSPDEA entry with IEN: "_IEN Q
 . S RDTTM=$P(N8,U),PDT=$P(RDTTM,".") I PDT="",'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("APSPDEA Entry - Missing Timestamp",IEN,.BUSAR),1:"0") D  Q
 .. S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","P",9999999,"P",ECT)=IEN_U_"E^Timestamp is missing from APSPDEA entry with IEN: "_IEN
 . ;
 . ;Reset date if first one
 . I '$D(PRCDT(PDT)) D
 .. K ^XTMP("BEHOEPIC","P",PDT)
 .. S ^XTMP("BEHOEPIC","P",PDT)=DT_U_$G(DUZ)
 .. S PRCDT(PDT)=""
 .. I LSTDT S $P(^XTMP("BEHOEPIC","P",LSTDT),U,3,4)=DECNT_U_TOCNT
 .. S TOT=TOT+TOCNT,DECNT=0,TOCNT=0,LSTDT=PDT
 . ;
 . ;Compare against previous IEN to find missing entries
 . I IEN'=(PVIEN+1) D
 .. NEW MIEN
 .. ;GDIT/HS/BEE 04192021;Add remediation check
 .. ;F MIEN=PVIEN+1:1:(IEN-1) S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","P",9999999,"P",ECT)=MIEN_U_"D^APSPDEA is missing entry for IEN: "_MIEN
 .. F MIEN=PVIEN+1:1:(IEN-1) I '$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("APSPDEA Entry - Missing",MIEN,.BUSAR),1:"0") D
 ... S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","P",9999999,"P",ECT)=MIEN_U_"D^APSPDEA is missing entry for IEN: "_MIEN
 . ;
 . ;Check HASH
 . ;
 . ;Calculate New
 . S RDSC=$$GENSPHSH(IEN)
 . S NH=$$GENHASH(RDSC)
 . ;
 . ;Get original
 . S OHSH=$P(N8,U,3)
 . ;
 . ;Log mismatches
 . S TOCNT=TOCNT+1
 . ;GDIT/HS/BEE 04192021;Add remediation check
 . ;I OHSH'=NH S DECNT=DECNT+1,^XTMP("BEHOEPIC","P",PDT,"P",DECNT)=IEN_U_"H^HASH Mismatch in APSPDEA IEN: "_IEN
 . I OHSH'=NH,'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("APSPDEA Entry - HASH Mismatch",IEN,.BUSAR),1:"0") D
 .. S DECNT=DECNT+1,^XTMP("BEHOEPIC","P",PDT,"P",DECNT)=IEN_U_"H^HASH Mismatch in APSPDEA IEN: "_IEN
 ;
 ;Save last totals
 I LSTDT S $P(^XTMP("BEHOEPIC","P",LSTDT),U,3,4)=DECNT_U_TOCNT
 S ^XTMP("BEHOEPIC","P",9999999)=DT_U_$G(DUZ)_U_$G(ECT)_U_$G(TECNT)
 S $P(^XTMP("BEHOEPIC","P"),U,6)=$G(TOT)+$G(TOCNT)+$G(TECNT)
 ;
 ;Mark as completed
XPO D NOW^%DTC
 S $P(^XTMP("BEHOEPIC","P"),U,2)=%
 ;
 ;Log process complete to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","Pharmacy Order Integrity Compile Completed|TYPE~G|RSLT~S|||EP~P|EPCS107|","","")
 ;
 Q
 ;
GENSOHSH(IEN) ;Adapted from GENSOHSH^BEHOEPS - Will not save hash
 Q:'IEN
 N X,GBLROOT,STR,QFLG,FDA,FHSH
 S GBLROOT="^ORPA(101.52,"_IEN
 S STR="",FHSH=""
 S X=GBLROOT_")"
 F  S X=$Q(@X) Q:X'[GBLROOT  D  Q:$G(QFLG)
 .I X=(GBLROOT_",0)") S FHSH=$P(@X,U,3),STR=$$ADDSTR($P(@X,U)_FHSH)
 .E  I X=(GBLROOT_",3)") S STR=$$ADDSTR($P(@X,U,1,4))
 .E  I X=(GBLROOT_",6)") S STR=$$ADDSTR(@X) S QFLG=1
 .E  S STR=$$ADDSTR(@X)
 S STR=STR_$$DSIGTSTR(FHSH)
 Q STR
 ;
GENSPHSH(IEN) ;Adapted from GENSPHSH^BEHOEPS - Will not save hash
 Q:'IEN
 N X,GBLROOT,STR,QFLG,FDA,FHSH
 S GBLROOT="^APSPDEA("_IEN
 S STR="",FHSH=""
 S X=GBLROOT_")"
 F  S X=$Q(@X) Q:X'[GBLROOT  D  Q:$G(QFLG)
 .I X=(GBLROOT_",0)") S FHSH=$P(@X,U,2),STR=$$ADDSTR(@X)
 .E  I X=(GBLROOT_",6)") S STR=$$ADDSTR(@X) S QFLG=1
 .E  S STR=$$ADDSTR(@X)
 S STR=STR_$$DSIGTSTR(FHSH)
 Q STR
 ;
DSIGTSTR(HSH) ;Pull signature from PKI Digital Signatures - Adapted from DSIGTSTR^BEHOEPS
 N PKI,LP,STR,SIEN
 I $G(HSH)="" Q ""
 ;S PKI=$$FIND1^DIC(8980.2,,"X",HSH)  ;P070005
 S (PKI,SIEN)="" F  S SIEN=$O(^XUSSPKI(8980.2,"B",$E(HSH,1,30),SIEN)) Q:SIEN=""  D  Q:PKI'=""
 .I $P($G(^XUSSPKI(8980.2,SIEN,0)),U)=HSH S PKI=SIEN
 Q:'PKI ""
 S LP=0
 F  S LP=$O(^XUSSPKI(8980.2,PKI,1,LP)) Q:'LP  S STR=$G(STR)_^(LP,0)
 Q $G(STR)
 ;
ADDSTR(X) ;Copied from ADDSTR^BEHOEPS
 Q $S($L(STR):STR_U_X,1:X)
 ;
GENHASH(STR) ;Copied from GENHASH^BEHOEPS
 N X
 X "S X=##class(%SYSTEM.Encryption).SHAHash(256,STR)"
 X "S X=$System.Encryption.Base64Encode(X)"
 Q X
 ;
HASHSVC ;EPCS Hash Check Compile
 ;
 N SCR,OUT,ERR,INDEX,RET,RESPONSE,COUNT,TOTAL,STS,TMPLST,%
 ;
 D NOW^%DTC
 S ^XTMP("BSTSEPIC","E")=%_U_U_$G(DUZ)_U_DT
 ;
 ;Log the start to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","Provider Profile Integrity Compile Started|TYPE~G|RSLT~S|||EP~E|EPCS102|","","")
 ;
 S SCR="I 1",COUNT=0,TOTAL=0
 S SCR=SCR_" & (($P($G("_"^"_"(""IHSEPCS1"")),""^"",1))'="_""""""_")"
 D LIST^DIC(200,"","@;.01","B","*",,,,SCR,"","OUT","ERR")
 I $D(ERR("DIERR")) S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","EPCS Monitoring Hash Check Incomplete|TYPE~PP|RSLT~F|||EP~E|","","")
 S INDEX=$O(OUT("DILIST",2,""))
 I +INDEX>0 F  D  Q:(+INDEX'>0)
 .D VRFYPHSH^BEHOEP3(.RET,OUT("DILIST",2,INDEX))
 .I '$G(RET) D
 .. S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","EPCS Monitoring Hash Check Fail: "_$G(INDEX)_"-"_OUT("DILIST","ID",INDEX,.01)_"|TYPE~PP|RSLT~F|||EP~E|","","")
 .. S COUNT=COUNT+1
 .. S TMPLST(COUNT)="EPCS Monitoring Hash Check Fail: "_$G(INDEX)_"-"_OUT("DILIST","ID",INDEX,.01)
 .S INDEX=$O(OUT("DILIST",2,INDEX)),TOTAL=TOTAL+1
 ;
 ;Get current date and time
 D NOW^%DTC
 ;
 ;Save results in ^XTMP
 K ^XTMP("BEHOEPIC","E",DT)
 S ^XTMP("BEHOEPIC","E",DT)=DT_U_$G(DUZ)_U_COUNT_U_TOTAL
 M ^XTMP("BEHOEPIC","E",DT)=TMPLST
 S $P(^XTMP("BEHOEPIC","E"),U,2)=%
 S $P(^XTMP("BEHOEPIC","E"),U,6)=TOTAL
 ;
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","Provider Profile Integrity Compile Completed. "_$G(COUNT)_" out of "_$G(TOTAL)_" logged in BUSA|TYPE~G|RSLT~S|||EP~E|EPCS103|"_+$G(COUNT)_"~"_+$G(TOTAL)_"|","","")
 Q
 ;
EPCS ;EP - Entry point for EPCS daily report creation for MailMan delivery
 ;
 NEW ENDDT,PRINT,STARTDT,X1,X2,X,XMTEXT,XMSUB,XMY,XLINE,RL,BODY,SKIEN,SDUZ,PGNUM,COL,COVERCOL
 NEW NOW,STOP,TITLE,LINE,STS
 ;
 S X1=DT,X2=-1 D C^%DTC S (STARTDT,ENDDT)=X
 S PRINT="",XLINE=-1
 ;
 ;Compile report
 D INQ^BEHOEPR1
 S $P(LINE,"-",79)="-"
 S TITLE="EPCS Audit Summary Report"
 S NOW=$$UP^XLFSTR($$HTE^XLFDT($H)),NOW=$P(NOW,"@",1)_"  "_$P($P(NOW,"@",2),":",1,2)
 S XLINE=XLINE+1,BODY(XLINE)=""
 S XLINE=XLINE+1,BODY(XLINE)=$$LJ^XLFSTR($E(TITLE,1,46),47," ")_NOW
 S XLINE=XLINE+1,BODY(XLINE)=""
 S XLINE=XLINE+1,BODY(XLINE)="Report Date Range: "_$$FMTE^XLFDT(STARTDT)_" through "_$$FMTE^XLFDT(ENDDT)
 S XLINE=XLINE+1,BODY(XLINE)=LINE
 S XLINE=XLINE+1,BODY(XLINE)=""
 S RL="" F  S RL=$O(^TMP("BEHOEPR1",$J,RL)) Q:RL=""  D
 . S XLINE=XLINE+1
 . S BODY(XLINE)=$G(^TMP("BEHOEPR1",$J,RL))
 . S XMTEXT="BODY("
 ;
 ;Assemble TO list
 S XMY("G.BEHO EPCS INCIDENT RESPONSE")=""
 ;
 ;Subject Line
 S XMSUB="EPCS Incident Report for "_$$FMTE^XLFDT(STARTDT,"5D")
 ;
 ;Send message
 D ^XMD
 ;
 ;Log entry to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","Generated BEHO EPCS Audit Summary Report|TYPE~G|RSLT~S|||EP~E|","","")
 ;
 Q
 ;
APSP ;EP - Entry point for APSP daily report creation for MailMan delivery
 NEW ENDDT,PRINT,STARTDT,X1,X2,X,XMTEXT,XMSUB,XMY,XLINE,RL,BODY,SKIEN,SDUZ,PGNUM,COL,COVERCOL
 NEW NOW,STOP,TITLE,LINE
 ;
 S X1=DT,X2=-1 D C^%DTC S (STARTDT,ENDDT)=X
 S PRINT="",XLINE=-1
 ;
 ;Compile report
 D INQ^APSPEPR1
 S $P(LINE,"-",79)="-"
 S TITLE="Pharmacy Audit Summary Report"
 S NOW=$$UP^XLFSTR($$HTE^XLFDT($H)),NOW=$P(NOW,"@",1)_"  "_$P($P(NOW,"@",2),":",1,2)
 S XLINE=XLINE+1,BODY(XLINE)=""
 S XLINE=XLINE+1,BODY(XLINE)=$$LJ^XLFSTR($E(TITLE,1,46),47," ")_NOW
 S XLINE=XLINE+1,BODY(XLINE)=""
 S XLINE=XLINE+1,BODY(XLINE)="Report Date Range: "_$$FMTE^XLFDT(STARTDT)_" through "_$$FMTE^XLFDT(ENDDT)
 S XLINE=XLINE+1,BODY(XLINE)=LINE
 S XLINE=XLINE+1,BODY(XLINE)=""
 S RL="" F  S RL=$O(^TMP("APSPEPR1",$J,RL)) Q:RL=""  D
 . S XLINE=XLINE+1
 . S BODY(XLINE)=$G(^TMP("APSPEPR1",$J,RL))
 . S XMTEXT="BODY("
 ;
 ;Assemble TO list
 S XMY("G.BEHO EPCS INCIDENT RESPONSE")=""
 ;
 ;Subject Line
 S XMSUB="Pharmacy Incident Report for "_$$FMTE^XLFDT(STARTDT,"5D")
 ;
 ;Send message
 D ^XMD
 ;
 ;Log entry to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","Generated BEHO Pharmacy Audit Summary Report|TYPE~G|RSLT~S|||EP~P|","","")
 ;
 Q
