%ZIS1 ;SFISC/AC,RWF -- DEVICE HANDLER (DEVICE INPUT) ;05/14/2001  15:35 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**18,49,69,104,112,199**;JUL 10, 1995
MAIN ;Called from %ZIS with a GO
 I '$D(IOP),$D(^%ZIS(1,%E,0)),'$P(^(0),"^",3) S %A=%H,%Z=^(0) D L2^%ZIS2 G EXIT
L1 ;Main Loop
 I '$D(IOP),$D(IO("Q")),POP D AQUE^%ZIS3 K:%=2 IO("Q") S:%=2 %ZISB=$S(%IS'["N":2,1:0) I %=-1 S POP=1 G EXIT
 S %E=%H,POP=0,%IS=%ZIS ;Reset %IS from %ZIS
 I %IS'["Q",$D(XQNOGO) S POP=1 W:'$D(IOP) !,*7,"OUTPUT IS NEVER ALLOWED FOR THIS OPTION" G EXIT
 D IOP:$D(IOP),R:'$D(IOP)
 G EXIT:$D(DTOUT)!$D(DUOUT)!(POP&$D(IOP)),L1:POP&'$D(IOP)
 D LKUP I %A'>0 S POP=1 D:'$D(DUOUT) MSG1 K DUOUT
 I POP G EXIT:$D(IOP),L1:'$D(IOP)
 I '$D(^%ZIS(1,%A,0)) D MSG1 K %ZISIOS S POP=1
 I POP G EXIT:$D(IOP),L1:'$D(IOP)
 S %E=%A,%Z=^%ZIS(1,%A,0),%Z1=$G(^(1))
 I $D(%ZIS("S")) N Y S Y=%E D XS^ZISX S:'$T POP=1 G G:POP
 W:'$D(IOP)&($P(%Z,"^",2)'=$I)&($P(%Z1,"^")]"") "  ",$P(%Z1,"^")
 D L2^%ZIS2
G G L1:POP&'$D(IOP)&'($D(DTOUT)!$D(DUOUT)) ;Didn't get it
 ;For type[TRM reset $X & $Y
 I 'POP,%ZTYPE["TRM",IO]"",$D(IO(1,IO)) U IO S:'(IO=IO(0)&'$D(IO("S"))&'$D(ZTQUEUED)) $X=0,$Y=0
 ;
EXIT I $D(IO)#2,IO]"",$D(IO(1,IO))#2,$D(%Z1),$P(%Z1,"^",11) S IO(1,IO,"NOFF")=1
 I 'POP,%ZIS["H" S IO(0)=IO,IO("HOME")=%ZISIOS_"^"_IO ;Make home device
 I %IS'[0,$G(IO(0))]"" U IO(0) ;Make sure return with home active
 G SETVAR:'POP!(%IS["T"),KILVAR
 ;
IOP ;Request with IOP set
 S (%ZISVT,%X)=IOP S:%X'?1.UNP %X=$$UP(%X) I %X'="Q" D SETQ Q
 S %IS=%IS_%X K IOP W %X D SETQ Q
 ;Get ready to ask user for device
R I %IS["Q",$D(XQNOGO) W !,*7,"AT THIS TIME, OUTPUT MUST BE QUEUED"
 S %A=$S($D(%IS("B")):%IS("B"),1:"HOME") ;Setup default
 I %IS["P",%A="HOME",$D(^%ZIS(1,%E,99)),$D(^%ZIS(1,+^(99),0)) S %A=$P(^(0),"^",1)
RD W !,$S($D(%IS("A")):%IS("A"),1:"DEVICE: ") W:%A]"" %A,"// " D SBR S:%X="" %X=%A S %ZISVT=%X
 I %X?2"?".E D EN2^%ZIS7 G R
 I %X?1"?".E D EN1^%ZIS7 G R
 I $D(DTOUT)!$D(DUOUT)!(%X'?.ANP)!($L($P(%X,";"))>31) S:%IS["T" IO="" S POP=1 Q
 S:%X'?1.UNP %X=$$UP(%X) D SETQ G R:$T Q
SETQ S %Y=$P(%X,";",2,9),%X=$P(%X,";",1) S:$L(";"_%Y,";/")=2 IO("P")=$P(";"_%Y,";/",2)
 I %IS["Q",%X="Q" S %X=%Y,%ZISVT=$P(%ZISVT,";",2,9),%ZISB=0,IO("Q")=1,%IS("A")="DEVICE: " S:$D(IOP) %Y=$P(%X,";",2,9),%X=$P(%X,";",1)
 I $T,'$D(IOP) W "UEUE TO PRINT ON" Q  ; Return $T value
 Q
LKUP S %ZISMY=$P(%ZISVT,";",2,999),%ZISVT=$P(%ZISVT,";")
 I %X="H" W:'$D(IOP) "ome" S %X=0
 I 0[%X!(%X="HOME")!(%X=$I) S %A=%H Q
 I $E(%ZISVT)="`",$D(IOP) S %A=+$E(%ZISVT,2,999) I $G(^%ZIS(1,%A,0))]"" Q
 S %A=0 I "P"[%X Q:$D(IOP)&('$D(^%ZIS(1,%E,99)))  I $D(^%ZIS(1,%E,99)) S %A=+^(99) Q
 I %X=" ",$D(DUZ)#2,$D(^DISV(+DUZ,"^%ZIS(1,")) S %A=^("^%ZIS(1,") Q
 S %A=+$O(^%ZIS(1,"B",%ZISVT,0)) Q:%A>0  ;mixed case lookup
 I %X'=%ZISVT S %A=+$O(^%ZIS(1,"B",%X,0)) Q:%A>0  ;uppercase lookup
 D VTLKUP^%ZIS S %A=%E Q:%A>0  ;mixed case lookup
 I %X'=%ZISVT S %ZISVT=%X D VTLKUP^%ZIS S %A=%E Q:%A>0  ;uppercase lookup
 N %XX,%YY S %XX=%X D 1^%ZIS5 S %A=+%YY Q
SBR K DFOUT,DTOUT,DUOUT R %X:$S($D(DTIME)#2:DTIME,1:300) E  W *7 S DTOUT=1 Q
 S:%X="."!(%X="^") DUOUT=1,%X="" Q
LC S %X=$$UP(%X)
 Q
LOW(%) Q $TR(%,"ABCDEFGHIJKLMNOPQRSTUVWXYZ","abcdefghijklmnopqrstuvwxyz")
UP(%) Q $TR(%,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
YN W "? ",$P("YES// ^NO// ",U,%)
RYN R %X:$S($D(DTIME):DTIME,$D(%ZISDTIM):%ZISDTIM,1:300) E  S DTOUT=1,%X=U W *7
 S:%X]""!'% %=$A(%X),%=$S(%=89:1,%=121:1,%=78:2,%=110:2,%=94:-1,1:0)
 I '%,%X'?."?" W *7,"??",!?4,"ANSWER 'YES' OR 'NO': " G RYN
 W:$X>73 ! W $P("  (YES)^  (NO)",U,%) Q
MSG1 I '$D(IOP) W ?20,*7,"  [DEVICE DOES NOT EXIST]"
 Q
SETVAR ;Come here to setup the variables for the selected device
 S:$D(IO)[0 IO="" G KILVAR:%IS["T"&(IO="")
 I $G(%Z)="" S ION="Unknown device",POP=1 G KILVAR
 S:IO'=IO(0)&($D(DUZ)#2) ^DISV(+DUZ,"^%ZIS(1,")=%E
 S ION=$P(%Z,"^",1),IOM=+%Z91,IOF=$P(%Z91,"^",2),IOSL=$P(%Z91,"^",3),IOBS=$P(%Z91,"^",4),IOXY=$P(%Z91,"^",5)
 S IOT=%ZTYPE,IOST(0)=%ZISIOST(0),IOST=%ZISIOST,IOPAR=%ZISOPAR,IOUPAR=%ZISUPAR,IOHG=%ZISHG
 S:IOF="" IOF="#" ;See that IOF has something
 K IOCPU S:$D(%ZISCPU) IOCPU=%ZISCPU G KIL
 ;
KILVAR ;Come here to restore the calling variables
 D SYMBOL^%ZISUTL(1,"%ZISOLD")
 S:'$L($G(IOF)) IOF="#" S:'$D(IOST(0)) IOST(0)=0
 ;See that all standard variables are defined
 F %I="IO","ION","IOM","IOBS","IOSL","IOST" S:$D(@%I)[0 @%I=""
 K IO("HFSIO"),IO("OPEN") I $D(%ZISCPU) S:'$D(IOCPU) IOCPU=%ZISCPU
KIL ;Final exit cleanup
 S:'POP IOS=%ZISIOS I POP K:%IS'["T" %ZISIOS I %IS["T" K IOS S:$D(%ZISIOS) IOS=%ZISIOS
 S:%IS["T" IO("T")=1 K %ZIS,%IS,%A,%E,%H,%ZISOS,%ZISV,IOP
K2 K %I,%X,%Y,%Z,%Z1,%Z91,%Z95,%ZTYPE,%ZTIME
 K %ZISCHK,%ZISCPU,%ZISI,%ZISR,%ZISVT,%ZISB,%ZISX,ZISI,%ZISHGL,%ZISHP,%ZISIO,%ZISIOS,%ZISIOM,%ZISIOF,%ZISIOSL,%ZISIOBS,%ZISIOST,%ZISIOST(0),%ZISTO,%ZISTP,%ZISHG,%ZISSIO,%ZISOPEN,%ZISOPAR,%ZISUPAR
 K %ZISMY,%ZISQUIT
 Q
