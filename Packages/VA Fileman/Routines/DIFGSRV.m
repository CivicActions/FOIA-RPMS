DIFGSRV ;SFISC/RWF-SERVER INTERFACE TO FILEGRAMS ; [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q
HIST ;Add a message to the FileGram History file so it can be processed.
 S DIXM=0,U="^" X XMREC ;get first line
 I $P(XMRG,U)'="$DAT" S DIXM=DIXM+1,XQSTXT(DIXM)="First line of message doesn't start with '$DAT'"
 S DIFG=$P(XMRG,U,3)
 I DIFG<2 S DIXM=DIXM+1,XQSTXT(DIXM)="Can't update a VA FileMan file."
 I "^2^3^19^"[(U_DIFG_U) S DIXM=DIXM+1,XQSTXT(DIXM)="Update to a protected file (#"_DIFG_")."
 Q:DIXM
 S DIFG("FE")=+$P(XQSUB,"#",2),DIFG("TEMPLATE")="",DIFG("DUZ")=XMFROM
 D LOG^DIFGG
 Q
