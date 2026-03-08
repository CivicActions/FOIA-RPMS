XUMFPZL7 ;CIOFO-SF/RAM - Master File Param ZL7 ;06/28/00 [ 07/29/2004   9:01 AM ]
 ;;8.0;KERNEL;**262**;Jul 10, 1995
 ;
 ;
Z05 ; State (#5)
 ;
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",1.1,1)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",1.2,.01)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",1.4,2)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",1.5,.01)="ST"
 ;
 Q
 ;
Z49 ; Service/Section (#49)
 ;
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",1.1,.01)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",1.2,1)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",3,1.6)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",4,6)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",5,1.5)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",6,1.7)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",7,730)="ST"
 ;
 Q
 ;
ZAG ; Agency (#4.11)
 ;
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",1.1,.02)="ST"
 S ^TMP("XUMF MFS",$J,"PARAM","SEG","ZL7","SEQ",1.2,.01)="ST"
 ;
NOTAB ;
 ;
 Q
 ;
