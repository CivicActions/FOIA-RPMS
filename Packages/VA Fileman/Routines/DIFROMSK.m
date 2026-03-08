DIFROMSK ;SCISC/DCL-DIFROM SERVER DELETE PARTS ;02:55 PM  9 Sep 1994; [ 09/09/1998  12:03 PM ]
 ;;21.0;VA Fileman;**1007**;SEP 8, 1998
 ;;21.0;VA FileMan;;Dec 28, 1994
 ;Per VHA Directive 10-93-142, this routine should not be modified.
 Q
 ;
DEL(DIFRFILE,DIFRFLG,DIFRSA,DIFRMSGR) ;DELETE TEMPLATES
 ;FILE_NUMBER,FLAGS,SOURCE_ARRAY,MSG_ARRAY_ROOT
 ;*
 ;FILE_NUMBER = Template File Number
 ;
 ;     (Required) -
 ;                  Forms           .403   ^DIST(.403,   "DIST(.403,"
 ;                  Blocks          .404   ^DIST(.404,   "DIST(.404,"
 ;                  Input Template  .402   ^DIE(         "DIE"
 ;                  Print Template  .4     ^DIPT(        "DIPT"
 ;                  Sort Template   .401   ^DIBT(        "DIBT"
 ;*
 ;FLAGS = None at this time
 ;*
 ;SOURCE_ARRAY = Source Array where the list of internal
 ;               entry numbers are passed (IEN/DA).
 ;               Format is:   ARRAY(DA)=""
 ;               In this example "ARRAY" is passed.
 ;*
 ;MSG_ARRAY_ROOT = Array Root where the error message will be sent.
 ;*
 I '$D(DIQUIET) N DIQUIET S DIQUIET=1
 I '$D(DIFM) N DIFM S DIFM=1
 I $G(U)'="^"!($G(DT)'>0)!($G(DTIME)'>0)!('$D(DUZ)) D DT^DICRW
 D  I '$G(DIFRFILE) D BLD^DIALOG(9529) Q
 .I $G(DIFRFILE)'>0 Q
 .I DIFRFILE=.4!(DIFRFILE=.401)!(DIFRFILE=.402)!(DIFRFILE=.403)!(DIFRFILE=.404) Q
 .S DIFRFILE=0
 .Q
 I $G(DIFRSA)']"" D BLD^DIALOG(9506) Q
 I '$D(@DIFRSA) D BLD^DIALOG(9506) Q
 N DIFRDA,DIFROOT,DIFRCR
 S DIFRDA=0,DIFROOT=$$ROOT^DILFD(DIFRFILE),DIFRCR=$$ROOT^DILFD(DIFRFILE,"",1)
 I DIFROOT']"" D BLD^DIALOG(9529) Q
 ;I $$NPT(
 F  S DIFRDA=$O(@DIFRSA@(DIFRDA)) Q:DIFRDA'>0  D:$D(@DIFRCR@(DIFRDA,0))
 .I DIFRFILE=.4!(DIFRFILE=.401)!(DIFRFILE=.402) D DT(DIFROOT,DIFRDA) Q
 .I DIFRFILE=.404 D DFB(DIFRDA) Q
 .Q
 Q
 ;
DT(DIK,DA) ;Delete Template
 N DIFRFILE,DIFRSA,DIFRFLG,DIFRMSGR,DIFRDA,DIFRCR,DIFROOT
 N %,A,B,D0,I,W,X,Y,Z
 S Y=""
 D ^DIK
 Q
 ;
DFB(DA) ;Delete Forms and Blocks, within the specified form.
 D EN^DDSDFRM(DA)
 Q
 ;
EXIT I $G(DIFRMSGR)]"" D CALLOUT^DIEFU(DIFRMSGR)
 Q
 ;
