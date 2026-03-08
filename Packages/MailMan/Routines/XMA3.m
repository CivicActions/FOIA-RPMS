XMA3 ;(WASH ISC)/CAP-XMCLEAN, XMAUTOPURGE ;02/16/99  12:44
 ;;7.1;MailMan;**37,54,69,50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; CLEAN      Option: XMCLEAN - Clean out waste baskets and
 ;                              Postmaster's ARRIVING basket
 ; EN         Option: XMAUTOPURGE - Purge Unreferenced Messages
 ; SCAN       Option: XMPURGE - Purge Unreferenced Messages, then STAT
 ; STAT       Option: XMSTAT  - Message Statistics
 Q
EN ;
 N XMPARM
 D PURGEIT(.XMPARM)
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
STAT ;
 D AUDIT^XMA30 ; Show purge audit records
 D USERSTAT^XMA30 ; Show user mailbox info
 Q
SCAN ; PURGE MESSAGES
 N DIR,XMPARM
 I $D(ZTQUEUED) D  Q
 . D PURGEIT(.XMPARM)
 . S ZTREQ="@"
 D AUDIT^XMA30 ; Show purge audit records
 S DIR(0)="E" D ^DIR Q:$D(DIRUT)  K DIR
 W !!,"I will purge messages which are not in anybody's Mailbox."
 W !,"This will be done by comparing the message numbers in the MESSAGE file (3.9)"
 W !,"against the 'M' cross reference of the MAILBOX file (3.7)."
 W !!,"Because this is a real-time dynamic cross reference, it is"
 W !,"RECOMMENDED that you run the INTEGRITY CHECKER with some"
 W !,"frequency, to CORRECT problems, if any."
 I '$P($G(^XMB(1,1,.12)),U) D
 . W !,"A Mailbox INTEGRITY CHECK will run before the PURGE."
 E  D
 . W !,"A Mailbox INTEGRITY CHECK will NOT run before the PURGE,"
 . W !,"because your site parameters indicate you do not want it to."
 . W !,"You may want to do a BACK-UP just before this runs, and revert"
 . W !,"to it if many problems are discovered."
 W !
 D GETPARMS(.XMPARM)
 S DIR("A")="Do you really want to purge all unreferenced messages"
 S DIR("B")="NO"
 S DIR(0)="Y"
 D ^DIR I Y=0!$D(DIRUT) Q
 D WAIT^DICD
 D PURGEIT(.XMPARM)
 K DIR S DIR(0)="E" D ^DIR Q:$D(DIRUT)  K DIR
 D STAT
 Q
PURGEIT(XMPARM) ;
 N XMKILL,XMIEN,XMCNT,XMCRE8
 D INIT(.XMIEN,.XMPARM,.XMKILL)
 D MPURGE(.XMCRE8,.XMPARM,.XMKILL,.XMCNT)
 D FINISH(XMIEN,XMCRE8,.XMKILL,.XMCNT)
 Q
INIT(XMIEN,XMPARM,XMKILL) ;
 D:'$D(XMPARM) GETPARMS(.XMPARM)
 D:'$P($G(^XMB(1,1,.12)),U) MAILBOX^XMUT4 ; Integrity check
 S (XMKILL("MSG"),XMKILL("RESP"))=0
 S XMKILL("START")=$P(^XMB(3.9,0),U,4)
 D AUDTPURG^XMA32 ; purge audit records
 D DONTPURG ; Note all messages which shouldn't be purged
 D INITAUDT^XMA32A(.XMIEN,.XMPARM)
 Q
GETPARMS(XMPARM) ;
 N XMSBUF,XMBUFREC
 S (XMPARM("TYPE"),XMPARM("START"))=0
 ; Set up a date buffer, beyond which we won't purge
 S XMBUFREC=$G(^XMB(1,1,.14))
 S XMPARM("END")=$$PDATE(+$P(XMBUFREC,U,1),2) ; purge thru this date
 S XMPARM("PDATE")=$$PDATE(+$P(XMBUFREC,U,2),7) ; don't purge local messages sent on or after this date to remote sites.
 ; If today is Saturday, start purge at beginning.
 ; If not Saturday, check MailMan Site Parameter file for field 4.304 ...
 I $$DOW^XLFDT(DT,1)'=6 D
 . S XMSBUF=+$P($G(^XMB(1,1,"NOTOPURGE")),U)
 . I XMSBUF=0,($G(^XMB("NETNAME"))="FORUM.VA.GOV"!$G(^XMB("NETNAME"))="FORUM.MED.VA.GOV") S XMSBUF=45
 . Q:XMSBUF=0
 . S XMPARM("START")=$$PDATE(XMSBUF,45)
 Q:$D(ZTQUEUED)
 W !,"Any unreferenced message will be purged if its local create date "
 W !,"is from ",$S(XMPARM("START")=0:"the beginning of time",1:$$MMDT^XMXUTIL1(XMPARM("START")))," to ",$$MMDT^XMXUTIL1(XMPARM("END"))," inclusive."
 W !,"However, locally generated messages sent to remote sites will not be purged"
 W !,"if they were sent on or after ",$$MMDT^XMXUTIL1(XMPARM("PDATE")),"."
 W !!,"The following messages are considered 'referenced' and will not be purged:"
 W !,"- Messages in users' baskets"
 W !,"- Messages in transit (arriving or being sent)"
 W !,"- Server messages"
 W !,"- Messages being edited (includes aborted edits)"
 W !,"- Later'd messages"
 Q
PDATE(XMDAYS,XMDEFALT) ; Subtract so many days from today and return that date.
 S:+XMDAYS=0 XMDAYS=XMDEFALT ; use default if days is null
 Q $$FMADD^XLFDT(DT,-XMDAYS)
FINISH(XMIEN,XMCRE8,XMKILL,XMCNT) ;
 K ^TMP("XM",$J)
 S XMKILL("TOTAL")=XMKILL("MSG")+XMKILL("RESP")
 W:'$D(ZTQUEUED) !!,XMCNT," messages processed, ",XMKILL("TOTAL")," messages purged, ",XMKILL("START")-XMKILL("TOTAL")," messages in ^XMB(3.9"
 D CHKAUDT^XMA32A(XMIEN,XMCRE8,.XMKILL)
 Q
DONTPURG ; Find all messages which might not be in someone's mailbox,
 ; but which shouldn't be purged anyway.
 N XMDUZ,XMZ,XMZR,XMQ,XMT,XMD,XMINST,XMG
 K ^TMP("XM",$J)
 ;
 ; DON'T PURGE LOCAL MESSAGES AND REPLIES WHICH ARE ABOUT TO BE DELIVERED
 ;
 S (XMT,XMG,XMZ)="" ; new messages, forwarded messages, and replies
 F  S XMT=$O(^XMBPOST("BOX",XMT)) Q:XMT=""  D
 . F  S XMG=$O(^XMBPOST("BOX",XMT,XMG)) Q:XMG=""  D
 . . F  S XMZ=$O(^XMBPOST("BOX",XMT,XMG,XMZ)) Q:XMZ=""  S ^TMP("XM",$J,"NOP",+XMZ)="" I XMG="R" S ^TMP("XM",$J,"NOP",$P(XMZ,U,2))=""
 ;
 ; new messages, forwarded messages
 S (XMQ,XMT,XMZ)="" ; Queue number, Timestamp, Message IEN
 F  S XMQ=$O(^XMBPOST("M",XMQ)) Q:XMQ=""  D
 . F  S XMT=$O(^XMBPOST("M",XMQ,XMT)) Q:XMT=""  D
 . . F  S XMZ=$O(^XMBPOST("M",XMQ,XMT,XMZ)) Q:XMZ=""  S ^TMP("XM",$J,"NOP",+XMZ)=""
 ;
 ; replies
 S (XMQ,XMZ,XMZR)="" ; Queue number, Message IEN, Reply IEN
 F  S XMQ=$O(^XMBPOST("R",XMQ)) Q:XMQ=""  D
 . S XMT="" ; Timestamp
 . F  S XMT=$O(^XMBPOST("R",XMQ,XMT)) Q:XMT'>0  D
 . . F  S XMZ=$O(^XMBPOST("R",XMQ,XMT,XMZ)) Q:XMZ=""  D
 . . . S ^TMP("XM",$J,"NOP",XMZ)="" ; Original msg to new replies
 . . . F  S XMZR=$O(^XMBPOST("R",XMQ,XMT,XMZ,XMZR)) Q:XMZR=""  S ^TMP("XM",$J,"NOP",XMZR)="" ; Reply
 ;
 ; DON'T PURGE MESSAGES QUEUED TO BE DELIVERED REMOTELY
 S XMINST=999 ; Institution
 F  S XMINST=$O(^XMB(3.7,.5,2,XMINST)) Q:XMINST'>0  D
 . S XMZ=0
 . F  S XMZ=$O(^XMB(3.7,.5,2,XMINST,1,XMZ)) Q:XMZ'>0  S ^TMP("XM",$J,"NOP",XMZ)=""
 ;
 ; DON'T PURGE LATER'D MESSAGES
 S XMD=0 ; Date to be later'd
 F  S XMD=$O(^XMB(3.73,XMD)) Q:XMD'>0  D
 . S XMZ=$P(^XMB(3.73,XMD,0),U,3)
 . S:XMZ ^TMP("XM",$J,"NOP",XMZ)="" ; Msg to be later'd
 ;
 ; DON'T PURGE MESSAGES WHICH ARE BEING EDITED
 S (XMDUZ,XMZ)=""
 F  S XMDUZ=$O(^XMB(3.7,"AD",XMDUZ)) Q:XMDUZ=""  D
 . F  S XMZ=$O(^XMB(3.7,"AD",XMDUZ,XMZ)) Q:XMZ=""  S ^TMP("XM",$J,"NOP",XMZ)=""
 ;
 ; DON'T PURGE MESSAGES WHICH ARE TO BE DELIVERED LATER TO CERTAIN RECIPIENTS
 S (XMD,XMZ)=""
 F  S XMD=$O(^XMB(3.9,"AL",XMD)) Q:XMD=""  D
 . F  S XMZ=$O(^XMB(3.9,"AL",XMD,XMZ)) Q:XMZ=""  S ^TMP("XM",$J,"NOP",XMZ)=""
 Q
MPURGE(XMCRE8,XMPARM,XMKILL,XMCNT) ;
 N XMZREC,XMZ
 S XMZ="",XMCNT=0
 S XMCRE8=$S(XMPARM("START")=0:0,1:$O(^XMB(3.9,"C",XMPARM("START")),-1))
 F  S XMCRE8=$O(^XMB(3.9,"C",XMCRE8)) Q:'XMCRE8  Q:XMCRE8>XMPARM("END")  D
 . F  S XMZ=$O(^XMB(3.9,"C",XMCRE8,XMZ)) Q:'XMZ  D
 . . I '$D(ZTQUEUED) S XMCNT=XMCNT+1 I XMCNT#5000=0 W:$X>40 ! W XMCNT,"."
 . . I '$D(^XMB(3.9,XMZ)) K ^XMB(3.9,"C",XMCRE8,XMZ) Q
 . . Q:$D(^XMB(3.7,"M",XMZ))        ; Msg is in someone's basket
 . . Q:$D(^TMP("XM",$J,"NOP",XMZ))  ; Msg is one of "do not purge"
 . . S XMZREC=$G(^XMB(3.9,XMZ,0))
 . . Q:$P(XMZREC,U,8)                  ; Msg is a response
 . . I $P($P(XMZREC,U,3),".")?7N,XMCRE8'<XMPARM("PDATE"),$O(^XMB(3.9,XMZ,1,"C",":"))'="" Q  ; local msg recently sent to remote site
 . . D PURGE(XMZ,.XMKILL)
 Q
PURGE(XMZ,XMKILL) ; Purge message and responses
 N XMZR,XMIEN
 S XMIEN=0
 F  S XMIEN=$O(^XMB(3.9,XMZ,3,XMIEN)) Q:XMIEN'>0  D
 . S XMZR=$P($G(^XMB(3.9,XMZ,3,XMIEN,0)),U) Q:'XMZR
 . D KILLRESP(XMZR,.XMKILL)
 D KILLMSG(XMZ,.XMKILL)
 Q
KILLRESP(XMZ,XMKILL) ; Kill response
 Q:'$D(^XMB(3.9,XMZ))      ; Response does not exist
 Q:$D(^XMB(3.7,"M",XMZ))   ; Someone has response in mailbox
 D KILLMSG^XMXUTIL(XMZ)
 S XMKILL("RESP")=XMKILL("RESP")+1
 Q
KILLMSG(XMZ,XMKILL) ; Kill message
 D KILLMSG^XMXUTIL(XMZ)
 S XMKILL("MSG")=XMKILL("MSG")+1
 Q
CLEAN ; Clean various files
 D CSTAT ; Clean Message Statistics file
 D CMBOX ; Clean out WASTE baskets and Postmaster's ARRIVING basket
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
CSTAT ; Clean Statistics file audits - delete records more than 2 years old
 N XMINST,XMAUDT,XMCUTOFF,DA,DIK
 S XMCUTOFF=DT\100-200   ; 2 years ago, in yyymm format
 S XMINST=0
 F  S XMINST=$O(^XMBS(4.2999,XMINST)) Q:XMINST'>0  D
 . S DA(1)=XMINST,DIK="^XMBS(4.2999,"_DA(1)_",100,"
 . S XMAUDT=0
 . F  S XMAUDT=$O(^XMBS(4.2999,XMINST,100,XMAUDT)) Q:XMAUDT'>0!(XMAUDT>XMCUTOFF)  D
 . . S DA=XMAUDT D ^DIK
 Q
CMBOX ; Clean the mailbox file
 N XMDUZ,XMCNT
 D CARRIVE
 S (XMDUZ,XMCNT)=0
 F  S XMDUZ=$O(^XMB(3.7,XMDUZ)) Q:XMDUZ'>0  D CWASTE(XMDUZ,.XMCNT)
 W:'$D(ZTQUEUED) !,"Waste & Arriving Baskets Cleaned!"
 Q
CWASTE(XMDUZ,XMCNT) ; Clean a user's WASTE basket
 N XMZ
 L +^XMB(3.7,XMDUZ):5  E  Q
 I '$D(ZTQUEUED) S XMCNT=XMCNT+1 I XMCNT#100=0 W:$X>60 ! W XMCNT,"."
 S XMZ=0
 F  S XMZ=$O(^XMB(3.7,XMDUZ,2,.5,1,XMZ)) Q:XMZ'>0  K ^XMB(3.7,"M",XMZ,XMDUZ,.5)
 K ^XMB(3.7,XMDUZ,2,.5)
 S ^XMB(3.7,XMDUZ,2,.5,0)="WASTE",^(1,0)="^3.702P^0^0"
 L -^XMB(3.7,XMDUZ)
 Q
CARRIVE ; Clean the postmaster's ARRIVING basket
 N XMZ,XMCNT,XMZLAST,XMDATE,XMPARM
 S XMPARM("END")=$$PDATE(+$P($G(^XMB(1,1,.14)),U,1),2)
 L +^XMB(3.7,.5):5 E  Q
 S (XMZ,XMCNT,XMZLAST)=0
 F  S XMZ=$O(^XMB(3.7,.5,2,.95,1,XMZ)) Q:XMZ'>0  D
 . I '$D(^XMB(3.9,XMZ,0)) D  Q
 . . S DA=XMZ,DA(1)=.95,DA(2)=.5,DIK="^XMB(3.7,.5,2,.95,1," D ^DIK
 . ; If it's still arriving, its date will be a FileMan date.
 . ; After it's finished arriving, its date will be an internet (text) date.
 . S XMDATE=$P($G(^XMB(3.9,XMZ,3)),U,3)
 . I XMDATE?7N1".".N,XMDATE'>XMPARM("END") D  Q  ; been arriving for over 24 hours
 . . S DA=XMZ,DA(1)=.95,DA(2)=.5,DIK="^XMB(3.7,.5,2,.95,1," D ^DIK
 . S XMCNT=XMCNT+1,XMZLAST=XMZ
 S ^XMB(3.7,.5,2,.95,0)="ARRIVING",^(1,0)="^3.702P^"_XMZLAST_U_XMCNT
 L -^XMB(3.7,.5)
 Q
