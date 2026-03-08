XMSERR ;(WASH ISC)/THM/CAP- ERRORS... ;03/18/99  15:52
 ;;7.1;MailMan;**32,50**;Jun 02, 1994
HELONO S ERR=^XMB("NETNAME")_" not Recognized by "_$P(Y3,U),ER=1
 G ERR
MAILNO S ERR="Receiver will not accept Mail."
 Q:+$G(XMRG)'=502
 S XMB="XM_TRANSMISSION_ERROR",XMB(1)="message from you",XMB(2)=XMRG,XMB(3)="The message (Subj: "_$E($P(XMR,U),1,20)_$S($L($P(XMR,U))>20:"...",1:"")_" ["_XMZ_"]) was not transmitted" ;,XMY($P(XMR,U,2))=""
 N XMSRIEN,XMSRTO,XMSRTXT,XMSRI
 ; For every addressee for that site, send reject message to
 ; - user who forwarded to that addressee.
 ; - if no one forwarded, then to message originator.
 S (XMSRIEN,XMSRI)=0
 F  S XMSRIEN=$O(^XMB(3.9,XMZ,1,"AQUEUE",XMINST,XMSRIEN)) Q:XMSRIEN=""  D
 . S XMSRTO=$$SENDER^XMSM(XMZ,XMNVFROM,XMSRIEN) Q:"<>"[XMSRTO
 . S XMY(XMSRTO)=""
 . S XMSRI=XMSRI+1
 . S XMSRTXT(XMSRI)=" to:  "_$P($G(^XMB(3.9,XMZ,1,XMSRIEN,0)),U,1)
 . K ^XMB(3.9,XMZ,1,"AQUEUE",XMINST,XMSRIEN)
 . S $P(^XMB(3.9,XMZ,1,XMSRIEN,0),U,5,7)=XMD_U_"Receive site reject originator"  ; XMD should be FM date/time
 S:$D(XMSRTXT) XMTEXT="XMSRTXT("
 D:$D(XMY) ^XMB
 S ER=1
 G ERR
DATANO S ERR="Receiver will not accept DATA."
 G ERR
VALBAD S XMSG="500 Invalid domain validation response"
 X XMSEN S XMB="XMVALBAD",XMB(1)=$P(Y3,U)
 D ^XMB S ER=1
 Q
ERR S XMTRAN="Error: "_ERR S:'$D(XMB(4)) XMB(4)=XMTRAN D TRAN^XMC1 S ER=1 Q
