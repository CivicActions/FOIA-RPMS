XUS1B ;ISCSF/RWF - Auto sign-on ;09/16/97  09:48 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;;**59**;Feb 14, 1997
 Q
 ;
AUTOXUS() ;Do the check for XUS and Auto Sign-on
 N %,Y
 I $G(XQXFLG("ASO")) Q 0 ;Already tried once.
 G AUTO
 ;
AUTOXWB() ;Do the check for XWB and Auto Sign-on
 N %,Y
AUTO ;Common code
 I ($T(^XWBCAGNT)="")!($P(XOPT,U,18)="d") S XQXFLG("ZEBRA")=-1 Q 0 ;Disabled
 S Y=$$CHKVIP^XUS1B(),%=0 I Y>0 S XQXFLG("ASO")=1,%=$$PREF($P(XOPT,U,18),$P($G(^VA(200,Y,200)),U,18))
 I Y>0,'% S Y=0 ;No Auto signon
 Q Y
 ;
CHKVIP() ;Check for a Valid current IP
 N REF,XREF,IEN,R0,ENV,JOB,HNDL
 S IEN=0,ENV=$$ENV I $G(IO("IP"))]"" D GETHNDL(.HNDL)
 S REF=$G(IO("IP")) I REF]"" D LKUP("AS1",$P(REF,":")) Q:IEN IEN
 ;Only use IP address for lookup
 ;S REF=$G(IO("CLNM")) Q:REF["@" 0
 ;S REF=$P(REF,":") I REF]"" D LKUP2 Q:IEN IEN I REF["." D LKUP("AS2",$P(REF,".")) Q:IEN IEN
 ;S REF=$$LOW^XLFSTR(REF) I REF]"" D LKUP2 Q:IEN IEN I REF["." D LKUP("AS2",$P(REF,".")) Q:IEN IEN
 Q 0
 ;
LKUP2 ;See if we can find a workstation name
 I $D(^XUSEC(0,"AS2",REF))>0 D LKUP("AS2",REF) Q:IEN
 S XREF=$O(^XUSEC(0,"AS2",REF)) I XREF]"",$E(XREF,1,$L(REF))=REF D LKUP("AS2",XREF) Q:IEN
 Q
LKUP(XREF,LK) ;Check one X-ref
 S IX=0
 F  S IX=$O(^XUSEC(0,XREF,LK,IX)) Q:IX'>0  D CHK Q:IEN
 Q
CHK ;Could this be a good one.
 N R0,R1,JOB
 S R0=$G(^XUSEC(0,IX,0))
 ;Check handle.
 S R1=$P(R0,U,13) I R1]"",$D(HNDL(R1)) D  Q:IEN
 . L +^XWB("SESSION",IX_"~"_R1):0 I $T L -^XWB("SESSION",IX_"~"_R1) Q
 . S IEN=+R0 Q  ;Found a match
 ;I $P(R0,U,5)'=$P(ENV,U,2) Q  ;Make sure on the same VOL.
 ;I $P(R0,U,10)'=$P(ENV,U,3) Q  ;Check that on same NODE.
 ;S JOB=$P(R0,U,3) I $D(^$JOB(JOB)),IX=+$G(^XUTL("XQ",JOB,0)) S IEN=+R0 Q  ;Found a match
 Q
 ;
ENV() N Y D GETENV^%ZOSV Q Y
PREF(%1,%2) ;
 Q $S(%2]"":%2,1:%1)
GETHNDL(RET) ;Get the Handles from the Client
 N %,%1,X,XXX
 S %=$$CMD^XWBCAGNT(.XXX,"XWB GET HANDLES") Q:'%
 Q:'$O(XXX(0))
 ;build array
 S RET=0,%1=1 F %=1:1:$L(XXX(%1),"^") S X=$P(XXX(%1),"^",%) S:X]"" RET(X)="",RET=RET+1
 Q
