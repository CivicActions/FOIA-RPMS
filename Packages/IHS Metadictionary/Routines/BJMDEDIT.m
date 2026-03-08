BJMDEDIT ;VNGT/HS/AM-Edit Site Parameters ; 04 Jan 2010  9:28 PM
 ;;1.0;CDA/C32;**1,3,4**;Feb 08, 2011
 ;
EN ; Entry point
 N DA,DR,DIE,Y,X,MT,C32OK,SPACE
 ; Option disabled; replaced by CCDA - 2/05/2014 GCD
 D CCDAMSG^BJMDTSK
 Q
 ;
 L +^BJMDEDIT:0 E  W !,"Someone else is editing site parameters" Q
 W !,"Now editing C Messaging parameters:",!
 ; This is now obsolete.   We no longer create the record and no longer use Station as
 ; field .01
 ;I $G(^BJMDS(90607,1,0))="" D
 ;. S BGPHN=$O(^BGPSITE(0)) S:BGPHN BGPHOME=$P($G(^BGPSITE(BGPHN,0)),U,1)
 ;. I BGPHOME="" S BGPHOME=$G(DUZ(2))
 ;. I BGPHOME="" S DIC="^BJMDS(90607,",DIC(0)="AELMNZ" D ^DIC Q
 ;. S DIC="^BJMDS(90607,",DIC(0)="LNZ",X=BGPHOME D FILE^DICN
 S DA=$O(^BJMDS(90607,0)) I 'DA G EXIT
 ;S DR=".02;.03;.05;.06//^S X=30;.07;.09;1"
 S DR=".02;.05;.09"
 S DIE="^BJMDS(90607," D ^DIE
 G EXIT:$D(Y)
 ;
 S MT=0,PATSPC=40
 F  S MT=$O(^BJMDS(90606,MT)) Q:'MT  D  Q:$D(Y)
 . W !,!,"Now editing ",$P(^BJMDS(90606,MT,0),U)," (",$P(^BJMDS(90606,MT,0),U,3),")-specific parameters:",!
 . S DR=".04//^S X=30;1"
 . S DIE="^BJMDS(90606," D ^DIE
 . S DR=".05"
 . I $P(^BJMDS(90606,MT,0),U)="C32" D
 .. ; space only matters if there is no transmission date, so we are about to send lots of data
 .. I $P(^BJMDS(90606,MT,0),U,2)'="" Q
 .. I $G(^BJMDS(90606,MT,1))="" Q
 .. S C32OK=1 W !,"Checking free space..." S SPACE=$$SPACE^BJMDECK()
 .. I SPACE>PATSPC W "OK" Q
 .. W !,!,"There are ",$P(SPACE,U,3)," patients and ",$P(SPACE,U,2)\1024," MB of free disk space in the C32"
 .. W !,"Database (",$J($P(SPACE,U),"",3)," KB per patient).  The C32 database needs ",PATSPC," KB of"
 .. W !,"free disk space per patient, "
 .. S NEEDSPC=$P(SPACE,U,3)*PATSPC-$P(SPACE,U,2)
 .. W NEEDSPC\1024," MB more than you currently have."
 .. I $P(SPACE,U,6)<0 D
 ... W !,!,"Your system doesn't have enough free space on file system to allow this"
 ... W !,"to proceed. Contact Support to assist you with expanding file system."
 .. I $P(SPACE,U,6)>0 D
 ... S XYZ=$P(SPACE,U,4)+NEEDSPC\1024
 ... W !,!,"You must change the value of the ""Maximum Size"" field in the ""Database "
 ... W !,"Properties"" screens in the Ensemble System Management Portal to at least "
 ... W !,XYZ," MB before you can enable C32 generation"
 .. S DR=".05////N"
 . D ^DIE
EXIT ;
 L -^BJMDEDIT
 Q
