AZZZEOB9 ; IHS/ADC/GTH - AREA WRITE EOBR FILES FOR FACILITIES (2/2) ; [ 09/17/97   9:12 AM ]
 ;;3.0;CONTRACT HEALTH MGMT SYSTEM;**10**;SEP 17, 1997
 ;
DSM ;
 U IO(0)
 KILL DIR
 W !!!!
 S DIR(0)="S^T:TAPE;C:CARTRIDGE;A:ABORT THE PROCESS",DIR("B")=ACHSMDIA,DIR("A")="Copy the "_$P(^DIC(4,ACHSPFAC,0),U,1)_" EOBR file to",DIR("?")="Which Media do you wish the EOBR file copied to?"
 D ^DIR
 I $D(DTOUT)!$D(DIROUT)!$D(DUOUT)!(Y["A") W !!,"Job TERMINATED by Operator at Device Select" S ACHSFLG=1 K DIR G CLOSE^AZZZEOB8
 S ACHSMED=Y
 G TAPEDSM:"Tt"[ACHSMED,CARTDSM:"Cc"[ACHSMED
CARTDSM ;
 S IO=47,ACHSMSG="Cartridge"
 G GO
 ;
TAPEDSM ;
 S IO=48,ACHSMSG="9-Track"
GO ; 
 S IOP=IO
 D ^%ZIS
 KILL IOP
 I POP S ACHSMSG=ACHSMSG_" NOT AVAILABLE" G ERR
 U IO
 X ^%ZOSF("MAGTAPE")
 W @%MT("REW")
 KILL %MT
 U IO(0)
 W !!,"Mount The ",ACHSMSG," Tape 'WRITE ENABLED' And "
RETRY ;
 KILL DIR
 W !!
 S DIR(0)="E",DIR("A")="Press RETURN When Ready or '^' to Exit "
 D ^DIR
 I $D(DTOUT)!$D(DIROUT)!$D(DUOUT) W !!,"Job ABORTED by Operator During Tape Mount." S ACHSFLG=1 K DIR G CLOSE^AZZZEOB8
 U IO
 X ^%ZOSF("MTONLINE")
 I 'Y U IO(0) W !!,"WAITING FOR TAPE"
 F I=1:1:75 U IO X ^%ZOSF("MTONLINE") G S9:Y U IO(0) W "." H 5
 U IO(0)
 W !!,"Job Aborted, Tape not Ready After 6 Minutes"
 S ACHSFLG=1
 G CLOSE^AZZZEOB8
 ;
S9 ; Check write protect, copy to tape, rewind tape.
 U IO
 X ^%ZOSF("MTWPROT")
 I Y U IO(0) W *7,!!,"  The Tape Is WRITE PROTECTED. Please Remove The Tape,",!,"  And Re-position The Write Protect/Enable Switch.",! G RETRY
 U IO(0)
 W !,"Please Standby - Copying Data to ",ACHSMSG
 D SAVE^AZZZEOB8
 S $P(^ACHSAOP(DUZ(2),16,ACHSPFAC,0),U,4)=ACHSEBSQ
 X ^%ZOSF("MAGTAPE")
 U IO
 W @%MT("WTM")
 W @%MT("REW")
 KILL %MT
 U IO(0)
 W !!,"Rewinding tape. <WAIT>"
 F L=1:1:150 U IO X ^%ZOSF("MTBOT") G:Y GOODREW U IO(0) W "." H 2
 U IO(0)
 W !!,"Tape not rewound",*7
 S ACHSFLG=1
 G CLOSE^AZZZEOB8
 ;
GOODREW ; Rewind successful.
 U IO(0)
 W !!,"Please Remove the Tape..."
ERR ; Error in tape rewind.
 G CLOSE^AZZZEOB8
 ;
