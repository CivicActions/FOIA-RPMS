XMYPRE ;(WASH ISC)/CAP-PREINSTALLATION INIT ;05/20/98  07:53
 ;;7.1;MailMan;**50**;Jun 02, 1994
 I +^DD(3.5,0,"VR")<7 W !!,*7,"Kernel 7 or later must be installed !",!,"This seems to be [from ^DD(3.5,0,""VR"")]",!,"Kernel "_^("VR"),!! Q
 S X=$S($D(^DD(3.7,0,"VR")):^("VR"),1:"") I $L(X),X\1<6 G B
 ;
 ;CHECK MAILMAN VERSION / QUIT-CONT
 I $D(^XMB("POSTQUIT")) S $P(^XMB(1,1,0),U,16)=1 K ^XMB("POSTQUIT")
 ;
 S XMVER=$S($D(^DD(3.7,0,"VR")):^("VR"),1:"")
 G CONT:XMVER="" I +XMVER D ALL:XMVER<3.2,DOM,DDK1,PRE G CONT
 K DIFQ W !!,"<ERROR> XMYPRE+10^XMYPRE (MailMan pre-init) -- INIT ABORTED !",!!,"[ ^DD(3.7,0,""VR"") was defined & not equal to a previous MailMan version. ]",!!
 Q
ALL ;Data Dictionary clean up
 ;Delete old Mailbox fields
 I XMVER<4 F DA=23,24 S DIK="^DD(3.7,",DA(1)=3.7 D ^DIK
 Q
 ;Delete fields from Domain file (4.2) moved to file 4.2999
DOM F DA=7:1:15,15.4,15.5,15.6,15.7,24,25 S DIK="^DD(4.2," D ^DIK
 S DIU=4.25,DIU(0)="DS" D EN^DIU2 K DIU,DIK,DA
 F %=0:0 S %=$O(^DIC(4.2,%)) Q:+%'=%  K ^DIC(4.2,%,3)
 Q
SET S ^(.95,0)="ARRIVING",^XMB(3.7,.5,2,"B","ARRIVING",.95)=""
 Q
DDK1 ;remove old file for Message Statistics
 ;This was required only for Alpha/Beta Test sites of Kernel 7 and
 ;should go away for Kernel 8.
 S DIU=4.2999,DIU(0)="DEST" D EN^DIU2 Q
 ;
 ;The Postmaster is set up here, but it is by a call from XMYPOST
 ;because in a virgin UCI the zero node of the 3.7 file is not yet there.
PRE S X="POSTMASTER",Y=.5 D A S X="SHARED,MAIL",Y=.6 D A G P
A Q:$D(^VA(200,Y,0))
 W !!,"Creating an entry for the "_X_" in the NEW PERSON file (file 200)"
 S %=^VA(200,0),$P(%,U,4)=$P(%,U,4)+1,^(0)=%,^(Y,0)=X_"^^;",^VA(200,"B",X,Y)=""
 D NEW^XM Q
P S X=^VA(200,.5,0) I $P(X,U,3)="" S $P(^VA(200,.5,0),U,3)=";"
 I '$D(^XMB(3.7,.5,0)) S Y=.5 D NEW^XM
 I $D(XMB(3.7,.5,2,.95)) K ^(.95) D SET Q
 S Y=^XMB(3.7,.5,2,0),$P(^(0),U,3,4)=$P(Y,U,3)+1_U_($P(Y,U,4)+1) D SET Q
CONT ;W !!,"If you are initializing the entire Kernel, disregard the following, as"
 ;W !,"the MailMan initialization is being included in a much larger process."
 ;W !!,"The entire mailman initialization could take 2 to 3 hours.",!
 ;R !,"Do you wish to continue with the initialization: NO// ",X:$S($D(DTIME):DTIME,1:600) I "Nn"[$E(X) K DIFQ Q
 ;
END D OPTIONS^XM,GO^XMP W !!,"<<<< SUCCESSFUL PRE-INIT >>>>",!
Q K DIC,DIK,I,J,DA Q
 Q
NO W !,"NOT YET IMPLEMENTED" Q
B W !!,"COULD NOT CONFIRM WHICH KERNEL VERSION IS LOADED.",!
 K DIFQ Q
