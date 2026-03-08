RA412PST ; IHS/HQW/SCR - POSTINIT for RA patch 11; [ 01/10/2002  4:06 PM ]
 ;;4.0;RADIOLOGY;**12**;NOV 20, 1997
 ;
 ;This routine
 ;  ..Initializes all procedures with type RADIOLOGY
 ;  ..Cleans up temporary globals used for tracking conversions  
 ;  ..compiles the input templates RA EXAM EDIT
 ;        RA QUICK EXAM ORDER and RA ORDER EXAM
 ;
 D TYPINIT,CLEAN,TMPLATE
 Q
 ;
TYPINIT ;
 ;Initializes all Procedures in Radiology Procedure File with Imaging
 ;Type "1" (RADIOLOGY). This field can be edited through the SUP menu
 ;
 N RAPROC
 S RAPROC=0
 F  S RAPROC=$O(^RAMIS(71,RAPROC)) Q:RAPROC=""  S $P(^RAMIS(71,RAPROC,0),U,12)=1
 K RAPROC
 W !,"All Radiology Procedures have been initialized with RADIOLOGY imaging type."
 Q
CLEAN ;
 K ^RA("IHSPATCH10","MOCK"),^RA("IHSPATCH10","VA_ATS_CONVERSION"),^RA("IHSPATCH10","VA_HL7_CONVERSION"),^RA("IHSPATCH10","JRNLERROR"),^RA("IHSPATCH10","VA_FILE200_CONVERSION")
 Q
 ;
TMPLATE ;
 N IEN,ROUTINE,DMAX
 ;
 F RAINTMP="RA EXAM EDIT","RA QUICK EXAM ORDER","RA ORDER EXAM" D
 .S IEN=0,IEN=$O(^DIE("B",RAINTMP,IEN))
 .I IEN'>0 D CLN Q
 .;
 .S ROUTINE=$G(^DIE(IEN,"ROU"))
 .I $E(ROUTINE)="^" S ROUTINE=$E(ROUTINE,2,999)
 .I ROUTINE="" D CLN Q
 .;
 .S DMAX=$$ROUSIZE^DILF
 .D COMPILE(ROUTINE,IEN,DMAX)
 .W !,"COMPILING INPUT TEMPLATE: ",RAINTMP
 .; 
CLN ;
 K IEN,ROUTINE,DMAX
 Q
 ;
COMPILE(X,Y,DMAX) ;
 ; 
 ;  X    = ROUTINE NAME
 ;  Y    = TEMPLATE IEN
 ;  DMAX = COMPILED ROUTINE SIZE
 ;
 D EN^DIEZ
 Q
