BPDMRDRN ;IHS/CMI/LAB - MAIN DRIVER FOR PDM REPORT; ; 08 Apr 2019  2:51 PM
 ;;2.0;CONTROLLED DRUG EXPORT SYSTEM;**1,3,4,5,6,7**;NOV 15, 2011;Build 51
 ;
START ;
 D EN^XBVK("BPDM")
 K ^TMP($J)
 S BPDMPTYP="P"
START1 ;
 D HOME^%ZIS S BPDMBS=$S('$D(ZTQUEUED):IOBS,1:"")
 S BPDMQFLG=0
 S (BPDMERRC,BPDMCNT,BPDMRCNT)=0
 S BPDMRTYP=1
 D ^BPDMRD2N
 I '$G(BPDMSITE) W !,"Site selection is required!" D EOJ Q
 ;
 I BPDMQFLG=99 D EOJ Q
 I BPDMQFLG D BULL^BPDMDR,EOJ Q
DRIVER ;called from TSKMN+2
 S BPDM("BT")=$H
 D NOW^%DTC S BPDM("RUN START")=%,BPDM("MAIN TX DATE")=$P(%,".") K %,%H,%I
 S BPDMCNT=$S('$D(ZTQUEUED):"X BPDMCNT1  X BPDMCNT2",1:"S BPDMCNTR=BPDMCNTR+1"),BPDMCNT1="F BPDMCNTL=1:1:$L(BPDMCNTR)+1 W @BPDMBS",BPDMCNT2="S BPDMCNTR=BPDMCNTR+1 W BPDMCNTR,"")"""
 I '$G(BPDMZRO) D PROCESS^BPDMDR1N ;            Generate transactions
 ;
 I BPDMQFLG D BULL^BPDMDR,EOJ Q
 ;
 I '$G(BPDMZRO) D PASTPROC  ;look at all past RX for resend
 ;
 I BPDMQFLG D BULL^BPDMDR,EOJ Q
ZERO ;-- zero goes here
 I $$ZEROCHKN^BPDMCHKN(),'$D(^TMP($J,"EXPORT")) D  ;this is for reviewed but no exported rx's
 . S BPDMZRO=1
 . I '$D(ZTQUEUED) W !,"Since this is the first run for today, I will now check to see if a ZERO REPORT needs to be generated."
 . ;lets kill off the "ABF" for this entry here
 . K ^BPDMLOG("ABF",(9999999.999999-BPDM("RUN BEGIN")),BPDMOSIT,BPDMRTYP,BPDM("RUN LOG"))
 . D ZEROSET^BPDMZERO(BPDMRST,BPDMYST)
 . D UPLOG(4)
 I '$G(BPDMZRO),'$D(^TMP($J,"EXPORT")) D  Q
 . W:'$D(ZTQUEUED) !,"No prescriptions to export, file and log not created."
 . D DELLOG^BPDMDR
 . D EOJ
 I '$D(ZTQUEUED) W !!,"Writing out transaction file...."
 I '$G(BPDMZRO) D
 . D TAPE^BPDMDR1N
 I $G(BPDMZRO) D
 . D RPT^BPDMZERO  ;do zero report
 . S BPDM("REC COUNT")=0
 I BPDMQFLG D BULL^BPDMDR,EOJ Q
 I '$D(ZTQUEUED) W !!,"Updating Log Entry...."
 D LOG^BPDMDR1N
 I $G(BPDMNOFI) D  Q  ;20220223 patch 6 73211
 . ;20220714 maw removed duplicate message
 . ;I '$D(ZTQUEUED) W !,"Error in file export, failed to create export file"
 . D EOJ
 ;add code here to change verbiage if autosend 1107 field is set to yes
 S BPDMAUUP=$$GET1^DIQ(9002315.01,BPDMSITE,1107,"I")
 ;S BPDMAUUP=0  ;20220518 cmi/maw patch 6 remove auto upload verbiage since now in BCOM production
 I '$$OPENSSH() D
 . Q:'$G(BPDMAUUP)
 . W !,"OpenSSH is not installed/configured on the server..."  ;, Auto Upload is disabled for this run..."
 . S BPDMAUUP=0  ;turn off auto upload if OpenSSH isnt installed
 I $G(BPDMZRO) D
 . Q:$G(BPDMZFL)  ;error writing file so no message displays
 . W !!,"No reportable prescriptions processed during export period. Zero report created."
 . I $G(BPDMAUUP) W !,"The file ",BPDMFILE," will auto upload to the state.",!
 . ;I '$G(BPDMAUUP) W !,"You must now send the file ",BPDMFILE," to the state.",!
 . W !,"You must now send the file ",BPDMFILE," to the state.",!
 I '$G(BPDMAUUP),'$G(BPDMZRO) W !!,"Successfully completed...you must now send the file ",BPDMFILE," to the state.",!
 I $G(BPDMAUUP),'$G(BPDMZRO) W !!,"Successfully completed...the file ",BPDMFILE," will auto upload to the state.",!
 I $G(BPDMAUUP) D
 . ;lets kickoff the autoftp process here
 . D FTPSEND^BPDMSFTP(BPDM("RUN LOG"))
 . I $P($G(BPDMFTPK),"^")=0 W:'$D(ZTQUEUED) !,BPDMFILE_" has been auto uploaded successfully." Q
 . W:'$D(ZTQUEUED) !,BPDMFILE_" was NOT uploaded successfully, see log entry "_BPDM("RUN LOG")_" for details."
 D EOJ
 Q
 ;
OPENSSH() ;-- check for OpenSSH on Windows
 N BPDMOS,FOLD,OSH,Y
 S BPDMOS=$$OS^%ZOSV()
 I $G(BPDMOS)="UNIX" Q 1
 S FOLD=$$GET1^DIQ(9002315.01,BPDMSITE,1410)
 I FOLD="" Q 0
 S Y=$$LIST^%ZISH(FOLD,"ssh*",.OSH)
 I $O(OSH("")) Q 1
 Q 0
 ;
UPLOG(RTYP) ;-- update the log
 S DIE="^BPDMLOG(",DA=BPDM("RUN LOG"),DR=".02////"_$G(BPDM("RUN BEGIN"))_";.03////"_$G(BPDM("RUN END"))_";.08///"_RTYP_";.1////"_BPDMOSIT
 D ^DIE
 S DIK="^BPDMLOG(",DA=BPDM("RUN LOG"),DIK(1)=".1" D EN^DIK
 Q
 ;
TEST ;EP - called from option
 D EN^XBVK("BPDM")
 S BPDMPTYP="T"
 G START1
ERR ;
 Q
DATE(D) ;EP
 I $G(D)="" Q ""
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
RZERO(V,L) ;ep right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
LBLK(V,L) ;left blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=" "_V
 Q V
RBLK(V,L) ;EP right blank fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_" "
 Q V
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
EOJ ; EOJ
 D ^XBFMK
 D EN^XBVK("BPDM")
 K ^TMP($J)
PAUSE ;EP
 I $D(ZTQUEUED) Q
 S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
CALLDIE ;EP
 Q:'$D(DA)
 Q:'$D(DIE)
 Q:'$D(DR)
 D ^DIE
 D ^XBFMK
 K DLAYGO,DIADD
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
PASTPROC ;go back 180 days and see if any need to be re-sent due to change
 ;
 ;IF V3.0 AND HID Q
 I BPDMVER="3.0",BPDMPDMP="HID" Q  ;no processing, done manually
 N BPDMLR
 S BPDMLR=$$FNDLST^BPDMDR1N(BPDMOSIT,1)
 S BPDMD=$$FMADD^XLFDT(DT,-181)  ;180 days first run of the day
 I $G(BPDMLR),$P($P($G(^BPDMLOG(BPDMLR,0)),U),".")=DT,$G(BPDMPTYP)="P" S BPDMD=$$FMADD^XLFDT(DT,-7)  ;7 days for all other real time runs 20231102 maw p8
 S BPDM("EDIT CHECK")=BPDMD  ;20231205 maw p7
 F  S BPDMD=$O(^BPDMLOG("AEXP",BPDMD)) Q:BPDMD'=+BPDMD  D
 .S BPDMR=0 F  S BPDMR=$O(^BPDMLOG("AEXP",BPDMD,BPDMR)) Q:BPDMR'=+BPDMR  D
 ..S BPDMIEN=0 F  S BPDMIEN=$O(^BPDMLOG("AEXP",BPDMD,BPDMR,BPDMIEN)) Q:BPDMIEN'=+BPDMIEN  D
 ...;Q:$P(^BPDMLOG(BPDMIEN,0),U,9)="T"  ;don't bother with "test" exports
 ...Q:$P(^BPDMLOG(BPDMIEN,0),U,10)'=BPDMOSIT  ;that is another site's log entry
 ...S BPDMIENI=0 F  S BPDMIENI=$O(^BPDMLOG("AEXP",BPDMD,BPDMR,BPDMIEN,BPDMIENI)) Q:BPDMIENI'=+BPDMIENI  D
 ....Q:'$D(^BPDMLOG(BPDMIEN,31,BPDMIENI,0))  ;ihs/cmi/maw 06/29/2014 p3 for existing xref but no data
 ....S BPDMNODE=^BPDMLOG(BPDMIEN,31,BPDMIENI,0)
 ....S BPDMRF=+$P(BPDMNODE,U,3)
 ....S BPDMPFI=+$P(BPDMNODE,U,4)
 ....Q:'$$LAST(BPDMD,BPDMR,BPDMIEN,BPDMIENI,BPDMRF,BPDMPFI)
 ....S BPDMCEXP=0
 ....S G=0 D DELCHK I G Q
 ....S G=0 D RTSCHK I G  ; Q
 ....;now check edits for revision to be sent
 ....D EDITCHK
 ....I '$G(BPDMECHK) D PUCHK  ;20230822 maw p7 check for pickup and create edit
 ....K BPDMECHK
 ....;D REISSUE
 S BPDMRELY=""
 Q
 ;
EDITCHK ;
 ;check activity log for "EDIT"
 S BPDMACTL=""
 S BPDMPULG=""
 N RXRF,EX
 S D=""
 ;I '$G(BPDMD) S BPDMD=$G(BPDMCHKD)  ;20250411 maw for edit check on original
 S EX=0 F  S EX=$O(^PSRX(BPDMR,"A",EX)) Q:'EX  D
 .I $P(^PSRX(BPDMR,"A",EX,0),U,2)'="E" Q
 .S D=$P($P(^PSRX(BPDMR,"A",EX,0),U,1),".")
 .I D,D<$P(BPDMD,".") Q  ;20231205 maw mod
 .;I BPDMR=673207 B
 .S RXRF=$P(^PSRX(BPDMR,"A",EX,0),U,4)
 .;S BPDMRF=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,3)
 .Q:RXRF'=BPDMRF  ;20231005 maw p7
 .;S BPDMPFI=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,4)
 .S BPDMPULG=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,9)
 .I $O(^BPDMLOG("AIR",BPDMR)) D  ;20240410 p7 maw for multi pu logs
 .. N REF,XDA,XIEN
 .. S XDA=0 F  S XDA=$O(^BPDMLOG("AIR",BPDMR,XDA)) Q:'XDA  D
 ... S XIEN=0 F  S XIEN=$O(^BPDMLOG("AIR",BPDMR,XDA,XIEN)) Q:'XIEN  D
 .... S REF=$P($G(^PSRX(BPDMR,"ZPAL",XDA,0)),U,2)
 .... Q:REF'=RXRF
 .... S BPDMPULG=REF
 .S BPDMPART=$S(BPDMPFI:"01",1:"02")
 .S BPDMACTL=EX
 .Q:$$EXPORTED^BPDMUTL1(BPDM("EDIT CHECK"),BPDMR,$G(BPDMRF),"01",$G(BPDMACTL))  ;20231129 was this already exported today?
 .S BPDMSTAT="01"
 .S BPDMCEXP=1
 .D PROCESS3^BPDMDR1N
 .S BPDMCEXP=0
 .;S G=0
 Q
 ;
PUCHK ;
 N PDA,RF,PDAA,PDRF
 S RF=$P($G(^BPDMLOG(BPDMIEN,31,BPDMIENI,0)),U,3)
 S PDA=0 F  S PDA=$O(^BPDMLOG("AIR",BPDMR,PDA)) Q:'PDA  D
 .S PDAA=0 F  S PDAA=$O(^BPDMLOG("AIR",BPDMR,PDA,PDAA)) Q:'PDAA  D
 ..I PDAA,PDAA<BPDM("RUN BEGIN") Q
 ..S PDRF=$P($G(^PSRX(BPDMR,"ZPAL",PDA,0)),U,2)
 ..Q:RF'=PDRF  ;20231116 maw added
 ..S BPDMAIEN=PDA
 ..S BPDMSTAT="01"
 ..S BPDMPFI=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,4)
 ..S BPDMPART=$S(BPDMPFI:"01",1:"02")
 ..S BPDMCEXP=1
 ..D PROCESS3^BPDMDR1N
 ..S G=1
 Q
 ;
REISSUE ;
 ;20230511 maw 96246 patch 7 changed code to check for reissue
 K BPDMRTSC
 S BPDMACTL=""
 S G="",D="" S X=0 F  S X=$O(^PSRX(BPDMR,"A",X)) Q:X'=+X!(G)  D
 .Q:$P(^PSRX(BPDMR,"A",X,0),U,2)'="Z"
 .S D=$P(^PSRX(BPDMR,"A",X,0),U,1)
 .I D,D<BPDMD Q
 .S BPDMSTAT="00"
 .S BPDMRF=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,3)
 .S BPDMPFI=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,4)
 .S BPDMPART=$S(BPDMPFI:"01",1:"02")
 .S BPDMCEXP=1
 .S BPDMACTL=X
 .D PROCESS3^BPDMDR1N
 .S G=1
 Q
 ; 
LAST(D,P,IEN,IENI,RF,PFI)  ;was this the last instance of this prescription
 ;loop through APE for this prescriptin and get last one
 NEW CDATE,CIEN,CIENI,CRF,CPFI,LDATE,LIEN,LIENI,LRF,LPFI
 S CDATE=0 F  S CDATE=$O(^BPDMLOG("APE",P,CDATE)) Q:CDATE=""  D
 .S CIEN=0 F  S CIEN=$O(^BPDMLOG("APE",P,CDATE,CIEN)) Q:CIEN'=+CIEN  D
 ..S CIENI=0 F  S CIENI=$O(^BPDMLOG("APE",P,CDATE,CIEN,CIENI)) Q:CIENI'=+CIENI  D
 ...Q:'$D(^BPDMLOG(CIEN,31,CIENI,0))  ;ihs/cmi/maw 06/29/2014 p3 for existing xref but no data
 ...S CRF=+$P(^BPDMLOG(CIEN,31,CIENI,0),U,3),CPFI=+$P(^BPDMLOG(CIEN,31,CIENI,0),U,4)
 ...Q:CRF'=RF  ;not this one
 ...Q:PFI'=CPFI  ;not a partial
 ...S LDATE=CDATE,LIEN=CIEN,LRF=CRF,LPFI=CPFI
 I LDATE=D,LIEN=IEN,RF=LRF,PFI=LPFI Q 1  ;the one past in is the last one
 Q 0
DELCHK ;
 Q:$P($G(^PSRX(BPDMR,"STA")),U)'=13  ;not deleted
 ;check activity log for "RX DELETED"
 S BPDMACTL=""
 S G="",D="" S X=0 F  S X=$O(^PSRX(BPDMR,"A",X)) Q:X'=+X!(G)  D
 .I ^PSRX(BPDMR,"A",X,0)'["RX DELETED" Q
 .S D=$P($P(^PSRX(BPDMR,"A",X,0),U,1),".")
 .I D,D<BPDMD Q
 .S BPDMSTAT="02"
 .S BPDMRF=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,3)
 .S BPDMPFI=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,4)
 .S BPDMPART=$S(BPDMPFI:"01",1:"02")
 .S BPDMRELY="" I BPDMVER="3.0",BPDMPDMP="RH" S BPDMRELY=1
 .S BPDMCEXP=1
 .S BPDMACTL=X
 .D PROCESS3^BPDMDR1N
 .S G=1
 .S BPDMRELY=""
 Q
DISEDIT ;DISCONTINUED (EDIT) SENDS A VOID
 Q:$P($G(^PSRX(BPDMR,"STA")),U)'=15  ;not deleted
 ;check activity log for "RX DELETED"
 S BPDMACTL=""
 S G="",D="" S X=0 F  S X=$O(^PSRX(BPDMR,"A",X)) Q:X'=+X!(G)  D
 .I ^PSRX(BPDMR,"A",X,0)'["Discontinued due to editing. New Rx" Q
 .S D=$P($P(^PSRX(BPDMR,"A",X,0),U,1),".")
 .I D,D<BPDMD Q
 .S BPDMSTAT="02"
 .S BPDMRF=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,3)
 .S BPDMPFI=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,4)
 .S BPDMPART=$S(BPDMPFI:"01",1:"02")
 .S BPDMCEXP=1
 .S BPDMACTL=X
 .D PROCESS3^BPDMDR1N
 .S G=1
 Q
RTSCHK ;
 N OK
 S OK=0
 K BPDMOFD
 S BPDMRTSC=0
 S BPDMACTL=""
 S BPDMRF=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,3)
 S BPDMPFI=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,4)
 S BPDMOFD=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,6)
 S BPDMPART=$S(BPDMPFI:"01",1:"02")
 S BPDMPULG=$P(^BPDMLOG(BPDMIEN,31,BPDMIENI,0),U,9)
 S D=$$RTSD(BPDMR,BPDMRF,BPDMPFI)
 ;cmi/maw may need to remove until next comment line
 I D="",$G(BPDMRF),'$D(^PSRX(BPDMR,1,BPDMRF)) D  Q  ;cmi/maw 20211029 patch 5 check activity log
 . S G="" S X=0 F  S X=$O(^PSRX(BPDMR,"A",X)) Q:X'=+X!(G)  D
 ..;20220228 patch 6 11950
 ..S OK=0  ;20220831 maw reset OK every time
 ..S D=$P(^PSRX(BPDMR,"A",X,0),U,1)  ;20220831 maw move this above the status check
 ..I $P(^PSRX(BPDMR,"A",X,0),U,4)'=BPDMRF Q  ;20220831 maw move this above the status check
 ..I D,D<BPDMD Q  ;20220831 maw move this above the status check
 ..I $P(^PSRX(BPDMR,"A",X,0),U,2)="I" S OK=1
 ..Q:'OK
 ..;end of mods
 ..S BPDMSTAT="02"
 ..S BPDMRTSC=1
 ..S BPDMCEXP=1
 ..S BPDMACTL=X
 ..D PROCESS3^BPDMDR1N
 ..S G=1
 I D="",$G(BPDMRF),$D(^PSRX(BPDMR,1,BPDMRF)) D  Q  ;cmi/maw 20211029 patch 5 check activity log
 . S G="" S X=0 F  S X=$O(^PSRX(BPDMR,"A",X)) Q:X'=+X!(G)  D
 ..;20220228 patch 6 11950
 ..S OK=0  ;20220831 maw reset OK every time
 ..S D=$P(^PSRX(BPDMR,"A",X,0),U,1)
 ..I $P(^PSRX(BPDMR,"A",X,0),U,4)'=BPDMRF Q
 ..I D,D<BPDMD Q
 ..I $P(^PSRX(BPDMR,"A",X,0),U,2)="I" S OK=1
 ..Q:'OK
 ..;end of mods
 ..S BPDMSTAT="02"
 ..S BPDMRTSC=1
 ..S BPDMCEXP=1
 ..S BPDMACTL=X
 ..D PROCESS3^BPDMDR1N
 ..S G=1
 ;cmi/maw end of mods for RTS activity log
 I D="",'$G(BPDMRF) D  Q  ;check activity log
 . S G="" S X=0 F  S X=$O(^PSRX(BPDMR,"A",X)) Q:X'=+X!(G)  D
 ..;20220228 patch 6 11950
 ..S OK=0  ;20220831 maw reset OK every time
 ..S D=$P(^PSRX(BPDMR,"A",X,0),U,1)
 ..I $P(^PSRX(BPDMR,"A",X,0),U,4)'=0 Q
 ..I D,D<BPDMD Q
 ..I $P(^PSRX(BPDMR,"A",X,0),U,2)="I" S OK=1
 ..Q:'OK
 ..;end of mods
 ..S BPDMSTAT="02"
 ..S BPDMRTSC=1
 ..S BPDMCEXP=1
 ..S BPDMACTL=X
 ..D PROCESS3^BPDMDR1N
 ..S G=1
 ..S BPDMRELY=""
 I $G(D),D<BPDMD Q
 S BPDMSTAT="02"
 S BPDMRELY="" I BPDMVER="3.0",BPDMPDMP="RH" S BPDMRELY=1
 S BPDMRTSC=1
 S BPDMCEXP=1
 D PROCESS3^BPDMDR1N
 S G=1
 S BPDMRELY=""
 Q
RTSD(P,R,F) ;
 NEW T
 S T=""
 I $G(R) D  Q T  ;refill
 .S T=$P($G(^PSRX(P,1,R,0)),U,16)
 I $G(F) D  Q T
 .S T=$P($G(^PSRX(P,"P",F,0)),U,16)
 S T=$P($G(^PSRX(P,2)),U,15)
 Q T
 ;
TESTFLG ;-- turn on/off test flag
 S DIC="^BPDMSITE(",DIC(0)="AEMQZ" D ^DIC
 Q:Y<0
 S DA=+Y
 S DIE=DIC,DR=1108 D ^DIE
 Q
 ;
NEWQ ;-- lets go through the PDM SITE PARAMETER file and queue each one individually
 ;20220208 Patch 6 76077
 N IDA,IIEN
 S IDA=0 F  S IDA=$O(^BPDMSITE(IDA)) Q:'IDA  D
 . S IIEN=$P($G(^BPDMSITE(IDA,0)),U)
 . Q:'$P($G(^BPDMSITE(IDA,11)),U,9)
 . S ZTQPARAM=$P($G(^PS(59,IIEN,0)),U)
 . D QUEUE
 . D EOJ
 . H 30  ;lets hold a bit so another log can be created
 Q
 ;
QUEUE ;EP - called from option that can be scheduled to run automatically
 K BPDMDDR
 N BPDMQLR
 I $D(ZTQUEUED) S BPDM("SCHEDULED")=""
 S BPDM("RUN")="NEW" ;      Let BPDMDRI know this is a new run.
 S BPDMSITE=$O(^PS(59,"B",ZTQPARAM,0))
 I 'BPDMSITE S BPDMQFLG=1,BPDMQMSG="Site file not known" D BULL^BPDMDR,EOJ Q
 S BPDMPTYP="P"
 S BPDMQLR=$$FNDLOG^BPDMRDRN(BPDMSITE,1)
 I $G(BPDMQLR),$P($G(^BPDMLOG(BPDMQLR,0)),U,7)="R" Q
 S BPDMSITE=$O(^BPDMSITE("B",BPDMSITE,0))
 I 'BPDMSITE S BPDMQFLG=1,BPDMQMSG="Site file not known" D BULL^BPDMDR,EOJ Q
 K ^TMP($J)
 S BPDMQFLG=0
 S (BPDMERRC,BPDMCNT,BPDMRCNT)=0
 S BPDMRTYP=1
B D ^BPDMRD2N ;           Do initialization
 I BPDMQFLG D BULL^BPDMDR,EOJ Q
 D DRIVER
 Q
 ;
FNDLOG(SITE,TYP) ;-- find the last log end time and start there
 N LST,LDA
 S LDA=0 F  S LDA=$O(^BPDMLOG("ABF",LDA)) Q:'LDA!($G(LST))  D
 . S LIEN=0 F  S LIEN=$O(^BPDMLOG("ABF",LDA,SITE,TYP,LIEN)) Q:'LIEN!($G(LST))  D
 .. I $G(BPDMPTYP)="P",$P($G(^BPDMLOG(LIEN,0)),U,9)="T" Q  ;maw beta testing
 .. S LST=LIEN
 Q $G(LST)
 ;
