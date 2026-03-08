XMZIN007 ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(4.24,.01,21,2,0)
 ;;=a background poller is activated to send mail to this list.
 ;;^DD(4.24,.01,"DT")
 ;;=2860625
 ;;^DD(4.25,0)
 ;;=NOTES SUB-FIELD^^.01^1
 ;;^DD(4.25,0,"DT")
 ;;=2920312
 ;;^DD(4.25,0,"NM","NOTES")
 ;;=
 ;;^DD(4.25,0,"UP")
 ;;=4.2
 ;;^DD(4.25,.01,0)
 ;;=NETWORK NOTES^WL^^0;1^Q
 ;;^DD(4.25,.01,21,0)
 ;;=^^2^2^2931214^
 ;;^DD(4.25,.01,21,1,0)
 ;;=NETWORK NOTES should be used to document indiosyncracies that occur when
 ;;^DD(4.25,.01,21,2,0)
 ;;=communicating with the domain in question.
 ;;^DD(4.25,.01,"DT")
 ;;=2920312
 ;;^DD(4.299,0)
 ;;=TRANSMISSION SCRIPT NOTES SUB-FIELD^^.01^1
 ;;^DD(4.299,0,"DT")
 ;;=2930312
 ;;^DD(4.299,0,"NM","TRANSMISSION SCRIPT NOTES")
 ;;=
 ;;^DD(4.299,0,"UP")
 ;;=4.21
 ;;^DD(4.299,.01,0)
 ;;=NOTES^WL^^0;1^Q
 ;;^DD(4.299,.01,21,0)
 ;;=^^1^1^2931214^
 ;;^DD(4.299,.01,21,1,0)
 ;;=Keep notes that are important for systems management here.
 ;;^DD(4.299,.01,"DT")
 ;;=2930312
