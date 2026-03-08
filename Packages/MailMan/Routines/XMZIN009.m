XMZIN009 ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2999)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(4.2999,9,3)
 ;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 99999999
 ;;^DD(4.2999,9,21,0)
 ;;=^^2^2^2851009^
 ;;^DD(4.2999,9,21,1,0)
 ;;=This is a count of the number of messages which have been received from this
 ;;^DD(4.2999,9,21,2,0)
 ;;=domain since the counter was last reset.
 ;;^DD(4.2999,9,21,3,0)
 ;;=Monthly Message Statistics area after each successful transmission.
 ;;^DD(4.2999,10,0)
 ;;=CHARACTERS SENT^NJ8,0^^3;9^K:+X'=X!(X>99999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,10,3)
 ;;=Type a Number between 0 and 99999999, 0 Decimal Digits
 ;;^DD(4.2999,10,21,0)
 ;;=0^^4^4^2900605^2900605^2900605
 ;;^DD(4.2999,10,21,0,0,99999999)
 ;;=^10^11^12^13^99999999
 ;;^DD(4.2999,10,21,1,0)
 ;;=Here is where the numbers of characters sent successfully are recorded for
 ;;^DD(4.2999,10,21,2,0)
 ;;=the particular transmission and particular message in transit.  This field
 ;;^DD(4.2999,10,21,3,0)
 ;;=is initialized (and the old contents are added to the monthly statistics
 ;;^DD(4.2999,10,21,4,0)
 ;;=in file 4.2999 (Message Statistics)) between messages.
 ;;^DD(4.2999,10,21,10,0)
 ;;=Here is where the numbers of characters sent successfully are recorded for
 ;;^DD(4.2999,10,21,11,0)
 ;;=the particular transmission and particular message in transit.  This field
 ;;^DD(4.2999,10,21,12,0)
 ;;=is initialized (and the old contents are added to the monthly statistics
 ;;^DD(4.2999,10,21,13,0)
 ;;=in file 4.2999 (Message Statistics)) between messages.
 ;;^DD(4.2999,10,23,0)
 ;;=0^^2^2^2900605^2900605^2900605
 ;;^DD(4.2999,10,23,0,0,99999999)
 ;;=^10^11^99999999
 ;;^DD(4.2999,10,23,0,"LE")
 ;;=3
 ;;^DD(4.2999,10,23,10,0)
 ;;=
 ;;^DD(4.2999,10,23,10,1)
 ;;=^^*
 ;;^DD(4.2999,10,23,11,0)
 ;;=
 ;;^DD(4.2999,10,"DT")
 ;;=2900605
 ;;^DD(4.2999,17,0)
 ;;=TOTAL MESSAGES RECEIVED^NJ7,0^^0;7^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,17,3)
 ;;=Type a Number between 0 and 9999999, 0 Decimal Digits
 ;;^DD(4.2999,17,21,0)
 ;;=^^1^1^2900530^
 ;;^DD(4.2999,17,21,1,0)
 ;;=This is a count of all the messages received at this domain.
 ;;^DD(4.2999,25,0)
 ;;=TRANSMISSION TASK#^NJ8,0^^3;7^K:+X'=X!(X>99999999)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,25,3)
 ;;=Type a Number between 1 and 99999999, 0 Decimal Digits
 ;;^DD(4.2999,25,21,0)
 ;;=^^2^2^2890922^^
 ;;^DD(4.2999,25,21,1,0)
 ;;=The transmission task# points to the TaskMan task that has been generated
 ;;^DD(4.2999,25,21,2,0)
 ;;=to handle delivery of messages to the domain in background.
 ;;^DD(4.2999,25,"DT")
 ;;=2890922
 ;;^DD(4.2999,41,0)
 ;;=XMIT START DATE/TIME^D^^4;1^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
 ;;^DD(4.2999,41,3)
 ;;=This is the date/time that the transmission process started.
 ;;^DD(4.2999,41,21,0)
 ;;=^^2^2^2960529^^
 ;;^DD(4.2999,41,21,1,0)
 ;;=This field helps MailMan determine, after a fatal error, whether to start the
 ;;^DD(4.2999,41,21,2,0)
 ;;=transmission process at script 1, try 1, or to start it elsewhere.
 ;;^DD(4.2999,41,"DT")
 ;;=2960529
 ;;^DD(4.2999,42,0)
 ;;=XMIT FINISH DATE/TIME^D^^4;2^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
 ;;^DD(4.2999,42,3)
 ;;=Date/time transmission process started/ended
 ;;^DD(4.2999,42,21,0)
 ;;=^^1^1^2960529^
 ;;^DD(4.2999,42,21,1,0)
 ;;=This may be useful information for debugging purposes.
 ;;^DD(4.2999,42,"DT")
 ;;=2960529
 ;;^DD(4.2999,43,0)
 ;;=XMIT SCRIPT^NJ3,0^^4;3^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,43,3)
 ;;=IEN (0-100) of TRANSMISSION SCRIPT (4.21) record within DOMAIN file (4.2)
 ;;^DD(4.2999,43,21,0)
 ;;=^^1^1^2960529^
 ;;^DD(4.2999,43,21,1,0)
 ;;=This tells MailMan which script is/was being used.
 ;;^DD(4.2999,43,"DT")
 ;;=2960529
 ;;^DD(4.2999,44,0)
 ;;=XMIT TRIES^NJ3,0^^4;4^K:+X'=X!(X>100)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,44,3)
 ;;=Type a Number between 0 and 100, 0 Decimal Digits
 ;;^DD(4.2999,44,21,0)
 ;;=^^1^1^2960529^
 ;;^DD(4.2999,44,21,1,0)
 ;;=This tells MailMan how many tries have been made with the current script.
 ;;^DD(4.2999,44,"DT")
 ;;=2960529
 ;;^DD(4.2999,45,0)
 ;;=XMIT LATEST TRY DATE/TIME^D^^4;5^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
 ;;^DD(4.2999,45,3)
 ;;=Enter date/time of latest transmission attempt
 ;;^DD(4.2999,45,21,0)
 ;;=^^1^1^2960529^
 ;;^DD(4.2999,45,21,1,0)
 ;;=This may be useful information for debugging purposes.
 ;;^DD(4.2999,45,"DT")
 ;;=2960529
 ;;^DD(4.2999,46,0)
 ;;=XMIT SCRIPT CYCLE ITERATIONS^NJ3,0^^4;6^K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,46,3)
 ;;=Type a Number between 0 and 999, 0 Decimal Digits
 ;;^DD(4.2999,46,21,0)
 ;;=^^2^2^2960809^^
 ;;^DD(4.2999,46,21,1,0)
 ;;=This is the number of script cycles we have tried.  This field starts off at 0.
