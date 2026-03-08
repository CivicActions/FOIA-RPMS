DIKZ ;SFISC/XAK-XREF COMPILER ;8:28 AM  30 Oct 1996 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**6,24**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 I $G(DUZ(0))'="@" W $C(7),$$EZBLD^DIALOG(101) Q
EN1 N DIKJ,%X D:'$D(DISYS) OS^DII
 I '$D(^DD("OS",DISYS,"ZS")) W $C(7),$$EZBLD^DIALOG(820) Q
 S U="^" S:'$G(DTIME) DTIME=300
 D SIZ^DIPZ0(8036) G:$D(DTOUT)!($D(DUOUT))!('X) Q1 S DMAX=X
FILE K DIC S DMAX=X,DIC="^DIC(",DIC(0)="AEQ" D ^DIC G Q1:Y'>0 N DIPZ S DIPZ=+Y
 D RNM^DIPZ0(8036) G:$D(DTOUT)!($D(DUOUT))!(X="") Q1 S DNM=X
 W ! S DIR(0)="Y",DIR("A")=$$EZBLD^DIALOG(8020) D ^DIR K DIR G:'Y!($D(DIRUT)) Q1
 S X=DNM,Y=DIPZ K DIPZ
EN ;
 S Y(1)=$$EZBLD^DIALOG(8036),Y(3)=Y D BLD^DIALOG(8024,.Y,"","DIR") W:'$G(DIKZS) !!,DIR,! K Y(1),Y(3)
 K ^UTILITY($J),^UTILITY("DIK",$J) N DIK,DIFILENO
 S DNM=X,(DH,DIFILENO)=+Y I $D(^DIC(+Y,0,"GL")) S DIK2=^("GL")
 I '$D(DIK2)!(DMAX<2400) G Q
 S X=DH D A^DIU21,WAIT^DICD:'$G(DIKZS),DT^DICRW,OS^DII:'$D(DISYS) S (DIKA,A)=1,(DRN,DIKZQ,T)=0
 S DIKGO="^"_DNM_1,DMAX=DMAX-100,DIK=DIK2,X=2,DIKVR="DIKILL"
 D NEWR S ^UTILITY($J,0,3)=" S DIKZK=2" D ^DIKZ0 G:DIKZQ Q D RTE
 S (X,DIKA,A)=1,DIKVR="DISET",DIK=DIK2
 D Q2,NEWR S ^UTILITY($J,0,3)=" S DIKZK=1",DIKGO=DIKGO_",^"_DNM_DRN
 D ^DIKZ0 G:DIKZQ Q D RTE,Q2,^DIKZ1
 S:'DIKZQ ^DD(DIFILENO,0,"DIKOLD")=DNM
Q I DIKZQ S X=DH(1) D A^DIU21
Q1 K DH,X,Y,DIK4,DIKQ,DIKC,T,DV,DIK8,DU,DW,DW1,DIKGO,DRN,DNM,DTOUT,DIRUT,DIROUT,DUOUT,DIC,A,%,%H,%Y
 K DIKVR,DIK6,DIKA,DIKR,DMAX,DIK2,DIKCT,DIK1,DIK0,^UTILITY($J),^("DIK"),DIK,DIKZQ,DIKZZ,DIKZZ1,DIKZOVFL
Q2 K DIKRT,DIKLW,DIKL2
 Q
SV S DNM(1)=DNM_DRN
 F DIKR=0:0 S DIKR=$O(^UTILITY($J,DIKR)) Q:DIKR'>0  S %=^(DIKR) K ^(DIKR) D SAVE:T+$L(%)>DMAX S ^UTILITY($J,0,DIKR)=%,T=T+$L(%)+2
SAVE I DIKR,$E($P(%," ",2))="." F  D  Q:$E($P(%," ",2))'="."
 . S ^UTILITY($J,DIKR)=%
 . S DIKR=$O(^UTILITY($J,0,DIKR),-1),%=^(DIKR) K ^(DIKR)
 . S T=T-$L(%)-2
 I $D(DIKLW),'DIKR S ^UTILITY($J,0,997)=" G:'$D(DIKLM) "_$C(64+DIKCT)_$S(DNM_DRN'=DNM(1):"^"_DNM(1),1:"")_" Q:$D("_DIKVR_")"
 I $D(DIKLW),DIKR S ^UTILITY($J,0,998)=" G ^"_DNM_(DRN+1)
 S ^UTILITY($J,0,999)="END "_$S($D(DIKRT)&'DIKR:"Q",1:"G "_$S(DIKR&($D(DIKLW)):"END",1:"")_U_DNM_(DRN+1))
 N X,DIR S X=DNM_DRN X ^DD("OS",DISYS,"ZS") S X(1)=X D BLD^DIALOG(8025,.X,"","DIR") W:'$G(DIKZS) !,DIR S:$G(DIKZRLA)]"" @DIKZRLA@(DNM_DRN)="",DIKZRLAF=1
 D NEWR:'$D(DIKRT)!(T+$L(%)>DMAX) Q:DIKZQ  S ^DD(DH,0,"DIK")=DNM K DIKL2
 Q
NEWR ;
 I '$D(DIKRT)&(T+$L(%)>DMAX) S DIKZDH=+$P(^UTILITY($J,0,1),"#",2)
 K ^UTILITY($J,0) S DIKR=4,T=0,DRN=DRN+1 I $L(DNM_DRN)>8 W:'$G(DIKZS) $C(7),!,DNM_DRN_$$EZBLD^DIALOG(1503) S:$G(DIKZRLA)]"" DIKZRLAF=0 S DIKZQ=1 Q
 S ^UTILITY($J,0,1)=DNM_DRN_" ; COMPILED XREF FOR FILE #"_$S($D(DIKZDH):DIKZDH,1:DH)_" ; "_$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3),^(2)=" ; "
 K DIKZDH Q
RTE ;
 F DIK4=0:0 S DIK4=$O(DIK(X,DIK4)) Q:DIK4'>0  S DIKQ=DIK4,DH=2 F DIK6=0:0 S DIK6=^DD(DIKQ,0,"UP") Q:DIK6'>0!(^("UP")=DH(1))  D RTE1
 S DIKRT=1,A=A-1,DH=DH(1) G SV
 ;
RTE1 ;
 I DIK(X,DIK6)[$P(DIK(X,DIKQ),",") S DIK(X,DIK6)=DIK(X,DIK6)_","_$P(DIK(X,DIKQ),",",DH,999),DIKQ=DIK6,DH=DH+1 Q
 S DIK(X,DIK6)=DIK(X,DIK6)_","_DIK(X,DIKQ),DIKQ=DIK6
 Q
 ;
EN2(Y,DIKZFLGS,X,DMAX,DIKZRLA,DIKZZMSG) ;Silent or Talking with parameter passing
 ;and optionally return list of routines built and if successful
 ;FILE#,FLAGS,ROUTINE,RTNMAXSIZE,RTNLISTARRAY,MSGARRAY
 ;Y=FILE NUMBER (required)
 ;FLAGS="T"alk (optional)
 ;X=ROUTINE NAME (required)
 ;DMAX=ROUTINE SIZE (optional)
 ;DIKZRLA=ROUTINE LIST ARRAY, by value (optional)
 ;DIKZZMSG=MESSAGE ARRAY (optional) (default ^TMP)
 ;*
 ;DIKZS will be used to indicate "silent" if set to 1
 ;Write statements are made conditional, if not "silent"
 ;*
 N DIKZS,DNM,DIQUIET,DIKZRIEN,DIKZRLAZ,%X,DIKJ,DIR,DIKZRLAF,DK1
 N DIK,DIC,%I,DICS
 S DIKZS=$G(DIKZFLGS)'["T"
 S:DIKZS DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1 D
 .N Y,DIKZFLGS,X,DMAX,DIKZRLA,DIKZS
 .D INIZE^DIEFU
 I $G(Y)'>0 D BLD^DIALOG(1700,"File Number missing or invalid") G EN2E
 I '$D(^DD(Y,0)) D BLD^DIALOG(1700,"File Number: "_Y_" Invalid") G EN2E
 I $G(X)']"" D BLD^DIALOG(1700,"Routine name missing") G EN2E
 I X'?1U.NU&(X'?1"%"1U.NU) D BLD^DIALOG(1700,"Routine name invalid") G EN2E
 I $L(X)>7 D BLD^DIALOG(1700,"Routine name too long") G EN2E
 S DIKZRLA=$G(DIKZRLA,"DIKZRLAZ"),DIKZRIEN=Y
 S:DIKZRLA="" DIKZRLA="DIKZRLAZ" S:$G(DMAX)<2500!($G(DMAX)>^DD("ROU")) DMAX=^DD("ROU")
 S DIKZRLAF=""
 K @DIKZRLA
 D EN
 G:'DIKZS!(DIKZRLAF) EN2E
 D BLD^DIALOG(1700,"Compiling Cross-references (FILE#:"_DIKZRIEN_")"_$S(DIKZRLAF=0:", routine name too long",1:""))
EN2E I 'DIKZS D MSG^DIALOG() Q
 I $G(DIKZZMSG)]"" D CALLOUT^DIEFU(DIKZZMSG)
 Q
 ;
 ;DIALOG #101    'only those with programmer's access'
 ;       #820    'no way to save routines on the system'
 ;       #8020   'Should the compilation run now?'
 ;       #8024   'Compiling template name Input template of file n'
 ;       #8036   'Cross-References'
 ;       #8025   'Routine filed'
 ;       #1503   'routine name is too long...'
