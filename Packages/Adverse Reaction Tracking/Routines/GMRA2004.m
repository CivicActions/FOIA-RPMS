GMRA2004 ;IHS/MSC/PLS - Patch support;25-Jun-2024 09:30
 ;;4.0;Adverse Reaction Tracking;**2004**;Mar 28, 1996;Build 3
 ;
ENV ;EP -
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for the installation of other patches
 S PATCH="GMRA*4.0*2003"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 Q
 ;
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numb
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
PRE ;EP -
 Q
POST ;EP -
 D DATA
 D SIGNS
 Q
 ;
DATA ; Import Data
 N LP,NAM,F,LNAARY
 S F=120.82,XUMF=1
 ; Build array of local national allergies
 S LP=0 F  S LP=$O(^GMRD(120.82,LP)) Q:'LP  D
 .Q:'$P(^GMRD(120.82,LP,0),U,3)  ;Must be a National Allergy
 .S LNAARY($P(^GMRD(120.82,LP,0),U),LP)=""
 S LP=0 F  S LP=$O(@XPDGREF@("DATA",F,LP)) Q:'LP  D
 .Q:'$P(@XPDGREF@("DATA",F,LP,0),U,3)  ; Must be marked as National Allergy
 .S NAM=$P($G(@XPDGREF@("DATA",F,LP,0)),U)
 .D STOREALG(LP)
 Q
SIGNS ;  Build array of signs/symptoms
 N F,LP,NAM,SNAARY,XUMF
 S F=120.83,XUMF=1
 S LP=0 F  S LP=$O(^GMRD(120.83,LP)) Q:'LP  D
 .Q:'$P(^GMRD(120.83,LP,0),U,2)  ;Must be a National Allergy
 .S SNAARY($P(^GMRD(120.83,LP,0),U),LP)=""
 S LP=0 F  S LP=$O(@XPDGREF@("DATA",F,LP)) Q:'LP  D
 .Q:'$P(@XPDGREF@("DATA",F,LP,0),U,2)  ; Must be marked as National Allergy
 .S NAM=$P($G(@XPDGREF@("DATA",F,LP,0)),U)
 .D STORSIGN(LP)
 Q
 ;
STOREALG(DATAIEN) ;
 N FDA,FDAIEN,ERR,IENS,ARY,LP2,CNT,IEN
 Q:'$L(DATAIEN)
 M ARY=@XPDGREF@("DATA",120.82,DATAIEN)
 S IEN=$$ALGIEN(NAM)
 S:'IEN IEN="+1"
 S IENS=IEN_",",X=IEN
 S CNT=0
 I X=+X D  ;EXISTING ENTRY
 .S FDA(F,IENS,1)=$P(ARY(0),U,2)
 .S FDA(F,IENS,2)=$P(ARY(0),U,3)
 .S FDA(F,IENS,99.99)=$P($G(ARY("VUID")),U,1)
 .S FDA(F,IENS,99.98)=$P($G(ARY("VUID")),U,2)
 .D FILE^DIE("K","FDA","ERR")
 .Q:$D(ERR)
 .I $D(ARY(1)) D SUBSYS(120.822,IEN)
 .D SUBDATA(IEN)
 E  D  ;New entry
 .S FDA(F,IENS,.01)=$P(ARY(0),U)
 .S FDA(F,IENS,1)=$P(ARY(0),U,2)
 .S FDA(F,IENS,2)=$P(ARY(0),U,3)
 .S FDA(F,IENS,99.99)=$P($G(ARY("VUID")),U,1)
 .S FDA(F,IENS,99.98)=$P($G(ARY("VUID")),U,2)
 .D UPDATE^DIE("","FDA","IENS","ERR")
 .I $D(ERR) W !,IENS W ERR W !! Q
 .I $D(ARY(1)) D SUBSYS(120.822,IENS(1))
 .D SUBDATA(IENS(1))
 Q
 ; Add subfile data
SUBDATA(DIEN) ;EP-
 N IENS
 S IENS=DIEN_","
 ; KILL EXISTING SUBFILE DATA
 ;Synonyms
 K ^GMRD(120.82,DIEN,3)
 S LP2=0 F  S LP2=$O(ARY(3,LP2)) Q:'LP2  D
 .S FDA(120.823,"+"_$$INC()_","_IENS,.01)=$P(ARY(3,LP2,0),U)
 ;Drug Class
 K ^GMRD(120.82,DIEN,"CLASS")
 S LP2=0 F  S LP2=$O(ARY("CLASS",LP2)) Q:'LP2  D
 .S FDA(120.8205,"+"_$$INC()_","_IENS,.01)=$P(ARY("CLASS",LP2,0),U)
 ;Drug Ingredient
 K ^GMRD(120.82,DIEN,"ING")
 S LP2=0 F  S LP2=$O(ARY("ING",LP2)) Q:'LP2  D
 .S FDA(120.824,"+"_$$INC()_","_IENS,.01)=$P(ARY("ING",LP2,0),U)
 ;Effective Date
 K ^GMRD(120.82,DIEN,"TERMSTATUS")
 S LP2=0 F  S LP2=$O(ARY("TERMSTATUS",LP2)) Q:'LP2  D
 .S FDA(120.8299,"+"_$$INC()_","_IENS,.01)=$P(ARY("TERMSTATUS",LP2,0),U)
 .S FDA(120.8299,"+"_$$INC(0)_","_IENS,.02)=$P(ARY("TERMSTATUS",LP2,0),U,2)
 K ERR
 D UPDATE^DIE("","FDA","","ERR")
 I $D(ERR) W !,IENS W ERR("DIERR",1,"TEXT",1) W !! Q
 Q
 ; Increment counter
INC(VAL) ;EP-
 S VAL=$G(VAL,1)
 S CNT=$G(CNT)+VAL
 Q CNT
DIERR(XPDI) N XPD
 D MSG^DIALOG("AE",.XPD) Q:'$D(XPD)
 D BMES^XPDUTL(XPDI),MES^XPDUTL(.XPD)
 Q
 ; Get Allergy IEN from Local National Allergies
ALGIEN(NAM) ;EP-
 Q $O(LNAARY(NAM,0))
SIGNIEN(NAM) ;EP
 Q $O(SNAARY(NAM,0))
 ;
STORSIGN(DATAIEN) ;
 N FDA,FDAIEN,ERR,IENS,ARY,LP2,CNT,IEN
 Q:'$L(DATAIEN)
 M ARY=@XPDGREF@("DATA",120.83,DATAIEN)
 S IEN=$$SIGNIEN(NAM)
 S:'IEN IEN="+1"
 S IENS=IEN_",",X=IEN
 S CNT=0
 I X=+X D  ;EXISTING ENTRY
 .S FDA(F,IENS,1)=$P(ARY(0),U,2)
 .S FDA(F,IENS,99.99)=$P($G(ARY("VUID")),U,1)
 .S FDA(F,IENS,99.98)=$P($G(ARY("VUID")),U,2)
 .D FILE^DIE("K","FDA","ERR")
 .Q:$D(ERR)
 .I $D(ARY(1)) D SUBSYS(120.833,IEN)
 .D SUBSIGN(IEN)
 E  D  ;New entry
 .S FDA(F,IENS,.01)=$P(ARY(0),U)
 .S FDA(F,IENS,1)=$P(ARY(0),U,2)
 .S FDA(F,IENS,99.99)=$P($G(ARY("VUID")),U,1)
 .S FDA(F,IENS,99.98)=$P($G(ARY("VUID")),U,2)
 .D UPDATE^DIE("","FDA","IENS","ERR")
 .I $D(ERR) W !,IENS W ERR W !! Q
 .I $D(ARY(1)) D SUBSYS(120.833,IENS(1))
 .D SUBSIGN(IENS(1))
 Q
SUBSIGN(DIEN) ;EP-
 N IENS
 S IENS=DIEN_","
 ; KILL EXISTING SUBFILE DATA
 ;Synonyms
 K ^GMRD(120.83,DIEN,2)
 S LP2=0 F  S LP2=$O(ARY(2,LP2)) Q:'LP2  D
 .S FDA(120.832,"+"_$$INC()_","_IENS,.01)=$P(ARY(2,LP2,0),U)
 ;Effective Date
 K ^GMRD(120.83,DIEN,"TERMSTATUS")
 S LP2=0 F  S LP2=$O(ARY("TERMSTATUS",LP2)) Q:'LP2  D
 .S FDA(120.8399,"+"_$$INC()_","_IENS,.01)=$P(ARY("TERMSTATUS",LP2,0),U)
 .S FDA(120.8399,"+"_$$INC(0)_","_IENS,.02)=$P(ARY("TERMSTATUS",LP2,0),U,2)
 K ERR
 D UPDATE^DIE("","FDA","","ERR")
 I $D(ERR) W !,IENS W ERR("DIERR",1,"TEXT",1) W !! Q
 Q
PRETRAN ;EP -
 D PRELOOP(120.82,"GMR ALLERGIES",""),PRELOOP(120.83,"SIGN/SYMPTOMS","")
 Q
PRELOOP(FILE,FNAM,SCRN) ;EP-
 D FIA^DIFROMSU(FILE,"",FNAM,XPDGREF,"n^n^f^^n^^y^m^n","",SCRN,4.0)
 D DATAOUT^DIFROMS("","","",XPDGREF)
 Q
SUBSYS(GRP,DIEN) ; Populate Allergies Coding system and Code
  I $D(^GMRD($E(GRP,1,6),DIEN,1)) K ^(1)
  N SUB,I S SUB="+1,"_DIEN_","
  F I=1:1 Q:'$D(ARY(1,I))  D
  .N FDA
  .S FDA(GRP,SUB,.01)=$P(ARY(1,I,0),U)
  .S FDA(GRP,SUB,.02)=$P(ARY(1,I,0),U,2)
  .D UPDATE^DIE("","FDA","IENS")
  Q
POPULATE(NUM) ; Populate files 120.82 and 120.83 with Coding System and Code
 N NUM1,TAB,FL,FL1,I,REC,NAME,CODSYS,CODE
 S TAB=$C(9),U="^",NUM1=NUM_$E(NUM,6)
 S FL="^GMRD("_NUM_")",FL1="^MIR"_$TR(NUM,".")
 F I=1:1 Q:'$D(@FL1@(I))  D
 .S REC=@FL1@(I),NAME=$P(REC,TAB),CODSYS=$P(REC,TAB,2),CODE=$P(REC,TAB,3)
 .S IEN=$O(@FL@("B",NAME,"")) Q:$D(@FL@(IEN,1,"B",CODSYS))
 .N SUB,FDA S SUB="+1,"_IEN_","
 .S FDA(NUM1,SUB,.01)=CODSYS
 .S FDA(NUM1,SUB,.02)=CODE
 .D UPDATE^DIE("","FDA","IENS")
 .Q
 Q
