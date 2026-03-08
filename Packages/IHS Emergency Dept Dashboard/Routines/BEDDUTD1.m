BEDDUTD1 ;GDIT/HS/BEE-BEDD Utility Routine 3 ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;**7**;Jun 04, 2014;Build 21
 ;
 Q
 ;
 ;Moved from BEDDUTID because of routine size
PROV(PROV,KEY,CIEN) ;EP - Return List of Providers
 ;
 ;Input:
 ; KEY - Security to search for
 ; CIEN - The current selection
 ;
 ;Output:
 ; PROV Array - List of Providers
 ;
 NEW CNT,PNAME,PIEN,X,CNAME,CFND,TPROV
 ;
 S X="S:$G(U)="""" U=""^""" X X
 S X="S:$G(DT)="""" DT=$$DT^XLFDT" X X
 S CIEN=$G(CIEN)
 S KEY=$G(KEY)
 ;
 K PROV
 ;
 ;Get the current information if passed in
 S CFND=1,CNAME="" I $G(CIEN)]"" D
 . S CNAME=$$GET1^DIQ(200,CIEN_",",.01,"E")
 . I CNAME]"" S CFND=0
 ;
 ;Look for list if key passed in
 S CNT=0 I $G(KEY)]"",$O(^XUSEC(KEY,""))]"" S PIEN=0 F  S PIEN=$O(^XUSEC(KEY,PIEN)) Q:'PIEN  D
 . NEW TERM,PNAME
 . S TERM=$$GET1^DIQ(200,PIEN_",","9.2","I")
 . I TERM]"",TERM<DT Q
 . I $$GET1^DIQ(200,PIEN_",",7,"I")=1 Q   ;Disuser
 . ;
 . ;Are they a provider?
 . I '$D(^XUSEC("PROVIDER",PIEN)) Q
 . ;
 . S PNAME=$$GET1^DIQ(200,PIEN_",",.01,"E") Q:PNAME=""
 . S TPROV(PNAME,PIEN)=PIEN_"^"_PNAME
 . ;
 . ;Look for current
 . I PIEN=CIEN S CFND=1
 ;
 ;Output sorted list
 I $O(TPROV(""))]"" S PNAME="" F  S PNAME=$O(TPROV(PNAME)) Q:PNAME=""  S PIEN="" F  S PIEN=$O(TPROV(PNAME,PIEN)) Q:PIEN=""  S CNT=$G(CNT)+1,PROV(CNT)=TPROV(PNAME,PIEN)
 ;
 I $O(PROV(""))]"" D  Q
 . I CIEN="" Q
 . I 'CFND S CNT=CNT+1,PROV(CNT)=CIEN_"^"_CNAME
 ;
 ;If no key or none are assigned key, return full list
 S PNAME="" F  S PNAME=$O(^VA(200,"AK.PROVIDER",PNAME)) Q:PNAME=""  D
 . S PIEN=0 F  S PIEN=$O(^VA(200,"AK.PROVIDER",PNAME,PIEN)) Q:+PIEN=0  D
 .. ;BEDD*2.0*2;Handle future termination dates
 .. ;I $$GET1^DIQ(200,PIEN_",","9.2","I")]"" Q
 .. NEW TERM
 .. S TERM=$$GET1^DIQ(200,PIEN_",","9.2","I")
 .. I TERM]"",TERM<DT Q
 .. I $$GET1^DIQ(200,PIEN_",",7,"I")=1 Q   ;Disuser
 .. ;
 .. ;Are they a provider?
 .. I '$D(^XUSEC("PROVIDER",PIEN)) Q
 .. ;
 .. S CNT=CNT+1
 .. S PROV(CNT)=PIEN_"^"_PNAME
 ;
 Q
 ;
PVFRMT(DFN,BEDDARY,BPROV,BNURSE) ;Assemble provider information
 ;
 ;This call takes provider information out of the edit page fields and from the
 ;edit page provider table and formats them into an array. It also puts the most
 ;recent entries in to be returned for saving into ER ADMISSION
 ;
 I $G(DFN)="" Q
 ;
 ;Retrieve the provider/nurse info from the top fields and assemble
 D NRPRV(.BEDDARY,.BPROV,.BNURSE)
 ;
 ;Loop through the provider history table
 D PHIST(DFN,.BPROV,.BNURSE)
 ;
 ;Update for ER ADMISSION file
 D EADM(.BEDDARY,.BPROV,.BNURSE)
 ;
 Q
 ;
NRPRV(BEDDARY,BPROV,BNURSE) ;Retrieve provider/nurse data from edit fields and format
 ;
 NEW PRV,TIME
 ;
 ;Current Triage Nurse
 S PRV=$G(BEDDARY("TrgN"))
 I PRV]"" D
 . S TIME=$$DATE^BEDDUTIL($G(BEDDARY("TrgNow")))
 . I TIME]"" S BNURSE(TIME,PRV,"TR")=""
 ;
 ;Current Triage Provider
 S PRV=$G(BEDDARY("TrgP"))
 I PRV]"" D
 . S TIME=$$DATE^BEDDUTIL($G(BEDDARY("TrgPDtTm")))
 . I TIME]"" S BPROV(TIME,PRV,"TR")=""
 ;
 ;Current Primary Nurse
 S PRV=$G(BEDDARY("PrmNurse"))
 I PRV]"" D
 . S TIME=$$DATE^BEDDUTIL($G(BEDDARY("PrmNurseDTM")))
 . I TIME]"" S BNURSE(TIME,PRV,"PR")=""
 ;
 ;Current ED Provider
 S PRV=$G(BEDDARY("AdmPrv"))
 I PRV]"" D
 . S TIME=$$DATE^BEDDUTIL($G(BEDDARY("EDPvDtm")))
 . I TIME]"" S BPROV(TIME,PRV,"ED")=""
 ;
 ;Current Discharge Nurse
 S PRV=$G(BEDDARY("DCNrs"))
 I PRV]"" D
 . S TIME=$G(BEDDARY("DCDtTm"))
 . I TIME]"" S BNURSE(TIME,PRV,"DC")=""
 ;
 ;Current Discharge Provider
 S PRV=$G(BEDDARY("DCPrv"))
 I PRV]"" D
 . S TIME=$G(BEDDARY("DCDtTm"))
 . I TIME]"" S BPROV(TIME,PRV,"DC")=""
 ;
 Q
 ;
PHIST(DFN,BPROV,BNURSE) ;Loop through provider history table and assemble entries
 ;
 I $G(DFN)="" Q
 ;
 NEW PCNT
 ;
 S PCNT=0 F  S PCNT=$O(^TMP("BEDD_PROV",$J,+$G(DUZ),+$G(DFN),PCNT)) Q:PCNT=""  D
 . ;
 . NEW NODE,TIME,PRV,TYP,PN,PTYP
 . ;
 . S NODE=$G(^TMP("BEDD_PROV",$J,+$G(DUZ),+$G(DFN),PCNT))
 . ;
 . ;Retrieve date/time seen
 . S TIME=$P(NODE,"^",2) I TIME="" Q
 . ;
 . ;Retrieve provider/nurse
 . S PRV=$P(NODE,"^",3) I PRV="" Q
 . ;
 . ;Retrieve type
 . S (PN,PTYP)=""
 . S TYP=$P(NODE,"^") I TYP="" Q
 . I TYP="ED PROVIDER" S PN="P",PTYP="ED"
 . E  I TYP="TRIAGE PROVIDER" S PN="P",PTYP="TR"
 . E  I TYP="PRIMARY PROVIDER" S PN="P",PTYP="PR"
 . E  I TYP="DISCHARGE PROVIDER" S PN="P",PTYP="DC"
 . E  I TYP="TRIAGE NURSE" S PN="N",PTYP="TR"
 . E  I TYP="PRIMARY NURSE" S PN="N",PTYP="PR"
 . E  I TYP="OTHER NURSE" S PN="N",PTYP="OT"
 . E  I TYP="DISCHARGE NURSE" S PN="N",PTYP="DC"
 . I PTYP="" Q
 . ;
 . ;Handle deletes
 . I $P(NODE,"^",6)=1 D  Q
 .. I PN="P" K BPROV(TIME,PRV,PTYP)
 .. I PN="N" K BNURSE(TIME,PRV,PTYP)
 . ;
 . ;Save
 . I PN="P" S BPROV(TIME,PRV,PTYP)=""
 . E  I PN="N" S BNURSE(TIME,PRV,PTYP)=""
 ;
 Q
 ;
EADM(BEDDARY,BPROV,BNURSE) ;Update array for AMER entry
 ;
 NEW TIME,PRV,TYP
 ;
 ;Loop through nurses first
 S TIME="" F  S TIME=$O(BNURSE(TIME)) Q:TIME=""  D
 . S PRV="" F  S PRV=$O(BNURSE(TIME,PRV)) Q:PRV=""  D
 .. S TYP="" F  S TYP=$O(BNURSE(TIME,PRV,TYP)) Q:TYP=""  D
 ... ;
 ... ;Triage nurse
 ... I TYP="TR" S BEDDARY("TrgN")=PRV,BEDDARY("TrgNow")=TIME Q
 ... ;
 ... ;Primary nurse
 ... I TYP="PR" S BEDDARY("PrmNurse")=PRV,BEDDARY("PrmNurseDTM")=TIME Q
 ... ;
 ... ;Discharge nurse
 ... I TYP="DC" S BEDDARY("DCNrs")=PRV,BEDDARY("DCDtTm")=TIME Q
 ;
 ;Now loop through providers
 S TIME="" F  S TIME=$O(BPROV(TIME)) Q:TIME=""  D
 . S PRV="" F  S PRV=$O(BPROV(TIME,PRV)) Q:PRV=""  D
 .. S TYP="" F  S TYP=$O(BPROV(TIME,PRV,TYP)) Q:TYP=""  D
 ... ;
 ... ;Triage provider
 ... I TYP="TR" S BEDDARY("TrgP")=PRV,BEDDARY("TrgPDtTm")=TIME Q
 ... ;
 ... ;ED provider
 ... I TYP="ED" S BEDDARY("AdmPrv")=PRV,BEDDARY("EDPvDtm")=TIME Q
 ... ;
 ... ;Discharge provider
 ... I TYP="DC" S BEDDARY("DCPrv")=PRV,BEDDARY("DCDtTm")=TIME Q
 ;
 Q
