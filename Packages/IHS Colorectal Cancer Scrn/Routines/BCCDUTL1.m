BCCDUTL1 ;GDIT/HS/BEE-BCCD Utilities Routine 2 ; 08 Apr 2013  9:28 AM
 ;;2.0;CCDA;**1**;Aug 12, 2020;Build 106
 ;
 Q
 ;
SUBLST(SLST,SUBSET) ;Return concepts in a subset
 ;
 NEW STS
 ;
 S STS=$$SUBLST^BSTSAPI("SLST",SUBSET)
 ;
 Q 1
 ;
SUBSET(SLIST) ;Return list of subsets
 ;
 NEW STS
 ;
 KILL SLIT
 ;
 S STS=$$SUBSET^BSTSAPI("SLIST")
 ;
 Q 1
 ;
CDTC(X1,X2) ;Add/Subtract date
 ;
 NEW X
 I $G(X1)'?7N Q ""
 S X2=+$G(X2) I X2=0 Q ""
 D C^%DTC
 Q X
 ;
 ;GDIT/HS/BEE;FEATURE#76183;PBI#82985;02/09/22;Filter out particular stop codes
HVISIT(VLIST,INCDEL,SCSKIP) ;EP - Return all visit IENs for hospitalization
 ;
 ;Function will accept array of visit IENs for a hospitalization
 ;Returns all H and I visits for that hospitalization
 ;
 ;Input: 
 ; VLIST(VIENs) array - should contain at least one "I" visit or "H" visit
 ; INCDEL (Optional) - 1 to include deleted visits
 ; SCSKIP (Optional) - STOP CODES visits to skip
 ;
 ;Output:
 ; Function returns - H visit IEN associated with hospitalization
 ; Updated VLIST array - additional I visits or H visit could be added to VLIST
 ;
 ;
 NEW VIEN,HVISIT,IVISIT,IHVISIT
 ;
 ;Make sure visit passed in
 I $O(VLIST(""))="" Q "-1^No visit passed in"
 S INCDEL=$G(INCDEL)
 ;
 ;Loop through input list and locate H and/or I visit
 S (HVISIT,IVISIT,IHVISIT)=""
 ; Ok to quit if H visit found
 S VIEN="" F  S VIEN=$O(VLIST(VIEN)) Q:VIEN=""  D  Q:HVISIT]""
 . NEW SCAT,VDT
 . ;
 . ;Skip deleted visits
 . I 'INCDEL,$$GET1^DIQ(9000010,VIEN,.11,"I") Q
 . ;
 . ;Get service category
 . S SCAT=$$GET1^DIQ(9000010,VIEN,.07,"I") Q:SCAT=""
 . ;
 . ;Look for "H" visit
 . I HVISIT="",SCAT="H" S HVISIT=VIEN Q
 . ;
 . ;Look for "I" visit - try to find PARENT VISIT LINK
 . I SCAT="I",IHVISIT="" D
 .. ;
 .. ;Find PARENT VISIT LINK for I visit
 .. S IHVISIT=$$GET1^DIQ(9000010,VIEN,.12,"I")
 .. S IVISIT=VIEN
 ;
 ;If no H visit found, see if one was found in I visit
 S:HVISIT="" HVISIT=IHVISIT
 ;
 ;If no H visit or I visit found quit
 I HVISIT="",IVISIT="" Q "-1^No H or I type visit passed in"
 ;
 ;If no H visit, try locating it using I visit
 I HVISIT="" S HVISIT=$$GETHVST(IVISIT,.VLIST,INCDEL)
 ;
 ;Quit if no H visit
 I HVISIT="" Q "-1^No H visit could be located"
 ;
 ;Make sure H visit included in list
 S VLIST(HVISIT)=""
 ;
 ;Get all I visits and add them to VLIST
 D GETIVST(HVISIT,.VLIST,INCDEL,$G(SCSKIP))
 ;
 Q HVISIT
 ;
GETHVST(IVISIT,VLIST,INCDEL) ;EP - Given an I visit, try to find H visit
 ;
 ;Make sure IVISIT passed
 I $G(IVISIT)="" Q ""
 S INCDEL=$G(INCDEL)
 ;
 NEW VDT,PVDT,PVIEN,PVDAY,DFN,HVIEN,MAXDT,X1,X2,%H,X,MAXCK
 ;
 ;Get I visit date/time
 S VDT=$$GET1^DIQ(9000010,IVISIT,".01","I") Q:VDT="" ""
 ;
 ;Get DFN
 S DFN=$$GET1^DIQ(9000010,IVISIT,".05","I") Q:DFN="" ""
 ;
 ;Get date 3 years ago - farthest back to look
 S MAXDT=$P(VDT,".")
 S X1=MAXDT,X2=-1096
 D C^%DTC
 S MAXDT=X
 ;
 ;Loop through and try to locate H visit.
 ;Since "AA" index is reversed-timed by date with visit time tacked on
 ;to end of value, index cannot be looped straight through because
 ;date portion will be okay chronologically, but within each date those entries
 ;will be in reverse order.  Therefore have to loop through by date and within
 ;each date move backwards by visit time.
 ;
 ;Calculate where to start from by converting current visit date/time - Add 99 in case I
 ;and H have same date/time
 S PVDT=(9999999-$P(VDT,"."))_"."_$P(VDT,".",2)_"99"
 S HVIEN="",PVDAY=$P(PVDT,".")
 ;
 ;Loop backwards by date. If date changes, go get next date.
 S MAXCK=0
GETHVST1 F  S PVDT=$O(^AUPNVSIT("AA",DFN,PVDT),-1) Q:PVDT=""  Q:($P(PVDT,".")'=PVDAY)  D  I (HVIEN'="")!MAXCK Q
 . NEW VIEN
 . S VIEN="" F  S VIEN=$O(^AUPNVSIT("AA",DFN,PVDT,VIEN),-1) Q:VIEN=""  D  I (HVIEN'="")!MAXCK Q
 .. ;
 .. ;Skip deleted visits
 .. I '$G(INCDEL),$$GET1^DIQ(9000010,VIEN_",",".11","I") Q
 .. ;
 .. ;Look for maximum date to search back
 .. I $$GET1^DIQ(9000010,VIEN_",",.01,"I")<MAXDT S MAXCK=1 Q
 .. ;
 .. ;Quit if not H visit
 .. I $$GET1^DIQ(9000010,VIEN_",",".07","I")'="H" Q
 .. ;
 .. ;GDIT/HS/BEE;FEATURE#76183;PBI#82985;02/09/22;Filter out particular stop codes
 .. I '$$ELGVST^BCCDUTIL(VIEN,$G(SCSKIP)) Q
 .. ;
 .. S HVIEN=VIEN
 .. S VLIST(VIEN)=""
 ;
 ;Quit if visit found
 I HVIEN'="" G XGETHVST
 ;
 ;Previous visit was not found in this date range. Get next date
 ;in index and send back to loop to order by visit time.
 S PVDT=PVDAY_".9999"
 S PVDT=$O(^AUPNVSIT("AA",DFN,PVDT))
 I PVDT="" G XGETHVST
 S PVDAY=$P(PVDT,"."),PVDT=$P(PVDT,".")_".9999" G GETHVST1
 ;
 ;Return H visit if found
XGETHVST Q HVIEN
 ;
GETIVST(HVISIT,VLIST,INCDEL,SCSKIP) ;EP - Return I visits for H visit
 ;
 ;Check for valid H visit
 I $G(HVISIT)="" Q
 ;
 NEW VDT,HDSCHDT,VHIEN,DFN,PVDT,PVDAY,MAXDT
 ;
 ;Get H visit date/time
 S VDT=$$GET1^DIQ(9000010,HVISIT,".01","I") Q:VDT="" ""
 ;
 ;Get DFN
 S DFN=$$GET1^DIQ(9000010,HVISIT,".05","I") Q:DFN="" ""
 ;
 ;Loop through and try to find any I visits for H visit
 ;
 ;Calculate where to start from by converting current visit date/time
 S VDT=VDT-.00001
 S PVDT=(9999999-$P(VDT,"."))_"."_$P(VDT,".",2)
 S PVDAY=$P(PVDT,".")
 ;
 ;Loop by date. If date changes, go get next date.
 S MAXCK=0
GETIVST1 F  S PVDT=$O(^AUPNVSIT("AA",DFN,PVDT)) Q:PVDT=""  Q:($P(PVDT,".")'=PVDAY)  D  I MAXCK Q
 . NEW VIEN,PVL,SCAT,HL,SC,SKIP
 . S VIEN="" F  S VIEN=$O(^AUPNVSIT("AA",DFN,PVDT,VIEN)) Q:VIEN=""  D  I MAXCK Q
 .. ;
 .. ;Skip deleted visits
 .. I '$G(INCDEL),$$GET1^DIQ(9000010,VIEN_",",".11","I") Q
 .. ;
 .. ;Get service category
 .. S SCAT=$$GET1^DIQ(9000010,VIEN_",",".07","I")
 .. ;
 .. ;Quit if we get to another H visit
 .. I SCAT="H",VIEN'=HVISIT S MAXCK=1 Q
 .. ;
 .. ;Quit if not an I visit
 .. I SCAT'="I" Q
 .. ;
 .. ;Quit if PARENT VISIT LINK populated and not H visit
 .. S PVL=$$GET1^DIQ(9000010,VIEN_",",".12","I")
 .. I PVL]"",PVL'=HVISIT Q
 .. ;
 .. ;GDIT/HS/BEE;FEATURE#76183;PBI#82985;02/09/22;Filter out particular stop codes
 .. I '$$ELGVST^BCCDUTIL(VIEN,$G(SCSKIP)) Q
 .. ;
 .. ;Add to list
 .. S VLIST(VIEN)=""
 ;
 ;Quit if max date found
 I MAXCK G XGETIVST
 ;
 ;Get next date in index and send back to loop
 ;to order by visit time.
 S PVDT=PVDAY
 S PVDT=$O(^AUPNVSIT("AA",DFN,PVDT),-1)
 I PVDT="" G XGETIVST
 S PVDAY=$P(PVDT,"."),PVDT=$P(PVDT,".") G GETIVST1
 ;
XGETIVST Q
 ;
RLDFVLAB(VLABIEN) ; EP - Return Lab Data From V LAB
 NEW DFN,LRDFN,COLLDATE,LRIDT,F60IEN,DATANAME,VIEN,SCAT
 ;
 S DFN=$$GET1^DIQ(9000010.09,VLABIEN_",",".02","I")
 S VIEN=$$GET1^DIQ(9000010.09,VLABIEN_",",".03","I")
 S SCAT=$$GET1^DIQ(9000010,VIEN_",",".07","I")
 I SCAT'="A",SCAT'="H",SCAT'="I",SCAT'="S",SCAT'="O" Q -1
 S LRDFN=$$GET1^DIQ(2,DFN_",",63,"I") ;I 'LRDFN Q ""
 ;
 I LRDFN="" Q 0
 ;
 S COLLDATE=$$GET1^DIQ(9000010.09,VLABIEN,"COLLECTION DATE AND TIME","I")
 S LRIDT=9999999-COLLDATE
 ;
 I $D(^LR(LRDFN,"CH",LRIDT))<1 Q ""
 ;
 S F60IEN=$$GET1^DIQ(9000010.09,VLABIEN,"LAB TEST","I")
 I $$ISPANEL^BLRPOC(F60IEN) Q ""
 ;
 S DATANAME=$$GET1^DIQ(60,F60IEN,"DATA NAME","I")
 ;
 S DATASTR=$G(^LR(LRDFN,"CH",LRIDT,DATANAME))
 S VERIFYI=$P(DATASTR,U,9)
 S VERIFY=$$GET1^DIQ(4,VERIFYI,"NAME")
 S RESULTDT=$P(DATASTR,U,6)
 ;
 ;If no verify location look in Accessioning Location
 S LINST=VERIFYI I LINST="" S LINST=$P($G(^LR(LRDFN,"CH",LRIDT,0)),U,14)
 ;
 Q LINST
 S T="~"
 Q RESULTDT_U_VERIFYI_T_VERIFY_U_DFN_U_LRDFN_U_LRIDT_U_LRAS_U_LDLRAS_U_LINST
 ;
TFRAME(TFRM,RDT) ;Return beginning date specified by timeframe
 ;
 I $G(TFRM)="" Q ""
 ;
 ;If no run date, assume today
 S:$G(RDT)="" RDT=DT
 ;
 NEW II,FND,DWMY,ENDT,X1,X2,X
 ;
 ;Get last date
 S X1=RDT,X2=-1 D C^%DTC S ENDT=X
 ;
 ;Handle formatting
 S FND=0 F II=1:1:$L(TFRM) I $E(TFRM,II)'?1N S FND=1 Q
 I FND=0 Q ""
 ;
 ;Look for type
 S DWMY=$E(TFRM,II,9999) I (".CM.CW.CY.LD.LM.LW.LY.PY.PM.PW."'[("."_DWMY_".")) Q ""
 S LST=$E(TFRM,1,II-1) S:LST="" LST=1
 ;
 I DWMY="LD" Q $$TFD(LST,ENDT)_U_ENDT ;Days
 I DWMY="LM" Q $$TFM(LST,ENDT)_U_ENDT ;Months
 I DWMY="LW" Q $$TFW(LST,ENDT)_U_ENDT ;Weeks
 I DWMY="LY" Q $$TFY(LST,ENDT)_U_ENDT ;Years
 I DWMY="PY" Q $$TFPY(LST,RDT) ;Previous Years
 I DWMY="PM" Q $$TFPM(LST,RDT) ;Previous Months
 I DWMY="PW" Q $$TFPW(LST,RDT) ;Previous Weeks
 I DWMY="CY" Q $$TFCY(RDT) ;Current year
 I DWMY="CM" Q $$TFCM(RDT) ;Current month
 I DWMY="CW" Q $$TFCW(RDT) ;Current week
 ;
 Q LST_"|"_DWMY
 ;
TFCW(RDT) ;Return current week
 ;
 NEW X1,X2,X,W,LDT,%H,%T,%Y,SUN
 ;
 ;Go to the last Sunday
 S X=RDT,SUN="" F  D  Q:SUN]""
 . S LDT=X D H^%DTC
 . I %Y=0 S SUN=LDT Q
 . S X1=X,X2=-1 D C^%DTC
 I SUN="" Q ""
 ;
 Q SUN_U_RDT
 ;
TFCM(RDT) ;Return current month
 ;
 NEW BDT
 ;
 S BDT=$E(RDT,1,5)_"01"
 Q BDT_U_RDT
 ;
TFCY(RDT) ;Return current year
 ;
 NEW BDT
 ;
 S BDT=$E(RDT,1,3)_"0101"
 Q BDT_U_RDT
 ;
TFD(LST,RDT) ;Return last x days date
 ;
 NEW X1,X2,X
 ;
 ;Get date
 S X1=RDT,X2=-(LST-1)
 D C^%DTC
 Q X
 ;
TFM(LST,RDT) ;Return last x months date
 ;
 NEW X1,X2,X,CDAY,CD,CM,CY,CC,%DT,Y,FDT,CT,II
 ;
 ;Get previous date
 S X1=RDT,X2=-1 D C^%DTC
 S CDAY=RDT
 ;
 ;Get current month,year,day
 S CM=$E(CDAY,4,5),CD=$E(CDAY,6,7)
 S CC=$E(CDAY,1),CY=$E(CDAY,2,3)
 S CY=$S(CC=1:18,CC=2:19,CC=3:20,CC=4:21,1:00)_CY
 ;
 ;Back up by number of months
 F CT=LST:-1:1 S CM=CM-1 I CM<1 S CM=12,CY=CY-1
 ;
 ;Check if date is month end, return month end
 S X1=RDT,X2=1 D C^%DTC
 S %DT="X" D ^%DT
 I Y<0 D  Q X
 . S FDT="" F II=31:-1:28 D  Q:FDT]""
 .. S X=CM_"/"_II_"/"_CY
 .. S %DT="X" D ^%DT
 .. I Y>0 S FDT=1,X=Y Q
 ;
 ;Not month end back up until valid date
 S FDT="" F  D  Q:FDT]""
 . S X=CM_"/"_CD_"/"_CY
 . S %DT="X" D ^%DT
 . I Y>0 S FDT=1,X=Y Q
 . S CD=CD-1 I CD=0 S FDT=1,X=""
 ;
 Q X
 ;
TFW(LST,RDT) ;Return last x weeks date
 ;
 NEW X1,X2,X,W
 ;
 S W=LST*7
 ;
 ;Get date
 S X1=RDT,X2=-(W-1)
 D C^%DTC
 Q X
 ;
TFY(LST,RDT) ;Return last x years date
 ;
 NEW CDAY,CY,CC,FND,%DT,X,Y,CD
 ;
 S CDAY=RDT
 S CY=$E(CDAY,1,3)
 S CY=CY-LST
 S CC=$E(CY,1)
 S CDAY=$E(CDAY,4,5)_"/"_$E(CDAY,6,7)_"/"_$S(CC=3:20,CC=2:19,CC=1:18,CC=4:21,1:"")_$E(CY,2,3)
 S FND=0 F  D  Q:FND
 . NEW CD
 . S %DT="X",X=CDAY D ^%DT
 . I Y>0 S FND=1 Q
 . S CD=$P(CDAY,"/",2),CD=CD-1 I CD<1 S FND=1,Y=""
 . S $P(CDAY,"/",2)=CD
 Q Y
 ;
TFPY(LST,RDT) ;Return previous x years date range
 ;
 NEW CDAY,CY,CC,%DT,X,Y,ENDT
 ;
 ;Calculate end date
 S ENDT=""
 S CY=$E(RDT,1,3)
 S CY=CY-1
 S CC=$E(CY,1)
 S CDAY="12/31/"_$S(CC=3:20,CC=2:19,CC=1:18,CC=4:21,1:"")_$E(CY,2,3)
 S %DT="X",X=CDAY D ^%DT
 I Y>0 S ENDT=Y
 E  Q ""
 ;
 ;Calculate beginning date
 S CY=$E(RDT,1,3)
 S CY=CY-LST
 S CC=$E(CY,1)
 S CDAY="01/01/"_$S(CC=3:20,CC=2:19,CC=1:18,CC=4:21,1:"")_$E(CY,2,3)
 S %DT="X",X=CDAY D ^%DT
 I Y>0 Q Y_U_ENDT
 Q ""
 ;
TFPM(LST,RDT) ;Return previous x months date range
 ;
 NEW X1,X2,X,CDAY,CD,CM,CY,CC,%DT,Y,FDT,CT,EM,EY,II,ENDT
 ;
 ;Get the current month,year,day
 S (EM,CM)=$E(RDT,4,5),CD=$E(RDT,6,7)
 S CC=$E(RDT,1),CY=$E(RDT,2,3)
 S (EY,CY)=$S(CC=1:18,CC=2:19,CC=3:20,CC=4:21,1:00)_CY
 ;
 ;Get previous month
 S EM=EM-1 I EM<1 S EM=12,EY=CY-1
 S FDT="" F II=31:-1:28  D  Q:FDT]""
 . S X=EM_"/"_II_"/"_EY
 . S %DT="X" D ^%DT
 . I Y>0 S FDT=1,X=Y Q
 I FDT="" Q ""
 S ENDT=X
 ;
 ;Back up by number of months
 F CT=LST:-1:1 S CM=CM-1 I CM<1 S CM=12,CY=CY-1
 S X=CM_"/01/"_CY
 S %DT="X" D ^%DT
 I Y>0 Q Y_U_ENDT
 ;
 Q ""
 ;
 ;
TFPW(LST,RDT) ;Return previous x weeks date range
 ;
 NEW X1,X2,X,W,LDT,%H,%T,%Y,SUN,ENDT
 ;
 ;Go to last Sunday
 S X=RDT,SUN="" F  D  Q:SUN]""
 . S LDT=X D H^%DTC
 . I %Y=0 S SUN=LDT Q
 . S X1=X,X2=-1 D C^%DTC
 I SUN="" Q ""
 ;
 ;Now back up one day to get end date
 S X1=SUN,X2=-1 D C^%DTC S ENDT=X
 ;
 ;Now drop back number of weeks
 S W=LST*7
 ;
 ;Get date
 S X1=SUN,X2=-W
 D C^%DTC
 Q X_U_ENDT
 ;
TF(X) ;Check format of timeframe
 I $G(X)="" Q ""
 I X?1N.N.1"LD" Q X
 I X?1N.N.1"LW" Q X
 I X?1N.N.1"LM" Q X
 I X?1N.N.1"LY" Q X
 I X?1N.N.1"PW" Q X
 I X?1N.N.1"PM" Q X
 I X?1N.N.1"PY" Q X
 I X?1."CY" Q X
 I X?1."CW" Q X
 I X?1."CM" Q X
 Q ""
 ;
ENCVST(EVISIT,VLIST,VDT,SCSKIP) ;EP - Given visit, locate visits within last year
 ;
 ;Returns list of visits in VLIST
 ;
 ;Make sure EVISIT passed in
 I $G(EVISIT)="" Q 0
 ;
 ;Check earliest visit date
 S:$G(VDT)="" VDT=$G(DT)
 ;
 NEW PVDT,PVIEN,PVDAY,DFN,MAXDT,%H,MAXCK,X1,X2,X,VTIME
 ;
 ;Make sure time complete
 S VTIME=$E($P(VDT,".",2)_"0000",1,4)
 S $P(VDT,".",2)=VTIME
 ;
 ;Get DFN
 S DFN=$$GET1^DIQ(9000010,EVISIT,".05","I") Q:DFN="" 0
 ;
 ;Get date 1 year ago - farthest back to look
 ;Function goes back one year from yesterday so need to pass in tomorrow
 set X1=VDT,X2=1 D C^%DTC
 set MAXDT=$p($$TFRAME^BCCDUTL1("LY",X),U)
 ;
 ;Loop through and try to locate any visits in last year
 ;Since "AA" index is reversed-timed by date with visit time tacked on
 ;to end of value, the index cannot be looped straight through because
 ;date portion will be okay chronologically, but within each date those entries
 ;will be in reverse order.  Therefore have to loop through by date and within
 ;each date move backwards by visit time.
 ;
 ;Calculate where to start from by converting current visit date/time
 S PVDT=(9999999-$P(VDT,"."))_"."_$P(VDT,".",2)_"99"
 S PVDAY=$P(PVDT,".")
 ;
 ;Loop backwards by date. If date changes, go get next date.
 S MAXCK=0
GETEVST1 F  S PVDT=$O(^AUPNVSIT("AA",DFN,PVDT),-1) Q:PVDT=""  Q:($P(PVDT,".")'=PVDAY)  D  I MAXCK Q
 . NEW VIEN,SCAT,SKIP
 . S VIEN="" F  S VIEN=$O(^AUPNVSIT("AA",DFN,PVDT,VIEN),-1) Q:VIEN=""  D  I MAXCK Q
 .. ;
 .. ;Skip deletes
 .. I '$G(INCDEL),$$GET1^DIQ(9000010,VIEN_",",".11","I") Q
 .. ;
 .. ;Look for maximum date to search back
 .. I $$GET1^DIQ(9000010,VIEN_",",.01,"I")<MAXDT S MAXCK=1 Q
 .. ;
 .. ;Quit if not in SERVICE CATEGORY
 .. S SCAT=$$GET1^DIQ(9000010,VIEN_",",".07","I")
 .. ;BEE;Added 'I' to get previous 'I' visits
 .. I (",A,H,O,R,S,M,I,"'[(","_SCAT_",")) Q
 .. ;
 .. ;GDIT/HS/BEE;FEATURE#76183;PBI#82985;02/09/22;Filter out particular stop codes
 .. I '$$ELGVST^BCCDUTIL(VIEN,$G(SCSKIP)) Q
 .. ;
 .. ;Special filtering logic for Ambulatory and Telemedicine
 .. S SKIP="" I (",A,M,"[(","_SCAT_",")) D  I SKIP Q
 ... S SKIP=1
 ... ;
 ... NEW CLINIC,AWRKLD
 ... ;
 ... ;Get workload reportable-Only include if Yes
 ... S CLINIC=$$GET1^DIQ(9000010,VIEN_",",.08,"I") Q:CLINIC=""
 ... ;
 ... S AWRKLD=$$GET1^DIQ(40.7,CLINIC_",",90000.01,"I")
 ... I AWRKLD="Y" S SKIP=""
 .. ;
 .. S VLIST(VIEN)=""
 ;
 ;Prev visit not found in date range. Get next date
 ;in index and send back to loop to order by visit time.
 S PVDT=PVDAY_".9999"
 S PVDT=$O(^AUPNVSIT("AA",DFN,PVDT))
 I PVDT="" G XGETEVST
 S PVDAY=$P(PVDT,"."),PVDT=$P(PVDT,".")_".9999" G GETEVST1
 ;
XGETEVST Q 1
