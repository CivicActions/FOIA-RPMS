XMJBM1 ;ISC-SF/GMB-Manage Mail in Mailbox (cont'd) ;05/10/99  09:10
 ;;7.1;MailMan;**50**;Jun 02, 1994
INIT(XMDUZ,XMRDR,XMABORT) ;
 D CHECK^XMVVITAE
 I XMDUZ'=DUZ,'$$RPRIV^XMXSEC D  Q
 . S XMABORT=1
 . D SHOW^XMJERR
 D RDR(.XMRDR,.XMABORT)
 Q
RDR(XMRDR,XMABORT) ;
 S XMRDR=XMV("RDR DEF")
 Q:XMV("RDR ASK")="N"
 N DIR,DIRUT,X,Y,XMRDRTXT
 S XMRDRTXT=$S(XMRDR="D":"Detailed Full Screen",XMRDR="S":"Summary Full Screen",1:"Classic")
 S DIR("A")="Select message reader:  "
 S DIR("B")=XMRDRTXT
 S DIR(0)="SAMB^C:Classic;D:Detailed Full Screen;S:Summary Full Screen"
 S DIR("??")="^D QRDR^XMJBM1"
 D ^DIR I $D(DIRUT) S XMABORT=1 Q
 S XMRDR=Y
 Q
QRDR ;
 W !,"The Classic reader is the one that has been around forever."
 W !
 W !,"The Full Screen reader has two flavors:"
 W !,"Detailed Full Screen contains a detailed message list."
 W !,"Summary Full Screen contains a summary message list."
 W !
 I $P($G(^XMB(3.7,DUZ,0)),U,16)="" D
 . W !,"You may choose a default MESSAGE READER under"
 . W !,"'Personal Preferences|User Options Edit'."
 . W !,"Until you do, the Classic reader will be your default."
 E  D
 . W !,"Your default MESSAGE READER is the ",XMRDRTXT," reader."
 . W !,"You may change your default MESSAGE READER under"
 . W !,"'Personal Preferences|User Options Edit'."
 W !
 W !,"If you don't want to be asked this question again, and wish to use the "
 W !,XMRDRTXT," reader exclusively, set the MESSAGE READER PROMPT to"
 W !,"""No, don't ask"" under 'Personal Preferences|User Options Edit'."
 Q
ASKBSKT(XMDUZ,XMRDR,XMK,XMKN,XMABORT) ;
 N XMKNEW,XMKNUM
 F  D ASKBSKT^XMJBN(XMDUZ,0,.XMK,.XMKN,.XMABORT) Q:XMABORT  D  Q:XMKNUM
 . S XMKNUM=+$P($G(^XMB(3.7,XMDUZ,2,XMK,1,0)),U,4)
 . D:'XMKNUM NOMSGS(XMDUZ,XMK,XMKN)
 Q:XMABORT
 Q:'XMKNUM
 Q:XMRDR'="C"
 W !,"Last message number: ",$O(^XMB(3.7,XMDUZ,2,XMK,1,"C",""),-1)
 W "   Messages in basket: ",XMKNUM
 S XMKNEW=$P(^XMB(3.7,XMDUZ,2,XMK,0),U,2)
 W:XMKNEW " (",XMKNEW," new)"
 W !,"Enter ??? for help."
 Q
NOMSGS(XMDUZ,XMK,XMKN) ;
 W !,"No messages in basket."
 Q:XMK<2
 I XMDUZ'=DUZ,$G(XMV("PRIV"))'["R",$G(XMV("PRIV"))'["W" Q
 W !
 N DIR,DIRUT,X,Y
 S DIR(0)="Y"
 S DIR("A",1)="Since the '"_XMKN_"' basket is empty,"
 S DIR("A")="do you want to delete it"
 S DIR("B")="YES"
 D ^DIR Q:'Y
 D DELBSKT^XMXBSKT(XMDUZ,XMK)
 W !,"Basket deleted."
 Q
