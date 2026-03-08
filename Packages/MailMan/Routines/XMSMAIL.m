XMSMAIL ;(WASH ISC)/THM/CAP-SMTP TRANSMITTER ;04/07/99  16:08
V ;;7.1;MailMan;**59,50**;Jun 02, 1994
MAIL ;SEND MAIL
 S %DT="T",X="N" D ^%DT S XMD=Y
 S XMR=^XMB(3.9,XMZ,0),XMPOST=20
 S XMNVFROM=$P($G(^XMB(3.9,XMZ,.7)),U,1) ; envelope from
 S XMFROM=$$FROM($P(XMR,U,2))
 I XMNVFROM="" S XMNVFROM=XMFROM
 S XMSG="MAIL FROM:"_XMNVFROM X XMSEN Q:ER
 I 'XMBT S XMSTIME=300 X XMREC K XMSTIME Q:ER
 I XMBT S XMRG="200 ID:Batch"
 I 'XMBT,$E(XMRG)'=2 D MAILNO^XMSERR,TRASH^XMS S ER=0 Q
 S XMRZ=$P(XMRG,"ID:",2)
RCPT ;IDENTIFY RECIPIENTS
 S J=0 I $G(XMSDOM) S XMINST=XMSDOM
 D R1 Q:ER  G RESET^XMS:$O(XMJ(0))="",GO^XMS0
R1 ; Loop from bottom of routine
 S J=$O(^XMB(3.9,XMZ,1,"AQUEUE",XMINST,J)) Q:'J
 S XMDES=$G(^XMB(3.9,XMZ,1,J,0)) G R1:$P(XMDES,U,7)'=XMINST
 I $G(XMR)="" S XMR=^XMB(3.9,XMZ,0)
 S (Y,XMDER)=$P(XMDES,U)
 S:$D(^XMB(3.9,XMZ,1,J,"T")) (Y,XMDER)=$P(^XMB(3.9,XMZ,1,J,"T"),U)_":"_XMDER
 I $P(Y,"@",2)=^XMB("NETNAME") S $P(XMDES,U,6,7)="^",^XMB(3.9,XMZ,1,J,0)=XMDES G R1
 ;S Y=$P(Y,"@") I $S($G(XMVA)>4:1,'$G(XMVA):1,1:0) S:Y["," Y=$TR(Y,", .","._+")
 S Y=$P(Y,"@")
 G R2:Y?.A
 I $E(Y)=$C(34),$E(Y,$L(Y))=$C(34) G R2
 S:Y?.E1C.E Y=$$CTRL^XMXUTIL1(Y)
 ; If we translate blanks to underscores, we run into problems with
 ; G. and S. names which contain blanks.  ^XMXADDR1 does not translate
 ; them back.
 I Y["," S Y=$TR(Y,", .","._+")
 ;Allowed punctuation (without quoting rcpt name is .%_-@+!
 I $TR(Y,"()<>@,;:\[]"_$C(34),"")=Y G R
 ;Reformat name for \ and " characters
 S %=-1
S S %=$F(Y,"\",%+2) I % S Y=$E(Y,1,%-2)_"\"_$E(Y,%,$L(Y)) G S
 S %=-1
D S %=$F(Y,"""",%+2) I % S Y=$E(Y,1,%-2)_"\"_$E(Y,%-1,$L(Y)) G D
 ;
R S X=Y_"@"_$P(XMDER,"@",2,99)
 S XMDER=X
R2 S XMSG="RCPT TO:<"_XMDER_">"_$S('$G(XMVA):"",$D(^XMB(3.9,XMZ,1,J,"F")):$$FWDBY(^("F")),1:"") X XMSEN Q:ER
 I 'XMBT S XMSTIME=300 X XMREC K XMSTIME Q:ER
 I XMBT S XMRG="200 In transit"
 I $E(XMRG)=2 S XMJ(J)="" G R1
R3 S XMSUP=$G(XMSUP)+1 I XMSUP<3 S X=XMDER,XMDER=$S(XMSUP=1:$TR(XMDER,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz"),XMSUP=2:$TR(XMDER,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")) G R2:X'=XMDER,R3
 K XMSUP
 D ENTR^XMSM(XMD,XMRG,XMZ,$P(XMR,U,1),XMNVFROM,$P(XMDES,U),XMDER,J)
 G R1
FWDBY(XMFREC) ;
 I $E(XMFREC,U,1)=" " Q ""
 I $E(XMFREC,U,1)="<" Q " FWD BY:"_$P(XMFREC,">",1)_">"
 N XMFDUZ
 S XMFDUZ=$P(XMFREC,U,2)
 I +XMFDUZ=XMFDUZ Q " FWD BY:<"_$$NETNAME^XMXUTIL(XMFDUZ)_">"
 Q ""
FROM(XMFROM) ;
 I $F(XMFROM,"@"_^XMB("NETNAME"))>$L(XMFROM) S XMFROM=$P(XMFROM,"@"_^XMB("NETNAME"))
 I XMFROM'["@" Q "<"_$$NETNAME^XMXUTIL(XMFROM)_">"
 Q "<"_$$REMADDR^XMXADDR1(XMFROM)_">"
