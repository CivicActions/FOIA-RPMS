AUM21081 ;IHS/SET/GTH - ICD INACTIVE FLAG AND DATE ; [ 06/28/2002   5:53 PM ]
 ;;02.1;TABLE MAINTENANCE;**8**;SEP 28,2001
 ;
START ;EP
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables.
 ;
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 ;
 D RSLT($J("",5)_$P($T(UPDATE^AUM2108A),";",3))
 F L="GREET","INTROE","INTROI" F %=1:1 D RSLT($P($T(@L+%^AUM2108),";",3)) Q:$P($T(@L+%+1^AUM2108),";",3)="###"
 D DASH,ICD9INAC,DASH,ICD9MOD,DASH,MEASNEW,DASH
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
E(L) Q $P($P($T(@L^AUM2108A),";",3),":",1)
IEN(X,%,Y) ;
 S Y=$O(@(X_"""C"",%,0)"))
 I 'Y S Y=$$VAL^AUM2108M(X,%) I Y D  S:Y<0 Y=""
 . NEW %,@($P($T(SVARS),";",3))
 . S L=Y
 . I X["AREA" NEW X D RSLT("(Add Missing Area)") D ADDAREA D RSLT("(END Add Missing Area)") Q
 . I X["SU" NEW X D RSLT("(Add Missing SU)") D ADDSU D RSLT("(END Add Missing SU)") Q
 . I X["CTY" NEW X D RSLT("(Add Missing County)") D ADDCNTY D RSLT("(END Add Missing County)") Q
 .Q
 D:'Y RSLT($J("",5)_$$M(0)_$P(@(X_"0)"),U)_" DOES NOT EXIST => "_%)
 Q +Y
DIK NEW @($P($T(SVARS),";",3)) D ^DIK KILL DIK
 Q
FILE NEW @($P($T(SVARS),";",3)) K DD,DO S DIC(0)="L" D FILE^DICN KILL DIC
 Q
M(%) Q $S(%=0:"ERROR : ",%=1:"NOT ADDED : ",1:"")
MODOK D RSLT($J("",5)_"Changed : "_L)
 Q
RSLT(%) S ^(0)=$G(^TMP("AUM2108",$J,0))+1,^(^(0))=% D MES(%)
 Q
MES(%) NEW @($P($T(SVARS),";",3)) D MES^XPDUTL(%)
 Q
IXDIC(DIC,DIC0,D,X,DLAYGO) NEW @($P($T(SVARS),";",3))
 S DIC(0)=DIC0
 KILL DIC0
 I '$G(DLAYGO) KILL DLAYGO
 D IX^DIC
 Q Y
 ; -----------------------------------------------------
ADDAREA ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),A=$P(L,U),N=$P(L,U,2),R=$P(L,U,3),C=$P(L,U,4),L=A_" "_N_" "_R_" "_C
 I $D(^AUTTAREA("B",N)) D RSLT($J("",5)_$$M(1)_"NAME EXISTS => "_N) Q
 I $D(^AUTTAREA("C",A)) D RSLT($J("",5)_$$M(1)_"CODE EXISTS => "_A) Q
 S DLAYGO=9999999.21,DIC="^AUTTAREA(",X=N,DIC("DR")=".02///"_A_";.03///"_R_";.04///"_C
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 KILL DLAYGO
 Q
 ; -----------------------------------------------------
ADDCNTY ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3),A=$P(L,U,4),L=S_"    "_C_"    "_N_$J("",30-$L(N))_A
 I $D(^AUTTCTY("C",S_C)) D RSLT($J("",5)_$$M(1)_"CODE EXISTS => "_S_C) Q
 S P("S")=$$IEN("^DIC(5,",S)
 Q:'P("S")
 S DIC="^AUTTCTY(",X=N,DIC("DR")=".02////"_P("S")_";.03///"_C_";.06///"_A
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ; -----------------------------------------------------
ADDSU ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3),L=A_" "_S_" "_N
 I $D(^AUTTSU("C",A_S)) D RSLT($J("",5)_$$M(1)_"ASU EXISTS => "_A_S) Q
 S P=$$IEN("^AUTTAREA(",A)
 Q:'P
 S DLAYGO=9999999.22,DIC="^AUTTSU(",X=N,DIC("DR")=".02////"_P_";.03///"_S
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 KILL DLAYGO
 Q
 ; -----------------------------------------------------
 ;
ICD9INAC ;
 D RSLT($$E("ICD9INAC"))
 D RSLT($J("",8)_"CODE    "_$$LJ^XLFSTR("DIAGNOSIS",32)_"INACTIVE DATE")
 D RSLT($J("",8)_"----    "_$$LJ^XLFSTR("---------",32)_"-------------")
 NEW AUMI,DA,DIE,DR,X,Y
 F AUMI=1:1 S L=$P($T(ICD9INAC+AUMI^AUM2108A),";;",2) Q:L="END"  D
 . S C=$P(L,U,1),Y=$$IXDIC("^ICD9(","ILX","AB",C)
 . I Y=-1 D RSLT(" CODE '"_C_"' not found (that's OK).") Q
 . S M=$P(L,U,2),A=$P(L,U,3),DA=+Y,DIE="^ICD9(",DR="100///1;102///"_A_";2100000///"_DT
 . D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of INACTIVE DATE field for CODE '"_C_"' FAILED.") Q
 . D RSLT($J("",8)_$$LJ^XLFSTR(C,8)_$$LJ^XLFSTR(M,32)_A)
 .Q
 Q
 ; -----------------------------------------------------
ICD9MOD ;
 D RSLT($$E("ICD9MOD"))
 D RSLT($J("",8)_"CODE    "_$$LJ^XLFSTR("DIAGNOSIS",32)_"MAJOR DX CATERGORY")
 D RSLT($J("",8)_"----    "_$$LJ^XLFSTR("---------",32)_"------------------")
 NEW AUMI,DA,DIE,DR
 F AUMI=1:1 S L=$P($T(ICD9MOD+AUMI^AUM2108A),";;",2) Q:L="END"  D
 . S C=$P(L,U,1),Y=$$IXDIC("^ICD9(","ILX","AB",C,80)
 . I Y=-1 D RSLT("ERROR:  Lookup/Add of CODE '"_C_"' FAILED.") Q
 . S DA=+Y,DR="3///"_$E($P(L,U,3),1,30)_";5///"_$P(L,U,3)_";10///"_$E($P(L,U,4),1,245)_";100///@;102///@;2100000///"_DT,DIE="^ICD9("
 . D DIE
 . I $D(Y) D RSLT("ERROR:  Edit of fields for CODE '"_C_"' FAILED.") Q
 . D RSLT($J("",8)_$$LJ^XLFSTR(C,8)_$$LJ^XLFSTR($P(L,U,2),32)_$P(L,U,3))
 .Q
 Q
 ; -----------------------------------------------------
MEASNEW ;
 D RSLT($$E("MEASNEW"))
 D RSLT($J("",13)_"TYPE  "_$$LJ^XLFSTR("DESCRIPTION",32)_"CODE")
 D RSLT($J("",13)_"----  "_$$LJ^XLFSTR("-----------",32)_"----")
 F T=1:1 S L=$T(MEASNEW+T^AUM2108A) Q:$P(L,";",3)="END"  D ADDMEAS
 Q
 ;
ADDMEAS ;
 S L=$P(L,";;",2),N=$P(L,U),S=$P(L,U,2),C=$P(L,U,3),L=$$LJ^XLFSTR(N,6)_$$LJ^XLFSTR(S,32)_C
 I $D(^AUTTMSR("C",C)) D RSLT($$M(1)_" : MEASUREMENT TYPE CODE EXISTS => "_C) Q
 S DLAYGO=9999999.07,DIC="^AUTTMSR(",X=N,DIC("DR")=".02///"_S_";.03///"_C
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 Q
 ;
