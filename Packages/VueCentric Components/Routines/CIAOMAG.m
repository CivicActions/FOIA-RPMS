CIAOMAG ;MSC/IND/DKM - Imaging Extensions ;17-Dec-2010 16:07;PLS
 ;;1.1;VUECENTRIC COMPONENTS;013001,013002;March 12, 2008
 ;;Copyright 2000-2010, Medsphere Systems Corporation
 ;=================================================================
 ; RPC: CIAOMAG PATIMGS
 ; Call to return a list of images for a patient.
 ; Returns all images for a patient. Groups are returned as one
 ; image. Images are returned in reverse chronological order.
PATIMGS(DATA,MAGDFN) ;
 D IMAGES^MAGGTIG(.DATA,MAGDFN)
 D:$O(DATA(0)) FORMAT(.DATA)
 Q
 ; RPC: CIAOMAG GRPIMGS
 ; Return image list of a group.
 ; MAGIEN is the entry in file 2005.  We assume it is a group.
GRPIMGS(DATA,MAGIEN,BKG) ;
 D GROUP^MAGGTIG(.DATA,MAGIEN,.BKG)
 D FORMAT(.DATA)
 Q
 ; RPC: CIAOMAG TIUIMGS
 ; Return all images for a given TIU document.
 ; First get all image IENs, breaking groups into separate images.
 ; DATA    - Return array of image data entries
 ; DATA(0) - 1 ^ message  if successful, 0 ^ Error message if error.
 ; TIUDA   - IEN in file 8925
TIUIMGS(DATA,TIUDA) ;
 D IMAGES^MAGGNTI(.DATA,TIUDA)
 D FORMAT(.DATA)
 Q
 ; RPC: CIAOMAG PATPHOTO
 ; Call to return list of all photo IDs on file for a patient.
 ; The images are returned in reverse chronological order.
PATPHOTO(DATA,MAGDFN) ;
 D PHOTOS^MAGGTIG(.DATA,MAGDFN)
 D FORMAT(.DATA)
 Q
 ; RPC: CIAOMAG GETURL
 ; Get url associated with MAGXX
GETURL(DATA,MAGXX) ;
 N MAGFILE
 D:$D(^MAG(2005,MAGXX,0)) INFO^MAGGTII
 S DATA=$P($G(MAGFILE),U,2)
 S:DATA["/" DATA=$TR(DATA,"\","/")
 Q
 ; RPC: CIAOMAG SHARES
 ; Get list of image shares
 ; TYPE = MAG, EKG, WORM, or ALL
SHARES(DATA,TYPE) ;
 N TMP,INDX,N0,N2,N3,N6,CNT,SHARE,VALUE,DFLT,X
 S DFLT=$P(^MAG(2006.1,1,0),U,3)
 S CNT=1,INDX=0
 S:'$L($G(TYPE)) TYPE="ALL"
 F  S INDX=$O(^MAG(2005.2,INDX)) Q:'INDX  D
 .S N0=$G(^MAG(2005.2,INDX,0)),N2=$G(^(2)),N3=$G(^(3)),N6=$G(^(6))
 .I TYPE'="ALL",$P(N0,U,7)'[TYPE Q
 .Q:'$P(N0,U,6)                                                        ; Don't return offline shares
 .S SHARE=$P(N0,U,2)
 .S:$E(SHARE,$L(SHARE))="\" SHARE=$E(SHARE,1,$L(SHARE)-1)
 .S $P(SHARE,U,2)=$P(N0,U,7)                                           ; Physical reference (path)
 .S $P(SHARE,U,3)=$P(N0,U,6)                                           ; Operational Status 0=OFFLINE 1=ONLINE
 .S $P(SHARE,U,4)=$P(N2,U)                                             ; Username
 .S $P(SHARE,U,5)=$P(N2,U,2)                                           ; Password
 .S $P(SHARE,U,6)=$P(N6,U)                                             ; MUSE Site #
 .S:$P(N6,U,2)'="" $P(SHARE,U,7)=^MAG(2006.17,$P(N6,U,2),0)            ; MUSE version #
 .S $P(SHARE,U,8)=$P(N3,U,5)                                           ; Network location SITE
 .S:'$D(TMP(SHARE)) TMP(SHARE)=INDX
 S INDX=""
 F  S INDX=$O(TMP(INDX)) Q:INDX=""  D
 .I TMP(INDX)=DFLT S X=0
 .E  S X=CNT,CNT=CNT+1
 .S DATA(X)=TMP(INDX)_U_INDX
 Q
 ; Format return data
FORMAT(DATA) ;
 N I,IEN
 S I=0
 F  S I=$O(DATA(I)) Q:'I  D
 .S IEN=+$P(DATA(I),U,2)
 .S $P(DATA(I),U,24)=$P($G(^MAG(2005,IEN,2)),U)                        ; capture date/time
 .S $P(DATA(I),U,25)=$P($G(^MAG(2005,IEN,2)),U,6)_";"_$P($G(^MAG(2005,IEN,2)),U,7) ; parentfile;ien
 .S $P(DATA(I),U,26,27)=$P($G(^MAG(2005,IEN,0)),U,3,4)
 .I ($P($P(DATA(I),U,4),"~")=-1),($P(DATA(I),U,7)=64) D
 ..S $P(DATA(I),U,4)="http"_$P($P(DATA(I),U,3),"/http",2,999),$P(DATA(I),U,8)="REMOTE URL"
 ..I $P(DATA(I),U,4)["\http" S $P(DATA(I),U,4)="http"_$P($P(DATA(I),U,3),"\http",2,999)
 ..S $P(DATA(I),U,3)=$P(DATA(I),U,4)
 .I $G(DUZ),+$P(DATA(I),U,25)=8925 D
 ..N IEN,X
 ..S IEN=+$P($P(DATA(I),U,25),";",2)
 ..Q:'IEN
 ..S X=$P($G(^TIU(8925,IEN,0)),U,5)                                    ;Get STATUS
 ..Q:'X
 ..S X=$P($G(^TIU(8925.6,X,0)),U)
 ..I X'="UNSIGNED",X'="UNCOSIGNED" Q
 ..;Check AUTHOR, EXPECTED SIGNER, EXPECTED COSIGNER, ATTENDING PHYSICIAN
 ..S X=$G(^TIU(8925,IEN,12))
 ..I $P(X,U,2)'=DUZ,$P(X,U,4)'=DUZ,$P(X,U,9)'=DUZ,$P(X,U,8)'=DUZ D
 ...K DATA(I)                                                          ;Delete if doesn't match user
 Q
 ; RPC: CIAOMAG GETRAURL
 ; Get Radiology URL associated with Order ID
GETRAURL(DATA,ORID,DFN) ; EP
 S DATA=$$I(ORID)
 Q
I(IFN) ;EP - Get URL from Order Number
 N I
 Q:'$D(^RAO(75.1,"AMSC",+IFN)) ""
 S I=$O(^(+IFN,0)) Q:'I ""
 Q $G(^RAO(75.1,I,21400))
