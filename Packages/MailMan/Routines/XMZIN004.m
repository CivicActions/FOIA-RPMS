XMZIN004 ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(4.2,6.62,3)
 ;;=Answer must be 7-61 characters in length.
 ;;^DD(4.2,6.62,21,0)
 ;;=^^6^6^2930426^^^
 ;;^DD(4.2,6.62,21,1,0)
 ;;=This is the information needed by to log into an FTP service to send
 ;;^DD(4.2,6.62,21,2,0)
 ;;=files.  It is overridden by the site if they wish in their Kernel Site
 ;;^DD(4.2,6.62,21,3,0)
 ;;=Parameters and sent to the sender in real time.
 ;;^DD(4.2,6.62,21,4,0)
 ;;= 
 ;;^DD(4.2,6.62,21,5,0)
 ;;=There are really two pieces of data in this field separated by a ";".
 ;;^DD(4.2,6.62,21,6,0)
 ;;=Piece number 1 is the username.  Piece number 2 is the password.
 ;;^DD(4.2,6.62,"DT")
 ;;=2930426
 ;;^DD(4.2,6.7,0)
 ;;=FTP BLOB DIRECTORY^F^^FTP-DIR;1^K:$L(X)>40!($L(X)<2) X
 ;;^DD(4.2,6.7,3)
 ;;=Answer must be 2-40 characters in length.
 ;;^DD(4.2,6.7,21,0)
 ;;=^^2^2^2931214^^
 ;;^DD(4.2,6.7,21,1,0)
 ;;=This field contains the directory into which a file should be put
 ;;^DD(4.2,6.7,21,2,0)
 ;;=by a domain sending it files to attach to multimedia messages.
 ;;^DD(4.2,6.7,"DT")
 ;;=2930301
 ;;^DD(4.2,16,0)
 ;;=POLL LIST^4.24^^4;0
 ;;^DD(4.2,16,3)
 ;;=ANSWER MUST BE 1-15 CHARACTERS IN LENGTH
 ;;^DD(4.2,16,21,0)
 ;;=^^2^2^2931214^^
 ;;^DD(4.2,16,21,1,0)
 ;;=If this domain belongs to a poll list, then it will be activated when
 ;;^DD(4.2,16,21,2,0)
 ;;=a background poller is activated to send mail to this list.
 ;;^DD(4.2,16,"DT")
 ;;=2860228
 ;;^DD(4.2,17,0)
 ;;=PHYSICAL LINK DEVICE^FX^^0;17^K:$L(X)>30!($L(X)<1) X I $D(X) S %ZIS="NQRS",IOP=X D ^%ZIS K:POP X S:$D(X) X=ION W:$D(X) " Stored internally as ",X D ^%ZISC S IOP="HOME" D ^%ZIS K IOP,%ZIS
 ;;^DD(4.2,17,3)
 ;;=MUST MATCH THE NAME FIELD IN THE DEVICE FILE.
 ;;^DD(4.2,17,21,0)
 ;;=^^18^18^2881121^^^^
 ;;^DD(4.2,17,21,1,0)
 ;;=This field is used for network mail ONLY.
 ;;^DD(4.2,17,21,2,0)
 ;;=If there is an entry in this field, it will override any device that is
 ;;^DD(4.2,17,21,3,0)
 ;;=named in the TRANSMISSION SCRIPT field.  If there is no entry in this field,
 ;;^DD(4.2,17,21,4,0)
 ;;=the device named in the transmission script will be used.
 ;;^DD(4.2,17,21,5,0)
 ;;=If this domain has a physical link such as a miniengine port,
 ;;^DD(4.2,17,21,6,0)
 ;;=a direct line to another cpu, a modem, etc., this port should be named
 ;;^DD(4.2,17,21,7,0)
 ;;=in this field to direct network mail to the proper output device.
 ;;^DD(4.2,17,21,8,0)
 ;;=There must be an entry in the DEVICE file for this cpu port.  The name
 ;;^DD(4.2,17,21,9,0)
 ;;=field of the DEVICE file can be a literal (such as MINIENGINE-OUT or
 ;;^DD(4.2,17,21,10,0)
 ;;=CPU B LINK) but the $I field must match with the correct cpu $I.
 ;;^DD(4.2,17,21,11,0)
 ;;=If the link is physically located on a cpu other than the one the network
 ;;^DD(4.2,17,21,12,0)
 ;;=mail is being sent from, the local DEVICE file MUST reflect that in the
 ;;^DD(4.2,17,21,13,0)
 ;;=OTHER CPU field of the device file if the transmission is to take place
 ;;^DD(4.2,17,21,14,0)
 ;;=immediately.  If it is not identified properly, the message will go into
 ;;^DD(4.2,17,21,15,0)
 ;;=a queue to be processed the next time a network message is sent from or
 ;;^DD(4.2,17,21,16,0)
 ;;=recieved on the processor with the physical link.
 ;;^DD(4.2,17,21,17,0)
 ;;=NOTE:  The DEVICE files on all cpu's must have matching device names
 ;;^DD(4.2,17,21,18,0)
 ;;=       to correctly route the message to the proper cpu for sending.
 ;;^DD(4.2,17,"DT")
 ;;=2911217
 ;;^DD(4.2,20,0)
 ;;=LEVEL 1 NAME^CJ8^^ ; ^X ^DD(4.2,20,9.2) S Y(4.2,20,5)=X S X=".",X=$L(Y(4.2,20,5),X),X=$P(Y(4.2,20,2),Y(4.2,20,3),X)
 ;;^DD(4.2,20,9)
 ;;=^
 ;;^DD(4.2,20,9.01)
 ;;=4.2^.01
 ;;^DD(4.2,20,9.1)
 ;;=$P(NAME,".",$L(NAME,"."))
 ;;^DD(4.2,20,9.2)
 ;;=S Y(4.2,20,1)=$S($D(^DIC(4.2,D0,0)):^(0),1:"") S X=$P(Y(4.2,20,1),U,1),Y(4.2,20,2)=X S X=".",Y(4.2,20,3)=X,Y(4.2,20,4)=X S X=$P(Y(4.2,20,1),U,1)
 ;;^DD(4.2,20,21,0)
 ;;=^^2^2^2881107^
 ;;^DD(4.2,20,21,1,0)
 ;;=The most right "." piece of a domain name 
 ;;^DD(4.2,20,21,2,0)
 ;;=($P(domain-name,".",$L(domain-name,"."))
 ;;^DD(4.2,21,0)
 ;;=LEVEL 2 NAME^CJ8^^ ; ^X ^DD(4.2,21,9.2) S Y(4.2,21,5)=X S X=".",X=$L(Y(4.2,21,5),X)-1,Y(4.2,21,6)=X S X=9,X=$P(Y(4.2,21,2),Y(4.2,21,3),Y(4.2,21,6),X)
 ;;^DD(4.2,21,9)
 ;;=^
 ;;^DD(4.2,21,9.01)
 ;;=4.2^.01
 ;;^DD(4.2,21,9.1)
 ;;=$P(NAME,".",$L(NAME,".")-1)
 ;;^DD(4.2,21,9.2)
 ;;=S Y(4.2,21,1)=$S($D(^DIC(4.2,D0,0)):^(0),1:"") S X=$P(Y(4.2,21,1),U,1),Y(4.2,21,2)=X S X=".",Y(4.2,21,3)=X,Y(4.2,21,4)=X S X=$P(Y(4.2,21,1),U,1)
 ;;^DD(4.2,21,21,0)
 ;;=^^1^1^2881107^^
 ;;^DD(4.2,21,21,1,0)
 ;;=$P(domain-name,".",$L(domain-name,".")-1)
