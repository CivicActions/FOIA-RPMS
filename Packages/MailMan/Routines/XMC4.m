XMC4 ;(WASH ISC)/THM-MISCELLANEOUS NETWORK MGT FUNCTIONS ;06/30/99  06:33
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; QUEUE    XMQSHOW
QUEUE ; Display messages in queue
 N DIC,Y,DIRUT
 I '$D(XMV("ORDER")) N XMV S XMV("ORDER")=1
 W !!,"This option lets you select only those queues which have messages."
 W !,"If you can't select a queue, it either doesn't exist or it has no messages.",!
 S DIC(0)="AEQM"
 S DIC="^DIC(4.2,"
 S DIC("A")="Enter domain name: "
 S DIC("?")="Select queue.  Only queues with messages are shown."
 S DIC("S")="I $O(^XMB(3.7,.5,2,Y+1000,1,0))"
 D ^DIC Q:Y'>0
 D LIST^XMJML(.5,Y+1000,$P(Y,U,2),"",1)
 Q
