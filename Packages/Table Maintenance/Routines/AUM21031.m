AUM21031 ; IHS/ASDST/GTH - LOCATION FILE COMP UPDATE ; [ 11/28/2001  12:13 PM ]
 ;;02.1;TABLE MAINTENANCE;**3**;SEP 28,2001
 ;
START ;EP
SVARS ;;A,C,E,F,L,M,N,O,P,R,S,T,V;Single-character work variables.
 ;
 NEW DA,DIC,DIE,DINUM,DLAYGO,DR,@($P($T(SVARS),";",3))
 ;
 D RSLT($J("",5)_$P($T(UPDATE^AUM2103A),";",3))
 F L="GREET","INTROE","INTROI" F %=1:1 D RSLT($P($T(@L+%^AUM2103),";",3)) Q:$P($T(@L+%+1^AUM2103),";",3)="###"
 D DASH,LOCNEW,DASH
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
E(L) Q $P($P($T(@L^AUM2103A),";",3),":",1)
IEN(X,%,Y) ;
 S Y=$O(@(X_"""C"",%,0)"))
 I 'Y S Y=$$VAL^AUM2103Z(X,%) I Y D  S:Y<0 Y=""
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
RSLT(%) S ^(0)=$G(^TMP("AUM2103",$J,0))+1,^(^(0))=% D MES(%)
 Q
MES(%) NEW @($P($T(SVARS),";",3)) D MES^XPDUTL(%)
 Q
 ; -----------------------------------------------------
ADDAREA ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),A=$P(L,U),N=$P(L,U,2),R=$P(L,U,3),C=$P(L,U,4),L=A_" "_N_" "_R_" "_C
 I $D(^AUTTAREA("B",N)) D RSLT($J("",5)_$$M(1)_"NAME EXISTS => "_N) Q
 I $D(^AUTTAREA("C",A)) D RSLT($J("",5)_$$M(1)_"CODE EXISTS => "_A) Q
 S DLAYGO=9999999.21,DIC="^AUTTAREA(",X=N,DIC("DR")=".02///"_A_";.03///"_R_";.04///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DLAYGO
 Q
 ; -----------------------------------------------------
ADDCNTY ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),S=$P(L,U),C=$P(L,U,2),N=$P(L,U,3),L=S_" "_C_" "_N
 I $D(^AUTTCTY("C",S_C)) D RSLT($J("",5)_$$M(1)_"CODE EXISTS => "_S_C) Q
 S P("S")=$$IEN("^DIC(5,",S)
 Q:'P("S")
 S DIC="^AUTTCTY(",X=N,DIC("DR")=".02////"_P("S")_";.03///"_C
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 Q
 ; -----------------------------------------------------
ADDSU ; PROGRAMMER NOTE:  This s/r is required for every patch.
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),N=$P(L,U,3),L=A_" "_S_" "_N
 I $D(^AUTTSU("C",A_S)) D RSLT($J("",5)_$$M(1)_"ASU EXISTS => "_A_S) Q
 S P=$$IEN("^AUTTAREA(",A)
 Q:'P
 S DLAYGO=9999999.22,DIC="^AUTTSU(",X=N,DIC("DR")=".02////"_P_";.03///"_S
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DLAYGO
 Q
 ; -----------------------------------------------------
LOCNEW ; This is for the comp update, only.  Don't use for regular updates.
 NEW AUM
 D RSLT($$E("LOCNEW"))
 D RSLT($$RJ^XLFSTR("AA SU FA NAME",26)_$$RJ^XLFSTR("PSE STATUS",38))
 D RSLT($$RJ^XLFSTR("-- -- -- ----",26)_$$RJ^XLFSTR("--- ------",38))
 S L=" "
 F AUM=65:1 Q:L=""  F T=1:1 S L=$T(LOCNEW+T^@("AUM2103"_$C(AUM))) Q:L=""  Q:$P(L,";",3)="END"  D ADDLOC
 Q
 ;
ADDLOC ; This is for the comp update, only.  Don't use for regular updates.
 S L=$P(L,";;",2),A=$P(L,U),S=$P(L,U,2),F=$P(L,U,3),N=$P(L,U,4),P=$P(L,U,5),V=$P(L,U,6)
 S L=A_" "_S_" "_F_" "_N_$J("",32-$L(N))_P_" "_V,V=$E(V)
 ;
 ; If the LOCATION exists, edit if necessary and Quit.
 S %=A_S_F,DA=$O(^AUTTLOC("C",%,0))
 I DA D ACTIVE(DA),NAME(DA):V="A",PSEUDO(DA):V="A" Q
 ;
 Q:V="I"  ; Don't add an Inactive LOCATION.
 ; Make sure AREA and SERVICE UNIT exist.
 S P("A")=$$IEN("^AUTTAREA(",A)
 Q:'P("A")
 S P("S")=$$IEN("^AUTTSU(",A_S)
 Q:'P("S")
 ;
 ; Add to INSTITUTION.
 F DINUM=+$P(^DIC(4,0),U,3):1 Q:'$D(^DIC(4,DINUM))&('$D(^AUTTLOC(DINUM)))  I DINUM>99999 D RSLT($J("",5)_$$M(0)_"DINUM FOR LOC/INSTITUTION TOO BIG. NOTIFY ISC.") Q
 Q:DINUM>99999
 I $L(N)>30 S N=$E(N,1,30) D RSLT($J("",5)_"NAME TRUNCATED TO '"_N_"'.")
 S DLAYGO=4,DIC="^DIC(4,",X=N
 D FILE
 KILL DINUM,DLAYGO
 I Y<0 D RSLT($J("",5)_$$M(0)_"^DIC(4 ADD FAILED => "_L) Q
 ;
 ; Add to LOCATION.
 S DINUM=+Y,DLAYGO=9999999.06,DIC="^AUTTLOC(",X=DINUM,DIC("DR")=".04////"_P("A")_";.05////"_P("S")_";.07///"_F_";.28////"_DT_";.31///"_P
 D FILE,ADDFAIL:Y<0,ADDOK:Y>0
 KILL DINUM,DLAYGO
 Q
 ; -----------------------------------------------------
 ;
ACTIVE(DA) ; Active/Inactive.
 I $P($G(^AUTTLOC(DA,0)),U,21),V="I" Q
 I '$P($G(^AUTTLOC(DA,0)),U,21),V="A" Q
 S DIE="^AUTTLOC(",DR=".27///"_$S(V="I":("/"_DT),1:"@")_";.28////"_DT
 D DIE
 I '$D(Y) D RSLT($J("",5)_"LOCATION "_$S(V="I":"IN",1:"RE")_"ACTIVATED  =>"),RSLT($J("",13)_L) Q
 D RSLT($J("",5)_$$M(0)_"EDIT OF INACTIVE DATE FIELD FAILED => "),RSLT($J("",13)_L)
 Q
 ;
NAME(DA) ; Name.
 I '$D(^DIC(4,DA,0)) S $P(^DIC(4,DA,0),U,1)=$P(^AUTTLOC(DA,0),U,2)
 Q:N=$P(^DIC(4,DA,0),U)
 Q:$E(N,1,30)=$P(^DIC(4,DA,0),U)
 I $L(N)>30 S N=$E(N,1,30) D RSLT($J("",5)_"NAME TRUNCATED TO '"_N_"'.")
 NEW AUMDA
 S DIE="^DIC(4,",DR=".01///"_N,AUMDA=DA
 D DIE
 I '$D(Y) D  Q
 . D RSLT($J("",5)_"INSTITUTION NAME UPDATED => "),RSLT($J("",13)_L)
 . S DIE="^AUTTLOC(",DR=".28////"_DT,DA=AUMDA
 . D DIE
 .Q
 D RSLT($J("",5)_$$M(0)_"EDIT INSTITUTION NAME FIELD FAILED => "),RSLT($J("",13)_L)
 Q
 ;
PSEUDO(DA) ; Pseudo Prefix.
 Q:P=$P($G(^AUTTLOC(DA,1)),U,2)
 S DIE="^AUTTLOC(",DR=".28////"_DT_";.31///"_P
 D DIE
 I '$D(Y) D RSLT($J("",5)_"PSEUDO PREFIX UPDATED => "),RSLT($J("",13)_L) Q
 D RSLT($J("",5)_$$M(0)_"EDIT PSEUDO PREFIX FAILED => "),RSLT($J("",13)_L)
 Q
 ;
