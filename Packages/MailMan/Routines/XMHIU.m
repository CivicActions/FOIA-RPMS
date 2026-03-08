XMHIU ;ISC-SF/GMB User Info ;05/11/99  14:16
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces UHELP^XMA7 (ISC-WASH/RJ/THM/CAP)
 ; Entry points used by MailMan options (not covered by DBIA):
 ; HELP      XMHELPUSER - Get user info
HELP ; User Info
 N DIC,Y
 D CHECK^XMVVITAE
 S DIC=200,DIC(0)="AEQMZ",DIC("A")="User name: "
 S DIC("S")="I $S('$D(^VA(200,Y,0)):0,Y<1:1,$L($P(^(0),U,3)):1,1:0)"
 S DIC("W")="D USERINFO^XMXADDR(Y)"
 F  W ! D ^DIC Q:Y<0  D
 . W @IOF,$P(Y,U,2)
 . D DISPUSER(+Y)
 . S DIC("W")="D USERINFO^XMXADDR(Y)"
 Q
DISPUSER(XMUSER) ;
 N XMABORT
 S XMABORT=0
 D GENERAL(XMUSER)                     ; General info
 D GROUPS(XMUSER,.XMABORT) Q:XMABORT   ; Groups in which this user is a member
 D SURRBEU(XMUSER,.XMABORT) Q:XMABORT  ; Surrogates who may be this user
 D UBESURR(XMUSER,.XMABORT)            ; Users for whom this user may be surrogate
 Q
GENERAL(XMUSER) ;
 N X,XMREC
 I '$D(^XMB(3.7,XMUSER)) W !,"No Mailbox for this user !" Q
 S XMREC=$G(^XMB(3.7,XMUSER,0))
 Q:XMREC=""&'$D(^XMB(3.8,"AB",XMUSER))
 S X=$G(^XMB(3.7,XMUSER,"B")) W:$L(X) !,"Current Banner: ",X
 S X=$P($G(^XMB(3.7,XMUSER,"L")),U) W:$L(X) !,"Last used MailMan: ",X
 S X=$P(XMREC,U,6) I X D
 . W !,"This user has "_X_" NEW message"_$S(X>1:"s",1:"")
 . S X=$P(^XMB(3.7,XMUSER,2,1,0),U,2)
 . W:X " ("_X_" in the IN basket)"
 I $D(^XMB(3.7,XMUSER,1,0)) D
 . W !!,"Introduction:"
 . S X=0
 . F  S X=$O(^XMB(3.7,XMUSER,1,X)) Q:X'>0  W !,"  ",^(X,0)
 S X=$P(XMREC,U,2) I $L(X) W !,"Forwarding Address: ",X,", Local Delivery is "_$S($P(XMREC,U,8):"on",1:"off")
 S XMREC=$G(^VA(200,XMUSER,.13))
 S X=$P(XMREC,U,2) I X'="" W !!,"Office phone:  ",X
 S X=$P(XMREC,U,6) I X'="" W !,"Fax:           ",X
 S X=$P(XMREC,U,7) I X'="" W !,"Voice pager:   ",X
 S X=$P(XMREC,U,8) I X'="" W !,"Digital pager: ",X
 S X=$P(XMREC,U,3) I X'="" W !,"Add'l phone:   ",X
 S X=$P(XMREC,U,4) I X'="" W !,"Add'l phone:   ",X
 Q:'$P(^XMB(1,1,0),U,10)  ; Don't show address unless site OKs it.
 S XMREC=$G(^VA(200,XMUSER,.11),"^^")
 I $P(XMREC,U,1,3)'="^^" D
 . W !!,"Address: "
 . F X=1:1:3 I $P(XMREC,U,X)'="" W !,"  ",$P(XMREC,U,X)
 . S X=$P(XMREC,U,4) I X'="" W !,"  ",X
 . S X=$P(XMREC,U,5) I X W ", ",$P($G(^DIC(5,X,0)),U,2)
 . S X=$P(XMREC,U,6) I X'="" W "  ",X
 Q
GROUPS(XMUSER,XMABORT) ;
 N XMGIEN,XMREC,XMTYPE
 Q:'$D(^XMB(3.8,"AB",XMUSER))
 W !!,"Mail Groups:"
 S XMGIEN=""
 F  S XMGIEN=$O(^XMB(3.8,"AB",XMUSER,XMGIEN)) Q:XMGIEN=""  D  Q:XMABORT
 . S XMREC=$G(^XMB(3.8,XMGIEN,0)) Q:XMREC=""
 . S XMTYPE=$P(XMREC,U,2)
 . ; Don't show private group membership, unless user is a member, too.
 . I XMTYPE="PR",'$D(^XMB(3.8,"AB",DUZ,XMGIEN)) Q
 . I $Y+4>IOSL D PAGE(.XMABORT) Q:XMABORT
 . W !?2,$P(XMREC,U)
 . W:$G(^XMB(3.8,XMGIEN,3))=XMUSER " (Organizer) "
 . W ?45,$S(XMTYPE="PR":"(Private)",1:"(Public)")
 Q
SURRBEU(XMUSER,XMABORT) ; List surrogates for this user
 N XMSIEN
 Q:'$O(^XMB(3.7,XMUSER,9,0))
 W !!,"This user's surrogates are:"
 S XMSIEN=0
 F  S XMSIEN=$O(^XMB(3.7,XMUSER,9,XMSIEN)) Q:XMSIEN=""  D  Q:XMABORT
 . D DISPSURR(2,XMUSER,XMSIEN,.XMABORT)
 Q
UBESURR(XMSURR,XMABORT) ; List users for whom this user may act as surrogate
 N XMUSER,XMSIEN
 Q:'$O(^XMB(3.7,"AB",XMSURR,0))
 W !!,"This user may act as surrogate for:"
 S XMUSER=""
 F  S XMUSER=$O(^XMB(3.7,"AB",XMSURR,XMUSER)) Q:XMUSER=""  D  Q:XMABORT
 . S XMSIEN=$O(^XMB(3.7,"AB",XMSURR,XMUSER,""))
 . D DISPSURR(1,XMUSER,XMSIEN,.XMABORT)
 Q
DISPSURR(XMFLAG,XMUSER,XMSIEN,XMABORT) ;
 N XMPRIV,XMREC,XMNIEN
 I $Y+4>IOSL D PAGE(.XMABORT) Q:XMABORT
 S XMREC=$S(XMUSER=.6:".6^y^y",1:$G(^XMB(3.7,XMUSER,9,XMSIEN,0)))
 S XMNIEN=$S(XMFLAG=1:XMUSER,1:$P(XMREC,U,1))
 Q:'XMNIEN  Q:'$D(^VA(200,XMNIEN,0))
 W !,?2,$P(^VA(200,XMNIEN,0),U)
 S XMPRIV=$P(XMREC,U,2,3)
 I XMPRIV'["y" W ?45,"No Privileges" Q
 I $L(XMPRIV,"y")>2 W ?45,"Read and Write Privileges" Q
 W ?45,$S($P(XMPRIV,U)["y":"Read",1:"Write")," Privilege"
 Q
PAGE(XMABORT) ;
 D PAGE^XMXUTIL(.XMABORT) Q:XMABORT
 W @IOF
 Q
