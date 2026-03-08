XMXMSGS ;ISC-SF/GMB- Message APIs ;05/26/99  08:04
 ;;7.1;MailMan;**50**;Jun 02, 1994
DELMSG(XMDUZ,XMK,XMKZA,XMMSG) ;
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 D ACTMSG("XDEL^XMXMSGS2") ;,XMDUZ,XMK,.XMKZA,"",.XMMSG)
 S XMMSG=XMMSG_" deleted."
 Q
MOVEMSG(XMDUZ,XMK,XMKZA,XMKTO,XMMSG) ;
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 Q:XMK=XMKTO
 D ACTMSG("XMOVE^XMXMSGS2") ;,XMDUZ,XMK,.XMKZA,XMKTO,.XMMSG)
 S XMMSG=XMMSG_" saved."
 Q
TERMMSG(XMDUZ,XMK,XMKZA,XMMSG) ;
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 D ACTMSG("XTERM^XMXMSGS2") ;,XMDUZ,XMK,.XMKZA,"",.XMMSG)
 S XMMSG=XMMSG_" terminated."
 Q
FLTRMSG(XMDUZ,XMK,XMKZA,XMMSG) ;
 N XMKN,XMKTO,XMKNTO
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 I XMK'=.5,'$D(^XMB(3.7,XMDUZ,15,"AF")) D  Q
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="You have no message filters defined."
 S:XMK XMKN=$P(^XMB(3.7,XMDUZ,2,XMK,0),U,1)
 D ACTMSG("XFLTR^XMXMSGS2") ;,XMDUZ,XMK,XMKN,.XMKZA,"",.XMMSG)
 S XMMSG=XMMSG_" filtered."
 Q
FWDMSG(XMDUZ,XMK,XMKZA,XMTO,XMINSTR,XMMSG) ;
 ; XMINSTR("SHARE DATE")  delete date if SHARED,MAIL is recipient
 ; XMINSTR("SHARE BSKT")  basket if SHARED,MAIL is recipient
 N XMRTN
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 I $$ONEMSG(.XMKZA) D
 . S XMRTN="XFWDONE^XMXMSGS1" ; just one msg
 E  D
 . S XMRTN="XFWD^XMXMSGS1"
 . I $G(XMINSTR("ADDR FLAGS"))'["I" D INIT^XMXADDR
 . D CHKADDR^XMXADDR(XMDUZ,.XMTO,.XMINSTR)
 D ACTMSG(XMRTN) ;,XMDUZ,XMK,.XMKZA,.XMINSTR,.XMMSG)
 D CLEANUP^XMXADDR
 S XMMSG=XMMSG_" forwarded."
 Q
ONEMSG(XMKZA) ; Function decides if just one message
 N XMONE,XMMSGS
 I $G(XMKZA)]"" D  Q XMONE
 . I $O(XMKZA(""))="",+XMKZA=XMKZA S XMONE=1 Q
 . S XMONE=0
 S XMMSGS=$O(XMKZA(""))
 I $O(XMKZA(XMMSGS))'="" Q 0
 I +XMMSGS=XMMSGS Q 1
 Q 0
LATERMSG(XMDUZ,XMK,XMKZA,XMINSTR,XMMSG) ;
 ; XMINSTR("LATER")  FM date/time when msg should be made new.
 N XMWHEN
 K XMERR,^TMP("XMERR",$J)
 Q:'$$LATER^XMXSEC(XMDUZ)
 D ACTMSG("XLATER^XMXMSGS2") ;,XMDUZ,XMK,.XMKZA,.XMINSTR,.XMMSG)
 S XMMSG=XMMSG_" latered."
 Q
PRTMSG(XMDUZ,XMK,XMKZA,XMPRTTO,XMINSTR,XMMSG,XMTASK,XMSUBJ,XMTO) ;
 K XMERR,^TMP("XMERR",$J),^TMP("XM",$J,"XMZ")
 D ACTMSG("XPRT^XMXMSGS1") ;,XMDUZ,XMK,.XMKZA,.XMINSTR,.XMMSG)
 S XMMSG=XMMSG_" sent to printer."
 Q:+XMMSG=0
 I +XMMSG=1 D
 . D PRINT1^XMXPRT(XMDUZ,$O(^TMP("XM",$J,"XMZ","")),XMPRTTO,.XMINSTR,.XMTASK,.XMSUBJ,.XMTO)
 E  D
 . D PRINTM^XMXPRT(XMDUZ,XMPRTTO,.XMINSTR,.XMTASK,.XMSUBJ,.XMTO)
 K ^TMP("XM",$J,"XMZ")
 Q:$D(XMTASK)
 S XMMSG="0 messages sent to printer.  TaskMan Problem."
 S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Problem setting up TaskMan task."
 Q
XPMSG(XMDUZ,XMK,XMKZA,XMMSG) ; Postmaster transmit priority toggle
 K XMERR,^TMP("XMERR",$J)
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC Q
 I XMDUZ'=.5!(XMK'>999) D  Q
 . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Transmission Priority toggle valid only for Postmaster Transmission Queues."
 D ACTMSG("XXP^XMXMSGS1") ;,XMDUZ,XMK,.XMKZA,"",.XMMSG)
 S XMMSG=XMMSG_" transmission priority toggled."
 Q
ACTMSG(XMRTN) ;,XMDUZ,XMK,XMKZA,XMKTO,XMMSG)
 ; XMKZA    Array of msg numbers  DEL("1-3,7,11-15")
 ; XMKZL    List of msg numbers   1-3,7,11-15
 ;          (It is OK if the list ends with a comma)
 ; XMKZR    Range of msg numbers  1-3
 ; XMKZ1    First number in range 1
 ; XMKZN    Last number in range  3
 ; XMKZ     Message number
 N XMCNT,XMI,XMZ,XMPIECES
 S XMCNT=0
 I $G(XMK) D
 . N XMKZ,XMKZL,XMKZR,XMKZ1,XMKZN
 . ; is this an array or a variable?
 . I $G(XMKZA)]"",$O(XMKZA(""))="" S XMKZA(XMKZA)=""
 . S XMKZL=""
 . F  S XMKZL=$O(XMKZA(XMKZL)) Q:XMKZL=""  D
 . . S XMPIECES=$L(XMKZL,",")
 . . S:$P(XMKZL,",",XMPIECES)="" XMPIECES=XMPIECES-1
 . . F XMI=1:1:XMPIECES D
 . . . S XMKZR=$P(XMKZL,",",XMI)
 . . . I XMKZR["-" D
 . . . . ; deal with a range of msg #s
 . . . . S XMKZ1=$P(XMKZR,"-",1)
 . . . . S XMKZN=$P(XMKZR,"-",2)
 . . . . I XMKZ1>XMKZN S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Range '"_XMKZ1_"-"_XMKZN_"' invalid." Q
 . . . . S XMKZ=XMKZ1-.1
 . . . . F  S XMKZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ)) Q:'XMKZ!(XMKZ>XMKZN)  D
 . . . . . S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ,""))
 . . . . . I 'XMZ S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Message "_XMKZ_" in basket "_XMK_" does not exist." Q
 . . . . . I '$D(^XMB(3.9,XMZ,0)) S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Message '"_XMZ_"' (message "_XMKZ_" in basket "_XMK_") does not exist." Q
 . . . . . D @XMRTN ;(XMDUZ,XMK,XMZ)
 . . . E  D
 . . . . S XMKZ=XMKZR
 . . . . S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",XMKZ,""))
 . . . . I 'XMZ S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Message "_XMKZ_" in basket "_XMK_" does not exist." Q
 . . . . I '$D(^XMB(3.9,XMZ,0)) S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Message '"_XMZ_"' (message "_XMKZ_" in basket "_XMK_") does not exist." Q
 . . . . D @XMRTN ;(XMDUZ,XMK,XMZ)
 E  D
 . N XMZL,XMZREC
 . ; is this an array or a variable?
 . I $G(XMKZA)]"",$O(XMKZA(""))="" S XMKZA(XMKZA)=""
 . S XMZL=""
 . F  S XMZL=$O(XMKZA(XMZL)) Q:XMZL=""  D
 . . I XMZL["-" D  Q
 . . . S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="XMZ message ranges are not allowed."
 . . S XMPIECES=$L(XMZL,",")
 . . S:'$P(XMZL,",",XMPIECES) XMPIECES=XMPIECES-1
 . . F XMI=1:1:XMPIECES D
 . . . N XMK
 . . . S XMZ=$P(XMZL,",",XMI)
 . . . I '$D(^XMB(3.9,XMZ,0)) S XMERR=$G(XMERR)+1,^TMP("XMERR",$J,XMERR,"TEXT",1)="Message '"_XMZ_"'  does not exist." Q
 . . . S XMZREC=$G(^XMB(3.9,XMZ,0))
 . . . Q:'$$ACCESS^XMXSEC(XMDUZ,XMZ,XMZREC)
 . . . D @XMRTN ;(XMDUZ,XMK,XMZ)
 S XMMSG=XMCNT_" message"_$S(XMCNT=1:"",1:"s")
 Q
