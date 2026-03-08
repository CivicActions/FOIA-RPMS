ZU ;SF/JLI,RWF - For GT.M, TIE ALL TERMINALS TO THIS ROUTINE!! ;11/24/2003  11:34
 ;;8.0;KERNEL;**275**;Jul 10, 1995
 ; for GT.M for VMS & Unix, version 4.3
 ;
 ;The env var ZINTRRUPT should be set to catch all interrupts.
EN ;See that escape processing is off, Conflict with Screenman
 U $P:(NOCENABLE:NOESCAPE)
 D:+$G(^%ZTSCH("LOGRSRC")) LOGRSRC^%ZOSV("$LOGIN$")
 N $ESTACK,$ETRAP S $ETRAP="D ERR^ZU Q:$QUIT -9 Q"
 S $ZINTERRUPT="I $$JOBEXAM^ZU($ZPOSITION)"
 D COUNT^XUSCNT(1)
 G ^XUS
 ;
G ;Entry point for GUI device.
 Q
 ;
ERR ;Come here on error
 ; handle stack overflow errors specially
 I $P($ZS,",",3)["STACKOFLOW" S $ET="Q:$ST>"_($ST-8)_"  D ERR2^ZU" Q
 ;
ERR2 S $ETRAP="D UNWIND^ZU" L  U $P:NOCENABLE
 ;
 Q:$ECODE["<PROG>"
 I $P($ZS,",",2,3)["^XUS1A:2, %GTM-E-IOWRITERR" G HALT
 ;
 I $G(IO)]"",$D(IO(1,IO)),$E($G(IOST))="P" D
 . U IO
 . W @$S($D(IOF):IOF,1:"#")
 I $G(IO(0))]"" D
 . U IO(0)
 . W !!,"RECORDING THAT AN ERROR OCCURRED ---"
 . W !!?15,"Sorry 'bout that"
 . W !,*7
 . W !?10,"$STACK=",$STACK,"  $ECODE=",$ECODE
 . W !?10,"$ZSTATUS=",$ZSTATUS
 ;
 D ^%ZTER K %ZT S XUERF="" ; Capture symbol table first!
 ;
 I $G(DUZ)'>0 G HALT
 ;
CTRLC I $D(IO)=11 U IO(0) C:IO'=IO(0) IO S IO=IO(0)
 W:$P($ZS,",",3)["-CTRLC" !,"--Interrupt Acknowledged",!
 D KILL1^XUSCLEAN ;Clean up symbol table
 S $ECODE=",<<POP>>,"
 Q
 ;
UNWIND ;Unwind the stack
 Q:$ESTACK>1  G CONT:$ECODE["<<HALT>>",CTRLC2:$ECODE["<<POP>>"
 S $ECODE=""
 Q
 ;
CTRLC2 S $ECODE="" G:$G(^XUTL("XQ",$J,"T"))<2 ^XUSCLEAN
 S ^XUTL("XQ",$J,"T")=1,XQY=$G(^(1)),XQY0=$P(XQY,"^",2,99)
 G:$P(XQY0,"^",4)'="M" CTRLC2
 S XQPSM=$P(XQY,"^",1),XQY=+XQPSM,XQPSM=$P(XQPSM,XQY,2,3)
 G:'XQY ^XUSCLEAN
 S $ECODE="",$ETRAP="D ERR^ZU Q:$QUIT 0 Q"
 U $P:NOESCAPE G M1^XQ
 ;
HALT I $D(^XUTL("XQ",$J)) D:$G(DUZ)>0 BYE^XUSCLEAN
 D COUNT^XUSCNT(-1)
 I '$ESTACK G CONT
 S $ETRAP="D UNWIND^ZU" ;Set new trap
 S $ECODE=",<<HALT>>," ;Cause error to unwind stack
 D:+$G(^%ZTSCH("LOGRSRC")) LOGRSRC^%ZOSV("$LOGOUT$")
 Q
CONT ;
 S $ECODE="",$ETRAP=""
 D:+$G(^%ZTSCH("LOGRSRC")) LOGRSRC^%ZOSV("$LOGOUT$")
 I $D(XQXFLG("HALT")) HALT
 I ($PRINCIPAL["_TNA") HALT  ;Check for TelNet
 S X="Waiting "_($J#1000000) D SETENV^%ZOSV ;Change VMS name
 ;For sites that want to retain the connection, uncomment the next line
 ;U $P:NOCENABLE R !,"Enter return to continue: ",X:600 S:'$T X="^" G:X'="^" ^ZU
 HALT
 ;
JOBEXAM(%ZPOS) ;
 N %reference S %reference=$REFERENCE
 S ^XUTL("XUSYS",$J,0)=$H,^XUTL("XUSYS",$J,"INTERRUPT")=$G(%ZPOS)
 I %ZPOS["^" S ^XUTL("XUSYS",$J,"codeline")=$T(@%ZPOS)
 K ^XUTL("XUSYS",$J,"JE")
 I $G(^XUTL("XUSYS","COMMAND"))'="EXAM" ZSHOW "SD":^XUTL("XUSYS",$J,"JE")
 I $G(^XUTL("XUSYS","COMMAND"))="EXAM" ZSHOW "*":^XUTL("XUSYS",$J,"JE")
 I $G(^XUTL("XUSYS",$J,"CMD"))="HALT" ;To do.
 Q 1
 ;
