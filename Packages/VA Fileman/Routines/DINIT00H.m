DINIT00H ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,8005,2,10,0)
 ;;= 
 ;;^UTILITY(U,$J,.84,8005,2,11,0)
 ;;=If S and/or C is entered, the heading prompt will re-appear.
 ;;^UTILITY(U,$J,.84,8005,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,8005,3,1,0)
 ;;=1^Text from either entry #8006 or #8007, depending on whether we're coming from the search or print.
 ;;^UTILITY(U,$J,.84,8005,3,2,0)
 ;;=2^Text from either entry #8038 or #8037, depending on whether we're coming from the search or print.
 ;;^UTILITY(U,$J,.84,8005,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8005,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,8005,5,2,0)
 ;;=DIS^ENS
 ;;^UTILITY(U,$J,.84,8006,0)
 ;;=8006^2^^11^
 ;;^UTILITY(U,$J,.84,8006,1,0)
 ;;=^^1^1^2940526^^^^
 ;;^UTILITY(U,$J,.84,8006,1,1,0)
 ;;=Inserted as a parameter to #8005 when called from the SEARCH Option.
 ;;^UTILITY(U,$J,.84,8006,2,0)
 ;;=^^1^1^2940526^^
 ;;^UTILITY(U,$J,.84,8006,2,1,0)
 ;;=Number of Matches from the search
 ;;^UTILITY(U,$J,.84,8006,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8006,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,8006,5,2,0)
 ;;=DIS^ENS
 ;;^UTILITY(U,$J,.84,8007,0)
 ;;=8007^2^^11^
 ;;^UTILITY(U,$J,.84,8007,1,0)
 ;;=^^1^1^2940526^^^^
 ;;^UTILITY(U,$J,.84,8007,1,1,0)
 ;;=Inserted as a parameter to #8005 when called from the PRINT Option.
 ;;^UTILITY(U,$J,.84,8007,2,0)
 ;;=^^1^1^2940526^
 ;;^UTILITY(U,$J,.84,8007,2,1,0)
 ;;=heading when there are no records to print
 ;;^UTILITY(U,$J,.84,8007,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8007,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,8007,5,2,0)
 ;;=DIS^ENS
 ;;^UTILITY(U,$J,.84,8008,0)
 ;;=8008^2^^11^
 ;;^UTILITY(U,$J,.84,8008,1,0)
 ;;=^^4^4^2940908^
 ;;^UTILITY(U,$J,.84,8008,1,1,0)
 ;;=At the HEADING prompt during the FileMan print, the user can enter flags
 ;;^UTILITY(U,$J,.84,8008,1,2,0)
 ;;=to either suppress printing of the header if there are no records to
 ;;^UTILITY(U,$J,.84,8008,1,3,0)
 ;;=print, or to cause the sort criteria to print in the header.  This is the
 ;;^UTILITY(U,$J,.84,8008,1,4,0)
 ;;=prompt for the reader call.
 ;;^UTILITY(U,$J,.84,8008,2,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,8008,2,1,0)
 ;;=Heading (S/C)
 ;;^UTILITY(U,$J,.84,8008,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8008,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,8008,5,2,0)
 ;;=DIS^ENS
 ;;^UTILITY(U,$J,.84,8009,0)
 ;;=8009^2^^11^
 ;;^UTILITY(U,$J,.84,8009,1,0)
 ;;=^^2^2^2940908^^^^
 ;;^UTILITY(U,$J,.84,8009,1,1,0)
 ;;=This is the normal help message given if user enters a question mark when
 ;;^UTILITY(U,$J,.84,8009,1,2,0)
 ;;=being prompted for the HEADER during a FileMan print.
 ;;^UTILITY(U,$J,.84,8009,2,0)
 ;;=^^3^3^2940908^
 ;;^UTILITY(U,$J,.84,8009,2,1,0)
 ;;=Accept default heading or enter a custom heading.
 ;;^UTILITY(U,$J,.84,8009,2,2,0)
 ;;=For no heading at all, type @.
 ;;^UTILITY(U,$J,.84,8009,2,3,0)
 ;;=To use a Print Template for the heading, type [TEMPLATE NAME].
 ;;^UTILITY(U,$J,.84,8009,3,0)
 ;;=^.845
 ;;^UTILITY(U,$J,.84,8009,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8009,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,8009,5,2,0)
 ;;=DIS^ENS
 ;;^UTILITY(U,$J,.84,8010,0)
 ;;=8010^2^y^11^
 ;;^UTILITY(U,$J,.84,8010,1,0)
 ;;=^^1^1^2931102^^^^
 ;;^UTILITY(U,$J,.84,8010,1,1,0)
 ;;=Print dialog coming from routine ^DIP31.
 ;;^UTILITY(U,$J,.84,8010,2,0)
 ;;=^^1^1^2931102^
 ;;^UTILITY(U,$J,.84,8010,2,1,0)
 ;;=** Suppress the |1|.
 ;;^UTILITY(U,$J,.84,8010,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8010,3,1,0)
 ;;=1^Text from either entry #8006 or #8007, depending on whether it's called from the SEARCH or PRINT Options.
 ;;^UTILITY(U,$J,.84,8010,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8010,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,8010,5,2,0)
 ;;=DIS^ENS
 ;;^UTILITY(U,$J,.84,8011,0)
 ;;=8011^2^y^11^
 ;;^UTILITY(U,$J,.84,8011,1,0)
 ;;=^^1^1^2940526^^^^
 ;;^UTILITY(U,$J,.84,8011,1,1,0)
 ;;=Dialog coming from routine ^DIP31
 ;;^UTILITY(U,$J,.84,8011,2,0)
 ;;=^^1^1^2940526^
 ;;^UTILITY(U,$J,.84,8011,2,1,0)
 ;;=** print |1| Criteria in heading.
 ;;^UTILITY(U,$J,.84,8011,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,8011,3,1,0)
 ;;=1^The word SORT or SEARCH, depending on which option we're coming from.
 ;;^UTILITY(U,$J,.84,8011,5,0)
 ;;=^.841^2^2
 ;;^UTILITY(U,$J,.84,8011,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,8011,5,2,0)
 ;;=DIS^ENS
 ;;^UTILITY(U,$J,.84,8012,0)
 ;;=8012^2^^11^
 ;;^UTILITY(U,$J,.84,8012,1,0)
 ;;=^^2^2^2931102^^^
 ;;^UTILITY(U,$J,.84,8012,1,1,0)
 ;;=The word HEADING to be used in the prompt for the heading from the FileMan
