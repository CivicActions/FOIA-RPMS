DDBR4 ;SFISC/DCL-LOAD CURRENT LIST :13 AM  27 Dec 1993;10:28 AM  28 Jun 1994 [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;Per VHA Directive 10-93-142, this routine should not be modified.
LOADCL(DDBSA,DDBFLG,DDBPMSG,DDBL,DDBC,DDBLST) ;
 ;DDBSA=source array by value
 ;DDGFLG=no flags currently available
 ;DDBPMSG=text to be displayed (centered) on top line
 ;DDBL=display line default 1st screen/line (22 in most cases)
 ;DDBC=location of column tab array used with right/left arrow keys
 ;DDBLST=location of current list (BROWSER expects ^TMP("DDBLST",$J))
 I $G(DDBSA)']"" N X S X(1)="SOURCE ARRAY("_DDBSA_")" D BLD^DIALOG(202,.X) Q
 I '$D(@DDBSA) N X S X(1)="SOURCE ARRAY("_DDBSA_")" D BLD^DIALOG(202,.X) Q
 N DDBRE,DDBLN,DDBRPE,DDBPSA,DDBTO,I,X,Y
 N DDBFNO,DDBDM,DDBSF,DDBTL,DDBTPG,DDBZN,DDBFTR,DDBHDR,DDBST
 S DDBHDR=$$CTXT($G(DDBPMSG,"VA FileMan Browser"),$J("",IOM+1),IOM)
 S DDBTL=$P($G(@DDBSA@(0)),"^",3) S:DDBTL'>0 DDBTL=$O(@DDBSA@(" "),-1)
 I DDBTL'>0 D  I DDBTL'>0 D BLD^DIALOG(1700,"*NO TEXT* "_DDBSA) Q
 .N I S I=0 F  S I=$O(@DDBSA@(I)) Q:I'>0  S DDBTL=I
 .Q
 S DDBZN=$D(@DDBSA@(DDBTL,0))#2,DDBTPG=DDBTL\DDBSRL+(DDBTL#DDBSRL'<1),DDBDM=DDBSA="^TMP(""DDB"",$J)",DDBSF=1
 S DDBC=$G(DDBC,"^TMP(""DDBC"",$J)")
 S DDBPSA=0,DDBFLG=$G(DDBFLG)
 S DDBL=$G(DDBL,0) S:DDBL<0 DDBL=0 S:DDBL>DDBTL DDBL=DDBTL
 S (DDBRE,DDBRPE)="",DDBTO=0,DDBST=IOM
 S DDBLST=$G(DDBLST,"^TMP(""DDBLST"",$J)"),DDBLN=$S($D(@DDBLST@("A",DDBSA)):^(DDBSA),1:$O(@DDBLST@(" "),-1)+1)
 D SAVEDDB^DDBR2(DDBLST,DDBLN,1)
 Q
 ;
CTXT(X,T,W) ;Center X in T which is W characters wide (usually spaces) and W for screen width
 Q:X="" $G(T)
 N HW
 S W=$G(W,79),HW=W\2
 S $E(T,HW-($L(X)\2),HW-($L(X)\2)+$L(X))=X Q T
OREF(X) N X1,X2 S X1=$P(X,"(")_"(",X2=$$OR2($P(X,"(",2)) Q:X2="" X1 Q X1_X2_","
OR2(%) Q:%=")"!(%=",") "" Q:$L(%)=1 %  S:"),"[$E(%,$L(%)) %=$E(%,1,$L(%)-1) Q %
