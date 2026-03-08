DINIT00O ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,8071,0)
 ;;=8071^2^^11
 ;;^UTILITY(U,$J,.84,8071,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8071,1,1,0)
 ;;=Variable Pointer lookup
 ;;^UTILITY(U,$J,.84,8071,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8071,2,1,0)
 ;;=Enter one of the following:
 ;;^UTILITY(U,$J,.84,8071,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8072,0)
 ;;=8072^2^y^11^
 ;;^UTILITY(U,$J,.84,8072,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8072,1,1,0)
 ;;=Variable Pointer Lookup
 ;;^UTILITY(U,$J,.84,8072,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8072,2,1,0)
 ;;=  |1|.EntryName to select a |2|
 ;;^UTILITY(U,$J,.84,8072,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,8072,3,1,0)
 ;;=1^Prefix
 ;;^UTILITY(U,$J,.84,8072,3,2,0)
 ;;=2^Filename
 ;;^UTILITY(U,$J,.84,8072,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8073,0)
 ;;=8073^2^^11
 ;;^UTILITY(U,$J,.84,8073,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8073,1,1,0)
 ;;=Variable Pointer Lookup
 ;;^UTILITY(U,$J,.84,8073,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8073,2,1,0)
 ;;=To see the entries in any particular file type <Prefix.?>
 ;;^UTILITY(U,$J,.84,8073,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8074,0)
 ;;=8074^2^^11
 ;;^UTILITY(U,$J,.84,8074,1,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8074,1,1,0)
 ;;=How to call for help
 ;;^UTILITY(U,$J,.84,8074,2,0)
 ;;=^^1^1^2940314^
 ;;^UTILITY(U,$J,.84,8074,2,1,0)
 ;;=Press <PF1>H for help
 ;;^UTILITY(U,$J,.84,8074,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8075,0)
 ;;=8075^2^^11
 ;;^UTILITY(U,$J,.84,8075,1,0)
 ;;=^^1^1^2940524^^
 ;;^UTILITY(U,$J,.84,8075,1,1,0)
 ;;=Save changes question on form exit
 ;;^UTILITY(U,$J,.84,8075,2,0)
 ;;=^^1^1^2940524^^
 ;;^UTILITY(U,$J,.84,8075,2,1,0)
 ;;=Save changes before leaving form (Y/N)?
 ;;^UTILITY(U,$J,.84,8075,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8076,0)
 ;;=8076^2^^11
 ;;^UTILITY(U,$J,.84,8076,1,0)
 ;;=^^1^1^2940315^
 ;;^UTILITY(U,$J,.84,8076,1,1,0)
 ;;=Timeout
 ;;^UTILITY(U,$J,.84,8076,2,0)
 ;;=^^1^1^2940315^
 ;;^UTILITY(U,$J,.84,8076,2,1,0)
 ;;=Timed out.  
 ;;^UTILITY(U,$J,.84,8076,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8077,0)
 ;;=8077^2^^11
 ;;^UTILITY(U,$J,.84,8077,1,0)
 ;;=^^1^1^2940315^
 ;;^UTILITY(U,$J,.84,8077,1,1,0)
 ;;=Changes not saved on leaving form
 ;;^UTILITY(U,$J,.84,8077,2,0)
 ;;=^^1^1^2940315^
 ;;^UTILITY(U,$J,.84,8077,2,1,0)
 ;;=Changes not saved!
 ;;^UTILITY(U,$J,.84,8077,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8078,0)
 ;;=8078^2^^11
 ;;^UTILITY(U,$J,.84,8078,1,0)
 ;;=^^1^1^2940316^
 ;;^UTILITY(U,$J,.84,8078,1,1,0)
 ;;=Wording for record
 ;;^UTILITY(U,$J,.84,8078,2,0)
 ;;=^^1^1^2940316^
 ;;^UTILITY(U,$J,.84,8078,2,1,0)
 ;;=record
 ;;^UTILITY(U,$J,.84,8078,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8079,0)
 ;;=8079^2^^11
 ;;^UTILITY(U,$J,.84,8079,1,0)
 ;;=^^1^1^2940316^
 ;;^UTILITY(U,$J,.84,8079,1,1,0)
 ;;=Wording for Subrecord
 ;;^UTILITY(U,$J,.84,8079,2,0)
 ;;=^^1^1^2940316^
 ;;^UTILITY(U,$J,.84,8079,2,1,0)
 ;;=Subrecord
 ;;^UTILITY(U,$J,.84,8079,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8080,0)
 ;;=8080^2^y^11^
 ;;^UTILITY(U,$J,.84,8080,1,0)
 ;;=^^1^1^2940316^
 ;;^UTILITY(U,$J,.84,8080,1,1,0)
 ;;=Warning for immediate deletion of entries.
 ;;^UTILITY(U,$J,.84,8080,2,0)
 ;;=^^3^3^2940316^
 ;;^UTILITY(U,$J,.84,8080,2,1,0)
 ;;=  WARNING: DELETIONS ARE DONE IMMEDIATELY!
 ;;^UTILITY(U,$J,.84,8080,2,2,0)
 ;;=           (EXITING WITHOUT SAVING WILL NOT RESTORE DELETED RECORDS.)
 ;;^UTILITY(U,$J,.84,8080,2,3,0)
 ;;=Are you sure you want to delete this entire |1| (Y/N)?
 ;;^UTILITY(U,$J,.84,8080,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8080,3,1,0)
 ;;=1^Record or Subrecord
 ;;^UTILITY(U,$J,.84,8080,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8081,0)
 ;;=8081^2^y^11^
 ;;^UTILITY(U,$J,.84,8081,1,0)
 ;;=^^1^1^2940316^
 ;;^UTILITY(U,$J,.84,8081,1,1,0)
 ;;=Choose from-to dialog
 ;;^UTILITY(U,$J,.84,8081,2,0)
 ;;=^^1^1^2940316^^
 ;;^UTILITY(U,$J,.84,8081,2,1,0)
 ;;=Choose |1| or '^' to quit: 
 ;;^UTILITY(U,$J,.84,8081,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8081,3,1,0)
 ;;=1^Number range for selection
 ;;^UTILITY(U,$J,.84,8081,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,8082,0)
 ;;=8082^2^^11
 ;;^UTILITY(U,$J,.84,8082,1,0)
 ;;=^^2^2^2940318^^^^
 ;;^UTILITY(U,$J,.84,8082,1,1,0)
 ;;=Used to build error prompts in the TRANSFER/MERGE routine ^DIT3.  Could be
 ;;^UTILITY(U,$J,.84,8082,1,2,0)
 ;;=used elsewhere, however, so I didn't put it into the ERROR category.
 ;;^UTILITY(U,$J,.84,8082,2,0)
 ;;=^^1^1^2940318^
 ;;^UTILITY(U,$J,.84,8082,2,1,0)
 ;;=Transfer FROM
