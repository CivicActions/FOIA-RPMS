DIINI003 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",158,"U")
 ;;=VERIFY FIELDS
 ;;^UTILITY(U,$J,"OPT",159,0)
 ;;=DIXREF^Cross-Reference A Field^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",159,1,0)
 ;;=^^5^5^2890316^
 ;;^UTILITY(U,$J,"OPT",159,1,1,0)
 ;;=The Cross-Reference a Field sub-option of the Utility Functions option
 ;;^UTILITY(U,$J,"OPT",159,1,2,0)
 ;;=allows you to identify a field or sub-field for cross-referencing or
 ;;^UTILITY(U,$J,"OPT",159,1,3,0)
 ;;=for removing cross-referencing from an identified field.
 ;;^UTILITY(U,$J,"OPT",159,1,4,0)
 ;;=VA FileMan currently has seven types of cross-references -- Regular,
 ;;^UTILITY(U,$J,"OPT",159,1,5,0)
 ;;=KWIC, Mnemonic, MUMPS, Soundex, Trigger and Bulletin.
 ;;^UTILITY(U,$J,"OPT",159,20)
 ;;=S DI=2 G EN^DIU
 ;;^UTILITY(U,$J,"OPT",159,"U")
 ;;=CROSS-REFERENCE A FIELD
 ;;^UTILITY(U,$J,"OPT",160,0)
 ;;=DIIDENT^Identifier^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",160,1,0)
 ;;=^^4^4^2890316^
 ;;^UTILITY(U,$J,"OPT",160,1,1,0)
 ;;=Use the Identifier sub-option of the Utility Functions option to associate
 ;;^UTILITY(U,$J,"OPT",160,1,2,0)
 ;;=a field with the .01 (or NAME) field of a file.  The field designated as
 ;;^UTILITY(U,$J,"OPT",160,1,3,0)
 ;;=an identifier can be displayed along with the selected entry to help
 ;;^UTILITY(U,$J,"OPT",160,1,4,0)
 ;;=a user positively identify the entry.
 ;;^UTILITY(U,$J,"OPT",160,20)
 ;;=S DI=3 G EN^DIU
 ;;^UTILITY(U,$J,"OPT",160,"U")
 ;;=IDENTIFIER
 ;;^UTILITY(U,$J,"OPT",161,0)
 ;;=DIRDEX^Re-Index File^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",161,1,0)
 ;;=^^4^4^2890316^
 ;;^UTILITY(U,$J,"OPT",161,1,1,0)
 ;;=The Re-index a File sub-option of the Utility Functions option allows
 ;;^UTILITY(U,$J,"OPT",161,1,2,0)
 ;;=you to re-index a file.  This VA FileMan feature is especially helpful
 ;;^UTILITY(U,$J,"OPT",161,1,3,0)
 ;;=when you create a new cross reference on a field that already contains
 ;;^UTILITY(U,$J,"OPT",161,1,4,0)
 ;;=data.
 ;;^UTILITY(U,$J,"OPT",161,20)
 ;;=S DI=4 G EN^DIU
 ;;^UTILITY(U,$J,"OPT",161,"U")
 ;;=RE-INDEX FILE
 ;;^UTILITY(U,$J,"OPT",162,0)
 ;;=DIITRAN^Input Transform (Syntax)^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",162,1,0)
 ;;=^^4^4^2901212^^^
 ;;^UTILITY(U,$J,"OPT",162,1,1,0)
 ;;=The Input Transform sub-option of the Utility Functions option allows
 ;;^UTILITY(U,$J,"OPT",162,1,2,0)
 ;;=you to enter an executable string of MUMPS code which is used to check
 ;;^UTILITY(U,$J,"OPT",162,1,3,0)
 ;;=the validity of user input and will then convert the input into an
 ;;^UTILITY(U,$J,"OPT",162,1,4,0)
 ;;=internal form for storage.
 ;;^UTILITY(U,$J,"OPT",162,20)
 ;;=Q:DUZ(0)'="@"  S DI=5 G EN^DIU
 ;;^UTILITY(U,$J,"OPT",162,"U")
 ;;=INPUT TRANSFORM (SYNTAX)
 ;;^UTILITY(U,$J,"OPT",163,0)
 ;;=DIEDFILE^Edit File^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",163,1,0)
 ;;=^^3^3^2890316^^
 ;;^UTILITY(U,$J,"OPT",163,1,1,0)
 ;;=This option allows the user to document and control a file.  The user
 ;;^UTILITY(U,$J,"OPT",163,1,2,0)
 ;;=may describe the purpose of the file, assign it security, indicate
 ;;^UTILITY(U,$J,"OPT",163,1,3,0)
 ;;=application groups which use the file, and change the name of the file.
 ;;^UTILITY(U,$J,"OPT",163,20)
 ;;=S DI=6 G EN^DIU
 ;;^UTILITY(U,$J,"OPT",163,"U")
 ;;=EDIT FILE
 ;;^UTILITY(U,$J,"OPT",164,0)
 ;;=DIOTRAN^Output Transform^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",164,1,0)
 ;;=^^3^3^2890316^
 ;;^UTILITY(U,$J,"OPT",164,1,1,0)
 ;;=The Output Transform sub-option of the Utility Functions option allows
 ;;^UTILITY(U,$J,"OPT",164,1,2,0)
 ;;=you to enter an executable string of MUMPS code which converts internally
 ;;^UTILITY(U,$J,"OPT",164,1,3,0)
 ;;=stored data into a readable display.
 ;;^UTILITY(U,$J,"OPT",164,20)
 ;;=S DI=7 G EN^DIU
 ;;^UTILITY(U,$J,"OPT",164,"U")
 ;;=OUTPUT TRANSFORM
 ;;^UTILITY(U,$J,"OPT",165,0)
 ;;=DITEMP^Template Edit^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",165,1,0)
 ;;=^^4^4^2890316^
 ;;^UTILITY(U,$J,"OPT",165,1,1,0)
 ;;=The Template Edit sub-option of the Utility Functions option allows you
 ;;^UTILITY(U,$J,"OPT",165,1,2,0)
 ;;=to enter a description of any sort, print or input templates in a selected
 ;;^UTILITY(U,$J,"OPT",165,1,3,0)
 ;;=file.  These descriptions will be printed when you request a Templates
 ;;^UTILITY(U,$J,"OPT",165,1,4,0)
 ;;=Only data dictionary listing.
 ;;^UTILITY(U,$J,"OPT",165,20)
 ;;=S DI=8 G EN^DIU
 ;;^UTILITY(U,$J,"OPT",165,"U")
 ;;=TEMPLATE EDIT
