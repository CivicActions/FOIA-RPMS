AMHLETP3 ; IHS/CMI/LAB - print goals on tp ; [ 07/01/03  2:26 PM ]
 ;;3.0;IHS BEHAVIORAL HEALTH;**1,6,7,10**;JAN 27, 2003
 ;
 ;
SIG ;signature line
 Q:AMHQUIT
 I $Y>(IOSL-17) D HEAD^AMHLETPP Q:AMHQUIT
 I '$G(AMHBROW) S X=IOSL-$Y-17 F I=1:1:X W !
 I $G(AMHBROW) W !!
 W !!!!?2,"__________________________________     ___________________________________"
 W !?2,"Client's Signature                     Designated Provider's Signature"
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Supervisor's Signature                 Physician's Signature",!
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Other                                  Other",!
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Other                                  Other",!
REV ;EP - review with client
 I $G(AMHPREV)="T" Q
 I '$D(^AMHPTXP(AMHTP,41)) Q
 S AMHD=0 F  S AMHD=$O(^AMHPTXP(AMHTP,41,AMHD)) Q:AMHD'=+AMHD!(AMHQUIT)  D
 .I $D(AMHREVP) Q:'$D(AMHREVP(AMHD))
 .D HEAD Q:AMHQUIT
 .W !!?2,"Date of Review:  ",?27,$$FMTE^XLFDT(AMHD)
 .I $Y>(IOSL-3) D HEAD Q:AMHQUIT
 .W !!?2,"Reviewing Provider:  ",?27,$S($P(^AMHPTXP(AMHTP,41,AMHD,0),U,3):$P(^VA(200,$P(^AMHPTXP(AMHTP,41,AMHD,0),U,3),0),U),1:"<<not recorded>>")
 .I $Y>(IOSL-3) D HEAD Q:AMHQUIT
 .W !!?2,"Reviewing Supervisor:  ",?27,$S($P(^AMHPTXP(AMHTP,41,AMHD,0),U,4):$P(^VA(200,$P(^AMHPTXP(AMHTP,41,AMHD,0),U,4),0),U),1:"<<not recorded>>")
 .I $Y>(IOSL-3) D HEAD Q:AMHQUIT
 .W !!?2,"Next Review Date:  ",?27,$$FMTE^XLFDT($P(^AMHPTXP(AMHTP,41,AMHD,0),U,2))
 .W !!?2,"Outcomes: ",!
 .K AMHPCNT,AMHPRNM S AMHPCNT=0,AMHNODE=1,AMHDA=AMHD,AMHFILE=9002011.564101,AMHG="^AMHPTXP("_AMHTP_",41," D WP^AMHLETP4
 .I $D(AMHPRNM) S X=0 F  S X=$O(AMHPRNM(X)) Q:X'=+X!(AMHQUIT)  D:$Y>(IOSL-2) HEAD^AMHLETPP Q:AMHQUIT  W ?6,AMHPRNM(X),!
 .Q:AMHQUIT
 .;participants
 .I $Y>(IOSL-5) D HEAD Q:AMHQUIT
PART .W !!?2,"Participants in Review:"
 .W !!?2,"PARTICIPANT NAME",?35,"RELATIONSHIP TO CLIENT"
 .I '$D(^AMHPTXP(AMHTP,41,AMHD,12)) D SIGREV Q
 .S X=0 F  S X=$O(^AMHPTXP(AMHTP,41,AMHD,12,X)) Q:X'=+X!(AMHQUIT)  D
 ..D:$Y>(IOSL-3) HEAD Q:AMHQUIT  W !!?2,$P(^AMHPTXP(AMHTP,41,AMHD,12,X,0),U),?35,$P(^AMHPTXP(AMHTP,41,AMHD,12,X,0),U,2)
 ..Q
 .Q:AMHQUIT
 .D SIGREV
 .Q
 Q
SIGREV ;
 I $Y>(IOSL-17) D HEAD^AMHLETPP Q:AMHQUIT
 I '$G(AMHBROW) S X=IOSL-$Y-17 F I=1:1:X W !
 I $G(AMHBROW) W !!
 W !!!!?2,"__________________________________     ___________________________________"
 W !?2,"Client's Signature                     Designated Provider's Signature"
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Supervisor's Signature                 Physician's Signature",!
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Other                                  Other",!
 W !!!?2,"___________________________________    ___________________________________"
 W !?2,"Other                                  Other",!
 Q
HEAD ;ENTRY POINT
 I 'AMHPG G HEAD1
 NEW X
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S AMHQUIT=1 Q
HEAD1 ;EP
 W:$D(IOF) @IOF S AMHPG=AMHPG+1
 W !?13,"********** CONFIDENTIAL PATIENT INFORMATION **********"
 W !,$TR($J("",80)," ","*")
 W !,"*",?79,"*"
 W !,"*  TREATMENT PLAN REVIEW",?45,"Printed: ",$$FMTE^XLFDT($$NOW^XLFDT),?79,"*"
 W !,"*  Name:  ",$P(^DPT(DFN,0),U),?68,"Page ",AMHPG,?79,"*"
 W !,"*  ",$E($P(^DIC(4,DUZ(2),0),U),1,25),?30,"DOB:  ",$$FMTE^XLFDT($P(^DPT(DFN,0),U,3),"2D"),?46,"Sex:  ",$P(^DPT(DFN,0),U,2),?54,"  Chart #:  ",$P(^AUTTLOC(DUZ(2),0),U,7),$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2),?79,"*"
 W !,"*",?79,"*"
 W !,$TR($J("",80)," ","*"),!
 Q
 ;
