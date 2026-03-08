ORB ; slc/CLA - Main routine for OE/RR notifications ;7/18/91  14:34 [ 04/02/2003   8:51 AM ]
 ;;8.0;KERNEL;**1005,1007**;APR 1, 2003
 ;;2.5;ORDER ENTRY/RESULTS REPORTING;**20**;Jan 08, 1993
EN ;called by NOTE^ORX3 - find appropriate notification recipients and send them to Kernel (XQALERT)
 S:'$D(ORBPMSG) ORBPMSG=""
 S ORBN=^ORD(100.9,ORN,0)
 Q:$P(ORVP,";",2)'["DPT("!(^ORD(100.9,ORN,3)="D")
 N DFN S DFN=$P(ORVP,";"),VA200="" D OERR^VADPT Q:('$D(VA("BID")))!('$D(VADM(1)))
 S XQAID=$P(ORBN,"^",2)_","_$P(ORVP,";")_","_ORN
 S XQAFLG=$P(ORBN,"^",5)
 S XQAROU=$P(ORBN,"^",6)_"^"_$P(ORBN,"^",7)
 S XQADATA=$S($D(ORBXDATA):ORBXDATA,1:"")
 S PTNAM=$E(VADM(1)_"         ",1,9)
 S XQAMSG=PTNAM_" "_"("_$E(PTNAM)_VA("BID")_")"_": "_$S(ORBPMSG'=""&($P(ORBN,"^",4)="PKG"):ORBPMSG,1:$P(ORBN,"^",3))
 I $P(ORBN,"^",4)'="PKG" S TXQAID=XQAID D DELETEA^XQALERT S XQAID=TXQAID
 S ORBDFN=$P(ORVP,";") D DEFDUZ ;always send notifs to primary and attending drs
 D:$D(ORBPV) ORDUZ ;if OE/RR is supplying a default DUZ in ORBPV
 D:$D(ORBADUZ) PKGDUZ ;if the pkg-supplied default DUZs in ORBADUZ()
 I $D(ORBTDUZ),($P(ORBN,"^",8)["T") D UTEAM ;if pkg-supplied DUZs in ORBTDUZ and RECIPIENT RESTRICTIONS contains "T", process related teams
 D:$P(ORBN,"^",8)'["P" PLIST ;if RECIPIENT RESTRICTIONS does not contain "P", process patient lists
 D RECIPG,SETUP^XQALERT
QUIT ;
 K ORBADUZ,ORBDFN,ORBN,ORBPMSG,ORBTDUZ,ORBXDATA,PDUZ,PTNAM,RG,TXQAID,USER,VA,VA200,VADM,VAERR,VAIN,XQA,XQADATA,XQAID,XQAFLG,XQAMSG,XQAROU
 ; variables ORBPV,ORN are killed in ORX3, ORVP killed by OERR 
 Q
RECIPG ;get recipient groups that should always receive this notification
 F RG=0:0 S RG=$O(^ORD(100.9,ORN,2,"B",RG)) Q:'RG  D DUZ
 Q
PLIST ;get team(s) or user(s) with patient (ORVP) on their list(s)
 F RG=0:0 S RG=$O(^OR(100.21,"AB",ORVP,RG)) Q:'RG  D DUZ
 Q
UTEAM ;get team(s) with default user (ORBTDUZ) on their list(s)
 F RG=0:0 S RG=$O(^OR(100.21,"C",ORBTDUZ,RG)) Q:'RG  D DUZ
 Q
DUZ ;get user DUZs from team or recipient group 
 F USER=0:0 S USER=$O(^OR(100.21,RG,1,USER)) Q:'USER  S:^ORD(100.9,ORN,3)="M"!($D(^ORD(100.9,"E",USER,ORN))) XQA(USER)="" ;make USER a recipient if the notification is mandatory or is "turned-on" for the user
 Q
PKGDUZ ;get DUZs from the ORBADUZ() array of user DUZs passed from the pkg
 F PDUZ=0:0 S PDUZ=$O(ORBADUZ(PDUZ)) Q:PDUZ'>0  S:^ORD(100.9,ORN,3)="M"!($D(^ORD(100.9,"E",PDUZ,ORN))) XQA(PDUZ)="" ;make pkg defined user (PDUZ) a recipient if the notification is mandatory or is "turned-on" for the user
 Q
ORDUZ ;if a default DUZ has been identified by OE/RR (ORBPV)
 I $P(ORBN,"^",8)["T" S ORBTDUZ=ORBPV ;if RECIPIENT RESTRICTIONS contains "T", process default recipient and related teams
 S ORBADUZ(ORBPV)="" ;always process the default recipient
 Q
DEFDUZ ;get default DUZs of primary and attending drs
 N PRIM,ATTD S (PRIM,ATTD)=""
 S PRIM=+$P(VAIN(2),"^")
 I $G(PRIM) S:^ORD(100.9,ORN,3)="M"!($D(^ORD(100.9,"E",PRIM,ORN))) XQA(PRIM)="" ;make Primary Provider a recipient if the notification is mandatory or "turned-on"
 S ATTD=+$P(VAIN(11),"^")
 I $G(ATTD) S:^ORD(100.9,ORN,3)="M"!($D(^ORD(100.9,"E",ATTD,ORN))) XQA(ATTD)="" ;make Attending Dr a recipient if the notification is mandatory or "turned-on"
 Q
