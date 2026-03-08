BEHOIMPU ;IHS/MSC/PLS - SUPPORT FOR IMPLANTABLE DEVICES ;11-Dec-2019 11:57;du
 ;;1.1;BEH COMPONENTS;**073001**;March 20,2007
 ;Utility RPCs to support implantable devices
 Q
 ; Fileman Lookup utility (uses FIND^DIC)
 ;  INP = GBL [1] ^ Lookup Value [2] ^ FROM [3] ^ DIR [4] ^ MAX [5] ^ XREF [6] ^ SCRN [7] ^ ALL [8] ^ FLDS [9]
 ;   GBL  = File global root (open or closed, without leading ^) or file #
 ;   FROM = Text from which to start search
 ;   DIR  = Search direction (not supported)
 ;   MAX  = Maximum # to return (defaults to 44)
 ;   XREF = Cross ref to use (defaults to "B")
 ;   SCRN = Screening logic (e.g. => .04="TEST";.07=83)
 ;   ALL  = Return all records, maximum of 9999
 ;   FLDS = Fields to return
DICLKUP(RET,INP) ;EP
 N GBL,LKP,FROM,DIR,MAX,XREF,XREFS,SCRN,ALL,FLDS,FNUM,LP,X
 S DATA=$$TMPGBL^BEHOIMP1("IMPLOOOKUP")
 S GBL=$P(INP,U)
 I GBL=+GBL S GBL=$$ROOT^DILFD(GBL,,1)
 E  S GBL=$$CREF^DILF(U_GBL)
 S FNUM=$P($G(@GBL@(0)),U,2),FNUM(0)=FNUM["P",FNUM=+FNUM
 Q:'FNUM
 S LKP=$P(INP,U,2)
 S FROM=$P(INP,U,3)
 S DIR=$P(INP,U,4)  ; ignored
 S MAX=$P(INP,U,5)
 S XREF=$TR($P(INP,U,6),"~",U)
 S SCRN=$TR($P(INP,U,7),"~",U)
 S ALL=$P(INP,U,8)
 S FLDS=$P(INP,U,9)
 S:FLDS="" FLDS=".01"
 I LKP'="",FROM="" S FROM=LKP
 S MAX=$S(ALL:9999,MAX>0:+MAX,1:100),DIR=$S(DIR'=-1:1,1:-1)
 D FIND^DIC(FNUM,,"@;"_FLDS,"BP",LKP,MAX,XREF,SCRN,,RET)
 K @RET@("DILIST",0)
 Q
