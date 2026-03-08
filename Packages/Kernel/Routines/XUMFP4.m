XUMFP4 ;CIOFO-SF/RAM - Master File C/S Params INSTITUTION ;06/28/00
 ;;8.0;KERNEL;**206,217,294,335**;Jul 10, 1995
 ;
 ;
 ; This routine sets up the parameters required by the INSTITUTION (#4)
 ; file for the Master File server mechanism.
 ;
 ;  ** This routine is not a supported interface -- use XUMFP **
 ;
 ;  See XUMFP for parameter list documentation
 ;
 N PKV,HLFS,HLCS,RT,RF
 ;
 S ^TMP("XUMF MFS",$J,"PARAM","PRE")="PRE^XUMFP4C"
 S ^TMP("XUMF MFS",$J,"PARAM","POST")="POST^XUMFP4C"
 ;S ^TMP("XUMF MFS",$J,"PARAM","PRE")="PRE^XUMFR"
 ;S ^TMP("XUMF MFS",$J,"PARAM","POST")="POST^XUMFR"
 ;
 I $O(HL(""))="" D
 .I 'PROTOCOL D
 ..S:UPDATE PROTOCOL=$O(^ORD(101,"B","XUMF MFN",0))
 ..S:QUERY PROTOCOL=$O(^ORD(101,"B","XUMF MFQ",0))
 .S:'PROTOCOL ERROR="1^invalid protocol" Q:ERROR
 .S ^TMP("XUMF MFS",$J,"PARAM","PROTOCOL")=PROTOCOL
 .D INIT^HLFNC2(PROTOCOL,.HL)
 ;
 I $O(HL(""))="" S ERROR="1^"_$P(HL,U,2) Q
 S HLFS=HL("FS"),HLCS=$E(HL("ECH"))
 ;
 I QUERY D QRD^XUMFP4C
 ;
 ; MFI -- Master File Identification Segment
 S ^TMP("XUMF MFS",$J,"PARAM","MFI")="Z04"  ;Master File Identifier
 S ^TMP("XUMF MFS",$J,"PARAM","MFAI")=""  ;Application Identifier
 S ^TMP("XUMF MFS",$J,"PARAM","FLEC")="UPD"  ;File-Level Event Code
 S ^TMP("XUMF MFS",$J,"PARAM","ENDT")=""  ;Entered Data/Time
 S ^TMP("XUMF MFS",$J,"PARAM","MFIEDT")=""  ;Effective Date/Time
 S ^TMP("XUMF MFS",$J,"PARAM","RLC")="NE"  ;Response Level Code
 ;
 ; MFE -- Master File Entry
 I $G(^TMP("XUMF MFS",$J,"PARAM","RLEC"))="" D  ;Record-Level Event Code
 .S ^TMP("XUMF MFS",$J,"PARAM","RLEC")="MUP"
 S ^TMP("XUMF MFS",$J,"PARAM","MFNCID")=""  ;MFN Control ID
 I $G(^TMP("XUMF MFS",$J,"PARAM","MFEEDT"))="" D  ;Effective Date/Time
 .S ^TMP("XUMF MFS",$J,"PARAM","MFEEDT")=$$HLDATE^HLFNC($$NOW^XLFDT)
 ;
SEG ; -- ZIN segment
 ;
 S ^TMP("XUMF MFS",$J,"PARAM","MULT","ZIN",8)=""
 S ^TMP("XUMF MFS",$J,"PARAM","MKEY","ZIN",8)="VISN"
 S ^TMP("XUMF MFS",$J,"PARAM","MULT","ZIN",9)=""
 S ^TMP("XUMF MFS",$J,"PARAM","MKEY","ZIN",9)="PARENT FACILITY"
 S ^TMP("XUMF MFS",$J,"PARAM","MULT","ZIN",10)=10
 S ^TMP("XUMF MFS",$J,"PARAM","MULT","ZIN",11)=10
 S ^TMP("XUMF MFS",$J,"PARAM","MULT","ZIN",12)=12
 S ^TMP("XUMF MFS",$J,"PARAM","MULT","ZIN",13)=12
 ;
 I IEN D
 .I $G(^DIC(4,IEN,99)) D
 ..S PKV=$P(^DIC(4,IEN,99),U)_HLCS_"STATION NUMBER"_HLCS_"D"
 .;S PKV=$P($G(^DIC(4,+IEN,99)),U)_HLCS_"STATION NUMBER"_HLCS_"D"
 .I CDSYS'="" D
 ..S $P(PKV,HLCS,2)=$P($G(^DIC(4,+IEN,0)),U),$P(PKV,HLCS,3)=CDSYS
 .S ^TMP("XUMF MFS",$J,"PARAM","PKV")=PKV  ; Primary Key Value
 .S ^TMP("XUMF MFS",$J,"PARAM","IENS","ZIN",8)="1,"_IEN_","
 .S ^TMP("XUMF MFS",$J,"PARAM","KEY","ZIN",4.014,"1,"_IEN_",")="VISN"
 .S ^TMP("XUMF MFS",$J,"PARAM","IENS","ZIN",9)="2,"_IEN_","
 .S ^TMP("XUMF MFS",$J,"PARAM","KEY","ZIN",4.014,"2,"_IEN_",")="PARENT FACILITY"
 .S RF=$$RF^XUAF4(IEN) D:RF
 ..S ^TMP("XUMF MFS",$J,"PARAM","IENS","ZIN",10)=$P(RF,U,3)_","_IEN_","
 ..S ^TMP("XUMF MFS",$J,"PARAM","IENS","ZIN",11)=$P(RF,U,3)_","_IEN_","
 ..S ^TMP("XUMF MFS",$J,"PARAM","KEY","ZIN",4.999,$P(RF,U,3)_","_IEN_",")=$P(RF,U,3)
 .S RT=$$RT^XUAF4(IEN) D:RT
 ..S ^TMP("XUMF MFS",$J,"PARAM","IENS","ZIN",12)=$P(RT,U,3)_","_IEN_","
 ..S ^TMP("XUMF MFS",$J,"PARAM","IENS","ZIN",13)=$P(RT,U,3)_","_IEN_","
 ..S ^TMP("XUMF MFS",$J,"PARAM","KEY","ZIN",4.999,$P(RT,U,3)_","_IEN_",")=$P(RT,U,3)
 ;
 I NEW D
 .S PKV="NEW"_HLCS_"STATION NUMBER"_HLCS_"D"
 .S ^TMP("XUMF MFS",$J,"PARAM","PKV")=PKV  ; Primary Key Value
 ;
 ; ZIN -- VA Specific VHA Institution Segment sequence
 S ^TMP("XUMF MFS",$J,"PARAM","SEGMENT")="ZIN"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",1,.01)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",2,99)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",3,11)="ID"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",4,13)="CE^~FACILITY TYPE~VA"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",5,100)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",6,101)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",7,.02)="ST"
 ; associations -- VISN
 I '$P($G(^DIC(4,+IEN,99)),U,4) D
 .S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",8,"FILE")=4.014
 .S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",8,"FIELD")=1
 .S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",8,"DTYP")="CE^~VISN~VA"
 .; associations -- parent
 .S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",9,"FILE")=4.014
 .S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",9,"FIELD")="1"
 .S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",9,"DTYP")="ST"
 ; history -- old station number
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",10,"FILE")=4.999
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",10,"FIELD")=.01
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",10,"DTYP")="DT"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",11,"FILE")=4.999
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",11,"FIELD")=".06"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",11,"DTYP")="ST^^:99"
 ; history -- new station number
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",12,"FILE")=4.999
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",12,"FIELD")=.01
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",12,"DTYP")="DT"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",13,"FILE")=4.999
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",13,"FIELD")=".05"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",13,"DTYP")="ST^^:99"
 ; physical address
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",14.1,.01)="SAD"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",14.2,1.01)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",14.3,1.03)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",14.4,.02)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",14.5,1.04)="ST"
 ; mailing address
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",15.1,.01)="SAD"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",15.2,4.01)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",15.3,4.03)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",15.4,4.04)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",15.5,4.05)="ST"
 ; agency code
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZIN","SEQ",16,95)="CE^~AGENCY CODE~VA"
 ;
GROUP ; -- query group
 ;
 D GROUP^XUMFP4C
 ;
 Q
 ;
