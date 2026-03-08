ACPT210A ;IHS/SD/RNB - ACPT 2.11 ; 10 Nov 2010 08:47 AM
 ;;2.11;CPT FILES;**1**;JAN 03, 2011
 ;
PRE ;
CLEANALL ;Remove Control Characters from ^ICPT
 ;
 D BMES^XPDUTL($$T("MSG+9")) ;
 D MES^XPDUTL($$T("MSG+8")) W ! ; Removing control character from your ...
 ;
 K ^TMP("ACPT",$J) ; clear scratch space
 ;
 S ACPTNAME="^ICPT" ; the name value of each node of ^ICPT
 S ACPTCNTC=0 ; how many nodes had control characters
 S ACPTCNTN=0 ; how many node names had control characters
 ;
 F ACPTCNT=1:1 D  S ACPTNAME=$Q(@ACPTNAME) Q:ACPTNAME=""
 .;
 .I '(ACPTCNT#1000) W "." ; indicate progress
 .S ACPTVALU=$G(@ACPTNAME) ; fetch value of node
 .S ACPTBADN=ACPTNAME?.E1C.E ; is it a bad name
 .S ACPTBADV=ACPTVALU?.E1C.E ; is it a bad value
 .;[RNB] Add next 2 lines
 .K ACPTX F ACPTX=1:1:$L(ACPTNAME) S ACPTY=$E(ACPTNAME,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTBADN=1 Q
 .K ACPTX F ACPTX=1:1:$L(ACPTVALU) S ACPTY=$E(ACPTVALU,ACPTX) I ($A(ACPTY)<32)!($A(ACPTY)>126) S ACPTBADV=1 Q
 .Q:'ACPTBADN&'ACPTBADV  ; skip good nodes
 .;
 .; for output, show where control characters were
 .S ACPTMAPN=ACPTNAME
 .S ACPTMAPV=ACPTVALU
 .;
 .S ACPTCLN=ACPTNAME ; save cleaned up name in ACPTCLN
 .I ACPTBADN D  ; if the node name contains a control character
 ..S ACPTCNTC=ACPTCNTC+1,ACPTCNTN=ACPTCNTN+1 ; add to both counts
 ..;[RNB] W ACPTCNT,$C(7),": bad name" ; note presence of control chars
 ..W !,ACPTCNT,$C(7),": bad name: " ; note presence of control chars
 ..D CLEAN(.ACPTCLN,.ACPTMAPN,1) ; strip out the control characters
 .;
 .I ACPTBADV D  ; if the node value contains a control character
 ..S ACPTCNTC=ACPTCNTC+1 ; add to our count of instances
 ..;[RNB] W ACPTCNT,$C(7),": bad value" ; note presence of control chars
 ..W !,ACPTCNT,$C(7),": bad value: " ; note presence of control chars
 ..D CLEAN(.ACPTVALU,.ACPTMAPV,0) ; strip out the control characters
 .;
 .D MES^XPDUTL(ACPTMAPN_"="_ACPTMAPV_"...") W ! ; show the problem (safely)
 .;
 .I ACPTBADV,'ACPTBADN S @ACPTNAME=ACPTVALU Q  ; good name but bad value
 .;
 .; what we wish we could do here is just kill the node and replace it
 .; but we would need the Millennium standard's KVALUE, which can kill
 .; just a node. We are stuck with KILL, which kills the entire tree
 .; and so would interfere with nodes we have not yet scanned and saved
 .; off. So, we have to separate the killing from the scanning & saving.
 .; For now we copy our cleaned up names and values out to ^TMP.
 .S ACPTEMP=ACPTCLN ; change name from ^ICPT(*)
 .;S $E(ACPTEMP,1,9)="^TMP(""ACPT"","_$J_"," ; to ^TMP("ACPT",$J,*)
 .S $E(ACPTEMP,1,6)="^TMP(""ACPT"","_$J_"," ; to ^TMP("ACPT",$J,*)
 .;IHS/OIT/CLS 09/17/2008 change to equal length of global root ^ICPT(
 .;
 .; W ACPTCLN,"  ==>  ",ACPTEMP ; debugging code
 .S @ACPTEMP=ACPTVALU ; save off the cleaned up node to ^TMP
 .S @ACPTEMP@(U)=ACPTNAME ; save off bad name with ctl chars
 ;
 I ACPTCNTN D BMES^XPDUTL($$T("MSG+7")) ; Replacing the bad node ...
 ;
 S ACPTNAME=$NA(^TMP("ACPT",$J)) ; now we will traverse our saved nodes
 S ACPTLENG=$L(ACPTNAME) ; get the length of the prefix
 S ACPTPRE=$E(ACPTNAME,1,ACPTLENG-1) ; & grab that prefix
 ; walk ^TMP("ACPT",$J), exit when name no longer starts with prefix
 F  S ACPTNAME=$Q(@ACPTNAME) Q:$P(ACPTNAME,ACPTPRE)'=""!(ACPTNAME="")  D
 .N ICPT S ICPT=ACPTNAME,$E(ICPT,1,ACPTLENG)="^ICPT(" ; change back
 .K @(@ACPTNAME@(U)) ; delete node in ^ICPT whose bad name we saved off
 .N ACPTVALU S ACPTVALU=@ACPTNAME ; get the saved, clean value
 .S @ICPT=ACPTVALU ; copy cleaned up node back into ^ICPT
 .N ACPTSUB S ACPTSUB=$QS(ACPTNAME,3) ; get the main subscript
 .K @ACPTNAME@(U) ; delete the saved node name to avoid it
 .D MES^XPDUTL(ICPT_"="_ACPTVALU) ; report nodes as we copy them back
 K ^TMP("ACPT",$J) ; clean up rest of temp space
 ;
 D BMES^XPDUTL(ACPTCNT-1_$$T("MSG+1")) ; # nodes in ^ICPT were scanned.
 D MES^XPDUTL(ACPTCNTC_$$T("MSG+2")) ; # instances of control charact...
 ; # of them from node names, # from values.
 D MES^XPDUTL(ACPTCNTN_$$T("MSG+3")_(ACPTCNTC-ACPTCNTN)_$$T("MSG+4"))
 ; Your ^ICPT global is [now] free of control characters.
 D BMES^XPDUTL($$T("MSG+5")_$S(ACPTCNTC:"now ",1:"")_$$T("MSG+6"))
 ;
 Q
T(TAG) QUIT $P($T(@TAG),";;",2)
 ;
 ;
MSG ; messages to display
 ;; nodes in ^ICPT were scanned.
 ;; instances of control characters were found and removed,
 ;; of them from node names, 
 ;; from values.
 ;;Your ^ICPT global is 
 ;;free of control characters.
 ;;Replacing the bad node names found in ^ICPT
 ;;Removing control characters from your ^ICPT global...
 ;;ACPT 2.11 PRE-INIT
 ;
CLEAN(ACPTSTR,ACPTMAP,ACPTNAME) ; private, strip ctl chars out of a string
 ;
 ; .ACPTSTR = input & output: string to clear of control characters
 ; .ACPTMAP = output: display version of AUMSTR
 ; ACPTNAME = 1 if this is a name, else 0, affects quotation marks
 ;
 ; code useful another time, but not here
 ; N ACPTCHAR
 ; S ACPTCHAR=$C(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21)
 ; S ACPTCHAR=ACPTCHAR_$C(22,23,24,25,26,27,28,29,30,31,127)
 ; S ACPTSTR=$TR(ACPTSTR,ACPTCHAR) ; strip out standard ASCII ctl chars
 ;
 ; traverse loop backward so our insertions do not throw off our position
 ; within ACPTMAP. Replacing one control character with _$C(#)_ expands
 ; the value of ACPTMAP, shifting all the character positions & throwing
 ; off its positional mapping to ACPTSTR; we work from the end of the
 ; string forward so that the loss of correspondence happens in the part
 ; of ACPTMAP we have already looked at.
 ;
 S ACPTNAME=+$G(ACPTNAME) ; default to not a name
 S ACPTMAP=ACPTSTR ; create copy to highlight the control characters
 N ACPTPOS ; each position
 ;[RNB] F ACPTPOS=$L(ACPTSTR):-1:1 D:$E(ACPTSTR,ACPTPOS)?1C ; for each ctl char
 F ACPTPOS=$L(ACPTSTR):-1:1 D:($A($E(ACPTSTR,ACPTPOS))<32)!($A($E(ACPTSTR,ACPTPOS))>126)  ; per control chara
 .N ACPTCHAR S ACPTCHAR=$E(ACPTSTR,ACPTPOS) ; copy it
 .N ACPTASCI S ACPTASCI=$A(ACPTCHAR) ; get its ASCII code
 .; replace control chars that have standard ASCII equivalents
 .N ACPTREPL
 .S ACPTREPL=$TR(ACPTCHAR,$C(28,145,146,147,148,150,151),"C''""""--")
 .I ACPTNAME,ACPTASCI=147!(ACPTASCI=148) S ACPTREPL="""""" ; dbl for nm
 .; I ACPTASCI=153 S ACPTREPL="(TM)" ; cutting legal text
 .;[RNB]I ACPTREPL?1C S ACPTREPL="" ; if no replacement, delete it
 .I ($A($E(ACPTSTR,ACPTPOS))<32)!($A($E(ACPTSTR,ACPTPOS))>126) S ACPTREPL=""
 .S $E(ACPTSTR,ACPTPOS)=ACPTREPL ; replace the ctl char
 .S $E(ACPTMAP,ACPTPOS)="_$C("_ACPTASCI_")_" ; highlight it in ACPTMAP
 Q
 ;
 ;
IMPORT ; Import CPTs from AMA files
 ;
 I $$VERSION^XPDUTL("BCSV")>0 D  Q  ;load 2011 for CSV environment
 .;
 .S ACPTYR=3110101
 .;INACTIVATE ALL CODES
 .D INACT
 .D BMES^XPDUTL("CPT 2011 Install (CPT v2.11)")
 .D MES^XPDUTL("The install will also attempt to read the 2011 CPT Long Description file")
 .D MES^XPDUTL("acpt2011.01l from the directory you specified")
 .D MES^XPDUTL("The install will also attempt to read the 2011 CPT Short Description file")
 .D MES^XPDUTL("acpt2011.01s from the directory you specified")
 .;[RNB] Add next two lines for HCPCS
 .D MES^XPDUTL("The install will attempt to read the 2011 HCPCS file")
 .D MES^XPDUTL("acpt2011.01h from the directory you specified")
 .;
 .;Get the directory containing the two files
 .S ACPTPTH=$G(XPDQUES("POST1")) ; path to files
 .I ACPTPTH="" D  ; for testing at programmer mode
 ..S ACPTPTH=$G(^XTV(8989.3,1,"DEV")) ; default directory
 ..D POST1^ACPTENVC(.ACPTPTH) ; input transform
 .;
 .S ACPTYR=3110101
 .; Installing 2011 CPTs from file acpt2011.01l
 .D BMES^XPDUTL("Loading 2011 CPTs from file acpt2011.01l")
 .D IMPCPT^ACPT21NL  ;all codes (adds/edits/deletes) BCSV environment
 .K ^TMP("ACPT-IMP",$J),^TMP("ACPT-CPTS",$J),^TMP("ACPT-CNT",$J)
 .;[RNB] Add next line to call to process HCPCS
 .D CPTCAT
 .D HCPCS10
 .;[RNB] Add next line to call tag to reactivate the cpt 00099 code
 .D CPT00099
 .Q
 ;
 I $$VERSION^XPDUTL("BCSV")<1 D  ;load 2011 codes NON-BCSV environment
 .;
 .S ACPTYR=3110101
 .;INACTIVATE ALL CODES
 .D INACT
 .D BMES^XPDUTL("CPT 2011 Install (CPT v2.11)")
 .D MES^XPDUTL("The install will attempt to read the 2011 CPT Description file")
 .D MES^XPDUTL("acpt2011.01l from the directory you specified")
 .D MES^XPDUTL("The install will also attempt to read the 2011 CPT Short Description file")
 .D MES^XPDUTL("acpt2011.01s from the directory you specified")
 .;[RNB] Add next two lines for HCPCS
 .D MES^XPDUTL("The install will attempt to read the 2011 HCPCS file")
 .D MES^XPDUTL("acpt2011.01h from the directory you specified")
 .;
 .;Get the directory containing the two files
 .S ACPTPTH=$G(XPDQUES("POST1")) ; path to files
 .I ACPTPTH="" D  ; for testing at programmer mode
 ..S ACPTPTH=$G(^XTV(8989.3,1,"DEV")) ; default directory
 ..D POST1^ACPTENVC(.ACPTPTH) ; input transform
 .;
 .; Installing 2011 CPTs from file acpt2011.01l
 .D BMES^XPDUTL("Loading 2011 CPTs from file acpt2011.01l")
 .D IMPORT^ACPT210L  ;all codes (adds/edits/deletes)
 .K ^TMP("ACPT-IMP",$J),^TMP("ACPT-CPTS",$J),^TMP("ACPT-CNT",$J)
 .K ^TMP("ACPT-DEL",$J),^TMP("ACPT-DCNT",$J)
 .;[RNB] Add next two lines make a call to CPTCAT tag vs drop through and then call to process HCPCS
 .;now populate CPT category for all codes not populated 
 .D CPTCAT
 .D HCPCS10
 Q
CPT00099 ;
 D ^XBFMK
 S DIE="^ACPT("
 S DA=99
 S DR="5////@;7////@"
 D ^DIE
 ;
 D ^XBFMK
 S DA(1)=99 ; into subfile under new entry
 S DIC="^ICPT("_DA(1)_",60," ; Effective Date (60/81.02)
 S DIC(0)="L" ; LAYGO
 S DIC("P")=$P(^DD(81,60,0),U,2) ; subfile # & specifier codes
 S X="01/01/1970"
 S DIC("DR")=".02////1" ; with Status = 1 (active)
 N DLAYGO,Y,DTOUT,DUOUT ; other parameters
 D ^DIC ; Fileman LAYGO lookup
 Q
CPTCAT ;
 ;[RNB] display message that the CPT category update
 D BMES^XPDUTL("Now populate CPT category for all codes not populated")
 S ACPTI=0
 F  S ACPTI=$O(^ICPT(ACPTI)) Q:'ACPTI  D
 .Q:$P($G(^ICPT(ACPTI,0)),U,3)'=""
 .S ACPTBFR=0,ACPTAFT=999999
 .S ACPTBFR=+$O(^DIC(81.1,"ACPT",ACPTI),-1)
 .S ACPTAFT=+$O(^DIC(81.1,"ACPT",ACPTI))
 .Q:ACPTBFR=0
 .I ACPTBFR<ACPTI<ACPTAFT D
 ..K DIC,DIE,DA,DR,X,Y
 ..S DIE="^ICPT("
 ..S DA=ACPTI
 ..S DR="3////"_$O(^DIC(81.1,"ACPT",ACPTBFR,0))
 ..D ^DIE
 Q
 ;[RNB] process the HCPCS codes
HCPCS10 ;
 ; Installing 2011 CPTs from file acpt2011.01h
 D BMES^XPDUTL("Loading 2011 HCPCSs from file acpt2011.01h")
 I $$VERSION^XPDUTL("BCSV")<1 D IMPORT^ACPT2101  ;(non-CSV) all codes (adds/edits/deletes)
 I $$VERSION^XPDUTL("BCSV")>0 D IMPHCPCS^ACPT2102  ;(CSV) all codes (adds/edits/deletes)
 ;
 ; Reindexing CPT file (81); this will take awhile.
 D BMES^XPDUTL("Reindexing CPT file (81); this will take awhile.")
 N DA,DIK S DIK="^ICPT(" ; CPT file's global root
 D IXALL^DIK ; set all cross-references for all records
 D ^ACPTCXR ; rebuild C index for all records
 ;
 ; Reindexing CPT Modifier file (9999999.88).
 D BMES^XPDUTL("Reindexing CPT Modifier file (9999999.88)")
 S DIK="^AUTTCMOD(" ; MODIFIER file's global root
 D IXALL^DIK ; set all cross-references for all records
 Q
INACT ;
 D BMES^XPDUTL("Inactivating codes - Started")
 D ^ACPT21XL  ; Inactivate all codes
 D BMES^XPDUTL("Inactivating codes - Completed")
 Q
