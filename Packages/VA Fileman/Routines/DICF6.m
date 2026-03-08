DICF6 ;SEA/TOAD-VA FileMan: Finder, Part 7 (Sets of Codes) ;10/18/94  12:02 ; [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 
PREPS(DIFLAGS,DINDEX,DILIST) 
 ; transform value for indexed set of codes field
 ; proc, DINDEX passed by ref
 N DICODE,DIMEAN,DIPAIR,DISKIP,DITRY,DIVAL
 N DISET S DISET=$P(DINDEX(0,"DEF"),U,3)
CODES 
 N DIP F DIP=1:1:$L(DISET,";")-1 D
 . S DIPAIR=$P(DISET,";",DIP)
 . S DIVAL=0 F  D  Q:DIVAL=""!(DIVAL>8)
 . . S DIVAL=$O(@DILIST("LVA")@("V",DIVAL)) Q:DIVAL=""!(DIVAL>8)
 . . I "^1^2^5^6^"'[(U_DIVAL_U) Q
 . . S DIMEAN=$P(DIPAIR,":",2)
 . . S DITRY=@DILIST("LVA")@("V",DIVAL)
 . . I $P(DIMEAN,DITRY)'="" Q
 . . I DIFLAGS["X",DIMEAN'=DITRY Q
 . . S DICODE=$P(DIPAIR,":")
 . . I DICODE=DITRY Q
MATCH . . 
 . . D ADDVAL^DICF2(DICODE,.DINDEX,.DILIST)
 Q
 
ERR(DIERN,DIFILE,DIIENS,DIFIELD,DI1,DI2,DI3) 
 ; error logging procedure
 N DIPE
 N DI F DI="FILE","IENS","FIELD",1:1:3 S DIPE(DI)=$G(@("DI"_DI))
 D BLD^DIALOG(DIERN,.DIPE,.DIPE)
 Q
 
 
