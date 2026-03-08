XMA2 ;(WASH ISC)/CAP/THM-Create Message Stub ;05/13/99  06:24
 ;;7.1;MailMan;**5,6,10,15,39,50**;Jun 02, 1994
 ; Entry points (DBIA 10066):
 ; GET  get a message number
 ; XMZ  get a message number
 ;
XMZ ; Create stub/return error
 ; In:
 ; XMDUZ  User's DUZ or free text
 ; XMSUB  Message subject
 ; Out:
 ; XMZ    Message number (-1 if error)
 D MAKESTUB($G(XMDUZ),XMSUB,.XMZ,1)
 Q
GET ; Create stub
 ; In:
 ; XMDUZ  User's DUZ or free text
 ; XMSUB  Message subject
 ; Out:
 ; XMZ    Message number (HALT if error)
 D MAKESTUB($G(XMDUZ),XMSUB,.XMZ)
 Q
MAKESTUB(XMDUZ,XMSUBJ,XMZ,XMRETURN) ;
 N XMZREC,XMSENDR
 I '$G(DUZ) N DUZ D DUZ^XUP(.5)
 I XMDUZ=0!(XMDUZ="") S XMDUZ=DUZ
 I $L(XMSUBJ)>65 S XMSUBJ=$E(XMSUBJ,1,65)
 I $L(XMSUBJ)<3 S XMSUBJ=XMSUBJ_"..."
 D VSUBJ^XMXPARM(.XMSUBJ)
 I $D(XMERR) D  Q
 . S XMZ=-1
 . D:'$D(ZTQUEUED) SHOW^XMJERR
 . I '$G(XMRETURN) G ABORT
 . H 1
 D CRE8XMZ^XMXSEND(XMSUBJ,.XMZ)
 I XMZ<1 D  Q
 . W:'$D(ZTQUEUED) !,"  Please try again later.",!
 . I '$G(XMRETURN) G ABORT
 . K XMERR,^TMP("XMERR",$J)
 . H 1
 S XMZREC=^XMB(3.9,XMZ,0)
 I XMDUZ=.6 S XMDUZ=DUZ,XMSENDR=.6
 E  S XMSENDR=DUZ
 I XMDUZ=.5,XMSENDR'=.5 S $P(XMZREC,U,12)="y" ;Info Only / sent by Postmaster
 S $P(XMZREC,U,2,4)=XMDUZ_U_$$NOW^XLFDT()_U_$S(XMDUZ'=XMSENDR&+XMDUZ:XMSENDR,1:"")
 S ^XMB(3.9,XMZ,0)=XMZREC
 Q
ABORT ;
 S X=^TMP("XMERR",$J,1,"TEXT",1)
 K XMERR,^TMP("XMERR",$J)
 X X
 Q
