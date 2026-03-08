XPDDP ;SFISC/RSD - Display a package ;04/26/2004  11:23
 ;;8.0;KERNEL;**21,28,44,68,100,108,229,304,346**;Jul 10, 1995
EN1 ;print from Build file
 N DIC,D0,XPD,XPDT,XPDST,Y,Z
 S XPDST=$$LOOK^XPDB1 Q:XPDST<0
 S XPD("XPDT(")="",Y="LST1^XPDDP",Z="Build File Print"
 D EN^XUTMDEVQ(Y,Z,.XPD)
 Q
EN2 ;print from Distribution
 N D0,DIC,POP,XPD,XPDA,XPDNM,XPDT,XPDST,Y,Z,%ZIS
 S XPDST=$$LOOK^XPDI1("I $D(^XTMP(""XPDI"",Y))",1)
 S XPD("XPDT(")="",Y="LST2^XPDDP",Z="Transport Global Print",D0=$O(^XTMP("XPDI",XPDST,"BLD",0))
 Q:'D0
 D EN^XUTMDEVQ(Y,Z,.XPD)
 Q
 ;
LST1 ;
 K DIRUT N XPDIT S XPDIT=0
 F  S XPDIT=$O(XPDT(XPDIT)) Q:$D(DIRUT)!(XPDIT'>0)  D
 . S D0=+XPDT(XPDIT) D PNT("XPD(9.6,D0)")
 Q
 ;
LST2 ;Print from XPDT array
 K DIRUT N XPDIT S XPDIT=0
 F  S XPDIT=$O(XPDT(XPDIT)) Q:$D(DIRUT)!(XPDIT'>0)  D
 . S XPDA=+XPDT(XPDIT),D0=$O(^XTMP("XPDI",XPDA,"BLD",0)) D PNT("XTMP(""XPDI"",XPDA,""BLD"",D0)")
 Q
 ;
PNT(XPDGR) ;print a package, XPDGR=global root
 ;XPDFL=0 - Build - ^XPD(9.7 global root, 1 - Install - ^XTMP global root
 ;2 - Packman ^TMP($J, global root
 N I,J,K,X,XPD,XPDDT,XPDI,XPD0,XPDFL,XPDPG,XPDUL,XPDTYPE,XPDTRACK,XPDTXT,XPDOUT
 Q:$G(XPDGR)=""  S XPDGR="^"_XPDGR
 Q:'$D(@XPDGR@(0))
 S XPD0=^(0),XPDPG=1,XPDFL=$S($E(XPDGR,1,5)="^TMP(":2,1:$E(XPDGR,1,5)="^XTMP"),$P(XPDUL,"-",IOM)="",XPDDT=$$HTE^XLFDT($H,"1PM"),XPDTYPE=+$P(XPD0,U,3),XPDTRACK=$P(XPD0,U,5)
 W:$E(IOST,1,2)="C-" @IOF D HDR W XPDUL,!
 W "TYPE: ",$$EXTERNAL^DILFD(9.6,2,"",XPDTYPE)
 W !,"TRACK NATIONALLY: ",$$EXTERNAL^DILFD(9.6,5,"",XPDTRACK)
 W !,"NATIONAL PACKAGE: ",$P($G(^DIC(9.4,+$P(XPD0,U,2),0),$P(XPD0,U,2)),U)
 W !,"DESCRIPTION:",!
 S (XPDI,XPDOUT)=0
 F  S XPDI=$O(@XPDGR@(1,XPDI)) Q:'XPDI  S XPDTXT=$G(^(XPDI,0)) D  Q:XPDOUT
 . I $L(XPDTXT)'<IOM,$E(XPDTXT,$L(XPDTXT))=" " F  S XPDTXT=$E(XPDTXT,1,$L(XPDTXT)-1) Q:$E(XPDTXT,$L(XPDTXT))'=" "
 . F  D  Q:$L(XPDTXT)<IOM!XPDOUT!(IOM<2)  S XPDTXT=$E(XPDTXT,IOM,999)
 . . W $S(IOM>1:$E(XPDTXT,1,IOM-1),1:XPDTXT),!
 . . S XPDOUT=$$CHK(2)
 Q:$D(DIRUT)  G:XPDTYPE=1 MULT
 W !,"ENVIRONMENT CHECK : ",$G(@XPDGR@("PRE"))
 W ?47,"DELETE ENV ROUTINE: ",$S($P($G(@XPDGR@("INID")),U)="y":"Yes",1:"No")
 W !
 I 'XPDTYPE D
 . W " PRE-INIT ROUTINE : ",$G(@XPDGR@("INI"))
 . W ?42,"DELETE PRE-INIT ROUTINE: ",$S($P($G(@XPDGR@("INID")),U,3)="y":"Yes",1:"No")
 . W !
 Q:$$CHK(4)  W "POST-INIT ROUTINE : ",$G(@XPDGR@("INIT"))
 W ?41,"DELETE POST-INIT ROUTINE: ",$S($P($G(@XPDGR@("INID")),U,2)="y":"Yes",1:"No")
 W !
 W:'XPDTYPE "PRE-TRANSPORT RTN : ",$G(@XPDGR@("PRET")),!
 G:XPDTYPE=2 GLOBAL
 I '$O(@XPDGR@(4,0)) Q:$$CHK(4)  G COMP
 S I=$$CHK(10,1) Q:I  I '$P(I,"^",2) W !! D HDR1 W XPDUL,!
PNT2 S XPDI=0 F  S XPDI=$O(@XPDGR@(4,XPDI)) Q:'XPDI  S XPD=$G(^(XPDI,222)) Q:$$CHK(4,1)  D
 .;file number, file name, partial DD
 .W !,XPDI,?12,$S('XPDFL:$P($G(^DIC(XPDI,0),"**unknown**"),U),1:$G(^XTMP("XPDI",XPDA,"FIA",XPDI)))
 .W ?41,$$EXTERNAL^DILFD(9.64,222.1,"",$P(XPD,U)),?47,$$EXTERNAL^DILFD(9.64,222.2,"",$P(XPD,U,2)),?53,$$EXTERNAL^DILFD(9.64,222.7,"",$P(XPD,U,7))
 .W ?60,$E($$EXTERNAL^DILFD(9.64,222.8,"",$P(XPD,U,8)),1,4),?67,$$EXTERNAL^DILFD(9.64,222.5,"",$P(XPD,U,5)),?73,$$EXTERNAL^DILFD(9.64,222.9,"",$P(XPD,U,9)),!
 .;print partial DD information
 .I $P(XPD,U,3)="p" S J=0 D
 ..W "Partial DD:"
 ..F  S J=$O(@XPDGR@(4,"APDD",XPDI,J)) Q:'J  W ?12,"subDD: ",J D  Q:$$CHK(4,1)
 ...I '$O(@XPDGR@(4,"APDD",XPDI,J,0)) W ! Q
 ...S I=0 F  S I=$O(@XPDGR@(4,"APDD",XPDI,J,I)) Q:'I  W ?30,"fld: ",I,!
 .I $D(@XPDGR@(4,XPDI,223)) W ?2,"DD SCREEN  : ",^(223),!
 .I $D(@XPDGR@(4,XPDI,224)) W ?2,"DATA SCREEN: ",^(224),!
COMP Q:$D(DIRUT)  W ! Q:$$CHK(3)  S I=0,XPD=$P(^DD(9.68,.03,0),U,3)
 ;print build components
 F  S I=$O(@XPDGR@("KRN",I)),K=0,J="" Q:$D(DIRUT)!'I  F  S J=$O(@XPDGR@("KRN",I,"NM","B",J)) Q:J=""  S X=$O(^(J,0)) Q:$$CHK(4)  D:X
 .S X=$G(@XPDGR@("KRN",I,"NM",X,0)) Q:X=""
 .;K is flag to write type of component
 .I 'K W !,$S($D(^DIC(I,0)):$P(^(0),U),XPDFL:$G(^XTMP("XPDI",XPDA,"FIA",I),"UNKNOWN"),1:"UNKNOWN")_":",! S K=1
 .;write the entry name and write the action
 .W ?3,$P(X,U),?50,$P($P(XPD,";",$P(X,U,3)+1),":",2),!
 Q:XPDFL=2
 ;XPDFL=2 this is a Packman message, called from XMP2 - Summarize
 ;XPDFL=1 this is a Install, the call backs are already Build Components
 Q:$D(DIRUT)  Q:$$CHK(3)
 I $O(@XPDGR@("QUES",0)) W !,"INSTALL QUESTIONS: " S I=0 D
 .F  S I=$O(@XPDGR@("QUES",I)) Q:'I  S X=$P(^(I,0),U),J=$G(^(1)),K=$G(^("A")) Q:$$CHK(5)  D
 ..W !?5,"SUBSCRIPT: ",X,!,"DIR(0)=",J W:K]"" !,"DIR(""A"")=",K,!
 ..F J=1:1 Q:'$D(@XPDGR@("QUES",I,"A1",J,0))  W "DIR(""A"",",J,")=",^(0),!
 ..I $G(@XPDGR@("QUES",I,"B"))]"" W "DIR(""B"")=",^("B"),!
 ..I $G(@XPDGR@("QUES",I,"Q"))]"" W "DIR(""?"")=",^("Q"),!
 ..F J=1:1 Q:'$D(@XPDGR@("QUES",I,"Q1",J,0))  W "DIR(""?"",",J,")=",^(0),!
 ..I $G(@XPDGR@("QUES",I,"QQ"))]"" W "DIR(""??"")=",^("QQ"),!
 ..I $G(@XPDGR@("QUES",I,"M"))]"" W "M CODE: ",^("M"),!
 Q:$D(DIRUT)  Q:$$CHK(3)
 I $L($G(@XPDGR@("ABPKG"))) S XPD=^("ABPKG") D:$P(XPD,U)="y"
 .W !,"ALPHA/BETA TESTING:",$$EXTERNAL^DILFD(9.6,20,"",$P(XPD,U)),?40,"INSTALLATION MESSAGE: ",$$EXTERNAL^DILFD(9.6,21,"",$P(XPD,U,2))
 .W !,"ADDRESS: ",$P(XPD,U,3),!!,"INCLUDE NAMESPACE",?30,"EXCLUDE NAMESPACE" S I=0
 .F  S I=$O(@XPDGR@("ABNS",I)),J=0 Q:'I  W !?5,^(I,0) F  S J=$O(@XPDGR@("ABNS",I,1,J)) Q:'J  W ?35,^(J,0),! Q:$$CHK(3)
REQB Q:$D(DIRUT)  Q:$$CHK(4)
 I $O(@XPDGR@("REQB",0)) W !,"REQUIRED BUILDS:",?50,"ACTION:" D
 .S XPDI=0 F  S XPDI=$O(@XPDGR@("REQB",XPDI)) Q:'XPDI  S XPD=$G(^(XPDI,0)) Q:$$CHK(4,1)  D
 ..W !?3,$P(XPD,U),?50,$$EXTERNAL^DILFD(9.611,1,"",$P(XPD,U,2))
 Q
GLOBAL ;globals listing
 S I=$$CHK(8,1) Q:I  I '$P(I,"^",2) W !!,"GLOBAL:",?20,"KILL GLOBAL BEFORE INSTALL:"
 S XPDI=0 F  S XPDI=$O(@XPDGR@("GLO",XPDI)) Q:'XPDI  S XPD=$G(^(XPDI,0)) Q:$$CHK(4,1)  D
 .W !?3,$P(XPD,U),?33,$$EXTERNAL^DILFD(9.65,1,"",$P(XPD,U,2))
 W ! Q
 ;
MULT ;multiple-package
 S I=$$CHK(10,1) Q:I  I '$P(I,"^",2) W !,"SEQUENCE OF BUILDS:"
 S XPDI=0 F  S XPDI=$O(@XPDGR@(10,XPDI)) Q:'XPDI  S XPD=$G(^(XPDI,0)) Q:$$CHK(4,1)  D
 .W !?2,XPDI,?8,$E($P(XPD,U),1,44),?54,$S($P(XPD,U,2)=1:"",1:"Not ")_"Required to Continue"
 W ! Q
 ;
 ;return 0 if header was not written, else "0^1"
CHK(Y,XPD) ;Y=excess lines XPD=1 print file header, return 1 to exit
 Q:$Y<(IOSL-Y) 0
 I $E(IOST,1,2)="C-" D  Q:'Y 1
 .N DIR,I,J,K,X
 .S DIR(0)="E" D ^DIR
 S XPD=$G(XPD),XPDPG=XPDPG+1
 W @IOF D HDR,HDR1:XPD
 W XPDUL,!
 Q "0^1"
 ;
XMP2(X,D0) ;called from ^XMP2
 N XPDA S XPDA=-1
 D PNT(X) Q
 ;
HDR W !,"PACKAGE: ",$P(XPD0,U),"     ",XPDDT,?70,"PAGE ",XPDPG,!
 Q
HDR1 W ?41,"UP",?47,"SEND",?53,"DATA",?73,"USER",!,?41,"DATE",?47,"SEC.",?53,"COMES",?60,"SITE",?67,"RSLV",?73,"OVER"
 W !,"FILE #",?12,"NAME",?41,"DD",?47,"CODE",?53,"W/FILE",?60,"DATA",?67,"PTS",?73,"RIDE",!
 Q
