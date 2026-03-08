DINIT017 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DIC(.85,0,"GL")
 ;;=^DI(.85,
 ;;^DIC("B","LANGUAGE",.85)
 ;;=
 ;;^DIC(.85,"%",0)
 ;;=^1.005
 ;;^DIC(.85,"%D",0)
 ;;=^^7^7^2941122^
 ;;^DIC(.85,"%D",1,0)
 ;;=The LANGUAGE file is used both to officially identify a language, and to
 ;;^DIC(.85,"%D",2,0)
 ;;=store MUMPS code needed to do language-specific conversions of data such
 ;;^DIC(.85,"%D",3,0)
 ;;=as dates and numbers.  VA FileMan currently distributes only the English
 ;;^DIC(.85,"%D",4,0)
 ;;=language entry for this file (entry number 1).  This code is currently
 ;;^DIC(.85,"%D",5,0)
 ;;=available for use only within VA FileMan.  A pointer to this file from the
 ;;^DIC(.85,"%D",6,0)
 ;;=TRANSLATION multiple on the DIALOG file also allows non-English text to be
 ;;^DIC(.85,"%D",7,0)
 ;;=returned via FileMan calls.
 ;;^DD(.85,0)
 ;;=FIELD^^20.2^9
 ;;^DD(.85,0,"DDA")
 ;;=N
 ;;^DD(.85,0,"DT")
 ;;=2940714
 ;;^DD(.85,0,"ID",1)
 ;;=W "   ",$P(^(0),U,2)
 ;;^DD(.85,0,"IX","B",.85,.01)
 ;;=
 ;;^DD(.85,0,"IX","C",.85,1)
 ;;=
 ;;^DD(.85,0,"NM","LANGUAGE")
 ;;=
 ;;^DD(.85,0,"PT",.847,.01)
 ;;=
 ;;^DD(.85,.01,0)
 ;;=ID NUMBER^RNJ10,0X^^0;1^K:+X'=X!(X>9999999999)!(X<1)!(X?.E1"."1N.N) X S:$G(X) DINUM=X
 ;;^DD(.85,.01,.1)
 ;;=Language-ID-Number
 ;;^DD(.85,.01,1,0)
 ;;=^.1
 ;;^DD(.85,.01,1,1,0)
 ;;=.85^B
 ;;^DD(.85,.01,1,1,1)
 ;;=S ^DI(.85,"B",$E(X,1,30),DA)=""
 ;;^DD(.85,.01,1,1,2)
 ;;=K ^DI(.85,"B",$E(X,1,30),DA)
 ;;^DD(.85,.01,3)
 ;;=Type a Number between 1 and 9999999999, 0 Decimal Digits
 ;;^DD(.85,.01,21,0)
 ;;=^^3^3^2941121^^
 ;;^DD(.85,.01,21,1,0)
 ;;=A number that is used to uniquely identify a language.  This number
 ;;^DD(.85,.01,21,2,0)
 ;;=corresponds to the FileMan system variable DUZ("LANG"), which is set
 ;;^DD(.85,.01,21,3,0)
 ;;=during Kernel signon to signify which language FileMan should use.
 ;;^DD(.85,.01,"DT")
 ;;=2940524
 ;;^DD(.85,1,0)
 ;;=NAME^RF^^0;2^K:$L(X)>30!($L(X)<1) X
 ;;^DD(.85,1,.1)
 ;;=Language-Name
 ;;^DD(.85,1,1,0)
 ;;=^.1
 ;;^DD(.85,1,1,1,0)
 ;;=.85^C
 ;;^DD(.85,1,1,1,1)
 ;;=S ^DI(.85,"C",$E(X,1,30),DA)=""
 ;;^DD(.85,1,1,1,2)
 ;;=K ^DI(.85,"C",$E(X,1,30),DA)
 ;;^DD(.85,1,1,1,"DT")
 ;;=2940307
 ;;^DD(.85,1,3)
 ;;=Answer must be 1-30 characters in length. (e.g., ENGLISH, GERMAN, FRENCH)
 ;;^DD(.85,1,21,0)
 ;;=^^2^2^2941121^
 ;;^DD(.85,1,21,1,0)
 ;;=The descriptive name of the language corresponding to this entry (i.e.,
 ;;^DD(.85,1,21,2,0)
 ;;=German, Spanish).
 ;;^DD(.85,1,"DT")
 ;;=2940524
 ;;^DD(.85,10.1,0)
 ;;=ORDINAL NUMBER FORMAT^K^^ORD;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.85,10.1,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.85,10.1,9)
 ;;=@
 ;;^DD(.85,10.1,21,0)
 ;;=^^6^6^2941121^^^^
 ;;^DD(.85,10.1,21,1,0)
 ;;=MUMPS code used to transfer a number in Y to its ordinal equivalent in
 ;;^DD(.85,10.1,21,2,0)
 ;;=this language. The code should set Y to the ordinal equivalent without
 ;;^DD(.85,10.1,21,3,0)
 ;;=altering any other variables in the environment.  Ex. in English:
 ;;^DD(.85,10.1,21,4,0)
 ;;=       Y=1     becomes         Y=1ST
 ;;^DD(.85,10.1,21,5,0)
 ;;=       Y=2     becomes         Y=2ND
 ;;^DD(.85,10.1,21,6,0)
 ;;=       Y=3     becomes         Y=3RD  etc.
 ;;^DD(.85,10.1,"DT")
 ;;=2940307
 ;;^DD(.85,10.2,0)
 ;;=DATE/TIME FORMAT^K^^DD;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.85,10.2,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.85,10.2,9)
 ;;=@
 ;;^DD(.85,10.2,21,0)
 ;;=^^6^6^2941121^^^
 ;;^DD(.85,10.2,21,1,0)
 ;;=MUMPS code used to transfer a date or date/time in Y from FileMan internal
 ;;^DD(.85,10.2,21,2,0)
 ;;=format, to printable format equivalent to English MMM DD,YYYY@HH.MM.SS.
 ;;^DD(.85,10.2,21,3,0)
 ;;=The code should set Y to the output, without altering any other variables
 ;;^DD(.85,10.2,21,4,0)
 ;;=in the environment.  Ex. in English:
 ;;^DD(.85,10.2,21,5,0)
 ;;= 
 ;;^DD(.85,10.2,21,6,0)
 ;;=       Y=2940612.031245        becomes         Y=JUN 12,1994@03:12:45
 ;;^DD(.85,10.2,"DT")
 ;;=2940307
 ;;^DD(.85,10.21,0)
 ;;=DATE/TIME FORMAT (FMTE)^K^^FMTE;E1,245^K:$L(X)>245 X D:$D(X) ^DIM
 ;;^DD(.85,10.21,3)
 ;;=This is Standard MUMPS code.
 ;;^DD(.85,10.21,9)
 ;;=@
 ;;^DD(.85,10.21,21,0)
 ;;=^^22^22^2941122^
 ;;^DD(.85,10.21,21,1,0)
 ;;=MUMPS code used to transfer a date or date/time in Y from FileMan internal
 ;;^DD(.85,10.21,21,2,0)
 ;;=format, to printable format based on the various outputs from routine
 ;;^DD(.85,10.21,21,3,0)
 ;;=FMTE^DILIBF.  This is an extrinsic function.  Coming in to this MUMPS
