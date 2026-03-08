DINIT00V ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9201,2,77,0)
 ;;=     few times, then press the arrow up key.  Also notice that the 'Line>'
 ;;^UTILITY(U,$J,.84,9201,2,78,0)
 ;;=     and 'Screen>' indicator numbers are changing. To see more of this
 ;;^UTILITY(U,$J,.84,9201,2,79,0)
 ;;=     text keep pressing the ARROW DOWN key.  Now try the arrow right key,
 ;;^UTILITY(U,$J,.84,9201,2,80,0)
 ;;=     then the arrow left key.  Notice that the 'Col>' indicator number is
 ;;^UTILITY(U,$J,.84,9201,2,81,0)
 ;;=     also changing.  This shows what column the left most edge of the
 ;;^UTILITY(U,$J,.84,9201,2,82,0)
 ;;=     document is on.  As you can see, the VA FileMan Browser is like a
 ;;^UTILITY(U,$J,.84,9201,2,83,0)
 ;;=     window placed over a document. You are in control of this window
 ;;^UTILITY(U,$J,.84,9201,2,84,0)
 ;;=     which moves over the document by pressing the functional key
 ;;^UTILITY(U,$J,.84,9201,2,85,0)
 ;;=     sequences.  Here are a few more functions.
 ;;^UTILITY(U,$J,.84,9201,2,86,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9201,2,87,0)
 ;;=     To PAGE DOWN one screen at one time, press the NEXT SCREEN key, PAGE
 ;;^UTILITY(U,$J,.84,9201,2,88,0)
 ;;=     DOWN or PF1 followed by the ARROW DOWN key, depending on what kind of
 ;;^UTILITY(U,$J,.84,9201,2,89,0)
 ;;=     CRT or workstation that is being used.
 ;;^UTILITY(U,$J,.84,9201,2,90,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,91,0)
 ;;=     To PAGE UP one screen at one time, press the PREV SCREEN key, PAGE UP
 ;;^UTILITY(U,$J,.84,9201,2,92,0)
 ;;=     or PF1 followed by the ARROW UP key, depending on what kind of CRT or
 ;;^UTILITY(U,$J,.84,9201,2,93,0)
 ;;=     workstation that is being used.
 ;;^UTILITY(U,$J,.84,9201,2,94,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,95,0)
 ;;=     To return to the TOP, back to the beginning of the document, press
 ;;^UTILITY(U,$J,.84,9201,2,96,0)
 ;;=     the <PF1> key followed by the letter 'T'.
 ;;^UTILITY(U,$J,.84,9201,2,97,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,98,0)
 ;;=     To go to the BOTTOM, end of the document, press the <PF1> key
 ;;^UTILITY(U,$J,.84,9201,2,99,0)
 ;;=     followed by the letter 'B'.
 ;;^UTILITY(U,$J,.84,9201,2,100,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,101,0)
 ;;=     To GOTO a specific screen, line or column press the <PF1> key
 ;;^UTILITY(U,$J,.84,9201,2,102,0)
 ;;=     followed by the letter 'G'.  This will cause a prompt to be displayed
 ;;^UTILITY(U,$J,.84,9201,2,103,0)
 ;;=     where a screen, line or column number can be entered preceded by a
 ;;^UTILITY(U,$J,.84,9201,2,104,0)
 ;;=     'S' , 'L' or 'C'.  The default is screen, meaning that the 'S' is
 ;;^UTILITY(U,$J,.84,9201,2,105,0)
 ;;=     optional when entering a screen number.  10 or S10 will go to screen
 ;;^UTILITY(U,$J,.84,9201,2,106,0)
 ;;=     10, if screen 10 is a valid screen.  L99 will go to line 99 and C33
 ;;^UTILITY(U,$J,.84,9201,2,107,0)
 ;;=     will go to column 33.
 ;;^UTILITY(U,$J,.84,9201,2,108,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,109,0)
 ;;=     To FIND a string of characters, on a line, press the <PF1> key
 ;;^UTILITY(U,$J,.84,9201,2,110,0)
 ;;=     followed by the letter 'F' or 'FIND' key.  A prompt will appear where
 ;;^UTILITY(U,$J,.84,9201,2,111,0)
 ;;=     a search string of characters can be entered.  The Find facility will
 ;;^UTILITY(U,$J,.84,9201,2,112,0)
 ;;=     search the document and immediately stop when it finds a match and
 ;;^UTILITY(U,$J,.84,9201,2,113,0)
 ;;=     'Goto' the line/screen.  The matched text will be highlighted in
 ;;^UTILITY(U,$J,.84,9201,2,114,0)
 ;;=     reverse video, if available, so it can be found easily.  However, if
 ;;^UTILITY(U,$J,.84,9201,2,115,0)
 ;;=     a string contains two or more words, matching will only be done if
 ;;^UTILITY(U,$J,.84,9201,2,116,0)
 ;;=     the words are found on the same line.  The default direction of the
 ;;^UTILITY(U,$J,.84,9201,2,117,0)
 ;;=     search is down.  This can be controlled by using the ARROW UP or
 ;;^UTILITY(U,$J,.84,9201,2,118,0)
 ;;=     ARROW DOWN keys instead of the RETURN key to terminate the search
 ;;^UTILITY(U,$J,.84,9201,2,119,0)
 ;;=     string.
 ;;^UTILITY(U,$J,.84,9201,2,120,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,121,0)
 ;;=     To, NEXT FIND, find the next occurrence of the same search string,
 ;;^UTILITY(U,$J,.84,9201,2,122,0)
 ;;=     press the letter 'N' or <PF1> followed by the letter 'N'. The FIND
