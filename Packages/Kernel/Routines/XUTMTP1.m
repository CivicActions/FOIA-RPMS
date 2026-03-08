XUTMTP1 ;SEA/RDS - TaskMan: ToolKit, Print, Part 3 ;10/04/2001  13:30 [ 07/29/2004   9:01 AM ]
 ;;8.0;KERNEL;**20,225**;Jul 10, 1995
 ;
PRINT ;Print Task
 N %ZTT,ZTC,ZTD,ZTI,ZTO,ZTTAB S XUINX=+$G(XUINX)
 S ZTTAB=$S(XUINX:$L(XUINX),1:$L(XUTSK))
 I XUINX W !,XUINX,": (Task #",XUTSK,") "
 E  W !,XUTSK,": "
 S ZTD=$P(XUTSK(0),U,1,2)
 I ZTD="ZTSK^XQ1",$P(XUTSK(0),U,11)_","_$P(XUTSK(0),U,12)=XUTMUCI S ZTO=$S($D(^%ZTSK(XUTSK,.3,"XQY"))#2:+^("XQY"),1:+$P(XUTSK(0),U,8)) I ZTO,$D(^DIC(19,ZTO,0))#2 S ZTD=$P(^(0),U)_" - "_$P(^(0),U,2)
 S:'$T ZTD=$S(ZTD]"":ZTD_", ",1:"")_$E(XUTSK(.03),1,75) D W($S(ZTD]"":ZTD,1:"Task data missing")_$E(".",($E(ZTD,$L(ZTD))'=".")))
 S ZTD=$S($P($P(XUTSK(.2),U),";")]"":"  Device "_$P($P(XUTSK(.2),U),";")_".",XUTSK(0)]"":"  No device.",1:"  Device unknown.") D W(ZTD)
 S ZTD=$P(XUTSK(0),U,4) I ZTD="" S ZTD=$P(XUTSK(0),U,11) I ZTD]"" S ZTD=ZTD_","_$P(XUTSK(0),U,12)
 I ZTD]"",$P(XUTSK(0),U,14)]"" S $P(ZTD,",",2)=$P(XUTSK(0),U,14)
 S ZTD="  "_$S(ZTD]"":ZTD,1:"Account unknown")_"." D W(ZTD)
 S ZTD=$P(XUTSK(0),U,5) I ZTD]"" D W("  From "_$$TIME^XUTMTP(ZTD)_",") ; D W(ZTD)
 I ZTD]"" S ZTD=$S($P(XUTSK(0),U,10)=ZTNAME:"  By you.",$P(XUTSK(0),U,10)]"":"  By "_$P(XUTSK(0),U,10)_".",$P(XUTSK(0),U,3)]"":"  By user # "_$P(XUTSK(0),U,3)_".",1:"  By an unspecified user.") D W(ZTD)
 S ZTC="" F ZTI=0:0 S ZTC=$O(XUTSK(.15,ZTC)) Q:ZTC=""  S ZTD="  "_XUTSK(.15,ZTC) D W(ZTD)
 ; The information about the running task appears to be stored in
 ; ^%ZTSCH("TASK",task number) and the 10th piece is equal to the
 ; job number.
 ; XUTSK("TASK") is equal ^%ZTSCH("TASK",task number)
 I $D(XUTSK("TASK")),$P(XUTSK("TASK"),U,10)]"" S ZTD=$P(XUTSK("TASK"),U,10),ZTD="  Job #: "_ZTD_$S(ZTD>2048:" ["_$$CNV^XLFUTL(ZTD,16)_"]",1:"") D W(ZTD)
 K XUTMT Q
 ;
W(A) ;Write value
 W:$X+$L(A)>80 !,?ZTTAB W A
 Q
