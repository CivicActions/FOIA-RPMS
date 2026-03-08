BLRDESIG ; IHS/MSC/MKK - Deprecate Lab E-SIG Menus/Options; 10-Oct-2023 11:25 ; MKK
 ;;5.2;IHS LABORATORY;**1054**;NOV 01, 1997;Build 20
 ;
 ; Item 102309 - Deprecate Lab E-SIG module
 ;
EEP ; Ersatz EP
 W !!,$C(7),$C(7),$C(7)
 W ?9,$$SHOUTMSG^BLRGMENU("Must use Line Labels to access subroutines",60)
 W !!,$C(7),$C(7),$C(7)
 Q
 ;
 ;
POST ; EP - Post-Install
 NEW BLRVERN,CP,CPSTR,PATCHNUM,TAB,TODAY,WOTCNT
 ; 
 D SETEVARS
 ;
 S TODAY=$$DT^XLFDT
 S WOTCNT=$$WOTCNT(BLRVERN)
 S TAB=$J("",5)
 ;
 D BMES^XPDUTL(CPSTR_" Post Install begins.")
 D MES^XPDUTL("")
 ;
 D ESIGPLUG     ; Turn RPMS LAB E-SIG PLUG-IN OFF
 D ESIGOPTS     ; Make Lab E-Sig options OUT-OF-ORDER fields set
 D OTHRMENU     ; Remove LAB ESIG Options from Other Menus
 ;
 D BMES^XPDUTL(CPSTR_" Post Install ends.")
 D MES^XPDUTL("")
 ;
 D ^XBFMK
 Q
 ;
ESIGPLUG ; EP - Make sure RPMS LAB E-SIG PLUG-IN is OFF
 NEW BLRSITEI,BLRSITEN,ERRS,FDA,I,LABAPPPI,PLUGIN,TAB
 ;
 F I=1:1:3 S TAB(I)=$J("",5*I)
 ;
 D BMES^XPDUTL(TAB(1)_"BLR MASTER CONTROL (#9009029) file")
 D MES^XPDUTL(TAB(2)_"""LR*5.2*1013"" Plug-In")
 D MES^XPDUTL(TAB(1)_"Inactivation begins.")
 D MES^XPDUTL("")
 ;
 S BLRSITEI=.9999999
 F  S BLRSITEI=$O(^BLRSITE(BLRSITEI))  Q:BLRSITEI<1  D
 . S BLRSITEN=$$GET1^DIQ(9009029,BLRSITEI,.01)     ; SITE NAME
 . S LABAPPPI=0      ; LAB APPLICATION PLUG-IN
 . F  S LABAPPPI=$O(^BLRSITE(BLRSITEI,1,LABAPPPI))  Q:LABAPPPI<1  D
 .. S PLUGIN=$$GET1^DIQ(9009029.02101,LABAPPPI_","_BLRSITEI,.01)
 .. Q:PLUGIN'="LR*5.2*1013"
 .. ;
 .. ; At this point, the PLUG-IN is known to be LR*5.2*1013
 .. K FDA,ERRS
 .. S FDA(9009029.02101,LABAPPPI_","_BLRSITEI_",",1)=0   ; Force to OFF
 .. D UPDATE^DIE("S","FDA",,"ERRS")
 .. I $D(ERRS)<1 D  Q
 ... D MES^XPDUTL(TAB(2)_BLRSITEN_"'s 'LR*5.2*1013' PLUG-IN set to OFF.")
 .. ;
 .. ; At this point, known error.  Report it.
 .. D BMES^XPDUTL(TAB(2)_BLRSITEN_"'s LR*5.2*1013 PLUG-IN Change UPDATE^DIE Error.")
 .. D MES^XPDUTL(TAB(3)_"Error:"_$G(ERRS("DIERR",1,"TEXT",1)))
 .. D MES^XPDUTL("")
 ;
 D BMES^XPDUTL(TAB(1)_"BLR MASTER CONTROL (#9009029) file")
 D MES^XPDUTL(TAB(2)_"""LR*5.2*1013"" Plug-In")
 D MES^XPDUTL(TAB(1)_"Inactivation ends.")
 D MES^XPDUTL("")
 D ^XBFMK
 Q
 ;
 ;
ESIGOPTS ; EP - Make sure all Lab E-Sig options OUT-OF-ORDER fields set and removed from main Lab Options
 NEW BLRVERN,CNT,F19IEN,F19OTHER,I,LINE,LINESTR,LINETAG,MENU,ONGO,OTHRMENU,OPTION,TAB
 ;
 F I=1:1:3 S TAB(I)=$J("",5*I)
 S BLRVERN=$TR($P($T(+1),";")," ")
 ;
 D BMES^XPDUTL(TAB(1)_"RPRMS LAB E-SIG Options Deprecation begins.")
 D MES^XPDUTL("")
 ;
 ; First, make sure all RPMS LAB E-SIG options have OUT-OF-ORDER field set.
 S LINETAG="OPTSESIG"
 F LINE=1:1  S LINESTR=$T(@(LINETAG_"+"_LINE_U_BLRVERN))  Q:LINESTR["$$END"  D
 . S OPTION=$P(LINESTR,";",3)
 . D OUT^XPDMENU(OPTION,"DEPRECATED")
 . ;
 . S F19IEN=$$LKOPT^XPDMENU(OPTION)
 . S OOORDER=$$GET1^DIQ(19,F19IEN,"OUT OF ORDER MESSAGE")
 . D MES^XPDUTL(TAB(2)_OPTION_" OUT OF ORDER MESSAGE = "_OOORDER)
 ;
 ; Next, make sure LAB ESIG MENU is removed from LRMENU, BLRMENU, IHS OIT BLRMENU, and
 ; IHS SHORT LAB MAIN MENU.
 F MENU="LRMENU","BLRMENU","IHS OIT BLRMENU","IHS SHORT LAB MAIN MENU"  D
 . I $$DELETE^XPDMENU(MENU,"BLRA LAB ESIG MENU") D
 .. D MES^XPDUTL(TAB(2)_"'BLRA LAB ESIG MENU' option removed from "_MENU_".")
 . I $$DELETE^XPDMENU(MENU,"BLRA LAB E-SIG Menu") D
 .. D MES^XPDUTL(TAB(2)_"'BLRA LAB E-SIG Menu' option removed from "_MENU_".")
 ;
 D BMES^XPDUTL(TAB(1)_"RPRMS LAB E-SIG Options Deprecation ends.")
 D ^XBFMK
 Q
 ;
OTHRMENU ; EP - Remove LAB ESIG Options from Other Menus
 NEW BLRVERN,CNT,F19IEN,F19OTHER,I,LINE,LINESTR,LINETAG,MENU,ONGO,OTHRMENU,OPTION,TAB
 ;
 F I=1:1:3 S TAB(I)=$J("",5*I)
 S BLRVERN=$TR($P($T(+1),";")," ")
 ;
 D BMES^XPDUTL(TAB(1)_"RPRMS LAB E-SIG Options Other Menu Removal begins.")
 D MES^XPDUTL("")
 ;
 ; Make sure all RPMS LAB E-SIG options are removed from other menus
 S ONGO="YES"
 F  Q:ONGO="NO"  D
 . S CNT=0
 . S LINETAG="OPTSESIG"
 . F LINE=1:1  S LINESTR=$T(@(LINETAG_"+"_LINE_U_BLRVERN))  Q:LINESTR["$$END"!(LINESTR="")  D
 .. S OPTION=$P(LINESTR,";",3)
 .. S F19IEN=$$LKOPT^XPDMENU(OPTION)
 .. Q:F19IEN<1
 .. ;
 .. S F19OTHER=0
 .. F  S F19OTHER=$O(^DIC(19,"AD",F19IEN,F19OTHER))  Q:F19OTHER<1  D
 ... S OTHRMENU=$$GET1^DIQ(19,F19OTHER,"NAME")
 ... ;
 ... ; Don't remove from RPMS LAB ESIG Menus
 ... Q:OTHRMENU="BLRA Lab E-SIG Menu"
 ... Q:OTHRMENU="BLRA LAB ESIG MENU"
 ... ;
 ... S CNT=CNT+1
 ... S X=$$DELETE^XPDMENU(OTHRMENU,OPTION)
 ... D:X MES^XPDUTL(TAB(2)_"Option "_OPTION_" Removed from "_OTHRMENU_".")
 . S:CNT<1 ONGO="NO"
 ;
 D BMES^XPDUTL(TAB(1)_"RPRMS LAB E-SIG Options Other Menu Removal ends.")
 D MES^XPDUTL("")
 Q
 ;
 ;
OPTSESIG ; EP
 ;;BLRA LAB AUDIT ARCHIVE
 ;;BLRA LAB ES INACTIVATE PHYS
 ;;BLRA LAB ES PHYSICIANS
 ;;BLRA LAB ES SURR PHYS PURGE
 ;;BLRA LAB ESIG MENU
 ;;BLRA LAB E-SIG Menu
 ;;BLRA Lab E-SIG Menu
 ;;BLRA LAB REVIEW/SIGN RESULTS
 ;;BLRA LAB SIGNED RPT
 ;;BLRA LAB DELINQUENT RPT
 ;;$$END
 ;
 ;
 ; ================================== UTILITIES ===================================
 ;
SETEVARS ; EP - SET standard "Enviroment" VARiables.
 S (CP,PATCHNUM)=$P($T(+2),"*",3)
 S CPSTR="LR*5.2*"_CP
 S BLRVERN=$TR($P($T(+1),";")," ")
 Q
 ;
BLANK ; EP - Blank Line
 D MES^XPDUTL("")
 Q
 ;
WOTCNT(BLRVERN) ; EP - Counter for ^XTMP
 NEW CNT,TODAY
 ;
 S TODAY=$$DT^XLFDT
 ;
 S CNT=1+$G(^XTMP(BLRVERN,0,TODAY))
 S ^XTMP(BLRVERN,0,TODAY)=CNT
 Q $TR($J(CNT,3)," ","0")
