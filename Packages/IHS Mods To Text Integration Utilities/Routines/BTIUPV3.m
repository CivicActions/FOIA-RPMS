BTIUPV3 ; IHS/MSC/MIR - Problem Objects ;16-Jan-2025 10:23
 ;;1.0;TEXT INTEGRATION UTILITIES;**1014,1016,1017,1020,1022,1030**;NOV 10, 2004;Build 40
 ;
 ; External References
 ;   DBIA 10011  ^DIWP
 ;   DBIA  1573  $$DSMONE^LEXU
 ;
ALL(DFN,TARGET) ; Get All Problems (Active and Inactive)
 N STATUS,HDR S STATUS="ALL",HDR="ALL" D MAIN
 Q "~@"_$NA(@TARGET)
ACTIVE(DFN,TARGET) ; Get Active Problems
 N STATUS,HDR S STATUS="A",HDR="ACTIVE" D MAIN
 Q "~@"_$NA(@TARGET)
INACT(DFN,TARGET) ; Get Inactive Problems
 N STATUS,HDR S STATUS="I",HDR="INACTIVE" D MAIN
 Q "~@"_$NA(@TARGET)
MAIN ; Driver
 K @TARGET N CNT
 D GETLIST(STATUS)
 S @TARGET@(1,0)=HDR_" PROBLEMS WITH DATES"
 I '$D(^TMP("TIUPROB",$J)) S @TARGET@(2,0)="No Problems found" Q
 S CNT=2,@TARGET@(CNT,0)="ST PROBLEM"_$J("",47)_"DATES"
 D WRT
 K ^TMP("TIUPROB",$J),@TARGET@(CNT,0) Q
 ;
WRT ;   Writes Problem List Component,X
 ;
 ;     ^TMP("TIUPROB",$J,#,0)= Diagnosis [1] Date Last Modified [2] Date Entered [4] Status [5] Date of Onset [6]
 ;							   Date Resolved [10] Date Recorded [12]
 ;							   Problem - Lexicon Term [13] SNOMED-CT Preferred Text [16] Primary ICD Code [17]
 ;							   VHAT Concept Code [19] Diagnosis Date [21]
 ;     ^TMP("TIUPROB",$J,#,#,"ICD9")      Other multiple mapped ICD-CM codes
 ;     ^TMP("TIUPROB",$J,#,"L")           Lexicon Term
 ;     ^TMP("TIUPROB",$J,#,"N")           Provider Narrative
 ;
 N REC,NODE,DIAG,DIAC,DIAT,DIAS,STAT,ONSETDT,ENTDT,LASTMDT,DIAGDT,RESLVDT
 N SCT,SCTT,VHAT,EXP,PROVNARR,NARR,ICD,LEX,SNO,WRTARR
 S REC=0 F  S REC=$O(^TMP("TIUPROB",$J,REC)) Q:'REC  D
 .S (DIAC,DIAT)=""
 .S NODE=$G(^TMP("TIUPROB",$J,REC,0)) Q:NODE=""
 .S DIAG=$P(NODE,U),LASTMDT=$P(NODE,U,2),ENTDT=$P(NODE,U,4),STAT=$P(NODE,U,5)
 .S ONSETDT=$P(NODE,U,6),DIAGDT=$P(NODE,U,21),RESDT=$P(NODE,U,10)
 .S:$E(ONSETDT,1,2)="0/" ONSETDT=$E(ONSETDT,$L(ONSETDT)-3,$L(ONSETDT))
 .S:ONSETDT["/0/" ONSETDT=$P(ONSETDT,"/0/")_"/"_$P(ONSETDT,"/0/",2)
 .S SCT=$P(NODE,U,15),SCTT=$P(NODE,U,16),VHAT=$P(NODE,U,19)
 .S EXP=$P(NODE,U,14),PROVNARR=$P(NODE,U,7) S:$L(EXP) EXP=" ("_EXP_")"
 .S ICD=$P(NODE,U,17)
 .S DIAC=$P(ICD,"-"),GMDIAT=$P(ICD,"-",2,99)
 .S LEX=$G(^TMP("TIUPROB",$J,REC,"L"))
 .S SNO=$G(^TMP("TIUPROB",$J,REC,"S"))
 .S NARR=$G(^TMP("TIUPROB",$J,REC,"N")) S:PROVNARR'="" NARR=PROVNARR
 .D TXTFMT(ICD,NARR)
 .I '$D(WRTARR) Q
 .F I=1:1:5 S TXT=$$RT($G(WRTARR(0,I,0))) D LN
 .I WRTARR(0)>5 F  S I=$O(WRTARR(0,I)) Q:'I  S TXT=$$RT($G(WRTARR(0,I,0))) D LN
 .S CNT=CNT+1,@TARGET@(CNT,0)=""
 .K WRTARR
 Q
LN ; Problem
 S CNT=CNT+1 S @TARGET@(CNT,0)=$S(I=1:STAT,1:" ")_"  "_TXT Q:I>5
 S @TARGET@(CNT,0)=@TARGET@(CNT,0)_$J("",57-$L(@TARGET@(CNT,0)))
 N DATE S DATE=$S(I=1:"Entered",I=2:"Onset",I=3:"Diagnosis",I=4:"Resolved",1:"Modified")
 S DATE=DATE_":"_$J("",10-$L(DATE))_$S(I=1:ENTDT,I=2:ONSETDT,I=3:DIAGDT,I=4:RESDT,1:LASTMDT)
 S @TARGET@(CNT,0)=@TARGET@(CNT,0)_DATE
 Q
 ;
RM(X) ; Remove MST
 F  Q:X'["MST"  S X=$P(X,"MST")_$P(X,"MST",2,99)
 F  Q:X'["//"  S X=$P(X,"//")_"/"_$P(X,"//",2,99)
 F  Q:$E(X,$L(X))'="/"  S X=$E(X,1,($L(X)-1))
 F  Q:$E(X)'="/"  S X=$E(X,2,$L(X))
 Q X
RF(X) ; Remove Leading Spaces/Punctuation
 I $L(X) F  Q:" ;"'[$E(X,1)  S X=$E(X,2,$L(X)) Q:X=""
 S X=$$LD(X) Q X
LD(X) ; Uppercase Leading Character
 Q $$UP^XLFSTR($E(X,1))_$E(X,2,$L(X))
RT(X) ; Right Trim Spaces
 F  Q:"| "'[$E(X,$L(X))!'$L(X)  S X=$E(X,1,($L(X)-1))
 Q X
GETLIST(STATUS) ; Define List
 N LIST,LVIEW,TOTAL K ^TMP("TIUPROB",$J) Q:'DFN
 S LVIEW("ACT")=STATUS,LVIEW("PROV")=0,LVIEW("VIEW")=""
 D GETPLIST(.LIST,.TOTAL,.LVIEW)
BUILD ; Build list for selected patient
 ;   Sets ^TMP("TIUPROB",$J,STATUS,0)
 ;   Piece 1:  CNT     # of entries extracted
 ;         2:  TOTAL   # of entries that exist
 N IFN,CNT,NUM S (NUM,CNT)=0 F  S NUM=$O(LIST(NUM)) Q:'NUM  S IFN=+LIST(NUM) I IFN D GETPROB(IFN)
 I 'CNT K ^TMP("TIUPROB",$J) Q
 S ^TMP("TIUPROB",$J,STATUS,0)=CNT_U_TOTAL
 Q
GETPLIST(PLIST,TOTAL,VIEW) ; Build PLIST(#)=IFN for view
 N STBEG,STEND,ST,CNT,IFN,RECORD,DATE,LIST,REV K PLIST S REV=0 ;($P($G(^GMPL(125.99,1,0)),U,5)="R")
 S STBEG=$S(VIEW("ACT")="I":"A",1:""),STEND=$S(VIEW("ACT")="A":"I",1:""),ST=STBEG,TOTAL=0
 S ST="" F  S ST=$O(^AUPNPROB("ACTIVE",DFN,ST)) Q:ST=""  D:ST'="D"
 .I VIEW("ACT")="A",ST="I" Q
 .I VIEW("ACT")="I",ST'="I" Q
 .S IFN=0 F  S IFN=$O(^AUPNPROB("ACTIVE",DFN,ST,IFN)) Q:'IFN  D
 ..S RECORD=$G(^AUPNPROB(IFN,1)) ;IHS/CIA/DKM Q:'$L(RECORD)
 ..Q:$P(RECORD,U,2)="H"  S TOTAL=TOTAL+1
 ..I $L(VIEW("VIEW"))>2,VIEW("VIEW")'[("/"_$P(RECORD,U,$S($E(VIEW("VIEW"))="S":6,1:8))_"/") Q
 ..I VIEW("PROV"),$P(RECORD,U,5)'=+VIEW("PROV") Q
 ..S DATE=$P(RECORD,U,9) S:'DATE DATE=$P($G(^AUPNPROB(IFN,0)),U,8)
 ..;S:REV DATE=9999999-DATE
 ..S LIST(ST_DATE_IFN)=IFN
 S ST="",CNT=0 F  S ST=$O(LIST(ST)) Q:ST=""  S IFN=LIST(ST),CNT=CNT+1,PLIST(CNT)=IFN,PLIST("B",IFN)=CNT
 S PLIST(0)=CNT
 Q
GETPROB(IFN) ; Get problem data and set it to ^TMP array
 ;   Sets Global Arrays:
 ;   ^TMP("TIUPROB",$J,CNT,0)
 ;   Piece 1:  Pointer to ICD9 file #80
 ;         2:  Internal Date Last Modified
 ;         3:  Facility Name
 ;         4:  Internal Date Entered
 ;         5:  Internal Status (A/I/"")
 ;         6:  Internal Date of Onset
 ;         7:  Responsible Provider Narrative
 ;         8:  Service Name
 ;         9:  Service Abbreviation
 ;        10:  Internal Date Resolved
 ;        11:  Clinic Name
 ;        12:  Internal Date Recorded
 ;        13:  Problem Term (from Lexicon)
 ;        14:  Exposure String (AO/IR/EC/HNC/MST/CV/SHD)
 ;        15:  SNOMED-CT Concept Code
 ;        16:  SNOMED-CT Preferred Text
 ;        17:  Primary ICD Code
 ;        18:  Primary ICD Description
 ;        19:  VHAT Concept Code
 ;        20:  VHAT Preferred Text
 ;
 ;   ^TMP("TIUPROB",$J,CNT,#,"ICD9") <-Multiple ICD-9-CM codes mapped to a SNOMED-CT concept
 ;   Piece 1: Secondary ICD-9-CM Code
 ;   Piece 2: Secondary ICD-9-CM Description
 ;
 ;   ^TMP("TIUPROB",$J,CNT,"N")   Provider Narrative
 ;
 ;   ^TMP("TIUPROB",$J,CNT,"IEN") Pointer to Problem file 9000011
 ;
 N DIC,DIQ,DR,DA,REC,DIAG,LASTMDT,NARR,ENTDT,STAT,ONSETDT,RPROV,T,VHATC,VHATT
 N SERV,SERVABB,RESDT,CLIN,RECDT,LEXI,LEX,PG,AO,EXP,HNC,MST,CV,SHD,IR,SCS,SCTC,SCTT,ICD,ICDD,DIAGDT
 S DIC=9000011,DA=IFN,DIQ="REC(",DIQ(0)="IE"
 S DR=".01;.03;.05;.08;.12;.13;.24;1.01;1.05;1.06;1.07;1.08;1.09;1.11;1.12;1.13;1.15;1.16;1.17;1.18;80001;80003"
 D EN^DIQ1
 S ICD=REC(9000011,DA,.01,"E"),DIAG=REC(9000011,DA,.01,"I")
 S LASTMDT=$$FMTE^XLFDT($P(REC(9000011,DA,.03,"I"),"."),5)
 S ENTDT=$$FMTE^XLFDT($P(REC(9000011,DA,.08,"I"),"."),5)
 S ONSETDT=$$FMTE^XLFDT($P(REC(9000011,DA,.13,"I"),"."),5)
 S DIAGDT=$$FMTE^XLFDT($P($G(REC(9000011,DA,.24,"I")),"."),5)
 S RESDT=$$FMTE^XLFDT($P(REC(9000011,DA,1.07,"I"),"."),5)
 S NARR=REC(9000011,DA,.05,"E")
 S STAT=REC(9000011,DA,.12,"I")
 S LEXI=REC(9000011,DA,1.01,"I")
 S LEX=REC(9000011,DA,1.01,"E")
 S RPROV=REC(9000011,DA,1.05,"E")
 S SERV=REC(9000011,DA,1.06,"E")
 S SERVABB=$$SERV(REC(9000011,DA,1.06,"I"),SERV)
 S CLIN=REC(9000011,DA,1.08,"E")
 S RECDT=REC(9000011,DA,1.09,"I")
 S AO=+REC(9000011,DA,1.11,"I")
 S IR=+REC(9000011,DA,1.12,"I")
 S PG=+REC(9000011,DA,1.13,"I")
 S HNC=+REC(9000011,DA,1.15,"I")
 S MST=+REC(9000011,DA,1.16,"I")
 S SCTC=REC(9000011,DA,80001,"I")
 S VHATC=REC(9000011,DA,80003,"I")
 I $L($G(SCTC)) S SCTT=$$SCTTEXT($G(SCTC),$G(ENTDT),"SCT")
 I $L($G(VHATC)) S VHATT=$$SCTTEXT($G(VHATC),$G(ENTDT),"VHAT")
 S ICDD=$$ICDDESC($G(ICD),$G(ENTDT))
 S EXP="" ;K SCS D SCS^GMPLX1(DA,.SCS) S EXP=$G(SCS(1))
 S CNT=+$G(CNT)+1,^TMP("TIUPROB",$J,CNT,0)=DIAG_U_LASTMDT_U_U_ENTDT_U_STAT_U_ONSETDT_U_RPROV_U_SERV_U_SERVABB_U_RESDT_U_CLIN_U_RECDT_U_LEX_U_EXP_U_SCTC_U_$G(SCTT)_U_$G(ICD)_U_$G(ICDD)_U_VHATC_U_$G(VHATT)_U_DIAGDT
 S ^TMP("TIUPROB",$J,CNT,"N")=NARR,^TMP("TIUPROB",$J,CNT,"IEN")=IFN
 S:LEXI ^TMP("TIUPROB",$J,CNT,"L")=LEXI_"^"_LEX
 S ^TMP("TIUPROB",$J,CNT,0,"ICD9")=""
 Q
SERV(X,SERV) ; Returns Service Name Abbreviation
 N ABBREV S ABBREV=$P($G(^DIC(49,+X,0)),U,2) S:ABBREV="" ABBREV=$E($G(SERV),1,5)
 Q ABBREV
SCTTEXT(LCODE,TIUDT,SYS) ; Get Preferred Text for SCT Code
 N %DT,REST,LEX,LEXY
 S REST="",TIUDT=$G(TIUDT,DT),SYS=$G(SYS,"SCT")
 S LEXY=$$CODE^LEXTRAN(LCODE,SYS,TIUDT)
 I LEXY S REST=$G(LEX("P"))
 Q REST
TXTFMT(ICD,NARR) ; Wrapping
 N X,DIWR,DIWL S DIWR=48,DIWL=0
 K ^UTILITY($J,"W"),WRTARR
 I ICD'="" S X=ICD S:NARR]"" X=X_"-"
 I NARR]"" S X=$G(X)_NARR
 D ^DIWP M WRTARR=^UTILITY($J,"W") K ^UTILITY($J,"W")
 Q
ICDDESC(LCODE,ICDT) ; Get description for ICD9 Code
 N ICDD,ICDY,DESC S DESC="",ICDT=$G(ICDT,DT)
 S ICDY=$$ICDD^ICDCODE(LCODE,"ICDD",ICDT)
 I ICDY S DESC=$G(ICDD(1))
 Q DESC
