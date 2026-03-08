XMZIN002 ; ; 05-NOV-1996
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;Mailman 7.1;;NOV 05, 1996
 Q:'DIFQ(4.2)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(4.2,1,21,13,0)
 ;;= 
 ;;^DD(4.2,1,21,14,0)
 ;;=N = NO-forward.  MailMan will not allow messages to be forwarded.
 ;;^DD(4.2,1,21,15,0)
 ;;=    messages for this domain.
 ;;^DD(4.2,1,21,16,0)
 ;;= 
 ;;^DD(4.2,1,21,17,0)
 ;;=T = Talkman enabled.  The presence of this flag allows Talkman to be 
 ;;^DD(4.2,1,21,18,0)
 ;;=    used at your site.  It is also necessary to put a 'T' command into
 ;;^DD(4.2,1,21,19,0)
 ;;=    the script so that TalkMan will be invoked properly.
 ;;^DD(4.2,1,"DT")
 ;;=2881117
 ;;^DD(4.2,1.5,0)
 ;;=SECURITY KEY^FX^^0;11^K:$L(X)>30!($L(X)<1) X I $D(X) I '$D(^DIC(19.1,"B",X)) W !,*7,"Security key must exactly match an existing security key name" K X
 ;;^DD(4.2,1.5,3)
 ;;=Enter the exact name of a security required of the user to address this domain.
 ;;^DD(4.2,1.5,21,0)
 ;;=^^3^3^2860225^
 ;;^DD(4.2,1.5,21,1,0)
 ;;=This field, if defined, names a security key which must be held by the 
 ;;^DD(4.2,1.5,21,2,0)
 ;;=sender.  If the sender does not have this key, then he may not address this
 ;;^DD(4.2,1.5,21,3,0)
 ;;=domain.
 ;;^DD(4.2,1.5,"DT")
 ;;=2860225
 ;;^DD(4.2,1.6,0)
 ;;=VALIDATION NUMBER^NJ8,0^^0;15^K:+X'=X!(X>99999999)!(X<1000000)!(X?.E1"."1N.N) X
 ;;^DD(4.2,1.6,3)
 ;;=TYPE A WHOLE NUMBER BETWEEN 1000000 AND 99999999
 ;;^DD(4.2,1.6,21,0)
 ;;=^^3^3^2900306^^
 ;;^DD(4.2,1.6,21,1,0)
 ;;=This field is used for security.  If filled in any messaging services
 ;;^DD(4.2,1.6,21,2,0)
 ;;=that contact you will need to know the value of this field, or their
 ;;^DD(4.2,1.6,21,3,0)
 ;;=requests will be ignored.  Messaging services = other MailMan domains.
 ;;^DD(4.2,1.6,"DT")
 ;;=2861009
 ;;^DD(4.2,1.7,0)
 ;;=DISABLE TURN COMMAND^S^y:YES;n:NO;^0;16^Q
 ;;^DD(4.2,1.7,21,0)
 ;;=^^5^5^2861027^^
 ;;^DD(4.2,1.7,21,1,0)
 ;;=This field, if set to "YES", means that a remote domain calling this
 ;;^DD(4.2,1.7,21,2,0)
 ;;=domain will not be able to execute the SMTP TURN command.  This means
 ;;^DD(4.2,1.7,21,3,0)
 ;;=that the sending domain must open the link.  This allows an extra 
 ;;^DD(4.2,1.7,21,4,0)
 ;;=measure of security, to insure that the sending domain establishes the
 ;;^DD(4.2,1.7,21,5,0)
 ;;=link.
 ;;^DD(4.2,1.7,"DT")
 ;;=2861007
 ;;^DD(4.2,2,0)
 ;;=RELAY DOMAIN^P4.2^DIC(4.2,^0;3^Q
 ;;^DD(4.2,2,3)
 ;;=NAME OF DOMAIN TO SEND MESSAGES TO IF NO DIRECT PATH
 ;;^DD(4.2,2,21,0)
 ;;=^^7^7^2840330^
 ;;^DD(4.2,2,21,1,0)
 ;;=This is the name of the domain, if any, to which messages are to be
 ;;^DD(4.2,2,21,2,0)
 ;;=always routed.  For example, if traffic from Los Angeles to Washington
 ;;^DD(4.2,2,21,3,0)
 ;;=is always to be routed through San Francisco, then the RELAY DOMAIN for
 ;;^DD(4.2,2,21,4,0)
 ;;=Los Angeles is defined to be San Francisco.  
 ;;^DD(4.2,2,21,5,0)
 ;;= 
 ;;^DD(4.2,2,21,6,0)
 ;;=The relay domain overides any other path determination processes, such
 ;;^DD(4.2,2,21,7,0)
 ;;=as scripts and parent domains.
 ;;^DD(4.2,2,"DT")
 ;;=2840330
 ;;^DD(4.2,4,0)
 ;;=TRANSMISSION SCRIPT^4.21^^1;0
 ;;^DD(4.2,4,21,0)
 ;;=^^14^14^2931214^^^^
 ;;^DD(4.2,4,21,1,0)
 ;;=See the Technical Description for how this field is used in implicit
 ;;^DD(4.2,4,21,2,0)
 ;;=routing by the name server.  This field should always have at least one
 ;;^DD(4.2,4,21,3,0)
 ;;=Script command in it unless implicit routing is desirable.
 ;;^DD(4.2,4,21,4,0)
 ;;=Each line of this text field is interpreted by the MailMan script processor.
 ;;^DD(4.2,4,21,5,0)
 ;;= 
 ;;^DD(4.2,4,21,6,0)
 ;;=There are commands to be used:
 ;;^DD(4.2,4,21,7,0)
 ;;= 
 ;;^DD(4.2,4,21,8,0)
 ;;=  Open
 ;;^DD(4.2,4,21,9,0)
 ;;=  Device
 ;;^DD(4.2,4,21,10,0)
 ;;=  Wait
 ;;^DD(4.2,4,21,11,0)
 ;;=  Xecute
 ;;^DD(4.2,4,21,12,0)
 ;;=  Call
 ;;^DD(4.2,4,21,13,0)
 ;;= 
 ;;^DD(4.2,4,21,14,0)
 ;;=These commands are described in other documentation.
 ;;^DD(4.2,4,23,0)
 ;;=17
 ;;^DD(4.2,4,23,1,0)
 ;;=MailMan looks at this field at two different points.  The most obvious is
 ;;^DD(4.2,4,23,2,0)
 ;;=that this field contains a script that is interpreted by the script
 ;;^DD(4.2,4,23,3,0)
 ;;=processor.  This gives results that are explicitely defined.
 ;;^DD(4.2,4,23,4,0)
 ;;= 
 ;;^DD(4.2,4,23,5,0)
 ;;=However, this field is also looked at by the name server to determine
 ;;^DD(4.2,4,23,6,0)
 ;;=implicit routing.  The implication to the system, if this field is not
 ;;^DD(4.2,4,23,7,0)
 ;;=defined is that the local system does not know how to deliver mail to
 ;;^DD(4.2,4,23,8,0)
 ;;=this domain.  (There are no directions in the form of a Transmission Script
 ;;^DD(4.2,4,23,9,0)
 ;;=to tell MailMan what to do.)  Since, this system doesn't know how to deliver
