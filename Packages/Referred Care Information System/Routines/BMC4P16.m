BMC4P16 ;IHS/OIT/FCJ - BMC 4.0 PATCH 16 ; 16 Feb 2011  2:54 PM
 ;;4.0;REFERRED CARE INFO SYSTEM;**16**;JAN 09, 2006;Build 168
 ;
INSTALLD(BMC) ; Determine if patch BMC was installed, where BMC is
 ; the name of the INSTALL.  E.g "AVA*93.2*12".
 NEW DIC,X,Y
 ;  lookup package.
 S X=$P(BMC,"*",1)
 S DIC="^DIC(9.4,",DIC(0)="FM",D="C"
 D IX^DIC
 I Y<1 Q 0
 ;  lookup version.
 S DIC=DIC_+Y_",22,",X=$P(BMC,"*",2)
 D ^DIC
 I Y<1 Q 0
 ;  lookup patch.
 S DIC=DIC_+Y_",""PAH"",",X=$P(BMC,"*",3)
 D ^DIC
 Q $S(Y<1:0,1:1)
 ; -----------------------------------------------------
PRE ;EP - From KIDS.
 I $$NEWCP^XPDUTL("PRE1","AUDS^BMC4E")
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 Q
 ;
POST ;EP - From KIDS.
 ; --- Restore dd audit settings.
 S %="AUDR^BMC4E"
 I $$NEWCP^XPDUTL("POS1-"_%,%)
 ; ---Update Gen Ret
 S %="P14^BMC4P16"
 I $$NEWCP^XPDUTL("POS12-"_%,%)
 ; ---Update Site Parameter
 S %="P15^BMC4P16"
 I $$NEWCP^XPDUTL("POS13-"_%,%)
 ; ---Update Gen Ret file
 S %="P15G^BMC4P16"
 I $$NEWCP^XPDUTL("POS14-"_%,%)
 ; ---Update new "CA" index
 S %="P15INDX^BMC4P16"
 I $$NEWCP^XPDUTL("POS15-"_%,%)
 ; ---Update new Business Office menu option
 S %="P15MENU^BMC4P16"
 I $$NEWCP^XPDUTL("POS16-"_%,%)
 ; ---Update Gen Ret File
 S %="P16G1^BMC4P16"
 I $$NEWCP^XPDUTL("POS17-"_%,%)
 ; ---Update Med Priority file and pointer field
 S %="P16MP^BMC4P16"
 I $$NEWCP^XPDUTL("POS18-"_%,%)
 ; ---Remove Med Priority help text for Fed sites
 S %="P16MPHLP^BMC4P16"
 I $$NEWCP^XPDUTL("POS19-"_%,%)
 ; ---ADD NEW APT LETTER MENU OPTION
 S %="P16MENU^BMC4P16"
 I $$NEWCP^XPDUTL("POS20-"_%,%)
 ; ---ADD RPC CALL
 S %="P16RPC^BMC4P16"
 I $$NEWCP^XPDUTL("POS21-"_%,%)
 ; ---UPDATE PATCHES NOT INSTALLED
 S %="HIST^BMC4P16"
 I $$NEWCP^XPDUTL("POS22-"_%,%)
 ; --- Send mail message of install.
 S %="MAIL^BMC4E"
 I $$NEWCP^XPDUTL("POS23-"_%,%)
 Q
 ;
P14 ;Patch 14
 S BMC="BMC*4.0*14" Q:$$INSTALLD(BMC)
 ;update GEN RET option CHS Dt PO Added
 NEW DA,DIE,DIC,DR
 S X="CHS Dt PO Added",(DIC,DIE)="^BMCTSORT("
 D ^DIC
 I +Y<0 D BMES^XPDUTL("Unable to update CHS Dt PO Added item from Gen Ret Report list . . .") K DIC,DIE,X Q
 S DA=+Y
 S DR="3////"_"F  S BMCX=$O(^BMCREF(BMCREF,41,BMCX)) Q:BMCX'=+BMCX  S BMCPCNT=BMCPCNT+1,BMCDT=$P($G(^BMCREF(BMCREF,41,BMCX,11)),U,2)"
 S DR=DR_" Q:BMCDT'?1N.N  S Y=BMCDT D DT^BMCRUTL S BMCDT=Y,BMCPRNM(BMCPCNT)=BMCDT"
 D ^DIE
 D BMES^XPDUTL("CHS Dt PO Added item updated in Gen Ret items . . .")
 K DA,DIE,DIC,DR
 Q
P15 ;Patch 15
 S BMC="BMC*4.0*15" Q:$$INSTALLD(BMC)
 ;Update new FY and referral number fields in Parameter file
 NEW DA,DIE,DIC,DR,BMCF
 ;SORT THROUGH REFERRAL INDEX, GET LAST REF NUMBER FOR THE FY
 S BMC=0
 F  S BMC=$O(^BMCPARM(BMC)) Q:BMC'?1N.N  D
 .S BMCTMP("C",BMC)=$P($G(^AUTTLOC(BMC,0)),U,10)
 S BMCRNUM=0,BMCFY="",CT=0
 F  S BMCRNUM=$O(^BMCREF("C",BMCRNUM)) Q:BMCRNUM'?1N.N  D
 .S CT=CT+1,BMCRFY=+$E(BMCRNUM,7,8)
 .I CT=1 S BMCFY=BMCRFY,BMC=$E(BMCRNUM,1,6)
 .I BMC=$E(BMCRNUM,1,6),BMCRFY=BMCFY D P15S Q
 .I BMC=$E(BMCRNUM,1,6),BMCRFY'=BMCFY S CT=1,BMCFY=BMCRFY D P15S Q
 .I BMC'=$E(BMCRNUM,1,6) S CT=1,BMCFY=BMCRFY,BMC=$E(BMCRNUM,1,6) D P15S Q
 ;
P15SFY ;SET THE MULTIPLE WITH FY AND COUNTS
 S BMCPT=0
 F  S BMCPT=$O(BMCTMP("C",BMCPT)) Q:BMCPT'?1N.N  D
 .S BMC=BMCTMP("C",BMCPT)
 .S BMCFY=0
 .F  S BMCFY=$O(BMCTMP(BMC,BMCFY)) Q:BMCFY'?1N.N  D
 ..S BMCRNUM=+($E($P(BMCTMP(BMC,BMCFY),U,3),9,13))
 ..S DIC("P")=$P(^DD(90001.31,3,0),U,2)
 ..S DIC(0)="L",DLAYGO=90001.31,DIC="^BMCPARM("_BMCPT_",3,",DA(1)=BMCPT,(X,DA)=BMCFY
 ..S DIC("DR")=".02////"_BMCRNUM D DIC^BMCFMC
 Q
P15S ;
 S BMCTMP(BMC,BMCFY)=BMCFY_"^"_CT_"^"_BMCRNUM
 Q
P15G ;Add/update GEN RET options
 ;UPDATE GEN RET Option for CHS PO Type
 S BMC="BMC*4.0*15" Q:$$INSTALLD(BMC)
 NEW DA,DIE,DIC,DR
 S X="CHS PO Type",(DIC,DIE)="^BMCTSORT("
 S DIC(0)="L" D ^DIC
 I +Y<0 D BMES^XPDUTL("Unable to add CHS PO Type item to General Retrieval Report list . . .") G P15G1
 S DA=+Y
 S DR=".02////R;.04////9002080.01,3;.05////PSR;.06////TYPE;.07////4;.08////1;.09////99.7;.11////R;.12////CHS PO TYPE;.14////1"
 D ^DIE
 S DR="1////S Y=0 F  S Y=$O(^BMCREF(BMCREF,41,Y)) Q:Y'=+Y  S Y1=$P(^BMCREF(BMCREF,0),U,5) I $D(^ACHSF(Y1,""D"",Y,0)) S X($P(^ACHSF(Y1,""D"",Y,0),U,4))="""
 D ^DIE
 S DR="3////S DA=0 F  S DA=$O(^BMCREF(BMCREF,41,DA)) Q:DA'=+DA  S DA(1)=$P(^BMCREF(BMCREF,0),U,5) I $D(^ACHSF(DA(1),""D"",DA,0)) S BMCPCNT=BMCPCNT+1,"
 S DR=DR_"BMCPRNM(BMCPCNT)=$E($TR($$VAL^XBDIQ1(9002080.01,.DA,3),""()"",""""),1,2)"
 D ^DIE
 S DR="4////S Y=0 F  S Y=$O(^BMCREF(BMCREF,41,Y)) Q:Y'=+Y  S Y1=$P(^BMCREF(BMCREF,0),U,5) I $D(^ACHSF(Y1,""D"",Y,0)) S BMCPRNT=$P(^ACHSF(Y1,""D"",Y,0),U,4)"
 D ^DIE
 D BMES^XPDUTL("CHS PO Type item added to General Retrieval items . . .")
 K DA,DIE,DIC,DR
P15G1 ;
 ;UPDATE GEN RET Option for SSN
 S X="SSN",(DIC,DIE)="^BMCTSORT("
 D ^DIC
 I +Y<0 D BMES^XPDUTL("Unable to edit SSN item in General Retrieval Report list . . .") G P15G2
 S DA=+Y
 S DR=".04////@;.05////@;.06////@;.07////@;.09////@;.11////@;.14////@;1////@;3////@;4////@"
 D ^DIE
 K DR,DA
P15G2 ;
 ;UPDATE THE CHS PO TYPE ENTRY
 S X="CHS PO Type"
 D ^DIC
 S DA=+Y
 S ^BMCTSORT(DA,1)="S Y=0 F  S Y=$O(^BMCREF(BMCREF,41,Y)) Q:Y'=+Y  S Y1=$P(^BMCREF(BMCREF,0),U,5) I $D(^ACHSF(Y1,""D"",Y,0)) S X($P(^ACHSF(Y1,""D"",Y,0),U,4))="""""
 Q
P15INDX ;NEW INDEX FOR DATE LAST MODIFIED
 S BMC="BMC*4.0*15" Q:$$INSTALLD(BMC)
 N DA,DIK,X
 D BMES^XPDUTL("Reindexing DATE LAST MODIFIED.")
 S DIK="^BMCREF("
 S DIK(1)=".27^CA"
 D ENALL^DIK
 Q
P15MENU ;update menu option to syn for changing BO notes to Referral notes
 S BMC="BMC*4.0*15" Q:$$INSTALLD(BMC)
 D BMES^XPDUTL("Begin updating Business Office Menu Option change to Referral Notes Option.")
 I $$ADD^XPDMENU("BMC MENU EDIT REFERRAL","BMC BUSINESS OFFICE COMMENTS","RFN")
 I $$ADD^XPDMENU("BMC MENU SPECIAL","BMC BUSINESS OFFICE COMMENTS","RFN")
 D MES^XPDUTL("END updating option.")
 Q
P16G1 ;GEN RET UPDATE
 ;S BMC="BMC*4.0*16" Q:$$INSTALLD(BMC)
 S X="Actual IHS Cost",(DIC,DIE)="^BMCTSORT("
 D ^DIC
 I +Y<0 D BMES^XPDUTL("Unable to update Actual IHS Cost item from Gen Ret Report list . . .") G P16G2
 S DA=+Y
 S DR="6////"_"Actual IHS Cost"
 D ^DIE
 D BMES^XPDUTL("Actual IHS Cost Column Header updated in Gen Ret items . . .")
P16G2 ;GEN RET-SNOMED
 K DA,DIE,DIC,DR
 S X="Snomed Term",(DIC,DIE)="^BMCTSORT("
 S DIC(0)="L" D ^DIC
 I +Y<0 D BMES^XPDUTL("Unable to Add Snomed Term item from Gen Ret Report list . . .") Q
 S DA=+Y
 S DR=".02////S;.04////9000010.59,.01;.05////PS;.06////SNOMED Term;.07////40;.08////0;.09////980;.11////R;.12////SNOMED Term;.14////1"
 D ^DIE
 S DR="1////S:$P($G(^BMCREF(BMCREF,13)),U,3)'="""" X=$P($G(^AUPNVREF($P($G(^BMCREF(BMCREF,13)),U,3),0)),U)"
 D ^DIE
 S DR="3////D SNO^BMCRLP1"
 D ^DIE
 S DR="4////S DA=BMCREF D DIQ^BMCRLP"
 D ^DIE
 D BMES^XPDUTL("Snomed Term added in Gen Ret items . . .")
 K DA,DIE,DIC,DR
 Q
P16MP ;UPDATE RCIS PRIORITY FILE WITH CURRENT ENTRIES
 S BMC="BMC*4.0*16" Q:$$INSTALLD(BMC)
 N BMCRIEN,MPIEN,MPRI
 K ^XTMP("BMCP16",$J,"MEDPR")
 D BMES^XPDUTL("Updating Medical Priority field . . .")
 S BMCRIEN=0 F  S BMCRIEN=$O(^BMCREF(BMCRIEN)) Q:BMCRIEN'?1N.N  D
 .Q:$P($G(^BMCREF(BMCRIEN,0)),U,32)=""
 .S ^XTMP("BMCP16",$J,"MEDPR",$P(^BMCREF(BMCRIEN,0),U,32))=""
 ;UPDATE MED PRI FILE
 S MPIEN=17,X="" F  S X=$O(^XTMP("BMCP16",$J,"MEDPR",X)) Q:X=""  D
 .Q:$D(^BMCMPRI("B",X))
 .S ^BMCMPRI(MPIEN,0)=X_U_DT,^BMCMPRI("B",X,MPIEN)="",$P(^BMCMPRI(0),U,3,4)=MPIEN_U_MPIEN
 .S MPIEN=MPIEN+1
 ;
P16MPUP ;UPDATE MED PRI IN RCIS REF FILE
 S BMCRIEN=0 F  S BMCRIEN=$O(^BMCREF(BMCRIEN)) Q:BMCRIEN'?1N.N  S MPIEN="" D
 .Q:$P($G(^BMCREF(BMCRIEN,0)),U,32)=""
 .S MPRI=$P(^BMCREF(BMCRIEN,0),U,32)
 .I $D(^BMCMPRI("B",MPRI)) S MPIEN=$O(^BMCMPRI("B",MPRI,MPIEN))
 .S $P(^BMCREF(BMCRIEN,0),U,32)=MPIEN
 D BMES^XPDUTL("Finished Updating Medical Priority field . . .")
 K ^TMP("BMCP16",$J,"MEDPR")
 Q
P16MPHLP ;REMOVE MED PRI HELP TEXT FOR FED SITES
 S BMC="BMC*4.0*16" Q:$$INSTALLD(BMC)
 N BMC,DA,DR,DIE
 D BMES^XPDUTL("Removing Medical Priority Help text . . .")
 S BMC=0 F  S BMC=$O(^BMCPARM(BMC)) Q:BMC'?1N.N  D
 .I $P(^AUTTLOC(BMC,0),U,25)'=1 Q
 .S DIE="^BMCPARM(",DA=BMC,DR="1///@"
 .D ^DIE
 Q
P16MENU ;Add menu option Appointment Letter
 S BMC="BMC*4.0*16" Q:$$INSTALLD(BMC)
 D BMES^XPDUTL("Adding New Appointment Menu Option to Print RCIS Letter Types.")
 I $$ADD^XPDMENU("BMC MENU LETTERS","BMC PRINT APT LETTER","PAPT")
 Q
P16RPC ;Add RPC-BMC ACKNOWLEDGE DT UPDATE
 N DA,DIE,DIC,DR
 Q:$D(^XWB(8994,"B","BMC ACKNOWLEDGE DT UPDATE"))
 S X="BMC ACKNOWLEDGE DT UPDATE",(DIC,DIE)="^XWB(8994,"
 S DIC(0)="L" D ^DIC
 I +Y<0 D BMES^XPDUTL("Unable to Add RPC-BMC ACKNOWLEDGE DT UPDATE . . .") Q
 S DA=+Y
 S DR=".02////SETACKDT;.03////BMCRPC5;.04////1;.05////P"
 D ^DIE
 K DA,DIE,DIC,DR
 S DA(1)=0
 S DA(1)=$O(^DIC(19,"B","CIANB MAIN MENU",DA(1)))
 I 'DA(1) D BMES^XPDUTL("Missing CIA BROKER MAIN Menu, unable to Add RPC-BMC ACKNOWLEDGE DT UPDATE to Option . . .") Q
 S X="BMC ACKNOWLEDGE DT UPDATE",(DIC,DIE)="^DIC(19,"_DA(1)_",""RPC"","
 S DIC(0)="L" D ^DIC
 I +Y<0 D BMES^XPDUTL D BMES^XPDUTL("CIA BROKER MAIN Menu, Unable to Add RPC-BMC ACKNOWLEDGE DT UPDATE to Option . . .")
 Q
HIST ;PATCH HISTORY UPDATE
 N PKGNM,PKGIEN,I,TEXT,DATA,VERSION,PATCH,VSB,CT,DDLM,DLM,TAG,FDA
 S CT=0
 S DDLM=";;",DLM="|",TAG="BMC"
 S PKGNM="REFERRED CARE INFO SYSTEM"
 I '$D(^DIC(9.4,"B",PKGNM)) D MES^XPDUTL("Problem with package name.") Q
 S PKGIEN=$O(^DIC(9.4,"B",PKGNM,0))
 F I=1:1  D  Q:TEXT["END"
 .S TEXT=$T(@TAG+I) Q:TEXT["END"
 .S DATA=$P(TEXT,DDLM,2)
 .S VERSION=$P(DATA,DLM,2),PATCH=$P(DATA,DLM,3)
 .S VSB=$O(^DIC(9.4,PKGIEN,22,"B",VERSION,0))
 .Q:'VSB
 .K FDA
 .; Do not update if the patch is already in the patch history
 .Q:$D(^DIC(9.4,PKGIEN,22,VSB,"PAH","B",PATCH))
 .S FDA(9.4901,"+1,"_VSB_","_PKGIEN_",",.01)=$G(PATCH)
 .S FDA(9.4901,"+1,"_VSB_","_PKGIEN_",",.02)=DT
 .S FDA(9.4901,"+1,"_VSB_","_PKGIEN_",",.03)=DUZ
 .D UPDATE^DIE(,"FDA")
 .D:$G(DIERR)'="" MES^XPDUTL("Error adding patch "_PATCH_" to package file.")
 .S CT=CT+1
 D:CT>0 MES^XPDUTL("Completed adding patches to package file.")
 Q
 ;;;;FORMAT - Package name|Version|Patch|Sequence
BMC ;
 ;;REFERRED CARE INFO SYSTEM|4.0|14
 ;;REFERRED CARE INFO SYSTEM|4.0|15
 ;END
