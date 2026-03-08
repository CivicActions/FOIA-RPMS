PSOKI002 ;IHS/DSD/ENM - ; 12-MAY-1998 [ 05/13/1998  5:24 PM ]
 ;;6.0;OUTPATIENT PATCH (PSO*6.0*1);**1**;MAY 12, 1998
 Q:'DIFQ(52)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DD(52.3,.02,3)
 ;;=Enter code to indicate the activity taking place for this prescription.
 ;;^DD(52.3,.02,21,0)
 ;;=^^1^1^2921001^^^^
 ;;^DD(52.3,.02,21,1,0)
 ;;=What was done that caused activity to happen.
 ;;^DD(52.3,.02,23,0)
 ;;=^^4^4^2921001^^^^
 ;;^DD(52.3,.02,23,1,0)
 ;;=Set 'H' for Hold, 'U' for Unhold, 'C' for Cancelled, 'E' for Edit,
 ;;^DD(52.3,.02,23,2,0)
 ;;='L' for Lost, 'P' for Partial, 'R' for Reinstate, 'W' for Reprint,
 ;;^DD(52.3,.02,23,3,0)
 ;;='S' for Suspensed, 'I' for Returned to Stock, 'V' for Intervention
 ;;^DD(52.3,.02,23,4,0)
 ;;='D' for Deleted, 'A' for Pending due to drug interactions, 'B' for Unpending.
 ;;^DD(52.3,.02,"DT")
 ;;=2921001
 ;;^DD(52.3,.03,0)
 ;;=INITIATOR OF ACTIVITY^RP200'^VA(200,^0;3^Q
 ;;^DD(52.3,.03,3)
 ;;=
 ;;^DD(52.3,.03,21,0)
 ;;=^^1^1^2920428^^^
 ;;^DD(52.3,.03,21,1,0)
 ;;=The name of the person entering an activity is entered.
 ;;^DD(52.3,.03,23,0)
 ;;=^^1^1^2920428^^^
 ;;^DD(52.3,.03,23,1,0)
 ;;=(Required) Pointer.
 ;;^DD(52.3,.03,"DT")
 ;;=2920428
 ;;^DD(52.3,.04,0)
 ;;=RX REFERENCE^S^0:ORIGINAL;1:FIRST REFILL;2:SECOND REFILL;3:THIRD REFILL;4:FOURTH REFILL;5:FIFTH REFILL;6:SIXTH REFILL;7:SEVENTH REFILL;8:EIGHTH REFILL;9:NINTH REFILL;10:TENTH REFILL;11:ELEVENTH REFILL;12:PARTIAL;^0;4^Q
 ;;^DD(52.3,.04,3)
 ;;=Contains the number of the fill.
 ;;^DD(52.3,.04,21,0)
 ;;=^^1^1^2980512^^^^
 ;;^DD(52.3,.04,21,1,0)
 ;;=This field is used to indicate which fill the activity took place.
 ;;^DD(52.3,.04,23,0)
 ;;=^^5^5^2980512^^^^
 ;;^DD(52.3,.04,23,1,0)
 ;;=Set '0' for Original, '1' for First Refill, '2' for Second Refill,
 ;;^DD(52.3,.04,23,2,0)
 ;;='3' for Third Refill, '4' for Fourth Refill, '5' for Fifth Refill,
 ;;^DD(52.3,.04,23,3,0)
 ;;='6' for Sixth Refill, '7' for Seventh Refill, '8' for Eighth Refill,
 ;;^DD(52.3,.04,23,4,0)
 ;;='9' for Ninth Refill, '10' for Tenth Refill, '11' for Eleventh Refill,
 ;;^DD(52.3,.04,23,5,0)
 ;;='12' for Partial.
 ;;^DD(52.3,.04,"DT")
 ;;=2980512
 ;;^DD(52.3,.05,0)
 ;;=COMMENT^RF^^0;5^K:$L(X)>75!($L(X)<1) X
 ;;^DD(52.3,.05,3)
 ;;=ANSWER MUST BE 1-75 CHARACTERS IN LENGTH
 ;;^DD(52.3,.05,21,0)
 ;;=^^1^1^2920115^
 ;;^DD(52.3,.05,21,1,0)
 ;;=Any additional comments.
 ;;^DD(52.3,.05,23,0)
 ;;=^^1^1^2920115^
 ;;^DD(52.3,.05,23,1,0)
 ;;=(Required) Free Text.
 ;;^DD(52.3,.05,"DT")
 ;;=2820901
 ;;^DD(52.3,1,0)
 ;;=FIELD EDITED^F^^1;1^K:$L(X)>25!($L(X)<5) X
 ;;^DD(52.3,1,3)
 ;;=Enter the name of the field that was edited.  Answer must be 5-25 characters in length.
 ;;^DD(52.3,1,21,0)
 ;;=^^2^2^2920305^
 ;;^DD(52.3,1,21,1,0)
 ;;=This field is used to indicate any editing to a data field of a presciption.
 ;;^DD(52.3,1,21,2,0)
 ;;=This field will contain the name of the field edited.
 ;;^DD(52.3,1,"DT")
 ;;=2920305
 ;;^DD(52.3,2,0)
 ;;=OLD VALUE^F^^1;2^K:$L(X)>25!($L(X)<1) X
 ;;^DD(52.3,2,3)
 ;;=Enter the old value of the edited field of the RX.  Answer must be 1-25 characters in length.
 ;;^DD(52.3,2,21,0)
 ;;=^^1^1^2930316^^
 ;;^DD(52.3,2,21,1,0)
 ;;=This field is used to show the old value of an edited field.
 ;;^DD(52.3,2,"DT")
 ;;=2920305
 ;;^DD(52.3,3,0)
 ;;=NEW VALUE^F^^1;3^K:$L(X)>25!($L(X)<1) X
 ;;^DD(52.3,3,3)
 ;;=Enter the new value of the edited field of the RX.  Answer must be 1-25 characters in length.
 ;;^DD(52.3,3,21,0)
 ;;=^^1^1^2920305^
 ;;^DD(52.3,3,21,1,0)
 ;;=This field is ued to show the new value of an edited field of a RX.
