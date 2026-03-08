ABMDF35Y ; IHS/SD/SDR - New HCFA-1500 (02/12) Format ;   
 ;;2.6;IHS Third Party Billing;**29**;NOV 12, 2009;Build 562
 ;IHS/SD/SDR 2.6*29 CR10875 Call ABMDF35Y if Medicare is secondary
 ;
 I ABMP("ITYP")'="R" Q  ;insurer type 'R' for active insurer
 ;
 K ABMT
 S (ABMT,ABMTSV)=+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)
 S ABMT=ABMT_" "  ;make it treat ABMT like string, not numeric
 S ABMTF=0
 S ABMCNT=1
 F  S ABMT=$O(^ABMDBILL(DUZ(2),"B",ABMT)) Q:(($G(ABMT)="")!(ABMTF=1))  D
 .I +$G(ABMT)'=ABMTSV S ABMTF=1 Q  ;only do the bill in question
 .S ABMTA=0
 .F  S ABMTA=$O(^ABMDBILL(DUZ(2),"B",ABMT,ABMTA)) Q:'ABMTA  D
 ..I $P($G(^ABMDBILL(DUZ(2),ABMTA,0)),U,4)="X" Q  ;skip if cancelled bill
 ..S ABMT("LST",ABMCNT)=$P($G(^ABMDBILL(DUZ(2),ABMTA,0)),U,4)_U_$P($G(^ABMDBILL(DUZ(2),ABMTA,2)),U,2)_U_ABMTA_U_$P($G(^ABMDBILL(DUZ(2),ABMTA,0)),U,8)  ;bill status^insurer type^BDFN^insurer
 ..S ABMT("ILST",$P($G(^ABMDBILL(DUZ(2),ABMTA,0)),U,8))=1  ;list of insurers billed or billing
 ..S ABMCNT=+$G(ABMCNT)+1
 I '("^B^C^"[("^"_($P($G(ABMT("LST",1)),U)_"^"))&($P($G(ABMT("LST",2)),U,2)="R")) Q  ;stop here if first bill isn't billed/complete and second bill isn't to Medicare
 ;
 S X=$P(ABMT("LST",1),U,3)
 ;SBR^ABMUTLP resets a few variables so have to save and then restore afterwards
 S (ABMISV,ABMINS)=ABMP("INS")
 S ABMBLSV=ABMP("BDFN")
 D SBR^ABMUTLP(X)
 S (ABMP("INS"),ABMINS)=ABMISV
 S ABMP("BDFN")=ABMBLSV
 I (+$G(ABMP("PH"))=0) Q  ;no policy holder-stop here
 S $P(ABMF(3),U)=$P($G(^DPT(ABMP("PDFN"),0)),U)  ;patient name not Medicare name FL2
 S $P(ABMF(3),U,5)=$P($G(^AUPN3PPH(ABMP("PH"),0)),U)  ;PH name FL4
 S $P(ABMF(5),U,6)=$P($G(^AUPN3PPH(ABMP("PH"),0)),U,9)  ;PH address FL7
 S $P(ABMF(7),U,3)=$P($G(^AUPN3PPH(ABMP("PH"),0)),U,11)  ;PH city FL7
 S $P(ABMF(7),U,4)=$P($G(^DIC(5,$P($G(^AUPN3PPH(ABMP("PH"),0)),U,12),0)),U,2)  ;PH state FL7
 S $P(ABMF(9),U,3)=$P($G(^AUPN3PPH(ABMP("PH"),0)),U,13)  ;PH zip FL7
 S $P(ABMF(9),U,4)=$P($G(^AUPN3PPH(ABMP("PH"),0)),U,14)  ;PH phone FL7
 S $P(ABMF(11),U)=""  ;leave blank FL9
 S $P(ABMF(11),U,2)=ABMP("PNUM")  ;policy# FL11
 S $P(ABMF(13),U)=""  ;leave blank FL9a
 S $P(ABMF(13),U,4)=$P($G(^AUPN3PPH(ABMP("PH"),0)),U,19)  ;PH DOB FL 11a
 F ABMI=5,6 S $P(ABMF(13),U,ABMI)=""  ;null both fields, then set correct one in the next line
 S $P(ABMF(13),U,$S($P($G(^AUPN3PPH(ABMP("PH"),0)),U,8)="F":6,1:5))="X"  ;PH gender FL 11a
 S:(+$P($G(^AUPN3PPH(ABMP("PH"),0)),U,16)'=0) $P(ABMF(15),U,4)=$P($G(^AUTNEMPL($P($G(^AUPN3PPH(ABMP("PH"),0)),U,16),0)),U)  ;PH employer FL 11b
 S $P(ABMF(17),U,3)=$P($G(^AUTNINS($P($G(^AUPN3PPH(ABMP("PH"),0)),U,3),0)),U)  ;insurer FL 11c
 S $P(ABMF(19),U)=""  ;leave blank 9d
 S $P(ABMF(19),U,3)="",$P(ABMF(19),U,4)=""  ;leave 11d blank
 ;
 S ABMTI=0
 S ABMTIF=0
 F  S ABMTI=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABMTI)) Q:'ABMTI  D  Q:(ABMTIF=1)
 .S ABMTIA=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABMTI,0))
 .I +$G(ABMT("ILST",$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMTIA,0)),U)))=0 S ABMTIF=1
 ;
 I (+$G(ABMTI)'=0) D
 .I ($O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABMTI,0))'=0) D  ;get tertiary info
 ..S ABMT=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,"C",ABMTI,0))
 ..S ABMTRE=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMT,0)),U)
 ;
 I +$G(ABMTRE)'=0 I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMT,0)),U,3)="U" Q  ;there is a tertiary but it's unbillable
 ;
 I +$G(ABMTRE)'=0 D
 .S ABMTREI=$$GET1^DIQ(9999999.181,$$GET1^DIQ(9999999.18,ABMTRE,".211","I"),1,"I")
 .;
 .I ABMTREI="D" D
 ..S ABMMCDI=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMT,0)),U,6)
 ..S $P(ABMF(11),U)=$P($G(^AUPNMCD(ABMMCDI,21)),U)  ;Medicaid name-tertiary FL9
 ..I $P(ABMF(11),U)="" S $P(ABMF(11),U)=$P($G(^DPT(ABMP("PDFN"),0)),U)
 ..S $P(ABMF(13),U)=$$GET1^DIQ(9000004,ABMMCDI,.03,"E")  ;tertiary FL9a
 ..S $P(ABMF(13),U)=$P(ABMF(13),U)_" "_$$GET1^DIQ(9000004,ABMMCDI,.17,"E")  ;group name
 ..S $P(ABMF(19),U)=$P($G(^AUTNINS(ABMTRE,0)),U)  ;tertiary 9d
 .;
 .I ABMTREI="P" D
 ..S $P(ABMF(11),U)=""
 ..S ABMT("PI",ABMT)=$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),13,ABMT,0)),U,8)  ;Priv Ins Mult
 ..S ABMT("PH",ABMT)=$P($G(^AUPNPRVT(ABMP("PDFN"),11,ABMT("PI",ABMT),0)),U,8)
 ..S:(+$G(ABMT("PH",ABMT))'=0) $P(ABMF(11),U)=$P($G(^AUPN3PPH(ABMT("PH",ABMT),0)),U)  ;Policy holder name-tertiary FL9
 ..I $P(ABMF(11),U)="" S $P(ABMF(11),U)=$P($G(^DPT(ABMP("PDFN"),0)),U)
 ..S $P(ABMF(13),U)=$P($G(^AUPN3PPH(ABMT("PH",ABMT),0)),U,4)  ;tertiary FL9a
 ..S $P(ABMF(13),U)=$P(ABMF(13),U)_" "_$S($P($G(^AUPN3PPH(ABMT("PH",ABMT),0)),U,6)'="":" "_$$GET1^DIQ(9000003.1,ABMT("PH",ABMT),".06","E"),1:"")
 ..S $P(ABMF(19),U)=$P($G(^AUTNINS(ABMTRE,0)),U)  ;tertiary 9d
 Q
