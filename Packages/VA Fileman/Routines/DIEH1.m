DIEH1 ;SFISC/DPC-DBS HELP CON'T ;11/20/97  08:34 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;**44**;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 ;;
DT(DIEHDT) ;
 N P,Q
 I DIEHDT'["N" S P(1)="or 012057"
 D
 . I DIEHDT["P" S P(2)="assumes a date in the PAST." Q
 . I DIEHDT["F" S P(2)="assumes a date in the FUTURE." Q
 . S P(2)="uses CURRENT YEAR.  Two digit year"
 . S P(3)="  assumes no more than 20 years in the future, or 80 years in the past."
 . Q
 I DIEHDT'["X" D
 . N X S X="You may omit the precise day, as:  JAN, 1957."
 . I $G(P(3))]"" S P(4)=X Q
 . S P(3)=X Q
 D BLD^DIALOG(9110,.P,.P)
 I DIEHDT["T"!(DIEHDT["R") D
 . I DIEHDT["S" S Q(1)="Seconds may be entered as 10:30:30 or 103030AM."
 . I DIEHDT["R" S Q(2)="Time is REQUIRED for this response."
 . D BLD^DIALOG(9111,.Q,.Q)
 . Q
 Q
 ;
