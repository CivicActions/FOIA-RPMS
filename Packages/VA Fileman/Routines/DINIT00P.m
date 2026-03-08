DINIT00P ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,8082,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8082,5,1,0)
 ;;=DIT^TRNMRG
 ;;^UTILITY(U,$J,.84,8083,0)
 ;;=8083^2^^11
 ;;^UTILITY(U,$J,.84,8083,1,0)
 ;;=^^2^2^2940318^^^^
 ;;^UTILITY(U,$J,.84,8083,1,1,0)
 ;;=Used to build error prompts in the TRANSFER/MERGE routine ^DIT3.  Could be
 ;;^UTILITY(U,$J,.84,8083,1,2,0)
 ;;=used elsewhere, however, so I didn't put it into the ERROR category.
 ;;^UTILITY(U,$J,.84,8083,2,0)
 ;;=^^1^1^2940318^
 ;;^UTILITY(U,$J,.84,8083,2,1,0)
 ;;=Transfer TO
 ;;^UTILITY(U,$J,.84,8083,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8083,5,1,0)
 ;;=DIT^TRNMRG
 ;;^UTILITY(U,$J,.84,8084,0)
 ;;=8084^2^^11
 ;;^UTILITY(U,$J,.84,8084,1,0)
 ;;=^^1^1^2940318^
 ;;^UTILITY(U,$J,.84,8084,1,1,0)
 ;;=The words 'file number' to be used in any dialog.
 ;;^UTILITY(U,$J,.84,8084,2,0)
 ;;=^^1^1^2940318^
 ;;^UTILITY(U,$J,.84,8084,2,1,0)
 ;;=file number
 ;;^UTILITY(U,$J,.84,8084,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8084,5,1,0)
 ;;=DIT^TRNMRG
 ;;^UTILITY(U,$J,.84,8085,0)
 ;;=8085^2^^11
 ;;^UTILITY(U,$J,.84,8085,1,0)
 ;;=^^1^1^2940426^^
 ;;^UTILITY(U,$J,.84,8085,1,1,0)
 ;;=The words 'IEN string' to be used in any dialog.
 ;;^UTILITY(U,$J,.84,8085,2,0)
 ;;=^^1^1^2940426^^
 ;;^UTILITY(U,$J,.84,8085,2,1,0)
 ;;=IEN string
 ;;^UTILITY(U,$J,.84,8085,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8085,5,1,0)
 ;;=DIT^TRNMRG
 ;;^UTILITY(U,$J,.84,8086,0)
 ;;=8086^2^^11
 ;;^UTILITY(U,$J,.84,8086,1,0)
 ;;=^^1^1^2940608^^^^
 ;;^UTILITY(U,$J,.84,8086,1,1,0)
 ;;=Warning to use the merge only during non-peak times.
 ;;^UTILITY(U,$J,.84,8086,2,0)
 ;;=^^5^5^2940608^
 ;;^UTILITY(U,$J,.84,8086,2,1,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,8086,2,2,0)
 ;;=NOTE: Use this option ONLY DURING NON-PEAK HOURS if merging entries in a
 ;;^UTILITY(U,$J,.84,8086,2,3,0)
 ;;=file that is pointed-to either by many files, or by large files.
 ;;^UTILITY(U,$J,.84,8086,2,4,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,8086,2,5,0)
 ;;=MERGE ENTRIES AFTER COMPARING THEM 
 ;;^UTILITY(U,$J,.84,8086,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9002,0)
 ;;=9002^3^y^11^
 ;;^UTILITY(U,$J,.84,9002,1,0)
 ;;=^^1^1^2930617^^
 ;;^UTILITY(U,$J,.84,9002,1,1,0)
 ;;=Help for entering maximum routine size for compiled routines.
 ;;^UTILITY(U,$J,.84,9002,2,0)
 ;;=^^4^4^2930629^^^^
 ;;^UTILITY(U,$J,.84,9002,2,1,0)
 ;;=This number will be used to determine how large to make the generated
 ;;^UTILITY(U,$J,.84,9002,2,2,0)
 ;;=compiled |1| routines.  The size must be a number greater
 ;;^UTILITY(U,$J,.84,9002,2,3,0)
 ;;=than 2400, the larger the better, up to the maximum routine size for
 ;;^UTILITY(U,$J,.84,9002,2,4,0)
 ;;=your operating system.
 ;;^UTILITY(U,$J,.84,9002,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,9002,3,1,0)
 ;;=1^Will be the word 'TEMPLATE' when compiling templates, or 'cross-reference' when compiling CROSS-REFERENCES.
 ;;^UTILITY(U,$J,.84,9002,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9002,5,0)
 ;;=^.841^3^3
 ;;^UTILITY(U,$J,.84,9002,5,1,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,9002,5,2,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,9002,5,3,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,9004,0)
 ;;=9004^3^y^11^
 ;;^UTILITY(U,$J,.84,9004,1,0)
 ;;=^^2^2^2931110^^^^
 ;;^UTILITY(U,$J,.84,9004,1,1,0)
 ;;=Help asking the user whether they wish to UNCOMPILE previously compiled
 ;;^UTILITY(U,$J,.84,9004,1,2,0)
 ;;=templates or cross-references.
 ;;^UTILITY(U,$J,.84,9004,2,0)
 ;;=^^4^4^2931110^^
 ;;^UTILITY(U,$J,.84,9004,2,1,0)
 ;;=  Answer YES to UNCOMPILE the |1|.
 ;;^UTILITY(U,$J,.84,9004,2,2,0)
 ;;=The compiled routine will no longer be used.
 ;;^UTILITY(U,$J,.84,9004,2,3,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9004,2,4,0)
 ;;=  Answer NO to recompile the |1| at this time.
 ;;^UTILITY(U,$J,.84,9004,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,9004,3,1,0)
 ;;=1^Will contain either the word 'TEMPLATE' or 'CROSS-REFERENCES.
 ;;^UTILITY(U,$J,.84,9004,4,0)
 ;;=^.847P^^0
 ;;^UTILITY(U,$J,.84,9004,5,0)
 ;;=^.841^3^3
 ;;^UTILITY(U,$J,.84,9004,5,1,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,9004,5,2,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,9004,5,3,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,9006,0)
 ;;=9006^3^y^11^
 ;;^UTILITY(U,$J,.84,9006,1,0)
 ;;=^^2^2^2931105^^^^
 ;;^UTILITY(U,$J,.84,9006,1,1,0)
 ;;=Help for prompting for compiled routine name, when compiling templates
 ;;^UTILITY(U,$J,.84,9006,1,2,0)
 ;;=or cross-references.
 ;;^UTILITY(U,$J,.84,9006,2,0)
 ;;=^^2^2^2931109^
 ;;^UTILITY(U,$J,.84,9006,2,1,0)
 ;;=Enter a valid MUMPS routine name of from 3 to |1| characters.  This must
