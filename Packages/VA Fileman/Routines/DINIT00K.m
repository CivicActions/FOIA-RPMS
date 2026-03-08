DINIT00K ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,8026,2,1,0)
 ;;=|1| now uncompiled.
 ;;^UTILITY(U,$J,.84,8026,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8026,3,1,0)
 ;;=1^Contains the word 'TEMPLATE' or 'CROSS-REFERENCES'
 ;;^UTILITY(U,$J,.84,8026,5,0)
 ;;=^.841^6^6
 ;;^UTILITY(U,$J,.84,8026,5,1,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8026,5,2,0)
 ;;=DIPZ^EN
 ;;^UTILITY(U,$J,.84,8026,5,3,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,8026,5,4,0)
 ;;=DIEZ^EN
 ;;^UTILITY(U,$J,.84,8026,5,5,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,8026,5,6,0)
 ;;=DIKZ^EN
 ;;^UTILITY(U,$J,.84,8027,0)
 ;;=8027^2^^11
 ;;^UTILITY(U,$J,.84,8027,1,0)
 ;;=^^2^2^2931110^^^
 ;;^UTILITY(U,$J,.84,8027,1,1,0)
 ;;=Prompt for maximum routine size, used when compiling templates or
 ;;^UTILITY(U,$J,.84,8027,1,2,0)
 ;;=cross-references.
 ;;^UTILITY(U,$J,.84,8027,2,0)
 ;;=^^1^1^2931110^
 ;;^UTILITY(U,$J,.84,8027,2,1,0)
 ;;=Maximum routine size on this computer (in bytes).
 ;;^UTILITY(U,$J,.84,8027,5,0)
 ;;=^.841^3^3
 ;;^UTILITY(U,$J,.84,8027,5,1,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8027,5,2,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,8027,5,3,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,8028,0)
 ;;=8028^2^y^11^
 ;;^UTILITY(U,$J,.84,8028,1,0)
 ;;=^^2^2^2931110^^^^
 ;;^UTILITY(U,$J,.84,8028,1,1,0)
 ;;=Extended dialogue for asking user whether they wish to UNCOMPILE
 ;;^UTILITY(U,$J,.84,8028,1,2,0)
 ;;=a previously compiled template or cross-references.
 ;;^UTILITY(U,$J,.84,8028,2,0)
 ;;=^^2^2^2931110^
 ;;^UTILITY(U,$J,.84,8028,2,1,0)
 ;;= |1| currently compiled under namespace |2|.
 ;;^UTILITY(U,$J,.84,8028,2,2,0)
 ;;=UNCOMPILE the |1|
 ;;^UTILITY(U,$J,.84,8028,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,8028,3,1,0)
 ;;=1^Contains the word 'TEMPLATE' or 'CROSS-REFERENCES'
 ;;^UTILITY(U,$J,.84,8028,3,2,0)
 ;;=2^Routine name under which templates were previously compiled.
 ;;^UTILITY(U,$J,.84,8028,5,0)
 ;;=^.841^4^4
 ;;^UTILITY(U,$J,.84,8028,5,1,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8028,5,2,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,8028,5,3,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,8028,5,4,0)
 ;;=DIOZ^ENCU
 ;;^UTILITY(U,$J,.84,8029,0)
 ;;=8029^2^y^11^
 ;;^UTILITY(U,$J,.84,8029,1,0)
 ;;=^^2^2^2931110^
 ;;^UTILITY(U,$J,.84,8029,1,1,0)
 ;;=Extended dialogue for asking user whether they wish to COMPILE a
 ;;^UTILITY(U,$J,.84,8029,1,2,0)
 ;;=template or cross-references.
 ;;^UTILITY(U,$J,.84,8029,2,0)
 ;;=^^2^2^2931110^
 ;;^UTILITY(U,$J,.84,8029,2,1,0)
 ;;= |1| not currently compiled.
 ;;^UTILITY(U,$J,.84,8029,2,2,0)
 ;;=COMPILE the |1|
 ;;^UTILITY(U,$J,.84,8029,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8029,3,1,0)
 ;;=1^Contains the word 'TEMPLATE' or 'CROSS-REFERENCES'
 ;;^UTILITY(U,$J,.84,8029,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8029,5,1,0)
 ;;=DIOZ^ENCU
 ;;^UTILITY(U,$J,.84,8030,0)
 ;;=8030^2^y^11^
 ;;^UTILITY(U,$J,.84,8030,1,0)
 ;;=^^2^2^2931110^^^^
 ;;^UTILITY(U,$J,.84,8030,1,1,0)
 ;;=Warning to user that SORT/PRINT templates are uneditable because the PRINT
 ;;^UTILITY(U,$J,.84,8030,1,2,0)
 ;;=TEMPLATE field on the SORT TEMPLATE has linked it with a print template.
 ;;^UTILITY(U,$J,.84,8030,2,0)
 ;;=^^7^7^2931112^
 ;;^UTILITY(U,$J,.84,8030,2,1,0)
 ;;=Because this Sort Template has been linked with the Print Template
 ;;^UTILITY(U,$J,.84,8030,2,2,0)
 ;;=|1|, neither template can be edited from this option.
 ;;^UTILITY(U,$J,.84,8030,2,3,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,8030,2,4,0)
 ;;=To edit the templates, first use the FileMan TEMPLATE EDIT
 ;;^UTILITY(U,$J,.84,8030,2,5,0)
 ;;=option to edit the Sort Template, and delete the field called
 ;;^UTILITY(U,$J,.84,8030,2,6,0)
 ;;='PRINT TEMPLATE'.  Then, the templates can be edited from
 ;;^UTILITY(U,$J,.84,8030,2,7,0)
 ;;=the PRINT option.
 ;;^UTILITY(U,$J,.84,8030,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8030,3,1,0)
 ;;=1^Name of associated PRINT TEMPLATE.
 ;;^UTILITY(U,$J,.84,8030,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8030,5,1,0)
 ;;=DIP^EN
 ;;^UTILITY(U,$J,.84,8031,0)
 ;;=8031^2^^11
 ;;^UTILITY(U,$J,.84,8031,1,0)
 ;;=^^1^1^2931110^^
 ;;^UTILITY(U,$J,.84,8031,1,1,0)
 ;;=Warning that compiled routine names may get too long.
 ;;^UTILITY(U,$J,.84,8031,2,0)
 ;;=^^3^3^2931110^
 ;;^UTILITY(U,$J,.84,8031,2,1,0)
 ;;=WARNING!!  Since the namespace for this routine is so long, use the
 ;;^UTILITY(U,$J,.84,8031,2,2,0)
 ;;=largest possible size to compile these routines.  Otherwise, FileMan may
 ;;^UTILITY(U,$J,.84,8031,2,3,0)
 ;;=run out of routine names.
 ;;^UTILITY(U,$J,.84,8031,5,0)
 ;;=^.841^3^3
