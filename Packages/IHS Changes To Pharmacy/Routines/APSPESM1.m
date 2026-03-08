APSPESM1 ;IHS/MSC/PLS - Surescripts Mailbox Support;17-Jul-2020 08:47;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1024,1026**;Sep 23, 2004;Build 47
 Q
 ; Utilization Report
RPTRPC(DATA,PRV,INP,SDT,EDT) ;-
 N APSPIO
 D EXEC("D UTLZ^APSPESM2(PRV,INP,.SDT,.EDT)","P-HTML")
 Q
 ;Execute M code
EXEC(MCODE,SUBTYPE) ;-
 N FIL,APZ,APX
 I $$NEWERR^%ZTER N $ET S $ET=""
 S @$$TRAP^CIAUOS("RPCERR^APSPESM1"),DATA=$$TMPGBL()
 S FIL=$$UFN^CIAU("TMP"),FIL(FIL)=""
 I $$DEL^%ZISH("","FIL")
 D OPEN^%ZISH("TMP","",FIL,"W",32767)
 I POP D RPCX("Unable to open temporary file.") Q
 S IOST=SUBTYPE,IOST(0)=+$$ENTRY^CIAUDIC(3.2,"="_IOST)
 D TRMIO()
 U IO
 X MCODE
 I $$REWIND^%ZIS(IO,IOT,0)
 F APZ=1:2 D  Q:$$STATUS^%ZISH
 .K APX
 .D READNXT^%ZISH(.APX)
 .M @DATA@(APZ)=APX
 .S @DATA@(APZ+1)=$C(13,10)
 D CLOSE^%ZISH("TMP")
 I $$DEL^%ZISH("","FIL")
 D:$D(@DATA)<10 RPCX("No data retrieved.")
 Q
RPCERR D RPCX($ZE)
 Q
RPCX(X) S @DATA@(1)="MUMPS Error: "_X
 D ^%ZTER
 Q
 ; Return reference to temporary global
TMPGBL() K ^TMP("APSPESMRPT",$J) Q $NA(^($J))
 ;
 ; Output HTML tag
 ; Preserves $X and $Y
TAG(VAL) ;-
 N APX,APY
 S APX=$X,APY=$Y
 W VAL
 S $X=APX,$Y=APY
 Q ""
 ; Defined special variables for terminal type
TRMIO() ;-
 N IOINHI,IOINORM,IOUOFF,IOUON,IORVOFF,IORVON
 N X
 S X="IOINHI;IOINORM;IOUOFF;IOUON;IORVOFF;IORVON" D ENDR^%ZISS
 F X="IOINHI","IOINORM","IOUOFF","IOUON","IORVOFF","IORVON" D
 .S APSPIO(X)=@X
 S APSPIO("STRON")="<Strong>"
 S APSPIO("STROFF")="</Strong>"
 Q
 ; Display aattribute commands
HI() Q $$SETIT("IOINHI")
NOHI() Q $$SETIT("IOINORM")
UND() Q $$SETIT("IOUON")
NOUND() Q $$SETIT("IOUOFF")
RV() Q $$SETIT("IORVON")
NORV() Q $$SETIT("IORVOFF")
STRON() Q $$SETIT("STRON")
STROFF() Q $$SETIT("STROFF")
 ; Output a display attribute
 ; Preserves $X and $Y
SETIT(ATTR) ;-
 S ATTR=$G(APSPIO(ATTR))
 I ATTR'="" N X,Y S X=$X,Y=$Y,$X=0 W ATTR S $X=X,$Y=Y
 Q ""
