XUSERBLK ;SF/RWF - Bulk user (new person) COMPUTER ACCESS  ; 9/4/03 11:55am
 ;;8.0;KERNEL;**20,214,230,289**;Jul 10, 1995
 ; This routine allows the Cloning of one person to a group of others.
A ;
 I $S('$D(DUZ)#2:1,DUZ'>0:1,1:0) W !!,"You are not a known user and can't use this option." Q
 D QUIT
B1 W @IOF,!?26,"Batch Entry of New Persons"
 W !?26,"--------------------------",!!,"Please select a person to copy from"
 K DIC S DIC(0)="AEQZ",DIC("A")="Template PERSON: ",DIC="^VA(200," D ^DIC
 G QUIT:$D(DTOUT)!$D(DUOUT),B1:Y=-1
 ; Show INFO to be copied"
 S XUTMP=+Y,XUTMP(0)=$P(Y,U,2),DA=+Y D EN^DIQ
 S DIR(0)="Y",DIR("A")="Is this the person data you want cloned" D ^DIR G B1:'Y
 W !,"You may enter a date, when the users that are being created/updated",!,"will no longer have access to the system."
 S XUTERMDT="",%DT="AEF",%DT(0)=DT,%DT("A")="Enter (optional) TERMINATION DATE: " D ^%DT S:Y>0 XUTERMDT=Y
 K XUSER S XUSER=0
B2 ;
 W !!,?26,"Batch Entry of New Persons",!,?26,"--------------------------",!
 W !,"Clone of: ",XUTMP(0) I XUTERMDT S Y=XUTERMDT D DD^%DT W ?50,"TERMINATION DATE: ",Y
 ;;
B3 F  S XUY=$$ADD^XUSERNEW Q:XUY<0  D  ;Create new entry
 . I '$P(XUY,U,3) D
 . . S DIR(0)="Y",DIR("A")=$P(XUY,U,2)_" is an existing user. Do you want to include" D ^DIR I Y'=1 S XUY=-1 Q
 . . S DIR(0)="Y",DIR("A")="Clear out KEYS, FILES, SECONDARY MENUS first" D ^DIR
 . . S:Y=1 $P(XUY,U,4)=1
 . . Q
 . I XUY>0 D
 . . S DIR(0)="Y",DIR("A")="Do You Want To Clone PERSON CLASS" D ^DIR
 . . S:Y=1 $P(XUY,U,5)=1
 . S:XUY>0 XUSER=XUSER+1,XUSER(XUSER)=XUY W !,"Next!",!
 . Q
B4 ;
 G:XUSER'>0 QUIT
 I XUTERMDT>0 S ZTRTN="CHECK^XUSTERM1",ZTIO="",ZTDTH=XUTERMDT D ^%ZTLOAD W !,"Automatic deactivation has been queued for this date.",!
 W !!,"Where do you want to print the COMPUTER ACCOUNT NOTIFICATION LETTERS"
 S %ZIS="MQ" D ^%ZIS G QUIT:POP,CLONE:'$D(IO("Q"))
 S ZTRTN="CLONE^XUSERBLK" F I="XUTMP","XUTERMDT","XUSER","XUSER(" S ZTSAVE(I)=""
 K IO("Q") D ^%ZTLOAD
 ;;
QUIT ;Call at start
 K DIC,DIR,%,L,XUIOP,XUNODE,XU1,X1,X2,X3,X4,X5,X6,XUTEXT,XUNEW,XUSER,XUTMP,XUTERMDT,XUH,XUU,M,P,XU
 K ^TMP($J)
 Q
 ;;
CLONE ;;
 S XUTEXT=$O(^DIC(9.2,"B",$$GET^XUPARAM("XUSER COMPUTER ACCOUNT","N"),0)),XUIOP=ION_";"_IOST_";"_IOM_";"_IOSL
 F XU1=1:1:XUSER S %=XUSER(XU1),DA=+%,XUNEW=$P(%,U,3),XUPURGE=$P(%,U,4) D C2,UPDATE("ORD",DA)
 G QUIT
 ;
C2 I '$D(ZTQUEUED) W !!?8,$S(XUNEW:"CREATING A NEW ACCOUNT FOR '"_$P(XUSER(XU1),U,2)_"'",1:"CONVERTING "_$P(XUSER(XU1),U,2)_"'S ACCOUNT OVER"),!!,"One moment please..."
 D BLDFDA
 I $P(^VA(200,DA,0),U,3)']"" S XUNEW=1 ;if no access code treat as new
 I $P($G(^VA(200,DA,.1)),U,2)']"" S XUNEW=1 ;If no verify code treat as new
 S XUU="unchanged",$P(^VA(200,DA,0),U,11)=XUTERMDT
 I XUNEW D ACODE S @XFDA@(200,DA_",",2)=XUH
 D UPDATE^DIE("",XFDA,XIEN,"XERR") ;S DIK="^VA(200," D IX1^DIK
 I XUNEW,XUTEXT>0 D LET(DA,XUTEXT)
 I $D(^XMB(3.7,DA,0))[0 S Y=DA K XMZ D NEW^XM K XMDT,XMM,XMZ
 Q
BLDFDA ;Build the FDA
 S XFDA="^TMP($J,""XFDA"")",XIEN="^TMP($J,""XIEN"")" K ^TMP($J)
 ;Move piece on nodes from list, Build XU only once
 F X2=1:1 S XUNODE=$P($T(DATA+X2),";;",2) Q:XUNODE=""  D
 . F X3=1:1 S X7=$P(XUNODE,U,X3) Q:X7']""  S X4=$$GETDD(200,X7),X5=$P(X4,";"),X6=$P(X4,";",2) D
 . . I '$D(XU(2,X5)) S XU(2,X5)=$G(^VA(200,XUTMP,X5))
 . . S:$P(XU(2,X5),U,X6)]"" @XFDA@(200,DA_",",X7)=$P(XU(2,X5),U,X6)
 . . Q
 . Q
 D SUBFILE
 Q
GETDD(FI,FE) ;Return node;piece for a field
 Q $P($G(^DD(FI,FE,0)),U,4)
DATA ;;field#
 ;;3^8^15^29^28
 ;;200.04^200.05^200.06^200.09^200.1^201^
 ;;41^41.1^41.2
 ;;101.01^101.02
 ;;9.21^9.22
 ;;
ACODE F Z=0:0 D ^XUS4 S X=XUU D ^XUSHSH S XUH=X Q:'($D(^VA(200,"AOLD",XUH))!$D(^VA(200,"A",XUH)))
 Q
 ;;
SUBFILE ;Move subfiles: Subscript, Subfile#, DINUM, Fields
 N XCNT S XCNT=0
KEY D MULTI(51,200.051,1,".01,3")
PATH ;D MULTI(19.8,".01")
FOF D MULTI("FOF",200.032,1,".01,1,2,3,4,5,6")
DIV D MULTI(2,200.02,1,".01")
SEC D MULTI(203,200.03,0,".01,2")
TAB D MULTI("ORD",200.010113,0,".01,.02,.03")
PSCLSS I $P($G(XUSER(XU1)),U,5)=1 D PRSNCL(DA)
 Q
MULTI(XSS,XSF,XDN,XDD) ;Build new data
 I XUPURGE D CLEAR(DA,XSS)
 Q:'$D(^VA(200,XUTMP,XSS,0))
 ;S X=^(0),Y=$S($D(^VA(200,DA,X2,0)):^(0),1:"")
 F X1=0:0 S X1=$O(^VA(200,XUTMP,XSS,X1)) Q:X1'>0  S X=^(X1,0) D
 . F X2=1:1 S X3=$P(XDD,",",X2) Q:X3=""  D
 . . I X3'=.01 S @XFDA@(XSF,"?+"_XCNT_","_DA_",",X3)=$$VAL(X,X3,XSF) Q
 . . S XCNT=XCNT+1,@XFDA@(XSF,"?+"_XCNT_","_DA_",",.01)=$P(X,U,1)
 . . S:XDN @XIEN@(XCNT)=X1
 . . Q
 . Q
 Q
VAL(V,FE,FI) ;Get value
 N % S %=$$GETDD(FI,FE),%=$P(%,";",2) Q $P(V,"^",%)
 ;
LET(DA,XUTEXT) ;Write access letter
 N DIWF,FR,TO,BY,IOP
 S DIWF="^DIC(9.2,"_XUTEXT_",1,",DIWF(1)=200,FR=DA,TO=DA,BY="NUMBER",IOP=XUIOP D EN2^DIWF
 Q
CLEAR(X4,X2) ;Clear subfile first, IEN, Subscript
 Q:$D(^VA(200,X4,X2,0))[0  N C,XUFN,XDEL,XMSG
 S C=",",XDEL=$NA(^TMP($J,"XUBLK2")),XUFN=+$P(^VA(200,X4,X2,0),"^",2)
 F X1=0:0 S X1=$O(^VA(200,X4,X2,X1)) Q:X1'>0  D
 . I X2=51 S %=$$DEL^XQKEY(X4,X1) Q  ;Special case for KEYS
 . S @XDEL@(XUFN,X1_C_X4_C,.01)="@"
 . Q
 I $D(@XDEL)>1 D FILE^DIE("",XDEL,"XMSG") ;I $D(XMSG) ZW XMSG
 Q
UPDATE(XX,USRIEN) ;Update effective date
 N PC,PC1
 S PC=$O(^VA(200,USRIEN,XX,"A"),-1) Q:PC'>0
 S PC=0 F  S PC=$O(^VA(200,USRIEN,XX,PC)) Q:PC'>0  D
 .S PC1=$P($G(^VA(200,USRIEN,XX,PC,0)),"^",3)
 .I (PC1="")!(PC1'<DT) D DOPD
 Q
DOPD ;
 L +^VA(200,DA,XX,PC,0):20 I '$T D  Q
 .W !,"===> The user is locked. Please try this option again."
 S $P(^VA(200,USRIEN,XX,PC,0),"^",2)=DT
 L -^VA(200,USRIEN,XX,PC,0)
 Q
PRSNCL(USERIEN) ;
 N XUDATA,XUPSC,XUEFDA,XUEXDA,ZZ
 S XUDATA=$O(^VA(200,XUTMP,"USC1","A"),-1) Q:XUDATA'>0
 S XUDATA=$G(^VA(200,XUTMP,"USC1",XUDATA,0)) Q:XUDATA=""
 S XUPSC=$P(XUDATA,"^")
 S XUEFDA=$P(XUDATA,"^",2) I XUEFDA'>DT S XUEFDA=DT
 S XUEXDA=$P(XUDATA,"^",3)
 I XUEXDA<DT,XUEXDA'="" Q
 N XULAST,XULDATA
 S XULAST=$O(^VA(200,USERIEN,"USC1","A"),-1)
 S ZZ(1,200.05,"+2,"_USERIEN_",",.01)=XUPSC
 S ZZ(1,200.05,"+2,"_USERIEN_",",2)=XUEFDA
 S ZZ(1,200.05,"+2,"_USERIEN_",",3)=XUEXDA
 D UPDATE^DIE("","ZZ(1)")
 Q:XULAST'>0
 S XULDATA=$G(^VA(200,USERIEN,"USC1",XULAST,0))
 S XULDATA=$P(XULDATA,"^",3)
 Q:XULDATA'>DT
 S $P(^VA(200,USERIEN,"USC1",XULAST,0),"^",3)=DT
 Q
