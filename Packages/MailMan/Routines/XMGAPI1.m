XMGAPI1 ;(WASH ISC)/CAP-Initialize MailMan Variables ;5/31/95  16:59 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**17**;Jun 02, 1994
EN(DUZ,A) N %,X,XMCHAN,XMER,Y I $S('$D(DUZ)#2:1,DUZ=0:1,1:0) Q "1-No DUZ"
 S:'$D(XMDUZ) XMDUZ=DUZ K XMY,XMY0 F %="XMY","XMY0" K ^TMP(%,$J)
 S %=^VA(200,XMDUZ,0),XMDUN=$P(%,U),(XMKN,XMLOCK)="",(XMK,XMZ)=0
 S %=$P(^VA(200,XMDUZ,0),U,3)=""+$S('$D(^XMB(3.7,XMDUZ)):10,1:0)
 I %#10'=0 S XMER=$$XMER("2-No Access Code")
EN2 I '$D(^VA(200,DUZ,0)) S XMER=$$XMER("8-No Person") Q XMER
 S A=1,A(1)="VA MailMan "_$P($T(XMGAPI1+1),";",3)_" service for "_$S($P($L($G(^XMB(3.7,XMDUZ,.3))),U):$P(^(.3),U),1:$TR(XMDUN,", .","._+"))_"@"_^XMB("NETNAME")
 I XMDUZ'=DUZ S:$L(A(1))+13+$L($P(^VA(200,DUZ,0),U))>79 A=A+1,%="",$P(%," ",25)="" S A(A)=$G(A(A))_" (Surrogate: "_$P(^(0),U)_")"
 I XMDUZ'=.6 D DT^DICRW S %=$$D(%) S:$D(^XMB(3.7,XMDUZ,"L")) A=A+1,A(A)="You last used MailMan: "_$P(^("L"),U) Q:$D(DUZ("SAV")) "" S ^XMB(3.7,XMDUZ,"L")=%_$S(XMDUZ'=DUZ:" (Surrogate: "_$P(^VA(200,DUZ,0),U)_")",1:"")_U_DT_U_DUZ
 I '$D(^XMB(3.7,XMDUZ,0)) S XMER=$$XMER("4-No Mail Box") Q XMER
 S X=^XMB(3.7,XMDUZ,0)
 I $D(^XMB(3.7,XMDUZ,"B")) S Y=^("B") K:'$L(Y) ^("B") S:$L(Y) A=A+1,A(A)="Your current banner is: "_Y
 S Y=$P(X,U,6) I Y S A=A+1,A(A)=$S(XMDUZ=DUZ:"You have ",1:XMDUN_" has ")_Y_" new message"_$S(Y=1:"",1:"s")_"."
 I $D(^XMB(3.7,XMDUZ,"N")) S XMER=$$XMER("5-Priority Mail")
 I '$G(XMNOSEND),$D(^XMB(3.7,"AD",DUZ)) S XMER=$$XMER("6-Message in Buffer") Q XMER
 I $D(^XMB(1,1,0)) I $P(^(0),U,6)["y",'$D(^XMB(3.7,XMDUZ,1,1,0)) S XMER=$$XMER("7-No Introduction")
 D DSP^XM Q $S($D(XMER):XMER,1:"")
D(%) N A,Y S Y=%,A=$E(Y,6,7)_" "_$P("Jan^Feb^Mar^Apr^May^Jun^Jul^Aug^Sep^Oct^Nov^Dec",U,$E(Y,4,5))_" "_$E(Y,2,3)
 I Y\1'=Y S Y=$P(Y,".",2)_"0000",A=A_" "_$E(Y,1,2)_":"_$E(Y,3,4)
 Q A
XMER(%) Q $S('$L($G(XMER)):%,1:XMER_":"_%)
 ;
 ;Set receive variable for Server Protocol
READ() D REC^XMS3 Q XMRG
