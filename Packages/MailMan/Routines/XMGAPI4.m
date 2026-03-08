XMGAPI4 ;(WASH ISC)/CAP - Info Functions (Alerts...) ;11/8/94  12:19 [ 04/02/2003   8:29 AM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;;Jul 10, 1995
NU(XM,Z,XMT) ;API for new message display
 ;
 ;Usage:  S X=$$NU^XMGAPI4(1) = Display on screen
 ;        S X=$$NU^XMGAPI4(0) = Do not display
 ;        S X=$$NU^XMGAPI4(1,1,"ABC") Return displayable array "ABC"
 ;
 ;Inputs:  DUZ must exist
 ;         XMDUZ will exist if the context is in MailMan
 ;
 ;XM=1 to force new display
 ;XM=0 for no display
 ;Z=1 will cause an array to be passed back in array XMT
 ;
 S XM("XMT")=$G(Z) N XM0 S XM0=0 D XN
 I XM("XMT"),XMT?1.AN M @XMT=XM0 Q Y
 ;
 ;Return values or write
 I XM W !,*7 N I S I=0 F  S I=$O(XM0(I)) Q:'I  W XM0(I),!
 Q Y
CHK K ^TMP("XMY",$J),^TMP("XMY0",$J) Q:$G(XMDUZ)=.6  N XM S XM=0
XN S XM(0)=$S($D(XMDUZ):XMDUZ,1:DUZ) I '$D(XM0) N XM0 S XM0=0
 I $D(^XMB(3.7,XM(0),0)) S Y=+$P(^(0),U,6) D  G XM1
 . Q:'XM!'Y
 . S XM0=XM0+1,XM0(XM0)=$S(XM(0)=.5:"The Postmaster has",1:"You have")_" "_$S(Y:Y,1:"NO")_" new message"_$S(Y=1:"",1:"s")
 . S %=$P(^XMB(3.7,XM(0),2,1,0),U,2)
 . I % S XM0(XM0)=XM0(XM0)_" ["_%_" in the 'IN' basket]"
 . S %=$S($D(^XMB(3.7,XM(0),"N0",0)):^(0),1:0)
 . I % D D S XM0=XM0+1,XM0(XM0)="(Last arrival: "_A_")"
 . K:'$D(DUZ("SAV")) ^XMB(3.7,XM(0),"N0",0)
 . S XM0=XM0+1,XM0(XM0)=""
 . S XM0=XM0+1
 I XM(0)'=.5 S XM0(XM0)="Enter '^NML' to read your new messages !"
 . Q
XM1 I $D(^XMB(3.7,XM(0),"N")),'$P($G(^(0)),U,13) D C
 ;
 ;If Postmaster surrogate notify of new Postmaster mail
 Q:$S(DUZ=.5:1,$G(XMDUZ)=.5:1,1:0)
 I XM,$D(^XMB(3.7,"AB",XM(0),.5)) D PM K XM0(XM0)
 Q
PM N XMDUZ S XMDUZ=.5
 S XM0(XM0+1)="",XM0(XM0+2)="Checking the Postmaster's Mail Box !",XM0=XM0+2
 D XN
 Q
C N Y I '$D(IORVON) N IORVON,IORVOFF,IOBON,IOBOFF D ZIS^XMAH1
 S XM0=XM0+1,XM0(XM0)=$S($D(IORVON):IORVON,1:"")_"There is PRIORITY Mail for you !!!"_$S($D(IORVOFF):IORVOFF,1:"")
 Q
D N Y S Y=%,A=$E(Y,6,7)_" "_$P("Jan^Feb^Mar^Apr^May^Jun^Jul^Aug^Sep^Oct^Nov^Dec",U,$E(Y,4,5))_" "_$E(Y,2,3)
 I Y\1'=Y S Y=$P(Y,".",2)_"0000",A=A_" "_$E(Y,1,2)_":"_$E(Y,3,4)
 Q
LST(A,X,Y) ;List NEW message (or any other) array
 ; A=Array to list
 ; X=X address of box
 ; Y=Y address of box
 ;
 N I,S S I="",$P(S," ",IOM+1)=""
 F  S I=$O(A(I)) Q:I=""  D
 . I $G(X) S DX=X,DY=Y X IOXY
 . E  W !
 . W $E(A(I)_S,1,IOM-$G(X))
 . I $D(Y) S Y=Y+1
 . Q
 Q
PRIALRT ;Priority Mail Alert
 N XQAID S XQAID="XM-PRIOMESS" D ALERT
 I '$D(XMDUZ) N XMDUZ S XMDUZ=DUZ
 W !,"Select PRIORITY (NEW) messages (one at a time) from the list given.",!
 H 1 G PRIO^XMA0A
NEWALRT ;Alert for NEW Mail
 N XQAID S XQAID="XM-NEWMESS" D ALERT
 I '$D(XMDUZ) N XMDUZ S XMDUZ=DUZ
 W !,"Select NEW messages (one at a time) from the list given.",! H 1
 G LIST^XMA0A
ALERT N X,XQAKILL
 S X=$$NU(1,1,"X") D LST(.X)
 S XQA($S($G(XMDUZ):XMDUZ,1:DUZ))="",XQAKILL=1
 D DELETEA^XQALERT
 Q
