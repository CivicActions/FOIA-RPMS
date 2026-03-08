XMXANSER ;ISC-SF/GMB-Answer a msg ;06/14/99  09:27
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces ^XMA11A (ISC-WASH/CAP/THM)
 ; XMDUZ             DUZ of who the msg is from
 ; XMSUBJ            Subject of the msg (defaults to 'Re:' original subject)
 ; XMBODY            Closed root of Body of the msg
 ;                   Must be closed root, passed by value.  See WP_ROOT
 ;                   definition for WP^DIE(), FM word processing filer.
 ; XMTO              Additional addressees, besides msg originator
 ; XMINSTR("FROM")   String saying from whom (default is user)
 ; XMINSTR("SELF BSKT") Basket to deliver to if sender is recipient
 ; XMINSTR("SHARE BSKT") Basket to deliver to if recipient is "SHARED,MAIL"
 ; XMINSTR("SHARE DATE") Delete date if recipient is "SHARED,MAIL"
 ; XMINSTR("RCPT BSKT") Basket name (only) to deliver to for other recipients
 ; XMINSTR("VAPOR")  Date on which to vaporize (delete) this message
 ;                   from recipient baskets
 ; XMINSTR("LATER")  Date on which to send this msg, if not now
 ; XMINSTR("FLAGS")  Any or all of the following:
 ;                   P Priority
 ;                   I Information only (may not be replied to)
 ;                   X Closed msg (may not be forwarded)
 ;                   C Confidential (surrogates may not read)
 ;                   S Send to sender (make sender a recipient)
 ;                   R Confirm receipt
 ; XMINSTR("SCR KEY")   Scramble key (implies that msg should be scrambled)
 ; XMINSTR("SCR HINT")  Hint (to guess the scramble key)
 ; XMINSTR("KEYS")   List of keys needed by recipient to read msg (NOT IMPLEMENTED)
 ; XMINSTR("TYPE")   Msg type is one of the following:
 ;                   D Document
 ;                   S Spooled Document
 ;                   X DIFROM
 ;                   O ODIF
 ;                   B BLOB
 ;                   K KIDS
 ;
 ; Output:
 ; XMZR              The number of the message containing the answer.
ANSRMSG(XMDUZ,XMK,XMKZ,XMSUBJ,XMBODY,XMTO,XMINSTR,XMZR) ;
 N XMZ,XMZREC,XMZSENDR
 K XMERR,^TMP("XMERR",$J)
 D CHKMSG^XMXSEC1(XMDUZ,.XMK,.XMKZ,.XMZ,.XMZREC) Q:$D(XMERR)
 Q:'$$ANSWER^XMXSEC(XMDUZ,XMZ,XMZREC)
 S:$G(XMSUBJ)="" XMSUBJ="Re: "_$P(XMZREC,U,1)
 D CRE8XMZ^XMXSEND(XMSUBJ,.XMZR) Q:$D(XMERR)
 S XMZSENDR=$P(XMZREC,U,2)
 S:XMZSENDR["@" XMZSENDR=$$REPLYTO1^XMXREPLY(XMZ)
 D COMPOSE(XMZ,$P(XMZREC,U,1),XMZSENDR,XMZR,XMBODY)
 S XMTO(XMZSENDR)=""
 D ADDRNSND^XMXSEND(XMDUZ,XMZR,.XMTO,.XMINSTR)
 Q
COMPOSE(XMZ,XMZSUBJ,XMZSENDR,XMZR,XMBODY) ;
 D COPY(XMZ,XMZSUBJ,XMZSENDR,XMZR)
 ; File XMBODY, with the "append" option
 D MOVEBODY^XMXSEND(XMZR,XMBODY,"A") ; Put the msg body in place
 D NETSIG(XMZR)
 Q
COPY(XMZO,XMZOSUBJ,XMZOFROM,XMZ) ; Copy the original msg, putting ">" in front of each line.
 N I,J,XMS,XMF
 S XMS=">Original Msg: '"_XMZOSUBJ_"'"
 S XMF="From: "_$$NAME^XMXUTIL(XMZOFROM)
 I $L(XMS)+$L(XMF)<80 D
 . S ^XMB(3.9,XMZ,2,1,0)=XMS_" "_XMF
 . S J=1
 E  D
 . S ^XMB(3.9,XMZ,2,1,0)=XMS
 . S ^XMB(3.9,XMZ,2,2,0)=">"_XMF
 . S J=2
 S J=J+1,^XMB(3.9,XMZ,2,J,0)=">"
 S I=.999999
 F  S I=$O(^XMB(3.9,XMZO,2,I)) Q:I=""  S J=J+1,^XMB(3.9,XMZ,2,J,0)=$E(">"_^(I,0),1,254)
 S J=J+1,^XMB(3.9,XMZ,2,J,0)=""
 S J=J+1,^XMB(3.9,XMZ,2,J,0)=""
 S ^XMB(3.9,XMZ,2,0)="^3.92A^"_J_U_J_U_DT
 Q
NETSIG(XMZ) ;
 N I,XMNSIG
 S XMNSIG(.1)=""
 S XMNSIG(.2)=""
 S XMNSIG(.3)="*******************************************************************************"
 S XMNSIG=$G(^XMB(3.7,XMDUZ,"NS1"))
 F I=1:1:3 S:$P(XMNSIG,U,I)'="" XMNSIG(I)=$P(XMNSIG,U,I)
 S XMNSIG(4)=XMNSIG(.3)
 D MOVEBODY^XMXSEND(XMZ,"XMNSIG","A") ; Add the network signature
 Q
