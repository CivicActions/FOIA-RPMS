DDWK ;SFISC/MKO-SCREEN EDITOR MAIN ROUTINE ;1:04 PM  18 Oct 1995 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**11**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;
GETKEY ;Get key sequences and defaults
 N AU,AD,AR,AL,F1,F2,F3,F4
 N FIND,REMOVE,PREVSC,NEXTSC
 N I,K,N,T
 S AU=$P(DDGLKEY,U,2)
 S AD=$P(DDGLKEY,U,3)
 S AR=$P(DDGLKEY,U,4)
 S AL=$P(DDGLKEY,U,5)
 S F1=$P(DDGLKEY,U,6)
 S F2=$P(DDGLKEY,U,7)
 S F3=$P(DDGLKEY,U,8)
 S F4=$P(DDGLKEY,U,9)
 S FIND=$P(DDGLKEY,U,10)
 S REMOVE=$P(DDGLKEY,U,13)
 S PREVSC=$P(DDGLKEY,U,14)
 S NEXTSC=$P(DDGLKEY,U,15)
 ;
 S DDW("IN")="",DDW("OUT")=""
 F I=1:1 S T=$P($T(MAP+I),";;",2,999) Q:T=""  D
 . S @("K="_$P(T,";",2))
 . I DDW("IN")'[(U_K),K]"" D
 .. S DDW("IN")=DDW("IN")_U_K
 .. S DDW("OUT")=DDW("OUT")_$P(T,";")_U
 S DDW("IN")=DDW("IN")_U
 S DDW("OUT")=$E(DDW("OUT"),1,$L(DDW("OUT"))-1)
 Q
 ;
MAP ;Keys for main screen
 ;;UP;AU
 ;;DN;AD
 ;;RT;AR
 ;;LT;AL
 ;;TAB;$C(9)
 ;;PUP;F1_AU
 ;;PUP;PREVSC
 ;;PDN;F1_AD
 ;;PDN;NEXTSC
 ;;JLT;F1_AL
 ;;JRT;F1_AR
 ;;LB;F1_F1_AL
 ;;LE;F1_F1_AR
 ;;TOP;F1_"T"
 ;;BOT;F1_"B"
 ;;WRT;F1_" "
 ;;WRT;$C(12)
 ;;WLT;$C(10)
 ;;RUB;$C(127)
 ;;RUB;$C(8)
 ;;DEL;REMOVE
 ;;DEL;F4
 ;;DEOL;F1_F2
 ;;BRK;$C(13)
 ;;JN;F1_"J"
 ;;RFT;F1_"R"
 ;;ST;F1_"?"
 ;;XLN;F1_"D"
 ;;TST;F1_$C(9)
 ;;LST;F1_","
 ;;RST;F1_"."
 ;;WRM;F2
 ;;RPM;F3
 ;;SV;F1_"S"
 ;;SW;F1_"A"
 ;;EX;F1_"E"
 ;;QT;F1_"Q"
 ;;HLP;F1_"H"
 ;;DLW;$C(23)
 ;;MRK;F1_"M"
 ;;UMK;F1_F1_"M"
 ;;CUT;F1_"X"
 ;;CPY;F1_"C"
 ;;PST;F1_"V"
 ;;FND;F1_"F"
 ;;FND;FIND
 ;;NXT;F1_"N"
 ;;GTO;F1_"G"
 ;;CHG;F1_"P"
 ;;';$C(27)_"Q"
 ;;';$C(27)_"R"
 ;;";$C(27)_"S"
 ;;";$C(27)_"T"
 ;;
