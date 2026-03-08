BLRP46P2 ; IHS/MSC/MKK - RPMS COVID-19 LOINC Update Lab Patch LR*5.2*1046, Post Install, Part 2 ; 08-May-2020 07:55 ; MKK
 ;;5.2;IHS LABORATORY;**1046**;NOV 01, 1997;Build 24
 ;
 ; Cloned from BLRP44P2
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
PEP ; EP
 D ADDLLCOM
 D ADDLOINC
 D DISCLAMR
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
 ;;SARS coronavirus 2 Ag
 ;;SARS coronavirus 2 Ab.IgA
 ;;SARS coronavirus 2 S gene
 ;;SARS coronavirus 2 Ab
 ;;$$END
 ;
 ;
ADDLOINC ; EP - Add COVID-19 LOINC Data
 NEW HEADSTR,LINE,LINESTR,LINETAG,TAB
 ;
 K ^XTMP("BLRPRELO")
 S TAB=$J("",5)
 D BMES^XPDUTL(TAB_"Adding Entries to the LAB LOINC (#95.3) file begins.")
 D MES^XPDUTL("")
 ;
 S LINETAG="COVID19"
 F RTN="^BLRP46P3","^BLRP46P4" D
 . S RTNSTR="+5"_RTN
 . S HEADSTR=$T(@RTNSTR)
 . F LINE=2:1  S RTNSTR=LINETAG_"+"_LINE_RTN  S LINESTR=$T(@RTNSTR)  Q:LINESTR["$$END"  D
 .. D LOINCADD(LINESTR)
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
 . D MES^XPDUTL(TAB2_"LOINC "_$P(LINESTR,";",3)_" already in 95.3")
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
 S FDA(95.3,"+1,",3)=TIME
 S FDA(95.3,"+1,",80)=LONGNAME
 S FDA(95.3,"+1,",81)=SHORTNAME
 S IEN(1)=CODE
 ;
 D UPDATE^DIE("ES","FDA","IEN","ERRS")
 ;
 I $D(ERRS)<1 D
 . S IENSTR=IEN(1)_","
 . NEW FDA,ERRS
 . S FINDO=$$FIND1^DIC(95.31,,"O",COMPONENT)
 . S FINDX=$$FIND1^DIC(95.31,,"X",COMPONENT)
 . S FINDCOMP=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 . S:FINDCOMP FDA(95.3,IENSTR,1)=FINDCOMP
 . ;
 . S FINDO=$$FIND1^DIC(64.061,,"O",PROPERTY)
 . S FINDX=$$FIND1^DIC(64.061,,"X",PROPERTY)
 . S FINDPROP=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 . I PROPERTY'="-",FINDPROP S FDA(95.3,IENSTR,2)=FINDPROP
 . ;
 . S FINDO=$$FIND1^DIC(64.061,,"O",SYSTEM)
 . S FINDX=$$FIND1^DIC(64.061,,"X",SYSTEM)
 . S FINDSYS=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 . S:FINDSYS FDA(95.3,IENSTR,4)=FINDSYS
 . ;
 . S FINDO=$$FIND1^DIC(64.061,,"O",SCALE)
 . S FINDX=$$FIND1^DIC(64.061,,"X",SCALE)
 . S FINDSCL=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 . S:FINDSCL FDA(95.3,IENSTR,5)=FINDSCL
 . ;
 . S FINDO=$$FIND1^DIC(64.2,,"O",METHOD)
 . S FINDX=$$FIND1^DIC(64.2,,"X",METHOD)
 . S FINDMTH=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 . S:FINDMTH FDA(95.3,IENSTR,6)=FINDMTH
 . ;
 . D:$D(FDA) UPDATE^DIE("S","FDA",,"ERRS")
 ;
 I $D(ERRS)<1 D  Q
 . D MES^XPDUTL(TAB2_"Entry "_LOINC_" added to 95.3")
 ;
 ; If here, there was an error.  Show it.
 D MES^XPDUTL(TAB2_"Error adding "_LOINC_" to file 95.3")
 D MES^XPDUTL(TAB3_"Error:"_$G(ERRS("DIERR",1,"TEXT",1)))
 ;
 ; Store the error as well
 S:$D(^XTMP("BLRPRELO"))<1 ^XTMP("BLRPRELO")=$$HTFM^XLFDT(+$H+180)_U_$$DT^XLFDT_U_"LR*5.2*1046 Install Errors"
 S NOWHDT=$H
 M ^XTMP("BLRPRELO","LR*5.2*1046",NOWHDT,"95.3 Add Error",CODE,"FDA")=FDA
 S ^XTMP("BLRPRELO","LR*5.2*1046",NOWHDT,"95.3 Add Error",CODE,"ERROR")=$G(ERRS("DIERR",1,"TEXT",1))
 Q
 ;
DISCLAMR ; EP - Add Disclaimer comments to LOINC entries
 NEW ERRS,LINE,LINESTR,LINETAG,LOINC,NOWHDT,RTN,RTNSTR,TAB,WP
 ;
 ; Create Disclaimer array
 S WP(1)="Special Use codes are developed in response to an urgent or"
 S WP(2)="emergent situation. These codes are based on the most up to"
 S WP(3)="date information available at the time of their creation."
 S WP(4)="They have undergone the normal QA terminology process."
 S WP(5)="LOINC supports their use in the unique situation that"
 S WP(6)="resulted in their rapid creation. However, be aware that "
 S WP(7)="downstream users may not be ready to handle prerelease codes"
 S WP(8)="until they are published in an official release."
 ;
 S TAB=$J("",5),TAB2=$J("",10),TAB3=$J("",15)
 ;
 D BMES^XPDUTL(TAB_"Adding Disclaimer Comments to the Covid-19 LOINCs Begins.")
 D MES^XPDUTL(" ")
 ;
 S LINETAG="COVID19"
 F RTN="^BLRP46P3","^BLRP46P4","^BLRP44P2" D
 . F LINE=2:1  S RTNSTR=LINETAG_"+"_LINE_RTN  S LINESTR=$T(@RTNSTR)  Q:LINESTR["$$END"  D
 .. S LOINC=+$P(LINESTR,";",3)
 .. Q:$L(LOINC)<1
 .. Q:$L($$GET1^DIQ(95.3,LOINC,.01))<1   ; Skip if LOINC not in the file
 .. ;
 .. S XUMF=1
 .. K ERRS
 .. D WP^DIE(95.3,LOINC_",",99,"K","WP","ERRS")
 .. I $D(ERRS)<1 D MES^XPDUTL(TAB2_"Comments Added to LOINC "_LOINC) Q
 .. ;
 .. ; If here, there's an error
 .. D BMES^XPDUTL(TAB2_"Error adding Comments to LOINC "_LOINC)
 .. D MES^XPDUTL(TAB3_"Error:"_$G(ERRS("DIERR",1,"TEXT",1)))
 .. ;
 .. ; Store the error as well
 .. S:$D(^XTMP("BLRPRELO"))<1 ^XTMP("BLRPRELO")=$$HTFM^XLFDT(+$H+180)_U_$$DT^XLFDT_U_"LR*5.2*1046 Install Errors"
 .. S NOWHDT=$H
 .. S ^XTMP("BLRPRELO","LR*5.2*1046",NOWHDT,"95.3 Add Comment Error",LOINC)=""
 .. S ^XTMP("BLRPRELO","LR*5.2*1046",NOWHDT,"95.3 Add Comment Error",LOINC,"ERROR")=$G(ERRS("DIERR",1,"TEXT",1))
 ;
 D OLDLOINC
 ;
 D BMES^XPDUTL(TAB_"Adding Disclaimer Comments to the Covid-19 LOINCs Ends.")
 D MES^XPDUTL(" ")
 Q
 ;
OLDLOINC ; EP - Add Disclaimer to LR*5.2*1044 LOINCs
 NEW ERRS,LINE,LINESTR,LINETAG,LOINC,NOWHDT,RTN,RTNSTR,TAB,WP
 ;
 ; Create Disclaimer array
 S WP(1)="Special Use codes are developed in response to an urgent or"
 S WP(2)="emergent situation. These codes are based on the most up to"
 S WP(3)="date information available at the time of their creation."
 S WP(4)="They have undergone the normal QA terminology process."
 S WP(5)="LOINC supports their use in the unique situation that"
 S WP(6)="resulted in their rapid creation. However, be aware that "
 S WP(7)="downstream users may not be ready to handle prerelease codes"
 S WP(8)="until they are published in an official release."
 ;
 S TAB=$J("",5),TAB2=$J("",10),TAB3=$J("",15)
 ;
 S RTN="^BLRP44P2"
 S LINETAG="COVID19"
 F LINE=2:1  S RTNSTR=LINETAG_"+"_LINE_RTN  S LINESTR=$T(@RTNSTR)  Q:LINESTR["$$END"  D
 . S LOINC=+$P(LINESTR,";",3)
 . Q:LOINC<1
 . Q:$L($$GET1^DIQ(95.3,LOINC,.01))<1   ; Skip if LOINC not in the file
 . ;
 . S XUMF=1
 . K ERRS
 . D WP^DIE(95.3,LOINC_",",99,"K","WP","ERRS")
 . I $D(ERRS)<1 D MES^XPDUTL(TAB2_"Comments Added to LOINC "_LOINC) Q
 . ;
 . ; If here, there's an error
 . D BMES^XPDUTL(TAB2_"Error adding Comments to LOINC "_LOINC)
 . D MES^XPDUTL(TAB3_"Error:"_$G(ERRS("DIERR",1,"TEXT",1)))
 . ;
 . ; Store the error as well
 . S:$D(^XTMP("BLRPRELO"))<1 ^XTMP("BLRPRELO")=$$HTFM^XLFDT(+$H+180)_U_$$DT^XLFDT_U_"LR*5.2*1046 Install Errors"
 . S NOWHDT=$H
 . S ^XTMP("BLRPRELO","LR*5.2*1046",NOWHDT,"95.3 Add Comment Error",LOINC)=""
 . S ^XTMP("BLRPRELO","LR*5.2*1046",NOWHDT,"95.3 Add Comment Error",LOINC,"ERROR")=$G(ERRS("DIERR",1,"TEXT",1))
 Q
 ;
 ;
SHOLOINC ; EP - Add COVID-19 LOINC Data Report
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S HEADER(1)="COVID-19 LOINC Data"
 S HEADER(2)="Data Listing"
 S HEADER(3)=" "
 S HEADER(4)="LOINC"
 S $E(HEADER(4),13)="ShortName"
 S $E(HEADER(4),30)="Compnent"
 S $E(HEADER(4),49)="Property"
 S $E(HEADER(4),59)="Time"
 S $E(HEADER(4),65)="System"
 S $E(HEADER(4),76)="Scale"
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
 . I $L(COMPONENT) D
 .. S FINDO=$$FIND1^DIC(95.31,,"O",COMPONENT)
 .. S FINDX=$$FIND1^DIC(95.31,,"X",COMPONENT)
 .. S FINDCOMP=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 .. S FLAGCOMP=$S(FINDO:"~O",FINDX:"~X",1:"~*")
 .. I FINDCOMP<1 S NOTFOUND(95.31,COMPONENT)=1+$G(NOTFOUND(95.31,COMPONENT))
 . ;
 . I $L(PROPERTY) D
 .. S FINDO=$$FIND1^DIC(64.061,,"O",PROPERTY)
 .. S FINDX=$$FIND1^DIC(64.061,,"X",PROPERTY)
 .. S FINDPROP=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 .. S FLAGPROP=$S(FINDO:"~O",FINDX:"~X",1:"~*")
 .. I FINDPROP<1 S NOTFOUND(64.061,"PROPERTY",PROPERTY)=1+$G(NOTFOUND(64.061,"PROPERTY",PROPERTY))
 . ;
 . I $L(TIME) D
 .. S FINDO=$$FIND1^DIC(64.061,,"O",TIME)
 .. S FINDX=$$FIND1^DIC(64.061,,"X",TIME)
 .. S FINDTIME=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 .. S FLAGTIME=$S(FINDO:"~O",FINDX:"~X",1:"~*")
 .. I FINDTIME<1 S NOTFOUND(64.061,"TIME",TIME)=1+$G(NOTFOUND(64.061,"TIME",TIME))
 . ;
 . I $L(SYSTEM) D
 .. S FINDO=$$FIND1^DIC(64.061,,"O",SYSTEM)
 .. S FINDX=$$FIND1^DIC(64.061,,"X",SYSTEM)
 .. S FINDSYS=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 .. S FLAGSYS=$S(FINDO:"~O",FINDX:"~X",1:"~*")
 .. I FINDSYS<1 S NOTFOUND(64.061,"SYSTEM",SYSTEM)=1+$G(NOTFOUND(64.061,"SYSTEM",SYSTEM))
 . ;
 . I $L(SCALE) D
 .. S FINDO=$$FIND1^DIC(64.061,,"O",SCALE)
 .. S FINDX=$$FIND1^DIC(64.061,,"X",SCALE)
 .. S FINDSCL=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 .. S FLAGSCL=$S(FINDO:"~O",FINDX:"~X",1:"~*")
 .. I FINDSCL<1 S NOTFOUND(64.061,"SCALE",SCALE)=1+$G(NOTFOUND(64.061,"SCALE",SCALE))
 . ;
 . I $L(METHOD) D
 .. S FINDO=$$FIND1^DIC(64.2,,"O",METHOD)
 .. S FINDX=$$FIND1^DIC(64.02,,"X",METHOD)
 .. S FINDMTH=$S(FINDO:FINDO,FINDX:FINDX,1:"")
 .. S FLAGMTH=$S(FINDO:"~O",FINDX:"~X",1:"~*")
 .. I FINDMTH<1 S NOTFOUND(64.2,METHOD)=1+$G(NOTFOUND(64.2,METHOD))
 . ;
 . W LOINC
 . W ?9,$E(SHORTNAME,1,18)
 . W ?29,$E(COMPONENT,1,15),FLAGCOMP
 . W ?48,$E(PROPERTY,1,7),FLAGPROP
 . W ?58,$E(TIME,1,7),FLAGTIME
 . W ?64,$E(SYSTEM,1,7),FLAGSYS
 . W ?75,$E(SCALE,1,7),FLAGSCL
 . ; W ?79,METHOD,FLAGMTH
 . W !
 ;
 W !!,?4,CNT," LOINC strings analyzed.",!
 D PRESSKEY^BLRGMENU(9)
 ; 
 Q
 ;
