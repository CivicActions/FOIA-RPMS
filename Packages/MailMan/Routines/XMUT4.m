XMUT4 ;(WASH ISC)/CAP-INTEGRITY CHECKER ;05/27/99  07:29
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; CHKFILES   XMUT-CHKFIL
 Q
CHKFILES ;
 I $D(ZTQUEUED) D PROCESS Q
 N XMABORT
 S XMABORT=0
 D WARNING(.XMABORT) Q:XMABORT
 D EN^XUTMDEVQ("PROCESS^XMUT4","MailMan Global Integrity Checker")
 Q
WARNING(XMABORT) ;
 N DIR,X,Y
 W !!,"The MailMan file checker may take some time to process."
 W !,"If you have not tried it,  PLEASE try it when"
 W !,"the system will be quiescent for a LONG period of time."
 W !!,"ERRORS LISTED ARE GENERALLY NOT FATAL."
 W !,"(Please contact your ISC if there are many errors.)"
 W !!,"MOST ERRORS ARE CORRECTED:  New message, basket counts..."
 W !!,"Keep list generated for future reference.  If you see errors in"
 W !,"MailMan, the list may help to resolve them.",!
 S DIR(0)="Y",DIR("A")="Do you wish to proceed",DIR("B")="NO"
 S DIR("?")="Enter 'Y' to proceed, 'N' or '^' to stop."
 D ^DIR
 I $D(DIRUT)!'Y S XMABORT=1
 Q
PROCESS ;
 D MAILBOX
 D MESSAGE
 D SUMMARY
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
MESSAGE ;
 D MESSAGE^XMUT4C
 Q
SUMMARY ;
 D SUMMARY^XMUT4B
 Q
MAILBOX ;
 W:'$D(ZTQUEUED) !!,"Checking ^XMB(3.7, MAILBOX file"
 D USERS
 D MXREF
 D POSTBSKT
 Q
MXREF ;
 ; XMECNT   # messages in mailbox
 N XMZ,XMUSER,XMECNT,XMK
 W:'$D(ZTQUEUED) !!,"Checking M xref",!
 S (XMZ,XMECNT)=0
 F  S XMZ=$O(^XMB(3.7,"M",XMZ)) Q:'XMZ  D
 . S XMECNT=XMECNT+1 I '$D(ZTQUEUED),XMECNT#5000=0 W:$X>40 ! W XMECNT,"."
 . S XMUSER=""
 . F  S XMUSER=$O(^XMB(3.7,"M",XMZ,XMUSER)) Q:'XMUSER  D
 . . S XMK=""
 . . F  S XMK=$O(^XMB(3.7,"M",XMZ,XMUSER,XMK)) Q:'XMK  D
 . . . Q:$D(^XMB(3.7,XMUSER,2,XMK,1,XMZ,0))
 . . . K ^XMB(3.7,"M",XMZ,XMUSER,XMK)
 . . . D ERR(121,"M xref, but msg not in bskt: xref killed",XMUSER,XMK,XMZ)
 W:'$D(ZTQUEUED) !!,XMECNT," messages"
 Q
USERS ;
 ; XMUKCNT  # user's baskets
 ; XMUNCNT  # new messages for a user
 ; XMUCNT   # users
 ; XMKCNT   # baskets
 ; XMECNT   # message entries
 N XMUSER,XMECNT,XMUCNT,XMKCNT
 W:'$D(ZTQUEUED) !!,"Checking each user mailbox",!
 S (XMUSER,XMECNT,XMUCNT,XMKCNT)=0
 F  S XMUSER=$O(^XMB(3.7,XMUSER)) Q:XMUSER'>0  D
 . S XMUCNT=XMUCNT+1 I '$D(ZTQUEUED),XMUCNT#20=0 W:$X>40 ! W XMUCNT,"."
 . D USER(XMUSER,.XMUKCNT,.XMUECNT)
 . S XMKCNT=XMKCNT+XMUKCNT
 . S XMECNT=XMECNT+XMUECNT
 W:'$D(ZTQUEUED) !!,XMUCNT," Users, ",XMKCNT," Baskets, ",XMECNT," Entries"
 I $D(^XMB(3.7,0)) S:$P(^XMB(3.7,0),U,4)'=XMUCNT $P(^(0),U,4)=XMUCNT Q
 S ^XMB(3.7,0)="MAILBOX^3.7P^3^"_XMUCNT
 Q
USER(XMUSER,XMUKCNT,XMUECNT) ;
 ; XMUKECNT # messages in a user's basket
 ; XMUKNCNT # new messages in a user's basket
 N XMK,XMUKNCNT,XMUKECNT,XMUNCNT
 D BXREF(XMUSER)
 D N0XREF(XMUSER)
 S (XMK,XMUKCNT,XMUNCNT,XMUECNT)=0
 F  S XMK=$O(^XMB(3.7,XMUSER,2,XMK)) Q:XMK'>0  D
 . Q:XMK=.95
 . S XMUKCNT=XMUKCNT+1
 . D BSKT(XMUSER,XMK,.XMUKNCNT,.XMUKECNT)
 . S XMUNCNT=XMUNCNT+XMUKNCNT
 . S XMUECNT=XMUECNT+XMUKECNT
 S:$P($G(^XMB(3.7,XMUSER,0)),U,1)'=XMUSER $P(^(0),U,1)=XMUSER
 S:$P(^XMB(3.7,XMUSER,0),U,6)'=XMUNCNT $P(^(0),U,6)=XMUNCNT
 S:'$D(^XMB(3.7,"B",XMUSER,XMUSER)) ^XMB(3.7,"B",XMUSER,XMUSER)=""
 I $D(^XMB(3.7,XMUSER,2,0)) S:$P(^XMB(3.7,XMUSER,2,0),U,4)'=XMUKCNT $P(^(0),U,4)=XMUKCNT Q
 S ^XMB(3.7,XMUSER,2,0)="^3.701^"_$O(^XMB(3.7,XMUSER,2,"B"),-1)_U_XMUKCNT
 Q
BSKT(XMUSER,XMK,XMUKNCNT,XMUKECNT) ;
 N XMKN,XMKZ,XMZ,XMREC,XMRESEQ
 D CXREF(XMUSER,XMK,.XMRESEQ)
 S (XMZ,XMUKNCNT,XMUKECNT)=0
 F  S XMZ=$O(^XMB(3.7,XMUSER,2,XMK,1,XMZ)) Q:XMZ'>0  D
 . S XMREC=^XMB(3.7,XMUSER,2,XMK,1,XMZ,0)
 . I $P(XMREC,U,1)'=XMZ D
 . . S $P(^XMB(3.7,XMUSER,2,XMK,1,XMZ,0),U,1)=XMZ
 . . D ERR(103,"Msg in bskt, but no .01 field: .01 field created",XMUSER,XMK,XMZ)
 . I '$D(^XMB(3.9,XMZ,0)) D  Q
 . . D ERR(101,"Msg in bskt, but no msg: removed from bskt",XMUSER,XMK,XMZ)
 . . D ZAPIT^XMXMSGS2(XMUSER,XMK,XMZ)
 . S XMUKECNT=XMUKECNT+1
 . S XMKZ=$P(XMREC,U,2)
 . I XMKZ D
 . . I '$D(^XMB(3.7,XMUSER,2,XMK,1,"C",XMKZ,XMZ)) S ^(XMZ)="" D ERR(112,"Msg in bskt, but no C xref: xref created",XMUSER,XMK,XMZ)
 . E  D
 . . S XMKZ=$O(^XMB(3.7,XMUSER,2,XMK,1,"C",""),-1)+1
 . . S $P(^XMB(3.7,XMUSER,2,XMK,1,XMZ,0),U,2)=XMKZ
 . . S ^XMB(3.7,XMUSER,2,XMK,1,"C",XMKZ,XMZ)=""
 . . D ERR(102,"Msg in bskt, but no seq #: seq # created",XMUSER,XMK,XMZ)
 . ;I XMUSER=.5,XMK>999 Q
 . I $P(XMREC,U,3) D
 . . S XMUKNCNT=XMUKNCNT+1
 . . I '$D(^XMB(3.7,XMUSER,"N0",XMK,XMZ)) S ^(XMZ)="" D ERR(113,"New msg, but no N0 xref: xref created",XMUSER,XMK,XMZ)
 . I '$D(^XMB(3.7,"M",XMZ,XMUSER,XMK,XMZ)) S ^(XMZ)="" D ERR(111,"Msg in bskt, but no M xref: xref created",XMUSER,XMK,XMZ)
 I '$D(^XMB(3.7,XMUSER,2,XMK,0)) D
 . S XMKN=$S(XMK=1:"IN",XMK=.5:"WASTE",1:"* No Name *")
 . S ^XMB(3.7,XMUSER,2,XMK,0)=XMKN
 . D ERR(131,"No bskt 0 node: created",XMUSER,XMK)
 E  D
 . S XMKN=$P(^XMB(3.7,XMUSER,2,XMK,0),U)
 . I XMKN="" D
 . . S XMKN=$S(XMK=1:"IN",XMK=.5:"WASTE",1:"* No Name *")
 . . S $P(^XMB(3.7,XMUSER,2,XMK,0),U)=XMKN
 . . D ERR(132,"Bskt name null: created",XMUSER,XMK)
 I '$D(^XMB(3.7,XMUSER,2,"B",XMKN,XMK)) S ^(XMK)="" D ERR(141,"Bskt name, but no B xref: xref created",XMUSER,XMK)
 S:$P(^XMB(3.7,XMUSER,2,XMK,0),U,2)'=XMUKNCNT $P(^(0),U,2)=XMUKNCNT
 I $D(^XMB(3.7,XMUSER,2,XMK,1,0)) D
 . S:$P(^XMB(3.7,XMUSER,2,XMK,1,0),U,4)'=XMUKECNT $P(^(0),U,4)=XMUKECNT
 E  I XMUKECNT D
 . S ^XMB(3.7,XMUSER,2,XMK,1,0)="^3.702P^"_$O(^XMB(3.7,XMUSER,2,XMK,1,"C"),-1)_U_XMUKECNT
 . D ERR(133,"No msg multiple 0 node: created",XMUSER,XMK)
 Q:'$G(XMRESEQ)
 D RSEQ^XMXBSKT(XMUSER,XMK)
 D ERR(125,"C xref duplicate seq #s: bskt reseq'd",XMUSER,XMK)
 Q
CXREF(XMUSER,XMK,XMRESEQ) ; Check the basket's C xref (message sequence numbers in basket)
 N XMKZ,XMZ,XMCNT
 S XMKZ=0
 F  S XMKZ=$O(^XMB(3.7,XMUSER,2,XMK,1,"C",XMKZ)) Q:'XMKZ  D
 . S (XMZ,XMCNT)=0
 . F  S XMZ=$O(^XMB(3.7,XMUSER,2,XMK,1,"C",XMKZ,XMZ)) Q:'XMZ  D
 . . S XMCNT=XMCNT+1
 . . Q:$P($G(^XMB(3.7,XMUSER,2,XMK,1,XMZ,0)),U,2)=XMKZ
 . . I '$D(^XMB(3.7,XMUSER,2,XMK,1,XMZ,0)) D  Q
 . . . S ^XMB(3.7,XMUSER,2,XMK,1,XMZ,0)=XMZ_U_XMKZ
 . . . D ERR(122,"C xref, but msg not in bskt: put in bskt",XMUSER,XMK,XMZ)
 . . I $P(^XMB(3.7,XMUSER,2,XMK,1,XMZ,0),U,2)="" D  Q
 . . . S $P(^XMB(3.7,XMUSER,2,XMK,1,XMZ,0),U,2)=XMKZ
 . . . D ERR(123,"C xref, but no msg seq #: set seq # using xref",XMUSER,XMK,XMZ)
 . . K ^XMB(3.7,XMUSER,2,XMK,1,"C",XMKZ,XMZ)
 . . D ERR(124,"C xref does not match msg seq #: xref killed",XMUSER,XMK,XMZ)
 . S:XMCNT>1 XMRESEQ=1
 Q
N0XREF(XMUSER) ; Check the user's N0 xref (new messages)
 N XMK,XMZ
 S XMK=0
 F  S XMK=$O(^XMB(3.7,XMUSER,"N0",XMK)) Q:'XMK  D
 . S XMZ=0
 . F  S XMZ=$O(^XMB(3.7,XMUSER,"N0",XMK,XMZ)) Q:'XMZ  D
 . . Q:$P($G(^XMB(3.7,XMUSER,2,XMK,1,XMZ,0)),U,3)=1
 . . I '$D(^XMB(3.7,XMUSER,2,XMK,1,XMZ,0)) D  Q
 . . . S ^XMB(3.7,XMUSER,2,XMK,1,XMZ,0)=XMZ_"^^1"
 . . . D ERR(126,"N0 xref, but msg not in bskt: msg put in bskt",XMUSER,XMK,XMZ)
 . . S $P(^XMB(3.7,XMUSER,2,XMK,1,XMZ,0),U,3)=1
 . . D ERR(127,"N0 xref, but msg not new: new flag set",XMUSER,XMK,XMZ)
 Q
BXREF(XMUSER) ; Check the user's B xref (basket names)
 N XMK,XMKN
 S XMKN=""
 F  S XMKN=$O(^XMB(3.7,XMUSER,2,"B",XMKN)) Q:XMKN=""  D
 . S XMK=0
 . F  S XMK=$O(^XMB(3.7,XMUSER,2,"B",XMKN,XMK)) Q:'XMK  D
 . . Q:$E($P($G(^XMB(3.7,XMUSER,2,XMK,0)),U),1,30)=XMKN
 . . I $D(^XMB(3.7,XMUSER,2,XMK,0)) D  Q
 . . . S $P(^XMB(3.7,XMUSER,2,XMK,0),U)=XMKN
 . . . D ERR(151,"B xref, but bskt name null: name set using xref",XMUSER,XMK)
 . . S $P(^XMB(3.7,XMUSER,2,XMK,0),U)=XMKN
 . . D ERR(152,"B xref, but no bskt node: node set using xref",XMUSER,XMK)
 Q
POSTBSKT ; Check the Postmaster's baskets to see if any
 ; remote baskets are numbered below 1000.  If so, move them.
 N XMK,XMKN,XMKINST,XMZ,XMINST,XMPUT
 S XMK=1
 F  S XMK=$O(^XMB(3.7,.5,2,XMK)) Q:XMK>999  S XMKN=$P(^(XMK,0),U,1)  D
 . S XMINST=$$FIND1^DIC(4.2,"","XQ",XMKN)
 . Q:'XMINST
 . D ERR(160,"Xmit basket<1000 has domain name: investigate msgs.",.5,XMK)
 . ; This basket has a remote site name.  Does it have msgs to xmit?
 . S XMKINST=XMINST+1000
 . I '$D(^XMB(3.7,.5,2,XMKINST)) D MAKEBSKT^XMXBSKT(.5,XMKINST,XMKN)
 . S (XMZ,XMPUT)=0
 . F  S XMZ=$O(^XMB(3.7,.5,2,XMK,1,XMZ)) Q:'XMZ  D
 . . I '$D(^XMB(3.9,XMZ,1,"AQUEUE",XMINST)) D  Q
 . . . ; This msg does not need to be transmitted.  Does it belong here?
 . . . Q:$D(^XMB(3.9,XMZ,1,"C",.5))!$$BCAST^XMXSEC(XMZ)
 . . . D ERR(161,"Msg in xmit basket<1000 not addressed to Postmaster: deleted.",.5,XMK,XMZ)
 . . . D ZAPIT^XMXMSGS2(.5,XMK,XMZ)
 . . ; This msg needs to be transmitted.  Is it in the real xmit bskt?
 . . Q:$D(^XMB(3.7,.5,2,XMKINST,1,XMZ))  ; already there
 . . S XMPUT=XMPUT+1
 . . I $D(^XMB(3.9,XMZ,1,"C",.5))!$$BCAST^XMXSEC(XMZ) D  Q
 . . . D ERR(162,"Msg in xmit basket<1000: copied to proper bskt.",.5,XMK,XMZ)
 . . . D PUTMSG^XMXMSGS2(.5,XMKINST,XMKN,XMZ)
 . . D ERR(163,"Msg in xmit basket<1000: moved to proper bskt.",.5,XMK,XMZ)
 . . D COPYIT^XMXMSGS2(.5,XMK,XMZ,XMKINST)
 . . D ZAPIT^XMXMSGS2(.5,XMK,XMZ)
 . Q:$$BMSGCT^XMXUTIL(.5,XMK)
 . N XMFDA
 . S XMFDA(3.701,XMK_",.5,",.01)="@"
 . D FILE^DIE("","XMFDA")
 . D ERR(164,"Xmit basket<1000 with no msgs: deleted.",.5,XMK)
 Q
ERR(XMERRNUM,XMERRMSG,XMUSER,XMK,XMZ) ;
 S XMERROR(XMERRNUM)=$G(XMERROR(XMERRNUM))+1
 Q:$D(ZTQUEUED)
 W !,"DUZ=",XMUSER,", Bskt=",XMK,$S($D(XMZ):", Msg="_XMZ,1:""),", Err=",$J(XMERRNUM,3)," ",XMERRMSG
 Q
