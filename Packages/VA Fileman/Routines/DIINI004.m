DIINI004 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",166,0)
 ;;=DIUNEDIT^Uneditable Data^^A^^^^^^^^^n^1^^
 ;;^UTILITY(U,$J,"OPT",166,1,0)
 ;;=^^4^4^2890316^
 ;;^UTILITY(U,$J,"OPT",166,1,1,0)
 ;;=The Uneditable Data sub-option of the Utility Functions option allows you
 ;;^UTILITY(U,$J,"OPT",166,1,2,0)
 ;;=to specify a particular field that CANNOT be edited or deleted by a user.
 ;;^UTILITY(U,$J,"OPT",166,1,3,0)
 ;;=If an uneditable data field is edited, VA FileMan will display the field
 ;;^UTILITY(U,$J,"OPT",166,1,4,0)
 ;;=value along with one of the famous 'No Editing' messages.
 ;;^UTILITY(U,$J,"OPT",166,20)
 ;;=S DI=9 G EN^DIU
 ;;^UTILITY(U,$J,"OPT",166,"U")
 ;;=UNEDITABLE DATA
 ;;^UTILITY(U,$J,"OPT",230,0)
 ;;=DI SET MUMPS OS^Set Type of Mumps Operating System^^R^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",230,1,0)
 ;;=^^3^3^2880712^
 ;;^UTILITY(U,$J,"OPT",230,1,1,0)
 ;;=This option allows the user to set the Type of Mumps Operating System.
 ;;^UTILITY(U,$J,"OPT",230,1,2,0)
 ;;=VA FileMan uses this to perform operating system specific functions
 ;;^UTILITY(U,$J,"OPT",230,1,3,0)
 ;;=such as determining routine existence or filing routines.
 ;;^UTILITY(U,$J,"OPT",230,25)
 ;;=OS^DINIT
 ;;^UTILITY(U,$J,"OPT",230,"U")
 ;;=SET TYPE OF MUMPS OPERATING SY
 ;;^UTILITY(U,$J,"OPT",231,0)
 ;;=DI MGMT MENU^VA FileMan Management^^M^^XUMGR^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",231,10,0)
 ;;=^19.01IP^7^7
 ;;^UTILITY(U,$J,"OPT",231,10,1,0)
 ;;=230^^6
 ;;^UTILITY(U,$J,"OPT",231,10,1,"^")
 ;;=DI SET MUMPS OS
 ;;^UTILITY(U,$J,"OPT",231,10,2,0)
 ;;=232^^5
 ;;^UTILITY(U,$J,"OPT",231,10,2,"^")
 ;;=DI REINITIALIZE
 ;;^UTILITY(U,$J,"OPT",231,10,3,0)
 ;;=235^^1
 ;;^UTILITY(U,$J,"OPT",231,10,3,"^")
 ;;=DI DD COMPILE
 ;;^UTILITY(U,$J,"OPT",231,10,4,0)
 ;;=233^^3
 ;;^UTILITY(U,$J,"OPT",231,10,4,"^")
 ;;=DI PRINT COMPILE
 ;;^UTILITY(U,$J,"OPT",231,10,5,0)
 ;;=234^^2
 ;;^UTILITY(U,$J,"OPT",231,10,5,"^")
 ;;=DI INPUT COMPILE
 ;;^UTILITY(U,$J,"OPT",231,10,6,0)
 ;;=338^^7
 ;;^UTILITY(U,$J,"OPT",231,10,6,"^")
 ;;=DIWF
 ;;^UTILITY(U,$J,"OPT",231,10,7,0)
 ;;=407^^4
 ;;^UTILITY(U,$J,"OPT",231,10,7,"^")
 ;;=DI SORT COMPILE
 ;;^UTILITY(U,$J,"OPT",231,99)
 ;;=55713,45966
 ;;^UTILITY(U,$J,"OPT",231,99.1)
 ;;=55799,10811
 ;;^UTILITY(U,$J,"OPT",231,"U")
 ;;=VA FILEMAN MANAGEMENT
 ;;^UTILITY(U,$J,"OPT",232,0)
 ;;=DI REINITIALIZE^Re-Initialize VA FileMan^^R^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",232,25)
 ;;=DINIT
 ;;^UTILITY(U,$J,"OPT",232,"U")
 ;;=RE-INITIALIZE VA FILEMAN
 ;;^UTILITY(U,$J,"OPT",233,0)
 ;;=DI PRINT COMPILE^Print Template Compile/Uncompile^^R^^^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",233,1,0)
 ;;=^^1^1^2930715^^
 ;;^UTILITY(U,$J,"OPT",233,1,1,0)
 ;;=This option allows the user to compile or uncompile a print template.
 ;;^UTILITY(U,$J,"OPT",233,25)
 ;;=EN1^DIPZ
 ;;^UTILITY(U,$J,"OPT",233,"U")
 ;;=PRINT TEMPLATE COMPILE/UNCOMPI
 ;;^UTILITY(U,$J,"OPT",234,0)
 ;;=DI INPUT COMPILE^Input Template Compile/Uncompile^^A^^^^^^^^VA FILEMAN^^1^^
 ;;^UTILITY(U,$J,"OPT",234,1,0)
 ;;=^^1^1^2930715^^^^
 ;;^UTILITY(U,$J,"OPT",234,1,1,0)
 ;;=This option allows the user to compile or uncompile an Input Template.
 ;;^UTILITY(U,$J,"OPT",234,20)
 ;;=D EN1^DIEZ K DNM
 ;;^UTILITY(U,$J,"OPT",234,"U")
 ;;=INPUT TEMPLATE COMPILE/UNCOMPI
 ;;^UTILITY(U,$J,"OPT",235,0)
 ;;=DI DD COMPILE^Data Dictionary Cross-reference Compile/Uncompile^^R^^^^^^^^VA FILEMAN^^
 ;;^UTILITY(U,$J,"OPT",235,1,0)
 ;;=^^3^3^2930715^^^^
 ;;^UTILITY(U,$J,"OPT",235,1,1,0)
 ;;=This option allows the user to compile or uncompile a Data Dictionary's
 ;;^UTILITY(U,$J,"OPT",235,1,2,0)
 ;;=cross-references into routines which are run whenever an entry
 ;;^UTILITY(U,$J,"OPT",235,1,3,0)
 ;;=is indexed or deleted.
 ;;^UTILITY(U,$J,"OPT",235,25)
 ;;=EN1^DIKZ
 ;;^UTILITY(U,$J,"OPT",235,"U")
 ;;=DATA DICTIONARY CROSS-REFERENC
 ;;^UTILITY(U,$J,"OPT",287,0)
 ;;=DIAUDIT^Audit Menu^^M^^XUAUDITING^^^^^^^^
 ;;^UTILITY(U,$J,"OPT",287,1,0)
 ;;=^^2^2^2901206^^
 ;;^UTILITY(U,$J,"OPT",287,1,1,0)
 ;;=This menu contains the options which show which files and fields are
 ;;^UTILITY(U,$J,"OPT",287,1,2,0)
 ;;=being audited as well as the options which purge audit trails.
 ;;^UTILITY(U,$J,"OPT",287,10,0)
 ;;=^19.01IP^5^5
 ;;^UTILITY(U,$J,"OPT",287,10,1,0)
 ;;=288^^1
 ;;^UTILITY(U,$J,"OPT",287,10,1,"^")
 ;;=DIAUDITED FIELDS
 ;;^UTILITY(U,$J,"OPT",287,10,2,0)
 ;;=289^^2
 ;;^UTILITY(U,$J,"OPT",287,10,2,"^")
 ;;=DIAUDIT DD
 ;;^UTILITY(U,$J,"OPT",287,10,3,0)
 ;;=290^^3
 ;;^UTILITY(U,$J,"OPT",287,10,3,"^")
 ;;=DIAUDIT PURGE DATA
