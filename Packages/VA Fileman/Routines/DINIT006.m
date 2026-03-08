DINIT006 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,305,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,305,2,1,0)
 ;;=The array with a root of '|1|' has no data associated with it.
 ;;^UTILITY(U,$J,.84,305,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,305,3,1,0)
 ;;=1^Passed root.
 ;;^UTILITY(U,$J,.84,305,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,305,5,1,0)
 ;;=DIE^FILE
 ;;^UTILITY(U,$J,.84,306,0)
 ;;=306^1^y^11
 ;;^UTILITY(U,$J,.84,306,1,0)
 ;;=^^2^2^2940628^
 ;;^UTILITY(U,$J,.84,306,1,1,0)
 ;;=When an IENS is used to explicitly identify a subfile, not a subfile
 ;;^UTILITY(U,$J,.84,306,1,2,0)
 ;;=entry, then the first comma-piece should be empty. This one wasn't.
 ;;^UTILITY(U,$J,.84,306,2,0)
 ;;=^^1^1^2941018^
 ;;^UTILITY(U,$J,.84,306,2,1,0)
 ;;=The first comma-piece of IENS '|IENS|' should be empty.
 ;;^UTILITY(U,$J,.84,306,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,306,3,1,0)
 ;;=IENS^IENS.
 ;;^UTILITY(U,$J,.84,307,0)
 ;;=307^1^y^11
 ;;^UTILITY(U,$J,.84,307,1,0)
 ;;=^^2^2^2940629^
 ;;^UTILITY(U,$J,.84,307,1,1,0)
 ;;=One of the IENs in the IENS has been left out, leaving an empty
 ;;^UTILITY(U,$J,.84,307,1,2,0)
 ;;=comma-piece. 
 ;;^UTILITY(U,$J,.84,307,2,0)
 ;;=^^1^1^2941018^
 ;;^UTILITY(U,$J,.84,307,2,1,0)
 ;;=The IENS '|IENS|' has an empty comma-piece.
 ;;^UTILITY(U,$J,.84,307,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,307,3,1,0)
 ;;=IENS^IENS.
 ;;^UTILITY(U,$J,.84,308,0)
 ;;=308^1^y^11
 ;;^UTILITY(U,$J,.84,308,1,0)
 ;;=^^3^3^2940629^
 ;;^UTILITY(U,$J,.84,308,1,1,0)
 ;;=The syntax of this IENS is incorrect. For example, a record number may be
 ;;^UTILITY(U,$J,.84,308,1,2,0)
 ;;=illegal; or a subfile may be specified as already existing, but have a
 ;;^UTILITY(U,$J,.84,308,1,3,0)
 ;;=parent that is just now being added.
 ;;^UTILITY(U,$J,.84,308,2,0)
 ;;=^^1^1^2941018^
 ;;^UTILITY(U,$J,.84,308,2,1,0)
 ;;=The IENS '|IENS|' is syntactically incorrect.
 ;;^UTILITY(U,$J,.84,308,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,308,3,1,0)
 ;;=IENS^IENS.
 ;;^UTILITY(U,$J,.84,309,0)
 ;;=309^1^^11
 ;;^UTILITY(U,$J,.84,309,1,0)
 ;;=^^2^2^2931109^
 ;;^UTILITY(U,$J,.84,309,1,1,0)
 ;;=A multiple field is involved.  Either the root of the multiple or the 
 ;;^UTILITY(U,$J,.84,309,1,2,0)
 ;;=necessary entry numbers are missing.
 ;;^UTILITY(U,$J,.84,309,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,309,2,1,0)
 ;;=There is insufficient information to identify an entry in a subfile.
 ;;^UTILITY(U,$J,.84,310,0)
 ;;=310^1^y^11
 ;;^UTILITY(U,$J,.84,310,1,0)
 ;;=^^6^6^2940629^
 ;;^UTILITY(U,$J,.84,310,1,1,0)
 ;;=Some of the IENS subscripts in this FDA conflict with each other. For
 ;;^UTILITY(U,$J,.84,310,1,2,0)
 ;;=example, one IENS may use the sequence number ?1 while another uses +1.
 ;;^UTILITY(U,$J,.84,310,1,3,0)
 ;;=This would be illegal because the sequence number 1 is being used to
 ;;^UTILITY(U,$J,.84,310,1,4,0)
 ;;=represent two different operations. Consult your documentation for an
 ;;^UTILITY(U,$J,.84,310,1,5,0)
 ;;=explanation of the various conflicts possible. The IENS returned with this
 ;;^UTILITY(U,$J,.84,310,1,6,0)
 ;;=error happens to be one of the IENS values in conflict.
 ;;^UTILITY(U,$J,.84,310,2,0)
 ;;=^^1^1^2941018^
 ;;^UTILITY(U,$J,.84,310,2,1,0)
 ;;=The IENS '|IENS|' conflicts with the rest of the FDA.
 ;;^UTILITY(U,$J,.84,310,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,310,3,1,0)
 ;;=IENS^IENS.
 ;;^UTILITY(U,$J,.84,311,0)
 ;;=311^1^y^11
 ;;^UTILITY(U,$J,.84,311,1,0)
 ;;=^^3^3^2940629^
 ;;^UTILITY(U,$J,.84,311,1,1,0)
 ;;=Adding an entry to a file without including all required identifiers
 ;;^UTILITY(U,$J,.84,311,1,2,0)
 ;;=violates database integrity. The entry identified by this IENS lacks some
 ;;^UTILITY(U,$J,.84,311,1,3,0)
 ;;=of its required identifiers in the passed FDA.
 ;;^UTILITY(U,$J,.84,311,2,0)
 ;;=^^1^1^2941018^
 ;;^UTILITY(U,$J,.84,311,2,1,0)
 ;;=The new record '|IENS|' lacks some required identifiers.
 ;;^UTILITY(U,$J,.84,311,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,311,3,1,0)
 ;;=IENS^IENS.
 ;;^UTILITY(U,$J,.84,330,0)
 ;;=330^1^y^11
 ;;^UTILITY(U,$J,.84,330,1,0)
 ;;=^^2^2^2941123^
 ;;^UTILITY(U,$J,.84,330,1,1,0)
 ;;=The value passed by the calling application should be a certain data type,
 ;;^UTILITY(U,$J,.84,330,1,2,0)
 ;;=but according to our checks it is not.
 ;;^UTILITY(U,$J,.84,330,2,0)
 ;;=^^1^1^2941123^
 ;;^UTILITY(U,$J,.84,330,2,1,0)
 ;;=The value '|1|' is not a valid |2|.
 ;;^UTILITY(U,$J,.84,330,3,0)
 ;;=^.845^2^2
