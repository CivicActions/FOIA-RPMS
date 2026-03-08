ACHSEOBN ; IHS/ADC/GTH - PROCESS EOBRS extention of ACHSEOB3 ; [ 06/12/2000   8:30 AM ]
 ;;3.0;CONTRACT HEALTH MGMT SYSTEM;**17**;SEP 17, 1997
 ;
 ;ACHS*3*17 created this routine by splitting ACHSEOB3
 ;
SENDMSG ;
 NEW X,Y,Z
 KILL ^TMP("ACHSEOB3")
 F X=1:1 S Y=$P($T(TXT+X),";;",2) Q:Y="###"  S Z="" X:$L($P(Y,";",2)) $P(Y,";",2) S ^TMP("ACHSEOB3",$J,X)=$P(Y,";",1)_Z
 KILL X,Y,Z
 NEW XMSUB,XMDUZ,XMTEXT,XMY
 S XMB="ACHS EOBR PROCESSING"
 S XMDUZ="CHS EOBR Automatic Processing",XMSUB="3P Pay on EOBR, no Insurance in Reg."
 S XMTEXT="^TMP(""ACHSEOB3"",$J,"
 S XMY(1)=""
 D ^XMB,KILL^XM
 KILL ^TMP("ACHSEOB3")
 Q
 ;
TXT ;
 ;;During automatic processing of CHS EOBRs, an EOBR was found
 ;;to have a payment from a Third Party Source, and no insurance
 ;;for the patient was effective for the patient on the DOS, in
 ;;your local Patient Registration files.  Specific info:
 ;;       EOBR Control Number :  ;S Z=ACHSEOBR("A",13)_"-"_ACHSEOBR("A",5)
 ;;     Purchase Order Number :  ;S Z=ACHSEOBR("A",12)
 ;;              Patient Name :  ;S Z=ACHSEOBR("B",8)
 ;;                       HRN :  ;S Z=ACHSEOBR("B",9)
 ;;Amount Paid by Third Party :  $;S Z=$FN($E(ACHSEOBR("D",11),1,7)_"."_$E(ACHSEOBR("D",11),8,9),",",2)
 ;; 
 ;;The current EOBR data does not include the Third Party source.
 ;;If you want that information, contact the Fiscal Intemediary.
 ;;Your area CHS Officer can provide you with contacts at the FI.
 ;;###
 ;
