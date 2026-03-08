AMHGUVF ; IHS/CMI/MAW - AMH GUI Visit Form Utilities (frmVisitDataEntry) 2/13/2009 8:51:56 AM ;
 ;;4.0;IHS BEHAVIORAL HEALTH;**11,12**;JUN 02, 2010;Build 46
 ;
 ;
 ;
 Q
 ;
FNDPOV(IEN,R) ;-- find POV based on ien of pov and amhrec ptr
 N DA,POV
 S POV=0
 S DA=0 F  S DA=$O(^AMHRPRO("AD",R,DA)) Q:'DA!($G(POV))  D
 . N AMHPOV
 . S AMHPOV=$P($G(^AMHRPRO(DA,0)),U)
 . I AMHPOV=IEN S POV=DA Q
 Q $G(POV)
 ;
PRF(DF,RET) ;-- return the flag and narrative for a patient
 N FLAG,FDA,FLG,FN
 S FLAG=$$GETACT^DGPFAPI(DF,"PRF")
 S FN=""
 I 'FLAG Q 0
 S FDA=0 F  S FDA=$O(PRF(FDA)) Q:'FDA  D
 . S FLG=$P(PRF(FDA,"FLAG"),U,2)
 . I $D(PRF(FDA,"NARR")) D
 .. S FIEN=0 F  S FIEN=$O(PRF(FDA,"NARR",FIEN)) Q:'FIEN  D
 ... S FN=FN_$G(PRF(FDA,"NARR",FIEN,0))_" "
 . S RET(FDA)=FLG_" - "_FN
 K PRF
 Q 1
 ;
PRFG(RETVAL,AMHSTR) ;-- get the prf for the GUI
 S X="MERR^AMHGU",@^%ZOSF("TRAP") ; m error trap
 N AMHDA,AMHNS,P,AMHDATA,AMHKEYI,AMHKEY,AMHI
 S AMHI=0
 K ^AMHTMP($J)
 S RETVAL="^AMHTMP("_$J_")"
 S ^AMHTMP($J,AMHI)="T00250Flags"_$C(30)
 S P="|"
 S AMHP=$P(AMHSTR,P)
 S AMHF=$$PRF(AMHP,.FLG)
 I AMHF=0 D  Q
 . S ^AMHTMP($J,AMHI+1)=$C(31)
 S AMHDA=0 F  S AMHDA=$O(FLG(AMHDA)) Q:'AMHDA  D
 . S AMHI=AMHI+1
 . S ^AMHTMP($J,AMHI)=$G(FLG(AMHDA))_$C(30)
 S ^AMHTMP($J,AMHI+1)=$C(31)
 Q
 ;
CLNSCRN(RETVAL,AMHSTR) ;-- clean out screening before filing
 S X="MERR^AMHGU",@^%ZOSF("TRAP") ; m error trap
 S P="|",R="~"
 S RETVAL="^AMHTMP("_$J_")"
 S AMHI=0
 I $G(AMHSTR)="" D CATSTR^AMHGU(.AMHSTR,.AMHSTR)
 K ^AMHTMP($J)
 S @RETVAL@(AMHI)="T00001Result"_$C(30)
 N AMHR,I,J,K
 S AMHR=$P(AMHSTR,P)
 F I=1:1:10 D
 . S $P(^AMHREC(AMHR,14),U,I)=""
 F J=1:1:12 D
 . S $P(^AMHREC(AMHR,22),U,J)=""
 S ^AMHREC(AMHR,15)=""
 S ^AMHREC(AMHR,16)=""
 S ^AMHREC(AMHR,17)=""
 S ^AMHREC(AMHR,19)=""
 S ^AMHREC(AMHR,20)=""
 F K=23:1:28 D
 . S ^AMHREC(AMHR,K)=""
 S AMHI=AMHI+1
 S @RETVAL@(AMHI)=0_$C(30)
 S @RETVAL@(AMHI+1)=$C(31)
 Q
 ;
