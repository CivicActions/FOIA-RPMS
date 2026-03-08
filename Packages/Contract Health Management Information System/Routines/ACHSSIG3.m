ACHSSIG3 ;IHS.OIT.FCJ-ELECTRONIC SIGNATURE FOR DENIAL LETTERS [ 01/11/2005  7:33 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**30**;JUNE 11,2001 ;Build 39
 ;ACHS*3.1*30-New Routine
 ;
 ;
ST ;EP FROM MENU OPTION
 ;CHECK ESIG AND USER AUTHORIZED
 D SIG^XUSESIG I X1="" D SIGERR G EXT
 D CHKUSR I ACHSQ D RTRN^ACHS G EXT
 ;CHECK PARAMETER AND QUEUE
 S ACHSESDT=$P($G(^ACHSESIG(DUZ(2),0)),U,4)
 I ('ACHSESDT)!(ACHSESDT>DT) W !!,?5,"The Denial E-Signature Parameter start date has not been",!?5,"set up for your facility.",! D RTRN^ACHS G EXT
 I $P(^ACHSDENR(DUZ(2),0),U,14)<1 W !!?5,"There are not any Denial Letters in the queue to be signed.",! D RTRN^ACHS G EXT
 D LSTDEN
 D DOCTOT
 G EXT
 Q
 ;
EXT ;
 D EN^XBVK("VALM")
 D EN^XBVK("ACHS")
 K ^TMP("ACHSDS",$J),^TMP("ACHSDSN",$J),^TMP("ACHSDSL",$J)
 K INDX,INDXS,CT,LN,LNFMT
 D ^ACHSVAR
 Q
 ;
LSTDEN ;LIST DENIALS USING LISTMAN
 K ^TMP("ACHSDS",$J),^TMP("ACHSDSL",$J),^TMP("ACHSDSN",$J)
 D EN^VALM("ACHS DENIAL E-SIG")
 D CLEAR^VALM1
 Q
 ;
DOCTOT ; ELECTRONIC DOCUMENT TOTALS
  ;S ACHSSGCT=10  ;used for testing this section
  ;S ACHSNSCT=5   ;used for testing this section
  W !?10,"Number of Denials Electronically signed = ",ACHSSGCT
  W !?10,"Number of Denials NOT Electronically signed = ",ACHSNSCT
  S L="" F  S L=$O(^TMP("ACHSDS",$J,L)) Q:L'?1N.N  D
  .S LN=^TMP("ACHSDS",$J,L,0)
  .I $E(LN,1)="*" W !?15,$E(LN,4,32)
  S %=$$DIR^XBDIR("Y","Do you want ALL selected documents stamped with your electronic signature","","","","",2)
  I 'Y D  Q
  .W !!?10,"Please Note all Selections/De-Selections have been lost.",!
  .I $$DIR^XBDIR("FO","          Press any key to exit")
SIGN ;--ADD THE USER AND DATE SIGNED and totals
 ;        0;9         .09    -E-SIGNATURE OFFICIAL
 ;        0;11        .11    -E-SIGNATURE DATE SIGNED
 S LN="",CT=0
 F  S LN=$O(^TMP("ACHSDSL",$J,LN)) Q:LN'?1N.N  D
 .Q:$P(^TMP("ACHSDSL",$J,LN),U,4)="*"
 .S ACHSA=$P(^TMP("ACHSDSL",$J,LN),U,3)
 .S DA=ACHSA,DA(1)=DUZ(2),DIE="^ACHSDEN("_DUZ(2)_",""D"","
 .S DR=".09////"_DUZ_";.11////"_DT
 .D ^DIE
 .S CT=CT+1
 K DIC,DIE,DA,DR,D
 I CT'=ACHSSGCT D
 .W !,"All Denials were not signed, please use the e-sig option to review" H 2
 .S ACHSSGCT=ACHSSGCT-CT
 .S ACHSNSCT=ACHSNSCT+CT
 S ACHSNSCT=$P(^ACHSDENR(DUZ(2),0),U,14)-ACHSSGCT
 S ACHSSGCT=ACHSSGCT+$P(^ACHSDENR(DUZ(2),0),U,15)
 S DIE="^ACHSDENR(",DA=DUZ(2)
 S DR=".14////"_ACHSNSCT_";.15////"_ACHSSGCT
 D ^DIE
 K DIC,DIE,DA,DR,D
 I CT=0 W !?10,"There are not any documents selected to be signed."
 E  W !?10,"Documents have been signed and are ready for printing."
 I $$DIR^XBDIR("FO","          Press any key to exit")
 Q
 ;
CHKUSR ;--IS THE USER AUTHORIZED IN THE E-SIG PARM FILE--
 N BEG,END
 S ACHSQ="",ACHSAU="",ACHSAUTH=""
 S ACHSAU=$O(^ACHSESIG(DUZ(2),1,"B",DUZ,ACHSAU))
 I 'ACHSAU S ACHSQ=1 D USRERR Q
 S ACHSAUTH=$P(^ACHSESIG(DUZ(2),1,ACHSAU,0),U,7) I ACHSAUTH'="Y" S ACHSQ=1 D USRERR Q
 ;TEST DATES AUTH
 S BEG=$P(^ACHSESIG(DUZ(2),1,ACHSAU,0),U,8),END=$P(^ACHSESIG(DUZ(2),1,ACHSAU,0),U,9)
 I (BEG="")!(BEG>DT) S ACHSQ=1 D USRERR Q
 I END?1N.N,DT>END S ACHSQ=1 D USRERR Q
 Q
USRERR ;
 W !!,"You are not authorized in the CHS E-SIG file to sign Denial Letters.",!
 Q
 ;
SIGERR ; ELECTRONIC SIG NOT FOUND
  W !?10 F L=1:1:50 W "*"
  W !?10,"*",?17,"Electronic Signature Code not found.",?59,"*",!
  W ?10,"*",?14,"Please contact site manager for assistance.",?59,"*",!
  W ?10,"*",?59,"*",!
  W ?10 F L=1:1:50 W "*"
  I IOST["C-",'$D(IO("S")) S Y=$$DIR^XBDIR("E","","","","",1)
  Q
