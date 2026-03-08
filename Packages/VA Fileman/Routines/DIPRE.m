DIPRE ;SFISC/TKW - PRE-INIT PATCH DI*21*46 - MOVE NUMDATE4 AND NUMYEAR4 ;5/11/98  07:57
V ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
EN ; Move NUMYEAR4 and NUMDATE4 functions to proper IEN location
 N DIOLDDA,DIK,DA
 S DIOLDDA=$O(^DD("FUNC","B","NUMDATE4",0)) I DIOLDDA'=60 D
 . I DIOLDDA S DIK="^DD(""FUNC"",",DA=DIOLDDA D ^DIK
 . S ^DD("FUNC",60,0)="NUMDATE4"
 . S ^DD("FUNC",60,1)="S:X X=$E(X,4,5)_""/""_$E(X,6,7)_""/""_(1700+$E(X,1,3))"
 . S ^DD("FUNC",60,2)="X"
 . S ^DD("FUNC",60,9)="DATE IN 'MM/DD/YYYY' FORMAT"
 . S DIK="^DD(""FUNC"",",DA=60 D IX1^DIK
 . Q
 S DIOLDDA=$O(^DD("FUNC","B","NUMYEAR4",0)) I DIOLDDA'=61 D
 . I DIOLDDA S DIK="^DD(""FUNC"",",DA=DIOLDDA D ^DIK
 . S ^DD("FUNC",61,0)="NUMYEAR4"
 . S ^DD("FUNC",61,1)="S:X X=1700+$E(X,1,3)"
 . S ^DD("FUNC",61,2)="X"
 . S ^DD("FUNC",61,9)="YEAR NUMBER (YYYY) FOR A DATE"
 . S DIK="^DD(""FUNC"",",DA=61 D IX1^DIK
 . Q
 Q
 ;
 ; PATCH DI*21*29 - Add new WRITE identifier to DIALOG file (.84)
 ;S ^DD(.84,0,"ID","WRITE")="N DIALID S DIALID(1)=$P($G(^(0)),U,5) S:DIALI D(1)="""" DIALID=+$O(^(2,0)),DIALID(1)=$E($G(^(DIALID,0)),1,42) S DIALID(1,""F"")=""?10"" D EN^DDIOL(.DIALID)"
 ;Q
 ;
