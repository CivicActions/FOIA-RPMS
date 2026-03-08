XUPROD ;ISF/RWF - Is this a PROD account. ;06/17/2004  08:13
 ;;8.0;KERNEL;**284**;Jul 10, 1995
 ;
 ;IA# 4440
PROD(FORCE) ;Return 1 if this is a production account
 ;A non-zero flag will force a real check
 ;This call just checks a flag in the KSP, Other code will compair
 ;with registered ID.
 N LC,SID
 S SID=$G(^XTV(8989.3,1,"SID"))
 I '$L($P(SID,"^",3))!($P(SID,"^",3)'=$G(DT))!$G(FORCE) D
 . D CHECK S SID=$G(^XTV(8989.3,1,"SID"))
 Q +$P(SID,"^",1)
 ;
CHECK ;Check if SID matched stored value, Set field 501
 N CSID,SSID,FDA
 L +^XTV(8989.3,1,"SID"):2
 S CSID=$$SID^%ZOSV,SSID=$P($G(^XTV(8989.3,1,"SID")),"^",2)
 S FDA(8989.3,"1,",501)=(CSID=SSID),FDA(8989.3,"1,",503)=$$DT^XLFDT
 D FILE^DIE("","FDA")
 L -^XTV(8989.3,1,"SID")
 Q
 ;
SSID(SID) ;Set the SID into KSP.
 N FDA
 S FDA(8989.3,"1,",502)=SID,FDA(8989.3,"1,",503)="@"
 L +^XTV(8989.3,1,"SID"):2
 D FILE^DIE("","FDA")
 L -^XTV(8989.3,1,"SID")
 Q
ASK ;Ask user if this is prod.
 N DIR,P S P=$$PROD
 S DIR(0)="YO",DIR("A")="Is this a Production Account",DIR("B")="No"
 S DIR("A",1)="This is now a "_$S(P:"PRODUCTION",1:"TEST")_" account."
 S DIR("A",2)=" "
 S DIR("A",3)="Only answer YES if this is the full time Production Account."
 S DIR("A",4)="Answer No for all other accounts."
 D ^DIR Q:$D(DIRUT)
 I Y=1 D SSID($$SID^%ZOSV)
 E  D SSID("2~TEST~999")
 S P=$$PROD
 W:P !!,"This is now a PRODUCTION account.",! W:'P !!,"This is now a TEST account.",!
 Q
