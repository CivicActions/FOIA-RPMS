XMZIN008 ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2999)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(4.2999,0,"GL")
 ;;=^XMBS(4.2999,
 ;;^DIC("B","MESSAGE STATISTICS",4.2999)
 ;;=
 ;;^DIC(4.2999,"%D",0)
 ;;=^^1^1^2900530
 ;;^DIC(4.2999,"%D",1,0)
 ;;=This file is used to collect non-static information about network mail transmissions
 ;;^DD(4.2999,0)
 ;;=FIELD^^101^23
 ;;^DD(4.2999,0,"DT")
 ;;=2900605
 ;;^DD(4.2999,0,"IX","B",4.2999,.01)
 ;;=
 ;;^DD(4.2999,0,"NM","MESSAGE STATISTICS")
 ;;=
 ;;^DD(4.2999,.01,0)
 ;;=NAME^RP4.2'X^DIC(4.2,^0;1^S:$D(X) DINUM=X
 ;;^DD(4.2999,.01,.1)
 ;;=The exact name of the domain, as used in network addressing
 ;;^DD(4.2999,.01,1,0)
 ;;=^.1
 ;;^DD(4.2999,.01,1,1,0)
 ;;=4.2999^B
 ;;^DD(4.2999,.01,1,1,1)
 ;;=S ^XMBS(4.2999,"B",$E(X,1,30),DA)=""
 ;;^DD(4.2999,.01,1,1,2)
 ;;=K ^XMBS(4.2999,"B",$E(X,1,30),DA)
 ;;^DD(4.2999,.01,3)
 ;;=
 ;;^DD(4.2999,.01,21,0)
 ;;=^^4^4^2880310^^^
 ;;^DD(4.2999,.01,21,1,0)
 ;;=This name is the exact name of the domain, as used in network addressing
 ;;^DD(4.2999,.01,21,2,0)
 ;;= 
 ;;^DD(4.2999,.01,21,3,0)
 ;;=The name must begin with an alpha, then be followed by only alpha,
 ;;^DD(4.2999,.01,21,4,0)
 ;;=numeric, or "-" characters, for a total less than 13 characters.
 ;;^DD(4.2999,.01,"DT")
 ;;=2910212
 ;;^DD(4.2999,1,0)
 ;;=PROGRESS REPORT^F^^3;1^K:$L(X)>20!($L(X)<6) X
 ;;^DD(4.2999,1,3)
 ;;=Answer must be 6-20 characters in length.
 ;;^DD(4.2999,1,21,0)
 ;;=^^4^4^2900530^
 ;;^DD(4.2999,1,21,1,0)
 ;;=This field contains the time in $H format of the last time a queue dump 
 ;;^DD(4.2999,1,21,2,0)
 ;;=routine reported its progress.  If this field is undefined, or 'old', then 
 ;;^DD(4.2999,1,21,3,0)
 ;;=the queue is assumed to be inactive.  If not, the rest of the fields on this
 ;;^DD(4.2999,1,21,4,0)
 ;;=node indicate the status of the transmission.
 ;;^DD(4.2999,2,0)
 ;;=MESSAGE IN TRANSIT^NJ9,0^^3;2^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,2,3)
 ;;=Type a Number between 0 and 999999999, 0 Decimal Digits
 ;;^DD(4.2999,2,21,0)
 ;;=^^1^1^2900530^
 ;;^DD(4.2999,2,21,1,0)
 ;;=This points to the 3.9 (Message) file entry of the message being transmitted.
 ;;^DD(4.2999,3,0)
 ;;=LINE LAST TRANSMITTED^NJ9,0^^3;3^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,3,3)
 ;;=Type a Number between 0 and 999999999, 0 Decimal Digits
 ;;^DD(4.2999,3,21,0)
 ;;=^^1^1^2900530^
 ;;^DD(4.2999,3,21,1,0)
 ;;=This is the line number of the message in transit.
 ;;^DD(4.2999,4,0)
 ;;=ERRORS THIS TRANSMISSION^NJ3,0^^3;4^K:+X'=X!(X>999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,4,3)
 ;;=Type a Number between 0 and 999, 0 Decimal Digits
 ;;^DD(4.2999,4,21,0)
 ;;=^^2^2^2900530^
 ;;^DD(4.2999,4,21,1,0)
 ;;=This is the number of "soft" errors (non-fatal) that have been encountered 
 ;;^DD(4.2999,4,21,2,0)
 ;;=during the course of the entire current transmission.
 ;;^DD(4.2999,5,0)
 ;;=RATE OF TRANSMISSION^NJ8,2^^3;5^K:+X'=X!(X>99999.99)!(X<0)!(X?.E1"."3N.N) X
 ;;^DD(4.2999,5,3)
 ;;=Type a Number between 0 and 99999.99.
 ;;^DD(4.2999,5,21,0)
 ;;=^^3^3^2900530^
 ;;^DD(4.2999,5,21,1,0)
 ;;=This is the transmission rate in characters per secondthat is valid for the
 ;;^DD(4.2999,5,21,2,0)
 ;;=current transmission.  It may be for a single line or for a block or for the
 ;;^DD(4.2999,5,21,3,0)
 ;;=entire message.
 ;;^DD(4.2999,6,0)
 ;;=NETWORK DEVICE^F^^3;6^K:$L(X)>19!($L(X)<1) X
 ;;^DD(4.2999,6,3)
 ;;=Answer must be 1-19 characters in length.
 ;;^DD(4.2999,6,21,0)
 ;;=^^2^2^2900530^
 ;;^DD(4.2999,6,21,1,0)
 ;;=This is the name of the device (system name) that the transmission is 
 ;;^DD(4.2999,6,21,2,0)
 ;;=running on.  It may be incoming or outgoing.
 ;;^DD(4.2999,7,0)
 ;;=OUTGOING MESSAGE COUNT^NJ7,0^^0;5^K:+X'=X!(X>9999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,7,3)
 ;;=TYPE A WHOLE NUMBER BETWEEN 0 AND 9999999
 ;;^DD(4.2999,7,21,0)
 ;;=^^2^2^2851009^
 ;;^DD(4.2999,7,21,1,0)
 ;;=This is a count of the number of messages which have been transmitted to this
 ;;^DD(4.2999,7,21,2,0)
 ;;=domain since the counter was last set to zero.
 ;;^DD(4.2999,7,21,3,0)
 ;;=avoid 'playing scripts' or 'transmitting' a domain that a background task
 ;;^DD(4.2999,7,21,4,0)
 ;;=is trying to deliver.
 ;;^DD(4.2999,7,"DT")
 ;;=2851009
 ;;^DD(4.2999,8,0)
 ;;=CHARACTERS REC'D^NJ9,0^^3;8^K:+X'=X!(X>999999999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.2999,8,3)
 ;;=Type a Number between 0 and 999999999, 0 Decimal Digits
 ;;^DD(4.2999,8,21,0)
 ;;=^^2^2^2900530^
 ;;^DD(4.2999,8,21,1,0)
 ;;=This is the number of characters received during the current transmission.
 ;;^DD(4.2999,8,21,2,0)
 ;;=See Field 10, Characters Sent.
 ;;^DD(4.2999,9,0)
 ;;=INCOMING MESSAGE COUNT^NJ8,0^^0;7^K:+X'=X!(X>99999999)!(X<0)!(X?.E1"."1N.N) X
