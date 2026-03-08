DINIT21 ;SFISC/GFT-INITIALIZE VA FILEMAN ;9/8/94  11:15 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
DD F I=1:1 S X=$T(DD+I),Y=$P(X," ",3,99) Q:X?.P  S D="^DD(""OS"","_$E($P(X," ",2),3,99)_")" S @D=Y
 ;;0 MUMPS OPERATING SYSTEM^.7
 ;;8,0 MSM^^127^5000^^1^63
 ;;8,1 B X
 ;;8,"SDP" O @("DIO:"_DLP) F %=0:0 U DIO R % Q:$ZA=X&($ZB>Y)!($ZA>X)  U IO W:$A(%)'=12 ! W %
 ;;8,"SDPEND" S X=$ZA,Y=$ZB
 ;;8,"XY" U $I:(::::::IOY*256+IOX)
 ;;8,8 X ^DD("$O")
 ;;8,18 I $D(^ (X))
 ;;8,"ZS" ZR  X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  ZI ^(%Y)" ZS @X
 ;;9,0 DTM-PC^^127^5000^^1^115^4095
 ;;9,1 B X
 ;;9,8 D:$P($ZVER,"/",2)<4 ^%VARLOG X:$P($ZVER,"/",2)'<4 ^DD("$O")
 ;;9,18 I $ZRSTATUS(X)'=""
 ;;9,"SDP" O @("DIO:"_"(""R"":"_$P(DLP,":",2,9)) F %=0:0 U DIO R % Q:$ZIOS=3  U IO W:$A(%)'=12 ! W %
 ;;9,"SDPEND" Q
 ;;9,"XY" S $X=IOX,$Y=IOY
 ;;9,"ZS" S %X="" X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  S %X=%X_$C(10)_^(%Y)" ZS @X:$E(%X,2,999999)
 ;;16,0 DSM for OpenVMS^^108^5000^^1^63^255
 ;;16,1 U @("$I:"_$P("NO",1,'X)_"CENABLE")
 ;;16,8 D DOLRO^%ZOSV
 ;;16,18 I $D(^ (X))!$D(^!(X))
 ;;16,"SDP" O DIO U DIO:DISCONNECT F %=0:0 U DIO R % Q:%="#$#"  U IO W:$A(%)'=12 ! W %
 ;;16,"SDPEND" W !,"#$#",! C IO
 ;;16,"XY" U $I:(NOCURSOR,X=IOX,Y=IOY,CURSOR)
 ;;16,"ZS" ZR  X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  ZI ^(%Y)" ZS @X
 ;;17,0 GT.M(VAX)^^120^99999^^1^64
 ;;17,1 U @("$I:"_$P("NO",1,'X)_"CENABLE")
 ;;17,8 X ^DD("$O")
 ;;17,18 I $ZSEARCH(X_".M")'=""
 ;;17,"SDP" O DIO F  U DIO R % Q:%="#$#"  U IO W:$A(%)'=12 ! W %
 ;;17,"SDPEND" W !,"#$#",! C IO
 ;;17,"XY" S $X=IOX,$Y=IOY
 ;;17,"ZS" O X:NEWV S %Y="" F  S %Y=$O(^UTILITY($J,0,%Y)) C:%Y="" X Q:%Y=""  U X W ^(%Y),!
 ;;18,0 M/SQL^^120^8000^^1
 ;;18,1 B X
 ;;18,8 X ^DD("$O")
 ;;18,18 I $D(^ROUTINE(X))>1
 ;;18,"SDP" C DIO O DIO F %=0:0 U DIO R % Q:%="#$#"  U IO W %
 ;;18,"SDPEND" W !,"#$#",! C IO
 ;;18,"XY" S $Y=IOY,$X=IOX
 ;;18,"ZS" ZR  X "S %Y=0 F  S %Y=$O(^UTILITY($J,0,%Y)) Q:%Y=""""  Q:'$D(^(%Y))  ZI ^(%Y)" ZS @X
 ;;100,0 OTHER^^40^5000
 ;;100,1 Q
