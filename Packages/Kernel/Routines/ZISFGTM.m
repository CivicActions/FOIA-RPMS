%ZISF ;SFISC/AC - HOST FILES FOR GT.M on Unix/VMS  ;10 Feb 2003 6:35 pm
 ;;8.0;KERNEL;**275**;Jul 10, 1995
HFS ;Host File Server
 Q:$D(IOP)&$D(%IS("HFSIO"))&$D(%IS("IOPAR"))
 I $D(%ZIS("HFSNAME")) S IO=%ZIS("HFSNAME"),%X=IO ;
 E  D ASKHFS
H S:$D(%ZIS("HFSMODE")) %ZISOPAR=$$MODE(%ZIS("HFSMODE"))
H1 I $D(IO("Q"))!(%IS["Z") S IO("HFSIO")=""
 S IO=$S(%X]"":%X,1:IO),IO=$$CHKNM(IO) ;See that we have a directory
 S:$D(IO("HFSIO")) IO("HFSIO")=IO
 W:'$D(IOP)&$D(%ZIS("HFSNAME")) "    HOST FILE TO USE:  "_%ZIS("HFSNAME"),!
 D ASKPAR^%ZIS6,SETPAR^%ZIS3
HFSIOO I '$D(IOP),%ZTYPE="HFS",'$D(%ZIS("HFSMODE")),'$P(^%ZIS(1,%E,0),"^",4),%ZISOPAR="",$D(^%ZIS(1,%E,1)),$P(^(1),"^",6) W ?45,"INPUT/OUTPUT OPERATION: R//"
 Q:'$T  D SBR^%ZIS1 I $D(DTOUT)!$D(DFOUT)!$D(DUOUT) S POP=1 Q
 D HOPT:%X="?"!'$$CHECK(%X),HOPT1:%X="??" G HFSIOO:%X="?"!'$$CHECK(%X)
 S:%X]"" %ZISOPAR="("""_%X_""")" Q
 ;
CHECK(X) ;Check that we have valid option
 N Y,%
 Q:(X["R")&(X["W") 0 ;Can't have both
 S Y=1 F %=1:1:$L(X) I "AFNRSVW"'[$E(X) S Y=0
 Q Y
 ;
ASKHFS ;---Ask host file name here---
 I $D(%IS("B","HFS"))#2,%IS("B","HFS")]"" D
 .S IO=%IS("B","HFS") ;Set default host file name
 S %X='$P($G(^%ZIS(1,%E,1)),"^",5)
 S:'%X %X=""
 I $D(IOP)!%X!$D(%ZIS("HFSNAME")) S %X="" Q
ASKAGN W !,"HOST FILE NAME: "_IO_"//" D SBR^%ZIS1
 I %X?1."?".E W !,"ENTER HOST FILE NAME" G ASKAGN
 S:$D(DTOUT)!$D(DUOUT) POP=1
 Q
CHKNM(H) ;Check the HFS name
 N N S N=H
 I $ZV["VMS" D
 . I (H'[":")&(H'["[") S N=$$DEFDIR^%ZISH("")_H
 E  D
 . I (H'["/") S N=$$DEFDIR^%ZISH("")_H
 Q N
 ;
MODE(X) ;Return %ZISOPAR in Y.
 N Y,Q S Q=$C(34)
 S Y=$S(X["R"&(X["W"):"(VARIABLE)",X="N":"(NEWVERSION:NOREADONLY:VARIABLE)",X="W":"(NEWVERSION:NOREADONLY:VARIABLE)",X="A":"(APPEND:NOREADONLY:VARIABLE)",1:"(READONLY:VARIABLE)")
 Q Y
 ;
HOPT W !,"You may enter a string of codes that represents",!,"the following host file input/ouput operation:"
 W !?16,"R = READ ACCESS",!?16,"W = WRITE ACCESS",!?16,"N = NEWVERSION",!?16,"S = FIXED FORMAT",!?16,"V = VARIABLE FORMAT",!?16,"A = APPEND"
 W !,"Example valid groupings 'RV', 'NW', 'AWV'"
 Q
HOPT1 S %ZISI=$O(^DIC(9.2,"B","XUHFSPARAM-GUX",0)) Q:'%ZISI  Q:'$D(^DIC(9.2,+%ZISI,0))  Q:$P(^(0),"^",1)'="XUHFSPARAM-GUX"
 Q:$D(^DIC(9.2,+%ZISI,1))'>9  F %X=0:0 S %X=$O(^DIC(9.2,+%ZISI,1,%X)) Q:%X'>0  I $D(^(%X,0)) W !,^(0)
 W ! S %X="??" Q
