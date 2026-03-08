XMZIN006 ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(4.21,1.1,21,3,0)
 ;;=This field is used in conjunction with the Priority field.  When the
 ;;^DD(4.21,1.1,21,4,0)
 ;;=the Number of tries to transmit the messages in the queue exceeds the value
 ;;^DD(4.21,1.1,21,5,0)
 ;;=of this field, a Transmission Failure bulletin is sent to the Postmaster.
 ;;^DD(4.21,1.1,23,0)
 ;;=^^2^2^2930312^
 ;;^DD(4.21,1.1,23,1,0)
 ;;= 
 ;;^DD(4.21,1.1,23,2,0)
 ;;= 
 ;;^DD(4.21,1.1,"DT")
 ;;=2930312
 ;;^DD(4.21,1.2,0)
 ;;=TYPE^S^FTP:File Transfer Protocol;SMTP:Simple Mail Transfer Protocol;TELNET:Interactive / TalkMan;TCPCHAN:TCP/IP Channel;OTHER:OTHER;^0;4^Q
 ;;^DD(4.21,1.2,21,0)
 ;;=^^2^2^2931214^
 ;;^DD(4.21,1.2,21,1,0)
 ;;=Each transmission script must be given a type so that it
 ;;^DD(4.21,1.2,21,2,0)
 ;;=can be handled properly.
 ;;^DD(4.21,1.2,"DT")
 ;;=2931218
 ;;^DD(4.21,1.3,0)
 ;;=PHYSICAL LINK / DEVICE^FX^^0;5^K:$L(X)>30!($L(X)<1) X I $D(X) S %ZIS="NQRS",IOP=X D ^%ZIS K:POP X S:$D(X) X=ION W:$D(X) " Stored internally as ",X D ^%ZISC S IOP="HOME" D ^%ZIS K IOP,%ZIS
 ;;^DD(4.21,1.3,3)
 ;;=Answer must be 3-30 characters in length.
 ;;^DD(4.21,1.3,21,0)
 ;;=^^4^4^2930312^
 ;;^DD(4.21,1.3,21,1,0)
 ;;=The physical link is the channel that the transmission will take place
 ;;^DD(4.21,1.3,21,2,0)
 ;;=on.  This field is always a free text pointer to the device file.
 ;;^DD(4.21,1.3,21,3,0)
 ;;=See field 17 / Physical Link Device for more information.
 ;;^DD(4.21,1.3,21,4,0)
 ;;= 
 ;;^DD(4.21,1.3,23,0)
 ;;=^^1^1^2930312^
 ;;^DD(4.21,1.3,23,1,0)
 ;;= 
 ;;^DD(4.21,1.3,"DT")
 ;;=2930312
 ;;^DD(4.21,1.4,0)
 ;;=NETWORK ADDRESS (MAILMAN HOST)^F^^0;6^K:$L(X)>50!($L(X)<3) X
 ;;^DD(4.21,1.4,3)
 ;;=Answer must be 3-50 characters in length.
 ;;^DD(4.21,1.4,21,0)
 ;;=^^2^2^2930312^
 ;;^DD(4.21,1.4,21,1,0)
 ;;=The network address is that identifier that, used appropriately on the
 ;;^DD(4.21,1.4,21,2,0)
 ;;=physical link, allows specification of the system to be contacted.
 ;;^DD(4.21,1.4,"DT")
 ;;=2930312
 ;;^DD(4.21,1.5,0)
 ;;=OUT OF SERVICE^S^0:in service;1:out of service;^0;7^Q
 ;;^DD(4.21,1.5,3)
 ;;= If you don't want this script to be used, set this field to 1; otherwise leave it blank or set it to zero.
 ;;^DD(4.21,1.5,21,0)
 ;;=^^2^2^2960716^
 ;;^DD(4.21,1.5,21,1,0)
 ;;=This is the preferred field to set to take a script out of service,
 ;;^DD(4.21,1.5,21,2,0)
 ;;=to prevent it from being used.
 ;;^DD(4.21,1.5,"DT")
 ;;=2960718
 ;;^DD(4.21,2,0)
 ;;=TEXT^4.22^^1;0
 ;;^DD(4.21,2,3)
 ;;=Enter the number of hours before or after GMT
 ;;^DD(4.21,2,21,0)
 ;;=^^1^1^2931214^^
 ;;^DD(4.21,2,21,1,0)
 ;;=This is the text of the script.  See description above.
 ;;^DD(4.21,99,0)
 ;;=TRANSMISSION SCRIPT NOTES^4.299^^NOTES;0
 ;;^DD(4.21,99,21,0)
 ;;=^^1^1^2931214^
 ;;^DD(4.21,99,21,1,0)
 ;;=Keep notes that are important for systems management here.
 ;;^DD(4.21,99,"DT")
 ;;=2930405
 ;;^DD(4.22,0)
 ;;=TEXT SUB-FIELD^NL^.01^1
 ;;^DD(4.22,0,"NM","TEXT")
 ;;=
 ;;^DD(4.22,0,"UP")
 ;;=4.21
 ;;^DD(4.22,.01,0)
 ;;=TEXT^WL^^0;1^Q
 ;;^DD(4.22,.01,3)
 ;;=THE TEXT OF THE LOGON SCRIPT
 ;;^DD(4.22,.01,21,0)
 ;;=^^1^1^2931214^^
 ;;^DD(4.22,.01,21,1,0)
 ;;=This is the text of the script.  See description above.
 ;;^DD(4.22,.01,"DT")
 ;;=2860724
 ;;^DD(4.23,0)
 ;;=SYNONYM SUB-FIELD^NL^.01^1
 ;;^DD(4.23,0,"NM","SYNONYM")
 ;;=
 ;;^DD(4.23,0,"UP")
 ;;=4.2
 ;;^DD(4.23,.01,0)
 ;;=SYNONYM^MF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>30!($L(X)<1) X
 ;;^DD(4.23,.01,1,0)
 ;;=^.1
 ;;^DD(4.23,.01,1,1,0)
 ;;=4.2^C
 ;;^DD(4.23,.01,1,1,1)
 ;;=S ^DIC(4.2,"C",$E(X,1,30),DA(1),DA)=""
 ;;^DD(4.23,.01,1,1,2)
 ;;=K ^DIC(4.2,"C",$E(X,1,30),DA(1),DA)
 ;;^DD(4.23,.01,3)
 ;;=ANSWER MUST BE 1-30 CHARACTERS IN LENGTH
 ;;^DD(4.23,.01,21,0)
 ;;=^^3^3^2851009^
 ;;^DD(4.23,.01,21,1,0)
 ;;=Another name by which this Domain is known. For example,
 ;;^DD(4.23,.01,21,2,0)
 ;;="San Francisco, CA" can be a synonym of the domain
 ;;^DD(4.23,.01,21,3,0)
 ;;="SANFRANCISCO.VA.GOV".
 ;;^DD(4.23,.01,"DT")
 ;;=2840330
 ;;^DD(4.24,0)
 ;;=POLL LIST SUB-FIELD^^.01^1
 ;;^DD(4.24,0,"NM","POLL LIST")
 ;;=
 ;;^DD(4.24,0,"PT",4.3,.01)
 ;;=
 ;;^DD(4.24,0,"PT",4.3,3)
 ;;=
 ;;^DD(4.24,0,"UP")
 ;;=4.2
 ;;^DD(4.24,.01,0)
 ;;=POLL LIST^MNJ7,2^^0;1^K:+X'=X!(X>1000)!(X<0)!(X?.E1"."3N.N) X
 ;;^DD(4.24,.01,1,0)
 ;;=^.1
 ;;^DD(4.24,.01,1,1,0)
 ;;=4.2^AB
 ;;^DD(4.24,.01,1,1,1)
 ;;=S ^DIC(4.2,"AB",$E(X,1,30),DA(1),DA)=""
 ;;^DD(4.24,.01,1,1,2)
 ;;=K ^DIC(4.2,"AB",$E(X,1,30),DA(1),DA)
 ;;^DD(4.24,.01,3)
 ;;=Enter a poll list number between 0 and 1000
 ;;^DD(4.24,.01,21,0)
 ;;=^^2^2^2931214^
 ;;^DD(4.24,.01,21,1,0)
 ;;=If this domain belongs to a poll list, then it will be activated when
