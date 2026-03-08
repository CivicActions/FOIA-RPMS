XMC1A1 ;(WASH ISC)/THM-SCRIPT INTERPRETER (C/L/O/S) DOC ;2/15/91  11:58 ;
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.1;MailMan;;Jun 02, 1994
LOOK ;For Text
 ; 
 ;  There can only be one 'B' in a LOOK command.  It may be preceeded by
 ;  at least one 'A' and succeeded by as many 'C's as desired.
 ;  The 'B' parameter may be null.  In this case two spaces would 
 ;  separate the 'A' parameters for the 'C' parameters.
 ;
 ;X=SCRIPT COMMAND 'L:Timeout A A A ... B C C C ...'
 ;
 ;The string represented by 'x' must always have a length >0.
 ;The string being looked for must always be surrounded by '|'s.
 ;To use the new form, the looked for strings must be surrounded by '|'s.
 ;    If no '|'s are found, it is assumed to be of the old form
 ;    (see example 4 below).
 ;There must not be any '|'s for the "OLD" form as the 1st character
 ;     after the 1st space in the string.
 ;The 1st character after the 1st space in the string must be a '|'
 ;     in the "NEW" form.
 ;Condition A is always checked first
 ;
 ;WHERE 'A' (mandatory) has form 'x' / QUIT on finding string 'x'
 ;                 or 'x:y' / GOTO line 'y' on finding 'x'
 ;
 ;WHERE 'C' (optional) has form 'x' / QUIT setting ER=1 on finding 'x'
 ;
 ;WHERE 'B' (optional) has form 'y' / GOTO 'y' on timeout
 ;
 ;********************************************************************
 ;
EXAM ;Examples:
 ;
 ;    1.  Look for "LINE" or "CONNECTED" on a timeout just error out
 ;        (Where the command is on line 3)
 ;
 ;            L |LINE|:3 |CONNECTED|:3
 ;                   or
 ;            L |LINE| |CONNECTED|
 ;
 ;    2.  Look for "LINE" and if found go to line 15 of this script
 ;        Look for "CONNECTED" and if found go to line 18 of this script.
 ;        Go to line 25 of this script on a time out.
 ;        If "DISCON" is found error out.
 ;
 ;            L |LINE|:15 |CONNECTED|:18 25 |DISCON|
 ;
 ;    3.  Same case as 2 except that on a timeout just error out.
 ;
 ;            L |LINE|:15 |CONNECTED|:18  |DISCON|
 ;
 ;        (Note that '18' is followed by 2 spaces [Timeout is null])
 ;
 ;    4.  Look for 'ON LINE', then look for the string 'CONNECTED'
 ;
 ;            L |ON LINE|:6 |CONNECTED|
 ;
 ;        This is a little tricky.  The old syntax for looking for a
 ;        string took $P(X," ",2,999) as the argument, where X is the
 ;        entire script command.  To be backwards compatible, there must
 ;        be '|'s surrounding all of the strings being looked for.
 ;
 ;****************************************************************
 ;
 ;     The old syntax still works:
 ;
 ;     L ON LINE
 ;
 ;     is interpreted in the old way as look for the phrase "ON LINE"
 ;
 ;*****************************************************************
 ;
 ;  VARIABLES
 ;
 ;XMC1A(,,)   === Array of checks XMC1A(1,,)=success checks
 ;                                XMC1A(2,1,1)=timout (also XMC1A(2))
 ;                                XMC1A(3,,)=failure checks
 ;failure is type 'C', success is type 'A', time-out is Type 'B' above
