XMR3 ;(WASH ISC)/THM-SMTP HELP PROCESSOR ; 12/4/87  2:05 PM ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
ALL F XMP="RSET","TURN","VRFY","EXPN","HELP","NOOP","QUIT" D H3
 G H4
H2 D H3,H4 Q
H3 Q:$T(@XMP)=""  F J=0:1 S XMSG="214-"_$P($T(@XMP+J),";",3,99) Q:$L(XMSG)=4  X XMSEN Q:ER
 Q
H4 S XMSG="214 " X XMSEN Q
 Q
DATA ;; 
 ;;The DATA command is used after the MAIL and RCPT commands to transmit
 ;;the body of the message.  The command has no arguments.  The receiver's
 ;;response to the command is to either issue an error message:
 ;;"503 no recipients specified" or "354 Start mail input".
 ;; 
 ;;Data will be accepted until a line consisting of a single period is
 ;;detected.  If any line begins with a period, it must have an
 ;;additional period inserted at the beginning of the line.
 ;; 
 ;;After the DATA command is completed, the receiver will respond with
 ;;"250 OK" if the message was accepted, or an error message if 
 ;;otherwise.
 ;;
RSET ;; 
 ;;The RSET (Reset) command is used to reset the receiver to its initial
 ;;state and cancel any mail in progress.  The sender does not need to
 ;;issue HELO again.
 ;;
VRFY ;; 
 ;;The VRFY (Verify) command is used to verify the existence of a user
 ;;at the receiver.  The format is:
 ;; 
 ;;   VRFY <user>
 ;;  
 ;;The computer will respond with the user's full name if found, or
 ;;"550 User not found" if not.  This command can be issued at any 
 ;;time, and does not affect the recipient list.
 ;;
EXPN ;; 
 ;;The EXPN (Expand) command causes the receiver to expand a mailing
 ;;list, showing the sender the list of individuals in the list.
 ;;
HELP ;;
 ;;The HELP command displays user assistance information for interactive
 ;;users.  If issued without an argument, it gives a general introduction.
 ;;If given an argument naming a command, it gives further information
 ;;on that command.  If given an argument of "ALL", it displays 
 ;;help on all arguments.
 ;;
NOOP ;; 
 ;;The NOOP (no operation) command causes the receiver to respond with
 ;;a "250 OK" message.
 ;;
QUIT ;; 
 ;;The QUIT command is used to terminate the mail transfer process.
 ;;The connection will be closed, and any mail transfers not concluded
 ;;with a successful DATA command will be lost.
 ;;
TURN ;;  
