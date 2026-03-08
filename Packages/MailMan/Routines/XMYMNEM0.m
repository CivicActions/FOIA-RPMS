XMYMNEM0 ;(WASH ISC)/CAP - CONVERT MAILMAN HOST #'S TO MNEMONICS ;5/22/90  13:24
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 ;;ALL;
 ;FROM GO^XMZDOM
 S XMA=0,XMA(0)=0 H 3
 ;
 ;XMC=MNEMONIC
 ;XMD(0)=OLD NUMBER
 ;XMD=DATA FROM FILE (MAILMAN HOST number)
 ;XMB=NAME (NEEDS TO BE PARSED AND ADDED TO ".VA.GOV")
 ;
A S XMA=XMA+1 G:'$D(^TMP($J,"#",XMA)) A:$O(^(XMA)),Q S X=^(XMA),XMB=$P(X,";",3),XMC=$P(X,";",4),XMD(0)=$P(X,";",5),XMA(0)=XMA(0)+1
 K XMS I XMB="",XMB?1"END".E G Q
 I XMB'?1.E1".VA.GOV",":COM:EDU:MIL:"'[(":"_$P(XMB,U,$L(XMB,U))) S XMB=XMB_".VA.GOV"
 S ^TMP($J,"!",XMB)="",XME=$O(^DIC(4.2,"B",XMB,0)),XME=$S(XME:XME,1:"ZILCH"),XMF=$S(XME="ZILCH":"",$D(^DIC(4.2,XME,0)):^(0),1:"") I XMF="" S XMS(99)="??? NO DOMAIN ON FILE"
 S XMD=$P(XMF,U,12),XMNOTE=""
 I +XMD,XMD'=XMD(0),XME'="ZILCH" S XMNOTE="(See note below)",XMS(1)="MISMATCH on Old IDCU number",XMS(2)="IDCU ("_$S($L(XMD):XMD,1:"No Entry in")_" file / "_XMD(0)_" Sent)"
 I +XMD,XMNOTE="" S XMNOTE="IDCU number matches"
 I XMD?1"MM"3N1"."2N.E S XMNOTE="MNEMONIC" I XMC=XMD S XMNOTE=XMNOTE_" matches"
 S %=$S(XMC:$D(^TMP($J,XMC)),1:0) I % S %0=^(XMC)
 I XMC S ^TMP($J,XMC)=XMB
 I % S XMS(3)="DUPLICATE MNEMONIC "_$P(%0,".")
 D HD:$Y>(IOSL-(IOSL\10#10*2))!'XMPG W !,XMB,?26,XMD(0),"  ",XMC,"  "
 I XMF0'="CHECK" S $P(XMF,U,12)=XMC,^DIC(4.2,XME,0)=XMF S XMNOTE="Converted to Mnemonic"
 I XMNOTE'="" W ?50,XMNOTE
C S X=$O(XMS(0)) G A:X=""
B W !,?40,XMS(X) S X=$O(XMS(X)) G A:X="",B
Q W !!!,XMA(0)," DOMAINS PROCESSED" G QQ:$E(XMF0)="P"
 W !!,"<<< Looking for domains that were not updated >>>",!
 S (%,Y,X)=0 F I=0:0 S %=$O(^DIC(4.2,%)) Q:+%'=%  S Y=Y+1,I=$S($D(^(%,0)):^(0),1:"") W:Y#10=0 "." I $P(I,U,12),$P(I,U,12)'?2"M"3N1"."2N.E,'$D(^TMP($J,"!",$P(I,U))) W !,$P(I,U) S X=X+1
 W !,$S(X:X_" Domains found that were not updated",1:"All domains updated"),!!,"<<< DONE >>>",!!!
 Q
QQ I '$D(ZTQUEUED) D ^%ZISC S IO="HOME" D HOME^%ZIS
 G KILL^XMYMNEM
HD S XMPG=XMPG+1 W @IOF I XMF0'="CHECK" W ?36,"IDCU Mnemomic CONVERSION"
 E  W ?35,"CHECK MAILMAN HOST NUMBERS"
 W !,?31,XMDT,?70,"PAGE: ",XMPG,!!
 W !,?29," IDCU",!,"DOMAIN",?29,"NUMBER   MNEMONIC   NOTES",!!
 Q
