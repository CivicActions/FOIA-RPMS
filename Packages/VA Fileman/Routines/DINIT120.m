DINIT120 ;SFISC/TKW - INITIALIZE V21 SORT TEMPLATE DD NODES ;11/4/94  09:44 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^DIC(.401,0,"GL")
 ;;=^DIBT(
 ;;^DIC("B","SORT TEMPLATE",.401)
 ;;=
 ;;^DIC(.401,"%D",0)
 ;;=^^4^4^2940908^^
 ;;^DIC(.401,"%D",1,0)
 ;;=This file stores either SORT or SEARCH criteria. For SORT criteria, the
 ;;^DIC(.401,"%D",2,0)
 ;;=SORT DATA multiple contains the sort parameters. For SEARCH criteria, the
 ;;^DIC(.401,"%D",3,0)
 ;;=template also contains a list of record numbers selected as the result of
 ;;^DIC(.401,"%D",4,0)
 ;;=running the search.
 ;;^DD(.401,0)
 ;;=FIELD^^1819^18
 ;;^DD(.401,0,"DDA")
 ;;=N
 ;;^DD(.401,0,"DI")
 ;;=^
 ;;^DD(.401,0,"DT")
 ;;=2931221
 ;;^DD(.401,0,"ID","WRITED")
 ;;=I $G(DZ)?1"???".E N % S %=0 F  S %=$O(^DIBT(Y,"%D",%)) Q:%'>0  I $D(^(%,0))#2 D EN^DDIOL(^(0),"","!?5")
 ;;^DD(.401,0,"IX","B",.401,.01)
 ;;=
 ;;^DD(.401,0,"NM","SORT TEMPLATE")
 ;;=
 ;;^DD(.401,0,"PT",1.11,2)
 ;;=
 ;;^DD(.401,.01,0)
 ;;=NAME^F^^0;1^K:$L(X)<2!($L(X)>30) X
 ;;^DD(.401,.01,1,0)
 ;;=^.1^2^2
 ;;^DD(.401,.01,1,1,0)
 ;;=.401^B
 ;;^DD(.401,.01,1,1,1)
 ;;=S @(DIC_"""B"",X,DA)=""""")
 ;;^DD(.401,.01,1,1,2)
 ;;=K @(DIC_"""B"",X,DA)")
 ;;^DD(.401,.01,1,2,0)
 ;;=^^MUMPS
 ;;^DD(.401,.01,1,2,1)
 ;;=X "S %=$P("_DIC_"DA,0),U,4) S:$L(%) "_DIC_"""F""_+%,X,DA)=1"
 ;;^DD(.401,.01,1,2,2)
 ;;=X "S %=$P("_DIC_"DA,0),U,4) K:$L(%) "_DIC_"""F""_+%,X,DA)"
 ;;^DD(.401,.01,3)
 ;;=2-30 CHARACTERS
 ;;^DD(.401,9,0)
 ;;=SEARCH COMPLETE DATE^D^^QR;1^S %DT="ESTXR" D ^%DT S X=Y K:Y<1 X
 ;;^DD(.401,9,3)
 ;;=Enter the date/time that this search was run to completion.
 ;;^DD(.401,9,21,0)
 ;;=^^4^4^2921124^
 ;;^DD(.401,9,21,1,0)
 ;;=  This field will be filled in automatically by the search option, but
 ;;^DD(.401,9,21,2,0)
 ;;=only if the search runs to completion.  It will contain the date/time
 ;;^DD(.401,9,21,3,0)
 ;;=that the search last ran.  If it was not allowed to run to completion,
 ;;^DD(.401,9,21,4,0)
 ;;=this field will be empty.
 ;;^DD(.401,9,23,0)
 ;;=^^1^1^2921124^^
 ;;^DD(.401,9,23,1,0)
 ;;=Filled in automatically by the FileMan search option.
 ;;^DD(.401,9,"DT")
 ;;=2921124
 ;;^DD(.401,11,0)
 ;;=TOTAL RECORDS SELECTED^NJ10,0^^QR;2^K:+X'=X!(X>9999999999)!(X<1)!(X?.E1"."1N.N) X
 ;;^DD(.401,11,3)
 ;;=Type a Number between 1 and 9999999999, 0 Decimal Digits
 ;;^DD(.401,11,21,0)
 ;;=^^5^5^2921125^^
 ;;^DD(.401,11,21,1,0)
 ;;=  This field is filled in automatically by the FileMan search option.
 ;;^DD(.401,11,21,2,0)
 ;;=If the search is allowed to run to completion, the total number of
 ;;^DD(.401,11,21,3,0)
 ;;=records that met the search criteria is stored in this field.  If the
 ;;^DD(.401,11,21,4,0)
 ;;=last search was not allowed to run to completion, this field will be
 ;;^DD(.401,11,21,5,0)
 ;;=null.
 ;;^DD(.401,11,23,0)
 ;;=^^1^1^2921124^
 ;;^DD(.401,11,23,1,0)
 ;;=Filled in automatically by the FileMan search option.
 ;;^DD(.401,11,"DT")
 ;;=2921125
 ;;^DD(.401,1621,0)
 ;;=SORT FIELD DATA^.4014^^2;0
 ;;^DD(.401,1815,0)
 ;;=ROUTINE INVOKED^F^^ROU;E1,13^K:$L(X)>5!($L(X)<5) X
 ;;^DD(.401,1815,3)
 ;;=Answer must be 5 characters in length.Must contain '^DISZ'.
 ;;^DD(.401,1815,21,0)
 ;;=^^7^7^2930331^^^
 ;;^DD(.401,1815,21,1,0)
 ;;=  If this sort template is compiled, the first characters of the name
 ;;^DD(.401,1815,21,2,0)
 ;;=of that compiled routine will appear on this node.  Compiled sort
 ;;^DD(.401,1815,21,3,0)
 ;;=routines are re-created each time the sort/print runs.  These characters
 ;;^DD(.401,1815,21,4,0)
 ;;=are concatenated with the next available number from the COMPILED ROUTINE
 ;;^DD(.401,1815,21,5,0)
 ;;=file to create the routine name.
 ;;^DD(.401,1815,21,6,0)
 ;;=  If this node is present, a new compiled sort routine will be created
 ;;^DD(.401,1815,21,7,0)
 ;;=during the FileMan sort/print.
 ;;^DD(.401,1815,23,0)
 ;;=^^3^3^2930331^^^
 ;;^DD(.401,1815,23,1,0)
 ;;=A routine beginning with these characters is created during the FileMan
 ;;^DD(.401,1815,23,2,0)
 ;;=sort/print.  The routine is then called from DIO2 to do the sort, rather
 ;;^DD(.401,1815,23,3,0)
 ;;=than executing code from the local DY, DZ and P arrays.
 ;;^DD(.401,1815,"DT")
 ;;=2930416
 ;;^DD(.401,1816,0)
 ;;=PREVIOUS ROUTINE INVOKED^F^^ROUOLD;E1,13^K:$L(X)>4!($L(X)<4)!'(X?1"DISZ") X
