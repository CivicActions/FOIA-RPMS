BUSAPFA ;GDIT/HS/BEE-Partial FileMan Auding ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**5**;Nov 05, 2013;Build 42
 ;
 Q
 ;
DEF W !!,"This option will allow a site to define a list of files and fields"
 W !,"that they would like to set up for BUSA FileMan auditing. Note, that"
 W !,"due to the increased space requirements for auditing files, the"
 W !,"number of files and fields entered in this definition should be kept"
 W !,"to a mininum."
 ;
 NEW CONT
 ;
 ;Prompt to continue
 S CONT=$$CONT("Would you like to edit the files and fields to be BUSA/FileMan audited","NO") I CONT'=1 Q
 ;
 ;Prompt for the file
 S CONT=$$FILE()
 ;
 Q
 ;
FILE() ;Add, edit, remove files
 ;
 NEW ACT,FILE,CONT,FIEN,FDIEN,QUIT,ALL
 ;
FILE1 ;Get the file
 S (ACT,FILE,FIEN)=""
 S CONT=$$EFILE(.ACT,.FILE,.FDIEN) I CONT=-1 Q -1
 I ACT="Q" Q 1
 I $G(FILE)="" Q -1
 ;
 ;See if file already has audits
 S FIEN=$O(^BUSAPFMN("B",FDIEN,""))
 I ACT="A",FIEN]"" W !!,"<File ",FILE," is already set up for auditing. Please use the Edit Option>" H 3 G FILE1
 I ACT="E",FIEN="" W !!,"<File ",FILE," has not been set up for auditing. Please use the Add Option>" H 3 G FILE1
 I ACT="R",FIEN="" W !!,"<File ",FILE," has not been set up for auditing>" H 3 G FILE1
 ;
 ;If add create entry stub
 I ACT="A" S FIEN=$$FSTUB(FDIEN) Q:FIEN="" -1
 ;
 ;Remove
 I ACT="R" S CONT=$$REMF(FIEN) G:CONT'=-1 FILE1 Q:CONT=-1 -1
 ;
 ;Prompt for all entries
 S (QUIT,ALL)="" D  I QUIT Q -1
 . NEW DA,DIE,DR,X,Y,DTOUT,BDESC,BSTATUS,IFILE,OALL
 . ;
 . ;Set up initial BUSA entry
 . S IFILE=$$GET1^DIQ(9002319.14,FIEN_",",.01,"I")
 . I ACT="A" D
 .. S BDESC="BUSA: "_FILE
 .. S BDESC=BDESC_" file registered for partial auditing - no fields set up yet to be audited"
 .. S BDESC=BDESC_"||||||BUSA09|"_$G(IFILE)
 .. S BSTATUS=$$BYPSLOG^BUSAAPI("A","S","A","BUSAPFAF",BDESC,"",1)
 . S DA=FIEN
 . ;
 . ;Get the old ALL value
 . S OALL=+$$GET1^DIQ(9002319.14,FIEN_",",.02,"I")
 . S DIE="^BUSAPFMN("
 . S DR=".02"
 . D ^DIE
 . I ($G(X)="")!($G(X)="^") S QUIT=1 Q
 . S ALL=$G(X)
 . ;
 . ;If it was ALL, now NO create BUSA entry
 . I OALL,'ALL D  Q
 .. ;
 .. NEW BDESC,BSTATUS
 .. ;
 .. ;Log the entry
 .. S BDESC="BUSA: "_FILE
 .. S BDESC=BDESC_" file set up for partial auditing - NO fields"
 .. S BDESC=BDESC_"||||||BUSA11|"_$G(IFILE)
 .. S BSTATUS=$$BYPSLOG^BUSAAPI("A","S","D","BUSAPFAF",BDESC,"",1)
 .. ;
 .. I $O(^BUSA(9002319.04,"S","F",1,""))]"" W !!,"*Note - FileMan Auditing must be turned off and back on for this to take full effect",!
 .. D AKEY^BUSAPFA
 . ;
 . ;If ALL, remove underlying fields
 . I ALL=1 D
 .. ;
 .. ;Log the entry
 .. S BDESC="BUSA: "_FILE
 .. S BDESC=BDESC_" file set up for partial auditing - ALL fields"
 .. S BDESC=BDESC_"||||||BUSA10|"_$G(IFILE)
 .. S BSTATUS=$$BYPSLOG^BUSAAPI("A","S","A","BUSAPFAF",BDESC,"",1)
 .. ;
 .. I $O(^BUSA(9002319.04,"S","F",1,""))]"" W !!,"*Note - FileMan Auditing must be turned off and back on for this to take full effect",!
 .. D AKEY^BUSAPFA
 .. ;
 .. NEW II,DA,DIK
 .. S DA(1)=FIEN
 .. S II=0 F  S II=$O(^BUSAPFMN(FIEN,1,II)) Q:'II  D
 ... S DIK="^BUSAPFMN("_DA(1)_",1,"
 ... S DA=II
 ... D ^DIK
 ;
 I ALL G FILE1
 ;
 ;Not all entries - look at fields
 S CONT=$$FAUD^BUSAPFAF(FIEN,FILE) Q:CONT=-1 -1
 ;
 G FILE1
 ;
FSTUB(FDIEN) ;Create file stub
 ;
 NEW DIC,DLAYGO,X,Y,FIEN,DA
 ;
 S DIC(0)="LX",DLAYGO=9002319.14,DIC="^BUSAPFMN("
 S X=FDIEN
 K DO,DD D FILE^DICN
 S FIEN=+$G(Y) I FIEN<1 D  Q ""
 . W !!,"<Unable to create a new audit file entry>"
 . H 3
 ;
 Q FIEN
 ;
REMF(FIEN) ;Remove file audit entry
 ;
 NEW DA,DIK,CONT,FILE,BDESC,BSTATUS,IFILE
 ;
 ;Prompt to remove
 S CONT=$$CONT("Are you sure you want to remove this file from the audit list","NO") I CONT=-1 Q -1
 I CONT=0 Q 1
 ;
 S IFILE=$$GET1^DIQ(9002319.14,FIEN_",",.01,"I")
 S FILE=$$GET1^DIQ(9002319.14,FIEN_",",.01,"E")
 ;
 S DA=FIEN,DIK="^BUSAPFMN("
 D ^DIK
 W !!,"File has been removed from the list of audited files" H 2
 ;
 ;Log the entry
 S BDESC="BUSA: "_FILE
 S BDESC=BDESC_" file removed from partial auditing"
 S BDESC=BDESC_"||||||BUSA11|"_$G(IFILE)
 S BSTATUS=$$BYPSLOG^BUSAAPI("A","S","D","BUSAPFAF",BDESC,"",1)
 ;
 I $O(^BUSA(9002319.04,"S","F",1,""))]"" W !!,"*Note - FileMan Auditing must be turned off and back on for this to take full effect",!
 D AKEY^BUSAPFA
 ;
 Q 1
 ;
EFILE(ACT,FILE,FIEN) ;Select the file to set up partial auditing on
 ;
 NEW DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DIR,DA,PARRAY,CONT,HYPHEN,ONLY1
 ;
 S $P(HYPHEN,"-",80)="-"
 ;
 ;Display current file list
 S PARRAY("A")="Add file to set up for auditing"
 I $O(^BUSAPFMN(0)) D
 . S PARRAY("R")="Remove file from partial auditing list"
 . S PARRAY("E")="Edit existing file in auditing list"
 . NEW FL
 . W !!,"Current File(s) with Audit definitions"
 . W !,$E(HYPHEN,1,45)
 . S FL="" F  S FL=$O(^BUSAPFMN("B",FL)) Q:FL=""  D
 .. W !,FL,?12,$P($G(^DIC(FL,0)),U)
 ;
 ;Prompt user for action
 S ACT="",CONT=$$SCPRMPT(.ACT,"Selection",.PARRAY,"Q",1) Q:CONT=-1 -1
 I ACT="Q" Q 1
 ;
 ;If edit or remove and only one file there, pick it
 I (ACT="E")!(ACT="R") S ONLY1=$$ONLYF1() I ONLY1]"" S FILE=$P(ONLY1,"|"),FIEN=$P(ONLY1,"|",2) Q 1
 ;
 ;Select file
 S (FIEN,FILE)=""
 W !!,"Please select the file you would like to "
 I ACT="A" W "add to be audited."
 I ACT="E" W "edit the audit definitions for."
 I ACT="R" W "remove the audit definitions for."
 W !
 S DIR(0)="PO^DIC(:QEM"
 S DIR("A")="FILE"
 D ^DIR I +Y<1 Q -1
 S:+$P(Y,U)>0 FILE=$P(Y,U,2),FIEN=$P(Y,U)
 ;
 I FILE]"",FIEN]"" Q 1
 Q -1
 ;
ONLYF1() ;Return file if profile only has one
 ;
 NEW FILE,FDIEN,FIEN
 ;
 ;No entry
 S FDIEN=$O(^BUSAPFMN("B","")) I 'FDIEN Q ""
 ;
 ;More than 1 entry
 I $O(^BUSAPFMN("B",FDIEN))]"" Q ""
 S FIEN=$O(^BUSAPFMN("B",FDIEN,"")) I 'FIEN Q ""
 ;
 ;Get the file number
 S FDIEN=$$GET1^DIQ(9002319.14,FIEN_",",".01","I") Q:FDIEN="" ""
 S FILE=$P($G(^DIC(FDIEN,0)),U)
 ;
 W !!,"Partial Audit File: ",FILE,"  ",$P($G(^DIC(FDIEN,0)),U),!
 ;
 Q FILE_"|"_FDIEN
 ;
 ;
CONT(PROMPT,YN) ;Continue with processing
 ;
 NEW DIR,DA,X,Y,DTOUT,DUOUT,DIROUT,DIRUT,DIC,DLAYGO,RECUR
 ;
 ;Prompt if they want to continue
 W !
 S DIR(0)="Y",DIR("B")="NO"
 I $G(YN)]"" S DIR("B")=YN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 E  S DIR("A")="Would you like to import this schema file"
 D ^DIR
 S Y=$G(Y)
 I Y=1 Q 1
 I Y=0 Q 0
 Q -1
 ;
SCPRMPT(RET,PROMPT,PARRAY,DEF,QUIT) ;Prompt for user input
 ;
 I $O(PARRAY(""))="" W !,"No choices passed into SCPRMPT" Q -1
 S PROMPT=$G(PROMPT)
 I PROMPT="" S PROMPT="Please select one of the choices"
 ;
 NEW DTOUT,DUOUT,DIRUT,DIROUT,X,Y,DIR,LIST,CODE
 ;
 ;Assemble choices
 S LIST="",CODE="" F  S CODE=$O(PARRAY(CODE)) Q:CODE=""  S LIST=LIST_$S(LIST="":"",1:";")_CODE_":"_PARRAY(CODE)
 I +$G(QUIT) S LIST=LIST_$S(LIST="":"",1:";")_"Q:Quit"
 ;
 ;Prompt
 W !
 S DIR("B")=$S($G(DEF)]"":DEF,1:"")
 S DIR("A")=PROMPT
 S DIR(0)="S^"_LIST
 D ^DIR
 I +$G(QUIT),Y="Q" S RET=Y Q 1
 I Y'="",$D(PARRAY(Y)) S RET=Y Q 1
 Q -1
 ;
DSP ;EP - Display a listing of partial audit fields
 ;
 NEW CONT,POP,SCREEN,FOUND,HYPHEN,FNAME,FIEN
 ;
 S $P(HYPHEN,"-",80)="-"
 ;
 W !!,"This option will display a listing of files and fields that"
 W !,"are set up for partial FileMan auditing",!
 ;
 ;Prompt to continue
 S CONT=$$CONT("Would you like to continue","NO") I CONT'=1 Q
 ;
 ;Display on device
 W ! D ^%ZIS I $G(POP) Q
 ;
 ;Output report
 U 0 W !!,"Outputting report..."
 ;
 U IO
 ;
 ;Screen
 S SCREEN=0
 I $E($G(IOST),1,2)="C-" S SCREEN=1
 ;
 I SCREEN,$G(IOF)]"" W @IOF
 W !!,"BUSA PARTIAL FILEMAN AUDITING FILE/FIELD LISTING"
 ;
 ;Display Header
 W !!,"FILE REFERENCE",?50,"FIELD"
 W !,HYPHEN
 ;
 ;Display entries
 S FNAME="" F  S FNAME=$O(^BUSAPFMN("F",FNAME)) Q:FNAME=""  D
 . F FIEN="" F  S FIEN=$O(^BUSAPFMN("F",FNAME,FIEN)) Q:'FIEN  D
 .. NEW SFILE,SFIELD,FLIEN,SFIEN
 .. ;
 .. ;Display header if entry is defined
 .. S FLIEN=$$GET1^DIQ(9002319.14,FIEN_",",.01,"I") Q:FLIEN=""
 .. W !!,"File: ",$P($G(^DIC(FLIEN,0)),U)," (#"_FLIEN_")"
 .. I $P($G(^BUSAPFMN(FIEN,0)),U,2) W ?50,"*AUDITING ALL FIELDS IN FILE" Q
 .. I $O(^BUSAPFMN(FIEN,1,"SF",""))="" W ?50,"*NO FIELDS DEFINED TO BE AUDITED" Q
 .. S SFILE="" F  S SFILE=$O(^BUSAPFMN(FIEN,1,"SF",SFILE)) Q:SFILE=""  D
 ... S SFIELD="" F  S SFIELD=$O(^BUSAPFMN(FIEN,1,"SF",SFILE,SFIELD)) Q:SFIELD=""  D
 .... S SFIEN="" F  S SFIEN=$O(^BUSAPFMN(FIEN,1,"SF",SFILE,SFIELD,SFIEN)) Q:SFIEN=""  D
 ..... W !,$E($P($G(^BUSAPFMN(FIEN,1,SFIEN,1)),U),1,48),?50,$E($P($G(^BUSAPFMN(FIEN,1,SFIEN,0)),U,2),1,29)
 ;
 ;Close the device
 D ^%ZISC
 ;
 U 0
 ;
 ;Prompt to continue
 D AKEY
 ;
 Q
 ;
AKEY ;Hit any key to continue
 NEW DIR,X,Y,DTOUT,DUOUT,DIRUT,DIROUT
 ;
 ;Prompt to continue
 W ! S DIR(0)="E",DIR("A")="Hit ENTER to continue" D ^DIR
 Q
