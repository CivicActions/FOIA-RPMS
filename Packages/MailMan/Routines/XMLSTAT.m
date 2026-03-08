XMLSTAT ;(WASH ISC)/THM- NETWORK TRANSMIT/RECEIVE STATS ;8/23/90  13:55 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ;
STAT(XMINST,Y,X,Z,%) ;Statistics recording for messages
 ;Where
 ;XMINST=Domain#
 ;Y:  1=Send, 2=Receive
 ;X=XMRG or XMSG (What is sent or received)
 ;Z=Protocol
 ;%=# Lines to update
 ;
 ;Output= >0 if successful (1 if variables updated, 2 if 4.2999 file)
 ;       0 if fails
 ;
 ;XMLCT and XMLINE are updated
 ;XMLST exists in all network transmissions as the time in seconds when
 ;      the process starting updating statistics.
 ;
 S:'$D(XMLST) XMLST=+$H*86400+$P($H,",",2)-.001
 ;
 I '$G(XMINST)!(Y'=1&(Y'=2)) Q 0
 S XMLINE=$G(XMLINE)+%,XMLCT=$G(XMLCT)+$L(X)
 ;
 I $S(XMLINE<100&(XMLINE#20'=0):1,XMLINE#100'=0:1,1:0) Q 1
 ;
 S ^XMBS(4.2999,XMINST,3)=$H_U_$G(XMZ)_U_XMLINE_"^"_$G(XMLER)_"^"_$J(XMLCT/($H*86400+$P($H,",",2)-XMLST),0,2)_U_$E(IO,1,8)_" "_Z_U_$S($D(ZTSK)#2:ZTSK,1:"")_U_$E("^",Y)_U_XMLCT
 Q 2
