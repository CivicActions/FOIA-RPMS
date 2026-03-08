XMYPOST0 ;(WASH ISC)/CAP-RESET MAILBOX'S X-REFS ;10/24/89  13:37 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ;Converts MailMan 3.09 and previous versions to new structure
 ;ADD NO-FORWARD FLAG IN Q-DOMAINS
 I $S('$D(^XMB("NETNAME")):1,^("NETNAME")="FOC-AUSTIN.VA.GOV":0,1:1) S J="Q-" F I=0:0 S J=$O(^DIC(4.2,"B",J)) Q:$E(J,1,2)'="Q-"  S I=$O(^(J,0)),I=^DIC(4.2,I,0) I $P(I,U,2)'["N" S $P(I,U,2)=$P(I,U,2)_"N",^(0)=I
 S XMDUZ=0,XMT0=0,XMD0=0 K XMN0,^XMB(3.7,"M")
 ;
 W !!,"Now for a conversion of the Mail Boxes (the 3.7 file), of which"
 W !,"you have ",$P(^XMB(3.7,0),U,3),".  It may take some time [about 10"
 W !,"minutes for each 100 users (Mail Boxes)].  Each '+' is a Mail Box."
 W !,"Each '-' is a NEW message.  Each '.' is 100 messages processed."
 W !!,"An announcement will be made for every 25 users processed.",!!!
 ;
 W !!,"*** STARTED " D DT W " ***"
A S XMDUZ=$O(^XMB(3.7,XMDUZ)) K XMN0 G Q:XMDUZ=""
 I XMDUZ'=+XMDUZ G A:XMDUZ'["@"
 ;
 ;FIX INCORRECT NODES FROM NETWORK MAIL BUG IN 3.09 & PREVIOUS VERSIONS
 ;
 I +XMDUZ'=XMDUZ G K:XMDUZ["@"
 ;
 S Y=$S($D(^XMB(3.7,XMDUZ,0)):^(0),1:"") I $L(Y) G D:'$L($P(Y,U,2)) G D:$E(X)'="\" S $P(Y,U,8)=1,$P(Y,U,2)=$E($P(Y,U,2),2,99),^(0)=Y G D
 S ^XMB(3.7,XMDUZ,0)=XMDUZ I '$D(^("L")) G K:'$D(^VA(200,XMDUZ,0)) S Y=^(0) G L:$P(Y,U,3)'="",K:$F(":Y:y:",":"_$P(Y,U,5)_":"),L
 ;
 ;DELETE MAILBOX IF NO LONGER ACTIVE & MAILBOXES DELETED AT TERMINATION
D G K:'$D(^VA(200,XMDUZ,0)) S Y=^(0)
 I $P(Y,U,3)="" S Y=$P(Y,U,5) I Y="y"!(Y="Y") G K
 S ^XMB(3.7,"B",XMDUZ,XMDUZ)=""
 I '$D(^XMB(3.7,XMDUZ,2,1,0)) S Y=XMDUZ D NEW^XM
 ;
B S (XMZ,XMC0)=0,XMD0=XMD0+1
 I XMD0#25=0 W !,"***** ",XMD0," USERS PROCESSED. *****",!!
 K XMN0 S XMM0=0 D Z G A
 ;
 ;FIND NEW MESSAGES / COUNT BY BASKET / TOTAL
 ;
Z S XMZ=$O(^XMB(3.7,XMDUZ,"N",XMZ)) G Y:'XMZ S XMK=0
Z0 S XMK=$O(^XMB(3.7,XMDUZ,"N",XMZ,XMK)) I 'XMK G Z
 I '$D(XMN0(XMK)) S XMN0(XMK)=""
 S XMN0(XMK,XMZ)="",XMN0(XMK)=XMN0(XMK)+1,XMM0=XMM0+1,XMC0=XMC0+1
 I XMM0>99 G NEW^XMYPOST1
 G Z0
 ;
 ;RESET NEW 'N' NODES / FLAG NEW MESSAGES / SET COUNTS INTO FILE
 ;
Y S:XMC0 $P(^XMB(3.7,XMDUZ,0),U,6)=XMC0 S XMK=0 K ^XMB(3.7,XMDUZ,"R")
Y1 S XMK=$O(XMN0(XMK)) G YQ:'XMK
 I XMN0(XMK) S $P(^XMB(3.7,XMDUZ,2,XMK,0),U,2)=XMN0(XMK)
 S XMZ=0
Y2 S XMZ=$O(XMN0(XMK,XMZ)) G Y1:'XMZ
 W "-" W:$X>78 !
 S ^XMB(3.7,XMDUZ,2,XMK,1,XMZ,0)=XMZ_"^^1",^XMB(3.7,XMDUZ,"N0",XMK,XMZ)=""
 G Y2
YQ W "+" W:$X>78 !
 ;
 ;SET "B" REF / COUNTS / "M" REFERENCE
 ;
U S XMK=0
U0 S XMK=$O(^XMB(3.7,XMDUZ,2,XMK)) I 'XMK K ^XMB(3.7,XMDUZ,"N") Q
 W "." W:$X>78 ! S XMZ=0,XMN0=0 K ^XMB(3.7,XMDUZ,2,XMK,1,"C"),^("B")
U1 S XMZ=$O(^XMB(3.7,XMDUZ,2,XMK,1,XMZ)) G U2:'XMZ S X=^(XMZ,0),XMN0=XMN0+1,XMT0=XMT0+1,X=XMZ_U_XMN0_"^"_$P(X,U,3)_"^"_DT,^(0)=X
 S ^XMB(3.7,XMDUZ,2,XMK,1,"C",XMN0,XMZ)="",^XMB(3.7,"M",XMZ,XMDUZ,XMK,XMZ)=""
 G U1
U2 S $P(^XMB(3.7,XMDUZ,2,XMK,0),U,3,5)=XMN0_U_XMN0_U_XMN0
 G U0
Q ;FINISH UP / RESET "I" CROSS REFERENCES
 ;
 W !!,"<<< DONE @ " D DT W ", ",XMT0," MESSAGE/BASKETS PROCESSED >>>",!!
 G IQ:$O(^XMB(3.9,"I",""))=""
 W !!,"   ***** RESETTING ^XMB(3.9,I X-REF *****",!!
 ;
 S I="",Y=0,K=0
I S I=$O(^XMB(3.9,"I",I)) G IQ:I="" S Y=Y+1 G I:+I=0 S J=0,K=K+1
 I Y#100=0 W "." W:$X>70 !
I0 S J=$O(^XMB(3.9,"I",I,J)) G I:J="" S XMD0=^(J) K ^(J)
 S ^XMB(3.9,"AI",$P(I,"@",2)_"@"_+I,J)=XMD0,$P(^XMB(3.9,J,5),U)=$P(I,"@",2)_"@"_+I
 G I0
IQ K XMD0,XMN0,XMC0,XMM0,XMZ,XMDUZ,XMK,XMT0 D NOW^%DTC
 W !!,"<<< DONE @ " D DT W ", ",Y," PROCESSED, ",K," CHANGED >>>>>",!!
 Q
 ;
K ;KILL MAILBOXES
 K ^XMB(3.7,XMDUZ)
 G A
L ;ERROR MESSAGE: MAIL-BOXES WITH NO ZERO NODES THAT CAN'T BE AUTO-DELETED
 W !,"Mail-Box: ",XMDUZ,?25,"looks terminated (still receiving mail)."
 W !,?25,"PLEASE ANALYSE & DELETE IF APPROPRIATE"
 G B
DT D NOW^%DTC S %=$P(%,".",2)
 W $E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)," @ ",$E(%,1,2),$E(":"_$E(%,3,4)_"00",1,3)
 Q
