XMXSEC ;ISC-SF/GMB-Message security and restrictions ;05/27/99  09:51
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; All entry points covered by DBIA 2731.
BCAST(XMZ) ; 0=msg was not broadcast; 1=msg was broadcast
 Q:$D(^XMB(3.9,XMZ,1,"C","* (Broadcast to all local user")) 1
 Q:$D(^XMB(3.9,XMZ,1,"C","* (Broadcast to all local users)")) 1
 Q 0
ZCLOSED(XMZ) ;
 Q $$CLOSED($G(^XMB(3.9,XMZ,0)))
CLOSED(XMZREC) ; 0=msg is not closed; 1=msg is closed
 Q "^Y^y^"[(U_$P(XMZREC,U,9)_U)
ZCONFID(XMZ) ;
 Q $$CONFID($G(^XMB(3.9,XMZ,0)))
CONFID(XMZREC) ; 0=msg is not confidential; 1=msg is confidential
 Q "^Y^y^"[(U_$P(XMZREC,U,11)_U)
ZCONFIRM(XMZ) ;
 Q $$CONFIRM($G(^XMB(3.9,XMZ,0)))
CONFIRM(XMZREC) ; 0=msg is not confirm receipt requested; 1=msg is confirm
 Q "^Y^y^"[(U_$P(XMZREC,U,5)_U)
ZINFO(XMZ) ;
 Q $$INFO($G(^XMB(3.9,XMZ,0)))
INFO(XMZREC) ; 0=msg is not information only; 1=msg is information only
 Q "^Y^y^"[(U_$P(XMZREC,U,12)_U)
ZORIGIN8(XMDUZ,XMZ) ;
 Q $$ORIGIN8R(XMDUZ,$G(^XMB(3.9,XMZ,0)))
ORIGIN8R(XMDUZ,XMZREC) ; Did the user send the message?
 ; 1=user is the originator ; 0=user is NOT the originator
 Q:XMDUZ=$P(XMZREC,U,2) 1
 Q:XMDUZ=$P(XMZREC,U,4) 1
 Q:XMDUZ=DUZ 0
 Q:DUZ=$P(XMZREC,U,2) 1
 Q:DUZ=$P(XMZREC,U,4) 1
 Q 0
ZPRI(XMZ) ;
 Q $$PRIORITY($G(^XMB(3.9,XMZ,0)))
PRIORITY(XMZREC) ; 0=msg is not priority; 1=msg is priority
 Q $P(XMZREC,U,7)["P"
SURRCONF(XMDUZ,XMZ) ; 0=msg is not confidential; 1=msg is confidential, and surrogate may not read it.
 ; We already know that XMDUZ'=DUZ.
 ; But the surrogate may read a confidential message if it was the
 ; surrogate who sent it.
 Q:"^Y^y^"'[(U_$P($G(^XMB(3.9,XMZ,0)),U,11)_U) 0
 Q:DUZ=$P(^(0),U,2) 0  ; naked ref from above
 Q:DUZ=$P(^(0),U,4) 0  ; naked ref from above
 Q 1
ACCESS(XMDUZ,XMZ,XMZREC) ; Determines user access to a message.
 ; 1=user may access; 0=user may not access
 Q:$D(^XMB(3.7,"M",XMZ,XMDUZ)) 1  ; Message is in user's mailbox
 N XMPRE
 S XMPRE=$P(^XMB(3.7,XMDUZ,0),U,7)
 I XMPRE,$P($G(^XMB(3.9,XMZ,.6)),U,1)<XMPRE D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="You may not access any message prior to "_$$MMDT^XMXUTIL1(XMPRE)
 . S ^TMP("XMERR",$J,XMERR,"TEXT",2)="unless someone forwards it to you."
 Q:$D(^XMB(3.9,XMZ,1,"C",XMDUZ)) 1  ; User is recipient
 ;Q:$D(^XMB(3.9,XMZ,1,"C",DUZ)) 1 ; Surrogate is a recipient.
 Q:$$BCAST(XMZ) 1
 I $G(XMZREC)="" S XMZREC=$G(^XMB(3.9,XMZ,0))
 I $P(XMZREC,U,8) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Message "_XMZ_" is a response to message "_$P(XMZREC,U,8)_"."
 I $$ORIGIN8R(XMDUZ,XMZREC) D  Q 1  ; User is sender
 . D ADDRECP^XMTDL(XMZ,$P(XMZREC,U,7)["P",XMDUZ)
 . ;D LASTREAD^XMTDL(XMZ,XMDUZ,$P(XMZREC,U,3))
 S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 S ^TMP("XMERR",$J,XMERR,"TEXT",1)="You are neither a sender nor a recipient of this message."
 S ^TMP("XMERR",$J,XMERR,"TEXT",2)="If you need to see it, ask someone to forward it to you."
 Q 0
SURRACC(XMDUZ,XMACCESS,XMZ,XMZREC) ; Determines surrogate access to a message.
 ; 1=surrogate may access; 0=surrogate may not access
 I $G(XMZREC)="" S XMZREC=$G(^XMB(3.9,XMZ,0))
 Q:'$$CONFID(XMZREC) 1  ; Message isn't confidential.
 Q:DUZ=$P(XMZREC,U,2) 1 ; Surrogate sent the message.
 Q:DUZ=$P(XMZREC,U,4) 1 ; Surrogate sent the message.
 ;Q:$D(^XMB(3.9,XMZ,1,"C",DUZ)) 1 ; Surrogate is a recipient.
 S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Surrogates may not "_XMACCESS_" CONFIDENTIAL messages."
 Q 0
ANSWER(XMDUZ,XMZ,XMZREC) ; Answer (1=may, 0=may not)
 I DUZ=.6!(XMDUZ=.6) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="SHARED,MAIL may not answer a message."
 I XMDUZ'=DUZ Q:'$$WPRIV 0  Q:'$$SURRACC(XMDUZ,"answer",XMZ,.XMZREC) 0
 I $G(XMZREC)="" S XMZREC=$G(^XMB(3.9,XMZ,0))
 I $$PAKMAN^XMXSEC1(XMZ,XMZREC) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="May not answer a PackMan message."
 I $D(^XMB(3.9,XMZ,"K")) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="May not answer a scrambled message.  Use Reply."
 I "^^"[$G(^XMB(3.7,XMDUZ,"NS1")) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Must have a network signature in order to answer a message."
 Q 1
COPY(XMDUZ,XMZ,XMZREC) ; Copy (1=may, 0=may not)
 I XMDUZ'=DUZ Q:'$$WPRIV 0  Q:'$$SURRACC(XMDUZ,"copy",XMZ,.XMZREC) 0
 I $G(XMZREC)="" S XMZREC=$G(^XMB(3.9,XMZ,0))
 I $$CLOSED(XMZREC),'$$ORIGIN8R(XMDUZ,XMZREC) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Only the message originator may copy CLOSED messages."
 I XMDUZ=.6,DUZ'=$P(XMZREC,U,2),DUZ'=$P(XMZREC,U,4) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Only the originator may copy messages in SHARED,MAIL"
 I $D(^XMB(3.9,XMZ,"K")) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="May not copy a scrambled message."
 Q 1
DELETE(XMDUZ,XMK,XMZ,XMZREC) ; Delete, Terminate (1=may, 0=may not)
 Q:XMDUZ=DUZ 1
 Q:'$$RWPRIV 0
 I XMDUZ=.5,XMK>999 Q 1
 Q:'$$SURRACC(XMDUZ,"delete",XMZ,.XMZREC) 0
 I $G(XMZREC)="" S XMZREC=$G(^XMB(3.9,XMZ,0))
 I XMDUZ=.6,DUZ'=$P(XMZREC,U,2),DUZ'=$P(XMZREC,U,4),'$D(^XUSEC("XMMGR",DUZ)),'$D(^XMB(3.7,"AB",DUZ,.5,0)) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Only the originator, postmaster surrogate, or XMMGR key holder"
 . S ^TMP("XMERR",$J,XMERR,"TEXT",2)="may Delete, Terminate, Save, or Filter messages in SHARED,MAIL"
 Q 1
FORWARD(XMDUZ,XMZ,XMZREC) ; Forward (1=may, 0=may not)
 I XMDUZ'=DUZ Q:'$$RWPRIV 0  Q:'$$SURRACC(XMDUZ,"forward",XMZ,.XMZREC) 0
 I $G(XMZREC)="" S XMZREC=$G(^XMB(3.9,XMZ,0))
 I $$CLOSED(XMZREC),'$$ORIGIN8R(XMDUZ,XMZREC) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Only the message originator may forward CLOSED messages."
 I XMDUZ=.6,DUZ'=$P(XMZREC,U,2),DUZ'=$P(XMZREC,U,4) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Only the originator may forward messages in SHARED,MAIL"
 Q 1
LATER(XMDUZ) ; Later (1=may, 0=may not)
 I DUZ=.6!(XMDUZ=.6) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="SHARED,MAIL may not 'later' a message."
 Q:XMDUZ=DUZ 1
 Q $$RWPRIV
MOVE(XMDUZ,XMZ,XMZREC) ; Save or Filter (1=may, 0=may not)
 Q:XMDUZ=DUZ 1
 Q:'$$RWPRIV 0
 ;Q:'$$SURRACC(XMDUZ,"save",XMZ,.XMZREC) 0
 I $G(XMZREC)="" S XMZREC=$G(^XMB(3.9,XMZ,0))
 I XMDUZ=.6,DUZ'=$P(XMZREC,U,2),DUZ'=$P(XMZREC,U,4),'$D(^XUSEC("XMMGR",DUZ)),'$D(^XMB(3.7,"AB",DUZ,.5,0)) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Only the originator, postmaster surrogate, or XMMGR key holder"
 . S ^TMP("XMERR",$J,XMERR,"TEXT",2)="may Delete, Terminate, Save, or Filter messages in SHARED,MAIL"
 Q 1
READ(XMDUZ,XMZ,XMZREC) ; Read or Print (1=may, 0=may not)
 Q:XMDUZ=DUZ 1
 Q $$SURRACC(XMDUZ,"access",XMZ,.XMZREC)
REPLY(XMDUZ,XMZ,XMZREC) ; Reply (1=may, 0=may not)
 I DUZ=.6 D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="May not reply to message as SHARED,MAIL"
 I XMDUZ'=DUZ Q:'$$RWPRIV 0  Q:'$$SURRACC(XMDUZ,"reply to",XMZ,.XMZREC) 0
 I $G(XMZREC)="" S XMZREC=$G(^XMB(3.9,XMZ,0))
 I $D(^XMB(3.9,XMZ,"K")),$$PAKMAN^XMXSEC1(XMZ,XMZREC) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="May not reply to secure PackMan message."
 Q:$$ORIGIN8R(XMDUZ,XMZREC) 1
 I $$INFO(XMZREC) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="Only originator may reply to 'INFORMATION ONLY' message."
 I $P($G(^XMB(3.9,XMZ,1,+$O(^XMB(3.9,XMZ,1,"C",XMDUZ,0)),"T")),U,1)["I" D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="'INFORMATION ONLY' recipient may not reply to message."
 I $P(XMZREC,U,2)["POSTMASTER@" D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"XMZ")=XMZ
 . S ^TMP("XMERR",$J,XMERR,"TEXT",1)="May not reply to message from remote POSTMASTER."
 Q 1
SEND(XMDUZ,XMINSTR) ; Send (1=may, 0=may not)
 I DUZ=.6!(XMDUZ=.6) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="SHARED,MAIL may not send a message."
 Q:XMDUZ=DUZ 1
 Q:$D(XMINSTR("FROM")) 1
 Q:XMDUZ=.5 1
 Q $$WPRIV
RWPRIV() ; Does the surrogate have 'read' or 'write' privilege? (1=yes, 0=no)
 Q:$G(XMV("PRIV"))["R"!($G(XMV("PRIV"))["W") 1
 S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="You do not have 'read' or 'write' privilege for "_XMV("NAME")
 Q 0
RPRIV() ; Does the surrogate have 'read' privilege? (1=yes, 0=no)
 Q:$G(XMV("PRIV"))["R" 1
 S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="You do not have 'read' privilege for "_XMV("NAME")
 Q 0
WPRIV() ; Does the surrogate have 'write' privilege? (1=yes, 0=no)
 Q:$G(XMV("PRIV"))["W" 1
 S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="You do not have 'write' privilege for "_XMV("NAME")
 Q 0
POSTPRIV() ; Perform postmaster actions (1=may, 0=may not)
 ; This includes permission to perform group message actions in Shared,Mail.
 I '$D(^XUSEC("XMMGR",DUZ)),'$D(^XMB(3.7,"AB",DUZ,.5)) D  Q 0
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Only a POSTMASTER surrogate or XMMGR key holder may do this."
 Q 1
ZPOSTPRV() ; Perform postmaster actions (1=may, 0=may not)
 ; This includes permission to perform group message actions in Shared,Mail.
 Q:$D(^XUSEC("XMMGR",DUZ)) 1
 Q:$D(^XMB(3.7,"AB",DUZ,.5)) 1
 Q 0
