BSTSDCLN ;GDIT/HS/BEE-Clean up duplicate concepts ; 19 Nov 2012  9:41 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**4**;Dec 01, 2016;Build 10
 ;
 Q
 ;
DUP(STS) ;Clean up duplicate concepts
 ;
 NEW CONC,CIEN,CIEN,DCNT,RUN
 ;
 ;Set up scratch global
 S ^XTMP("BSTS_DUP",0)=$$FMADD^XLFDT($P($$NOW^XLFDT,"."),60)_U_$P($$NOW^XLFDT,".")_U_"BSTS DUPLICATE CONCEPT REMOVAL"
 S (RUN,^XTMP("BSTS_DUP","CNT"))=$G(^XTMP("BSTS_DUP","CNT"))+1
 ;
 ;First identify the duplicates
 S CONC="" F  S CONC=$O(^BSTS(9002318.4,"C",36,CONC)) Q:CONC=""  D
 . NEW DCIEN,CTMCNT
 . ;
 . ;Update status
 . I $G(STS) S ^XTMP("BSTSLCMP","STS")="Searching local cache to address duplicate concepts. On entry - "_CONC
 . ;
 . S CIEN=$O(^BSTS(9002318.4,"C",36,CONC,"")) I CIEN="" Q
 . S DCIEN=$O(^BSTS(9002318.4,"C",36,CONC,CIEN)) I DCIEN="" Q
 . ;
 . ;There are duplicates, get them
 . S DCIEN="" F DCNT=1:1 S DCIEN=$O(^BSTS(9002318.4,"C",36,CONC,DCIEN)) Q:DCIEN=""  S DCIEN(DCNT)=DCIEN
 . ;
 . ;Check for for terms
 . S CTMCNT=0,DCIEN=""
 . S DCNT="" F  S DCNT=$O(DCIEN(DCNT)) Q:DCNT=""  D
 .. ;
 .. ;Get the concept IEN
 .. S DCIEN=$P(DCIEN(DCNT),U) Q:DCIEN=""
 .. ;
 .. ;Check if concept has terms
 .. I $O(^BSTS(9002318.3,"C",36,DCIEN,""))]"" S $P(DCIEN(DCNT),U,2)=1,CTMCNT=CTMCNT+1,CTMCNT(DCIEN)=""
 . ;
 . ;If only one has terms, remove the others
 . I CTMCNT=1 D  Q
 .. ;
 .. NEW RCIEN
 .. ;
 .. ;Get the one with terms
 .. S DCIEN=$O(CTMCNT("")) Q:DCIEN=""
 .. ;
 .. ;Loop through the rest and remove
 .. S DCNT="" F  S DCNT=$O(DCIEN(DCNT)) Q:DCNT=""  D
 ... ;
 ... NEW DA,DIK,DTS,VAR,STS
 ... ;
 ... ;Skip one with terms
 ... S RCIEN=$P(DCIEN(DCNT),U) Q:RCIEN=""
 ... I $P(DCIEN(DCNT),U)=DCIEN Q
 ... ;
 ... ;Save to scratch
 ... M ^XTMP("BSTS_DUP",RUN,RCIEN,"C")=^BSTS(9002318.4,RCIEN)
 ... S ^XTMP("BSTS_DUP",RUN,RCIEN,"ORIG")=DCIEN
 ... ;
 ... ;Remove entry
 ... S DA=RCIEN,DIK="^BSTS(9002318.4," D ^DIK
 ... ;
 ... ;Update existing entry
 ... S DTS=$P($G(^BSTS(9002318.4,DCIEN,0)),U,8) Q:'DTS
 ... S STS=$$DTSLKP^BSTSAPI("VAR",DTS)
 ;
 Q
