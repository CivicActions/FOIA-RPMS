APSPES11 ;IHS/MSC/PLS - SureScripts HL7 interface  ;08-Jul-2021 08:20;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1023,1024,1026,1027,1028**;Sep 23, 2004;Build 50
 ;====================================================================
 Q
 ;
AACK ; EP - Application ACK call back - called when AA, AE or AR is received.
 N DATA,RXIEN,AACK,ARY,RET
 Q:'$G(HLMSGIEN)
 S RXIEN=$$RXIEN^APSPES2(HLMSGIEN)
 S AACK=$G(^HLB(HLSMGIEN,4))
 I $P(AACK,U,3)'["|AA|" D
 .S MSG(1)="HL7 Message "_^HLB(HLMSGIEN,1)_^HLB(HLMSGIEN,2)
 .S MSG(2)=" "
 .S MSG(3)="did not receive a valid NEWRX acknowledgement."
 .S MSG(4)=AACK
 .S WHO("G.APSP EPRESCRIBING")=""
 .D BULL^APSPES2A("HL7 ERROR","APSP eRx Interface",.WHO,.MSG)
 .I +RXIEN D
 ..D ERX^APSPCSA(RXIEN,"UN")   ;Add call to update log for EPCS
 E  D
 .Q:'RXIEN
 .S ARY("REASON")="X"
 .S ARY("RX REF")=0
 .S ARY("TYPE")="U"
 .S ARY("COM")="eRx update: Received acknowledgement from SureScripts"
 .D UPTLOG^APSPFNC2(.RET,+RXIEN,0,.ARY)
 .D ERX^APSPCSA(RXIEN,"SR")  ;Add call to update log for EPCS
 Q
 ;
CACK ; EP - Commit ACK callback - called when CA, CE or CR is received.
 N CACK
 S CACK=$G(^HLB(HLMSGIEN,4))
 I $P(CACK,"^",3)'["|CA|" D
 .S MSG(1)="HL7 Message "_^HLB(HLMSGIEN,1)_^HLB(HLMSGIEN,2)
 .S MSG(2)=" "
 .S MSG(3)="did not receive a valid NEWRX acknowledgement."
 .S MSG(4)=CACK
 .S WHO("G.APSP EPRESCRIBING")=""
 .D BULL^APSPES2A("HL7 ERROR","APSP eRx Interface",.WHO,.MSG)
 Q
 ;
ARSP ; EP - callback for ORP/O10 event
 N AACK,MSG,WHO,OPRV,ARY,RET,RXIEN,DATA,HLMSTATE,MSA,PT,SPI,PRV,OCOMM,STRING,INTE,SSID,MSGNUM,ORD
 N SEGIEN,SEGMSA,MSGIEN,SEGERR,SEGNTE,ERRTXT,TXT,DEA,DRG,RELID,SENDID,DENY,DENYTXT,OCNT,MCNT,TYPE,STYPE
 S MSGIEN=0,TXT=0
 S MTYPE="",SUBTYPE=""
 D PARSE^APSPES2(.DATA,HLMSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"MSA")
 I 'SEGIEN D  Q
 .D BADORP^APSPES4
 M SEGMSA=DATA(SEGIEN)
 S RELID=$$GET^HLOPRS(.SEGMSA,2)
 S MSGIEN=+$P(RELID," ",2)
 S AACK=$$GET^HLOPRS(.SEGMSA,1)
 S TXT=$$GET^HLOPRS(.SEGMSA,3)
 S OCOMM(0)="",OCNT=0
 F INTE=1:1 D  Q:'+SEGIEN
 .S STRING=""
 .S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"NTE",SEGIEN)
 .Q:'+SEGIEN
 .M SEGNTE=DATA(SEGIEN)
 .S MCNT=0
 .F  S MCNT=$O(SEGNTE(4,MCNT)) Q:'+MCNT  D
 ..S STRING=$G(SEGNTE(4,MCNT,1,1))
 ..S OCNT=OCNT+1
 ..S OCOMM(OCNT)=STRING
 S OCOMM(0)=OCNT
 I AACK'="AA" D
 .S SEGIEN=$$FSEGIEN^APSPES1(.DATA,"ERR")
 .M SEGERR=DATA(SEGIEN)
 .S ERRTXT=$$GET^HLOPRS(.SEGERR,8)
 .S DENY=$$GET^HLOPRS(.SEGERR,5,2)
 .I DENY=""&(TXT="Denied") S DENY=TXT
 I MSGIEN'="" D
 .S (ORD,SSID)=""
 .S RXIEN=$$RXIEN^APSPES2(MSGIEN)
 .S OPRV=$$OPRV^APSPES2(MSGIEN)
 .I +RXIEN S ORD=$$GET1^DIQ(52,RXIEN,39.3,"I")
 .I +ORD S SSID=+$$VALUE^ORCSAVE2(+ORD,"SSRREQIEN")
 .I +SSID D
 ..S MTYPE=$$GET1^DIQ(9009033.91,SSID,.12,"I")
 ..S SUBTYPE=$$GET1^DIQ(9009033.91,SSID,7.4,"I")
 .S TYPE=$$TYPE(MSGIEN)
 .S ARY("REASON")="X"
 .S ARY("RX REF")=0
 .S ARY("USER")=OPRV
 .I AACK'="AA" D
 ..D BADORP^APSPES4
 ..I $G(ERRTXT)="" S ERRTXT=TXT
 ..I RXIEN D
 ...I TYPE=1!(TYPE=3)!(TYPE=4)!(TYPE=5) S DRG=$$GET1^DIQ(52,RXIEN,6)
 ...I TYPE'=4 D
 ....S ARY("TYPE")="F"
 ....S ARY("COM")=$S($L($G(ERRTXT)):ERRTXT,1:"ERROR: eRx did not transmit.")
 ...I TYPE=4 D
 ....S ARY("TYPE")="U"
 ....S ARY("COM")=$S($L($G(DENY)):"Cancel denied for: "_DENY,1:"Cancel message was denied.")
 ...D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY,.OCOMM)
 ...D ERX^APSPCSA(RXIEN,"FA")   ;Add call to update log for EPCS
 ...I TYPE=0 D NOTIF^APSPES4(RXIEN,"ERROR: eRx did not transmit.",$S($L($G(ERRTXT)):ERRTXT,1:"Transmission was not accepted"))
 ...I TYPE=1 D NOTIF^APSPES4(RXIEN,"ERROR: eRx denial did not transmit.",$S($L($G(ERRTXT)):ERRTXT_"@D@"_MSGIEN_"@"_DRG,1:"Transmission was not accepted@D@"_MSGIEN_"@"_DRG),"","","","",TYPE)
 ...I TYPE=2 D NOTIF^APSPES4(RXIEN,"ERROR: eRx ref req did not transmit.",$S($L($G(ERRTXT)):ERRTXT,1:"Refill Request Transmission was not accepted"))
 ...I TYPE=3 D NOTIF^APSPES4(RXIEN,"ERROR: eRx cancel did not transmit.",$S($L($G(ERRTXT)):ERRTXT_"@C@"_MSGIEN_"@"_DRG,1:"Transmission was not accepted@C@"_MSGIEN_"@"_DRG))
 ...I TYPE=4 D NOTIF^APSPES4(RXIEN,"eRx cancel was denied for."_DRG,$S($L($G(DENY)):DENY_" for "_DRG,1:"Cancel was denied by pharmacy"),"","","","",TYPE)
 ...I TYPE=5 D
 ....I SUBTYPE="U"!(SUBTYPE="P")!('+SSID) D NOTIF^APSPES4(RXIEN,"ERROR: eRx change req did not transmit.",$S($L($G(ERRTXT)):ERRTXT_"@A@"_MSGIEN_"@"_DRG,1:"Change Request Transmission was not accepted@A@"_MSGIEN_@_DRG)) I 1
 ....E  D NOTIF^APSPES4(RXIEN,"ERROR: eRx change req did not transmit.",$S($L($G(ERRTXT)):ERRTXT,1:"Change Request Transmission was not accepted"))
 ..I '+RXIEN D
 ...S PT=$$CHKNME^APSPES4(MSGIEN)
 ...S SPI=$$GETVAL^APSPES2(MSGIEN,"ORC",12,1)
 ...S DRG=$$GETVAL^APSPES2(MSGIEN,"RXD",2,2)
 ...S PRV=$$FIND1^DIC(200,,"O",SPI,"ASPI")
 ...I TYPE=0 D NOTIF^APSPES4("","ERROR: eRx did not transmit.",$S($L($G(ERRTXT)):ERRTXT,1:"Transmission was not accepted"),PT,PRV)
 ...I TYPE=1 D NOTIF^APSPES4("","ERROR: eRx denial did not transmit.",$S($L($G(ERRTXT)):ERRTXT_"@D@"_MSGIEN_"@"_DRG,1:"Transmission was not accepted@D@"_MSGIEN_"@"_DRG),PT,PRV,"","",TYPE)
 ...I TYPE=2 D NOTIF^APSPES4("","ERROR: eRx ref req did not transmit.",$S($L($G(ERRTXT)):ERRTXT,1:"Refill Request Transmission was not accepted"),PT,PRV)
 ...I TYPE=5 D NOTIF^APSPES4("","ERROR: eRx change req did not transmit.",$S($L($G(ERRTXT)):ERRTXT,1:"Change Request Transmission was not accepted"))
 .I AACK="AA"&(+RXIEN) D
 ..D ERX^APSPCSA(RXIEN,"SR")   ;Add call to update log for EPCS
 ..S SENDID=$$GET1^DIQ(52,RXIEN,9999999.45)
 ..I SENDID="" D
 ...N FDA
 ...S FDA(52,RXIEN_",",9999999.45)=RELID
 ...D FILE^DIE("K","FDA")          ;Store the relates to msg in Rx file
 ..S ARY("TYPE")="U"
 ..S ARY("COM")=$S(TXT'="":TXT,1:"eRx update: Prescription delivered to pharmacy.")
 ..D UPTLOG^APSPFNC2(.RET,RXIEN,0,.ARY,.OCOMM)
 Q
CHKDUP(RRIEN) ;EP
 ;Loop through any duplicates for this request and send DENY messages
 ;to Surescripts for all of them
 N NIEN,RRDUP,MSGTXT,DATA,RXREF,STAT,CTYPE,MSGIEN
 S DUPDENY=1
 S RXREF=$$GET1^DIQ(9009033.91,RRIEN,.1)
 Q:RXREF=""
 S MSGIEN=$$GET1^DIQ(9009033.91,RRIEN,.01)
 S CTYPE=$$GET1^DIQ(9009033.91,RRIEN,7.4,"I")
 I CTYPE'="" D
 .S RRDUP=$$UDUPCHK^APSPES11(MSGIEN,RXREF,CTYPE,RRIEN)
 .I +RRDUP D
 ..S MSGTXT="AF-Duplicate of request already processed by provider"
 ..S DATA=""
 ..D DENYRPC^APSPES3(.DATA,RRDUP,MSGTXT)
 I CTYPE="" D
 .S RRDUP=0 F  S RRDUP=$O(^APSPRREQ("G",RXREF,RRDUP)) Q:'+RRDUP  D
 ..Q:RRDUP=RRIEN
 ..S MSGTXT="AF-Duplicate of request already processed by provider"
 ..S DATA=""
 ..D DENYRPC^APSPES3(.DATA,RRDUP,MSGTXT)
 K DUPDENY
 Q
CHKDATA(OLD,DFN,OI,MSGIEN,SSNUM,CTYPE) ;Check the original and duplicate to see if msgs are the same
 N MATCH,OLDPT,OLDMED,NEWPT,NEWMED,CHK
 S MATCH=0
 I CTYPE'="" D              ;its a change request
 .S OLDMSG=$$GET1^DIQ(9009033.91,OLD,.01)
 .S OLDTYP=$$GET1^DIQ(9009033.91,OLD,7.4)
 .I OLDTYP=CTYPE D          ;the types match
 ..I CTYPE="U" D
 ...S CHK=$$VALCHK(OLDMSG,OLD,MSGIEN)     ;special call for U types
 ...I +CHK S MATCH=1
 ..E  D
 ...S OLDPT=$$GET1^DIQ(9009033.91,OLD,1.2,"I")
 ...I OLDPT=DFN S MATCH=1
 E  D                            ;Renewals don't have a Ctype
 .S OLDPT=$$GET1^DIQ(9009033.91,OLD,1.2,"I")
 .I OLDPT=DFN S MATCH=1
 Q MATCH
STOREID(RR,PRV,DFN) ;Store data on duplicates
 N FDA,FN
 S FN=9009033.91
 I +PRV S FDA(FN,RR_",",1.3)=PRV
 I +DFN S FDA(FN,RR_",",1.2)=DFN  ; Patient IEN
 D FILE^DIE("K","FDA")
 Q
TYPE(MSGIEN) ;Type of response
 N DATA2,SEGIEN,SEGORC,TYPE,ACT
 D PARSE^APSPES2(.DATA2,MSGIEN,.HLMSTATE)
 S SEGIEN=$$FSEGIEN^APSPES1(.DATA2,"ORC")
 M SEGORC=DATA2(SEGIEN)
 S ACT=$$GET^HLOPRS(.SEGORC,1)
 S TYPE=$S(ACT="RP":1,ACT="DF":1,ACT="AF":2,ACT="CF":2,ACT="XC":5,ACT="XR":5,ACT="DC":3,ACT="UX":1,1:0)
 I TYPE=3&($G(DENY)'="") S TYPE=4
 Q TYPE
RECHK(HLMSGIEN,PROV,RX2) ;EP check for changes
 ;Accept is not allowed if provider and/or supervisor changes were made.
 ;Get the current data and check it against the data sent in the message.
 ;change the accept to accept w/change.
 N CHG,SUP,OLDX,NEWX,INST,LN,FN
 S CHG=0
 ;Check the supervisor fields
 S SUP=$$GET1^DIQ(49,$$GET1^DIQ(200,PROV,29,"I"),2,"I")
 S NEWX=$$GET1^DIQ(200,+SUP,41.99) ; Immediate Supervisor NPI
 S OLDX=$$GETVAL^APSPES2(HLMSGIEN,"ORC",11,1)
 I OLDX'=NEWX S CHG=1 Q CHG
 S NEWX=$P($$GET1^DIQ(200,SUP,.01)," ",1)
 S LN=$$GETVAL^APSPES2(HLMSGIEN,"ORC",11,2)
 S FN=$$GETVAL^APSPES2(HLMSGIEN,"ORC",11,3)
 S OLDX=LN_","_FN
 I OLDX'=NEWX S CHG=1 Q CHG
 S NEWX=$$PRVDEA^APSPES9(SUP)
 S OLDX=$$GETVAL^APSPES2(HLMSGIEN,"ORC",11,10)
 I OLDX'=NEWX S CHG=1 Q CHG
 ;Next check the ordering provider fields
 S NEWX=$$SPI^APSPES1(PROV)
 S OLDX=$$GETVAL^APSPES2(HLMSGIEN,"ORC",12,1)
 I OLDX'=NEWX S CHG=1 Q CHG
 S NEWX=$P($$GET1^DIQ(200,PROV,.01)," ",1)
 S LN=$$GETVAL^APSPES2(HLMSGIEN,"ORC",12,2)
 S FN=$$GETVAL^APSPES2(HLMSGIEN,"ORC",12,3)
 S OLDX=LN_","_FN
 I OLDX'=NEWX S CHG=1 Q CHG
 S NEWX=$$PRVDEA^APSPES9(PROV)
 S OLDX=$$GETVAL^APSPES2(HLMSGIEN,"ORC",12,10)
 I OLDX'=NEWX S CHG=1 Q CHG
 ;Get institution data for address check
 S INST=+$$GETRINST^APSPES1($P(RX2,U,9))
 S:'INST INST=+$G(DUZ(2))
 S NEWX=$$GET1^DIQ(4,INST,1.01)
 S OLDX=$$GETVAL^APSPES2(HLMSGIEN,"ORC",24,1)
 I OLDX'=NEWX S CHG=1 Q CHG
 S NEWX=$$GET1^DIQ(4,INST,1.02)
 S OLDX=$$GETVAL^APSPES2(HLMSGIEN,"ORC",24,2)
 I OLDX'=NEWX S CHG=1 Q CHG
 S NEWX=$$GET1^DIQ(4,INST,1.03)
 S OLDX=$$GETVAL^APSPES2(HLMSGIEN,"ORC",24,3)
 I OLDX'=NEWX S CHG=1 Q CHG
 S NEWX=$$GET1^DIQ(5,$$GET1^DIQ(4,INST,.02,"I"),1)
 S OLDX=$$GETVAL^APSPES2(HLMSGIEN,"ORC",24,4)
 I OLDX'=NEWX S CHG=1 Q CHG
 S NEWX=$E($$GET1^DIQ(4,INST,1.04,"I"),1,5)
 S OLDX=$$GETVAL^APSPES2(HLMSGIEN,"ORC",24,5)
 I OLDX'=NEWX S CHG=1 Q CHG
 ;Check for age changes for children
 S CHG=$$CHKVITL^APSPES7(DFN,HLMSGIEN)
 Q CHG
GHB(RX) ;EP-
 N RXNORM,SUBSET,INPUT,INSUB,RET
 S RET=""
 S RXNORM=$$GET1^DIQ(52,RX,9999999.27)
 I +RXNORM D
 .S SUBSET="RXNO EPCS GHB"
 .S INPUT=+RXNORM_U_SUBSET_U_1552
 .S INSUB=$$CIDINSB(INPUT)
 .I +INSUB D
 ..S RET=$$GET1^DIQ(52,RX,9999999.21)
 ..S RET=$$TRIM^XLFSTR($P(RET,"|",1))
 ..I $L(RET)>35 S RET="GHB:"_$E(RET,1,35)
 ..E  S RET="GHB:"_RET
 Q RET
CIDINSB(INPUT) ;Return whether a concept id is in a subset
 ;
 ;Input: INPUT -
 I $P(INPUT,U)="" Q 0   ;Missing concept id
 I $P(INPUT,U,2)="" Q 0  ;Missing subset
 I $P(INPUT,U,3)="" S $P(INPUT,U,3)="1552"
 ;
 N VAR,I,FND,STS,IN
 ;
 ;Lookup by ID
 S STS=$$CNCLKP^BSTSAPI("VAR",$P(INPUT,U)_U_$P(INPUT,U,3))
 ;
 ;Check if in subset
 S FND=0,I="" F  S I=$O(VAR(1,"SUB",I)) Q:I=""  D  Q:FND
 .I $G(VAR(1,"SUB",I,"SUB"))=$P(INPUT,U,2) S FND=1
 Q FND
 ;IHS/MSC/MGH patch 1026 check for duplicates of change type U
UDUPCHK(MSGIEN,SSNUM,CTYPE,OLD) ;Check the data in the 2 fields
 N NEWVAL,OLDVAL,HLMSG,OLDIEN,ORGIEN,DUP,DONE
 S (DONE,ORGIEN)=0
 S OLD=$G(OLD)
 ;Get the old message ID
 S DUP=0 F  S DUP=$O(^APSPRREQ("G",SSNUM,DUP)) Q:'+DUP!(DONE=1)!(DUP=OLD)  D
 .S OLDMSG=$$GET1^DIQ(9009033.91,DUP,.01)
 .S OLDTYP=$$GET1^DIQ(9009033.91,DUP,7.4)
 .I OLDTYP=CTYPE D
 ..I OLDTYP="U" D
 ...S ORGIEN=$$VALCHK(OLDMSG,DUP,MSGIEN)
 ...I +ORGIEN S DONE=1
 ..E  S ORGIEN=DUP,DONE=1
 Q ORGIEN
VALCHK(OLDMSG,OLDIEN,MSGIEN) ;Check the value of the ZSF segments for a potential match
 N DUP,OLDVAL,NEWVAL
 S DUP=0
 S NEWVAL=$$GETVAL^APSPES2(+$G(MSGIEN),"ZSF",1,1)
 S OLDIEN=$O(^APSPRREQ("B",OLDMSG,""))
 S HLMSG=$$GHLDAT^APSPESG1(OLDIEN)
 D SHLVARS^APSPESG
 S OLDVAL=$P(APSPZSF,"|",2)
 I OLDVAL=NEWVAL S DUP=OLDIEN
 Q DUP
SETDUP(OLDIEN,NEWIEN,CTYP,MSGIEN) ;EP-
 N FDA,ERR,IENS,OLDTYP,DUP
 S OLDTYP=$$GET1^DIQ(9009033.91,OLDIEN,7.4)
 Q:OLDTYP'=CTYP
 I CTYP="U" D  Q:'+DUP
 .S OLDMSG=$$GET1^DIQ(9009033.91,OLDIEN,.01)
 .S DUP=$$VALCHK^APSPES11(OLDMSG,OLDIEN,MSGIEN)
 I $D(APSPRREQ(NEWIEN,9,"B",OLDIEN))<10 D
 .S IENS="+1,"_NEWIEN_","
 .S FDA(9009033.919,IENS,.01)=OLDIEN
 .D UPDATE^DIE("","FDA")
 Q
