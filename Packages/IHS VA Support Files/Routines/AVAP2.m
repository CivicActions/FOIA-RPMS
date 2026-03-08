AVAP2 ;IHS/DSD/GTH - AVA 93.2 PATCH 2, FILE SECURITY ; [ 10/21/93  3:34 PM ]
 ;;93.2;VA SUPPORT FILES;**2,27**;JUL 01, 1993;Build 8
 ;PATCH 27: THIS ROUTINE'S FUNCTION PARTIALLY DEPRECATED BY DELETION OF FILES 3/6/16
 ;
 ;W !!,"Resetting file protection for files 5 (STATE) and 16 (PERSON)"  ;AVA*93.2*27
 W !!,"Resetting file protection for file 5 (STATE)"  ;AVA*93.2*27
 W !,"to pre-d93.2 values."
 D RPI
 E  W !,"LOCK UNAVAILABLE.  NOTIFY PROGRAMMER." Q
 W !!,"DONE."
 Q
 ;
RPI ;EP - Non-Interactive entry point for Remote Patch Installation.
 ;
 LOCK +^DIC(5,0,"RD"):60 E  G ABORT
 S ^DIC(5,0,"RD")="" LOCK -^DIC(5,0,"RD")
 Q  ;AVA*93.2*27
 ;
 LOCK +^DIC(16,0,"LAYGO"):60 E  G ABORT
 S ^DIC(16,0,"LAYGO")="#" LOCK -^DIC(16,0,"LAYGO")
 ;
 LOCK +^DIC(16,0,"WR"):60 E  G ABORT
 S ^DIC(16,0,"WR")="#" LOCK -^DIC(16,0,"WR")
 ;
 Q
 ;
 ;
ABORT D @^%ZOSF("ERRTN") I 0
 Q
