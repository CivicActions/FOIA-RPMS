XMLTCP ;(WASH ISC)/CAP - TCP/IP TO MAILMAN ;04/08/98  10:36 [ 10/19/1998  1:50 PM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**8,27,61**;Jun 02, 1994
 ; modified to run with MSM NT and Protocol TCP/IP-MAILMAN (file 3.4)
 ;
SEND ;returns ER(0 OR 1), XMLER=number of "soft" errors
 I $$NEWERR^%ZTER N $ETRAP,$ESTACK S $ETRAP="D C^XMCTRAP"
 E  S X="C^XMCTRAP",@^%ZOSF("TRAP")
 S %=XMSG I $L(%)>255 S ER=1,XMTRAN="Line too long" D TRAN Q
 ;I %'?.ANP S %=$$STR^XMLUTL(%)
 S XMSG=% I $G(XMINST) S Y=$$STAT^XMLSTAT(XMINST,1,XMSG,"TCP/IP-MailMan",1)
 W XMSG,$C(13,10),!
 Q
 ;Receive a line (must keep buffer / lines divided by LF)
REC N L
 I $D(XMRG),$G(XMINST) S Y=$$STAT^XMLSTAT(XMINST,2,XMRG,"TCP/IP-MailMan",1)
 I '$D(XMOS) S XMOS=^%ZOSF("OS") I XMOS["MSM" S XMOS("MSMVER")=$P($ZV," 4.0.",2) S:+XMOS("MSMVER")=0 XMOS("MSMVER")=8
 I $$NEWERR^%ZTER N $ETRAP,$ESTACK S $ETRAP="D C^XMCTRAP"
 E  S X="C^XMCTRAP",@^%ZOSF("TRAP")
 ;Return line if read last time
RE G R:XMLTCP[$C(10) S %=255-$L(XMLTCP) G R:%<1
 ;Insure can clean up if line dropped, etc.
 I $S(XMOS["VAX":1,+$G(XMOS("MSMVER"))<8:1,XMOS["OpenM-NT":1,1:0) R X#$S(%:%,1:1):$S($G(XMSTIME):XMSTIME,1:160) G RE2
 ;Compliant with M standard
 R X:$S($G(XMSTIME):XMSTIME,1:60)
 ;
RE2 I '$T,"."_$C(10)'=XMLTCP S ER=1,XMRG="",XMTRAN="Rcvr timed out" D TRAN Q
 I X="" S ER=ER+.1 S:ER=1 XMRG="" Q:ER=1  H 1 G RE
 S XMLTCP=XMLTCP_X I XMLTCP'[$C(10) G RE
R S %=$F(XMLTCP,$C(10))
 ;
 ;Strip out LF (and CR, if present)
 S L=$L(XMLTCP)
 I %,%<256 S XMRG=$E(XMLTCP,1,%-3+($A(XMLTCP,%-2)'=13)),XMLTCP=$E(XMLTCP,%,L) G RQ
 ;
 ;Line too long or doesn't contain a Line Feed, return first 255 chars.
 S XMRG=$E(XMLTCP,1,255),XMLTCP=$E(XMLTCP,256,L)
 ;
RQ I $L(XMRG),$C(13,10)[$E(XMRG) S XMRG=$E(XMRG,2,$L(XMRG)) G RQ
 Q
TRAN Q:$G(XM)'["D"  D TRAN^XMC1 ;IHS/MFD added $G of XM
 Q
