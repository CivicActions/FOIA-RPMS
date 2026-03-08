BQIDCABK ;PRXM/HC/ALA-Kernel Alerts for Abnormal Labs ; 14 Jul 2006  4:44 PM
 ;;1.0;ICARE MANAGEMENT SYSTEM;**2**;May 21, 2007
 ;
 Q
 ;
ALR(DATA,PARMS,MPARMS) ;EP
 ;
 ;Description
 ;  Executable that determines abnormal lab Kernal alerts
 ;Input
 ;  PARMS = Array of parameters and their values
 ;  MPARMS = Multiple array of a parameter
 ;Parameters
 ;  TMFRAME = Relative time frame
 ;  FDT = Starting date for the time frame
 ;  TDT = Ending date for the time frame
 ;  IEN = Lab record internal entry number
 ;  VIEN = Visit record internal entry number
 ;  ABNFL = Abnormal lab result
 ;Output
 ;  All records found will be put into ^TMP by patient and Alert internal entry
 ;  numbers.  The patient will be checked against the patients found in all the
 ;  panels and added to the ICARE PATIENT INDEX file.
 ;
 NEW UID
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQIDCABK",UID))
 K @DATA
 ;
 NEW IEN,NM,FDT,TDT,VTYP,X,DIC,Y,RSTM,VIEN,DFN,USR,ALRT,ALRIEN,ALDATA,LDATA
 NEW LRDFN,TYP,LDT,LREC,ACC,LIEN,TMFRAME,%DT
 S NM=""
 F  S NM=$O(PARMS(NM)) Q:NM=""  S @NM=PARMS(NM)
 ;
 I $G(TMFRAME)="" S TMFRAME="T-6M"
 I TMFRAME["T-" D
 . S %DT="",X=TMFRAME D ^%DT S FDT=Y
 I $G(DT)="" D DT^DICRW
 S TDT=DT
 ;
 ;  Go through the Alert file for the designated time frame to find any
 ;  abnormal lab results
 S USR=0
 F  S USR=$O(^XTV(8992,USR)) Q:'USR  D
 . S RSTM=FDT
 . F  S RSTM=$O(^XTV(8992,USR,"XQA",RSTM)) Q:RSTM=""!(RSTM\1>TDT)  D
 .. I $G(^XTV(8992,USR,"XQA",RSTM,0))'["Abnormal lab" Q
 .. S ALRT=$P(^XTV(8992,USR,"XQA",RSTM,0),U,2)
 .. S ALRIEN=$O(^XTV(8992.1,"B",ALRT,"")) I ALRIEN="" Q
 .. ;S DFN=$P($P(ALRT,";"),",",2)
 .. S DFN=$P($G(^XTV(8992.1,ALRIEN,0)),U,4) I DFN="" Q
 .. S ALDATA=$G(^XTV(8992.1,ALRIEN,2))
 .. S LDATA=$P(ALDATA,"@",2)
 .. S LRDFN=$P($G(^DPT(DFN,"LR")),U,1) I LRDFN="" Q
 .. S TYP=$P(LDATA,";",4) I TYP="" Q
 .. S LDT=$P(LDATA,";",5) I LDT="" Q
 .. S LREC=$G(^LR(LRDFN,TYP,LDT,0)),ACC=$P(LREC,U,6) I ACC="" Q
 .. S LIEN=""
 .. F  S LIEN=$O(^AUPNVLAB("AC",DFN,LIEN)) Q:LIEN=""  D
 ... I $P(^AUPNVLAB(LIEN,0),U,6)'=ACC Q
 ... S VIEN=$$GET1^DIQ(9000010.09,LIEN_",",.03,"I")
 .. S $P(@DATA@(DFN,ALRIEN),U,1)=$G(VIEN)
 .. I $G(VIEN)'="" S $P(@DATA@(DFN,ALRIEN),U,2)=$$GET1^DIQ(9000010,VIEN,.01,"I") Q
 .. S $P(@DATA@(DFN,ALRIEN),U,2)=RSTM
 Q
