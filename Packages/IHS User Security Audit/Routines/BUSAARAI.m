BUSAARAI ;GDIT/HS/BEE-BUSA Archive BUSA Information option ; 06 Mar 2013  1:52 PM
 ;;1.0;IHS USER SECURITY AUDIT;**3**;Nov 05, 2013;Build 47
 ;
 Q
 ;
ARCHIVE(PATH,BIEN,BIENDT,LRIEN,SIZE,AUSER,QUEUE) ;Perform a file archive
 ;
 ;Lock the process so others cannot run it
 L +^XTMP("BUSAARCH",1):1 E  G FQUIT
 ;
 I $G(PATH)="" G FQUIT     ;Archive file path
 I $G(BIEN)="" G FQUIT     ;Archive - First record IEN
 I $G(BIENDT)="" G FQUIT   ;Archive - First record date
 I $G(LRIEN)="" G FQUIT    ;Archive - Last record IEN
 I $G(SIZE)="" G FQUIT     ;Archive - Estimated file size
 I $G(AUSER)="" G FQUIT     ;Archive - User
 S QUEUE=+$G(QUEUE)
 ;
 NEW STS,FNAME,FSIZE,STOP,BSIEN,BSDATE,RCNT,HIEN,LIEN,LSTDT,X1,X2,X,JOURNAL
 ;
 ;Set up error handling, get current journal status and disable if needed
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BUSAARAI D UNWIND^%ZTER" ; SAC 2009 2.2.3.17
 S JOURNAL=$$CURRENT^%NOJRN() I JOURNAL D DISABLE^%NOJRN
 ;
 ;Create ^XTMP entry
 S X1=DT,X2=60 D C^%DTC
 S ^XTMP("BUSAARCH",0)=X_U_DT_U_"BUSA ARCHIVE RUN INFORMATION"
 ;
 ;Open the initial file
 S STS=$$FOPEN(PATH,BIEN,BIENDT,.FSIZE,.FNAME,.RCNT,QUEUE,.HIEN,AUSER) I STS=0 G FQUIT
 ;
 ;Start the looping process
 S LIEN="",LSTDT=""
 S STOP=0,BSDATE=BIENDT,BSIEN=BIEN-1 F  S BSIEN=$O(^BUSAS(BSIEN)) D  I STOP Q
 . ;
 . ;Check if maximum reached
 . I BSIEN>LRIEN S STOP=2 Q
 . ;
 . ;Check if end reached
 . I 'BSIEN S STOP=2 Q
 . ;
 . NEW SQUEUE,QUIT,BDIEN,VALUE,USER
 . NEW N0,N1,LDT,USR,CAT,TYP,ACT,CAL,DSC,OHASH,HASH
 . ;
 . ;Get the current record date
 . S BSDATE=$P($G(^BUSAS(BSIEN,0)),U) I BSDATE="" S STOP=1 Q
 . ;
 . ;Calculate the size - Open new file if needed
 . ;Subtracting 800k from max size to allow for final record size
 . I FSIZE>(SIZE-500000) D
 .. NEW ERROR,STS
 .. ;
 .. ;Write final record
 .. W !,"LAST RECORD"_U_RCNT_U_LIEN_U_LSTDT
 .. ;
 .. ;Close the file
 .. I $$DEVICE^BUSAAUT("C",PATH,FNAME) S STOP=1 Q
 .. ; 
 .. ;Log to ^XTMP
 .. D EVENT^BUSAARO(HIEN,"C","Closed file "_FNAME_" for archive creation")
 .. D EVENT^BUSAARO(HIEN,"CS","1^File created")
 .. ;
 .. ;Log to BUSA
 .. S STS=$$LOG^BUSAAPI("A","S","","BUSAARAI","BUSA Archiving: Closed archive file "_FNAME_" ("_RCNT_" records)")
 .. ;
 .. ;Update history entry
 .. I +$G(HIEN) D  I $D(ERROR) S STOP=1 Q
 ... NEW HUPDATE
 ... I $G(LSTDT)]"" S HUPDATE(9002319.13,HIEN_",",.04)=LSTDT
 ... I $G(LIEN)]"" S HUPDATE(9002319.13,HIEN_",",.06)=LIEN
 ... I $G(RCNT)]"" S HUPDATE(9002319.13,HIEN_",",.07)=RCNT
 ... I $D(HUPDATE) D FILE^DIE("","HUPDATE","ERROR")
 .. ;
 .. ;Open the new file
 .. S STS=$$FOPEN(PATH,BSIEN,BSDATE,.FSIZE,.FNAME,.RCNT,QUEUE,.HIEN,AUSER) I STS=0 S STOP=1 Q
 . ;
 . ;Process each SUMMARY subscript
 . S QUIT="",SQUEUE="^BUSAS("_BSIEN_")" F  S SQUEUE=$Q(@SQUEUE) D  I QUIT Q
 .. ;
 .. NEW CIEN,SQUEUEV
 .. ;
 .. ;Check if on the same summary entry
 .. S CIEN=$P($P(SQUEUE,"(",2),",")
 .. I CIEN'=BSIEN S QUIT=1 Q
 .. ;
 .. ;Output the record reference string
 .. W !,SQUEUE
 .. S RCNT=RCNT+1
 .. ;
 .. ;Output the record value
 .. S SQUEUEV=$G(@SQUEUE)
 .. S SQUEUEV=$TR(SQUEUEV,$C(13),$C(28))  ;Convert $c(13) to $c(28)
 .. S SQUEUEV=$TR(SQUEUEV,$C(10),$C(29))  ;Convert $c(10) to $c(29)
 .. W !,SQUEUEV
 .. S RCNT=RCNT+1
 .. ;
 .. ;Increment the size
 .. S FSIZE=FSIZE+$L(SQUEUE)+$L(SQUEUEV)+2
 . ;
 . ;Calculate current HASH
 . S N0=$G(^BUSAS(BSIEN,0))
 . S N1=$G(^BUSAS(BSIEN,1))
 . S LDT=$P(N0,"^")
 . S USR=$P(N0,"^",2)
 . S CAT=$P(N0,"^",3)
 . S TYP=$P(N0,"^",4)
 . S ACT=$P(N0,"^",5)
 . S CAL=$P(N0,"^",6)
 . S DSC=$P(N1,"^")
 . S HASH=$$HASH^BUSAAPI(LDT_"^"_USR_"^"_CAT_"^"_TYP_"^"_ACT_"^"_CAL_"^"_DSC)
 . ;
 . ;Retrieve original HASH
 . S OHASH=$G(^BUSAS(BSIEN,2))
 . ;
 . ;Compare
 . I OHASH]"",OHASH'=HASH D EVENT^BUSAARO(HIEN,"C","HASH mismatch in BUSA Summary entry: "_BSIEN,1)
 . ;
 . ;Archive original value
 . S:OHASH]"" HASH=OHASH
 . ;
 . ;Assemble the hash entry and output
 . S VALUE="^BUSAS("_BSIEN_",2)"
 . W !,VALUE
 . S RCNT=RCNT+1
 . S FSIZE=FSIZE+$L(VALUE)+1
 . S VALUE=HASH
 . W !,VALUE
 . S RCNT=RCNT+1
 . S FSIZE=FSIZE+$L(VALUE)+1
 . ;
 . ;Output the summary "B" cross reference
 . S VALUE="^BUSAS(""B"","_BSDATE_","_BSIEN_")"
 . I '$D(@VALUE) Q
 . W !,VALUE
 . S RCNT=RCNT+1
 . S FSIZE=FSIZE+$L(VALUE)+1
 . ;
 . ;Output the summary "C" cross reference (User) if defined
 . S USER=+$P($G(^BUSAS(BSIEN,0)),U,2)
 . I USER'=0 D
 .. S VALUE="^BUSAS(""C"","_$E(USER,1,30)_","_BSIEN_")"
 .. W !,VALUE
 .. S RCNT=RCNT+1
 .. S FSIZE=FSIZE+$L(VALUE)+1
 . ;
 . ;Process each DETAIL subscript
 . S BDIEN="" F  S BDIEN=$O(^BUSAD("B",BSIEN,BDIEN)) Q:BDIEN=""  D
 .. ;
 .. NEW DQUEUE,QUIT,VALUE,DFN,DQUEUEV,HASH,OHASH,ESTR,QGBL
 .. ;
 .. S QUIT="",DQUEUE="^BUSAD("_BDIEN_")" F  S DQUEUE=$Q(@DQUEUE) D  I QUIT Q
 ... ;
 ... ;Check if on the same detail entry
 ... NEW DIEN
 ... S DIEN=$P($P(DQUEUE,"(",2),",")
 ... I DIEN'=BDIEN S QUIT=1 Q
 ... ;
 ... ;Output the record reference string
 ... W !,DQUEUE
 ... S RCNT=RCNT+1
 ... ;
 ... ;Output the record value
 ... S DQUEUEV=$G(@DQUEUE)
 ... S DQUEUEV=$TR(DQUEUEV,$C(13),$C(28))  ;Convert $c(13) to $c(28)
 ... S DQUEUEV=$TR(DQUEUEV,$C(10),$C(29))  ;Convert $c(10) to $c(29)
 ... W !,DQUEUEV
 ... S RCNT=RCNT+1
 ... ;
 ... ;Increment the size
 ... S FSIZE=FSIZE+$L(DQUEUE)+$L(DQUEUEV)+2
 .. ;
 .. ;Calculate Detail HASH
 .. ;
 .. ;Assemble string
 .. S ESTR="",QGBL="^BUSAD("_BDIEN_")" F  S QGBL=$Q(@QGBL) Q:(QGBL'[BDIEN)!(QGBL[(BDIEN_",3"))  S ESTR=ESTR_@QGBL
 .. ;
 .. ;Get the hash
 .. S HASH=$$HASH^BUSAAPI(ESTR)
 .. ;
 .. ;Get the original HASH
 .. S OHASH=$G(^BUSAD(BDIEN,3))
 .. ;Compare
 .. I OHASH]"",OHASH'=HASH D EVENT^BUSAARO(HIEN,"C","HASH mismatch in BUSA Detail entry: "_BDIEN,1)
 .. ;
 .. ;Archive original value
 .. S:OHASH]"" HASH=OHASH
 .. ;
 .. ;Assemble the hash entry and output
 .. S VALUE="^BUSAD("_BDIEN_",3)"
 .. W !,VALUE
 .. S RCNT=RCNT+1
 .. S FSIZE=FSIZE+$L(VALUE)+1
 .. S VALUE=HASH
 .. W !,VALUE
 .. S RCNT=RCNT+1
 .. S FSIZE=FSIZE+$L(VALUE)+1
 .. ;
 .. ;Output the "B" cross reference if it exists
 .. S VALUE="^BUSAD(""B"","_BSIEN_","_BDIEN_")"
 .. I '$D(@VALUE) Q
 .. W !,VALUE
 .. S RCNT=RCNT+1
 .. S FSIZE=FSIZE+$L(VALUE)+1
 .. ;
 .. ;Output the "C" cross reference if it exists
 .. S DFN=$P($G(^BUSAD(BDIEN,0)),U,2) Q:DFN=""
 .. I DFN=0 Q
 .. I DFN'?1N.N S DFN=$C(34)_DFN_$C(34)
 .. S VALUE="^BUSAD(""C"","_DFN_","_BDIEN_")"
 .. I '$D(@VALUE) Q
 .. W !,VALUE
 .. S RCNT=RCNT+1
 .. S FSIZE=FSIZE+$L(VALUE)+1
 . ;
 . ;Capture last processed record
 . S LIEN=BSIEN
 . S LSTDT=BSDATE
 ;
 ;Write final record
 W !,"LAST RECORD"_U_RCNT_U_U
 ;
 ;Close the file
 I $$DEVICE^BUSAAUT("C",PATH,FNAME) G FQUIT
 ;
 ;Log to ^XTMP
 D EVENT^BUSAARO(HIEN,"C","Closed file "_FNAME_" for archive creation")
 D EVENT^BUSAARO(HIEN,"CS","1^File created")
 ;
 ;Log to BUSA
 S STS=$$LOG^BUSAAPI("A","S","","BUSAARAI","BUSA Archiving: Closed archive file "_FNAME_" ("_RCNT_" records)")
 ;
 ;Update history entry
 I +$G(HIEN) D  I $D(ERROR) S STOP=1 G FQUIT
 . NEW HUPDATE
 . I $G(LSTDT)]"" S HUPDATE(9002319.13,HIEN_",",.04)=LSTDT
 . I $G(LIEN)]"" S HUPDATE(9002319.13,HIEN_",",.06)=LIEN
 . I $G(RCNT)]"" S HUPDATE(9002319.13,HIEN_",",.07)=RCNT
 . I $D(HUPDATE) D FILE^DIE("","HUPDATE","ERROR")
 ;
 U 0
 ;
 ;Quit on success
 I STOP=2 D  Q 1
 . L -^XTMP("BUSAARCH",1) K ^XTMP("BUSAARCH","STS")
 . I $G(JOURNAL) D ENABLE^%NOJRN
 ;
FQUIT I $G(JOURNAL) D ENABLE^%NOJRN
 L -^XTMP("BUSAARCH",1)
 K ^XTMP("BUSAARCH","STS")
 Q 0
 ;
FOPEN(PATH,FIEN,FIENDT,SIZE,FNAME,RCNT,QUEUE,HIEN,AUSER) ;Open the new file
 ;
 NEW EXEC,NAMESPC,HUPDATE,ERROR,%,DIC,X,Y,DA,DLAYGO,DINUM,DO,DD,ONAMESPC,SITE,HEADER,STS
 ;
 ;Set up the filename
 S ONAMESPC=""
 S EXEC="S ONAMESPC=$"_"ZNSPACE" X EXEC  ;Namespace
 S SITE=$$GET1^DIQ(9999999.39,"1,",.01,"I")
 S FNAME="BUSA_"_ONAMESPC_"_"_SITE_"_"_$P(FIENDT,".")_"_"_FIEN_".txt"
 ;
 ;Open the file
 I $$DEVICE^BUSAAUT("W",PATH,FNAME) Q 0
 ;
 ;Log the file entry
 D NOW^%DTC
 S DIC(0)="L",DIC="^BUSAAH(",DLAYGO=DIC
 S X=%
 K DO,DD D FILE^DICN
 I '+Y Q 0
 S HIEN=+Y
 S HUPDATE(9002319.13,HIEN_",",.02)=AUSER
 S HUPDATE(9002319.13,HIEN_",",.03)=FIENDT
 S HUPDATE(9002319.13,HIEN_",",.05)=FIEN
 S HUPDATE(9002319.13,HIEN_",",.11)=FNAME
 S HUPDATE(9002319.13,HIEN_",",.14)="C"
 D FILE^DIE("","HUPDATE","ERROR")
 I $D(ERROR) Q 0
 ;
 ;Log to ^XTMP
 K ^XTMP("BUSAARCH","C",HIEN)
 K ^XTMP("BUSAARCH","V",HIEN)
 D EVENT^BUSAARO(HIEN,"C","Opened file "_FNAME_" for archive creation")
 D EVENT^BUSAARO(HIEN,"CF",FNAME)
 ;
 ;Log to BUSA
 S STS=$$LOG^BUSAAPI("A","S","","BUSAARAI","BUSA Archiving: Opened file "_FNAME_" for archive creation")
 ;
 I 'QUEUE U 0 W !,"Creating file: ",FNAME U IO
 S ^XTMP("BUSAARCH","STS")="Creating archive file: "_FNAME
 ;
 U IO
 ;
 ;Output the header record
 S HEADER=FNAME
 ;
 ;Output the record
 W HEADER
 ;
 ;Update the size
 S SIZE=$L(HEADER)
 ;
 ;Update the counter
 S RCNT=1
 ;
 Q 1
 ;
ERR ;Error occurred during process
 I $G(JOURNAL) D ENABLE^%NOJRN
 NEW %ERROR,EXEC
 S EXEC="S $"_"ZE=""<The BUSA AI process errored out>""" X EXEC
 S %ERROR="Please log a ticket with the BUSA Support Group for their assistance"
 D ^ZTER
 Q
