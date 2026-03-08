XMYPDOM1 ;(WASH ISC)/CAP - INITIALIZE IDCU TRANS. SCRIPTS ;5/21/90  13:35
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
IDCU W !!,*7,"You MUST have these codes for the MINIENGINE and AUSTIN entries in the",!,"TRANSMISSION SCRIPT file (4.6) to work.  Enter them later (but before you",!,"try to turn on your network mail) -- it won't work without them."
 W !!,"The place to enter them is clearly marked with dummy codes in the TEXT field",!,"of both the MINIENGINE and AUSTIN entries in the TRANSMISSION SCRIPT file",!,"if you didn't enter anything.  If you entered the wrong code, the wrong code"
 W !,"will be entered there instead."
 W !!,"Line 3 of the TEXT field will begin with ""S "".  Following this will",!,"be either ""UserID"" or what you typed in incorrectly."
 W !!,"Line 5 of the TEXT field will begin with ""S "".  Following this will",!,"be either ""Password"" or what you typed in incorrectly."
 W !!,*7,"If you decide to continue, use FileMan to EDIT the MINIENGINE and AUSTIN",!,"entries in the TRANSMISSION SCRIPT file when this process completes.",!,"Enter the correct values for the 'UserID' and 'Password'."
 W !!,"To ABORT and RETRY LATER enter ""^"": "
 S X="" R X:299 E  S X="^" Q
 ;
WARN ;DISPLAY before asking if scripts should be inited for the IDCU
 W *7 H 1 W !!,"====== PLEASE READ THIS  B E F O R E   A N S W E R I N G  NEXT QUESTION =====",*7,!!,"Answer 'YES' if:"
 W !,"If you have converted to the IDCU you may want to perform this."
 W !,"This script uses the new LOOK script command and will timeout"
 W !,"faster when DISCONNECTED is received explicitly."
 ;
 W !!,"Answer 'NO' if:"
 W !,"If you are still using VADATS, do not perform this IDCU initialization."
 W !,"When you switch to the IDCU, run the IDCU conversion, then 'D ^XMYPDOM' !",!!
 Q
