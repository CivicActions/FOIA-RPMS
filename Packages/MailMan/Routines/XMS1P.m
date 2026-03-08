XMS1P ;(WASH ISC)/THM/CAP- XMPOLL Option ;8/14/93  12:45 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ;
 ;This option is SCHEDULED to run through TaskMan and it will
 ;go through a list of domains that have are on Poll lists and
 ;try to send messages to them.  If no messages are in the queue to
 ;be sent, the script will be 'played' and the TURN command executed
 ;to try to pull in messages waiting.
 ;
 ;Polling can be interupted in such a way as to not be effective if
 ;any errors occur that can stop a MUMPS process or cause it to be
 ;disconnected.
 ;
 ;FROM TASKMAN -- SCANNING DOMAINS WITH FLAG "P"
 ;
 S XMDUZ=.5,XMSCR=0,XMPOLL="NOREQUE"
P1 S XMSCR=$O(^DIC(4.2,"AC","P",XMSCR)) G KL1^XMC:XMSCR=""
 S XMB("XMSCR")=XMSCR,XMB("XMSCRN")=$P(^DIC(4.2,XMSCR,0),U),XMIO=$S($G(ZTIO)'="":ZTIO,1:$P(^(0),U,17)) G P1:XMIO=""
 F I=1:1 S IOP=XMIO D ^%ZIS Q:POP=0  G P1:I>30 H 60
 S ^XMBS(4.2999,XMSCR,3)="" K XMR0,XMTURN D ZTSK^XMS0
 G P1
