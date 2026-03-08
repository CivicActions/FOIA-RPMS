XMXEDIT ;ISC-SF/GMB-Edit msg that user has sent to self ;06/14/99  16:40
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; All entry points covered by DBIA 2730.
 ; These entry points edit a message.  They do not perform any checks to
 ; see whether it is appropriate to do so.  That is the responsibility
 ; of the calling routine.
 ; For these entry points, it is expected that:
 ; OPTMSG^XMXSEC2  has been called and has given its permission to
 ;                 edit the message or to toggle information only.
 ; OPTEDIT^XMXSEC2 has been called and has given its permission to
 ;                 edit the particular thing we are editing here.
 ; INMSG2^XMXUTIL2 has been called to set XMINSTR.  These routines expect
 ;                 that XMINSTR has been correctly set.  They will change
 ;                 XMINSTR according to the edit.
CLOSED(XMZ,XMINSTR,XMMSG) ; Toggle Closed msg
 I $D(^TMP("XMY",$J,.6)) D  Q
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Messages addressed to SHARED,MAIL may not be closed."
 D FLAGTOGL(XMZ,1.95,.XMINSTR,"X","Closed",.XMMSG)
 Q
CONFID(XMZ,XMINSTR,XMMSG) ; Toggle Confidential msg
 I $D(^TMP("XMY",$J,.6)) D  Q
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Messages addressed to SHARED,MAIL may not be confidential."
 D FLAGTOGL(XMZ,1.96,.XMINSTR,"C","Confidential",.XMMSG)
 Q
CONFIRM(XMZ,XMINSTR,XMMSG) ; Toggle Confirm receipt of msg
 D FLAGTOGL(XMZ,1.3,.XMINSTR,"R","Confirm Receipt Requested",.XMMSG)
 Q
DELIVER(XMZ,XMDBSKT,XMINSTR,XMMSG) ; Delivery basket
 I XMDBSKT="@" D  Q
 . K XMINSTR("RCPT BSKT")
 . S XMFDA(3.9,XMZ_",",21)="@"
 . D FILE^DIE("","XMFDA")
 . S XMMSG="Delivery basket removed"
 S XMINSTR("RCPT BSKT")=XMDBSKT
 S XMFDA(3.9,XMZ_",",21)=XMINSTR("RCPT BSKT")
 D FILE^DIE("","XMFDA")
 S XMMSG="Delivery basket set"
 Q
INFO(XMZ,XMINSTR,XMMSG) ; Toggle Information only msg
 D FLAGTOGL(XMZ,1.97,.XMINSTR,"I","Information only",.XMMSG)
 Q
PRIORITY(XMZ,XMINSTR,XMMSG) ; Toggle Priority msg
 D FLAGTOGL(XMZ,1.7,.XMINSTR,"P","Priority",.XMMSG)
 Q
SUBJ(XMZ,XMSUBJ,XMIM) ; Replace Subject
 I $G(XMSUBJ)="" S XMSUBJ=$$EZBLD^DIALOG(34012)
 S (XMIM("SUBJ"),XMFDA(3.9,XMZ_",",.01))=$$ENCODEUP^XMXUTIL1(XMSUBJ)
 D FILE^DIE("","XMFDA")
 Q
TEXT(XMZ,XMBODY) ; Replace Text
 D WP^DIE(3.9,XMZ_",",3,"",XMBODY)
 Q
VAPOR(XMZ,XMVAPOR,XMINSTR,XMMSG) ; Vaporize date
 I XMVAPOR="@" D  Q
 . K XMINSTR("VAPOR")
 . S XMFDA(3.9,XMZ_",",1.6)="@"
 . D FILE^DIE("","XMFDA")
 . S XMFDA(3.702,XMZ_","_XMK_","_XMDUZ_",",5)="@"
 . D FILE^DIE("","XMFDA")
 . S XMMSG="Vaporize Date removed"
 S XMINSTR("VAPOR")=XMVAPOR
 S XMFDA(3.9,XMZ_",",1.6)=XMINSTR("VAPOR")
 D FILE^DIE("","XMFDA")
 S XMFDA(3.702,XMZ_","_XMK_","_XMDUZ_",",5)=XMINSTR("VAPOR")
 D FILE^DIE("","XMFDA")
 S XMMSG="Vaporize Date set"
 Q
FLAGTOGL(XMZ,XMFIELD,XMINSTR,XMFLAG,XMTYPE,XMMSG) ; Flag Toggle
 N XMFDA
 I $G(XMINSTR("FLAGS"))[XMFLAG D
 . S XMINSTR("FLAGS")=$TR(XMINSTR("FLAGS"),XMFLAG)
 . S XMMSG="'"_XMTYPE_"' flag removed"
 . I XMFLAG="P" D
 . . S XMFDA(3.9,XMZ_",",XMFIELD)=$S($G(XMINSTR("TYPE"))="":"@",1:XMINSTR("TYPE"))
 . E  S XMFDA(3.9,XMZ_",",XMFIELD)="@"
 E  D
 . S XMINSTR("FLAGS")=$G(XMINSTR("FLAGS"))_XMFLAG
 . S XMMSG="Message flagged '"_XMTYPE_"'"
 . I XMFLAG="P" S XMFDA(3.9,XMZ_",",XMFIELD)=$G(XMINSTR("TYPE"))_"P"
 . E  S XMFDA(3.9,XMZ_",",XMFIELD)="y"
 D FILE^DIE("","XMFDA")
 Q
 ;
 ;#34012 = * No Subject *
