DDS3 ;SFISC/MLH-COMMAND UTILS ;02:46 PM  22 Feb 1995 [ 09/10/1998  11:17 AM ]
 ;;21.0;VA Fileman;**1007**;SEP 08, 1998
 ;;21.0;VA FileMan;**4**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 I Y(0)]"","ECNRS"[$E(Y(0)) D @$E(Y(0))
 Q
 ;
S ;Save the form
 D ^DDS4,R^DDSR
 D:$D(DDSBR)#2 BR^DDS2
 Q
 ;
R ;Repaint all pages on current screen
 ;Called after wp, mults, and deletions
 G R^DDSR
 ;
E ;
 I DDSSC>1!'DDSCHG!$P(DDSSC(DDSSC),U,4) S DDACT="Q" Q
 S DDM=1
 K DIR S DIR(0)="YO"
 S DIR("A")=$$EZBLD^DIALOG(8075)
 D BLD^DIALOG(9037,"","","DIR(""?"")")
 S DIR0=IOSL-1_U_($L(DIR("A"))+1)_"^3^"_(IOSL-1)_"^0"
 D ^DIR
 K DIR,DUOUT,DIROUT,DIRUT
 ;
 I Y=0!$D(DTOUT)!$D(DUOUT) D QT Q
 I Y="" S DDACT="N" Q
 I Y=1 D EX
 Q
N ;
 S:DDSNP]"" DDSPG=DDSNP,DDACT="NP"
 Q
C ;
 S DDACT="Q"
 Q
 ;
QT ;Exit, don't save
 G:DDSSC>1!$G(DDSSEL)!$P(DDSSC(DDSSC),U,4) ERR1
 I $G(DDSDN)=1,DDO G ERR3
 S DDACT="Q" Q:'DDSCHG
 D DEL^DDS6
 S DX=0,DY=IOSL-1 X IOXY
 W $P(DDGLCLR,DDGLDEL),$S($D(DTOUT):$$EZBLD^DIALOG(8076),1:"")_$$EZBLD^DIALOG(8077) H 1
 Q
 ;
EX ;Exit, save
 G:DDSSC>1!$G(DDSSEL)!$P(DDSSC(DDSSC),U,4) ERR1
 I $G(DDSDN)=1,DDO G ERR3
 S DDACT="Q"
 D ^DDS4 I 'Y S DDACT="N" D R D:$D(DDSBR)#2 BR^DDS2
 Q
CL ;Close
 I DDSSC'>1,'$G(DDSSEL),'$P(DDSSC(DDSSC),U,4) G ERR2
 I $G(DDSDN)=1,DDO G ERR3
 G E
 ;
TO ;Time-out
 I DDO,$G(DDSDN) S DDACT="N" G CURSOR^DDS01
 I DDO S DDSOSV=DDO,DDO=0
 E  D E
 Q
 ;
ERR1 ;Print error message
 D MSG^DDSMSG("You must press <PF1>C to close this page.",1)
 S DDACT="N"
 Q
 ;
ERR2 ;
 D MSG^DDSMSG("You must press <PF1>Q or <PF1>E to leave the form.",1)
 S DDACT="N"
 Q
 ;
ERR3 ;
 D MSG^DDSMSG("Since navigation for the block is disabled, that key sequence is disabled.",1)
 S DDACT="N"
 Q
 ;
 ;#8075  Save changes before leaving form (Y/N)?
 ;#8076  Time out.
 ;#8077  Changes not saved!
 ;#9037  Enter 'Y' to save before exiting...(3 lines)
