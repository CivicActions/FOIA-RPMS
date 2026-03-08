AUM21072 ;IHS/SET/GTH - SCB UPDATE 2002 MAY 10 ; [ 05/21/2002  11:27 AM ]
 ;;02.1;TABLE MAINTENANCE;**7**;SEP 28,2001
 ;
START ;EP
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables.
 ;
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 ;
 D DASH,PCLASNEW,DASH,CLINNEW,DASH,TRIBNEW,DASH,HFNEW,DASH,CLINMOD,DASH
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
E(L) Q $P($P($T(@L^AUM2107A),";",3),":",1)
DIK NEW @($P($T(SVARS),";",3)) D ^DIK KILL DIK
 Q
FILE NEW @($P($T(SVARS),";",3)) K DD,DO S DIC(0)="L" D FILE^DICN KILL DIC
 Q
M(%) Q $S(%=0:"ERROR : ",%=1:"NOT ADDED : ",1:"")
MODOK D RSLT($J("",5)_"Changed : "_L)
 Q
RSLT(%) S ^(0)=$G(^TMP("AUM2107",$J,0))+1,^(^(0))=% D MES(%)
 Q
MES(%) NEW @($P($T(SVARS),";",3)) D MES^XPDUTL(%)
 Q
 ; -----------------------------------------------------
PCLASNEW ;
 D RSLT($$E("PCLASNEW"))
 D RSLT($J("",12)_"CODE  NAME"_$J("",29)_"ABBREV  PCP1A-RPT WL-RPT")
 D RSLT($J("",12)_"----  ----"_$J("",29)_"------  --------- ------")
 F T=1:1 S L=$T(PCLASNEW+T^AUM2107A) Q:$P(L,";",3)="END"  D ADDPCLAS
 KILL DLAYGO
 Q
 ;
ADDPCLAS ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),P=$P(L,U,4),F=$P(L,U,5),L=C_"   "_$$LJ^XLFSTR(N,33)_$$LJ^XLFSTR(A,8)_P_$J("",7)_F
 I $D(^DIC(7,"D",C)) D RSLT($J("",5)_$$M(1)_"PROVIDER CODE EXISTS => "_C_".  Populating report fields.") D  Q
 . S DIE="^DIC(7,",DA=$O(^DIC(7,"D",C,0)),DR="9999999.03///"_P_";9999999.05///"_F
 . D DIE
 . I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT PROVIDER CODE FAILED => "_L) Q
 . D MODOK
 .Q
 S DLAYGO=7,DIC="^DIC(7,",X=N,DIC("DR")="1///"_A_";9999999.01///"_C_";9999999.03///"_P_";9999999.05///"_F
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ; -----------------------------------------------------
CLINNEW ;
 D RSLT($$E("CLINNEW"))
 D RSLT($J("",11)_"CODE NAME"_$J("",28)_"ABRV.  PRI.CARE")
 D RSLT($J("",11)_"---- ----"_$J("",28)_"-----  --------")
 F T=1:1 S L=$T(CLINNEW+T^AUM2107A) Q:$P(L,";",3)="END"  D ADDCLIN
 KILL DLAYGO
 Q
ADDCLIN ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),P=$P(L,U,4),L=C_" "_N_$J("",(32-$L(N)))_A_"  "_P
 I $D(^DIC(40.7,"C",C)) D RSLT($J("",5)_$$M(1)_"CLINIC CODE EXISTS => "_C) Q
 S DLAYGO=40.7,DIC="^DIC(40.7,",X=N,DIC("DR")="1///"_C_";999999901///"_A_";999999902///"_P
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ; -----------------------------------------------------
TRIBNEW ;
 D RSLT($$E("TRIBNEW"))
 D RSLT($$RJ^XLFSTR("CCC NAME",21)_$$RJ^XLFSTR("LONG NAME",45))
 D RSLT($$RJ^XLFSTR("--- ----",21)_$$RJ^XLFSTR("---------",45))
 F T=1:1 S L=$T(TRIBNEW+T^AUM2107A) Q:$P(L,";",3)="END"  D ADDTRIB
 KILL DLAYGO
 Q
 ;
ADDTRIB ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),O=$P(L,U,3),L=C_" "_N_$J("",40-$L(N))_" "_O
 I $D(^AUTTTRI("C",C)) D RSLT($J("",5)_$$M(1)_"TRIBE CODE EXISTS => "_C) Q
 S DLAYGO=9999999.03,DIC="^AUTTTRI(",X=N,DIC("DR")=".02///"_C_";.03///"_O_";.04///N"
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ; -----------------------------------------------------
HFNEW ;
 D RSLT($$E("HFNEW"))
 F T=1:1 S L=$T(HFNEW+T^AUM2107A) Q:$P(L,";",3)="END"  D ADDHF
 KILL DLAYGO
 Q
ADDHF ;
 S L=$P(L,";;",2),N=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),R=$P(L,U,4),S=$P(L,U,5),L=N
 D RSLT(" ")
 D RSLT("             FACTOR: "_N)
 D RSLT("               CODE: "_O)
 D RSLT("           CATEGORY: "_C)
 D RSLT("  DISP. ON HLTH SUM: "_R)
 D RSLT("         ENTRY TYPE: "_S)
 I $D(^AUTTHF("B",N)) D RSLT($J("",5)_$$M(1)_"HEALTH FACTOR EXISTS => "_N) Q
 S DLAYGO=9999999.64,DIC="^AUTTHF(",X=N,DIC("DR")=".02///"_O_";.03///"_C_";.08///"_R_";.1///"_S
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ; -----------------------------------------------------
CLINMOD ;
 D RSLT($$E("CLINMOD"))
 D RSLT($J("",13)_"CODE NAME"_$J("",28)_"ABRV.  PRI.CARE")
 D RSLT($J("",13)_"---- ----"_$J("",28)_"-----  --------")
 F T=1:1 S L=$T(CLINMOD+T^AUM2107A) Q:$P(L,";",3)="END"  D
 . S C=$P($P(L,";;",2),U,1)
 . I '$D(^DIC(40.7,"C",C)) D ADDCLIN Q
 . S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),P=$P(L,U,4),L=C_" "_N_$J("",(32-$L(N)))_$$LJ^XLFSTR(A,8)_P
 . S DA=$O(^DIC(40.7,"C",C,0)),DIE="^DIC(40.7,",DR=".01///"_N_";999999901///"_A_";999999902///"_P
 . D DIE
 . I $D(Y) D RSLT($J("",5)_$$M(0)_"CHANGE FAILED => "_L) Q
 . D MODOK
 .Q
 Q
 ; -----------------------------------------------------
 ;
