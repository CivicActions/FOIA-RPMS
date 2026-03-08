%ZOSV ;SFISC/AC - $View commands for Open M for NT.  ;09/22/2004  11:56
 ;;8.0;KERNEL;**34,94,107,118,136,215,293,284**;Jul 10, 1995
ACTJ() ;# Active jobs
 N %,V,Y S V=$$VERSION()
 I V<5 D  Q Y
 . S %=0 F Y=0:1 S %=$ZJ(%) Q:%=""
 S Y=$system.License.LUConsumed()
 Q Y
AVJ() ;# available jobs
 N %,AVJ,ZOSV,port,t,x,v,maxpid,lmflim,$ET
 S v=+$$VERSION()
 ;Cache 3 and 4
 ;maxpid: from %SS
 I v<5 D  Q AVJ
 . S $ET="",maxpid=$v($zu(40,2,118),-2,4)
 . X "S ZOSV=$ZU(5),%=$ZU(5,""%SYS"") S lmflim=$$inquire^LMFCLI,%=$ZU(5,ZOSV)" ;Get the license info
 . ;Add together the enterprise and division licenses avaliable
 . S x=$P(lmflim,";",2)+$P($P(lmflim,"|",2),";",2)
 . S t=+lmflim+$P(lmflim,"|",2) ;Check the license total
 . S AVJ=$S(t<maxpid:x,1:maxpid-$$ACTJ) ;Return the smaller of license or pid
 ;To get available jobs from Cache 5.0
 I v'<5 D  Q AVJ
 . X "S ZOSV=$ZU(5),%=$ZU(5,""%SYS"") S AVJ=$system.License.LUAvailable(),%=$ZU(5,ZOSV)"
 ;Return fixed value not known version
 Q 15
 ; 
PRIINQ() ; 
 Q 8
 ; 
UCI ;Current UCI
 S Y=$ZU(5)_","_^%ZOSF("VOL") Q
 ; 
UCICHECK(X) ;Check if valid UCI
 N Y,%
 S %=$P(X,",",1),Y=0 I $ZU(90,10,%) S Y=%
 Q Y
 ; 
GETPEER() ;Get the PEER tcp/ip address
 N PEER,NL,$ET S NL="",$ET="S $EC=NL Q NL",PEER=""
 I $$OS="VMS" S PEER=$ZF("TRNLNM","VISTA$IP")
 I '$L(PEER) S PEER=$ZU(111,0) S:$L(PEER) PEER=$A(PEER,1)_"."_$A(PEER,2)_"."_$A(PEER,3)_"."_$A(PEER,4)
 Q PEER
 ; 
SHARELIC(TYPE) ;See if can share a C/S license
 ;Type is 1 for C/S and 0 for Telnet
 N %,%N,%2,UID,%V,$ET S $ET="S $EC="""" Q",%V=$$VERSION()
 I %V<3.1 X:TYPE "S %N=$ZU(5),%2=$ZU(5,""%SYS""),%2=$$GetLic^LMFCLI,%N=$ZU(5,%N)" Q
 I %V<5 S:TYPE %=$$GetCSLic^%LICENSE S:'TYPE %=$$ShareLic^%LICENSE
 ;Per Sandy Waal 10/18/2003: With Cache' 5.0, your telnet and IP connections are now handled properly.
 I %V'<5 S %V=%V
 S $EC=""
 Q 
JOBPAR ;See if X points to a valid Job. Return its UCI.
 N ZJ S Y="",$ZT="JOBX"
 Q:'$D(^$JOB(X))  S Y=$V(-1,X),Y=$P(Y,"^",14)_","_^%ZOSF("VOL")
JOBX Q 
 ; 
NOLOG ; 
 S Y="$V(0,-2,4)\4096#2" Q
 ; 
PROGMODE() ;Check if in PROG mode
 Q $ZJ#2 
 ; 
PRGMODE ; 
 W ! S ZTPAC=$S('$D(^VA(200,+DUZ,.1)):"",1:$P(^(.1),U,5)),XUVOL=^%ZOSF("VOL")
 S X="" X ^%ZOSF("EOFF") R:ZTPAC]"" !,"PAC: ",X:60 D LC^XUS X ^%ZOSF("EON") I X'=ZTPAC W "??"_$C(7) Q
 S XMB="XUPROGMODE",XMB(1)=DUZ,XMB(2)=$I D ^XMB:$L($T(^XMB)) D BYE^XUSCLEAN K ZTPAC,X,XMB
 D UCI S XUCI=Y,XQZ="PRGM^ZUA[MGR]",XUSLNT=1 D DO^%XUCI D ^%PMODE U $I:(:"+B+C+R") S $ZT="" Q
 Q 
LGR() S $ZT="LGRX^%ZOSV"
 Q $ZR ;Last Global ref.
LGRX Q ""
 ; 
EC() Q $ZE ;Error code
 ; 
DOLRO ;SAVE ENTIRE SYMBOL TABLE IN LOCATION SPECIFIED BY X
 S Y="%" F %=0:0 S Y=$O(@Y) Q:Y=""  S %=$D(@Y) S:%#2 @(X_"Y)="_Y) I %>9 S %X=Y_"(",%Y=X_"Y," D %XY^%RCR
 Q 
 ; 
ORDER ;SAVE PART OF SYMBOL TABLE IN LOCATION SPECIFIED BY X
 S (Y,Y1)=$P(Y,"*",1) I $D(@Y)=0 F %=0:0 S Y=$O(@Y) Q:Y=""!(Y[Y1)
 Q:Y=""  S %=$D(@Y) S:%#2 @(X_"Y)="_Y) I %>9 S %X=Y_"(",%Y=X_"Y," D %XY^%RCR
 F %=0:0 S Y=$O(@Y) Q:Y=""!(Y'[Y1)  S %=$D(@Y) S:%#2 @(X_"Y)="_Y) I %>9 S %X=Y_"(",%Y=X_"Y," D %XY^%RCR
 K %,X,Y,Y1
 Q 
 ; 
PARSIZ ; 
 S X=3
 Q 
 ; 
DEVOPN ;List of Devices opened
 ;Returns variable Y. Y=Devices owned separated by a comma
 Q 
DEVOK ; 
 S Y=0,X1=$G(X1) Q:X=2  Q:(X1="HFS")!(X1="SPL")!(X1="MT")!(X1="CHAN")  ;Quit w/ OK for HFS, Spool, MT, TCP/IP
 G:X1="RES" RESOK^%ZIS6
 N $ET S $ET="D OPNERR Q"
 O X::$S($D(%ZISTO):%ZISTO,1:0) E  S Y=999 Q  ;G NOPN
 S Y=0 I '$D(%ZISCHK)!($G(%ZIS)["T") C X Q
 S:X]"" IO(1,X)="" Q
 Q 
NOPN ; 
 N ZJ S $ZT="NJ"
 S ZJ="" F %=0:0 S ZJ=$ZJ(ZJ) Q:'ZJ  D NOPN1 Q:'ZJ
 Q 
NOPN1 S Y=$V(-1,ZJ) I $P(Y,"^",3)[X_","!($P(Y,"^",3)[X_"*,") S Y=ZJ,ZJ="" Q
 Q 
NJ Q  ;NOJOB ERROR
OPNERR S $EC="",Y=-1 Q
 ; 
GETENV ;Get environment  (UCI^VOL^NODE^BOX:VOLUME)
 N %,%1 S %=$$VERSION,%1=$ZU(86),%1=$S(%<3.1:$P(%1,"*",3),1:$P(%1,"*",2))
 D UCI S Y=$P(Y,",")_"^"_^%ZOSF("VOL")_"^"_$ZU(110)_"^"_^%ZOSF("VOL")_":"_%1
 Q 
VERSION(X) ;return Cache version, X=1 - return full name
 Q $S($G(X):$P($ZV,")")_")",1:$P($P($ZV,") ",2),"("))
 ; 
OS() ;Return the OS NT, VMS, Unix
 Q $S($ZV["VMS":"VMS",$ZV["NT":"NT",$ZV["LINUX":"UNIX",1:"UNK")
 ; 
SETNM(X) ;Set name, Fall into SETENV
SETENV ;Set environment
 N Q,$ET,$ES S $ET="S $EC="""" Q"
 I $$OS="VMS" S Q=$ZF("SETPRN",$E(X,1,15))
 Q 
 ;
SID() ;System ID Ver 1
 N J1,T S T="~"
 S J1(1)=$ZU(86) ;Node specific
 S J1(2)=$ZU(5)_T_$ZU(12,"") ;namespace~directory
 ; Q "1~"_J1(1)_T_J1(2)
 Q "1~"_J1(2)
 ;
HFSREW(IO,IOPAR) ;Rewind Host File.
 S $ZT="HFSRWERR"
 C IO O @(""""_IO_""""_$S(IOPAR]"":":"_IOPAR_":1",1:":1")) I '$T Q 0
 Q 1
HFSRWERR ;Error encountered
 Q 0
LOGRSRC(OPT,TYPE,STATUS) ;record resource usage in ^XTMP("KMPR"
 Q:'$G(^%ZTSCH("LOGRSRC"))  ; quit if RUM not turned on.
 ; call to RUM routine.
 D RU^%ZOSVKR($G(OPT),$G(TYPE),$G(STATUS))
 Q 
SETTRM(X) ;Turn on specified terminators.
 U $I:(:"+T":X)
 Q 1
 ; 
T0 ; start RT clock
 S XRT0=$H Q
T1 ; store RT datum
 S ^%ZRTL(3,XRTL,+$H,XRTN,$P($H,",",2))=XRT0 K XRT0 Q
