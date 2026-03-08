VASITE ; IHS/DIR/AAB - TIME SENSETIVE VA STATION NUMBER UTILITY 4/22/92 ; [ 04/02/2003   8:51 AM ]
 ;;8.0;KERNEL;**1007**;APR 1, 2003
 ;;5.2;LR;**1002**;JUN 01, 1998
 ;;5.2;REGISTRATION;;JUL 29,1992
 ;THIS ROUTINE CONTAINS MODIFICATIONS BY IHS/ANMC/CLS 09/20/2000
 ;
SITE(DATE,DIV) ;
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1007
 ;THE LINE BELOW IS COMMENTED OUT
 ;Q $$SITE^HLZFUNC  ;IHS/OIRM TUC/AAB 1/29/98
 ;----- END IHS MODIFICATION
 ;       -Output= Institution file pointer^Institution name^station number with suffix
 ;
 ;       -Input (optional) date for division, if undefined will use DT
 ;       -      (optional) medical center division=pointer in 40.8
 ;
 N PRIM,SITE
 S:'$D(DATE) DATE=DT
 S:'$D(DIV) DIV=$$PRIM^VASITE(DATE)
 I DATE'?7N!DIV<0 Q -1
 S PRIM=$G(^VA(389.9,+$O(^(+$O(^VA(389.9,"AIVDT",DIV,-DATE)),0)),0))
 S SITE=$S('$P(PRIM,"^",6)&($P(PRIM,"^",4)?3N.AN):$P(PRIM,"^",4),1:-1)
 S:SITE>0 SITE=$P(^DG(40.8,DIV,0),"^",7)_"^"_$P($G(^DIC(4,$P(^DG(40.8,DIV,0),"^",7),0)),"^")_"^"_SITE
 Q SITE
 ;
ALL(DATE) ; -returns all possible station numbers 
 ;         -input date, if date is undefined, then date will be today
 ;          - output VASITE= 1 or -1 if stations exist
 ;                   VASITE(station number)=station number
 ;
 N PRIM,DIV
 S:'$D(DATE) DATE=DT
 S VASITE=-1
 S DIV=0 F  S DIV=$O(^VA(389.9,"C",DIV)) Q:'DIV  S PRIM=$G(^VA(389.9,+$O(^(+$O(^VA(389.9,"AIVDT",DIV,-DATE)),0)),0)) S:'$P(PRIM,"^",6)&($P(PRIM,"^",4)?3N) VASITE($P(PRIM,"^",4))=$P(PRIM,"^",4),VASITE=1
 Q VASITE
 ;
CHK ;  -input transform for IS PRIMARY STATION? field
 ;  -only 1 primary station number allowed per effective date
 ;
 I '$P(^VA(389.9,DA,0),"^",2) W !,"Effective Date must be entered first" K X G CHKQ
 I '$P(^VA(389.9,DA,0),"^",3) W !,"Medical Center Division must be entered first.",! K X G CHKQ
 I $D(^VA(389.9,"AIVDT1",1,-X)) W !,"Another entry Is Primary Division for this date.",! K X G CHKQ
 I 1
CHKQ I 0 Q
 ;
YN ;  -input transform for is primary facility
 I '$P(^VA(389.9,DA,0),"^",2) W !,"Effective date must be entered first!" K X Q
 I '$P(^VA(389.9,DA,0),"^",3) W !,"Medical Center Division must be entered first!" K X Q
 I $D(^VA(389.9,"AIVDT1",1,-$P(^VA(389.9,DA,0),"^",2))) W !,"Only one division can be primary division for an effective date!" K X Q
 S X=$E(X),X=$S(X=1:X,X=0:X,X="Y":1,X="y":1,X="n":0,X="N":0,1:2) I X'=2 W "  (",$S(X:"YES",1:"NO"),")" Q
 W !?4,"NOT A VALID CHOICE!",*7 K X Q
 ;
PRIM(DATE) ;  -returns medical center division of primary medical center division
 ;          - input date, if date is null then date will be today
 ;
 N PRIM
 S:'$D(DATE) DATE=DT S DATE=DATE+.24
 S PRIM=$G(^VA(389.9,+$O(^(+$O(^VA(389.9,"AIVDT1",1,-DATE)),0)),0))
 ;----- BEGIN IHS MODIFICATION - XU*8.0*1007
 ;THE LINE BELOW IS COMMENTED OUT AND REPLACED BY A NEW LINE
 ;ORIGINAL MODIFICATION BY IHS/ANMC/CLS 09/20/2000
 ;Q $S($P(PRIM,"^",4)?3N:$P(PRIM,"^",3),1:-1)
 Q $S($P(PRIM,"^",4)?4N:$P(PRIM,"^",3),1:-1)
 ;----- END IHS MODIFICATION
