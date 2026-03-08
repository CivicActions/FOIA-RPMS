AUM21062 ;IHS/SET/GTH - SCB UPDATE 2002 APR 02 ; [ 04/05/2002  11:37 AM ]
 ;;02.1;TABLE MAINTENANCE;**6**;SEP 28,2001
 ;
START ;EP
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables.
 ;
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 ;
 D RSLT($J("",5)_$P($T(UPDATE^AUM2106A),";",3))
 F L="GREET","INTROE","INTROI" F %=1:1 D RSLT($P($T(@L+%^AUM2106),";",3)) Q:$P($T(@L+%+1^AUM2106),";",3)="###"
 D DASH,CLINNEW,DASH,TRIBMOD,DASH,PCLASNEW,DASH
 Q
 ; -----------------------------------------------------
ADDOK D RSLT($J("",5)_"Added : "_L)
 Q
ADDFAIL D RSLT($J("",5)_$$M(0)_"ADD FAILED => "_L)
 Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("")
 Q
DIE NEW @($P($T(SVARS),";",3))
 LOCK +(@(DIE_DA_")")):10 E  D RSLT($J("",5)_$$M(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) KILL DA,DIE,DR
 Q
E(L) Q $P($P($T(@L^AUM2106A),";",3),":",1)
DIK NEW @($P($T(SVARS),";",3)) D ^DIK KILL DIK
 Q
FILE NEW @($P($T(SVARS),";",3)) K DD,DO S DIC(0)="L" D FILE^DICN KILL DIC
 Q
M(%) Q $S(%=0:"ERROR : ",%=1:"NOT ADDED : ",1:"")
MODOK D RSLT($J("",5)_"Changed : "_L)
 Q
RSLT(%) S ^(0)=$G(^TMP("AUM2106",$J,0))+1,^(^(0))=% D MES(%)
 Q
MES(%) NEW @($P($T(SVARS),";",3)) D MES^XPDUTL(%)
 Q
 ; -----------------------------------------------------
CLINNEW ;
 D RSLT($$E("CLINNEW"))
 D RSLT($J("",11)_"CODE NAME"_$J("",28)_"ABRV.")
 D RSLT($J("",11)_"---- ----"_$J("",28)_"-----")
 F T=1:1 S L=$T(CLINNEW+T^AUM2106A) Q:$P(L,";",3)="END"  D ADDCLIN
 KILL DLAYGO
 Q
ADDCLIN ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),L=C_" "_N_$J("",(32-$L(N)))_A
 I $D(^DIC(40.7,"C",C)) D RSLT($J("",5)_$$M(1)_"CLINIC CODE EXISTS => "_C) Q
 S DLAYGO=40.7,DIC="^DIC(40.7,",X=N,DIC("DR")="1///"_C_";999999901///"_A
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ; -----------------------------------------------------
ADDTRIB ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),S=$P(L,U,3),O=$P(L,U,4),L=C_" "_N_$J("",40-$L(N))_" "_O
 I $D(^AUTTTRI("C",C)) D RSLT($J("",5)_E(1)_"TRIBE CODE EXISTS => "_C),RSLT($J("",5)_"Could not add '"_L_"'.") Q
 S DLAYGO=9999999.03,DIC="^AUTTTRI(",X=N,DIC("DR")=".02///"_C_";.03///"_O_";.04///N"
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DLAYGO
 Q
 ; -----------------------------------------------------
TRIBMOD ;
 D RSLT($$E("TRIBMOD"))
 D RSLT($$RJ^XLFSTR("CCC NAME",22)_$$RJ^XLFSTR("INACTIVE",44)_$$RJ^XLFSTR("LONG NAME",11))
 D RSLT($$RJ^XLFSTR("--- ----",22)_$$RJ^XLFSTR("--------",44)_$$RJ^XLFSTR("---------",11))
 F T=1:2 S L=$T(TRIBMOD+T^AUM2106A) Q:$P(L,";",3)="END"  S L("TO")=$T(TRIBMOD+T+1^AUM2106A) D
 . S L=$P(L,U,2,99),C=$P(L,U)
 . S P=$O(^AUTTTRI("C",C,0))
 . S L=$P(L("TO"),U,2,99),C=$P(L,U),N=$P(L,U,2),S=$P(L,U,3),O=$P(L,U,4)
 . I 'P S L=";;"_L D ADDTRIB Q
 . S L=C_" "_N_$J("",40-$L(N))_S_$J("",10-$L(S))_O
 . S DIE="^AUTTTRI(",DA=P,DR=".01///"_N_";.03///"_O_";.04///"_S
 . D DIE
 . I $D(Y) D RSLT(E(0)_E_" : EDIT TRIBE FAILED => "_L) Q
 . D MODOK
 .Q
 Q
 ; -----------------------------------------------------
PCLASNEW ;
 D RSLT($$E("PCLASNEW"))
 I '$$INSTALLD^AUM2106("AVA*93.2*12") D  Q
 . D RSLT($$M(0)_" Patch 'AVA*93.2*12' is not installed.")
 . D RSLT("    Please install 'AVA*93.2*12' and re-run this patch.")
 .Q
 D RSLT($J("",14)_"CODE  NAME                             ABBREV  PCP1A-RPT WL-RPT")
 D RSLT($J("",14)_"----  ----                             ------  --------- ------")
 F T=1:1 S L=$T(PCLASNEW+T^AUM2106A) Q:$P(L,";",3)="END"  D ADDPCLAS
 KILL DLAYGO
 Q
 ;
ADDPCLAS ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),P=$P(L,U,4),F=$P(L,U,5),L=C_"   "_$$LJ^XLFSTR(N,36)_$$LJ^XLFSTR(A,8)_P_$J("",7)_F
 I $D(^DIC(7,"D",C)) D RSLT($J("",5)_$$M(1)_"PROVIDER CODE EXISTS => "_C_".  Populating report fields.") D  Q
 . S DIE="^DIC(7,",DA=$O(^DIC(7,"D",C,0)),DR="9999999.03///"_P_";9999999.05///"_F
 . D DIE
 . I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT PROVIDER CODE FAILED => "_L) Q
 . D MODOK
 .Q
 S DLAYGO=7,DIC="^DIC(7,",X=N,DIC("DR")="1///"_A_";9999999.01///"_C_";9999999.03///"_P_";9999999.05///"_F
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ;
 ; -----------------------------------------------------
 ;
