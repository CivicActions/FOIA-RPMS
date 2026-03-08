XMCSIZE ;(WASH ISC)/AML-give stats of a message ;1/23/90  11:58 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
 R !,"Message number: ",XMZ:$S($D(DTIME):DTIME,1:300) Q:'$T  W !,"WORKING..." S Y=0
 S I=0 F X=0:0 S X=$O(^XMB(3.9,XMZ,2,X)) Q:X=""  S I=I+1,Y=Y+$L(^(X,0)) I I#100=0 W "." I $X>70 W !
 W !,I," Lines ","   ",Y,"  Bytes ",!
TT R !,"Transmission time in seconds:  ",%:$S($D(DTIME):DTIME,1:300) Q:%=""!(%["^")!'$T
 I %'?1.N!'% W *7,!,"   Enter a non-zero number of seconds, please.",! G TT
 W !,$J(I-1/%,15,2)," Lines/sec  ",$J(Y/%,20,2),"  Bytes/sec",!
 Q
COMP ;COMPARE TWO MESSAGES
 R !,"First message to compare: ",XMZ1:$S($D(DTIME):DTIME,1:300) Q:XMZ1=""
 R !,"Second message to compare: ",XMZ2:$S($D(DTIME):DTIME,1:300) Q:XMZ2=""
 K ^TMP($J) F O=0:1 Q:'$D(^XMB(3.9,XMZ1,2,O+1,0))  S ^TMP($J,1,O+1,0)=^(0)
 F F=0:1 Q:'$D(^XMB(3.9,XMZ2,2,F+1,0))  S ^TMP($J,2,F+1,0)=^(0)
 ;
 D ^XMPC
 Q
 ;F I=1:1 Q:'$D(^XMB(3.9,XMZ1,2,I,0))  S X=^(0),Y=^XMB(3.9,XMZ2,2,I,0) D:X'=Y CHK
 ;Q
CHK ;COMPARE DIFFERENCES
 W !,X,!!,Y Q
