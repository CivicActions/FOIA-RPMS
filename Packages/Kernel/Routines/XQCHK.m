XQCHK ; SEA/MJM - Check security on option # XQCY ;5/12/03 12:31pm [ 07/29/2004   9:01 AM ]
 ;;8.0;KERNEL;**47,110,149,303**;Jul 10, 1995
 Q:'$D(XQCY)!(XQCY<1)  S:'$D(XQJMP) XQJMP=0
 I '$D(XQY0) S XQY0=^DIC(19,+XQCY,0)
 I '$D(XQCY0) S XQSAV=XQY0,XQY=XQCY D SET Q:XQCY<0  S XQCY0=XQY0,XQY0=XQSAV
CHK I XQCY0="" S XQCY=-1 G OUT
 I $P(XQCY0,U,3)'="" S XQCY=-1 G OUT
 I $L($P(XQCY0,U,6)) S %="" F %XQI=1:1 S %=$P($P(XQCY0,U,6),",",%XQI) Q:%=""  I '$D(^XUSEC(%,DUZ)) S XQCY=-2 G OUT
 I $L($P(XQCY0,U,16)) S %="" F %XQI=1:1 S %=$P($P(XQCY0,U,16),",",%XQI) Q:%=""  I $D(^XUSEC(%,DUZ)) S XQCY=-3 G OUT
 I $L($P(XQCY0,U,9)) S XQZ=$P(XQCY0,U,9) D ^XQDATE S X=% D XQO^XQ92 I X="" S XQCY=-4 G OUT
 G:$P(XQCY0,U,10)'["y" OUT
 S %=0 F %XQI=1:1 S %=$O(^DIC(19,XQCY,3.96,%,0)) Q:%=""  I IOS=% G OUT
 S XQCY=-5 G OUT
 Q
 ;
OUT K %,%XQI,XQCY0,%Y,XQZ
 Q
 ;
JMP ;Check all options in jump path in %XQJP returned as "" if not OK
 S XQJMP=1
 F %XQCI=1:1 S XQCY=$P(%XQJP,",",%XQCI) Q:XQCY=""  S XQCY0=$G(^XUTL("XQO",XQDIC,"^",XQCY)),XQCY0=$P(XQCY0,U,2,99) D CHK S:XQCY<0 %XQJP=""
 K %XQCI,XQCY,XQCY0
 Q
 ;
SET ;Produce the same XQY0 as SET1^XQ7 without the synonym
 I '$D(^DIC(19,+XQY,0)) S XQY=-1 Q
S1 Q:XQY'>0  S XQY0=^DIC(19,+XQY,0),XQY0=$P(XQY0,U,1,2)_U_$S($P(XQY0,U,3)]"":1,1:"")_U_$P(XQY0,U,4)_U_U_$P(XQY0,U,6,99)
 S %="" I $D(^DIC(19,+XQY,3.91)) F %XQI=0:0 S %XQI=$O(^DIC(19,+XQY,3.91,%XQI)) Q:%XQI=""!(%XQI'=+%XQI)  I ^(%XQI,0)]"" S %=$S(%'="":%_";",1:"")_$P(^(0),U,1)_$P(^(0),U,2)
 I %]"" S XQY0=$P(XQY0,U,1,8)_U_%_U_$P(XQY0,U,10,99)
 I $P(XQY0,U,16),$D(^DIC(19,XQY,3)) S %=$P(^(3),U) I %'="" S XQY0=$P(XQY0,U,1,15)_U_%_U_$P(XQY0,U,17,99)
 K %,%XQI
 Q
 ;
MES ;Messages for rejected options from a call to XQCHK
 W $C(7)
 I XQCY=-1 W !!?5,"==> Sorry, ",$S($D(XQPRMN):"your Primary Menu",1:"this option")," is out of order with the message:",!?10,$P(^DIC(19,XQY,0),U,3)
 I XQCY=-2 W !!?5,"==> Sorry, ",$S($D(XQPRMN):"your Primary Menu",1:"this option")," is locked."
 I XQCY=-3 W !!?5,"==> Sorry, ",$S($D(XQPRMN):"your Primary Menu",1:"this option")," has a reverse lock on it."
 I XQCY=-4 W !!?5,"==> Sorry, ",$S($D(XQPRMN):"your Primary Menu",1:"this option")," not allowed right now."
 I XQCY=-5 W !!?5,"==> Sorry, ",$S($D(XQPRMN):"your Primary Menu",1:"this option")," not allowed on this device."
 Q
 ;
OP ;Find out what option or protocol is in charge right now
 ;Returns option or protocol name and text in XQOPT
 S U="^",%XQ=0
 I $D(XQORNOD) S %XQ=+XQORNOD,%XQ1=U_$P(XQORNOD,";",2),%XQ=@(%XQ1_%XQ_",0)"),XQOPT=$P(%XQ,U)_U_$P(%XQ,U,2)
 I '$D(XQORNOD) S %XQ=$S($D(XQY)#2:XQY,1:0) I %XQ S %XQ1=^DIC(19,+%XQ,0),XQOPT=$P(%XQ1,U)_U_$P(%XQ1,U,2)
 I '$D(XQOPT) S XQOPT="-1^Unknown"
 K %XQ,%XQ1
 Q
 ;
OP1() ;Extrinsic function call returns 3 pieces: 1. "P", "O", or "U" for
 ;Protocol, Option, or Unknown.  2: The Option or Protocol's name. 3:
 ;3: Text name of the Protocol or Option.  For example:
 ;
 ;           O^EVE^System Manager's Menu
 ;
 N %,%XQ,%XQ1
 S U="^",%XQ=0
 I $D(XQORNOD) S %XQ=+XQORNOD,%XQ1=U_$P(XQORNOD,";",2),%XQ=@(%XQ1_%XQ_",0)"),%="P"_U_$P(%XQ,U)_U_$P(%XQ,U,2)
 I '$D(XQORNOD) S %XQ=$S($D(XQY)#2:XQY,1:0) I %XQ S %XQ1=^DIC(19,+%XQ,0),%="O"_U_$P(%XQ1,U)_U_$P(%XQ1,U,2)
 I '$D(%) S %="U"_U_"Unknown"_U_"No option or protocol data available"
 Q %
 ;
 ;
ACCESS(%XQUSR,%XQOP) ;Find out if a user has access to a particular option
 ;
 ;    W $$ACCESS(DUZ,Option IEN) returns:
 ;
 ;-1:no such user in the New Person File
 ;-2: User terminated or has no access code
 ;-3: no such option in the Option File
 ;0: no access found in any menu tree the user owns
 ;
 ;    All other cases return a 4-piece string stating
 ;    access ^ menu tree IEN ^ a set of codes ^ key
 ;
 ;O^tree^codes^key: No access because of locks (see XQCODES below)
 ;  where 'tree' is the menu where access WOULD be allowed
 ;  and 'key' is the key preventing access
 ;1^OpIEN^^: Access allowed through Primary Menu
 ;2^OpIEN^codes^: Access found in the Common Options
 ;3^OpIEN^codes^: Access found in top level of secondary option
 ;4^OpIEN^codes^: Access through a the secondary menu tree OpIEN.
 ;
 ;XQCODES can contain:
 ;  N=No Primary Menu in the User File (warning only)
 ;  L=Locked and the user does not have the key (forces 0 in first piece)
 ;  R=Reverse lock and user has the key (forces 0 in first piece)
 ;
 I '$D(^VA(200,%XQUSR,0)) Q -1
 N %,DT
 S DT=$$HTFM^XLFDT($H,1)
 S %=^VA(200,%XQUSR,0) I ($P(%,U,3)="")!($L($P(%,U,11))&($P(%,U,11)'>DT)) Q -2
 ;
 ;Convert %XQOP to its IEN if the name is passed
 I +%XQOP'=%XQOP D
 .I $D(^DIC(19,"B",%XQOP))<1 S %XQOP=0 Q
 .E  S %XQOP=$O(^DIC(19,"B",%XQOP,0))
 .Q
 I '%XQOP Q -3
 I '$D(^DIC(19,%XQOP,0)) Q -3
 ;
 N XQCODES,XQCOM,XQDIC,XQDONE,XQI,XQJ,XQKEY,XQOK,XQPM,XQRSLT,XQSEC,XQTREE
 S (%,XQDONE,XQOK)=0,(XQRSLT,XQCODES,XQTREE)=""
 ;
 ;
 ;Look in the user's primary menu tree
 S XQPM=$P($G(^VA(200,%XQUSR,201)),"^")
 I 'XQPM S XQCODES=XQCODES_"N"
 ;
 ;
 I XQPM S XQDIC="P"_XQPM I $D(^XUTL("XQO",XQDIC,"^",%XQOP)) D
 .D KEYS
 .I XQCODES'["L"&(XQCODES'["M") S XQOK=1
 .Q
 I XQOK Q "1^"_XQPM_"^"_XQCODES
 I XQCODES["L"!(XQCODES["R") S XQRSLT="0^"_XQPM_"^"_XQCODES_"^"_XQKEY
 ;
 ; Search the common options
 S XQCOM=$O(^DIC(19,"B","XUCOMMAND",0))
 S XQDIC="PXU"
 I $D(^XUTL("XQO",XQDIC,"^",%XQOP)) D
 .D KEYS
 .I XQCODES'["L"&(XQCODES'["R") S XQOK=1
 .Q
 I XQOK Q "2^"_XQCOM_"^"_XQCODES
 I XQRSLT="" I XQCODES["L"!(XQCODES["R") S XQRSLT="0^"_XQCOM_"^"_XQCODES_"^"_XQKEY
 ;
 ;Check the top level of the secondary options
 S XQDIC="U"_%XQUSR
 I $D(^VA(200,%XQUSR,203,0)),$P(^(0),U,4)>0 D
 .S XQJ=0,XQDONE=0
 .F XQI=1:1 D  Q:XQDONE
 ..S XQJ=$O(^VA(200,%XQUSR,203,XQJ))
 ..I (XQJ'=+XQJ)!('XQJ) S XQDONE=1 Q
 ..S XQSEC(XQI)=+^VA(200,%XQUSR,203,XQJ,0)
 ..Q:XQSEC(XQI)'=%XQOP
 ..D KEYS
 ..I XQCODES'["L"&(XQCODES'["R") S XQOK=1
 ..I XQRSLT="" I XQCODES["L"!(XQCODES["R") S XQRSLT="0^"_XQSEC(XQI)_"^"_XQCODES_"^"_XQKEY
 ..Q
 .Q
 I XQOK Q "3^"_%XQOP_"^"_XQCODES
 ;
 ;If there are no secondaries quit here
 I '$D(XQI)&((XQCODES["L")!(XQCODES["R")) Q XQRSLT
 I '$D(XQI) Q 0
 ;
 ;Check each secondary menu tree
 F XQK=1:1:XQI-1 Q:XQOK  D
 .S XQDIC="P"_XQSEC(XQK)
 .Q:'$D(^XUTL("XQO",XQDIC,"^",%XQOP))
 .S XQTREE=$P(XQDIC,"P",2)
 .D KEYS
 .I XQCODES'["L"&(XQCODES'["R") S XQOK=1
 .I XQRSLT="" I XQCODES["L"!(XQCODES["R") S XQRSLT="0^"_XQTREE_"^"_XQCODES_"^"_XQKEY
 .Q
 I XQOK Q "4^"_XQTREE_"^"_XQCODES
 I XQRSLT]"" Q XQRSLT
 ;
 ;We doan find nothing nowhere
 Q "0^^"_XQCODES
 ;
KEYS ;Check for keys, reverse keys...
 N XQK,XQN,XQOPIQ,KFG
 D CHCK1^XQCHK1 Q:KFG=1
 I $D(^XUTL("XQO",XQDIC,"^",%XQOP)) S XQOPIQ=^(%XQOP)
 E  S XQOPIQ=U_^DIC(19,%XQOP,0)
 ;
 I $L($P(XQOPIQ,U,7)) D
 .S %=$P(XQOPIQ,U,7)
 .F XQN=1:1 S XQK=$P(%,",",XQN) Q:XQK=""  D
 ..I '$D(^XUSEC(XQK,%XQUSR)) S XQCODES=XQCODES_"L",XQKEY=XQK
 ..Q
 .Q
 ;
 I $L($P(XQOPIQ,U,17)) D
 .S %=$P(XQOPIQ,U,17)
 .F XQN=1:1 S XQK=$P(%,",",XQN) Q:XQK=""  D
 ..I $D(^XUSEC(XQK,%XQUSR)) S XQCODES=XQCODES_"R",XQKEY=XQK
 ..Q
 .Q
 Q
 ;
OPACCES ;Entry point for the option that checks to see if a user has
 ;access to a particular option by calling the above function.
 N %,DIC,X,XQANS,XQCODES,XQK,XQKEY,XQOPT,XQOPN,XQPTR,XQRSLT,XQTREE,XQUSER,XQUSN,Y
 ;
 S DIC(0)="AEMNQ",DIC="^VA(200,",DIC("A")="Please enter the user's name: " D ^DIC
 I $D(DUOUT)!($D(DTOUT)) D KILLFM Q
 I Y=-1 W !!?5,"Sorry we couldn't find that user in the New Person File.",!
 E  S XQUSN=+Y,XQUSER=$P(Y,U,2)
 I Y=-1 D KILLFM Q
 D KILLFM
 ;
 S DIC(0)="AEMNQ",DIC="^DIC(19,",DIC("A")="Please enter the name of the option: " D ^DIC
 I $D(DUOUT)!($D(DTOUT)) D KILLFM Q
 I Y=-1 W !!?5,"Sorry we couldn't find that option.",!
 E  S XQOPN=+Y,XQOPT=$P(Y,U,2)
 I Y=-1 D KILLFM Q
 D KILLFM
 ;
 S XQANS=$$ACCESS(XQUSN,XQOPN)
 ;W !,XQANS,!
 ;
 S XQRSLT=+XQANS,XQTREE=""
 S XQPTR=$P(XQANS,U,2) I XQPTR>0 S XQTREE=$P(^DIC(19,$P(XQANS,U,2),0),U)
 S XQCODES=$P(XQANS,U,3),XQKEY=$P(XQANS,U,4)
 ;
 I XQRSLT=-1 W !!?5,"User ",XQUSER," is not in the New Person File."
 I XQRSLT=-2 W !!?5,"User ",XQUSER," has an active termination date,",!?5,"or no verify code."
 I XQRSLT=-3 W !!?5,"Option ",XQOPT," is not in the Option File."
 I XQRSLT=0 D
 .W !!?5,"User ",XQUSER," does not have access to the option",!?5,XQOPT,"."
 .I XQCODES["L" W !!?5,"There is a lock somewhere in the menu tree "_XQTREE,!?5,"and the user does not hold the key "_XQKEY_"."
 .I XQCODES["R" W !!?5,"There is a reverse lock somewhere in the menu tree "_XQTREE,!?5,"and the user holds the key "_XQKEY_"."
 .Q
 I XQRSLT=1 W !!?5,"User ",XQUSER," has access to the option ",XQOPT,!?5,"through the primary menu ",XQTREE," (",$P(^DIC(19,XQPTR,0),U,2),")."
 I XQRSLT=2 W !!?5,"User ",XQUSER," has access to the option ",XQOPT,!?5,"through the Common Options (XUCOMMAND)."
 I XQRSLT=3 W !!?5,"User ",XQUSER," has access to the option ",XQOPT,!?5,"as a top-level secondary menu option."
 I XQRSLT=4 W !!?5,"User ",XQUSER," has access to the option ",XQOPT,!?5,"through the secondary menu tree ",XQTREE," (",$P(^DIC(19,XQPTR,0),U,2),")."
 W !
 ;W !!,%,"  ",XQUSER,"  ",XQOPT
 Q
 ;
KILLFM ;Kill off the FileMan variables
 K D0,DI,DIC,DIE,DISYS,DQ,DR,DUOUT,DTOUT,X,Y
 Q
 ;
KEYSET(XQU) ;Collect users keys and set them into ^TMP($J)
 N %,XQI
 S %=0 F XQI=0:1 S %=$O(^VA(200,XQU,51,"B",%)) Q:%=""  S:$D(^DIC(19.1,%,0)) ^TMP($J,$P(^DIC(19.1,%,0),U),%)=""
 Q
