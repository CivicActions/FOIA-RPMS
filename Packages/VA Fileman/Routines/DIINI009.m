DIINI009 ; ; 22-DEC-1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^UTILITY(U,$J,"OPT",396,20)
 ;;=S DI=1 D EN^DIAX
 ;;^UTILITY(U,$J,"OPT",396,"U")
 ;;=SELECT ENTRIES TO EXTRACT
 ;;^UTILITY(U,$J,"OPT",397,0)
 ;;=DIAX ADD/DELETE^Add/Delete Selected Entries^^A^^DIEXTRACT^^^^^^^^1^^^
 ;;^UTILITY(U,$J,"OPT",397,1,0)
 ;;=^^3^3^2921222^
 ;;^UTILITY(U,$J,"OPT",397,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",397,1,2,0)
 ;;=Use this option to edit the list of selected entries to extract by adding
 ;;^UTILITY(U,$J,"OPT",397,1,3,0)
 ;;=needed entries or by deleting undesired ones.
 ;;^UTILITY(U,$J,"OPT",397,20)
 ;;=S DI=2 D EN^DIAX
 ;;^UTILITY(U,$J,"OPT",397,"U")
 ;;=ADD/DELETE SELECTED ENTRIES
 ;;^UTILITY(U,$J,"OPT",398,0)
 ;;=DIAX PRINT^Print Selected Entries^^A^^DIEXTRACT^^^^^^^^1^^^
 ;;^UTILITY(U,$J,"OPT",398,1,0)
 ;;=^^3^3^2921222^
 ;;^UTILITY(U,$J,"OPT",398,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",398,1,2,0)
 ;;=Use this option to display the list of entries selected for extract.  This
 ;;^UTILITY(U,$J,"OPT",398,1,3,0)
 ;;=option uses the standard VA Fileman interface for printing.
 ;;^UTILITY(U,$J,"OPT",398,20)
 ;;=S DI=3 D EN^DIAX
 ;;^UTILITY(U,$J,"OPT",398,"U")
 ;;=PRINT SELECTED ENTRIES
 ;;^UTILITY(U,$J,"OPT",399,0)
 ;;=DIAX MODIFY^Modify Destination File^^A^^DIEXTRACT^^^^^^^^1^^^
 ;;^UTILITY(U,$J,"OPT",399,1,0)
 ;;=^^3^3^2921222^
 ;;^UTILITY(U,$J,"OPT",399,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",399,1,2,0)
 ;;=Use this option to create a destination file that will hold the data
 ;;^UTILITY(U,$J,"OPT",399,1,3,0)
 ;;=extracted from the source entries.
 ;;^UTILITY(U,$J,"OPT",399,20)
 ;;=S DI=4 D EN^DIAX
 ;;^UTILITY(U,$J,"OPT",399,"U")
 ;;=MODIFY DESTINATION FILE
 ;;^UTILITY(U,$J,"OPT",400,0)
 ;;=DIAX CREATE^Create Extract Template^^A^^DIEXTRACT^^^^^^^^1^^^
 ;;^UTILITY(U,$J,"OPT",400,1,0)
 ;;=^^4^4^2930104^
 ;;^UTILITY(U,$J,"OPT",400,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",400,1,2,0)
 ;;=Use this option to identify the fields to be extracted from the source
 ;;^UTILITY(U,$J,"OPT",400,1,3,0)
 ;;=file and the fields in the destination file where the extracted data will
 ;;^UTILITY(U,$J,"OPT",400,1,4,0)
 ;;=be stored.
 ;;^UTILITY(U,$J,"OPT",400,20)
 ;;=S DI=5 D EN^DIAX
 ;;^UTILITY(U,$J,"OPT",400,"U")
 ;;=CREATE EXTRACT TEMPLATE
 ;;^UTILITY(U,$J,"OPT",401,0)
 ;;=DIAX UPDATE^Update Destination File^^A^^DIEXTRACT^^^^^^^^1^^^
 ;;^UTILITY(U,$J,"OPT",401,1,0)
 ;;=^^3^3^2921222^
 ;;^UTILITY(U,$J,"OPT",401,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",401,1,2,0)
 ;;=Use this option to extract data from the source file and move it to the
 ;;^UTILITY(U,$J,"OPT",401,1,3,0)
 ;;=destination file.
 ;;^UTILITY(U,$J,"OPT",401,20)
 ;;=S DI=6 D EN^DIAX
 ;;^UTILITY(U,$J,"OPT",401,"U")
 ;;=UPDATE DESTINATION FILE
 ;;^UTILITY(U,$J,"OPT",402,0)
 ;;=DIAX PURGE^Purge Extracted Entries^^A^^DIEXTRACT^^^^^^^^1^^^
 ;;^UTILITY(U,$J,"OPT",402,1,0)
 ;;=^^2^2^2921222^
 ;;^UTILITY(U,$J,"OPT",402,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",402,1,2,0)
 ;;=Use this option to delete the extracted data from the primary file.
 ;;^UTILITY(U,$J,"OPT",402,20)
 ;;=S DI=7 D EN^DIAX
 ;;^UTILITY(U,$J,"OPT",402,"U")
 ;;=PURGE EXTRACTED ENTRIES
 ;;^UTILITY(U,$J,"OPT",403,0)
 ;;=DIAX CANCEL^Cancel Extract Selection^^A^^DIEXTRACT^^^^^^^^1^^^
 ;;^UTILITY(U,$J,"OPT",403,1,0)
 ;;=^^3^3^2921222^
 ;;^UTILITY(U,$J,"OPT",403,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",403,1,2,0)
 ;;=Use this option to cancel an extract activity any time before the selected
 ;;^UTILITY(U,$J,"OPT",403,1,3,0)
 ;;=entries in the primary file are purged.
 ;;^UTILITY(U,$J,"OPT",403,20)
 ;;=S DI=8 D EN^DIAX
 ;;^UTILITY(U,$J,"OPT",403,"U")
 ;;=CANCEL EXTRACT SELECTION
 ;;^UTILITY(U,$J,"OPT",404,0)
 ;;=DIAX VALIDATE^Validate Extract Template^^A^^DIEXTRACT^^^^^^^^1^^^
 ;;^UTILITY(U,$J,"OPT",404,1,0)
 ;;=^^3^3^2930104^
 ;;^UTILITY(U,$J,"OPT",404,1,1,0)
 ;;= 
 ;;^UTILITY(U,$J,"OPT",404,1,2,0)
 ;;=Use this option to verify the compatibility between fields to be extracted
 ;;^UTILITY(U,$J,"OPT",404,1,3,0)
 ;;=and their corresponding destination fields in the destination file.
 ;;^UTILITY(U,$J,"OPT",404,20)
 ;;=S DI=9 D EN^DIAX
 ;;^UTILITY(U,$J,"OPT",404,"U")
 ;;=VALIDATE EXTRACT TEMPLATE
 ;;^UTILITY(U,$J,"OPT",405,0)
 ;;=DDXP FORMAT DOCUMENTATION^Print Format Documentation^^A^^^^^^^^^^1
 ;;^UTILITY(U,$J,"OPT",405,1,0)
 ;;=^^2^2^2921207^^
 ;;^UTILITY(U,$J,"OPT",405,1,1,0)
 ;;=Use this option ot print documentation for existing entries in the Foreign
 ;;^UTILITY(U,$J,"OPT",405,1,2,0)
 ;;=Format file.
