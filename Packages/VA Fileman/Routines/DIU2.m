DIU2 ;SFISC/XAK-EDIT FILE ;7/25/94  14:39 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
N S X=$P(^DIC(DA,0),U,1),D=@(DIU_"0)"),^(0)=X_U_$P(D,U,2,9) K ^DD(+$P(D,U,2),0,"NM") S ^("NM",X)="" Q:$D(Y)
VR ;S DIR("A")="VERSION",DIR(0)="FO^1^I X'=""@"",X'?.N.1"".""1.N,X'?.N.1"".""1.N1U1.N K X"
 ;S DIR("?")="Enter the number that describes the current version of this data dictionary"
 ;S:$D(^DD(DA,0,"VR")) DIR("B")=^("VR")
 ;S DIR("??")="^W !!,""This number can be in either the old format (1.0, 16.04, etc.)"",!,""or the new format (18.0T4, 19.1V2, etc.)."""
 ;D ^DIR G Q:$D(DTOUT)!$D(DUOUT) K DIRUT
 ;I X="@" K ^DD(DA,0,"VR") W "   Deleted" S X=""
 ;I X]"" S ^DD(DA,0,"VR")=X
 ;
 I DUZ(0)]"" F DR=1:1:6 S D=$P("DD^RD^WR^DEL^LAYGO^AUDIT",U,DR),Y=$S($D(^DIC(DA,0,D)):^(D),1:"") D RW G Q:X=U
 S X=$S($D(^("AUDIT")):^("AUDIT"),1:"")
 I X]"",DUZ(0)'="@" F Z=1:1:$L(X) Q:DUZ(0)[$E(X,Z)  Q:Z=$L(X)
 S DIU(0)=$P(@(DIU_"0)"),U,2) K DIR
A ;S DIR("A")="AUDIT THE ENTIRE FILE",DIR(0)="YO",DIR("B")=$S(DIU(0)["a":"YES",1:"NO")
 ;S DIR("??")="^W !!?5,""Answer YES only if you want to audit the data changes for every field"",!?5,""in this file."""
 ;D ^DIR G Q:$D(DTOUT)!$D(DUOUT),DDA:X=""
 ;I Y,DIU(0)'["a" S DIU(0)=DIU(0)_"a",$P(@(DIU_"0)"),U,2)=DIU(0)
 ;I 'Y,DIU(0)["a" S DIU(0)=$P(DIU(0),"a")_$P(DIU(0),"a",2),$P(@(DIU_"0)"),U,2)=DIU(0)
 ;
DDA K DIR S DIR("A")="DD AUDIT",DIR(0)="YO"
 S:$D(^DD(DA,0,"DDA")) DIR("B")=$S(^("DDA")["Y":"YES",1:"NO")
 S DIR("??")="^W !!?5,""Enter 'Y' (YES) if you want to audit the Data Dictionary changes"",!?5,""for this file."""
 D ^DIR K DIR Q:$D(DTOUT)!$D(DUOUT)  S ^DD(DA,0,"DDA")=$S(Y=1:"Y",1:"N")
DIE ;D DIE^DIU21 Q:$D(DTOUT)!$D(DUOUT)
 ;
OK S %=DIU(0)'["O"+1
 W !,"ASK 'OK' WHEN LOOKING UP AN ENTRY" D YN^DICN
 I %>0 S $P(@(DIU_"0)"),U,2)=$P(DIU(0),"O")_$E("O",%)_$P(DIU(0),"O",2)
 I '% W !?5,"Answer YES to cause a lookup into this file to verify the",!?5,"selection by prompting with '...OK? YES//'." G OK
 I DUZ(0)="@",%'<0 D ^DIU21
Q K DIR,DIRUT,DTOUT,DUOUT,DIROUT Q
 ;
K ; CALLED BY ^DD(1,.01,"DEL",1,0)
 S %=2,DG=@(DIU_"0)")
 I $P($G(^DD(+$P(DG,U,2),0,"DI")),U,2)["Y" W $C(7)," CANNOT DELETE A RESTRICTED"_$S($P($G(^("DI")),U)["Y":" (ARCHIVE)",1:"")_" FILE!" Q
 I $P(DG,U,4)>1 W $C(7),!,"DO YOU WANT JUST TO DELETE THE ",$P(DG,U,4)," FILE ENTRIES,",!?9,"& KEEP THE FILE DEFINITION" D YN^DICN I %=1 G KL
 Q
KL K % S %=$L(DIU),%=$E(DIU,1,%-1)_$E(")",$E(DIU,%)=","),%Y="%(",%X=DIU_"0," D %XY^%RCR K @% S @(DIU_"0)")=$P(DG,U,1,2)_U,^DIC(DA,0,"GL")=DIU,%X="%(",%Y=DIU_"0," D %XY^%RCR K % I 1 Q
 ;
RW W !,$P("DATA DICTIONARY^READ^WRITE^DELETE^LAYGO^AUDIT",U,DR)," ACCESS: " G R:Y="" W Y I DUZ(0)'="@" F X=1:1:$L(Y) Q:DUZ(0)[$E(Y,X)  G Q:X=$L(Y)
 W "// "
R R X:DTIME S:'$T X=U,DTOUT=1 Q:X=""
 I X["@" G V:Y="" W $C(7),"   PROTECTION ERASED!" K ^(D) Q
 Q:X[U
 I X["?" W !,"ENTER CODE(S) TO RESTRICT USER'S ACCESS TO THIS FILE" G RW
V I DUZ(0)'="@" F Z=1:1:$L(X) I DUZ(0)'[$E(X,Z) W $C(7),"??" G RW
 S ^(D)=X Q
EN ;
 Q:'$D(DIU)  G EN^DIU0
