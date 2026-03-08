ZIBER1 ;BFH;MSM ERROR REPORT PART II;7/19/83 [ 07/13/1999  11:40 AM ]
 ;;3.0;IHS/VA UTILITIES;**7**;JULY 13, 1999
 ;COPYRIGHT MICRONETICS DESIGN CORP @1985
QUE ;ENTRY POINT FOR QUESTION MARK RESPONSE
 W !!,"ENTER:" F %J=1:1 S %K=$P(%XQF,",",%J) Q:%K=""  W !,?7,$P($T(@%K),";",2)
 W ! K %J,%K,%L,%XQF Q
1 ;'^Q' to exit this utility.
2 ;<RETURN> or '^' to return to the last question.
3 ;An option number, or
4 ;'^' or '^Q' or <RETURN> to exit this utility.
6 ;'S' to display a summarized listing of errors.
7 ;'D' to display individual errors and symbols on the screen.
8 ;'P' to print a detailed list of errors logged during a range of dates.
9 ;'E' to erase errors logged during a range of dates.
10 ;'^L' to obtain a list of all symbols.
11 ;date as 'MM/DD/YY' or, 'T' (today) or, 'T-1' (yesterday), etc.
12 ;two dates, in either format, separated by ":", for range of dates,
13 ;name of symbol to be displayed.
14 ;number of error desired.
15 ;'^S' to set symbols into the symbol table of this partition,
16 ;     and exit this utility.
17 ;'^' to return to the last question.
18 ;'^L' to list all errors for this date.
19 ;number of the device on which to print errors.
20 ;example:  6/7/83:6/30/83 for period between June 7th and 30th inclusive.
PRINT S %DEL=0,%SUM=0,%DIS=0 ;ENTRY POINT TO PRINT ERROR LIST
DAT S $Y=25,%PG=0 R !!,"Enter date(s) > ",%X G OPT^ZIBER:"^"[%X&('%DEL),DELXIT:"^"[%X&%DEL,EXIT:%X="^Q",DINFO1^ZIBER:%X="?"
 S %D2=$P(%X,":",2),%X=$P(%X,":",1) D DCHK G:%QF DAT S %D1=%DAT I %D2'="" S %X=%D2 D DCHK G:%QF DAT S %D2=%DAT
 I %D2'=""&(%D2'>%D1) W "  Earlier date must be first" G DAT
 S %NE1=-1
 S %NE=$D(^UTILITY("%ER",%DAT,0)),%DAT=%D1,%NE1=$N(^UTILITY("%ER",%DAT))
 I ('%NE)&(%D2="") D E1^ZIBER G DAT
 I ('%NE)&(%NE1=-1) D E2^ZIBER G DAT
 G:%DEL DEL
DEV D P0^%SDEV G:$D(QUIT) DAT
 S %X=%DEV
 I %DEV>50,%DEV<55 G DEV:$D(QUIT),DAT1:$D(%SUM),DAT
 I %DEV>58,%DEV<63 G DEV:$D(QUIT),DAT1:$D(%SUM),DAT
 O %X::1 E  W !!,"Device busy" G DEV
DAT1 S %PG=0,%RDTE=$ZD($H),%T=$H,%T=$P(%T,",",2),%H=%T\3600,%M=%T-(%H*3600)\60,%AP=$S(%H>11:"PM",1:"AM"),%H=%H-(12*(%H>12)) S:%M<10 %M="0"_%M S %RTME=%H_":"_%M_" "_%AP K %AP,%H,%M,%T
 U %DEV D PRT W # U 0 G DAT
PRT I %D2 S %DAT=%D1-1 S %X=$N(^UTILITY("%ER",%DAT)) G:%X>0&(%X<(%D2+1)) DATLOOP U 0 W !!,"No errors logged between ",$ZD(%D1)," and ",$ZD(%D2),! Q
 I '$D(^UTILITY("%ER",%D1)) U 0 W !!,"No errors logged on ",$ZD(%D1) Q
 I %DEL K ^UTILITY("%ER",%D1) Q
 S %DAT=%D1 G ERR
DATLOOP S %DAT=$N(^UTILITY("%ER",%DAT)) Q:%DAT>%D2!(%DAT<0)  G:%DEL DEL1 D ERR G DATLOOP
ERR I $D(%AZ("PACKAGE")) D TMD Q:'%AZ("PHIT")
 S %NE=^UTILITY("%ER",%DAT,0),%NUM=0,FLG=0
ERR1 S %NUM=%NUM+1 Q:%NUM>%NE!(FLG=1)  U %DEV D HD
 I %SUM S %I=-1,FLG=0 W !! F %I=1:1:%NE U 0 D:$Y>20&(%DEV=$I) NPAGE Q:FLG=1  D
 .I $D(%AZ("PACKAGE")) S %AZ("P")=%I D TMD2 Q:'%AZ("PHIT")
 .U %DEV W ?5,%I,")  ",^UTILITY("%ER",%DAT,%I,0),! S %NUM=%NE+1
 I $D(%AZ("PACKAGE")) G ERR1
 I %DEV=$V(8,$J,2) I %SUM I FLG=0 I %DEV=$I W !,"Enter <RETURN> to continue" R *%X F %Y=$X:-1:1 W *8,*32,*8
 I %SUM G ERR1
 I '$D(^UTILITY("%ER",%DAT,%NUM,0)) W !,"Error number ",NUM," not on file" G ERR1
WF S %I=-1 W !!#
WF1 S %I=$N(^(%I)) I %I>(1E6)!(%I<0) G:'%DIS ERR1 W:%FND=1 !,"Symbol not defined" G:'$D(%LIST) WRT^ZIBER Q
 G WF1:%I=100
WS S %A=$P(^(%I),"=",1),%B=$P(^(%I),"=",2,999)
 I %A?1";".E S %A=$P(%A,";",2) G:$D(^(1E8+99-%I))>1 LONG S %B=^(1E8+99-%I) ; OLD WAY FOR LOCALS '> 255 CHARACTERS
WS1 I %DIS I %SYM'="",$E(%A,1,$L(%SYM))'=%SYM G WF1
 S:%DIS %FND=%FND+1 S %DUM=%B'?.PAN
 D:$Y>18 NPAGE
 G:FLG=1 ERR^ZIBER
 W %A,"=""" I '%DUM W %B,"""",! G WF1
 F %K=1:1:$L(%B) S %Z=$E(%B,%K) S %TAG=$S(%Z?1C:"A",1:"B") D @%TAG
 W """",! G WF1
A W "\",$E($A(%Z)+1000,2,4) Q
B W %Z Q
HD I '$D(%AZ("PACKAGE")) S %PG=%PG+1 H 1 W #!!?14,"UCI '",%UCI,"' ERRORS ON ",$ZD(%DAT),?60," PAGE ",%PG,!,?18,"(RUN ",%RDTE,"  ",%RTME,")",! G HD1:%SUM
 E  I $Y>20 S %PG=%PG+1 W #!!?10,"UCI '",%UCI,"' ERRORS for ",%AZ("PACKAGE")," namespace",?60," PAGE ",%PG,!,?18,"(RUN ",%RDTE,"  ",%RTME,")",! G HD1:%SUM
 W !,"ERROR NUMBER ",%NUM," OF ",%NE," LOGGED ON ",$ZD(%DAT) Q
HD1 I %SUM W !,%NE,$S(%NE=1:" ERR0R ",1:" ERR0RS "),"LOGGED ON ",$ZD(%DAT) W:%NE=1 ! Q
 W !! G WS
EXIT W # G EXIT^ZIBER
DELETE S %DEL=1,%SUM=0,%DIS=0 G DAT ;ENTRY POINT TO DELETE ERRORS
DEL I '%D2,'$D(^UTILITY("%ER",%D1)) W !!,"No errors logged on ",$ZD(%D1),! G DAT
 I %D2 S %X=$N(^UTILITY("%ER",%D1-1)) I %X<0!(%X>%D2) U 0 W !!,"No errors logged between ",$ZD(%D1)," and ",$ZD(%D2),! G DAT
 W !!,"Are you sure you want to delete all errors logged ",$S('%D2:"on "_$ZD(%D1),1:"from "_$ZD(%D1)_" to "_$ZD(%D2)) R " ? ",%X
 G OPT^ZIBER:%X?1"N".E,EXIT:%X="^Q",DAT:%X="^" I %X'?1"Y".E W !,"Please answer Yes or No" G DEL
 D PRT W !!,"ERRORS DELETED"
DELXIT G OPT^ZIBER
DEL1 W "." K ^UTILITY("%ER",%DAT) G DATLOOP
DCHK S %QF=0 I %X="T"!(%X?1"T-".N) S %DAT=$H-$P(%X,"-",2) Q
 ; begin Y2K fix block
 ;I %X'?1N.N1"/"1N.N1"/"2N W "   Incorrect format -> ",%X S %QF=1 Q
 ;S %M=+%X,%D=+$P(%X,"/",2),%Y=+$P(%X,"/",3)
 ;I %Y<70!(%Y>99)!(%M<1)!(%D<1)!(%M>12) W " ..Invalid date -> ",%X S %QF=1 Q
 ;S %B=%Y*365+(%Y-1\4)+%D+21549,%A=0
 ;F %I=2:2:%M+%M S %B=%B+%A,%A=$E("312831303130313130313031",%I-1,%I) I %I=4,'(%Y#4) S %A=%A+1
 ;I %D>%A W "  Month has only ",%A," days",! S %QF=1 Q
 N X,%DT,%H,%T,%Y
 S X=%X D ^%DT I Y<0  W "   Incorrect format -> ",%X S %QF=1 Q
 S X=+Y D H^%DTC S %DAT=%H
 ;S %DAT=%B K %A,%B,%D,%M,%Y Q
 ; end Y2K fix block
 Q
 ; end Y2K fix block
LONG ; LONG LOCALS IN MSM-UNIX,MSM-PC,MSM-09 (VERSION >= 3.0)
 S %B="" F %J=1:1 Q:'$D(^UTILITY("%ER",%DAT,%NUM,(1E8+99-%I),%J))  S %B=%B_^(%J)
 I $D(^UTILITY("%ER",%DAT,%NUM,1E8+99-%I)) ; SET NAKED
 G WS1 ;RESUME PROCESSING OF LOCAL
NPAGE Q:%DEV'=$V(8,$J,2)  R "Enter <RETURN> to Continue ",X F %Y=$X:-1:1 W *8,*32,*8
 D:$D(%AZ("PACKAGE")) HD
 S:X="^" FLG=1 S $Y=0 Q
 ;
TMD S %AZ("PHIT")=0
 S %AZ("P")=0 F  S %AZ("P")=$O(^UTILITY("%ER",%DAT,%AZ("P"))) Q:'%AZ("P")  D TMD2 Q:%AZ("PHIT")
 Q
 ;
TMD2 S %AZ("PHIT")=0
 I $P(^UTILITY("%ER",%DAT,%AZ("P"),0),"^")["<INRPT>" Q
 I $P(^UTILITY("%ER",%DAT,%AZ("P"),0),"^",2)[%AZ("PACKAGE") S %AZ("PHIT")=1 Q
 S %AZ("PZ")=100 F  S %AZ("PZ")=$O(^UTILITY("%ER",%DAT,%AZ("P"),%AZ("PZ"))) Q:'%AZ("PZ")  I $G(^(%AZ("PZ")))]"",$P(^(%AZ("PZ")),"=")[%AZ("PACKAGE") S %AZ("PHIT")=1 Q
 Q
