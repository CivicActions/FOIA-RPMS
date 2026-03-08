XMUT5B ;(WASH ISC)/CAP-DELIVERY QUEUE ANALYSIS ;01/09/98  09:55
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ;;XX.XX
 ;
 ;M("O") & R("O") = frequency ^ oldest in group
 ;M("T") & R("T") = same as "O" above except for all messages/responses
GO ;S X="USERY^XMUT5B",@^%ZOSF("TRAP"),X=$ZC(%SPAWN,"SUBMIT/QUE=FORUM7_BATCH LEEUSER.COM")
GP F I=1:1:10 S M("O",I)=0,R("O",I)=0
 S M("T")=0
 F I=1:1:10 I $D(^XMBPOST("M",I)) D M
 S R("T")=0
 F I=1:1:10 I $D(^XMBPOST("R",I)) D R
 ;
 Q
M S %0=$G(^(I)),%=$O(^XMBPOST("M",I,0)),M("O",I)=+%0_"^"_%_"^"_$P(%0,U,2),$P(M("T"),U)=$P(M("T"),U)+%0,$P(M("T"),U,3)=$P(M("T"),U,3)+$P(%0,U,2) I $S('$P(M("T"),U,2):1,$P(M("T"),U,2)>%:1,1:0) S $P(M("T"),U,2)=%
 Q
R S %0=$G(^(I)),%=$O(^XMBPOST("R",I,0)),R("O",I)=+%0_"^"_%_"^"_$P(%0,U,2),$P(R("T"),U)=$P(R("T"),U)+%0,$P(R("T"),U,3)=$P(R("T"),U,3)+$P(%0,U,2) I $S('$P(R("T"),U,2):1,$P(R("T"),U,2)>%:1,1:0) S $P(R("T"),U,2)=%
 Q
USERS(%) ;Get the number of ZSLOT users
 ;%=1 do not display output, %=0 display
 N X,A,B,C,Y,Z,ZSLOTDSP S ZSLOTDSP=%
 ;
 ;First -- is the ZSLOT software installed ?
 S X="ZSLOT" X ^%ZOSF("TEST") E  S %=0 G USERQ
 ;
 ;Call ZSLOT for count of ZSLOT users
 S %="N/A" I $T(ENTCLUST^ZSLOT)'="" D ENTCLUST^ZSLOT S %=Y
USERQ Q %
