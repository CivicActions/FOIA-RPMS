ADSLRPT ;GDIT/HS/BEE-ADS Log Report ; April 6, 2022
 ;;1.0;DISTRIBUTION MANAGEMENT;**1,2,3**;Apr 23, 2020;Build 15
 ;
EN ;ADS Log Rpt Entry
 ;
 NEW FRDT,TODT,ESERV,SRV,SIEN,SNUM,RNAME,EXEC,ENSPACE,BSTSWS,SERVERS
 NEW SPACE,STS,POP,CT,ADSRPT,ICNT,SRMAX,SCNT,DIRUT,DTOUT
 NEW DIR,X,Y,RTYPE,DISP,WIDTH,RES
 ;
 S $P(SPACE," ",80)=" "
 ;
 W !!,"DISPLAY ADS RECORD LOG HISTORY"
 ;
 ;Type
 S DIR(0)="SO^A:ASU Log Entries;I:IZP Log Entries;L:License Log Entries;P:Package Log Entries"
 S DIR("A")="Enter the type of log entry to retrieve"
 S DIR("B")="ASU Log Entries"
 D ^DIR
 S Y=$G(Y)
 I Y'="A",Y'="I",Y'="P",Y'="L" Q
 S RTYPE=Y
 ;
 ;Summary/Detail
 ;BEGIN IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455 - Moved display select code to $$SD^ADSUTL
 S DISP=$$SD^ADSUTL
 Q:"SD"'[DISP
 ;END IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455 - Moved display select code to $$SD^ADSUTL
 ;
 ;Width
 ;BEGIN IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455 - Moved width select code to $$WIDTH^ADSUTL
 S WIDTH=$$WIDTH^ADSUTL
 Q:'WIDTH
 ;END IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455 - Moved width select code to $$WIDTH^ADSUTL
 ;
 ;From
 S FRDT=$$DATE^BSTSDSP("From Date","T-7") Q:'FRDT
 ;
 ;To
 S TODT=$$DATE^BSTSDSP("To Date","T",FRDT) Q:'TODT
 ;
 ;Max
 S SRMAX=$$SMAX^BSTSSTA() Q:'SRMAX
 ;
 S ENSPACE=36
 ;
 ;Server info
 S ESERV=$$WSERVER^BSTSWSV(.SERVERS,"") Q:'ESERV
 S SRV=$O(SERVERS(0)) Q:'SRV
 M BSTSWS=SERVERS(SRV)
 ;
 ;Site
 S SIEN=$O(^AUTTSITE(0)) Q:'+SIEN
 S SNUM=$$GET1^DIQ(9999999.39,SIEN_",",.01,"I") Q:SNUM=""
 ;
 ;Results
 S BSTSWS("FRDT")=$P($$FMTE^BSTSUTIL(FRDT),":",1,2)_" 00:00"
 S BSTSWS("TODT")=$P($$FMTE^BSTSUTIL(TODT),":",1,2)_" 23:59"
 S BSTSWS("ENSPACE")=ENSPACE
 S BSTSWS("ESITE")=SNUM
 S BSTSWS("EPROD")=$$PROD^XUPROD()
 S RNAME="",EXEC="S RNAME=$"_"ZNSPACE" X EXEC
 S BSTSWS("RNAME")=RNAME
 ;
 ;Srch list
 S STS=$$LHIST^BSTSCMCL(.BSTSWS,.RES)
 ;
 ;Dev
 W !!,"Select the output device. Note that if the 132 page width display was"
 W !,"chosen that the device may need to be set up for 132 column printing.",!
 S POP="" D ^%ZIS I POP Q
 U IO
 ;
 ;Disp
 S (SCNT,CT)=0
 D HDR(.ADSRPT,.CT,RTYPE,FRDT,TODT,SRMAX,DISP,WIDTH)
 S ICNT="" F  S ICNT=$O(^TMP("BSTSCMCL",$J,ICNT)) Q:ICNT=""  D  I (SCNT+1)>SRMAX Q
 . ;
 . NEW NODE,ROW,T
 . ;
 . S NODE=$G(^TMP("BSTSCMCL",$J,ICNT))
 . ;
 . ;Look for selected
 . S T=$P(NODE,U,4) Q:T=""
 . I RTYPE="A",T="ASU" D ASU(.ADSRPT,NODE,DISP,WIDTH,.SCNT) Q
 . I RTYPE="I",T="IZP" D IZP(.ADSRPT,NODE,DISP,WIDTH,.SCNT) Q
 . I RTYPE="L",T="LICENSE" D LIC(.ADSRPT,NODE,DISP,WIDTH,.SCNT) Q
 . I RTYPE="P",T="PKG" D PKG(.ADSRPT,NODE,DISP,WIDTH,.SCNT) Q
 . ;
 . Q
 ;
 ;Trailer
 I SCNT D TRAIL(.ADSRPT,.CT,RTYPE,DISP)
 ;
 ;No results
 I SCNT=0 D
 . S CT=CT+1,ADSRPT(CT)="No results found.  This could be because the link to the DTS server"
 . S CT=CT+1,ADSRPT(CT)="is currently down."
 ;
 S CT=CT+1,ADSRPT(CT)=" "
 S CT=CT+1,ADSRPT(CT)="<END OF REPORT>"
 ;
 ;Disp rpt
 D EN^DDIOL(.ADSRPT)
 ;
 ;Close dev
 D ^%ZISC
 ;
 I $D(IOST),IOST["C-",'$D(DIRUT),'$D(DTOUT) D
 . NEW DIR,X,Y
 . W ! S DIR(0)="E",DIR("A")="Press 'Return to continue'" D ^DIR
 ;
 Q
 ;
HDR(ADSRPT,CT,RTYPE,FRDT,TODT,SRMAX,DISP,WIDTH) ;Disp header
 ;
 I $G(RTYPE)="" Q
 ;
 NEW ETYP
 ;
 S ETYP=$S(RTYPE="A":"ASU",RTYPE="I":"IZP",RTYPE="L":"License",RTYPE="P":"PKG",1:"")
 ;BEGIN IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455 - changed $$CNTR to $$CNTR^ADSUTL
 S CT=$G(CT)+1,ADSRPT(CT)=$$CNTR^ADSUTL("ADS DTS LOG HISTORY - "_$S(DISP="S":"SUMMARY",1:"DETAIL"),WIDTH)
 S CT=CT+1,ADSRPT(CT)=$$CNTR^ADSUTL("Period: "_$$FMTE^XLFDT(FRDT,"2ZD")_" to "_$$FMTE^XLFDT(TODT,"2ZD"),WIDTH)
 S CT=CT+1,ADSRPT(CT)=$$CNTR^ADSUTL("Latest "_SRMAX_" "_ETYP_" Events Logged",WIDTH)
 ;END IHS/GDIT/AEF 04/12/2022;ADS*1.0*3 Feature#81455 - changed $$CNTR to $$CNTR^ADSUTL
 S CT=CT+1,ADSRPT(CT)=" "
 ;
 ;Summary
 I DISP="S" D  Q
 . S CT=CT+1,ADSRPT(CT)="DTS ID (gid)    EVENT DATE       VALUE"
 . S CT=CT+1,ADSRPT(CT)=" "
 ;
 ;Detail
 I (RTYPE="P"),DISP="D" D  Q
 . S CT=CT+1,ADSRPT(CT)="DTS ID (gid)    EVENT DATE       PKG  NAME                          VRSN PATCH"
 Q
 ;
TRAIL(ADSRPT,CT,RTYPE,DISP) ;Disp trailer
 ;
 ;ASU Det
 I RTYPE="A",DISP="D" D
 . S CT=CT+1,ADSRPT(CT)=" "
 . S CT=CT+1,ADSRPT(CT)="Field explanations"
 . S CT=CT+1,ADSRPT(CT)=" "
 . S CT=CT+1,ADSRPT(CT)="*  The mailing address is first pulled from the INSTITUTION file fields"
 . S CT=CT+1,ADSRPT(CT)="   listed. If all of the fields are blank the mailing address is pulled"
 . S CT=CT+1,ADSRPT(CT)="   from the LOCATION file mailing address fields."
 . S CT=CT+1,ADSRPT(CT)="** The Medical Center Name is pulled from the MEDICAL CENTER DIVISION"
 . S CT=CT+1,ADSRPT(CT)="   file entry that points to the selected INSTITUTION file entry."
 ;
 Q
 ;
ASU(ADSRPT,NODE,DISP,WIDTH,SCNT) ;Disp ASU
 ;
 NEW SPACE,VLEN,TXT
 ;
 S $P(SPACE," ",132)=" "
 ;
 ;Counter
 S SCNT=SCNT+1
 ;
 ;Summary
 I DISP="S" D  Q
 . NEW VAL
 . I WIDTH=80 S VLEN=47
 . E  I WIDTH=132 S VLEN=99
 . E  S VLEN=99999
 . S VAL=$P(NODE,U,6)
 . S CT=CT+1,ADSRPT(CT)=$E($P(NODE,U)_SPACE,1,16)_$E($TR($$FMTE^XLFDT($$DTS2FMDT^BSTSUTIL($P(NODE,U,3)),"5"),"@"," ")_SPACE,1,17)_$E(VAL_SPACE,1,VLEN)
 . F  S VAL=$E(VAL,VLEN+1,999999) Q:VAL=""  S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,(WIDTH-VLEN))_$E(VAL_SPACE,1,VLEN)
 ;
 ;Detail
 I WIDTH=80 S VLEN=17
 E  I WIDTH=132 S VLEN=69
 E  S VLEN=99999
 S CT=CT+1,ADSRPT(CT)="***** DTS ID (gid): "_$E($P(NODE,U)_SPACE,1,10)_"EVENT DATE: "_$TR($$FMTE^XLFDT($$DTS2FMDT^BSTSUTIL($P(NODE,U,3)),"5"),"@"," ")_" *****"
 S CT=CT+1,ADSRPT(CT)=" "
 ;
 ;Header
 S CT=CT+1,ADSRPT(CT)=$E("DTS Field"_SPACE,1,30)_$E("RPMS LOCATION FILE"_SPACE,1,30)_"VALUE"
 S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,30)_$E("FIELD(S)"_SPACE,1,30)
 S CT=CT+1,ADSRPT(CT)=" "
 ;
 ;Disp
 F TXT=1:1 S ROW=$T(@RTYPE+TXT) Q:ROW[";END;"  D
 . NEW VAL
 . S VAL=$P($P(NODE,U,6),"|",$P(ROW,";",2))
 . S CT=CT+1,ADSRPT(CT)=$E($P(ROW,";",3)_SPACE,1,30)_$E($P(ROW,";",5)_SPACE,1,30)_$E(VAL,1,VLEN)
 . S VAL=$E(VAL,VLEN+1,99999)
 . S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,30)_$E($P(ROW,";",6)_SPACE,1,30)_$E(VAL,1,VLEN)
 . F  S VAL=$E(VAL,VLEN+1,99999) Q:VAL=""  S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,60)_$E(VAL,1,VLEN)
 ;
 Q
 ;
PKG(ADSRPT,NODE,DISP,WIDTH,SCNT) ;Disp PKG
 ;
 NEW SPACE,VLEN,TXT,VAL
 ;
 S $P(SPACE," ",132)=" "
 ;
 ;Counter
 S SCNT=SCNT+1
 ;
 ;Summary
 I DISP="S" D  Q
 . I WIDTH=80 S VLEN=47
 . E  I WIDTH=132 S VLEN=99
 . E  S VLEN=99999
 . S VAL=$P(NODE,U,6)
 . S CT=CT+1,ADSRPT(CT)=$E($P(NODE,U)_SPACE,1,16)_$E($TR($$FMTE^XLFDT($$DTS2FMDT^BSTSUTIL($P(NODE,U,3)),"5"),"@"," ")_SPACE,1,17)_$E(VAL_SPACE,1,VLEN)
 . F  S VAL=$E(VAL,VLEN+1,999999) Q:VAL=""  S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,(WIDTH-VLEN))_$E(VAL_SPACE,1,VLEN)
 ;
 ;Detail
 S CT=CT+1,ADSRPT(CT)=$E($P(NODE,U)_SPACE,1,16)_$E($TR($$FMTE^XLFDT($$DTS2FMDT^BSTSUTIL($P(NODE,U,3)),"5"),"@"," ")_SPACE,1,17)
 S ADSRPT(CT)=ADSRPT(CT)_$E($P($P(NODE,U,6),"|",2)_SPACE,1,5)_$E($P($P(NODE,U,6),"|",3)_SPACE,1,30)_$E($P($P(NODE,U,6),"|",4)_SPACE,1,5)
 S ADSRPT(CT)=ADSRPT(CT)_$E($P($P(NODE,U,6),"|",5)_SPACE,1,5)
 ;
 Q
 ;
IZP(ADSRPT,NODE,DISP,WIDTH,SCNT) ;Disp IZP
 ;
 NEW SPACE,VLEN,TXT,VAL,FLDP,AFLDP,TYPE
 ;
 S $P(SPACE," ",132)=" "
 ;
 ;Counter
 S SCNT=SCNT+1
 ;
 ;Summary
 I DISP="S" D  Q
 . I WIDTH=80 S VLEN=47
 . E  I WIDTH=132 S VLEN=99
 . E  S VLEN=99999
 . S VAL=$P(NODE,U,6)
 . S CT=CT+1,ADSRPT(CT)=$E($P(NODE,U)_SPACE,1,16)_$E($TR($$FMTE^XLFDT($$DTS2FMDT^BSTSUTIL($P(NODE,U,3)),"5"),"@"," ")_SPACE,1,17)_$E(VAL_SPACE,1,VLEN)
 . F  S VAL=$E(VAL,VLEN+1,999999) Q:VAL=""  S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,(WIDTH-VLEN))_$E(VAL_SPACE,1,VLEN)
 ;
 ;Detail
 I WIDTH=80 S VLEN=17
 E  I WIDTH=132 S VLEN=69
 E  S VLEN=99999
 S CT=CT+1,ADSRPT(CT)="***** DTS ID (gid): "_$E($P(NODE,U)_SPACE,1,10)_"EVENT DATE: "_$TR($$FMTE^XLFDT($$DTS2FMDT^BSTSUTIL($P(NODE,U,3)),"5"),"@"," ")_" *****"
 S CT=CT+1,ADSRPT(CT)=" "
 ;
 ;Header
 S CT=CT+1,ADSRPT(CT)=$E("DTS Field"_SPACE,1,30)_$E("RPMS LOCATION FILE"_SPACE,1,30)_"VALUE"
 S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,30)_$E("FIELD(S)"_SPACE,1,30)
 S CT=CT+1,ADSRPT(CT)=" "
 ;
 ;Get type (P-Primary,A-Additional)
 S TYPE=$P($P(NODE,U,6),"|",7) Q:TYPE=""
 I TYPE="P" S FLDP=6,AFLDP=7
 E  S FLDP=8,AFLDP=9
 ;
 ;Disp
 F TXT=1:1 S ROW=$T(@RTYPE+TXT) Q:ROW[";END;"  D
 . NEW VAL
 . S VAL=$P($P(NODE,U,6),"|",$P(ROW,";",2))
 . S CT=CT+1,ADSRPT(CT)=$E($P(ROW,";",3)_SPACE,1,30)_$E($P(ROW,";",5)_SPACE,1,30)_$E(VAL,1,VLEN)
 . S VAL=$E(VAL,VLEN+1,99999)
 . S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,30)_$E($P(ROW,";",FLDP)_SPACE,1,30)_$E(VAL,1,VLEN)
 . I $P(ROW,";",AFLDP)]"" S VAL=$E(VAL,VLEN+1,99999),CT=CT+1,ADSRPT(CT)=$E(SPACE,1,30)_$E($P(ROW,";",AFLDP)_SPACE,1,30)_$E(VAL,1,VLEN)
 . F  S VAL=$E(VAL,VLEN+1,99999) Q:VAL=""  S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,60)_$E(VAL,1,VLEN)
 ;
 Q
 ;
LIC(ADSRPT,NODE,DISP,WIDTH,SCNT) ;Disp LICENSE
 ;
 NEW SPACE,VLEN,TXT,VAL
 ;
 S $P(SPACE," ",132)=" "
 ;
 ;Counter
 S SCNT=SCNT+1
 ;
 ;Summary
 I DISP="S" D  Q
 . I WIDTH=80 S VLEN=47
 . E  I WIDTH=132 S VLEN=99
 . E  S VLEN=99999
 . S VAL=$P(NODE,U,6)
 . S CT=CT+1,ADSRPT(CT)=$E($P(NODE,U)_SPACE,1,16)_$E($TR($$FMTE^XLFDT($$DTS2FMDT^BSTSUTIL($P(NODE,U,3)),"5"),"@"," ")_SPACE,1,17)_$E(VAL_SPACE,1,VLEN)
 . F  S VAL=$E(VAL,VLEN+1,999999) Q:VAL=""  S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,(WIDTH-VLEN))_$E(VAL_SPACE,1,VLEN)
 ;
 ;Detail
 I WIDTH=80 S VLEN=17
 E  I WIDTH=132 S VLEN=69
 E  S VLEN=99999
 S CT=CT+1,ADSRPT(CT)=" "
 S CT=CT+1,ADSRPT(CT)="***** DTS ID (gid): "_$E($P(NODE,U)_SPACE,1,10)_"EVENT DATE: "_$TR($$FMTE^XLFDT($$DTS2FMDT^BSTSUTIL($P(NODE,U,3)),"5"),"@"," ")_" *****"
 S CT=CT+1,ADSRPT(CT)=" "
 ;
 ;Header
 S CT=CT+1,ADSRPT(CT)=$E("DTS Field"_SPACE,1,30)_"VALUE"
 S CT=CT+1,ADSRPT(CT)=" "
 ;
 ;Disp
 F TXT=1:1 S ROW=$T(@RTYPE+TXT) Q:ROW[";END;"  D
 . NEW VAL
 . S VAL=$P($P(NODE,U,6),"|",$P(ROW,";",2))
 . S CT=CT+1,ADSRPT(CT)=$E($P(ROW,";",3)_SPACE,1,30)_$E(VAL,1,VLEN)
 . F  S VAL=$E(VAL,VLEN+1,99999) Q:VAL=""  S CT=CT+1,ADSRPT(CT)=$E(SPACE,1,30)_$E(VAL,1,VLEN)
 ;
 Q
 ;
A       ;ASU Rpt flds
 ;1;Facility;Facility;Site STATION NUMBER;
 ;2;InstitutionNumber;Institution;INSTITUTION;IEN POINTER
 ;3;SiteName;Site Name;LOCATION;NAME
 ;4;OfficialRegisteringFacility;Official Registering Facility;REGISTRATION PARAMETERS;OFFICIAL REGISTERING FACILITY
 ;5;RPMSDBID;Unique RPMS DB ID;LOCATION;UNIQUE RPMS DB ID
 ;6;ASUFACIndex;ASUFAC Index;LOCATION;ASUFAC INDEX
 ;7;PseudoPrefix;Pseudo Prefix;LOCATION;PSEUDO PREFIX
 ;8;StationNumber;Station Number;INSTITUTION;STATION NUMBER
 ;9;SiteASUFAC;Site ASUFAC;Site ASUFAC;
 ;10;SiteDBID;Site DBID;Site DBID
 ;11;SiteStreet;Site Physical Street;INSTITUTION;STREET ADDR. 1/2
 ;12;SiteCity;Site Physical City;INSTITUTION;CITY
 ;13;SiteState;Site Physical State;INSTITUTION;STATE
 ;14;SiteZip;Site Physical Zip;INSTITUTION;ZIP
 ;15;AreaOffice;Area Office;LOCATION;AREA
 ;16;AREAOfficeCode;AREA Office Code;LOCATION;AREA CODE
 ;17;SiteITUDesignation;Site I/T/U Designation;LOCATION;CURRENT TYPE
 ;18;Class;CLASS multiple;LOCATION;CLASS Subfields
 ;19;SiteServiceUnit;Site Service Unit;LOCATION;SERVICE UNIT
 ;20;SiteServiceUnitCode;Site Service Unit Code;LOCATION;SU CODE
 ;21;FacilityLocationCode;Facility Location Code;LOCATION;FACILITY LOCATION CODE
 ;22;MailingStreet;Mailing Street;INSTITUTION;ST. ADDR. 1/2 (MAILING)*
 ;23;MailingCity;Mailing City;INSTITUTION;CITY (MAILING)*
 ;24;MailingState;Mailing State;INSTITUTION;STATE (MAILING)*
 ;25;MailingZip;Mailing Zip;INSTITUTION;ZIP (MAILING)*
 ;26;MultiDivisional;Multi Divisional;INSTITUTION;MULTI-DIVISION FACILITY
 ;27;NationalProviderID;National Provider ID;INSTITUTION;NPI
 ;28;DEANumber;DEA Number;LOCATION;DEA REGISTRATION NO.
 ;29;FederalTaxID;Federal Tax ID;LOCATION;FEDERAL TAX NO.
 ;30;MedicareProviderID;Medicare Provider ID;LOCATION;MEDICARE NO.
 ;31;FinancialLocationCode;Financial Location Code;LOCATION;FINANCIAL LOCATION CODE
 ;32;DirectEmailAddress;Direct Email Address;LOCATION;DIRECT EMAIL ADDRESS
 ;33;Mnemonic;Mnemonic;LOCATION;MNEMONIC
 ;34;ABBRV;ABBRV;LOCATION;ABBRV
 ;35;ShortName;Short Name;LOCATION;SHORT NAME
 ;36;MedicalCenterName;Medical Center Name;MEDICAL CENTER DIVISION;NAME**
 ;37;AgencyCode;Agency Code;INSTITUTION;AGENCY CODE
 ;38;PointertoAgency;Pointer to Agency;INSTITUTION;POINTER TO AGENCY
 ;39;Association;Association;INSTITUTION;ASSOCIATIONS
 ;40;FacilityType;Facility Type;INSTITUTION;FACILITY TYPE
 ;41;MultiDivisionalType;Multidivisional Type;INSTITUTION;Derived from ASSOCIATIONS
 ;42;Parent;Parent;INSTITUTION;Derived from ASSOCIATIONS
 ;43;Child;Child;INSTITUTION;Derived from ASSOCIATIONS
 ;44;ParentofAssociation;Parent of Association;Derived from ASSOCIATIONS
 ;END;
 ;
I       ;IZP Rpt flds
 ;1;StationID;Site Station ID;Site STATION NUMBER;
 ;2;SiteName;Site Name;IZ PARAMETERS;SITE NAME;;SITE NAME
 ;3;DataExchangeEntry;Institution Name;IZ PARAMETERS;ADDITIONAL DATA EXCHANGE SITES;NAME OF DATA EXCHANGE STATE;ADDITIONAL DATA EXCHANGE SITES;NAME OF DATA EXCHANGE STATE
 ;4;AgesToExport;Ages to Export;IZ PARAMETERS;AGES TO EXPORT;;ADDITIONAL DATA EXCHANGE SITES;AGES TO EXPORT
 ;5;Version;Version;IZ PARAMETERS;VERSION IN USE;;ADDITIONAL DATA EXCHANGE SITES;VERSION IN USE
 ;6;NameOfStateForExchange;Name of State For Exchange;IZ PARAMETERS;NAME OF STATE FOR EXCHANGE;;ADDITIONAL DATA EXCHANGE SITES;NAME OF STATE FOR EXCHANGE
 ;7;Type;Type;Type of Entry
 ;8;SiteASUFAC;Site ASUFAC;Site ASUFAC;;;Site ASUFAC;
 ;9;SiteDBID;Site DBID;Site DBID;;;Site DBID;
 ;END;
 ;
 ;GDIT/HS/BEE 09/09/2021;ADS*1.0*2;Feature#78926 - Added new license info (fields 17-20)
L       ;Licences Rpt flds
 ;1;Facility;4 digit Facility or Site Number - for comparison with HealthConnect values
 ;2;KeyCustomerName;String showing this value from the license
 ;3;LUMaxConsumed;Max number of license units used since last restart or reset
 ;4;LUMaxDateTime;Date/time LUMaxConsumed was last run
 ;5;LUMaxResetDateTime;Date/time LUMaxConsumed was last reset
 ;6;StartDateTime;Date/time Ensemble/HealthShare server was last restarted
 ;7;FullVersion;HealthShare or Ensemble <space> version number <space> O/S
 ;8;OSVersion;Windows or AIX
 ;9;ServerFQDN;Fully Qualified Domain Name of the server running HealthShare or Ensemble
 ;10;ServerIP;IP Address of the server running HealthShare or Ensemble
 ;11;Namespace;Namespace in which this process was run
 ;12;GeneratedBy;AUTO or MANUAL process
 ;13;KeyLicenseCapacity;String showing this value from the license
 ;14;SiteASUFAC;Site ASUFAC
 ;15;SiteDBID;Site DBID
 ;16;SiteSetAs;Site Set As
 ;17;LicenseKey;The Healthshare license key
 ;18;KeyExpirationDate;The expiration date of the Healthshare license key
 ;19;HS4;HS4 value
 ;20;HLU;HLU value
 ;21;LicenseKeyOrderNo;License Key Order Number  ;IHS/GDIT/AEF 03/29/2022;ADS*1.0*3 Feature#81455 - Added new field to display
 ;END;
