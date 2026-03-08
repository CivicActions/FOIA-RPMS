DINIT00U ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9201,2,15,0)
 ;;=     Jump to the Top                         <PF1>T
 ;;^UTILITY(U,$J,.84,9201,2,16,0)
 ;;=     Jump to the Bottom                      <PF1>B
 ;;^UTILITY(U,$J,.84,9201,2,17,0)
 ;;=     Goto                                    <PF1>G
 ;;^UTILITY(U,$J,.84,9201,2,18,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,19,0)
 ;;=SEARCH:
 ;;^UTILITY(U,$J,.84,9201,2,20,0)
 ;;========
 ;;^UTILITY(U,$J,.84,9201,2,21,0)
 ;;=     Find text                               <PF1>F
 ;;^UTILITY(U,$J,.84,9201,2,22,0)
 ;;=     Next (occurrence)                       <PF1>N
 ;;^UTILITY(U,$J,.84,9201,2,23,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,24,0)
 ;;=     Direction-terminate find text with:
 ;;^UTILITY(U,$J,.84,9201,2,25,0)
 ;;=     -----------------------------------
 ;;^UTILITY(U,$J,.84,9201,2,26,0)
 ;;=     Down                                    ARROW DOWN
 ;;^UTILITY(U,$J,.84,9201,2,27,0)
 ;;=     Up                                      ARROW UP
 ;;^UTILITY(U,$J,.84,9201,2,28,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,29,0)
 ;;=BRANCH:
 ;;^UTILITY(U,$J,.84,9201,2,30,0)
 ;;========
 ;;^UTILITY(U,$J,.84,9201,2,31,0)
 ;;=     Switch to another document              <PF1>S
 ;;^UTILITY(U,$J,.84,9201,2,32,0)
 ;;=     Return to previous document(s)          R
 ;;^UTILITY(U,$J,.84,9201,2,33,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9201,2,34,0)
 ;;=SCREEN:
 ;;^UTILITY(U,$J,.84,9201,2,35,0)
 ;;========
 ;;^UTILITY(U,$J,.84,9201,2,36,0)
 ;;=     Repaint screen                          <PF1>P
 ;;^UTILITY(U,$J,.84,9201,2,37,0)
 ;;=     Split screen                            <PF2>S
 ;;^UTILITY(U,$J,.84,9201,2,38,0)
 ;;=     restore Full screen                     <PF2>F
 ;;^UTILITY(U,$J,.84,9201,2,39,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9201,2,40,0)
 ;;=     Split Screen Mode Navigation:
 ;;^UTILITY(U,$J,.84,9201,2,41,0)
 ;;=     -----------------------------
 ;;^UTILITY(U,$J,.84,9201,2,42,0)
 ;;=     Navigate to bottom screen              <PF2>ARROW DOWN
 ;;^UTILITY(U,$J,.84,9201,2,43,0)
 ;;=     Navigate to top screen                 <PF2>ARROW UP
 ;;^UTILITY(U,$J,.84,9201,2,44,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9201,2,45,0)
 ;;=     Resize Split Screen:
 ;;^UTILITY(U,$J,.84,9201,2,46,0)
 ;;=     --------------------
 ;;^UTILITY(U,$J,.84,9201,2,47,0)
 ;;=     Top/Bottom screen larger/smaller       <PF2><PF2>ARROW DOWN
 ;;^UTILITY(U,$J,.84,9201,2,48,0)
 ;;=     Bottom/Top screen larger/smaller       <PF2><PF2>ARROW UP
 ;;^UTILITY(U,$J,.84,9201,2,49,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,50,0)
 ;;=HELP:
 ;;^UTILITY(U,$J,.84,9201,2,51,0)
 ;;======
 ;;^UTILITY(U,$J,.84,9201,2,52,0)
 ;;=     Browse Key Summary                     <PF1>H
 ;;^UTILITY(U,$J,.84,9201,2,53,0)
 ;;=     More Help                              <PF1><PF1>H
 ;;^UTILITY(U,$J,.84,9201,2,54,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9201,2,55,0)
 ;;=EXIT:
 ;;^UTILITY(U,$J,.84,9201,2,56,0)
 ;;======
 ;;^UTILITY(U,$J,.84,9201,2,57,0)
 ;;=     Exit Browser or help text              <PF1>E or "EXIT"
 ;;^UTILITY(U,$J,.84,9201,2,58,0)
 ;;=     Quit                                   <PF1>Q
 ;;^UTILITY(U,$J,.84,9201,2,59,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,60,0)
 ;;=                                    More Help
 ;;^UTILITY(U,$J,.84,9201,2,61,0)
 ;;=                                    =========
 ;;^UTILITY(U,$J,.84,9201,2,62,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9201,2,63,0)
 ;;=     To EXIT the VA FileMan Browser, press <PF1> followed by the letter
 ;;^UTILITY(U,$J,.84,9201,2,64,0)
 ;;=     'E'.  This is also true for this HELP document which is being
 ;;^UTILITY(U,$J,.84,9201,2,65,0)
 ;;=     presented by the Browser.
 ;;^UTILITY(U,$J,.84,9201,2,66,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,67,0)
 ;;=     To SCROLL DOWN one line at a time, press the ARROW DOWN key.
 ;;^UTILITY(U,$J,.84,9201,2,68,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,69,0)
 ;;=     To SCROLL UP one line at a time, press the ARROW UP key.
 ;;^UTILITY(U,$J,.84,9201,2,70,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,71,0)
 ;;=     To SCROLL RIGHT, press the ARROW RIGHT key.
 ;;^UTILITY(U,$J,.84,9201,2,72,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,73,0)
 ;;=     To SCROLL LEFT, press the ARROW LEFT key.
 ;;^UTILITY(U,$J,.84,9201,2,74,0)
 ;;=     
 ;;^UTILITY(U,$J,.84,9201,2,75,0)
 ;;=     Try pressing these keys at this time and observe the behavior. Get a
 ;;^UTILITY(U,$J,.84,9201,2,76,0)
 ;;=     feel for 'browsing' through a document.  Press the arrow down key a
