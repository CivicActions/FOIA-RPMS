DIPKI009 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q:'DIFQ(9.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(9.45,.01,21,3,0)
 ;;=an INIT of this file, instead of the full data dictionary. (i.e.,
 ;;^DD(9.45,.01,21,4,0)
 ;;=a partial DD).
 ;;^DD(9.45,.01,"DT")
 ;;=2840302
 ;;^DD(9.454,0)
 ;;=COMMENTS SUB-FIELD^NL^.01^1
 ;;^DD(9.454,0,"NM","COMMENTS")
 ;;=
 ;;^DD(9.454,0,"UP")
 ;;=9.444
 ;;^DD(9.454,.01,0)
 ;;=COMMENTS^W^^0;1^Q
 ;;^DD(9.454,.01,21,0)
 ;;=^^1^1^2851008^
 ;;^DD(9.454,.01,21,1,0)
 ;;=These are comments about the status of this Package's namespace.
 ;;^DD(9.454,.01,"DT")
 ;;=2840815
 ;;^DD(9.455,0)
 ;;=*KEY VARIABLE SUB-FIELD^NL^1^3
 ;;^DD(9.455,0,"DT")
 ;;=2920928
 ;;^DD(9.455,0,"IX","AB",9.455,.01)
 ;;=
 ;;^DD(9.455,0,"NM","*KEY VARIABLE")
 ;;=
 ;;^DD(9.455,0,"UP")
 ;;=9.4
 ;;^DD(9.455,.01,0)
 ;;=KEY VARIABLE^MF^^0;1^K:X[""""!($A(X)=45) X I $D(X) K:$L(X)>17!($L(X)<1) X
 ;;^DD(9.455,.01,1,0)
 ;;=^.1
 ;;^DD(9.455,.01,1,1,0)
 ;;=9.455^AB
 ;;^DD(9.455,.01,1,1,1)
 ;;=S ^DIC(9.4,DA(1),1933,"AB",$E(X,1,30),DA)=""
 ;;^DD(9.455,.01,1,1,2)
 ;;=K ^DIC(9.4,DA(1),1933,"AB",$E(X,1,30),DA)
 ;;^DD(9.455,.01,3)
 ;;=Please enter the name of a MUMPS Variable needed by this Package (1-17 characters).
 ;;^DD(9.455,.01,21,0)
 ;;=^^2^2^2851009^^
 ;;^DD(9.455,.01,21,1,0)
 ;;=The name of a MUMPS variable which the Package would like defined
 ;;^DD(9.455,.01,21,2,0)
 ;;=prior to entry into the routines.
 ;;^DD(9.455,.01,"DT")
 ;;=2850228
 ;;^DD(9.455,.02,0)
 ;;=PURPOSE FOR ERR REPORTS^F^^0;2^K:$L(X)>40!($L(X)<3) X
 ;;^DD(9.455,.02,3)
 ;;=Answer must be 3-40 characters in length.  This will be displayed to indicate the purpose of this variable on error reports
 ;;^DD(9.455,.02,21,0)
 ;;=^^8^8^2920928^
 ;;^DD(9.455,.02,21,1,0)
 ;;=This field is meant to contain a brief description of the purpose or role
 ;;^DD(9.455,.02,21,2,0)
 ;;=of this KEY VARIABLE.  If this variable is present in an error which has
 ;;^DD(9.455,.02,21,3,0)
 ;;=been trapped, and a user selects display of key variables, then this
 ;;^DD(9.455,.02,21,4,0)
 ;;=description will be displayed to aid the user in interpeting the variable
 ;;^DD(9.455,.02,21,5,0)
 ;;=and its value at the time the error occurred.  If this description is not
 ;;^DD(9.455,.02,21,6,0)
 ;;=available, then the variable would not be displayed along with other
 ;;^DD(9.455,.02,21,7,0)
 ;;=annotated key variables.
 ;;^DD(9.455,.02,21,8,0)
 ;;= 
 ;;^DD(9.455,.02,"DT")
 ;;=2920928
 ;;^DD(9.455,1,0)
 ;;=DESCRIPTION^9.456^^1;0
 ;;^DD(9.455,1,21,0)
 ;;=^^2^2^2851008^^
 ;;^DD(9.455,1,21,1,0)
 ;;=This lists information about the MUMPS variable required by this
 ;;^DD(9.455,1,21,2,0)
 ;;=Package.
 ;;^DD(9.456,0)
 ;;=DESCRIPTION SUB-FIELD^NL^.01^1
 ;;^DD(9.456,0,"NM","DESCRIPTION")
 ;;=
 ;;^DD(9.456,0,"UP")
 ;;=9.455
 ;;^DD(9.456,.01,0)
 ;;=DESCRIPTION^W^^0;1^Q
 ;;^DD(9.456,.01,21,0)
 ;;=^^2^2^2851008^^
 ;;^DD(9.456,.01,21,1,0)
 ;;=This describes the MUMPS variable which this Package would like
 ;;^DD(9.456,.01,21,2,0)
 ;;=defined prior to entry into the routines.
 ;;^DD(9.456,.01,"DT")
 ;;=2850228
 ;;^DD(9.46,0)
 ;;=*PRINT TEMPLATE SUB-FIELD^NL^2^2
 ;;^DD(9.46,0,"NM","*PRINT TEMPLATE")
 ;;=
 ;;^DD(9.46,0,"UP")
 ;;=9.4
 ;;^DD(9.46,.01,0)
 ;;=PRINT TEMPLATE^MF^^0;1^K:$L(X)>50!($L(X)<2) X
 ;;^DD(9.46,.01,1,0)
 ;;=^.1^^0
 ;;^DD(9.46,.01,3)
 ;;=Please enter the name of a Print Template (2-50 characters).
 ;;^DD(9.46,.01,21,0)
 ;;=^^5^5^2921202^
 ;;^DD(9.46,.01,21,1,0)
 ;;=The name of a Print Template being sent with this Package.
 ;;^DD(9.46,.01,21,2,0)
 ;;=This multiple is used to send non-namespaced templates in an INIT.
 ;;^DD(9.46,.01,21,3,0)
 ;;=Namespaced templates are sent automatically and need not be listed
 ;;^DD(9.46,.01,21,4,0)
 ;;=separately.  Selected Fields for Export and Export templates cannot be
 ;;^DD(9.46,.01,21,5,0)
 ;;=sent; entering their names here will have no effect.
 ;;^DD(9.46,.01,"DT")
 ;;=2821117
 ;;^DD(9.46,2,0)
 ;;=FILE^RP1'^DIC(^0;2^Q
 ;;^DD(9.46,2,21,0)
 ;;=^^1^1^2920513^^
 ;;^DD(9.46,2,21,1,0)
 ;;=The FileMan file for this Print Template.
 ;;^DD(9.46,2,"DT")
 ;;=2821126
 ;;^DD(9.47,0)
 ;;=*INPUT TEMPLATE SUB-FIELD^NL^2^2
 ;;^DD(9.47,0,"ID",2)
 ;;=W "   FILE #"_$P(^(0),U,2)
 ;;^DD(9.47,0,"NM","*INPUT TEMPLATE")
 ;;=
 ;;^DD(9.47,0,"UP")
 ;;=9.4
 ;;^DD(9.47,.01,0)
 ;;=INPUT TEMPLATE^MF^^0;1^K:$L(X)>50!($L(X)<2) X
 ;;^DD(9.47,.01,1,0)
 ;;=^.1^^0
 ;;^DD(9.47,.01,3)
 ;;=Please enter the name of an Input Template (2-50 characters).
 ;;^DD(9.47,.01,21,0)
 ;;=^^4^4^2920513^^^
