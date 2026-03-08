DIPKI008 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q:'DIFQ(9.4)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(9.44,222.7,"DT")
 ;;=2940502
 ;;^DD(9.44,222.8,0)
 ;;=MERGE OR OVERWRITE SITE'S DATA^S^m:MERGE;o:OVERWRITE;^222;8^Q
 ;;^DD(9.44,222.8,3)
 ;;=
 ;;^DD(9.44,222.8,21,0)
 ;;=^^7^7^2920513^^^^
 ;;^DD(9.44,222.8,21,1,0)
 ;;= 
 ;;^DD(9.44,222.8,21,2,0)
 ;;=If the data being sent is to be MERGED, then only data which is not
 ;;^DD(9.44,222.8,21,3,0)
 ;;=already on file at the recipient site will be put in place.
 ;;^DD(9.44,222.8,21,4,0)
 ;;= 
 ;;^DD(9.44,222.8,21,5,0)
 ;;=If the data being sent is to OVERWRITE, then the data included in
 ;;^DD(9.44,222.8,21,6,0)
 ;;=the initialization routines will be put in place regardless of what
 ;;^DD(9.44,222.8,21,7,0)
 ;;=is on file at the recipient site.
 ;;^DD(9.44,222.8,"DT")
 ;;=2890627
 ;;^DD(9.44,222.9,0)
 ;;=MAY USER OVERRIDE DATA UPDATE^S^y:YES;n:NO;^222;9^Q
 ;;^DD(9.44,222.9,3)
 ;;=
 ;;^DD(9.44,222.9,21,0)
 ;;=^^7^7^2920513^^^^
 ;;^DD(9.44,222.9,21,1,0)
 ;;=YES means that the user has the option to determine whether or not
 ;;^DD(9.44,222.9,21,2,0)
 ;;=to bring in the data that has been sent with the package.  However,
 ;;^DD(9.44,222.9,21,3,0)
 ;;=he does not get the ability to change from merge to overwrite or
 ;;^DD(9.44,222.9,21,4,0)
 ;;=from overwrite to merge.
 ;;^DD(9.44,222.9,21,5,0)
 ;;= 
 ;;^DD(9.44,222.9,21,6,0)
 ;;=No means that the developer of the INIT will control whether the data
 ;;^DD(9.44,222.9,21,7,0)
 ;;=will be installed at the target site.
 ;;^DD(9.44,222.9,"DT")
 ;;=2940502
 ;;^DD(9.44,223,0)
 ;;=SCREEN TO DETERMINE DD UPDATE^KX^^223;E1,245^K:$L(X)>240 X I $D(X) D ^DIM
 ;;^DD(9.44,223,3)
 ;;=This is Standard MUMPS code from 1 to 240 characters in length.
 ;;^DD(9.44,223,9)
 ;;=@
 ;;^DD(9.44,223,21,0)
 ;;=^^7^7^2920513^^
 ;;^DD(9.44,223,21,1,0)
 ;;=This field contains standard MUMPS code which is used to determine
 ;;^DD(9.44,223,21,2,0)
 ;;=whether or not a data dictionary should be updated.  This code must
 ;;^DD(9.44,223,21,3,0)
 ;;=set $T.  If $T=1, the DD will be updated.  If $T=0, it will not.
 ;;^DD(9.44,223,21,4,0)
 ;;= 
 ;;^DD(9.44,223,21,5,0)
 ;;=This code will be executed within VA FileMan which may be being called
 ;;^DD(9.44,223,21,6,0)
 ;;=from within MailMan which is being called from within MenuMan.
 ;;^DD(9.44,223,21,7,0)
 ;;=Namespace your variables.
 ;;^DD(9.44,223,"DT")
 ;;=2890927
 ;;^DD(9.444,0)
 ;;=*STATUS SUB-FIELD^NL^2^4
 ;;^DD(9.444,0,"NM","*STATUS")
 ;;=
 ;;^DD(9.444,0,"UP")
 ;;=9.4
 ;;^DD(9.444,.01,0)
 ;;=DATE^DX^^0;1^S %DT="E" D ^%DT S (DINUM,X)=Y K:Y<1 X,DINUM
 ;;^DD(9.444,.01,3)
 ;;=Please enter the date at which the current status took effect.
 ;;^DD(9.444,.01,21,0)
 ;;=^^1^1^2851008^^
 ;;^DD(9.444,.01,21,1,0)
 ;;=This is the date at which the current status took effect.
 ;;^DD(9.444,.01,"DT")
 ;;=2840814
 ;;^DD(9.444,1,0)
 ;;=STATUS^S^A:ASSIGNED;P:PENDING;T:TEMPORARY;X:NO LONGER USED;^0;2^Q
 ;;^DD(9.444,1,21,0)
 ;;=^^2^2^2851008^
 ;;^DD(9.444,1,21,1,0)
 ;;=This specifies the current status of the namespace, i.e. Temporary,
 ;;^DD(9.444,1,21,2,0)
 ;;=Pending, Assigned, etc.
 ;;^DD(9.444,1,"DT")
 ;;=2840814
 ;;^DD(9.444,1.5,0)
 ;;=EXPIRATION DATE^D^^2;1^S %DT="E" D ^%DT S X=Y K:Y<1 X
 ;;^DD(9.444,1.5,3)
 ;;=Please enter the date at which the namespace was de-assigned.
 ;;^DD(9.444,1.5,21,0)
 ;;=^^2^2^2851008^^
 ;;^DD(9.444,1.5,21,1,0)
 ;;=This is the date at which the assignment of the namespace to
 ;;^DD(9.444,1.5,21,2,0)
 ;;=this Package expired.
 ;;^DD(9.444,1.5,"DT")
 ;;=2840815
 ;;^DD(9.444,2,0)
 ;;=COMMENTS^9.454^^1;0
 ;;^DD(9.444,2,21,0)
 ;;=^^1^1^2851008^
 ;;^DD(9.444,2,21,1,0)
 ;;=These are any comments about the status of this Package's namespace.
 ;;^DD(9.45,0)
 ;;=FIELD SUB-FIELD^NL^.01^1
 ;;^DD(9.45,0,"IX","B",9.45,.01)
 ;;=
 ;;^DD(9.45,0,"NM","FIELD")
 ;;=
 ;;^DD(9.45,0,"UP")
 ;;=9.44
 ;;^DD(9.45,.01,0)
 ;;=FIELD^MFX^^0;1^S %=+^DIC(9.4,DA(2),4,DA(1),0),X=$S($L(X)>30:X,$D(^DD(%,"B",X)):X,X'?.NP:0,'$D(^DD(%,X,0)):0,1:$P(^(0),U,1)) K:X=0 X
 ;;^DD(9.45,.01,.1)
 ;;=FIELDS REQUIRED FOR THE PACKAGE
 ;;^DD(9.45,.01,1,0)
 ;;=^.1
 ;;^DD(9.45,.01,1,1,0)
 ;;=9.45^B
 ;;^DD(9.45,.01,1,1,1)
 ;;=S ^DIC(9.4,DA(2),4,DA(1),1,"B",X,DA)=""
 ;;^DD(9.45,.01,1,1,2)
 ;;=K ^DIC(9.4,DA(2),4,DA(1),1,"B",X,DA)
 ;;^DD(9.45,.01,3)
 ;;=Please enter the name of a field.
 ;;^DD(9.45,.01,21,0)
 ;;=^^4^4^2920513^^^^
 ;;^DD(9.45,.01,21,1,0)
 ;;=The name of a FileMan field required by this Package.  This field is
 ;;^DD(9.45,.01,21,2,0)
 ;;=only to be filled in if you wish to send only selected fields in
