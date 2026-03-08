BIVISIT3 ;IHS/CMI/MWR - ADD/EDIT IMM/SKIN VISITS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**24,25,26,29,30**;OCT 24,2011;Build 125
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;
 ;
 ;----------
 ;
 ;
 ;----------
VFILE ;EP
 ;---> Add/edit (create) V IMMUNIZATION or V SKIN TEST entry for this Visit.
 ;---> Parameters:
 ;     1 - BIVSIT (req) IEN of Parent Visit.
 ;     2 - BIDATA (req) String of data for the Visit to be added.
 ;                      See BIDATA definition at linelabel PARSE.
 ;     3 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;
 ;
 I BIDATA="" D ERRCD^BIUTL2(437,.BIERR) S BIERR="1^"_BIERR Q
 ;
 N BIVTYPE,BIDFN,BIPTR,BIDOSE,BILOT,BIDATE,BILOC,BIOLOC,BICAT
 N BIRES,BIREA,BIDTR,BIREC,BIVISD,BIPROV,BIOVRD,BIINJS,BIVOL
 N BIREDR,BISITE,BICCPT,BIMPRT,BIANOT,BILOTSK
 N DLAYGO,DITC
 ;
 S BIIAAE=$G(BIIAAE)  ;edit variable
 I BIIAAE=1,'BIOIEN S BIIAAE=""
 ;---> See BIDATA definition at linelabel PARSE (above).
 D PARSE^BIVISIT(BIDATA,1)
 ;
 ;---> Fields in V IMMUNIZATION File are as follows:
 ;
 ;       .01 APCDTIMM  Pointer to IMMUNIZATION File (Vaccine)
 ;       .02 APCDPAT   Patient
 ;       .03 APCDVSIT  IEN of Visit
 ;       .04 APCDTSER  Dose# (Series#)
 ;       .05 APCDTLOT  Lot# IEN, Pointer to IMMUNIZATION LOT File
 ;       .06 APCDTREC  Reaction
 ;
 ;       This will no longer be used:
 ;       .07 APCDTCON  Contraindication (Stored in ^BIP.)
 ;
 ;       .12 APCDTVSD  VIS Date (Lori will put in a future template.)
 ;      1202 APCDTPRV  Ordering provider
 ;      1204 APCDTEPR  Immunization Provider
 ;
 ;---> Fields in V SKIN TEST File are as follows:
 ;
 ;       .01 APCDTSK   Pointer to IMMUNIZATION File
 ;       .02 APCDPAT   Patient
 ;       .03 APCDVSIT  IEN of Visit
 ;       .04 APCDTRES  Result
 ;       .05 APCDTREA  Reading
 ;       .06 APCDTDR   Date read
 ;      1204 APCDTEPR  Skin Test Provider
 ;
 ;---> Check that a Parent VISIT exists.
 I '$D(^AUPNVSIT(+$G(BIVSIT),0)) D  Q
 .D ERRCD^BIUTL2(432,.BIERR) S BIERR="1^"_BIERR
 ;
 N APCDALVR
 ;
 ;---> Set Visit pointer.
 S APCDALVR("APCDVSIT")=BIVSIT
 ;
 ;
 ;---> Set Patient.
 S APCDALVR("APCDPAT")=BIDFN
 ;
 ;
 ;
 ;---> * * * If this is an IMMUNIZATION, set APCD array for Immunizations. * * *
 ;
 I BIVTYPE="I" D
 .;
 .;if this is an edit then wipe out all fields except .01/.02
 .I BIIAAE D
 ..D DELIMF
 ..NEW DIE,DA,DR S DIE="^AUPNVIMM(",DA=BIOIEN,DR=".03////"_BIVSIT,DITC=1 D ^DIE K DA,DR,DIE,DITC
 .;---> Set permission override for this file.
 .I 'BIIAAE S DLAYGO=9000010.11
 .;
 .;---> Immunization/vaccine name.
 .S APCDALVR("APCDTIMM")="`"_BIPTR
 .;
 .;---> Lot Number IEN for this immunization.
 .S:'$G(BILOT) BILOT=""
 .;
 .;---> Reaction to this vaccine on this Visit.
 .S:'$G(BIREC) BIREC=""
 .S APCDALVR("APCDTREC")=BIREC
 .;
 .;---> Immunization Provider ("Shot giver").
 .S:$G(BIPROV) APCDALVR("APCDTEPR")="`"_BIPROV
 .;
 .;---> ordering provider .
 .S:$G(BIOPROV) APCDALVR("APCDTPRV")="`"_BIOPROV
 .;---> User who last edited this Immunization.
 .S:$G(DUZ) APCDALVR("APCDTULU")="`"_DUZ
 .;
 .;---> Template to add encounter to V IMMUNIZATION File.
 .I 'BIIAAE S APCDALVR("APCDATMP")="[APCDALVR 9000010.11 (ADD)]"
 .I BIIAAE S APCDALVR("APCDATMP")="[APCDALVR 9000010.11 (MOD)]",APCDALVR("APCDLOOK")="`"_BIOIEN  ;edit old ien
 ;
 ;
 ;
 ;---> * * * If this is a SKIN TEST, set APCD array for Skin Tests.  * * *
 ;
 I BIVTYPE="S" D
 .;
 .;---> Set permission override for this file.
 .S DLAYGO=9000010.12
 .;I 
 .;
 .;---> Skin Test name.
 .S APCDALVR("APCDTSK")="`"_BIPTR
 .;
 .;---> Skin Test Result.
 .S APCDALVR("APCDTRES")=BIRES
 .;
 .;---> Skin Test Reading (mm).
 .S APCDALVR("APCDTREA")=BIREA
 .;
 .;---> Skin Test Date Read.
 .S APCDALVR("APCDTDR")=BIDTR
 .;
 .;---> Skin Test Provider (Person who administered the test).
 .S:$G(BIPROV) APCDALVR("APCDTEPR")="`"_BIPROV
 .;
 .;---> Template to add encounter to V SKIN TEST File.
 .S APCDALVR("APCDATMP")="[APCDALVR 9000010.12 (ADD)]"
 ;
 ;
 ;---> * * *  CALL TO APCDALVR.  * * *
 D EN^APCDALVR
 D:$G(BITEST) DISPLAY2^BIPCC
 ;
 ;---> Quit if a V File entry was not created.
 I $D(APCDALVR("APCDAFLG")) D  Q
 .I BIVTYPE="I" D ERRCD^BIUTL2(402,.BIERR) S BIERR="1^"_BIERR Q
 .I BIVTYPE="S" D ERRCD^BIUTL2(413,.BIERR) S BIERR="1^"_BIERR
 ;
 I 'BIIAAE,'$G(APCDALVR("APCDADFN")) D  Q
 .I BIVTYPE="I" D ERRCD^BIUTL2(402,.BIERR) S BIERR="1^"_BIERR Q
 .I BIVTYPE="S" D ERRCD^BIUTL2(413,.BIERR) S BIERR="1^"_BIERR
 ;
 ;Returns:  APCDADFN - IEN of V IMMUNIZATION File entry.
 ;          APCDAFLG - =2 If FAILED to create a V FILE entry.
 ;
 ;
 ;---> Save IEN of V IMMUNIZATION just created.
 N BIADFN
 I 'BIIAAE S BIADFN=APCDALVR("APCDADFN")
 I BIIAAE S BIADFN=BIOIEN
 I BIVTYPE="S" S BIADFN=APCDALVR("APCDADFN")  ;20221004 maw p26 for skin test fields not being saved correctly
 ;
 ;
 ;---> ADD OTHER V SKIN TEST FIELDS:
 ;---> If this is a Skin Test, add Skin Test Reader and Quit.
 I BIVTYPE="S" D  Q
 .;---> Store Additional data.
 .N BIFLD
 .S BIFLD(.08)=BIREDR,BIFLD(.09)=BIINJS,BIFLD(.11)=BIVOL
 .;
 .;********** PATCH 10, v8.5, MAY 30,2015, IHS/CMI
 .;---> BILOTSK (opt) Skin Test Lot Number.
 .S BIFLD(.14)=BILOTSK
 .;
 .;---> Set DATE/TIME LAST MODIFIED, per Lori Butcher, 5/26/12
 .S:$G(BIOIEN) BIFLD(1218)=$$NOW^XLFDT
 .;
 .D FDIE^BIFMAN(9000010.12,BIADFN,.BIFLD,.BIERR)
 .I BIERR=1 D ERRCD^BIUTL2(421,.BIERR) S BIERR="1^"_BIERR
 .;
 .;---> If Skin Test is a PPD and result is Positive, add Contraindication
 .;---> to further TST-PPD tests.
 .I $$SKNAME^BIUTL6($G(BIPTR))="PPD",$E($G(BIRES))="P" D
 ..;---> Set date equal to either Date Read, or Date of Visit, or Today.
 ..N BIDTC S BIDTC=$S($G(BIDTR):BIDTR,$G(BIDATE):$P(BIDATE,"."),1:$G(DT))
 ..S BIDATA=BIDFN_"|"_203_"|"_17_"|"_BIDTC
 ..D ADDCONT^BIRPC4(,BIDATA)
 ;
 ;
 ;---> ADD OTHER V IMMUNIZATION FIELDS:
 ;---> Quit if this is not an Immunization.
 Q:BIVTYPE'="I"
 ;
 ;---> Add VIS, Dose Override, Injection Site and Volume data.
 ;---> Build DR string.
 ;
 S:(BIVISD<1) BIVISD="@" S:BIOVRD="" BIOVRD="@"
 ;
 S:BIINJS="" BIINJS="@" S:BIVOL="" BIVOL="@"
 S:BILOT="" BIILOT="@"
 ;
 ;---> Store Additional data.
 N BIFLD
 S BIFLD(.05)=BILOT
 S BIFLD(.08)=BIOVRD,BIFLD(.09)=BIINJS
 S BIFLD(.11)=BIVOL,BIFLD(.12)=BIVISD,BIFLD(.13)=BICCPT
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> If patient is 19yrs or older at the time of the immunization,
 ;---> and Eligibility is null, set Eligibility=V01.
 D
 .Q:(BIVFC]"")
 .N BIAGDT
 .S BIAGDT=$S($G(BIADMIN):BIADMIN,1:BIDATE)
 .;V8.5 PATCH 29 - FID-107546 Tdap age check
 .I +$$AGE^BIUTL1(BIDFN,1,BIAGDT)>18 S BIVFC=$O(^BIELIG("B","V01",0))
 ;**********
 ;
 S BIFLD(.14)=BIVFC
 S BIFLD(.15)=$S(BIMPRT>0:2,1:"")
 ;S BIFLD(.16)=BINDC
 S:($G(BIANOT)]"") BIFLD(1)=BIANOT
 ;
 ;---> Set DATE/TIME LAST MODIFIED, per Lori Butcher, 5/26/12
 S BIFLD(1218)=$$NOW^XLFDT
 ;**********
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Add Admin Date and VIS Presented Date to data being saved.
 ;    28 - BIADMIN  Admin Date (Date shot admin'd to patient).
 ;    29 - BIVPRES  Date VIS Presented to Patient.
 ;
 I $G(BIADMIN)["/" S BIADMIN=""  ;20221208 88884 p26 ihs/cmi/maw dont store external date
 S BIFLD(1201)=BIADMIN
 S BIFLD(.17)=BIVPRES
 ;**********
 ;
 ;********** PATCH 19, v8.5, JUN 01,2020, IHS/CMI/MWR
 ;---> If this is an Edit, retrive State ID from previous entry.
 ;---> If this in not an Edit, add State ID to the .18 field.
 ;
 ;********** PATCH 24, v8.5, APR 01,2022, ihs/cmi/maw
 ;---> If previous V IMM doesn't have State ID, create it.
 N BIID
 D
 .;---> If this is a previous V Imm: retrieve or create State ID.
 .D  Q
 ..S BIID=$P($G(^AUPNVIMM(BIADFN,0)),U,18)
 ..I BIID="" D
 ...S BIID=$$ASTID^BIVISIT2(BIADFN) D
 ...;--> Populate the old V Imm so ASTID link goes with it to BI V IMM DELETED.
 ...S $P(^AUPNVIMM(BIADFN,0),U,18)=BIID,^AUPNVIMM("ASTID",BIID,BIADFN)=""
 .;
 .;---> New V Imm, generate a STID.
 .;S BIID=$$ASTID^BIVISIT2(BIADFN)
 ;
 ;S BIFLD(.18)=BIID
 ;
 ;**********
 ;
 ;
 D FDIE^BIFMAN(9000010.11,BIADFN,.BIFLD,.BIERR)
 I BIERR=1 D  Q
 .D ERRCD^BIUTL2(421,.BIERR) S BIERR="1^"_BIERR
 ;
 ;
 ;---> If there was an anaphylactic reaction to this vaccine,
 ;---> add it as a contraindication for this patient.
 D:BIREC=9
 .Q:'$G(BIDFN)  Q:'$G(BIPTR)  Q:'$G(BIDATE)
 .N BIREAS S BIREAS=$O(^BICONT("B","Anaphylaxis",0))
 .Q:'BIREAS
 .;
 .N BIADD,N,V S N=0,BIADD=1,V="|"
 .;---> Loop through patient's existing contraindications.
 .F  S N=$O(^BIPC("B",BIDFN,N)) Q:'N  Q:'BIADD  D
 ..N X S X=$G(^BIPC(N,0))
 ..Q:'X
 ..;---> Quit (BIADD=0) if this contra/reason/date already exists.
 ..I $P(X,U,2)=BIPTR&($P(X,U,3)=BIREAS)&($P(X,U,4)=BIDATE) S BIADD=0
 .Q:'BIADD
 .;
 .D ADDCONT^BIRPC4(.BIERR,BIDFN_V_BIPTR_V_BIREAS_V_BIDATE)
 .I $G(BIERR)]"" S BIERR="1^"_BIERR
 ;
 ;---> Now trigger New Immunization Trigger Event.
 D TRIGADD^BIVISIT
 Q
 ;
DELIMF ;EP - delete all v imm fields using DIE
 ;DO NOT DELETE .01/.02/1216/1217/1101/2601/2701
 NEW BIF,DA,DIE,DR,DITC
 S BIF=0 F  S BIF=$O(^DD(9000010.11,BIF)) Q:BIF'=+BIF  D
 .Q:BIF=.01
 .Q:BIF=.02
 .Q:BIF=.03  ;VISIT
 .Q:BIF=.13  ;CREATED BY V CPT
 .Q:BIF=.15  ;IMPORT FLAG
 .Q:BIF=.18  ;PER TOM LOVE LEAVE STATE ID ALONE
 .Q:BIF=1216
 .Q:BIF=1217
 .Q:BIF=1101  ;REMARKS
 .Q:BIF=2601  ;this will get updated by the AMAP xref
 .Q:BIF=2701  ;this will get updated by the AMAP xref
 .I $$VAL^XBDIQ1(9000010.11,BIOIEN,BIF)]"" D
 ..S DA=BIOIEN,DIE="^AUPNVIMM(",DR=BIF_"///@",DITC=1 D ^DIE K DA,DR,DIE
 Q
