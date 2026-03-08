XMYPOST5 ;(WASH ISC)/CAP-RESET "AI" X-REF ;7/26/90  16:23 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ;I $O(^XMB(3.9,"AI",""))'="" W !!,"   ***** RESETTING ^XMB(3.9,""AI"", X-REF *****",!,"   ***** into ^XMBX(""AI"",               *****",!!
 W *7,!!,"DON'T FORGET TO RESET TRANSLATION ON ALL NODES TO ^XMB*",!,"where previously you had translated only ^XMB",!,"(the difference is the '*' {asterisk})."
 F I=1:1:9 H 3 W *7,*7,*7,!,"."
 I '$D(^XMB(3.9,"AI")) G IZ
 W !,"Moving the 'AI' of the Message file from the XMB global to the XMBX global",!!
 ;
 S I="",Y=0,K=0
I S I=$O(^XMB(3.9,"AI",I)) G IQ:I="" S Y=Y+1,J=0,K=K+1
 I Y#100=0 W "." W:$X>70 !
I0 S J=$O(^XMB(3.9,"AI",I,J)) G I:J="" S XMD0=^(J) K ^(J)
 S ^XMBX(3.9,"AI",I,J)=XMD0
 G I0
IQ D NOW^%DTC W !!,"<<< DONE @ " D DT W ", ",Y," PROCESSED, ",K," CHANGED >>>>>",!!
IZ K XMD0,XMN0,XMC0,XMM0,XMDUZ,XMT0
 ;
 ;Add new cross reference to messages in Postmaster queues
 ;This new cross reference is there so that messages being
 ;sent to remote sites with many recipients will not have to
 ;have their entire recipient chains parsed to find the
 ;appropriate recipients.
 ;
 S XMK=1000
XMK S XMK=$O(^XMB(3.7,.5,2,XMK)) G Q:XMK>9999!'XMK
 S XMZ=0
XMZ S XMZ=$O(^XMB(3.7,.5,2,XMK,1,XMZ)) G XMK:'XMZ
 S A=9999999
A S A=$O(^XMB(3.9,XMZ,1,"C",A)) G XMZ:A="" S %=$O(^(A,0)) G A:'%
 S B=$P($G(^XMB(3.9,XMZ,1,%,0)),U,7) G A:'B,A:B+1000-XMK'=0
 S ^XMB(3.9,XMZ,1,"AQUEUE",B,%)=""
 G A
Q K %,A,B,C,X,XMK,XMZ Q
 ;
DT D NOW^%DTC S DT=X,%=$P(%,".",2)
 W $E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)," @ ",$E(%,1,2),$E(":"_$E(%,3,4)_"00",1,3)
 Q
VIRGIN ;Special note for virgin installs
 W !!!!,"*****************************************************************************",!,"IMPORTANT !!!  Translate XMB* (all the globals whose name begin with 'XMB')."
 W !,"*****************************************************************************",!
 Q
 ;
 ;PostINIT for MailMan 7.1
ENT71 W !!,"Now to delete some obsolete fields from the Data Dictionary:"
 W !?9,"*PRIORITY (1.6) from Message (3.9) file."
 S DIK="^DD(3.9,",DA=1.6,DA(1)=3.9 D ^DIK
 W !?9,"*LAST RESPONSE SEEN (6) from Mail Box (3.7) file."
 S DIK="^DD(3.7,",DA=6,DA(1)=3.7 D ^DIK
 W !!,"Reindexing the domain file.",!!
 S DIK="^DIC(4.2," D IXALL^DIK
 W !!,"This part of the INIT should not take very long."
 W !,"It creates synonyms for each domain that ends '.VA.GOV'"
 W !,"in preparation for Internet access.",!!
 N %,DA,DIE,X1,Y,XMA0,XMB0 S (XMA0,DA)=0,DIE="^DIC(4.2,"
 F  S DA=$O(^DIC(4.2,DA)) Q:DA'=+DA  S XMB0=$P(^(DA,0),U) D
 . S %=$L(XMB0,".")
 . Q:$P(XMB0,".",%-1,%)'="VA.GOV"
 . S Y=$P(XMB0,".",%-2)
 . I ":NCS:VACO:VACOWMAIL:SUP:BEN:GC:FOC-AUSTIN:FORUM:"[(":"_Y_":") Q
 . S X1=$P(XMB0,".",1,%-2)_".MED.VA.GOV"
 . I '$D(^DIC(4.2,"C",X1,DA)) S DR="5///^S X=X1" D ^DIE
 . I '$D(^DIC(4.2,"C",XMB0,DA)) S DR="5///^S X=XMB0",XMA0=XMA0+1 D ^DIE
 . I XMA0#10=0 W "."
 . Q
 W !!,"<<  Done creating synonyms for all domain !! >>" D ^%T W !!
 ;
 ;Set flag to allow Directory Requests
 S ^XMB(1,1,8.4)=1
 ;
 K DA,DIK
 Q
