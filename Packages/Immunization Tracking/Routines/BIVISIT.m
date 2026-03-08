BIVISIT ;IHS/CMI/MWR - ADD/EDIT IMM/SKIN VISITS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**24,25**;OCT 24,2011;Build 22
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CODE TO ADD V IMMUNIZATION AND V SKIN TEST VISITS.  CALLED BY BIRPC3.
 ;;  PATCH 9: Added save of Admin Date and VIS Presented Date.  VFILE+200
 ;;           If >19yrs on date of immunization and Elig="", set Elig-V01.  VFILE+188
 ;;  PATCH 10: Added save of Skin Test Lot Number.  VFILE+143
 ;;  PATCH 19: Add IEN_ASUFAC State ID to the .18 field.  VFILE+212
 ;;  PATCH 24: Add code for BIDFN. VFILE+223
 ;;  PATCH 25; Added ordering provider
 ;
 ;
 ;----------
PARSE(Y,Z) ;EP
 ;---> Parse out passed Visit and V File data into local variables.
 ;---> Parameters:
 ;     1 - Y (req) String of data for the Visit to be added.
 ;     2 - Z (opt) If Z=1 do NOT set BIVSIT (call from VFILE below must
 ;                 preserve new Visit IEN sent to it).
 ;
 ;---> Pieces of Y delimited by "|":
 ;     -----------------------------
 ;     1 - BIVTYPE (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;     2 - BIDFN   (req) DFN of patient.
 ;     3 - BIPTR   (req) Vaccine or Skin Test .01 pointer.
 ;     4 - BIDOSE  (opt) Dose# number for this Immunization.
 ;     5 - BILOT   (opt) Lot Number IEN for this Immunization.
 ;     6 - BIDATE  (req) Date.Time of Visit.
 ;     7 - BILOC   (req) Location of encounter IEN.
 ;     8 - BIOLOC  (opt) Other Location of encounter.
 ;     9 - BICAT   (req) Category: A (Ambul), I (Inpat), E (Event/Hist)
 ;    10 - BIVSIT  (opt) Visit IEN.
 ;    11 - BIOIEN  (opt) Old V File IEN (for edits).
 ;    12 - BIRES   (req) Skin Test Result: P,N,D,O.
 ;    13 - BIREA   (req) Skin Test Reading: 0-40.
 ;    14 - BIDTR   (req) Skin Test Date Read.
 ;    15 - BIREC   (opt) Vaccine Reaction.
 ;    16 - BIVFC   (opt) VFC Eligibility.  vvv83
 ;    17 - BIVISD  (opt) Release/Revision Date of VIS (YYYMMDD).
 ;    18 - BIPROV  (opt) IEN of Provider of Immunization/Skin Test.
 ;    19 - BIOVRD  (opt) Dose Override.
 ;    20 - BIINJS  (opt) Injection Site.
 ;    21 - BIVOL   (opt) Volume.
 ;    22 - BIREDR  (opt) IEN of Reader of Skin Test.
 ;    23 - BISITE  (opt) Passed DUZ(2) for Site Parameters.
 ;    24 - BICCPT  (opt) If created from CPT ^DD BICCPT=1 or IEN; otherwise=""
 ;                       (called from BIRPC6
 ;    25 - BIMPRT  (opt) If =1 it was imported.
 ;    27 - BIANOT  (opt) Administrative Note (<161 chars).
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Add Admin Date and VIS Presented Date to data being saved.
 ;    28 - BIADMIN (opt) Admin Date (Date shot admin'd to patient.
 ;    29 - BIVPRES (opt) Date VIS Presented to Patient.
 ;
 ;********** PATCH 10, v8.5, MAY 30,2015, IHS/CMI/MWR
 ;    30 - BILOTSK (opt) Skin Test Lot Number.
 ;
 ;********** PATCH 25, v8.5, May 31, 2022, IHS/CMI/LAB
 ;    31 - BIOPROV (opt) Ordering Provider
 ;
 N V S V="|"
 ;
 S BIVTYPE=$P(Y,V,1)
 S BIDFN=$P(Y,V,2)
 S BIPTR=$P(Y,V,3)
 S BIDOSE=$P(Y,V,4)
 S BILOT=$P(Y,V,5)
 S BIDATE=$P(Y,V,6) S:$P(BIDATE,".",2)="" BIDATE=BIDATE_".12"
 S BILOC=$P(Y,V,7)
 S BIOLOC=$P(Y,V,8)
 S BICAT=$P(Y,V,9)
 S:'$G(Z) BIVSIT=$P(Y,V,10)
 S BIOIEN=$P(Y,V,11)
 S BIRES=$P(Y,V,12)
 S BIREA=$P(Y,V,13)
 S BIDTR=$P(Y,V,14) S:BIDTR<1 BIDTR=""
 S BIREC=$P(Y,V,15)
 S BIVFC=$P(Y,V,16)
 S BIVISD=$P(Y,V,17)
 S BIPROV=$P(Y,V,18)
 S BIOVRD=$P(Y,V,19)
 S BIINJS=$P(Y,V,20)
 S BIVOL=$P(Y,V,21)
 S BIREDR=$P(Y,V,22)
 S BISITE=$P(Y,V,23)
 S BICCPT=$P(Y,V,24)
 S BIMPRT=$P(Y,V,25)
 ;S BINDC=$P(Y,V,26)
 S BIANOT=$P(Y,V,27)
 S BIADMIN=$P(Y,V,28)
 S BIVPRES=$P(Y,V,29)
 S BILOTSK=$P(Y,V,30)
 S BIOPROV=$P(Y,V,31)  ;ord prv
 ;**********
 Q
 ;
 ;
 ;----------
ADDV(BIERR,BIDATA,BIOIEN,BINOM) ;EP
 ;---> Add a Visit (if necessary) and V FILE entry for this patient.
 ;---> Called exclusively by ^BIRPC3.
 ;---> Parameters:
 ;     1 - BIERR  (ret) 1^Text of Error Code if any, otherwise null.
 ;     2 - BIDATA (req) String of data for the Visit to be added.
 ;                      See BIDATA definition at linelabel PARSE (above).
 ;     3 - BIOIEN (opt) Not used? pc 11 of BIDATA.
 ;                      Was: IEN of V IMM or V SKIN being edited (if
 ;                      not new).
 ;     4 - BINOM  (opt) 0=Allow display of Visit Selection Menu if site
 ;                       parameter is set. 1=No display (for export).
 ;
 I BIDATA="" D ERRCD^BIUTL2(437,.BIERR) S BIERR="1^"_BIERR Q
 ;
 N BIVTYPE,BIDFN,BIPTR,BIDOSE,BILOT,BIDATE,BILOC,BIOLOC,BICAT,BIVSIT
 N BIRES,BIREA,BIDTR,BIREC,BIVISD,BIPROV,BIOVRD,BIINJS,BIVOL
 N BIREDR,BISITE,BICCPT,BIMPRT,BIANOT,BILOTSK
 ;
 ;---> See BIDATA definition at linelabel PARSE.
 D PARSE(BIDATA)
 ;
 N APCDALVR,APCDANE,AUPNTALK,BITEST,DLAYGO,X
 S BIERR=0
 ;
 ;---> Set BITEST=1 To display VISIT and V IMM pointers after sets.
 ;S BITEST=1
 ;
 ;---> If this is an edit, check or set BIVSIT=IEN of Parent Visit.
 D:$G(BIOIEN)
 .I (BIVTYPE'="I"&(BIVTYPE'="S")) D  Q
 ..D ERRCD^BIUTL2(410,.BIERR) S BIERR="1^"_BIERR
 .;
 .;---> Quit if valid Visit IEN passed.
 .Q:$G(^AUPNVSIT(+$G(BIVSIT),0))
 .;
 .;---> Get Visit IEN from V File entry (and set in BIDATA).
 .N BIGBL S BIGBL=$S(BIVTYPE="I":"^AUPNVIMM(",1:"^AUPNVSK(")
 .S BIGBL=BIGBL_BIOIEN_",0)"
 .;---> Get IEN of VISIT.
 .S BIVSIT=$P($G(@BIGBL),U,3)
 Q:BIERR
 ;
 ;---> Create or edit Visit if necessary.
 ;---> NOTE: BIVSIT, even if sent, might come backed changed (due to
 ;---> change in Date, Category, etc.)
 ;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 ;---> Added BINOM parameter to control Visit Menu display.
 S:($G(BINOM)="") BINOM=0
 D VISIT^BIVISIT1(BIDFN,BIDATE,BICAT,BILOC,BIOLOC,BISITE,.BIVSIT,.BIERR,BINOM)
 ;**********
 Q:BIERR
 ;
 ;---> Create/edit V FILE entry.
 ;ihs/cmi/lab - patch 27 June 2022
 ;modified to edit the V IMM rather than add a new one if BIOIEN exists
 I $G(BIOIEN) S BIIAAE=1
 D VFILE($G(BIVSIT),BIDATA,.BIERR,$G(BIIAAE),$G(BIOIEN))
 Q:BIERR
 ;
VM ;---> If this was a mod to an existing Visit, update VISIT Field .13.
 D:($G(BIOIEN)&($G(BIVSIT)))
 .N AUPNVSIT,DA,DIE,DLAYGO
 .S AUPNVSIT=BIVSIT,DLAYGO=9000010
 .D MOD^AUPNVSIT
 ;
 Q
 ;
 ;
 ;----------
VFILE(BIVSIT,BIDATA,BIERR,BIIAAE,BIOIEN) ;EP
 ;IHS/CMI/LAB - moved to BIVISIT3 due to routine size
 D VFILE^BIVISIT3
 Q
 ;
 ;
 ;----------
TRIGADD ;EP
 ;---> Immunization Added Trigger Event call to Protocol File.
 D TRIGADD^BIVISIT2
 Q
 ;
 ;
 ;----------
VFILE1 ;EP
 ;---> Add (create) V IMMUNIZATION from ^DD of V CPT.
 ;---> Called from EN^XBNEW, from CPTIMM^BIRPC6
 ;---> Local Variables:
 ;     1 - BIVSIT (req) IEN of Parent Visit.
 ;     2 - BIDATA (req) String of data for the Visit to be added.
 ;                      See BIDATA definition at linelabel PARSE.
 ;
 Q:'$G(BIVSIT)  Q:'$D(BIDATA)
 D VFILE(BIVSIT,BIDATA,,"","")
 Q
 ;
 ;
 ;----------
IMPORT(APCDALVR) ;PEP - Code to flag V Imm as "Imported."
 ;---> Code for Tom Love to flag entry as Imported From Outside Registry.
 ;---> Parameters:
 ;     1 - APCDALVR (req) Array returned from call to EN^APCDALVR.
 ;                   APCDALVR("APCDADFN") - IEN of V IMMUNIZATION File entry.
 ;                   APCDALVR("APCDAFLG") - =2 If FAILED to create a V FILE entry.
 ;
 Q:($G(APCDALVR("APCDAFLG")))
 Q:('$G(APCDALVR("APCDADFN")))
 N BIADFN S BIADFN=APCDALVR("APCDADFN")
 ;
 ;---> Add Import From Outside.
 N BIFLD S BIFLD(.15)=1
 D FDIE^BIFMAN(9000010.11,BIADFN,.BIFLD,.BIERR)
 Q
