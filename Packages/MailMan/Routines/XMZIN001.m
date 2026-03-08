XMZIN001 ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(4.2,0,"GL")
 ;;=^DIC(4.2,
 ;;^DIC("B","DOMAIN",4.2)
 ;;=
 ;;^DIC(4.2,"%D",0)
 ;;=^^19^19^2880415^^^^
 ;;^DIC(4.2,"%D",1,0)
 ;;=This file is used to name all of the nodes to which MailMan messages
 ;;^DIC(4.2,"%D",2,0)
 ;;=may be routed.  Each name in this file corresponds to the right side
 ;;^DIC(4.2,"%D",3,0)
 ;;=of a MailMan address-the part following the "@".
 ;;^DIC(4.2,"%D",4,0)
 ;;= 
 ;;^DIC(4.2,"%D",5,0)
 ;;=Domains may have synonyms, allowing users to name sites with one name,
 ;;^DIC(4.2,"%D",6,0)
 ;;=while MailMan uses the more formal Domain Naming conventions.
 ;;^DIC(4.2,"%D",7,0)
 ;;= 
 ;;^DIC(4.2,"%D",8,0)
 ;;=This file also controls whether messages are queued for immediate transmission
 ;;^DIC(4.2,"%D",9,0)
 ;;=and into what queue they are dropped.  Any domain may have a relay domain,
 ;;^DIC(4.2,"%D",10,0)
 ;;=which controls the routing as follows:
 ;;^DIC(4.2,"%D",11,0)
 ;;= 
 ;;^DIC(4.2,"%D",12,0)
 ;;=If a domain has a named relay domain, the message is put in the queue for
 ;;^DIC(4.2,"%D",13,0)
 ;;=the relay domain.
 ;;^DIC(4.2,"%D",14,0)
 ;;= 
 ;;^DIC(4.2,"%D",15,0)
 ;;=If not, and the domain has a TRANSMISSION SCRIPT, then the message is put
 ;;^DIC(4.2,"%D",16,0)
 ;;=in the queue for that domain.
 ;;^DIC(4.2,"%D",17,0)
 ;;= 
 ;;^DIC(4.2,"%D",18,0)
 ;;=Otherwise, the message is put in the queue for the Parent domain, as defined
 ;;^DIC(4.2,"%D",19,0)
 ;;=at MailMan initialization time.
 ;;^DD(4.2,0)
 ;;=FIELD^^50^24
 ;;^DD(4.2,0,"DDA")
 ;;=Y
 ;;^DD(4.2,0,"DT")
 ;;=2940602
 ;;^DD(4.2,0,"IX","AB",4.24,.01)
 ;;=
 ;;^DD(4.2,0,"IX","AC",4.2,1)
 ;;=
 ;;^DD(4.2,0,"IX","AD",4.2,6.2)
 ;;=
 ;;^DD(4.2,0,"IX","AE",4.2,50)
 ;;=
 ;;^DD(4.2,0,"IX","ATCP",4.2,6.61)
 ;;=
 ;;^DD(4.2,0,"IX","B",4.2,.01)
 ;;=
 ;;^DD(4.2,0,"IX","C",4.23,.01)
 ;;=
 ;;^DD(4.2,0,"IX","D",4.2,6.61)
 ;;=
 ;;^DD(4.2,0,"NM","DOMAIN")
 ;;=
 ;;^DD(4.2,0,"PT",3.8161,.01)
 ;;=
 ;;^DD(4.2,0,"PT",3.91,6)
 ;;=
 ;;^DD(4.2,0,"PT",4,60)
 ;;=
 ;;^DD(4.2,0,"PT",4.2,2)
 ;;=
 ;;^DD(4.2,0,"PT",4.2999,.01)
 ;;=
 ;;^DD(4.2,0,"PT",4.3,.01)
 ;;=
 ;;^DD(4.2,0,"PT",4.3,3)
 ;;=
 ;;^DD(4.2,0,"PT",4.31,.01)
 ;;=
 ;;^DD(4.2,0,"PT",8989.3,.01)
 ;;=
 ;;^DD(4.2,.01,0)
 ;;=NAME^RFX^^0;1^D CHDOM^XM
 ;;^DD(4.2,.01,.1)
 ;;=The exact name of the domain, as used in network addressing
 ;;^DD(4.2,.01,1,0)
 ;;=^.1
 ;;^DD(4.2,.01,1,1,0)
 ;;=4.2^B
 ;;^DD(4.2,.01,1,1,1)
 ;;=S ^DIC(4.2,"B",$E(X,1,30),DA)=""
 ;;^DD(4.2,.01,1,1,2)
 ;;=K ^DIC(4.2,"B",$E(X,1,30),DA)
 ;;^DD(4.2,.01,3)
 ;;=
 ;;^DD(4.2,.01,4)
 ;;=
 ;;^DD(4.2,.01,21,0)
 ;;=^^8^8^2930503^^^^
 ;;^DD(4.2,.01,21,1,0)
 ;;=This name is the exact name of the domain, as used in network addressing
 ;;^DD(4.2,.01,21,2,0)
 ;;=It consists of "." (dot) pieces that are formed hierarchically starting at
 ;;^DD(4.2,.01,21,3,0)
 ;;=the right.  Domains with dot pieces to the left are administered by the
 ;;^DD(4.2,.01,21,4,0)
 ;;=domain whose domain name consists of its name less the 1st dot piece.
 ;;^DD(4.2,.01,21,5,0)
 ;;=For example:  A.DOMAIN.COM is administered by DOMAIN.COM.
 ;;^DD(4.2,.01,21,6,0)
 ;;= 
 ;;^DD(4.2,.01,21,7,0)
 ;;=Each dot piece must begin with an alpha, then be followed by only alpha,
 ;;^DD(4.2,.01,21,8,0)
 ;;=numeric, or "-" characters, for a total less than 13 characters.
 ;;^DD(4.2,.01,"DT")
 ;;=2930208
 ;;^DD(4.2,1,0)
 ;;=FLAGS^F^^0;2^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>10!($L(X)<1) X
 ;;^DD(4.2,1,1,0)
 ;;=^.1
 ;;^DD(4.2,1,1,1,0)
 ;;=4.2^AC^MUMPS
 ;;^DD(4.2,1,1,1,1)
 ;;=I X["P" S ^DIC(4.2,"AC","P",DA)=""
 ;;^DD(4.2,1,1,1,2)
 ;;=K ^DIC(4.2,"AC","P",DA)
 ;;^DD(4.2,1,1,1,"%D",0)
 ;;=^^2^2^2931212^
 ;;^DD(4.2,1,1,1,"%D",1,0)
 ;;=This cross reference keeps track of domains that have the polling
 ;;^DD(4.2,1,1,1,"%D",2,0)
 ;;=flag on.
 ;;^DD(4.2,1,3)
 ;;=C=CLOSED, S=SEND, Q=QUEUE, N=NO-FORWARD, P=POLL, T=TALKMAN ENABLED
 ;;^DD(4.2,1,21,0)
 ;;=19^^19^19^2890525^^^^
 ;;^DD(4.2,1,21,1,0)
 ;;=The flags field controls the flow of messages to this domain from the
 ;;^DD(4.2,1,21,2,0)
 ;;=local node.  Flags are:
 ;;^DD(4.2,1,21,3,0)
 ;;= 
 ;;^DD(4.2,1,21,4,0)
 ;;=S = Send.  MailMan should start a Task Manager task to transmit the message
 ;;^DD(4.2,1,21,5,0)
 ;;=    as soon as the message is received.
 ;;^DD(4.2,1,21,6,0)
 ;;= 
 ;;^DD(4.2,1,21,7,0)
 ;;=C = Close.  MailMan will not allow users to address mail to this domain.
 ;;^DD(4.2,1,21,8,0)
 ;;= 
 ;;^DD(4.2,1,21,9,0)
 ;;=Q or "" (the null string) = Queue.  MailMan will not deliver until a task
 ;;^DD(4.2,1,21,10,0)
 ;;=    is explicitely created to deliver the mail.
 ;;^DD(4.2,1,21,11,0)
 ;;= 
 ;;^DD(4.2,1,21,12,0)
 ;;=P = Poll.  A taskmanager task will poll all domains with this flag.
