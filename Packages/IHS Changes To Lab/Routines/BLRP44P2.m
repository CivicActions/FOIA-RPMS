BLRP44P2 ; IHS/MSC/MKK - RPMS COVID-19 LOINC Lab Patch LR*5.2*1044 Post Install, Part 2 ; 11-Mar-2020 14:45 ; MKK
 ;;5.2;IHS LABORATORY;**1044**;NOV 01, 1997;Build 16
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ;
ADDLLCOM ; EP - Add Data to LAB LOINC COMPONENT (#95.31) file
 NEW COMPNENT,ERRS,FDA,IEN,IENSET,LINESTR,LINETAG,TAB,TAB2,TAB3
 ;
 S TAB=$J("",5),TAB2=$J("",10),TAB3=$J("",15)
 ;
 D BMES^XPDUTL(TAB_"Adding Entries to the LAB LOINC COMPONENT (#95.31) file begins.")
 ;
 S LINETAG="LLCOMP"
 F LINE=1:1  S LINESTR=$T(@LINETAG+LINE)  Q:LINESTR["$$END"  D
 . S COMPNENT=$P(LINESTR,";",3)
 . S IEN=$P(LINESTR,";",4)
 . I $$FIND1^DIC(95.31,,"O",COMPNENT) D  Q
 .. D BMES^XPDUTL(TAB2_"Entry "_COMPNENT_" already added to 95.31")
 . K FDA,ERRS
 . S IENSET=""
 . S:IEN IENSET(1)=IEN
 . S FDA(95.31,"+1,",.01)=COMPNENT
 . D UPDATE^DIE("ES","FDA",IENSET,"ERRS")
 . I $D(ERRS)<1 D  Q
 .. D BMES^XPDUTL(TAB2_"Entry "_COMPNENT_" added to 95.31")
 . ;
 . ; If here, there was an error.  Show it.
 . D BMES^XPDUTL(TAB2_"Error adding "_COMPNENT_" to file 95.31")
 . D MES^XPDUTL(TAB3_"Error:"_$G(ERRS("DIERR",1,"TEXT",1)))
 ;
 D BMES^XPDUTL(TAB_"Adding Entries to the LAB LOINC COMPONENT (#95.31) file ends.")
 D MES^XPDUTL("")
 Q
 ;
LLCOMP ; EP - LAB LOINC COMPONENT (#95.31) entries
 ;;SARS coronavirus 2 RNA panel
 ;;SARS coronavirus 2 N gene
 ;;SARS coronavirus 2 RNA
 ;;SARS-like Coronavirus N gene
 ;;SARS coronavirus 2 RdRp gene
 ;;SARS coronavirus 2 E gene
 ;;SYMPTOM;28865;
 ;;SARS coronavirus 2 Ab.IgG
 ;;SARS coronavirus 2 Ab.IgG & IgM panel
 ;;SARS coronavirus 2 Ab.IgG+IgM
 ;;SARS coronavirus 2 Ab.IgM
 ;;SARS coronavirus 2 ORF1ab region
 ;;SARS coronavirus+SARS-like coronavirus+SARS coronavirus 2 RNA
 ;;$$END
 ;
 ;
ADDLECOD ; EP - Add Data to the LAB ELECTRONIC CODES (#64.061) file
 NEW CODES,ERRS,FDA,TAB,TAB2,TAB3
 ;
 S TAB=$J("",5),TAB2=$J("",10),TAB3=$J("",15)
 ;
 D BMES^XPDUTL(TAB_"Adding Entries to the LAB ELECTRONIC CODES (#64.061) file begins.")
 ;
 S LINETAG="LABECODE"
 F DATALINE=1:1  S LINESTR=$T(@LINETAG+DATALINE)  Q:LINESTR["$$END"  D
 . S CODES=$P(LINESTR,";",3)
 . Q:$O(^LAB(64.061,"E",CODES,0))   ; Skip if code already exists
 . ;
 . K FDA,ERRS
 . S FDA(64.061,"+1,",.01)=CODES
 . S FDA(64.061,"+1,",1)=CODES
 . D UPDATE^DIE("ES","FDA",,"ERRS")
 . I $D(ERRS)<1 D  Q
 .. D BMES^XPDUTL(TAB2_"Added Code "_CODES_" to 64.061 file.")
 . ;
 . D BMES^XPDUTL(TAB2_"Error Adding Code "_CODES_" to 64.061 file.")
 . D MES^XPDUTL(TAB3_"ERROR:"_$G(ERRS("DIERR",1,"TEXT",1)))
 ;
 D BMES^XPDUTL(TAB_"Adding Entries to the LAB ELECTRONIC CODES (#64.061) file ends.")
 D MES^XPDUTL("")
 Q
 ;
LABECODE ; EP - LAB ELECTRONIC CODES (#64.061) updates
 ;;Prid
 ;;Ord
 ;;Qn
 ;;Asp
 ;;Cornea/Conjunctiva
 ;;Respiratory
 ;;Respiratory.lower
 ;;PrThr
 ;;Imp
 ;;ThreshNum
 ;;$$END
 ;
 ;
ADDLOINC ; EP - Add COVID-19 LOINC Data
 NEW HEADSTR,LINE,LINESTR,LINETAG,TAB
 ;
 K ^XTMP("BLRPRELO")
 S TAB=$J("",5)
 D BMES^XPDUTL(TAB_"Adding Entries to the LAB LOINC (#95.3) file begins.")
 ;
 S LINETAG="COVID19"
 S HEADSTR=$T(@LINETAG+1)
 F LINE=2:1  S LINESTR=$T(@LINETAG+LINE)  Q:LINESTR["$$END"  D
 . D LOINCADD(LINESTR)
 . ;
 ;
 D BMES^XPDUTL(TAB_"Adding Entries to the LAB LOINC (#95.3) file ends.")
 D MES^XPDUTL("")
 Q
 ;
LOINCADD(LINESTR) ; EP - Add the LOINC code to the dictionary
 NEW CODE,CHKDIGIT,LOINC,LONGNAME,COMPONENT,PROPERTY,TIME,SYSTEM
 NEW SCALE,METHOD,SHORTNAME
 NEW FDA,ERRS,IEN,TAB,TAB2,TAB3,XUMF
 ;
 S TAB=$J("",5),TAB2=$J("",10),TAB3=$J("",15)
 ;
 S CODE=$P($P(LINESTR,";",3),"-")
 ;
 I $D(^LAB(95.3,CODE)) D  Q
 . D BMES^XPDUTL(TAB2_"LOINC "_$P(LINESTR,";",3)_" already in 95.3")
 ;
 S LOINC=$P(LINESTR,";",3)
 S CHKDIGIT=$P($P(LINESTR,";",3),"-",2)
 S LONGNAME=$P(LINESTR,";",4)
 S COMPONENT=$P(LINESTR,";",6)
 S PROPERTY=$P(LINESTR,";",7)
 S TIME=$P(LINESTR,";",8)
 S SYSTEM=$P(LINESTR,";",9)
 S SCALE=$P(LINESTR,";",10)
 S METHOD=$P(LINESTR,";",11)
 S SHORTNAME=$P(LINESTR,";",12)
 ;
 S XUMF=1
 S FDA(95.3,"+1,",.01)=CODE
 S FDA(95.3,"+1,",15)=CHKDIGIT
 S:$$FIND1^DIC(95.31,,"O",COMPONENT) FDA(95.3,"+1,",1)=COMPONENT
 S FDA(95.3,"+1,",3)=TIME
 S:$$FIND1^DIC(64.061,,"O",SYSTEM) FDA(95.3,"+1,",4)=SYSTEM
 S:$$FIND1^DIC(64.061,,"O",SCALE) FDA(95.3,"+1,",5)=SCALE
 S:$$FIND1^DIC(64.2,,"O",METHOD) FDA(95.3,"+1,",6)=METHOD
 S FDA(95.3,"+1,",80)=LONGNAME
 S FDA(95.3,"+1,",81)=SHORTNAME
 S IEN(1)=CODE
 ;
 D UPDATE^DIE("ES","FDA","IEN","ERRS")
 ;
 I $D(ERRS)<1,PROPERTY'="-" D
 . NEW FDA,ERRS
 . S FDA(95.3,IEN(1)_",",2)=PROPERTY
 . D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS)<1 D  Q
 . D BMES^XPDUTL(TAB2_"Entry "_LOINC_" added to 95.3")
 ;
 ; If here, there was an error.  Show it.
 D BMES^XPDUTL(TAB2_"Error adding "_LOINC_" to file 95.3")
 D MES^XPDUTL(TAB3_"Error:"_$G(ERRS("DIERR",1,"TEXT",1)))
 M ^XTMP("BLRPRELO","95.3 Add Error",CODE,"FDA")=FDA
 Q
 ;
COVID19 ; EP - LOINC Data
 ;;LOINC_NUM;LONG_COMMON_NAME;Special Use;COMPONENT;PROPERTY;TIME_ASPCT;SYSTEM;SCALE_TYP;METHOD_TYP;SHORTNAME
 ;;41000-1;Human coronavirus RNA [Identifier] in Unspecified specimen by NAA with probe detection;;Human coronavirus RNA;Prid;Pt;XXX;Nom;Probe.amp.tar;HCoV RNA XXX NAA+probe
 ;;41001-9;Human coronavirus RNA [Presence] in Unspecified specimen by NAA with probe detection;;Human coronavirus RNA;PrThr;Pt;XXX;Ord;Probe.amp.tar;HCoV RNA XXX Ql NAA+probe
 ;;60265-6;Human coronavirus RNA [Presence] in Serum or Plasma by NAA with probe detection;;Human coronavirus RNA;PrThr;Pt;Ser/Plas;Ord;Probe.amp.tar;HCoV RNA SerPl Ql NAA+probe
 ;;75325-1;Symptom;;Symptom;Find;Pt;^Patient;Nom;;Symptom
 ;;88614-3;Human coronavirus RNA [Presence] in Aspirate by NAA with probe detection;;Human coronavirus RNA;PrThr;Pt;Asp;Ord;Probe.amp.tar;HCoV RNA Aspirate Ql NAA+probe
 ;;88620-0;Human coronavirus RNA [Presence] in Lower respiratory specimen by NAA with probe detection;;Human coronavirus RNA;PrThr;Pt;Respiratory.lower;Ord;Probe.amp.tar;HCoV RNA Lower Resp Ql NAA+probe
 ;;88628-3;Human coronavirus RNA [Presence] in Cornea or Conjunctiva by NAA with probe detection;;Human coronavirus RNA;PrThr;Pt;Cornea/Conjunctiva;Ord;Probe.amp.tar;HCoV RNA Corn/Cnjt Ql NAA+probe
 ;;94306-8;SARS coronavirus 2 RNA panel - Unspecified specimen by NAA with probe detection;;SARS coronavirus 2 RNA panel;-;Pt;XXX;-;Probe.amp.tar;SARS-CoV-2 RNA Pnl XXX NAA+probe
 ;;94307-6;SARS coronavirus 2 N gene [Presence] in Unspecified specimen by Nucleic acid amplification using primer-probe set N1;;SARS coronavirus 2 N gene;PrThr;Pt;XXX;Ord;Probe.amp.tar.primer-probe set N1;SARS-CoV-2 N gene XXX Ql NAA N1
 ;;94308-4;SARS coronavirus 2 N gene [Presence] in Unspecified specimen by Nucleic acid amplification using primer-probe set N2;;SARS coronavirus 2 N gene;PrThr;Pt;XXX;Ord;Probe.amp.tar.primer-probe set N2;SARS-CoV-2 N gene XXX Ql NAA N2
 ;;94309-2;SARS coronavirus 2 RNA [Presence] in Unspecified specimen by NAA with probe detection;;SARS coronavirus 2 RNA;PrThr;Pt;XXX;Ord;Probe.amp.tar;SARS-CoV-2 RNA XXX Ql NAA+probe
 ;;94310-0;SARS-like coronavirus N gene [Presence] in Unspecified specimen by NAA with probe detection;;SARS-like Coronavirus N gene;PrThr;Pt;XXX;Ord;Probe.amp.tar;SARS-like CoV N XXX Ql NAA+probe
 ;;94311-8;SARS coronavirus 2 N gene [Cycle Threshold #] in Unspecified specimen by Nucleic acid amplification using primer-probe set N1;;SARS coronavirus 2 N gene;ThreshNum;Pt;XXX;Qn;Probe.amp.tar.primer-probe set N1;SARS-CoV-2 N gene Ct XXX Qn NAA N1
 ;;94312-6;SARS coronavirus 2 N gene [Cycle Threshold #] in Unspecified specimen by Nucleic acid amplification using primer-probe set N2;;SARS coronavirus 2 N gene;ThreshNum;Pt;XXX;Qn;Probe.amp.tar.primer-probe set N2;SARS-CoV-2 N gene Ct XXX Qn NAA N2
 ;;94313-4;SARS-like coronavirus N gene [Cycle Threshold #] in Unspecified specimen by NAA with probe detection;;SARS-like Coronavirus N gene;ThreshNum;Pt;XXX;Qn;Probe.amp.tar;SARS-like CoV N Ct XXX Qn NAA+probe
 ;;94314-2;SARS coronavirus 2 RdRp gene [Presence] in Unspecified specimen by NAA with probe detection;;SARS coronavirus 2 RdRp gene;PrThr;Pt;XXX;Ord;Probe.amp.tar;SARS-CoV-2 RdRp gene XXX Ql NAA+probe
 ;;94315-9;SARS coronavirus 2 E gene [Presence] in Unspecified specimen by NAA with probe detection;;SARS coronavirus 2 E gene;PrThr;Pt;XXX;Ord;Probe.amp.tar;SARS-CoV-2 E gene XXX Ql NAA+probe
 ;;94316-7;SARS coronavirus 2 N gene [Presence] in Unspecified specimen by NAA with probe detection;;SARS coronavirus 2 N gene;PrThr;Pt;XXX;Ord;Probe.amp.tar;SARS-CoV-2 N gene XXX Ql NAA+probe
 ;;94500-6;SARS coronavirus 2 RNA [Presence] in Respiratory specimen by NAA with probe detection;;SARS coronavirus 2 RNA;PrThr;Pt;Respiratory;Ord;Probe.amp.tar;SARS-CoV-2 RNA Resp Ql NAA+probe
 ;;94502-2;SARS coronavirus+SARS-like coronavirus+SARS coronavirus 2 RNA [Presence] in Respiratory specimen by NAA with probe detection;;SARS coronavirus+SARS-like coronavirus+SARS coronavirus 2 RNA;PrThr;Pt;Respiratory;Ord;Probe.amp.tar;SARS+SARS-Lk+SARS-CoV-2 RNA Resp Ql NAA
 ;;94503-0;SARS coronavirus 2 IgG and IgM panel - Serum or Plasma Qualitative by Immunoassay;;SARS coronavirus 2 Ab.IgG & IgM panel;-;Pt;Ser/Plas;Ord;IA;SARS-CoV-2 IgG+IgM Pnl SerPl IA
 ;;94505-5;SARS coronavirus 2 IgG Ab [Units/volume] in Serum or Plasma by Immunoassay;;SARS coronavirus 2 Ab.IgG;ACnc;Pt;Ser/Plas;Qn;IA;SARS-CoV-2 IgG SerPl IA-aCnc
 ;;94504-8;SARS coronavirus 2 IgG and IgM panel - Serum or Plasma by Immunoassay;;SARS coronavirus 2 Ab.IgG & IgM panel;-;Pt;Ser/Plas;Qn;IA;SARS-CoV-2 IgG+IgM Pnl SerPl IA-aCnc
 ;;94506-3;SARS coronavirus 2 IgM Ab [Units/volume] in Serum or Plasma by Immunoassay;;SARS coronavirus 2 Ab.IgM;ACnc;Pt;Ser/Plas;Qn;IA;SARS-CoV-2 IgM SerPl IA-aCnc
 ;;94507-1;SARS coronavirus 2 IgG Ab [Presence] in Serum or Plasma by Immunoassay;;SARS coronavirus 2 Ab.IgG;PrThr;Pt;Ser/Plas;Ord;IA;SARS-CoV-2 IgG SerPl Ql IA
 ;;94508-9;SARS coronavirus 2 IgM Ab [Presence] in Serum or Plasma by Immunoassay;;SARS coronavirus 2 Ab.IgM;PrThr;Pt;Ser/Plas;Ord;IA;SARS-CoV-2 IgM SerPl Ql IA
 ;;94509-7;SARS coronavirus 2 E gene [Cycle Threshold #] in Unspecified specimen by NAA with probe detection;;SARS coronavirus 2 E gene;ThreshNum;Pt;XXX;Qn;Probe.amp.tar;SARS-CoV-2 E gene Ct XXX Qn NAA+probe
 ;;94510-5;SARS coronavirus 2 N gene [Cycle Threshold #] in Unspecified specimen by NAA with probe detection;;SARS coronavirus 2 N gene;ThreshNum;Pt;XXX;Qn;Probe.amp.tar;SARS-CoV-2 N gene Ct XXX Qn NAA+probe
 ;;94511-3;SARS coronavirus 2 ORF1ab region [Cycle Threshold #] in Unspecified specimen by NAA with probe detection;;SARS coronavirus 2 ORF1ab region;ThreshNum;Pt;XXX;Qn;Probe.amp.tar;SARS-CoV-2 ORF1ab Ct XXX Qn NAA+probe
 ;;94531-1;SARS coronavirus 2 RNA panel - Respiratory specimen by NAA with probe detection;;SARS coronavirus 2 RNA panel;-;Pt;Respiratory;-;Probe.amp.tar;SARS-CoV-2 RNA Pnl Resp NAA+probe
 ;;94532-9;SARS coronavirus+SARS-like coronavirus+SARS coronavirus 2+MERS coronavirus RNA [Presence] in Respiratory specimen by NAA with probe detection;;SARS coronavirus+SARS-like coronavirus+SARS coronavirus 2+MERS coronavirus RNA;PrThr;Pt;Respiratory;Ord;Probe.amp.tar;SARS+SARS-Lk+SARS-CoV-2+MERS Ql NAA-prb
 ;;94533-7;SARS coronavirus 2 N gene [Presence] in Respiratory specimen by NAA with probe detection;;SARS coronavirus 2 N gene;PrThr;Pt;Respiratory;Ord;Probe.amp.tar;SARS-CoV-2 N gene Resp Ql NAA+probe
 ;;94534-5;SARS coronavirus 2 RdRp gene [Presence] in Respiratory specimen by NAA with probe detection;;SARS coronavirus 2 RdRp gene;PrThr;Pt;Respiratory;Ord;Probe.amp.tar;SARS-CoV-2 RdRp gene Resp Ql NAA+probe
 ;;94547-7;SARS coronavirus 2 IgG+IgM Ab [Presence] in Serum or Plasma by Immunoassay;;SARS coronavirus 2 Ab.IgG+IgM;PrThr;Pt;Ser/Plas;Ord;IA;SARS-CoV-2 IgG+IgM SerPl Ql IA
 ;;$$END
 ;
 ;
SHOLOINC ; EP - Add COVID-19 LOINC Data
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S HEADER(1)="COVID-19 LOINC Data"
 S HEADER(2)="Data Listing"
 S HEADER(3)=" "
 S HEADER(4)="LOINC"
 S $E(HEADER(4),13)="ShortName"
 S $E(HEADER(4),43)="Property"
 S $E(HEADER(4),55)="Time"
 S $E(HADER(4),65)="Scale"
 ;
 D HEADERDT^BLRGMENU
 ;
 S LINETAG="COVID19",CNT=0
 F DATALINE=2:1  S LINESTR=$T(@LINETAG+DATALINE)  Q:LINESTR["$$END"  D
 . S CNT=CNT+1
 . S LOINC=$P(LINESTR,";",3)
 . S CODE=$P($P(LINESTR,";",3),"-")
 . S CHKDIGIT=$P($P(LINESTR,";",3),"-",2)
 . S LONGNAME=$P(LINESTR,";",4)
 . S COMPONENT=$P(LINESTR,";",6)            ; LAB LOINC COMPONENT (#95.31)
 . S PROPERTY=$P(LINESTR,";",7)             ; LAB ELECTRONIC CODES (#64.061)
 . S TIME=$P(LINESTR,";",8)                 ; LAB ELECTRONIC CODES (#64.061)
 . S SYSTEM=$P(LINESTR,";",9)               ; LAB ELECTRONIC CODES (#64.061)
 . S SCALE=$P(LINESTR,";",10)               ; LAB ELECTRONIC CODES (#64.061)
 . S METHOD=$P(LINESTR,";",11)              ; WKLD SUFFIX CODES (#64.2)
 . S SHORTNAME=$P(LINESTR,";",12)
 . ;
 . I $L(COMPONENT),$$FIND1^DIC(95.31,,"O",COMPONENT)<1 S NOTFOUND(95.31,COMPONENT)=1+$G(NOTFOUND(95.31,COMPONENT))
 . I $L(PROPERTY),$$FIND1^DIC(64.061,,"O",PROPERTY)<1 S NOTFOUND(64.061,"PROPERTY",PROPERTY)=1+$G(NOTFOUND(64.061,"PROPERTY",PROPERTY))
 . I $L(TIME),$$FIND1^DIC(64.061,,"O",TIME)<1 S NOTFOUND(64.061,"TIME",TIME)=1+$G(NOTFOUND(64.061,"TIME",TIME))
 . I $L(SYSTEM),$$FIND1^DIC(64.061,,"O",SYSTEM)<1 S NOTFOUND(64.061,"SYSTEM",SYSTEM)=1+$G(NOTFOUND(64.061,"SYSTEM",SYSTEM))
 . I $L(SCALE),$$FIND1^DIC(64.061,,"O",SCALE)<1 S NOTFOUND(64.061,"SCALE",SCALE)=1+$G(NOTFOUND(64.061,"SCALE",SCALE))
 . I $L(METHOD),$$FIND1^DIC(64.2,,"O",METHOD)<1 S NOTFOUND(64.2,METHOD)=1+$G(NOTFOUND(64.2,METHOD))
 . ;
 . W LOINC,?12,SHORTNAME,?42,PROPERTY,?54,TIME,64,SCALE,!
 ;
 W !!,?4,CNT," LOINC strings analyzed.",!
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
