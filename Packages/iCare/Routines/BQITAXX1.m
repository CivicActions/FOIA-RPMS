BQITAXX1 ;PRXM/HC/ALA - Delete Taxonomy Item ; 26 May 2006  1:32 PM
 ;;1.0;ICARE MANAGEMENT SYSTEM;**1**;May 21, 2007
 ;
 Q
 ;
DEL(DATA,IVALUE,TVIEN) ; EP -- BQI DELETE TAXONOMY ITEM
 ; Input
 ;   IVALUE - Internal entry number of taxonomy in structure, IEN;FILE REF
 ;            because this is a variable pointer value
 ;   TVIEN  - Internal entry number of the LOW/HIGH VALUE
 NEW UID,II,DA,DIK,CHK,X,RESULT,BQIDA,FILE
 S UID=$S($G(ZTSK):"Z"_ZTSK,1:$J)
 S DATA=$NA(^TMP("BQITXDEL",UID))
 K @DATA
 ;
 S II=0
 NEW $ESTACK,$ETRAP S $ETRAP="D ERR^BQITAXX1 D UNWIND^%ZTER" ; SAC 2006 2.2.3.3.2
 ;
 I '$$KEYCHK^BQIULSC("BGPZ TAXONOMY EDIT",DUZ) S BMXSEC="You do not have the security access to edit a taxonomy."_$C(10)_"Please see your supervisor or program manager." Q
 ;
 S IVALUE=$G(IVALUE,""),TVIEN=$G(TVIEN,"")
 I IVALUE="" S BMXSEC="No taxonomy selected" Q
 I TVIEN="" S BMXSEC="No value selected" Q
 ;
 S FILE=$$GREF^BQITAXX(IVALUE)
 S BQIDA=$$SPM^BQIGPUTL()
 S IEN=$O(^BQI(90508,BQIDA,10,"AC",IVALUE,""))
 I IEN=""!($P(^BQI(90508,BQIDA,10,IEN,0),U,4)'=1) S BMXSEC="Cannot delete entry in a non-site populated taxonomy" Q
 ;
 S @DATA@(II)="I00010RESULT"_$C(30)
 ;
 S DA(1)=$P(IVALUE,";",1),DA=TVIEN
 S DIK="^"_$P(IVALUE,";",2)_DA(1)_",21,"
 D ^DIK
 S CHK="^"_$P(IVALUE,";",2)_DA(1)_",21,"_DA_",0)"
 I '$D(@CHK) D
 . S RESULT=1
 . I FILE=9002228 D  ; Updated by/date are unique to ^ATXLAB
 .. S BQIUPD(FILE,DA(1)_",",.05)=DUZ
 .. S BQIUPD(FILE,DA(1)_",",.06)=DT
 .. D FILE^DIE("","BQIUPD","ERROR")
 .. K BQIUPD
 I $D(@CHK) S RESULT=0
 S II=II+1,@DATA@(II)=RESULT_$C(30)
 ;
DONE ;
 S II=II+1,@DATA@(II)=$C(31)
 Q
 ;
ERR ;
 D ^%ZTER
 NEW Y,ERRDTM
 S Y=$$NOW^XLFDT() X ^DD("DD") S ERRDTM=Y
 S BMXSEC="Recording that an error occurred at "_ERRDTM
 S II=II+1,^TMP("BQITXDEL",UID,II)=$C(31)
 Q
