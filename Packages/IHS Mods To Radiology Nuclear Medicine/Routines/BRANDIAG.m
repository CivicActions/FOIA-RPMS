BRANDIAG ;IHS/OIT/NST - Radiology Diagnostic Code Unitlity ; 10 Jul 2025 10:24 AM
 ;;5.0;Radiology/Nuclear Medicine;**1013**;Mar 16, 1998;Build 1
 ;;
 Q
 ;
EN ;  Import Radiology Diagnostic Code
 N DDWFLAGS,DIC,DIWEPSE,DIWESUB,DWPK,BRAFDA,BRAIEN,BRAERR,BRARC,CODES,DIERR,I,IEN,IENS,X,Y,VALUE,FIELD
 S DIC="^TMP("_$J_",""BRAWP"","
 K ^TMP($J,"BRAWP")
 S DWPK=1
 S DIWESUB="Diagnostic Codes"
 W !,"Import Diagnostic Code list"
 W !,"  e.g., 1001^SIGNIFICANT ABNORMALITY, ATTN NEEDED"
 W !,"where"
 W !,"  1st-'^' piece is the diagnostic code IEN in DIAGNOSTIC CODES file (#78.3)"
 W !,"  2nd-'^' piece is the DIAGNOSTIC CODE field (#78.3,1)"
 W !,"  3rd-'^' piece is the DESCRIPTION field (#78.3,2)"
 W !,"  4rd-'^' piece is the PRINT ON ABNORMAL REPORT  field (#78.3,3) value Y/N"
 W !,"  5th-'^' piece is the GENERATE ABNORMAL ALERT? field (#78.3,4) value y/n"
 W !
 S DDWFLAGS="M"
 S DIWEPSE=1
 D EN^DIWE
 ;
 I '$O(^TMP($J,"BRAWP",0)) Q
 ;
 S I=0
 F  S I=$O(^TMP($J,"BRAWP",I)) Q:'I  D
 . S X=^TMP($J,"BRAWP",I,0)
 . S:X'="" CODES($P(X,"^"))=X
 . Q
 ;
 W !
 K DIR
 S DIR(0)="Y"
 S DIR("A")="Are you ready to import the Diagnostic Codes"
 S DIR("B")="NO"
 D ^DIR
 Q:'$G(Y)
 ;
 S IEN="",BRARC=0
 F  S IEN=$O(CODES(IEN))  Q:IEN=""  D  Q:BRARC<0
 . ;--- Check if the diagnostic code exists
 . I $D(^RA(78.3,IEN)) D  Q
 . . W !,"Already exists: ",IEN,":"_$P(CODES(IEN),"^",2)
 . . Q
 . ; Check fields integrity
 . F FIELD=3,4 D  Q:BRARC<0
 . . S VALUE=$P(CODES(IEN),"^",FIELD+1)
 . . Q:VALUE=""
 . . D CHK^DIE(78.3,FIELD,"",VALUE,.X,"BRAERR")
 . . I X="^" D
 . . . S BRARC=-1
 . . . W !,"Error adding diagnostic code "_IEN_": "_$P(CODES(IEN),"^",2)
 . . . F I=1:1 Q:'$D(BRAERR("DIERR",1,"TEXT",I))  D
 . . . . W !,BRAERR("DIERR",1,"TEXT",I)
 . . . . Q
 . . . Q
 . . E  S $P(CODES(IEN),"^",FIELD+1)=X
 . . Q
 . ;--- Add diagnostic code
 . K BRAFDA
 . S IENS="+1,"
 . S BRAIEN(1)=IEN
 . S BRAFDA(78.3,IENS,.01)=$P(CODES(IEN),"^",2)
 . S BRAFDA(78.3,IENS,2)=$P(CODES(IEN),"^",3)
 . S BRAFDA(78.3,IENS,3)=$P(CODES(IEN),"^",4)
 . S BRAFDA(78.3,IENS,4)=$P(CODES(IEN),"^",5)
 . D UPDATE^DIE("","BRAFDA","BRAIEN","BRAERR")
 . I $D(BRAERR("DIERR",1,"TEXT")) D  Q
 . . S BRARC=-1
 . . W !,"Error adding diagnostic code "_IEN_": "_$P(CODES(IEN),"^",2)
 . . F I=1:1 Q:'$D(BRAERR("DIERR",1,"TEXT",I))  D
 . . . W !,BRAERR("DIERR",1,"TEXT",I)
 . . . Q
 . . Q
 . Q
 I BRARC<0  W !,"ABORTED!"
 W !,"Import has been completed."
 Q
