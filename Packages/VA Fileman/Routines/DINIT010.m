DINIT010 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9251,2,17,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9251,2,18,0)
 ;;=Press    To
 ;;^UTILITY(U,$J,.84,9251,2,19,0)
 ;;=----------------------------------------------------
 ;;^UTILITY(U,$J,.84,9251,2,20,0)
 ;;=<PF1>S   Save changes
 ;;^UTILITY(U,$J,.84,9251,2,21,0)
 ;;=<PF1>E   Save changes and exit the Form Editor
 ;;^UTILITY(U,$J,.84,9251,2,22,0)
 ;;=<PF1>Q   Quit the Form Editor without saving changes
 ;;^UTILITY(U,$J,.84,9252,0)
 ;;=9252^3^^11
 ;;^UTILITY(U,$J,.84,9252,1,0)
 ;;=^^1^1^2941116^^^
 ;;^UTILITY(U,$J,.84,9252,1,1,0)
 ;;=Help Screen 2 of Form Editor.
 ;;^UTILITY(U,$J,.84,9252,2,0)
 ;;=^^19^19^2941116^
 ;;^UTILITY(U,$J,.84,9252,2,1,0)
 ;;=                                                          \BHelp Screen 2 of 9\n
 ;;^UTILITY(U,$J,.84,9252,2,2,0)
 ;;=\BSELECTING SCREEN ELEMENTS\n
 ;;^UTILITY(U,$J,.84,9252,2,3,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9252,2,4,0)
 ;;=To "select" a screen element, position the cursor over the element and
 ;;^UTILITY(U,$J,.84,9252,2,5,0)
 ;;=press <SpaceBar> or <Enter>.  This process is abbreviated <SelectElement>.
 ;;^UTILITY(U,$J,.84,9252,2,6,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9252,2,7,0)
 ;;=Press            To
 ;;^UTILITY(U,$J,.84,9252,2,8,0)
 ;;=----------------------------------------
 ;;^UTILITY(U,$J,.84,9252,2,9,0)
 ;;=<SelectElement>  Select a screen element
 ;;^UTILITY(U,$J,.84,9252,2,10,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9252,2,11,0)
 ;;=Once an element is selected, you can drag it around the screen by using
 ;;^UTILITY(U,$J,.84,9252,2,12,0)
 ;;=the navigational keys.  You cannot drag an element beyond the boundaries
 ;;^UTILITY(U,$J,.84,9252,2,13,0)
 ;;=of the block on which it is defined.
 ;;^UTILITY(U,$J,.84,9252,2,14,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9252,2,15,0)
 ;;=If you press <SpaceBar> or <Enter> over the caption of an element, both
 ;;^UTILITY(U,$J,.84,9252,2,16,0)
 ;;=the caption and data portion of the element, if one exists, are selected.
 ;;^UTILITY(U,$J,.84,9252,2,17,0)
 ;;=If you press <SpaceBar> or <Enter> over the data portion of an element,
 ;;^UTILITY(U,$J,.84,9252,2,18,0)
 ;;=only the data portion is selected and can be dragged independently of the
 ;;^UTILITY(U,$J,.84,9252,2,19,0)
 ;;=caption.  Press <SpaceBar> or <Enter> again to deselect the element.
 ;;^UTILITY(U,$J,.84,9253,0)
 ;;=9253^3^^11
 ;;^UTILITY(U,$J,.84,9253,1,0)
 ;;=^^1^1^2940707^
 ;;^UTILITY(U,$J,.84,9253,1,1,0)
 ;;=Help Screen 3 of Form Editor.
 ;;^UTILITY(U,$J,.84,9253,2,0)
 ;;=^^15^15^2940707^
 ;;^UTILITY(U,$J,.84,9253,2,1,0)
 ;;=                                                          \BHelp Screen 3 of 9\n
 ;;^UTILITY(U,$J,.84,9253,2,2,0)
 ;;=\BEDITING ELEMENT PROPERTIES\n
 ;;^UTILITY(U,$J,.84,9253,2,3,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9253,2,4,0)
 ;;=Press                 To
 ;;^UTILITY(U,$J,.84,9253,2,5,0)
 ;;=---------------------------------------------
 ;;^UTILITY(U,$J,.84,9253,2,6,0)
 ;;=<SelectElement><PF4>  Edit element properties
 ;;^UTILITY(U,$J,.84,9253,2,7,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9253,2,8,0)
 ;;=You will then be taken into a ScreenMan form where the properties of the
 ;;^UTILITY(U,$J,.84,9253,2,9,0)
 ;;=element can be edited.
 ;;^UTILITY(U,$J,.84,9253,2,10,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9253,2,11,0)
 ;;=The Form Editor uses ScreenMan forms as a kind of modal dialog box.  The
 ;;^UTILITY(U,$J,.84,9253,2,12,0)
 ;;=changes you make within the forms are permanent; that is, if from a
 ;;^UTILITY(U,$J,.84,9253,2,13,0)
 ;;=ScreenMan form you edit the properties of an element, use <PF1>E to save
 ;;^UTILITY(U,$J,.84,9253,2,14,0)
 ;;=and exit the form, and then use <PF1>Q to quit the Form Editor, the
 ;;^UTILITY(U,$J,.84,9253,2,15,0)
 ;;=changes you made to the properties of the element will remain.
 ;;^UTILITY(U,$J,.84,9254,0)
 ;;=9254^3^^11
 ;;^UTILITY(U,$J,.84,9254,1,0)
 ;;=^^1^1^2940707^
 ;;^UTILITY(U,$J,.84,9254,1,1,0)
 ;;=Help Screen 4 of Form Editor.
 ;;^UTILITY(U,$J,.84,9254,2,0)
 ;;=^^18^18^2940707^
 ;;^UTILITY(U,$J,.84,9254,2,1,0)
 ;;=                                                          \BHelp Screen 4 of 9\n
 ;;^UTILITY(U,$J,.84,9254,2,2,0)
 ;;=\BEDITING A CAPTION OR DATA LENGTH\n
 ;;^UTILITY(U,$J,.84,9254,2,3,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9254,2,4,0)
 ;;=To edit the caption or data length of an element from the Form Editor's
 ;;^UTILITY(U,$J,.84,9254,2,5,0)
 ;;=Main screen, you can position the cursor over the caption or data portion
