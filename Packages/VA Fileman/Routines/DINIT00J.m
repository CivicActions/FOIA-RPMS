DINIT00J ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,8019,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,8020,0)
 ;;=8020^2^^11
 ;;^UTILITY(U,$J,.84,8020,1,0)
 ;;=^^2^2^2931110^^^^
 ;;^UTILITY(U,$J,.84,8020,1,1,0)
 ;;=This prompt asks the user whether they are ready to compile, when
 ;;^UTILITY(U,$J,.84,8020,1,2,0)
 ;;=compiling TEMPLATES or CROSS-REFERENCES.
 ;;^UTILITY(U,$J,.84,8020,2,0)
 ;;=^^1^1^2931110^^
 ;;^UTILITY(U,$J,.84,8020,2,1,0)
 ;;=Should the compilation run now
 ;;^UTILITY(U,$J,.84,8020,5,0)
 ;;=^.841^4^4
 ;;^UTILITY(U,$J,.84,8020,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,8020,5,2,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8020,5,3,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,8020,5,4,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,8021,0)
 ;;=8021^2^^11
 ;;^UTILITY(U,$J,.84,8021,1,0)
 ;;=^^3^3^2931109^
 ;;^UTILITY(U,$J,.84,8021,1,1,0)
 ;;=Message from editing the CROSS-REFERENCE ROUTINE.  If this field is
 ;;^UTILITY(U,$J,.84,8021,1,2,0)
 ;;=deleted, the message notifies the user that the compiled routines will no
 ;;^UTILITY(U,$J,.84,8021,1,3,0)
 ;;=longer be used for re-indexing.
 ;;^UTILITY(U,$J,.84,8021,2,0)
 ;;=^^1^1^2931109^
 ;;^UTILITY(U,$J,.84,8021,2,1,0)
 ;;=The compiled routines will no longer be used for re-indexing.
 ;;^UTILITY(U,$J,.84,8021,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8021,5,1,0)
 ;;=DIU0^6
 ;;^UTILITY(U,$J,.84,8022,0)
 ;;=8022^2^^11
 ;;^UTILITY(U,$J,.84,8022,1,0)
 ;;=^^2^2^2931110^^^
 ;;^UTILITY(U,$J,.84,8022,1,1,0)
 ;;=Used when compiling PRINT templates, this is the prompt for the margin
 ;;^UTILITY(U,$J,.84,8022,1,2,0)
 ;;=width to be used for the printed report.
 ;;^UTILITY(U,$J,.84,8022,2,0)
 ;;=^^1^1^2931112^
 ;;^UTILITY(U,$J,.84,8022,2,1,0)
 ;;=Margin Width for output
 ;;^UTILITY(U,$J,.84,8022,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8022,5,1,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8023,0)
 ;;=8023^2^^11
 ;;^UTILITY(U,$J,.84,8023,1,0)
 ;;=^^2^2^2931110^^^^
 ;;^UTILITY(U,$J,.84,8023,1,1,0)
 ;;=This is the help prompt for MARGIN WIDTH FOR OUTPUT, used when compiling
 ;;^UTILITY(U,$J,.84,8023,1,2,0)
 ;;=PRINT templates.
 ;;^UTILITY(U,$J,.84,8023,2,0)
 ;;=^^2^2^2931110^^^^
 ;;^UTILITY(U,$J,.84,8023,2,1,0)
 ;;=Type a number from 19 to 255.  This is the number of columns
 ;;^UTILITY(U,$J,.84,8023,2,2,0)
 ;;=on the report
 ;;^UTILITY(U,$J,.84,8023,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,8023,5,1,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8024,0)
 ;;=8024^2^y^11^
 ;;^UTILITY(U,$J,.84,8024,1,0)
 ;;=^^1^1^2931110^^^^
 ;;^UTILITY(U,$J,.84,8024,1,1,0)
 ;;=This is the text that tells the user they are now compiling routines.
 ;;^UTILITY(U,$J,.84,8024,2,0)
 ;;=^^1^1^2931110^^^^
 ;;^UTILITY(U,$J,.84,8024,2,1,0)
 ;;=Compiling |1| |2| of File |3|.
 ;;^UTILITY(U,$J,.84,8024,3,0)
 ;;=^.845^3^3
 ;;^UTILITY(U,$J,.84,8024,3,1,0)
 ;;=1^Name of template, if compiling templates.
 ;;^UTILITY(U,$J,.84,8024,3,2,0)
 ;;=2^The words "print template", "cross-references", etc. (i.e., what is being compiled).
 ;;^UTILITY(U,$J,.84,8024,3,3,0)
 ;;=3^File name
 ;;^UTILITY(U,$J,.84,8024,5,0)
 ;;=^.841^6^6
 ;;^UTILITY(U,$J,.84,8024,5,1,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8024,5,2,0)
 ;;=DIPZ^EN
 ;;^UTILITY(U,$J,.84,8024,5,3,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,8024,5,4,0)
 ;;=DIEZ^EN
 ;;^UTILITY(U,$J,.84,8024,5,5,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,8024,5,6,0)
 ;;=DIKZ^EN
 ;;^UTILITY(U,$J,.84,8025,0)
 ;;=8025^2^y^11^
 ;;^UTILITY(U,$J,.84,8025,1,0)
 ;;=^^2^2^2931110^^
 ;;^UTILITY(U,$J,.84,8025,1,1,0)
 ;;=Notify user that a routine has been filed.  Used during compilation of
 ;;^UTILITY(U,$J,.84,8025,1,2,0)
 ;;=TEMPLATES and CROSS-REFERENCES.
 ;;^UTILITY(U,$J,.84,8025,2,0)
 ;;=^^1^1^2931110^^^
 ;;^UTILITY(U,$J,.84,8025,2,1,0)
 ;;='|1|' ROUTINE FILED.
 ;;^UTILITY(U,$J,.84,8025,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8025,3,1,0)
 ;;=1^Routine name
 ;;^UTILITY(U,$J,.84,8025,5,0)
 ;;=^.841^8^7
 ;;^UTILITY(U,$J,.84,8025,5,1,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,8025,5,2,0)
 ;;=DIKZ^EN
 ;;^UTILITY(U,$J,.84,8025,5,3,0)
 ;;=DIOZ^ENCU
 ;;^UTILITY(U,$J,.84,8025,5,5,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,8025,5,6,0)
 ;;=DIPZ^EN
 ;;^UTILITY(U,$J,.84,8025,5,7,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,8025,5,8,0)
 ;;=DIEZ^EN
 ;;^UTILITY(U,$J,.84,8026,0)
 ;;=8026^2^y^11^
 ;;^UTILITY(U,$J,.84,8026,1,0)
 ;;=^^2^2^2931110^^^
 ;;^UTILITY(U,$J,.84,8026,1,1,0)
 ;;=Used to notify the user that templates or cross-references have been
 ;;^UTILITY(U,$J,.84,8026,1,2,0)
 ;;=UNCOMPILED.
 ;;^UTILITY(U,$J,.84,8026,2,0)
 ;;=^^1^1^2931110^
