DIPKI006 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q:'DIFQ(9.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(9.404,1,21,0)
 ;;=^^1^1^2920513^^
 ;;^DD(9.404,1,21,1,0)
 ;;=The name of the ISC where this verification was done.
 ;;^DD(9.404,1,"DT")
 ;;=2840815
 ;;^DD(9.404,2,0)
 ;;=VERSION^NJ6,2^^0;3^K:+X'=X!(X>999)!(X<0)!(X?.E1"."3N.N) X
 ;;^DD(9.404,2,3)
 ;;=Please enter the version number of this verified Package (0.00-999.99).
 ;;^DD(9.404,2,21,0)
 ;;=^^1^1^2920513^^
 ;;^DD(9.404,2,21,1,0)
 ;;=The version number of this verified Package.
 ;;^DD(9.404,2,"DT")
 ;;=2840815
 ;;^DD(9.404,3,0)
 ;;=COMMENTS^9.414^^1;0
 ;;^DD(9.404,3,21,0)
 ;;=^^1^1^2920513^^
 ;;^DD(9.404,3,21,1,0)
 ;;=Comments regarding this verified version of the Package.
 ;;^DD(9.409,0)
 ;;=*DELTA SUB-FIELD^NL^.01^1
 ;;^DD(9.409,0,"NM","*DELTA")
 ;;=
 ;;^DD(9.409,0,"UP")
 ;;=9.4
 ;;^DD(9.409,.01,0)
 ;;=DELTA^MP4'X^DIC(4,^0;1^S:$D(X) DINUM=X
 ;;^DD(9.409,.01,3)
 ;;=Please enter the name of the Delta Test site.
 ;;^DD(9.409,.01,21,0)
 ;;=^^1^1^2851007^
 ;;^DD(9.409,.01,21,1,0)
 ;;=The name of a Delta Test site for this Package.
 ;;^DD(9.409,.01,"DT")
 ;;=2840815
 ;;^DD(9.41,0)
 ;;=DESCRIPTION SUB-FIELD^NL^.01^1
 ;;^DD(9.41,0,"NM","DESCRIPTION")
 ;;=
 ;;^DD(9.41,0,"UP")
 ;;=9.4
 ;;^DD(9.41,.01,0)
 ;;=DESCRIPTION^W^^0;1^Q
 ;;^DD(9.41,.01,3)
 ;;=Please enter a complete and detailed description of the Package.
 ;;^DD(9.41,.01,21,0)
 ;;=^^2^2^2920513^^^^
 ;;^DD(9.41,.01,21,1,0)
 ;;=This is a complete and detailed description of the Package's functions
 ;;^DD(9.41,.01,21,2,0)
 ;;=and capabilities.
 ;;^DD(9.41,.01,"DT")
 ;;=2851007
 ;;^DD(9.414,0)
 ;;=COMMENTS SUB-FIELD^NL^.01^1
 ;;^DD(9.414,0,"NM","COMMENTS")
 ;;=
 ;;^DD(9.414,0,"UP")
 ;;=9.404
 ;;^DD(9.414,.01,0)
 ;;=COMMENTS^W^^0;1^Q
 ;;^DD(9.414,.01,3)
 ;;=Comments relating to verification
 ;;^DD(9.414,.01,21,0)
 ;;=^^1^1^2920513^^^
 ;;^DD(9.414,.01,21,1,0)
 ;;=Comments regarding this verified version of the Package.
 ;;^DD(9.414,.01,"DT")
 ;;=2840815
 ;;^DD(9.42,0)
 ;;=*ROUTINE SUB-FIELD^NL^.01^1
 ;;^DD(9.42,0,"IX","B",9.42,.01)
 ;;=
 ;;^DD(9.42,0,"NM","*ROUTINE")
 ;;=
 ;;^DD(9.42,0,"UP")
 ;;=9.4
 ;;^DD(9.42,.01,0)
 ;;=ROUTINE^MFX^^0;1^K:$L(X)>8!($L(X)<1)!'(X?.UN!(X?1"%".UN)) X
 ;;^DD(9.42,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(9.42,.01,1,1,0)
 ;;=9.4^D
 ;;^DD(9.42,.01,1,1,1)
 ;;=S ^DIC(9.4,"D",X,DA(1))=""
 ;;^DD(9.42,.01,1,1,2)
 ;;=K ^DIC(9.4,"D",X,DA(1))
 ;;^DD(9.42,.01,1,2,0)
 ;;=9.42^B
 ;;^DD(9.42,.01,1,2,1)
 ;;=S ^DIC(9.4,DA(1),2,"B",X,DA)=""
 ;;^DD(9.42,.01,1,2,2)
 ;;=K ^DIC(9.4,DA(1),2,"B",X,DA)
 ;;^DD(9.42,.01,3)
 ;;=Please enter a routine name (1-8 characters).
 ;;^DD(9.42,.01,21,0)
 ;;=^^3^3^2920513^^^^
 ;;^DD(9.42,.01,21,1,0)
 ;;=This multiple is used for documentation purposes only and does
 ;;^DD(9.42,.01,21,2,0)
 ;;=not control anything during the INIT process.  It is used to document
 ;;^DD(9.42,.01,21,3,0)
 ;;=the routines that are included in this Package.
 ;;^DD(9.42,.01,22)
 ;;=
 ;;^DD(9.42,.01,"DT")
 ;;=2850211
 ;;^DD(9.43,0)
 ;;=*GLOBAL SUB-FIELD^NL^5^3
 ;;^DD(9.43,0,"DT")
 ;;=2910827
 ;;^DD(9.43,0,"IX","B",9.43,.01)
 ;;=
 ;;^DD(9.43,0,"NM","*GLOBAL")
 ;;=
 ;;^DD(9.43,0,"UP")
 ;;=9.4
 ;;^DD(9.43,.01,0)
 ;;=GLOBAL^MF^^0;1^K:X[""""!(X'?.ANP)!(X<0) X I $D(X) K:$L(X)>15!($L(X)<1) X
 ;;^DD(9.43,.01,1,0)
 ;;=^.1
 ;;^DD(9.43,.01,1,1,0)
 ;;=9.43^B
 ;;^DD(9.43,.01,1,1,1)
 ;;=S ^DIC(9.4,DA(1),3,"B",X,DA)=""
 ;;^DD(9.43,.01,1,1,2)
 ;;=K ^DIC(9.4,DA(1),3,"B",X,DA)
 ;;^DD(9.43,.01,3)
 ;;=Enter name of global used in this package.  Answer must be 1-15 characters in length.  (Used for documentation only.)
 ;;^DD(9.43,.01,21,0)
 ;;=^^2^2^2920513^^^
 ;;^DD(9.43,.01,21,1,0)
 ;;=The name of a global which is part of this Package.  Used for documentation
 ;;^DD(9.43,.01,21,2,0)
 ;;=only.
 ;;^DD(9.43,.01,"DT")
 ;;=2910827
 ;;^DD(9.43,4,0)
 ;;=DESCRIPTION^9.431^^4;0
 ;;^DD(9.43,4,21,0)
 ;;=^^1^1^2920513^^
 ;;^DD(9.43,4,21,1,0)
 ;;=This is a description of the global and how it is used by the Package.
 ;;^DD(9.43,5,0)
 ;;=JOURNALLING^S^M:mandatory!;O:optional--not required;N:not recommended;^5;1^Q
 ;;^DD(9.43,5,21,0)
 ;;=^^1^1^2920513^^^
 ;;^DD(9.43,5,21,1,0)
 ;;=Advises whether or not to Journal this global.
 ;;^DD(9.43,5,"DT")
 ;;=2850228
 ;;^DD(9.431,0)
 ;;=DESCRIPTION SUB-FIELD^NL^.01^1
 ;;^DD(9.431,0,"NM","DESCRIPTION")
 ;;=
 ;;^DD(9.431,0,"UP")
 ;;=9.43
 ;;^DD(9.431,.01,0)
 ;;=DESCRIPTION^W^^0;1^Q
 ;;^DD(9.431,.01,21,0)
 ;;=^^1^1^2920513^^^
 ;;^DD(9.431,.01,21,1,0)
 ;;=This is a description of the global and how it is used by the Package.
