DINIT00D ; SFISC/TKW-DIALOG & LANGUAGE FILE INITS  [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,99) S:$A(Y)=61 Y=$E(Y,2,999) S @X=Y
Q Q
 ;;^UTILITY(U,$J,.84,1502,5,1,0)
 ;;=DIP^EN1
 ;;^UTILITY(U,$J,.84,1503,0)
 ;;=1503^1^y^11^
 ;;^UTILITY(U,$J,.84,1503,1,0)
 ;;=^^1^1^2931116^^^^
 ;;^UTILITY(U,$J,.84,1503,1,1,0)
 ;;=Warn user to shorten compiled cross-reference routine name.
 ;;^UTILITY(U,$J,.84,1503,2,0)
 ;;=^^1^1^2931116^^
 ;;^UTILITY(U,$J,.84,1503,2,1,0)
 ;;= routine name is too long.  Compilation has been aborted.
 ;;^UTILITY(U,$J,.84,1503,5,0)
 ;;=^.841^6^6
 ;;^UTILITY(U,$J,.84,1503,5,1,0)
 ;;=DIEZ^ 
 ;;^UTILITY(U,$J,.84,1503,5,2,0)
 ;;=DIEZ^EN
 ;;^UTILITY(U,$J,.84,1503,5,3,0)
 ;;=DIKZ^ 
 ;;^UTILITY(U,$J,.84,1503,5,4,0)
 ;;=DIKZ^EN
 ;;^UTILITY(U,$J,.84,1503,5,5,0)
 ;;=DIPZ^ 
 ;;^UTILITY(U,$J,.84,1503,5,6,0)
 ;;=DIPZ^EN
 ;;^UTILITY(U,$J,.84,1504,0)
 ;;=1504^1^^11
 ;;^UTILITY(U,$J,.84,1504,1,0)
 ;;=^^2^2^2940316^
 ;;^UTILITY(U,$J,.84,1504,1,1,0)
 ;;=If doing Transfer/Merge of a single record from one file to another, and
 ;;^UTILITY(U,$J,.84,1504,1,2,0)
 ;;=the .01 field names do not match, we cannot do the transfer/merge.
 ;;^UTILITY(U,$J,.84,1504,2,0)
 ;;=^^1^1^2940316^
 ;;^UTILITY(U,$J,.84,1504,2,1,0)
 ;;=No matching .01 field names found.  Transfer/Merge cannot be done.
 ;;^UTILITY(U,$J,.84,1504,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,1504,5,1,0)
 ;;=DIT^TRNMRG
 ;;^UTILITY(U,$J,.84,1610,0)
 ;;=1610^1^^11
 ;;^UTILITY(U,$J,.84,1610,1,0)
 ;;=^^2^2^2940223^^
 ;;^UTILITY(U,$J,.84,1610,1,1,0)
 ;;=A question mark or, in the case of a variable pointer field, a <something>.?
 ;;^UTILITY(U,$J,.84,1610,1,2,0)
 ;;=was passed to the Validator.  The Validator does not process help requests.
 ;;^UTILITY(U,$J,.84,1610,2,0)
 ;;=^^1^1^2940223^^^
 ;;^UTILITY(U,$J,.84,1610,2,1,0)
 ;;=Help is being requested from the Validator utility.
 ;;^UTILITY(U,$J,.84,1610,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,1610,3,1,0)
 ;;=FILE^File number.
 ;;^UTILITY(U,$J,.84,1610,3,2,0)
 ;;=FIELD^Field number.
 ;;^UTILITY(U,$J,.84,1610,5,0)
 ;;=^.841^1^1
 ;;^UTILITY(U,$J,.84,1610,5,1,0)
 ;;=DIE^FILE
 ;;^UTILITY(U,$J,.84,1700,0)
 ;;=1700^1^y^11^
 ;;^UTILITY(U,$J,.84,1700,1,0)
 ;;=^^1^1^2940310^^
 ;;^UTILITY(U,$J,.84,1700,1,1,0)
 ;;=Generic message for Silent DIFROM
 ;;^UTILITY(U,$J,.84,1700,2,0)
 ;;=^^1^1^2940310^^
 ;;^UTILITY(U,$J,.84,1700,2,1,0)
 ;;=Error: |1|.
 ;;^UTILITY(U,$J,.84,1700,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,1700,3,1,0)
 ;;=1^Generic message
 ;;^UTILITY(U,$J,.84,1701,0)
 ;;=1701^1^y^11^
 ;;^UTILITY(U,$J,.84,1701,1,0)
 ;;=^^1^1^2940912^^^
 ;;^UTILITY(U,$J,.84,1701,1,1,0)
 ;;=Transport structure does not contain SPECIFIC ELEMENT.
 ;;^UTILITY(U,$J,.84,1701,2,0)
 ;;=^^1^1^2940912^^^
 ;;^UTILITY(U,$J,.84,1701,2,1,0)
 ;;=Transport structure does not contain |1|.
 ;;^UTILITY(U,$J,.84,1701,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,1701,3,1,0)
 ;;=1^Describes missing element in transport structure.
 ;;^UTILITY(U,$J,.84,3000,0)
 ;;=3000^1^^11
 ;;^UTILITY(U,$J,.84,3000,1,0)
 ;;=^^1^1^2930721^
 ;;^UTILITY(U,$J,.84,3000,1,1,0)
 ;;=Initial call to ^DDS failed.
 ;;^UTILITY(U,$J,.84,3000,2,0)
 ;;=^^1^1^2931202^
 ;;^UTILITY(U,$J,.84,3000,2,1,0)
 ;;=THE FORM COULD NOT BE INVOKED.
 ;;^UTILITY(U,$J,.84,3002,0)
 ;;=3002^1^y^11^
 ;;^UTILITY(U,$J,.84,3002,1,0)
 ;;=^^1^1^2931202^
 ;;^UTILITY(U,$J,.84,3002,1,1,0)
 ;;=An error was encountered during Form compilation.
 ;;^UTILITY(U,$J,.84,3002,2,0)
 ;;=^^1^1^2931202^^
 ;;^UTILITY(U,$J,.84,3002,2,1,0)
 ;;=THE FORM "|1|" COULD NOT BE COMPILED.
 ;;^UTILITY(U,$J,.84,3002,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,3002,3,1,0)
 ;;=1^Form name
 ;;^UTILITY(U,$J,.84,3011,0)
 ;;=3011^1^y^11^
 ;;^UTILITY(U,$J,.84,3011,1,0)
 ;;=^^1^1^2931201^
 ;;^UTILITY(U,$J,.84,3011,1,1,0)
 ;;=The specified field is missing or invalid.
 ;;^UTILITY(U,$J,.84,3011,2,0)
 ;;=^^1^1^2931201^
 ;;^UTILITY(U,$J,.84,3011,2,1,0)
 ;;=The |1| field of the |2| file is missing or invalid.
 ;;^UTILITY(U,$J,.84,3011,3,0)
 ;;=^.845^2^2
 ;;^UTILITY(U,$J,.84,3011,3,1,0)
 ;;=1^Field or subfield name
 ;;^UTILITY(U,$J,.84,3011,3,2,0)
 ;;=2^File name
 ;;^UTILITY(U,$J,.84,3012,0)
 ;;=3012^1^y^11^
 ;;^UTILITY(U,$J,.84,3012,1,0)
 ;;=^^2^2^2931201^
 ;;^UTILITY(U,$J,.84,3012,1,1,0)
 ;;=The specified file or subfile does not exist; it is not present in the
 ;;^UTILITY(U,$J,.84,3012,1,2,0)
 ;;=data dictionary.
 ;;^UTILITY(U,$J,.84,3012,2,0)
 ;;=^^1^1^2931201^
 ;;^UTILITY(U,$J,.84,3012,2,1,0)
 ;;=File |1| does not exist.
 ;;^UTILITY(U,$J,.84,3012,3,0)
 ;;=^.845^1^1
 ;;^UTILITY(U,$J,.84,3012,3,1,0)
 ;;=1^File number or name
