ABSPHTTP ; IHS/OIT/RAM - HTTP POST functionality for sending claims ; [ 25 Mar 24  1200 ]
 ;;1.0;PHARMACY POINT OF SALE;**53**;JUN 01, 2001;Build 131
 ;
 Q
 ;
SENDMSG(DIALOUT,MSG) ;
 if $G(U)="" S U="^"
 N ABSPREQ,ABSPCRED,ABSPCLAM,ABSPSTAT,STATLIST,ERRCODE,HTTPURL,NAMSPC,ERRLIST,ERRLOC,ZZ,ABSPRESP
 set ABSPREQ=##class(%Net.HttpRequest).%New()
 set ABSPCRED=##class(Ens.Config.Credentials).%OpenId("ABSP_Optum")
 ; set ABSPCRED=##class(Ens.Config.Credentials).%OpenId("TestOutput")
 ; Uncomment the 2nd line down for actual ABSP testing, instead of the 'interim' global in the immediate line below.
 ; set ABSPCLAM=##class(%SYSTEM.Encryption).Base64Encode(^ABSPTESTCLAIM(1))
 set ABSPCLAM=##class(%SYSTEM.Encryption).Base64Encode(MSG)
 ; test server that echos data & headers. Comment out when Change HealthCare is ready to be tested.
 ; set ABSPREQ.Server="httpbin.org"
 ; bad dns server from Change Healthcare for testing failures:
 ; set ABSPREQ.Server="connecthttppost.changehealthcare.zzz"
 ; actual change healthcare website for claim submission. Same domain for both testing & live data.
 set ABSPREQ.Server="connecthttppost.changehealthcare.com"
 ; set ABSPREQ.Port=443
 set ABSPREQ.Https=1
 set ABSPREQ.SSLConfiguration="ABSP_Optum"
 Do ABSPREQ.InsertFormData("wsMessageType","PHM")
 Do ABSPREQ.InsertFormData("wsUserID",ABSPCRED.Username)
 Do ABSPREQ.InsertFormData("wsPassword",ABSPCRED.Password)
 Do ABSPREQ.InsertFormData("wsEncodedRequest",ABSPCLAM)
 Do ABSPREQ.SetHeader("Cache-Control","no-cache")
 Do ABSPREQ.SetHeader("Content-Type","application/x-www-form-urlencoded")
 Do ABSPREQ.SetHeader("Host","connecthttppost.changehealthcare.com")
 Do ABSPREQ.SetHeader("User-Agent","IndianHealthService-RPMSABSP/1.0")
 ; test line with bad URL to test how 404 errors are logged.
 ; set ABSPSTAT=ABSPREQ.Post("/grongle")
 ; normal line used with echo testing server URL that replies with all headers & data.
 ; set ABSPSTAT=ABSPREQ.Post("/anything")
 ; URL with Change Healthcare testing environment:
 ; set ABSPSTAT=ABSPREQ.Post("/qa/erx/connect/post.aspx")
 ; URL with Change Healthcare live environment:
 set ABSPSTAT=ABSPREQ.Post("/prod/erx/connect/post.aspx")
 ;
 ; W !!,"Status: "_ABSPSTAT,!!
 i +ABSPSTAT=0 d
 . ; zw ABSPSTAT
 . s STATLIST=$e(ABSPSTAT,3,999999)
 . s ERRCODE=$LG($LG(STATLIST,1),1)
 . s HTTPURL=$LG($LG(STATLIST,1),2)
 . s NAMSPC=$LG($LG($LG(STATLIST,1),10),2)
 . s ERRLIST=$LG($LG($LG(STATLIST,1),10),3)
 . s ERRLOC=$tr($p($lg(ERRLIST,$ll(ERRLIST)-1),U,2,3),U,"*")
 . s ABSPRESP="999^HTTP POST communication unsuccessful.^"_ERRCODE_U_HTTPURL_U_NAMSPC_U_ERRLOC ;
 . ; w "end of program.",!!
 e  d
 . s ZZ=ABSPREQ.HttpResponse
 . ; s data=##class(%GlobalBinaryStream).%New()
 . ; s stuff=data.ReadLine()
 . ; w "Headers: ",!!
 . ; do ZZ.OutputHeaders()
 . ; w !!,"Data: ",!!
 . ; do ZZ.OutputToDevice()
 . ;
 . s ABSPRESP=""
 . f  q:ZZ.Data.AtEnd  d
 . . s ABSPRESP=ABSPRESP_ZZ.Data.Read() ; /IHS/OIT/RAM ; 19 MAR 24 ; May run into future bug if responses go larger than MAXSTRING which is just over 3Meg.
 . . ; w ">"
 . ; w !!,"retrieved data: ",!!
 . ; zw ABSPRESP
 ; stuff,!
 ; zwrite ZZ
 ; /IHS/OIT/RAM ; 25 MAR 24 ; DEBUG ONLY - SAVE RESPONSE TO SEPARATE GLOBAL FOR VERIFICATION.
 ;    COMMENT OUT NEXT TWO LINES BEFORE GOING TO PRODUCTION.
 ; S ABSPNEXT=$O(^ABSPHTTPRESPONSE(9999999),-1)+1
 ; S ^ABSPHTTPRESPONSE(ABSPNEXT)=ABSPRESP
 Q ABSPRESP
 ;
