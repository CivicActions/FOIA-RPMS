XMCTRAP ;(WASH ISC)/THM/CAP-ERROR TRAP ;08/05/96  10:06
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;**20,27**;Jun 02, 1994
 ;Modified for TCP/IP under INET_SERVERS of Wollongong
 ;
C ;set in XMC1
 N XMCTRAP S XMCTRAP=1
R ;set in XMRUCX
TRP N %,%E,X S (%,X)=""
 S %E=$$EC^%ZOSV()
 I '$$SCREEN^%ZTER(%E) D ^%ZTER
 ;Error Trap for Script processing (remove back-up tasks)...
 I $G(ZTQUEUED),$G(XMCTRAP) D REQ^XMS0
 ;I $D(XMHANG),$L(XMHANG) X XMHANG
 ;D:IO'=IO(0) ^%ZISC
 S ER=1 G UNWIND^%ZTER
