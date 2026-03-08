BEHOEPC1 ;GDIT/HS/BEE - EPCS Integrity Checking Compile (cont)
 ;;1.1;BEH COMPONENTS;**070003**;Mar 20, 2007;Build 10
 ;
 Q
 ;
BIBUSA(TWOYRS) ;Perform BUSA Integrity Comp
 ;
 NEW FDT,FDTTM,FIEN,IEN,PVIEN,PRCDT,ECT,%,DECNT,LSTDT,STS,TOCNT,TECNT,TOT,BUSAR
 ;
 ;Log process start to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","BUSA Integrity Compile Started|TYPE~G|RSLT~S|||EP~EP|EPCS108|","","")
 ;
 ;Get timestamp
 D NOW^%DTC
 ;
 ;Get first BUSA timestamp
 S FDTTM=$O(^BUSAS("B",TWOYRS)) G XBI:FDTTM=""
 S FDT=$P(FDTTM,".")
 ;
 ;Now retrieve corresponding IEN for entry
 S FIEN=$O(^BUSAS("B",FDTTM,"")) G XBI:FIEN=""
 ;
 ;Reset header, bad date and missing IEN storage location
 S ^XTMP("BEHOEPIC","B")=%_U_U_$G(DUZ)_U_DT_U_FDT_U
 K ^XTMP("BEHOEPIC","B",9999999)
 ;
 ;Now loop through ^BUSAS from that point forward to look for issues
 S (TOT,DECNT,TOCNT,TECNT,ECT)=0,IEN=FIEN-1,LSTDT="" F  S PVIEN=IEN,IEN=$O(^BUSAS(IEN)) Q:'IEN  D
 . NEW PDT,N0,N1,N2,RDTTM,RUSER,RTYPE,RACT,RCAT,RCALL,RDSC,NH,OHSH,EPCS,EP
 . ;
 . ;Pull entire zero node to save global hits
 . S N0=$G(^BUSAS(IEN,0))
 . ;
 . ;Get timestamp - flag if blank
 . ;GDIT/HS/BEE 04192021;Add remediation check
 . ;S RDTTM=$P(N0,U),PDT=$P(RDTTM,".") I PDT="" S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","B",9999999,"EP",ECT)=IEN_U_"E^Timestamp is missing from BUSAS entry with IEN: "_IEN Q
 . S RDTTM=$P(N0,U),PDT=$P(RDTTM,".") I PDT="",'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("BUSAS Entry - Missing Timestamp",IEN,.BUSAR),1:"0") D  Q
 .. S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","B",9999999,"EP",ECT)=IEN_U_"E^Timestamp is missing from BUSAS entry with IEN: "_IEN
 . ;
 . ;Reset date if first
 . I '$D(PRCDT(PDT)) D
 .. K ^XTMP("BEHOEPIC","B",PDT)
 .. S ^XTMP("BEHOEPIC","B",PDT)=DT_U_$G(DUZ)
 .. S PRCDT(PDT)=""
 .. I LSTDT S $P(^XTMP("BEHOEPIC","B",LSTDT),U,3,4)=DECNT_U_TOCNT
 .. S TOT=TOT+TOCNT,DECNT=0,TOCNT=0,LSTDT=PDT
 . ;
 . ;Compare against previous IEN to find missing entries
 . I IEN'=(PVIEN+1) D
 .. NEW MIEN
 .. ;GDIT/HS/BEE 04192021;Add remediation check
 .. ;F MIEN=PVIEN+1:1:(IEN-1) S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","B",9999999,"EP",ECT)=MIEN_U_"D^BUSAS is missing entry for IEN: "_MIEN
 .. F MIEN=PVIEN+1:1:(IEN-1) I '$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("BUSAS Entry - Missing",MIEN,.BUSAR),1:"0") D
 ... S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","B",9999999,"EP",ECT)=MIEN_U_"D^BUSAS is missing entry for IEN: "_MIEN
 . ;
 . ;Check HASH
 . ;
 . S RDSC=$G(^BUSAS(IEN,1)) ;Description
 . S OHSH=$G(^BUSAS(IEN,2)) ;Hash on file
 . ;
 . ;If no "|" pieces or HASH quit
 . I $L(RDSC,"|")<6,OHSH="" Q
 . ;
 . ;Only check E/P/EP
 . S EPCS=$P(RDSC,"|",6),EP=$P(EPCS,"EP~",2)
 . I ",E,P,EP,"'[(","_EP_",") Q
 . ;
 . S RDTTM=$P(N0,U,1)
 . S RUSER=$P(N0,U,2)
 . S RCAT=$P(N0,U,3)
 . S RTYPE=$P(N0,U,4)
 . S RACT=$P(N0,U,5)
 . S RCALL=$P(N0,U,6)
 . ;
 . ;Calculate Hash
 . S NH=$$HASH^BUSAAPI(RDTTM_U_RUSER_U_RCAT_U_RTYPE_U_RACT_U_RCALL_U_RDSC)
 . ;
 . ;Log mismatches
 . S TOCNT=TOCNT+1
 . ;GDIT/HS/BEE 04192021;Add remediation check
 . ;I OHSH'=NH S DECNT=DECNT+1,^XTMP("BEHOEPIC","B",PDT,EP,DECNT)=IEN_U_"H^HASH Mismatch in BUSAS IEN: "_IEN
 . I OHSH'=NH,'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("BUSAS Entry - HASH Mismatch",IEN,.BUSAR),1:"0") D
 .. S DECNT=DECNT+1,^XTMP("BEHOEPIC","B",PDT,EP,DECNT)=IEN_U_"H^HASH Mismatch in BUSAS IEN: "_IEN
 ;
 ;Save last totals
 I LSTDT S $P(^XTMP("BEHOEPIC","B",LSTDT),U,3,4)=DECNT_U_TOCNT
 S ^XTMP("BEHOEPIC","B",9999999)=DT_U_$G(DUZ)_U_$G(ECT)_U_TECNT
 S $P(^XTMP("BEHOEPIC","B"),U,6)=$G(TOT)+$G(TOCNT)+$G(TECNT)
 ;
XBI ;Mark completed
 D NOW^%DTC
 S $P(^XTMP("BEHOEPIC","B"),U,2)=%
 ;
 ;Log process complete to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","BUSA Integrity Compile Completed|TYPE~G|RSLT~S|||EP~EP|EPCS109|","","")
 ;
 Q
 ;
OICOMP(TWOYRS) ;Perform Order Integrity Comp
 ;
 NEW FDT,FDTTM,FIEN,IEN,PVIEN,PRCDT,ECT,%,DECNT,LSTDT,STS,TOCNT,TECNT,TOT
 ;
 ;Log process start to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","CS Order Integrity Compile Started|TYPE~G|RSLT~S|||EP~E|EPCS104|","","")
 ;
 ;Get timestamp
 D NOW^%DTC
 ;
 ;Get first ORDER DEA ARCHIVE INFO timestamp
 S FDTTM=$O(^ORPA(101.52,"ADT",TWOYRS)) G XOI:FDTTM=""
 S FDT=$P(FDTTM,".")
 ;
 ;Now retrieve corresponding IEN for entry
 S FIEN=$O(^ORPA(101.52,"ADT",FDTTM,"")) G XOI:FIEN=""
 ;
 ;Reset header, bad date and missing IEN storage location
 S ^XTMP("BEHOEPIC","O")=%_U_U_$G(DUZ)_U_DT_U_FDT_U
 K ^XTMP("BEHOEPIC","O",9999999)
 ;
 ;Now loop through ^ORPA(101.52) from that point forward to look for issues
 S (TOT,DECNT,TOCNT,TECNT,ECT)=0,IEN=FIEN-1,LSTDT="" F  S PVIEN=IEN,IEN=$O(^ORPA(101.52,IEN)) Q:'IEN  D
 . NEW PDT,RDTTM,RDSC,NH,OHSH,EPCS,EP,N999
 . ;
 . ;Pull entire zero node to save global hits
 . S N999=$G(^ORPA(101.52,IEN,9999999))
 . ;
 . ;Get timestamp - flag if blank
 . ;GDIT/HS/BEE 04192021;Add remediation check
 . ;S RDTTM=$P(N999,U),PDT=$P(RDTTM,".") I PDT="" S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","O",9999999,"E",ECT)=IEN_U_"E^Timestamp is missing from ORPA(101.52) entry with IEN: "_IEN Q
 . S RDTTM=$P(N999,U),PDT=$P(RDTTM,".") I PDT="",'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("ORPA(101.52) Entry - Missing Timestamp",IEN,.BUSAR),1:"0") D  Q
 .. S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","O",9999999,"E",ECT)=IEN_U_"E^Timestamp is missing from ORPA(101.52) entry with IEN: "_IEN
 . ;
 . ;Reset date if first one
 . I '$D(PRCDT(PDT)) D
 .. K ^XTMP("BEHOEPIC","O",PDT)
 .. S ^XTMP("BEHOEPIC","O",PDT)=DT_U_$G(DUZ)
 .. S PRCDT(PDT)=""
 .. I LSTDT S $P(^XTMP("BEHOEPIC","O",LSTDT),U,3,4)=DECNT_U_TOCNT
 .. S TOT=TOT+TOCNT,DECNT=0,TOCNT=0,LSTDT=PDT
 . ;
 . ;Compare against previous IEN to find missing entries
 . I IEN'=(PVIEN+1) D
 .. NEW MIEN
 .. ;GDIT/HS/BEE 04192021;Add remediation check
 .. ;F MIEN=PVIEN+1:1:(IEN-1) S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","O",9999999,"E",ECT)=MIEN_U_"D^ORPA(101.52) is missing entry for IEN: "_MIEN
 .. F MIEN=PVIEN+1:1:(IEN-1) I '$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("ORPA(101.52) Entry - Missing",MIEN,.BUSAR),1:"0") D
 ... S TECNT=TECNT+1,ECT=ECT+1,^XTMP("BEHOEPIC","O",9999999,"E",ECT)=MIEN_U_"D^ORPA(101.52) is missing entry for IEN: "_MIEN
 . ;
 . ;Check HASH
 . ;
 . ;Calculate New
 . S RDSC=$$GENSOHSH^BEHOEPIC(IEN)
 . S NH=$$GENHASH^BEHOEPIC(RDSC)
 . ;
 . ;Get original
 . S OHSH=$P(N999,U,3)
 . ;
 . ;Log mismatches
 . S TOCNT=TOCNT+1
 . ;GDIT/HS/BEE 04192021;Add remediation check
 . ;I OHSH'=NH S DECNT=DECNT+1,^XTMP("BEHOEPIC","O",PDT,"E",DECNT)=IEN_U_"H^HASH Mismatch in ORPA(101.52) IEN: "_IEN
 . I OHSH'=NH,'$S($L($T(CHECK^BUSAAPIR)):$$CHECK^BUSAAPIR("ORPA(101.52) - HASH Mismatch",IEN,.BUSAR),1:"0") D
 .. S DECNT=DECNT+1,^XTMP("BEHOEPIC","O",PDT,"E",DECNT)=IEN_U_"H^HASH Mismatch in ORPA(101.52) IEN: "_IEN
 ;
 ;Save last totals
 I LSTDT S $P(^XTMP("BEHOEPIC","O",LSTDT),U,3,4)=DECNT_U_TOCNT
 S ^XTMP("BEHOEPIC","O",9999999)=DT_U_$G(DUZ)_U_$G(ECT)_U_$G(TECNT)
 S $P(^XTMP("BEHOEPIC","O"),U,6)=$G(TOT)+$G(TOCNT)+$G(TECNT)
 ;
 ;Mark completed
XOI D NOW^%DTC
 S $P(^XTMP("BEHOEPIC","O"),U,2)=%
 ;
 ;Log process complete to BUSA
 S STS=$$LOG^XUSBUSA("A","O","","BEHOEPIC","CS Order Integrity Compile Completed|TYPE~G|RSLT~S|||EP~E|EPCS105|","","")
 ;
 Q
