ACPT213 ;IHS/OIT/NKD - ACPT V2.13 CPT ENVIRONMENT CHECKER 12/19/12 ;
 ;;2.13;CPT FILES;**1,2**;DEC 19, 2012;Build 1
 ; 2/6/13 - ACPT*2.13*1 - CHECK FOR TRANSPORT GLOBAL AND KILL TRANSPORT GLOBAL AFTER POST-INSTALL
 ;                      - PRE-REQS AND ADDED HCPCS CONSISTENCY REPORT
 ; 07/03/13 - ACPT*2.13*2 - MODIFIED DISPLAY FOR INCREMENTAL UPDATES
 ;                        - PRE-REQS AND CPT CATEGORY UPDATE
 ;                        - ADD DEFAULT CPT RANGE TO MODIFIERS WITH BLANK RANGES
 ;
 I '$G(DUZ) W !,"DUZ UNDEFINED OR 0." D SORRY(2) Q
 ;
 I '$L($G(DUZ(0))) W !,"DUZ(0) UNDEFINED OR NULL." D SORRY(2) Q
 ;
 S X=$P(^VA(200,DUZ,0),U)
 W !!,$$CJ^XLFSTR("Hello, "_$P(X,",",2)_" "_$P(X,","),IOM)
 ;W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_$P($T(+2),";",3)_$S($L($P($T(+2),";",5))>4:" Patch "_$P($T(+2),";",5),1:"")_".",IOM),!
 ; IHS/OIT/NKD ACPT*2.13*2 MODIFIED DISPLAY FOR INCREMENTAL UPDATES - START NEW CODE
 N ACPTV,ACPTP
 S ACPTV=$P($T(+2),";",3),ACPTP=$P($T(+2),";",5),ACPTP=$S($L(ACPTP)>4:$P(ACPTP,"**",2),1:""),ACPTP=$S(ACPTP]"":$P(ACPTP,",",$L(ACPTP,",")),1:"")
 W !!,$$CJ^XLFSTR("Checking Environment for "_$P($T(+2),";",4)_" V "_ACPTV_$S(ACPTP]"":" Patch "_ACPTP,1:"")_".",IOM),!
 ; IHS/OIT/NKD ACPT*2.13*2 END NEW CODE
 ;
 S XPDQUIT=0,ACPTQUIT=0
 I '$$VCHK("XU","8",2)
 I '$$VCHK("XT","7.3",2)
 I '$$VCHK("DI","22",2)
 ;I '$$VCHK("ACPT","2.13",2)
 I ('$$VCHK2("ACPT","2.13.1",2))
 I ('$$VCHK2("BCSV","1.0.3",2))
 ; IHS/OIT/NKD ACPT*2.13*1 - CHECK FOR TRANSPORT GLOBAL
 I '$D(^ACPT) D
 . K DIFQ  ;IHS/OIT/NKD ACPT*2.13*2
 . S XPDQUIT=2
 . W !,$$CJ^XLFSTR("Transport global not installed!",IOM)
 . W *7,!,$$CJ^XLFSTR("^^^^**NEEDS TO BE FIXED**^^^^",IOM)
 ;
 I XPDQUIT D SORRY(XPDQUIT) Q
 ;
 W !!,$$CJ^XLFSTR("ENVIRONMENT OK.",IOM)
 ;
 Q
 ;
PRE ; EP - PRE-INSTALL
 ; IF ANNUAL UPDATE, RUN PRE-INSTALL UTILITIES
 I $L($P($T(+2),";",5))<5 D
 . D CLEANALL
 . D REINDEX
 . D CPTCINA
 ; IHS/OIT/NKD ACPT*2.13*2 CPT CATEGORY CLEANUP - START NEW CODE
 D CATCLN^ACPT213C
 D CATRNDX^ACPT213C
 ; IHS/OIT/NKD ACPT*2.13*2 END NEW CODE
 Q
 ;
POST ; EP - POST-INSTALL
 N ACPTYR
 S ACPTYR="3130101"
 D UPDATE^ACPT213C ; IHS/OIT/NKD ACPT*2.13*2 - CPT CATEGORY UPDATE
 ; IF ANNUAL UPDATE, RUN POST-INSTALL THEN CONSISTENCY REPORT
 I $L($P($T(+2),";",5))<5 D
 . D UPDATE^ACPT213A
 . D CRPT
 E  D UPDATE^ACPT213I
 ;D HRPT ; IHS/OIT/NKD ACPT*2.13*1 - HCPCS CONSISTENCY REPORT
 D ASSIGN^ACPT213C ; IHS/OIT/NKD ACPT*2.13*2 - ASSIGN CPT CATEGORIES
 D CPTMOD^ACPT213U ; IHS/OIT/NKD ACPT*2.13*2 - ASSIGN CPT MODIFIER RANGES FOR EHR
 ;K ^ACPT(0),^ACPT("CPT"),^ACPT("HCPCS") ; IHS/OIT/NKD ACPT*2.13*1 - DELETE TRANSPORT GLOBAL AFTER UPDATE
 K ^ACPT(0),^ACPT("CPT"),^ACPT("HCPCS"),^ACPT("CAT") ; IHS/OIT/NKD ACPT*2.13*2
 Q
 ;
SORRY(X) ;
 KILL DIFQ
 S XPDQUIT=X
 W:'$D(ZTQUEUED) *7,!,$$CJ^XLFSTR("Sorry....",IOM),$$DIR^XBDIR("E","Press RETURN")
 Q
 ;
VCHK(ACPTPRE,ACPTVER,ACPTQUIT) ; Check versions needed.
 N ACPTV
 S ACPTV=$$VERSION^XPDUTL(ACPTPRE)
 W !,$$CJ^XLFSTR("Need at least "_ACPTPRE_" v "_ACPTVER_"....."_ACPTPRE_" v "_ACPTV_" Present",IOM)
 I ACPTV<ACPTVER K DIFQ S XPDQUIT=ACPTQUIT W *7,!,$$CJ^XLFSTR("^^^^**NEEDS FIXED**^^^^",IOM) Q 0  ;IHS/OIT/NKD ACPT*2.13*2
 Q 1
 ;
VCHK2(ACPTPRE,ACPTVER,ACPTQUIT) ; Check patch level
 N ACPTV
 S ACPTV=$$VERSION^XPDUTL(ACPTPRE)
 ;I $L(ACPTV)<1 S XPDQUIT=ACPTQUIT W !,$$CJ^XLFSTR("Need at least "_ACPTPRE_" v "_ACPTVER_"....."_ACPTPRE_" Not Installed",IOM),*7,!,$$CJ^XLFSTR("^^^^**NEEDS TO BE FIXED**^^^^",IOM) Q 1
 S PTCH=+$$LAST(ACPTPRE,ACPTV) S:PTCH=-1 DPTCH="" S:PTCH'=-1 DPTCH="."_PTCH
 W !,$$CJ^XLFSTR("Need at least "_ACPTPRE_" v "_ACPTVER_"....."_ACPTPRE_" v "_ACPTV_DPTCH_" Present",IOM)
 I (ACPTV<($P(ACPTVER,".",1,2))) K DIFQ S XPDQUIT=ACPTQUIT W *7,!,$$CJ^XLFSTR("^^^^**NEEDS TO BE FIXED**^^^^",IOM) Q 0  ;IHS/OIT/NKD ACPT*2.13*2
 I (ACPTV=$P(ACPTVER,".",1,2))&(PTCH<$P(ACPTVER,".",3)) K DIFQ S XPDQUIT=ACPTQUIT W *7,!,$$CJ^XLFSTR("^^^^**NEEDS TO BE FIXED**^^^^",IOM) Q 0  ;IHS/OIT/NKD ACPT*2.13*2
 Q 1
 ;
LAST(PKG,VER) ; Returns last patch applied for a Package, PATCH^DATE
 ;        Patch includes Seq # if Released
 N PKGIEN,VERIEN,LATEST,PATCH,SUBIEN
 I $G(VER)="" S VER=$$VERSION^XPDUTL(PKG) Q:'VER -1
 S PKGIEN=$O(^DIC(9.4,"C",PKG,"")) Q:'PKGIEN -1
 S VERIEN=$O(^DIC(9.4,PKGIEN,22,"B",VER,"")) Q:'VERIEN -1
 S LATEST=-1,PATCH=-1,SUBIEN=0
 F  S SUBIEN=$O(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN)) Q:SUBIEN'>0  D
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)>LATEST S LATEST=$P(^(0),U,2),PATCH=$P(^(0),U)
 . I $P(^DIC(9.4,PKGIEN,22,VERIEN,"PAH",SUBIEN,0),U,2)=LATEST,$P(^(0),U)>PATCH S PATCH=$P(^(0),U)
 Q PATCH_U_LATEST
 ;
CLEANALL ; Remove Control Characters from ^ICPT
 D MES^XPDUTL("Removing control characters from your ^ICPT global...") W !
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
 I ACPTCNTN D BMES^XPDUTL("Replacing the bad node names found in ^ICPT")
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
 D BMES^XPDUTL(ACPTCNT-1_" nodes in ^ICPT were scanned.")
 D MES^XPDUTL(ACPTCNTC_" instances of control characters were found and removed,")
 D MES^XPDUTL(ACPTCNTN_" of them from node names, "_(ACPTCNTC-ACPTCNTN)_" from values.")
 D BMES^XPDUTL("Your ^ICPT global is "_$S(ACPTCNTC:"now ",1:"")_"free of control characters.")
 ;
 Q
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
REINDEX ; COMPLETE RE-INDEX OF FILES 81 AND 81.3
 N IND,DA,DIK
 D BMES^XPDUTL("Reindexing CPT file (81); this will take awhile.")
 K DA,DIK
 F IND="ACT","ADS","AST","B","BA","C","D","E","F","I" K ^ICPT(IND)
 S DIK="^ICPT("
 D IXALL^DIK
 D BMES^XPDUTL("Reindexing CPT MODIFIER file (81.3); this will take awhile.")
 K DA,DIK
 F IND="ACT","ADS","AST","B","BA","C","D","M" K ^DIC(81.3,IND)
 S DIK="^DIC(81.3,"
 D IXALL^DIK
 Q
 ;
CPTCINA ; CORRECT IMPROPERLY INACTIVATED CPT CODES
 ; Examines the CPT file and inactivates any code that has an Active Date (8) < Inactive Date (7) without an Inactive Flag (5)
 D BMES^XPDUTL("Fixing improperly inactivated CPT codes")
 N ACPTC,ACPTI,ACPTRES,FDA
 S ACPTC=0,ACPTRES="" F  S ACPTC=$O(^ICPT("BA",ACPTC)) Q:ACPTC']""  D
 . Q:ACPTC="00099 "
 . S ACPTI=0 F  S ACPTI=$O(^ICPT("BA",ACPTC,ACPTI)) Q:ACPTI']""  D
 . . Q:'$D(^ICPT(ACPTI,0))
 . . Q:$P(^ICPT(ACPTI,0),U,4)=1
 . . Q:$P(^ICPT(ACPTI,0),U,7)']""
 . . Q:+$P(^ICPT(ACPTI,0),U,8)>+$P(^ICPT(ACPTI,0),U,7)
 . . K FDA
 . . S FDA(81,ACPTI_",",5)="1" ; Inactive Flag (5)
 . . D UPDATE^DIE(,"FDA",)
 . . S ACPTRES=ACPTRES_$E(ACPTC,1,$L(ACPTC)-1)_$J("",3)
 . . I $L(ACPTRES)>79 D MES^XPDUTL(ACPTRES) S ACPTRES=""
 I $L(ACPTRES)>0 D MES^XPDUTL(ACPTRES)
 Q
 ;
CRPT ; CPT CONSISTENCY REPORT
 D BMES^XPDUTL("The following reports will display possible local inconsistencies in the CPT file.")
 ; DISPLAY DUPLICATE ACTIVE CODES
 D BMES^XPDUTL("Report #1: Active duplicate CPT/HCPCS codes")
 N ACPTC,ACPTI,ACPTRES
 S ACPTC=0 F  S ACPTC=$O(^ICPT("BA",ACPTC)) Q:ACPTC']""  D
 . S ACPTI=0,ACPTRES="" F  S ACPTI=$O(^ICPT("BA",ACPTC,ACPTI)) Q:ACPTI']""  D
 . . Q:'$D(^ICPT(ACPTI,0))
 . . Q:$P(^ICPT(ACPTI,0),U,4)=1
 . . S ACPTRES=ACPTRES_ACPTI_U
 . S:$E(ACPTRES,$L(ACPTRES))=U ACPTRES=$E(ACPTRES,1,$L(ACPTRES)-1)
 . I $L(ACPTRES,U)>1 D MES^XPDUTL("CODE: "_ACPTC_$J("",4)_"IENS: "_ACPTRES)
 ; DISPLAY ACTIVE CODES NOT PRESENT IN ANNUAL CPT DATA FILE
 D BMES^XPDUTL("Report #2: Active CPT codes that are not present in the annual data file")
 N ACPTC,ACPTI,ACPTRES
 S ACPTI=0 F  S ACPTI=$O(^ACPT("CPT","C",ACPTI)) Q:'ACPTI  S ACPTC=$P(^ACPT("CPT","C",ACPTI),U,1)_" ",^ACPT("CPT","C","BA",ACPTC,ACPTI)=""
 S ACPTC=0,ACPTRES="" F  S ACPTC=$O(^ICPT("BA",ACPTC)) Q:ACPTC']""  D
 . Q:$D(^ACPT("CPT","C","BA",ACPTC))
 . S ACPTI=0 F  S ACPTI=$O(^ICPT("BA",ACPTC,ACPTI)) Q:ACPTI']""  D
 . . Q:'$D(^ICPT(ACPTI,0))
 . . Q:$P(^ICPT(ACPTI,0),U,4)=1
 . . Q:$P(^ICPT(ACPTI,0),U,6)'="C"
 . . S ACPTRES=ACPTRES_$E(ACPTC,1,$L(ACPTC)-1)_$J("",3)
 . . I $L(ACPTRES)>79 D MES^XPDUTL(ACPTRES) S ACPTRES=""
 I $L(ACPTRES)>0 D MES^XPDUTL(ACPTRES)
 Q
 ;
 ; IHS/OIT/NKD ACPT*2.13*1 - ADDED CONSISTENCY REPORT FOR HCPCS FULL UPDATE
HRPT ; HCPCS CONSISTENCY REPORT
 ; DISPLAY ACTIVE CODES NOT PRESENT IN ANNUAL HCPCS DATA FILE
 D BMES^XPDUTL("Report #1: Active HCPCS codes that are not present in the annual data file")
 N ACPTC,ACPTI,ACPTRES
 S ACPTI=0 F  S ACPTI=$O(^ACPT("HCPCS","A",ACPTI)) Q:'ACPTI  S ACPTC=$P(^ACPT("HCPCS","A",ACPTI),U,1)_" ",^ACPT("HCPCS","C","BA",ACPTC,ACPTI)=""
 S ACPTI=0 F  S ACPTI=$O(^ACPT("HCPCS","C",ACPTI)) Q:'ACPTI  S ACPTC=$P(^ACPT("HCPCS","C",ACPTI),U,1)_" ",^ACPT("HCPCS","C","BA",ACPTC,ACPTI)=""
 S ACPTC=0,ACPTRES="" F  S ACPTC=$O(^ICPT("BA",ACPTC)) Q:ACPTC']""  D
 . Q:$D(^ACPT("HCPCS","C","BA",ACPTC))
 . S ACPTI=0 F  S ACPTI=$O(^ICPT("BA",ACPTC,ACPTI)) Q:ACPTI']""  D
 . . Q:'$D(^ICPT(ACPTI,0))
 . . Q:$P(^ICPT(ACPTI,0),U,4)=1
 . . Q:$P(^ICPT(ACPTI,0),U,6)'="H"
 . . S ACPTRES=ACPTRES_$E(ACPTC,1,$L(ACPTC)-1)_$J("",3)
 . . I $L(ACPTRES)>79 D MES^XPDUTL(ACPTRES) S ACPTRES=""
 I $L(ACPTRES)>0 D MES^XPDUTL(ACPTRES)
 Q
