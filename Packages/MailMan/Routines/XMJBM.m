XMJBM ;ISC-SF/GMB-Manage Mail in Mailbox ;06/29/99  15:14
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces ^XMA0,^XMA01 (ISC-WASH/CAP/THM)
 ; Entry points used by MailMan options (not covered by DBIA):
 ; MANAGE   XMREAD
MANAGE ; Manage existing mail in your Mailbox
 N XMABORT,XMK,XMKN,XMRDR
 S XMABORT=0
 D INIT^XMJBM1(.XMDUZ,.XMRDR,.XMABORT) Q:XMABORT
 F  D ASKBSKT^XMJBM1(XMDUZ,XMRDR,.XMK,.XMKN,.XMABORT) Q:XMABORT  D  Q:XMABORT
 . D:XMRDR="C" CLASSIC(XMDUZ,XMK,XMKN,.XMABORT) ; Classic Reader
 . D:XMRDR="D" LIST^XMJMLR(XMDUZ,XMK,.XMKN,1,.XMABORT) ; Full Screen Detail
 . D:XMRDR="S" LIST^XMJMLR(XMDUZ,XMK,.XMKN,0,.XMABORT) ; Full Screen Summary
 . I XMABORT,XMDUZ=.6 S XMABORT=0
 . I '$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",0)) D NOMSGS^XMJBM1(XMDUZ,XMK,XMKN)
 Q
CLASSIC(XMDUZ,XMK,XMKN,XMABORT) ; Read Message
 N XMFIRST,XMLAST,XMZ,XMNEXT,XMKZ,XMORDER
 I XMDUZ=.5,XMK>999 S XMORDER=XMV("ORDER"),XMV("ORDER")=1
 S XMKZ=""
 F  D  Q:XMABORT
 . F  S XMKZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ),XMV("ORDER")) Q:'XMKZ  Q:XMDUZ=DUZ  Q:'$$SURRCONF^XMXSEC(XMDUZ,$O(^(XMKZ,"")))
 . I XMKZ="" D  Q:XMABORT
 . . F  S XMKZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ),XMV("ORDER")) Q:'XMKZ  Q:XMDUZ=DUZ  Q:'$$SURRCONF^XMXSEC(XMDUZ,$O(^(XMKZ,"")))
 . . I XMKZ="" S XMABORT=1 Q
 . . D AGAIN^XMJMLR(.XMABORT)
 . S XMFIRST=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",""))
 . S XMLAST=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",""),-1)
 . ; have the user pick from first to last, or any xmz
 . N XMY,XMOPTION,XMPREVU
 . D SETCMD(XMDUZ,XMK,.XMOPTION)
 . S:XMV("PREVU") XMPREVU=$$PREVU(XMDUZ,XMK,XMKN,XMKZ)
 . S XMNEXT=0
 . F  D  Q:XMNEXT!XMABORT
 . . W ! W:XMV("PREVU") !,XMPREVU
 . . W !,XMKN," Basket Message: ",XMKZ,"// "
 . . R XMY:DTIME I '$T S XMABORT=1 Q
 . . I XMY[U S XMABORT=1 Q
 . . I XMY="" S XMY=XMKZ D NUMBER Q
 . . I XMY?.N D NUMBER Q
 . . I $E(XMY)="?" D QUESTION Q
 . . S XMY=$$COMMAND^XMJDIR(.XMOPTION,XMY)
 . . I XMY=-1 D HELPSCR Q
 . . I $D(XMOPTION(XMY,"?")) D SHOWERR^XMJDIR(.XMOPTION,.XMY) Q
 . . D @XMY
 . . S:'$D(^XMB(3.7,XMDUZ,2,XMK,1,"C",+XMKZ)) XMNEXT=1
 I $D(XMORDER) S XMV("ORDER")=XMORDER
 Q
PREVU(XMDUZ,XMK,XMKN,XMKZ) ;
 Q:XMKZ="" ""
 N XMZ,XMZREC,XMSUBJ,XMFROM,XMLEN,XMSL,XMFL
 S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ,""))
 I '$D(^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)) D ADDITC^XMUT4A(XMDUZ,XMK,XMZ,XMKZ)
 S XMZREC=$G(^XMB(3.9,XMZ,0))
 S XMSUBJ=$$SUBJ^XMXUTIL2(XMZREC)
 S XMFROM=$$NAME^XMXUTIL($P(XMZREC,U,2))
 S XMSL=$L(XMSUBJ)
 S XMFL=$L(XMFROM)
 S XMLEN=64
 I XMSL+XMFL>XMLEN D
 . I XMSL<36 S XMFROM=$E(XMFROM,1,XMLEN-XMSL) Q
 . I XMFL<26 S XMSUBJ=$E(XMSUBJ,1,XMLEN-XMFL) Q
 . S XMSL=XMSL-(XMSL+XMFL-XMLEN\2)
 . S XMSUBJ=$E(XMSUBJ,1,XMSL)
 . S XMFROM=$E(XMFROM,1,XMLEN-XMSL)
 Q "Subj: "_XMSUBJ_"   From: "_XMFROM
SETCMD(XMDUZ,XMK,XMOPTION) ;
 D OPTGRP^XMXSEC1(XMDUZ,XMK,.XMOPTION)
 I XMDUZ=.5,XMK>999 Q
 S XMOPTION("I")="Ignore this message"
 Q
NUMBER ;
 ; See ENTM^XMA03 to see how MM7.1 handles this
 I $L(XMY)>25 W *7,"?" Q
 I XMY<XMFIRST D  Q
 . S (XMKZ,DIR("B"))=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",""))
 . S:XMV("PREVU") XMPREVU=$$PREVU(XMDUZ,XMK,XMKN,XMKZ)
 . W *7,"?"
 I $D(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMY)) D  Q
 . S XMKZ=XMY
 . S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ,""))
 . I '$D(^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)) D ADDITC^XMUT4A(XMDUZ,XMK,XMZ,XMKZ)
 . D READMSG(XMDUZ,XMK,XMKN,XMZ)
 . S XMNEXT=1
 I XMFIRST'>XMY,XMY'>XMLAST D  Q
 . S (XMKZ,DIR("B"))=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMY),XMV("ORDER"))
 . S:XMV("PREVU") XMPREVU=$$PREVU(XMDUZ,XMK,XMKN,XMKZ)
 . W *7,"?"
 I $D(^XMB(3.9,XMY,0)) D NUMBERZ Q
 I XMY>XMLAST D  Q
 . S (XMKZ,DIR("B"))=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",""),-1)
 . S:XMV("PREVU") XMPREVU=$$PREVU(XMDUZ,XMK,XMKN,XMKZ)
 . W *7,"?"
 W *7,"?"
 Q
NUMBERZ ;
 I $D(^XMB(3.7,"M",XMY,XMDUZ)) D  Q
 . S XMZ=XMY
 . I '$D(^XMB(3.7,XMDUZ,2,XMK,1,XMZ)) D
 . . ; It's in another basket
 . . S XMK=$O(^XMB(3.7,"M",XMZ,XMDUZ,""))
 . . S XMKN=$P(^XMB(3.7,XMDUZ,2,XMK,0),U,1)
 . S XMKZ=$P($G(^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)),U,2)
 . I 'XMKZ D ADDITM^XMUT4A(XMDUZ,XMK,XMZ,.XMKZ)
 . D READMSG(XMDUZ,XMK,XMKN,XMZ)
 . S XMNEXT=1
 . ; *** MM7.1 checks to see if XMK=.5 (WASTE).  If so, it moves it to the IN basket.  I disagree.
 I $D(^XMB(3.9,XMY,0)) D  Q
 . S XMZ=XMY
 . I $D(XMERR) K XMERR,^TMP("XMERR",$J)
 . I '$$ACCESS^XMXSEC(XMDUZ,XMZ,^XMB(3.9,XMZ,0)) D  Q
 . . W "?"
 . . D SHOW^XMJERR
 . D PUTMSG^XMXMSGS2(XMDUZ,XMK,XMKN,XMZ) ; User is a recipient, so save to user's basket
 . D READMSG(XMDUZ,XMK,XMKN,XMZ)
 . S XMNEXT=1
 Q
QUESTION ;
 I XMY="?" D LIST^XMJML(XMDUZ,XMK,XMKN,XMKZ,0) Q
 I XMY="??" D LIST^XMJML(XMDUZ,XMK,XMKN,XMKZ,1) Q
 I XMY="???" D HELPSCR Q
 I XMY?4."?"!("?HELP"[$$UP^XLFSTR(XMY)) D  Q
 . N XQH
 . S XQH="XM-U-BO-CLASSIC"
 . D EN^XQH
 I XMY?1"??".E D  Q
 . ; Search for messages whose subject starts with string
 . I $E(XMY,3,99)?.N,$D(^XMB(3.9,$E(XMY,3,999),0)) D  Q
 . . S XMY=$E(XMY,3,99)
 . . D NUMBERZ
 . D FIND^XMJMFA(XMDUZ,$E(XMY,3,99))
 I XMY?1"?".E D  Q
 . ; Search for messages whose subject contains string
 . N XMF
 . S XMF("BSKT")=XMK
 . S XMF("SUBJ")=$E(XMY,2,99)
 . D FIND1^XMJMFB(XMDUZ,.XMF)
 Q
HELPSCR ;
 N DIR
 I XMDUZ=.5,XMK>999
 E  D
 . W !!,"Press RETURN to read message "_XMKZ_".  Enter message number ("_XMFIRST_"-"_XMLAST_") to read"
 . W !,"a message in this basket.  Enter internal message number to read any"
 . W !,"message still on the system, which you ever sent or received.  Enter:"
 W !,"  ? or ??         Display a summary or detailed list of messages in this basket"
 W !,"  ???? or ?HELP   Display detailed help"
 W !,"  ?string         Search for messages in this basket whose subject"
 W !,"                  contains the specified string"
 W !,"  ??string        Search for messages you once sent or received"
 W !,"                  whose subject begins with the specified string"
 S XMCMD=""
 F  S XMCMD=$O(XMOPTION(XMCMD)) Q:XMCMD=""  D
 . Q:$D(XMOPTION(XMCMD,"?"))
 . W !,"  "_XMCMD_"              "_$S($L(XMCMD)=1:" ",1:"")_XMOPTION(XMCMD)
 Q
READMSG(XMDUZ,XMK,XMKN,XMZ) ;
 I '$D(^XMB(3.9,XMZ,0)) D ZAPIT(XMDUZ,XMK,XMZ) Q
 I XMDUZ'=DUZ,'$$SURRACC^XMXSEC(XMDUZ,"read",XMZ,$G(^XMB(3.9,XMZ,0))) D  Q
 . D SHOW^XMJERR
 . I $G(XMRDR)'="C" D WAIT^XMXUTIL
 N XMSECURE,XMPAKMAN,XMSECBAD ; Important 'new' - part of scramble and packman handling
 D DISPMSG^XMJMP(XMDUZ,XMK,XMKN,XMZ,.XMSECBAD) Q:$G(XMSECBAD)
 D READMSG^XMJMOI(0,XMDUZ,XMK,XMKN,XMZ)
 Q
ZAPIT(XMDUZ,XMK,XMZ) ;
 W !,*7,"This references a message which doesn't exist - deleting it."
 D ZAPIT^XMXMSGS2(XMDUZ,XMK,XMZ)
 Q
C ; Change the name of the basket
 D NAMEBSKT^XMJBU(XMDUZ,XMK,.XMKN)
 Q
D ; Delete
 D DELETE^XMJMOR(XMDUZ,XMK)
 Q
F ; Forward
 D FORWARD^XMJMOR(XMDUZ,XMK)
 Q
FI ; Filter
 D FILTER^XMJMOR(XMDUZ,XMK)
 Q
H ; Headerless Print
 D PRINT^XMJMOR(XMDUZ,XMK,XMKN,0)
 Q
I ; Ignore this message
 S XMNEXT=1
 Q
L ; Later
LA ; Later
 D LATER^XMJMOR(XMDUZ,XMK)
 Q
LM ; List Messages (can't read)
 D LIST^XMJML(XMDUZ,XMK,XMKN,"",1)
 Q
LN ; List New Messages
 D LISTONE^XMJMLN(XMDUZ,XMK,XMKN,"N0")
 Q
LP ; List Priority Messages
 D LISTONE^XMJMLN(XMDUZ,XMK,XMKN,"N")
 Q
N ; List New Messages (can't read)
 D LISTNEW^XMJML(XMDUZ,XMK,XMKN)
 Q
P ; Print
 D PRINT^XMJMOR(XMDUZ,XMK,XMKN)
 Q
Q ; Query by subject, sender, and/or date
 D FINDBSKT^XMJMF(XMDUZ,XMK,XMKN)
 Q
R ; Resequence
 N XMMSG
 W !,"Resequencing ..."
 D RSEQBSKT^XMXBSKT(XMDUZ,XMK,.XMMSG)
 W !,XMMSG
 S XMKZ=""
 Q
S ; Save
 D SAVE^XMJMOR(XMDUZ,XMK)
 Q
T ; Terminate
 D TERM^XMJMOR(XMDUZ,XMK)
 Q
X ; Xmit Priority toggle (for Postmaster only)
 D XMTPRI^XMJMOR(XMDUZ,XMK)
 Q
