DINIT00I ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,8012,1,2,0)
 ;;=PRINT option.
 ;;^UTILITY(U,$J,.84,8012,2,0)
 ;;=^^1^1^2931102^
 ;;^UTILITY(U,$J,.84,8012,2,1,0)
 ;;=Heading
 ;;^UTILITY(U,$J,.84,8012,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8012,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,8012,5,2,0)
 ;;=DIS^ENS
 ;;^UTILITY(U,$J,.84,8013,0)
 ;;=8013^2^^11^
 ;;^UTILITY(U,$J,.84,8013,1,0)
 ;;=^^3^3^2931105^^
 ;;^UTILITY(U,$J,.84,8013,1,1,0)
 ;;=The DD for the file of files is not completely FileMan compatible.  This
 ;;^UTILITY(U,$J,.84,8013,1,2,0)
 ;;=is the field name prompt for the POST-SELECTION ACTION field on the file
 ;;^UTILITY(U,$J,.84,8013,1,3,0)
 ;;=of files.  Prompt appears when file attributes.
 ;;^UTILITY(U,$J,.84,8013,2,0)
 ;;=^^1^1^2931105^^
 ;;^UTILITY(U,$J,.84,8013,2,1,0)
 ;;=POST-SELECTION ACTION
 ;;^UTILITY(U,$J,.84,8013,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8013,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,8014,0)
 ;;=8014^2^^11^
 ;;^UTILITY(U,$J,.84,8014,1,0)
 ;;=^^3^3^2931105^
 ;;^UTILITY(U,$J,.84,8014,1,1,0)
 ;;=The DD for the file of files is not completely FileMan compatible.  This
 ;;^UTILITY(U,$J,.84,8014,1,2,0)
 ;;=is the field name prompt for the LOOK-UP PROGRAM field on the file
 ;;^UTILITY(U,$J,.84,8014,1,3,0)
 ;;=of files.  Prompt appears when file attributes are edited.
 ;;^UTILITY(U,$J,.84,8014,2,0)
 ;;=^^1^1^2931105^
 ;;^UTILITY(U,$J,.84,8014,2,1,0)
 ;;=LOOK-UP PROGRAM
 ;;^UTILITY(U,$J,.84,8014,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8014,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,8015,0)
 ;;=8015^2^^11
 ;;^UTILITY(U,$J,.84,8015,1,0)
 ;;=^^2^2^2931105^
 ;;^UTILITY(U,$J,.84,8015,1,1,0)
 ;;=Standard prompt to verify to the user that they just deleted something
 ;;^UTILITY(U,$J,.84,8015,1,2,0)
 ;;=with the "@".
 ;;^UTILITY(U,$J,.84,8015,2,0)
 ;;=^^1^1^2931105^
 ;;^UTILITY(U,$J,.84,8015,2,1,0)
 ;;=Deleted.
 ;;^UTILITY(U,$J,.84,8015,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8015,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,8016,0)
 ;;=8016^2^y^11^
 ;;^UTILITY(U,$J,.84,8016,1,0)
 ;;=^^2^2^2931105^^^^
 ;;^UTILITY(U,$J,.84,8016,1,1,0)
 ;;=Called after performing routine existence test to tell user that routine
 ;;^UTILITY(U,$J,.84,8016,1,2,0)
 ;;=is already in their directory.
 ;;^UTILITY(U,$J,.84,8016,2,0)
 ;;=^^1^1^2931105^
 ;;^UTILITY(U,$J,.84,8016,2,1,0)
 ;;=Note that |1| is already in the routine directory.
 ;;^UTILITY(U,$J,.84,8016,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8016,3,1,0)
 ;;=1^Name of the routine.
 ;;^UTILITY(U,$J,.84,8016,5,0)
 ;;=^.841^4^4
 ;;^UTILITY(U,$J,.84,8016,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,8016,5,2,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,8016,5,3,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,8016,5,4,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8017,0)
 ;;=8017^2^^11
 ;;^UTILITY(U,$J,.84,8017,1,0)
 ;;=^^2^2^2931105^
 ;;^UTILITY(U,$J,.84,8017,1,1,0)
 ;;=Message warning user that a routine does not exist in their routine
 ;;^UTILITY(U,$J,.84,8017,1,2,0)
 ;;=directory.
 ;;^UTILITY(U,$J,.84,8017,2,0)
 ;;=^^1^1^2931105^
 ;;^UTILITY(U,$J,.84,8017,2,1,0)
 ;;=This routine does not exist in the routine directory.
 ;;^UTILITY(U,$J,.84,8017,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8017,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,8018,0)
 ;;=8018^2^y^11^
 ;;^UTILITY(U,$J,.84,8018,1,0)
 ;;=^^2^2^2931105^
 ;;^UTILITY(U,$J,.84,8018,1,1,0)
 ;;=Prompt showing the user a routine name previously used for compiled
 ;;^UTILITY(U,$J,.84,8018,1,2,0)
 ;;=routines (input templates, print templates, cross-references).
 ;;^UTILITY(U,$J,.84,8018,2,0)
 ;;=^^1^1^2931105^
 ;;^UTILITY(U,$J,.84,8018,2,1,0)
 ;;=Previously compiled under routine name |1|.
 ;;^UTILITY(U,$J,.84,8018,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8018,3,1,0)
 ;;=1^Routine name from "DIKOLD" or "ROUOLD" nodes in templates or DD for cross-references.
 ;;^UTILITY(U,$J,.84,8018,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8018,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,8019,0)
 ;;=8019^2^^11
 ;;^UTILITY(U,$J,.84,8019,1,0)
 ;;=^^3^3^2931105^^
 ;;^UTILITY(U,$J,.84,8019,1,1,0)
 ;;=The DD for the file of files is not completely FileMan compatible.  This
 ;;^UTILITY(U,$J,.84,8019,1,2,0)
 ;;=is the field name prompt for the CROSS-REFERENCE ROUTINE field on the file
 ;;^UTILITY(U,$J,.84,8019,1,3,0)
 ;;=of files.  Prompt appears when file attributes are edited.
 ;;^UTILITY(U,$J,.84,8019,2,0)
 ;;=^^1^1^2931105^
 ;;^UTILITY(U,$J,.84,8019,2,1,0)
 ;;=CROSS-REFERENCE ROUTINE
 ;;^UTILITY(U,$J,.84,8019,5,0)
 ;;=^.841^1^1
