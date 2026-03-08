DDXP4 ;SFISC/DPC-EXPORT DATA ;10/17/94  14:27 [ 09/10/1998  11:17 AM ]
 ;;21.0;VA Fileman;**1007**;SEP 08, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
EN1 ;
 K ^UTILITY($J)
 D ^DICRW I Y=-1 G QUIT
 S DDXPFINO=+Y
XTEM ;
 S DIC="^DIPT(",DIC(0)="QEASZ",DIC("A")="Choose an EXPORT template: ",DIC("S")="I $P(^(0),U,8)=3",D="F"_DDXPFINO W !
 D IX^DIC K DIC,D I $D(DTOUT)!$D(DUOUT) G QUIT
 I Y=-1 G XTEM
 S DDXPXTNO=+Y,DDXPXTNM=$P(Y,U,2),FLDS="["_DDXPXTNM_"]"
 W !,"Do you want to delete the "_DDXPXTNM_" template",!,"after the data export is complete?",!
 S DDXPTMDL=0,DIR(0)="Y",DIR("B")="NO" D ^DIR K DIR W !
 I $D(DIRUT) G QUIT
 S:Y DDXPTMDL=1
 S DDXPFFNO=+$G(^DIPT(DDXPXTNO,105)),DDXPFMZO=$G(^DIST(.44,DDXPFFNO,0))
 I $G(^DIST(.44,DDXPFFNO,6))]"" S DDXPDATE=1
 S DDXPATH=$P($G(^DIPT(DDXPXTNO,105)),U,4) I DDXPATH]"" D MULTBY
SORS ;
 W ! S DIR(0)="YA",DIR("B")="NO",DIR("A")="Do you want to SEARCH for entries to be exported? "
 S DIR("?",1)="To use VA FileMan's SEARCH option to choose entries, answer 'YES'."
 S:'$D(BY) DIR("?",2)="After the SEARCH, you can respond to VA FileMan's 'SORT BY:' prompt."
 S DIR("?")="If you answer 'NO', "_$S('$D(BY):"you can only SORT entries before export.",1:"the data export will begin.")
 D ^DIR K DIR I $D(DIRUT) G QUIT
 S DDXPSORS=Y,DIC=DDXPFINO,L=0
 D DIOBEG,DIOEND
 I DDXPSORS D EN^DIS
 I 'DDXPSORS D EN1^DIP
 I $G(X)="^"!($G(POP)) G QUIT
 I $G(DDXPQ) W !,?5,"Export template "_DDXPXTNM_" will be deleted",!,?5,"when queued export is completed." G DONE
 I $G(DDXPTMDL) S DIK="^DIPT(",DA=DDXPXTNO D ^DIK K DIK,DA
 G DONE
QUIT ;
 W !!,?10,"Export NOT completed!"
DONE ;
 K DDXPFINO,DDXPSORS,DDXPIOM,DDXPIOSL,DDXPXTNO,DDXPXTNM,DDXPFFNO,DDXPFMZO,DDXPCUSR,DDXPDATE,DDXPTMDL,DDXPY,DDXPATH,L,Y,DTOUT,DUOUT,DIRUT,DIC,FLDS,BY,FR,DIOEND,DIOBEG,DDXPQ,X,POP
 Q
ZIS ;
 S %ZIS="Q"
 S DDXPIOM=$S($P(DDXPFMZO,U,8):$P(DDXPFMZO,U,8),$G(^DIPT(DDXPXTNO,"IOM")):^("IOM"),1:80)
 S DDXPIOSL=99999
 Q
MULTBY ;
 N NUMPC,I,C S BY="",C=",",NUMPC=$L(DDXPATH,C)
 W !!,"Since you are exporting fields from multiples,"
 W !,"a sort will be done automatically."
 W !,"You will not have the opportunity to sort the data before export.",!
 F I=1:1:NUMPC D
 . S BY=BY_DDXPATH_",NUMBER,"
 . S DDXPATH=$P(DDXPATH,C,1,$L(DDXPATH,C)-1)
 . Q
 S BY=$E(BY,1,$L(BY)-1),FR=""
 Q
DIOBEG ;
 S DDXPBEG=$G(^DIST(.44,DDXPFFNO,1))
 I DDXPBEG']"" G QBEG
 I $E(DDXPBEG)="""" S DIOBEG="W "_DDXPBEG G QBEG
 S DIOBEG=DDXPBEG
QBEG K DDXPBEG
 Q
DIOEND ;
 S DDXPEND=$G(^DIST(.44,DDXPFFNO,2))
 I DDXPEND']"" G QEND
 I $E(DDXPEND)="""" S DIOEND="W "_DDXPEND G QEND
 S DIOEND=DDXPEND
QEND K DDXPEND
 Q
DJTOPY(Y) ;
 N BJ,EJ,YOUT,NUMW,TYPEJ,DDXPXORY,SUB S YOUT=Y
 S BJ=$F(Y,"$J(") I BJ D
 . S DDXPXORY=$P($E(Y,BJ,999),",",1)
 . S NUMW=$L($E(Y,1,BJ),"W")-1 I NUMW'>0 Q
 . S EJ=$F(Y,") ",BJ)
 . S TYPEJ=$L($E(Y,BJ,$S(EJ:EJ-1,1:999)),",")
 . I TYPEJ'=2&(TYPEJ'=3) Q
 . I TYPEJ=3 S SUB="$S("_DDXPXORY_"]"""":+"_DDXPXORY_",1:"""_$P(DDXPFMZO,U,13)_""")"
 . I TYPEJ=2 S SUB=DDXPXORY
 . S YOUT=$P($E(Y,1,BJ),"W",1,NUMW)_"W "_SUB_$S(EJ:$E(Y,EJ-1,999),1:"")
 . Q
 Q YOUT
DT ;
 N X
 I 'Y S DDXPY=Y Q
 S X=Y
 I $D(^DIST(.44,DDXPFFNO,6)) X ^(6) S DDXPY=$G(Y)
 Q
