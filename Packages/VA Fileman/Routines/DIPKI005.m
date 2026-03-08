DIPKI005 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q:'DIFQ(9.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(9.4,1944,9)
 ;;=^
 ;;^DD(9.4,1944,9.01)
 ;;=
 ;;^DD(9.4,1944,9.1)
 ;;=S (XU,X)=$P(^DIC(9.4,D0,0),U,2) I X?1A.E F D=0:0 Q:$P(X,XU,1)]""!(X="")  S D=$O(^XMB(3.6,X,0)) S:D="" D=-1 X:$D(^XMB(3.6,D,0)) DICMX S X=$O(^XMB(3.6,"B",X))
 ;;^DD(9.4,1944,21,0)
 ;;=^^2^2^2851008^
 ;;^DD(9.4,1944,21,1,0)
 ;;=This presents information about any BULLETINs which are distributed
 ;;^DD(9.4,1944,21,2,0)
 ;;=along with the Package.
 ;;^DD(9.4,1944,"DT")
 ;;=2940606
 ;;^DD(9.4,1945,0)
 ;;=*SECURITY KEYS^XCmJ30^^ ; ^S (XU,X)=$P(^DIC(9.4,D0,0),U,2) I X?1A.E F D=0:0 X:$D(^XUSEC(X)) DICMX S X=$O(^XUSEC(X)) I $P(X,XU,1)]""!(X="") S X="" Q
 ;;^DD(9.4,1945,9)
 ;;=^
 ;;^DD(9.4,1945,9.01)
 ;;=
 ;;^DD(9.4,1945,9.1)
 ;;=S (XU,X)=$P(^DIC(9.4,D0,0),U,2) I X?1A.E F D=0:0 X:$D(^XUSEC(X)) DICMX S X=$O(^XUSEC(X)) I $P(X,XU,1)]""!(X="") S X="" Q
 ;;^DD(9.4,1945,21,0)
 ;;=^^2^2^2851008^
 ;;^DD(9.4,1945,21,1,0)
 ;;=This describes the SECURITY KEYs which are distributed along with
 ;;^DD(9.4,1945,21,2,0)
 ;;=the Package.
 ;;^DD(9.4,1945,"DT")
 ;;=2940606
 ;;^DD(9.4,1946,0)
 ;;=*OPTIONS^XCmJ30^^ ; ^S (XU,X)=$P(^DIC(9.4,D0,0),U,2) I X?1A.E F D=0:0 S D=$O(^DIC(19,"B",X,0)) S:D="" D=-1 X:$D(^DIC(19,D,0)) DICMX S X=$O(^DIC(19,"B",X)) I $P(X,XU,1)]""!(X="") S X="" Q
 ;;^DD(9.4,1946,9)
 ;;=^
 ;;^DD(9.4,1946,9.01)
 ;;=
 ;;^DD(9.4,1946,9.1)
 ;;=S (XU,X)=$P(^DIC(9.4,D0,0),U,2) I X?1A.E F D=0:0 Q:$P(X,XU,1)]""!(X="")  S D=$O(^DIC(19,"B",X,0)) S:D="" D=-1 X:$D(^DIC(19,D,0)) DICMX S X=$O(^DIC(19,"B",X))
 ;;^DD(9.4,1946,21,0)
 ;;=^^2^2^2851008^
 ;;^DD(9.4,1946,21,1,0)
 ;;=This lists information concerning the OPTIONs which are distributed
 ;;^DD(9.4,1946,21,2,0)
 ;;=along with the Package.
 ;;^DD(9.4,1946,"DT")
 ;;=2940606
 ;;^DD(9.402,0)
 ;;=AFFECTS RECORD MERGE SUB-FIELD^^4^3
 ;;^DD(9.402,0,"DT")
 ;;=2900906
 ;;^DD(9.402,0,"IX","B",9.402,.01)
 ;;=
 ;;^DD(9.402,0,"NM","AFFECTS RECORD MERGE")
 ;;=
 ;;^DD(9.402,0,"UP")
 ;;=9.4
 ;;^DD(9.402,.01,0)
 ;;=FILE AFFECTED^*P1'X^DIC(^0;1^S DIC("S")="I $D(^DD(15,.01,""V"",""B"",Y))" D ^DIC K DIC S DIC=DIE,X=+Y K:Y<0 X S:$D(X) DINUM=X
 ;;^DD(9.402,.01,1,0)
 ;;=^.1
 ;;^DD(9.402,.01,1,1,0)
 ;;=9.402^B
 ;;^DD(9.402,.01,1,1,1)
 ;;=S ^DIC(9.4,DA(1),20,"B",$E(X,1,30),DA)=""
 ;;^DD(9.402,.01,1,1,2)
 ;;=K ^DIC(9.4,DA(1),20,"B",$E(X,1,30),DA)
 ;;^DD(9.402,.01,1,2,0)
 ;;=9.4^AMRG
 ;;^DD(9.402,.01,1,2,1)
 ;;=S ^DIC(9.4,"AMRG",$E(X,1,30),DA(1),DA)=""
 ;;^DD(9.402,.01,1,2,2)
 ;;=K ^DIC(9.4,"AMRG",$E(X,1,30),DA(1),DA)
 ;;^DD(9.402,.01,1,2,"%D",0)
 ;;=^^2^2^2900906^
 ;;^DD(9.402,.01,1,2,"%D",1,0)
 ;;=This xref is used by the merge process to determine if any package
 ;;^DD(9.402,.01,1,2,"%D",2,0)
 ;;=file entry affects the file being merged.
 ;;^DD(9.402,.01,1,2,"DT")
 ;;=2900906
 ;;^DD(9.402,.01,3)
 ;;=Pointer to a file that has been added to FILE 15's variable pointer.
 ;;^DD(9.402,.01,12)
 ;;=MUST BE VARIABLE POINTER FILE IN FIELD .01 OF FILE 15
 ;;^DD(9.402,.01,12.1)
 ;;=S DIC("S")="I $D(^DD(15,.01,""V"",""B"",Y))"
 ;;^DD(9.402,.01,21,0)
 ;;=^^1^1^2940627^^
 ;;^DD(9.402,.01,21,1,0)
 ;;=A file that if merged will affect this package.
 ;;^DD(9.402,.01,"DT")
 ;;=2900910
 ;;^DD(9.402,3,0)
 ;;=NAME OF MERGE ROUTINE^F^^0;3^K:$L(X)>8!($L(X)<2)!'(X?1U1.7UN) X
 ;;^DD(9.402,3,3)
 ;;=Answer with a routine name (1U.1.7UN).
 ;;^DD(9.402,3,21,0)
 ;;=^^4^4^2930330^
 ;;^DD(9.402,3,21,1,0)
 ;;=This field holds the routine name to call when two records in
 ;;^DD(9.402,3,21,2,0)
 ;;=an affected file are to be merged. This allows the package to
 ;;^DD(9.402,3,21,3,0)
 ;;=do any repointing or other clean-up needed before the records
 ;;^DD(9.402,3,21,4,0)
 ;;=are merged.
 ;;^DD(9.402,3,"DT")
 ;;=2900816
 ;;^DD(9.402,4,0)
 ;;=RECORD HAS PACKAGE DATA^K^^1;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(9.402,4,3)
 ;;=This is Standard MUMPS code. To tell if this record has data in this package.
 ;;^DD(9.402,4,9)
 ;;=@
 ;;^DD(9.402,4,"DT")
 ;;=2900816
 ;;^DD(9.404,0)
 ;;=*VERIFICATION SUB-FIELD^NL^3^4
 ;;^DD(9.404,0,"ID",1)
 ;;=W:$D(^(0)) "   ",$P(^(0),U,2)
 ;;^DD(9.404,0,"NM","*VERIFICATION")
 ;;=
 ;;^DD(9.404,0,"UP")
 ;;=9.4
 ;;^DD(9.404,.01,0)
 ;;=VERIFICATION^DX^^0;1^S %DT="E" D ^%DT S (DINUM,X)=Y K:Y<1 DINUM,X
 ;;^DD(9.404,.01,21,0)
 ;;=^^1^1^2920513^^^
 ;;^DD(9.404,.01,21,1,0)
 ;;=Date of notification that this software has been verified.
 ;;^DD(9.404,.01,"DT")
 ;;=2840815
 ;;^DD(9.404,1,0)
 ;;=ISC^F^^0;2^K:$L(X)>20!($L(X)<2) X
 ;;^DD(9.404,1,3)
 ;;=The name of the ISC responsible for verification (3-20 characters).
