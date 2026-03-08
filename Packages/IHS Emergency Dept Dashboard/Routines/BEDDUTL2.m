BEDDUTL2 ;GDIT/HS/BEE-BEDD Utility Routine 2 ; 08 Nov 2011  12:00 PM
 ;;2.0;BEDD DASHBOARD;**3,7**;Jun 04, 2014;Build 21
 ;
 Q
 ;
PROV(BEDDP,VIEN,FLTR) ;Return an array of providers for a visit
 ;
 ;FLTR - Pass one to not include the latest values in list
 ;
 S FLTR=+$G(FLTR)
 ;
 K BEDDP,EVIEN,PIEN,NIEN,PCOUNT,PLIST,T,D,P
 ;
 ;Verify a visit passed in
 I +$G(VIEN)<1 Q 0
 ;
 ;Loop through V EMERGENCY MANAGEMENT RECORD and retrieve nurses
 S EVIEN=$O(^AUPNVER("AD",VIEN,"")) I EVIEN="" Q 0
 S NIEN=0 F  S NIEN=$O(^AUPNVER(EVIEN,14,NIEN)) Q:'NIEN  D
 . ;
 . NEW NVIEN,NNAME,NTYPE,NDATE,DA,IENS
 . ;
 . ;Retrieve information for nurse
 . S DA(1)=EVIEN,DA=NIEN,IENS=$$IENS^DILF(.DA)
 . S NVIEN=$$GET1^DIQ(9000010.2914,IENS,.01,"I") Q:NVIEN=""
 . S NNAME=$$GET1^DIQ(200,NVIEN_",",.01,"E") S:NNAME="" NNAME=NVIEN Q:NNAME=""
 . S NTYPE=$$GET1^DIQ(9000010.2914,IENS,".02","E") Q:NTYPE=""
 . S NDATE=$$GET1^DIQ(9000010.2914,IENS,".03","I") Q:NDATE=""
 . ;
 . ;Set up return array
 . S PLIST(NTYPE,NDATE,NVIEN)=NNAME_"^"_$$FMTE^BEDDUTIL(NDATE)
 ;
 ;Loop through V EMERGENCY MANAGEMENT RECORD and retrieve providers
 S PIEN=0 F  S PIEN=$O(^AUPNVER(EVIEN,13,PIEN)) Q:'PIEN  D
 . ;
 . NEW PVIEN,PNAME,PTYPE,PDATE,DA,IENS,T,D,P
 . ;
 . ;Retrieve information for provider
 . S DA(1)=EVIEN,DA=PIEN,IENS=$$IENS^DILF(.DA)
 . S PVIEN=$$GET1^DIQ(9000010.2913,IENS,.01,"I") Q:PVIEN=""
 . S PNAME=$$GET1^DIQ(200,PVIEN_",",.01,"E") S:PNAME="" PNAME=PVIEN Q:PNAME=""
 . S PTYPE=$$GET1^DIQ(9000010.2913,IENS,".02","E") Q:PTYPE=""
 . S PDATE=$$GET1^DIQ(9000010.2913,IENS,".03","I") Q:PDATE=""
 . ;
 . ;Set up return array
 . S PLIST(PTYPE,PDATE,PVIEN)=PNAME_"^"_$$FMTE^BEDDUTIL(PDATE)
 ;
 ;Filter out latest entries if desired (will show at the top of the page)
 I FLTR D
 . S PTYPE="" F  S PTYPE=$O(PLIST(PTYPE)) Q:PTYPE=""  D
 .. NEW LPRV
 .. S (LPRV,PDATE)="" F  S PDATE=$O(PLIST(PTYPE,PDATE),-1) Q:PDATE=""  D
 ... S PVIEN="" F  S PVIEN=$O(PLIST(PTYPE,PDATE,PVIEN),-1) Q:PVIEN=""  D
 .... ;
 .... ;If the first entry, remove it
 .... I LPRV="" D
 ..... K PLIST(PTYPE,PDATE,PVIEN)
 ..... S LPRV=PTYPE_"^"_PDATE_"^"_PVIEN
 ;
 ;Set up output array
 S PCOUNT=0
 S T="" F  S T=$O(PLIST(T)) Q:T=""  D
 . S D="" F  S D=$O(PLIST(T,D)) Q:D=""  D
 .. S P="" F  S P=$O(PLIST(T,D,P)) Q:P=""  D
 ... S PCOUNT=PCOUNT+1
 ... S BEDDP(PCOUNT)=T_"^"_D_"^"_P_"^"_$P(PLIST(T,D,P),"^")_"^"_$P(PLIST(T,D,P),"^",2)
 S BEDDP=$S(PCOUNT>0:1,1:0)_"^"_PCOUNT
 ;
 Q BEDDP
 ;
CLIN(CLIN) ;EP - Return List of Applicable Clinics
 ;
 ;Input:
 ; None
 ;
 ;Output:
 ; CLIN Array - List of Clinics
 ;
 NEW CIEN,CTIEN,CNT
 K CLIN
 S CTIEN=$O(^AMER(2,"B","CLINIC TYPE","")) Q:CTIEN=""
 S CNT=0,CIEN="" F  S CIEN=$O(^AMER(3,"AC",CTIEN,CIEN)) Q:+CIEN=0  D
 . ;GDIT/HS/BEE 05/10/2018;CR#10213 - BEDD*2.0*3 - Filter out inactive
 . I $$GET1^DIQ(9009083,CIEN_",",.05,"I") Q
 . S CNT=CNT+1
 . ;GDIT/HS/BEE 07/10/2018;CR#10213 - BEDD*2.0*3 - Now use CIEN rather then code
 . ;S CLIN(CNT)=$$GET1^DIQ(9009083,CIEN_",",5,"I")_"^"_$$GET1^DIQ(9009083,CIEN_",",".01","I")
 . S CLIN(CNT)=CIEN_"^"_$$GET1^DIQ(9009083,CIEN_",",".01","I")
 ;
 Q
 ;
VCLIN(VIEN) ;Return the ER Clinic IEN based on the PCC visit
 ;
 I '$G(VIEN) Q ""
 ;
 Q $$GETCLN^AMER2A(VIEN)
 ;
 NEW CLIN,HL
 ;
 S CLIN=""
 ;
 ;First lookup by hospital location
 S HL=$$GET1^DIQ(9000010,VIEN_",",.22,"I")
 I HL]"" D
 . NEW INST,DA,IENS
 . ;
 . ;Get the Hospital Location Pointer to file 4
 . S INST=$$GET1^DIQ(44,HL_",",3,"I") Q:INST=""
 . ;
 . ;Now look in ER PREFERENCES for map to ER OPTION Entry
 . S DA(1)=INST,DA=$O(^AMER(2.5,"C",HL,INST,"")) Q:DA=""
 . S IENS=$$IENS^DILF(.DA)
 . S CLIN=$$GET1^DIQ(9009082.58,IENS,.01,"I")
 ;
 ;If not set - try old method
 I CLIN="" D
 . NEW CL
 . ;
 . ;Get the clinic code from the visit
 . S CL=$$GET1^DIQ(9000010,VIEN_",",.08,"I")
 . I CL]"" S CLIN=$O(^AMER(3,"B",CL,""))
 ;
 Q CLIN
 ;
GCLIN(CLIN) ;Return the clinic code and hospital location for the ER OPTION CIEN
 ;
 I '$G(CLIN) Q ""
 ;
 NEW HLOC,ICPREF
 ;
 S HLOC=""
 ;
 ;Look for associated hospital location
 S ICPREF=$O(^AMER(2.5,DUZ(2),8,"B",CLIN,"")) I ICPREF]"" D
 . NEW DA,IENS
 . S DA(1)=DUZ(2),DA=ICPREF,IENS=$$IENS^DILF(.DA)
 . S HLOC=$$GET1^DIQ(9009082.58,IENS,".02","I")
 ;
 ;If hospital location isn't set, pull from default
 S:HLOC="" HLOC=$G(^AMER(2.5,DUZ(2),"SD"))
 ;
 I HLOC="" D  Q ""
 . W !,"SITE PARAMETERS have not been set up in the ERS PARAMETER option"
 . W !,"No entry for EMERGENCY MEDICINE could be located"
 ;
 ;Get the clinic
 S CLIN=$$GET1^DIQ(44,HLOC_",",8,"I")
 ;
 Q CLIN_U_HLOC
 ;
MEDIAN(BEDDTOT) ;Return the median wait time for each dashboard section
 ;
 NEW EDSTAT,RETURN,WTG
 ;
 S RETURN=""
 ;
 ;Loop through sections and calculate the median for each
 S EDSTAT="" F  S EDSTAT=$O(BEDDTOT(EDSTAT)) Q:EDSTAT=""  D
 . NEW TOT,CNT
 . ;
 . ;Get the original section total cound
 . S TOT=+$P($G(BEDDTOT(EDSTAT)),"^")
 . ;
 . ;Handle zero in section
 . I TOT=0 S $P(RETURN,"^",EDSTAT)=0 Q
 . ;
 . ;Calculate median
 . F  D  Q:TOT<3  Q:$P(RETURN,"^",EDSTAT)]""
 .. ;
 .. ;Quit if already 1 or 2
 .. I TOT<3 Q
 .. ;
 .. ;Remove the first and last entry
 .. D MED(.BEDDTOT,EDSTAT,.TOT)
 . ;
 . ;None left - there is an issue - quit
 . I TOT<1 S $P(RETURN,"^",EDSTAT)=0 Q
 . ;
 . ;Get the median - one left
 . I TOT=1 D  Q
 .. S WTG=$O(BEDDTOT(EDSTAT,""))
 .. S $P(RETURN,"^",EDSTAT)=+WTG
 . ;
 . ;Get the median - two left - return their average
 . I TOT=2 S WTG=$$AVG(.BEDDTOT,EDSTAT) S $P(RETURN,"^",EDSTAT)=WTG Q
 ;
 Q RETURN
 ;
AVG(ARY,EDSTAT) ;Calculate the average of two remaining entries
 ;
 NEW WTG,AVG,TWTG,IEN
 ;
 ;Loop through remaining two entries for section and average
 S WTG="" F  S WTG=$O(ARY(EDSTAT,WTG)) Q:WTG=""  D
 . S IEN="" F  S IEN=$O(ARY(EDSTAT,WTG,IEN)) Q:IEN=""  D
 .. S TWTG=$G(TWTG)+WTG
 ;
 Q (+$G(TWTG)\2)
 ;
MED(ARY,EDSTAT,TOT) ;Remove the first and last entries
 ;
 NEW IEN,WTG
 ;
 ;Remove the first entry
 S IEN=""
 S WTG=$O(ARY(EDSTAT,""))
 I WTG]"" S IEN=$O(ARY(EDSTAT,WTG,""))
 I IEN]"" K ARY(EDSTAT,WTG,IEN)
 S TOT=$G(TOT)-1
 ;
 ;Remove the last entry
 S IEN=""
 S WTG=$O(ARY(EDSTAT,""),-1)
 I WTG]"" S IEN=$O(ARY(EDSTAT,WTG,""),-1)
 I IEN]"" K ARY(EDSTAT,WTG,IEN)
 S TOT=$G(TOT)-1
 ;
 Q
 ;
TOTAL(BEDD,BEDDTOT,MEDIAN) ;Assemble dashboard totals
 ;
 NEW EDSTAT
 ;
 S EDSTAT="" F  S EDSTAT=$O(BEDDTOT(EDSTAT)) Q:EDSTAT=""  D
 . NEW CNT,WTG,AVG
 . S CNT=$P(BEDDTOT(EDSTAT),"^")
 . S WTG=$P(BEDDTOT(EDSTAT),"^",2)
 . S AVG="" I CNT>0,WTG>0 S AVG=WTG\CNT
 . S BEDD("TSUM",EDSTAT)=CNT_"^"_WTG_"^"_+$P(MEDIAN,"^",EDSTAT)
 ;
 Q
