XUMFH ;CIOFO-SF/RAM - Master File HL7 Msg Handler ;06/28/00
 ;;8.0;KERNEL;**206,209,217,218,262,335,261**;Jul 10, 1995
 ;
 ; This routine handles Master File HL7 messages.
 ;
MAIN ; -- entry point
 ;
 N CNT,ERR,I,X,HLFS,HLCS,ERROR,HLRESLTA,IFN,IEN,MTPE,TYPE,ARRAY
 N HDT,KEY,MID,REASON,VALUE,XREF,ALL,GROUP,PARAM,ROOT,SEG,QRD
 N QID,WHAT,WHO,HLSCS,CDSYS
 ;
 D INIT,PROCESS,REPLY,EXIT
 ;
 Q
 ;
INIT ; -- initialize
 ;
 K ^TMP("DILIST",$J),^TMP("DIERR",$J)
 K ^TMP("HLS",$J),^TMP("HLA",$J)
 ;
 S (ERROR,CNT,TYPE,ARRAY)=0
 S HLFS=HL("FS"),HLCS=$E(HL("ECH")),HLSCS=$E(HL("ECH"),4)
 ;
 Q
 ;
PROCESS ; -- pull message text
 ;
 F  X HLNEXT Q:HLQUIT'>0  D
 .Q:$P(HLNODE,HLFS)=""
 .D @($P(HLNODE,HLFS))
 ;
 Q
 ;
MSH ; -- MSH segment
 ;
 Q
 ;
MSA ; -- MSA segment
 ;
 N CODE
 ;
 S CODE=$P(HLNODE,HLFS,2)
 ;
 I CODE="AE"!(CODE="AR") D
 .S ERROR=ERROR_U_$P(HLNODE,HLFS,4)_U_$G(ERR)
 .D EM(ERROR,.ERR)
 ;
 Q
 ;
QRD ; -- QRD segment
 ;
 Q:ERROR
 ;
 S QRD="QRD,QDT,QFC,QP,QID,DRT,DRDT,QLR,WHO,WHAT,WDDC,WDCVQ,QRL"
 ;
 F I=2:1:13 S PARAM($P(QRD,",",I))=$P(HLNODE,HLFS,I)
 S QID=$P(HLNODE,HLFS,5)
 S WHO=$P(HLNODE,HLFS,9)
 I WHO="" D  Q
 .S ERROR="1^QRD segment has null missing WHO parameter"
 .D EM(ERROR,.ERR)
 S WHAT=$P(HLNODE,HLFS,10)
 I WHAT="" D  Q
 .S ERROR="1^QRD segment has null missing WHAT parameter"
 .D EM(ERROR,.ERR)
 ;
 S ARRAY=$S(QID["ARRAY":1,1:0)
 S ALL=$S(WHO["ALL":1,1:0)
 S GROUP=$S(ALL:1,(WHO["IEN"):1,1:0)
 ;
 S:ARRAY TYPE=$S(GROUP:7,1:3)
 S:'ARRAY TYPE=$S(GROUP:5,1:1)
 S:HL("MTN")="MFR" TYPE=TYPE+10
 ;
 S IFN=+WHAT
 S XREF=$P(WHO,HLCS,9),ROOT=$$ROOT^DILFD(IFN,,1)
 S IEN=$O(@ROOT@(XREF,$P(WHO,HLCS),0))
 S IEN=$S(IEN:IEN,1:$P(WHO,HLCS))
 S:$L(XREF)>1 PARAM("CDSYS")=XREF
 ;
 K:ARRAY ^TMP("XUMF ARRAY",$J)
 ;
 Q
 ;
MFI ; -- MFI segment
 ;
 Q:ERROR
 Q:$G(IFN)
 ;
 I $P(HLNODE,HLFS,2)="" D  Q
 .S ERROR="1^MFI segment missing Master File Identifier"
 .D EM(ERROR,.ERR)
 S IFN=$$MFI^XUMFP($P(HLNODE,HLFS,2))
 I 'IFN D  Q
 .S ERROR="1^IFN in MFI could not be resolved"
 .D EM(ERROR,.ERR)
 ;
 Q
 ;
MFE ; -- MFE segment
 ;
 Q:ERROR
 ;Q:$G(IEN)
 ;
 S KEY=$P(HLNODE,HLFS,5) Q:ARRAY
 ;
 I $P(KEY,HLCS)="" D  Q
 .D EM("MFE segment NULL key "_$E(HLNODE,1,80),.ERR)
 .
 S XREF=$P(KEY,HLCS,3)
 S IEN=$$FIND1^DIC(IFN,,"BX",$P(KEY,HLCS),XREF,,"ERR")
 S IEN=$S(IEN:IEN,KEY["ALL":"ALL",$G(ERR)'="":"ERROR",1:"NEW")
 I IEN="ERROR" D  Q
 .D EM("MFE segment couldn't resolve IEN",.ERR)
 .K ERR
 D MAIN^XUMFP(IFN,IEN,TYPE,.PARAM,.ERROR)
 ;
 Q
 ;
ZL7 ; -- Generic Master File
ZIN ; -- VHA Institution segment
ZFT ; -- VHA Facility Type segment
LOC ; -- Location Identification segment
ZZZ ; -- get [Z...] segment(s)
 ;
 Q:ERROR
 Q:IEN="ERROR"
 ;
 I $G(ARRAY) D ARRAY Q
 ;
 N FDA,IENS,FIELD,ERR,PRE,POST,XUMF,MULT,FDA1,SEQ,SEQ1,SEQ2,SEQ3
 ;
 S PRE=$G(^TMP("XUMF MFS",$J,"PARAM","PRE"))
 D:PRE'="" @(PRE)
 ;
 S XUMF=7
 ;
 S SEG=$P(HLNODE,HLFS)
 S IENS=$S(IEN:IEN,1:"+1")_","
 S SEQ=0
 F  S SEQ=$O(^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ)) Q:'SEQ  D
 .S SEQ1=$P(SEQ,"."),SEQ2=$P(SEQ,".",2)
 .S SEQ3=$O(^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ,"HLSCS",0))
 .I SEQ3 D SUBCOMP Q
 .S FIELD=$O(^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ,0))
 .I FIELD=".01" D
 ..N FDA,IEN1
 ..S TYP=$G(^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ,FIELD))
 ..S VALUE=$$VALUE(.HLNODE,SEQ1)
 ..S:SEQ2 VALUE=$P(VALUE,HLCS,SEQ2)
 ..S VALUE=$$DTYP^XUMFP(VALUE,TYP,HLCS,0)
 ..S FDA(IFN,IENS,FIELD)=VALUE
 ..D UPDATE^DIE("E","FDA","IEN1","ERR")
 ..I $D(ERR) D
 ...D EM("update DIE call error message in ZZZ",.ERR)
 ...K ERR
 ..I $D(IEN1) S IENS=IEN1(1)_","
 .I 'FIELD D SUBFILE Q
 .S TYP=$G(^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ,FIELD))
 .S VALUE=$$VALUE(.HLNODE,SEQ)
 .S:SEQ2 VALUE=$P(VALUE,HLCS,SEQ2)
 .S VALUE=$$DTYP^XUMFP(VALUE,TYP,HLCS,0)
 .S FDA(IFN,IENS,FIELD)=VALUE
 ;
 M FDA=FDA1
 ;
 D FILE^DIE("E","FDA","ERR")
 I $D(ERR) D
 .D EM("file DIE call error message in ZZZ",.ERR)
 .K ERR
 ;
 S POST=$G(^TMP("XUMF MFS",$J,"PARAM","POST"))
 D:POST'="" @(POST)
 ;
 K IEN
 ;
 Q
 ;
SUBFILE ; -- process subfile record
 ;
 N IFN,IENS1,KEY1,FIELD,TYP,MKEY,ERR
 ;
 S IFN=^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ,"FILE")
 S FIELD=^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ,"FIELD")
 S TYP=^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ,"DTYP")
 S VALUE=$$VALUE(.HLNODE,SEQ)
 S:SEQ2 VALUE=$P(VALUE,HLCS,SEQ2)
 S VALUE=$$DTYP^XUMFP(VALUE,TYP,HLCS,0)
 ;
 S MULT=$G(^TMP("XUMF MFS",$J,"PARAM","MULT","ZIN",SEQ))
 S MKEY=$G(^TMP("XUMF MFS",$J,"PARAM","MKEY","ZIN",SEQ))
 I MULT=SEQ Q:VALUE=""  D
 .N FDA,IEN
 .S FDA(IFN,"?+1,"_IENS,.01)=VALUE
 .D UPDATE^DIE("E","FDA","IEN","ERR")
 .I $D(ERR) D
 ..D EM("update DIE call error message in SUBFILE",.ERR)
 ..K ERR
 .S IENS1=IEN(1)_","_IENS,MULT(SEQ)=IENS1
 I 'MULT D
 .N FDA,IEN
 .S FDA(IFN,"?+1,"_IENS,.01)=MKEY
 .D UPDATE^DIE("E","FDA","IEN","ERR")
 .I $D(ERR) D
 ..D EM("update DIE call error message in SUBFILE",.ERR)
 ..K ERR
 .S IENS1=IEN(1)_","_IENS,MULT(SEQ)=IENS1
 .S FDA1(IFN,IENS1,.01)=MKEY
 I MULT,MULT'=SEQ S IENS1=$G(MULT(+MULT)) Q:IENS1=""
 S FDA1(IFN,IENS1,FIELD)=VALUE
 ;
 Q
 ;
VALUE(HLNODE,SEQ) ; -- handle HL7 continuation nodes
 ;
 N I,X,Y,N,T,Z,NODE
 ;
 S SEQ=$P($G(SEQ),".") Q:'SEQ ""
 ;
 M Z=HLNODE
 S Z(0)=HLNODE
 ;
 S I=0
 F  S I=$O(Z(I)) Q:'I  D
 .Q:$E(Z(I),1)=HLFS
 .S X=$P(Z(I),HLFS)
 .S Y=$O(Z(I),-1)
 .S Z(Y)=Z(Y)_X
 .S:$L(Z(I),HLFS)'="" Z(I)=HLFS_$P(Z(I),HLFS,2,999)
 .K:$L(Z(I),HLFS)="" Z(I)
 ;
 S X=0
 F  S X=$O(Z(X)) Q:'X  D
 .S X(X)=$L(Z(X),HLFS)-1
 S X(0)=$L(Z,HLFS)-1
 ;
 S (X,N,T)=""
 F  S X=$O(X(X)) Q:X=""  D
 .S T=T+$P(X(X),U),N(T+1)=X
 ;
 S (X,Y)=""
 F  S X=$O(X(X)) Q:X=""  D
 .S $P(X(X),U,2)=Y
 .S Y=+X(X)+Y
 ;
 S NODE=$G(N(+$O(N(SEQ)))) Q:NODE="" ""
 ;
 Q $P(Z(NODE),HLFS,(SEQ-($P(X(NODE),U,2))+1))
 ;
SUBCOMP ; -- subcomponents
 ;
 S SEQ3=0
 F  S SEQ3=$O(^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ,"HLSCS",SEQ3)) Q:'SEQ3  D
 .S FIELD=$O(^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ,"HLSCS",SEQ3,0))
 .S TYP=$G(^TMP("XUMF MFS",$J,"PARAM","SEG",SEG,"SEQ",SEQ,"HLSCS",SEQ3,FIELD))
 .S VALUE=$$VALUE(.HLNODE,SEQ)
 .S VALUE=$P(VALUE,HLCS,SEQ2)
 .S VALUE=$P(VALUE,HLSCS,SEQ3)
 .S VALUE=$$DTYP^XUMFP(VALUE,TYP,HLSCS,0)
 .S FDA(IFN,IENS,FIELD)=VALUE
 ;
 Q
 ;
ARRAY ; -- query data stored in array (not filed)
 ;
 I $P($G(KEY),HLCS)="" D  Q
 .D EM("Null KEY found in the following segment: "_$E(HLNODE,1,80),.ERR)
 .S ERROR=ERROR_U_$G(ERR)
 ;
 M ^TMP("XUMF ARRAY",$J,$P(KEY,HLCS))=HLNODE
 ;
 Q
 ;
REPLY ; -- master file response
 ;
 Q:HL("MTN")="MFR"
 Q:HL("MTN")="MFK"
 Q:HL("MTN")="ACK"
 ;
 S:(TYPE<10) TYPE=(TYPE+10)
 ;
 I HL("MTN")="MFQ" D
 .S IFN=+$G(WHAT) I 'IFN D  Q
 ..S ERROR="1^REPLY MFQ couldn't resolve IFN"
 ..D EM(ERROR,.ERR)
 .S XREF=$P(WHO,HLCS,9),ROOT=$$ROOT^DILFD(IFN,,1)
 .S IEN=$O(@ROOT@(XREF,$P(WHO,HLCS),0))
 .S IEN=$S(IEN:IEN,1:$P(WHO,HLCS))
 ;
 S IFN=$G(IFN),IEN=$G(IEN)
 ;
 D MAIN^XUMFP(IFN,IEN,TYPE,.PARAM,.ERROR)
 D MAIN^XUMFI(IFN,IEN,TYPE,.PARAM,.ERROR)
 ;
 Q
 ;
EXIT ; -- cleanup, and quit
 ;
 K ^TMP("DILIST",$J),^TMP("DIERR",$J),^TMP("HLS",$J),^TMP("HLA",$J)
 ;
 Q
 ;
EM(ERROR,ERR,XMSUB,XMY) ; -- error message
 ;
 N X,XMTEXT,FLG
 ;
 S FLG=0
 ;
 D MSG^DIALOG("AM",.X,80,,"ERR")
 ;
 S X(.1)="HL7 message ID: "_$G(HL("MID"))
 S X(.2)="",X(.3)=$G(ERROR),X(.4)=""
 S:$G(XMSUB)="" XMSUB="MFS ERROR"
 S XMY("G.XUMF ERROR")=""
 S XMTEXT="X("
 ;
 S X=.9 F  S X=$O(X(X)) Q:'X  D
 .I X(X)="" K X(X) Q
 .I X(X)["DINUMed field cannot" S FLG=1 K X(X) Q
 .I X(X)["ASSOCIATION" S FLG=1 K X(X) Q
 .I X(X)["INSTITUTION" S FLG=1 K X(X) Q
 ;
 I FLG Q:'$O(X(.9))
 ;
 D ^XMD
 ;
 Q
 ;
