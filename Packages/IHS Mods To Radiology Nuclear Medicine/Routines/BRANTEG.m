BRANTEG ;ISC/XTSUMBLD KERNEL - Package checksum checker ; 16 Aug 2017  1:21 PM
 ;;5.0;Radiology/Nuclear Medicine;**1007**;Aug 14, 2017;Build 14
 ;;7.3;3170816.13201
 S XT4="I 1",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
CONT F XT1=1:1 S XT2=$T(ROU+XT1) Q:XT2=""  S X=$P(XT2," ",1),XT3=$P(XT2,";",3) X XT4 I $T W !,X X ^%ZOSF("TEST") S:'$T XT3=0 X:XT3 ^%ZOSF("RSUM") W ?10,$S('XT3:"Routine not in UCI",XT3'=Y:"Calculated "_$C(7)_Y_", off by "_(Y-XT3),1:"ok")
 ;
 K %1,%2,%3,X,Y,XT1,XT2,XT3,XT4 Q
ONE S XT4="I $D(^UTILITY($J,X))",X=$T(+3) W !!,"Checksum routine created on ",$P(X,";",4)," by KERNEL V",$P(X,";",3),!
 W !,"Check a subset of routines:" K ^UTILITY($J) X ^%ZOSF("RSEL")
 W ! G CONT
ROU ;;
BRACOMP ;;3602140
BRAPCC ;;15080283
BRAPCC2 ;;1593301
BRAPLINK ;;6726717
BRAPRAD ;;3477427
BRAWH ;;9700099
RAEDCN1 ;;7312231
RAHLO ;;17844642
RAORD1 ;;17604243
RAORD6 ;;20599273
RAORDU1 ;;25144353
RAPROD ;;17454754
RAPSET ;;11813713
RAREG2 ;;20675254
RARIC ;;3519021
RARTE7 ;;5763188
RARTR2 ;;6374309
RASTEXT1 ;;6338203
