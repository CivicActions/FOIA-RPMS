DINIT012 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9257,2,4,0)
 ;;=Press   To
 ;;^UTILITY(U,$J,.84,9257,2,5,0)
 ;;=----------------------------------------
 ;;^UTILITY(U,$J,.84,9257,2,6,0)
 ;;=<PF1>M  Select another form
 ;;^UTILITY(U,$J,.84,9257,2,7,0)
 ;;=<PF1>P  Select another page
 ;;^UTILITY(U,$J,.84,9257,2,8,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9257,2,9,0)
 ;;=<PF2>M  Add a new form
 ;;^UTILITY(U,$J,.84,9257,2,10,0)
 ;;=<PF2>P  Add a new page
 ;;^UTILITY(U,$J,.84,9257,2,11,0)
 ;;=<PF2>B  Add a new block
 ;;^UTILITY(U,$J,.84,9257,2,12,0)
 ;;=<PF2>F  Add a new field element
 ;;^UTILITY(U,$J,.84,9257,2,13,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9257,2,14,0)
 ;;=<PF4>M  Edit properties of current form
 ;;^UTILITY(U,$J,.84,9257,2,15,0)
 ;;=<PF4>P  Edit properties of current page
 ;;^UTILITY(U,$J,.84,9258,0)
 ;;=9258^3^^11
 ;;^UTILITY(U,$J,.84,9258,1,0)
 ;;=^^1^1^2940707^
 ;;^UTILITY(U,$J,.84,9258,1,1,0)
 ;;=Help Screen 8 of Form Editor.
 ;;^UTILITY(U,$J,.84,9258,2,0)
 ;;=^^11^11^2940707^
 ;;^UTILITY(U,$J,.84,9258,2,1,0)
 ;;=                                                          \BHelp Screen 8 of 9\n
 ;;^UTILITY(U,$J,.84,9258,2,2,0)
 ;;=\BDELETING ELEMENTS\n
 ;;^UTILITY(U,$J,.84,9258,2,3,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9258,2,4,0)
 ;;=To delete an element, edit the properties of the element, and enter an
 ;;^UTILITY(U,$J,.84,9258,2,5,0)
 ;;=at-sign (@) at the first field of the ScreenMan form.  For example, to
 ;;^UTILITY(U,$J,.84,9258,2,6,0)
 ;;=delete a field from a block, select the field with <SpaceBar>, press <PF4>
 ;;^UTILITY(U,$J,.84,9258,2,7,0)
 ;;=to invoke the "edit properties" form, and enter @ at the "Field Order:"
 ;;^UTILITY(U,$J,.84,9258,2,8,0)
 ;;=prompt.
 ;;^UTILITY(U,$J,.84,9258,2,9,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9258,2,10,0)
 ;;=You cannot use the Form Editor to delete entire forms or blocks.  A separate
 ;;^UTILITY(U,$J,.84,9258,2,11,0)
 ;;=utility provides that functionality.
 ;;^UTILITY(U,$J,.84,9259,0)
 ;;=9259^3^^11
 ;;^UTILITY(U,$J,.84,9259,1,0)
 ;;=^^1^1^2940707^^
 ;;^UTILITY(U,$J,.84,9259,1,1,0)
 ;;=Help Screen 9 of Form Editor.
 ;;^UTILITY(U,$J,.84,9259,2,0)
 ;;=^^16^16^2940707^
 ;;^UTILITY(U,$J,.84,9259,2,1,0)
 ;;=                                                          \BHelp Screen 9 of 9\n
 ;;^UTILITY(U,$J,.84,9259,2,2,0)
 ;;=\BREORDERING FIELDS ON A BLOCK\n
 ;;^UTILITY(U,$J,.84,9259,2,3,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9259,2,4,0)
 ;;=After creating and arranging all the elements on a block, you can quickly
 ;;^UTILITY(U,$J,.84,9259,2,5,0)
 ;;=make the field orders of all the elements equivalent to the tab order
 ;;^UTILITY(U,$J,.84,9259,2,6,0)
 ;;=by doing the following:
 ;;^UTILITY(U,$J,.84,9259,2,7,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9259,2,8,0)
 ;;=     1.  Go to the Block Viewer page (<PF1>V)
 ;;^UTILITY(U,$J,.84,9259,2,9,0)
 ;;=     2.  Select the block (<SpaceBar> over the block name)
 ;;^UTILITY(U,$J,.84,9259,2,10,0)
 ;;=     3.  Press <PF1>O
 ;;^UTILITY(U,$J,.84,9259,2,11,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9259,2,12,0)
 ;;=The field order is the order in which the elements on the block are
 ;;^UTILITY(U,$J,.84,9259,2,13,0)
 ;;=traversed when the user presses the <Enter> key.  The <PF1>O key
 ;;^UTILITY(U,$J,.84,9259,2,14,0)
 ;;=sequence reassigns field order numbers to all the elements on the
 ;;^UTILITY(U,$J,.84,9259,2,15,0)
 ;;=block, so that the <Enter> key takes the user from element to element
 ;;^UTILITY(U,$J,.84,9259,2,16,0)
 ;;=in the same order as the <Tab> key (left to right, top to bottom).
 ;;^UTILITY(U,$J,.84,9501,0)
 ;;=9501^1^^11
 ;;^UTILITY(U,$J,.84,9501,1,0)
 ;;=^^1^1^2940909^^^^
 ;;^UTILITY(U,$J,.84,9501,1,1,0)
 ;;=DIFROM Server, FIA array does not exist or invalid.
 ;;^UTILITY(U,$J,.84,9501,2,0)
 ;;=^^1^1^2940909^^^^
 ;;^UTILITY(U,$J,.84,9501,2,1,0)
 ;;=FIA array does not exist or invalid.
 ;;^UTILITY(U,$J,.84,9502,0)
 ;;=9502^1^^11
 ;;^UTILITY(U,$J,.84,9502,1,0)
 ;;=^^1^1^2940908^
 ;;^UTILITY(U,$J,.84,9502,1,1,0)
 ;;=FIA file number invalid.
 ;;^UTILITY(U,$J,.84,9502,2,0)
 ;;=^^1^1^2940908^
 ;;^UTILITY(U,$J,.84,9502,2,1,0)
 ;;=FIA file number invalid.
 ;;^UTILITY(U,$J,.84,9503,0)
 ;;=9503^1^^11
 ;;^UTILITY(U,$J,.84,9503,1,0)
 ;;=^^1^1^2940908^^^^
 ;;^UTILITY(U,$J,.84,9503,1,1,0)
 ;;=DIFROM Server; FIA node is set to "NO DD UPDATE"
 ;;^UTILITY(U,$J,.84,9503,2,0)
 ;;=^^1^1^2940908^^^^
 ;;^UTILITY(U,$J,.84,9503,2,1,0)
 ;;=Data Dictionary not installed; FIA node is set to "No DD Update"
