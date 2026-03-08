XMZIN00A ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2999)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(4.2999,46,21,2,0)
 ;;=After we have tried all the scripts available, we bump up this field by 1.
 ;;^DD(4.2999,46,"DT")
 ;;=2960809
 ;;^DD(4.2999,47,0)
 ;;=XMIT FIRST SCRIPT^NJ3,0^^4;7^K:+X'=X!(X>100)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,47,3)
 ;;=Type a Number between 1 and 100, 0 Decimal Digits
 ;;^DD(4.2999,47,21,0)
 ;;=^^2^2^2960809^
 ;;^DD(4.2999,47,21,1,0)
 ;;=This field notes which script has the highest priority, that is, which script
 ;;^DD(4.2999,47,21,2,0)
 ;;=was tried first.
 ;;^DD(4.2999,47,"DT")
 ;;=2960809
 ;;^DD(4.2999,51,0)
 ;;=XMIT SCRIPT RECORD^F^^5;E1,245^K:$L(X)>245!($L(X)<10) X
 ;;^DD(4.2999,51,3)
 ;;=Answer must be 10-245 characters in length.
 ;;^DD(4.2999,51,21,0)
 ;;=^^1^1^2960529^
 ;;^DD(4.2999,51,21,1,0)
 ;;=This is a copy of the zeronode of the latest script used.
 ;;^DD(4.2999,51,"DT")
 ;;=2960529
 ;;^DD(4.2999,60,0)
 ;;=XMIT AUDIT^4.29992D^^6;0
 ;;^DD(4.2999,60,21,0)
 ;;=^^2^2^2960614^^
 ;;^DD(4.2999,60,21,1,0)
 ;;=This multiple contains an audit of the attempts that have been made during
 ;;^DD(4.2999,60,21,2,0)
 ;;=this transmission.
 ;;^DD(4.2999,101,0)
 ;;=MESSAGE STATISTICS MONTH^4.29991D^^100;0
 ;;^DD(4.2999,101,21,0)
 ;;=^^3^3^2931214^^
 ;;^DD(4.2999,101,21,1,0)
 ;;=Message statistics are summed into this area at the end of each successful
 ;;^DD(4.2999,101,21,2,0)
 ;;=message received or sent into the appropriate month according to the time
 ;;^DD(4.2999,101,21,3,0)
 ;;=the message is received.
 ;;^DD(4.29991,0)
 ;;=MESSAGE STATISTICS MONTH SUB-FIELD^^107^7
 ;;^DD(4.29991,0,"IX","B",4.29991,.01)
 ;;=
 ;;^DD(4.29991,0,"NM","MESSAGE STATISTICS MONTH")
 ;;=
 ;;^DD(4.29991,0,"UP")
 ;;=4.2999
 ;;^DD(4.29991,.01,0)
 ;;=MESSAGE STATISTICS MONTH^D^^0;1^S %DT="E" D ^%DT S X=Y K:Y<1 X
 ;;^DD(4.29991,.01,1,0)
 ;;=^.1
 ;;^DD(4.29991,.01,1,1,0)
 ;;=4.29991^B
 ;;^DD(4.29991,.01,1,1,1)
 ;;=S ^XMBS(4.2999,DA(1),100,"B",$E(X,1,30),DA)=""
 ;;^DD(4.29991,.01,1,1,2)
 ;;=K ^XMBS(4.2999,DA(1),100,"B",$E(X,1,30),DA)
 ;;^DD(4.29991,.01,21,0)
 ;;=^^3^3^2931214^
 ;;^DD(4.29991,.01,21,1,0)
 ;;=Message statistics are summed into this area at the end of each successful
 ;;^DD(4.29991,.01,21,2,0)
 ;;=message received or sent into the appropriate month according to the time
 ;;^DD(4.29991,.01,21,3,0)
 ;;=the message is received.
 ;;^DD(4.29991,102,0)
 ;;=MESSAGES SENT^NJ7,0^^0;2^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.29991,102,3)
 ;;=Type a Number between 0 and 9999999, 0 Decimal Digits
 ;;^DD(4.29991,102,21,0)
 ;;=^^3^3^2900530^
 ;;^DD(4.29991,102,21,1,0)
 ;;=This is the number of messagaes that were transmitted to this domain.
 ;;^DD(4.29991,102,21,2,0)
 ;;=Previously transmitted (but forwarded to new recipients) message and
 ;;^DD(4.29991,102,21,3,0)
 ;;=responses are included as though they were separate messages.
 ;;^DD(4.29991,103,0)
 ;;=MESSAGES RECEIVED^NJ7,0^^0;3^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.29991,103,3)
 ;;=Type a Number between 0 and 9999999, 0 Decimal Digits
 ;;^DD(4.29991,103,21,0)
 ;;=^^3^3^2900530^
 ;;^DD(4.29991,103,21,1,0)
 ;;=Messages received are inlcuded here even if they are received only to be
 ;;^DD(4.29991,103,21,2,0)
 ;;=forwarded on to another site.  Also included are responses and messages
 ;;^DD(4.29991,103,21,3,0)
 ;;=received previously (as long as they have additional recipients).
 ;;^DD(4.29991,104,0)
 ;;=CHARACTERS SENT^NJ7,0^^0;4^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.29991,104,3)
 ;;=Type a Number between 0 and 9999999, 0 Decimal Digits
 ;;^DD(4.29991,104,21,0)
 ;;=^^1^1^2900530^^
 ;;^DD(4.29991,104,21,1,0)
 ;;=This is a count of the number of characters in the messages sent.
 ;;^DD(4.29991,105,0)
 ;;=CHARACTERS RECEIVED^NJ7,0^^0;5^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.29991,105,3)
 ;;=Type a Number between 0 and 9999999, 0 Decimal Digits
 ;;^DD(4.29991,105,21,0)
 ;;=^^1^1^2900530^
 ;;^DD(4.29991,105,21,1,0)
 ;;=This is a count of the number of characters in the messages received.
 ;;^DD(4.29991,106,0)
 ;;=LINES SENT^NJ7,0^^0;6^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.29991,106,3)
 ;;=Type a Number between 0 and 9999999, 0 Decimal Digits
 ;;^DD(4.29991,106,21,0)
 ;;=^^1^1^2900530^
 ;;^DD(4.29991,106,21,1,0)
 ;;=This is a count of the number of lines in the message sent.
 ;;^DD(4.29991,107,0)
 ;;=LINES RECEIVED^NJ7,0^^0;7^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.29991,107,3)
 ;;=Type a Number between 0 and 9999999, 0 Decimal Digits
 ;;^DD(4.29991,107,21,0)
 ;;=^^1^1^2900605^^^
 ;;^DD(4.29991,107,21,1,0)
 ;;=This is a count of the number of lines in the messages received.
