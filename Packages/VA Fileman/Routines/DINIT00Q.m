DINIT00Q ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9006,2,2,0)
 ;;=be entered without a leading up-arrow, and cannot begin with "DI".
 ;;^UTILITY(U,$J,.84,9006,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,9006,3,1,0)
 ;;=1^Internal parameter indicating the maximum number of characters allowed for routine namespace.
 ;;^UTILITY(U,$J,.84,9006,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9006,5,0)
 ;;=^.841^4^4
 ;;^UTILITY(U,$J,.84,9006,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,9006,5,2,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,9006,5,3,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,9006,5,4,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,9014,0)
 ;;=9014^3^^11^
 ;;^UTILITY(U,$J,.84,9014,1,0)
 ;;=^^1^1^2930706^^^^
 ;;^UTILITY(U,$J,.84,9014,1,1,0)
 ;;=Help prompt for compiling sort templates.
 ;;^UTILITY(U,$J,.84,9014,2,0)
 ;;=^^3^3^2931110^
 ;;^UTILITY(U,$J,.84,9014,2,1,0)
 ;;=If YES is entered,
 ;;^UTILITY(U,$J,.84,9014,2,2,0)
 ;;=the Sort logic will be compiled into a routine at the
 ;;^UTILITY(U,$J,.84,9014,2,3,0)
 ;;=time the template is used in a FileMan Sort/Print.
 ;;^UTILITY(U,$J,.84,9014,3,0)
 ;;=^.845^^0
 ;;^UTILITY(U,$J,.84,9014,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,9014,5,1,0)
 ;;=DIOZ^ENCU
 ;;^UTILITY(U,$J,.84,9019,0)
 ;;=9019^3^^11^
 ;;^UTILITY(U,$J,.84,9019,1,0)
 ;;=^^1^1^2931110^^^^
 ;;^UTILITY(U,$J,.84,9019,1,1,0)
 ;;=Help prompt for Uncompiling sort templates.
 ;;^UTILITY(U,$J,.84,9019,2,0)
 ;;=^^3^3^2931110^
 ;;^UTILITY(U,$J,.84,9019,2,1,0)
 ;;=If YES is entered,
 ;;^UTILITY(U,$J,.84,9019,2,2,0)
 ;;=the Sort logic for this template will NOT be compiled into a
 ;;^UTILITY(U,$J,.84,9019,2,3,0)
 ;;=routine during the time it is used by a FileMan sort/print.
 ;;^UTILITY(U,$J,.84,9019,3,0)
 ;;=^.845^^0
 ;;^UTILITY(U,$J,.84,9019,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,9019,5,1,0)
 ;;=DIOZ^ENCU
 ;;^UTILITY(U,$J,.84,9024,0)
 ;;=9024^3^^11^
 ;;^UTILITY(U,$J,.84,9024,1,0)
 ;;=^^2^2^2931105^
 ;;^UTILITY(U,$J,.84,9024,1,1,0)
 ;;=Help for the POST-SELECTION ACTION field for a file.  This entry is put
 ;;^UTILITY(U,$J,.84,9024,1,2,0)
 ;;=in from the Utility option to edit a file.
 ;;^UTILITY(U,$J,.84,9024,2,0)
 ;;=^^1^1^2931105^^^
 ;;^UTILITY(U,$J,.84,9024,2,1,0)
 ;;=This code will be executed whenever an entry is selected from the file.
 ;;^UTILITY(U,$J,.84,9024,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,9024,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,9025,0)
 ;;=9025^3^^11^
 ;;^UTILITY(U,$J,.84,9025,1,0)
 ;;=^^1^1^2931105^^
 ;;^UTILITY(U,$J,.84,9025,1,1,0)
 ;;=General help for MUMPS type fields.
 ;;^UTILITY(U,$J,.84,9025,2,0)
 ;;=^^1^1^2931105^
 ;;^UTILITY(U,$J,.84,9025,2,1,0)
 ;;=Enter a line of standard MUMPS code.
 ;;^UTILITY(U,$J,.84,9025,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,9025,5,1,0)
 ;;=DIOU^6
 ;;^UTILITY(U,$J,.84,9026,0)
 ;;=9026^3^^11
 ;;^UTILITY(U,$J,.84,9026,1,0)
 ;;=^^3^3^2931105^^
 ;;^UTILITY(U,$J,.84,9026,1,1,0)
 ;;=The DD for the file of files is not completely FileMan compatible.  This
 ;;^UTILITY(U,$J,.84,9026,1,2,0)
 ;;=is the standard help prompt for the LOOK-UP PROGRAM field on the file of
 ;;^UTILITY(U,$J,.84,9026,1,3,0)
 ;;=files.  Prompt appears when file attributes are being edited.
 ;;^UTILITY(U,$J,.84,9026,2,0)
 ;;=^^2^2^2931105^^
 ;;^UTILITY(U,$J,.84,9026,2,1,0)
 ;;=This special lookup routine will be executed instead of the standard
 ;;^UTILITY(U,$J,.84,9026,2,2,0)
 ;;=FileMan lookup logic, whenever a call is made to ^DIC.
 ;;^UTILITY(U,$J,.84,9026,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,9026,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,9027,0)
 ;;=9027^3^^11
 ;;^UTILITY(U,$J,.84,9027,1,0)
 ;;=^^3^3^2931105^
 ;;^UTILITY(U,$J,.84,9027,1,1,0)
 ;;=The DD for the file of files is not completely FileMan compatible.  This
 ;;^UTILITY(U,$J,.84,9027,1,2,0)
 ;;=is the standard help prompt for the CROSS-REFERENCE ROUTINE field on the
 ;;^UTILITY(U,$J,.84,9027,1,3,0)
 ;;=file of files.  Prompt appears when file attributes are being edited.
 ;;^UTILITY(U,$J,.84,9027,2,0)
 ;;=^^5^5^2931109^
 ;;^UTILITY(U,$J,.84,9027,2,1,0)
 ;;=If a NEW routine name is entered, but the cross-references are not
 ;;^UTILITY(U,$J,.84,9027,2,2,0)
 ;;=compiled at this time, the routine name will be automatically deleted.
 ;;^UTILITY(U,$J,.84,9027,2,3,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9027,2,4,0)
 ;;=If the routine name is deleted, the cross-references are considered
 ;;^UTILITY(U,$J,.84,9027,2,5,0)
 ;;=uncompiled, and FileMan will not use the routine for re-indexing.
 ;;^UTILITY(U,$J,.84,9027,5,0)
 ;;=^.841^1^1
