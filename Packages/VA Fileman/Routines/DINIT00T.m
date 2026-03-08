DINIT00T ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9110,3,2,0)
 ;;=2^Conditionally, indicates if past, future, or current year is assumed.
 ;;^UTILITY(U,$J,.84,9110,3,3,0)
 ;;=3^Conditionally, indicates that day is not needed.
 ;;^UTILITY(U,$J,.84,9111,0)
 ;;=9111^3^y^11^
 ;;^UTILITY(U,$J,.84,9111,1,0)
 ;;=^^1^1^2930806^
 ;;^UTILITY(U,$J,.84,9111,1,1,0)
 ;;=Instructions for entering time data.
 ;;^UTILITY(U,$J,.84,9111,2,0)
 ;;=^^5^5^2931104^^
 ;;^UTILITY(U,$J,.84,9111,2,1,0)
 ;;=If the date is omitted, the current date is assumed.
 ;;^UTILITY(U,$J,.84,9111,2,2,0)
 ;;=Follow the date with a time, such as JAN 20@10, T@10AM, 10:30, etc.
 ;;^UTILITY(U,$J,.84,9111,2,3,0)
 ;;=You may enter NOON, MIDNIGHT, or NOW to indicate the time.
 ;;^UTILITY(U,$J,.84,9111,2,4,0)
 ;;=|1|
 ;;^UTILITY(U,$J,.84,9111,2,5,0)
 ;;=|2|
 ;;^UTILITY(U,$J,.84,9111,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,9111,3,1,0)
 ;;=1^Conditionally, give instructions for entering seconds.
 ;;^UTILITY(U,$J,.84,9111,3,2,0)
 ;;=2^Conditionally, state that time is required.
 ;;^UTILITY(U,$J,.84,9115,0)
 ;;=9115^3^^11
 ;;^UTILITY(U,$J,.84,9115,1,0)
 ;;=^^1^1^2930810^
 ;;^UTILITY(U,$J,.84,9115,1,1,0)
 ;;=The short help for variable pointers.
 ;;^UTILITY(U,$J,.84,9115,2,0)
 ;;=^^1^1^2930810^
 ;;^UTILITY(U,$J,.84,9115,2,1,0)
 ;;=To see the entries in any particular file, type <Prefix.?>.
 ;;^UTILITY(U,$J,.84,9116,0)
 ;;=9116^3^^11
 ;;^UTILITY(U,$J,.84,9116,1,0)
 ;;=^^1^1^2930810^
 ;;^UTILITY(U,$J,.84,9116,1,1,0)
 ;;=Long help for variable pointers.
 ;;^UTILITY(U,$J,.84,9116,2,0)
 ;;=^^15^15^2930810^
 ;;^UTILITY(U,$J,.84,9116,2,1,0)
 ;;=If you enter just a name, the system will search each of the 
 ;;^UTILITY(U,$J,.84,9116,2,2,0)
 ;;=above files for the name you have entered.  If a match is found,
 ;;^UTILITY(U,$J,.84,9116,2,3,0)
 ;;=the system will ask you if it is the entry you desire.
 ;;^UTILITY(U,$J,.84,9116,2,4,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9116,2,5,0)
 ;;=However, if you know the file the entry should be in, you can
 ;;^UTILITY(U,$J,.84,9116,2,6,0)
 ;;=speed processing by using the following syntax to select an entry:
 ;;^UTILITY(U,$J,.84,9116,2,7,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9116,2,8,0)
 ;;=     <Prefix>.<entry name>
 ;;^UTILITY(U,$J,.84,9116,2,9,0)
 ;;=             or
 ;;^UTILITY(U,$J,.84,9116,2,10,0)
 ;;=     <Message>.<entry name>
 ;;^UTILITY(U,$J,.84,9116,2,11,0)
 ;;=             or
 ;;^UTILITY(U,$J,.84,9116,2,12,0)
 ;;=     <File Name>.<entry name>
 ;;^UTILITY(U,$J,.84,9116,2,13,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9116,2,14,0)
 ;;=You do not need to enter the entire file name or message.
 ;;^UTILITY(U,$J,.84,9116,2,15,0)
 ;;=The first few characters will suffice.
 ;;^UTILITY(U,$J,.84,9117,0)
 ;;=9117^3^y^11^
 ;;^UTILITY(U,$J,.84,9117,1,0)
 ;;=^^1^1^2930810^^
 ;;^UTILITY(U,$J,.84,9117,1,1,0)
 ;;=Variable pointer help - prefix and message.
 ;;^UTILITY(U,$J,.84,9117,2,0)
 ;;=^^1^1^2930810^^^
 ;;^UTILITY(U,$J,.84,9117,2,1,0)
 ;;=|1|.EntryName to select a |2|.
 ;;^UTILITY(U,$J,.84,9117,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,9117,3,1,0)
 ;;=1^The prefix for a variable pointer file.
 ;;^UTILITY(U,$J,.84,9117,3,2,0)
 ;;=2^The message for a variable pointer file.
 ;;^UTILITY(U,$J,.84,9201,0)
 ;;=9201^3^^11
 ;;^UTILITY(U,$J,.84,9201,1,0)
 ;;=^^1^1^2941024^
 ;;^UTILITY(U,$J,.84,9201,1,1,0)
 ;;=Browser help
 ;;^UTILITY(U,$J,.84,9201,2,0)
 ;;=^^180^180^2941024^
 ;;^UTILITY(U,$J,.84,9201,2,1,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9201,2,2,0)
 ;;=                                  HELP SUMMARY
 ;;^UTILITY(U,$J,.84,9201,2,3,0)
 ;;=                                  ============
 ;;^UTILITY(U,$J,.84,9201,2,4,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,9201,2,5,0)
 ;;=NAVIGATION:
 ;;^UTILITY(U,$J,.84,9201,2,6,0)
 ;;============
 ;;^UTILITY(U,$J,.84,9201,2,7,0)
 ;;=     Scroll Down (one line)                  ARROW DOWN
 ;;^UTILITY(U,$J,.84,9201,2,8,0)
 ;;=     Scroll Up (one line)                    ARROW UP
 ;;^UTILITY(U,$J,.84,9201,2,9,0)
 ;;=     Page Down                               <PF1>ARROW DOWN
 ;;^UTILITY(U,$J,.84,9201,2,10,0)
 ;;=     Page Up                                 <PF1>ARROW UP
 ;;^UTILITY(U,$J,.84,9201,2,11,0)
 ;;=     Scroll Right (default 22 columns)       ARROW RIGHT
 ;;^UTILITY(U,$J,.84,9201,2,12,0)
 ;;=     Scroll Left (default 22 columns)        ARROW LEFT
 ;;^UTILITY(U,$J,.84,9201,2,13,0)
 ;;=     Scroll Horizontally to the end          <PF1>ARROW RIGHT
 ;;^UTILITY(U,$J,.84,9201,2,14,0)
 ;;=     Scroll Horizontally to the end          <PF1>ARROW LEFT
