BLRVFRDU ;IHS/MSC/MKK - IHS LAB V Files' Result Dates' Updates ; 30-May-2023 06:00 ; MKK
 ;;5.2;LR;**1054**;NOV 01, 1997;Build 20
 ;
EEP ; EP -- Ersatz Entry Point
 W !!,$C(7),$C(7),$C(7)
 W ?9,$$SHOUTMSG^BLRGMENU("Must use Line Labels to access subroutines",60),!
 W !!,$C(7),$C(7),$C(7)
 Q
 ;
 ;
QUEUPDT ; EP - Que the tasks
 NEW TASKNUM,ZTIO,ZTDTH,ZTDESC,ZTRTN,ZTSK
 ;
 D ^XBFMK
 S ZTIO="",ZTDTH=$H,ZTDESC="IHS V File Result Date Updates",ZTRTN="QUEEM^BLRVFRDU"
 D ^%ZTLOAD
 S TASKNUM=+$G(ZTSK)
 D ^%ZISC
 D BMES^XPDUTL($J("",5)_"V LAB & V MICRO UID Updating Program"_$S(TASKNUM:" Queued ["_TASKNUM_"]",1:" NOT QUEUED"))
 D MES^XPDUTL("")
 Q
 ;
 ;
QUEEM ; EP - QUE 'EM
 I $D(ZTQUEUED) S ZTREQ="@"
 D VLABRDU
 ; D VMICRDU
 Q
 ;
 ;
VLABRDU ; EP - V LAB Result Date Update
 NEW BEGPROC,CNT,CNTERRS,CNTVLAB,COLLDTT,DFN,ENDPROC,ERRS,FDA,HEADER
 NEW HOURS,HOWLONG,LDLRAS,LRDFN,LRIDT,LRUID,MINUTES,MSGARRAY,VLABIEN,VLLRAS
 ;
 S:$D(ZTQUEUED) ZTREQ="@"
 ;
 I $D(ZTQUEUED)<1  D
 . S HEADER(1)="V LAB (#9000010.09) File"
 . S HEADER(2)="RESULT DATE Update"
 . D HEADERDT^BLRGMENU
 . W "V LAB LRUID Update Process Begins"
 . W !!,?4
 ;
 K ^XTMP("LRVLABRD")
 S ^XTMP("LRVLABRD",0)=$$HTFM^XLFDT(+$H+180)_U_DT_U_"V LAB File UID Update Errors."_$S($D(ZTQUEUED):" Task #:"_ZTSK,1:"")
 ;
 S BEGPROC=$$NOW^XLFDT
 S (CNT,CNTERRS,CNTVLAB)=0
 S VLABIEN=.9999999
 F  S VLABIEN=$O(^AUPNVLAB(VLABIEN))  Q:VLABIEN<1  D
 . S CNTVLAB=CNTVLAB+1
 . ;
 . I $D(ZTQUEUED)<1 D
 .. W:(CNTVLAB#10000)=0 "."
 .. I $X>68 W $J($FN(CNTVLAB,","),11),!,?4
 . ;
 . S DFN=$$GET1^DIQ(9000010.09,VLABIEN,"PATIENT NAME","I")
 . Q:DFN<1      ; Skip if no DFN
 . ;
 . S LRDFN=$$GET1^DIQ(2,DFN,"LABORATORY REFERENCE")
 . Q:LRDFN<1    ; Skip if no LRDFN
 . ;
 . S VABLRDT=$$GET1^DIQ(9000010.09,VLABIEN,"RESULT DATE AND TIME","I")
 . ;
 . S VLLRAS=$$GET1^DIQ(9000010.09,VLABIEN,"LR ACCESSION NO.")
 . Q:$L(VLLRAS)<1
 . ;
 . S COLLDTT=$$GET1^DIQ(9000010.09,VLABIEN,"COLLECTION DATE AND TIME","I")
 . Q:COLLDTT<1  ; Skip if no Collection Date
 . ;
 . S LRIDT=9999999-COLLDTT
 . Q:$D(^LR(LRDFN,"CH",LRIDT))<1    ; Skip if cannot determine Lab Data File entry
 . ;
 . S LDLRAS=$$GET1^DIQ(63.04,LRIDT_","_LRDFN,"ACCESSION")
 . Q:VLLRAS'=LDLRAS  ; Skip if Accessions do not match
 . ;
 . S VLABF60=$$GET1^DIQ(9000010.09,VLABIEN,"LAB TEST","I")
 . S VLAB60DN=$$GET1^DIQ(60,VLABF60,"DATA NAME","I")
 . ;
 . S LDF63RD=0
 . ;
 . ; Set Result Date variable, LDF63RD, to test level Result Date (if it exists).
 . S:+$G(VLAB60DN) LDF63RD=$P($G(^LR(LRDFN,"CH",LRIDT,VLAB60DN)),U,6)
 . ;
 . ; If Result Date variable, LDF63RD, still null, try to set it to DATE REPORT COMPLETED
 . S:LDF63RD<1 LDF63RD=$$GET1^DIQ(63.04,LRIDT_","_LRDFN,"DATE REPORT COMPLETED","I")
 . ;
 . Q:LDF63RD<1  ; Skip if no Result Date
 . ;
 . I VABLRDT,VABLRDT=LDF63RD Q      ; Skip if Date Already matches.
 . ;
 . K FDA,ERRS
 . S FDA(9000010.09,VLABIEN_",","RESULT DATE AND TIME")=LDF63RD
 . D UPDATE^DIE("S","FDA",,"ERRS")
 . I $D(ERRS)<1 S CNT=CNT+1  Q      ; Successful update.  Get next entry
 . ;
 . ; At this point, there was an error.  Store it.
 . S CNTERRS=CNTERRS+1
 . S ^XTMP("LRVLABRD",VLABIEN)=$$NOW^XLFDT_U_LRDFN_U_LRIDT_U_VLABF60_U_VLAB60DN
 . S ^XTMP("LRVLABRD",VLABIEN,"ERROR MESSAGE")=$G(ERRS("DIERR",1,"TEXT",1))
 ;
 S ENDPROC=$$NOW^XLFDT
 S HOWLONG=$P($$FMDIFF^XLFDT(ENDPROC,BEGPROC,3)," ",2)
 S HOURS=$P(HOWLONG,":")
 S MINUTES=$P(HOWLONG,":",2)
 S HOWLONG="Process took "_$S(HOURS:HOURS_" hours and ",1:"")_MINUTES_" minutes."
 I HOURS<1,+MINUTES<1 S HOWLONG="Process took less than a minute."
 ;
 I $D(ZTQUEUED) D  Q      ; If QUEUED, send Alert & MailMan message to LMI Mail Group and then Quit
 . K MSGARRAY
 . D MAKEMSG("V LAB LRUID Update Process Completed.")
 . D MAKEMSG(HOWLONG)
 . D MAKEMSG($FN(CNTVLAB,",")_" V LAB entries analyzed.",5)
 . D MAKEMSG($S(CNT:$FN(CNT,","),1:"No")_" V LAB LRUID field entr"_$$PLURALI^BLRVFUID(CNT)_" updated.",10)
 . D:CNTERRS MAKEMSG($J($FN(CNTERRS,","),$L($FN(CNT,",")))_" V LAB UPDATE^DIE Errors.",10)
 . ;
 . D MAILALMI^BLRUTIL3("V LAB LRUID Updates",.MSGARRAY,"V LAB LRUID Updater",1)
 . ;
 . K:CNTERRS<1 ^XTMP("LRVLAB")  ; Clear XTMP if no errors.
 ;
 W:$X>5 ?69,$J($FN(CNTVLAB,","),11)
 ;
 W !!,"V LAB LRUID Update Process Completed."
 W !!,HOWLONG
 W !!,?4,$FN(CNTVLAB,",")," V LAB entries analyzed."
 W !!,?9,$S(CNT:$FN(CNT,","),1:"No")," V LAB LRUID field entr",$$PLURALI(CNT)," updated."
 W:CNTERRS !!,?9,$FN(CNTERRS,",")," V LAB UPDATE^DIE Errors."
 D PRESSKEY^BLRGMENU(4)
 ;
 K:CNTERRS<1 ^XTMP("LRVLAB")  ; Clear XTMP if no errors.
 Q
 ;
 ;
VFILERDR(VFILE) ; EP - V FILE Result Date Report
 NEW (VFILE,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 I $G(VFILE)="" D BADSTUFF("No V FILE.")  Q
 ;
 S VFILENUM=$S(VFILE="VLAB":9000010.09,VFILE="VMIC":9000010.25,1:"")
 Q:VFILENUM=""
 ;
 S VFILNAME=$S(VFILE="VLAB":"V LAB",VFILE="VMIC":"V MICRO",1:"")
 Q:VFILNAME=""
 ;
 S VFILEGLO=$S(VFILE="VLAB":"^AUPNVLAB(",VFILE="VMIC":"^AUPNVMIC(",1:"")
 Q:VFILEGLO=""
 ;
 D SETBLRVS
 S HEADER(1)=VFILNAME_" "_VFILENUM_" File"
 S HEADER(2)="RESULT DATE Update Report"
 D HEADERDT^BLRGMENU
 W ?4
 ;
 S HEADER(3)=" "
 S HEADER(4)=$$COLHEAD^BLRGMENU(VFILNAME_" FILE",24)
 S $E(HEADER(4),27)="FILE 60"
 S $E(HEADER(4),38)=$$COLHEAD^BLRGMENU("LAB DATA FILE",43)
 S HEADER(5)="IEN"
 S $E(HEADER(5),10)="RES DATE/TIME"
 S $E(HEADER(5),27)="IEN"
 S $E(HEADER(5),38)="LRDFN"
 S $E(HEADER(5),45)="LRIDT"
 S $E(HEADER(5),62)="DT REPT COMPL"
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S HDRONE="NO"
 S (CNT,CNTCOLLD,CNTDFN,CNTLRAS,CNTLDF63,CNTLRDFN,CNTLRIDT,CNTMLRAS,CNTOK,CNTVLAB,PG)=0,QFLG="NO"
 ;
 S VFILEIEN=.9999999
 F  S VFILEIEN=$O(@(VFILEGLO_VFILEIEN_")"))  Q:VFILEIEN<1!(QFLG="Q")  D
 . S CNTVLAB=CNTVLAB+1
 . ;
 . I CNT<1 D
 .. W:(CNTVLAB#5000)=0 "."
 .. I $X>68 W $J($FN(CNTVLAB,","),11),!,?4
 . ;
 . S DFN=$$GET1^DIQ(VFILENUM,VFILEIEN,"PATIENT NAME","I")
 . Q:DFN<1      ; Skip if no DFN
 . S CNTDFN=CNTDFN+1
 . ;
 . S LRDFN=$$GET1^DIQ(2,DFN,"LABORATORY REFERENCE")
 . Q:LRDFN<1    ; Skip if no LRDFN
 . S CNTLRDFN=CNTLRDFN+1
 . ;
 . S VABLRDT=$$GET1^DIQ(VFILENUM,VFILEIEN,$S(VFILE="VLAB":"RESULT DATE AND TIME",VFILE="VMIC":"COMPLETE DATE"),"I")
 . ;
 . S VLLRAS=$$GET1^DIQ(VFILENUM,VFILEIEN,"LR ACCESSION NO.")
 . Q:$L(VLLRAS)<1
 . S CNTLRAS=CNTLRAS+1
 . ;
 . S COLLDTT=$$GET1^DIQ(VFILENUM,VFILEIEN,"COLLECTION DATE AND TIME","I")
 . Q:COLLDTT<1  ; Skip if no Collection Date
 . S CNTCOLLD=CNTCOLLD+1
 . ;
 . S LRIDT=9999999-COLLDTT
 . Q:$D(^LR(LRDFN,"CH",LRIDT))<1    ; Skip if cannot determine Lab Data File entry
 . S CNTLRIDT=CNTLRIDT+1
 . ;
 . S LDLRAS=$$GET1^DIQ(63.04,LRIDT_","_LRDFN,"ACCESSION")
 . Q:VLLRAS'=LDLRAS  ; Skip if Accessions do not match
 . S CNTMLRAS=CNTMLRAS+1
 . ;
 . S VLABF60=$$GET1^DIQ(VFILENUM,VFILEIEN,$S(VFILE="VLAB":"LAB TEST",VFILE="VMIC":"CULTURE"),"I")
 . S VLAB60DN=$$GET1^DIQ(60,+VLABF60,"DATA NAME","I")
 . ;
 . ; Set LAB DATA file Result Date variable, LDF63RD, to test level Result Date (if it exists).
 . S LDF63RD=$P($G(^LR(LRDFN,"CH",LRIDT,+VLAB60DN)),U,6)
 . ;
 . ; If LAB DATA file Result Date variable, LDF63RD, still null, try to set it to DATE REPORT COMPLETED
 . S:LDF63RD<1 LDF63RD=$$GET1^DIQ(63.04,LRIDT_","_LRDFN,"DATE REPORT COMPLETED","I")
 . ;
 . Q:LDF63RD<1  ; Skip if no LAB DATA file Result Date
 . S CNTLDF63=CNTLDF63+1
 . ;
 . I VABLRDT,VABLRDT=LDF63RD S CNTOK=CNTOK+1  Q    ; Skip if Date Already matches.
 . ;
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"
 . ;
 . W VFILEIEN
 . W ?9,VABLRDT
 . W ?26,VLABF60
 . W:$$ISPANEL^BLRPOC(VLABF60) "*"  ; Note COSMIC Tests
 . W ?37,LRDFN
 . W ?46,LRIDT
 . W ?61,LDF63RD
 . W !
 . S CNT=CNT+1
 . S LINES=LINES+1
 ;
CNTDTAIL ; EP
 F I=3:1:5 K HEADER(I)
 ;
 D HEADERDT^BLRGMENU
 ;
 W ?4,$FN(CNTVLAB,",")," ",VFILNAME," entries analyzed."
 W !!,?7,$S(CNTOK:$FN(CNTOK,","),1:"No")," ",VFILNAME," entr",$$PLURALI(CNTOK)," Matching LAB DATA file Result Date."
 W !!,?7,$S(CNT:$FN(CNT,","),1:"No")," ",VFILNAME," entr",$$PLURALI(CNT)," Not Matching LAB DATA file Result Date."
 ;
 S RJ=$L($FN(CNTDFN,","))
 W !!,?10,$S(CNTDFN:$FN(CNTDFN,","),1:"No")," ",VFILNAME," entr",$$PLURALI(CNTDFN)," with DFNs."
 W !,?10,$J($S(CNTLRDFN:$FN(CNTLRDFN,","),1:"No"),RJ)," ",VFILNAME," entr",$$PLURALI(CNTDFN)," with LRDFNs."
 W !,?10,$J($S(CNTLRAS:$FN(CNTLRAS,","),1:"No"),RJ)," ",VFILNAME," entr",$$PLURALI(CNTLRAS)," with Accession Numbers."
 W !,?10,$J($S(CNTCOLLD:$FN(CNTCOLLD,","),1:"No"),RJ)," ",VFILNAME," entr",$$PLURALI(CNTCOLLD)," with Collection Dates."
 W !,?10,$J($S(CNTLRIDT:$FN(CNTLRIDT,","),1:"No"),RJ)," ",VFILNAME," file enter",$$PLURALI(CNTLRIDT)," with valid Inverse Dates."
 W !,?10,$J($S(CNTMLRAS:$FN(CNTMLRAS,","),1:"No"),RJ)," ",VFILNAME," & LAB DATA file enter",$$PLURALI(CNTLRIDT)," with matching Accessions."
 W !,?10,$J($S(CNTLDF63:$FN(CNTLDF63,","),1:"No"),RJ)," LAB DATA file enter",$$PLURALI(CNTLRIDT)," with Result Dates."
 ;
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
 ;
 ; ============================= UTILITIES =============================
 ;
UTILS ; EP - Exclusive NEW put here to facilitate adding new routines.
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 Q
 ;
 ;
SETBLRVS(TWO) ; EP - Set the BLRVERN variables
 K BLRVERN,BLRVERN2
 S BLRVERN=$TR($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=TWO
 Q
 ;
PLURAL(CNT) ; EP - Return "s" if CNT>1, else return "".
 Q $S(CNT>1:"s",1:"")
 ;
PLURALI(CNT) ; EP - If CNT=1 return "y", else return "ies"
 Q $S(CNT=1:"y",1:"ies")
 ;
SETHEAD(HDRONE) ; EP - Set the HDRONE variable
 D HEADERDT^BLRGMENU
 D HEADONE^BLRGMENU(.HDRONE)
 D HEADERDT^BLRGMENU
 Q
 ;
BADSTUFF(STR,TAB)       ; EP - BADSTUFF error message
 S TAB=$S($L($G(TAB))<1:4,1:TAB)
 W !!,?TAB,STR,"  Routine Ends.",!
 D PRESSKEY^BLRGMENU(TAB+5)
 Q
 ;
MAKEMSG(TEXT,TAB) ; EP
 NEW NODE
 ;
 S NODE=$O(MSGARRAY("A"),-1)+1
 S MSGARRAY(NODE)=$J("",+$G(TAB))_$S($L($G(TEXT)):TEXT,1:" ")
 S MSGARRAY(NODE+1)=" "
 Q
