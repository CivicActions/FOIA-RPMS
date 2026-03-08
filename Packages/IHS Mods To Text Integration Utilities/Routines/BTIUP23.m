BTIUP23 ; IHS/MSC/MGH - SETUP FOR PATCH 1023;19-Jan-2021 10:03;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1023**;SEPT 04, 2005;Build 12
 ;
ENV ;EP environment check
 N PATCH,IN,STAT,INSTDA
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="TIU*1.0*1022"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDABORT=1
 ; -- Set data for DDEFs to export:
 D SETXTMP
 ; -- Check for potential DDEF duplicates at site:
 N TIUDUPS
 D TIUDUPS(.TIUDUPS)
 ; -- If potential duplicates exist, abort install:
 ;I 'TIUDUPS W !,"Document Definitions look OK." Q
 ;S XPDABORT=1 W !,"Aborting Install..."
 Q
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numbers
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
SETXTMP ; Set up ^XTMP global
 S ^XTMP("TIU1023",0)=3201125_U_DT
 ; -- Set basic data for new DDEFS into ^XTMP.
 ;    Reference DDEFS by NUMBER.
 ;    Number parent-to-be BEFORE child.
 ; -- DDEF Document classes:
 S ^XTMP("TIU1023","BASICS",1,"NAME")="CLINICAL REMINDER DIALOG IMMUNIZATIONS"
 S ^XTMP("TIU1023","BASICS",1,"INTTYPE")="DC"
 ; -- DDEF:
 S ^XTMP("TIU1023","BASICS",2,"NAME")="COVID-19 VACCINE POLICY ORDER"
 S ^XTMP("TIU1023","BASICS",2,"INTTYPE")="DOC"
 Q
TIUDUPS(TIUDUPS) ; Set array of potential duplicates
 N NUM S (NUM,TIUDUPS)=0
 F  S NUM=$O(^XTMP("TIU1023","BASICS",NUM)) Q:'NUM  D
 . ; -- When looking for duplicates, ignore DDEF if
 . ;      previously created by this patch:
 . Q:$G(^XTMP("TIU1023","BASICS",NUM,"DONE"))
 . ; -- If site already has DDEF w/ same Name & Type as one
 . ;    we are exporting, set its number into array TIUDUPS:
 . N NAME,TYPE,TIUY S TIUY=0
 . S NAME=^XTMP("TIU1023","BASICS",NUM,"NAME"),TYPE=^XTMP("TIU1023","BASICS",NUM,"INTTYPE")
 . F  S TIUY=$O(^TIU(8925.1,"B",NAME,TIUY)) Q:+TIUY'>0  D
 . . I $P($G(^TIU(8925.1,+TIUY,0)),U,4)=TYPE S TIUDUPS(NUM)=+TIUY,TIUDUPS=1
 ; -- Write list of duplicates:
 I +TIUDUPS D
 . W !,"You already have the following Document Definitions exported by this patch."
 . W !,"I don't want to overwrite them. See the notes file for details."
 . W !!,"If you are reinstalling this patch, the documents will not be installed again"
 . N NUM S NUM=0
 . F  S NUM=$O(TIUDUPS(NUM)) Q:'NUM  D
 . . W !?5,^XTMP("TIU1023","BASICS",NUM,"NAME")
 Q
 ;
PRE ;EP; beginning of pre install code
 Q
POST ;EP; beginning of post install code
 D BEGIN^TIU1023D
 Q
