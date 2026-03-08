XMCD ;(WASH ISC)/THM-COMMUNICATIONS DIAGNOSTICS ;06/22/99  15:02
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Entry points used by MailMan options (not covered by DBIA):
 ; DIALER   XMDXMODEM
 ; SMTP     XMDXSMTP
 ; TRAN     XMDXSCRIPT
 ; VADATS   XMDXVADATS
 Q
VADATS ;VADATS DIAGNOSTIC
 ;W !,"This will test the VADATS link to see if it responds"
 ;I '$D(^XMB(1,1,0)) W !,*7,"No MailMan site parameters defined" Q
 ;S IO=$P(^(0),U,7) I IO="" W !,*7,"No VADATS device defined.  Use the SITE PARAMETERS option to define one." Q
 ;S IO=$P(^%ZIS(1,IO,0),U,1) W !,"Device ",IO," defined as the VADATS device."
 ;O IO:0 I $T W !,*7,"VADATS device is currently in use." Q  ;HARD CODED OPEN REQUIRED FOR COMMUNICATIONS
 ;W !,"Trying to open link to VADATS....."
 ;S IOP=IO D ^%ZIS Q:POP  S XMNCR=$C(13),XMNIME=30,XMNABT=0 U IO D NETSHAK^XMNET2 U IO(0)
 ;I XMNABT W !,*7,"Unable to open device." Q
 ;W !,"VADATS line OK" Q
DIALER ;TEST THE MODEM AUTODIALER
 W !!,"This will test the modem autodialer, allowing you to enter a phone number",!,"which this program will then dial on the selected modem.",!!
DIAL1 D ^%ZIS Q:POP  D D1^XMC3
 U IO(0) I XMMOD="" W !,*7,"This device has no modem defined for it." G DIAL1
 U IO(0) W !,^%ZIS(2,XMMOD,0)," is the defined modem for device ",IO
 I $L(XMSTAT) W !,"Checking status..." U IO X XMSTAT U IO(0) W " Status: ",Y
 I '$L(XMDIAL) W !,"No dialer logic specified for this modem type" G DIAL1
 I '$L(XMHANG) W !,"No hangup logic specified for this modem type",*7
PH R !,"Enter the phone number to dial ",XMPHONE:DTIME Q:XMPHONE=""!(XMPHONE[U)
 U IO X XMDIAL U IO(0) I ER W !,*7,"Call failed: ",Y G PH
 W !,"Successful.  Now hanging up...." U IO X XMHANG U IO(0)
 I ER W !,*7,"Hang up unsuccessful" G DIAL1
 W !,"Successfully hung up. " G DIAL1
SMTP ;SMTP TESTER
 W !!,"This procedure will test the Simple Mail Transfer Protocol,"
 W !,"allowing you to interactively enter each of the SMTP commands."
 W !,"The messages will not actually be delivered to the named recipients."
 W !,"That which you type will be preceded with an 'S: '.",!,"The SMTP responses will be preceded with an 'R: '",!!,"Terminate the session with a QUIT command",!!
 S XMRDX=1 D TST^XMR K XMRDX Q
TRAN ;TEST TRANSMISSION ERROR RATES, SPEEDS
 N XMSECURE,%X,%Y
 W !!,"This will test a link by executing the script, then sending 20 lines"
 W !,"in echo test mode.  It will report the number of recoverable and "
 W !,"unrecoverable errors, as well as the transmission efficiency."
 D LOADCODE^XMJMCODE
 S %X="XMSECURE(",%Y="^TMP(""XMS"",$J,""S""," D %XY^%RCR
 K XMSECURE
 S XMST=1
 D GO^XMC11
 K XMST
 Q
