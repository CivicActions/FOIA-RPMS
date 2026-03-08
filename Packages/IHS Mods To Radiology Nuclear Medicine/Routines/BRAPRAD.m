BRAPRAD ;CIA/PLS,IHS/ITSC/CLS/NST - Radiology Protocol Event API ; 27 Jan 2025  4:29 PM
 ;;5.0;Radiology/Nuclear Medicine;**1001,1003,1006,1007,1009,1012**;Mar 16, 1998;Build 13
 ;
HOOK ;
 ;S $ZE="RAD PCC TEST" D ^ZTER  ;IHS/ITSC/CLS testing
 ;N SEG,LP,DL1,DL2,RAPCC,ACTION,ORDSTS
 ; Get SEND PCC AT EXAMINED field
 S RAPCC=+$G(^RA(79,+$G(RAMDIV),9999999))
 S LP=0
 S SEG=$$SEG("MSH",.LP)
 Q:'LP
 S DL1=$E(SEG,4),DL2=$E(SEG,5)
 Q:$P(SEG,DL1,3)'="RADIOLOGY"
 S SEG=$$SEG("ORC",.LP)
 Q:'LP
 S ORDSTS=$P(SEG,DL1,6)  ; Order Status
 S ACTION=$P(SEG,DL1,2)  ; Order Control
 I ACTION?2U,$L($T(@ACTION)) D @ACTION
 ; Patch 1012 - Updated clinical indication
 I ACTION="RE" D
 . N BRAOIFN,BRACLIND
 . S BRAOIFN=$P($G(^RADPT(+$G(RADFN),"DT",+$G(RADTI),"P",+$G(RACNI),0)),U,11)  ; RA Order IEN in #75.1
 . S BRACLIND=$$GET1^DIQ(75.1,BRAOIFN,91,"I")
 . D UVRAD^BRANCLNI($G(RADFN),$G(RADTI),$G(RACNI),BRACLIND)
 . Q
 Q
 ;
 ;
 ; Return specified segment, starting at line LP
SEG(TYP,LP) ;
 F  S LP=$O(RAMSG(LP)) Q:'LP  Q:$E(RAMSG(LP),1,$L(TYP))=TYP
 Q $S(LP:RAMSG(LP),1:"")
 ;
 ;
SN ; New Order (doesn't create visit - "PCC" node absent)
 Q
 ;
 ;
SC ; Status Change (scheduled, registered, or unverified)
 ; Status Change (registered - ORSTS="ZR", ACTION="SC")
 ; Status Change (examined   - ORSTS="", ACTION="SC")
 ; Status Change (unverified - ORSTS=ZU, ACTION="SC")
 ;
 ;Released report was unverified
 I ORDSTS="ZU" D
 .D UPDTIMP^BRAPCC($G(RADFN),$G(RADTI))
 .D UPDATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 ;
 ;
 ;Don't create visit for registered
 ;Do create visit if examined and 'Send PCC at Examined' is YES
 I ORDSTS="" D
 .I RAPCC D
 ..D CREATE^BRAPCC
 ..D CREATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 Q
 ;
 ;
OH ; Exam on Hold, not even registered yet so no action necessary
 Q
 ;
 ;
OD ; Delete Exam and request
 I RAPCC D
 .D DELETE^BRAPCC
 .D UPDATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 Q
 ;
 ;
OC ; Cancelled
DC ; Discontinued
 D DELETE^BRAPCC
 D UPDATE^BRAWH($G(RADFN),$G(RADTI),$G(RACNI))
 Q
 ;
 ;
RE ; Report verification
 ;
 ;IHS/CMI/DAY - Patch 1007 - Changes to pass PCC data
 ;
 I +$G(RADFN)=0 Q
 I +$G(RADTI)=0 Q
 I +$G(RACNI)=0 Q
 ;
 ;Check if V Rad entry has been created
 S BRAVRAD=$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC")),U,2)
 ;
 ;Get Exam Status (will look for COMPLETE later in the processing)
 S BRASTAT=""
 S BRASTIEN=$P(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0),U,3)
 I BRASTIEN S BRASTAT=$P(^RA(72,BRASTIEN,0),U)
 ;
 ;We have a verified report and 'Send PCC at Examined' is NO,
 ;then create the PCC Visit and create the Women's Health entry
 I $P($G(RA74("0")),U,5)="V",'RAPCC D  Q
 .D CREATE^BRAPCC
 .D CREATE^BRAWH(RADFN,RADTI,RACNI)
 .D PARENT
 ;
 ;We have a verified report and 'Send PCC at Examined' is YES,
 ;but no V Rad entry has been created, 
 ;then create V Rad entry and create the Women's Health entry
 I $P($G(RA74("0")),U,5)="V",RAPCC,+BRAVRAD=0 D  Q
 .D CREATE^BRAPCC
 .D CREATE^BRAWH(RADFN,RADTI,RACNI)
 .D PARENT
 ;
 ;We have a verified report and 'Send PCC at Examined' is YES,
 ;and the V Rad entry has been created,
 ;then update the V Rad entry and update the Women's Health entry
 I $P($G(RA74("0")),U,5)="V",RAPCC,+BRAVRAD D  Q
 .S RACN=$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),U)
 .D UPDTIMP^BRAPCC(RADFN,RADTI)
 .D UPDTDX^BRAWH(RADFN,RADTI,RACNI)
 .D PARENT
 ;
 ;Create visit and V RAD if exam status override to complete 
 ;and no V Rad entry exists
 I BRASTAT["COMPLETE",+BRAVRAD=0 D  Q
 .D CREATE^BRAPCC
 .D CREATE^BRAWH(RADFN,RADTI,RACNI)
 .D PARENT
 ;
 ;Update visit and V Rad if exam status override to complete,
 ;and a V Rad entry exists
 I BRASTAT["COMPLETE",+BRAVRAD D  Q
 .S RACN=$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),U)
 .D UPDTIMP^BRAPCC(RADFN,RADTI)
 .D UPDTDX^BRAWH(RADFN,RADTI,RACNI)
 .D PARENT
 ;
 Q
 ;
 ;
PARENT ;EP - Check/Process Parent and Descendents
 ;
 ;The RA IHS HOOK Protocol is NOT triggered each time a descendent
 ;report is verified and completed.  It only happens when the last
 ;descendent exam is verified and completed -- however, that 'last'
 ;one only processes that single exam.  Therefore, we must check the
 ;other descendents to make sure that they have passed data to PCC.
 ;
 ;Check this exam
 ;
 ;Is the report verified
 I $P($G(RA74("0")),U,5)'="V" Q
 ;
 ;Is the exam Complete
 I BRASTAT'["COMPLETE" Q
 ;
 ;Is the PCC link turned on
 I 'RAPCC Q
 ;
 ;Did this exam pass to PCC
 I +BRAVRAD=0 Q
 ;
 ;Is the Impression in V RAD something besides NO IMPRESSION.
 S Y=$$GET1^DIQ(9000010.22,BRAVRAD,1101)
 I Y["NO IMPRESSION" Q
 ;
 ;Check if member of set with separate reports (P25 = 1)
 I +$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),U,25)=0 Q
 ;
 ;Store Important Variables
 S BRAZCN=$G(RACN)
 S BRAZCNI=$G(RACNI)
 S BRAZRPT=$G(RARPT)
 ;
 ;Loop Other Exams to find Descendents with NO IMPRESSION.
 S RACNI=0
 F  S RACNI=$O(^RADPT(RADFN,"DT",RADTI,"P",RACNI)) Q:'RACNI  D
 .;
 .S BRAZERO=$G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0))
 .;
 .;Is this a member of a Printset
 .I +$P(BRAZERO,U,25)=0 Q
 .;
 .;Is there a report
 .S RARPT=$P(BRAZERO,U,17)
 .I RARPT="" Q
 .I '$D(^RARPT(RARPT)) Q
 .;
 .;Is the report verfied
 .I $$GET1^DIQ(74,RARPT,5)'="VERIFIED" Q
 .;
 .;Is the Exam Status COMPLETE
 .S BRASTIEN=$P(BRAZERO,U,3)
 .S BRASTAT=$P($G(^RA(72,BRASTIEN,0)),U)
 .I BRASTAT'="COMPLETE" Q
 .;
 .;Is there a PCC Node with a V Rad entry
 .S BRAVRAD=$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,"PCC")),U,2)
 .I BRAVRAD="" Q
 .I '$D(^AUPNVRAD(BRAVRAD)) Q
 .;
 .;Is the PCC impression equal to NO IMPRESSION.
 .I $$GET1^DIQ(9000010.22,BRAVRAD,1101)'="NO IMPRESSION." Q
 .;
 .;Update Impression
 .S RACN=$P($G(^RADPT(RADFN,"DT",RADTI,"P",RACNI,0)),U)
 .D UPDTIMP^BRAPCC(RADFN,RADTI)
 .D UPDTDX^BRAWH(RADFN,RADTI,RACNI)
 ;
 ;Restore Held Variables
 S RACNI=$G(BRAZCNI)
 S RACN=$G(BRAZCN)
 S RARPT=$G(BRAZRPT)
 ;
 Q
 ;
 ;
FIXVP ;EP - CALLED FROM NIGHTLY TASK TO CHECK AND FIX VISIT POINTERS IN RADIOLOGY PATIENT FILE
 ;IHS/CMI/LAB 04/12/21 CR #10047 PATCH 1009
 ;loop thorugh past 90 days of exams
 NEW BRABD,BRAED,BRAPAT,BRAI,BRADT,BRARVSIT,BRAVRAD
 S BRABD=$$FMADD^XLFDT(DT,-91)
 F  S BRABD=$O(^RADPT("AR",BRABD)) Q:BRABD'=+BRABD  D
 .S BRAPAT=0 F  S BRAPAT=$O(^RADPT("AR",BRABD,BRAPAT)) Q:BRAPAT'=+BRAPAT  D
 ..S BRADT=0 F  S BRADT=$O(^RADPT("AR",BRABD,BRAPAT,BRADT)) Q:BRADT'=+BRADT  D
 ...;now loop this multiple for all PCC nodes and check visit
 ...S BRAI=0 F  S BRAI=$O(^RADPT(BRAPAT,"DT",BRADT,"P",BRAI)) Q:BRAI'=+BRAI  D
 ....S BRARVSIT=$P($G(^RADPT(BRAPAT,"DT",BRADT,"P",BRAI,"PCC")),U,3)
 ....I BRARVSIT="" Q  ;NO VISIT
 ....S BRAVRAD=$P($G(^RADPT(BRAPAT,"DT",BRADT,"P",BRAI,"PCC")),U,2)
 ....I BRAVRAD="" Q   ;NO V RAD
 ....I '$D(^AUPNVRAD(BRAVRAD,0)) Q  ;V RAD HAS BEEN DELETED
 ....S BRAVRADV=$P(^AUPNVRAD(BRAVRAD,0),U,3)  ;V RAD VISIT
 ....I BRAVRADV'=BRARVSIT D FIXVP^BRAPCC2(BRAPAT,BRADT,BRAI,BRAVRAD)
 ....Q
 ...Q
 ..Q
 .Q
 Q
ASKRH(P,D) ;EP - called from RA EXAM EDIT input template
 ;IHS/CMI/LAB 05/10/2021 PATCH 1009 CR#8954 and #8979
 ;get imaging location for this exam, if 9999999.01 set to no return 0, else return 1
 NEW BRAIL,BRAARH
 S BRAIL=$P($G(^RADPT(P,"DT",D,0)),U,4)
 I 'BRAIL Q 0
 S BRAARH=$P($G(^RA(79.1,BRAIL,9999999)),U,1)
 I 'BRAARH Q 0
 Q 1
 ;
REQRH(P,D) ;EP - called from RA EXAM EDIT input template
 ;IHS/CMI/LAB 05/10/2021 PATCH 1009 CR#8954 and #8979
 ;get imaging location for this exam, if 9999999.02 set to no return 0, else return 1
 ;are these fields required
 NEW BRAIL,BRAARH
 S BRAIL=$P($G(^RADPT(P,"DT",D,0)),U,4)
 I 'BRAIL Q 0
 S BRAARH=$P($G(^RA(79.1,BRAIL,9999999)),U,2)
 I 'BRAARH Q 0
 Q 1
