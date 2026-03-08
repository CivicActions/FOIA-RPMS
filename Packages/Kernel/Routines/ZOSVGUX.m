%ZOSV ;SFISC/AC,PUG/TOAD,HOU/DHW - View commands & special functions. ;09/03/2003  15:34
 ;;8.0;KERNEL;**275**;Jul 10, 1995
 ;
ACTJ() ; # active jobs
 Q $G(^XUTL("XUSYS",0))
 ;This would also work
 N %FILE S %FILE=$$TEMP_"zosv_actj_"_$J_".tmp"
 ZSYSTEM "ps cef -C mumps|wc>"_%FILE
 N %I S %I=$I
 O %FILE
 U %FILE R Y U %I
 C %FILE:DELETE
 F  Q:$E(Y)'=" "  S $E(Y)=""
 S Y=Y-1
 Q Y
 ;
RTNDIR() ; primary routine source directory
 ;Assume /home/xxx/o(/home/xxx/r /home/gtm)
 Q $P($S($ZRO["(":$P($P($ZRO,"(",2),")"),1:$ZRO)," ")_"/"
 ;
TEMP() ; Return path to temp directory
 ;N %TEMP S %TEMP=$P($$RTNDIR," "),%TEMP=$P(%TEMP,"/",1,$L(%TEMP,"/")-2)_"/t/"
 Q $G(^%ZOSF("TMP"),"/tmp/")
 ;
AVJ() ; # available jobs
 Q $G(^%ZTSCH("MAXJOBS"),1000)-$$ACTJ
 ;
PASSALL ;
 U $I:(PASTHRU) Q  ; <=====
NOPASS ;
 U $I:(NOPASTHRU) Q  ; <=====
 ;
GETPEER() ;Get the IP address of a connection peer
 Q $S($L($G(IO("GTM-IP"))):IO("GTM-IP"),1:"")
 ;
PRGMODE ; <=====
 W ! S ZTPAC=$S($D(^VA(200,+DUZ,.1))#10:$P(^(.1),"^",5),1:""),XUVOL=^%ZOSF("VOL")
 S X="" X ^%ZOSF("EOFF") R:ZTPAC]"" !,"PAC: ",X:60 D LC^XUS X ^%ZOSF("EON") I X'=ZTPAC W "??",*7 Q
 K XMB,XMTEXT,XMY S XMB="XUPROGMODE",XMB(1)=DUZ,XMB(2)=$I D ^XMB:$L($T(^XMB)) D BYE^XUSCLEAN K ZTPAC,X,XMB
 D UCI S XUCI=Y,XQZ="PRGM^ZUA[MGR]",XUSLNT=1 D DO^%XUCI B  ; then this used to ZESCAPE, but we need something new
 E  S $ECODE=",<<PROG>>,"
 ;
PROGMODE() ; <=====
 Q 1 ; until we fix this, we're never in application mode
 ;
UCI ;
 S Y=^%ZOSF("PROD") Q
 ;
UCICHECK(X) ;
 Q X
 ;
JOBPAR ; <=====
 N %FILE S %FILE=$$PWD^%ZISH_"zosv_jobpar_"_$J_".tmp"
 ZSYSTEM "ps c -p "_X_"|tail -1>"_%FILE
 N %I S %I=$I
 O %FILE
 U %FILE R Y U %I
 C %FILE:DELETE
 F  Q:$E(Y)'=" "  S $E(Y)=""
 I +Y=X,$E(Y,$L(Y)-4,$L(Y))="mumps" S Y="VAH,ROU"
 E  S Y=""
 Q
 ;
PRIORITY ; <=====
 K Y ; Wally has this disabled in general, but I'd like to bring it back
 Q
 ;
PRIINQ() ; <=====
 Q 5 ; for now, we're always middle of the road
 ;
BAUD S X="UNKNOWN" Q
 ;
LGR() ; Last global reference ($REFERENCE)
 Q $R
 ;
EC() ; Error Code: returning $ZS in format more like $ZE from DSM
 N %ZE
 I $ZS="" S %ZE=""
 S %ZE=$P($ZS,",",2)_","_$P($ZS,",",4)_","_$P($ZS,",")_",-"_$P($ZS,",",3)
 Q %ZE
 ;
DOLRO ;SAVE ENTIRE SYMBOL TABLE IN LOCATION SPECIFIED BY X
 S Y="%" F  S Y=$O(@Y) Q:Y=""  D  ;code from DEC
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
 N %HOST,%V S %V=^%ZOSF("PROD"),%HOST=$$RETURN("hostname -s")
 S Y=$TR(%V,",","^")_"^"_%HOST_"^"_$P(%V,",",2)_":"_%HOST
 Q
 ;
VERSION(X) ;return OS version, X=1 - return OS
 Q $S($G(X):$P($ZV," V"),1:+$P($ZV," V",2))
 ;
SETNM(X) ;Set name, Trap dup's, Fall into SETENV
 N $ETRAP S $ETRAP="S $ECODE="""" Q"
 ;
SETENV ;Set environment X='PROCESS NAME^ '
 S ^XUTL("XUSYS",$J,0)=$H,^("NM")=X ; workaround
 Q
 ;
SID() ;System ID
 N J1,T S T="~"
 S J1(1)=$ZROUTINES,J1(1)=$P(J1(1)," ")
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
 U $I:(TERM=X)
 Q 1
 ;
DEVOK ;
 ;use lsof (list open files)
 ; given a device name in X
 ;INPUT:  X=Device $I, X1=IOT -- X1 needed for resources
 ;OUTPUT: Y=0 if available, Y=job # if owned
 ; Y=-1 if device does not exists.
 ; return Y=0 if not owned, Y=$J of owning job, Y=999 if dev cycling
 ;
 I $G(X1)="RES" G RESOK^%ZIS6
 S Y=0
 Q  ;Let ZIS deal with it.
 ;
 N %FILE S %FILE=$$TEMP_"zosv_devok_"_$J_".tmp"
 ZSYSTEM "/usr/sbin/lsof -F Pc "_X_" >"_%FILE
 N %I,%X,%Y S %I=$I
 O %FILE
 N %I,%X,%Y S %I=$I
 U %FILE
 F %Y=0:1 R %X Q:%X=""  Q:%X["lsof: status error"  D
 . S %Y(%Y\2,$S($E(%X)="p":"PID",$E(%X)="c":"CMD",1:"?"))=$E(%X,2,$L(%X))
 U %I
 C %FILE:(DELETE)
 I %X["lsof: status error" S Y=-1 Q
 S %X="",Y=0
 F  S %X=$O(%Y(%X)) Q:%X=""  I %Y(%X,"CMD")="mumps" S Y=%Y(%X,"PID") Q
 Q
 ;
PIDOPN ; give a list of of all JOBS that have the current device open
 ; returns comma separated in Y
 N %FILE S %FILE=$$TEMP_"zosv_pidopn_"_$J_".tmp"
 ZSYSTEM "lsof -F Pc "_$I_" >"_%FILE
 N %I,%X,%Y S %I=$I
 O %FILE
 N %I,%X,%Y S %I=$I
 U %FILE
 F %Y=0:1 R %X Q:%X=""  S %Y(%Y\2,$S($E(%X)="p":"PID",$E(%X)="c":"CMD",1:"?"))=$E(%X,2,$L(%X))
 U %I
 C %FILE:(DELETE)
 S (Y,%X)="" F  S %X=$O(%Y(%X)) Q:%X=""  I %Y(%X,"CMD")="mumps" S Y=Y_","_%Y(%X,"PID")
 Q
 ;
DEVOPN ;List of Devices opened
 ;Returns variable Y. Y=Devices owned separated by a comma
 ; ZSHOW "D":Y
 N %FILE S %FILE=$$TEMP_"zosv_devopn_"_$J_".tmp"
 ZSYSTEM "lsof -F n -p "_$J_" >"_%FILE
 N %I,%X,%Y S %I=$I
 O %FILE
 U %FILE
 F %Y=0:1 R %X Q:%X=""  S %Y($S($E(%X)="p":"PID",$E(%X)="n":%Y,1:"?"))=$E(%X,2,$L(%X))
 U %I
 C %FILE:(DELETE)
 I %Y("PID")'=$J S Y="" Q
 I $D(%Y("?")) S Y="" Q
 K %Y("PID"),%Y("?")
 S (Y,%X)="" F  S %X=$O(%Y(%X)) Q:%X=""  S Y=Y_","_%Y(%X)
 Q
 ;
RETURN(%COMMAND) ; ** Private Entry Point: execute a shell command & return the resulting value **
 ;
 ; %COMMAND is the string value of the Linux command
 N %VALUE S %VALUE="" ; value to return
 N %FILE S %FILE=$$TEMP_"RET"_$J_".txt" ; temporary results file
 ZSYSTEM %COMMAND_" > "_%FILE ; execute command & save result
 O %FILE:(REWIND) U %FILE R:'$ZEOF %VALUE C %FILE:(DELETE) ; fetch value & delete file
 ;
 QUIT %VALUE ; return value
 ;
 ;
STRIPCR(%DIRECTORY) ; ** Private Entry Point: strip extraneous CR from end of lines of all
 ; routines in %DIRECTORY Linux directory
 ;
 ZSYSTEM "perl -pi -e 's/\r\n$/\n/' "_%DIRECTORY_"[A-K]*.m"
 ZSYSTEM "perl -pi -e 's/\r\n$/\n/' "_%DIRECTORY_"[L-S]*.m"
 ZSYSTEM "perl -pi -e 's/\r\n$/\n/' "_%DIRECTORY_"[T-z]*.m"
 ZSYSTEM "perl -pi -e 's/\r\n$/\n/' "_%DIRECTORY_"[_]*.m"
 Q
 ;
