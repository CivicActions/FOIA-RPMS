ADSFAC ;GDIT/HS/KJH-ADS Package ASUFAC Report ; April 6, 2022
 ;;1.0;DISTRIBUTION MANAGEMENT;**1,3,4,5,6**;Apr 23, 2020;Build 8
EN ;
 NEW %ZIS,DIR,DTOUT,DUOUT,IOP,POP,X,Y,NOW,NOWH,NOWFM
 NEW IEN,AR,FAC,IN,INSTIEN,SITE,H
 K AR
 ;
 S $P(H,"-",75)="-"
 ;
 S FAC=$$FACILITY^ADSUTL  ;IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455;moved code to ADSUTL
 D ASUFAC
 I $D(ZTQUEUED) D EN1 Q
 E  D DISPLAY Q
 Q
DISPLAY ; Display the compiled ASUFAC data.
 K IOP,%ZIS
 W !! S %ZIS="PM" D ^%ZIS
 I POP Q
 U IO
 S IN=""
 F  S IN=$O(AR(IN)) Q:IN=""  D DISPLAY1 I $D(DTOUT)!$D(DUOUT) Q
 Q
DISPLAY1 ;
 D EN^DDIOL(" ")
 D EN^DDIOL(H)
 D EN^DDIOL("Institution Number             : "_IN)
 D EN^DDIOL("Site Name                      : "_$G(AR(IN,"SITE")))
 D EN^DDIOL("Official Registering Facility? : "_$G(AR(IN,"ORF")))
 D EN^DDIOL("Unique RPMS DB ID              : "_$G(AR(IN,"DBID")))
 D EN^DDIOL("ASUFAC Index                   : "_$G(AR(IN,"INDEX")))
 D EN^DDIOL("Pseudo Prefix                  : "_$G(AR(IN,"PP")))
 D EN^DDIOL("Station Number                 : "_$G(AR(IN,"STN")))
 D EN^DDIOL("Site ASUFAC                    : "_$G(AR(IN,"SASUFAC")))
 D EN^DDIOL("Site DBID                      : "_$G(AR(IN,"SDBID")))
 D EN^DDIOL("Site Street Address            : "_$G(AR(IN,"STREET")))
 D EN^DDIOL("Site City                      : "_$G(AR(IN,"CITY")))
 D EN^DDIOL("Site State                     : "_$G(AR(IN,"STATE")))
 D EN^DDIOL("Site Zip Code                  : "_$G(AR(IN,"ZIP")))
 D EN^DDIOL("Site Mailing Street Address    : "_$G(AR(IN,"MSTREET")))
 D EN^DDIOL("Site Mailing City              : "_$G(AR(IN,"MCITY")))
 D EN^DDIOL("Site Mailing State             : "_$G(AR(IN,"MSTATE")))
 D EN^DDIOL("Site Mailing Zip               : "_$G(AR(IN,"MZIP")))
 D EN^DDIOL("AREA Office                    : "_$G(AR(IN,"AREA")))
 D EN^DDIOL("AREA Office Code               : "_$G(AR(IN,"AOFFICECODE")))
 D EN^DDIOL("Site I/T/U Designation         : "_$G(AR(IN,"SITEITU")))
 D EN^DDIOL("Site Service Unit              : "_$G(AR(IN,"SVCUNIT")))
 D EN^DDIOL("Site Service Unit Code         : "_$G(AR(IN,"SVCCODE")))
 D EN^DDIOL("Facility Location Code         : "_$G(AR(IN,"FLOCCODE")))
 D EN^DDIOL("Facility Type                  : "_$G(AR(IN,"FACTYPE")))
 D EN^DDIOL("Multidivisional                : "_$G(AR(IN,"MULTI")))
 D EN^DDIOL("Multidivisional Type           : "_$G(AR(IN,"MULTTYPE")))
 D EN^DDIOL("Parent                         : "_$G(AR(IN,"PARENT")))
 D EN^DDIOL("Child                          : "_$G(AR(IN,"CHILD")))
 D EN^DDIOL("NPI#                           : "_$G(AR(IN,"NPI")))
 D EN^DDIOL("DEA#                           : "_$G(AR(IN,"DEA")))
 D EN^DDIOL("Financial Location Code        : "_$G(AR(IN,"FLOC")))
 D EN^DDIOL("Federal Tax ID                 : "_$G(AR(IN,"TAXID")))
 D EN^DDIOL("Medicare Provider ID           : "_$G(AR(IN,"MCARE")))
 D EN^DDIOL("Direct Email Address           : "_$G(AR(IN,"DIRECT")))
 D EN^DDIOL("MNEMONIC                       : "_$G(AR(IN,"MNEMONIC")))
 D EN^DDIOL("ABBRV                          : "_$G(AR(IN,"ABBRV")))
 D EN^DDIOL("Short Name                     : "_$G(AR(IN,"SHORT")))
 D EN^DDIOL("Medical Center Name            : "_$G(AR(IN,"MCENTER")))
 D EN^DDIOL("Agency Code                    : "_$G(AR(IN,"AGCODE")))
 D EN^DDIOL("Pointer to Agency              : "_$G(AR(IN,"AGPOINT")))
 D EN^DDIOL("Associations                   : "_$G(AR(IN,"ASSOC")))
 D EN^DDIOL("Parent of Association          : "_$G(AR(IN,"PASSOC")))
 D EN^DDIOL("Class Info                     : "_$G(AR(IN,"CLASS")))
 D EN^DDIOL("Site GUID                      : "_$P($$SITE^ADSUTL,U,4)) ;IHS/GDIT/AEF ;ADS*1.0*6 FID110314
 D EN^DDIOL("Site Domain Name               : "_$P($$SITE^ADSUTL,U,5)) ;IHS/GDIT/AEF ;ADS*1.0*6 FID110314
 D EN^DDIOL(H)
 D EN^DDIOL(" ")
 D ^%ZISC
 K DIR
 S DIR(0)="E"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT) Q
 Q
EN1 ; Output text to BSTS contains the following data delimited by "|" symbols, in this order:
 ; 1 - FACILITY     - Facility (4 digit Facility or Site Number
 ; 2 - IN           - Institution
 ; 3 - SITE         - Site Name
 ; 4 - ORF          - Official Registering Facility (YES/NO)
 ; 5 - DBID         - Unique RPMS DB ID
 ; 6 - INDEX        - ASUFAC Index
 ; 7 - PP"          - Pseudo Prefix
 ; 8 - STN          - Station Number
 ; 9 - SASUFAC      - Site ASUFAC
 ;10 - SDBID        - Site DBID
 ;11 - STREET       - Site Physical Street
 ;12 - CITY         - Site Physical City
 ;13 - STATE        - Site Physical State
 ;14 - ZIP          - Site Physical Zip
 ;15 - AREA         - Area Office
 ;16 - AOFFOCE CODE - AREA Office Code
 ;17 - SITEITU      - Site I/T/U Designation
 ;18 - CLASS        - CLASS multiple (Multiple records '&' delimited, fields '~' delimited)
 ;                     - BEGIN DATE (1)
 ;                     - IHS/NON-IHS (2)
 ;                     - CLASS (3)
 ;19 - SVCUNIT      - Site Service Unit
 ;20 - SVCCODE      - Site Service Unit Code
 ;21 - FLOCCODE     - Facility Location Code
 ;22 - MSTREET      - Mailing Street
 ;23 - MCITY        - Mailing City
 ;24 - MSTATE       - Mailing State
 ;25 - MZIP         - Mailing Zip
 ;26 - MULTI        - Multi Divisional
 ;27 - NPI          - National Provider ID
 ;28 - DEA          - DEA Number
 ;29 - TAXID        - Federal Tax ID
 ;30 - MCARE        - Medicare Provider ID
 ;31 - FLOC         - Financial Location Code
 ;32 - DIRECT       - Direct Email Address
 ;33 - MNEMONIC     - Mnemonic
 ;34 - ABBRV        - ABBRV
 ;35 - SHORT        - Short Name
 ;36 - MCENTER      - Medical Center Name
 ;37 - AGCODE       - Agency Code
 ;38 - AGPOINT      - Pointer to Agency
 ;39 - ASSOC        - Association
 ;40 - FACTYPE      - Facility Type
 ;41 - MULTTYPE     - Multidivisional Type
 ;42 - PARENT       - Parent
 ;43 - CHILD        - Child
 ;44 - PASSOC       - Parent of Association
 ;45 - GUID         - Site GUID ;IHS/GDIT/AEF ;ADS*1.0*6 FID110314
 ;46 - DOMAIN       - Site Domain Name ;IHS/GDIT/AEF ;ADS*1.0*6 FID110314
 ;
 I $T(LOG^BSTSAPIL)="" Q  ; Check for existence of send routine
 N STR,SINFO,SASUFAC,SDBID
 ;
 N ADSDT,CNT S ADSDT=$$NOW^XLFDT,CNT=0   ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINE
 S IN=""
 F  S IN=$O(AR(IN)) Q:IN=""  D
 . S STR=""
 . S STR=STR_FAC_"|"  ;1
 . S STR=STR_IN_"|"  ;2
 . S STR=STR_$G(AR(IN,"SITE"))_"|"  ;3
 . S STR=STR_$G(AR(IN,"ORF"))_"|"  ;4
 . S STR=STR_$G(AR(IN,"DBID"))_"|"  ;5
 . S STR=STR_$G(AR(IN,"INDEX"))_"|"  ;6
 . S STR=STR_$G(AR(IN,"PP"))_"|"  ;7
 . S STR=STR_$G(AR(IN,"STN"))_"|"  ;8
 . S STR=STR_$G(AR(IN,"SASUFAC"))_"|"  ;9
 . S STR=STR_$G(AR(IN,"SDBID"))_"|"  ;10
 . S STR=STR_$G(AR(IN,"STREET"))_"|"  ;11
 . S STR=STR_$G(AR(IN,"CITY"))_"|"  ;12
 . S STR=STR_$G(AR(IN,"STATE"))_"|"  ;13
 . S STR=STR_$G(AR(IN,"ZIP"))_"|"  ;14
 . S STR=STR_$G(AR(IN,"AREA"))_"|"  ;15
 . S STR=STR_$G(AR(IN,"AOFFICECODE"))_"|"  ;16
 . S STR=STR_$G(AR(IN,"SITEITU"))_"|"  ;17
 . S STR=STR_$G(AR(IN,"CLASS"))_"|"  ;18
 . S STR=STR_$G(AR(IN,"SVCUNIT"))_"|"  ;19
 . S STR=STR_$G(AR(IN,"SVCCODE"))_"|"  ;20
 . S STR=STR_$G(AR(IN,"FLOCCODE"))_"|"  ;21
 . S STR=STR_$G(AR(IN,"MSTREET"))_"|"  ;22
 . S STR=STR_$G(AR(IN,"MCITY"))_"|"  ;23
 . S STR=STR_$G(AR(IN,"MSTATE"))_"|"  ;24
 . S STR=STR_$G(AR(IN,"MZIP"))_"|"  ;25
 . S STR=STR_$G(AR(IN,"MULTI"))_"|"  ;26
 . S STR=STR_$G(AR(IN,"NPI"))_"|"  ;27
 . S STR=STR_$G(AR(IN,"DEA"))_"|"  ;28
 . S STR=STR_$G(AR(IN,"TAXID"))_"|"  ;29
 . S STR=STR_$G(AR(IN,"MCARE"))_"|"  ;30
 . S STR=STR_$G(AR(IN,"FLOC"))_"|"  ;31
 . S STR=STR_$G(AR(IN,"DIRECT"))_"|"  ;32
 . S STR=STR_$G(AR(IN,"MNEMONIC"))_"|"  ;33
 . S STR=STR_$G(AR(IN,"ABBRV"))_"|"  ;34
 . S STR=STR_$G(AR(IN,"SHORT"))_"|"  ;35
 . S STR=STR_$G(AR(IN,"MCENTER"))_"|"  ;36
 . S STR=STR_$G(AR(IN,"AGCODE"))_"|"  ;37
 . S STR=STR_$G(AR(IN,"AGPOINT"))_"|"  ;38
 . S STR=STR_$G(AR(IN,"ASSOC"))_"|"  ;39
 . S STR=STR_$G(AR(IN,"FACTYPE"))_"|"  ;40
 . S STR=STR_$G(AR(IN,"MULTTYPE"))_"|"  ;41
 . S STR=STR_$G(AR(IN,"PARENT"))_"|"  ;42
 . S STR=STR_$G(AR(IN,"CHILD"))_"|"  ;43
 . S STR=STR_$G(AR(IN,"PASSOC"))_"|"  ;44   ;IHS/GDIT/AEF ;ADS*1.0*6 FID110314 ADDED "|"
 . S STR=STR_$P($$SITE^ADSUTL,U,4)_"|"  ;45 GUID ;IHS/GDIT/AEF ;ADS*1.0*6 FID110314
 . S STR=STR_$P($$SITE^ADSUTL,U,5)  ;46 DOMAIN ;IHS/GDIT/AEF ;ADS*1.0*6 FID110314
 . D LOG^BSTSAPIL("ASU",42,"FAC",$$TFRMT^ADSRPT(STR))
 . S CNT=CNT+1   ;IHS/GDIT/AEF ADS*1.0*6 FID107834; NEW LINE
 . Q
 ;
 ;IHS/GDIT/AEF ADS*1.0*6 FID107834; New lines below
 ;Update ADS EXPORT LOG file:
 D UPDTLOG^ADSUTL(ADSDT,"ASU",CNT)
 Q
ASUFAC ;
 ;
 NEW SINFO,SASUFAC,SDBID,SADDR1,SADDR2,SIEN,CITY,STATE,ZIP,ALIST,PC,PNT,CHD,ASC
 ;
 ;Get site IEN, ASUFAC and DBID
 S SINFO=$$SITE^ADSUTL()  ;IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455; Changed call to $$SITE^ADSUTL
 S SASUFAC=$P(SINFO,U)  ;Site ASUFAC
 S SDBID=$P(SINFO,U,2)  ;Site DBID
 S SIEN=$P(SINFO,U,3)  ;Site IEN
 ;
 ;Need to loop through first time to get parent/child
 S IN=0 F  S IN=$O(^AGFAC(IN)) Q:'IN  D
 . NEW ASSOC,SITE,INSTIEN,IASSOC,TASSOC,II,ENTRY
 . S SITE=$$GET1^DIQ(9009061,IN_",",.01,"I") ; Get SITE IEN
 . Q:SITE']""   ;IHS/GDIT/AEF ADS*1.0*6 FID107263
 . S INSTIEN=$$GET1^DIQ(9999999.06,SITE_",",.01,"I") Q:INSTIEN=""
 . S ASSOC=$$ASSOC^ADSUTL(INSTIEN,1) ;IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455 ;Changed call to $$ASSOC^ADSUTL
 . F II=1:1:$L(ASSOC,"&") S ENTRY=$P(ASSOC,"&",II) D
 .. S IASSOC=$P(ENTRY,"~",3) Q:IASSOC=""
 .. S TASSOC=$P(ENTRY,"~") Q:TASSOC'="PARENT FACILITY"
 .. S ALIST("P",INSTIEN,IASSOC)=""
 .. S ALIST("C",IASSOC,INSTIEN)=""
 ;
 ;Now loop through and pull information
 S IN=0
 F  S IN=$O(^AGFAC(IN)) Q:'IN  D
 . S SITE=$$GET1^DIQ(9009061,IN_",",.01,"I") ; Get SITE IEN
 . Q:SITE']""   ;IHS/GDIT/AEF ADS*1.0*6 FID107263
 . S AR(IN,"ORF")=$$GET1^DIQ(9009061,IN_",",20,"E") ; Get OFFICIAL REGISTERING FACILITY flag
 . S AR(IN,"SITE")=$$GET1^DIQ(9999999.06,SITE_",",.01,"E") ; Get SITE NAME
 . S AR(IN,"DBID")=$$GET1^DIQ(9999999.06,SITE_",",.32,"E") ; Get UNIQUE RPMS DB ID
 . S AR(IN,"INDEX")=$$GET1^DIQ(9999999.06,SITE_",",.12,"E") ; Get ASUFAC INDEX
 . S AR(IN,"PP")=$$GET1^DIQ(9999999.06,SITE_",",.31,"E") ; Get PSEUDO PREFIX
 . S INSTIEN=$$GET1^DIQ(9999999.06,SITE_",",.01,"I") ; Get INSTITUTION IEN
 . S AR(IN,"AREA")=$$GET1^DIQ(9999999.06,SITE_",",.04,"E") ;AREA OFFICE
 . S AR(IN,"SVCUNIT")=$$GET1^DIQ(9999999.06,SITE_",",.05,"E") ;Service Unit
 . S AR(IN,"SVCCODE")=$$GET1^DIQ(9999999.06,SITE_",",".0599","E") ;SU Code
 . S AR(IN,"FLOCCODE")=$$GET1^DIQ(9999999.06,SITE_",",".18","E") ;Facility Location Code
 . S AR(IN,"SITEITU")=$$GET1^DIQ(9999999.06,SITE_",",.25,"E") ;Site I/T/U
 . S AR(IN,"AOFFICECODE")=$$GET1^DIQ(9999999.06,SITE_",",.0499,"E") ;AREA Code
 . S AR(IN,"DEA")=$$GET1^DIQ(9999999.06,SITE_",",.11,"E") ;DEA #
 . S AR(IN,"TAXID")=$$GET1^DIQ(9999999.06,SITE_",",.21,"E")  ;Federal Tax ID
 . S AR(IN,"MCARE")=$$GET1^DIQ(9999999.06,SITE_",",.22,"E")  ;Medicare No
 . S AR(IN,"FLOC")=$$GET1^DIQ(9999999.06,SITE_",",.19,"E")  ;Financial Location Code
 . S AR(IN,"DIRECT")=$$GET1^DIQ(9999999.06,SITE_",",2105,"E")  ;Direct Email Address
 . S AR(IN,"MNEMONIC")=$$GET1^DIQ(9999999.06,SITE_",",8801,"E")  ;Mnemonic
 . S AR(IN,"ABBRV")=$$GET1^DIQ(9999999.06,SITE_",",.08,"E")  ;ABBRV
 . S AR(IN,"SHORT")=$$GET1^DIQ(9999999.06,SITE_",",.02,"E")  ;Short Name
 . S AR(IN,"CLASS")=$$CLASS(SITE) ;Return CLASS multiple info
 . ;
 . ;Get site physical address information
 . S SADDR1=$$GET1^DIQ(4,INSTIEN_",",1.01,"E")
 . S SADDR2=$$GET1^DIQ(4,INSTIEN_",",1.02,"E")
 . S AR(IN,"STREET")=SADDR1_$S((($L(SADDR1)>0)&($L(SADDR2)>0)):", ",1:"")_SADDR2
 . S AR(IN,"CITY")=$$GET1^DIQ(4,INSTIEN_",",1.03,"E")
 . S AR(IN,"STATE")=$$GET1^DIQ(4,INSTIEN_",",.02,"E")
 . S AR(IN,"ZIP")=$$GET1^DIQ(4,INSTIEN_",",1.04,"I")
 . ;
 . ;Get site mailing address information
 . S SADDR1=$$GET1^DIQ(4,INSTIEN_",",4.01,"E")
 . S SADDR2=$$GET1^DIQ(4,INSTIEN_",",4.02,"E")
 . S CITY=$$GET1^DIQ(4,INSTIEN_",",4.03,"E")
 . S STATE=$$GET1^DIQ(4,INSTIEN_",",4.04,"E")
 . S ZIP=$$GET1^DIQ(4,INSTIEN_",",4.05,"E")
 . ;If blank pull from LOCATION entry
 . I $TR(SADDR1_SADDR2_CITY_STATE_ZIP,",-","")="" D
 .. S SADDR1=$$GET1^DIQ(9999999.06,SITE_",",.14,"E")
 .. S SADDR2=""
 .. S CITY=$$GET1^DIQ(9999999.06,SITE_",",.15,"E")
 .. S STATE=$$GET1^DIQ(9999999.06,SITE_",",.16,"E")
 .. S ZIP=$$GET1^DIQ(9999999.06,SITE_",",.17,"E")
 . S AR(IN,"MSTREET")=SADDR1_$S((($L(SADDR1)>0)&($L(SADDR2)>0)):", ",1:"")_SADDR2
 . S AR(IN,"MCITY")=CITY
 . S AR(IN,"MSTATE")=STATE
 . S AR(IN,"MZIP")=ZIP
 . ;
 . S AR(IN,"FACTYPE")=$$GET1^DIQ(4,INSTIEN_",",13,"E")  ;Facility Type
 . S ASC=$P($$ASSOC^ADSUTL(INSTIEN),"&") ;IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455; Changed call to $$ASSOC^ADSUTL
 . S AR(IN,"PASSOC")=$P(ASC,"~",2)
 . S AR(IN,"ASSOC")=$P(ASC,"~")  ;Associations
 . S AR(IN,"MCENTER")=$$MCNTR^ADSUTL(INSTIEN)  ;Medical Center Division ;IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455; Changed call to $$MCNTR^ADSUTL
 . S AR(IN,"STN")=$$GET1^DIQ(4,INSTIEN_",",99,"I")
 . S AR(IN,"MULTI")=$$GET1^DIQ(4,INSTIEN_",",5,"E")  ;Multi Divisional
 . S AR(IN,"NPI")=$$GET1^DIQ(4,INSTIEN_",",41.99,"E")  ;NPI
 . S AR(IN,"AGCODE")=$$GET1^DIQ(4,INSTIEN_",",95,"E")  ;Agency Code
 . ;
 . ;Parent/Child
 . S (PNT,CHD)=""
 . S PC=$O(ALIST("P",INSTIEN,"")) I PC]"" S CHD=$$GET1^DIQ(4,PC_",",.01,"E"),PC="Parent"
 . I PC="" S PC=$O(ALIST("C",INSTIEN,"")) I PC]"" S PNT=$$GET1^DIQ(4,PC_",",.01,"E"),PC="Child"
 . S AR(IN,"MULTTYPE")=PC
 . S AR(IN,"PARENT")=PNT
 . S AR(IN,"CHILD")=CHD
 . ;
 . S AR(IN,"AGPOINT")=$$GET1^DIQ(4,INSTIEN_",",97,"E")  ;Pointer to Agency
 . S AR(IN,"SASUFAC")=SASUFAC  ;Site ASUFAC
 . S AR(IN,"SDBID")=SDBID  ;Site DBID
 . Q
 Q
 ;
CLASS(SITE) ;Return Class entries
 ;
 I $G(SITE)="" Q ""
 ;
 NEW RET,CIEN
 ;
 S RET=""
 ;
 S CIEN=0 F  S CIEN=$O(^AUTTLOC(SITE,11,CIEN)) Q:'CIEN  D
 . NEW BDATE,REC,DA,IENS,IHS,CLASS,FTYPE
 . ;
 . S DA(1)=SITE,DA=CIEN,IENS=$$IENS^DILF(.DA)
 . ;
 . ;Begin Date
 . S BDATE=$$FMTE^XLFDT($$GET1^DIQ(9999999.0611,IENS,".01","I"),"5ZD")
 . Q:BDATE=""
 . ;
 . ;IHS/Non-IHS (AFFILIATION)
 . S IHS=$$GET1^DIQ(9999999.0611,IENS,".03","E")
 . ;
 . ;Class
 . S CLASS=$$GET1^DIQ(9999999.0611,IENS,".07","E")
 . ;
 . ;Facility Type
 . S FTYPE=$$GET1^DIQ(9999999.0611,IENS,".05","E")
 . ;
 . ;Form record
 . S REC=BDATE_"~"_IHS_"~"_CLASS
 . ;
 . ;Add to record
 . S RET=RET_$S(RET]"":"&",1:"")_REC
 ;
 Q RET
TASK ;EP - Front end for ADS nightly export task
 ;IHS/GDIT/AEF ADS*1.0*6 FID107206
 ;Code was moved from here to TASK^ADSTASK because ADSFAC had exceeded
 ;SAC size limit.
 ;
 ;This tag is called by the ADS SITE INFORMATION EXPORT TASK option
 ;
 D TASK^ADSTASK
 ;
 Q
