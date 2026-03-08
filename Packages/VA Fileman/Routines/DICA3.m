DICA3 ;SEA/TOAD-VA FileMan: Updater, Adder ;7/24/95  13:18 ; [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**17**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;11834;1508202
 
CREATE(DIFILE,DIEN,DIROOT,DIVALUE) 
 N DIENP S DIENP=","_$P(DIEN,",",2,999)
 S DIEN=$P(DIEN,",")
 N DINEXT S DINEXT=$P($G(@(DIROOT_"0)")),U,3)
 I DINEXT="" D  I $G(DIERR) S DIEN="" Q
 . N DIHEADER S DIHEADER=$$HEADER^DIDU2(.DIFILE,DIENP)
 . I '$G(DIERR) S @(DIROOT_"0)")=DIHEADER
GETNUM 
 N DINUM S DINUM=DIEN'="" I 'DINUM S DIEN=DINEXT\1
 N DIFAIL,DIOUT S DIFAIL=0,DIOUT=0 F  D  I DIOUT!DIFAIL Q
 . I 'DINUM S DIEN=DIEN+1
 . L +@(DIROOT_"DIEN)"):1
 . I '$T S DIFAIL=DINUM Q:'DIFAIL  D ERR(110,DIFILE,DIEN_DIENP) Q
 . I $D(@(DIROOT_"DIEN)")) L -@(DIROOT_"DIEN)") D  Q
 . . S DIFAIL=DINUM I 'DIFAIL Q
 . . D ERR(302,DIFILE,DIEN_DIENP)
 . S DIOUT=1
 I DIFAIL S DIEN="" Q
SETREC 
 S @(DIROOT_"DIEN,0)")=DIVALUE
 L +@(DIROOT_"0)"):1
 S $P(^(0),U,3,4)=DIEN_U_($P(@(DIROOT_"0)"),U,4)+1)
 I  L -@(DIROOT_"0)")
 S DIEN=DIEN_DIENP
 D XA^DIEFU(DIFILE,DIEN,.01,DIVALUE,"")
 Q
 
PROOT(DIFILE,DIEN) 
 ; ENTRY POINT--return the global root of a subfile's parent
 ; extrinsic function, all passed by value
 N DIENP S DIENP=$P(DIEN,",",2,999)
 Q $NA(@$$ROOT^DILFD($$PARENT(DIFILE),DIENP,1)@(+DIENP))
 
PARENT(DIFILE) 
 ; ENTRY POINT--return the file number of a subfile's parent
 ; extrinsic function, all passed by value
 Q $G(^DD(DIFILE,0,"UP"))
 
SUBFILE(DIFILE) 
 ; ENTRY POINT--return whether the file is a subfile
 ; extrinsic function, passed by value
 Q $D(^DD(DIFILE,0,"UP"))#2
 
ERR(DIERN,DIFILE,DIIENS,DIFIELD,DI1,DI2,DI3) 
 ; error logging procedure
 N DIPE
 N DI F DI="FILE","IENS","FIELD",1:1:3 S DIPE(DI)=$G(@("DI"_DI))
 D BLD^DIALOG(DIERN,.DIPE,.DIPE)
 Q
