BRAAPI ;ihs/cmi/maw - Radiology API by V Radiology Entry ; 08 Apr 2020  2:34 PM
 ;;5.0;Radiology/Nuclear Medicine;**1008**;May 1, 2020;Build 14
 ;We return a variable with 0 or 1
 ;
 ;A 0 means that the V RAD entry does not match any Exam in
 ;the RAD/NUC MED PATIENT file and no variables are returned.
 ;
 ;A 1 means that the V RAD entry matched an Exam in
 ;the RAD/NUC MED PATIENT file and we return the variable array.
 ;
 ;
TEST ;EP - test this API
 ;
 S Y=$$VRAD^BRAAPI(46521,"ARRY")
 ;
 Q
 ;
 ;
VRAD(BRAVRADI,BRARRY) ;EP - Receive V RAD IEN
 ;
 N BRAVSTI,BRAPATI,BRAPRCI,BRAEXDTI
 N BRADTI,BRACNI,BRAIEN,BRAPCC
 N BRAVRAD0,BRAVST0,BRAEX0
 N BRARPTI,BRAORDI,BRAEXSTI,BRAEXSTE
 N DOB,SEX,SSN
 ;
 S BRARET=0
 ;
 I $G(BRAVRADI)="" Q BRARET_U_"No VRAD IEN Passed In"
 ;
 ;Does the V RAD entry exist?
 S BRAVRAD0=$G(^AUPNVRAD(BRAVRADI,0))
 I BRAVRAD0="" Q BRARET_U_"No VRAD Entry in V Radiology File"
 ;
 ;Get Visit IEN
 S BRAVSTI=$P(BRAVRAD0,U,3)
 I BRAVSTI="" Q BRARET_U_"No Visit Entry in V Radiology File"
 ;
 ;Check Visit
 S BRAVST0=$G(^AUPNVSIT(BRAVSTI,0))
 I BRAVST0="" Q BRARET_U_"No Visit in Visit File"
 ;
 ;Is Visit Merged/Deleted
 I $P(BRAVST0,U,19)=1 Q BRARET_U_"Visit Merged/Deleted"
 ;
 ;Check Patient
 S BRAPATI=$P(BRAVST0,U,5)
 I BRAPATI="" Q BRARET_U_"No Patient in Visit File"
 I '$D(^DPT(BRAPATI)) Q BRARET_U_"No Patient in VA Patient File"
 I '$D(^AUPNPAT(BRAPATI)) Q BRARET_U_"No Patient in Patient File"
 ;
 ;Check Procedure
 S BRAPRCI=$P(BRAVRAD0,U)
 I BRAPRCI="" Q BRARET_U_"No Procedure in V Radiology File"
 I '$D(^RAMIS(71,BRAPRCI)) Q BRARET_U_"No Procedure in Procedure File"
 ;
 ;Get Event Date/Time
 ;This is the Exam Date/Time passed to PCC by the BRAPCC routine
 S BRAEXDTI=$$GET1^DIQ(9000010.22,BRAVRADI,1201,"I")
 I BRAEXDTI="" Q BRARET_U_"No Exam Date/Time in V Radiology File"
 ;
 ;Convert Exam Date/Time to Inverse format for Radiology
 S BRADTI=9999999.9999-BRAEXDTI
 ;
 ;Check if there are exams at this Date/Time
 I '$D(^RADPT(BRAPATI,"DT",BRADTI)) Q BRARET_U_"No Matching Exam Dates in Rad/Nuc Medicine Patient File"
 ;
 ;We now have to loop the exams at that particular exam date/time
 ;because there could be more than one 'case' at that time.
 ;
 S BRACNI=0
 S BRAIEN=0
 N BRAPCCN
 F  S BRAIEN=$O(^RADPT(BRAPATI,"DT",BRADTI,"P",BRAIEN)) Q:'BRAIEN  D  Q:BRACNI>0
 .;
 .;Check if we match the procedure IEN
 .S BRAEX0=$G(^RADPT(BRAPATI,"DT",BRADTI,"P",BRAIEN,0))
 .S BRAPCCN=$G(^RADPT(BRAPATI,"DT",BRADTI,"P",BRAIEN,"PCC"))  ;1008 maw 20200813
 .I BRAEX0="" Q
 .I BRAPRCI=$P(BRAEX0,U,2),$P(BRAPCCN,U,2)=BRAVRADI S BRACNI=BRAIEN  ;1008 20200813
 ;
 ;If BRACNI=0 we did not match a procedure
 I BRACNI=0 Q BRARET_U_"No Matching Procedure in Rad/Nuc Medicine Patient File"
 ;
 ;Get the Zero Node for this exam
 N BRADIV
 S BRAEX0=$G(^RADPT(BRAPATI,"DT",BRADTI,"P",BRACNI,0))
 I BRAEX0="" Q BRARET_U_"No Zero Node for Exam in Rad/Nuc Medicine Patient File"
 S BRADIV=$P($G(^RADPT(BRAPATI,"DT",BRADTI,0)),U,3)
 ;
 ;Get RAD/NUC MED REPORT IEN
 S BRARPTI=$P(BRAEX0,U,17)
 I '$G(BRARPTI) Q BRARET_U_"No Report IEN in Exam Node"  ;maw 1008 20200831
 ;
 ;Get RAD/NUC MED ORDER IEN
 S BRAORDI=$P(BRAEX0,U,11)
 I '$G(BRAORDI) Q BRARET_U_"No Order IEN in Exam Node"  ;maw 1008 20200831
 ;
 ;Get EXAM STATUS
 S BRAEXSTI=$P(BRAEX0,U,3)
 I BRAEXSTI="" Q BRARET_U_"No Exam Status in Rad/Nuc Medicine Patient File"
 S BRAEXSTE=$$GET1^DIQ(72,BRAEXSTI,.01)
 ;
 ;Quit if Cancelled
 I BRAEXSTE["CANCEL" Q BRARET_U_"Exam Cancelled"
 ;
 ;Check PCC Fields in RAD/NUC MED PATIENT
 ;The VISIT IEN for the V RADIOLOGY entry can be different than
 ;what is in the PCC nodes in the RAD/NUC MED PATIENT file
 ;because the V RAD entry could be merged into another visit.
 ;If so, we update the PCC fields in the RAD/NUC MED PATIENT file.
 ;
 ;  Piece 1 is Visit Date/Time
 ;  Piece 2 is V RADIOLOGY IEN
 ;  Piece 3 is VISIT IEN
 ;
 S BRAPCC=$G(^RADPT(BRAPATI,"DT",BRADTI,"P",BRACNI,"PCC"))
 ;
 ;************************************************************
 ;  We should match the V RAD or something is strange here.
 ;  How should this be handled?  Test a Procedure change!
 ;**************************************************************
 ;
 ;maw 1008 dont need this
 ;I $P(BRAPCC,U,2),$P(BRAPCC,U,2)'=BRAVRADI Q 0_"V Radiology entry doesn't match what is in the RAD/NUC Med Patient File"  ; D ^BOMB
 ;
 ;Since we have a good V RAD match, just stuff the Date/Time
 ;and Visit IEN here
 ;
 ;***********************************************************
 ;  Check for Xrefs on these fields???
 ;***********************************************************
 ;
 S $P(^RADPT(BRAPATI,"DT",BRADTI,"P",BRACNI,"PCC"),U)=$P(BRAVST0,U)
 S $P(^RADPT(BRAPATI,"DT",BRADTI,"P",BRACNI,"PCC"),U,3)=BRAVSTI
 ;
 ;*************************************
 ;  Here is what we know at this point
 ;*************************************
 ;
 ;  BRAPATI  is the PATIENT IEN
 ;  BRAVRADI is the V RADIOLOGY IEN
 ;  BRAVSTI  is the VISIT IEN
 ;  BRAPRCI  is the RAD/NUC MED PROCEDURE IEN
 ;  BRADTI   is the Inverse Date/Time (to lookup exam)
 ;  BRACNI   is the Internal Case Number (to lookup exam)
 ;  BRARPTI  is the RAD/NUC MED REPORT IEN
 ;  BRAORDI  is the RAD/NUC MED OPDER IEN
 ;
 ;***************
 ;Do we want to initialize all the variables at once, or just
 ;make sure we set them as we go?
 ;***************
 ;
 ;Get Patient Data
 D BLDPAT(BRAVRADI,BRAPATI,BRAVSTI,BRADIV)
 ;
 ;Get Visit Data
 D BLDVST(BRAVRADI,BRAVSTI)
 ;
 ;Get Exam Data
 D BLDEXAM(BRAVRADI,BRAPATI,BRADTI,BRACNI)
 ;
 ;Get Order Data
 D BLDORD(BRAVRADI,BRAORDI)
 ;
 ;Get Report Data
 D BLDRPT(BRAVRADI,BRARPTI)
 D BLDRPTI(BRAVRADI,BRARPTI)
 ;
 ;*****************************
 ;Quit and Kill Logic Goes Here
 ;******************************
 ;
 Q 1_U_"API Return Successful"
 ;
 ;
BLDPAT(VRADI,PIEN,VIEN,DIV) ;EP - Build Patient Data (File 2 and 9000001)
 ;
 ;Patient IEN
 ;Patient Name
 ;Patient HRN at Radiology Division user signed into
 ;Patient HRN at Radiology Division from Exam Node
 ;Patient DOB
 ;Patient Gender
 ;Patient SSN
 ;
 N PNM,DOB,SEX,SSN,LOC
 S PNM=$P($G(^DPT(PIEN,0)),U)
 S LOC=$P($G(^AUPNVSIT(VIEN,0)),U,6)
 S LHRN=$$HRN^AUPNPAT(PIEN,LOC)
 S DOB=$P($G(^DPT(PIEN,0)),U,3)
 S SEX=$P($G(^DPT(PIEN,0)),U,2)
 S SSN=$P($G(^DPT(PIEN,0)),U,9)
 S RHRN=$$HRN^AUPNPAT(PIEN,DIV)
 ;S LIST(BRAVRADI,"PATIENT")=PIEN_U_PNM_U_LHRN_U_RHRN_U_DOB_U_SEX_U_SSN
 S @BRARRY@(BRAVRADI,"PATIENT")=PIEN_U_PNM_U_LHRN_U_RHRN_U_DOB_U_SEX_U_SSN
 Q
 ;
 ;
BLDVST(VRADI,VIEN) ;EP - Build Visit Data (File 9000010)
 ;
 ;Visit IEN
 ;Visit Date/Time
 ;Visit Location
 ;Visit Service Category
 N VDT,VLOC,LSC
 S VDT=$P($G(^AUPNVSIT(VIEN,0)),U)
 S VLOC=$$GET1^DIQ(9000010,VIEN,.06)
 S VSC=$$GET1^DIQ(9000010,VIEN,.07)
 ;S LIST(BRAVRADI,"VISIT")=VIEN_U_VDT_U_VLOC_U_VSC
 S @BRARRY@(BRAVRADI,"VISIT")=VIEN_U_VDT_U_VLOC_U_VSC
 Q
 ;
BLDEXAM(VRADI,PIEN,DTI,CNI) ;EP - Build Exam Data (File 70)
 ;
 ;Exam Date/Time (FM)
 ;Exam Date/Time (Inverse)
 ;Accession Number (Date-Case)
 ;Case Number
 ;Case Number (Internal)
 ;Radiology Division IEN
 ;Radiology Division Name
 ;Type of Imaging
 ;Exam Status
 ;Category of Exam (I/P or O/P)
 ;Principal Clinic IEN
 ;Principal Clinic Name
 ;Primary Interpreting Staff
 ;Diagnostic Code (from File 78.3)
 ;Abnormal (from File 78.3)
 ;
 N EXDT,ACC,ACCDT,DAT,DATA,CN,CNII,DIVI,DIVN,TI,ES,CAT,PCI,PCN,PIS,DXC,ABN,PISI,PVO,PVOI
 S DAT=$G(^RADPT(PIEN,"DT",DTI,0))
 S EXDT=$P(DAT,U)
 S DATA=$G(^RADPT(PIEN,"DT",DTI,"P",CNI,0))
 S ACCDT=$E(EXDT,4,5)_$E(EXDT,6,7)_$E(EXDT,2,3)
 S ACC=ACCDT_"-"_$P(DATA,U)
 S CN=$P(DATA,U)
 S DIVI=$P(DAT,U,3)
 S DIVN=$$GET1^DIQ(79,$P(DAT,U,3),.01)
 S TI=$$GET1^DIQ(79.2,$P(DAT,U,2),.01)
 S EX=$$GET1^DIQ(72,$P(DATA,U,3),.01)
 S CAT=$P(DATA,U,4)
 S PCN=$$GET1^DIQ(44,$P(DATA,U,8),.01)
 S PCI=$P(DATA,U,8)
 S PISI=$P(DATA,U,15)
 I $G(PISI) S PVOI=$O(^RAMIS(73.99,"APER",PISI,0))
 I $G(PVOI) S PVO=$P($G(^RAMIS(73.99,PVOI,0)),U)
 S PIS=$$GET1^DIQ(200,$P(DATA,U,15),.01)
 S DXC=$$GET1^DIQ(78.3,$P(DATA,U,13),.01)
 S ABN=$$GET1^DIQ(78.3,$P(DATA,U,13),4)
 ;S LIST(VRADI,"EXAM")=EXDT_U_DTI_U_ACC_U_CN_U_CNI_U_DIVI_U_DIVN_U_TI_U_EX_U_CAT_U_PCN_U_PCI_U_PIS_U_DXC_U_ABN
 S @BRARRY@(VRADI,"EXAM")=EXDT_U_DTI_U_ACC_U_CN_U_CNI_U_DIVI_U_DIVN_U_TI_U_EX_U_CAT_U_PCI_U_PCN_U_PIS_U_DXC_U_ABN_U_$G(PVOI)_U_$G(PVO)
 Q
 ;
 ;
BLDORD(VRADI,ORD) ;EP - Build Order Data (File 75.1)
 ;
 ;Order IEN
 ;Ordered Procedure IEN
 ;Ordered Procedure Name
 ;Order Status
 ;Order Urgency
 ;Reason for Study (240 char)
 ;Requesting Physician IEN
 ;Requesting Physician Name
 ;Request Entered Date/Time
 N DAT,OPRCI,OPRCN,OS,OU,RFS,RPI,RPN,RQDT
 S DAT=$G(^RAO(75.1,ORD,0))
 S OPRCI=$P(DAT,U,2)
 D BLDPRC(BRAVRADI,OPRCI)
 S OPRCN=$$GET1^DIQ(71,$P(DAT,U,2),.01)
 S OS=$$GET1^DIQ(75.1,ORD,5)
 S OU=$$GET1^DIQ(75.1,ORD,6)
 S RFS=$G(^RAO(75.1,ORD,.1))
 S RPI=$P(DAT,U,14)
 S RFN=$$GET1^DIQ(75.1,ORD,14)
 S RQDT=$P(DAT,U,16)
 ;S LIST(VRADI,"ORDER")=ORD_U_OPRCI_U_OPRCN_U_OS_U_OU_U_RFS_U_RPI_U_RFN_U_RQDT
 S @BRARRY@(VRADI,"ORDER")=ORD_U_OPRCI_U_OPRCN_U_OS_U_OU_U_RFS_U_RPI_U_RFN_U_RQDT
 Q
 ;
 ;
BLDPRC(VRADI,PRCI) ;EP - Build Procedure Data (File 71)
 ;
 ;Procedure IEN
 ;Procedure Name
 ;CPT IEN
 ;CPT Code
 N PRCN,CPTI,CPTN
 S PRCN=$$GET1^DIQ(71,PRCI,.01)
 S CPTI=$P($G(^RAMIS(71,PRCI,0)),U,9)
 S CPT=$$GET1^DIQ(71,PRCI,9)
 ;S LIST(VRADI,"PROCEDURE")=PRCI_U_PRCN_U_CPTI_U_CPT
 S @BRARRY@(VRADI,"PROCEDURE")=PRCI_U_PRCN_U_CPTI_U_CPT
 Q
 ;
 ;
BLDRPT(VRADI,RPTI) ;EP - Build Report Data (File 74)
 ;
 ;Report IEN
 ;Report Status
 ;Verifying Physician IEN
 ;Verifying Physician Name
 ;Verifying Physician Organization IEN (aka Radiology Interpreting Site)
 ;Verifying Physician Organization (aka Radiology Interpreting Site)
 ;Verified Date/Time
 ;Date Report Entered
 N DAT,RS,VPI,VPN,VPOI,VPO,VDT,DRE
 I RPTI="" S @BRARRY@(VRADI,"REPORT")="No Report on File" Q
 I '$D(^RARPT(RPTI,0)) S @BRARRY@(VRADI,"REPORT")="No Report on File" Q
 S DAT=$G(^RARPT(RPTI,0))
 S RS=$$GET1^DIQ(74,RPTI,5)
 S VPI=$P(DAT,U,9)
 S VPN=$$GET1^DIQ(74,RPTI,9)
 I $G(VPI) S VPOI=$O(^RAMIS(73.99,"APER",VPI,0))
 I $G(VPOI) S VPO=$P($G(^RAMIS(73.99,VPOI,0)),U)
 S VDT=$P(DAT,U,7)
 S DRE=$P(DAT,U,6)
 ;S LIST(VRADI,"REPORT")=RPTI_U_RS_U_VPI_U_VPN_U_$G(VPO)_U_VDT_U_DRE
 S @BRARRY@(VRADI,"REPORT")=RPTI_U_RS_U_VPI_U_VPN_U_$G(VPOI)_U_$G(VPO)_U_VDT_U_DRE
 Q
 ;
 ;
BLDRPTI(VRADI,RPTI) ;EP - Build Impression Text
 N IT,IDA,CNT
 Q:RPTI=""
 S CNT=0
 Q:'$D(^RARPT(RPTI,0))
 I '$D(^RARPT(RPTI,"I",0)) S @BRARRY@(VRADI,"REPORT IMPRESSION")="No Impression Text" Q
 S IDA=0 F  S IDA=$O(^RARPT(RPTI,"I",IDA)) Q:'IDA  D
 . S CNT=CNT+1
 . ;S LIST(VRADI,"REPORT IMPRESSION",CNT)=$G(^RARPT(RPTI,"I",IDA,0))
 . S @BRARRY@(VRADI,"REPORT IMPRESSION",CNT)=$G(^RARPT(RPTI,"I",IDA,0))
 Q
 ;
