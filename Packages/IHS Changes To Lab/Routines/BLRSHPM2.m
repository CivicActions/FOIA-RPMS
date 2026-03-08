BLRSHPM2 ;IHS/MSC/MKK - BLR Reference Lab Shipping Manifest (con't) ; 05-May-2022 13:05 ; MKK
 ;;5.2;IHS LABORATORY;**1051**;NOV 01, 1997;Build 19
 ;
 ; Code moved from BLRSPHM to here because BLRSHPM became too large due to the following:
 ; IHS/MSC/MKK - LR*5.2*1051 - Item 78863 - Wrong DOB on Manifest
 ;
P1031FIX ; EP - Forcefully reset AGE, DFN, DOB, ORDNUM and SEX variables
 NEW ALLGOOD,FIXDFN,LRAA,LRAD,LRAN,LRAS,LRDFN,LRIDT,LRSS   ; IHS/MSC/MKK - LR*5.2*1051
 ;
 D RETACCV^BLRUTIL4(LRUID,.LRAA,.LRAD,.LRAN,.LRDFN,.LRSS,.LRIDT,.LRAS)
 Q:LRAA<1!(LRAD<1)!(LRAN<1)!(LRDFN<1)            ; If any Accession variables null, then exit
 ;
 Q:$P($G(^LR(LRDFN,0)),U,2)'=2    ; LR*5.2*1051 - Item 78863 - Skip if data not from VA PATIENT file
 ;
 S FIXDFN=$P($G(^LR(LRDFN,0)),U,3)     ; LR*5.2*1051 - Item 78863 - Get Patient IEN from Lab Data (#63) File
 Q:FIXDFN<1                            ; LR*5.2*1051 - Item 78863 - Skip if DFN doesn't exist
 ;
 ; Set AGE, DOB & SEX (if missing) from VA Patient (#2) File
 S DFN=FIXDFN
 S SEX=$$SEX^AUPNPAT(DFN)
 S DOB=$$DOB^AUPNPAT(DFN)
 S AGE=$$AGE^AUPNPAT(DFN)
 ;
 ; Get Order # from Accession (#68) File
 S ORDNUM=+$$GET1^DIQ(68.02,LRAN_","_LRAD_","_LRAA_",","ORDER #")
 Q:ORDNUM<1   ; If order # is zero, can't reset, so just return
 ;
 ; Set Order number (if missing)
 S:+$G(BLRRL("ORD"))<1 BLRRL("ORD")=ORDNUM
 S:+$G(^TMP("BLRRL",$J,"COMMON","ORD"))<1 ^TMP("BLRRL",$J,"COMMON","ORD")=ORDNUM
 Q
