XMZIN005 ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(4.2,22,0)
 ;;=LEVEL 3 NAME^CJ8^^ ; ^X ^DD(4.2,22,9.2) S Y(4.2,22,5)=X S X=".",X=$L(Y(4.2,22,5),X)-2,Y(4.2,22,6)=X S X=9,X=$P(Y(4.2,22,2),Y(4.2,22,3),Y(4.2,22,6),X)
 ;;^DD(4.2,22,9)
 ;;=^
 ;;^DD(4.2,22,9.01)
 ;;=4.2^.01
 ;;^DD(4.2,22,9.1)
 ;;=$P(NAME,".",$L(NAME,".")-2)
 ;;^DD(4.2,22,9.2)
 ;;=S Y(4.2,22,1)=$S($D(^DIC(4.2,D0,0)):^(0),1:"") S X=$P(Y(4.2,22,1),U,1),Y(4.2,22,2)=X S X=".",Y(4.2,22,3)=X,Y(4.2,22,4)=X S X=$P(Y(4.2,22,1),U,1)
 ;;^DD(4.2,22,21,0)
 ;;=^^1^1^2881107^
 ;;^DD(4.2,22,21,1,0)
 ;;=$P(domain-name,".",$L(domain-name,".")-2)
 ;;^DD(4.2,23,0)
 ;;=LEVEL 4 NAME^CJ8^^ ; ^X ^DD(4.2,23,9.2) S Y(4.2,23,5)=X S X=".",X=$L(Y(4.2,23,5),X)-3,Y(4.2,23,6)=X S X=9,X=$P(Y(4.2,23,2),Y(4.2,23,3),Y(4.2,23,6),X)
 ;;^DD(4.2,23,9)
 ;;=^
 ;;^DD(4.2,23,9.01)
 ;;=4.2^.01
 ;;^DD(4.2,23,9.1)
 ;;=$P(NAME,".",$L(NAME,".")-3)
 ;;^DD(4.2,23,9.2)
 ;;=S Y(4.2,23,1)=$S($D(^DIC(4.2,D0,0)):^(0),1:"") S X=$P(Y(4.2,23,1),U,1),Y(4.2,23,2)=X S X=".",Y(4.2,23,3)=X,Y(4.2,23,4)=X S X=$P(Y(4.2,23,1),U,1)
 ;;^DD(4.2,23,9.3)
 ;;=X ^DD(4.2,23,9.2) S Y(4.2,23,5)=X,X=".",Y(4.2,23,6)=X,X=$L(Y(4.2,23,5),X),Y(4.2,23,6)=X,Y(4.2,23,7)=X S X=9
 ;;^DD(4.2,23,21,0)
 ;;=^^1^1^2881107^
 ;;^DD(4.2,23,21,1,0)
 ;;=$P(domain-name,".",$L(domain-name,".")-3)
 ;;^DD(4.2,23,"DT")
 ;;=2870406
 ;;^DD(4.2,50,0)
 ;;=DIRECTORY REQUESTS FLAG^NJ2,0X^^50;1^I $S(X="":0,X\1'=X:1,X>99:1,1:0) K X
 ;;^DD(4.2,50,1,0)
 ;;=^.1
 ;;^DD(4.2,50,1,1,0)
 ;;=4.2^AE
 ;;^DD(4.2,50,1,1,1)
 ;;=S ^DIC(4.2,"AE",$E(X,1,30),DA)=""
 ;;^DD(4.2,50,1,1,2)
 ;;=K ^DIC(4.2,"AE",$E(X,1,30),DA)
 ;;^DD(4.2,50,1,1,"DT")
 ;;=2930323
 ;;^DD(4.2,50,3)
 ;;=Type a Number between 0 and 99, 0 Decimal Digits
 ;;^DD(4.2,50,21,0)
 ;;=10
 ;;^DD(4.2,50,21,1,0)
 ;;=This field controls whether or not the XMMGR-DIRECTORY-ALL option
 ;;^DD(4.2,50,21,2,0)
 ;;=will send a message requesting the user directory for the domain.
 ;;^DD(4.2,50,21,3,0)
 ;;= 
 ;;^DD(4.2,50,21,4,0)
 ;;=If the value is null or zero, no request will be made.
 ;;^DD(4.2,50,21,5,0)
 ;;=If the value is a positive integer, a request will be made
 ;;^DD(4.2,50,21,6,0)
 ;;=at the same time as other domains with the same number in this
 ;;^DD(4.2,50,21,7,0)
 ;;=field are made.  A task must be set up and scheduled for each
 ;;^DD(4.2,50,21,8,0)
 ;;=number assigned using the XMDIR-REQUEST-ALL option, which is then
 ;;^DD(4.2,50,21,9,0)
 ;;=run every 90 days (or according to what you change the reschedule
 ;;^DD(4.2,50,21,10,0)
 ;;=value to).
 ;;^DD(4.2,50,"DT")
 ;;=2930902
 ;;^DD(4.21,0)
 ;;=TRANSMISSION SCRIPT SUB-FIELD^NL^99^9
 ;;^DD(4.21,0,"DT")
 ;;=2931218
 ;;^DD(4.21,0,"IX","AC",4.21,1)
 ;;=
 ;;^DD(4.21,0,"NM","TRANSMISSION SCRIPT")
 ;;=
 ;;^DD(4.21,0,"UP")
 ;;=4.2
 ;;^DD(4.21,.01,0)
 ;;=TRANSMISSION SCRIPT^MF^^0;1^K:$L(X)>10!($L(X)<1) X
 ;;^DD(4.21,.01,.1)
 ;;=A free text string of 1 to 10 characters identifying the script.
 ;;^DD(4.21,.01,1,0)
 ;;=^.1^^0
 ;;^DD(4.21,.01,3)
 ;;=ANSWER MUST BE 1-10 CHARACTERS IN LENGTH
 ;;^DD(4.21,.01,21,0)
 ;;=^^2^2^2931214^^
 ;;^DD(4.21,.01,21,1,0)
 ;;=This field contains commands that will be used to connect to another
 ;;^DD(4.21,.01,21,2,0)
 ;;=site and deliver mail.
 ;;^DD(4.21,.01,"DT")
 ;;=2870402
 ;;^DD(4.21,1,0)
 ;;=PRIORITY^NJ4,0^^0;2^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.21,1,1,0)
 ;;=^.1
 ;;^DD(4.21,1,1,1,0)
 ;;=4.21^AC
 ;;^DD(4.21,1,1,1,1)
 ;;=S ^DIC(4.2,DA(1),1,"AC",$E(X,1,30),DA)=""
 ;;^DD(4.21,1,1,1,2)
 ;;=K ^DIC(4.2,DA(1),1,"AC",$E(X,1,30),DA)
 ;;^DD(4.21,1,1,1,"%D",0)
 ;;=^^3^3^2930317^
 ;;^DD(4.21,1,1,1,"%D",1,0)
 ;;=This cross reference controls which transmission script will be used to
 ;;^DD(4.21,1,1,1,"%D",2,0)
 ;;=trnsmit messages.  The highest priority script wil be used first.  Low
 ;;^DD(4.21,1,1,1,"%D",3,0)
 ;;=numbers mean high priority.
 ;;^DD(4.21,1,1,1,"DT")
 ;;=2930317
 ;;^DD(4.21,1,3)
 ;;=Type a Number between 0 and 9999, 0 Decimal Digits
 ;;^DD(4.21,1,21,0)
 ;;=^^3^3^2930312^
 ;;^DD(4.21,1,21,1,0)
 ;;=This field is used by MailMan to decide which script to play when trying
 ;;^DD(4.21,1,21,2,0)
 ;;=to transmit messages in background.  The higher the number the lower the
 ;;^DD(4.21,1,21,3,0)
 ;;=priority for being chosen.  See also the Number of Attempts field.
 ;;^DD(4.21,1,"DT")
 ;;=2930317
 ;;^DD(4.21,1.1,0)
 ;;=NUMBER OF ATTEMPTS^NJ4,0^^0;3^K:+X'=X!(X>9999)!(X<0)!(X?.E1"."1N.N) X
 ;;^DD(4.21,1.1,3)
 ;;=Type a Number between 0 and 9999, 0 Decimal Digits
 ;;^DD(4.21,1.1,21,0)
 ;;=^^5^5^2930312^^
 ;;^DD(4.21,1.1,21,1,0)
 ;;=MailMan tests against this field to determine how many times it should
 ;;^DD(4.21,1.1,21,2,0)
 ;;=try a particular protocol before giving up and trying the next one.
