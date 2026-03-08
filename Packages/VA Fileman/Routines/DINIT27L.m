DINIT27L ;SFISC/DPC - SAS (COLUMNS) FOREIGN FORMAT;2/26/93  11:05 AM [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(ENTRY+I) G:X="" ^DINIT28 S Y=$E($T(ENTRY+I+1),5,999),X=$E(X,4,999),@X=Y
 Q
ENTRY ;
 ;;^DIST(.44,.011,0)
 ;;=SAS (COLUMNS)^^^^^1^1^0^1^^1^1
 ;;^DIST(.44,.011,1)
 ;;=D SASCOL^DDXPLIB
 ;;^DIST(.44,.011,2)
 ;;=";"
 ;;^DIST(.44,.011,3,0)
 ;;=^^5^5^2921229^
 ;;^DIST(.44,.011,3,1,0)
 ;;=This format creates output designed for use with SAS.  The output is
 ;;^DIST(.44,.011,3,2,0)
 ;;=column-oriented.  The user is prompted for field lengths, maximum record
 ;;^DIST(.44,.011,3,3,0)
 ;;=length, field names (used as SAS variable names), and data types.  Field
 ;;^DIST(.44,.011,3,4,0)
 ;;=length for date data types must be 8 or larger.  No semicolons (;) may
 ;;^DIST(.44,.011,3,5,0)
 ;;=appear in the data.
 ;;^DIST(.44,.011,4,0)
 ;;=^^6^6^2930226^^^
 ;;^DIST(.44,.011,4,1,0)
 ;;=The exported output begins with an INPUT statement that contains variable
 ;;^DIST(.44,.011,4,2,0)
 ;;=names as specified by the user.  For numeric and free text (character)
 ;;^DIST(.44,.011,4,3,0)
 ;;=data, the start and end columns are shown.  For date data, the informat
 ;;^DIST(.44,.011,4,4,0)
 ;;='YYMMDDw.' is used with data always given YYYYMMDD (i.e., full century
 ;;^DIST(.44,.011,4,5,0)
 ;;=data).  Following the INPUT statement is a 'CARDS;' line, followed by the
 ;;^DIST(.44,.011,4,6,0)
 ;;=columnar data, followed by ';'.
 ;;^DIST(.44,.011,5,0)
 ;;=^.441^^
 ;;^DIST(.44,.011,6)
 ;;=S Y=X+17000000
