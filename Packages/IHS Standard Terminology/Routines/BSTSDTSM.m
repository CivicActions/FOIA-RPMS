BSTSDTSM ;GDIT/HS/BEE-Standard Terminology DTS Calls/Processing ; 5 Nov 2012  9:53 AM
 ;;2.0;IHS STANDARD TERMINOLOGY;**3,5,8**;Dec 01, 2016;Build 27
 ;
 Q
 ;
ICDMAP(CONCDA,GL) ;EP - Save ICD Mapping information
 ;
 NEW DA,DIK,II
 ;
 ;Clear existing entries
 S DA(1)=CONCDA
 S II=0 F  S II=$O(^BSTS(9002318.4,DA(1),18,II)) Q:'II  S DA=II,DIK="^BSTS(9002318.4,"_DA(1)_",18," D ^DIK
 ;
 ;Save ICD Mapping Information
 ;GDIT/HS/BEE;2/12/2024;FEATURE#79121;Switch to pull from new 17163 namespace
 ;I $D(@GL@("ICDM"))>1 D
 I $D(@GL@("ICD10NLM"))>1 D
 . NEW IMCNT
 . ;GDIT/HS/BEE;2/12/2024;FEATURE#79121;Switch to pull from new 17163 namespace
 . ;S IMCNT="" F  S IMCNT=$O(@GL@("ICDM",IMCNT)) Q:IMCNT=""  D
 . S IMCNT="" F  S IMCNT=$O(@GL@("ICD10NLM",IMCNT)) Q:IMCNT=""  D
 .. NEW DA,IENS,MATND,MAT,MATRIN,MATROUT,BSTSICD
 .. NEW MAND,MA,MARIN,MAROUT
 .. NEW MCVND,MCV,MCVRIN,MCVROUT
 .. NEW MGND,MG,MGRIN,MGROUT
 .. NEW MRND,MR,MRRIN,MRROUT
 .. NEW MTND,MT,MTRIN,MTROUT
 .. NEW MTNND,MTN,MTNRIN,MTNROUT
 .. NEW MPND,MP,MPRIN,MPROUT,MTGN
 .. ;
 .. ;Get new entry
 .. S DA=$$NEWM(CONCDA) I 'DA Q
 .. S DA(1)=CONCDA
 .. S IENS=$$IENS^DILF(.DA)
 .. ;
 .. ;Map Group
 .. ;GDIT/HS/BEE;2/12/2024;FEATURE#79121;Switch to pull from new 17163 namespace
 .. ;S MGND=$G(@GL@("ICDM",IMCNT,"mapGroup"))
 .. S MGND=$G(@GL@("ICD10NLM",IMCNT,"mapGroup"))
 .. S MG=$P(MGND,U)
 .. S MGRIN=$P(MGND,U,2)
 .. S MGROUT=$P(MGND,U,3)
 .. I MG]"" D
 ... S BSTSICD(9002318.418,IENS,.02)=MG
 ... S BSTSICD(9002318.418,IENS,.03)=$$EP2FMDT^BSTSUTIL(MGRIN)
 ... S BSTSICD(9002318.418,IENS,.04)=$$EP2FMDT^BSTSUTIL(MGROUT)
 .. ;
 .. ;Map Priority
 .. ;GDIT/HS/BEE;2/12/2024;FEATURE#79121;Switch to pull from new 17163 namespace
 .. ;S MPND=$G(@GL@("ICDM",IMCNT,"mapPriority"))
 .. S MPND=$G(@GL@("ICD10NLM",IMCNT,"mapPriority"))
 .. S MP=$P(MPND,U)
 .. S MPRIN=$P(MPND,U,2)
 .. S MPROUT=$P(MPND,U,3)
 .. I MP]"" D
 ... S BSTSICD(9002318.418,IENS,.05)=MP
 ... S BSTSICD(9002318.418,IENS,.06)=$$EP2FMDT^BSTSUTIL(MPRIN)
 ... S BSTSICD(9002318.418,IENS,.07)=$$EP2FMDT^BSTSUTIL(MPROUT)
 .. ;
 .. ;Map Target
 .. ;GDIT/HS/BEE;2/12/2024;FEATURE#79121;Switch to pull from new 17163 namespace
 .. ;S MTND=$G(@GL@("ICDM",IMCNT,"mapTarget"))
 .. S MTND=$G(@GL@("ICD10NLM",IMCNT,"mapTarget"))
 .. S MT=$P(MTND,U)
 .. S MTGN=$P(MTND,U,4)
 .. S MTRIN=$P(MTND,U,2)
 .. S MTROUT=$P(MTND,U,3)
 .. I MTND]"" D
 ... S BSTSICD(9002318.418,IENS,.08)=MT
 ... S BSTSICD(9002318.418,IENS,.09)=$$EP2FMDT^BSTSUTIL(MTRIN)
 ... S BSTSICD(9002318.418,IENS,.1)=$$EP2FMDT^BSTSUTIL(MTROUT)
 ... ;GDIT/HS/BEE;FEATURE#126820;TargetName
 ... S BSTSICD(9002318.418,IENS,.11)=MTGN
 .. ;
 .. ;Map Advice
 .. ;GDIT/HS/BEE;2/12/2024;FEATURE#79121;Switch to pull from new 17163 namespace
 .. ;S MAND=$G(@GL@("ICDM",IMCNT,"mapAdvice"))
 .. S MAND=$G(@GL@("ICD10NLM",IMCNT,"mapAdvice"))
 .. S MA=$P(MAND,U)
 .. S MATRIN=$P(MAND,U,2)
 .. S MATROUT=$P(MAND,U,3)
 .. I MA]"" D
 ... N TXT,VAR
 ... D WRAP^BSTSUTIL(.TXT,MA,220)
 ... S VAR="TXT"
 ... D WP^DIE(9002318.418,IENS,1,"",VAR)
 ... S BSTSICD(9002318.418,IENS,5.01)=$$EP2FMDT^BSTSUTIL(MATRIN)
 ... S BSTSICD(9002318.418,IENS,5.02)=$$EP2FMDT^BSTSUTIL(MATROUT)
 .. ;
 .. ;Map Target Name
 .. ;GDIT/HS/BEE;2/12/2024;FEATURE#79121;Switch to pull from new 17163 namespace
 .. ;S MTNND=$G(@GL@("ICDM",IMCNT,"mapTargetName"))
 .. S MTNND=$G(@GL@("ICD10NLM",IMCNT,"mapTargetName"))
 .. S MTN=$P(MTNND,U)
 .. S MTNRIN=$P(MTND,U,2)
 .. S MTNROUT=$P(MTND,U,3)
 .. I MTN]"" D
 ... N TXT,VAR
 ... D WRAP^BSTSUTIL(.TXT,MTN,220)
 ... S VAR="TXT"
 ... D WP^DIE(9002318.418,IENS,2,"",VAR)
 ... S BSTSICD(9002318.418,IENS,5.05)=$$EP2FMDT^BSTSUTIL(MTNRIN)
 ... S BSTSICD(9002318.418,IENS,5.06)=$$EP2FMDT^BSTSUTIL(MTNROUT)
 .. ;
 .. ;Map Rule
 .. ;GDIT/HS/BEE;2/12/2024;FEATURE#79121;Switch to pull from new 17163 namespace
 .. ;S MRND=$G(@GL@("ICDM",IMCNT,"mapRule"))
 .. S MRND=$G(@GL@("ICD10NLM",IMCNT,"mapRule"))
 .. S MR=$P(MRND,U)
 .. S MRRIN=$P(MRND,U,2)
 .. S MRROUT=$P(MRND,U,3)
 .. I MR]"" D
 ... N TXT,VAR
 ... D WRAP^BSTSUTIL(.TXT,MR,220)
 ... S VAR="TXT"
 ... D WP^DIE(9002318.418,IENS,3,"",VAR)
 ... S BSTSICD(9002318.418,IENS,5.03)=$$EP2FMDT^BSTSUTIL(MRRIN)
 ... S BSTSICD(9002318.418,IENS,5.04)=$$EP2FMDT^BSTSUTIL(MRROUT)
 .. ;
 .. ;Map Category Value
 .. ;GDIT/HS/BEE;2/12/2024;FEATURE#79121;Switch to pull from new 17163 namespace
 .. ;S MCVND=$G(@GL@("ICDM",IMCNT,"mapCategoryValue"))
 .. S MCVND=$G(@GL@("ICD10NLM",IMCNT,"mapCategoryValue"))
 .. S MCV=$P(MCVND,U)
 .. S MCVRIN=$P(MCVND,U,2)
 .. S MCVROUT=$P(MCVND,U,3)
 .. I MCV]"" D
 ... N TXT,VAR
 ... D WRAP^BSTSUTIL(.TXT,MCV,220)
 ... S VAR="TXT"
 ... D WP^DIE(9002318.418,IENS,4,"",VAR)
 ... S BSTSICD(9002318.418,IENS,5.07)=$$EP2FMDT^BSTSUTIL(MCVRIN)
 ... S BSTSICD(9002318.418,IENS,5.08)=$$EP2FMDT^BSTSUTIL(MCVROUT)
 .. ;
 .. ;File information
 .. I $D(BSTSICD) D FILE^DIE("","BSTSICD","ERROR")
 ;
 Q 1
 ;
NEWM(CIEN) ;Create new ICD Mapping entry
 N DIC,X,Y,DA,DLAYGO
 S DIC(0)="L",DA(1)=CIEN
 S DIC="^BSTS(9002318.4,"_DA(1)_",18,"
 L +^BSTS(9002318.4,CIEN,2,0):1 E  Q ""
 ;GDIT/HS/BEE;2/12/2024;FEATURE#79121;Switch to pull from new 17163 namespace
 ;S X=$P($G(^BSTS(9002318.4,CIEN,2,0)),U,3)+1
 S X=$P($G(^BSTS(9002318.4,CIEN,18,0)),U,3)+1
 S DLAYGO=9002318.418 D ^DIC
 L -^BSTS(9002318.4,CIEN,2,0)
 Q +Y
 ;
GICDMAP(OUT,BSTSWS,RESULT) ;EP - Set up mapping output information
 ;
 ;Input
 ; BSTSWS Array
 ; RESULT - [1]^[2]^[3]
 ;          [1] - Concept ID
 ;          [2] - DTS ID
 ;          [3] - Description Id
 ;
 ;Output
 ; Function returns - # Records Returned
 ;
 ; VAR(#) - List of Records - See above call for format
 ;
 N CNT,INMID,XNMID,MCNT,DFLD,%D,ICNT
 ;
 ;Get the Namespace ID
 S XNMID=$G(BSTSWS("NAMESPACEID"))
 ;
 ;Determine whether to return date fields
 S DFLD=$G(BSTSWS("DAT")) S DFLD=1
 ;
 ;Pull return request
 S INMID=$O(^BSTS(9002318.1,"B",XNMID,""))
 ;
 S (MCNT,CNT)="",ICNT=0 F  S CNT=$O(RESULT(CNT)) Q:CNT=""  D
 . ;
 . N CONC,CIEN,MIEN
 . ;
 . ;Get Concept IEN
 . S CONC=$P(RESULT(CNT),U)
 . S CIEN=$O(^BSTS(9002318.4,"C",XNMID,CONC,"")) Q:CIEN=""
 . ;
 . ;Pull Mapping Information
 . S MCNT=$O(@OUT@(""),-1),MIEN=0 F  S MIEN=$O(^BSTS(9002318.4,CIEN,18,MIEN)) Q:'MIEN  D
 .. ;
 .. NEW MG,MGRIN,MGROUT,DA,IENS,MP,MPRIN,MPROUT
 .. NEW MT,MTRIN,MTROUT,MTGN
 .. ;
 .. S DA(1)=CIEN,DA=MIEN,IENS=$$IENS^DILF(.DA)
 .. ;
 .. ;Pull Map Group
 .. S MG=$$GET1^DIQ(9002318.418,IENS,.02,"I")
 .. S MGRIN=$$GET1^DIQ(9002318.418,IENS,.03,"I")
 .. S MGROUT=$$GET1^DIQ(9002318.418,IENS,.04,"I")
 .. S MCNT=MCNT+1
 .. S @OUT@(MCNT,"MTYPE","VAL")="NLM"
 .. S @OUT@(MCNT,"MPGRP","VAL")=MG
 .. I 'DFLD S @OUT@(MCNT,"MPGRP","XADT")=MGRIN
 .. I 'DFLD S @OUT@(MCNT,"MPGRP","XRDT")=MGROUT
 .. ;
 .. ;Pull Map Priority
 .. S MP=$$GET1^DIQ(9002318.418,IENS,.05,"I")
 .. S MPRIN=$$GET1^DIQ(9002318.418,IENS,.06,"I")
 .. S MPROUT=$$GET1^DIQ(9002318.418,IENS,.07,"I")
 .. S @OUT@(MCNT,"MPPRI","VAL")=MP+100
 .. I 'DFLD S @OUT@(MCNT,"MPPRI","XADT")=MGRIN
 .. I 'DFLD S @OUT@(MCNT,"MPPRI","XRDT")=MGROUT
 .. ;
 .. ;Pull Map Target
 .. S MT=$$GET1^DIQ(9002318.418,IENS,.08,"I")
 .. S MTGN=$$GET1^DIQ(9002318.418,IENS,.11,"I")
 .. S MTRIN=$$GET1^DIQ(9002318.418,IENS,.09,"I")
 .. S MTROUT=$$GET1^DIQ(9002318.418,IENS,.1,"I")
 .. S @OUT@(MCNT,"MPTGT","VAL")=MT
 .. S @OUT@(MCNT,"MPTGTN","VAL")=MTGN
 .. I 'DFLD S @OUT@(MCNT,"MPTGT","XADT")=MTRIN
 .. I 'DFLD S @OUT@(MCNT,"MPTGT","XRDT")=MTROUT
 .. ;
 .. ;Pull Map Advice
 .. D
 ... NEW X,WP,II,MA,LINE,MARIN,MAROUT
 ... S X=$$GET1^DIQ(9002318.418,IENS,1,"","WP")
 ... S MA=""
 ... S II="" F  S II=$O(WP(II)) Q:II=""  S LINE=WP(II) I LINE]"" D
 .... S MA=MA_$S(MA]"":" ",1:"")_LINE
 ... S MARIN=$$GET1^DIQ(9002318.418,IENS,5.01,"I")
 ... S MAROUT=$$GET1^DIQ(9002318.418,IENS,5.02,"I")
 ... S @OUT@(MCNT,"MPADV","VAL")=MA
 ... I 'DFLD S @OUT@(MCNT,"MPADV","XADT")=MARIN
 ... I 'DFLD S @OUT@(MCNT,"MPADV","XRDT")=MAROUT
 .. ;
 .. ;Pull Map Target Name
 .. D
 ... NEW X,WP,II,MT,LINE,MTRIN,MTROUT
 ... S X=$$GET1^DIQ(9002318.418,IENS,2,"","WP")
 ... S MT=""
 ... S II="" F  S II=$O(WP(II)) Q:II=""  S LINE=WP(II) I LINE]"" D
 .... S MT=MT_$S(MT]"":" ",1:"")_LINE
 ... S MTRIN=$$GET1^DIQ(9002318.418,IENS,5.05,"I")
 ... S MTROUT=$$GET1^DIQ(9002318.418,IENS,5.06,"I")
 ... S @OUT@(MCNT,"MPTGN","VAL")=MT
 ... I 'DFLD S @OUT@(MCNT,"MPTGN","XADT")=MTRIN
 ... I 'DFLD S @OUT@(MCNT,"MPTFN","XRDT")=MTROUT
 .. ;
 .. ;Pull Map Rule
 .. D
 ... NEW X,WP,II,MR,LINE,MRRIN,MRROUT
 ... S X=$$GET1^DIQ(9002318.418,IENS,3,"","WP")
 ... S MR=""
 ... S II="" F  S II=$O(WP(II)) Q:II=""  S LINE=WP(II) I LINE]"" D
 .... S MR=MR_$S(MR]"":" ",1:"")_LINE
 ... S MRRIN=$$GET1^DIQ(9002318.418,IENS,5.03,"I")
 ... S MRROUT=$$GET1^DIQ(9002318.418,IENS,5.04,"I")
 ... S @OUT@(MCNT,"MPRUL","VAL")=MR
 ... I 'DFLD S @OUT@(MCNT,"MPRUL","XADT")=MRRIN
 ... I 'DFLD S @OUT@(MCNT,"MPRUL","XRDT")=MRROUT
 .. ;
 .. ;Pull Map Category Value
 .. D
 ... NEW X,WP,II,MCV,LINE,MCVRIN,MCVROUT
 ... S X=$$GET1^DIQ(9002318.418,IENS,4,"","WP")
 ... S MCV=""
 ... S II="" F  S II=$O(WP(II)) Q:II=""  S LINE=WP(II) I LINE]"" D
 .... S MCV=MCV_$S(MCV]"":" ",1:"")_LINE
 ... S MCVRIN=$$GET1^DIQ(9002318.418,IENS,5.07,"I")
 ... S MCVROUT=$$GET1^DIQ(9002318.418,IENS,5.08,"I")
 ... S @OUT@(MCNT,"MPCVL","VAL")=MCV
 ... I 'DFLD S @OUT@(MCNT,"MPCVL","XADT")=MCVRIN
 ... I 'DFLD S @OUT@(MCNT,"MPCVL","XRDT")=MCVROUT
 ;
 Q MCNT
