XTER1 ;ISC-SF.SEA/JLI - MODIFICATION OF %XTER FOR USE WITH VAX DSM ;11/6/95  16:36 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**8**;Jul 10, 1995
 S XTDV1=0
WRT S XTOUT=0 S:'$D(XTBLNK) $P(XTBLNK," ",133)=" " S:'$D(C) C=0 K:C=0 ^TMP($J,"XTER")
 D DV I '$D(%XTZLIN) S %XTY=$P(%XTZE,","),%XTX=$P(%XTY,"^") S:%XTX[">" %XTX=$P(%XTX,">",2)
 I '$D(%XTZLIN),%XTX'="" S X=$P($P(%XTY,"^",2),":") I X'="" X ^%ZOSF("TEST") I $T D
 .S XCNP=0,DIF="^TMP($J,""XTER1""," X ^%ZOSF("LOAD") S %XTY=$P(%XTX,"+",1) D
 ..I %XTY'="" F X=0:0 S X=$O(^TMP($J,"XTER1",X)) Q:X'>0  I $P(^(X,0)," ")=%XTY S X=X+$P(%XTX,"+",2),%XTZLIN=^TMP($J,"XTER1",X,0) Q
 ..I %XTY="" S X=+$P(%XTX,"+",2) Q:X'>0  S %XTZLIN=^TMP($J,"XTER1",X,0)
 S:'$D(%XTZLIN) %XTZLIN="" K ^TMP($J,"XTER1"),XCNP,DIF,%XTY,%XTX
 I %XTZLIN'="" S C=C+1,^TMP($J,"XTER",C)="",C=C+1,^(C)=%XTZLIN
 I '$D(^%ZTER(1,%XTZDAT,1,%XTZNUM,"ZV","B")) F XTI=0:0 S XTI=$O(^%ZTER(1,%XTZDAT,1,%XTZNUM,"ZV",XTI)) Q:XTI'>0  S XTSYM=^(XTI,0),^%ZTER(1,%XTZDAT,1,%XTZNUM,"ZV","B",XTSYM,XTI)=""
 I IO'=IO(0) S XTDV1=0 D DV
 S:%XTZGR'="" C=C+1,^TMP($J,"XTER",C)="",C=C+1,^(C)="Last Global Ref: "_%XTZGR D:'$G(XTMES)&'$G(XTPRNT) WRITER^XTER1A I IO'="",IO'=IO(0)!$G(XTPRNT) U IO W @IOF S X="^L" G WRTA
 I $G(XTMES) S X="^L" G WRTA
 K ^TMP($J,"XTER") S C=0 R !!,"Which symbol? > ",XTX:DTIME S:'$T!(XTX="") XTX="^" G XTERR^XTER:XTX>0!(XTX="^"),END^XTER:XTX="^Q"!(XTX="^q"),MESG^XTER1A:XTX="^M"!(XTX="^m"),PRNT^XTER1A:XTX="^P"!(XTX="^p") S X=XTX,XTX="",XTOUT=0
 I X="^I"!(X="^i") D EN^XTER1B G WRT
 I X["?" S XTF="1,2,10,7,13,14,15,8,9" D HELP^XTER G WRT
 I X="$" S XTDV1=0 D DV G WRT
 I X="^R"!(X="^r") G RESTOR^XTER2
WRTA D WRT1 S:'$D(XTX) XTX="" Q:$G(XTMES)!$G(XTPRNT)  G:IO=IO(0)&(XTX'="^Q")&(XTX'="^q") WRT U IO(0) G END^XTER:XTX="^Q"!(XTX="^q"),XTERR^XTER
 ;
WRT1 S:'$D(IOSL) IOSL=24 S C=C+1,^TMP($J,"XTER",C)="",C=C+1,^(C)="" S XTSYM=$S(X="^L":"",X="^l":"",1:X),%XTYL=IOSL-4,XTI=0,XTC=1,X="",XTA=XTSYM,XTA=$S(XTA="":"",1:$E(XTA,1,$L(XTA)-1)_$C($A($E(XTA,$L(XTA)))-1)_"z")
WF S:'%XTYL %XTYL=IOSL-4 S (XTA,XTA1)=$O(^%ZTER(1,%XTZDAT,1,%XTZNUM,"ZV","B",XTA)) S:XTA'="" XTI=$O(^(XTA,0)) I XTA=""!(XTSYM'=""&($E(XTA,1,$L(XTSYM))'=XTSYM)) S:XTSYM'=""&XTC C=C+1,^TMP($J,"XTER",C)="No such symbol" D:'$G(XTPRNT) MORE^XTER1A Q
 S XTB=$S($D(^%ZTER(1,%XTZDAT,1,%XTZNUM,"ZV",XTI,"D")):^("D"),1:"***  WARNING: this value was NOT recorded due to an ERROR WITHIN the TRAP ***")
 S XTC=0 S:'$G(XTMES)&'$G(XTPRNT) %XTYL=%XTYL-1 D:'%XTYL MORE^XTER1A Q:XTOUT  S:'%XTYL C=C+1,^TMP($J,"XTER",C)="" S XTA1=XTA1_"=" K XTC1 I XTB?.PUNL,XTB'["\" S XTA1=XTA1_XTB,XTC1=""
 I '$D(XTC1) S XTC1="" I $P(XTA1," ",2)="" F XTK=1:1 S XTZ=$E(XTB,XTK) Q:XTZ=""  S XTC1=XTC1_$S(XTZ'?1C:XTZ,1:"\"_$E($A(XTZ)+1000,2,4)) I XTZ="\" S XTC1=XTC1_"\"
SET I ($L(XTA1)+$L(XTC1))<246 S XTA1=XTA1_XTC1,XTC1="" S C=C+1,^TMP($J,"XTER",C)=XTA1 G WF
 I $L(XTA1)>245 S C=C+1,^TMP($J,"XTER",C)=$E(XTA1,1,245) S XTA1=$E(XTA1,246,$L(XTA1)) G SET
 I $L(XTA1)>0 S C=C+1,^TMP($J,"XTER",C)=XTA1_$E(XTC1,1,(245-$L(XTA1))) S XTC1=$E(XTC1,(245-$L(XTA1)+1),$L(XTC1)) G SET
 S C=C+1,^TMP($J,"XTER",C)=$E(XTC1,1,245),XTC1=$E(XTC1,246,$L(XTC1)) G SET
 G WF
 ;
DV I $D(XTDV1),XTDV1=1 G DV1
 K %XTZLIN
 S %XTZE=^%ZTER(1,%XTZDAT,1,%XTZNUM,"ZE"),%XTJOB=$G(^("J")),%XTIO=$G(^("I")),%XTZH=$G(^("ZH")),%XTZH1=$G(^("H")),%XTZGR=$G(^("GR")) S:$D(^("LINE")) %XTZLIN=^("LINE")
 I %XTZH1>0 S %H=%XTZH1 D YMD^%DTC S Y=X_% D DD^%DT S $P(%XTZH1,"^",2)=$P(Y,"@",1)_" "_$P(Y,"@",2)
 F %XTI=1:1:9 S %XTZH(%XTI)=$P(%XTZH,"^",%XTI)
 S %XTZH(3)=$P(%XTZH1,U,2)
 S %XTUCI=$P(%XTJOB,U,4)
 S C=C+1,^TMP($J,"XTER",C)="",C=C+1,^(C)="",C=C+1,^(C)="Process ID:  "_$P(%XTJOB,U,5)_"  ("_$P(%XTJOB,U)_")"
 S C=C+1,^TMP($J,"XTER",C)=$E(XTBLNK,1,79-$L(%XTZH(3)))_%XTZH(3)
 S %XTZ="Username\Process Name\UCI/VOL\\$ZA\$ZB\Current $IO\Current $ZIO\CPU time\Page Faults\Direct I/O\Buffered I/O"
 S %XTZ(1)=$P(%XTJOB,U,3),%XTZ(2)=$P(%XTJOB,U,2),%XTZ(3)=$S(%XTUCI]"":"["_%XTUCI_"]",1:""),%XTZ(4)="",%XTZ(5)=$J($P(%XTIO,U,2),3),%XTZ(6)=$J($P(%XTIO,U,3),3)
 S %XTZ(7)=$P(%XTIO,U),%XTZ(8)=$P(%XTIO,U,4,99),%XTZ(9)=$J(%XTZH(1),6),%XTZ(10)=$J(%XTZH(4),10),%XTZ(11)=$J(%XTZH(7),10),%XTZ(12)=$J(%XTZH(8),10)
 F %XTI=1:1:12 S:%XTI#2 C=C+1,^TMP($J,"XTER",C)="",X="" S X=X_$P(%XTZ,"\",%XTI)_": "_%XTZ(%XTI) S:%XTI#2 X=$E(X_$E(XTBLNK,1,40),1,40) S:'(%XTI#2) C=C+1,^TMP($J,"XTER",C)=X
DV1 S XTDV1=1 S C=C+1,^TMP($J,"XTER",C)="",C=C+1,^(C)="$ZE= "_%XTZE
 K X I $D(^%ZTER(1,%XTZDAT,1,%XTZNUM,"ZE2")) S X=^("ZE2")
 I $D(X) S C=C+1,^TMP($J,"XTER",C)="",C=C+1,^(C)="An error also occurred while logging this error -- This MAY CAUSE SOME",C=C+1,^(C)="LOCAL VARIABLES TO BE LOST.     This error was",C=C+1,^(C)="$ZE(2)= "_X
 Q
 ;
