DICN ;SFISC/GFT,XAK,SEA/TOAD-ADD NEW ENTRY ;1/16/97  10:13 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**12,19,29**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;12256;7973339;5158;
 ;
 N DIENTRY D:'$D(DO) DO^DIC1 S DO(1)=1
 G:$S($D(DLAYGO):DO(2)\1-(DLAYGO\1),1:1) B1
USR D DS S DIX=X I X'?16.N,X?.NP,X,DIC(0)["E",'$D(DICR),DS'["DINUM",$P(DS,U,2)'["N",DIC(0)["N"!$D(^DD(+DO(2),.001,0)) D N^DICN1 I $D(X) S DIENTRY=X G I
 S X=DIX D VAL G I:$D(X)
 S X=DIX
B G BAD^DIC1
B1 G USR:'DO(2),USR:$D(^DD(+DO(2),0,"UP")),USR:DO(2)=".12P" S DIFILE=+DO(2),DIAC="LAYGO" D ^DIAC K DIAC,DIFILE G B:'%,USR
 ;
1 I '$D(DIC("S")) S DST=$G(DST)_$$EZBLD^DIALOG(8058,$$OUT^DIALOGU(Y,"ORD")) S:$D(^DD(+DO(2),0,"UP")) DST=DST_$$EZBLD^DIALOG(8059,$O(^DD(^("UP"),0,"NM",0))) S DST=DST_")"
Y I $D(DDS) S A1="Q",DST=%_U_DST D H^DDSU Q
 W !,DST K DST
YN ;
 N %1 S %1=$$EZBLD^DIALOG(7001) S:'$D(%) %=0 W "? " W:(%>0) $P(%1,U,%),"// "
RX R %Y:$S($D(DTIME):DTIME,1:300) E  S DTOUT=1,%Y=U W $C(7)
 I %Y]""!'% S %=+$$PRS^DIALOGU(7001,%Y) S:(%<0&($A(%Y)'=94)) %=0
 I '%,%Y'?."?" W $C(7),"??",!?4,$$EZBLD^DIALOG(8040),": " G RX
 W:$X>73 ! W:% $S(%>0:"  ("_$P(%1,U,%)_")",1:"") Q
 ;
DS S DS=^DD(+DO(2),.01,0) Q
 ;
VAL I X'?.ANP K X Q
 I X["""" K X Q
 I $P(DS,U,2)'["N",$A(X)=45 K X Q
 I $P(DS,U,2)["*" S:DS["DINUM" DINUM=X Q
 S %=$F(DS,"%DT=""E"),DS=$E(DS,1,%-2)_$E(DS,%,999) N DICTST S DICTST=DS["+X=X"&(X?16.N) K:DICTST X X:'DICTST $P(DS,U,5,99) Q
 ;
I1 S DST=$C(7)_$$EZBLD^DIALOG(8060) S:'$D(DIENTRY) DST=DST_$$EZBLD^DIALOG(8061,Y) S %=$P(DO,U,1) I $L(DST)+$L(%)'>55 S DST=DST_$$EZBLD^DIALOG(8062,%) Q
 W:'$D(DDS) !,DST K A1 D:$D(DDS) H^DIC2 S DST="    "_$$EZBLD^DIALOG(8062,%) Q
 ;
I I DIC(0)["E",DO(2)'["A",DIC(0)'["W" K DTOUT,DUOUT S C=$P(^DD(+DO(2),.01,0),U,2),(DIX,Y)=X D Y^DIQ D  G OUT:$G(DTOUT)!($G(DUOUT)) G B:%'=1
 . D I1 S %=2,Y=$P(DO,U,4)+1,X=DIX D 1
I2 . Q:%>0!($G(DTOUT))  I %=-1 S DUOUT=1 Q
 . W:'$D(DDS) $C(7)_"??",!?4,$$EZBLD^DIALOG(8040) D YN G I2
 G NEW:'$D(DIENTRY)
R D DS S DST="   "_$P(DS,U,1)_": " I '$D(DDS) W !,DST K DST R X:DTIME S:$E(X)=U DUOUT=1 S:'$T X=U,DTOUT=1,Y=-1
 I $D(DDS) S A1="Q",DST="3^"_DST D H^DDSU S X=% I $D(DTOUT) S X=U,Y=-1
 G B:X[U,R:X="" D VAL I '$D(X) W $C(7) W:'$D(DDS) "??" G:'$D(^DD(+DO(2),.01,3)) R S DST="    "_^(3) W:'$D(DDS) !,DST D:$D(DDS) H^DDSU G R
 ;
NEW ; try to add a new record to the file
 ; FILE, I
 ;
 D:'$D(DO) DO^DIC1 I DO="0^-1" G OUT
 ;
 ; if LAYGO nodes are present, XECUTE them and verify they don't object
 ;
 S Y=1 F DIX=0:0 D  Q:DIX'>0  Q:'Y
 . S DIX=$O(^DD(+DO(2),.01,"LAYGO",DIX)) Q:DIX'>0
 . I $D(^DD(+DO(2),.01,"LAYGO",DIX,0)) X ^(0) S Y=$T
 I 'Y G OUT
 ;
 ; if the file is in the middle of archiving, keep out
 ;
 I $P($G(^DD($$FNO^DILIBF(+DO(2)),0,"DI")),U,2)["Y" D  I Y G OUT
 . S Y='$D(DIOVRD)&'$G(DIFROM)
 ;
 ; process DINUM
 ;
 S DIX=X
 I $D(DINUM) D
 . S X=DINUM
 . D N^DICN1 I '$D(X) S Y=0,X=DIX Q
 . D LOCK(DIC,X,.Y)
 ;
 ; or process DIENTRY (numeric input that might be IEN LAYGO)
 ;
 E  I $D(DIENTRY) D
 . S X=DIENTRY
 . D ASKP001^DICN1 I 'Y S X=DIX Q
 . D LOCK(DIC,X,.Y)
 ;
 ; or get a record number the usual way
 ;
 E  S X=$P(DO,U,3) D INCR F  D  Q:Y'="TRY NEXT"
 . F  S X=X\DIY*DIY+DIY Q:'$D(@(DIC_"X)"))
 . I $G(DUZ(0))="@"!$P(DO,U,2) D ASKP001^DICN1 Q:'Y
 . D LOCK(DIC,X,.Y) Q:Y  S Y="TRY NEXT"
 ;
 I 'Y G BAD^DIC1
 ;
 ; add the new record at the IEN selected
 ;
 S @(DIC_"X,0)")=DIX
 L @("-"_DIC_"X)")
 ;
 ; update the file header node & audit the new record
 ;
 K D S:$D(DA)#2 D=DA S DA=X,X=DIX
 I $D(@(DIC_"0)")) S ^(0)=$P(^(0),U,1,2)_U_DA_U_($P(^(0),U,4)+1)
 D
 . I DO(2)'["a" Q:$P(^DD(+DO(2),.01,0),U,2)'["a"  Q:^("AUDIT")["e"
 . D AUD^DIET
 ;
 ; index the new entry
 ;
 S DD=0 F  D  Q:'Y
 . S DS=X
 . S DD=$O(^DD(+DO(2),.01,1,DD)) I 'DD S Y=0 Q
 . I ^DD(+DO(2),.01,1,DD,0)["TRIGGER"!(^(0)["BULL") D
 . . N %,%RCR,DZ S %RCR="FIRE^DICN",DZ=^(1) ; *****
 . . F %="D0","Y","DIC","DIU","DIV","DO","D","DD","DICR","X" D
 . . . S %RCR(%)=""
 . . D STORLIST^%RCR
 . E  D
 . . X ^DD(+DO(2),.01,1,DD,1)
 . . S X=DS
 . S Y=1
 ;
 ; if we have DIC("DR"), or if the file has IDs, go do DIE.
 ; code will return at D if successful. We set output and go exit
 ;
 I DIC(0)["E"&($O(^DD(+DO(2),0,"ID",0))>0)!$D(DIC("DR")) G ^DICN1
D S Y=DA_U_X_"^1" I $D(D)#2 S DA=D
 G R^DIC2
 ;
INCR S DIY=1 I $P(DO,U,2)>1 F %=1:1:$L($P(X,".",2)) S DIY=DIY/10
 Q
OUT I DIC(0)["Q" W $C(7)_$S('$D(DDS):" ??",1:"")
 S Y=-1 G A^DIC:$D(DO(1))&'$D(DTOUT),Q^DIC2
 ;
FILE ; DOCUMENTED ENTRY POINT: add a new record to a file
 ;
 N DIENTRY G NEW
 ;
LOCK(DIROOT,DIEN,DIRESULT) ;
 ;
 ; try to lock the record, and see if it's already there
 ; NEW
 ;
 L @("+"_DIROOT_"DIEN):1")
 S DIRESULT='$D(@(DIROOT_"DIEN)"))&$T
 I 'DIRESULT L @("-"_DIROOT_"DIEN)")
 Q
 ;
FIRE ; fire the SET logic of a bulletin or trigger xref (in DZ)
 ; STORLIST^%RCR (called by NEW)
 ;
 X DZ
 Q
 ;
 ;#7001   Yes/No question
 ;#8040   Answer with 'Yes' or 'No'
 ;#8058   (the |entry number|
 ;#8059   for this |filename|
 ;#8060   Are you adding
 ;#8061   '|.01 field value|' as
 ;#8062   a new |filename|
