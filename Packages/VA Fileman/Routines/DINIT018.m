DINIT018 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DD(.85,10.21,21,4,0)
 ;;=code, in addition to the internal date in Y, a third parameter will be
 ;;^DD(.85,10.21,21,5,0)
 ;;=defined to contain flags equivalent to the flag passed as the second input
 ;;^DD(.85,10.21,21,6,0)
 ;;=parameter to FMTE^DILIBF. The code should set Y to the output, without
 ;;^DD(.85,10.21,21,7,0)
 ;;=altering any other variables in the environment.  The output should be
 ;;^DD(.85,10.21,21,8,0)
 ;;=formatted based on these flags:
 ;;^DD(.85,10.21,21,9,0)
 ;;= 
 ;;^DD(.85,10.21,21,10,0)
 ;;= 1    MMM DD, YYYY@HH:MM:SS
 ;;^DD(.85,10.21,21,11,0)
 ;;= 2    MM/DD/YY@HH:MM:SS     no leading zeroes on month,day
 ;;^DD(.85,10.21,21,12,0)
 ;;= 3    DD/MM/YY@HH:MM:SS     no leading zeroes on month,day
 ;;^DD(.85,10.21,21,13,0)
 ;;= 4    YY/MM/DD@HH:MM:SS
 ;;^DD(.85,10.21,21,14,0)
 ;;= 5    MMM DD,YYYY@HH:MM:SS  no space before year,no leading zero on day
 ;;^DD(.85,10.21,21,15,0)
 ;;= 6    MM-DD-YYYY @ HH:MM:SS spaces separate time 
 ;;^DD(.85,10.21,21,16,0)
 ;;= 7    MM-DD-YYYY@HH:MM:SS   no leading zeroes on month,day
 ;;^DD(.85,10.21,21,17,0)
 ;;= 
 ;;^DD(.85,10.21,21,18,0)
 ;;=letters in the flag
 ;;^DD(.85,10.21,21,19,0)
 ;;= S    return always seconds
 ;;^DD(.85,10.21,21,20,0)
 ;;= U    return uppercase month names
 ;;^DD(.85,10.21,21,21,0)
 ;;= P    return time as am,pm
 ;;^DD(.85,10.21,21,22,0)
 ;;= D    return only date part
 ;;^DD(.85,10.21,"DT")
 ;;=2940624
 ;;^DD(.85,10.3,0)
 ;;=CARDINAL NUMBER FORMAT^K^^CRD;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.85,10.3,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.85,10.3,9)
 ;;=@
 ;;^DD(.85,10.3,21,0)
 ;;=^^5^5^2941121^^
 ;;^DD(.85,10.3,21,1,0)
 ;;=MUMPS code used to transfer a number in Y to its cardinal equivalent in
 ;;^DD(.85,10.3,21,2,0)
 ;;=this language. The code should set Y to the cardinal equivalent without
 ;;^DD(.85,10.3,21,3,0)
 ;;=altering any other variables in the environment.  Ex. in English:
 ;;^DD(.85,10.3,21,4,0)
 ;;=       Y=2000     becomes         Y=2,000
 ;;^DD(.85,10.3,21,5,0)
 ;;=       Y=1234567  becomes         Y=1,234,567
 ;;^DD(.85,10.3,"DT")
 ;;=2940308
 ;;^DD(.85,10.4,0)
 ;;=UPPERCASE CONVERSION^K^^UC;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.85,10.4,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.85,10.4,9)
 ;;=@
 ;;^DD(.85,10.4,21,0)
 ;;=^^4^4^2941121^
 ;;^DD(.85,10.4,21,1,0)
 ;;=MUMPS code used to convert text in Y to its upper-case equivalent in
 ;;^DD(.85,10.4,21,2,0)
 ;;=this language. The code should set Y to the external format without
 ;;^DD(.85,10.4,21,3,0)
 ;;=altering any other variables in the environment.  In English, changes
 ;;^DD(.85,10.4,21,4,0)
 ;;=   abCdeF      to: ABCDEF
 ;;^DD(.85,10.4,"DT")
 ;;=2940308
 ;;^DD(.85,10.5,0)
 ;;=LOWERCASE CONVERSION^K^^LC;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.85,10.5,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.85,10.5,9)
 ;;=@
 ;;^DD(.85,10.5,21,0)
 ;;=^^4^4^2941121^
 ;;^DD(.85,10.5,21,1,0)
 ;;=MUMPS code used to convert text in Y to its lower-case equivalent in  
 ;;^DD(.85,10.5,21,2,0)
 ;;=this language. The code should set Y to the external format without
 ;;^DD(.85,10.5,21,3,0)
 ;;=altering any other variables in the environment.  In English, changes:
 ;;^DD(.85,10.5,21,4,0)
 ;;=    ABcdEFgHij         to:  abcdefghij
 ;;^DD(.85,10.5,"DT")
 ;;=2940308
 ;;^DD(.85,20.2,0)
 ;;=DATE INPUT^K^^20.2;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.85,20.2,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.85,20.2,9)
 ;;=@
 ;;^DD(.85,20.2,"DT")
 ;;=2940714
