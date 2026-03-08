BPXRMIM2 ; IHS/MSC/MGH - Handle Computed findings for immunizations. ;27-Oct-2021 15:30;DU
 ;;2.0;CLINICAL REMINDERS;**1001,1012,1013**;Feb 04, 2005;Build 9
 ;=================================================================
 ;This routine is designed to search  the immunication forcast
 ;data to determine if an immunization is due for a child requiring a
 ;series immunization
 ;Fixed Call to standard call for forecaster
 ;1005 Changed and added call to forecaster to display last date done
 ;if the reminder is due
 ;=====================================================================
GETVAR(BPXTRM) ;EP
 ;Get the needed data from the reminder term. This includes the date range
 ;the test name(s) and the value to search for
 N X,Y,BPXFIND,BPXTYPE,BPXFILE,BPXCOND,BPXOFF,BPXVAL,BPXRESLT,BPXLAST
 N BPXCNT,BPXHI,TARGET,BPXTEST,TSTRING,LATE,TSTNAME
 S TSTRING=""
 K ^TMP("BPXIMM",$J)
 S BPXCNT=0,BPXHI=0,BPXRESLT=0
 S X="TODAY" D ^%DT S TODAY=Y,LATE=Y
 S TARGET="^TMP(""BPXIMM"",$J)"
 S BPXFIND=0 F  S BPXFIND=$O(^PXRMD(811.5,BPXTRM,20,BPXFIND)) Q:BPXFIND=""!(BPXFIND?1A.A)!(BPXRESLT=1)  D
 .S BPXTYPE=$P($G(^PXRMD(811.5,BPXTRM,20,BPXFIND,0)),U,1)
 .S BPXTEST=$P(BPXTYPE,";",1),BPXFILE=$P(BPXTYPE,";",2)
 .Q:BPXFILE'="AUTTIMM("
 .S BPXOFF=$P($G(^PXRMD(811.5,BPXTRM,20,BPXFIND,0)),U,8)
 .S BPXOFF="-"_BPXOFF
 .;Call next routine with patient,start and stop dates,test name
 .S TSTNAME=$P(^AUTTIMM(BPXTEST,0),U,2)
 .S BPXRESLT=$$RESULT^BPXRMIM2(DFN,BPXTEST)
 I BPXRESLT=1 S TEST=0,VALUE=TSTNAME
 I BPXRESLT=0 S TEST=1,VALUE=TSTNAME,DATE=TODAY
 Q
RESULT(DFN,TEST) ;Find what is due
 ;Search the imunization forecast file to find the chosen  immunizations
 N BPXFOR,BPXIMM,BPXDONE,BPXSTR,TNAME,BIHX,BIDE,TCODE,I
 S BPXDONE=0,TSTRING=""
 ;Changed called Patch 1004 to standard call for forecaster
 S TNAME=$P(^AUTTIMM(TEST,0),U,2),TCODE=$P(^AUTTIMM(TEST,0),U,3)
 I TSTRING="" S TSTRING=TCODE
 I TSTRING'="" S TSTRING=TSTRING_","_TCODE
 ;Call the forecaster code to return the data
 N %,BID,BIT,N,X,BIUPD
 S BIUPD="",N=""
 S N=$O(^BIPDUE("B",DFN,0))
 I '+N D
 .D IMMFORC^BIRPC(.BPXSTR,DFN,"",BIUPD)
 E  D
 .S BID=$P($G(^BIPDUE(N,0)),U,6)
 .D NOW^%DTC S BIT=%
 .S:((BIT-BID)<.000059) BIUPD=1
 .D IMMFORC^BIRPC(.BPXSTR,DFN,"",BIUPD)
 F I=1:1 S BPXFOR=$P(BPXSTR,"^",I) Q:BPXFOR=""  D
 .S BPXIMM=$P(BPXFOR,"|",1)
 .;See if the immunization is due
 .I BPXIMM[TNAME S BPXDONE=1
 .;Find the date last done
 .S DATE=$$LASTIMM^BIUTL11(DFN,TSTRING)
 Q BPXDONE
IMMUNIZ(DFN,TEST,DATE,VALUE,TEXT) ;Call for all immunizations
 N BPXTRM,BPXNAME,BPXREM
 S BPXTRM="",BPXNAME=TEST
 S LINE=1,TEST=0,DATE="",VALUE="",TEXT=""
 S BPXREM="" S BPXREM=$O(^PXD(811.9,"B",BPXNAME,BPXREM))
 Q:BPXREM=""
 S BPXTRM=$O(^PXD(811.9,BPXREM,20,"E","PXRMD(811.5,",BPXTRM))
 I BPXTRM=""  S TEST=0,TEXT="Reminder term does not exist" Q
 D GETVAR^BPXRMIM2(BPXTRM)
 Q
