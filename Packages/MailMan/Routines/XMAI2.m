XMAI2 ;(WASH ISC)/CAP/L.RHODE -Send a message if too many messages ;05/27/99  12:47
 ;;7.1;MailMan;**36,50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; ENTER   XMMGR-DISK-MANY-MESSAGE-MAINT
ENTER ;
 N XMMAX,XMSAVE,XMABORT,I
 S XMABORT=0
 D INIT(.XMMAX,.XMABORT) Q:XMABORT
 I $D(ZTQUEUED) D PROCESS Q
 F I="XMMAX" S XMSAVE(I)=""
 D EN^XUTMDEVQ("PROCESS^XMAI2","MailMan Many Msg Maint Request",.XMSAVE)
 Q
INIT(XMMAX,XMABORT) ;
 S XMMAX=500 ; Threshold number of messages a user can own
 Q:$D(ZTQUEUED)
 N DIR,Y,DIRUT
 W !!,"This option sends a message to every user who has more than"
 W !,XMMAX," messages in his or her mailbox, asking the user to"
 W !,"terminate unnecessary messages."
 W !!,"You may change the threshold if you wish."
 S DIR(0)="N^10::"
 S DIR("A")="Enter the 'many message' threshold"
 S DIR("B")=XMMAX
 S DIR("?")="How many messages may a user have before MailMan sends a nastygram?"
 D ^DIR I $D(DIRUT) S XMABORT=1 Q
 S XMMAX=Y
 W !!,"Messages will be sent to owners of more than ",XMMAX," messages."
 W !!,"This option may take awhile - you may wish to queue it."
 Q
PROCESS ; (Requires XMMAX)
 N XMUSER,XMCNT
 S XMUSER=.9999
 F  S XMUSER=$O(^XMB(3.7,XMUSER)) Q:XMUSER'>0  D
 . S XMCNT=$$TMSGCT^XMXUTIL(XMUSER)
 . D:XMCNT>XMMAX MESSAGE(XMUSER,XMCNT)
 S:$D(ZTQUEUED) ZTREQ="@"
 Q
MESSAGE(XMTO,XMCNT) ; Send message
 N XMTEXT,XMINSTR
 S XMINSTR("FROM")=.5
 S XMTEXT(1)="You have at least "_XMCNT_" messages in your mail baskets."
 S XMTEXT(2)="("_$$BMSGCT^XMXUTIL(XMTO,1)_" in your IN basket)"
 S XMTEXT(3)=""
 S XMTEXT(4)="Please terminate all of your unnecessary messages."
 S XMTEXT(5)=""
 S XMTEXT(6)="Thanks"
 D SENDMSG^XMXSEND(.5,"Please Terminate Messages","XMTEXT",XMTO,.XMINSTR)
 Q
