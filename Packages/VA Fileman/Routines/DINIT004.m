DINIT004 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84)
 ;;=^DI(.84,
 ;;^UTILITY(U,$J,.84,0)
 ;;=DIALOG^.84I^630^271
 ;;^UTILITY(U,$J,.84,101,0)
 ;;=101^1^^11
 ;;^UTILITY(U,$J,.84,101,1,0)
 ;;=^^2^2^2931110^
 ;;^UTILITY(U,$J,.84,101,1,1,0)
 ;;=The option or function can only be done if DUZ(0)="@", designating 
 ;;^UTILITY(U,$J,.84,101,1,2,0)
 ;;=the user as having programmer access.
 ;;^UTILITY(U,$J,.84,101,2,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,101,2,1,0)
 ;;=Only those with programmer's access can perform this function.
 ;;^UTILITY(U,$J,.84,110,0)
 ;;=110^1^^11
 ;;^UTILITY(U,$J,.84,110,1,0)
 ;;=^^2^2^2931110^
 ;;^UTILITY(U,$J,.84,110,1,1,0)
 ;;=An attempt to get a lock timed out.  The record is locked and the desired
 ;;^UTILITY(U,$J,.84,110,1,2,0)
 ;;=action cannot be taken until the lock is released.
 ;;^UTILITY(U,$J,.84,110,2,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,110,2,1,0)
 ;;=The record is currently locked.
 ;;^UTILITY(U,$J,.84,110,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,110,3,1,0)
 ;;=FILE^File or subfile #.
 ;;^UTILITY(U,$J,.84,110,3,2,0)
 ;;=IENS^IEN string of entry numbers.
 ;;^UTILITY(U,$J,.84,110,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,110,5,1,0)
 ;;=DIE^FILE
 ;;^UTILITY(U,$J,.84,111,0)
 ;;=111^1^y^11^
 ;;^UTILITY(U,$J,.84,111,1,0)
 ;;=^^2^2^2940215^
 ;;^UTILITY(U,$J,.84,111,1,1,0)
 ;;=An attempt to get a lock timed out. The File Header Node is locked, and
 ;;^UTILITY(U,$J,.84,111,1,2,0)
 ;;=the desired action cannot be taken until the lock is released.
 ;;^UTILITY(U,$J,.84,111,2,0)
 ;;=^^1^1^2940215^
 ;;^UTILITY(U,$J,.84,111,2,1,0)
 ;;=The File Header Node is currently locked.
 ;;^UTILITY(U,$J,.84,111,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,111,3,1,0)
 ;;=FILE^File #.
 ;;^UTILITY(U,$J,.84,111,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,111,5,1,0)
 ;;=0
 ;;^UTILITY(U,$J,.84,120,0)
 ;;=120^1^y^11
 ;;^UTILITY(U,$J,.84,120,1,0)
 ;;=^^7^7^2941006^^
 ;;^UTILITY(U,$J,.84,120,1,1,0)
 ;;=An error occurred during the Xecution of a FileMan hook (e.g., an input
 ;;^UTILITY(U,$J,.84,120,1,2,0)
 ;;=transform, DIC screen).  The type of hook in which the error occurred is
 ;;^UTILITY(U,$J,.84,120,1,3,0)
 ;;=identified in the text.  When relevant, the file, field, and IENS for
 ;;^UTILITY(U,$J,.84,120,1,4,0)
 ;;=which the hook was being Xecuted are identified in the PARAM nodes.  The
 ;;^UTILITY(U,$J,.84,120,1,5,0)
 ;;=substance of the error will usually be identified by a separate error
 ;;^UTILITY(U,$J,.84,120,1,6,0)
 ;;=message generated during the Xecution of the hook itself. That error will
 ;;^UTILITY(U,$J,.84,120,1,7,0)
 ;;=usually be the one preceding this one in the DIERR array.
 ;;^UTILITY(U,$J,.84,120,2,0)
 ;;=^^1^1^2941006^^
 ;;^UTILITY(U,$J,.84,120,2,1,0)
 ;;=The previous error occurred when performing an action specified in a |1|.
 ;;^UTILITY(U,$J,.84,120,3,0)
 ;;=^.845^4^4
 ;;^UTILITY(U,$J,.84,120,3,1,0)
 ;;=1^Type of FileMan Xecutable code.
 ;;^UTILITY(U,$J,.84,120,3,2,0)
 ;;=FILE^File#
 ;;^UTILITY(U,$J,.84,120,3,3,0)
 ;;=FIELD^Field#.
 ;;^UTILITY(U,$J,.84,120,3,4,0)
 ;;=IENS^Internal Entry Number String.
 ;;^UTILITY(U,$J,.84,200,0)
 ;;=200^1^^11
 ;;^UTILITY(U,$J,.84,200,1,0)
 ;;=^^2^2^2931109^
 ;;^UTILITY(U,$J,.84,200,1,1,0)
 ;;=There is an error in one of the variables passed to a FileMan call or
 ;;^UTILITY(U,$J,.84,200,1,2,0)
 ;;=in one of the parameters passed in the actual parameter list.
 ;;^UTILITY(U,$J,.84,200,2,0)
 ;;=^^1^1^2931110^^^
 ;;^UTILITY(U,$J,.84,200,2,1,0)
 ;;=An input variable or parameter is missing or invalid.
 ;;^UTILITY(U,$J,.84,201,0)
 ;;=201^1^y^11^
 ;;^UTILITY(U,$J,.84,201,1,0)
 ;;=^^2^2^2931110^^
 ;;^UTILITY(U,$J,.84,201,1,1,0)
 ;;=The specified input variable is either 1) required but not defined or
 ;;^UTILITY(U,$J,.84,201,1,2,0)
 ;;=2) not valid.
 ;;^UTILITY(U,$J,.84,201,2,0)
 ;;=^^1^1^2931110^^^
 ;;^UTILITY(U,$J,.84,201,2,1,0)
 ;;=The input variable |1| is missing or invalid.
 ;;^UTILITY(U,$J,.84,201,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,201,3,1,0)
 ;;=1^Variable name.
 ;;^UTILITY(U,$J,.84,202,0)
 ;;=202^1^y^11^
 ;;^UTILITY(U,$J,.84,202,1,0)
 ;;=^^1^1^2931110^^^^
 ;;^UTILITY(U,$J,.84,202,1,1,0)
 ;;=The specified parameter is either required but missing or invalid.
 ;;^UTILITY(U,$J,.84,202,2,0)
 ;;=^^1^1^2931110^^^
 ;;^UTILITY(U,$J,.84,202,2,1,0)
 ;;=The input parameter that identifies the |1| is missing or invalid.
 ;;^UTILITY(U,$J,.84,202,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,202,3,1,0)
 ;;=1^Parameter as identified in the FM documentation.
