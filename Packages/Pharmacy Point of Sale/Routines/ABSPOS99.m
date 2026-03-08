ABSPOS99 ;IHS/GDIT/AEF - temporary for debugging [ 02/08/2000  10:28 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**54**;JUN 01, 2001;Build 131
 ; substitute for READER^ABSBPOSV
 K ABSBRXI N COUNT S COUNT=0
 W !,$T(+0)," special command > "
 N X R X:DTIME Q:"^^"[X   ;ABSP*1.0*54
 Q:$T(@X)=""
 D @X
 I '$D(ABSBRXI) D
 . W "None selected",!
 E  D
 . ;W "Selected: ",! ZW ABSBRXI
 . W "Selected: ",! N XEQ S XEQ="ZW ABSBRXI" X XEQ   ;ABSP*1.0*54
 Q
A ; last 1 prescription for each of them
 N A S A="" F  S A=$O(^TMP("ABSPOS DEBUG 1",A)) Q:A=""  D
 . D GOBACK(A,1)
 Q
B D GOBACK(60125,1,1) ; COVAL last 1
 D GOBACK(45813,1,2) ; GRAHAM last 2
 D GOBACK(6459,3,5) ; PROCTOR not last 2, but the 3 before that
 D GOBACK(40232,1,3) ; STEM last 3
 Q
C D GOBACK(6459,1,2) ; PROCTOR the last 2
 Q
D D GOBACK(6459,3,3) ; PROCTOR 3rd one from end
 D GOBACK(40232,3,3) ; STEM 3rd one from end
 Q
E D GOBACK(6459,2,2) ; PROCTOR 2nd one from end
 Q
GOBACK(PATDFN,FROM,TO)       ; go back N=FROM through N=TO for PATDFN
 ;W "GOBACK with PATDFN=",PATDFN,": ",$P(^DPT(PATDFN,0),"^"),!
 W "GOBACK with PATDFN=",PATDFN,": ",$P(^DPT(PATDFN,0),"^")_$$PPN1^ABSPUTL(PATDFN),!   ;IHS/GDIT/AEF 3240110 - ABSP*1.0*54 FID 77888
 I '$D(TO) S TO=FROM
 N I,RXI S RXI=""
 N TMP
 F I=1:1:FROM-1 D
 . S RXI=$O(^PSRX("C",PATDFN,RXI),-1)
 . W "Skipping #",I,": ",RXI,!
 F I=FROM:1:TO D
 . S RXI=$O(^PSRX("C",PATDFN,RXI),-1)
 . W "Adding #",I,": ",RXI,!
 . S TMP(RXI)=""
 S RXI="" F  S RXI=$O(TMP(RXI)) Q:RXI=""  D
 . S COUNT=COUNT+1
 . S ABSBRXI(COUNT)=RXI
 . ;W "Added ",RXI," for ",$P(^DPT(PATDFN,0),"^")," as ABSBRXI(",COUNT,")",!
 . W "Added ",RXI," for ",$P(^DPT(PATDFN,0),"^")_$$PPN1^ABSPUTL(PATDFN)," as ABSBRXI(",COUNT,")",!   ;IHS/GDIT/AEF 3240110 - ABSP*1.0*54 FID 77888
 . H 1
 Q
