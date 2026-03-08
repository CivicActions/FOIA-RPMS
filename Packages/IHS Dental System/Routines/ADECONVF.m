ADECONVF ;IHS/OIT/GAB - DENTAL File 200 Conversion
 ;;6.0;ADE;**38**;MAR 25, 1999;Build 158
 ;;IHS/OIT/GAB 11.2022 File 3,6,16 Removal - ADE Patch 38
 ; CONVERSION ROUTINE FOR FILE 200 UPDATE
 K ADEQUIT ; Termination Flag
 S ADEQUIT=0
 D CKCON
 I $G(ADEQUIT)=1 S XPDQUIT=1 D MSG("There was an issue with the Data Dictionary Update, stopping the conversion process...") Q
 ;Convert the Dental Procedure file, Attending & Auxiliary Providers
 S (ADECNT,ADEDFN)=0
 F  S ADEDFN=$O(^ADEPCD(ADEDFN)) Q:ADEDFN'=+ADEDFN  I $D(^ADEPCD(ADEDFN,0)) D
 .S ADECNT=ADECNT+1 I '$D(ZTQUEUED),ADECNT#10000=0 D MSG("*")
 .D PROV1
 .D PROV2
 .Q
 D CLEANRP
 ;Convert the rest of the files
 D SITEPAR
 D DENEMP
 D DENFLU
 D DENCONT
 D DENSTER
 D ADEPROV
 D ADEGENR
 D DENTFOL
 D AFTCONV ;set the Dental Site Parameter, File 200 entry=1, conversion complete
 D MSG("File 200 Conversion Complete")
 Q
 ;
CKCON ;EP - CK File 200 CONVERSION DENTAL PROCEDURE FILE
 ;
 I $G(^DD(9002007,3,0))'[200  D
 .S ADEQUIT=1
 .D MSG("  ")
 .D MSG("The Dental Procedure Data Dictionary is not present or has not been updated, stopping conversion now...")
 .D MSG("  ")
 .H 3
 K ^ADEPCD(-1) ;get rid of bad entries in the Dental Procedure file
 Q
PROV1 ;UPDATE FOR REPORTING PROVIDER - STUFF NEW PERSON IEN INTO DENTAL PROCEDURE FILE USING PERSON "A3" PTR
 ;Convert 4th piece - REPORTING DENTIST, FIELD 3 (DR=3)
 K ADEOLDN,ADENEWN
 S ADEOLDN=$P(^ADEPCD(ADEDFN,0),U,4)
 Q:'ADEOLDN
 S ADENEWN=$G(^DIC(16,ADEOLDN,"A3"))
 I 'ADENEWN D MSG("ERROR in Record (#"_ADEDFN_")...") Q
 S DA=ADEDFN,DIE="^ADEPCD(",DR="3///`"_ADENEWN D ^DIE K DIE  ;for dental
 K ADEOLDN,ADENEWN
 Q
 ;
PROV2 ;UPDATE FOR AUXILLIARY PROVIDER - STUFF NEW PERSON IEN INTO DENTAL PROCEDURE FILE USING PERSON "A3" PTR
 ;Convert 5th piece - AUXILLIARY PROVIDER, FIELD 4 (DR=4)
 K ADEOLDN,ADENEWN
 S ADEOLDN=$P(^ADEPCD(ADEDFN,0),U,5)
 Q:'ADEOLDN
 S ADENEWN=$G(^DIC(16,ADEOLDN,"A3"))
 I 'ADENEWN D MSG("ERROR in Dental Procedure Record (#"_ADEDFN_")...") Q
 S DA=ADEDFN,DIE="^ADEPCD(",DR="4///`"_ADENEWN D ^DIE K DIE
 K ADEOLDN,ADENEWN
 Q
SITEPAR ;UPDATE FOR DENTAL SITE PARAMETER FILE (9002006) - STUFF NEW PERSON IEN USING PERSON "A3" PTR
 ;Convert ^ADEPARAM file, Field 2/Piece 3 DEFAULT DENTIST
 K ADENEWN,ADEOLDN,IEN
 S (ADENEWN,ADEOLDN,IEN)=""
 F  S IEN=$O(^ADEPARAM(IEN)) Q:IEN'=+IEN  D
 .Q:IEN=0  ;ignore the 0 node
 .S ADEOLDN=$P($G(^ADEPARAM(IEN,0)),"^",3)
 .Q:'ADEOLDN
 .S ADENEWN=$G(^DIC(16,ADEOLDN,"A3"))
 .I 'ADENEWN D MSG("ERROR in Site Parameter Record (#"_IEN_")...") Q
 .S DA=IEN,DIE="^ADEPARAM(",DR="2///`"_ADENEWN D ^DIE K DIE
 K ADENEWN,ADEOLDN,IEN
 Q
DENEMP ;UPDATE FOR DENTAL EMPLOYEE FILE (9002010.01) - STUFF NEW PERSON IEN INTO EMPLOYEE FILE USING PERSON "A3" PTR
 ;Convert ^ADEEMP file, Field 1/Piece 1 and cross references; using ^TMP global for DINUM'd entries
 K ADENEWN,ADEOLDN,IEN
 N DIK
 K ^TMP($J,"ADEEMP")
 S ^TMP($J,"ADEEMP",0)="DENTAL EMPLOYEE^9002010.01PI^^0"
 S (ADENEWN,ADEOLDN,IEN)=""
 F  S IEN=$O(^ADEEMP(IEN)) Q:IEN'=+IEN  D
 .Q:IEN=0
 .S ADEOLDN=$P($G(^ADEEMP(IEN,0)),"^",1)
 .Q:'ADEOLDN
 .I ADEOLDN S ADENEWN=$G(^DIC(16,ADEOLDN,"A3"))
 .I 'ADENEWN D MSG("ERROR in DENTAL EMPLOYEE Record (#"_IEN_")...") Q
 .M ^TMP($J,"ADEEMP",ADENEWN)=^ADEEMP(ADEOLDN)
 .S $P(^TMP($J,"ADEEMP",ADENEWN,0),"^")=ADENEWN
 .S $P(^TMP($J,"ADEEMP",0),"^",3)=ADENEWN
 .S $P(^TMP($J,"ADEEMP",0),"^",4)=+$P($G(^TMP($J,"ADEEMP",0)),"^",4)+1
 K DA,DIK
 K ^ADEEMP
 M ^ADEEMP=^TMP($J,"ADEEMP")
 S DIK="^ADEEMP(" D IXALL^DIK
 K ADENEWN,ADEOLDN,IEN
 Q
DENFLU  ;UPDATE THE DENTAL FLUORIDATION SURVEILLANCE PTR (9002002.1) - POINTER TO DENTAL EMPLOYEE FILE
 ;Convert ^ADEFLU file, Field 3/Piece 4 ANALYST FIELD
 K ADENEWN,ADEOLDN,IEN,TST
 S (ADENEWN,ADEOLDN,IEN,TST)=""
 F  S IEN=$O(^ADEFLU(IEN)) Q:IEN'=+IEN  D
 .Q:IEN=0
 .S TST=0
 .F  S TST=$O(^ADEFLU(IEN,1,TST)) Q:TST'=+TST  D
 ..Q:TST=0
 ..S ADEOLDN=$P($G(^ADEFLU(IEN,1,TST,0)),"^",4)
 ..Q:'ADEOLDN
 ..I ADEOLDN S ADENEWN=$G(^DIC(16,ADEOLDN,"A3"))
 ..I 'ADENEWN D MSG("ERROR in Dental Fluoride Surv. Record IEN: (#"_IEN_") TST: (#"_TST_")..") Q
 ..S DA=TST,DA(1)=IEN
 ..S DIE="^ADEFLU("_DA(1)_",1,"
 ..S DR="3///`"_ADENEWN D ^DIE K DIE,DA
 Q
DENCONT ;UPDATE THE DENTAL CONTINUING EDUCATION PTR (9002002.6) - POINTER TO DENTAL EMPLOYEE FILE
 ;Convert ^ADECDE file, field .05/Piece 2 Employee field and "C" cross reference
 K ADENEWN,ADEOLDN,IEN
 N DIK
 S (ADENEWN,ADEOLDN,IEN)=""
 F  S IEN=$O(^ADECDE(IEN)) Q:IEN'=+IEN  D
 .Q:IEN=0
 .S ADEOLDN=$P($G(^ADECDE(IEN,0)),"^",2)
 .Q:'ADEOLDN
 .I ADEOLDN S ADENEWN=$G(^DIC(16,ADEOLDN,"A3"))
 .I 'ADENEWN D MSG("ERROR in Dental Continuing Education Record IEN: (#"_IEN_")...") Q
 .S DA=IEN,DIE="^ADECDE(",DR=".05///`"_ADENEWN D ^DIE K DIE,DA
 ;Re-index "C" Cross Reference
 K DA,DIK
 D MSG("Cleaning up Dental Continuing Education Employee cross-reference...")
 K ^ADECDE("C") ;Flush any pre-existing C "xref" contents prior to reindex
 S DIK="^ADECDE("  ;Global root for Dental Continuing Education file(#9002007)
 S DIK(1)=".05^C" ;Field^XREF spec
 D ENALL^DIK
 D MSG("... Cross-reference cleanup complete.")
 Q
DENSTER ;UPDATE THE DENTAL STERILIZER TEST FILE (9002002.51) - STUFF NEW PERSON IEN INTO ENTRY USING PERSON "A3" PTR
 ;Convert ^ADESTR file, field 3/Piece 3 Tester field
 K ADENEWN,ADEOLDN,IEN,TST
 S (ADENEWN,ADEOLDN,IEN,TST)=""
 F  S IEN=$O(^ADESTR(IEN)) Q:IEN'=+IEN  D
 .Q:IEN=0
 .S TST=0
 .F  S TST=$O(^ADESTR(IEN,1,TST)) Q:TST'=+TST  D
 ..Q:TST=0
 ..S ADEOLDN=$P($G(^ADESTR(IEN,1,TST,0)),"^",3)
 ..Q:'ADEOLDN
 ..I ADEOLDN S ADENEWN=$G(^DIC(16,ADEOLDN,"A3"))
 ..I 'ADENEWN D MSG("ERROR in Dental Sterilizer Record IEN: (#"_IEN_") TST: (#"_TST_")..") Q
 ..S DA=TST,DA(1)=IEN
 ..S DIE="^ADESTR("_DA(1)_",1,"
 ..S DR="3///`"_ADENEWN
 ..D ^DIE K DIE,DA
 Q
ADEPROV ;UPDATE THE ADE GENERIC PROVIDER FILE (9002002.22) - STUFF NEW PERSON IEN INTO FILE USING PERSON "A3" PTR
 ;Convert ^ADEDPRV file, field .01/Piece 1 Provider field and re-index the "B" cross-reference
 K ADENEWN,ADEOLDN,IEN
 N DIK
 S (ADENEWN,ADEOLDN,IEN)=""
 F  S IEN=$O(^ADEDPRV(IEN)) Q:IEN'=+IEN  D
 .Q:IEN=0
 .S ADEOLDN=$P($G(^ADEDPRV(IEN,0)),"^",1)
 .Q:'ADEOLDN
 .I ADEOLDN S ADENEWN=$G(^DIC(16,ADEOLDN,"A3"))
 .I 'ADENEWN D MSG("ERROR in ADE GENERIC PROVIDER Record (#"_IEN_")...") Q
 .S DA=IEN,DIE="^ADEDPRV(",DR=".01///`"_ADENEWN D ^DIE K DIE
 ;Re-index "B" Cross Reference
 K DA,DIK
 D MSG("Cleaning up ADE Generic Provider file, Provider cross-reference...")
 K ^ADEDPRV("B") ;Flush any pre-existing B "xref" contents prior to reindex
 S DIK="^ADEDPRV("  ;Global root for ADE Generic Provider file (9002002.22)
 S DIK(1)=".01^B" ;Field^XREF spec
 D ENALL^DIK
 D MSG("... Cross-reference cleanup complete.")
 Q
ADEGENR  ;UPDATE THE ADE GENERIC RECORD FILE (9002002.23 - STUFF NEW PERSON IEN INTO FILE USING PERSON "A3" PTR
 ;Convert ^ADEDREC file, field 99/Piece 18 Provider Field and re-index the "C" cross-reference
 Q  ;/IHS/OIT/GAB MAY NOT NEED THIS ONE!  LOOKS LIKE IT POINTS BACK TO CORRECT ENTRY (1,2, etc.,)
 K ADENEWN,ADEOLDN,IEN
 N DIK
 S (ADENEWN,ADEOLDN,IEN)=""
 F  S IEN=$O(^ADEDREC(IEN)) Q:IEN'=+IEN  D
 .Q:IEN=0
 .S ADEOLDN=$P($G(^ADEDREC(IEN,0)),"^",18)
 .Q:'ADEOLDN
 .I ADEOLDN S ADENEWN=$G(^DIC(16,ADEOLDN,"A3"))
 .I 'ADENEWN D MSG("ERROR in ADE GENERIC RECORD Record (#"_IEN_")...") Q
 .S DA=IEN,DIE="^ADEDREC(",DR="99///`"_ADENEWN D ^DIE K DIE
 ;Re-index "B" Cross Reference
 K DA,DIK
 D MSG("Cleaning up ADE Generic Provider file, Provider cross-reference...")
 K ^ADEDREC("C") ;Flush any pre-existing B "xref" contents prior to reindex
 S DIK="^ADEDREC("  ;Global root for ADE Generic Provider file (9002002.22)
 S DIK(1)="99^C" ;Field^XREF spec
 D ENALL^DIK
 D MSG("... Cross-reference cleanup complete.")
 Q
DENTFOL ;UPDATE THE DENTAL FOLLOWUP FILE (9002003.2 - STUFF NEW PERSON IEN INTO FILE USING PERSON "A3" PTR
 ;Convert ^ADEFOL file, field 6/Piece 7 Provider Field
 K ADENEWN,ADEOLDN,IEN
 S (ADENEWN,ADEOLDN,IEN)=""
 F  S IEN=$O(^ADEFOL(IEN)) Q:IEN'=+IEN  D
 .Q:IEN=0
 .S ADEOLDN=$P($G(^ADEFOL(IEN,0)),"^",7)
 .Q:'ADEOLDN
 .I ADEOLDN S ADENEWN=$G(^DIC(16,ADEOLDN,"A3"))
 .I 'ADENEWN D MSG("ERROR in Dental Followup Record (#"_IEN_")...") Q
 .S DA=IEN,DIE="^ADEFOL(",DR="6///`"_ADENEWN D ^DIE K DIE
 Q
CLEANRP ;CLEAN UP THE "ARPD" CROSS-REFERENCE/REPORTING DENTIST(ARPD)PROVIDER IN THE DENTAL PROCEDURE FILE
 ;/IHS/OIT/GAB - Reindex ARPD cross reference for Field 3
 K DA,DIK
 D MSG("Update the Dental Procedure File 'ARPD' Provider cross-reference...")
 K ^ADEPCD("ARPD") ;Flush any pre-existing ARPD xref contents prior to reindex
 S DIK="^ADEPCD("  ;Global root for Dental Procedure File (#9002007)
 S DIK(1)="3^ARPD" ;Field^XREF spec
 D ENALL^DIK
 D MSG("... Cross-reference cleanup complete.")
 Q
AFTCONV  ;add entry to the Dental Site Parameter file, field 99 to indicate conversion completed
 N D
 S D=0 F  S D=$O(^ADEPARAM(D)) Q:D'=+D  S ^ADEPARAM(D,99)=1
 Q
MSG(MSGTXT)  ;OUTPUT A TEXT MESSAGE
 I $D(XPDNM) D MES^XPDUTL($G(MSGTXT)) Q
 D EN^DDIOL($G(MSGTXT))
 Q
