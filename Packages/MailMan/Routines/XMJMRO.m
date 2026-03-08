XMJMRO ;ISC-SF/GMB-Options at 'reply' transmit prompt ;04/29/99  12:28
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces ^XMA22 (ISC-WASH/CAP/THM)
REPLYMSG(XMDUZ,XMK,XMKN,XMZO,XMZ,XMSUBJ,XMRESTR,XMPTR,XMRESPSO,XMRESP,XMABORT) ;
 N XMFINISH,XMLINE
 S XMFINISH=0
 F  D  Q:XMFINISH!XMABORT
 . N DIR,Y,X,XMNAME
 . D CHKRESP^XMJMP(XMDUZ,XMZO,XMRESPSO,XMRESP)
 . D REPLYSET(XMDUZ,.DIR)
 . D ^DIR I $D(DIRUT) S XMABORT=$S($D(DTOUT):DTIME,1:1) Q
 . D @Y
 Q
REPLYSET(XMDUZ,DIR) ;
 S DIR(0)="",XMLINE=0
 K DIR("L")
 D SET("B","Backup to review message")
 D SET("E","Edit reply")
 D SET("I","Include previous responses in reply")
 D SET("Q","Query")
 D SETHELP("Q xxx","Query recipient(s) xxx")
 D SET("QD","Query Detailed")
 D SET("QN","Query Network")
 D SET("T","Transmit now")
 S DIR("L")=DIR("L",XMLINE) K DIR("L",XMLINE)
 S DIR("A")="Select Message option:  "
 S DIR("B")="Transmit now"
 S DIR("PRE")="I X?1(1""Q "",1""q "",1""QD "",1""qd "").E S XMNAME=$P(X,"" "",2,99),X=""Query Detailed"""
 S DIR("??")="XM-U-MO-REPLY"
 S DIR(0)="SAM^"_$E(DIR(0),2,999)
 Q
SET(XMABBR,XMEXT) ;
 S DIR(0)=DIR(0)_";"_XMABBR_":"_XMEXT
 D SETHELP(XMABBR,XMEXT)
 Q
SETHELP(XMABBR,XMEXT) ;
 S XMLINE=XMLINE+1
 S DIR("L",XMLINE)=$E(XMABBR_"          ",1,10)_XMEXT
 Q
B ; Backup to review message
 D BACKUP^XMJMP(XMDUZ,XMK,XMKN,XMZO)
 S XMRESP=$P($G(^XMB(3.9,XMZO,1,XMPTR,0)),U,2)
 Q
E ; Edit msg
 D BODY^XMJMS(XMDUZ,XMZ,XMSUBJ,.XMRESTR,.XMABORT)
 Q
I ; Include previous response in reply
 N XMWHICH,XMNO
 S XMNO=0
 D WHICH^XMJMC(XMZO,"include",.XMWHICH,.XMNO) Q:XMNO
 Q:'$D(XMWHICH)
 D COPYTEXT^XMJMR(XMZO,XMZ,XMWHICH)
 D BODY^XMJMS(XMDUZ,XMZ,XMSUBJ,.XMRESTR,.XMABORT)
 Q
Q ; Query
 D Q^XMJMQ(XMDUZ,XMK,XMKN,XMZO)
 Q
QD ; Query Detailed
 I $D(XMNAME) D QNAMEX^XMJMQ(XMDUZ,XMK,XMKN,XMZO,XMNAME) Q
 D QD^XMJMQ(XMDUZ,XMK,XMKN,XMZO)
 Q
QN ; Query Network
 D QN^XMJMQ(XMDUZ,XMK,XMKN,XMZO)
 Q
T ; Transmit now
 S XMFINISH=1
 W "  Sending local reply... "
 D DOREPLY^XMXREPLY(XMDUZ,XMZO,XMZ)
 W !,"  Sent"
 Q
