BIUTL9 ;IHS/CMI/MWR - UTIL: OVERFLOW CODE FROM OTHER BIUTL RTNS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**12,26,28**;OCT 24,2011;Build 31
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  OVERFLOW CODE FROM OTHER BIUTL RTNS.
 ;;  PATCH 9: All EP's below are moved from BIUTL7 for space (<15000k).  REASCHK+0
 ;;  PATCH 12: Same as above. LOTDAT+0, HISTORY+0
 ;;  PATCH 26: 88884 Add sub to allow site to remove external dates from V IMMUNIZATION
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> All EP's below are moved from BIUTL7 for space (<15000k).
 ;
 ;----------
REASCHK ;EP
 ;---> Called by Post Action field of Field 5 on BI FORM-CASE DATA EDIT.
 ;---> If Date Inactive in Field 4, then a Reason is req'd in Field 5.
 ;
 I (BI("E")]"")&(BI("F")="") D
 .D HLP^DDSUTL("*** NOTE! An Inactive Date REQUIRES an Inactive Reason! ***")
 .S DDSBR=4
 Q
 ;
 ;
 ;----------
READCHK ;EP
 ;---> Called by Post Action field of Field 4 on BI FORM-SKIN VISIT ADD/EDIT.
 ;---> If user entered a Result in Field 3, then a Reading is req'd in Field 4.
 I $G(BI("L"))]"",$G(BI("M"))="",$G(BI("I"))'="E" D
 .;
 .D HLP^DDSUTL("*** NOTE! If you enter a Result you MUST enter a Reading! ***")
 .S DDSBR=3
 Q
 ;
 ;
 ;----------
READCH6 ;EP
 ;---> Called by Post Action field of Field 4 on BI FORM-SKIN VISIT ADD/EDIT.
 ;
 D READCHK
 I $G(DDSBR)=3 D  Q
 .S X=$G(DDSOLD) D PUT^DDSVALF(6,,,X)
 D LOCBR^BIUTL4
 Q
 ;
 ;
 ;----------
CREASCHK ;EP
 ;---> Called by Post Action of Field 4 on BI FORM-CONTRAIND ADD/EDIT.
 ;---> If user entered a Contra in Field 1, then a Reason is req'd in Field 4.
 ;
 I (BI("B")]"")&(BI("C")="") D
 .D HLP^DDSUTL("*** NOTE! A Reason for the contraindication is required! ***")
 .S DDSBR=1
 Q
 ;**********
 ;
 ;********** PATCH 12, v8.5, OCT 24,2011, IHS/CMI/MWR
 ;---> LOTDAT and VSHORT below are moved from BIUTL7 for space (<15000k).
 ;
 ;----------
LOTDAT(X) ;EP
 ;---> Called by Post Action field of Field 3 on BI FORM-IMM VISIT ADD/EDIT.
 ;---> Display Lot Exp Date and Remaining Balance (if tracked).
 ;---> Parameters:
 ;     1 - X (req) IEN of Lot Number in ^AUTTIML.
 ;
 Q:'$G(X)
 D PUT^DDSVALF(3.4,,," Exp Date: "_$$LOTEXP^BIRPC3(X,1))
 D PUT^DDSVALF(3.5,,,"Remaining: "_$$LOTRBAL^BIRPC3(X))
 Q
 ;
 ;
 ;----------
VSHORT(X) ;EP
 ;---> Called by LOADVIS above and by Post Action field of Field 2
 ;---> on BI FORM-IMM VISIT ADD/EDIT.
 ;---> Display Short Name below Vaccine Name if different.
 ;---> Parameters:
 ;     1 - X (req) IEN of Vaccine in ^AUTTIMM.
 ;
 Q:'$G(X)  Q:($$VNAME^BIUTL2(X)=$$VNAME^BIUTL2(X,1))
 D PUT^DDSVALF(2.5,,,"("_$$VNAME^BIUTL2(X)_")")
 Q
 ;**********
 ;
 ;
 ;********** PATCH 12, v8.5, OCT 24,2011, IHS/CMI/MWR
 ;---> HISTORY below are moved from BIUTL4 for space (<15000k).
 ;
 ;----------
HISTORY(X) ;EP
 ;---> Add/Edit Screenman actions to take ON POST-CHANGE of Category Field.
 ;---> Parameters:
 ;     1 - X (opt) X=Internal Value of Category Field ("E"=Historical Event).
 ;
 ;---> If this is an Historical Event, then set Lot#="" and not required.
 I X="E" D
 .S BI("D")=""
 .D PUT^DDSVALF(3,"","",""),REQ^DDSUTL(3,"","",0)
 .;---> Remove (default) provider.
 .D PUT^DDSVALF(9,,,) S BI("R")=""
 .;
 .;********** PATCH 12, v8.5, OCT 24,2011, IHS/CMI/MWR
 .;---> Set Injection Site AND Volume fields not required.
 .D REQ^DDSUTL(4,"","",0),REQ^DDSUTL(5,"","",0)
 ;
 ;---> If Category is Ambulatory or Inpatient, then set Inj Site to required.
 I (X="A")!(X="I") D REQ^DDSUTL(4,"","",1),REQ^DDSUTL(5,"","",1)
 Q
 ;**********
VIMM ;-- 88884 remove external dates from V IMM 1201
 W !,"Removing External Dates from V Immunization"
 N VDA,VDAT
 S VDA=0 F  S VDA=$O(^AUPNVIMM(VDA)) Q:'VDA  D
 . S VDAT=$P($G(^AUPNVIMM(VDA,12)),U)
 . I VDAT["/" D
 .. W "."
 .. S $P(^AUPNVIMM(VDA,12),U)=""
 Q
 ;
SDV(IVIEN) ;PEP;V8.0 PATCH 28 - FID-106077 Allow split dose vaccine to be added
 ;RETUNS:
 ;   0 = vaccine is not a split dose vaccine
 ;   1 = vaccine is a split dose vaccine
 ;
 ;Split dose vaccine can be added as 2 different V IMMUNIZATION entries
 ;for the same day
 ;
 Q $D(^BISDV(+$G(IVIEN),0))
 ;=====
 ;
SDVEDIT ;EP;TO ADD EDIT SPLIT DOES VACCINE
 K BIQUIT
 S BIQUIT=0
 F  D SDV1 Q:BIQUIT
 K BIQUIT
 Q
 ;=====
 ;
SDV1 ;SDV ADD/EDIT
 D SDVDISP
 K DIR
 S DIR(0)="SO^1:ADD additional SDV;2:REMOVE existing SDV"
 S DIR("A")="Add or Remove SDV"
 W !
 D ^DIR
 K DIR
 I X=""!($G(DIRUT)[U) S BIQUIT=1 Q
 I Y=1 D SDVADD Q
 I Y=2 D SDVREM
 Q
 ;=====
 ;
SDVDISP ;DISPLAY CURRENT SDV'S
 W @IOF
 W !?10,"Current SPLIT DOSE vaccines for which duplicate entry allowed:"
 W !!,"IEN",?5,"CVX",?10,"Short name"
 W !,"---",?5,"---",?10,"--------------------"
 N X,Y,Z
 S X=0
 F  S X=$O(^BISDV(X)) Q:'X  D
 .S Y=$G(^AUTTIMM(X,0))
 .Q:Y=""
 .W !,X,?5,$P(Y,U,3),?10,$P(Y,U,2)
 Q
 ;=====
 ;
SDVADD ;ADD ADDITIONAL SDV
 K Y,DIC,DA,DR
 S DIC="^AUTTIMM("
 S DIC(0)="AEMQZ"
 S DIC("A")="Add new SDV immunization: "
 S DIC("S")="I '$D(^BISDV(+Y,0))"
 W !
 D ^DIC
 Q:Y<1
 S (X,DINUM)=+Y
 S DIC="^BISDV("
 S DIC(0)="L"
 D FILE^DICN
 Q
 ;=====
 ;
SDVREM ;REMOVE EXISTING SDV
 N X,Y,Z
 K DIC,DA,DR
 S DIC="^BISDV("
 S DIC(0)="AEMQZ"
 S DIC("A")="Remove SDV immunization: "
 S DIC("S")="I +$G(^BISDV(+Y,0))"
 W !
 D ^DIC
 Q:Y<1
 S DA=+Y
 S X=$G(^AUTTIMM(DA,0))
 K DIR
 S DIR(0)="YO"
 S DIR("A")="Remove "_$P(X,U,2)_" (CVX "_$P(X,U,3)_") from the Split Dose list"
 S DIR("B")="NO"
 W !
 D ^DIR
 Q:'Y
 S DIK="^BISDV("
 D ^DIK
 Q
 ;=====
 ;
D343(DFN,VIEN,VDT) ;EP;TO COUNT NUMBER OF DUPS FOR DOS
 ;DFN  = PATIENT DFN
 ;VIEN = IEN FROM AUTTIM
 ;VDT  = REVERSE VISIT DATE
 N X,Y,Z,V
 S DUP=0
 S VIMM=0
 F  S VIMM=$O(^AUPNVIMM("AA",DFN,VIEN,VDT,VIMM)) Q:'VIMM  S DUP=DUP+1
 Q DUP
 ;=====
 ;
