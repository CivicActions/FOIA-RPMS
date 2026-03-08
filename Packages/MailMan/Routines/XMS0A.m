XMS0A ;(WASH ISC)/THM/CAP-DATA (CONT) ;06/14/99  16:39
 ;;7.1;MailMan;**2,13,55,50**;Jun 02, 1994
DATA ;SEND BODY OF TEXT
 S XMSG="DATA" X XMSEN Q:ER
 I 'XMBT X XMREC Q:ER
 S:XMBT XMRG=300 S XMSBT=$H*86400+$P($H,",",2)
 I $E(XMRG)'=3 G DATANO^XMSERR
 S XMR=^XMB(3.9,XMZ,0) I $D(^(2,.001)) G D6
 S XMSUB="Subject:"_$S($P(XMR,U)=$$EZBLD^DIALOG(34012):"",1:$P(XMR,U))
 S XMSG=XMSUB X XMSEN Q:ER
 S XMSG="Date:"_$$INDT^XMXUTIL1($P(XMR,U,3))
 X XMSEN Q:ER
 S XMSG="Message-ID:<"_$$NETID(XMZ)_">" X XMSEN Q:ER
 I $D(^XMB(3.9,XMZ,"IN")) S J=^("IN") S:$S($P(J,"@",1)?.E1".VA.GOV":1,$P(J,"@",2)?.N:1,1:0) J=$P(J,"@",2)_"@"_$P(J,"@") S XMSG="In-reply-to:<"_J_">" X XMSEN Q:ER
 I "^Y^y^"[(U_$P(XMR,U,5)_U) S XMSG="Return-Receipt-To:"_XMFROM X XMSEN Q:ER
 I $D(^XMB(3.9,XMZ,"K")) S XMSG="Encrypted:"_$P(XMR,U,10)_U_^("K") X XMSEN Q:ER
 S X1=$P(XMR,U,4) I X1'="" S XMSG="Sender:<"_$$NETNAME^XMXUTIL(X1)_">" X XMSEN Q:ER
 S XMSG="From:"_XMFROM X XMSEN Q:ER
 I $P(XMR,U,6)'="" D  Q:ER
 . S XMSG="Expiry-Date:"_$$INDT^XMXUTIL1($P(XMR,U,6)) X XMSEN
 I $P(XMR,U,7)["P" D  Q:ER
 . S XMSG="Importance:high" X XMSEN Q:ER
 . S XMSG="X-Priority:1" X XMSEN
 I "^Y^y^"[(U_$P(XMR,U,11)_U) D  Q:ER
 . S XMSG="Sensitivity:Private" X XMSEN
 I $D(^XMB(3.9,XMZ,.5)) D  Q:ER
 . N XMZBSKT
 . S XMZBSKT=$P($G(^XMB(3.9,XMZ,.5)),U,1)
 . Q:XMZBSKT=""
 . S XMSG="X-MM-Basket:"_XMZBSKT X XMSEN
 I $P(XMR,U,7)'="",$P(XMR,U,7)'="P" D  Q:ER
 . S XMSG="X-MM-Type:"_$P(XMR,U,7) X XMSEN
 I "^Y^y^"[(U_$P(XMR,U,9)_U) D  Q:ER
 . S XMSG="X-MM-Closed:YES" X XMSEN
 I "^Y^y^"[(U_$P(XMR,U,12)_U) D  Q:ER
 . S XMSG="X-MM-Info-Only:YES" X XMSEN
 S J=0,J(0)=0,J("N")=^XMB("NETNAME"),XMSG=""
 F  S J=$O(^XMB(3.9,XMZ,6,J)) Q:J'>0  D  Q:ER!(J(0)>50)
 . N XMADREC
 . S XMADREC=^XMB(3.9,XMZ,6,J,0)
 . S I=$P(XMADREC,U)
 . S:$P(XMADREC,U,2)'="" I=$P(XMADREC,U,2)_":"_I
 . D D4
 . I $L(XMSG)>80 D SEND Q:ER
 Q:ER
 I J(0)>50 S XMSG="(Too many recipients to list...)" X XMSEN Q:ER
 G D5
D4 S J(0)=J(0)+1 I XMSG="" S XMSG=$S(J(0)=1:"To: ",1:"    ")
 I $E(I)'=$C(34),$P(I,"@")["," S I=$TR($P(I,"@"),", .","._+")_"@"_$S($P(I,"@",2)'="":$P(I,"@",2),1:J("N"))
 I I'["@" S I=I_"@"_J("N")
D S XMSG=XMSG_$S(J(0)>1&(XMSG'?1." "):", ",1:"")_I
 Q
SEND S:+$O(^XMB(3.9,XMZ,1,J))>0 XMSG=XMSG_"," X XMSEN S XMSG=""
 Q
D5 ;START TRANSMISSION OF HEADER/BODY OF TEXT
 ;
 ;1st send last line in the "To list"
 I $L(XMSG)>9 X XMSEN
 K J S XMSG="" X XMSEN Q:ER
D6 S XMBLOCK=1,(XMS0AJ,J,I)=0 D D1 K XMS0AJ Q:ER  G D2
D1 S XMS0AJ=$O(^XMB(3.9,XMZ,2,XMS0AJ)) Q:+XMS0AJ'>0  S XMSG=^(XMS0AJ,0),I=I+1,J=J+1
 I $E(XMSG)="." S XMSG="."_XMSG
 I $E(XMSG,1,4)="~*~^" S XMSG=" "_XMSG
 X XMSEN
 I ER S XMB(4)=$S($D(XMCHAN):XMCHAN_":  ",1:"")_"Message "_XMZ_", Node "_XMS0AJ Q
 G D1
D2 ;SET POSTAGE ?? HERE
 I $D(XMBLOCK) D KILL^XML4CRC
 S XMSG=".",XMCJ=0 X XMSEN I 'XMBT S XMSTIME=300 X XMREC K XMSTIME Q:ER
 S:XMBT XMRG="250 OK" I $E(XMRG)'=2 D DATANO^XMS0
D2X S XMCNT("S")=$S($D(XMCNT("S")):XMCNT("S"),1:0)+1
 F XMCJ=0:0 S XMCJ=$O(XMJ(XMCJ)) Q:XMCJ=""  D D3
 S X=$G(^XMBS(4.2999,XMINST,0)) I X="" S X=XMINST,^XMBS(4.2999,"B",X,X)=""
 S $P(X,U,5)=$P(X,U,5)+1,Y(0)=$P($G(^XMB(3.9,XMZ,2,0)),U,3),^XMBS(4.2999,XMINST,0)=X S Y=$P($G(^(3)),U,9) I Y S $P(^(3),U,9)=0
 S:Y<1 Y=200 D STATS
 K XMLCT G TRASH^XMS ; POSTAGE WOULD GO HERE
D3 Q:XMJ(XMCJ)'=""
 S X=^XMB(3.9,XMZ,1,XMCJ,0),X=$P(X_"^^^",U,1,3)_U_XMRZ_U_XMD_U_U_$P(X,U,7)_":"_$G(XMSDOM)_U_($H*86400+$P($H,",",2)-XMSBT) S:XMBT $P(X,U,6)="In transit" S ^(0)=X
 K ^XMB(3.9,XMZ,1,"AQUEUE",XMINST,XMCJ)
Q Q
NETID(XMZ) ;
 I '$P($G(^XMB(3.9,XMZ,.6)),U,1) D
 . N XMCRE8
 . S XMCRE8=$P($G(^XMB(3.9,XMZ,0)),U,3)
 . I $P(XMCRE8,".")?7N S XMCRE8=$P(XMCRE8,".")
 . E  D
 . . S XMCRE8=$$CONVERT^XMXUTIL1(XMCRE8)
 . . I XMCRE8=-1 S XMCRE8=DT
 . S $P(^XMB(3.9,XMZ,.6),U,1)=XMCRE8
 . S ^XMB(3.9,"C",XMCRE8,XMZ)=""
 N XMREMID
 I $D(^XMB(3.9,XMZ,5)) D  Q:XMREMID'="" XMREMID
 . S XMREMID=^XMB(3.9,XMZ,5)
 . I $P(XMREMID,"@",1)?.E1".VA.GOV"!($P(XMREMID,"@",2)?.N) S XMREMID=$P(XMREMID,"@",2)_"@"_$P(XMREMID,"@")
 . Q:XMREMID'=""
 . D PARSE^XMR1(XMZ,.XMREMID)
 ;Q XMZ_"."_$P(^XMB(3.9,XMZ,.6),U,1)_"@"_^XMB("NETNAME")
 Q XMZ_"@"_^XMB("NETNAME")
STATS S %=1 G STAT
STATR S %=2
STAT ;UPDATE MONTHLY STATS [%=1 (SENT) OR 2 (REC'D), Y=#CHARS, Y(0)=#LINES]
 S I=$E(DT,1,5),X=$S($D(^XMBS(4.2999,XMINST,100,I,0)):^(0),1:"") I X'="" S $P(X,U,1+%)=$P(X,U,1+%)+1,$P(X,U,3+%)=$P(X,U,3+%)+Y,$P(X,U,5+%)=$P(X,U,5+%)+Y(0),^(0)=X Q
 S %0=I_"00",^XMBS(4.2999,XMINST,100,0)="^4.25D^"_%0_"^1",$P(%0,U,1+%)=1,$P(%0,U,3+%)=Y,$P(%0,U,5+%)=Y(0),^(I,0)=%0,^XMBS(4.2999,XMINST,100,"B",+%0,I)="" Q
 K I,X,Y,% Q
LOCKER S XMTRAN="Queue being delivered by another Job - Aborting transmission !" D TRAN^XMC1 Q
 ;
 ;#34012 = * No Subject *
