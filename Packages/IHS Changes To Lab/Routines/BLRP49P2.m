BLRP49P2 ; IHS/MSC/MKK - RPMS LOINC UPDATE Lab Patch LR*5.2*1049 Post Install Part 2 ; 19-Jan-2021 07:20 ; MKK
 ;;5.2;IHS LABORATORY;**1049**;NOV 01, 1997;Build 4
 ;
 Q
 ;
 ;
WKLDSADD ; EP - Add entries to WKLD SUFFIX CODES (#64.2) dictionary
 NEW ERRS,F6421IEN,F643IEN,FDA,WKLDSUF
 ;
 D BMES^XPDUTL(TAB_"Adding Entries to the WKLD SUFFIX CODES (#64.2) file begins.")
 ;
 S F643IEN=$$FIND1^DIC(64.3,,"O","REGENSTRIEF")
 S F6421IEN=$$FIND1^DIC(64.21,,"O","Not Assigned")
 ;
 ; Note that the WKLD SUFFIX CODE values were retrieved from the VA LOINC Patch LR*5.2*539 KIDS file.
 F WKLD="Non-probe.amp.tar^.1746","Probe.amp.tar.CDC primer-probe set N1^.2380","Probe.amp.tar.CDC primer-probe set N2^.2381","IA.rapid^.1319","pVNT^.2394","Probe.amp.tar^.3253"  D
 . S WKLDSUF=$P(WKLD,U)
 . I $$FIND1^DIC(64.2,,"O",WKLDSUF) D  Q     ; Skip if already in dictionary
 .. D MES^XPDUTL(TAB2_"'"_WKLDSUF_"' already in WKLD SUFFIX CODES (#64.2) file.")
 . ;
 . S WKLDSUFC=$P(WKLD,U,2)
 . ;
 . K FDA,ERRS
 . S FDA(64.2,"+1,",.01)=WKLDSUF
 . S FDA(64.2,"+1,",1)=WKLDSUFC
 . S:F643IEN FDA(64.2,"+1,",11)="`"_F643IEN
 . S:F6421IEN FDA(64.2,"+1,",12)="`"_F6421IEN
 . S FDA(64.2,"+1,",19)="REGENSTRIEF"
 . ;
 . D UPDATE^DIE("S","FDA",,"ERRS")
 . ;
 . I $D(ERRS)<1 D MES^XPDUTL(TAB2_"Added '"_WKLDSUF_"' to file 64.2")
 . I $D(ERRS) D
 .. D MES^XPDUTL(TAB2_"Error adding '"_WKLDSUF_"' to file 64.2")
 .. D MES^XPDUTL(TAB3_"Error:"_$G(ERRS("DIERR",1,"TEXT",1)))
 .. M ^XTMP("BLRPRELO","64.2 Add Error ",WKLDSUF,"FDA")=FDA
 ;
 D MES^XPDUTL(TAB_"Adding Entries to the WKLD SUFFIX CODES (#64.2) file ends.")
 D MES^XPDUTL("")
 Q
 ;
 ;
LABLCOMP ; EP - Add entries to the LAB LOINC COMPONENT (#95.31) file
 NEW HEADSTR,LINE,LINESTR,LINETAG,TAB,TAB2,TAB3
 ;
 S TAB=$J("",5),TAB2=$J("",10),TAB3=$J("",15)
 ;
 D BMES^XPDUTL(TAB_"Adding Entries to the LAB LOINC COMPONENT (#95.31) file begins.")
 ;
 S LINETAG="LLCOMPS"
 S HEADSTR=$T(@LINETAG+1)
 F LINE=2:1  S LINESTR=$T(@LINETAG+LINE)  Q:LINESTR["$$END"  D
 . D LLCOMADD(LINESTR)
 ;
 D MES^XPDUTL(TAB_"Adding Entries to the LAB LOINC COMPONENT (#95.31) file ends.")
 D MES^XPDUTL("")
 Q
 ;
 ; Note that the LAB LOINC COMPONENT IEN values were retrieved from the VA LOINC Patch LR*5.2*539 KIDS file.
LLCOMADD(LINESTR) ; EP - Add an entry to the LAB LOINC COMPONENT (#95.31) file
 NEW IEN,LABLCOMP,LABLCIEN
 ;
 S LABLCOMP=$P(LINESTR,";",3)
 ;
 I $$FIND1^DIC(95.31,,"O",LABLCOMP) D  Q      ; Skip if already entered
 . D MES^XPDUTL(TAB2_"LAB LOINC COMPONENT "_LABLCOMP_" already in 95.31")
 ;
 S LABLCIEN=+$P(LINESTR,";",4)      ; IEN 
 S:LABLCIEN IEN(1)=LABLCIEN
 ;
 S FDA(95.31,"+1,",.01)=LABLCOMP
 I LABLCIEN D UPDATE^DIE("S","FDA","IEN","ERRS")
 I LABLCIEN<1 D UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS)<1 D  Q
 . D MES^XPDUTL(TAB2_"LAB LOINC COMPONENT")
 . D MES^XPDUTL(TAB3_LABLCOMP)
 . D MES^XPDUTL(TAB2_"added to 95.31")  Q
 ;
 ; If here, there was an error.  Show it.
 D MES^XPDUTL(TAB2_"Error adding "_LOINC_" to file 95.3")
 D MES^XPDUTL(TAB3_"Error:"_$G(ERRS("DIERR",1,"TEXT",1)))
 M ^XTMP("BLRPRELO","95.31 Add Error",LABLCOMP,"FDA")=FDA
 Q
 ;
 ;
LLCOMPS ; EP - LAB LOINC COMPONENT Data
 ;;Respiratory pathogens DNA & RNA panel;39942
 ;;SARS coronavirus 2 Ab.IgA+IgM;53845
 ;;SARS coronavirus+SARS coronavirus 2 Ag; 53806
 ;;Influenza virus A & Influenza virus B & SARS coronavirus 2 & SARS-related coronavirus RNA panel
 ;;SARS coronavirus 2 Ab.neut;53923
 ;;Influenza virus A & Influenza virus B & SARS coronavirus 2 RNA panel
 ;;Influenza virus A & Influenza virus B & SARS coronavirus 2 identified
 ;;SARS-related coronavirus E gene;53338
 ;;Influenza virus A & Influenza virus B & SARS coronavirus 2 & Respiratory syncytial virus RNA panel
 ;;Influenza virus A & Influenza virus B & SARS coronavirus+SARS coronavirus 2 Ag panel
 ;;SARS coronavirus 2 specific TCRB gene rearrangements
 ;;SARS coronavirus 2 stimulated gamma interferon
 ;;SARS coronavirus 2 stimulated gamma interferon release by T-cells^^corrected for background
 ;;SARS coronavirus 2 stimulated gamma interferon release by T-cells
 ;;SARS coronavirus 2 stimulated gamma interferon panel
 ;;SARS coronavirus 2 & SARS-related coronavirus RNA panel
 ;;SARS coronavirus 2 Ab panel;53333
 ;;SARS-related coronavirus E gene
 ;;SARS coronavirus 2 spike protein RBD Ab.neut
 ;;SARS coronavirus 2 variant
 ;;$$END
 Q
 ;
 ;
SHOWDATA ; EP - Show the LOINCs that are to be added.  No updating.
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 D:+$G(IOM)<1 HOME^%ZIS
 ;
 S QFLG="NO"
 S LINETAG="COVID19"
 S RTN="BLRP49P3"
 S STR=LINETAG_"+1^"_RTN
 S HEADSTR=$T(@STR)
 F LINE=2:1  S STR=LINETAG_"+"_LINE_U_RTN  S LINESTR=$T(@STR)  Q:LINESTR["$$END"!(QFLG="Q")  D
 . S LOINC=$P(LINESTR,";",3)
 . S CHKDIGIT=$P($P(LINESTR,";",3),"-",2)
 . S COMPNENT=$P(LINESTR,";",5)
 . S COMPDICT=$$FIND1^DIC(95.31,,"O",COMPNENT)
 . S PROPERTY=$P(LINESTR,";",6)
 . S:PROPERTY="-" PROPERTY="DASH"
 . S PROPDICT=$$LECMDICT^BLRPST49(PROPERTY)
 . S TIMEASPT=$P(LINESTR,";",7)
 . S TIMEDICT=$$LECMDICT^BLRPST49(TIMEASPT)
 . S SYSTEM=$P(LINESTR,";",8)
 . S SYSDICT=$$LECMDICT^BLRPST49(SYSTEM)
 . S SCALETYP=$P(LINESTR,";",9)
 . S:SCALETYP="-" SCALETYP="DASH"
 . S SCALEDIC=$$LECMDICT^BLRPST49(SCALETYP)
 . S METHTYPE=$P(LINESTR,";",10)
 . S METHDICT=$$FIND1^DIC(64.2,,"O",METHTYPE)
 . S CLASS=$P(LINESTR,";",11)
 . S CLASSDIC=$$LECMDICT^BLRPST49(CLASS)
 . S CLASSTYP=$P(LINESTR,";",12)
 . S LONGNAME=$P(LINESTR,";",13)
 . S SHRTNAME=$P(LINESTR,";",14)
 . S COPYRITE=$P(LINESTR,";",15)
 . S STATUS=$P(LINESTR,";",16)
 . S FIRSTREL=$P(LINESTR,";",17)
 . S LASTCHNG=$P(LINESTR,";",18)
 . ;
 . W !!
 . W ?4,"VARIABLE"
 . W ?19,"VALUE"
 . W ?69,"Dict"
 . W ?77,"IN?"
 . W !,$TR($J("",IOM)," ","-"),!
 . ;
 . W ?4,"LOINC",?19,LOINC,!
 . W ?4,"COMPONENT"  D LINEWRAP^BLRGMENU(19,COMPNENT,48)  W ?69,"95.31",?77,$$INDICT(COMPDICT),!
 . W ?4,"PROPERTY",?19,PROPERTY,?69,"64.061",?77,$$INDICT(PROPDICT),!
 . W ?4,"TIME ASPECT",?19,TIMEASPT,?69,"64.061",?77,$$INDICT(TIMEDICT),!
 . W ?4,"SYSTEM",?19,SYSTEM,?69,"64.061",?77,$$INDICT(SYSDICT),!
 . W ?4,"SCALE TYPE",?19,SCALETYP,?69,"64.061",?77,$$INDICT(SCALEDIC),!
 . W ?4,"METHOD TYPE",?19,METHTYPE,?69,"64.2",?77,$$INDICT(METHDICT),!
 . W ?4,"CLASS",?19,CLASS,?69,"64.061",?77,$$INDICT(CLASSDIC),!
 . W ?4,"CLASS TYPE",?19,CLASSTYP,!
 . W ?4,"LONG NAME"  D LINEWRAP^BLRGMENU(19,LONGNAME,58)  W !
 . W ?4,"SHORT NAME",?19,SHRTNAME,!
 . W ?4,"COPY RIGHT",COPYRITE,!
 . W ?4,"STATUS",?19,STATUS,!
 . W ?4,"First Rel",?19,FIRSTREL,!
 . W ?4,"Last Chng",?19,LASTCHNG,!
 . D PRESSKEY^BLRGMENU(9)
 ;
 Q
 ;
 ;
INDICT(VALUE) ; EP
 Q $S(VALUE=0:"NO",$L($G(VALUE)):"YES",1:"NO")
 ;
 ;
