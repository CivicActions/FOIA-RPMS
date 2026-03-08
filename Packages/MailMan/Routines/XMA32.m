XMA32 ;(WASH ISC)/CAP-Purge Messages by Date ;06/09/99  13:59
 ;;7.1;MailMan;**37,50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; ENTRY   Option: XMPURGE-BY-DATE - Purge messages by local create date.
ENTRY ;
 N XMABORT,XMPARM
 S XMABORT=0
 D INIT(.XMPARM,.XMABORT) Q:XMABORT
 D SETUP(.XMPARM,.XMABORT) Q:XMABORT
 D PROCESS(.XMPARM)
 Q
INIT(XMPARM,XMABORT) ;
 I '$D(^XUSEC("XMMGR",DUZ)) D  Q
 . W !!,*7,"You may not run this option.  You do not hold the 'XMMGR' security key !"
 . S XMABORT=1
 I $G(^DD(3.7,0,"VR"))<7.1 D  Q
 . W !!,*7,"This routine only works with Kernel versions 7.1 or later.",!
 . S XMABORT=1
 S X="ERR^ZU" X ^%ZOSF("ETRP")
 W !!,"This process REMOVES MESSAGES PERMANENTLY from the system."
 W !,"             ***** BE VERY CAREFUL *****"
 I $D(^XMB(1,1,.1,0)) D LAST(.XMPARM)
 D AUDTPURG
 Q
LAST(XMPARM) ; Find the audit record for the last date purge
 N XMLIEN,XMREC,Y,XMDIFF
 S XMLIEN=$P(^XMB(1,1,.1,0),U,3)+1
 F  S XMLIEN=$O(^XMB(1,1,.1,XMLIEN),-1) Q:+XMLIEN=0  Q:$P(^(XMLIEN,0),U,6)
 Q:'XMLIEN
 S XMREC=^XMB(1,1,.1,XMLIEN,0)
 W !!,"This process was last run on ",$$MMDT^XMXUTIL1($P(XMREC,U)),$S($P(XMREC,U,6)["TEST":" in TEST MODE!",1:".")
 W !,"The PURGE DATE used was ",$$MMDT^XMXUTIL1($P(XMREC,U,7)),".",!
 S XMDIFF=$$FMDIFF^XLFDT($P(XMREC,U,7),$P(XMREC,U,1),1) ; difference in days
 S XMPARM("PDATE")=$$FMADD^XLFDT(DT,XMDIFF)
 Q
AUDTPURG ; Kill off the earliest purge entries, so that only a certain # remain.
 N XMREC,XMCNT,DA,DIK,XMMAX
 S XMMAX=20
 S XMREC=$G(^XMB(1,1,.1,0))
 S XMCNT=$P(XMREC,U,4)
 Q:XMCNT'>XMMAX
 S DA=0
 F  S DA=$O(^XMB(1,1,.1,0)) Q:DA'>0  D  Q:XMCNT'>XMMAX
 . S XMCNT=XMCNT-1
 . S DA(1)=1,DIK="^XMB(1,1,.1,"
 . D ^DIK
 Q
SETUP(XMPARM,XMABORT) ;
 D PDATE(.XMPARM,.XMABORT)    Q:XMABORT  ; Purge date
 D TESTMODE(.XMPARM,.XMABORT)            ; Test mode?
 Q
PDATE(XMPARM,XMABORT) ;
 N DIR,XMOK,XMOLDEST,XMDEF,XMOLDP1
 S XMOLDEST=$O(^XMB(3.9,"C",""))
 S XMOLDP1=$$FMADD^XLFDT(XMOLDEST,1)
 S XMDEF=$G(XMPARM("PDATE"),$$FMADD^XLFDT(DT,-730))
 I XMOLDP1>XMDEF S XMDEF=XMOLDP1
 S XMOK=0
 F  D  Q:XMOK!XMABORT
 . S DIR(0)="D^"_XMOLDP1_":DT:E"
 . S DIR("A",1)="The oldest message on the system is from "_$$FMTE^XLFDT(XMOLDEST,"2D")_"."
 . S DIR("A")="Purge all messages originating before"
 . S DIR("B")=$$FMTE^XLFDT(XMDEF,"2D")
 . S DIR("?",1)="All messages whose 'local create date' is prior to the"
 . S DIR("?",2)="'purge date' you enter will be deleted from the system,"
 . S DIR("?")="except those which are in one of SHARED,MAIL's baskets."
 . S DIR("??")="^N %DT S %DT=0 D HELP^%DTC"
 . D ^DIR I $D(DIRUT) S XMABORT=1 Q
 . S XMPARM("PDATE")=Y
 . I DT-Y>10000 S XMOK=1 Q
 . D ZIS^XM
 . W !!,$S($D(IORVON):IORVON,1:"")_$S($D(IOBON):IOBON,1:"")_"The date you entered is less than 1 year old !!",$S($D(IOBOFF):IOBOFF,1:""),$C(7),$S($D(IORVOFF):IORVOFF,1:"")
 . K DIR
 . S DIR(0)="Y"
 . S DIR("A")="Are you sure about this date"
 . S DIR("B")="No"
 . D ^DIR I $D(DIRUT) S XMABORT=1 Q
 . S XMOK=Y
 . K DIR
 Q
TESTMODE(XMPARM,XMABORT) ;
 N DIR
 S DIR(0)="Y",DIR("A")="TEST mode",DIR("B")="YES"
 S DIR("?",1)="Test mode will not kill off messages."
 S DIR("?",2)="Test mode gives you a list of what would happen in 'real' mode."
 S DIR("?",3)="If you do not run in test mode, messages will be KILLED!"
 S DIR("?",4)=""
 S DIR("?")="Enter 'yes' to run in 'test' mode; 'no', 'real' mode."
 D ^DIR I $D(DIRUT) S XMABORT=1 Q
 S XMPARM("TEST")=Y
 S XMPARM("TYPE")=$S(XMPARM("TEST"):2,1:1)
 Q
PROCESS(XMPARM) ;
 N ZTSAVE,ZTRTN,ZTDESC
 S ZTSAVE("XMPARM*")=""
 S ZTDESC="MailMan MESSAGE PURGE by DATE",ZTRTN="ENT^XMA32A"
 D EN^XUTMDEVQ(ZTRTN,ZTDESC,.ZTSAVE)
 Q
