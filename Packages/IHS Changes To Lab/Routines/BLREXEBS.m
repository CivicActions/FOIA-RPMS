BLREXEBS ;IHS/MSC/MKK - IHS "BEDSIDE SCHWARTZ" eGFR for Children (AGE < 18) ; 04-Aug-2022 12:15 ; MKK
 ;;5.2;IHS LABORATORY;**1052**;NOV 01, 1997;Build 17
 ;
 ; MSC/MKK - LR*5.2*1052 - Item 75281 - Add estimated eGFR "Bedside Schwartz" calculation for children.
 ;
 ; Equation is from the National Kidney Foundation website:
 ;      https://www.kidney.org/content/creatinine-based-%E2%80%9Cbedside-schwartz%E2%80%9D-equation-2009
 ;
 ; The formula is:
 ; 	GFR (mL/min/1.73 m²) = (0.41 × Height in cm) / Creatinine in mg/dL
 ;
 ; Because children grow quickly (approximately .5292 cm/month), it has been
 ; decided that eGFR should not be calculated if the last height measurement
 ; is more than 90 days old.
 ;
 ; The National Kidney Disease website has this caveat:
 ;      The combined effect of IDMS-traceable calibration and an erroneous
 ;      correction for serum proteins can cause a relatively large error in
 ;      the estimated GFR that is more pronounced in very young children under
 ;      the age of 2.
 ;
 Q
 ;
GFRBDSCH(CRET) ; EP
 NEW BADCREAT
 ;
 S BADCREAT="Creatinine.Invalid"
 ;
 I $TR($G(CRET)," ")="" Q BADCREAT   ; If creatinine null, then quit
 ;
 ; If 1st character not numeric, then quit
 I $G(CRET)?1A.A Q BADCREAT
 ;
 ; Following lines added to handle errors sent by some instruments
 ; Quit if any are true
 I $E($G(CRET))="" Q BADCREAT       ; If Null
 I $E($G(CRET))="#" Q BADCREAT      ; Out of Range
 I $E($G(CRET))="<" Q BADCREAT      ; Vitros results with "<"
 I ($G(CRET))="-" Q BADCREAT        ; Negative results
 ;
 I +$G(CRET)=0 Q BADCREAT           ; If zero results, then quit
 ;
 I +$G(AGE)<0 Q "No.Age"
 ;
 ; DYS = Days; MOS = Months
 I AGE'["DYS",AGE'["MOS",AGE>17 Q "Pt.Too.Old"
 ;
 S HEIGHT=$$GETHTVM()     ; Use V MEASUREMENT file
 I HEIGHT<0 Q "Ht.Too.Old"
 I HEIGHT=0 Q "Ht.Zero"
 ;
 ; GFR (mL/min/1.73 m²) = (0.41 × Height in cm) / Creatinine in mg/dL
 S EGFR=(HEIGHT*.41)/CRET      ; Measurement already in centimeters.
 Q $FN(EGFR,"",2)              ; Only 2 decimal places.
 ;
 ;
GETHTVM() ; EP - Get HEIGHT; ENTRYDTT = Entry Date/Time for latest HT measurement in V MEASUREMENT file
 ; 
 NEW DATEARRY,DATENTER,ENTRYDTT,IEN,VALUE
 ;
 S IEN="A"
 F  S IEN=$O(^AUPNVMSR("AC",DFN,IEN),-1)  Q:IEN<1  D    ; Order through V MEASUREMENT file
 . Q:$$GET1^DIQ(9000010.01,IEN,"TYPE")'="HT"
 . ;
 . S VALUE=$$GET1^DIQ(9000010.01,IEN,"VALUE")
 . Q:VALUE<1
 . ;
 . S DATENTER=$$GET1^DIQ(9000010.01,IEN,"DATE/TIME VITALS ENTERED","I")
 . Q:DATENTER<1
 . ;
 . S DATEARRY(DATENTER)=(VALUE*2.54)     ; Convert inches to centimeters
 ;
 I $D(DATEARRY)<1 S ENTRYDTT=""  Q 0     ; If no HEIGHT Measurement, return zero
 ;
 S ENTRYDTT=$O(DATEARRY("A"),-1)
 I $$FMDIFF^XLFDT($$NOW^XLFDT,ENTRYDTT)>90 Q -1  ; HEIGHT Measurement too old
 ;
 Q $G(DATEARRY(ENTRYDTT))
 ;
 ;
GMRVGHT(ENTRYDTT) ; EP - GMRV VITAL MEASUREMENT file - Get HEIGHT
 ; ENTRYDTT Set to Entry Date/Time for latest HT measurement
 ; 
 NEW DATEARRY,DATENTER,IEN,VALUE
 ;
 S VTYPEHT=$$FIND1^DIC(120.51,,"O","HEIGHT")
 ;
 S IEN="A"
 F  S IEN=$O(^GMR(120.5,"C",DFN,IEN),-1)  Q:IEN<1  D    ; Order through GMRV VITAL MEASUREMENT file
 . Q:$$GET1^DIQ(120.5,IEN,"VITAL TYPE","I")'=VTYPEHT
 . ;
 . S VALUE=$$GET1^DIQ(120.5,IEN,"RATE")
 . Q:VALUE<1
 . ;
 . S DATENTER=$$GET1^DIQ(120.5,IEN,"DATE/TIME VITALS TAKEN","I")
 . Q:DATENTER<1
 . ;
 . S DATEARRY(DATENTER)=(VALUE*2.54)     ; Convert inches to centimeters
 ;
 I $D(DATEARRY)<1 S ENTRYDTT=""  Q 0     ; If no HEIGHT Measurement, return zero
 ;
 S ENTRYDTT=$O(DATEARRY("A"),-1)
 I $$FMDIFF^XLFDT($$NOW^XLFDT,ENTRYDTT)>30 Q -1  ; HEIGHT Measurement too old
 ;
 Q $G(DATEARRY(ENTRYDTT))
 ;
 ;
NEWDELTA ; EP - Allows users to create new Delta Check utilizing the Bedside Schwartz eGFR function
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS("NEWDELTA")
 ;
 S HEADER(1)="IHS LAB"
 S HEADER(2)="Bedside Schwartz Delta Check Creation"
 D HEADERDT^BLRGMENU
 ;
 D ^XBFMK
 S DIR(0)="PO^60:EMZ"
 S DIR("A")="Test to hold Bedside Schwartz Results"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S BSEGFRI=$P(Y,U)
 S BSEGFRD=$P(Y,U,2)
 S CKDEPIDN=$$GET1^DIQ(60,BSEGFRI,"DATA NAME")
 I $L(CKDEPIDN)<1 D BADSTUFF("Test "_BSEGFRD_" has no DataName.")  Q
 ;
 D HEADERDT^BLRGMENU
 S DIR(0)="PO^61:EMZ"
 S DIR("A")="SITE/SPECIMEN of "_BSEGFRD_" Test to use for Ref Ranges"
 D ^DIR
 I +$G(DIRUT) D BADSTUFF("No Ref Ranges Will be Added.")
 ;
 S SSIEN=+Y,SSDESC=$P(Y,U,2)
 ;
 D HEADERDT^BLRGMENU
 D ^XBFMK
 S DIR(0)="PO^60:EMZ"
 S DIR("A")="Creatinine Test to use for Bedside Schwartz calculation"
 D ^DIR
 I +$G(DIRUT) D GQMFDIRR  Q
 ;
 S CREAT60I=$P(Y,U)
 S CREAT60D=$P(Y,U,2)
 S CREATDN=$$GET1^DIQ(60,CREAT60I,"DATA NAME")
 I $L(CREATDN)<1 D BADSTUFF("Test "_CREAT60D_" has no DataName.")  Q
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
 I $$FIND1^DIC(62.1,,"O",NAME) D BADSTUFF(NAME_" is a duplicate Delta Check Name.")  Q
 ;
ADDIT ; EP - ADDIT Line Label
 S XCODE="S %X="""" X:$D(LRDEL(1)) LRDEL(1) W:$G(%X)'="""" ""  Bedside Schwartz Calculated GFR:"",%X S:LRVRM>10 LRSB($$GETDNAM^BLREXEC2("""_CKDEPIDN_"""))=%X K %,%X,%Y,%Z,%ZZ"
 S OVER1STR="S %ZZ=$$GETDNAM^BLREXEC2("""_CREAT60I_""") X:LRVRM>10 ""F %=%ZZ S %X(%)=$S(%=LRSB:X,$D(LRSB(%)):+LRSB(%),1:0)"" X:LRVRM>10 ""F %=%ZZ S %X(%)=$S($D(LRSB(%)):LRSB(%),1:0)"""
 S OVER1=OVER1STR_" S %X=$$GFRBDSCH^BLREXEBS(X) S %X=%X_$$REFUN^BLREXEC5("_BSEGFRI_","_SSIEN_",%X)"
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
DLTADICA(NAME,XCODE,OVER1,DESC) ; EP
 NEW DICT0,DICT1,FDA,ERRS,PTR
 NEW HEREYAGO
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
 . D BADSTUFF("Error in adding "_NAME_" to the Delta Check Dictionary.")
 ;
 W !,?5,NAME_" Delta Check added to Delta Check Dictionary.",!
 ;
 S PTR=$$FIND1^DIC(62.1,,,NAME)   ; Get Delta Check IEN
 ;
 ; Now, add the Description
 K ERRS
 M WPARRAY("WP")=DESC
 D WP^DIE(62.1,PTR_",",30,"K","WPARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . W !!,"Error in adding DESCRIPTION to "_NAME_" Delta Check in the Delta Check Dictionary."
 . D BADSTUFF("")
 ;
 W !,?5,NAME_" Delta Check DESCRIPTION added to Delta Check Dictionary.",!
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
 W !,?5,NAME_" Delta Check SITE NOTES DATE added to Delta Check Dictionary.",!
 ;
 ; Now, add the TEXT
 K ERRS,WPARRAY
 S WPARRAY("WP",1)="Created by "_$$GET1^DIQ(200,DUZ,"NAME")_"     DUZ:"_DUZ
 D WP^DIE(62.131,"1,"_PTR_",",1,"K","WPARRAY(""WP"")","ERRS")
 ;
 I $D(ERRS("DIERR"))>0 D  Q
 . W !!,"Error in adding TEXT to "_NAME_" Delta Check in the Delta Check Dictionary."
 . D BADSTUFF("")
 ;
 W !,?5,NAME_" Delta Check TEXT added to Delta Check Dictionary."
 Q
 ;
 ;
SETDESC ; EP - Set DESCription array
 S CNT=0,TAB=$J("",5)
 D DESCADD(.DESC,.CNT,"This delta check, when added to a test named ")
 D DESCADD(.DESC,.CNT,$$LJ^XLFSTR(TAB_CREAT60D,72)_".")  ; Done to ensure DESCRIPTION field in DELTA CHECKS dictionary displays this on a seperate line
 D DESCADD(.DESC,.CNT,"will calculate an estimated Glomerular Filtration Rate (GFR)")
 D DESCADD(.DESC,.CNT,"using the Bedside Schwartz Equation.")
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,"The Bedside Schwartz Equation's result will be stuffed into the test called")
 D DESCADD(.DESC,.CNT,BSEGFRD,5)
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,"The National Kidney Foundation CREATININE-BASED ""BEDSIDE SCHWARTZ""")
 D DESCADD(.DESC,.CNT,"EQUATION (2009) is listed at (as of 08/30/2022)")
 D DESCADD(.DESC,.CNT,"https://www.kidney.org/content/",5)
 D DESCADD(.DESC,.CNT,"creatinine-based-""bedside-schwartz""-equation-2009",10)
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,"The equation used is:")
 D DESCADD(.DESC,.CNT,"GFR (mL/min/1.73 m^2) = (0.41 × Height in cm) / Creatinine in mg/dL",5)
 D DESCADD(.DESC,.CNT,"^ = indicates next character is a superscript",10)
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,"Note that the height measurement is retrieved from the")
 D DESCADD(.DESC,.CNT,"V MEASUREMENT (#9000010.01) file.",5)
 D DESCADD(.DESC,.CNT," ")
 D DESCADD(.DESC,.CNT,"eGFR Created "_$$HTE^XLFDT($H,"5MZ")_" by "_DUZ_".")
 D DESCADD(.DESC,.CNT," ")
 Q
 ;
 ;
WARNING ; EP - Warning from National Kidney Disease web-page (as of 06/21/2022)
 D DESCADD(.DESC,.CNT,"The National Kidney Disease website has this caveat:")
 D DESCADD(.DESC,.CNT,"The combined effect of IDMS-traceable calibration and an erroneous",5)
 D DESCADD(.DESC,.CNT,"correction for serum proteins can cause a relatively large error in",5)
 D DESCADD(.DESC,.CNT,"the estimated GFR that is more pronounced in very young children under",5)
 D DESCADD(.DESC,.CNT,"the age of 2.",5)
 D DESCADD(.DESC,.CNT," ")
 Q
 ;
 ;
 ; ============================= UTILITIES =============================
 ;
UTILTIES ; EP
 ;
VARSNEW ; EP - NEW put here to facilitate adding new routines.
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 Q
 ;
 ;
TESTKIDS ; EP - Report of Children (< 18 years old) from VA PATIENT (#2)
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS
 S HEADER(1)="Patients < 18 Years Old"
 D HEADERDT^BLRGMENU
 W ?4,"Compiling"
 ;
 S HEADER(2)="Alphabetical Sort"
 S HEADER(3)=" "
 S $E(HEADER(4),5)="DFN"
 S $E(HEADER(4),15)="Patient Name"
 S $E(HEADER(4),55)="Age"
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,CNTPAT,CNTKID,CNTKIDOK,PG)=0,QFLG="NO"
 ;
 S PTNAME=""
 F  S PTNAME=$O(^DPT("B",PTNAME))  Q:PTNAME=""!(QFLG="Q")  D
 . S DFN=0
 . F  S DFN=$O(^DPT("B",PTNAME,DFN))  Q:DFN<1!(QFLG="Q")  D
 .. S CNTPAT=CNTPAT+1
 .. I CNTKIDOK<1,(CNTPAT#1000)=0  W "."  I $X>68 W ?69,$J($FN(CNTKID,","),10),!,?4
 .. Q:$$GET1^DIQ(2,DFN,"AGE","I")>17     ; Skip if too old
 .. ;
 .. S CNTKID=CNTKID+1
 .. ;
 .. S HEIGHT=$$GHEIGHT()     ; Use V MEASUREMENT file
 .. Q:HEIGHT'>0
 .. ; I HEIGHT<0 S HEIGHT="Ht.Too.Old"
 .. ; I HEIGHT=0 S HEIGHT="Ht.Zero"
 .. ;
 .. I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,"NO")  Q:QFLG="Q"
 .. ;
 .. W ?4,DFN
 .. W ?14,$$GET1^DIQ(2,DFN,"NAME")
 .. W ?54,$$GET1^DIQ(2,DFN,"AGE")
 .. W ?64,HEIGHT
 .. W !
 .. S LINES=LINES+1
 .. S CNTKIDOK=CNTKIDOK+1
 ;
 W !!,?4,CNTPAT," Patients analyzed."
 W !!,?9,$S(CNTKID:CNTKID,1:"No")," Patients < 18 Years Old.",!
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
GHEIGHT() ; EP - Just get the latest height for the patient
 NEW DATEARRY,DATENTER,IEN,VALUE
 ;
 S VTYPEHT=$$FIND1^DIC(120.51,,"O","HEIGHT")
 ;
 S IEN="A"
 F  S IEN=$O(^GMR(120.5,"C",DFN,IEN),-1)  Q:IEN<1  D    ; Order through GMRV VITAL MEASUREMENT file
 . Q:$$GET1^DIQ(120.5,IEN,"VITAL TYPE","I")'=VTYPEHT
 . ;
 . S VALUE=$$GET1^DIQ(120.5,IEN,"RATE")
 . Q:VALUE<1
 . ;
 . S DATENTER=$$GET1^DIQ(120.5,IEN,"DATE/TIME VITALS TAKEN","I")
 . Q:DATENTER<1
 . ;
 . S DATEARRY(DATENTER)=(VALUE*2.54)     ; Convert inches to centimeters
 ;
 I $D(DATEARRY)<1 Q 0     ; If no HEIGHT Measurement, return zero
 ;
 S LATEST=$O(DATEARRY("A"),-1)
 I LATEST<1 Q 0  ; HEIGHT Measurement too old
 ;
 Q $G(DATEARRY(LATEST))
 ;
 ; ================================== UTILITIES ===================================
 ;
 ;
SETBLRVS(TWO) ; EP - Set the BLRVERN variables
 K BLRVERN,BLRVERN2
 S BLRVERN=$TR($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=TWO
 Q
 ;
 ;
SETHEAD(HDRONE) ; EP - Set the HDRONE variable
 D HEADERDT^BLRGMENU
 D SETHEAD^BLRGMENU(.HDRONE)
 D HEADERDT^BLRGMENU
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
DESCADD(DESC,CNT,STR,TAB) ; EP - Add Data to DESC Array
 S CNT=CNT+1
 S DESC(CNT)=$S($G(TAB):$J("",TAB),1:"")_STR
 Q
 ;
