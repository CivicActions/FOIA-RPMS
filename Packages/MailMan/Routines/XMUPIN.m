XMUPIN ;ISC-SF/GMB-IN Basket Purge ;06/15/99  10:35
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Replaces ^XMAI,^XMAI0,^XMAI1 (ISC-WASH/CAP)
 ; Entry points used by MailMan options (not covered by DBIA):
 ; ENTER  XMMGR-IN-BASKET-PURGE
ENTER ;
 ; XMIDAYS  If msg hasn't been read for this many days, flag for deletion
 ; XMDDAYS  If flagged msg hasn't been read after this many days, delete it
 N XMIDAYS,XMDDAYS,XMKALL,XMEXEMPT,XMABORT,XMTEST
 D INIT(.XMDUZ,.XMTEST,.XMDDAYS,.XMIDAYS,.XMKALL,.XMABORT) Q:XMABORT
 D PROCESS(XMTEST,XMDDAYS,XMIDAYS,XMKALL,.XMEXEMPT)
 Q
TEST ;
 N XMIDAYS,XMDDAYS,XMKALL,XMEXEMPT,XMABORT,XMTEST
 S XMTEST=1
 D INIT(.XMDUZ,.XMTEST,.XMDDAYS,.XMIDAYS,.XMKALL,.XMABORT) Q:XMABORT
 D PROCESS(XMTEST,XMDDAYS,XMIDAYS,XMKALL,.XMEXEMPT)
 Q
INIT(XMDUZ,XMTEST,XMDDAYS,XMIDAYS,XMKALL,XMABORT) ;
 I '$D(DUZ) W *7,!!!,"<<<< Who are you ? (NO DUZ) >>>>",!! G H^XUS
 I '$D(XMDUZ) S XMDUZ=.5
 D DT^DICRW ; Set up required FM variables
 S:'$D(XMTEST) XMTEST=0
 S XMDDAYS=30,XMABORT=0
 S XMIDAYS=+$P($G(^XMB(1,1,0)),U,9)
 S:'XMIDAYS XMIDAYS=30
 S XMKALL=+$P($G(^XMB(1,1,.15)),U)
 Q:$D(ZTQUEUED)
 N DIR,Y,DIRUT
 W !!,"This process cleans out old messages from 'IN' baskets."
 W !,"You may set the number of days messages will be retained"
 W !,"by this routine in the MAILMAN SITE PARAMETERS file (field 10)",!
 W !,"'IN' Basket messages that are not 'NEW' and have NOT been READ for "
 W !,XMIDAYS," days are marked for automatic deletion.  Messages so marked"
 W !,"that have not been read nor saved into another Basket within ",XMDDAYS
 W !,"days will be deleted automatically and completely from user's Baskets."
 W !!,"The deletion is NOT to the WASTE basket.  It is complete!"
 W !,"Each user will receive a message listing messages that are marked"
 W !,"for deletion.  The ",XMDDAYS," day grace period allows users to receive"
 W !,"this message and have time to prevent messages they want to keep from"
 W !,"being deleted from their Mail Baskets."
 W !!,"Even then many of the messages may still be recalled via the"
 W !,"search process that can be invoked to search for messages that"
 W !,"the user is a recipient of.  As long as the 'AUTOPURGE' has not been run"
 W !,"or another user has kept a copy, messages can be recovered.",!
 S DIR("A")="This may take some time.  Do you wish to continue"
 S DIR(0)="Y",DIR("B")="NO",DIR("??")="XM-IN-BASKET-PURGE"
 D ^DIR I $D(DIRUT)!'Y S XMABORT=1 Q
 W !!,"Compiling lists of messages to PURGE in ",XMDDAYS," days from "_$S(XMKALL:"*all* baskets",1:"user's IN Baskets")
 Q
PROCESS(XMTEST,XMDDAYS,XMIDAYS,XMKALL,XMEXEMPT) ;
 ; XMDDATE  Deletion date for inactive messages (FM format)
 ; XMDDATEX Deletion date for inactive messages (external format)
 ; XMIDATE  Date beyond which message has had no activity (and thus
 ;          becomes candidate for deletion).
 ; XMKALL   1=all baskets; 0=IN basket only
 ; XMEXEMPT Users exempt from purge (":duz1:duz2:...:duzn:")
 N XMDDATE,XMDDATEX,XMIDATE,XMUSER,XMK,XMI,XMLEN,XMLEFT,XMHDR
 S XMLEFT=79
 S XMLEN("XMZ")=$L($O(^XMB(3.9,":"),-1))+2
 S XMLEFT=XMLEFT-XMLEN("XMZ")-24
 S XMLEN("SUBJ")=XMLEFT\2
 S XMLEN("FROM")=XMLEFT-XMLEN("SUBJ")
 S XMHDR(1)=$$LJ^XLFSTR("Msg ID",XMLEN("XMZ")+1)_$$LJ^XLFSTR("Date      Subject",XMLEN("SUBJ")+12)_$$LJ^XLFSTR($$EZBLD^DIALOG(34006),XMLEN("FROM")+2)_"Last Read"
 S XMHDR(2)=$$REPEAT^XLFSTR("-",XMLEN("XMZ"))_" "_$$REPEAT^XLFSTR("-",9)_" "_$$REPEAT^XLFSTR("-",XMLEN("SUBJ"))_"  "_$$REPEAT^XLFSTR("-",XMLEN("FROM"))_"  "_$$REPEAT^XLFSTR("-",9)
 S XMDDATE=$$FMADD^XLFDT(DT,30)
 S XMDDATEX=$$MMDT^XMXUTIL1(XMDDATE)
 S XMIDATE=$$FMADD^XLFDT(DT,-XMIDAYS)
 S XMUSER=.999
 K ^TMP("XM",$J)
 F  S XMUSER=$O(^XMB(3.7,XMUSER)) Q:XMUSER'>0  D
 . Q:$G(XMEXEMPT)[(":"_XMUSER_":")
 . S XMI=10
 . I XMKALL D
 . . S XMK=.99
 . . F  S XMK=$O(^XMB(3.7,XMUSER,2,XMK)) Q:XMK'>0  D BASKET(XMTEST,XMK,$P($G(^(XMK,0),"NO NAME"),U),XMIDATE,XMDDATE,.XMLEN,.XMI)
 . E  D BASKET(XMTEST,1,"IN",XMIDATE,XMDDATE,.XMLEN,.XMHDR,.XMI)
 . Q:'$D(^TMP("XM",$J))
 . D SENDMSG(XMTEST,XMKALL,XMIDAYS,XMDDATEX,XMUSER)
 . K ^TMP("XM",$J)
 Q
BASKET(XMTEST,XMK,XMKN,XMIDATE,XMDDATE,XMLEN,XMHDR,XMI) ; Process Basket
 N XMZ,XMZDATE,XMREC,XMZREC,XMFDA,XMIENS,XMFIRST,XMIREC
 S XMZ=0,XMFIRST=1
 F  S XMZ=$O(^XMB(3.7,XMUSER,2,XMK,1,XMZ)) Q:XMZ'>0  S XMREC=$G(^(XMZ,0)) D
 . ; Quit if no data OR new msg OR already scheduled for deletion
 . ; OR activity after the cutoff date
 . Q:XMREC=""!$P(XMREC,U,3)!$P(XMREC,U,5)!($P(XMREC,U,4)>XMIDATE)
 . S XMZREC=$G(^XMB(3.9,XMZ,0))
 . S XMZDATE=$P(XMZREC,U,3)
 . S:XMZDATE'?7N1".".N XMZDATE=$$CONVERT^XMXUTIL1(XMZDATE)
 . I $P(XMREC,U,4)="" Q:XMZDATE>XMIDATE
 . I 'XMTEST D  ; Mark message w/delete date ("AC" x-ref created by trigger)
 . . S XMIENS=XMZ_","_XMK_","_XMUSER_","
 . . S XMFDA(3.702,XMIENS,5)=XMDDATE
 . . S XMFDA(3.702,XMIENS,7)=1
 . . D FILE^DIE("","XMFDA")
 . I XMFIRST D
 . . S XMFIRST=0
 . . S XMI=XMI+1,^TMP("XM",$J,XMI)=""
 . . S XMI=XMI+1,^TMP("XM",$J,XMI)="Basket: "_XMKN
 . . S XMI=XMI+1,^TMP("XM",$J,XMI)=""
 . . S XMI=XMI+1,^TMP("XM",$J,XMI)=XMHDR(1)
 . . S XMI=XMI+1,^TMP("XM",$J,XMI)=XMHDR(2)
 . S XMIREC=$J("["_XMZ_"]",XMLEN("XMZ"))_" "_$E($$MMDT^XMXUTIL1(XMZDATE),1,9)_" "_$$LJ^XLFSTR($E($$SUBJ^XMXUTIL2(XMZREC),1,XMLEN("SUBJ")),XMLEN("SUBJ"))
 . S XMIREC=XMIREC_"  "_$$LJ^XLFSTR($E($$NAME^XMXUTIL($P(XMZREC,U,2)),1,XMLEN("FROM")),XMLEN("FROM"))_"  "_$$MMDT^XMXUTIL1($P($P(XMREC,U,4),".",1))
 . S XMI=XMI+1,^TMP("XM",$J,XMI)=XMIREC
 Q
SENDMSG(XMTEST,XMKALL,XMIDAYS,XMDDATEX,XMTO) ; Send a message to the user
 N XMINSTR
 S ^TMP("XM",$J,1)="You have not read the following messages in over "_XMIDAYS_" days."
 I XMTEST D
 . S ^TMP("XM",$J,2)="If you don't need them, consider deleting them."
 . S ^TMP("XM",$J,3)="MailMan will not delete them."
 E  D
 . S ^TMP("XM",$J,2)="MailMan will delete them on "_XMDDATEX_" unless they become new"
 . S ^TMP("XM",$J,3)="or you read them or save them to another basket."
 S XMINSTR("FLAGS")="I"  ; Info only
 S XMINSTR("FROM")=.5
 D SENDMSG^XMXSEND(.5,$S(XMKALL:"Mailbox",1:"IN Basket")_" Maintenance","^TMP(""XM"",$J)",XMTO,.XMINSTR)
 Q
 ;
 ;#34006 = From
