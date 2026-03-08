PSOKI001 ;IHS/DSD/ENM - ; 12-MAY-1998 [ 05/13/1998  5:24 PM ]
 ;;6.0;OUTPATIENT PATCH (PSO*6.0*1);**1**;MAY 12, 1998
 Q:'DIFQ(52)  F I=1:2 S X=$T(Q+I) Q:X=""  S Y=$E($T(Q+I+1),4,999),X=$E(X,4,999) S:$A(Y)=126 I=I+1,Y=$E(Y,2,999)_$E($T(Q+I+1),5,999) S:$A(Y)=61 Y=$E(Y,2,999) X NO E  S @X=Y
Q Q
 ;;^DIC(52,0,"GL")
 ;;=^PSRX(
 ;;^DIC("B","PRESCRIPTION",52)
 ;;=
 ;;^DIC(52,"%",0)
 ;;=^1.005^2^2
 ;;^DIC(52,"%",1,0)
 ;;=PS
 ;;^DIC(52,"%",2,0)
 ;;=PSO
 ;;^DIC(52,"%","B","PS",1)
 ;;=
 ;;^DIC(52,"%","B","PSO",2)
 ;;=
 ;;^DIC(52,"%D",0)
 ;;=^^8^8^2930716^^^^
 ;;^DIC(52,"%D",1,0)
 ;;=Contains all outpatient RX data used by the outpatient pharmacy package.
 ;;^DIC(52,"%D",2,0)
 ;;=As the above indicates, this is the hub of the outpatient system.  It will
 ;;^DIC(52,"%D",3,0)
 ;;=easily be the largest pharmacy file in time and is pointed to very heavily.
 ;;^DIC(52,"%D",4,0)
 ;;=Deletion of an entry in this file must be handled VERY carefully and is not
 ;;^DIC(52,"%D",5,0)
 ;;=allowed if refills have been issued.
 ;;^DIC(52,"%D",6,0)
 ;;= 
 ;;^DIC(52,"%D",7,0)
 ;;=Of particular interest is that essentially all the history pertaining to a
 ;;^DIC(52,"%D",8,0)
 ;;=particular Rx is contained in each Rx entry.
 ;;^DD(52,0)
 ;;=FIELD^NL^9999999.11^63
 ;;^DD(52,0,"DDA")
 ;;=Y
 ;;^DD(52,0,"DIK")
 ;;=PSOXZA
 ;;^DD(52,0,"DIKOLD")
 ;;=PSOXZA
 ;;^DD(52,0,"DT")
 ;;=2980512
 ;;^DD(52,0,"ID",1)
 ;;=W ""
 ;;^DD(52,0,"ID",2)
 ;;=W ""
 ;;^DD(52,0,"ID",6)
 ;;=W:$D(^("0")) "   ",$S($D(^PSDRUG(+$P(^("0"),U,6),0))#2:$P(^(0),U,1),1:""),$E(^PSRX(Y,0),0)_$S($P(^(0),U,15)=13:"  ***MARKED FOR DELETION***",1:"")
 ;;^DD(52,0,"ID",108)
 ;;=W:$D(^("D")) "   ",$P(^("D"),U,3)
 ;;^DD(52,0,"IX","AC",52,1)
 ;;=
 ;;^DD(52,0,"IX","ACP2",52,31)
 ;;=
 ;;^DD(52,0,"IX","ACP4",52.1,2)
 ;;=
 ;;^DD(52,0,"IX","AD",52,22)
 ;;=
 ;;^DD(52,0,"IX","AD",52.1,.01)
 ;;=
 ;;^DD(52,0,"IX","AD2",52,20)
 ;;=
 ;;^DD(52,0,"IX","AD3",52.1,8)
 ;;=
 ;;^DD(52,0,"IX","AD4",52.2,.09)
 ;;=
 ;;^DD(52,0,"IX","AE",52,22)
 ;;=
 ;;^DD(52,0,"IX","AF",52,6)
 ;;=
 ;;^DD(52,0,"IX","AG",52,26)
 ;;=
 ;;^DD(52,0,"IX","AH",52,99)
 ;;=
 ;;^DD(52,0,"IX","AI",52,26)
 ;;=
 ;;^DD(52,0,"IX","AJ",52,32.1)
 ;;=
 ;;^DD(52,0,"IX","AJ1",52.1,14)
 ;;=
 ;;^DD(52,0,"IX","AK",52,26.1)
 ;;=
 ;;^DD(52,0,"IX","AL",52,31)
 ;;=
 ;;^DD(52,0,"IX","AL1",52.1,17)
 ;;=
 ;;^DD(52,0,"IX","ANCO",52,109)
 ;;=
 ;;^DD(52,0,"IX","AP",52,100)
 ;;=
 ;;^DD(52,0,"IX","APCC",52,9999999.11)
 ;;=
 ;;^DD(52,0,"IX","APCC2",52.1,9999999.11)
 ;;=
 ;;^DD(52,0,"IX","B",52,.01)
 ;;=
 ;;^DD(52,0,"IX","C",52,2)
 ;;=
 ;;^DD(52,0,"IX","CP",52,9999999.02)
 ;;=
 ;;^DD(52,0,"IX","ZAL",52,31)
 ;;=
 ;;^DD(52,0,"IX","ZAL2",52.2,8)
 ;;=
 ;;^DD(52,0,"IX","ZAL3",52.1,17)
 ;;=
 ;;^DD(52,0,"NM","PRESCRIPTION")
 ;;=
 ;;^DD(52,0,"PT",2.5,.01)
 ;;=
 ;;^DD(52,0,"PT",50.0731,3)
 ;;=
 ;;^DD(52,0,"PT",52.4,.01)
 ;;=
 ;;^DD(52,0,"PT",52.4,3)
 ;;=
 ;;^DD(52,0,"PT",52.41,.01)
 ;;=
 ;;^DD(52,0,"PT",52.5,.01)
 ;;=
 ;;^DD(52,0,"PT",52.52,1)
 ;;=
 ;;^DD(52,0,"PT",52.8,.01)
 ;;=
 ;;^DD(52,0,"PT",52.9002,.01)
 ;;=
 ;;^DD(52,0,"PT",55.03,.01)
 ;;=
 ;;^DD(52,0,"PT",356,.08)
 ;;=
 ;;^DD(52,.01,0)
 ;;=RX #^RF^^0;1^K:$L(X)>11!($L(X)<1) X
 ;;^DD(52,.01,1,0)
 ;;=^.1^^-1
 ;;^DD(52,.01,1,1,0)
 ;;=52^B
 ;;^DD(52,.01,1,1,1)
 ;;=S ^PSRX("B",$E(X,1,30),DA)=""
 ;;^DD(52,.01,1,1,2)
 ;;=K ^PSRX("B",$E(X,1,30),DA)
 ;;^DD(52,.01,3)
 ;;=TYPE A WHOLE NUMBER BETWEEN 1 AND 999999999
 ;;^DD(52,.01,4)
 ;;=W *7,!?5,"ENTER A VALID PRESCRIPTION NUMBER",!?5,"OR A BARCODE PRESCRIPTION NUMBER",!?5,"OR 'P' TO GET A PATIENT PROFILE (works only if in OUTPATIENT package)"
 ;;^DD(52,.01,7.5)
 ;;=
 ;;^DD(52,.01,20,0)
 ;;=^.3LA^1^1
 ;;^DD(52,.01,20,1,0)
 ;;=PSO
 ;;^DD(52,.01,21,0)
 ;;=^^1^1^2910724^
 ;;^DD(52,.01,21,1,0)
 ;;=This is the prescription number
 ;;^DD(52,.01,"DEL",1,0)
 ;;=I 1 W *7,!?5,"DELETE THROUGH PACKAGE ONLY!"
 ;;^DD(52,.01,"DEL",52,0)
 ;;=S X1=$S($D(^PSRX(D0,2)):$P(^(2),"^",6),1:0) S:'X1 RX0=^(0),J=D0 D ^PSOEXDT:'X1 I DT'>$P(^(2),U,6),$O(^PSRX(DA,1,0)) W !?5,*7,"CANNOT DELETE PRESCRIPTIONS WITH REFILLS."
 ;;^DD(52,.01,"DT")
 ;;=2901126
 ;;^DD(52,40,0)
 ;;=ACTIVITY LOG^52.3DA^^A;0
 ;;^DD(52,40,9)
 ;;=^
 ;;^DD(52,40,21,0)
 ;;=^^1^1^2980512^^^^
 ;;^DD(52,40,21,1,0)
 ;;=Activity Log.
 ;;^DD(52,40,23,0)
 ;;=^^1^1^2980512^^^^
 ;;^DD(52,40,23,1,0)
 ;;=Date.  Multiple #52.3 (Add new entry without asking).
 ;;^DD(52,40,"DT")
 ;;=2930324
 ;;^DD(52.3,0)
 ;;=ACTIVITY LOG SUB-FIELD^NL^3^8
 ;;^DD(52.3,0,"DT")
 ;;=2980512
 ;;^DD(52.3,0,"NM","ACTIVITY LOG")
 ;;=
 ;;^DD(52.3,0,"UP")
 ;;=52
 ;;^DD(52.3,.01,0)
 ;;=ACTIVITY LOG^MD^^0;1^S %DT="ETX" D ^%DT S X=Y K:Y<1 X
 ;;^DD(52.3,.01,1,0)
 ;;=^.1^^0
 ;;^DD(52.3,.01,21,0)
 ;;=^^1^1^2920427^^
 ;;^DD(52.3,.01,21,1,0)
 ;;=Date when activity occured.
 ;;^DD(52.3,.01,23,0)
 ;;=^^1^1^2920427^^
 ;;^DD(52.3,.01,23,1,0)
 ;;=Date (Multiply asked).
 ;;^DD(52.3,.01,"DT")
 ;;=2920428
 ;;^DD(52.3,.02,0)
 ;;=REASON^S^H:HOLD;U:UNHOLD;C:CANCELLED;E:EDIT;L:LOST;P:PARTIAL;R:REINSTATE;W:REPRINT;S:SUSPENSED;I:RETURNED TO STOCK;V:INTERVENTION;D:DELETED;A:PENDING/DRUG INTERACTION;B:PROCESSED;^0;2^Q
