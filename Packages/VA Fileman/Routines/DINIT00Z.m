DINIT00Z ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9232,2,3,0)
 ;;=\BDeletions\n
 ;;^UTILITY(U,$J,.84,9232,2,4,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9232,2,5,0)
 ;;=Character under cursor           <PF2> or <Delete>
 ;;^UTILITY(U,$J,.84,9232,2,6,0)
 ;;=Character left of cursor         <Backspace>
 ;;^UTILITY(U,$J,.84,9232,2,7,0)
 ;;=From cursor to end of word       <Ctrl-W>
 ;;^UTILITY(U,$J,.84,9232,2,8,0)
 ;;=From cursor to end of field      <PF1><PF2>
 ;;^UTILITY(U,$J,.84,9232,2,9,0)
 ;;=Toggle null/last edit/default    <PF1>D or <Ctrl-U>
 ;;^UTILITY(U,$J,.84,9232,2,10,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9232,2,11,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9232,2,12,0)
 ;;=\BMacro Movement\n
 ;;^UTILITY(U,$J,.84,9232,2,13,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9232,2,14,0)
 ;;=Field below         <Down>    |   Next page           <PF1><Down> or <PageDown>
 ;;^UTILITY(U,$J,.84,9232,2,15,0)
 ;;=Field above         <Up>      |   Previous page       <PF1><Up> or <PageUp>
 ;;^UTILITY(U,$J,.84,9232,2,16,0)
 ;;=Field to right      <Tab>     |   Next block          <PF1><PF4>
 ;;^UTILITY(U,$J,.84,9232,2,17,0)
 ;;=Field to left       <PF4>     |   Jump to a field     ^caption
 ;;^UTILITY(U,$J,.84,9232,2,18,0)
 ;;=Pre-defined order   <Return>  |   Go to Command Line  ^
 ;;^UTILITY(U,$J,.84,9232,2,19,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9232,2,20,0)
 ;;=Go into multiple or word processing field             <Return>
 ;;^UTILITY(U,$J,.84,9233,0)
 ;;=9233^3^^11
 ;;^UTILITY(U,$J,.84,9233,1,0)
 ;;=^^1^1^2941116^^
 ;;^UTILITY(U,$J,.84,9233,1,1,0)
 ;;=Screen 3 of ScreenMan help.
 ;;^UTILITY(U,$J,.84,9233,2,0)
 ;;=^^18^18^2941116^
 ;;^UTILITY(U,$J,.84,9233,2,1,0)
 ;;=                                                                \BScreen 3 of 3\n
 ;;^UTILITY(U,$J,.84,9233,2,2,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9233,2,3,0)
 ;;=\BCommand Line Options\n (Enter '^' at any field to jump to the command line.)
 ;;^UTILITY(U,$J,.84,9233,2,4,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9233,2,5,0)
 ;;=Command      Shortcut      Description
 ;;^UTILITY(U,$J,.84,9233,2,6,0)
 ;;=-------      --------      -----------
 ;;^UTILITY(U,$J,.84,9233,2,7,0)
 ;;=EXIT         see below     Exit form (asks whether changes should be saved)
 ;;^UTILITY(U,$J,.84,9233,2,8,0)
 ;;=CLOSE        <PF1>C        Close window and return to previous level
 ;;^UTILITY(U,$J,.84,9233,2,9,0)
 ;;=SAVE         <PF1>S        Save changes
 ;;^UTILITY(U,$J,.84,9233,2,10,0)
 ;;=NEXT PAGE    <PF1><Down>   Go to next page
 ;;^UTILITY(U,$J,.84,9233,2,11,0)
 ;;=REFRESH      <PF1>R        Repaint screen
 ;;^UTILITY(U,$J,.84,9233,2,12,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9233,2,13,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9233,2,14,0)
 ;;=\BOther Shortcut Keys\n
 ;;^UTILITY(U,$J,.84,9233,2,15,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9233,2,16,0)
 ;;=Exit form and save changes             <PF1>E
 ;;^UTILITY(U,$J,.84,9233,2,17,0)
 ;;=Quit form without saving changes       <PF1>Q
 ;;^UTILITY(U,$J,.84,9233,2,18,0)
 ;;=Invoke Record Selection Page           <PF1>L
 ;;^UTILITY(U,$J,.84,9251,0)
 ;;=9251^3^^11
 ;;^UTILITY(U,$J,.84,9251,1,0)
 ;;=^^1^1^2940707^^
 ;;^UTILITY(U,$J,.84,9251,1,1,0)
 ;;=Help Screen 1 of Form Editor help.
 ;;^UTILITY(U,$J,.84,9251,2,0)
 ;;=^^22^22^2940707^
 ;;^UTILITY(U,$J,.84,9251,2,1,0)
 ;;=                                                          \BHelp Screen 1 of 9\n
 ;;^UTILITY(U,$J,.84,9251,2,2,0)
 ;;=\BNAVIGATIONAL KEYS\n
 ;;^UTILITY(U,$J,.84,9251,2,3,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9251,2,4,0)
 ;;=Press    To move              |  Press         To move
 ;;^UTILITY(U,$J,.84,9251,2,5,0)
 ;;=-------------------------------------------------------------------
 ;;^UTILITY(U,$J,.84,9251,2,6,0)
 ;;=<Up>     Up one line          |  <PF1><Up>     To top of screen
 ;;^UTILITY(U,$J,.84,9251,2,7,0)
 ;;=<Down>   Down one line        |  <PF1><Down>   To bottom of screen
 ;;^UTILITY(U,$J,.84,9251,2,8,0)
 ;;=<Right>  Right one character  |  <PF1><Right>  To right edge of screen
 ;;^UTILITY(U,$J,.84,9251,2,9,0)
 ;;=<Left>   Left one character   |  <PF1><Left>   To left edge of screen
 ;;^UTILITY(U,$J,.84,9251,2,10,0)
 ;;=<Tab>    To next element
 ;;^UTILITY(U,$J,.84,9251,2,11,0)
 ;;=Q        To previous element
 ;;^UTILITY(U,$J,.84,9251,2,12,0)
 ;;=S        Right 5 characters
 ;;^UTILITY(U,$J,.84,9251,2,13,0)
 ;;=A        Left 5 characters
 ;;^UTILITY(U,$J,.84,9251,2,14,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9251,2,15,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9251,2,16,0)
 ;;=\BSAVING AND EXITING\n
