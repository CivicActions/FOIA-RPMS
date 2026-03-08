BLRP52P2 ; IHS/MSC/MKK - RPMS MONKEY POX LOINC Post Install ; 06-Sep-2022 14:45 ; MKK
 ;;5.2;IHS LABORATORY;**1052**;NOV 01, 1997;Build 17
 ;
EEP ; Ersatz EP
 D EEP^BLRPRE52
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
 ;;Monkeypox virus DNA
 ;;West African Monkeypox virus DNA
 ;;Congo Basin Monkeypox virus DNA
 ;;$$END
 ;
 ;
ADDLECOD ; EP - Add Data to the LAB ELECTRONIC CODES (#64.061) file
 NEW CODES,ERRS,FDA,TAB,TAB2,TAB3
 ;
 Q       ; As of 06-Sep-2022, no SYSTEM for MonekyPox
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
 ;;PrThr
 ;;Pt
 ;;Ord
 ;;Probe.amp.tar
 ;;$$END
 ;
 ;
ADDLOINC ; EP - Add MonkeyPox LOINC Data
 NEW HEADSTR,LINE,LINESTR,LINETAG,TAB
 ;
 K ^XTMP("BLRPRELO")
 S TAB=$J("",5)
 D BMES^XPDUTL(TAB_"Adding Entries to the LAB LOINC (#95.3) file begins.")
 ;
 S LINETAG="MONKYPOX"
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
 S:TIME'="-" FDA(95.3,"+1,",3)=TIME
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
MONKYPOX ; EP - LOINC Data
 ;;LOINC_NUM;LONG_COMMON_NAME;Special Use;COMPONENT;PROPERTY;TIME_ASPCT;SYSTEM;SCALE_TYP;METHOD_TYP;SHORTNAME
 ;;100383-9;Monkeypox virus DNA;PrThr;Pt;XXX;Ord;Probe.amp.tar;MICRO;2.73;ADD;;ACTIVE;;1;;;;;N;3 Self-Sustaining Sequence Replication; 3SR SR; Amplif; Amplification; Amplified; Deoxyribonucleic acid; DNA NUCLEIC ACID PROBE; DNA probe; LAT; LCR; Ligase chain reaction; Ligation-activated transcription; Microbiology; Misc; Miscellaneous; MVPX; MVPX DNA; NAA+probe; NAAT; NASBA; Nucleic acid sequence based analysis; Ordinal; Other; PCR; Point in time; Polymerase chain reaction; PR; Probe amp; Probe with ampification; Probe with target amplification; QBR; QL; Qual; Qualitative; Random; Screen; SDA; Spec; Strand Displacement Amplification; TMA; To be specified in another part of the message; Transcription mediated amplification; Unspecified;MVPX DNA Spec Ql NAA+probe;Both;;;;Monkeypox virus DNA [Presence] in Specimen by NAA with probe detection;;;;;0;0;0;;;;;;2.73;;Monkeypox virus DNA NAA+probe Ql (Specimen)
 ;;100888-7;West African monkeypox virus DNA;PrThr;Pt;XXX;Ord;Probe.amp.tar;MICRO;2.73;ADD;;ACTIVE;;1;;;;;N;3 Self-Sustaining Sequence Replication; 3SR SR; Amplif; Amplification; Amplified; Deoxyribonucleic acid; DNA NUCLEIC ACID PROBE; DNA probe; LAT; LCR; Ligase chain reaction; Ligation-activated transcription; Microbiology; Misc; Miscellaneous; MVPX; MVPX DNA; NAA+probe; NAAT; NASBA; Nucleic acid sequence based analysis; Ordinal; Other; PCR; Point in time; Polymerase chain reaction; PR; Probe amp; Probe with ampification; Probe with target amplification; QBR; QL; Qual; Qualitative; Random; Screen; SDA; Spec; Strand Displacement Amplification; TMA; To be specified in another part of the message; Transcription mediated amplification; Unspecified; WA MVPX; WA MVPX DNA;WA MVPX DNA Spec Ql NAA+probe;Both;;;;West African monkeypox virus DNA [Presence] in Specimen by NAA with probe detection;;;;;0;0;0;;;;;;2.73;;West African monkeypox virus DNA NAA+probe Ql (Specimen)
 ;;100889-5;Congo Basin monkeypox virus DNA;PrThr;Pt;XXX;Ord;Probe.amp.tar;MICRO;2.73;ADD;;ACTIVE;;1;;;;;N;3 Self-Sustaining Sequence Replication; 3SR SR; Amplif; Amplification; Amplified; CB MVPX; CB MVPX DNA; Deoxyribonucleic acid; DNA NUCLEIC ACID PROBE; DNA probe; LAT; LCR; Ligase chain reaction; Ligation-activated transcription; Microbiology; Misc; Miscellaneous; MVPX; MVPX DNA; NAA+probe; NAAT; NASBA; Nucleic acid sequence based analysis; Ordinal; Other; PCR; Point in time; Polymerase chain reaction; PR; Probe amp; Probe with ampification; Probe with target amplification; QBR; QL; Qual; Qualitative; Random; Screen; SDA; Spec; Strand Displacement Amplification; TMA; To be specified in another part of the message; Transcription mediated amplification; Unspecified;CB MVPX DNA Spec Ql NAA+probe;Both;;;;Congo Basin monkeypox virus DNA [Presence] in Specimen by NAA with probe detection;;;;;0;0;0;;;;;;2.73;;Congo Basin monkeypox virus DNA NAA+probe Ql (Specimen)
 ;;100890-3;Poxvirus DNA panel;-;Pt;Patient;-;;PANEL.MICRO;2.73;ADD;;ACTIVE;;1;;;;;N;Deoxyribonucleic acid; Microbiology; Pan; PANEL.MICROBIOLOGY; Panl; Pnl; Point in time; Random;Poxvirus DNA panel Patient;Both;;;;Poxvirus DNA panel;;;;;0;0;0;;;Panel;;;2.73;;Poxvirus DNA panel
 ;;$$END
 ;
 ;
SHOLOINC ; EP - Show MonkeyPox LOINC Data
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S HEADER(1)="MonkeyPox LOINC Data"
 S HEADER(2)="Data Listing"
 S HEADER(3)=" "
 S HEADER(4)="LOINC"
 S $E(HEADER(4),13)="ShortName"
 S $E(HEADER(4),43)="Property"
 S $E(HEADER(4),55)="Time"
 S $E(HEADER(4),65)="Scale"
 ;
 D HEADERDT^BLRGMENU
 ;
 S LINETAG="MONKYPOX",CNT=0
 F DATALINE=2:1  S LINESTR=$T(@LINETAG+DATALINE)  Q:LINESTR["$$END"  D
 . S CNT=CNT+1
 . S LOINC=$P(LINESTR,";",3)
 . S CODE=$P($P(LINESTR,";",3),"-")
 . S CHKDIGIT=$P($P(LINESTR,";",3),"-",2)
 . S LONGNAME=$P(LINESTR,";",28)
 . S COMPONENT=$P(LINESTR,";",4)            ; LAB LOINC COMPONENT (#95.31)
 . S PROPERTY=$P(LINESTR,";",5)             ; LAB ELECTRONIC CODES (#64.061)
 . S TIME=$P(LINESTR,";",6)                 ; LAB ELECTRONIC CODES (#64.061)
 . S SYSTEM=$P(LINESTR,";",7)               ; LAB ELECTRONIC CODES (#64.061)
 . S SCALE=$P(LINESTR,";",8)               ; LAB ELECTRONIC CODES (#64.061)
 . S METHOD=$P(LINESTR,";",9)              ; WKLD SUFFIX CODES (#64.2)
 . S SHORTNAME=$P(LINESTR,";",23)
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
