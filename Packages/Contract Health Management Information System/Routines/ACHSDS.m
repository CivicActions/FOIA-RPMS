ACHSDS ;IHS/OIT/FCJ - E-SIG DENIAL LETTERS LIST 1 of 2; 09-MAY-2022
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**30**;JUNE 11,2001 ;Build 39
 ;ACHS*3.1*30-New Routine
 ;Rtn uses LISTMAN
 ;
EN ; -- main entry point for ACHS DENIAL E-SIG
 D EN^VALM("ACHS DENIAL E-SIG")
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)="#  Patient Name              Date of Birth Service Date Reason for Denial"
 S VALMHDR(2)="         Denial Date Denial Number   Vendor"
 S VALMHDR(3)=$TR($J(" ",80)," ","-")
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0,CT=0,CT1=0,ACHSSGCT=0,ACHSNSCT=0
 S ACHSA=0
 ;TEST FOR NOT PRINTED-INX QP AND NOT SIGNED
 F  S ACHSA=$O(^ACHSDEN("AP",DUZ(2),"QP",ACHSA)) Q:ACHSA'?1N.N  D
 .Q:$P(^ACHSDEN(DUZ(2),"D",ACHSA,0),U,9)?1N.N        ;TEST FOR E-SIG IN DOC
 .Q:$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,0)),U,8)="Y"        ;TEST FOR CANCELLED
 .Q:$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,0)),U,8)="R"        ;TEST FOR REVERSED
 .S (ACHSPRG,ACHSNAM,ACHSDOB,DFN,ACHSD,ACHSDDT,ACHSSDT,ACHSVND,ACHSDREA)=""
 .S CT=CT+1
 .;CHECK FOR REGISTERED OR NON REGISTERED PATIENT
 .S ACHSPRG=$$DN^ACHS(0,6)
 .I ACHSPRG="Y" D
 ..S DFN=$$DN^ACHS(0,7)
 ..S ACHSPAT=$E(($P($G(^DPT(DFN,0)),U)),1,28)
 ..S X=$$DOB^AUPNPAT(DFN,"I") S:X ACHSDOB=$S('X:"",1:$E(X,4,5)_"-"_$E(X,6,7)_"-"_($E(X,1,3)+1700))
 .E  S ACHSPAT=$E($$DN^ACHS(10,1),1,28)
 .S ACHSD=$$DN^ACHS(0,1)
 .S X=$$DN^ACHS(0,2) S:X ACHSDDT=$E(X,4,5)_"-"_$E(X,6,7)_"-"_($E(X,1,3)+1700)
 .S X=$$DN^ACHS(0,4) S:X ACHSSDT=$E(X,4,5)_"-"_$E(X,6,7)_"-"_($E(X,1,3)+1700)
 .S:$$DN^ACHS(100,2) ACHSVND=$P($G(^AUTTVNDR($$DN^ACHS(100,2),0)),U)
 .S:$$DN^ACHS(250,1) ACHSDREA=$P($G(^ACHSDENS($$DN^ACHS(250,1),0)),U)
 .S ACHSPAT=ACHSPAT_$J("",28-$L(ACHSPAT))
 .S ACHSDOB=ACHSDOB_$J("",10-$L(ACHSDOB))
 .S ACHSDREA=ACHSDREA_$J("",25-$L(ACHSDREA))
 .S ACHSD=ACHSD_$J("",15-$L(ACHSD))
 .S ^TMP("ACHSDSN",$J,ACHSPAT,CT)=ACHSPAT_" "_ACHSDOB_" "_ACHSSDT_" "_ACHSDREA
 .S ^TMP("ACHSDSN",$J,ACHSPAT,CT,1)="          "_ACHSDDT_" "_ACHSD_" "_ACHSVND
 .S ^TMP("ACHSDSN",$J,ACHSPAT,CT,2)=DFN_U_ACHSA
 S ACHSSGCT=CT
 ;
 S CT=0,LN=0,INDXS=0
 S ACHSPAT="" F  S ACHSPAT=$O(^TMP("ACHSDSN",$J,ACHSPAT)) Q:ACHSPAT=""  D
 .S INDX=0 F  S INDX=$O(^TMP("ACHSDSN",$J,ACHSPAT,INDX)) Q:INDX'?1N.N  D
 ..I INDX'=INDXS S CT=CT+1
 ..S LN=LN+1,LNFMT=CT_$J("",3-$L(CT))
 ..S ^TMP("ACHSDS",$J,LN,0)=LNFMT_^TMP("ACHSDSN",$J,ACHSPAT,INDX)
 ..S ^TMP("ACHSDSL",$J,CT)=LN_U_^TMP("ACHSDSN",$J,ACHSPAT,INDX,2)
 ..S LN=LN+1
 ..S ^TMP("ACHSDS",$J,LN,0)=^TMP("ACHSDSN",$J,ACHSPAT,INDX,1)
 ..S INDXS=INDX
 S VALMCNT=LN
 Q
 ;
HELP ; -- help code
 K DIR
 ;S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 ;
 Q
 ;
EXPND ; -- expand code
 Q
DISPLAY ;DISPLAY THE DENIAL LETTER 
 ;
 S Y=+$$DIR^XBDIR("NO^1:"_(VALMCNT/2),"Which Denial","","","Enter the coresponding number of the denial to display",2)
 Q:$D(DTOUT)!$D(DUOUT)!(Y<1)
 S LN=+Y
 S ACHDCPAT=1,ACHDCVEN=0,ACHDCOFF=0,ACHDCFAC=0,(ACHDBDT,ACHDEDT)=0
 S DFN=$P(^TMP("ACHSDSL",$J,LN),U,2)
 S ACHSA=$P(^TMP("ACHSDSL",$J,LN),U,3),ACHDLTYP=1
 D VIEWR^XBLM("START^ACHSDNL1")
 Q
SEL ;SELECT DENIAL TO BE SIGNED
 S DIR(0)="LO^1:"_(VALMCNT/2)
 S DIR("A",1)="Enter the Item number that you Want your electronic signature applied"
 S DIR("A")="to"
 S DIR("?")="Enter Item number from the list"
 D ^DIR
 K DIR
 Q:$D(DTOUT)!$D(DUOUT)!(Y<1)
 S LN=Y(0)
 ;NOW GO THROUGH LINES AND REMOVE THE ASTERIC IN THE LINE...EXAMPLE OF Y(0)...Y(0)="1,2,3,7,"
 F I=1:1 S R=$P(LN,",",I) Q:R'?1N.N  D
 .S LN2=$P(^TMP("ACHSDSL",$J,R),U)
 .S LINE=^TMP("ACHSDS",$J,LN2,0)
 .Q:$E(LINE,1)'="*"
 .I $E(LINE,1)="*" S ^TMP("ACHSDS",$J,LN2,0)=$E(LINE,2,$L(LINE)),$P(^TMP("ACHSDSL",$J,R),U,4)=""
 .S ACHSSGCT=ACHSSGCT+1,ACHSNSCT=ACHSNSCT-1
 Q
DESEL ;DESELECT DENIAL TO BE SIGNED
 S DIR(0)="LO^1:"_(VALMCNT/2)
 S DIR("A",1)="Enter the Item number that you DO NOT want your electronic signature"
 S DIR("A")="applied to"
 S DIR("?")="Enter Item number from the list"
 D ^DIR
 K DIR
 Q:$D(DTOUT)!$D(DUOUT)!(Y<1)
 S LN=Y(0)
 ;NOW GO THROUGH LINES AND ADD AN ASTERIC TO THE LINE...EXAMPLE OF Y(0)...Y(0)="1,2,3,7,"
 F I=1:1 S R=$P(LN,",",I) Q:R'?1N.N  D
 .S LN2=$P(^TMP("ACHSDSL",$J,R),U)
 .Q:$E(^TMP("ACHSDS",$J,LN2,0),1)="*"
 .S ^TMP("ACHSDS",$J,LN2,0)="*"_^TMP("ACHSDS",$J,LN2,0),$P(^TMP("ACHSDSL",$J,R),U,4)="*"
 .S ACHSSGCT=ACHSSGCT-1,ACHSNSCT=ACHSNSCT+1
 Q
PRTL ;PRINT DENIAL LISTS
 K DIR
 S DIR(0)="N^1:2"
 S DIR("A")="Display denial list 1-Selected or 2-De-selected items"
 S DIR("?")="Enter 1 or 2 or ^ to exit"
 D ^DIR
 K DIR
 Q:$D(DTOUT)!$D(DUOUT)
 S ACHSLTY=+Y
 D VIEWR^XBLM("LST^ACHSDS")
 Q
LST ;LIST DENIALS READY TO BE SIGNED OR NOT SIGNED
 I ACHSSGCT=0,ACHSLTY=1 W !,"There are not any denials in the signed list." Q
 I ACHSNSCT=0,ACHSLTY=2 W !,"There are not any denials in the unsigned list." Q
 S L="" F  S L=$O(^TMP("ACHSDS",$J,L)) Q:L'?1N.N  D
 .S LN=^TMP("ACHSDS",$J,L,0)
 .I $E(LN,1)="*",ACHSLTY=1 S L=L+1 Q
 .I $E(LN,1)?1N,ACHSLTY=2 S L=L+1 Q
 .W !,LN,!,^TMP("ACHSDS",$J,L+1,0)
 .S L=L+1
 Q
 ; 
