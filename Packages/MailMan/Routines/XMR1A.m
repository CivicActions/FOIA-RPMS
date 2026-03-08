XMR1A ;(WASH ISC)/THM/CAP-SMTP AUX FUNCTIONS ;06/08/99  06:37
 ;;7.1;MailMan;**13,36,50**;Jun 02, 1994
STATS ;
 N X,Y
 I '$D(XMINST) S XMINST=$G(XMB("XMSCR"))
 Q:'XMINST
 D:'$D(^XMBS(4.2999,XMINST,0)) STAT^XMC1(XMINST)
 S Y=^XMBS(4.2999,XMINST,0)
 S $P(Y,U,7)=$P(Y,U,7)+1
 S Y(0)=$P($G(^XMB(3.9,XMZ,2,0)),U,3)
 S $P(Y,U,8)=$P(Y,U,8)+Y(0)
 S ^XMBS(4.2999,XMINST,0)=Y
 S Y=$P($G(^XMBS(4.2999,XMINST,3)),U,8) I Y S $P(^(3),U,8)=0
 S:Y<1 Y=200
 D STATR^XMS0A  ; expects Y, Y(0)
 Q
CHEKDUP ;
 N XMZCHK,XMTO
 ;REJECT ON PURGED MESSAGE PROTECT FOC-AUSTIN
 ;DO NOT CHANGE WITHOUT COORDINATING
 S XMZCHK=$$LOCALXMZ(XMREMID)
 ;Set up "AI" cross reference -- since XMBX is replicated at FOC-Austin
 ;set pseudo node first so that if DDP is down, failure will occur before
 ;message is considered received.
 ;
 ;Accept as new message if NOT HERE
 Q:'XMZCHK
 ; We already have the message
 I $P(XMZCHK,U,3)'="E"!(XMZ=+XMZCHK) D  Q
 . S XMSG="554 Duplicate (purged).  Msg rejected." X XMSEN
 . D KILLIT
 . S XMREJECT=1
 S XMTO=""
 F  S XMTO=$O(^TMP("XMY",$J,XMTO)) Q:XMTO=""  I $D(^XMB(3.7,"M",+XMZCHK,XMTO)) K ^TMP("XMY",$J,XMTO)
 I $O(^TMP("XMY",$J,""))="" D  Q
 . S XMSG="254 Duplicate (no add'l recipients).  Msg rejected." X XMSEN
 . D KILLIT
 . S XMREJECT=1
 ; We are forwarding a msg which already exists on our system
 ; to recipients who don't currently have it in their mailbox.
 K XMZFDA  ; When we implement true 'forwarded by', we'll have to retain that.
 D KILLIT
 S XMZ=+XMZCHK
 Q
KILLIT ;
 K XMREMID
 D ZAPIT^XMXMSGS2(.5,.95,XMZ)
 D KILLMSG^XMXUTIL(XMZ)
 Q
LOCALXMZ(XMREMID) ; Given a remote id, function returns XMZ if the message
 ; can be or was ever found locally.
 ; If no record of it, returns null.
 ; Otherwise, returns:
 ; Piece 1: local XMZ
 ; Piece 2: originated here? (0=no; 1=yes)
 ; Piece 3: still exists? (P=no, purged;
 ;                         R=no, purged, & replaced with something else;
 ;                         E=yes, it still exists here)
 N XMZCHK,XMP1,XMP2
 S XMP1=$P(XMREMID,"@",1),XMP2=$P(XMREMID,"@",2)
 I XMP1=""!(XMP2="") Q ""
 S XMZCHK=$$FINDXMZ(XMP1,XMP2)
 I XMZCHK Q XMZCHK
 S XMZCHK=$$FINDXMZ(XMP2,XMP1)
 I XMZCHK Q XMZCHK
 Q ""
FINDXMZ(XMP1,XMP2) ;
 I XMP1?.N!(XMP1?.N1"."7N) Q:XMP2=^XMB("NETNAME") $$LOCXMZ(XMP1)  Q:$P($$FACILITY(XMP2),U,2)=^XMB("NETNAME") $$LOCXMZ(XMP1)
 N XMZ
 S XMZ=$O(^XMBX(3.9,"AI",$E(XMP2,1,64),$E(XMP1,1,64),0))
 I XMZ Q $$REMXMZ(XMZ,XMP2,XMP1)
 Q ""
LOCXMZ(XMZ) ; Message originated here.
 I XMZ'["." Q XMZ_"^1^"_$S($D(^XMB(3.9,XMZ,0)):"E",1:"P")
 ; The following code won't activate until MailMan message IDs contain
 ; dates.  Message IDs are created in $$NETID^XMS0A.
 N XMCRE8
 S XMCRE8=$P(XMZ,".",2),XMZ=$P(XMZ,".",1)
 Q XMZ_"^1^"_$S('$D(^XMB(3.9,XMZ,0)):"P",$P($G(^XMB(3.9,XMZ,.6)),U,1)=XMCRE8:"E",1:"R")
REMXMZ(XMZ,XMP2,XMP1) ; Message originated somewhere else.
 I '$D(^XMB(3.9,XMZ,0)) Q XMZ_"^0^P"
 N XMREMID
 S XMREMID=$G(^XMB(3.9,XMZ,5))
 I XMREMID="" Q XMZ_"^0^R"
 I XMP1_"@"_XMP2=XMREMID Q XMZ_"^0^E"
 I XMP2_"@"_XMP1=XMREMID Q XMZ_"^0^E"
 Q XMZ_"^0^R"
FACILITY(X) ; If full domain name is found in domain file, either as main entry
 ; or as synonym, return main entry.  "Domain IEN^Domain name"
 N DIC,Y,D
 S DIC="^DIC(4.2,",DIC(0)="FMOZ",D="B^C"
 D MIX^DIC1
 Q Y
