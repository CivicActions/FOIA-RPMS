XMZIN003 ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(4.2,4,23,10,0)
 ;;=the message, it is assumed that the parent of this system does know.
 ;;^DD(4.2,4,23,11,0)
 ;;=Therefore, if a domain has no data at all in the Transmission Script field,
 ;;^DD(4.2,4,23,12,0)
 ;;=MailMan routes messages sent to it to the local domain's parent.
 ;;^DD(4.2,4,23,13,0)
 ;;=This often occurs with subdomains.    No protection exists to
 ;;^DD(4.2,4,23,14,0)
 ;;=prevent infinite loops of transmissions that can occur when the
 ;;^DD(4.2,4,23,15,0)
 ;;=parent has no entry for the subdomain and therefore implicitely assumes
 ;;^DD(4.2,4,23,16,0)
 ;;=that it should route the message to the subdomain's creator.  Other problems
 ;;^DD(4.2,4,23,17,0)
 ;;=that do not cause systems to be misued have can still occur, also.
 ;;^DD(4.2,4.2,0)
 ;;=NOTES^4.25^^5;0
 ;;^DD(4.2,4.2,21,0)
 ;;=^^2^2^2931214^^
 ;;^DD(4.2,4.2,21,1,0)
 ;;=NETWORK NOTES should be used to document indiosyncracies that occur when
 ;;^DD(4.2,4.2,21,2,0)
 ;;=communicating with the domain in question.
 ;;^DD(4.2,5,0)
 ;;=SYNONYM^4.23^^2;0
 ;;^DD(4.2,5,21,0)
 ;;=^^1^1^2851009^^
 ;;^DD(4.2,5,21,1,0)
 ;;=Other names by which this domain is known.
 ;;^DD(4.2,5.5,0)
 ;;=STATION^F^^0;13^K:$L(X)>7!($L(X)<3)!'(X?3N.E) X
 ;;^DD(4.2,5.5,3)
 ;;=ANSWER MUST BE 3-7 CHARACTERS IN LENGTH
 ;;^DD(4.2,5.5,21,0)
 ;;=^^1^1^2881107^
 ;;^DD(4.2,5.5,21,1,0)
 ;;=This is the domain's station.
 ;;^DD(4.2,5.5,"DT")
 ;;=2860423
 ;;^DD(4.2,6,0)
 ;;=MCTS ROUTING INDICATOR^F^^0;4^K:$L(X)>3!($L(X)<3)!'(X?3U) X
 ;;^DD(4.2,6,3)
 ;;=Must be three upper case letters
 ;;^DD(4.2,6,21,0)
 ;;=^^2^2^2860619^^^
 ;;^DD(4.2,6,21,1,0)
 ;;=This is a three character routing indicator for the VADATS network's
 ;;^DD(4.2,6,21,2,0)
 ;;=MCTS terminal system.
 ;;^DD(4.2,6,21,3,0)
 ;;=statistics reflect the messages as they are actually transmitted, not
 ;;^DD(4.2,6,21,4,0)
 ;;=as they are addressed.
 ;;^DD(4.2,6,"DT")
 ;;=2850320
 ;;^DD(4.2,6.2,0)
 ;;=DHCP ROUTING INDICATOR^F^^0;14^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>3!($L(X)<3) X
 ;;^DD(4.2,6.2,1,0)
 ;;=^.1
 ;;^DD(4.2,6.2,1,1,0)
 ;;=4.2^AD
 ;;^DD(4.2,6.2,1,1,1)
 ;;=S ^DIC(4.2,"AD",$E(X,1,30),DA)=""
 ;;^DD(4.2,6.2,1,1,2)
 ;;=K ^DIC(4.2,"AD",$E(X,1,30),DA)
 ;;^DD(4.2,6.2,3)
 ;;=ANSWER MUST BE 3 CHARACTERS IN LENGTH
 ;;^DD(4.2,6.2,21,0)
 ;;=^^2^2^2931214^
 ;;^DD(4.2,6.2,21,1,0)
 ;;=This field is used to route messages when they arrive at the
 ;;^DD(4.2,6.2,21,2,0)
 ;;=central data collection point at the domain FOC-AUSTIN.VA.GOV.
 ;;^DD(4.2,6.2,"DT")
 ;;=2900710
 ;;^DD(4.2,6.5,0)
 ;;=MAILMAN HOST^F^^0;12^K:$L(X)>20!($L(X)<2) X
 ;;^DD(4.2,6.5,3)
 ;;=Answer must be 2-20 characters in length.
 ;;^DD(4.2,6.5,21,0)
 ;;=^^2^2^2931214^
 ;;^DD(4.2,6.5,21,1,0)
 ;;=This field contains a logical or physical address of a remote domain
 ;;^DD(4.2,6.5,21,2,0)
 ;;=so that a connection can occur.
 ;;^DD(4.2,6.5,"DT")
 ;;=2940602
 ;;^DD(4.2,6.6,0)
 ;;=FTP BLOB IP ADDRESS^F^^IP;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>15!($L(X)<7)!'(X?1.N1"."1.N1"."1.N1"."1.N) X
 ;;^DD(4.2,6.6,1,0)
 ;;=^.1^^0
 ;;^DD(4.2,6.6,3)
 ;;=Enter a valid IP address in the form:  nn.nn.nn.nn
 ;;^DD(4.2,6.6,21,0)
 ;;=^^2^2^2931214^
 ;;^DD(4.2,6.6,21,1,0)
 ;;=This field contains the IP address of this host so that it can be
 ;;^DD(4.2,6.6,21,2,0)
 ;;=used as the to address for files that will be sent to this domain.
 ;;^DD(4.2,6.6,"DT")
 ;;=2930219
 ;;^DD(4.2,6.61,0)
 ;;=TCP/IP POLL FLAG^S^0:DO NOT POLL;1:POLL;^P;1^Q
 ;;^DD(4.2,6.61,1,0)
 ;;=^.1
 ;;^DD(4.2,6.61,1,1,0)
 ;;=4.2^D
 ;;^DD(4.2,6.61,1,1,1)
 ;;=S ^DIC(4.2,"D",$E(X,1,30),DA)=""
 ;;^DD(4.2,6.61,1,1,2)
 ;;=K ^DIC(4.2,"D",$E(X,1,30),DA)
 ;;^DD(4.2,6.61,1,1,3)
 ;;=If this cross reference is deleted, netmail may not be transmitted.
 ;;^DD(4.2,6.61,1,1,"DT")
 ;;=2920611
 ;;^DD(4.2,6.61,1,2,0)
 ;;=4.2^ATCP
 ;;^DD(4.2,6.61,1,2,1)
 ;;=S ^DIC(4.2,"ATCP",$E(X,1,30),DA)=""
 ;;^DD(4.2,6.61,1,2,2)
 ;;=K ^DIC(4.2,"ATCP",$E(X,1,30),DA)
 ;;^DD(4.2,6.61,1,2,"%D",0)
 ;;=^^3^3^2920706^
 ;;^DD(4.2,6.61,1,2,"%D",1,0)
 ;;=This cross reference is used by XMRTCP to poll domains that have messages
 ;;^DD(4.2,6.61,1,2,"%D",2,0)
 ;;=to be sent out.  TaskMan does not run on the node that has the TCP/IP
 ;;^DD(4.2,6.61,1,2,"%D",3,0)
 ;;=device sometimes.
 ;;^DD(4.2,6.61,1,2,"DT")
 ;;=2920706
 ;;^DD(4.2,6.61,21,0)
 ;;=^^3^3^2930612^
 ;;^DD(4.2,6.61,21,1,0)
 ;;=This is the information needed to log in the FTP service of this site
 ;;^DD(4.2,6.61,21,2,0)
 ;;=if the standard route needs to be overridden.
 ;;^DD(4.2,6.61,21,3,0)
 ;;=.
 ;;^DD(4.2,6.61,"DT")
 ;;=2920706
 ;;^DD(4.2,6.62,0)
 ;;=FTP^FX^^3;1^K:$L(X)>61!($L(X)<7) X I X'?2.E1";"2.E K X
