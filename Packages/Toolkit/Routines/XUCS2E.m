XUCS2E ;CLARKSBURG/SO C.M. BUILD GLOBAL REF. DATA (multiple 8987.33) ;3/29/96  13:35 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**14,15**;Apr 25, 1995
 K ^TMP($J,"XUCS")
 S XUCSSRN=0 F  S XUCSSRN=+$O(^%ZRTL("XUCS",XUCSVG,XUCSAP,+XUCSRN,XUCSSRN)) Q:+XUCSSRN<1  D
EPL1 . ; Get Global Raw Data nodes
 . ; Loop thru UCI,VG nodes
 . S XUCSX1="" F  S XUCSX1=$O(^%ZRTL("XUCS",XUCSVG,XUCSAP,+XUCSRN,+XUCSSRN,1,XUCSX1)) Q:XUCSX1=""  D
EPL2 .. ; Loop thru Global Nodes
 .. I $E($P(XUCSX1,","))="~" S XUCSTBFG="Y" Q  ; Table Full condition
 .. S XUCSX2="" F  S XUCSX2=$O(^%ZRTL("XUCS",XUCSVG,XUCSAP,+XUCSRN,+XUCSSRN,1,XUCSX1,XUCSX2)) Q:XUCSX2=""  D
EPL3 ... ; Table Global Data
 ... S XUCSTYPE=2 ; Initialize UCI type to OTHER
 ... I $P(XUCSX1,",")="MGR" S XUCSTYPE=0
 ... I $P(XUCSX1,",")=XUCSPUCI S XUCSTYPE=1
 ... S XUCSX2A=XUCSX2,XUCSX2A=XUCSX2A_U_$P(^%ZRTL("XUCS",XUCSVG,XUCSAP,+XUCSRN,+XUCSSRN,1,XUCSX1,XUCSX2),U,1,99)
 ... ; TMP($J,"XUCS",<uci type>,<global name>)=
 ... ; $P#1= # of global accesses
 ... ; $P#2= reserved RTHIST counter
 ... ; $P#3= $P#1 Neg? 0=no, 1=yes
 ... ; $P#4= name of UCI
 ... ; $P#5= global Volume Group
SETTMP ... I '$D(^TMP($J,"XUCS",XUCSTYPE,$P(XUCSX2A,U))) S ^TMP($J,"XUCS",XUCSTYPE,$P(XUCSX2A,U))=0_U_0_U_0_U_U
 ... S XUCSX3=^TMP($J,"XUCS",XUCSTYPE,$P(XUCSX2A,U))
 ... S $P(XUCSX3,U,4)=$P(XUCSX1,",")
 ... I $P(XUCSX2A,U,2)<0 S $P(XUCSX3,U,3)=1
 ... I $P(XUCSX2A,U,2)>0 S $P(XUCSX3,U)=$P(XUCSX3,U)+$P(XUCSX2A,U,2)
 ... S $P(XUCSX3,U,2)=$P(XUCSX3,U,2)+$P(XUCSX2A,U,3)
 ... ; Remove double letter if there (bug in RTHIST)
 ... D
 .... N A
 .... S A=$P(XUCSX1,",",2) ; Vol. Group Name
 .... I $L(A)=3 S $P(XUCSX3,U,5)=A Q
 .... I $E(A,2,2)=$E(A,3,3) S $P(XUCSX3,U,5)=$E(A,1,2)_$E(A,4,4) Q
 .... Q
 ... S ^TMP($J,"XUCS",XUCSTYPE,$P(XUCSX2A,U))=XUCSX3
 ... K XUCSTYPE,XUCSX2A,XUCSX3
 ... Q
 .. Q
 . Q
 K XUCSSRN,XUCSTYPE,XUCSX1,XUCSX2
EDIT ; Edit data into File #8987.2
 ; Update 8987.33 Multiple
 ; Loop thru TMP global, UCI type
 D EDIT^XUCSUTL ; Do common edits
 S XUCST="" F  S XUCST=$O(^TMP($J,"XUCS",XUCST)) Q:XUCST=""  D
EL1 . ; Loop thru Global
 . S XUCSR="" F  S XUCSR=$O(^TMP($J,"XUCS",XUCST,XUCSR)) Q:XUCSR=""  S XUCSX=^(XUCSR) D
EL2 .. ; Now edit the 8987.33 Multiple
 .. S XUCSX1=$P(XUCSX,U,4) ; name of UCI
 .. S XUCSX2=$S(XUCST=0:"m",XUCST=1:"p",1:"o") ; Type of UCI
 .. S XUCSX3=$P(XUCSX,U,1) ; Global accesses
 .. S XUCSX4=$P(XUCSX,U,2) ; Reserved RTHIST
 .. S XUCSX5=$S($P(XUCSX,U,3)=1:"y",1:"n") ; Global Counter Neg.
 .. S XUCSX6=$P(XUCSX,U,5) ; Vol. Group
 .. S DA(2)=XUCSDA2,DA(1)=XUCSDA1
 .. S DIC="^XUCS(8987.2,"_DA(2)_",1,"_DA(1)_",2,"
 .. S DIC(0)="FLMXZ",DIC("P")=$P(^DD(8987.21,3,0),"^",2),X=XUCSR D ^DIC
 .. I Y=-1 K DIC,XUCSX,XUCSX1,XUCSX2,XUCSX3,XUCSX4,XUCSX5,XUCSX6 Q
 .. S DIE=DIC K DIC S DA=+Y
 .. S DR="1///^S X=XUCSX1;2///^S X=XUCSX2;3///^S X=XUCSX3;4///^S X=XUCSX4;5///^S X=XUCSX5;6///^S X=XUCSX6"
 .. D ^DIE K DIE,DR,DA,Y,XUCSX,XUCSX1,XUCSX2,XUCSX3,XUCSX4,XUCSX5,XUCSX6
 .. Q
 . Q
 K XUCSDA1,XUCSDA2,XUCSR,XUCSRDT,XUCST,XUCSTBFG,^TMP($J,"XUCS")
 D KILL^XUCSUTL
 Q
