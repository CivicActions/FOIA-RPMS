BIPTCH1 ;IHS/CMI/MWR - PRE- AND POST-INIT ROUTINE CALLS FOR PATCH #1.
 ;;8.0;IMMUNIZATION;**1**;MAY 1,2004
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  PRE-INIT and POST-INIT to confirm installation of Imm v8.0 Patch #1.
 ;
 ;
 ;----------
PRE ;EP
 ;---> Pre-init program.
 ;
 D ^XBKVAR
 ;DUZ(0)="@"
 N DIU
 S DIU(0)="T",DIU=9999999.41 D EN^DIU2
 Q
 ;
 ;
 ;----------
POST ;EP
 ;---> Update software after KIDS installation.
 ;
 D ^XBKVAR
 D TEXT1,DIRZ()
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;
 ;;
 ;;Immunization v8.0
 ;;                    *  IMMUNIZATION PATCH #1  *
 ;;
 ;;
 ;; NOTE: Be sure to place the Immserve patch files (ihs-5-idef.csv and
 ;;       ihs-10-idef.csv) in the host file directory with the other
 ;;       Immserve files (per Installation Notes for this patch).
 ;;
 ;;
 ;;         - This concludes the Patch Installation program. -
 ;;
 ;;                       * CONGRATULATIONS! *
 ;;
 ;;    You have successfully installed Patch #1 for Immunization v8.0.
 ;;
 ;;
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 ;---> Print text at specified line label.
 ;
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
DIRZ(BIPOP,BIPRMT,BIPRMT1,BIPRMT2,BIPRMTQ) ;EP - Press RETURN to continue.
 ;---> Call to ^DIR, to Press RETURN to continue.
 ;---> Parameters:
 ;     1 - BIPOP   (ret) BIPOP=1 if DTOUT or DUOUT
 ;     2 - BIPRMT  (opt) Prompt other than "Press RETURN..."
 ;     3 - BIPRMT1 (opt) Prompt other than "Press RETURN..."
 ;     4 - BIPRMT2 (opt) Prompt other than "Press RETURN..."
 ;     5 - BIPRMTQ (opt) Response to "?" other than standard
 ;
 ;---> Example: D DIRZ^BIUTL3(.BIPOP)
 ;
 N DDS,DIR,DIRUT,X,Y,Z
 D
 .I $G(BIPRMT)="" D  Q
 ..S DIR("A")="   Press ENTER/RETURN to continue or ""^"" to exit"
 .S DIR("A")=BIPRMT
 .I $G(BIPRMT1)]"" S DIR("A",1)=BIPRMT1
 .I $G(BIPRMT2)]"" S DIR("A",2)=BIPRMT2
 I $G(BIPRMTQ)]"" S DIR("?")=BIPRMTQ
 S DIR(0)="E" W ! D ^DIR W !
 S BIPOP=$S($D(DIRUT):1,Y<1:1,1:0)
 Q
