XTCMFILN ;SFISC/JC - PREPARE HOST FILES FOR SHIPPING  ;05/12/95  11:41 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**2**;Apr 25, 1995
 ;MSM sites should have a device named 'HFS'
 ;if not, edit LOAD+9 and specify the correct hfs device to use
 ;expects path/filename in '%', ^TMP NODE IN XUHFN
 ;IF RUN IN BACKGROUND, XUHFS RETURNED AS '1' IF LOAD SUCCESSFUL
 I $G(XUHFN)="" S XUHFN="HFS" N J
 S U="^" D HOME^%ZIS S DTIME=$$DTIME^XUP
 I '$D(%) W !,"ENTER A HOST FILE: " R %:DTIME
 S %XUCM=%
 Q:'$D(%XUCM)!(%XUCM["^")!(%XUCM="")  I %XUCM["?" W !,"Enter the filename and/or path, ie, $1$DISK:[MYDIRECTORY]MYFILE.TXT" K %,%XUCM G XTCMFILN
 I $G(^TMP($J,XUHFN,0))="" S ^TMP($J,XUHFN,0)="^XTCMFILN^"_%XUCM_U_0
LOAD ;
 S XUHFS=0 N M,ZC
 ;DO WE HAVE A DEVICE NAMED 'HFS'
 K IOP S %ZIS="N",IOP="HFS" D ^%ZIS
 I $G(IOT)="HFS" S IOP=ION
 ;
 ;IF TOOLKIT IS INSTALLED SET IOP TO THE HFS DEVICE DEFINED IN CM SITE PARAMETERS (8986.095)
 I $D(^XUCM) S IOP=$P($$PARM^XUCMVPU,U,4)
 ;
 ;OPTIONALLY SET IOP DIRECTLY TO THE HFS DEVICE OF YOUR CHOICE
 ;S IOP="<your hfs device>"
 G:$G(IOP)="" EXIT S %ZIS("HFSNAME")=%XUCM,%ZIS("HFSMODE")="R"
 D ^%ZIS G:POP EXIT U IO
 S X="DONE^XTCMFILN",@^%ZOSF("TRAP")
 F  R X:DTIME Q:$$EOF  D STRIP S:X'="" J=1+$P(^TMP($J,XUHFN,0),U,4),^TMP($J,XUHFN,J)=$E(X,1,255),$P(^TMP($J,XUHFN,0),U,4)=J
 G EXIT
EOF() ;
 I ^%ZOSF("OS")["MSM" D
 .S M="S ZC=$ZC" X M
 .I ZC<0 S XUHFS=1
 Q XUHFS
STRIP ;
 S X1="" F Y=1:1:$L(X) S A=$E(X,Y) D
 .I $A(A)=9 S X1=X1_"     " Q
 .I $A(A)=210!($A(A)=211) S X1=X1_"""" Q
 .S:$A(A)'<32 X1=X1_A
 S X=X1
 Q
DONE ;Returns XUHFS=1 if file transfer was successful
 I $$EC^%ZOSV["END" S XUHFS=1
EXIT ;
 D ^%ZISC
 K I,%XUCM,X,X1,Y,A
 I $D(^TMP($J,XUHFN)),$O(^TMP($J,XUHFN,0))<1 S XUHFS=0
 I '$D(ZTQUEUED) D
 .I 'XUHFS W !,"COULD NOT LOAD FILE!"
 .I XUHFS W !,"<Load Successful>"
 S X=^%ZOSF("ERRTN"),@^%ZOSF("TRAP")
 Q
MAIL ;mail Bernstein data somewhere
 ;VAX Sites must have two mail groups defined in 8986.095:
 ;1. One with local recipients (for example, G.IRM).
 ;2. One containing remote recipients "G.CMP@SFISC.VA.GOV"
 ;                                      "G.CMP@your isc"
 Q:^%ZOSF("OS")'["VAX"
 I $G(XUHFN)="" S XUHFN="HFS"
 S U="^" D HOME^%ZIS S DTIME=$$DTIME^XUP
 I $D(^XUCM(8986.095)) S XUCMPARM=$$PARM^XUCMVPU,XUCMLOC="G."_$P(XUCMPARM,U,5),XUCMREM="G."_$P(XUCMPARM,U,9),XMY("S.XUCM SERVER")=""
 E  S (XUCMLOC,XUCMREM)="G.IRM"
 S XMSUB="BRTL HOST FILE "_$P(^TMP($J,XUHFN,0),U,3)
 S XMDUZ=XUCMLOC_"@"_^XMB("NETNAME"),XMY(XMDUZ)="",XMY(XUCMLOC)="",XMY("G.CMP@ISC-SF.VA.GOV")="",XMY(XUCMREM)=""
 S XMTEXT="^TMP($J,XUHFN,"
 I '$D(^TMP($J,XUHFN)) S XMTEXT="No data found in ^TMP"
 D ^XMD
 K ^TMP($J,XUHFN)
 Q
MAIL1 ;ALL SITES-Optionally mail ^tmp data anywhere
 ;If recipients not passed in XMY, mailman will prompt
 I $G(XUHFN)="" S XUHFN="HFS"
 S U="^" D HOME^%ZIS S DTIME=$$DTIME^XUP I '$G(DUZ) S XMDUZ=.5
 I $O(^TMP($J,XUHFN,0))<1 W !,$C(7),"NO DATA TO LOAD!" Q
 S XMTEXT="^TMP($J,XUHFN,"
 I $G(XMSUB)="" S XMSUB="HOST FILE "_$P(^TMP($J,XUHFN,0),U,3)
 D ^XMD,NNEW^XMA
 K ^TMP($J,XUHFN)
 K %ZIS,IOP,POP,XMDUZ,XMSUB,XMTEXT,XMY,XUD,XUHFN,ZTSK
 Q
