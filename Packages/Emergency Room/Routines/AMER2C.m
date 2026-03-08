AMER2C ; GDIT/HS/BEE-Overflow from AMER2A;  
 ;;3.0;ER VISIT SYSTEM;**13**;MAR 03, 2009;Build 36
 ;
 Q
 ;
QD52 ; Primary nurse
 ;
 ;GDIT/HS/BEE;Feature#73115/75284;AMER*3.0*13;Multiple nurse/provider handling
 ;Make call to new multi-nurse handler
 NEW AMERV,II
 S AMERV=$$NPRC^AMERMPRV(AMERDFN,"","PRIMARY NURSE","",0)
 ;
 ;Retrieve latest data from V file and save in ^TMP
 S Y=""
 I +AMERV D
 . S (Y,^TMP("AMER",$J,2,52))=$P(AMERV,U)  ;Primary nurse
 . S ^TMP("AMER",$J,2,53)=$P(AMERV,U,2)  ;Primary nurse time
 ;
 I $G(AMERV)="" F II=1,2 D
 . K ^TMP("AMER",$J,II,52)
 . K ^TMP("AMER",$J,II,53)
 ;
 S X=$S(AMERV="^":"^",AMERV="^^":"^^",1:"")
 S AMERRUN=20
 ;
 D OUT^AMER I $D(AMERQUIT) Q
 Q
