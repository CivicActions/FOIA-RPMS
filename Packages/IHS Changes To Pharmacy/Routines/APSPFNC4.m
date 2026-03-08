APSPFNC4 ;IHS/MSC/DKM E-Prescribing Support ;16-Feb-2024 12:01;DU
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1007,1009,1016,1024,1035**;Sep 23, 2004;Build 39
 ;==============================================================
 ; Pharmacy List Update Functions
 ; Patch 1016 added XUMF variable
 ; Patch 1035 added logic to inactivate entries missing from import and convert country code to uppercase
PHLFIL(DIR,FIL,MAX) ; EP - Import updates from a file
 N ERR,POP,CNT,XUMF
 D OPEN^%ZISH(,DIR,FIL,"R")
 I POP W "File not found",! Q
 S ERR="",MAX=+$G(MAX)
 S XUMF=1
 D PUT^XPAR("SYS","APSP SS DIRECTORY LAST UPDATE",,$E($$NOW^XLFDT(),1,12))
 D BLDTMP  ;p1035 Build list of current entries
 F CNT=1:1 D  Q:POP!(CNT=MAX)
 .N REC,LP
 .U IO
 .D READNXT^%ZISH(.REC)
 .I '$L($G(REC)) S POP=1 Q
 .S LP=0
 .F  S LP=$O(REC(LP)) Q:'LP  S REC=REC_REC(LP)
 .U IO(0)
 .S ERR=$$PHLREC(REC)
 .W:$L(ERR) CNT,": ",ERR,!
 D UPDOREC  ;p1035 Update abandoned entries
 D CLOSE^%ZISH()
 Q
PHLGBL(GBL) ; EP - Import updates from a local or global array
 N LP,ERR
 S (LP,ERR)=""
 F  S LP=$O(@GBL@(LP)) Q:'$L(LP)  S ERR=$$PHLREC(@GBL@(LP)) Q:$L(ERR)
 Q ERR
PHLREC(REC,DEBUG) ; EP - Import updates from a single record
 N LP,CTL,ERR,FDA,NCPDPID,IEN,SFN,SFNC,STNAME,IENS,D,P
 S D=$C(124)
 ;FID 107183
 Q:$$UP^XLFSTR($P(REC,D,9))'="US" "Not a US address"  ;Only process entries with US as the country code.
 S NCPDPID=$P(REC,D),SFNC=1,DEBUG=$G(DEBUG)
 Q:'$L(NCPDPID) "Missing NCPDP ID"
 S STNAME=$P(REC,D,3)
 Q:'$L(STNAME) "Missing Store Name"
 S IEN=$O(^APSPOPHM("C",NCPDPID,0))
 K:IEN ^TMP($J,"APSPCURRENT",IEN)  ;Remove entries that are in import file
 S FDA=$NA(FDA(9009033.9,$S(IEN:IEN,1:"+1")_","))
 S @FDA@(.11)="@"  ;Remove temp entry flag
 F LP=0:1 S CTL=$P($T(CTL60+LP),";;",2,99) Q:'$L(CTL)  D  Q:$D(ERR)
 .N X,FNUM,FNAM,TFRM
 .S FNAM=$P(CTL,";"),FNUM=$P(CTL,";",2)
 .S P=$P(CTL,";",3),X=$P(REC,D,P)
 .S TFRM=$P(CTL,";",4)
 .I FNUM'[":" D
 ..I TFRM="" D SCHAR(.X)
 ..E  X TFRM
 .I DEBUG U IO(0) W $P(CTL,";"),"=",X,!
 .I $D(ERR) S ERR="Error processing field "_FNAM_": "_ERR
 .E  Q:'$L(X)
 .E  I FNUM'[":" S @FDA@(FNUM)=X
 .E  D
 ..X TFRM
 Q:$D(ERR) ERR
 K:IEN ^APSPOPHM(IEN,3),^(4),^(8),^(9)
 D UPDATE^DIE("E","FDA",,"ERR")
 I $G(ERR("DIERR",1)) D  Q ERR
 .S LP=0,ERR=""
 .F  S LP=$O(ERR("DIERR",1,"TEXT",LP)) Q:'LP  S ERR=ERR_$S($L(ERR):" ",1:"")_ERR("DIERR",1,"TEXT",LP)
 Q ""
 ; Convert SS date format to FM
DT(X) S:$L(X) X=+($TR($P(X,"T"),"-")-17000000_"."_$TR($P($P(X,"T",2,99),"."),":"))
 Q
 ; Normalize phone format
PHONE(X) S X=$S($L($P(X,U,2)):$P(X,U,1)_"x"_$P(X,U,2),1:$P(X,U))
 S:X'?10N.(1"x"1.14N) X=""
 Q
 ; Validate email address
EMAIL(X) S X=$S(X'["@":"",1:X)
 Q
SPEC(X) ; Put specialty into upper case
 D SCHAR(.X)
 S X=$$UP^XLFSTR(X)
 Q
SCHAR(X) ; Remove characters that interfere with fileman
 S X=$$DESCAPE^HLOPRS1(X,"|","^","&","~","\")
 S X=$TR(X,"^&","")
 Q
 ;
MULTVAL(X) ;EP-Generic logic for mutliple type fields
 N LP
 S SFN=+FNUM,FNUM=$P(FNUM,":",2)
 F LP=1:1:$L(X,"~") S ITM=$P(X,"~",LP) Q:'$L(ITM)  D
 .S:FNUM=.01 SFNC=SFNC+1,IENS="+"_SFNC_","_$S(IEN:IEN,1:"+1")_","
 .Q:'$L($G(IENS))
 .D SCHAR(.ITM)
 .S:FNUM=.01!$D(FDA(SFN,IENS,.01)) FDA(SFN,IENS,FNUM)=ITM
 Q
ALTPHN(X) ;EP-Logic to identify alternate phone numbers
 N LP,ITM,QL,EXT,PHN
 S SFN=+FNUM,FNUM=$P(FNUM,":",2)
 F LP=1:1:$L(X,"~") S ITM=$P(X,"~",LP) Q:'$L(ITM)  D
 .S QL=$P(ITM,U),PHN=$TR($P(ITM,U,2,3),U,"x") D PHONE(.PHN)
 .S:FNUM=.01 SFNC=SFNC+1,IENS="+"_SFNC_","_$S(IEN:IEN,1:"+1")_","
 .Q:'$L($G(IENS))
 .I FNUM=.01!$D(FDA(SFN,IENS,.01)) D
 ..S FDA(SFN,IENS,FNUM)=PHN
 ..S FDA(SFN,IENS,.02)=QL
 Q
SPCLTY(X) ;EP-Logic to identify specialty types
 N LP,ITM,OK,ERR,ARY,ITMIEN
 S SFN=+FNUM,FNUM=$P(FNUM,":",2)
 F LP=1:1:$L(X,"~") S ITM=$P(X,"~",LP) D
 .S ITMIEN=$$FIND1^DIC(9009033.76,,,ITM)
 .I ITMIEN D
 ..D SVLFDA(ITMIEN,"9009033.98:.01")
 ;F LP=1:1:$L(X,"~") S ITM=$P(X,"~",LP) Q:'$L(ITM)  D
 ;.D SPEC(.ITM)
 ;.S:FNUM=.01 SFNC=SFNC+1,IENS="+"_SFNC_","_$S(IEN:IEN,1:"+1")_","
 ;.Q:'$L($G(IENS))
 ;.D VAL^DIE(SFN,IENS,.01,,ITM,.OK,,"ERR")
 ;.Q:$G(OK)="^"
 ;.S:FNUM=.01!$D(FDA(SFN,IENS,.01)) FDA(SFN,IENS,FNUM)=ITM
 Q
SVLLOOP(TXT) ;EP-Identify service levels
 N ITM,ARY,LP,ITMIEN
 F LP=1:1:$L(TXT,"~") S ITM=$P(TXT,"~",LP) D
 .S ITMIEN=$$FIND1^DIC(9009033.75,,,ITM)
 .I ITMIEN D
 ..S ARY(ITMIEN)=""
 ..D SVLFDA(ITMIEN,"9009033.99:.01")
 S @FDA@(.05)=$$SVLVAL(.ARY)
 Q
SVLVAL(SVLARY) ;EP-Calculate service level bit value
 N BIT,IEN,V
 S (BIT,IEN,VAL)=0 F  S IEN=$O(SVLARY(IEN)) Q:'IEN  D
 .S V=+$P($G(^APSPNCP(9009033.75,IEN,0)),U,2)
 .S BIT=BIT+V
 Q BIT
SVLFDA(X,FNUM) ;EP-Create FDA array for the service level
 S IEN=$G(IEN,0)
 S SFN=+FNUM,FNUM=$P(FNUM,":",2)
 S:FNUM=.01 SFNC=SFNC+1,IENS="+"_SFNC_","_$S(IEN:IEN,1:"+1")_","
 Q:'$L($G(IENS))
 S:FNUM=.01!$D(FDA(SFN,IENS,.01)) FDA(SFN,IENS,FNUM)="`"_X
 Q
 ;Build temp global for current values in ^APSPOPHM
BLDTMP ;-
 N LP,NID
 K ^TMP($J,"APSPCURRENT")
 S LP=0
 F  S LP=$O(^APSPOPHM(LP)) Q:'LP  D
 .S NID=$P(^APSPOPHM(LP,0),U,2)
 .I NID'=2122548 D   ; Exclude Bannockburn Pharmacy
 ..S ^TMP($J,"APSPCURRENT",LP)=NID
 Q
 ;Inactivate old entries
 ;ACTIVE END TIME to 1/1/2000@23:59:59 when field value is in the future
UPDOREC ;-
 N IEN,REC,AEDT,CNT
 S IEN=0,CNT=0
 F  S IEN=$O(^TMP($J,"APSPCURRENT",IEN)) Q:'IEN  D
 .S REC=$G(^APSPOPHM(IEN,7)),AEDT=$P(REC,U,2)
 .I AEDT=""!(AEDT>$$NOW^XLFDT()) D
 ..S $P(^APSPOPHM(IEN,7),U,2)=3000101.235959
 ..S CNT=CNT+1
 K ^TMP($J,"APSPCURRENT")
 Q
 ;Import control data
 ;Format is:
 ;;<SS field name>;<FM field #>;<piece>;<length>;<transform>
 ;Import control data for version 6.0
 ;Format is:
 ;;<SS field name>;<FM field #>;<piece>;<transform>;<delim for multipart field>;<multipart format=fld:piece(s) separated by comma$<transform>#<additional fields>
CTL60 ;;NCPDPID;.02;1;
 ;;StoreNumber;.03;2;
 ;;StoreName;.01;3;D SCHAR(.X) S X=$E(X,1,35)
 ;;StoreName;.1;3;
 ;;AddressLine1;1.1;4;
 ;;AddressLine2;1.2;5;
 ;;City;1.3;6;
 ;;State;1.4;7;
 ;;Zip;1.5;8;D SCHAR(.X) S X=$E(X,1,5)
 ;;PhonePrimary;2.1;15;S X=$P(X,U,1,2) D PHONE(.X)
 ;;Fax;2.2;16;D PHONE(.X)
 ;;Email;2.3;17;D EMAIL(.X)
 ;;PhoneAlt;9009033.93:.01;18;D ALTPHN(X);
 ;;ActiveStartTime;7.1;19;D DT(.X)
 ;;ActiveEndTime;7.2;20;D DT(.X)
 ;;ServiceLevels;9009033.99:.01;21;D SVLLOOP(X);
 ;;PartnerAccount;7.3;22;
 ;;LastModifiedDate;7.4;23;D DT(.X)
 ;;CrossStreet;1.6;24;
 ;;RecordChange;6.1;25;
 ;;Version;6.2;27;
 ;;NPI;.04;28;
 ;;SpecialtyType1;9009033.98:.01;29;D SPCLTY(X)
 ;;MedicareNumber;6.3;34;
 ;;MedicaidNumber;6.4;35;
 ;;Latitude;1.7;44;
 ;;Longitude;1.8;45
 ;;Precise;1.9;46;
 ;;
