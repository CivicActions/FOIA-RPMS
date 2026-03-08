DIOC ;SFISC/TKW-GENERATE CODE TO CHECK QUERY CONDITIONS ;8/25/93  16:01 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
BEF(X,Y,N,M) ; BEFORE  (X before Y)
 N Z S:+$P(Y,"E")'=Y Y=""""_Y_""""
 I $G(N)="'" S Z=Y_"']]"_X Q Z
 S Z="" S:$G(M)]"" Z=X_"]"""","
 S Z=Z_Y_"]]"_X Q Z
AFT(X,Y,N,M) ; AFTER (X after Y)
 N Z S:+$P(Y,"E")'=Y Y=""""_Y_""""
 I $G(N)="'" S Z="" S:$G(M)]"" Z=X_"]""""," S Z=Z_X_"']]"_Y Q Z
 S Z=X_"]]"_Y Q Z
BTWI(X,F,T,N,S) ;BETWEEN INCLUSIVE  (NOTE: Param.'S' defined only if called from sort.
 S S=$G(S) N Z
 I $G(N)="'" S Z="("_$$BEF(X,F)_")!("_$$AFT(X,T)_")" Q Z
 S:S]"" Z=$$AFT(X,F)
 I S="" S:+$P(F,"E")'=F F=""""_F_"""" S Z=F_"']]"_X
 S Z="("_Z_")&("_$$AFT(X,T,"'")_")" Q Z
BTWE(X,F,T,N) ;BETWEEN EXCLUSIVE
 N Z S:+$P(T,"E")'=T T=""""_T_""""
 I $G(N)="'" S Z="("_$$AFT(X,F,"'")_")!("_T_"']]"_X_")" Q Z
 S Z="("_$$AFT(X,F)_")&("_T_"]]"_X_")" Q Z
EQ(X,Y,N) ;EQUALS
 N Z S:$G(N)'="'" N="" S:+$P(Y,"E")'=Y Y=""""_Y_"""" S Z=X_N_"="_Y Q Z
NULL(X,N) ;NULL
 N Z S:$G(N)'="'" N="" S Z=X_N_"=""""" Q Z
