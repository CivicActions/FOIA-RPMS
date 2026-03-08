DINTEG03 ;ISC/XTSUMBLD KERNEL - Package checksum checker ;2980910.113755
 ;;0.0;
 ;;7.3;2980910.113755
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
DMSQF2 ;;8420650
DMSQP ;;2421661
DMSQP1 ;;3615502
DMSQP2 ;;6771316
DMSQP3 ;;11924117
DMSQP4 ;;2201117
DMSQP5 ;;5473440
DMSQP6 ;;10124629
DMSQS ;;3247125
DMSQT ;;11722705
DMSQT1 ;;1231734
DMSQU ;;10639129
