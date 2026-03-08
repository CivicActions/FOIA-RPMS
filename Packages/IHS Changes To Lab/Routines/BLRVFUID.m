BLRVFUID ;IHS/MSC/MKK - IHS LAB V Files' UID Updates ; 16-May-2023 06:35 ; MKK
 ;;5.2;IHS LABORATORY;**1054**;NOV 01, 1997;Build 20
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
 S ZTIO="",ZTDTH=$H,ZTDESC="IHS V Files' UID Updates",ZTRTN="QUEEM^BLRVFUID"
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
 D VLABUIDU
 D VMICUIDU
 Q
 ;
 ;
VLABUIDU ; EP - V LAB UID Update
 NEW BEGPROC,CNT,CNTALRDY,CNTERRS,CNTVLAB,COLLDTT,DFN,ENDPROC,ERRS,FDA,HEADER
 NEW HOURS,HOWLONG,LDLRAS,LRDATAMI,LRDFN,LRIDT,LRASMISS,LRUID,LRUIDMIS,MINUTES
 NEW MSGARRAY,VLABIEN,VLLRAS
 ;
 I $D(ZTQUEUED)<1  D
 . S HEADER(1)="V LAB (#9000010.09) File"
 . S HEADER(2)="UID and ""C"" x-ref Update"
 . D HEADERDT^BLRGMENU
 . W ?4
 ;
 K ^XTMP("LRVLAB")
 S ^XTMP("LRVLAB",0)=$$HTFM^XLFDT(+$H+180)_U_DT_U_"V LAB File UID Update Errors."_$S($D(ZTQUEUED):" Task #:"_ZTSK,1:"")
 ;
 S BEGPROC=$$NOW^XLFDT
 S (CNT,CNTALRDY,CNTERRS,CNTVLAB,LRDATAMI,LRASMISS,LRUIDMIS)=0
 S VLABIEN=.9999999
 F  S VLABIEN=$O(^AUPNVLAB(VLABIEN))  Q:VLABIEN<1  D
 . S CNTVLAB=CNTVLAB+1
 . ;
 . I $D(ZTQUEUED)<1 D
 .. W:(CNTVLAB#10000)=0 "."
 .. I $X>68 W $J($FN(CNTVLAB,","),11),!,?4
 . ;
 . ; Skip if UID already in V LAB
 . I $L($$GET1^DIQ(9000010.09,VLABIEN,"UID"))  S CNTALRDY=CNTALRDY+1  Q
 . ;
 . S DFN=$$GET1^DIQ(9000010.09,VLABIEN,"PATIENT NAME","I")
 . Q:DFN<1      ; Skip if no DFN
 . ;
 . S LRDFN=$$GET1^DIQ(2,DFN,"LABORATORY REFERENCE")
 . Q:LRDFN<1    ; Skip if no LRDFN
 . ;
 . S VLLRAS=$$GET1^DIQ(9000010.09,VLABIEN,"LR ACCESSION NO.")
 . Q:$L(VLLRAS)<1  ; ; Skip if no Accession
 . ;
 . S COLLDTT=$$GET1^DIQ(9000010.09,VLABIEN,"COLLECTION DATE AND TIME","I")
 . Q:COLLDTT<1  ; Skip if no Collection Date
 . ;
 . S LRIDT=9999999-COLLDTT
 . I $D(^LR(LRDFN,"CH",LRIDT))<1  S LRDATAMI=LRDATAMI+1  Q  ; Skip if cannot determine Lab Data File entry
 . ;
 . S LDLRAS=$$GET1^DIQ(63.04,LRIDT_","_LRDFN,"ACCESSION")
 . I VLLRAS'=LDLRAS  S LRASMISS=LRASMISS+1  Q  ; Skip if Accessions do not match
 . ;
 . S LRUID=$P($G(^LR(LRDFN,"CH",LRIDT,"ORU")),U)
 . I $L(LRUID)<1  S LRUIDMIS=LRUIDMIS+1   ; Skip if LRUID not found
 . ;
 . K FDA,ERRS
 . S FDA(9000010.09,VLABIEN_",","UID")=LRUID
 . D UPDATE^DIE("S","FDA",,"ERRS")
 . I $D(ERRS)<1 S CNT=CNT+1  Q      ; Successful update.  Get next entry
 . ;
 . ; At this point, there was an error.  Store it.
 . S CNTERRS=CNTERRS+1
 . S ^XTMP("LRVLAB",VLABIEN)=$$NOW^XLFDT_U_LRDFN_U_LRIDT_U_$G(ERRS("DIERR",1,"TEXT",1))
 ;
 S ENDPROC=$$NOW^XLFDT
 S HOWLONG=$P($$FMDIFF^XLFDT(ENDPROC,BEGPROC,3)," ",2)
 S HOURS=$P(HOWLONG,":")
 S MINUTES=$P(HOWLONG,":",2)
 S HOWLONG="Process took approximately "_$S(HOURS:HOURS_" hours and ",1:"")_MINUTES_" minutes."
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
 S RJ=$L($FN(CNTVLAB,","))
 W !!,"V LAB LRUID Update Process Completed."
 W !!,HOWLONG
 W !!,?4,$FN(CNTVLAB,",")," V LAB entries analyzed."
 W !,?4,$S(CNT:$J($FN(CNT,","),RJ),1:"No")," V LAB LRUID field entr",$$PLURALI(CNT)," updated."
 W:CNTALRDY !,?4,$J($FN(CNTALRDY,","),RJ)," V LAB LRUID field entr",$$PLURALI(CNTALRDY)," already updated."
 W:LRDATAMI !,?4,$J($FN(LRDATAMI,","),RJ)," Lab Data File entr",$$PLURALI(LRDATAMI)," not found."
 W:LRASMISS !,?4,$J($FN(LRASMISS,","),RJ)," V LAB & Lab Data File entr",$$PLURALI(LRASMISS)," do not match."
 W:LRUIDMIS !,?4,$J($FN(LRUIDMIS,","),RJ)," Lab Data File entr",$$PLURALI(LRUIDMIS)," without UID."
 W:CNTERRS !,?4,$J($FN(CNTERRS,","),RJ)," V LAB UPDATE^DIE Errors."
 D PRESSKEY^BLRGMENU(4)
 ;
 K:CNTERRS<1 ^XTMP("LRVLAB")  ; Clear XTMP if no errors.
 Q
 ;
 ;
VMICUIDU ; EP - V MICRO UID Update
 NEW BEGPROC,CNT,CNTALRDY,CNTERRS,CNTNOCDT,CNTNOMIF,CNTNOLDI,CNTVMIC,COLLDTT,DFN,ENDPROC,ERRS,FDA,HEADER
 NEW HOURS,HOWLONG,LDLRAS,LRDFN,LRIDT,LRUID,MINUTES,MSGARRAY,VMICIEN,VMLRAS
 ;
 I $D(ZTQUEUED)<1 D
 . S HEADER(1)="V MICROBIOLOGY (#9000010.25) File"
 . S HEADER(2)="UID and ""C"" x-ref Update"
 . D HEADERDT^BLRGMENU
 . W ?4
 ;
 K ^XTMP("LRVMIC")
 S ^XTMP("LRVMIC",0)=$$HTFM^XLFDT(+$H+180)_U_DT_U_"V LAB File UID Update Errors"_$S($D(ZTQUEUED):" Task #:"_ZTSK,1:"")
 ;
 S BEGPROC=$$NOW^XLFDT
 S (CNT,CNTERRS,CNTNOCDT,CNTNOLDI,CNTNOMIF,CNTVMIC,CNTALRDY)=0
 S VMICIEN=.9999999
 F  S VMICIEN=$O(^AUPNVMIC(VMICIEN))  Q:VMICIEN<1  D
 . S CNTVMIC=CNTVMIC+1
 . ;
 . I $D(ZTQUEUED)<1 D
 .. W:(CNTVMIC#1000)=0 "."
 .. I $X>68 W $J($FN(CNTVMIC,","),11),!,?4
 . ;
 . S DFN=$$GET1^DIQ(9000010.25,VMICIEN,"PATIENT NAME","I")
 . Q:DFN<1      ; Skip if no DFN
 . ;
 . S LRDFN=$$GET1^DIQ(2,DFN,"LABORATORY REFERENCE")
 . I LRDFN<1  S CNTNOLDI=1+CNTNOLDI  Q  ; Skip if no LRDFN
 . ;
 . S COLLDTT=$$GET1^DIQ(9000010.25,VMICIEN,"COLLECTION DATE AND TIME","I")
 . I COLLDTT<1  S CNTNOCDT=CNTNOCDT+1  Q      ; Skip if no Collection Date
 . ;
 . S LRIDT=9999999-COLLDTT
 . ;
 . ;; Skip if cannot determine Lab Data File entry
 . I $D(^LR(LRDFN,"MI",LRIDT))<1  S CNTNOMIF=CNTNOMIF+1  Q
 . ;
 . ; Skip if UID already in V MICRO
 . I $L($$GET1^DIQ(9000010.25,VMICIEN,"UID")) S CNTALRDY=CNTALRDY+1  Q
 . ;
 . ; $$GET1 for UID won't work for Micros because UID not defined in 63.05 Data Dictionary.
 . ; UID for Micro is defined in the LR*5.2*350 patch, i.e., LEDI IV.
 . ; Code to hard-set UID into "ORU" node for Micros is in the LRWLST11 routine.
 . ; S LRUID=$$GET1^DIQ(63.05,LRIDT_","_LRDFN,"UID")
 . S LRUID=$P($G(^LR(LRDFN,"MI",LRIDT,"ORU")),U)
 . Q:$L(LRUID)<1     ; Skip if LRUID not found
 . ;
 . K FDA,ERRS
 . S FDA(9000010.25,VMICIEN_",","UID")=LRUID
 . D UPDATE^DIE("S","FDA",,"ERRS")
 . I $D(ERRS)<1 S CNT=CNT+1  Q      ; Successful update.  Get next entry
 . ;
 . ; At this point, there was an error.  Store it.
 . S CNTERRS=CNTERRS+1
 . S ^XTMP("LRVMIC",VMICIEN)=$$NOW^XLFDT_U_LRDFN_U_LRIDT_U_$G(ERRS("DIERR",1,"TEXT",1))
 ;
 S ENDPROC=$$NOW^XLFDT
 S HOWLONG=$P($$FMDIFF^XLFDT(ENDPROC,BEGPROC,3)," ",2)
 S HOURS=$P(HOWLONG,":")
 S MINUTES=$P(HOWLONG,":",2)
 S HOWLONG="Process took approximately "_$S(HOURS:HOURS_" hours and ",1:"")_MINUTES_" minutes."
 I HOURS<1,+MINUTES<1 S HOWLONG="Process took less than a minute."
 ;
 I $D(ZTQUEUED) D  Q      ; If QUEUED, send Alert & MailMan message to LMI Mail Group and then Quit
 . K MSGARRAY
 . D MAKEMSG("V MICRO LRUID Update Process Completed.")
 . D MAKEMSG(HOWLONG)
 . D MAKEMSG($FN(CNTVMIC,",")_" V MICRO entries analyzed.",5)
 . D MAKEMSG($S(CNT:$FN(CNT,","),1:"No")_" V MICRO LRUID field entr"_$$PLURALI^BLRVFUID(CNT)_" updated.",10)
 . D:CNTERRS MAKEMSG($J($FN(CNTERRS,","),$L($FN(CNT,",")))_" V MICRO UPDATE^DIE Errors.",5)
 . ;
 . D MAILALMI^BLRUTIL3("V MICRO LRUID Updates",.MSGARRAY,"V MICRO LRUID Updater",1)
 . ;
 . K:CNTERRS<1 ^XTMP("LRVMIC")  ; Clear XTMP if no errors.
 ;
 S RJ=$L($FN(CNTVMIC,","))
 W !!,"V MICRO LRUID Update Process Completed."
 W !!,HOWLONG
 W !!,?4,$FN(CNTVMIC,",")," V MICRO entries analyzed."
 W !,?4,$S(CNT:$J($FN(CNT,","),RJ),1:"No")," V MICRO LRUID field entr",$$PLURALI(CNT)," updated."
 W:CNTALRDY !,?4,$J($FN(CNTALRDY,","),RJ)," V MICRO LRUID entr",$$PLURALI(CNTALRDY)," already Updated."
 W:CNTERRS !,?4,$J($FN(CNTERRS,","),RJ)," V MICRO UPDATE^DIE Errors."
 ;
 W !
 D ENDMSG(CNTNOLDI,"tied to DFNs without LRDFNs.")
 D ENDMSG(CNTNOCDT,"with no collection date.")
 D ENDMSG(CNTNOMIF,"that could not match Lab Data.")
 D PRESSKEY^BLRGMENU(4)
 ;
 K:CNTERRS<1 ^XTMP("LRVMIC")  ; Clear XTMP if no errors.
 Q
 ;
MAKEMSG(TEXT,TAB) ; EP
 NEW NODE
 ;
 S NODE=$O(MSGARRAY("A"),-1)+1
 S MSGARRAY(NODE)=$J("",+$G(TAB))_$S($L($G(TEXT)):TEXT,1:" ")
 S MSGARRAY(NODE+1)=" "
 Q
 ;
ENDMSG(CNTVAR,EXPLAN) ; EP 
 Q:CNTVAR<1
 ;
 W !,?9,$J($FN(CNTVAR,","),RJ)," entr",$$PLURALI(CNTVAR)," ",EXPLAN
 Q
 ;
 ;
LRASUIDS ; EP - Use Accession to set UID field in PCC Lab File
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D SETBLRVS("LRASUIDS")
 S HEADER(1)="V FILE UID Update"
 D HEADERDT^BLRGMENU
 D ^LRWU4
 I LRAA<1!(LRAD<1)!(LRAN<1) D BADSTUFF("Invalid Accession.")  Q
 I $D(^LRO(68,LRAA,1,LRAD,1,LRAN))<1 D BADSTUFF($S(BLRLRAS?.N:"UID",1:"Accession")_" "_BLRLRAS_" does Not exist in Accession file.")  Q
 ;
 S LRASIEN=LRAN_","_LRAD_","_LRAA
 S LRDFN=$$GET1^DIQ(68.02,LRASIEN,"LRDFN","I")
 S LRAS=$$GET1^DIQ(68.02,LRASIEN,"ACCESSION","I")
 S LRAA=$P(LRAS," ")
 S LRAAIEN=$$FIND1^DIC(68,,"O",LRAA)
 S LRSS=$$GET1^DIQ(68,LRAAIEN,"LR SUBSCRIPT","I")
 ;
 I LRSS'="CH",LRSS'="MI" D BADSTUFF("Invalid Accession.  Subscript = '"_LRSS_"'.")  Q
 ;
 S:LRSS="CH" PCCFILE="^AUPNVLAB(""ALR0"","_$C(34)_LRAS_$C(34)_",",VFILENUM=9000010.09,VFILNAME="V LAB"
 S:LRSS="MI" PCCFILE="^AUPNVMIC(""ALR0"","_$C(34)_LRAS_$C(34)_",",VFILENUM=9000010.25,VFILNAME="V MICRO"
 K HEADER(1)
 S HEADER(1)=VFILNAME_" UID Update"
 ;
 S LRUID=$$GET1^DIQ(68.02,LRASIEN,"UID","I")
 S LRASCOLD=$$GET1^DIQ(68.02,LRASIEN,"DRAW TIME","I")
 ;
 S HEADER(2)="Accession "_LRAS
 S HEADER(3)=$$CJ^XLFSTR("UID: "_LRUID,IOM)
 S HEADER(4)=" "
 S HEADER(5)="IEN"
 S $E(HEADER(5),10)="Coll Dt"
 S $E(HEADER(5),27)="UPDATE^DIE Message"
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,CNTVFILE,PG)=0,QFLG="NO"
 S HDRONE="NO"
 ;
 S VFILEIEN=0
 F  S VFILEIEN=$O(@(PCCFILE_VFILEIEN_")"))  Q:VFILEIEN<1!(QFLG="Q")  D
 . S CNTVFILE=CNTVFILE+1
 . Q:$L($$GET1^DIQ(VFILENUM,VFILEIEN,"UID"))      ; Skip if UID already existent
 . ;
 . S VFCOLLDT=$$GET1^DIQ(VFILENUM,VFILEIEN,"COLLECTION DATE AND TIME","I")
 . Q:VFCOLLDT'=LRASCOLD   ; Skip if Collection Dates do not match
 . ;
 . K FDA,ERRS
 . S FDA(VFILENUM,VFILEIEN_",","UID")=LRUID
 . D UPDATE^DIE("S","FDA",,"ERRS")
 . ;
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"
 . ;
 . W VFILEIEN
 . W ?9,VFCOLLDT
 . W:$D(ERRS)<1 ?26,"LRUID ",LRUID," Added."
 . I $D(ERRS) D LINEWRAP^BLRGMENU(26,$G(ERRS("DIERR",1,"TEXT",1)),53)
 . W !
 . S LINES=LINES+1
 . S CNT=CNT+1
 ;
 I CNT<1 K HEADER(4),HEADER(5)  D HEADERDT^BLRGMENU
 I CNT W !!
 W ?4,CNTVFILE," ",VFILNAME," Entr",$$PLURALI(CNTVFILE)," analyzed."
 W !!,?9,CNT," entr",$$PLURALI(CNT)," updated."
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
 ;
VLABRERR ; EP - V LAB LRUID Update Errors Report
 D REPTERRS("LRVLAB")
 Q
 ;
 ;
VMICRERR ; EP - V MICRO LRUID Update Errors Re
 D REPTERRS("LRVMIC")
 Q
 ;
 ;
REPTERRS(XTMPN) ; EP - LRUID Update Errors Report
 NEW (XTMPN,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S WOTVFILE=$S(XTMPN="LRVLAB":"V LAB",XTMPN="LRVMIC":"V MICRO")
 ;
 S HEADER(1)=WOTVFILE_" LRUID Update"
 S HEADER(2)="Errors Report"
 ;
 I $O(^XTMP(XTMPN,0))<1 D  Q
 . D HEADERDT^BLRGMENU
 . W ?4,"No ",WOTVFILE," Error Data."
 . D PRESSKEY^BLRGMENU(9)
 ;
 D SETHEAD(.HDRONE)
 ;
 S HEADER(3)=" "
 S HEADER(4)=WOTVFILE
 S $E(HEADER(4),10)="Error"
 S HEADER(5)="IEN"
 S $E(HEADER(5),10)="Date"
 S $E(HEADER(5),20)="LRDFN"
 S $E(HEADER(5),30)="LRIDT"
 S $E(HEADER(5),47)="UPDATE^DIE Error Message"
 ;
 D ^%ZIS
 U IO
 ;
 S MAXLINES=IOSL-4,LINES=MAXLINES+10
 S (CNT,PG)=0,QFLG="NO"
 ;
 S VLABIEN=.9999999
 F  S VLABIEN=$O(^XTMP(XTMPN,VLABIEN))  Q:VLABIEN<1!(QFLG="Q")  D
 . S STR=$G(^XTMP(XTMPN,VLABIEN))
 . S ERRDATE=$P(STR,U,1)
 . S LRDFN=$P(STR,U,2)
 . S LRIDT=$P(STR,U,3)
 . S ERRMSG=$P(STR,U,4)
 . ;
 . I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HDRONE)  Q:QFLG="Q"
 . ;
 . W VLABIEN
 . W ?9,$$FMTE^XLFDT(ERRDATE,"2DZ")
 . W ?19,LRDFN
 . W ?29,LRIDT
 . D LINEWRAP^BLRGMENU(46,ERRMSG,34)
 . W !
 . S LINES=LINES+1
 ;
 D ^%ZISC
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
