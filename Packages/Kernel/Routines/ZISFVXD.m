%ZISF ;SFISC/AC - HOST FILES (VAX DSM) ;05/06/98  16:32 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1007**;APR 1, 2003
 ;;8.0;KERNEL;**104**;JUL 10, 1995
HFS Q:$D(IOP)&$D(%IS("HFSIO"))&$D(%IS("IOPAR"))
 I $D(%ZIS("HFSNAME")) S IO=%ZIS("HFSNAME"),%X=IO
 E  D ASKHFS
H S:$D(%ZIS("HFSMODE")) %ZISOPAR=$$MODE(%ZIS("HFSMODE"))
H1 I $D(IO("Q"))!(%IS["Z") S IO("HFSIO")=""
 S %ZHFN=$S(%X]"":%X,1:IO),%ZHFN=$$CHKNM(%ZHFN),%XX=$&ZLIB.%PARSE(%ZHFN)
 G H2:%XX["::"
 I %XX]"",$&ZLIB.%GETDVI(%XX,"DEVCLASS")="DISK"
 E  S DUOUT=1,POP=1 W:'$D(IOP) !,"HOST FILE NAME NOT VALID" Q
H2 S IO=$&ZLIB.%PARSE(%ZHFN,".DAT") I $D(IO("HFSIO")) S IO("HFSIO")=IO
 W:'$D(IOP)&$D(%ZIS("HFSNAME")) "    HOST FILE TO USE:  "_IO,!
 D ASKPAR^%ZIS6,SETPAR^%ZIS3
HFSIOO Q:$D(%ZIS("HFSMODE"))
 I '$D(IOP),%ZTYPE="HFS",'$P(^%ZIS(1,%E,0),"^",4),%ZISOPAR="",$P($G(^%ZIS(1,%E,1)),"^",6) W ?45,"INPUT/OUTPUT OPERATION: "
 Q:'$T  D SBR^%ZIS1 I $D(DTOUT)!$D(DFOUT)!$D(DUOUT) S POP=1 Q
 D HOPT:%X="?"!($F("?^R^N^RW",%X)'>1),HOPT1:%X="??"
 G HFSIOO:%X="?"!($F("?^R^N^RW",%X)'>1)
 S %ZISOPAR=$S(%X="R":"(READONLY)",%X="N":"(NEWVERSION)",1:"") Q
 ;
ASKHFS ;---Ask host file name here---
 I $D(%IS("B","HFS"))#2,%IS("B","HFS")]"" D
 .S IO=%IS("B","HFS") ;Set default host file name
 S %X='$P($G(^%ZIS(1,%E,1)),"^",5)
 S:'%X %X=""
 I $D(IOP)!%X!$D(%ZIS("HFSNAME")) S %X="",%ZHFN=IO Q
ASKAGN W !,"HOST FILE NAME: "_IO_"//" D SBR^%ZIS1
 I %X?1."?".E W !,"ENTER HOST FILE NAME" G ASKAGN
 S:$D(DTOUT)!$D(DUOUT) POP=1
 Q
ASKHFSIO(DA) ;Ask HFS Input/Output operation.
 I %ZTYPE="HFS",'$P(^%ZIS(1,DA,0),"^",4),%ZISOPAR="",$P($G(^%ZIS(1,DA,1)),"^",6) Q 1
 Q 0
 ;
CHKNM(H) ;Check HFS for dir
 I H[":"!(H["[") Q H
 Q $$DEFDIR^%ZISH("")_H
 ;
MODE(X) ;Returns OPEN parameters in Y
 N Y
 S Y=$S(X["R"&(X["W"):"",X["A":"",X="R":"(READONLY)",X="W":"(NEWVERSION)",1:"(NEWVERSION)")
 Q Y
HOPT W !,"Enter one of the following host file input/ouput operation:"
 W !,?16,"R = READONLY",!,?16,"N = NEWVERSION",!,?15,"RW = READ/WRITE",! Q
HOPT1 S %ZISI=$O(^DIC(9.2,"B","XUHFSPARAM-VXD",0)) Q:'%ZISI  Q:'$D(^DIC(9.2,+%ZISI,0))  Q:$P(^(0),"^",1)'="XUHFSPARAM-VXD"
 Q:$D(^DIC(9.2,+%ZISI,1))'>9  F %X=0:0 S %X=$O(^DIC(9.2,+%ZISI,1,%X)) Q:%X'>0  I $D(^(%X,0)) W !,^(0)
 W ! S %X="??" Q
 ;
 ;--- OPEN/CLOSE EXECUTES, PRE-OPEN and POST-CLOSE EXECUTES FOR P-MESSAGE ---
OEXPMSG Q  ;Open Execute for p-message device
CEXPMSG S XMREC="R X#255:1" U IO:DISCONNECT D ^XMAPHOST,READ^XMAPHOST K XMIO Q  ;Close Execute for p-message device
 Q
POXPMSG Q  ;Pre-open Execute for p-message device
PCXPMSG Q  ;Post-close Execute for p-message device
 ;
 ;--- OPEN/CLOSE EXECUTES, PRE-OPEN and POST-CLOSE EXECUTES FOR BROWSER DEVICE ---
OEXDDBR D OPEN^DDBRZIS Q  ;Open Execute for Browser device
CEXDDBR D CLOSE^DDBRZIS Q  ;Close Execute for Browser device
POXDDBR I '$$TEST^DDBRT S %ZISQUIT=1 W $C(7),!,"Browser not selectable from current terminal.",! Q  ;Pre-close Execute for Browser device
PCXDDBR D POST^DDBRZIS Q  ;Post-close Execute for Browser device
