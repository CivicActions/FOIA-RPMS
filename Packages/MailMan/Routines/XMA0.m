XMA0 ;(WASH ISC)/CAP/THM-Print Message ;06/24/99  10:53
 ;;7.1;MailMan;**15,36,50**;Jun 02, 1994
 ; Entry points (DBIA 1230):
 ; ENTPRT  Print a message (interactive)
 ; HDR     Print a message (headerless)
 ; PR2     Print a message
 ;
ENTPRT ; Print a message (interactive)
 ; Needs:
 ; DUZ
 ; XMZ  Message number
 ; XMK  Basket number
 N XMV
 D INIT^XMVVITAE
 D PRINT^XMJMP(XMDUZ,XMK,$P(^XMB(3.7,XMDUZ,2,XMK,0),U,1),XMZ)
 Q
HDR ; Print a message (headerless)
 ; Needs:
 ; DUZ
 ; XMK    basket number
 ; XMZ    message number
 ; IO     output device
 ; Optional:
 ; XMDUZ
 ; $P(XMTYPE,";",6) response from which to start printing
 D PRINTIT(0,$G(XMTYPE))
 Q
PR2 ; Print a message
 ; Needs:
 ; DUZ
 ; XMK    basket number
 ; XMZ    message number
 ; IO     output device
 ; Optional:
 ; XMDUZ
 ; $P(XMTYPE,";",6) response from which to start printing
 D PRINTIT(1,$G(XMTYPE))
 Q
PRINTIT(XMPRTHDR,XMWHICH) ;
 N XMV,XMKN,XMRESPS,XMPTR,XMRECIPS
 Q:XMWHICH=U
 D INIT^XMVVITAE
 S XMKN=$P(^XMB(3.7,XMDUZ,2,XMK,0),U,1)
 D RESPONSE^XMJMP(XMDUZ,XMZ,.XMRESPS,.XMPTR)
 S XMRECIPS=0  ; don't print recipients
 S XMWHICH=+P(XMWHICH,";",6)_"-"_XMRESPS  ; print from
 D PRINTMSG^XMJMP
 Q
