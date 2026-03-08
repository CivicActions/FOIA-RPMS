AMHPEDIT ; IHS/CMI/LAB - INPUT TX ON PATIENT FIELD OF BH RECORD ;
 ;;3.0;IHS BEHAVIORAL HEALTH;**6,8**;JAN 27, 2003
 ;
 ;
 Q:'$D(AMHDATE)
 I AUPNDOD,$P(AMHDATE,".")>AUPNDOD W !,"  <Patient died before the visit date: DOD is "_$$FMTE^XLFDT(AUPNDOD)_">" Q
 I $P(AMHDATE,".")<AUPNDOB W !,"  <Patient born after the record date>" K X Q
 Q
 ;
 ;
DODGP(P,D) ;EP - called from screenman
 ;
 I $G(P)="" Q
 NEW T
 K T
 I $$DOD^AUPNPAT(P),$P(D,".")>$$DOD^AUPNPAT(P) D
 .S T(1)="  <Patient died before the visit date: DOD is "_$$FMTE^XLFDT($$DOD^AUPNPAT(P))_">"
 .S T(2)="  If you do not want to create a visit for this patient, please remove"
 .S T(3)="  them from the list by using the '@' to delete them."
 .D HLP^DDSUTL(.T)
 Q
