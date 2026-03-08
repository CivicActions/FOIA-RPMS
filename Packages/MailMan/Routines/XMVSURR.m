XMVSURR ;ISC-SF/GMB-Surrogate management ;04/14/99  15:40
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces ^XMA7 (ISC-WASH/RJ/THM/CAP)
 ; Entry points used by MailMan options (not covered by DBIA):
 ; SHARE    XMSHARE  - Become SHARED,MAIL
 ; ASSUME   XMASSUME - Become another user
SHARE ; Assume the identity of SHARED,MAIL
 Q:'$$CHKOK
 S XMDUZ=.6
 D SURROGAT^XMVVITAE(XMDUZ,.XMV,.XMDUN,"",.XMPRIV)
 D HEADER^XM
 D MANAGE^XMJBM
 D SELF
 Q
CHKOK() ;
 I $D(^XUSEC("XMNOPRIV",DUZ)) W !,*7,"You have been given the XMNOPRIV key and may not become anyone's surrogate." Q 0
 D CHECK^XMVVITAE
 Q 1
SELF ;
 S XMDUZ=DUZ
 D USER^XMVVITAE(XMDUZ,.XMV,.XMNOSEND,.XMDUN)
 W *7,!,"You are now yourself again.",!
 D HEADER^XM
 Q
ASSUME ; Assume someone else's identity
 I '$D(^XMB(3.7,"AB",DUZ)) D SHARE Q
 Q:'$$CHKOK
 D LISTEM
 N DIC,Y
 S DIC(0)="AEMQZ"
 S D="B^BB^C^D"
 S DIC="^VA(200,"
 S DIC("W")="D SHOWPRIV^XMVSURR(Y)"
 S DIC("S")="I Y=.6!$D(^XMB(3.7,""AB"",DUZ,Y))"
 I XMDUZ=DUZ D
 . S DIC("B")="SHARED,MAIL"
 E  D
 . S DIC("S")=DIC("S")_"!(Y=DUZ),Y'=XMDUZ"
 . S DIC("B")=XMV("DUZ NAME")
 . W !,"You may select yourself to resume your own identity."
 D MIX^DIC1 I Y=-1!$D(DUOUT)!$D(DTOUT) Q
 S XMDUZ=+Y
 I XMDUZ=DUZ D SELF Q
 I XMDUZ=.6 D SHARE Q
 D SURROGAT^XMVVITAE(XMDUZ,.XMV,.XMDUN,.XMNOSEND,.XMPRIV)
 D HEADER^XM
 Q
LISTEM ; List surrogates a user may become
 N XMDUZ
 W !,"Choose from:"
 S XMDUZ=0
 F  S XMDUZ=$O(^XMB(3.7,"AB",DUZ,XMDUZ)) Q:'XMDUZ  W !,?3,$$NAME^XMXUTIL(XMDUZ) D SHOWPRIV(XMDUZ)
 W !,?3,$$NAME^XMXUTIL(.6) D SHOWPRIV(.6) W !
 Q
SHOWPRIV(XMDUZ) ;
 Q:XMDUZ=DUZ
 I XMDUZ=.6 W ?40,"Read Privilege" Q
 N XMPRIV,XMNEW
 S XMPRIV=$P($G(^XMB(3.7,XMDUZ,9,+$O(^XMB(3.7,"AB",DUZ,XMDUZ,0)),0)),U,2,3)
 I XMPRIV'["y" W ?40,"No Privileges" Q
 S XMNEW=$$TNMSGCT^XMXUTIL(XMDUZ)
 I $L(XMPRIV,"y")>2 W ?39," Read & Write Privileges"
 E  W ?39,$S($P(XMPRIV,U)["y":" Read",1:" Write")," Privilege"
 W ?64," ",$S(XMNEW:XMNEW,1:"No")," New Msgs"
 Q
