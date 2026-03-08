BARACE ; IHS/SD/LSL - add new A/R Accounts ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**35**;OCT 26, 2005;Build 187
 ;IHS/SD/SDR 1.8*35 ADO60910 Update to display PPN preferred name
 ;;
 D:'$D(BARUSR) INIT^BARUTL
 ;
DIC ;EP
 ; loop A/R accounts
 K DIC,DA,DR
 S DIC="^BARAC(DUZ(2),"
 ;S DIC(0)="AQMLZ"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 S DIC(0)="AEQMLZ"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 S DIC("S")="I $P(^(0),U,10)=BARUSR(29,""I"")"
 S DIC("W")="D DICWACCT^BARUTL0(Y)"  ;bar*1.8*35 IHS/SD/SDR ADO60910
 D ^DIC
 Q:Y'>0
 S DR="2///BILLABLE;Q;" ;billable
 I Y["BAR" S DR="2///FINANCIAL;Q;" ;financial
 S DIE=DIC
 S DR=DR_".01;10///^S X=BARUSR(29,""I"");8////^S X=DUZ(2)"
 S DA=+Y
 S DIDEL=90050
 D ^DIE
 K DIDEL
 G DIC
