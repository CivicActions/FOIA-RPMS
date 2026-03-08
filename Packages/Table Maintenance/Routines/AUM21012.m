AUM21012 ; IHS/ASDST/GTH - STANDARD TABLE UPDATES, 2001 SEP 28 ; [ 10/31/2001   3:40 PM ]
 ;;02.1;TABLE MAINTENANCE;**1**;SEP 28,2001
 ;
START ;EP
 ;
 NEW A,C,DIC,DIE,DINUM,DLAYGO,DR,E,L,M,N,O,P,R,S,T
 ;
 D REFTNEW,DASH,MEASNEW,DASH
 ;
 Q
 ;
 ; -----------------------------------------------------
ADDOK D RSLT($J("",5)_"Added : "_L)
 Q
ADDFAIL D RSLT($J("",5)_$$M(0)_"ADD FAILED => "_L)
 Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("")
 Q
E(L) Q $P($P($T(@L^AUM2101A),";",3),":",1)
FILE NEW A,C,E,L,M,N,O,P,R,S,T K DD,DO S DIC(0)="L" D FILE^DICN KILL DIC
 Q
M(%) Q $S(%=0:"ERROR : ",%=1:"NOT ADDED : ",1:"")
MODOK D RSLT($J("",5)_"Changed : "_L)
 Q
RSLT(%) S ^(0)=$G(^TMP("AUM2101",$J,0))+1,^(^(0))=% D MES(%)
 Q
MES(%) NEW A,C,E,L,M,N,O,P,R,S,T D MES^XPDUTL(%)
 Q
 ; -----------------------------------------------------
MEASNEW ;
 D RSLT($$E("MEASNEW"))
 D RSLT($J("",13)_$$LJ^XLFSTR("TYPE",10)_$$LJ^XLFSTR("DESCRIPTION",30)_"CODE")
 D RSLT($J("",13)_$$LJ^XLFSTR("----",10)_$$LJ^XLFSTR("-----------",30)_"----")
 F T=1:1 S L=$T(MEASNEW+T^AUM2101A) Q:$P(L,";",3)="END"  D ADDMEAS
 KILL DLAYGO
 Q
 ;
ADDMEAS ;
 S L=$P(L,";;",2),N=$P(L,U),S=$P(L,U,2),C=$P(L,U,3),L=$$LJ^XLFSTR(N,10)_$$LJ^XLFSTR(S,30)_C
 I $D(^AUTTMSR("C",C)) D RSLT($$M(1)_" : MEASUREMENT TYPE CODE EXISTS => "_C) Q
 S DLAYGO=9999999.07,DIC="^AUTTMSR(",X=N,DIC("DR")=".02///"_S_";.03///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ; -----------------------------------------------------
REFTNEW ;
 D RSLT($$E("REFTNEW"))
 D RSLT($J("",13)_$$LJ^XLFSTR("TYPE",20)_$$LJ^XLFSTR("PRIMARY FILE",30)_"FIELD")
 D RSLT($J("",13)_$$LJ^XLFSTR("----",20)_$$LJ^XLFSTR("------------",30)_"-----")
 F T=1:1 S L=$T(REFTNEW+T^AUM2101A) Q:$P(L,";",3)="END"  D ADDREFT
 KILL DLAYGO
 Q
 ;
ADDREFT ;
 S L=$P(L,";;",2),N=$P(L,U),S=$P(L,U,2),C=$P(L,U,3),L=$$LJ^XLFSTR(N,20)_$$LJ^XLFSTR(S,30)_C
 I $D(^AUTTREFT("B",N)) D RSLT($$M(1)_" : REFUSAL TYPE EXISTS => "_N) Q
 S DLAYGO=9999999.73,DIC="^AUTTREFT(",X=N,DIC("DR")=".02///"_S_";.03///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ; -----------------------------------------------------
 ;
