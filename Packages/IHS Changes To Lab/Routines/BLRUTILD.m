BLRUTILD ; IHS/MSC/MKK - MISC IHS LAB UTILITIES (Cont) ; 28-Aug-2023 07:50 ; MKK
 ;;5.2;IHS LABORATORY;**1054**;NOV 01, 1997;Build 20
 ;
 ; MSC/MKK - LR*5.2*1054 - Item 76305 - Preferred Name & Legal Sex Controlled by XPAR
 ;
EEP ; EP - Ersatz EP
 D ^XBCLS
 W !,$C(7),$C(7),$C(7)
 W !!
 W ?9,$$SHOUTMSG^BLRGMENU("Must use Line Labels to access subroutines",60)     ; /IHS/MSC/MKK - LR*5.2*10XX
 W !!
 W !,$C(7),$C(7),$C(7),!
 Q
 ;
 ;
GETPREF(LRDFN) ; EP - Function to return Preferred Name
 Q:+$G(LRDFN)<1 "-1^Missing LRDFN"
 ;
 NEW DFN,PTNAME,PREFNAME
 ;
 S DFN=$$GET1^DIQ(63,LRDFN,"NAME","I")
 S PTNAME=$$GET1^DIQ(2,DFN,"NAME")
 ;
 I $$GET^XPAR("ALL","AUPN DISPLAY PPN")<1 Q PTNAME         ; If System XPAR not set, use File 2 Sex
 ;
 S PREFNAME=$$GETPREF^AUPNSOGI(DFN)      ; Use mandated API
 ;
 ; If Preferred Name does not exist, return "regular" name
 Q $S($L(PREFNAME):PREFNAME,1:PTNAME)
 ;
 ;
GETLSEX(LRDFN) ; EP - Function to return Legal Sex
 Q:+$G(LRDFN)<1 "-1^Missing LRDFN"
 ;
 NEW DFN
 ;
 S DFN=$$GET1^DIQ(63,LRDFN,"NAME","I")
 ;
 NEW EFFDATE,LEGALSEX,PTSEX
 ;
 S PTSEX=$$GET1^DIQ(2,DFN,"SEX","I")_U_$$GET1^DIQ(2,DFN,"SEX")
 ;
 ; I $$GET^XPAR("ALL","AUPN DISPLAY PPN")<1 Q PTSEX         ; If System XPAR not set use File 2 Sex
 I $$GET^XPAR("ALL","IHS RPMS LAB PPN FLAG")<1 Q PTSEX      ; If Lab XPAR not set use File 2 Sex
 ;
 S LEGALSEX=$P($$GETLSEX^AUPNSOGI(DFN),U,2)   ; Use mandated API
 ;
 ; If Legal Sex exists, return it, otherwise return "regular" Sex
 Q $S($L(LEGALSEX):$E(LEGALSEX)_U_LEGALSEX,1:PTSEX)
 ;
 ;
TOGGLE ; EP - Toggle IHS RPMS LAB PPN FLAG parameter (YES/NO)
 NEW HEADER,NEWVAL,OLDVAL,QFLG
 ;
 S OLDVAL=$$GET^XPAR("ALL","IHS RPMS LAB PPN FLAG")
 S NEWVAL=$S(OLDVAL<1:"YES",1:"NO")
 S OLDVAL=$S(OLDVAL<1:"NO",1:"YES")
 ;
 S HEADER(1)="PARAMETER: IHS RPMS LAB PPN FLAG"
 D HEADERDT^BLRGMENU
 W ?4,"PARAMETER 'IHS RPMS LAB PPN FLAG' Changed from ",OLDVAL," to ",NEWVAL,!
 D EN^XPAR("SYS","IHS RPMS LAB PPN FLAG",,NEWVAL,.ERRS)
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
 ;
 ; ============================= UTILITIES =============================
 ;
JUSTNEW ; EP - Generic RPMS EXCLUSIVE NEW
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 Q
 ;
SETBLRVS(TWO) ; EP - Set the BLRVERN variable(s)
 K BLRVERN,BLRVERN2
 ;
 S BLRVERN=$P($P($T(+1),";")," ")
 S:$L($G(TWO)) BLRVERN2=$G(TWO)
 Q
 ;
