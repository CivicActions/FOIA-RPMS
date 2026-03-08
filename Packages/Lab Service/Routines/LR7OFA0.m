LR7OFA0 ; IHS/DIR/AAB - Receive/Route MSG array from OE/RR to AP ; [ 8/11/97 ]
 ;;5.2;LR;**1003**;JUN 01, 1998
 ;
 ;;5.2;LAB SERVICE;**121**;Sep 27, 1994
 ;
EN(MSG) ;Route all AP messages from here
 N X,VISIT,LOC,LOCP,ROOM,DFN,PNM,LRXMSG,TEST,TESTN,TYPE,SAMP,SPEC,URG,ORIFN,STARTDT,LRDUZ,PROV,REASON,LRSX,LRLLOC,LROLLOC,LRPRAC,LROUTINE,LRSDT,LRXZ,LRODT,LRSAMP,LRSPEC,LRORDR,LRLB,LRNT,LRSX,LROT,LRCOM,LRI,LRIO,LRJ,LRORD
 N LOCA,LINE,LRORDER,LRORIFN,LRSN,LRSUM,LRSXN,LRTIME,LRTSTS,LRURG,LRSDT,LREND,LRXTYPE,LRXORC,LRDFN,LRDPF,LRPLACR
 S LRXORC=$S($P($G(MSG(3)),"|")="ORC":MSG(3),1:"ORC")
 I '$D(MSG(1)) D ACK^LR7OF0("DE",LRXORC,"No Message Header (MSH)") Q
 S X=MSG(1) I $P(X,"|")'="MSH" D ACK^LR7OF0("DE",LRXORC,"Invalid (MSH) Message Header: "_$P(X,"|")) Q
 I $P(X,"|",2)'="^~\&" D ACK^LR7OF0("DE",LRXORC,"Invalid Encoding Characters: "_$P(X,"|",2)) Q
 I $P(X,"|",3)'="ORDER ENTRY" D ACK^LR7OF0("DE",LRXORC,"Unrecognized message source: "_$P(X,"|",3)) Q
 I $P(X,"|",4)'=DUZ(2) D ACK^LR7OF0("DE",LRXORC,"DUZ(2) doesn't match institution in message: "_DUZ(2)_"'="_$P(X,"|",4)) Q
 I $P(X,"|",9)'="ORM"&($P(X,"|",9)'="ORR") D ACK^LR7OF0("DE",LRXORC,"Unrecognized Message type: "_$P(X,"|",9)) Q
 I '$D(MSG(2)) D ACK^LR7OF0("DE",LRXORC,"No Patient ID in message") Q
 S X=MSG(2)
 I $P(X,"|")'="PID" D ACK^LR7OF0("DE",LRXORC,"Invalid (PID) message header: "_$P(X,"|")) Q
 I '$L($P(X,"|",6)) D ACK^LR7OF0("DE",LRXORC,"No Patient Name") Q
 S DFN=$S($P(X,"|",4):$P(X,"|",4),1:+$P(X,"|",5)),LRDPF=$S($P(X,"|",4):"2^DPT(",1:$P(@("^"_$P($P(X,"|",5),";",2)_"0)"),"^",2)_"^"_$P($P(X,"|",5),";",2)),PNM=$P(X,"|",6),LRDFN=$P($G(@("^"_$P(LRDPF,"^",2)_+DFN_",""LR"")")),"^")
 I 'LRDFN D ACK^LR7OF0("DE",LRXORC,"Invalid LRDFN") Q
 I '$D(@("^"_$P(LRDPF,"^",2)_+LRDFN_",0)")) D ACK^LR7OF0("DE",LRXORC,"Patient identifyer: "_LRDFN_" not found in "_LRDPF_" file") Q
 I $P(@("^"_$P(LRDPF,"^",2)_+LRDFN_",0)"),"^")'=PNM D ACK^LR7OF0("DE",LRXORC,"Patient Name: "_PNM_" doesn't match name file: "_$P(^(0),"^")) Q  ;Global reference most likely ^LR(LRDFN,0), but could be other lab object file.
 S LINE=2,LRSX=0,LREND=0 F  S LINE=$O(MSG(LINE)) Q:LINE<1  S LRXMSG=MSG(LINE) D:$O(MSG(LINE,0)) SPLIT^LR7OF0 D  I LREND Q
 . I $P(LRXMSG,"|")="PV1" S VISIT=$P(LRXMSG,"|",19),LOC=$P($P(LRXMSG,"|",4),"^"),ROOM=$P($P(LRXMSG,"|",4),"^",2),LOCP=LOC,LOCA=$S(LOCP:$P(^SC(LOCP,0),"^",2),1:"") Q
 . I $P(LRXMSG,"|")="ORC" S LRXTYPE=$P(LRXMSG,"|",2),LRXORC=LRXMSG I LRXTYPE="NW" D NEW^LR7OF2 Q  ;New order, from OE/RR
 . I $P(LRXMSG,"|")="ORC",LRXTYPE="CA" D CANC^LR7OF2 S LREND=1 Q  ;Cancel order, from OE/RR
 . I $P(LRXMSG,"|")="ORC",LRXTYPE="XO" D XO^LR7OF2 Q  ;Change order
 . I $P(LRXMSG,"|")="ORC",LRXTYPE="NA" D NUM^LR7OF2 S LREND=1 Q  ;Backdoor new order, request order number
 . I $P(LRXMSG,"|")="ORC" D ACK^LR7OF0("DE",LRXORC,"Unrecognized Order Control: "_LRXTYPE) Q
 . I $P(LRXMSG,"|")="OBR",LRXTYPE="NW" D OBR^LR7OFA3 Q
 . I $P(LRXMSG,"|")="OBR",LRXTYPE="XO" D OBR^LR7OFA3 Q
 . I $P(LRXMSG,"|")="NTE" D NTE^LR7OFA2 Q  ;Order comments
 . D ACK^LR7OF0("DE",LRXORC,"Unrecognized Message segment: "_$P(LRXMSG,"|")) Q
 I LREND S LREND=0 Q
 I LRXTYPE="NW" D  ;Process new order request
 . S LROLLOC=LOCP,LRLLOC=$S($L($G(LOCA)):LOCA,1:"UNKNOWN"),LRDFN=$P($G(@("^"_$P(LRDPF,"^",2)_+LRDPF_",""LR"")")),"^"),LRPRAC=PROV,LROUTINE=$P(^LAB(69.9,1,3),"^",2)
 . I $D(^XUTL("OR",$J,"LROT")) S LRSDT=0 F  S LRSDT=$O(^XUTL("OR",$J,"LROT",LRSDT)) Q:LRSDT<1  S LRXZ="" F LRI=0:0 S LRXZ=$O(^XUTL("OR",$J,"LROT",LRSDT,LRXZ)) Q:LRXZ=""  S LRORD=^XUTL("OR",$J,"LROT",LRSDT,LRXZ),LRODT=$P(LRSDT,".") D EN^LR7OFA1
 . K ^XUTL("OR",$J,"LROT"),^("COM") D ACK^LR7OF0("OK","ORC|OK|"_LRPLACR_"|"_LRORD_";"_LRODT_";"_LRSN_"^"_$S($G(MSG)="BBMSG":"LRBB",$G(MSG)="APMSG":"LRAP",1:"LRCH"),"")
 Q
