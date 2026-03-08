AG2B ; IHS/ASDS/EFG - ENTER COMMUNITY OF RESIDENCE DATA ; JUL 11, 2023 
 ;;7.1;PATIENT REGISTRATION;**8,17**;AUG 25, 2005;Build 9
 ;
 ;; IHS/OIT/JS AG*7.1*17- L3 tag switchted with L1 tag - 'Date moved to Present community' is moved above community selection
 ;; User can only selecte communities where date moved to communtiy > community inactive date 
L1 ;
 K AG("EDIT")
 ;W !!,"When did the patient move to this community?  "  ;;IHS/OIT/JS AG*7.1*17  Community filter
 W !!,"When did the patient move to PRESENT COMMUNITY?  "
 W "( ""B"" = ""at BIRTH"" ) "
 W !,"   DATE: "
 D DEF1
 D READ^AG
 Q:$D(DTOUT)!$D(DFOUT)
 G L1:$D(DUOUT),END:$D(DLOUT)&($D(AG("EDIT")))
 I $D(DLOUT)!$D(DQOUT) S Y="?"
 G:Y="??" L1 ;;IHS/OIT/JS AG*7.1*17 - '??' error fix on community date
L1A ;date moved to community
 I Y="B" D
 . S DIC=2
 . S DA=DFN
 . S DR=.03
 . D ^AGDICLK
 . S:$D(AG("LKDATA")) Y=AG("LKDATA")
 . I $G(AG("LKERR"))!($D(AG("LKDATA"))&(+Y<99999)) D
 .. W !,*7,"There is no DATE-OF-BIRTH on file.",!
 .. S Y="?"
 S X=Y
 S %DT=""
 S %DT(0)="-NOW"
 D ^%DT
 K %DT(0)
 G L1:X="^",END:$D(AG("EDIT"))&(X=""),L1:Y<0
 S AG("CDATE")=Y
L2 ;community
 W !!,"Enter PRESENT COMMUNITY:  "
 D DEF
 D READ^AG
 Q:$D(DUOUT)!$D(DTOUT)!$D(DFOUT)
 G L3:$D(DLOUT)&$D(AG("EDIT"))
 I $D(DLOUT)!$D(DQOUT) S Y="?"
L3 ;
 K DIC
 S DIC="^AUTTCOM("
 S DIC(0)="QEM"
 S X=Y
 s DIC("S")="I (+$P(^(88),U,2)<1)!($$FMDIFF^XLFDT(+$P(^(88),U,2),AG(""CDATE""))>1)" ;;AG7.1p17 change - filter out inactive communities  w.r.t 'date moved'
 D ^DIC
 G L2:Y<0
 S AG("CPTR")=+Y
 S AG("CITY")=$P(Y,U,2)
L4 ;
 S DIC("P")=9000001.51,DIC="^AUPNPAT("_DFN_",51,",DIC(0)="QML",(DINUM,X)=AG("CDATE"),DA(1)=DFN,DIC("DR")=".02////"_DT_";.03////"_AG("CPTR") K DD,DO D FILE^DICN
END ;
 Q
DEF ;
 K AG("EDIT")
 Q:'$D(^AUPNPAT(DFN,51,0))
 S AG("CDATE")=$P(^AUPNPAT(DFN,51,0),U,3)
 Q:AG("CDATE")=""
 Q:'$D(^AUPNPAT(DFN,51,AG("CDATE")))
 S AG("CPTR")=$P(^AUPNPAT(DFN,51,AG("CDATE"),0),U,3)
 Q:+AG("CPTR")<1
 Q:'$D(^AUTTCOM(AG("CPTR")))
 W $P(^AUTTCOM(AG("CPTR"),0),U),"//"
 S AG("EDIT")=""
 Q
DEF1 ;
 K AG("EDIT")
 I $D(^AUPNPAT(DFN,51,0)),AG("CDATE")]"" D
 . S Y=$P(^AUPNPAT(DFN,51,AG("CDATE"),0),U)
 . D DD^%DT
 . W !,Y,"// "
 . S AG("EDIT")=""
 Q
EDCOM ;EP - Edit Communities (string in AGED1 and AGBICEDZ).
 ;Get before picture of community information
 I AGOPT(14)="N" D GETS^DIQ(9000001,DFN_",","5101*","I","OCOM")
 ;
 ;;IHS/OIT/JS AG*7.1*17 Community filter 
 ;E1 ;
 ;K DIC("S")
 ;S DIE="^AUPNPAT("
 ;S DA=DFN
 ;S DR=5101
 ;//S DIC(""S"")=""I AG(""""DATE"""")<=$P(^(88),U,2)""
 ;S DR(2,9000001.51)=".01;.03;S $P(^AUPNPAT(DFN,51,D1,0),U,2)=$P(^AUPNPAT(DFN,51,D1,0),U)"
 ;s DIC("W")="I +$P(^(0),U,3) W ?33,$P(^AUTTCOM($P(^(0),U,3),0),U,1) W:(+$P(^(88),U,2))&($P(^(88),U,2)<=+Y) ?65,""*INACTIVE*"""
 ;D ^DIE
 ; 
 ;AG 7.1 p17 ; june2023
 ;updating display of previous records to include 'inactive' status for communities
 ;per https://ihsgov.visualstudio.com/IHS%20HITSS/_workitems/edit/62335
E1 ;
 K DIC
 S DIC="^AUPNPAT("_DFN_",51,"
 S DA(1)=DFN
 S DIC("B")=$$GET1^DIQ(9000001.51,$O(^AUPNPAT(DFN,51,""),-1)_","_DFN,.01)
 S DIC(0)="AELQM"
 s DIC("DR")=".01;S $P(^AUPNPAT(DFN,51,DA,0),U,2)=$P(^AUPNPAT(DFN,51,DA,0),U)"
 S DIC("A")="  Select DATE MOVED: "
 s DIC("W")="I +$P(^(0),U,3) W ?33,$P(^AUTTCOM($P(^(0),U,3),0),U,1) W:(+$P(^(88),U,2))&($$FMDIFF^XLFDT($P(^(88),U,2),+Y)<=1) ?65,""*INACTIVE*"""
 D ^DIC
 I (+Y>0) D
 . K AG("CMNTDT")
 . S AG("CMNTDT")=+Y
 . K DIC
 . S DIC="^AUTTCOM("
 . S DIC(0)="AEQM"
 . S:$D(^AUPNPAT(DFN,51,AG("CMNTDT"))) DIC("B")=$$GET1^DIQ(9999999.05,$P(^AUPNPAT(DFN,51,AG("CMNTDT"),0),U,3),.01)
 . S DIC("S")="I (+$P(^(88),U,2)<1)!($$FMDIFF^XLFDT($P(^(88),U,2),AG(""CMNTDT""))>1)"
 . S DIC("A")="  COMMUNITY OF RESIDENCE: "
 . D ^DIC
 . K DIC
 .;now update community data into previous community multiple
 . I +Y>0&(+AG("CMNTDT")>0) D
 .. K AG("FDA8")
 .. K AG("AGMSGRT")
 .. S AG("FDA8",9000001.51,AG("CMNTDT")_","_DFN_",",.03)=+Y
 .. D FILE^DIE(,"AG(""FDA8"")","AG(""AGMSGRT"")")
 .. I $D(AG("AGMSGRT")) W AG("AGMSGRT",1,"TEXT",1)
 .;delete entry if a valid community was not selected
 . E  D
 .. S DIK="^AUPNPAT("_DFN_",51,"
 .. S DA=+AG("CMNTDT")
 .. D:DA>0 ^DIK
 .. K DIK,DA
 .. W "  Deleted <"_+AG("CMNTDT")_">"
 K AG("FDA8"),AG("AGMSGRT"),AG("CMNTDT")
 ;
 I AGOPT(14)'="N" D  Q
 . D EDCOM^AGBIC2B
 . D COMMVER^AGBIC2B
 . D CMMNR^AGBIC2
 ; 
 ;Verify that an entry is present - AG*7.1*8
 I $O(^AUPNPAT(DFN,51,0))="",'$D(Y) W "??  Required" G E1
 Q
