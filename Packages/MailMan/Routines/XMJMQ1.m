XMJMQ1 ;ISC-SF/GMB- Q,QD,QN Query recipients (continued) ;06/24/99  07:14
 ;;7.1;MailMan;**40,50**;Jun 02, 1994
 ; Replaces ^XMA5,^XMA5A (ISC-WASH/THM/CAP)
NETWORK(XMZ,XMABORT) ;
 N I,J,XMLINE,XMPOS,XMPHDR
 I $O(^XMB(3.9,XMZ,2,0))'<1 D  Q
 . W !!,"This message originated locally.  There is no network header."
 I $D(^XMB(3.9,XMZ,.7)) W !!,"Envelope From:",$P(^XMB(3.9,XMZ,.7),U,1)
 W !!,"Network header:",!
 S (I,XMPHDR)=0
 F  S I=$O(^XMB(3.9,XMZ,2,I)) Q:I=""!(I'<1)  D  Q:XMABORT
 . S XMLINE=^XMB(3.9,XMZ,2,I,0)
 . I $Y+3>IOSL D PAGE^XMJMQ(.XMABORT) Q:XMABORT
 . I $L(XMLINE)<IOM W !,XMLINE Q
 . S XMPOS=0
 . F  D  Q:XMLINE=""!XMABORT
 . . I $L(XMLINE)+XMPOS+1>IOM F J=IOM-XMPOS-1:-1:IOM-XMPOS-20 Q:", -;)"[$E(XMLINE,J)
 . . I $Y+3>IOSL D PAGE^XMJMQ(.XMABORT) Q:XMABORT
 . . W !,?XMPOS,$E(XMLINE,1,J)
 . . S XMPOS=10
 . . S XMLINE=$E(XMLINE,J+1,999)
 Q
SUMMARY(XMZ,XMPHDR,XMSUBJ,XMZSTR,XMPAGE,XMABORT) ;
 I $Y+3>IOSL D PAGE^XMJMQ(.XMABORT) Q:XMABORT
 W !
 I '$O(^XMB(3.9,XMZ,6,0)),'$O(^XMB(3.9,XMZ,7,0)) D  Q
 . W !,"This is an old message which has no summary recipient list."
 . W !,"Only the Detail Query (QD) is available."
 W !,"This message was addressed as follows:",!
 D PRTADDR(XMZ,6,.XMABORT) Q:XMABORT  ; addressed to
 D PRTADDR(XMZ,7,.XMABORT)            ; deliver later to
 Q
PRTADDR(XMZ,XMNODE,XMABORT) ;
 N XMTO
 ;List Groups first
 S XMTO="G."
 F  S XMTO=$O(^XMB(3.9,XMZ,XMNODE,"B",XMTO)) Q:$E(XMTO,1,2)'="G."  D PRTSUMRY(XMZ,XMNODE,XMTO,.XMABORT)  Q:XMABORT
 Q:XMABORT
 S XMTO=""  ; Now list the rest
 F  S XMTO=$O(^XMB(3.9,XMZ,XMNODE,"B",XMTO)) Q:XMTO=""  D  Q:XMABORT
 . Q:$E(XMTO,1,2)="G."
 . D PRTSUMRY(XMZ,XMNODE,XMTO,.XMABORT)
 Q
PRTSUMRY(XMZ,XMNODE,XMTO,XMABORT) ;
 N XMIEN,XMREC
 S XMIEN=$O(^XMB(3.9,XMZ,XMNODE,"B",XMTO,0)) Q:'XMIEN
 S XMREC=$G(^XMB(3.9,XMZ,XMNODE,XMIEN,0)) Q:XMREC=""
 I $Y+3>IOSL D PAGE^XMJMQ(.XMABORT) Q:XMABORT
 W ! W $S($P(XMREC,U,2)="":"",$P(XMREC,U,2)="I":"Info:",$P(XMREC,U,2)="C":"cc:",1:$P(XMREC,U,2)_":") W $P(XMREC,U,1)
 Q:XMNODE=6
 D W^XMJMQ(" for delivery "_$$MMDT^XMXUTIL1($P(XMREC,U,5)))
 D W^XMJMQ(" by "_$P(XMREC,U,4))
 Q
