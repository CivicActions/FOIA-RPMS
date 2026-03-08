DINIT00X ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9201,2,171,0)
 ;;=     and screen information.  The "Col>" indicates the column number the
 ;;^UTILITY(U,$J,.84,9201,2,172,0)
 ;;=     left edge of the browse window is over in the document.  The "Line>"
 ;;^UTILITY(U,$J,.84,9201,2,173,0)
 ;;=     shows the current line at the bottom of the scroll region and the
 ;;^UTILITY(U,$J,.84,9201,2,174,0)
 ;;=     total number of lines in the document.  The "Screen>" shows the
 ;;^UTILITY(U,$J,.84,9201,2,175,0)
 ;;=     current screen and the total number of screens in the document.
 ;;^UTILITY(U,$J,.84,9201,2,176,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,177,0)
 ;;=     The SCROLLING REGION, between the TITLE BAR and the STATUS BAR, is
 ;;^UTILITY(U,$J,.84,9201,2,178,0)
 ;;=     where the Browser displays the text being viewed.
 ;;^UTILITY(U,$J,.84,9201,2,179,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,180,0)
 ;;=     <<<Press 'R' or <PF1>'E' to exit this help document>>>
 ;;^UTILITY(U,$J,.84,9201,5,0)
 ;;=^.841^^0
 ;;^UTILITY(U,$J,.84,9211,0)
 ;;=9211^3^^11
 ;;^UTILITY(U,$J,.84,9211,1,0)
 ;;=^^1^1^2940624^^^^
 ;;^UTILITY(U,$J,.84,9211,1,1,0)
 ;;=Screen 1 of Screen Editor help.
 ;;^UTILITY(U,$J,.84,9211,2,0)
 ;;=^^17^17^2940830^
 ;;^UTILITY(U,$J,.84,9211,2,1,0)
 ;;=                                                           \BHelp Screen 1 of 4\n
 ;;^UTILITY(U,$J,.84,9211,2,2,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9211,2,3,0)
 ;;=\BSUMMARY OF KEY SEQUENCES\n
 ;;^UTILITY(U,$J,.84,9211,2,4,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9211,2,5,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9211,2,6,0)
 ;;=\BNavigation\n
 ;;^UTILITY(U,$J,.84,9211,2,7,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9211,2,8,0)
 ;;=   Incremental movement            Arrow keys
 ;;^UTILITY(U,$J,.84,9211,2,9,0)
 ;;=   One word left and right         <Ctrl-J> and <Ctrl-L>
 ;;^UTILITY(U,$J,.84,9211,2,10,0)
 ;;=   Next tab stop to the right      <Tab>
 ;;^UTILITY(U,$J,.84,9211,2,11,0)
 ;;=   Jump left and right             <PF1><Left> and <PF1><Right>
 ;;^UTILITY(U,$J,.84,9211,2,12,0)
 ;;=   Beginning and end of line       <PF1><PF1><Left> and <PF1><PF1><Right>
 ;;^UTILITY(U,$J,.84,9211,2,13,0)
 ;;=   Screen up or down               <PF1><Up> and <PF1><Down>
 ;;^UTILITY(U,$J,.84,9211,2,14,0)
 ;;=                                      or:  <PrevScr> and <NextScr>
 ;;^UTILITY(U,$J,.84,9211,2,15,0)
 ;;=                                      or:  <PageUp>  and <PageDown>
 ;;^UTILITY(U,$J,.84,9211,2,16,0)
 ;;=   Top or bottom of document       <PF1>T and <PF1>B
 ;;^UTILITY(U,$J,.84,9211,2,17,0)
 ;;=   Go to a specific location       <PF1>G
 ;;^UTILITY(U,$J,.84,9212,0)
 ;;=9212^3^^11
 ;;^UTILITY(U,$J,.84,9212,1,0)
 ;;=^^1^1^2940624^^^^
 ;;^UTILITY(U,$J,.84,9212,1,1,0)
 ;;=Screen 2 of Screen Editor help.
 ;;^UTILITY(U,$J,.84,9212,2,0)
 ;;=^^17^17^2940830^
 ;;^UTILITY(U,$J,.84,9212,2,1,0)
 ;;=                                                           \BHelp Screen 2 of 4\n
 ;;^UTILITY(U,$J,.84,9212,2,2,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9212,2,3,0)
 ;;=\BExiting/Saving\n
 ;;^UTILITY(U,$J,.84,9212,2,4,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9212,2,5,0)
 ;;=   Exit and save text              <PF1>E
 ;;^UTILITY(U,$J,.84,9212,2,6,0)
 ;;=   Quit without saving             <PF1>Q
 ;;^UTILITY(U,$J,.84,9212,2,7,0)
 ;;=   Exit, save, and switch editors  <PF1>A
 ;;^UTILITY(U,$J,.84,9212,2,8,0)
 ;;=   Save without exiting            <PF1>S
 ;;^UTILITY(U,$J,.84,9212,2,9,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9212,2,10,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9212,2,11,0)
 ;;=\BDeleting\n
 ;;^UTILITY(U,$J,.84,9212,2,12,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9212,2,13,0)
 ;;=   Character before cursor         <Backspace>
 ;;^UTILITY(U,$J,.84,9212,2,14,0)
 ;;=   Character at cursor             <PF4>  or  <Remove>  or  <Delete>
 ;;^UTILITY(U,$J,.84,9212,2,15,0)
 ;;=   From cursor to end of word      <Ctrl-W>
 ;;^UTILITY(U,$J,.84,9212,2,16,0)
 ;;=   From cursor to end of line      <PF1><PF2>
 ;;^UTILITY(U,$J,.84,9212,2,17,0)
 ;;=   Entire line                     <PF1>D
 ;;^UTILITY(U,$J,.84,9213,0)
 ;;=9213^3^^11
 ;;^UTILITY(U,$J,.84,9213,1,0)
 ;;=^^1^1^2940624^^^^
 ;;^UTILITY(U,$J,.84,9213,1,1,0)
 ;;=Screen 3 of Screen Editor help.
 ;;^UTILITY(U,$J,.84,9213,2,0)
 ;;=^^15^15^2940830^
 ;;^UTILITY(U,$J,.84,9213,2,1,0)
 ;;=                                                           \BHelp Screen 3 of 4\n
 ;;^UTILITY(U,$J,.84,9213,2,2,0)
 ;;=\BSettings/Modes\n
 ;;^UTILITY(U,$J,.84,9213,2,3,0)
 ;;= 
