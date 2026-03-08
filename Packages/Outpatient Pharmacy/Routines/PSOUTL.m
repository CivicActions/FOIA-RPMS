PSOUTL ;BHAM/ISC/SAB - UTILITY ROUTINE USED THROUGHOUT PSO*  [ 05/14/1998   4:04 PM ]
 ;;6.0;OUTPATIENT PHARMACY;**1**;09/03/97
 ;;6.0;OUTPATIENT PHARMACY;**10,58,71**;09/03/97
SUSPCAN ;CANCEL RX FROM SUSPENSE USED IN NEW, RENEW and VERIFICATION OF RXs
 S PSLAST=0 F PSI=0:0 S PSI=$O(^PSRX(PSRX,1,PSI)) Q:'PSI  S PSLAST=PSI
 I PSLAST S PSI=^PSRX(PSRX,1,PSLAST,0) K ^PSRX(PSRX,1,PSLAST),^PSRX(PSRX,1,"B",+PSI,PSLAST) S ^(0)=$P(^PSRX(PSRX,1,0),"^",1,3)_"^"_($P(^(0),"^",4)-1) K PSLAST,PSI,SUSX,SUS1,SUS2 Q
 S $P(^PSRX(PSRX,3),"^",7)="CANCELLED FROM SUSPENSE BEFORE FILLING" K PSI,SUSX,SUS1,SUS2 Q
 ;
ACTLOG ;ENTER MESSAGE INTO RX ACTIVITY LOG
 F PSI=0:0 S PSI=$O(^PSRX(PSRX,"A",PSI)) I 'PSI!'$O(^(PSI)) S ^PSRX(PSRX,"A",+PSI+1,0)=DT_"^"_PSREA_"^"_PSOCLC_"^"_PSRXREF_"^"_PSMSG,^PSRX(PSRX,"A",0)="^52.3DA^"_(+PSI+1)_"^"_(+PSI+1) Q
ACTOUT I PSREA="C" S PSI=$S($D(^PSRX(PSRX,2)):+$P(^(2),"^",6),1:0) K:$D(^PS(55,PSDFN,"P","A",PSI,PSRX)) ^(PSRX) S ^PS(55,PSDFN,"P","A",DT,PSRX)="" Q
 I PSREA="R" F PSI=0:0 S PSI=$O(^PSRX(PSRX,"A",PSI)) Q:'PSI  I $D(^(PSI,0)),$P(^(0),"^",2)="C" S PSS=+^(0)
 I $D(PSS),PSS K:$D(^PS(55,PSDFN,"P","A",PSS,PSRX)) ^(PSRX)
 I PSREA="R",$D(^PSRX(PSRX,2))#2 S ^PS(55,PSDFN,"P","A",+$P(^PSRX(PSRX,2),"^",6),PSRX)=""
 Q
 ;
QUES ;DISPLAY CHOICE INSTRUCTIONS FOR RENEW AND REFILL
 W !?5,"Enter the item #(s) or RX #(s) you wish to ",$S(PSFROM="N":"renew ",PSFROM="R":"REFILL "),"separated by commas."
 W !?5,"For example: 1,2,5 or 123456,33254A,232323B."
 W !?5,"Do not enter the same number twice, duplicates are not allowed."
 Q
ENDVCHK S PSOPOP=0 Q:'PSODIV  Q:'$P(^PSRX(PSRX,2),"^",9)!($P(^(2),"^",9)=PSOSITE)
CHK1 I '$P(PSOSYS,"^",2) W !?10,*7,"RX# ",$P(^PSRX(PSRX,0),"^")," is not a valid choice. (Different Division)" S PSPOP=1 Q
 I $P(PSOSYS,"^",3) W !?10,*7,"RX# ",$P(^PSRX(PSRX,0),"^")," is from another division. Continue? (Y/N) " R ANS:DTIME I ANS="^"!(ANS="") S PSPOP=1 Q
 I (ANS']"")!("YNyn"'[$E(ANS)) W !?10,*7,"Answer 'YES' or 'NO'." G CHK1
 S:$E(ANS)["Nn" PSPOP=1 Q
K52 S SFN=+$O(^PS(52.5,"B",DA(1),0))
 G:X'=""&(SFN)&($G(Y)=1) KILL I $G(Y)'=1,SFN S SDT=+$P(^PS(52.5,SFN,0),"^",2) K ^PS(52.5,"C",SDT,SFN),^PS(52.5,"AC",+$P(^PS(52.5,SFN,0),"^",3),SDT,SFN),SFN,SDT
 Q
S52 S RIFN=0 F  S RIFN=$O(^PSRX(DA(1),1,RIFN)) Q:'RIFN  S RFID=$P(^PSRX(DA(1),1,RIFN,0),"^")
 S SFN=+$O(^PS(52.5,"B",DA(1),0)) I SFN,'$G(^PS(52.5,SFN,"P")),$P($G(^PSRX($P($G(^PS(52.5,SFN,0)),"^"),0)),"^",15)=5 D
 .S $P(^PS(52.5,SFN,0),"^",2)=RFID,^PS(52.5,"C",RFID,SFN)="",^PS(52.5,"AC",+$P(^PS(52.5,SFN,0),"^",3),RFID,SFN)=""
 K SFN,RFIN,RFID Q
KILL S $P(^PSRX(DA(1),0),"^",15)=0,DFN=+$P(^PS(52.5,SFN,0),"^",3),PAT=$P(^DPT(DFN,0),"^")
 K ^PS(52.5,"B",+$P(^PS(52.5,SFN,0),"^"),SFN),^PS(52.5,"C",+$P(^PS(52.5,SFN,0),"^",2),SFN),^PS(52.5,"D",PAT,SFN),^PS(52.5,"AC",DFN,+$P(^PS(52.5,SFN,0),"^",2),SFN),^PS(52.5,SFN,0),^PS(52.5,SFN,"P"),DFN,SFN,PAT
 S CNT=0 F SUB=0:0 S SUB=$O(^PSRX(DA(1),"A",SUB)) Q:'SUB  S CNT=SUB
 D NOW^%DTC S CNT=CNT+1 L +^PSRX(DA(1),0) S ^PSRX(DA(1),"A",0)="^52.3DA^"_CNT_"^"_CNT,^PSRX(DA(1),"A",CNT,0)=%_"^D^"_DUZ_"^"_DA_"^"_"Refill deleted during Rx edit." L -^PSRX(DA(1),0) K CNT,SUB
 Q
CID ;calculates six months limit on past issue dates
 S PSID=X,X="T-6M",%DT="X" D ^%DT S %DT(0)=Y,X=PSID,%DT="EX" D ^%DT K PSID
 ;IHS/DSD/ENM/POC 01/16/98 NEXT LINE PREVENTS FUTURE DATES
 S X=Y,%DT(0)=-DT,%DT="EX" D ^%DT
 Q
CIDH S X="T-6M",%DT="X" D ^%DT X ^DD("DD") W !,"Issue Date must be greater or equal to "_Y
 Q
SPR F RF=0:0 S RF=$O(^PSRX(DA(1),1,RF)) Q:'RF  S NODE=RF
 I NODE=1 S $P(^PSRX(DA(1),3),"^",4)=$P(^PSRX(DA(1),2),"^",2) Q
SREF I $G(NODE) S NODE=NODE-1 G:'$D(^PSRX(DA(1),1,NODE,0)) SREF
 I NODE=0 S $P(^PSRX(DA(1),3),"^",4)=$P(^PSRX(DA(1),2),"^",2) Q
 S $P(^PSRX(DA(1),3),"^",4)=$P(^PSRX(DA(1),1,NODE,0),"^",1) Q
 K NODE,RF
 Q
KPR F RF=0:0 S RF=$O(^PSRX(DA(1),1,RF)) Q:'RF  S NODE=RF
 I NODE=DA&(X'="") S NODE=NODE-1 S:NODE=1 NODE=0 G:'NODE ORIG G:NODE>1 KREF
 I NODE=1 S $P(^PSRX(DA(1),3),"^",4)=$P(^PSRX(DA(1),2),"^",2) G EX
KREF S NODE=NODE-1 G:'NODE EX
 I NODE=1 S $P(^PSRX(DA(1),3),"^",4)=$P(^PSRX(DA(1),2),"^",2) G EX
 G:NODE=DA&(X'="") KREF G:'$D(^PSRX(DA(1),1,NODE,0)) KREF
ORIG I 'NODE S $P(^PSRX(DA(1),3),"^",4)=$P(^PSRX(DA(1),2),"^",2) G EX
 S $P(^PSRX(DA(1),3),"^",4)=$P(^PSRX(DA(1),1,NODE,0),"^",1) G EX
EX K NODE,RF
 Q
FLD K DIR S DIR("A")=$P(^DD(52,99,0),"^"),DIR(0)="52,99" D ^DIR Q:$D(DUOUT)!($D(DIRUT))  S FLD(99)=Y
 I $G(FLD(99))=99 K DIR S DIR("A")=$P(^DD(52,99.1,0),"^"),DIR(0)="52,99.1" D ^DIR Q:$D(DUOUT)!($D(DIRUT))  S FLD(99.1)=Y Q
 E  S FLD(99.1)=""
 Q
