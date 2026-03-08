BRARPT7 ;IHS/HIRMFO/MAW IHS/OIT/NST - Queue/print Radiology Report utility; Feb 26, 2023@14:18
 ;;5.0;Radiology/Nuclear Medicine;**1010,1011**;Mar 16, 1998;Build 1
SELECT ;EP - Select a Report to test with
 ;
 N DIWL,DIWR,DIWP,DIC,DIE
 N RARPT,RAP
 W #
 W !
 W "This will test the revised writing out of a Radiology Report."
 W !
 S DIWL=3,DIWR=75,DIWP="|WC75"
 ;
 S DIC=74,DIC(0)="AEQMZ"
 D ^DIC
 ;
 I Y<1 K RARPT,RAP,RAV Q
 S RARPT=+Y
 ;
 W !
 D ^%ZIS
 I $G(POP)=1 K RARPT,RAP,RAV,RAXX,RASTRIP,RALEN Q
 U IO
 ;
 W !,"Report Text: ",!
 S RAP="R"
 D PRINT
 ;
 W !,"Impression Text: "
 S RAP="I"
 D PRINT
 ;
 X ^%ZIS("C")
 ;
 I $E(IOST)="C" K DIR S DIR(0)="EO" D ^DIR K DIR
 G SELECT
 ;
PRINT ;EP - Print it
 ;
 ;
 N RAV,RAXX,RASTRIP,RALEN,X,Y
 S RAXX="",RASTRIP="",X=""
 ;
 S RAV=0
 F  S RAV=$O(^RARPT(RARPT,RAP,RAV)) Q:RAV'>0  D  Q:X="^"!(X="P")!(X="T")
 . S RAXX=$G(^RARPT(RARPT,RAP,RAV,0))
 . ;
 . ;If we need to strip a space, do it here
 . I RASTRIP=1,$E(RAXX,1)=" " S RAXX=$E(RAXX,2,999) S RASTRIP=""
 . ;
 . ;After adjusting the space characters above, check if first
 . ;character is a space.  If so, write on its own line.
 . I $E(RAXX,1)=" " S X=RAXX D ^DIWP S X="" Q
 . ;
 . ;Treat a null line as if it were a blank line
 . ;
 . I RAXX="" S X=" " D ^DIWP S X="" S RASTRIP="" Q
 . S X=""
 . D WAIT^RART1:($Y+6)>IOSL&('$D(RARTVERF)) Q:X="^"!(X="P")!(X="T")
 .;
 .;If the last character is not a space, then check the next line.
 .;If that line does not begin with a space, add one to this line.
 .;And set RASTRIP so we strip the next line.
 .S RALEN=$L(RAXX)
 .I $E(RAXX,RALEN)'=" ",$E($G(^RARPT(RARPT,RAP,RAV+1,0)),1)=" " S X=RAXX_" " D ^DIWP S X="" S RASTRIP=1 Q
 .;
 .;If the last character is a space, then check the next line.
 .;If that line begins with a space, write out what we have.
 .I $E(RAXX,RALEN)=" ",$E($G(^RARPT(RARPT,RAP,RAV+1,0)),1)=" " S X=RAXX D ^DIWP S X="" Q
 .;
 .;If we make it here, just write out what we have
 .;so the next line begins all the way to the left in position 2.
 . S X=RAXX
 . D ^DIWP
 . S X=""
 . Q
 ;
 Q:X="^"
 D ^DIWW:$D(RAXX)
 ;
 Q
 ;
 ;
WRTRT1 ;EP - Revised Printing to replace WRITE^RART1
 ;
 ;The original call is  from around DISP1+56 in RART1
 ;We intercept the processing there and redirect to here
 ;
 ;Patch 1009 set DIWF="|N" - this should be tested
 ;
 N RAV,RAXX,RASTRIP,RALEN,X,Y
 S RAXX="",RASTRIP="",X=""
 ;
 S RAV=0
 F  S RAV=$O(^RARPT(RARPT,RAP,RAV)) Q:RAV'>0  D  Q:X="^"!(X="P")!(X="T")
 . ;
 . S RAXX=$G(^RARPT(RARPT,RAP,RAV,0))
 . S X=""
 . ;
 . D WAIT^RART1:($Y+6)>IOSL&('$D(RARTVERF))
 . Q:X="^"!(X="P")!(X="T")
 . ;
 . ;If we need to strip a space, do it here
 . I RASTRIP=1,$E(RAXX,1)=" " S RAXX=$E(RAXX,2,999) S RASTRIP=""
 . ;
 . ;After any stripping above, check if the first character
 . ;is a space.  If so, write it on its own line
 . I $E(RAXX,1)=" " S X=RAXX D ^DIWP S X="" Q
 . ;
 . ;Treat a null line as if it were a blank line
 . I RAXX="" S X=" " D ^DIWP S X="" S RASTRIP="" Q
 . ;
 . ;If the last character on the current line is not a space,
 . ;then check the next line.  If that line begins with
 . ;a space, then add one to this line, and set RASTRIP=1
 . ;to strip that leading space when the next line is processed.
 . S RALEN=$L(RAXX)
 . I $E(RAXX,RALEN)'=" ",$E($G(^RARPT(RARPT,RAP,RAV+1,0)),1)=" " S X=RAXX_" " D ^DIWP S X="" S RASTRIP=1 Q
 . ;
 . ;If the last character is a space, then check the next line.
 . ;If that line begins with a space, then write out what we have.
 . I $E(RAXX,RALEN)=" ",$E($G(^RARPT(RARPT,RAP,RAV+1,0)),1)=" " S X=RAXX D ^DIWP S X="" Q
 . ;
 . ;If we make it here, just write out what we have so the next
 . ;line begins left justified.
 . S X=RAXX D ^DIWP S X="" Q
 ;
 ;If we fall through to here, make the DIWW call
 Q:X="^"
 D ^DIWW:$D(RAXX)
 ;
 Q
 ;
 ;
SETTR2 ;EP - Revised Printing to replace SET^RARTR2
 ;
 ;Set RARTR2 is called from RAO7PC3
 ;We intercept the processing in the SET^RARTR2 routine
 ;
 ;Patch 1009 set DIWF="|N" - this should be tested
 ;
 N RAV,RAXX,RASTRIP,RALEN,X,Y
 S RAXX="",RASTRIP="",X=""
 ;
 S RAPX=$S(RAP="AH":"H",1:RAP)
 ;
 S RAX=0
 F  S RAX=$O(^RARPT(RARPT,RAPX,RAX)) Q:RAX'>0  D
 . ;
 . S RAXX=$G(^RARPT(RARPT,RAPX,RAX,0))
 . S X=""
 . ;
 . ;If we need to strip a space, do it here
 . I RASTRIP=1,$E(RAXX,1)=" " S RAXX=$E(RAXX,2,999) S RASTRIP=""
 . ;
 . ;After any stripping above, check if the first character
 . ;is a space.  If so, write it on its own line
 . I $E(RAXX,1)=" " S X=RAXX D ^DIWP S X="" Q
 . ;
 . ;Treat a null line as if it were a blank line
 . I RAXX="" S X=" " D ^DIWP S X="" S RASTRIP="" Q
 . ;
 . ;If the last character on the current line is not a space,
 . ;then check the next line.  If that line begins with
 . ;a space, then add one to this line, and set RASTRIP=1
 . ;to strip that leading space when the next line is processed.
 . S RALEN=$L(RAXX)
 . I $E(RAXX,RALEN)'=" ",$E($G(^RARPT(RARPT,RAP,RAX+1,0)),1)=" " S X=RAXX_" " D ^DIWP S X="" S RASTRIP=1 Q
 . ;
 . ;If the last character is a space, then check the next line.
 . ;If that line begins with a space, then write out what we have.
 . I $E(RAXX,RALEN)=" ",$E($G(^RARPT(RARPT,RAP,RAX+1,0)),1)=" " S X=RAXX D ^DIWP S X="" Q
 . ;
 . ;If we make it here, just write out what we have so the next
 . ;line begins left justified.
 . S X=RAXX D ^DIWP S X="" Q
 ;
 Q
 ;
 ;
WRTTR2 ;EP - Revised printing to replace WRITE^RARTR2
 ;
 ;WRITE^RARTR2 is called from RAO7PC3
 ;We intercept the processing in WRITE^RARTR2
 ;
 ;Patch 1009 set DIWF="|N" - this should be tested
 ;
 N RAV,RASTRIP,RALEN,X,Y
 S RASTRIP="",X=""
 ;
 S ZRAP=$S(RAP="AH":"H",1:RAP)
 ;
 S RAV=0
 F  S RAV=$O(^RARPT(RARPT,ZRAP,RAV)) Q:RAV'>0  D  Q:$D(RAOOUT)
 . ;
 . S RAXX=$G(^RARPT(RARPT,ZRAP,RAV,0))
 . S X=""
 . ;
 . I ($Y+RAFOOT+4)>IOSL D  Q:$D(RAOOUT)
 . . D HANG^RARTR2
 . . Q:$D(RAOOUT)
 . . I $E(IOST)="P" D HD^RARTR
 . ;
 . ;If we need to strip a space, do it here
 . I RASTRIP=1,$E(RAXX,1)=" " S RAXX=$E(RAXX,2,999) S RASTRIP=""
 . ;
 . ;After any stripping above, check if the first character
 . ;is a space.  If so, write it on its own line
 . I $E(RAXX,1)=" " S X=RAXX D ^DIWP S X="" Q
 . ;
 . ;Treat a null line as if it were a blank line
 . I RAXX="" S X=" " D ^DIWP S X="" S RASTRIP="" Q
 . ;
 . ;If the last character on the current line is not a space,
 . ;then check the next line.  If that line begins with
 . ;a space, then add one to this line, and set RASTRIP=1
 . ;to strip that leading space when the next line is processed.
 . S RALEN=$L(RAXX)
 . I $E(RAXX,RALEN)'=" ",$E($G(^RARPT(RARPT,RAP,RAV+1,0)),1)=" " S X=RAXX_" " D ^DIWP S X="" S RASTRIP=1 Q
 . ;
 . ;If the last character is a space, then check the next line.
 . ;If that line begins with a space, then write out what we have.
 . I $E(RAXX,RALEN)=" ",$E($G(^RARPT(RARPT,RAP,RAV+1,0)),1)=" " S X=RAXX D ^DIWP S X="" Q
 . ;
 . ;If we make it here, just write out what we have so the next
 . ;line begins left justified.
 . S X=RAXX D ^DIWP S X="" Q
 ;
 Q
