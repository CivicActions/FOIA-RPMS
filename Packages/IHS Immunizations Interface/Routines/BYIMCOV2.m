BYIMCOV2 ;GDIT/HS/GCD - IMMUNIZATION DATA EXCHANGE; [ 13/13/2021  11:10 PM ]
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**2**;MAR 15, 2021;Build 493
 ;
 Q
 ;
 ; Configures BYIM business hosts in BCOM production
 ; Sets the following parameters:
 ; BO: Stay Connected = 30
 ; BO: Failure Timeout = -1
 ; BS: Confirm Complete = Writable (Windows) or Size (AIX)
BCOM() ;
 N BCOMNS,DIR,X,Y,OK,PROD,ITEMS,BONAME,BSNAME,SETTINGS,TSC
 ; Determine the BCOM namespace
 S @("BCOMNS=""BCOM""_$namespace")
 I @("'##class(%SYS.Namespace).Exists(BCOMNS)") S OK="" F  D  Q:X="^"!OK
 . S DIR(0)="F"
 . S DIR("A")="Enter the name of the BCOM Ensemble namespace"
 . D ^DIR
 . I X="^" Q
 . S BCOMNS=Y
 . I @("##class(%SYS.Namespace).Exists(BCOMNS)") S OK=1 Q
 . W !!,"Namespace '"_BCOMNS_"' does not exist",!
 Q:$G(X)="^"
 ;
 ; Switch to BCOM namespace
 N @("$namespace")  ; Using New causes the namespace to return to the current namespace when this subroutine quits
 S @("$namespace=BCOMNS")
 ;
 W !!,"Checking production..."
 ; Verify production exists
 S PROD="BCOM.SFTP"
 I @("'##class(%Dictionary.CompiledClass).%ExistsId(PROD)") D ERR("Production '"_PROD_"' does not exist. Please install the production and try again") Q
 ; Open production object
 S @("POBJ=##class(Ens.Config.Production).%OpenId(PROD)")
 I @("'$IsObject(POBJ)") D ERR("Production '"_PROD_"' could not be opened") Q
 ;
 ; Get existing hosts
 D @("##class(Ens.Director).getProductionItems(POBJ,.ITEMS)")
 ;
 ; Get BO and BS
 S BONAME="SendBYIM"
 I '$D(ITEMS(BONAME)) W " Production does not need updating" Q
 S BSNAME="GetBYIM"
 I '$D(ITEMS(BSNAME)) W " Production does not need updating" Q
 ;
 ; Update BO and BS
 S SETTINGS(BONAME,"Adapter","StayConnected")=30
 S SETTINGS(BONAME,"Host","FailureTimeout")="-1"
 ; ConfirmComplete: 0=None, 1=Size, 2=Rename, 4=Readable, 8=Writable
 I @("$ZVERSION(1)=2") S SETTINGS(BSNAME,"Adapter","ConfirmComplete")=8  ; Windows
 E  S SETTINGS(BSNAME,"Adapter","ConfirmComplete")=1,SETTINGS(BSNAME,"Adapter","FileAccessTimeout")=60
 S @("TSC=##class(Ens.Production).ApplySettings(PROD,.SETTINGS)")
 I 'TSC D ERR("Unable to apply production settings",$$GETERR(TSC)) Q
 W " Production updated"
 ;
 Q
 ;
ERR(MSG,ERR) ;
 I $G(MSG)="" Q
 W !!,"** Error: "_MSG
 I $G(ERR)'="" W !,ERR
 W !!
 Q
 ;
GETERR(TSC) ;
 N ERR,TXT,I
 I TSC Q ""
 D @("##class(%SYSTEM.Status).DecomposeStatus(TSC,.ERR,""-d"")")
 S TXT=""
 F I=1:1:ERR S TXT=TXT_ERR(I)_" "
 S @("TXT=$E(TXT,1,*-1)")
 Q TXT
