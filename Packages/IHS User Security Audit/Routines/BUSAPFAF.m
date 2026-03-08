BUSAPFAF ;GDIT/HS/BEE-BUSA Create/Edit File Field Audits
 ;;1.0;IHS USER SECURITY AUDIT;**5**;Nov 05, 2013;Build 42
 ;
 ;This routine will allow users to create/edit BUSA FileMan field level audits
 ;
 Q
 ;
FAUD(FIEN,FILE) ;Enter/Edit field level audits for a file
 ;
 ;FIEN - Profile file IEN
 ;FILE - File #
 ;
 I $G(FIEN)="" W !!,"<Missing FIEN>" H 3 Q -1
 I $G(FILE)="" W !!,"<Missing FILE>" H 3 Q -1
 ;
 NEW CONT
 ;
 ;Prompt if user wants to make any record level exclusions
 I ($O(^BUSAPFMN("I",FILE,""))=""),($O(^BUSAPFMN("F",FILE,""))="") S CONT=$$CONT^BUSAPFA("Would you like to create/edit/remove auditing on fields in this file","NO") Q:CONT=0 1 I CONT=-1 Q -1
 ;
 ;Exclude entry fields
 S CONT=$$EFIELD(FIEN)
 ;
 Q 1
 ;
EFIELD(FIEN) ;Audit field(s) in a file entry
 ;
 I '$G(FIEN) Q -1
 ;
 I $G(IOF)]"" W @IOF
 W !,"Audit specific fields in a file"
 ;
 NEW PARRAY,ACT,CARRAY,X,SFILE,SDEF,CONT,FLIST
 ;
EFIELD1 ;Prompt for action
 ;
 ;Clear existing array and repopulate
 S X="" F  S X=$O(CARRAY(X)) Q:X=""  K CARRAY(X)
 ;
 ;Get file/subfile
 S SFILE=$O(CARRAY(""))
 ;
 ;Clear existing choices
 S X="" F  S X=$O(PARRAY(X)) Q:X=""  K PARRAY(X)
 ;
 ;Clear flist
 S X="" F  S X=$O(FLIST(X)) Q:X=""  K FLIST(X)
 ;
 ;Set default response
 S SDEF="Q"
 ;
 ;Display current entries
 D DISP(FIEN,.FLIST)
 I $O(FLIST(""))]"" S PARRAY("R")="Remove audit on a field"
 ;
 ;Include add and condition check logic
 S PARRAY("A")="Add auditing on a field"
 ;
 ;Prompt for action
 S ACT="",CONT=$$SCPRMPT^BUSAPFA(.ACT,"Selection",.PARRAY,SDEF,1) Q:CONT=-1 -1
 I ACT="Q" Q 1
 ;
 ;Adds
 I ACT="A" S CONT=$$ADD(FIEN) G:CONT=-1 EFIELD1
 ;
 ;Removes
 I ACT="R" S CONT=$$REM(FIEN) G:CONT=-1 EFIELD1
 ;
 G EFIELD1
 ;
 ;
ADD(FIEN,OFILE,FILE,FNAM,FREF) ;Add a field to exclude
 ;
 S FREF=$G(FREF)
 ;
 NEW FSTYPE,FSNAME,COUNT,DDFNUM,FNAME,FLIST,CONT,FCNT,LCNT
 ;
 ;Get the file
 I $G(FILE)="" S FILE=$$GET1^DIQ(9002319.14,FIEN_",",.01,"I") Q:FILE="" -1
 S:$G(OFILE)="" OFILE=FILE
 ;
 ;Get the file/subfile name
 S FSTYPE=""
 S FSNAME=$P($G(^DIC(FILE,0)),U),FSTYPE="F"  ;File
 I FSNAME="" S FSNAME=$P($P($G(^DD(FILE,0)),U)," SUB-FIELD"),FSTYPE="S"  ;Sub-file
 I FSNAME]"" W !!,"Field listing for ",FSNAME,$S(FSTYPE="F":" file:",FSTYPE="S":" subfile:",1:""),!
 ;
 ;Loop through the fields
 S FNAM=$G(FNAM)_$S($G(FNAM)]"":">",1:"")_FSNAME
 S COUNT=0
 S DDFNUM=0 F  S DDFNUM=$O(^DD(FILE,DDFNUM)) Q:'DDFNUM  D
 . NEW MULT,SFILE,SFREF,PAUD
 . ;
 . S FNAME=$P($G(^DD(FILE,DDFNUM,0)),U) Q:FNAME=""
 . ;
 . ;Filter out LAB DATA special fields
 . I $$LABDATA(FILE,DDFNUM) Q
 . ;
 . ;Check if a multiple or word processing field
 . S MULT=$$MSEL(FILE,DDFNUM,.SFILE)
 . ;
 . ;Filter out word processing fields
 . I MULT,$P(MULT,U,2)="W" Q
 . ;
 . ;Save the field number reference
 . S SFREF=FREF_$S(FREF]"":",",1:"")_DDFNUM
 . ;
 . ;Save if already set up for auditing
 . S PAUD=0 I $O(^BUSAPFMN("FREF",OFILE,SFREF,"")) S PAUD=1
 . ;
 . ;Save the entry
 . S COUNT=COUNT+1,FLIST(COUNT)=DDFNUM_U_FNAME_U_+MULT_U_FNAM_U_SFREF_U_OFILE_U_PAUD,ILIST(DDFNUM)=COUNT_U_FNAME
 ;
 ;Select field from list
 S (CONT,FCNT)=""
 S FIELD=""
 F  D  Q:CONT]""
 . ;
 . NEW MAX,PARRAY,ACT,FLDIEN,SDEF,DCNT,FNAM,FSEL
 . ;
 . ;Display 10 fields
 . W !,"#",?5,"FIELD",?40,"FIELD NUMBER",?72,"AUDIT"
 . S DCNT=0,MAX=0,CONT="",ACT=""
 . S LCNT=FCNT
 . F  S FCNT=$O(FLIST(FCNT)) Q:FCNT=""  D  Q:MAX  Q:CONT]""
 .. W !,FCNT,?5,$P(FLIST(FCNT),U,2),$S($P(FLIST(FCNT),U,3):"...",1:""),?40,$P(FLIST(FCNT),U),?72,$S($P(FLIST(FCNT),U,7):"Yes",1:"")
 .. S DCNT=DCNT+1 I DCNT=10 S MAX=1
 . ;
 . ;Select field
 . S FIELD=""
 . S PARRAY("S")="Select field"
 . S SDEF="Q"
 . I FCNT,$O(FLIST(FCNT))]"" S PARRAY("N")="Next",SDEF="N"
 . S PARRAY("J")="Jump to FIELD NUMBER"
 . S ACT="",CONT=$$SCPRMPT^BUSAPFA(.ACT,"Selection",.PARRAY,SDEF,1)
 . I CONT=-1 Q
 . I ACT="Q" S CONT=0 Q
 . I (ACT="")!(ACT="N"),FCNT="" S CONT=0 Q
 . S CONT=""
 . ;
 . ;Jump to field number
 . I ACT="J" S CONT=$$JUMP(.FLIST,.ILIST,.FIELD,.FSEL) Q:CONT=-1  D  Q:CONT'=1
 .. I CONT=0 S CONT="" Q
 . ;
 . ;Select FIELD
 . I (ACT="S")!(FIELD]"") D  Q
 .. NEW SFILE,MULT,FNAM,PROMPT
 .. I FIELD="" S CONT=$$FSEL(.FLIST,.FIELD,FILE,.FSEL) I CONT=-1 Q
 .. I CONT=1 S CONT=""
 .. I FIELD="" S CONT=0
 .. ;
 .. ;Check for multiple field
 .. S SFILE=""
 .. S MULT=$$MSEL(FILE,FIELD,.SFILE)
 .. S FNAM=$P(FIELD,U,4)
 .. I MULT S CONT=$$ADD(FIEN,$P(FIELD,U,6),SFILE,FNAM,$P(FIELD,U,5)) I CONT]"" Q
 .. ;
 .. I FIELD="" S CONT="" Q
 .. ;
 .. ;Check if already set up
 .. I $P(FIELD,U,7) S FIELD="" W !!,"<Field is already set up for partial auditing>",! H 3 Q
 .. ;
 .. S PROMPT="Would you like to turn on auditing for the "_$P(FIELD,U,2)_" field"
 .. I $G(FIELD)]"" W ! S CONT=$$CONT^BUSAPFA(PROMPT,"NO") Q:CONT=-1
 .. I CONT=0 S CONT="",FCNT=LCNT Q
 .. ;
 .. ;Save entry
 .. I $G(FIELD)]"" D
 ... NEW DA,IENS,X,Y,DLAYGO,DIC
 ... S DA(1)=FIEN
 ... S X=$P(FIELD,U)
 ... S DIC("DR")=".02////"_$P(FIELD,U,2)_";.03////"_$G(FILE)_";1.01////"_$G(FNAM)_";.04////"_$P(FIELD,U,5)_";.05////"_$P(FIELD,U,6)
 ... S DIC(0)="LX",DLAYGO=9002319.141
 ... S DIC="^BUSAPFMN("_DA(1)_",1,"
 ... K DO,DD D FILE^DICN
 ... I +Y>0 D  Q
 .... ;
 .... NEW BSTATUS,BDESC
 .... ;
 .... ;Log the entry
 .... S BDESC="BUSA: "_$P(FIELD,U,4)
 .... S BDESC=BDESC_" file: "_$P(FIELD,U,2)_" field set up for partial auditing"
 .... S BDESC=BDESC_"||||||BUSA10|"_$G(FILE)
 .... S BSTATUS=$$BYPSLOG^BUSAAPI("A","S","A","BUSAPFAF",BDESC,"",1)
 .... I +$G(FSEL) S $P(FLIST(FSEL),U,7)=1
 .... ;
 .... W !!,"Field audit successfully added",!
 .... H 2 S CONT="",FCNT=LCNT,FIELD=""
 .... I $O(^BUSA(9002319.04,"S","F",1,""))="" Q
 .... W !!,"*Note - FileMan Auditing must be turned off and back on for this to take full effect",!
 .... D AKEY^BUSAPFA
 ... W !!,"<Unable to add new field audit>" H 2 S CONT=-1 Q
 ;
 I $G(CONT)]"" Q CONT
 Q 1
 ;
REM(FIEN) ;Remove field audit
 ;
 NEW CONT,DA,DIK,ILIST,COUNT,SFILE,FNUM,FOUND,FNAME,FLDIEN,FLIST,RFILE,RFIELD,BDESC,IFILE
 ;
REM1 ;Display
 K FLIST
 ;Get the current audited fields
 D DISP(FIEN,.FLIST,1)
 ; 
 S (COUNT,FOUND)=0,SFILE="" F  S SFILE=$O(FLIST(SFILE)) Q:SFILE=""  S FNUM="" F  S FNUM=$O(FLIST(SFILE,FNUM)) Q:FNUM=""  D
 . I 'FOUND D
 .. W !!,"Fields Currently Getting Audited:"
 .. W !!,"#",?4,"File/Subfile",?41,"FIELD (#)"
 .. W !,"-",?4,"---------------------------------------------",?50,"------------------------------"
 . W !
 . S COUNT=COUNT+1
 . I $D(^DIC(SFILE,0)) W COUNT,?4,$E($P(^DIC(SFILE,0),U),1,38)
 . E  I $D(^DD(SFILE,0)) W COUNT,?4,$E($P(^DD(SFILE,0),U),1,38)
 . S FNAME=$G(FLIST(SFILE,FNUM))
 . W ?41,$E(FNAME_" (#"_FNUM_")",1,28)
 . S ILIST(COUNT)=SFILE_U_FNUM_U_FNAME
 . S FOUND=1
 ;
 ;Select the entry - If only one pick it
 S (SFILE,FNUM,FNAME)=""
 S (X,Y)="" I COUNT=1 S (X,Y)=COUNT S:'$D(ILIST(Y)) (X,Y)=""
 S DIR(0)="NO^1:"_COUNT
 S DIR("A")="Select the number of the entry to remove or return to quit"
 I Y="" W ! D ^DIR
 I $G(X)="",$G(DIRUT),'$D(DTOUT) G REM1
 I $G(DTOUT)!$G(DUOUT)!$G(DIROUT)!$G(DIRUT) Q -1
 I Y="" Q 1
 I '$D(ILIST(Y)) W !,"<Invalid selection>" G REM1
 S SFILE=$P(ILIST(Y),U)
 S FNUM=$P(ILIST(Y),U,2)
 S FNAME=$P(ILIST(Y),U,3)
 ;
 ;Prompt to remove
 W !!,"File/Subfile: ",SFILE,"  Field: ",FNAME," (#",FNUM,")",!
 S CONT=$$CONT^BREHSIU("Are you sure you want to remove this partial field audit","NO") I CONT=-1 Q -1
 I CONT=0 Q 1
 ;
 ;See if file entry is set up for auditing
 S DA=$O(^BUSAPFMN("FLD",SFILE,FNUM,FIEN,"")) I DA="" W !!,"<Could not locate field audit entry>" H 3 Q 1
 K FLIST(SFILE,FNUM)
 ;
 ;Get info for BUSA
 S RFILE=$P($G(^BUSAPFMN(FIEN,1,DA,1)),U)
 S RFIELD=$P($G(^BUSAPFMN(FIEN,1,DA,0)),U,2)
 S IFILE=$P($G(^BUSAPFMN(FIEN,1,DA,0)),U,5)
 S BDESC="BUSA: "_RFILE
 S BDESC=BDESC_" file: "_RFIELD_" field removed from partial auditing"
 S BDESC=BDESC_"||||||BUSA11|"_$G(IFILE)
 S BSTATUS=$$BYPSLOG^BUSAAPI("A","S","D","BUSAPFAF",BDESC,"",1)
 ;
 ;Remove the entry
 S DA(1)=FIEN,DIK="^BUSAPFMN("_FIEN_",1,"
 D ^DIK
 W !!,"Field audit entry removed..."
 I $O(^BUSA(9002319.04,"S","F",1,""))="" Q 1
 W !!,"*Note - FileMan Auditing must be turned off and back on for this to take full effect",!
 D AKEY^BUSAPFA
 ;
 Q 1
 ;
DISP(FLIEN,FLIST,NOPRT) ;Display current audited fields in file
 ;
 I '$G(FLIEN) Q
 S NOPRT=+$G(NOPRT)
 ;
 NEW FDIEN,FOUND
 ;
 ;Get file pointer
 I '$D(^BUSAPFMN(FLIEN,0)) Q
 ;
 ;Loop through file fields
 S (FOUND,FDIEN)=0 F  S FDIEN=$O(^BUSAPFMN(FLIEN,1,FDIEN)) Q:'FDIEN  D
 . NEW SFILE,FNUM,FNAME,DA,IENS,FULLNM,FULLFLD
 . ;
 . S DA(1)=FLIEN,DA=FDIEN,IENS=$$IENS^DILF(.DA)
 . S SFILE=$$GET1^DIQ(9002319.141,IENS,".03","I")
 . S FNUM=$$GET1^DIQ(9002319.141,IENS,".01","I") Q:FNUM=""
 . S FNAME=$$GET1^DIQ(9002319.141,IENS,".02","I")
 . S FULLNM=$$GET1^DIQ(9002319.141,IENS,"1.01","E")
 . S FULLFLD=FNAME_" (#"_FNUM_")"
 . I 'FOUND D
 .. I 'NOPRT W !!,"CURRENT FIELD(S) BEING AUDITED:"
 .. I 'NOPRT W !!,"File>Subfile",?50,"FIELD (#)"
 .. I 'NOPRT W !,"------------",?50,"---------"
 . I 'NOPRT W !,$E(FULLNM,1,49)
 . I 'NOPRT W ?50,$E(FULLFLD,1,29)
 . I SFILE]"",FNUM]"" S FLIST(SFILE,FNUM)=FNAME
 . S FOUND=1
 Q
 ;
LABDATA(FILE,FLD) ;Filter on lab data special fields
 ;
 I FILE=63.04,FLD>1,FLD<9999991 Q 1
 I FILE=63.3,FLD>2,FLD<200 Q 1
 Q 0
 ;
JUMP(FLIST,ILIST,FIELD,FSEL) ;Jump to field
 ;
 NEW DTOUT,DUOUT,DIROUT,DIRUT,X,Y,DIR
 ;
JUMP1 S DIR(0)="FO^1:20"
 S DIR("A")="Enter the FIELD NUMBER to select or return to quit"
 D ^DIR
 I Y="" Q 0
 I $G(DTOUT)!$G(DUOUT)!$G(DIROUT)!$G(DIRUT) Q -1
 I '$D(ILIST(Y)) W !!,"<Invalid field number>" H 2 G JUMP1
 ;S FIELD=Y_U_$P(ILIST(Y),U,2)
 S FIELD=$G(FLIST(+$P(ILIST(Y),U)))
 S FSEL=$P(ILIST(Y),U)
 Q 1
 ;
MSEL(FILE,FIELD,SFILE) ;Check if selected field is multiple or Word Processing
 ;
 I $G(FILE)="" Q 0
 I $G(FIELD)="" Q 0
 ;
 NEW XTYPE,TYPE,FIEN
 ;
 ;Get the field IEN
 S FIEN=$P(FIELD,U)
 ;
 ;Get the field type
 S XTYPE=$P($G(^DD(FILE,FIEN,0)),U,2) I XTYPE="" Q 0
 S XTYPE=$TR(XTYPE,"BIMR'*sXa")
 S TYPE=$E(XTYPE,1)
 I TYPE="C",XTYPE["m" S TYPE="X"  ;Multiple computed
 S:TYPE="" TYPE="F"
 ;
 ;Determine if multiple or word type
 I TYPE'?1U D
 . NEW SDDTYP
 . S SDDTYP=$E($P($G(^DD(+XTYPE,.01,0)),U,2),1)
 . I SDDTYP="W" S TYPE="W"
 . E  S TYPE="m"
 I (TYPE="W")!(TYPE="m") S SFILE=+XTYPE Q 1_U_TYPE
 Q 0
 ;
 ;
FSEL(FLIST,FIELD,FILE,FSEL) ;Select a field from the file
 ;
 NEW MIN,MAX,DTOUT,DUOUT,DIROUT,DIRUT,X,Y,SEL,DIR
 ;
 ;Get total fields
 S MAX=$O(FLIST(""),-1) I MAX="" W !!,"<File/subfile ",FILE," has no fields/subfields>" H 3 Q -1
 ;
 S DIR(0)="NO^1:"_MAX
 S DIR("A")="Select field reference number (#) or return to quit"
 D ^DIR
 I Y="" Q -1
 I $G(DTOUT)!$G(DUOUT)!$G(DIROUT)!$G(DIRUT) Q -1
 I +Y>0 S FIELD=FLIST(+Y),FSEL=+Y Q 1
 ;
 Q 0
