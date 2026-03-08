%ZOSV ;ISF/STAFF - View commands & special functions (GT.M). ;05 Feb 2004 10:44 am
 ;;8.0;KERNEL;**275**;Jul 10, 1995
 ; for GT.M for VMS, version 4.3
 ;
ACTJ() ; # active jobs
 ;Keep active count in global
 Q $G(^XUTL("XUSYS","CNT"))
 ;Long way that would work
 ;N %IMAGE S %IMAGE=$ZGETJPI($J,"IMAGNAME")
 ;N Y S Y=0
 ;N %PID S %PID=0
 ;F  S %PID=$ZPID(%PID) Q:'%PID  I $ZGETJPI(%PID,"IMAGNAME")=%IMAGE S Y=Y+1
 ;Q Y
 ;
AVJ() ; # available jobs, Limit is in the OS.
 N V,J
 S V=^%ZOSF("VOL"),J=$G(^XTV(8989.3,"AMAX",V),100)
 Q J-$$ACTJ ;Use signon Max
 ;
PASSALL ;
 U $I:(PASTHRU) Q
NOPASS ;
 U $I:(NOPASTHRU) Q
 ;
GETPEER() ;Get the IP address of a connection peer
 N PEER
 S PEER=$ZTRNLNM("VISTA$IP")
 Q $S($L(PEER):PEER,$L($G(IO("GTM-IP"))):IO("GTM-IP"),1:"")
 ;
PRGMODE ;
 W ! S ZTPAC=$S($D(^VA(200,+DUZ,.1))#10:$P(^(.1),"^",5),1:""),XUVOL=^%ZOSF("VOL")
 S X="" X ^%ZOSF("EOFF") R:ZTPAC]"" !,"PAC: ",X:60 D LC^XUS X ^%ZOSF("EON") I X'=ZTPAC W "??",*7 Q
 K XMB,XMTEXT,XMY S XMB="XUPROGMODE",XMB(1)=DUZ,XMB(2)=$I D ^XMB:$L($T(^XMB)) D BYE^XUSCLEAN K ZTPAC,X,XMB
 D UCI S XUCI=Y,XQZ="PRGM^ZUA[MGR]",XUSLNT=1 D DO^%XUCI
 F  BREAK
 HALT
 ;
PROGMODE() ;
 Q 1 ; until we fix this, we're never in application mode
 ;
UCI ;
 S Y="VAH,"_^%ZOSF("VOL") Q
 ;
UCICHECK(X) ;
 Q 1
 ;
JOBPAR ;is job X valid on system, return UCI in Y.
 N $ES,$ET,J S $ET="Q:$ES>0  S Y="""" G JOBPX^%ZOSV"
 S Y=""
 S J=$ZGETJPI(X,"PRI")
 I $L(J) S Y=$P(^%ZOSF("PROD"),",")
JOBPX S $EC=""
 Q
 ;
SHARELIC(TYPE) ;Used by Cache implementations
 Q
 ;
PRIORITY ;The VA has this disabled in general.
 Q
 ;
PRIINQ() ;
 N PRI S PRI=$ZGETJPI($J,"PRI")
 Q $S(PRI=0:1,PRI=1:3,PRI=2:5,PRI=3:7,PRI=4:9,1:10)
 ;
BAUD S X="UNKNOWN" Q
 ;
LGR() Q $R ; Last global reference ($REFERENCE)
 ;
EC() ; Error Code: returning $ZS in format more like $ZE from DSM
 N %ZE
 I $ZS="" Q ""
 S %ZE=$P($ZS,",",2)_","_$P($ZS,",",4)_","_$P($ZS,",")_",-"_$P($ZS,",",3)
 Q %ZE
 ;
DOLRO ;SAVE ENTIRE SYMBOL TABLE IN LOCATION SPECIFIED BY X
 S Y="%" F  S Y=$O(@Y) Q:Y=""  D
 . I $D(@Y)#2 S @(X_"Y)="_Y)
 . I $D(@Y)>9 S %X=Y_"(",%Y=X_"Y," D %XY^%RCR
 K %X,%Y,Y Q
 ;
ORDER ;SAVE PARTS OF SYMBOL TABLE IN LOCATION SPECIFIED BY X
 ;PARTS INDICATED BY X1("NAMESPACE*")="" ARRAY
 I $D(X1("*"))#2 D DOLRO Q
 S X1="" F  S X1=$O(X1(X1)) Q:X1=""  D
 . S (Y,Y1)=$P(X1,"*") I $D(@Y)=0 F  S Y=$O(@Y) Q:Y=""!(Y[Y1)
 . Q:Y=""  S %=$D(@Y) S:%#2 @(X_"Y)="_Y) I %>9 S %X=Y_"(",%Y=X_"Y," D %XY^%RCR
 . F  S Y=$O(@Y) Q:Y=""!(Y'[Y1)  S %=$D(@Y) S:%#2 @(X_"Y)="_Y) I %>9 S %X=Y_"(",%Y=X_"Y," D %XY^%RCR
 K %,%X,%Y,Y,Y1
 Q
 ;
PARSIZ ;
 S X=3 Q
 ;
NOLOG ;
 S Y=0 Q
 ;
GETENV ;Get environment Return Y='UCI^VOL^NODE^BOX LOOKUP'
 N %V,%HOST S %HOST=$ZGETSYI("NODENAME"),%V=^%ZOSF("PROD")
 S Y=$TR(%V,",","^")_"^"_%HOST_"^"_$P(%V,",",2)_":"_%HOST
 Q
 ;
VERSION(X) ;return OS version, X=1 - return OS
 Q $S($G(X):$P($ZV," V"),1:+$P($ZV," V",2))
 ;
RTNDIR() ;
 Q $P($ZRO,",")
 ;
SETNM(X) ;Set name, Trap dup's, Fall into SETENV
 N $ETRAP S $ETRAP="S $ECODE="""" Q"
 ;
SETENV ;Set environment X='PROCESS NAME^ '
 ;workaround for GT.M
 S ^XUTL("XUSYS",$J,0)=$H,^("NM")=X,^("PID")=$$FUNC^%DH($J)
 Q
 ;
SID() ;System ID
 N J1,T S T="~"
 S J1(1)=$ZROUTINES
 S J1(2)=$ZGBLDIR
 Q "1~"_J1(1)_T_J1(2)
 ;
T0 ; start RT clock <=====
 Q  ; we don't have $ZH on GT.M
 ;
T1 ; store RT datum w/ZHDIF <=====
 Q  ; we don't have $ZH on GT.M
 ;
ZHDIF ;Display dif of two $ZH's <=====
 W !," CPU=",$J($P(%ZH1,",")-$P(%ZH0,","),6,2)
 W ?14," ET=",$J($P(%ZH1,",",2)-$P(%ZH0,",",2),6,1)
 W ?27," DIO=",$J($P(%ZH1,",",7)-$P(%ZH0,",",7),5)
 W ?40," BIO=",$J($P(%ZH1,",",8)-$P(%ZH0,",",8),5),! ; so far this won't be called
 Q
 ;
 ;Code moved to %ZOSVKR, Comment out if needed.
LOGRSRC(OPT,TYPE,STATUS) ;record resource usage in ^XTMP("KMPR"
 Q:'$G(^%ZTSCH("LOGRSRC"))  ; quit if RUM not turned on.
 ; call to RUM routine.
 D RU^%ZOSVKR($G(OPT),$G(TYPE),$G(STATUS))
 Q
 ;
SETTRM(X) ;Turn on specified terminators.
 U $I:TERM=X
 Q 1
 ;
DEVOK ;
 ;INPUT:  X=Device $I, X1=IOT -- X1 needed for resources
 ;OUTPUT: Y=0 if available, Y=job # if owned
 ; Y=-1 if device does not exists.
 ; return Y=0 if not owned, Y=$J of owning job, Y=999 if dev cycling
 ;
 S Y=0,X1=$G(X1) Q:(X1="HFS")!(X1="MT")!(X1="CHAN")
 I X1="RES" G RESOK^%ZIS6
 S Y=0
 Q  ;Let ZIS deal with it.
 ;
 Q
LPC(X) ;ZCRC(X)
 N R,I
 S R=$ZBITSTR(8,0)
 F I=1:1:$L(X) S R=$ZBITXOR(R,$C(0)_$E(X,I))
 Q $A(R,2)
