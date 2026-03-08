DINIT00W ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9201,2,123,0)
 ;;=     facility keeps track of the last find string including the direction
 ;;^UTILITY(U,$J,.84,9201,2,124,0)
 ;;=     and continues searching through the document and brings up the next
 ;;^UTILITY(U,$J,.84,9201,2,125,0)
 ;;=     screen.  If no match is found a message appears indicating this and
 ;;^UTILITY(U,$J,.84,9201,2,126,0)
 ;;=     the screen is repainted at it's original location.
 ;;^UTILITY(U,$J,.84,9201,2,127,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,128,0)
 ;;=     To rePAINT the screen, press the <PF1> key followed by the letter
 ;;^UTILITY(U,$J,.84,9201,2,129,0)
 ;;=     'P'.
 ;;^UTILITY(U,$J,.84,9201,2,130,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,131,0)
 ;;=     To SWITCH to another document press the <PF1> key followed by the
 ;;^UTILITY(U,$J,.84,9201,2,132,0)
 ;;=     letter 'S'.  This will allow the selection of another file, (wp)field
 ;;^UTILITY(U,$J,.84,9201,2,133,0)
 ;;=     and entry.  The document is put on an active list and Browse
 ;;^UTILITY(U,$J,.84,9201,2,134,0)
 ;;=     switches to the newly selected document.  Subsequent use of Switch
 ;;^UTILITY(U,$J,.84,9201,2,135,0)
 ;;=     will allow choosing from the active list if desired or branch to
 ;;^UTILITY(U,$J,.84,9201,2,136,0)
 ;;=     select file, (wp)field and entry prompts. This function CAN BE
 ;;^UTILITY(U,$J,.84,9201,2,137,0)
 ;;=     RESTRICTED depending on how the running application calls the Browser
 ;;^UTILITY(U,$J,.84,9201,2,138,0)
 ;;=     utility.
 ;;^UTILITY(U,$J,.84,9201,2,139,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,140,0)
 ;;=     To RETURN to the previous document after using Switch or Help, press
 ;;^UTILITY(U,$J,.84,9201,2,141,0)
 ;;=     'R'.  A separate list keeps track of the documents chosen during the
 ;;^UTILITY(U,$J,.84,9201,2,142,0)
 ;;=     current Browse session.  R will return all the way back to the very
 ;;^UTILITY(U,$J,.84,9201,2,143,0)
 ;;=     first document when used repeatedly.
 ;;^UTILITY(U,$J,.84,9201,2,144,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,145,0)
 ;;=     To SPLIT SCREEN, while in Full (Browse Region) Screen mode, press
 ;;^UTILITY(U,$J,.84,9201,2,146,0)
 ;;=     <PF2> followed by the letter 'S'.  This causes the screen to split
 ;;^UTILITY(U,$J,.84,9201,2,147,0)
 ;;=     into two separate scroll regions.
 ;;^UTILITY(U,$J,.84,9201,2,148,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,149,0)
 ;;=     To navigate to the bottom screen, while in Split Screen mode, press
 ;;^UTILITY(U,$J,.84,9201,2,150,0)
 ;;=     <PF2> followed by pressing the ARROW DOWN key.
 ;;^UTILITY(U,$J,.84,9201,2,151,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,152,0)
 ;;=     To navigate to the top screen, while in Split Screen mode, press
 ;;^UTILITY(U,$J,.84,9201,2,153,0)
 ;;=     <PF2> followed by pressing the ARROW UP key.
 ;;^UTILITY(U,$J,.84,9201,2,154,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,155,0)
 ;;=     To return to FULL SCREEN mode, while in Split Screen mode, press
 ;;^UTILITY(U,$J,.84,9201,2,156,0)
 ;;=     <PF2> followed by the letter 'F'.  This causes the entire browse
 ;;^UTILITY(U,$J,.84,9201,2,157,0)
 ;;=     region to return to one Full (Browse) Screen scroll region.
 ;;^UTILITY(U,$J,.84,9201,2,158,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,159,0)
 ;;=     To RESIZE screens, while in Split Screen mode, press <PF2><PF2>
 ;;^UTILITY(U,$J,.84,9201,2,160,0)
 ;;=     followed by the ARROW UP key.  This makes the top window smaller and
 ;;^UTILITY(U,$J,.84,9201,2,161,0)
 ;;=     the bottom window larger.  <PF2><PF2> followed by the ARROW DOWN key
 ;;^UTILITY(U,$J,.84,9201,2,162,0)
 ;;=     makes the top window larger and the bottom window smaller.
 ;;^UTILITY(U,$J,.84,9201,2,163,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,164,0)
 ;;=     The TITLE BAR, at the top, is a non scrolling region which contains
 ;;^UTILITY(U,$J,.84,9201,2,165,0)
 ;;=     static information, while browsing in the selected document.  The
 ;;^UTILITY(U,$J,.84,9201,2,166,0)
 ;;=     title bar information only changes when switching documents or
 ;;^UTILITY(U,$J,.84,9201,2,167,0)
 ;;=     requesting help.
 ;;^UTILITY(U,$J,.84,9201,2,168,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,169,0)
 ;;=     The STATUS BAR, at the bottom, is also a non scroll region.  It shows
 ;;^UTILITY(U,$J,.84,9201,2,170,0)
 ;;=     the column indicator, how to get help, how to exit, line information
