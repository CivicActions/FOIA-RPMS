BYIMCOV7 ;GDIT/HS/GCD - IMMUNIZATION DATA EXCHANGE;
 ;;3.0;BYIM IMMUNIZATION DATA EXCHANGE;**7**;AUG 20, 2020;Build 747
 ;
 Q
 ;V3.0 PATCH 7 - FID-101056 SHUT DOWN CAS EXPORT
 ;
 ; Removes up BYIM business hosts from BCOM production
BCOM ;
 N BCOMNS,DIR,X,Y,OK,PROD,POBJ,BSNAME,BONAME,HOSTID,REMOVED,TSC
 ;
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
 ; Switch to BCOM namespace. Using New causes the namespace to return 
 ; to the current namespace when this subroutine quits
 N @("$namespace")
 S @("$namespace=BCOMNS")
 ;
 ; Verify production exists
 S PROD="BCOM.SFTP"
 W !!,"Updating '"_PROD_"' production..."
 I @("'##class(%Dictionary.CompiledClass).%ExistsId(PROD)") W !!,"  Production does not exist. Unable to remove BYIM from the production." Q
 ; Open production object
 S @("POBJ=##class(Ens.Config.Production).%OpenId(PROD)")
 I @("'$IsObject(POBJ)") W !!,"  Production cannot be opened. Unable to remove BYIM from the production." Q
 ;
 ; Find and remove hosts
 S BSNAME="GetBYIM",BONAME="SendBYIM",HOSTID=1,REMOVED=""
 F  D  I @("HOSTID>POBJ.Items.Count()") Q
 . I @("'$IsObject(POBJ.Items.GetAt(HOSTID))") S HOSTID=HOSTID+1 Q
 . I @("POBJ.Items.GetAt(HOSTID).Name=BSNAME") D  Q
 . . D @("POBJ.RemoveItem(POBJ.Items.GetAt(HOSTID))")
 . . W !!,"  Removed '"_BSNAME_"' business service"
 . . S REMOVED=1
 . I @("POBJ.Items.GetAt(HOSTID).Name=BONAME") D  Q
 . . D @("POBJ.RemoveItem(POBJ.Items.GetAt(HOSTID))")
 . . W !!,"  Removed '"_BONAME_"' business operation"
 . . S REMOVED=1
 . S HOSTID=HOSTID+1  ; Increment only if we didn't remove one
 ;
 I 'REMOVED W !!,"  No production changes needed" Q
 ;
 ; Save production
 S @("TSC=POBJ.%Save()")
 I 'TSC W !!,"  Unable to save changes to BCOM production: "_$$GETERR(TSC) Q
 ;
 ; Update the production if necessary
 I @("##class(Ens.Director).ProductionNeedsUpdate()") D
 . W !!,"  Updating production..."
 . S @("TSC=##class(Ens.Director).UpdateProduction(120,1)")
 . I 'TSC W !!,"  Unable to update production: "_$$GETERR(TSC)
 ;
 Q
 ;
GETERR(TSC) ;
 N ERR,TXT,I
 I TSC Q ""
 D @("##class(%SYSTEM.Status).DecomposeStatus(TSC,.ERR,""-d"")")
 S TXT=""
 F I=1:1:ERR S TXT=TXT_ERR(I)_" "
 S TXT=$E(TXT,1,*-1) ; Strip the final space
 Q TXT
