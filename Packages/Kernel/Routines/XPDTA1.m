XPDTA1 ;SFISC/RSD - Build Actions for Kernel Files Cont. ;05/05/2003  13:42 [ 03/19/2004  12:04 PM ]
 ;;8.0;KERNEL;**44,68,85,131,302,1009**;Jul 10, 1995
 Q
 ;^XTMP("XPDT",XPDA,"KRN",XPDFILE,DA) is the global root
 ;DA=ien in ^XTMP,XPDNM=package name, XPDA=package ien in ^XPD(9.6,
 Q
HELP ;help frames #9.2
 ;remove Author (0;4), kill Editor (4;0) and under Object (10) kill "B" x-ref
 S $P(^XTMP("XPDT",XPDA,"KRN",9.2,DA,0),U,4)="",%=0 K ^(4),^(10,"B")
 ;loop thru Objects (10) and resolve (10;1), kill if it doesn't resolve
 F  S %=$O(^XTMP("XPDT",XPDA,"KRN",9.2,DA,10,%)) Q:'%  S %1=$G(^(%,0)) D
 .S %2=$$PT^XPDTA("^MAG",+%1)
 .I $L(%2) S $P(^XTMP("XPDT",XPDA,"KRN",9.2,DA,10,%,0),U)=%2 Q
 .K ^XTMP("XPDT",XPDA,"KRN",9.2,DA,10,%)
 ;kill under Related Frame (2) "B" x-ref
 K ^XTMP("XPDT",XPDA,"KRN",9.2,DA,2,"B") S %=0
 ;loop thru Related Frame (2) and resolve Related Frame (2;2)
 ;kill if it doesn't resolve
 F  S %=$O(^XTMP("XPDT",XPDA,"KRN",9.2,DA,2,%)) Q:'%  S %1=$P($G(^(%,0)),U,2) D
 .S %2=$$PT^XPDTA("^DIC(9.2)",%1)
 .I $L(%2) S $P(^XTMP("XPDT",XPDA,"KRN",9.2,DA,2,%,0),U,2)=%2 Q
 .K ^XTMP("XPDT",XPDA,"KRN",9.2,DA,2,%)
 Q
BUL ;bulletines #3.6
 ;kill Mailgroups (2)
 K ^XTMP("XPDT",XPDA,"KRN",XPDFILE,DA,2)
 Q
KEY ;security keys entry action #19
 ;Repoint SUBORDINATE (3) and MUTUALLY EXCLUSIVE KEYS (5).
 N %,%1,%2 S %=0
 F  S %=$O(^XTMP("XPDT",XPDA,"KRN",XPDFILE,DA,3,%)) Q:%'>0  S %1=+$G(^(%,0)) D
 . S %2=$$PT^XPDTA("^DIC("_XPDFILE_")",%1)
 . I $L(%2) S $P(^XTMP("XPDT",XPDA,"KRN",XPDFILE,DA,3,%,0),U,1)=%2 Q
 . K ^XTMP("XPDT",XPDA,"KRN",XPDFILE,DA,3,%)
 S %=0
 F  S %=$O(^XTMP("XPDT",XPDA,"KRN",XPDFILE,DA,5,%)) Q:%'>0  S %1=+$G(^(%,0)) D
 . S %2=$$PT^XPDTA("^DIC("_XPDFILE_")",%1)
 . I $L(%2) S $P(^XTMP("XPDT",XPDA,"KRN",XPDFILE,DA,5,%,0),U,1)=%2 Q
 . K ^XTMP("XPDT",XPDA,"KRN",XPDFILE,DA,5,%)
 Q
MAILG ;MAIL GROUP #3.8
 ;remove REFERENCE COUNT (0;4), LAST REFERENCE (0;5), COORDINATOR (0;7)
 S %=^XTMP("XPDT",XPDA,"KRN",3.8,DA,0),$P(%,U,4,5)="^",$P(%,U,7)="",^(0)=%
 ;remove ORGANIZER (3;1)
 S %=$P($G(^XTMP("XPDT",XPDA,"KRN",3.8,DA,3)),U) S:% $P(^(3),U)=""
 ;kill MEMBER (1;0), AUTHORIZE SENDER (4;0), DISTRIBUTION LIST (7;0)
 K ^XTMP("XPDT",XPDA,"KRN",3.8,DA,1),^(4),^(7)
 ;kill MEMBER GROUP "B" x-ref 
 K ^XTMP("XPDT",XPDA,"KRN",3.8,DA,5,"B") S %=0
 ;loop thru MEMBER GROUP and resolve (5;0)
 F  S %=$O(^XTMP("XPDT",XPDA,"KRN",3.8,DA,5,%)) Q:'%  S %1=$P($G(^(%,0)),U) D
 .S %2=$$PT^XPDTA("^XMB(3.8)",%1)
 .I $L(%2) S $P(^XTMP("XPDT",XPDA,"KRN",3.8,DA,5,%,0),U)=%2 Q
 .K ^XTMP("XPDT",XPDA,"KRN",3.8,DA,5,%)
 Q
HLAP ;HL7 application parameter #771
 S %=^XTMP("XPDT",XPDA,"KRN",771,DA,0)
 ;resolve MAIL GROUP (0;4)
 S:$P(%,U,4) $P(%,U,4)=$$PT^XPDTA("^XMB(3.8)",$P(%,U,4))
 ;resolve COUNTRY CODE (0;7)
 S:$P(%,U,7) $P(%,U,7)=$$PT^XPDTA("^HL(779.004)",$P(%,U,7))
 S ^XTMP("XPDT",XPDA,"KRN",771,DA,0)=%
 ;resolve HL7 SEGMENT (SEG;0)
 ;kill "B"=name x-ref, it will be re-indexed when installed
 I $D(^XTMP("XPDT",XPDA,"KRN",771,DA,"SEG")) K ^("SEG","B") D
 .;loop thru SEGs and resolve (SEG;1)
 .S %=0 F  S %=$O(^XTMP("XPDT",XPDA,"KRN",771,DA,"SEG",%)) Q:'%  S %1=$G(^(%,0)) D
 ..S %2=$$PT^XPDTA("^HL(771.3)",+%1)
 ..;if can't resolve then delete
 ..I %2="" K ^XTMP("XPDT",XPDA,"KRN",771,DA,"SEG",%) Q
 ..;save the SEG name
 ..S $P(^XTMP("XPDT",XPDA,"KRN",771,DA,"SEG",%,0),U)=%2
 .Q
 ;resolve HL7 MESSAGE (MSG;0)
 I $D(^XTMP("XPDT",XPDA,"KRN",771,DA,"MSG")) K ^("MSG","B") D
 .;loop thru MSGs and resolve (MSG;1)
 .S %=0 F  S %=$O(^XTMP("XPDT",XPDA,"KRN",771,DA,"MSG",%)) Q:'%  S %1=$G(^(%,0)) D
 ..S %2=$$PT^XPDTA("^HL(771.3)",+%1)
 ..;if can't resolve then delete
 ..I %2="" K ^XTMP("XPDT",XPDA,"KRN",771,DA,"MSG",%) Q
 ..;save the MSG name
 ..S $P(^XTMP("XPDT",XPDA,"KRN",771,DA,"MSG",%,0),U)=%2
 .Q
 Q
HLLLP ;HL7 lower level protocol #869.2
 ;patch HL*1.6*57 merged this file with 870
 Q
HLLL ;HL7 logical link #870
 S %=^XTMP("XPDT",XPDA,"KRN",870,DA,0)
 ;resolve INSTITUTION (0;2)
 S:$P(%,U,2) $P(%,U,2)=$$PT^XPDTA("^DIC(4)",$P(%,U,2))
 ;resolve LLP TYPE (0;3)
 S:$P(%,U,3) $P(%,U,3)=$$PT^XPDTA("^HLCS(869.1)",$P(%,U,3))
 ;resolve DOMAIN (0;7)
 S:$P(%,U,7) $P(%,U,7)=$$PT^XPDTA("^DIC(4.2)",$P(%,U,7))
 ;remove all data except (0;1-3,7,21)
 S %=$P(%,U,1,3)_"^^^^"_$P(%,U,7)_"^^^^^^^^^^^^^^"_$P(%,U,21)
 S ^XTMP("XPDT",XPDA,"KRN",870,DA,0)=%
 ;resolve MAIL GROUP (100;1)
 S %=$P($G(^XTMP("XPDT",XPDA,"KRN",870,DA,100)),U)
 S:% %=$$PT^XPDTA("^XMB(3.8)",%),$P(^XTMP("XPDT",XPDA,"KRN",870,DA,100),U)=%
 ;remove HLLP DEVICE (200;1)
 I $D(^XTMP("XPDT",XPDA,"KRN",870,DA,200)) S $P(^(200),U)=""
 ;remove X3.28 DEVICE (300;1)
 I $D(^XTMP("XPDT",XPDA,"KRN",870,DA,300)) S $P(^(300),U)=""
 ;remove Startup Node (400;6)
 I $D(^XTMP("XPDT",XPDA,"KRN",870,DA,400)) S $P(^(400),U,6)=""
 ;remove all queue multiples and pointers
 K ^XTMP("XPDT",XPDA,"KRN",870,DA,1),^(2),^("IN QUEUE BACK POINTER"),^("IN QUEUE FRONT POINTER")
 K ^XTMP("XPDT",XPDA,"KRN",870,DA,"OUT QUEUE BACK POINTER"),^("OUT QUEUE FRONT POINTER")
 Q
