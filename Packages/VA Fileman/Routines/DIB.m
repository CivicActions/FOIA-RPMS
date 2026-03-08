DIB ;SFISC/GFT,XAK-CREATE A NEW FILE ;7/8/94  14:42 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 W !! K DLAYGO,DTOUT D W^DICRW G Q:$D(DTOUT) K DICS,DIA Q:Y<0
1 Q:'$D(@(DIC_"0)"))  I $P($G(^DD(+$P(@(DIC_"0)"),U,2),0,"DI")),U,2)["Y" W !!,$C(7),"RESTRICTED"_$S($P(^("DI"),U)["Y":" (ARCHIVE)",1:"")_" FILE - NO EDITING ALLOWED!" Q
 S:$D(@(DIC_"0)")) DIA=DIC,X=^(0),(DI,J(0),DIA("P"))=+$P(X,U,2)
 D QQ S DR="",(L,DRS,DIAP,DB,DSC)=0,F=-1,I(0)=DIA,DXS=1
 D EN^DIA:$O(^DD(DI,.01))>0 I $D(DR) G ^DIA2
Q K DI,DLAYGO,DIA,I,J
QQ K ^UTILITY($J),DIAT,DIAB,DIZ,DIAO,DIAP,DIAA,IOP,DSC,DHIT,DRS,DIE,DR,DA,DG,DIC,F,DP,DQ,DV,DB,DW,D,X,Y,L,DIZZ Q
 ;
DIE ;
 S F=+Y,(DG,X)="^DIZ("_F_","
 I DUZ(0)="@" W !!,"INTERNAL GLOBAL REFERENCE: "_DG R "// ",X:DTIME S:'$T X="^" S:X="" X=DG I X?."?" W !,"TYPE A GLOBAL NAME, LIKE '^GLOBAL(' OR '^GLOBAL(4,'",!,"OR JUST HIT 'RETURN' TO STORE DATA IN '"_DG_"'" G DIE
 I X?1"^".E S X=$P(X,U,2,9) I X?.P W !?9,$C(7),"NO NEW FILE CREATED!" S DIK="^DIC(",DA=F K DG G ^DIK
 I "(,"[$E(X,$L(X)),X?1A.E!(X?1"%".E)!(X?1"[".E1"]"1AP.E) S DG=U_X,@("%=$O("_DG_"0))=""""") G SET:% W !,$C(7),"WARNING -- "_DG_" ALREADY EXISTS!  " G SET:DUZ(0)'="@" W "--OK" D YN^DICN G SET:%=1
 W $C(7),"??" G DIE
SET D WAIT^DICD S $P(^DIC(F,0),U,2)=F,^("%A")=DUZ_U_DT,X=$P(^(0),U,1),^(0,"GL")=DG
 I DUZ(0)]"" F %="DD","DEL","RD","WR","LAYGO","AUDIT" S ^(%)=DUZ(0)
 I DUZ(0)'="@",$S($D(^VA(200,"AFOF")):1,1:$D(^DIC(3,"AFOF"))) D SET1
 S %="" I @("$D("_DG_"0))") S %=^(0)
 S @(DG_"0)=X_U_F_U_$P(%,U,3,9)")
 K ^DD(F) S ^(F,0)="FIELD^^.01^1",^DD(F,.01,0)="NAME^RF^^0;1^K:$L(X)>30!(X?.N)!($L(X)<3)!'(X'?1P.E) X"
 S ^(3)="NAME MUST BE 3-30 CHARACTERS, NOT NUMERIC OR STARTING WITH PUNCTUATION" W !?5,"A FreeText NAME Field (#.01) has been created."
 S DA="B",^DD(F,.01,1,0)="^.1",^(1,0)=F_U_DA,X=DG_""""_DA_""",$E(X,1,30),DA)",^(1)="S "_X_"=""""",^(2)="K "_X
 S DIK="^DIC(",DA=F D IX1^DIK
 S DLAYGO=F,DIK="^DD(DLAYGO,",DA=.01,DA(1)=DLAYGO G IX1^DIK
 ;
EN ; Enter here when the user is allowed to select his fields
 S DIC=DIE S:DIC DIC=$S($D(^DIC(DIC,0,"GL")):^("GL"),1:"")
 D 1:DIC]"" K DIC Q
 ;
SET1 ;
 S:'$D(^VA(200,DUZ,"FOF",0)) ^(0)="^200.032PA^"_+F_"^1" S ^(+F,0)=F_"^1^1^1^1^1^1"
 S:'$D(^DIC(3,DUZ,"FOF",0)) ^(0)="^3.032PA^"_+F_"^1" S ^(+F,0)=F_"^1^1^1^1^1^1"
 S DIK=$S($D(^VA(200)):"^VA(200,DUZ,""FOF"",",1:"^DIC(3,DUZ,""FOF"","),DA=F,DA(1)=DUZ D IX1^DIK
 Q
