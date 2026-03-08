BARUP3 ; IHS/SD/SDR - 3P UPLOAD CONTINUED DEC 5,1996 ; 
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**34**;OCT 26,2005;Build 139
 ;
 ;IHS/SD/SDR 1.8*34 ADO80817 new routine - added multiples for Visits, Insurers, DXs, and Providers to A/R Bill
 ;************************
 Q
SETITM2  ;EP
VISIT ;
 ;Create Visit multiple for A/R Bill
 N BARCNT,DR,DA,DIC,J,I
 I '$D(BAR3PUP) D S3PUP^BARUP1
 S DA(1)=BARBLDA
 S DIC(0)="LX"
 S DIC="^BARBL(DUZ(2),"_DA(1)_",11,"
 S DIC("P")=$P(^DD(90050.01,1101,0),U,2)
 S DIC("DR")=""
 F I=1:1 S J=$T(TXT2+I) Q:J[("END")  S $P(DIC("DR"),";",I)=$P(J,"~",2)
 S BARCNT=0
 F  S BARCNT=$O(@BAR3PUP@("VSTS",BARCNT)) Q:'+BARCNT  D
 .S X=$G(@BAR3PUP@("VSTS",BARCNT,"VDFN"))
 .Q:'$L(X)
 .Q:$D(^BARBL(DUZ(2),DA(1),11,BARCNT))
 .K DD,DO
 .D FILE^DICN
 .K BARBLSRV
 K DLAYGO
 ;
DX ;
 ;Create DX multiple for A/R Bill
 N BARCNT,DR,DA,DIC,J,I
 I '$D(BAR3PUP) D S3PUP^BARUP1
 S DA(1)=BARBLDA
 S DIC(0)="LX"
 S DIC="^BARBL(DUZ(2),"_DA(1)_",17,"
 S DIC("P")=$P(^DD(90050.01,1701,0),U,2)
 S DIC("DR")=""
 F I=1:1 S J=$T(TXT4+I) Q:J[("END")  S $P(DIC("DR"),";",I)=$P(J,"~",2)
 S BARCNT=0
 F  S BARCNT=$O(@BAR3PUP@("DX",BARCNT)) Q:'+BARCNT  D
 .S X=$G(@BAR3PUP@("DX",BARCNT,"DX"))
 .Q:'$L(X)
 .Q:$D(^BARBL(DUZ(2),DA(1),17,BARCNT))
 .K DD,DO
 .D FILE^DICN
 .K BARBLSRV
 K DLAYGO
PX ;
 ;Create Procedure multiple for A/R Bill
 N BARCNT,DR,DA,DIC,J,I
 I '$D(BAR3PUP) D S3PUP^BARUP1
 S DA(1)=BARBLDA
 S DIC(0)="LX"
 S DIC="^BARBL(DUZ(2),"_DA(1)_",19,"
 S DIC("P")=$P(^DD(90050.01,1901,0),U,2)
 S DIC("DR")=""
 F I=1:1 S J=$T(TXT5+I) Q:J[("END")  S $P(DIC("DR"),";",I)=$P(J,"~",2)
 S BARCNT=0
 F  S BARCNT=$O(@BAR3PUP@("PX",BARCNT)) Q:'+BARCNT  D
 .S X=$G(@BAR3PUP@("PX",BARCNT,"PX"))
 .Q:'$L(X)
 .Q:$D(^BARBL(DUZ(2),DA(1),19,BARCNT))
 .K DD,DO
 .D FILE^DICN
 .K BARBLSRV
 K DLAYGO
PRV ;
 ;Create Provider multiple for A/R Bill
 N BARCNT,DR,DA,DIC,J,I
 I '$D(BAR3PUP) D S3PUP^BARUP1
 S DA(1)=BARBLDA
 S DIC(0)="LX"
 S DIC="^BARBL(DUZ(2),"_DA(1)_",41,"
 S DIC("P")=$P(^DD(90050.01,4101,0),U,2)
 S DIC("DR")=""
 F I=1:1 S J=$T(TXT6+I) Q:J[("END")  S $P(DIC("DR"),";",I)=$P(J,"~",2)
 S BARCNT=0
 F  S BARCNT=$O(@BAR3PUP@("PRV",BARCNT)) Q:'+BARCNT  D
 .S X=$G(@BAR3PUP@("PRV",BARCNT,"PRV"))
 .Q:'$L(X)
 .Q:$D(^BARBL(DUZ(2),DA(1),41,BARCNT))
 .K DD,DO
 .D FILE^DICN
 .K BARBLSRV
 K DLAYGO
 D SETITM3  ;insurer multiple
 Q
 ;************************
 ;This is a new section to build the DIC("DR") string
TXT2  ;
 ;;~.02////^S X=$G(@BAR3PUP@("VSTS",BARCNT,"STAT"))
 ;;END
 ;
SETITM3  ;EP
 ;Create Insurer multiple for A/R Bill
 N BARCNT,DR,DA,DIC,J,I
 I '$D(BAR3PUP) D S3PUP^BARUP1
 S DA(1)=BARBLDA
 S DIC="^BARBL(DUZ(2),"_DA(1)_",13,"
 S DIC(0)="LX"
 S DIC("P")=$P(^DD(90050.01,1301,0),U,2)
 S DIC("DR")=""
 F I=1:1 S J=$T(TXT3+I) Q:J[("END")  S $P(DIC("DR"),";",I)=$P(J,"~",2)
 S BARCNT=0
 F  S BARCNT=$O(@BAR3PUP@("INS",BARCNT)) Q:'+BARCNT  D
 .S X=$G(@BAR3PUP@("INS",BARCNT,"INM"))
 .Q:'$L(X)
 .Q:$D(^BARBL(DUZ(2),DA(1),13,BARCNT))
 .K DD,DO
 .D FILE^DICN
 .K BARBLSRV
 .I $D(@BAR3PUP@("INS",BARCNT,"CTYP")) D SETCTYP
 K DLAYGO
 Q
 ;************************
 ;This is a new section to build the DIC("DR") string
TXT3  ;
 ;;~.02////^S X=$G(@BAR3PUP@("INS",BARCNT,"PRI"))
 ;;~.03////^S X=$G(@BAR3PUP@("INS",BARCNT,"STAT"))
 ;;~.011////^S X=$G(@BAR3PUP@("INS",BARCNT,"RINM"))
 ;;END
SETCTYP ;EP
 N DR,DA,DIC
 S DA(2)=BARBLDA
 S DA(1)=BARCNT
 S DIC="^BARBL(DUZ(2),"_DA(2)_",13,"_DA(1)_",11,"
 S DIC(0)="LX"
 S DIC("P")=$P(^DD(90050.11301,11,0),U,2)
 S BARCNT2=0
 F  S BARCNT2=$O(@BAR3PUP@("INS",BARCNT,"CTYP",BARCNT2)) Q:'+BARCNT2  D
 .S X=$G(@BAR3PUP@("INS",BARCNT,"CTYP",BARCNT2))
 .Q:'$L(X)
 .Q:$D(^BARBL(DUZ(2),DA(2),13,DA(1),11,BARCNT))
 .K DD,DO
 .D FILE^DICN
 Q
TXT4  ;DXs
 ;;~.02////^S X=$G(@BAR3PUP@("DX",BARCNT,"PRI"))
 ;;~.05////^S X=$G(@BAR3PUP@("DX",BARCNT,"POA"))
 ;;END
TXT5  ;PXs
 ;;~.02////^S X=$G(@BAR3PUP@("PX",BARCNT,"PRI"))
 ;;~.03////^S X=$G(@BAR3PUP@("PX",BARCNT,"DOS"))
 ;;~.04////^S X=$G(@BAR3PUP@("PX",BARCNT,"NARR"))
 ;;END
TXT6  ;PRVs
 ;;~.02////^S X=$G(@BAR3PUP@("PRV",BARCNT,"PRVTYP"))
 ;;END
 ;
 ;IHS/SD/SDR - EOR
