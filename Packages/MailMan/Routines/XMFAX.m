XMFAX ;ISC-SF/GMB-Fax ;07/08/98  10:51
 ;;7.1;MailMan;**36,50**;Jun 02, 1994
FAX(XMZ) ; Fax a message
 N XMABORT,XMCNT,XMFIEN,XMQUIET
 S XMQUIET=1 ; "quiet flag"
 S XMABORT=0
 D CRE8FAX(XMZ,XMQUIET,.XMCNT,.XMABORT) Q:XMABORT
 D SENDFAX(XMQUIET,XMFIEN,XMCNT)
 Q
CRE8FAX(XMZ,XMQUIET,XMCNT,XMABORT) ;
 N XMFID
 D RECORD(XMQUIET,.XMFID,.XMFIEN,.XMABORT) Q:XMABORT
 L +^AKF("FAX",XMFIEN)
 D RECIPS(XMZ,XMFID,XMFIEN,.XMCNT)
 D BODY(XMZ,XMFIEN)
 L -^AKF("FAX",XMFIEN)
 Q
RECORD(AKQ,AKFAX,AKIEN,XMABORT) ; Add record to fax file
 ; AKFAX    Fax ID
 ; AKIEN    Record number in ^AKF("FAX",
 D NE^AKFAX0 I '$D(AKFAX) S XMABORT=1 Q  ; Add record to fax file
 S $P(^AKF("FAX",AKIEN,0),U,4)=1  ; This is a MailMan-generated fax
 Q
RECIPS(XMZ,XMFID,XMFIEN,XMCNT) ; Add recipients to fax record and update recipient record in mail msg.
 N I,XMREC,XMIENS,XMFDA
 S I="",XMCNT=0
 F  S I=$O(^XMB(3.9,XMZ,1,"AFAX",I)) Q:I=""  D
 . S XMREC=$G(^AKF("FAXR",I,0)) Q:XMREC=""
 . S XMCNT=XMCNT+1
 . S XMIENS="+1,"_XMFIEN_","
 . S XMFDA(589500.01,XMIENS,.01)=I ; Pointer to recipient
 . S XMFDA(589500.01,XMIENS,1)="Awaiting Transmission Path"
 . S XMFDA(589500.01,XMIENS,2)=$P(XMREC,U,2) ; Recipient fax phone
 . S XMFDA(589500.01,XMIENS,3)=$P(XMREC,U,3) ; Recipient physical location
 . S XMFDA(589500.01,XMIENS,4)=$P(XMREC,U,4) ; Recipient voice phone
 . D UPDATE^DIE("","XMFDA") ; Add recipient to fax record
 . S XMIENS=$O(^XMB(3.9,XMZ,1,"AFAX",I,""))_","_XMZ_","
 . S XMFDA(3.91,XMIENS,4)=$$NOW^XLFDT()    ; Current date/time
 . S XMFDA(3.91,XMIENS,5)="@"  ; get rid of status
 . S XMFDA(3.91,XMIENS,13)="@" ; get rid of xref
 . S XMFDA(3.91,XMIENS,14)=XMFID ; fax id
 . D FILE^DIE("","XMFDA") ; Update mail msg recipient
 Q
BODY(XMZ,XMFIEN) ; Copy the msg text to the fax text
 N XMTEXT,XMREC,I,XMDATE,XMFROM
 S XMREC=^XMB(3.9,XMZ,0)
 S I=1,XMTEXT(I)="Subj: "_$P(XMREC,U,1)_"  ["_XMZ_"]"
 S XMDATE=$P(XMREC,U,3) S:+XMDATE=XMDATE XMDATE=$$FMTE^XLFDT(XMDATE,1)
 I $L(XMTEXT(I))+$L(XMDATE)+1>79 S I=I+1,XMTEXT(I)=XMDATE
 E  S XMTEXT(I)=XMTEXT(I)_" "_XMDATE
 S I=I+1,XMTEXT(I)="From: "_$$FROM($P(XMREC,U,2))
 I DUZ'=$P(XMREC,U,2) S I=I+1,XMTEXT(I)="Sender: "_$$FROM(DUZ)
 S I=I+1,XMTEXT(I)="-------------------------------------------------------------------------------"
 S I=I+1,XMTEXT(I)=""
 D WP^DIE(589500,XMFIEN_",",7,"","XMTEXT")
 D WP^DIE(589500,XMFIEN_",",7,"A","^XMB(3.9,"_XMZ_",2)")
 Q 
SENDFAX(AKQ,AKIEN,AKML) ;
 W !,"Sending to fax"
 D QUE^AKFAX0
 Q
FAXHDR(XMFID,XMFTO) ; Print the fax header
 W !,"MailMan FAX for ",XMFTO
 W !,"FAXmail ID: ",XMFID,", Faxed: ",$$FMTE^XLFDT($$NOW^XLFDT,1),!
 Q
FROM(XMFROM) ;
 N XMFREC,XMTITLE,XMNAME
 Q:XMFROM'=+XMFROM XMFROM
 S XMFREC=$G(^VA(200,XMFROM,0)) Q:XMFREC="" $S(XMFROM=.5:"POSTMASTER",1:"USER #"_XMFROM)_"@"_^XMB("NETNAME")
 S XMNAME=$P(XMFREC,U)_"@"_^XMB("NETNAME")
 I $P($G(XMDISPI),U)["T",$P(XMFREC,U,9) D
 . S XMTITLE=$P($G(^DIC(3.1,$P(XMFREC,U,9),0)),U)
 . S:XMTITLE'="" XMNAME=XMNAME_"@"_^XMB("NETNAME")_" - "_XMTITLE
 E  I $P($G(XMDISPI),U)["I",$D(^XMB(3.7,XMFROM,6000)) D
 . N XMINST
 . S XMINST=$P(^XMB(3.7,XMFROM,6000),U)
 . S:XMINST'="" XMNAME=XMNAME_" ("_XMINST_")"
 Q XMNAME
