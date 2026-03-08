XMR2 ;(WASH ISC)/THM-SMTP HELP PROCESSOR ;02/11/98  10:04
 ;;7.1;MailMan;**50**;Jun 02, 1994
HELP ;
 S:XMP="" XMP="HHHH" G:$L(XMP)=4&("HHHH HELO MAIL RCPT"'[XMP) H2^XMR3
 I $L(XMP)=4 D H3 G H4
 G:XMP'="ALL" HE F XMP="HHHH","HELO","MAIL","RCPT" D H3
 G ALL^XMR3
H3 Q:$T(@XMP)=""  F J=0:1 S XMSG="214-"_$P($T(@XMP+J),";",3,99) Q:$L(XMSG)=4  X XMSEN Q:ER
 Q
H4 S XMSG="214 " X XMSEN Q
 Q
HE S XMP="HHHH" G HELP
HHHH ;; 
 ;;This is the simple mail transfer protocol receiver
 ;;Commands currently understood are: 
 ;;HELO <domain> (which initiates a transaction)
 ;;MAIL FROM: <reverse-path>
 ;;RCPT TO: <forward-path>  (which names a recipient)
 ;;DATA (terminated with a single line of '.')
 ;;HELP (which displays this text)
 ;;NOOP (which does nothing)
 ;;RSET <reason for> which stops transmission of message
 ;;STAT (which displays the current status of the receiver)
 ;;VRFY <user> (which verifies the existence of a user)
 ;;TURN (Which turns around the line; Sender becomes receiver)
 ;;EXPN <mail group> (which lists the members of a group)
 ;;QUIT (which terminates the connection)
 ;; 
 ;;CHRS <domain> initialize a remote domain
 ;;Extensions:
 ;;MESS ID:XMREMID Sending message remote ID to allow processing to stop
 ;; 
 ;;Enter HELP ALL to see further discussion on all commands, or
 ;;HELP <command> to see further discussion of <command>.
 ;;
HELO ;; 
 ;;The HELO command is used to identify the sending host to the receiver:
 ;; 
 ;;   HELO <domain>
 ;; 
 ;; Where <domain> is the name of the sending host.
 ;; 
 ;;If the receiver will accept mail, it responds with its name.
 ;; 
 ;;The HELO command must be the first command of a mail sequence.
 ;;
MAIL ;; 
 ;;The MAIL command is used after a HELO command to ask a receiver to
 ;;accept a mail message.  The format is:
 ;; 
 ;;  MAIL FROM: <user>@<site>
 ;; 
 ;;where <user> is the name of the user sending the message, and <site>
 ;;is the name of the site sending the mail, in Internet domain
 ;;format.
 ;;
 ;;The receiver will respond with "250 OK" if accepted, and "501 Invalid
 ;;Reverse path specification" if not.
 ;; 
 ;;This command is followed with RCPT and DATA commands to name
 ;;and transfer the data, respectively.
 ;;
RCPT ;; 
 ;;This command is used to identify the recipients of the mail.
 ;;Its format is:
 ;; 
 ;;   RCPT TO: <user>
 ;; 
 ;;If the user is found, the receiver will respond with "250 OK";
 ;;Otherwise, it will say "501 Invalid forward path specification".
 ;; 
 ;;Each recipient of the message is named individually.  The VRFY
 ;;command can be used to confirm the existence of a user without
 ;;actually putting him on the recipient list. 
 ;;After recipients are specified, the DATA command is used to transfer
 ;;the body of the message.
 ;;
