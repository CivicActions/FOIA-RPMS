BQICASE ;GDIT/HS/ALA - Case Reporting ; 28 Dec 2020  5:59 PM
 ;;2.9;ICARE MANAGEMENT SYSTEM;**3**;Mar 01, 2021;Build 32
 ;
FND ;EP - Find alerts and add pointer
 S EXN=0
 F  S EXN=$O(^BQI(90507.7,EXN)) Q:'EXN  D
 . S DN=0 F  S DN=$O(^BQI(90507.7,EXN,10,DN)) Q:'DN  D
 .. S TYP=$P(^BQI(90507.7,EXN,10,DN,0),"^",7)
 .. I TYP="ILI" S TYP="Influenza/ILI"
 .. S PN=$O(^XTMP("BQICASE","B",TYP,""))
 .. I PN'="" D  Q
 ... S DA(1)=EXN,DA=DN,IENS=$$IENS^DILF(.DA),UPD(90507.701,IENS,.12)=PN
 ... I TYP="Influenza/ILI" S UPD(90507.701,IENS,.07)=TYP
 .. I $D(UPD) D FILE^DIE("","UPD","ERROR")
 Q
 ;
REPT ; Repoint certain alerts
 ;HIV/AIDS -> HIV
 S EXN=0
 F  S EXN=$O(^BQI(90507.7,EXN)) Q:'EXN  D
 . S DN=0 F  S DN=$O(^BQI(90507.7,EXN,10,DN)) Q:'DN  D
 .. S TYP=$P(^BQI(90507.7,EXN,10,DN,0),"^",7)
 .. I TYP="HIV/AIDS" S TYP="HIV" D
 ... S DA(1)=EXN,DA=DN,IENS=$$IENS^DILF(.DA),UPD(90507.701,IENS,.07)=TYP
 .. I $D(UPD) D FILE^DIE("","UPD","ERROR")
 Q
 ;
LTAX1 ;EP - Set up labs with IHS LOINC code
 S LTREF=$NA(^XTMP("BQIIHSLOINC")) K @LTREF
 S ^XTMP("BQIIHSLOINC",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"IHS Loinc Lab List"
 S N=0 F  S N=$O(^LAB(60,N)) Q:'N  D
 . S L=$P($G(^LAB(60,N,9999999)),"^",2) I L="" Q
 . S CD=$$GET1^DIQ(95.3,L_",",.01,"E")
 . I CD=""&(L["-") S CD=L
 . S @LTREF@(CD,N)=$P(^LAB(60,N,0),"^",1)
 ;
LTAX2 ;EP - Set up labs from taxonomies and add from IHS LOINC
 S TREF=$NA(^XTMP("BQILBTAX")) K @TREF
 S ^XTMP("BQILBTAX",0)=$$FMADD^XLFDT(DT,365)_U_DT_U_"Loinc Lab List"
 S ALRT=0 F  S ALRT=$O(^BQI(90507.8,ALRT)) Q:'ALRT  D
 . S TREF=$NA(^XTMP("BQILBTAX",ALRT))
 . S ECR=+$P(^BQI(90507.8,ALRT,0),"^",7) I ECR Q
 . S TAX="" F  S TAX=$O(^BQI(90507.8,ALRT,12,"B",TAX)) Q:TAX=""  D
 .. D BLD^BQITUTL(TAX,.TREF)
 .. S TXN=$O(^ATXAX("B",TAX,"")) I TXN="" Q
 .. S L="" F  S L=$O(^ATXAX(TXN,21,"B",L)) Q:L=""  D
 ... S N="" F  S N=$O(@LTREF@(L,N)) Q:N=""  S @TREF@(N)=@LTREF@(L,N)
 Q
 ;
DISP ;EP - Display mapped labs
 I '$D(^XTMP("BQIIHSLOINC"))!('$D(^XTMP("BQILBTAX"))) D LTAX1
 S BQIRUN=$$HTE^XLFDT($H,1)
 S ZTDESC="COMMUNITY ALERT LABS MAPPED TO LOINCS REPORT",ZTRTN="BEG^BQICASE"
 S %ZIS="QM" D ^%ZIS G END:POP
 I '$D(IO("Q")) K ZTDESC G @ZTRTN
 S ZTIO=ION,ZTSAVE("*")=""
 D ^%ZTLOAD
 Q
 ;
BEG ;
 S (P,L,ABORT,CT)=0
 U IO D HDR I $G(ABORT)=1 Q
 S ALRT=0 F  S ALRT=$O(^XTMP("BQILBTAX",ALRT)) Q:ALRT=""  D  Q:$G(ABORT)=1
 . S LIEN=""
 . F  S LIEN=$O(^XTMP("BQILBTAX",ALRT,LIEN)) Q:LIEN=""  D  Q:$G(ABORT)=1
 .. S NAME=$P(^BQI(90507.8,ALRT,0),U,1),LAB=$P(^LAB(60,LIEN,0),"^",1)
 .. S OTYP=$P(^LAB(60,LIEN,0),"^",3)
 .. S ACC=$P(^LAB(60,LIEN,0),"^",4)
 .. I L+4>IOSL D HDR Q:$G(ABORT)=1
 .. W !,NAME,?35,$E(LAB,1,20),?65,OTYP,?80,ACC S L=L+1
 ;
 I '$G(ABORT) W !,"<End of Report>" I $E(IOST,1,2)="C-" W " Enter RETURN to continue" R Y:300
 D ^%ZISC
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
HDR ; Header
 I $E(IOST,1,2)="C-",P R !,"Enter RETURN to continue or '^' to exit: ",Y:300 I Y[U S ABORT=1 Q
 I $E(IOST,1,2)="C-"!P W @IOF
 S P=P+1,L=5
 W "COMMUNITY ALERT LABS MAPPED TO LOINCS REPORT",?90,"Run Date: ",BQIRUN,?124,"Page ",$J(P,3)
 W !,"Alert",?35,"Lab Test",?60,"Order Type",?75,"Accession Type"
 W !,$TR($J(" ",IOM)," ","-"),!
 Q
 ;
END ;
 Q
