XMF1 ;(WASH ISC)/THM/CAP-EXAMPLE SERVER ; 5/12/88  12:00 PM ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ;;This is just an example of how a server should work.
 ;;
 ;;It is important that servers do not assume they can
 ;;directly access the text of a message.  Instead they
 ;;should use the call to REC^XMS3.
 ;;
 ;;It is important that servers are fully compatible with standards.  It
 ;;is not the server's function to understand MailMan...
 ;;
 ;;The server will be initialized with the message # of the message
 ;;to be processed in the variable XMZ.  XMPOS is the node being
 ;;processed.  XMREC is the value of the text at that node.
 ;;
 ;;Since this is a test server in MailMan, XM* variables are used.
 ;;Non-MailMan servers should not change the value of any XM variables.
 ;;
 S XMA=0 ;                                Set local counter
 ;
 ;Begin main loop
 ;
A X XMREC ;                                Receive a line
 I $D(XMER) G Q:XMER<0 ;                         Check for end of message.
 S XMA=XMA+1 ;                            Increment local counter.
 S XMTXT(XMA)=XMRG ;                      Set local array
 G A ;                                    Go back for another
 ;
 ;FINISH UP
 ;
Q ;Set up for call to MailMan programmer interface
 S XMTEXT="XMTXT(",^TMP("XMY",$J,.5)=""
 S XMTXT(XMA+1)=" "
 S XMTXT(XMA+2)="This message arrived through a server routine."
 ;
 ;Call MailMan programmer interface
 D ^XMD
 QUIT
