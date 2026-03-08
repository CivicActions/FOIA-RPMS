BMAGVAR ;IHS/WOIFO/BT - Imaging User Filter RPC ; 06 June 2024 6:16 PM
 ;;3.0;IMAGING;**196**;May 24, 2024
 ;;
 Q
 ;
 ;RPC: [BMAG IMAGE INFO ADVANCED]
 ;  INPUT
 ;       NODE : Global Node. eq, ^MAG(2005,IEN)
 ;       NEXT : 0 - Return Current MAG node with TIU node if image attached to TIU
 ;              1 - Return Next MAG node
 ;             -1 - Previous node
 ;              2 - Return result of the NODE (any M Global Var) eq, $P($G(^MAG(2005.IEN,0)),"^",10)
 ;              3 - Return result (as reference) of the NODE (any M statement) eq, D GETREF^RTN(.OUT)
 ;              4 - Return result of the NODE (any M statement) eq, D CALL^RTN(.OUT)
 ;              5 - Return node and its value from any global. eq, ^TIU(8925,IEN 
 ;              
 ;  OUTPUT
 ;       RES - Result
 ;
GETVAR(RES,NODE,NEXT,PREVIDX) ; RPC: [BMAG IMAGE INFO ADVANCED]
 N IDX,OUT,MAGIEN,NODERES,SPACES,XCUTE
 K RES,OUT
 S $P(SPACES," ",25)=""
 ;
 S NEXT=$G(NEXT)
 I NEXT=2 S XCUTE="S NODERES="_NODE X XCUTE S RES(1)=$S(NODERES="":"null",1:NODERES) Q
 I NEXT=3 X NODE M RES=@OUT Q  ;The call return reference asrrsy
 I NEXT=4 X NODE M RES=OUT Q  ;The call return array
 I NEXT=5 D ANYGLB(.RES,NODE,PREVIDX) Q  ;Return Global Nodes for any file 
 ;
 ;--- Return Global Node for ^MAG(2005,IEN...
 I NEXT S IDX=$O(@NODE,NEXT) Q:IDX'?1.N  S NODE=$E($P(NODE,",",1,$L(NODE,",")-1),1,$L(NODE)-1)_","_$$QUOTE(IDX)_")"
 ;
 S MAGIEN=$P($P(NODE,",",2),")")
 K OUT D MAG^MAGGTSY2(.OUT,MAGIEN) M RES=@OUT
 S IDX=0 F  S IDX=$O(RES(IDX)) Q:'IDX  D
 . I RES(IDX)["*****" Q
 . I $L($P(RES(IDX)," "))>25 S RES(IDX)=$P(RES(IDX)," ")_" = "_$P(RES(IDX)," ",2,99) Q
 . S RES(IDX)=$E($P(RES(IDX)," ")_SPACES,1,25)_" = "_$P(RES(IDX)," ",2,99) Q
 Q
 ;
 ;Return any Global Node with its values
 ; Syntax:
 ;   ^TIU(8925,[IEN]  - Return the TIU for that IEN
 ;   ^TIU(8925,|10    - Return the first 10 nodes of TIU
 ;   ^TIU(8925,|MORE  - Return the next whatever count used in the previous request
 ;   [FILE#]^{IEN]    - Return the node for the filenumber with that IEN
 ;
ANYGLB(RES,NODE,LASTIDX) ;Any globals
 N IDX,IDX1,IDX2,IDX3,IDX4,IDX5,IDX6,IDX7,IDX8,IDX9,IDX10
 N NODE1,NODE2,NODE3,NODE4,NODE5,NODE6,NODE7,NODE8,NODE9,NODE10
 N CNT,OUT,MAGIEN,SPACES,REQUEST
 N NODECNT,MAXCNT,USECNT,PREVIDX,FLTR
 K RES,OUT
 S REQUEST=NODE
 ;
 I $L(NODE,U)=2,$P(NODE,U)'="" S NODE=^DIC($P(NODE,U),0,"GL")_$P(NODE,U,2)
 S USECNT=0,MAXCNT=100
 I NODE["|" D
 . S USECNT=1,MAXCNT=$P(NODE,"|",2) S:'MAXCNT MAXCNT=100
 . S NODE=$P(NODE,"|")
 . I $E(NODE,$L(NODE))="," S NODE=$E(NODE,1,$L(NODE)-1)_")"
 I $E(NODE,$L(NODE))'=")" S NODE=NODE_")"
 S PREVIDX=LASTIDX,IDX=$P(LASTIDX,$C(13)),CNT=0
 ;
 D GETFLT(.FLTR,.NODE) ;Subscript Filters 
 I $D(FLTR) S USECNT=0
 I '$D(FLTR) D STORE(.RES,NODE,.CNT)
 ;
 ; Maximum: 10 subscripts - 
 ; Recursive doesn't work well in this case causing stack error with large data and difficult to customize
 S NODECNT=1
 F  S IDX=$O(@NODE@(IDX)) Q:IDX=""!(USECNT&(NODECNT>MAXCNT))  D
 . S PREVIDX=IDX
 . S NODECNT=NODECNT+1
 . I USECNT,NODECNT>2 S CNT=CNT+1,RES(CNT)="{---------------------------}"
 . S NODE1=$E($P(NODE,",",1,$L(NODE,",")),1,$L(NODE)-1)_","_$$QUOTE(IDX)_")"
 . D STORE(.RES,NODE1,.CNT)
 . S IDX1=""
 . F  S IDX1=$O(@NODE1@(IDX1)) Q:IDX1=""  D
 . . I $G(FLTR(2))'="",IDX1'=FLTR(2) Q
 . . S NODE2=$E($P(NODE1,",",1,$L(NODE1,",")),1,$L(NODE1)-1)_","_$$QUOTE(IDX1)_")"
 . . D STORE(.RES,NODE2,.CNT)
 . . S IDX2=""
 . . F  S IDX2=$O(@NODE2@(IDX2)) Q:IDX2=""  D
 . . . I $G(FLTR(3))'="",IDX2'=FLTR(3) Q
 . . . S NODE3=$E($P(NODE2,",",1,$L(NODE2,",")),1,$L(NODE2)-1)_","_$$QUOTE(IDX2)_")"
 . . . D STORE(.RES,NODE3,.CNT)
 . . . S IDX3=""
 . . . F  S IDX3=$O(@NODE3@(IDX3)) Q:IDX3=""  D
 . . . . I $G(FLTR(4))'="",IDX3'=FLTR(4) Q
 . . . . S NODE4=$E($P(NODE3,",",1,$L(NODE3,",")),1,$L(NODE3)-1)_","_$$QUOTE(IDX3)_")"
 . . . . D STORE(.RES,NODE4,.CNT)
 . . . . S IDX4=""
 . . . . F  S IDX4=$O(@NODE4@(IDX4)) Q:IDX4=""  D
 . . . . . I $G(FLTR(5))'="",IDX4'=FLTR(5) Q
 . . . . . S NODE5=$E($P(NODE4,",",1,$L(NODE4,",")),1,$L(NODE4)-1)_","_$$QUOTE(IDX4)_")"
 . . . . . D STORE(.RES,NODE5,.CNT)
 . . . . . S IDX5=""
 . . . . . F  S IDX5=$O(@NODE5@(IDX5)) Q:IDX5=""  D
 . . . . . . I $G(FLTR(6))'="",IDX5'=FLTR(6) Q
 . . . . . . S NODE6=$E($P(NODE5,",",1,$L(NODE5,",")),1,$L(NODE5)-1)_","_$$QUOTE(IDX5)_")"
 . . . . . . D STORE(.RES,NODE6,.CNT)
 . . . . . . S IDX6=""
 . . . . . . F  S IDX6=$O(@NODE6@(IDX6)) Q:IDX6=""  D
 . . . . . . . I $G(FLTR(7))'="",IDX6'=FLTR(7) Q
 . . . . . . . S NODE7=$E($P(NODE6,",",1,$L(NODE6,",")),1,$L(NODE6)-1)_","_$$QUOTE(IDX6)_")"
 . . . . . . . D STORE(.RES,NODE7,.CNT)
 . . . . . . . S IDX7=""
 . . . . . . . F  S IDX7=$O(@NODE7@(IDX7)) Q:IDX7=""  D
 . . . . . . . . I $G(FLTR(8))'="",IDX7'=FLTR(8) Q
 . . . . . . . . S NODE8=$E($P(NODE7,",",1,$L(NODE7,",")),1,$L(NODE7)-1)_","_$$QUOTE(IDX7)_")"
 . . . . . . . . D STORE(.RES,NODE8,.CNT)
 . . . . . . . . S IDX8=""
 . . . . . . . . F  S IDX8=$O(@NODE8@(IDX8)) Q:IDX8=""  D
 . . . . . . . . . I $G(FLTR(9))'="",IDX8'=FLTR(9) Q
 . . . . . . . . . S NODE9=$E($P(NODE8,",",1,$L(NODE8,",")),1,$L(NODE8)-1)_","_$$QUOTE(IDX8)_")"
 . . . . . . . . . D STORE(.RES,NODE9,.CNT)
 . . . . . . . . . S IDX9=""
 . . . . . . . . . F  S IDX9=$O(@NODE9@(IDX9)) Q:IDX9=""  D
 . . . . . . . . . . I $G(FLTR(10))'="",IDX9'=FLTR(10) Q
 . . . . . . . . . . S NODE10=$E($P(NODE9,",",1,$L(NODE9,",")),1,$L(NODE9)-1)_","_$$QUOTE(IDX9)_")"
 . . . . . . . . . . D STORE(.RES,NODE10,.CNT)
 ;
 I REQUEST["|" D
 . S CNT=CNT+1,RES(CNT)="{---------------------------}"
  .S CNT=CNT+1,RES(CNT)="MAX COUNT : "_MAXCNT_" | LAST NODE : "_$P(NODE,")")_", | "_PREVIDX
 Q
 ;
GETFLT(FLTR,NODE) ;Create Filters, eq, ^MAG(2005,,0 - shows all node and return the 0 node
 N FIDX,GLB,FLTS,NNODE
 S NNODE=$P(NODE,")")
 S GLB="" K FLTR
 I $P(NNODE,",,",2)'="" D
 . S GLB=$P(NNODE,",,")
 . S FLTS=$P(NNODE,GLB_",",2)
 . F FIDX=1:1:$L(FLTS,",") I $P(FLTS,",",FIDX)'="" S FLTR(FIDX)=$P(FLTS,",",FIDX)
 . S NODE=GLB_")"
 Q
 ;
STORE(RES,NODE,CNT) ; Add to the list
 N VAL
 I $D(@NODE)=1!($D(@NODE)=11) D
 . S CNT=CNT+1
 . S VAL=$G(@NODE)
 . I VAL'?1.N S VAL=$C(34)_VAL_$C(34)
 . I $L(NODE)<30 S NODE=$E(NODE_$$REPEAT^XLFSTR(" ",30),1,30)
 . S RES(CNT)=NODE_" = "_VAL
 Q
 ;
MAGINFO(OUT,MAGIEN)  ; Called internaly 
 N MAGOUT,MAGERR,IDX,JBPATH,SDESC,PATHS,QAMSG,ABSLOC,FILLOC
 K MAGOUT D GETS^DIQ(2005,MAGIEN,".01;1;2;2.1;3;4;5;6;10;15;102;103;113","EI","MAGOUT","MAGERR")
 K OUT S IDX=0
 S PATHS=$P($$IMGPLC^MAGGSIU5(MAGIEN),"|")
 S IDX=IDX+1,OUT(IDX)="IEN          : "_MAGIEN
 S IDX=IDX+1,OUT(IDX)="Abstract     : "_$P(PATHS,U,2)
 S IDX=IDX+1,OUT(IDX)="Full Res     : "_$P(PATHS,U,1)
 S QAMSG=$G(MAGOUT(2005,MAGIEN_",",103,"E"))
 I QAMSG'="" S IDX=IDX+1,OUT(IDX)="QA Message   : "_QAMSG
 S IDX=IDX+1,OUT(IDX)="Big File     : "_$P(PATHS,U,3)
 S JBPATH=$G(MAGOUT(2005,MAGIEN_",",103,"E"))
 I (JBPATH'="") S IDX=IDX+1,OUT(IDX)="JB Path      : "_JBPATH
 S IDX=IDX+1,OUT(IDX)="Short Desc   : "_$G(MAGOUT(2005,MAGIEN_",",10,"E"))
 S IDX=IDX+1,OUT(IDX)="Image Type   : "_$G(MAGOUT(2005,MAGIEN_",",3,"E"))
 S IDX=IDX+1,OUT(IDX)="Patient      : "_$G(MAGOUT(2005,MAGIEN_",",5,"E"))
 S IDX=IDX+1,OUT(IDX)="Proc Date    : "_$G(MAGOUT(2005,MAGIEN_",",15,"E"))
 S IDX=IDX+1,OUT(IDX)="Procedure    : "_$G(MAGOUT(2005,MAGIEN_",",6,"E"))
 S ABSLOC=$G(MAGOUT(2005,MAGIEN_",",2.1,"I"))
 I ABSLOC'="" S ABSLOC=$P($G(^MAG(2005.2,ABSLOC,0)),U,2)
 S IDX=IDX+1,OUT(IDX)="Abs Location : "_ABSLOC
 S FILLOC=$G(MAGOUT(2005,MAGIEN_",",2,"I"))
 I FILLOC'="" S FILLOC=$P($G(^MAG(2005.2,FILLOC,0)),U,2)
 S IDX=IDX+1,OUT(IDX)="Full Image Accessable/Offline  : "_FILLOC
 Q
 ;
QUOTE(STR) ; return quoted string
 I STR'?1.N S STR=$C(34)_STR_$C(34)
 Q STR
