BUSAAUT ;GDIT/HS/BEE-BUSA Archive Utility Calls ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**3**;Nov 05, 2013;Build 47
 ;
 Q
 ;
DEVICE(MODE,PATH,FNAME) ;EP - Open to 'R'ead, Open to 'W'rite, 'C'lose or 'D'elete
 ; temporary file designed for use when converting report text to RPC
 ; data strings. Note that UID and DFN are components of the file name.
 ;
 ; Input
 ;    MODE(Required) - 'R'(Read),'W'(Write),'C'(Close),'D'(Delete)
 ;    UID(Req'd for modes D,R,W) - Job identifier
 ;    DFN(Req'd for modes D,R,W) - Patient IEN
 ; Output
 ;    POP - 0 for success, 1 for failure
 ;
 NEW POP,EXEC,SC
 ;
 S POP=1
 ;
 ;Make sure a valid mode was entered
 S MODE=$G(MODE)
 I MODE'="R",MODE'="C",MODE'="W",MODE'="D" W !!,"INVALID MODE VALUE ENTERED",! Q 1
 ;
 ;Validate Path
 I $G(PATH)="" W !!,"MISSING PATH",! Q 1
 S EXEC="S SC=##class(%File).DirectoryExists(PATH)" X EXEC
 I 'SC W !!,"DIRECTORY '",PATH,"' DOES NOT EXIST.",! Q 1
 ;
 ;Validate FileName
 I $G(FNAME)="" W !!,"MISSING FILENAME",! Q 1
 ;
 ;Close a file.
 I MODE="C" D CLOSE^%ZISH("BUSAFILE")
 ;
 ;Delete a file
 I MODE="D" S POP=$$DEL^%ZISH(PATH,FNAME)
 ;
 ;Read from or Write to a file.
 I (MODE="R")!(MODE="W") D
 .D OPEN^%ZISH("BUSAFILE",PATH,FNAME,MODE)
 ;
 Q POP
 ;
 ;This tag prompts the user for a path to save the archive file in
 ;
PATH(TYPE) ;Select path location
 ;
 NEW DIR,DA,X,Y,DTOUT,DUOUT,DIROUT,EXEC,SC,HSPATH
 ;
 I $G(TYPE)="W" W !!,"Enter the path of the folder to place the archive file(s) in. Since the"
 I $G(TYPE)="R" W !!,"Enter the path of the folder which contains the archive file(s). Since the"
 W !,"generated files contain patient information, please ensure the location"
 W !,"is encrypted and accessible by only the appropriate personnel.",!
 ;
 ;Pull the default location
 S HSPATH=$$DEFDIR^%ZISH("")
 ;
 ;Look for default
PATH1 S:HSPATH]"" DIR("B")=HSPATH
 S:$G(DIR("B"))="" DIR("B")=$$GET1^DIQ(9999999.39,"1,",2)
 ;
 ;Prompt for path
 S DIR(0)="F^1:80"
 D ^DIR
 I $G(DTOUT)!$G(DUOUT)!$G(DIROUT) Q "" ;Timed out or "^"
 ;
 ;Removed/skipped
 I Y="" W !,"<REQUIRED>" H 2 G PATH1
 ;
 S EXEC="S SC=##class(%File).DirectoryExists(Y)" X EXEC
 I 'SC W !!,"DIRECTORY '",Y,"' DOES NOT EXIST. PLEASE ENTER A VALID LOCATION",! G PATH1
 ;
 ;Update
 Q Y
 ;
LM(LST,RDT) ;Return last x months date
 ;
 NEW X1,X2,X,CDAY,CD,CM,CY,CC,%DT,Y,FDT,CT,II
 ;
 ;Get previous date
 S X1=RDT,X2=-1 D C^%DTC
 S CDAY=RDT
 ;
 ;Get the current month,year,day
 S CM=$E(CDAY,4,5),CD=$E(CDAY,6,7)
 S CC=$E(CDAY,1),CY=$E(CDAY,2,3)
 S CY=$S(CC=1:18,CC=2:19,CC=3:20,CC=4:21,1:00)_CY
 ;
 ;Back up by number of months
 F CT=LST:-1:1 S CM=CM-1 I CM<1 S CM=12,CY=CY-1
 ;
 ;Check if date is month end, return month end
 S X1=RDT,X2=1 D C^%DTC
 S %DT="X" D ^%DT
 I Y<0 D  Q X
 . S FDT="" F II=31:-1:28 D  Q:FDT]""
 .. S X=CM_"/"_II_"/"_CY
 .. S %DT="X" D ^%DT
 .. I Y>0 S FDT=1,X=Y Q
 ;
 ;Not month end back up until valid date
 S FDT="" F  D  Q:FDT]""
 . S X=CM_"/"_CD_"/"_CY
 . S %DT="X" D ^%DT
 . I Y>0 S FDT=1,X=Y Q
 . S CD=CD-1 I CD=0 S FDT=1,X=""
 ;
 Q X
 ;
SIZE() ;Return the approximate archive file size
 ;
 NEW SIZE,DIR,DTOUT,DUOUT,DIRUT,DIROUT,X,Y
 ;
 S SIZE=""
 ;
 W !!,"Enter the approximate file size for each archive file in this archive set."
 W !,"The archive process will automatically create a new file when the archive"
 W !,"output has reached this approximate file size. The response should be "
 W !,"entered in MegaBytes (MB), omitting commas and fractional values."
 W !,"The mininum file size is 10 MB and the maximum file size is 10000 MB."
 W !,"As a reference a standard CD holds approximately 740 MB and a single"
 W !,"sided DVD holds approximately 4700 MB.",!
 ;
 S DIR(0)="NA:10:10000:0"
 S DIR("A")="Enter the approximate size of each archive file in MegaBytes (MB): "
 S DIR("B")="10"
 D ^DIR
 I ($G(DTOUT)]"")!($G(DUOUT)]"")!($G(DIRUT)]"")!($G(DIROUT)]"") Q ""
 I ('Y)!(Y<0) Q ""
 ;
 S SIZE=Y*1000000
 ;
 Q SIZE
