BEHOEPR3 ;GDIT/HS/TJB - EPCS Audit Summary Report;24-Sep-2018 11:36;PLS
 ;;1.1;BEH COMPONENTS;**070001**;Mar 20, 2007;Build 10
 ;
 Q
EN ;EP - EPCS/Pharmacy Edit Threshold Variables for Daily IncidentReport
 N TITLE,T2,X,Y,Z,QQ,VAR,VAR1,V2,P1,H1,H2,P,DAR,ZARR,LARR,ZPRO,ZX,PC,CD,CW,CA,SV S TITLE="Daily Incident Threshold Variable Edit"
 D HL(TITLE)
 S P1="Selection (1/2) "
 S P(1)="Enter '1' for EPCS or '2' for Pharmacy variables."
 S VAR=$$READ("SO^1:EPCS Variables;2:Pharmacy Variables",P1,"","Enter '1' for EPCS or '2' for Pharmacy variables.","",.P)
 Q:(VAR="^")!(VAR="^^")
 I VAR="1" S T2="Editing the EPCS Variables"
 I VAR="2" S T2="Editing the Pharmacy Variables"
EN1 ; Get list of variables for possible editing
 K ZARR
 D GETVARS("ZARR",$S(VAR=1:"E",VAR=2:"P",1:"E"))
 ;
 I $D(ZARR)>1 D
 . N SP1,SP2 S $P(SP1," ",46)=" ",$P(SP2," ",30)=" "
 . S ZPRO="SO^"
 . S LARR(0)=""
 . S LARR(1)="Select one of the following variables to modify: "
 . S LARR(2)=""
 . S LARR(3)="    Variable name                           Default Value          Site Value"
 . S LARR(4)="=============================================================================="
 . S X=5,Z=0 F  S Z=$O(ZARR(Z)) Q:Z=""  D
 . . S PC=$S($P(ZARR(Z),U,5)="P":"%",1:" "),CD=$S($P(ZARR(Z),U,5)="P":2,1:0),CW=$S($P(ZARR(Z),U,5)="P":7,1:4),CA=$S($P(ZARR(Z),U,5)="P":"",1:"   ")
 . . I $P(ZARR(Z),U,4)'="" S SV=$J($P(ZARR(Z),U,4),CW,CD)_CA_PC ; Set the site value if not empty
 . . E  S SV="  -  " ; Empty site value
 . . S LARR(X)=$J(Z,2)_"  "_$P(ZARR(Z),U,1)_$E(SP1,1,(43-$L($P(ZARR(Z),U,1))))_$J($P(ZARR(Z),U,3),CW,CD)_CA_PC_$E(SP2,1,(21-$L(SV)))_SV
 . . S ZPRO=ZPRO_Z_":"_$P(ZARR(Z),U,2)_";"
 . . S X=X+1
 . . Q
 . Q
 S P1="Enter the number of variable to modify ",QQ="",QQ=$O(ZARR(QQ),-1)
 S H1="Select a variable to modify '1 - "_QQ_"'"
 D HL(TITLE,T2)
 S VAR1=$$READ(ZPRO,P1,"",H1,"","",.LARR)
 Q:(VAR1="^^")  G:(VAR1="^") EN ; "^^" Exit routine; "^" Go back to beginning
 I $P(ZARR(VAR1),U,5)="P" D
 . S P1="Enter a number, up to 2 decimals : "
 . S H2="Please enter a number with up to 2 decimal values "
 . S ZPRO="NA^-1:1000:2"
 I $P(ZARR(VAR1),U,5)="I" D
 . S P1="Enter an integer number with no decimals : "
 . S H2="Please enter an integer number with no decimals values "
 . S ZPRO="NA^-1:1000"
 S:$P(ZARR(VAR1),U,6)]"" H2=$P(ZARR(VAR1),U,6)
 S ZX=1,DAR(ZX)="Modifying the Site defined value: ",ZX=ZX+1
 S DAR(ZX)=$P(ZARR(VAR1),U,1)_"     Default Value: "_$P(ZARR(VAR1),U,3)
 S:+($P(ZARR(VAR1),U,4))>0 DAR(ZX)=DAR(ZX)_"     Current Site Value: "_$P(ZARR(VAR1),U,4),ZX=ZX+1,DAR(ZX)="To delete the existing Site Value enter '@'"
 S V2=$$READ(ZPRO,P1,"",H2,"",.DAR,"","I X=""@"" S X=-1")
 Q:(V2="^^")  G:(V2="^") EN1 ; "^^" Exit routine; "^" Go back to beginning
 S:V2<0 V2="@"
 D FILE("ZARR",VAR1,V2)
 G EN1
 Q
 ;
HL(TITLE,LN2) ; Head line
 ; TITLE = This line and date will appear on top line
 ; If LN2 is not empty then this will be displayed on the second line
 N ZDT,HZ
 S ZDT=$$FMTE^XLFDT($$DT^XLFDT,"D")
 S HZ=80-$L(ZDT)
 W @IOF,TITLE,?HZ,ZDT
 I $G(LN2)]"" S HZ=80-$L(LN2)\2 W !,?HZ,LN2
 Q
 ;
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA,DIRL,DIRP) ;EP - calls reader, returns response
 ; DIR Read type See ^DIR documentation
 ; PROMPT - The prompt to display to the user
 ; DEFAULT - Default value for the read
 ; HELP - What to display if user types "?" or "??"
 ; SCREEN - Used for pointer, set of code and list/range reads (See ^DIR documentation for DIR("S"))
 ; DIRA - Used for extended prompt displayed before PROMPT read (See ^DIR documentation for DIR("A",#))
 ; DIRL - Used for developer specified format of reads (See ^DIR documentation DIR("L"))
 ; DIRP - Used for DIR("PRE") processing the read (See ^DIR documentation DIR("PRE"))
 N DIR,Y,DIRUT,DIROUT,DUOUT,DLAYGO,DTOUT
 S DIR(0)=TYPE
 I $E(TYPE,1)="P",$P(TYPE,":",2)["L" S DLAYGO=+$P(TYPE,U,2)
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(DIRP) S DIR("PRE")=DIRP
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 I $D(DIRL)>1 S Y="" F  S Y=$O(DIRL(Y)) Q:Y=""  S:Y'=0 DIR("L",Y)=DIRL(Y) S:Y=0 DIR("L")=DIRL(Y)
 D ^DIR
 ; ZW DTOUT,DUOUT,DIRUT,DIROUT
 I $G(DTOUT) S Y="^" ; Timed out
 I $G(DUOUT),$G(DIRUT) S Y="^" ; User entered "^" - set go back
 I '$D(DTOUT),$G(DIRUT) S Y="^" ; User hit <ENTER> - set go back
 I $G(DIROUT) S Y="^^" ; Set this to exit.
 Q Y
 ;
GETVARS(ARR,V) ; Get Default values for the threshold variables from file 90460.13
 N SCRN,ZOUT,ZZ,LN
 I $G(V)="" Q  ; No screen variable exit
 Q:",E,P,"'[(","_V_",")  ; Quit if screen variable is not "E" or "P"
 S SCRN="I $P(^(0),U,4)="""_V_"""" ; Screening logic to grab the correct variables
 K ZOUT D LIST^DIC(90460.13,"",".01;.02;.05;.06;.07I;.08","P",,,,,SCRN,"","ZOUT")
 S ZZ=0 F  S ZZ=$O(ZOUT("DILIST",ZZ)) Q:ZZ=""  D
 . S LN=ZOUT("DILIST",ZZ,0)
 . S @ARR@(ZZ)=$P(LN,U,3)_U_$P(LN,U,4)_U_$P(LN,U,5)_U_$P(LN,U,6)_U_$P(LN,U,7)_U_$P(LN,U,8)
 . Q
 Q
 ;
FILE(ARR,N1,N2) ; File any changes back into the database.
 ; ARR = Array of variables to check
 ; N1 = Index into ARR to modify
 ; N2 = Value to update
 N IT1,ZIEN,ZFLD,ZERR,ZFDA
 S IT1=$P(@ARR@(N1),U,1) ; Get the name of the variable to modify
 S ZIEN=$$FIND1^DIC(90460.13,"","B",IT1)
 K ZFDA
 S ZFDA(90460.13,ZIEN_",",.03)=DUZ
 S ZFDA(90460.13,ZIEN_",",.06)=N2
 K ZERR D FILE^DIE("","ZFDA","ZERR")
 I $D(ZERR) W !!,"*** ERROR filing data...",!," ERROR Code: ",$G(ZERR("DIERR",1)),!," Error Message: ",$G(ZERR("DIERR",1,"TEXT",1)) Q
 Q
 ;
