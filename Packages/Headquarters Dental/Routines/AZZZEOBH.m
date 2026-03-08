AZZZEOBH ; IHS/ADC/GTH - PROCESS EOBRS CONTINUATION - SELECT INPUT MEDIA ; [ 09/17/97   9:12 AM ]
 ;;3.0;CONTRACT HEALTH MGMT SYSTEM;**10**;SEP 17, 1997
 ;
DSM ;EP
 KILL DIR
 S DIR(0)="S^T:TAPE;C:CARTRIDGE;A:ABORT THE PROCESS",DIR("A")="Process "_$S(ACHSISAO:"AO",1:"Facility")_" EOBR data from: ",DIR("B")="CARTRIDGE",DIR("?")="Which MEDIA do you want the EOBR data processed from?"
 D ^DIR
 I $D(DIROUT)!$D(DTOUT)!$D(DUOUT)!(Y["A") W !!,"Job TERMINATED by Operator at Device Select" K DIR G ENDX^AZZZEOB
 S ACHSMEDA=Y
 G CARTDSM:"Cc"[ACHSMEDA,TAPEDSM:"Tt"[ACHSMEDA
CARTDSM ;
 S IO=47,ACHSMSG="Cartridge"
 G GO
 ;
TAPEDSM ;
 S IO=48,ACHSMSG="9-Track"
GO ;
 S IOP=IO
 D ^%ZIS
 I POP D ^%ZISC U IO(0) W !!,ACHSMSG," Drive Not Available" G ABEND^AZZZEOB
 U IO
 X ^%ZOSF("MAGTAPE")
 W @%MT("REW")
 KILL %MT
 U IO(0)
 W !!,"Mount The ",ACHSMSG," Tape 'WRITE PROTECTED' And "
RETRY ;
 KILL DIR
 W !!
 S DIR(0)="E",DIR("A")="Press RETURN When Ready or '^' to Exit"
 D ^DIR
 I $D(DTOUT)!$D(DUOUT)!$D(DIROUT) W !!,"Job ABORTED by Operator During Tape Mount" G ABEND^AZZZEOB
 U IO(0)
 W !!,"Opening ",ACHSMSG
 F I=1:1:75 U IO X ^%ZOSF("MTONLINE") G S9:Y U IO(0) W "." H 5
 U IO(0)
 W !!,"Job Aborted, Tape not Ready After 6 Minutes"
 G ABEND^AZZZEOB
 ;
S9 ;
 U IO
 X ^%ZOSF("MTWPROT")
 I 'Y U IO(0) W *7,!!,"  The Tape Is NOT WRITE PROTECTED. Please Remove The Tape,",!,"  And Re-position The Write Protect/Enable Switch.",! G RETRY
 U IO(0)
 W !,"Please Standby - Reading Data From ",ACHSMSG
 G RDHDR^AZZZEOB
 ;
