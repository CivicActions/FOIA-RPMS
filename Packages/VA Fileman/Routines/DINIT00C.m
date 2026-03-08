DINIT00C ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,730,3,3,0)
 ;;=FIELD^Field #.
 ;;^UTILITY(U,$J,.84,730,3,4,0)
 ;;=FILE^File #.
 ;;^UTILITY(U,$J,.84,810,0)
 ;;=810^1^^11
 ;;^UTILITY(U,$J,.84,810,1,0)
 ;;=^^3^3^2931109^
 ;;^UTILITY(U,$J,.84,810,1,1,0)
 ;;=A %ZOSF node required to perform a function does not exist.  The
 ;;^UTILITY(U,$J,.84,810,1,2,0)
 ;;=VA FileMan Programmer's Manual contains a complete list of %ZOSF
 ;;^UTILITY(U,$J,.84,810,1,3,0)
 ;;=nodes.
 ;;^UTILITY(U,$J,.84,810,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,810,2,1,0)
 ;;=A necessary %ZOSF node does not exist on your system.
 ;;^UTILITY(U,$J,.84,820,0)
 ;;=820^1^^11
 ;;^UTILITY(U,$J,.84,820,1,0)
 ;;=^^3^3^2931109^
 ;;^UTILITY(U,$J,.84,820,1,1,0)
 ;;=The ZSAVE CODE field (#2619) in the MUMPS Operating System file (#.7)
 ;;^UTILITY(U,$J,.84,820,1,2,0)
 ;;=is empty for the operating system being used.  It is impossible to perform
 ;;^UTILITY(U,$J,.84,820,1,3,0)
 ;;=functions such as compiling templates or cross references.
 ;;^UTILITY(U,$J,.84,820,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,820,2,1,0)
 ;;=There is no way to save routines on the system.
 ;;^UTILITY(U,$J,.84,840,0)
 ;;=840^1^y^11^
 ;;^UTILITY(U,$J,.84,840,1,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,840,1,1,0)
 ;;=The Terminal Type file does not have an entry that matches IOST(0).
 ;;^UTILITY(U,$J,.84,840,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,840,2,1,0)
 ;;=Terminal type '|1|' cannot be found in the Terminal Type file.
 ;;^UTILITY(U,$J,.84,840,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,840,3,1,0)
 ;;=1^Terminal type as identified by IOST(0).
 ;;^UTILITY(U,$J,.84,842,0)
 ;;=842^1^y^11^
 ;;^UTILITY(U,$J,.84,842,1,0)
 ;;=^^2^2^2931110^^
 ;;^UTILITY(U,$J,.84,842,1,1,0)
 ;;=The field in the Terminal Type field that contains the specified
 ;;^UTILITY(U,$J,.84,842,1,2,0)
 ;;=characteristic of the terminal is null.
 ;;^UTILITY(U,$J,.84,842,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,842,2,1,0)
 ;;=|1| cannot be found for Terminal Type |2|.
 ;;^UTILITY(U,$J,.84,842,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,842,3,1,0)
 ;;=1^Terminal Type characteristic.
 ;;^UTILITY(U,$J,.84,842,3,2,0)
 ;;=2^Terminal type.
 ;;^UTILITY(U,$J,.84,845,0)
 ;;=845^1^^11
 ;;^UTILITY(U,$J,.84,845,1,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,845,1,1,0)
 ;;=A %ZIS call with IOP set to "HOME" returns POP.
 ;;^UTILITY(U,$J,.84,845,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,845,2,1,0)
 ;;=The characteristics for the HOME device cannot be obtained.
 ;;^UTILITY(U,$J,.84,1500,0)
 ;;=1500^1^y^11^
 ;;^UTILITY(U,$J,.84,1500,1,0)
 ;;=^^2^2^2931112^
 ;;^UTILITY(U,$J,.84,1500,1,1,0)
 ;;=Error given for unsuccessful lookup of search template in BY(0) input
 ;;^UTILITY(U,$J,.84,1500,1,2,0)
 ;;=variable.
 ;;^UTILITY(U,$J,.84,1500,2,0)
 ;;=^^2^2^2931112^
 ;;^UTILITY(U,$J,.84,1500,2,1,0)
 ;;=Search template |1| in BY(0) variable cannot be found,
 ;;^UTILITY(U,$J,.84,1500,2,2,0)
 ;;=is for the wrong file, or has no list of search results.
 ;;^UTILITY(U,$J,.84,1500,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,1500,3,1,0)
 ;;=1^Name of search template in input variable BY(0).
 ;;^UTILITY(U,$J,.84,1500,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,1500,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,1500,5,2,0)
 ;;=DIS^ENS
 ;;^UTILITY(U,$J,.84,1501,0)
 ;;=1501^1^^11
 ;;^UTILITY(U,$J,.84,1501,1,0)
 ;;=^^2^2^2931116^^^
 ;;^UTILITY(U,$J,.84,1501,1,1,0)
 ;;=Error message shown to user when no code was generated during compilation
 ;;^UTILITY(U,$J,.84,1501,1,2,0)
 ;;=of SORT TEMPLATES.
 ;;^UTILITY(U,$J,.84,1501,2,0)
 ;;=^^1^1^2931116^
 ;;^UTILITY(U,$J,.84,1501,2,1,0)
 ;;=There is no code to save for this compiled Sort Template routine.
 ;;^UTILITY(U,$J,.84,1501,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,1501,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,1502,0)
 ;;=1502^1^^11
 ;;^UTILITY(U,$J,.84,1502,1,0)
 ;;=^^3^3^2931116^^^
 ;;^UTILITY(U,$J,.84,1502,1,1,0)
 ;;=Error message notifying the user that there are no more available
 ;;^UTILITY(U,$J,.84,1502,1,2,0)
 ;;=routine numbers for compiled sort template routines.  This should
 ;;^UTILITY(U,$J,.84,1502,1,3,0)
 ;;=never happen, since routine numbers are re-used.
 ;;^UTILITY(U,$J,.84,1502,2,0)
 ;;=^^2^2^2940909^
 ;;^UTILITY(U,$J,.84,1502,2,1,0)
 ;;=All available routine numbers for compilation are in use.
 ;;^UTILITY(U,$J,.84,1502,2,2,0)
 ;;=IRM needs to run ENRLS^DIOZ() to release the routine numbers.
 ;;^UTILITY(U,$J,.84,1502,5,0)
 ;;=^.841^1^1
