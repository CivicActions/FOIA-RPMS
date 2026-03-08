AMQQMGR4 ; OHPRD/DG - OVERFLOW FROM AMQQMGR3 ;  [ 01/31/2008   5:08 PM ]
 ;;2.0;PCC QUERY UTILITY;**4,9,17,18,20,21**;FEB 07, 2007
LHEAD ; ENTRY POINT FROM AMQQMGR3 ; GETS HEADER INFO
 ;I 'AMQQLSPX S AMQQLTRM="" Q
 I AMQQLSPX S AMQQLUNT=$P($G(^LAB(60,AMQQLDFN,1,AMQQLSPX,0)),U,7)
 E  S AMQQLUNT=""
 S AMQQLHN=$P($G(^LAB(60,AMQQLDFN,.1)),U),AMQQLHL=$L(AMQQLHN),AMQQLOUT=""
 I AMQQLHN'="" G LHT
 S N=99 F I=1:1 S X=$P(AMQQLSTG,U,I) Q:X=""  I $L(X)<N S Y=X,N=$L(X)
 I N=99 Q
 S AMQQLHN=Y,AMQQLHL=N
LHT I AMQQLTYP=9 S %=$P(^LAB(60,AMQQLDFN,0),U,12),%=U_%_"0)",%=$P(@%,U,2),%=+$E(%,4,9) G LH1
 I AMQQLTYP=15 S %=8,AMQQLOUT="S X=$P(X,"" ""),X=$S(X="""":""??"",X=0:""Neg."",X=+X:(""1:""_X),1:X)" G LH1
 I AMQQLTYP=12 S AMQQLOUT="S X=$P(X,"" "") S:X'?1N X=""??"" S:X?1N X=X+1,X=$P(""Neg.;Trace;1+;2+;3+;4+"","";"",X)" G LH1
 I AMQQLTYP=11 S AMQQLOUT="S X=$S($E(X)=""P"",""Pos"",1:""Neg"")",%=4 G LH1
 I AMQQLTYP=6 S %=0,X=$P(^LAB(60,AMQQLDFN,0),U,12),X=U_X_"0)",X=$P(@X,U,3) D LOUT F I=1:1 S Y=$P(X,";",I) G:Y="" LH1 S Y=$P(Y,":",2),Y=$L(Y) I Y>% S %=Y
 I AMQQLTYP=2 S %=0,X=$P(^LAB(60,AMQQLDFN,0),U,12) Q:X=""  S X=U_X_"0)",X=$P($G(@X),U,5),%=+$P(X,"K:$L(X)>",2)
LH1 I (%+4)>AMQQLHL S AMQQLHL=(%+4)
 Q
 ;
LOUT S AMQQLOUT="N Y S Y="";"_X_""",X=$F(Y,("";""_X_"":"")),X=$E(Y,X,999),X=$P(X,"";"")"
 Q
 ;
CO ; ENTRY POINT FROM AMQQMGR3
 S %=^LAB(60,AMQQLDFN,0),%=$P(%,U),%=$P(%," ("),%=$P(%,"("),AMQQLC=%
 Q:%=""
 S AMQQLCO=% D CO2 I $D(AMQQLCOF) G COEXIT
 I $D(AMQQCONO) K AMQQCONO G COEXIT
 F AMQQLI=70:1:79 I $D(^LAB(60,AMQQLDFN,1,AMQQLI,0)) D CO1
COEXIT K AMQQLC,AMQQLCO,AMQQLI
 Q
 ;
CO1 S %=$P("BLOOD^URINE^SERUM^PLASMA^CSF^URETHRAL FLUID^PERITONEAL FLUID^PLEURAL FLUID^SYNOVIAL FLUID^CLOT",U,(AMQQLI-69)),AMQQLCO=AMQQLC_","_%
CO2 S %=$O(^AMQQ(5,"C",AMQQLCO,""))
 Q:'%
 S DA(1)=%,X=AMQQLDFN
 S DIC="^AMQQ(5,"_DA(1)_",4.1,"
 S DIC(0)="L"
 I '$D(^AMQQ(5,DA(1),4.1,0)) S ^(0)="^9009075.02PA^^"
 D ^DIC
 K DIC
 I Y'=-1 S AMQQLCOF=""
 W !,$P(^LAB(60,AMQQLDFN,0),U)," added as a companion test of ",AMQQLCO
 Q
 ;
TOP ; ENTRY POINT ; GETS TOP 40 LAB TESTS
 D CHECK ;IHS/OHPRD/TMJ 8/15/95 PATCH #9
 S I=$P(^AUPNVLAB(0),U,4)\500,G="^UTILITY(""AMQQ"",$J,""LU"")",Z="" K @G
 F X=0:0 S X=$O(^AUPNVLAB(X)) Q:'X  S Y=+^(X,0),%=$G(@G@(1,Y))+1,^(Y)=%,X=X+I W:X#2 "."
 F X=0:0 S X=$O(@G@(1,X)) Q:'X  S Y=^(X),@G@(2,(10000-Y),X)="" W:X#2 "."
 W !!!,?15,"*****  TOP 40 LAB TESTS  *****",!!!
 S I=0 F X=0:0 S X=$O(@G@(2,X)) Q:'X  F Y=0:0 S Y=$O(@G@(2,X,Y)) Q:'Y  S I=I+1 W:I#2 ! W:'(I#2) ?40 W I,") ",$E($P(^LAB(60,Y,0),U),1,30)," [",(10000-X),"]" S Z=Z_Y_U I I=40 G TOP1
TOP1 S AMQQLUST=Z D STUFF
 K @G,X,Y,Z,I,%
 Q
 ;
GET ; ENTRY POINT FOR 1 AT A TIME LAB TESTS
 D CHECK ;IHS/OHPRD/TMJ 8/15/95 PATCH #9
 S Z=""
 F  D  I Y=-1!($E(Y)=U) Q
 .I $L(Z)>235 S Y="" W !!,"I can't accept more new tests now.  If you want to add more, try again later",!! Q
 .S DIR(0)="PO^60:EMQ",DIR("A")="Lab test",DIR("?")="Enter the name of the test you want to add to the Q-Man metadictionary." D ^DIR K DIR
 .I +Y=175 D NEWGLU
 .I +Y=643 W "  <= It's already in there" Q
 .I $D(^AMQQ(5,1000+Y)) W "   <= It's already in there!" Q
 .I (U_Z)[(U_Y_U) W "   <= Already selected" Q
 .S Z=Z_Y_U
 .Q
 S AMQQLUST=Z D STUFF
 Q
 ;
STUFF W !!! F AMQQLSN=1:1 S X=$P(AMQQLUST,U,AMQQLSN) Q:X=""  D EN1^AMQQMGR3
 K AMQQLUST,AMQQLSN,X,Y,Z
 Q
 ;
LIST ; - EP - FROM ^AMQQMGR
 W !!! F X=1000:0 S X=$O(^AMQQ(5,X)) Q:'X  S Y=^(X,0),Y=$P(Y,U) W Y,", "
 K X,Y
 Q
 ;
CHECK ;
 S Z=0,X=$P(^AUPNVLAB(0),U,3)-1000 F I=1:1:1000  S X=$O(^AUPNVLAB(X)) Q:'X  I $P($G(^AUPNVLAB(X,11)),U,3) S Z=1 Q  ;IHS/OHPRD/JCM 5/31/94
 I Z
 W:'Z !!,"Specimen/site not entered into V LAB...Request cancelled",!!,*7 H 2
 K X,Z,I
 Q
 ;
NEWGLU S DA(1)=184,DIK="^AMQQ(5,"_DA(1)_",1,"
 F DA=0:0 S DA=$O(^AMQQ(5,184,1,DA)) Q:'DA  D ^DIK
 K DIK,DA
 Q
 ;
