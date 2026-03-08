BLREXEC5 ;IHS/OIT/MKK - IHS 2021 CKD-EPI eGFR ;23-Jan-2023 08:29;MKK
 ;;5.2;IHS LABORATORY;**1052**;NOV 01, 1997;Build 17
 ;
 ; MSC/MKK - LR*5.2*1052 - Item XXXXX - Add 2021 CKD-EPI eGFR:  race is no longer a parameter.
 ;
 ; Equation and Warnings are from the National Kidney Disease web-page (as of 06/21/2022):
 ;      https://www.kidney.org/content/ckd-epi-creatinine-equation-2021
 ;      eGFRcr = 142 x min(Scr/K, 1)^a x max(Scr/k, 1)^-1.200 x 0.9938Age x 1.012 [if female]
 ;                    Scr = standardized serum creatinine in mg/dL
 ;                    K = 0.7 (females) or 0.9 (males)
 ;                    ^ indicates next character is a superscript
 ;                    a = -0.241 (female) or -0.302 (male)
 ;                    min(Scr/?, 1) is the minimum of Scr/? or 1.0
 ;                    max(Scr/?, 1) is the maximum of Scr/? or 1.0
 ;                    Age = Age in years
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ;
CKDEPI(SCR) ; EP - SCR = Serum Creatinine in mg/dL
 ;
 Q:+$G(SCR)'>0 "N/A - SCR:NULL"   ; Cannot calculate if CREATININE not > 0.
 ;
 Q:(AGE<18) "N/A - AGE:"_AGE      ; Cannot calculate if AGE < 18.
 Q:(SEX="U")!((SEX'="M")&(SEX'="F")) "N/A - SEX:"_SEX   ; Cannot calculate if SEX is Undetermined or (Not Female AND Not Male)
 ;
 S ALPHA=$S(SEX="F":-.241,1:-.302)
 S K=$S(SEX="F":.7,1:.9)
 ;
 S SEXFACTR=$S(SEX="F":1.012,1:1)
 ;
 ; CKD-EPI Creatinine Equation (2021) calculation
 S CHKEPI=142*(($$MIN(SCR/K,1))**ALPHA)*(($$MAX(SCR/K,1))**-1.2)*(.9938**AGE)*SEXFACTR
 ;
 Q $FN(CHKEPI,"",2)  ; Round Result to 2 decimal places
 ;
MIN(VALUE,MIN) ; EP
 Q $S(VALUE<MIN:VALUE,1:MIN)
 ;
MAX(VALUE,MAX) ; EP
 Q $S(VALUE>MAX:VALUE,1:MAX)
 ;
TESTEQUA ; EP - Debug -- Allows user to TEST the equation
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S (BLRTFLAG,ONGO)="YES"
 S TAB=$J("",5),TAB2=TAB_TAB,TAB3=TAB_TAB_TAB
 S HEADER(1)="IHS LAB"
 S HEADER(2)="2021 CKD-EPI eGFR Equation Testing"
 ;
 F  Q:ONGO'="YES"  D
 . Q:$$GETSEX(.SEX)="Q"
 . Q:$$GETAGE(.AGE)="Q"
 . Q:$$GETCREAT(.CREATININE)="Q"
 . ;
 . D HEADERDT^BLRGMENU
 . W $$RJ^XLFSTR("SEX:",16),SEX,!
 . W $$RJ^XLFSTR("AGE:",16),AGE,!
 . W $$RJ^XLFSTR("Creatinine:",16),CREATININE_" mg/dL"
 . W !!
 . W TAB2,"2021 CKD-EPI eGFR Equation = ",$$CKDEPI(CREATININE),!!
 . ;
 . D ^XBFMK
 . S DIR(0)="YO"
 . S DIR("A")=TAB3_"Again"
 . S DIR("B")="NO"
 . D ^DIR
 . S ONGO=$S(Y=1:"YES",1:"NO")
 ;
 Q
 ;
GETSEX(SEX) ; EP - Get Sex function
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="SO^1:F;2:M;3:U"
 S DIR("L",1)=TAB_"Select Sex:"
 S DIR("L",2)=TAB2_"1: FEMALE"
 S DIR("L",3)=TAB2_"2: MALE"
 S DIR("L",4)=TAB2_"3: UNKNOWN"
 S DIR("L")=""
 S DIR("A")=TAB3_"SEX"
 D ^DIR
 ;
 I Y<1!(+$G(DIRUT)) D GQMFDIRR  S ONGO="NO"  Q "Q"
 ;
 I +X S SEX=$S(X=1:"F",X=2:"M",1:"U")
 E  S SEX=$$UP^XLFSTR($E(X))
 Q "OK"
 ;
GETAGE(AGE) ; EP - Age Function
 D HEADERDT^BLRGMENU
 D ^XBFMK
 W TAB,"Select Age:"
 S DIR(0)="NO^18:150"
 S DIR("A")=TAB3_"AGE"
 D ^DIR
 ;
 I Y<1!(+$G(DIRUT)) D GQMFDIRR  S ONGO="NO"  Q "Q"
 ;
 S AGE=Y
 Q "OK"
 ;
GETCREAT(CREATININE) ; EP - Creatinine function
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="NO^::2"
 S DIR("A")=TAB3_"Enter Creatinine Value (mg/dL Units)"
 D ^DIR
 ;
 I X=""!(+$G(DIRUT)) D GQMFDIRR  S ONGO="NO"  Q "Q"
 ;
 S CREATININE=+Y
 Q "OK"
 ;
 ;
NEWDELTA ; EP - Allows users to create new Delta Check utilizing the CKD-EPI (2021) function
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS("NEWDELTA")
 ;
 S HEADER(1)="IHS LAB"
 S HEADER(2)="2021 CKD-EPI Delta Check Creation"
 D HEADERDT^BLRGMENU
 ;
 D ^XBFMK
 S DIR(0)="PO^60:EMZ"
 S DIR("A")="Test to hold 2021 CKD-EPI Results"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S F60EGFR=+Y
 S CKDEPI60=$P(Y,"^",2)
 S CKDEPIDN=$$GET1^DIQ(60,F60EGFR,"DATA NAME")
 I $L(CKDEPIDN)<1 D BADSTUFF("Test "_CKDEPIDN_" has no DataName.")  Q
 ;
 S CKDPIDNI=$$GET1^DIQ(60,F60EGFR,"DATA NAME","I")
 ;
 D HEADERDT^BLRGMENU
 S DIR(0)="PO^61:EMZ"
 S DIR("A")="SITE/SPECIMEN of "_CKDEPI60_" Test to use for Ref Ranges"
 D ^DIR
 I +$G(DIRUT) D BADSTUFF("No Ref Ranges Will be Added.")
 ;
 S SSIEN=+Y,SSDESC=$P(Y,U,2)
 ;
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="PO^60:EMZ"
 S DIR("A")="Creatinine Test to use for 2021 CKD-EPI calculation"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S F60CREAT=+Y
 S CREAT60=$P(Y,"^",2)
 S CREATDN=$$GET1^DIQ(60,F60CREAT,"DATA NAME")
 I $L(CREATDN)<1 D BADSTUFF("Test "_CREAT60_" has no DataName.")  Q
 ;
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="FO"
 S DIR("A")="Create a name for the Delta Check"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S NAME=$G(X)
 ;
 ; Make sure it's not a duplicate Delta Check Name
 I +$O(^LAB(62.1,"B",NAME,0)) D BADSTUFF(NAME_" is a duplicate Delta Check Name.")  Q
 ;
 S XCODE="S %X="""" X:$D(LRDEL(1)) LRDEL(1) W:$G(%X)'="""" ""  CKD-EPI (2021) Calculated GFR:"",$P(%X,U) S:+$G(%X)>0 LRSB($$GETDNAM^BLREXEC5("""_CKDEPI60_"""))=%X K %,%X,%Y,%YY,%Z,%ZZ"
 S OVER1STR="S %ZZ=$$GETDNAM^BLREXEC5("""_CREAT60_""")"
 S OVER1=OVER1STR_" S %X=$$CKDEPI^BLREXEC5(X) S %X=%X_$$REFUN^BLREXEC5("_F60EGFR_","_SSIEN_",%X)"
 ;S TAB
 ;
 D SETDESC
 ;
 D WARNING
 ;
 D HEADERDT^BLRGMENU
 ;
 D DLTADICA(NAME,XCODE,OVER1,.DESC)
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
SETDESC ; EP - Setup DESC array
 S CNT=0,TAB=$J("",5)
 K DESC
 D DESCADD(.DESC,.CNT,"This delta check, when added to a test named ")
 D DESCADD(.DESC,.CNT,$$LJ^XLFSTR(TAB_CREAT60,72)_".")  ; Done to ensure DESCRIPTION field in DELTA CHECKS dictionary displays this on a seperate line
 D DESCADD(.DESC,.CNT,"will calculate an estimated Glomerular Filtration Rate (GFR)")
 D DESCADD(.DESC,.CNT,"using the CKD-EPI (2021) equation.")
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,"The CKD-EPI (2021) Equation's result will be stuffed into the test called")
 D DESCADD(.DESC,.CNT,TAB_CKDEPI60_".")
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,"The National Kidney Foundation CKD-EPI (2021) equation is listed")
 D DESCADD(.DESC,.CNT,"(as of 08/30/2022) at:")
 D DESCADD(.DESC,.CNT,TAB_"https://www.kidney.org/content/ckd-epi-creatinine-equation-2021")
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,"The equation is: ")
 D DESCADD(.DESC,.CNT,TAB_"eGFRcr = 142 x min(Scr/K,1)^a x max(Scr/K,1)^-1.200 x ")
 D DESCADD(.DESC,.CNT,TAB_"0.9938^Age x 1.012 [if female]")
 D DESCADD(.DESC,.CNT,TAB_TAB_"Scr = standardized serum creatinine in mg/dL")
 D DESCADD(.DESC,.CNT,TAB_TAB_"K = 0.7 (females) or 0.9 (males)")
 D DESCADD(.DESC,.CNT,TAB_TAB_"^ = indicates next character is a superscript")
 D DESCADD(.DESC,.CNT,TAB_TAB_"a = -0.241 (female) or -0.302 (male)")
 D DESCADD(.DESC,.CNT,TAB_TAB_"min(Scr/K, 1) is the minimum of Scr/K or 1.0")
 D DESCADD(.DESC,.CNT,TAB_TAB_"max(Scr/K, 1) is the maximum of Scr/K or 1.0")
 D DESCADD(.DESC,.CNT,TAB_TAB_"Age = Age in years")
 D DESCADD(.DESC,.CNT," ")
 Q
 ;
WARNING ; EP - Warning from National Kidney Disease web-page (as of 06/21/2022)
 D DESCADD(.DESC,.CNT,"Creatinine-based estimating equations are not recommended")
 D DESCADD(.DESC,.CNT,"for use with:")
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,TAB_"Individuals less than 18 years old.")
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,TAB_"Individuals with unstable creatinine concentrations.")
 D DESCADD(.DESC,.CNT,TAB_"This includes pregnant women; persons with serious")
 D DESCADD(.DESC,.CNT,TAB_"co-morbid conditions; and hospitalized patients,")
 D DESCADD(.DESC,.CNT,TAB_"particularly those with acute renal failure.")
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,TAB_"Persons with extremes in muscle mass and diet. This")
 D DESCADD(.DESC,.CNT,TAB_"includes, but is not limited to, individuals who are")
 D DESCADD(.DESC,.CNT,TAB_"amputees, paraplegics, body builders, or obese; persons")
 D DESCADD(.DESC,.CNT,TAB_"who have a muscle-wasting disease or a neuromuscular")
 D DESCADD(.DESC,.CNT,TAB_"disorder; and those suffering from malnutrition, eating")
 D DESCADD(.DESC,.CNT,TAB_"a vegetarian or low-meat diet, or taking creatinine dietary")
 D DESCADD(.DESC,.CNT,TAB_"supplements.")
 Q
 ;
DLTADICA(NAME,XCODE,OVER1,DESC) ; EP
 NEW DICT0,DICT1,FDA,ERRS,PTR
 NEW HEREYAGO,SNARRAY
 ;
 W !!,"Adding "_NAME_" to Delta Check Dictionary.",!
 ;
 D ^XBFMK
 K ERRS,FDA,IENS,DIE
 ;
 S DICT1="62.1"
 S FDA(DICT1,"?+1,",.01)=NAME   ; Find the Name node, or create it.
 S FDA(DICT1,"?+1,",10)=XCODE   ; Execute Code
 S FDA(DICT1,"?+1,",20)=OVER1   ; Overflow 1
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . W !,?5,"Error in adding "_NAME_" to the Delta Check Dictionary.",!
 . W ?10,"ERROR:",$G(ERRS("DIERR",1,"TEXT",1)),!
 . D PRESSKEY^BLRGMENU(4)
 ;
 W !,?5,NAME_" Delta Check added to Delta Check Dictionary.",!
 ;
 S PTR=$$FIND1^DIC(62.1,,,NAME)  ; Get Delta Check IEN
 ;
 ; Now, add the Description
 I $D(DESC) D
 . K ERRS,WPARRAY
 . M WPARRAY("WP")=DESC
 . D WP^DIE(62.1,PTR_",",30,"K","WPARRAY(""WP"")","ERRS")
 . ;
 . I $D(ERRS("DIERR"))>0 D  Q
 .. W !!,"Error in adding DESCRIPTION to "_NAME_" Delta Check in the Delta Check Dictionary."
 .. D BADSTUFF("")
 . ;
 . W !,?5,NAME_" Delta Check DESCRIPTION added to Delta Check Dictionary.",!
 ;
 ; Now, add the SITE NOTES DATE
 K ERRS,FDA
 S FDA(62.131,"?+1,"_PTR_",",.01)=$P($$NOW^XLFDT,".",1)
 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . W !!,"Error in adding SITES NOTES DATE to "_NAME_" Delta Check in the Delta Check Dictionary."
 . D BADSTUFF("")
 ;
 ; Now, add the TEXT
 K ERRS,WPARRAY
 S SNARRAY("WP",1)="Created by "_$$GET1^DIQ(200,DUZ,"NAME")_"     DUZ:"_DUZ
 D WP^DIE(62.131,"1,"_PTR_",",1,"K","SNARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . W !!,"Error in adding TEXT to "_NAME_" Delta Check in the Delta Check Dictionary."
 . D BADSTUFF("")
 ;
 W !,?5,NAME_" Delta Check SITE NOTES TEXT added to Delta Check Dictionary."
 Q
 ;
 ;
REFUN(GFRTEST,F61IEN,VALUE) ; EP - Return Abnormal Flag & Ref Low & High & Units
 NEW F60IEN,FLAG,REFL,REFH,RETSTR,RETSTR5,SSIEN,SITESPEC,STR,UNITS
 ;
 ; If GFRTEST = text, then use $$FIND1 to set F60IEN else just set F60IEN
 I +GFRTEST<1 S F60IEN=$$FIND1^DIC(60,,"O",GFRTEST)
 E  S F60IEN=GFRTEST
 ;
 S SSIEN=$O(^LAB(60,F60IEN,1,"B",F61IEN,0))
 S STR=$G(^LAB(60,F60IEN,1,SSIEN,0))
 S SITESPEC=$P(STR,U)
 S REFL=$P(STR,U,2)
 S REFH=$P(STR,U,3)
 S FLAG=""
 S:REFL FLAG=$S(VALUE<REFL:"L",1:"")
 S:REFH FLAG=$S(VALUE>REFH:"H",1:"")
 S UNITS=$P(STR,U,7)
 ;
 S RETSTR=U_FLAG
 S RETSTR5=$S(SITESPEC:SITESPEC,1:"")
 S $P(RETSTR5,"!",2)=REFL
 S $P(RETSTR5,"!",3)=REFH
 S $P(RETSTR5,"!",7)=UNITS
 S $P(RETSTR,U,5)=RETSTR5
 ;
 Q RETSTR
 ;
 ;
BBDELTA ;  EP - Create new Bare-Bones Delta Check utilizing the CKD-EPI (2021) function
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS("NEWDELTA")
 ;
 S HEADER(1)="IHS LAB"
 S HEADER(2)="CKD-EPI Delta Check (2021) Creation"
 D HEADERDT^BLRGMENU
 ;
 D ^XBFMK
 S DIR(0)="PO^60:EMZ"
 S DIR("A")="Test to hold CKD-EPI (2021) Results"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S F60EGFR=+Y
 S CKDEPI60=$P(Y,"^",2)
 S CKDEPIDN=$$GET1^DIQ(60,F60EGFR,"DATA NAME")
 I $L(CKDEPIDN)<1 D BADSTUFF("Test "_CKDEPIDN_" has no DataName.")  Q
 ;
 S CKDPIDNI=$$GET1^DIQ(60,F60EGFR,"DATA NAME","I")
 ;
 D HEADERDT^BLRGMENU
 S DIR(0)="PO^61:EMZ"
 S DIR("A")="SITE/SPECIMEN of "_CKDEPI60_" Test to use for Ref Ranges"
 D ^DIR
 I +$G(DIRUT) D BADSTUFF("No Ref Ranges Will be Added.")
 ;
 S SSIEN=+Y,SSDESC=$P(Y,U,2)
 ;
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="PO^60:EMZ"
 S DIR("A")="Creatinine Test to use for CKD-EPI (2021) calculation"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S F60CREAT=+Y
 S CREAT60=$P(Y,"^",2)
 S CREATDN=$$GET1^DIQ(60,F60CREAT,"DATA NAME")
 I $L(CREATDN)<1 D BADSTUFF("Test "_CREAT60_" has no DataName.")  Q
 ;
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="FO"
 S DIR("A")="Name of the Delta Check"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S NAME=$G(X)
 ;
 ; Make sure it's not a duplicate Delta Check Name
 I +$O(^LAB(62.1,"B",NAME,0)) D BADSTUFF(NAME_" is a duplicate Delta Check Name.")  Q
 ;
 S XCODE="S %X="""" X:$D(LRDEL(1)) LRDEL(1) W:$G(%X)'="""" ""  CKD-EPI (2021) Calculated GFR:"",$P(%X,U) S:+$G(%X)>0 LRSB($$GETDNAM^BLREXEC5("""_CKDEPI60_"""))=%X K %,%X,%Y,%YY,%Z,%ZZ"
 S OVER1STR="S %ZZ=$$GETDNAM^BLREXEC5("""_CREAT60_""")"
 S OVER1=OVER1STR_" S %X=$$CKDEPI^BLREXEC5(X) S %X=%X_$$REFUN^BLREXEC5("_F60EGFR_","_SSIEN_",%X)"
 ;
 D DLTADICA(NAME,XCODE,OVER1,.DESC)
 Q
 ;
 ;
 ; ============================= UTILITIES =============================
 ;
JUSTNEW ; EP - Generic RPMS EXCLUSIVE NEW
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q
 ;
SETBLRVS(TWO) ; EP - Set the BLRVERN variable(s)
 K BLRVERN,BLRVERN2
 ;
 S BLRVERN=$P($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=$G(TWO)
 Q
 ;
GQMFDIRR ; Generic "Quit" message for D ^DIR response
 D BADSTUFF("No/Invalid/Quit Entry.")
 Q
 ;
BADSTUFF(MSG,TAB) ; EP - Simple Message
 S:+$G(TAB)<1 TAB=4
 W !!,?TAB,$$TRIM^XLFSTR(MSG,"LR"," "),"  Routine Ends."
 D PRESSKEY^BLRGMENU(TAB+5)
 Q
 ;
DESCADD(DESC,CNT,STR) ; EP - Add Data to DESC Array
 S CNT=CNT+1
 S DESC(CNT)=STR
 Q
 ;
DESCADD2(DESC,CNT,STR,TAB) ; EP - Add Data to DESC Array
 S CNT=CNT+1
 S DESC(CNT)=$S($G(TAB):$J("",TAB),1:"")_STR
 Q
 ;
QUIKTEST ; EP
 I +GFRTEST<1 S F60IEN=$$FIND1^DIC(60,,"O",GFRTEST)
 E  S F60IEN=GFRTEST
 W !!,"GFRTEST = ",GFRTEST,!
 W ?4,"F60IEN=",F60IEN,!
 Q
 ;
GETDNAM(F60TEST) ; EP - Return DataName IEN from File 60 IEN
 NEW F60IEN
 ;
 ; If F60TEST = text, then use $$FIND1 to set F60IEN else just set F60IEN
 I F60TEST'?.N S F60IEN=$$FIND1^DIC(60,,"O",F60TEST)
 E  S F60IEN=F60TEST
 ;
 Q $$GET1^DIQ(60,F60IEN,"DATA NAME","I")
 ;
