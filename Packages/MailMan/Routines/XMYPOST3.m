XMYPOST3 ;(WASH ISC)/CAP-CONVERT "L" NODES ;8/20/90  16:35 ;
VER ;;7.1;Mailman;**1003**;OCT 27, 1998
VER ;;7.1;MailMan;;Jun 02, 1994
 S XMA=0,%DT="P",X="T" D ^%DT S XMA(0)=$P(Y,".")
 W !!,"Converting LATEST DATE ACCESSED (7N) - Each dot is a Mail Box.",!!
L S XMA=$O(^XMB(3.7,XMA)) G LQ:'XMA,L:'$D(^(XMA,"L")) S A=^("L") K ^("N")
 G L:$P(A,U,2) W "." S X=$P(A," ",2)_" "_$P(A," ")_" "_$P(A," ",3) D ^%DT
 S $P(^XMB(3.7,XMA,"L"),U,2)=$S(Y>0:Y,1:XMA(0)) G L
LQ K XMA Q
