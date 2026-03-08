ABMUMISS ; IHS/SD/SDR - 3PB/UFMS Cashiering Options   
 ;;2.6;IHS 3P BILLING SYSTEM;**40**;NOV 12, 2009;Build 785
 ;IHS/SD/SDR 2.6 New routine Check for bills that were missed in session
 ;IHS/SD/SDR 2.6*40 ADO75369 Check if bills are in another session that hasn't been transmitted yet
UFMSCK ;
 W !!,"Will now check for any ""missing"" claims/bills..."
 ;
 ;ABMFD contains open date/time of session; start there and
 ;go thru approved bills looking for this user
 ;
 S ABMPAR=0
 S ABMPFLG=0
 F  S ABMPAR=$O(^BAR(90052.05,ABMPAR)) Q:'ABMPAR  D  Q:ABMPFLG=1
 .I $D(^BAR(90052.05,ABMPAR,DUZ(2))) D
 ..Q:$P($G(^BAR(90052.05,ABMPAR,DUZ(2),0)),U,3)'=ABMPAR
 ..S ABMPFLG=1  ;set flag to stop looking; this is our parent
 S ABMSITE=0
 F  S ABMSITE=$O(^BAR(90052.05,ABMPAR,ABMSITE)) Q:'ABMSITE  D
 .I $D(^BAR(90052.05,ABMPAR,ABMSITE)) D
 ..Q:$P($G(^BAR(90052.05,ABMPAR,ABMSITE,0)),U,3)'=ABMPAR
 ..I ABMPAR=ABMSITE S ABMPARNT=ABMPAR
 ..S ABMP("SATS",ABMSITE)=""
 ;
 D LIST  ;abm*2.6*40 IHS/SD/SDR ADO75369
 ;
 S ABMFFLG=0
 S ABMHOLD=DUZ(2)
 S DUZ(2)=0
 F  S DUZ(2)=$O(ABMP("SATS",DUZ(2))) Q:'DUZ(2)  D
 .Q:$P($G(^ABMDPARM(DUZ(2),1,4)),U,15)'=1
 .K ABMLOC
 .S ABMASDT=(ABMFD-.000001)
 .F  S ABMASDT=$O(^ABMDBILL(DUZ(2),"AP",ABMASDT))  Q:'ABMASDT  D
 ..S ABMP("BDFN")=0
 ..F  S ABMP("BDFN")=$O(^ABMDBILL(DUZ(2),"AP",ABMASDT,ABMP("BDFN"))) Q:'ABMP("BDFN")  D
 ...I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),1)),U,4)'=DUZ Q
 ...I $P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,7)=901 Q  ;don't add if POS claim
 ...I $G(^TMP("ABM-MB",$J,ABMP("BDFN")))=1 Q  ;the bill is in another not-transmitted session  ;abm*2.6*40 IHS/SD/SDR ADO75369
 ...D ADDBENTR^ABMUCUTL("ABILL",ABMP("BDFN"))
 ...I ($P(Y,U,3)'="") D
 ....W !?5,"Bill number: ",$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U)," added to session"
 ....S ABMFFLG=1
 I ABMFFLG=0 W !,"No ""missing"" bills found"
 S DUZ(2)=ABMHOLD
 W !!
 K ABMPARNT,ABMP("SATS")
 K ^TMP("ABM-MB",$J)  ;abm*2.6*40 IHS/SD/SDR ADO75369
 Q
 ;
 ;start new abm*2.6*40 IHS/SD/SDR ADO75369
LIST ;
 K ^TMP("ABM-MB",$J)
 F ABM("ST")="O","C","S" D
 .S ABM("SESID")=0
 .F  S ABM("SESID")=$O(^ABMUCASH(DUZ(2),"AC",ABM("ST"),DUZ,ABM("SESID"))) Q:'ABM("SESID")  D
 ..S ABM("BA")=0
 ..F  S ABM("BA")=$O(^ABMUCASH(DUZ(2),10,DUZ,20,ABM("SESID"),11,ABM("BA"))) Q:'ABM("BA")  D
 ...S ABM("BIEN")=0
 ...F  S ABM("BIEN")=$O(^ABMUCASH(DUZ(2),10,DUZ,20,ABM("SESID"),11,ABM("BA"),2,ABM("BIEN"))) Q:'ABM("BIEN")  D
 ....S ^TMP("ABM-MB",$J,$P(^ABMUCASH(DUZ(2),10,DUZ,20,ABM("SESID"),11,ABM("BA"),2,ABM("BIEN"),0),U))=1
 Q
 ;end new abm*2.6*40 IHS/SD/SDR ADO75369
