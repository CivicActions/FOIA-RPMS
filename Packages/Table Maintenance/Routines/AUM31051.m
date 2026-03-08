AUM31051 ;IHS/SET/GTH - SCB UPDATE 2003 JAN 31 ; [ 02/15/2003   8:20 AM ]
 ;;3.1;TABLE MAINTENANCE;**5**;SEP 23,2002
 ;
START ;EP
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables.
 ;
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 ;
 D RSLT($J("",5)_$P($T(UPDATE^AUM3105A),";",3))
 F L="GREET","INTROE","INTROI" F %=1:1 D RSLT($P($T(@L+%^AUM3105),";",3)) Q:$P($T(@L+%+1^AUM3105),";",3)="###"
 D DASH,SUMOD,DASH,LOCNEW,DASH,LOCMOD,DASH,COMMNEW,DASH,COMMMOD,DASH,CLINNEW,DASH,DOMNEW,DASH
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
E(L) Q $P($P($T(@L^AUM3105A),";",3),":",1)
IEN(X,%,Y) ;
 S Y=$O(@(X_"""C"",%,0)"))
 I 'Y S Y=$$VAL^AUM3105M(X,%) I Y D  S:Y<0 Y=""
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
RSLT(%) S ^(0)=$G(^TMP("AUM3105",$J,0))+1,^(^(0))=% D MES(%)
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
 S L=$P(L,";;",2),A=$P(L,U),N=$P(L,U,2),R=$P(L,U,3),C=$P(L,U,4),L=$$LJ^XLFSTR(A,6)_$$LJ^XLFSTR(N,30)_$$LJ^XLFSTR(R,15)_C
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
SUNEW ;
 D RSLT($$E("SUNEW"))
 D RSLT($J("",13)_$$LJ^XLFSTR("AREA",6)_$$LJ^XLFSTR("S.U.",6)_"NAME")
 D RSLT($J("",13)_$$LJ^XLFSTR("----",6)_$$LJ^XLFSTR("----",6)_"----")
 F T=1:1 S L=$T(SUNEW+T^AUM3105A) Q:$P(L,";",3)="END"  D ADDSU
 Q
 ; -----------------------------------------------------
ADDSU ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3),L=$$LJ^XLFSTR(A,6)_$$LJ^XLFSTR(S,6)_N
 I $D(^AUTTSU("C",A_S)) D RSLT($J("",5)_$$M(1)_"ASU EXISTS => "_A_S) Q
 S P=$$IEN("^AUTTAREA(",A)
 Q:'P
 S DLAYGO=9999999.22,DIC="^AUTTSU(",X=N,DIC("DR")=".02////"_P_";.03///"_S
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 KILL DLAYGO
 Q
 ; -----------------------------------------------------
SUMOD ;
 D RSLT($$E("SUMOD"))
 D RSLT($J("",15)_"AA SU NAME")
 D RSLT($J("",15)_"-- -- ----")
 F T=1:2 S L=$T(SUMOD+T^AUM3105A) Q:$P(L,";",3)="END"  S L("TO")=$T(SUMOD+T+1^AUM3105A) D
 . S L=$P(L,U,2,99),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3)
 . S P=$O(^AUTTSU("C",A_S,0))
 . S L=$P(L("TO"),U,2,99),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3)
 . I 'P S P=$O(^AUTTSU("C",A_S,0)) I 'P S L=";;"_L D ADDSU Q
 . S L=A_" "_S_" "_N
 . S P("A")=$$IEN("^AUTTAREA(",A)
 . Q:'P("A")
 . S DIE="^AUTTSU(",DA=P,DR=".01///"_N_";.02////"_P("A")_";.03///"_S
 . D DIE
 . I $D(Y) D RSLT($J("",5)_E(0)_" : EDIT SERVICE UNIT FAILED => "_L) Q
 . D MODOK
 .Q
 ;
 Q
 ; -----------------------------------------------------
LOCNEW ;
 D RSLT($$E("LOCNEW"))
 D RSLT($$RJ^XLFSTR("AA SU FA NAME",26)_$$RJ^XLFSTR("PSEUDO",34))
 D RSLT($$RJ^XLFSTR("-- -- -- ----",26)_$$RJ^XLFSTR("------",34))
 F T=1:1 S L=$T(LOCNEW+T^AUM3105A) Q:$P(L,";",3)="END"  D ADDLOC
 Q
ADDLOC ;
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5)
 S L=A_" "_S_" "_F_" "_N_$J("",32-$L(N))_P
 S %=A_S_F,%=$O(^AUTTLOC("C",%,0))
 I % D RSLT($J("",5)_$$M(1)_"ASUFAC EXISTS => "_A_S_F) D  Q
 . I $P($G(^AUTTLOC(%,0)),U,21) S DIE="^AUTTLOC(",DA=%,DR=".27///@;.28////"_DT D DIE D:$D(Y) RSLT($J("",5)_$$M(0)_"DELETE INACTIVE DATE FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"INACTIVE DATE DELETED => "_L)
 . S %=$O(^AUTTLOC("C",A_S_F,0)),%=$P(^AUTTLOC(%,0),U)
 . I %,$D(^DIC(4,%,0)),N'=$P(^DIC(4,%,0),U) S DIE="^DIC(4,",DA=%,DR=".01///"_N D DIE D:$D(Y) RSLT($J("",5)_$$M(0)_"EDIT INSTITUTION FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"INSTITUTION NAME UPDATED => "_L)
 . S %=$O(^AUTTLOC("C",A_S_F,0))
 . I P'=$P($G(^AUTTLOC(%,1)),U,2) S DIE="^AUTTLOC(",DA=%,DR=".28////"_DT_";.31///"_P D DIE D:$D(Y) RSLT($J("",5)_$$M(0)_"EDIT PSEUDO PREFIX FAILED => "_L) D:'$D(Y) RSLT($J("",5)_"PSEUDO PREFIX UPDATED => "_L)
 .Q
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("S")=$$IEN("^AUTTSU(",A_S)
 Q:'P("S")
 F DINUM=+$P(^DIC(4,0),U,3):1 Q:'$D(^DIC(4,DINUM))&('$D(^AUTTLOC(DINUM)))  I DINUM>99999 D RSLT($J("",5)_$$M(0)_"DINUM FOR LOC/INSTITUTION TOO BIG. NOTIFY ISC.") Q
 Q:DINUM>99999
 S DLAYGO=4,DIC="^DIC(4,",X=N
 D FILE
 KILL DINUM,DLAYGO
 I Y<0 D RSLT($J("",5)_$$M(0)_"^DIC(4 ADD FAILED => "_L) Q
 NEW AUMAD
 S AUMAD=0
 F  S AUMAD=$O(^DD(4,.01,1,AUMAD)) Q:'AUMAD  I $P(^(AUMAD,0),U,2)="AD",$E(^(1),1)="I" Q
 ; If AD xref on 4 is active, edit LOCATION and Quit.
 I AUMAD D  Q
 . S DA=+Y,DIE="^AUTTLOC(",DR=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_P
 . D DIE
 . I '$D(Y) D ADDOK Q
 . D RSLT($J("",5)_$$M(0)_"EDIT LOCATION FAILED => "_L)
 .Q
 S DINUM=+Y,DLAYGO=9999999.06,DIC="^AUTTLOC(",X=DINUM,DIC("DR")=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_P
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 KILL DINUM,DLAYGO
 Q
 ; -----------------------------------------------------
LOCMOD ;
 D RSLT($$E("LOCMOD"))
 D RSLT($$RJ^XLFSTR("AA SU FA NAME",28)_$$RJ^XLFSTR("PSEUDO",34))
 D RSLT($$RJ^XLFSTR("-- -- -- ----",28)_$$RJ^XLFSTR("------",34))
 F T=1:2 S L=$T(LOCMOD+T^AUM3105A) Q:$P(L,";",3)="END"  S L("TO")=$T(LOCMOD+T+1^AUM3105A) D
 . S L=$P(L,U,2,99),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3)
 . S P=$O(^AUTTLOC("C",A_S_F,0))
 . S L=$P(L("TO"),U,2,99),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4)
 . I 'P S P=$O(^AUTTLOC("C",A_S_F,0)) I 'P S L=";;"_L D ADDLOC Q
 . S L=A_" "_S_" "_F_" "_N_$J("",32-$L(N))_$P(L("TO"),U,6)
 . S P("A")=$$IEN("^AUTTAREA(",A)
 . Q:'P("A")
 . S P("S")=$$IEN("^AUTTSU(",A_S)
 . Q:'P("S")
 . S DIE="^AUTTLOC(",DA=P,DR=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_$P(L("TO"),U,6)
 . D DIE
 . I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT LOCATION FAILED => "_L) Q
 . S DIE="^DIC(4,",DA=$P(^AUTTLOC(P,0),U),DR=".01///"_N
 . D DIE
 . I $D(Y) D RSLT($J("",5)_$$M(0)_"EDIT INSTITUTION FAILED => "_L) Q
 . D MODOK
 .Q
 ;
 D DASH
 D RSLT("Checking Location Code changes to determine export status.")
 D RSLT("Patient data is not exported if the only change is to the Location NAME.")
 D RSLT("Location Code changes must be rolled up into the national data repository...")
 D DASH,RSLT($$LOCMOD^AUMXPORT("AUM3105A")_" patients marked for export because of the Location Code changes.")
 Q
 ; -----------------------------------------------------
COMMNEW ;
 D RSLT($$E("COMMNEW"))
 D RSLT($$RJ^XLFSTR("ST CT COM NAME",27)_$$RJ^XLFSTR("AA SU",33))
 D RSLT($$RJ^XLFSTR("-- -- --- ----",27)_$$RJ^XLFSTR("-- --",33))
 F T=1:1 S L=$T(COMMNEW+T^AUM3105A) Q:$P(L,";",3)="END"  D ADDCOMM
 Q
 ;
ADDCOMM ;
 S L=$P(L,";;",2),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6),L=S_" "_O_" "_C_" "_N_$J("",32-$L(N))_A_" "_V
 I $D(^AUTTCOM("C",S_O_C)) D RSLT($J("",5)_$$M(1)_"STCTYCOM CODE EXISTS => "_S_O_C) Q
 S P("O")=$$IEN("^AUTTCTY(",S_O)
 Q:'P("O")
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("V")=$$IEN("^AUTTSU(",A_V)
 Q:'P("V")
 S DLAYGO=9999999.05,DIC="^AUTTCOM(",X=N,DIC("DR")=".02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C
 D FILE,@$S(Y>0:"ADDOK",1:"ADDFAIL")
 KILL DLAYGO
 Q
 ; -----------------------------------------------------
COMMMOD ;
 D RSLT($$E("COMMMOD"))
 D RSLT($J("",15)_"ST CT COM NAME"_$J("",28)_"AA SU")
 D RSLT($J("",15)_"-- -- --- ----"_$J("",28)_"-- --")
 F T=1:2 S L=$T(COMMMOD+T^AUM3105A) Q:$P(L,";",3)="END"  S L("TO")=$T(COMMMOD+T+1^AUM3105A) D
 . S L=$P(L,U,2,99),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3)
 . S P=$O(^AUTTCOM("C",S_O_C,0))
 . S L=$P(L("TO"),U,2,99),S=$P(L,U),O=$P(L,U,2),C=$P(L,U,3),N=$P(L,U,4),A=$P(L,U,5),V=$P(L,U,6)
 . I 'P S P=$O(^AUTTCOM("C",S_O_C,0)) I 'P S L=";;"_L D ADDCOMM Q
 . S L=S_" "_O_" "_C_" "_N_$J("",32-$L(N))_A_" "_V
 . S P("O")=$$IEN("^AUTTCTY(",S_O)
 . Q:'P("O")
 . S P("A")=$$IEN("^AUTTAREA(",A)
 . Q:'P("A")
 . S P("V")=$$IEN("^AUTTSU(",A_V)
 . Q:'P("V")
 . S DIE="^AUTTCOM(",DA=P,DR=".01///"_N_";.02////"_P("O")_";.05////"_P("V")_";.06////"_P("A")_";.07///"_C
 . D DIE
 . I $D(Y) D RSLT($J("",5)_$$M(0)_"CHANGE FAILED => "_L) Q
 . D MODOK
 .Q
 D DASH
 D RSLT("Checking Community Code changes to determine export status.")
 D RSLT("Patient data is not exported if the only change is to the Commnuity NAME.")
 D RSLT("Commnity Code changes must be rolled up into the national data repository...")
 D DASH,RSLT($$COMMMOD^AUMXPORT("AUM3105A")_" patients marked for export because of the Community Code changes.")
 Q
 ; -----------------------------------------------------
CLINNEW ;
 D RSLT($$E("CLINNEW"))
 D RSLT($J("",11)_"CODE NAME"_$J("",28)_"ABRV.  PRI.CARE  1A WL RPT")
 D RSLT($J("",11)_"---- ----"_$J("",28)_"-----  --------  ---------")
 F T=1:1 S L=$T(CLINNEW+T^AUM3105A) Q:$P(L,";",3)="END"  D ADDCLIN
 KILL DLAYGO
 Q
 ;
ADDCLIN ;
 S L=$P(L,";;",2),C=$P(L,U),N=$P(L,U,2),A=$P(L,U,3),P=$P(L,U,4),R=$P(L,U,5),L=C_" "_N_$J("",(32-$L(N)))_$$LJ^XLFSTR(A,8)_$$LJ^XLFSTR(P,11)_R
 I $D(^DIC(40.7,"C",C)) D RSLT($J("",5)_$$M(1)_"CLINIC CODE EXISTS => "_C) Q
 S DLAYGO=40.7,DIC="^DIC(40.7,",X=N,DIC("DR")="1///"_C_";999999901///"_A_";90000.01///"_R
 I $L(P) S DIC("DR")=DIC("DR")_";999999902///"_P
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ; -----------------------------------------------------
 ;
DOMNEW ;
 D RSLT($$E("DOMNEW"))
 D RSLT($J("",13)_"NAME")
 D RSLT($J("",13)_"----")
 F T=1:1 S L=$T(DOMNEW+T^AUM3105A) Q:$P(L,";",3)="END"  D ADDDOM
 Q
 ;
ADDDOM ;
 S L=$P(L,";;",2),N=$P(L,U),L=N
 I $D(^DIC(4.2,"B",N)) D RSLT($J("",5)_$$M(1)_"DOMAIN NAME EXISTS => "_N) Q
 S DLAYGO=4.2,DIC="^DIC(4.2,",X=N
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DLAYGO
 Q
 ;
 ; -----------------------------------------------------
 ;
