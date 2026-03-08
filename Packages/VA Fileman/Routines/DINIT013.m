DINIT013 ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,9504,0)
 ;;=9504^1^^11
 ;;^UTILITY(U,$J,.84,9504,1,0)
 ;;=^^1^1^2940908^^
 ;;^UTILITY(U,$J,.84,9504,1,1,0)
 ;;=DIFROM Server; Installing DD only if file is new on target system.
 ;;^UTILITY(U,$J,.84,9504,2,0)
 ;;=^^1^1^2940908^^
 ;;^UTILITY(U,$J,.84,9504,2,1,0)
 ;;=Data Dictionary not installed; DD already exist on target system.
 ;;^UTILITY(U,$J,.84,9505,0)
 ;;=9505^1^^11
 ;;^UTILITY(U,$J,.84,9505,1,0)
 ;;=^^1^1^2940915^^^
 ;;^UTILITY(U,$J,.84,9505,1,1,0)
 ;;=DIFROM Server; Did not pass DD screen.
 ;;^UTILITY(U,$J,.84,9505,2,0)
 ;;=^^1^1^2940915^^^
 ;;^UTILITY(U,$J,.84,9505,2,1,0)
 ;;=Data Dictionary not updated; Did not pass DD Screen.
 ;;^UTILITY(U,$J,.84,9506,0)
 ;;=9506^1^^11
 ;;^UTILITY(U,$J,.84,9506,1,0)
 ;;=^^1^1^2940909^^^^
 ;;^UTILITY(U,$J,.84,9506,1,1,0)
 ;;=DIFROM Server;  Transport structure does not exist or invalid.
 ;;^UTILITY(U,$J,.84,9506,2,0)
 ;;=^^1^1^2940909^^^^
 ;;^UTILITY(U,$J,.84,9506,2,1,0)
 ;;=Transport array does not exist or invalid.
 ;;^UTILITY(U,$J,.84,9507,0)
 ;;=9507^1^^11
 ;;^UTILITY(U,$J,.84,9507,1,0)
 ;;=^^1^1^2940908^^
 ;;^UTILITY(U,$J,.84,9507,1,1,0)
 ;;=DIFROM Server;  FIA file number invalid.
 ;;^UTILITY(U,$J,.84,9507,2,0)
 ;;=^^1^1^2940908^^
 ;;^UTILITY(U,$J,.84,9507,2,1,0)
 ;;=Data Dictionary not installed; FIA file number invalid.
 ;;^UTILITY(U,$J,.84,9508,0)
 ;;=9508^1^^11
 ;;^UTILITY(U,$J,.84,9508,1,0)
 ;;=^^1^1^2940908^^^
 ;;^UTILITY(U,$J,.84,9508,1,1,0)
 ;;=DIFROM Server;  File does not exist on target system (Partial DD).
 ;;^UTILITY(U,$J,.84,9508,2,0)
 ;;=^^1^1^2940908^^^
 ;;^UTILITY(U,$J,.84,9508,2,1,0)
 ;;=Data Dictionary not installed; Partial DD/File does not exist.
 ;;^UTILITY(U,$J,.84,9509,0)
 ;;=9509^1^^11
 ;;^UTILITY(U,$J,.84,9509,1,0)
 ;;=^^1^1^2940908^^^
 ;;^UTILITY(U,$J,.84,9509,1,1,0)
 ;;=DIFROMS Server;  FIA node is set to send "No Data"
 ;;^UTILITY(U,$J,.84,9509,2,0)
 ;;=^^1^1^2940908^^^
 ;;^UTILITY(U,$J,.84,9509,2,1,0)
 ;;=FIA array is set to "No data"
 ;;^UTILITY(U,$J,.84,9510,0)
 ;;=9510^1^^11
 ;;^UTILITY(U,$J,.84,9510,1,0)
 ;;=^^1^1^2940908^
 ;;^UTILITY(U,$J,.84,9510,1,1,0)
 ;;=DIFROM Server;  Records to transport do not exist.
 ;;^UTILITY(U,$J,.84,9510,2,0)
 ;;=^^1^1^2940908^
 ;;^UTILITY(U,$J,.84,9510,2,1,0)
 ;;=Records do not exist.
 ;;^UTILITY(U,$J,.84,9511,0)
 ;;=9511^1^^11
 ;;^UTILITY(U,$J,.84,9511,1,0)
 ;;=^^1^1^2940908^
 ;;^UTILITY(U,$J,.84,9511,1,1,0)
 ;;=DIFROM Server; DD not installed because FIA array does not exist.
 ;;^UTILITY(U,$J,.84,9511,2,0)
 ;;=^^1^1^2940908^
 ;;^UTILITY(U,$J,.84,9511,2,1,0)
 ;;=Data Dictionary not installed; FIA array does not exist.
 ;;^UTILITY(U,$J,.84,9512,0)
 ;;=9512^1^y^11
 ;;^UTILITY(U,$J,.84,9512,1,0)
 ;;=^^1^1^2940909^^^^
 ;;^UTILITY(U,$J,.84,9512,1,1,0)
 ;;=Parent DD missing on Partial DD.
 ;;^UTILITY(U,$J,.84,9512,2,0)
 ;;=^^1^1^2940909^^^^
 ;;^UTILITY(U,$J,.84,9512,2,1,0)
 ;;=DD: |1| not installed, parent DD(s) missing.
 ;;^UTILITY(U,$J,.84,9513,0)
 ;;=9513^1^y^11
 ;;^UTILITY(U,$J,.84,9513,1,0)
 ;;=^^1^1^2940909^^^
 ;;^UTILITY(U,$J,.84,9513,1,1,0)
 ;;=Invalid record in file.
 ;;^UTILITY(U,$J,.84,9513,2,0)
 ;;=^^1^1^2940909^^^
 ;;^UTILITY(U,$J,.84,9513,2,1,0)
 ;;=IEN: |1| in file |2| is invalid.
 ;;^UTILITY(U,$J,.84,9514,0)
 ;;=9514^1^y^11
 ;;^UTILITY(U,$J,.84,9514,1,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9514,1,1,0)
 ;;=Dangling pointer.  File, IEN and field.
 ;;^UTILITY(U,$J,.84,9514,2,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9514,2,1,0)
 ;;=Dangling pointer.  FILE: |1|, IEN: |2| FIELD: |3|
 ;;^UTILITY(U,$J,.84,9515,0)
 ;;=9515^1^y^11
 ;;^UTILITY(U,$J,.84,9515,1,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9515,1,1,0)
 ;;=No sending data on partial DDs.
 ;;^UTILITY(U,$J,.84,9515,2,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9515,2,1,0)
 ;;=Partial DD.  No sending of data allowed for file |1|.
 ;;^UTILITY(U,$J,.84,9516,0)
 ;;=9516^1^y^11
 ;;^UTILITY(U,$J,.84,9516,1,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9516,1,1,0)
 ;;=Invalid entry in trasnport structure.
 ;;^UTILITY(U,$J,.84,9516,2,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9516,2,1,0)
 ;;=Transport structure does not contain |1| with IEN: |2|.
 ;;^UTILITY(U,$J,.84,9517,0)
 ;;=9517^1^y^11
 ;;^UTILITY(U,$J,.84,9517,1,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9517,1,1,0)
 ;;=DIFROM Server unable to install block.
 ;;^UTILITY(U,$J,.84,9517,2,0)
 ;;=^^1^1^2940909^
 ;;^UTILITY(U,$J,.84,9517,2,1,0)
 ;;=DIFROM Server unable to install |1| block.
