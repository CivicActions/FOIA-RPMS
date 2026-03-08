GMTSP48 ; SLC/KER - Post-Install for GMTS*2.7*48      ; 08/02/2001
 ;;2.7;Health Summary;**48**;Oct 20, 1995
 Q
 ;                   
 ; External References
 ;   DBIA 10060  ^VA(200) 
 ;   DBIA 10013  ^DIK
 ;   DBIA 10013  IX1^DIK
 ;   DBIA 10141  BMES^XPDUTL
 ;   DBIA 10141  MES^XPDUTL
 ;   DBIA 10086  HOME^%ZIS
 ;   DBIA  1023  $$ADDSEG^VAQUTL50
 ;   DBIA 10112  $$SITE^VASITE
 ;   DBIA 10103  $$DT^XLFDT
 ;   DBIA 10103  $$FMTE^XLFDT
 ;   DBIA 10103  $$NOW^XLFDT
 ;   DBIA 10070  ^XMD
 ;   DBIA 10141  $$VERSION^XPDUTL
 ;   DBIA 10096  ^%ZOSF("UCI")
 ;   DBIA   820  ^VAT(394.71)
 ;   ^XPD(9.7)
 ;   ^XTV(8989.5)
 ;   ^XTV(8989.51)
 ;                   
 ; Variables not Newed or Killed
 ;   GMTSQT  Checked and not changed
 ;   XPDNM   Checked and not changed
 ;                   
POST ; Post-Install
 S U="^" D BM("  Remote Health Summary Types"),SET,CHK,BM("  <Done>") Q
SET ; Set Record
 N GMI,X,GMC S GMC=1 S GMI=5000015,X="REMOTE ONCOLOGY VIEW" D MSGS((GMI_U_X))
 D:+($D(^GMT(142,+GMI))) K(+GMI) S ^GMT(142,5000015,0)=X_"^GMTSMGR",^GMT(142,5000015,1,0)="^142.01IA^10^2"
 D ST(GMI,5,"5^2"),ST(GMI,10,"10^236^^"),TT(GMI,"Oncology View"),I(+GMI)
 Q
ST(T,S,X) ; Set Structure
 S T=+$G(T),S=+$G(S),X=$G(X) Q:T=0  Q:S=0  Q:$L(X)=0
 N C,H S C=+($P($G(X),"^",2)),H=$P($G(^GMT(142.1,+C,0)),"^",9)
 S:$L(H)&($P(X,"^",5)="") $P(X,"^",5)=H S ^GMT(142,T,1,S,0)=X Q
TT(T,X) ; Set Title and Timestamp
 S T=+$G(T),X=$G(X) Q:T=0  Q:$L(X)=0  S ^GMT(142,T,99)=$H
 S ^GMT(142,T,"T")=X,^GMT(142,T,"VA")=2,$P(^GMT(142,T,0),"^",4)="Y"
 S:$D(^VA(200,.5,0)) $P(^GMT(142,T,0),"^",3)=.5 Q
 Q
K(X) ; Kill Old Record
 N DA,DIK S DA=+($G(X)),DIK="^GMT(142," Q:+($G(DA))=0  D ^DIK Q
IALL ; Reindex All Records
 K ^GMT(142,"AB"),^GMT(142,"AE"),^GMT(142,"AW"),^GMT(142,"B")
 K ^GMT(142,"C"),^GMT(142,"D"),^GMT(142,"E") S U="^"
 N DA S DA=0 F  S DA=$O(^GMT(142,DA)) Q:+DA=0  D I(DA)
 Q
I(X) ; Index Single Record
 N DA,DIK,P,P3,P4 S DA=+($G(X)),DIK="^GMT(142," Q:+($G(DA))=0
 S (P,P3,P4)=0 F  S P=$O(^GMT(142,DA,1,P)) Q:+P=0  S P3=P,P4=P4+1
 S ^GMT(142,DA,1,0)="^142.01IA^"_P3_"^"_P4 D IX1^DIK Q
 ;
CHK ; Check Oncology Component and Type
 N ENV S ENV=$$ENV Q:+ENV'>0  K ^TMP("GMTSONC",$J)
 D INT,M(" "),M("    Checking Oncology Health Summary Component and Type in"),M("    the Patient Data Exchange (PDX) Data Segment file #394.71")
 D VER,PAT,COM,CPH,ADH,PDX,RDV,PAR,MAIL Q
INT ;   Introduction
 N X,Y,STR S:'$D(DT) DT=$$DT^XLFDT
 S X=" Health Summary Oncology Component/Type Installation" D S(X),S("")
 S STR=$P($$SITE^VASITE,"^",2) I $L(STR) S X="   Location:  "_STR D S(X)
 S Y="" X ^%ZOSF("UCI") S STR=$G(Y) I $L(STR) S X="   Account:   "_STR D S(X)
 S STR=$TR($$FMTE^XLFDT($$NOW^XLFDT,"5ZM"),"@"," ") I $L(STR) S X="   As of:     "_STR D S(X)
 D S(" ")
 Q
VER ;   Oncology Version #
 N X S X=$$VN S:+X=0 X="Not Installed" D DS("Oncology Package Version",X) Q
 ;
PAT ;   Oncology Last Patch # and Date
 N CTL,IDT,GMTSD,I,LI,LP,LPI,LPS,PCH,SEQ
 I +($$VN)=0 D DS("Oncology Package Last Patch","None") Q
 S (LP,LPI)="",(CTL,PCH)="ONC*"_+($$VN)_"*"
 F  S PCH=$O(^XPD(9.7,"B",PCH)) Q:PCH=""!(PCH'[CTL)  D
 . S I=0  F  S I=$O(^XPD(9.7,"B",PCH,I)) Q:+I=0  D
 . . Q:'$L($P($G(^XPD(9.7,+I,0)),"^",1))  Q:$P($G(^XPD(9.7,+I,0)),"^",9)'=3
 . . S IDT=$P($G(^XPD(9.7,+I,1)),"^",3) Q:+IDT'>+($G(LI))  S LI=+IDT
 . . S SEQ=+($P($P($G(^XPD(9.7,+I,2)),"^",1),"SEQ #",2)),LPS=$S(+SEQ>0:+SEQ,1:"")
 . . S LP=$P($G(^XPD(9.7,+I,0)),"^",1),LPI=$TR($$FMTE^XLFDT(IDT,"5ZM"),"@"," ")
 . . S:$L(LPS) LP=LP_" SEQ #"_LPS
 S:'$L($G(LP))!('$L($G(LPI))) LP="",LPI="None"
 D DS(("Oncology Package Last Patch "_LP),LPI)
 Q
COM ;   Oncology Component Installed file #142.1
 N X,FLG,OUT Q:+($$CI)'>0  I +($$VN)>0,+($$CI)>0 D
 . S $P(^GMT(142.1,+($$CI),0),"^",6)="",$P(^GMT(142.1,+($$CI),0),"^",8)=""
 S FLG=$P($G(^GMT(142.1,+($$CI),0)),"^",6)
 S OUT=$P($G(^GMT(142.1,+($$CI),0)),"^",8)
 S X="" S:FLG="T" X="Temporarily Disabled"
 S:$L(OUT) X="Out of Order"
 S:FLG="P" X="Permanently Disabled"
 S:'$L(X) X="GMTSONE Installed"
 D DS(("Health Summary Oncology Component Installed"),X)
 Q
CPH ;   Oncology Component Patches (GMTSONE)
 N X S X=$T(@("+2^GMTSONE")),X=$S(X["*":$P($P(X,"**",2),"**",1),'$L(X):"Not Found",1:"")
 D DS("Health Summary Oncology Component Patch(es)",X)
 Q
ADH ;   Oncology Component in Ad Hoc file #142
 I +($$AI)>0,'$D(^GMT(142,+($$AI),1,"C",+($$CI))) D
 . D DS(("  Rebuilding Ad Hoc Health Summary Type"),"") N GMTSQT S GMTSQT=1 D BUILD^GMTSXPD3
 I +($$AI)>0,$D(^GMT(142,+($$AI),1,"C",+($$CI))) D
 . D DS(("Health Summary Adhoc Oncology Component"),"Installed in Ad Hoc")
 Q
PDX ;   Oncology Component in PDX file #394.71
 I '$D(^VAT(394.71,"C","ONC")) D
 . D DS(("  Adding Health Summary PDX Oncology Segment"),"") N GMTSERR S GMTSERR=$$ADDSEG^VAQUTL50(+($$CI),"","")
 I $D(^VAT(394.71,"C","ONC")) D
 . D DS(("Health Summary PDX Oncology Segment"),"Installed in PDX")
 I '$D(^VAT(394.71,"C","ONC")) D
 . D DS(("Health Summary PDX Oncology Segment"),"Not Installed")
 Q
RDV ;   Oncology Remote Data View Type Installed file #142
 I +($$RI)>5000000 D
 . N X D DS(("Health Summary Remote Oncology View"),"Installed RDV")
 . S X=$$PROK^GMTSU("ORWRP",85),X=$S(+X>0:"Installed",1:"Not Installed")
 . D DS(("CPRS GUI Remote Data View"),X)
 Q
PAR ;   Oncology RDV Parameters Setup file #8989.51
 N X,ENT,SEQ,PAR,SYS,TYP,USR
 S PAR=+($O(^XTV(8989.51,"B","ORWRP HEALTH SUMMARY TYPE LIST",0)))
 S TYP=+($O(^GMT(142,"B","REMOTE ONCOLOGY VIEW",0)))
 I TYP>0 D
 . S ENT="" F  S ENT=$O(^XTV(8989.5,"AC",+PAR,ENT)) Q:ENT=""  D
 . . S SEQ=0 F  S SEQ=$O(^XTV(8989.5,"AC",+PAR,ENT,SEQ)) Q:+SEQ=0  D
 . . . Q:+($G(^XTV(8989.5,"AC",+PAR,ENT,SEQ)))'=TYP
 . . . S:ENT["VA(" USR=+($G(USR))+1  S:ENT["DIC(4.2" SYS=+($G(SYS))+1
 . S X="" S:+($G(SYS))>0 X="System"
 . S:+($G(USR))>0&($L(X)) X=X_"/"_+($G(USR))_" User"_$S(+($G(USR))>1:"s",1:"")
 . S:+($G(USR))>0&(X="") X=+($G(USR))_" User"_$S(+($G(USR))>1:"s",1:"")
 . S:'$L(X) X="Not Setup"
 . D DS(("Health Summary Remote Oncology Parameter Setup"),X)
 I TYP'>0 D DS(("Health Summary Remote Oncology Parameter Setup"),"Not Setup")
 Q
 ;                
 ; Miscellaneous
ENV(X) ;   Environment check
 D HOME^%ZIS S U="^",DT=$$DT^XLFDT Q:'$D(^VA(200,+($G(DUZ)),0)) 0  Q:'$L($P($G(^VA(200,+($G(DUZ)),0)),"^",1)) 0  Q:'$D(DUZ(0)) 0
 Q 1
CI(X) ;   Component IEN
 Q +($O(^GMT(142.1,"C","ONC",0)))
RI(X) ;   Remote Type INE
 Q +($O(^GMT(142,"B","REMOTE ONCOLOGY VIEW",0)))
AI(X) ;   Ad Hoc IEN
 Q +($O(^GMT(142,"B","GMTS HS ADHOC OPTION",0)))
VN(X) ;   Version Number
 Q $$VERSION^XPDUTL("ONCOLOGY")
DS(X,Y) ;   Display/Save
 N STR Q:'$L($G(X))  S Y=$G(Y),STR="      "_X F  Q:$L(STR)>55  S STR=STR_" "
 S STR=STR_Y D:$D(TEST)&($E(X,1)'=" ") M(STR) D:$E(X,1)=" " M(STR) D:$E(X,1)'=" " S(STR)
 Q
S(X) ;   Save
 N I S X=$G(X) S I=+($G(^TMP("GMTSONC",$J,0)))+1,^TMP("GMTSONC",$J,I)=X,^TMP("GMTSONC",$J,0)=I Q
MAIL ;   Mail global array in message
 N DIFROM S U="^",XMSUB="Oncology Health Summary Status"
 S XMY("G.GMTS@ISC-SLC.VA.GOV")="",XMTEXT="^TMP(""GMTSONC"",$J,",XMDUZ=.5 D ^XMD
 K ^TMP("GMTSONC",$J),%Z,XCNP,XMSCR,XMDUZ,XMY("G.GMTS@ISC-SLC.VA.GOV"),XMZ,XMSUB,XMY,XMTEXT,XMDUZ Q
 Q
SH ;   Show ^TMP
 N NN,NC S NN="^TMP(""GMTSONC"","_$J_")",NC="^TMP(""GMTSONC"","_$J_","
 F  S NN=$Q(@NN) Q:NN=""!(NN'[NC)  W !,@NN
 Q
MSGS(X) ;   Status Messages
 Q:'$L($G(X))  D:+($G(GMC))=1 INS1($P(X,"^",2)) D:+($G(GMC))'=1 INS($P(X,"^",2))
 S GMC=GMC+1 Q
INS1(X) ;     Install message (first)
 S X=$G(X) D:$L(X) BM("    Installing:  "_X) Q
INS(X) ;     Install message (other)
 S X=$G(X) D:$L(X) M("                 "_X) Q
BM(X) ;     Blank Line with Message
 Q:$D(GMTSQT)  D:$D(XPDNM) BMES^XPDUTL($G(X)) W:'$D(XPDNM) !!,$G(X) Q
M(X) ;     Message
 Q:$D(GMTSQT)  D:$D(XPDNM) MES^XPDUTL($G(X)) W:'$D(XPDNM) !,$G(X) Q
UP(X) ;     Uppercase
 Q $TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
