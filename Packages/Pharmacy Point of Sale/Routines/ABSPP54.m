ABSPP54 ;IHS/GDIT/AEF - PRE, POST, ENV CHECK ROUTINE FOR PATCH 54
 ;;1.0;PHARMACY POINT OF SALE;**54,55**;JUN 01, 2001;Build 131
 ;IHS/SD/SDR 1.0*55 ADO117693 Made correction for the HTTP POST to use the HTTP POST
 ;   for the DEFAULT DIAL OUT in the ABSP Set Up file. The Post install will only call
 ;   that one tag.
 ;
 ;
ENV ;EP - ENVIRONMENT CHECK ROUTINE
 ;
 N CVER,P
 K XPDQUIT
 ;
 S CVER=$$VERSION^XPDUTL("AG")
 I CVER=7.1 D
 . S P("AG*7.1*13")=""
 I CVER=7.2 D
 . S P("AG*7.2*4")=""
 ;
 S P("AUPN*99.1*26")=""
 S P("ABSP*1.0*47")=""
 ;
 S P=""
 F  S P=$O(P(P)) Q:P']""  D
 . I P["*" D CPCH(P,.XPDQUIT)
 . I P'["*" D CPKG(P,.XPDQUIT)
 ;
 I $G(XPDQUIT) D
 . D BMES^XPDUTL($$CJ^XLFSTR(("Required software missing!"),IOM))
 . D MES^XPDUTL($$CJ^XLFSTR(("INSTALL ABORTED!"),IOM))
 ;
 I '$G(XPDQUIT) D
 . D BMES^XPDUTL($$CJ^XLFSTR(("ALL OK! The package will be INSTALLED!"),IOM))
 ;
 Q
CPCH(P,XPDQUIT) ;CHECK PATCH
 ;
 I '$$INSTALLD(P) D
 . D MES^XPDUTL($$CJ^XLFSTR(("Patch """_P_""" or higher is required!"),IOM))
 . S XPDQUIT=1
 Q
CPKG(P,XPDQUIT) ;PACKAGE MESSAGE
 ;
 N CVER,NMSP,VER,X
 ;
 S NMSP=$P(P," ")
 S VER=$P(P," ",2)
 S CVER=$$VERSION^XPDUTL(NMSP)
 ;
 I CVER=VER D
 . D MES^XPDUTL($$CJ^XLFSTR(("Package """_P_""" is installed - *PASS*"),IOM))
 ;
 I CVER<VER D
 . I 'CVER S X=" *NOT*"
 . S V=$S(CVER]"":CVER,1:VER)
 . D MES^XPDUTL($$CJ^XLFSTR(("Package """_NMSP_" "_V_""" is"_$G(X)_" installed"),IOM))
 . D MES^XPDUTL($$CJ^XLFSTR(("Package """_P_""" or higher is required!"),IOM))
 Q
INSTALLD(PATCH) ;EP - Determine if patch is installed
 ;
 N X,Y
 ;
 S Y=0
 ;
 ;Find install entry and check if completed:
 S X=0
 F  S X=$O(^XPD(9.7,"B",PATCH,X)) Q:'X  D
 . S:$P($G(^XPD(9.7,X,0)),U,9)=3 Y=1
 ;
 ;Display message:
 D MES^XPDUTL($$CJ^XLFSTR("Patch """_PATCH_""" is"_$S(Y<1:" *NOT*",1:"")_" installed"_$S(Y<1:"",1:" - *PASS*"),IOM))
 ;
 Q Y
 ;
NOHTPOST ; DECONVERT ALL OF THE 'HTTP POST' ENTRIES BACK TO 'ENVOY DIRECT VIA T1 LINE'
 ;
 D BMES^XPDUTL("  UNMoving all NEW insurers back to old connectivity.")
 ;
 N L,L2,L3,M,M2,M3,FDA,FILE,FIELD,MSG,INS,POST,ENVOY
 ; NOW TO RESET THE DEFAULT IN THE ABSP SETUP FILE TO THE NEW CONNECTIVITY.
 ; NOW TO RESET THE DEFAULT IN THE ABSP SETUP FILE TO THE NEW CONNECTIVITY.
 ; /IHS/OIT/RAM ; P54 ; 019803 ; CHANGE FROM HARDCODED IENs TO LOOKUP.
 S POST=$O(^ABSP(9002313.55,"B","HTTP POST",0),1)
 S ENVOY=$O(^ABSP(9002313.55,"B","ENVOY DIRECT VIA T1 LINE",0),1)
 ;S FDA(9002313.99,"1,",440.01)=ENVOY  ;absp*1.0*55 IHS/SD/SDR ADO117693
 S FDA(9002313.99,"1,",440.01)=POST  ;absp*1.0*55 IHS/SD/SDR ADO117693
 D FILE^DIE("","FDA","MSG")
 I +$D(MSG)=0 D BMES^XPDUTL("  Successful UNsetting default in ABSP SETUP file to T1!")
 I +$D(MSG) D
 ..S INS=$$GET1^DIQ(9002313.4,L,.01)
 ..D BMES^XPDUTL("  ISSUE UNSETTING DEFAULT IN ABSP SETUP FILE TO HTTP POST. PLEASE INVESTIGATE.")
 K FDA,MSG
 S FILE=9002313.4,FIELD=100.07
 S L=0,L2=0,L3=0
 F  S L=$O(^ABSPEI(L)) Q:+L=0  D
 .K FDA,MSG
 .S J=$$GET1^DIQ(FILE,L_",",100.07,"I")
 .I J'=POST D
 ..;S FDA(FILE,L_",",100.07)=ENVOY  ;absp*1.0*55 IHS/SD/SDR ADO117693
 ..S FDA(FILE,L_",",100.07)=POST  ;absp*1.0*55 IHS/SD/SDR ADO117693
 ..D FILE^DIE("","FDA","MSG")
 ..I +$D(MSG)=0 S L3=L3+1
 ..I +$D(MSG) D
 ...S INS=$$GET1^DIQ(9002313.4,L,.01)
 ...D BMES^XPDUTL("  ISSUE CONVERTING "_INS_" TO HTTP POST. PLEASE INVESTIGATE.")
 ...S L2=1
 ;
 ;
 I 'L2 D
 . I L3 D
 . . D BMES^XPDUTL("  Success moving "_L3_" insurers BACK to old connectivity!")
 . E  D
 . . D BMES^XPDUTL("  No insurers needed to be moved BACK to old connectivity!")
 I L2 D BMES^XPDUTL("  ISSUES UNMOVING 1 OR MORE insurers to old connectivity!")
 ;
 Q
 ;
HTTPPOST ; CONVERT ALL OF THE 'ENVOY DIRECT VIA T1 LINE' TO 'HTTP POST'
 ;
 D BMES^XPDUTL("  Moving all T1 insurers to new connectivity.")
 ;
 N L,L2,L3,M,M2,M3,FDA,FILE,FIELD,MSG,INS,POST,ENVOY
 ; NOW TO RESET THE DEFAULT IN THE ABSP SETUP FILE TO THE NEW CONNECTIVITY.
 ; /IHS/OIT/RAM ; P54 ; 019803 ; CHANGE FROM HARDCODED IENs TO LOOKUP.
 S POST=$O(^ABSP(9002313.55,"B","HTTP POST",0),1)
 S ENVOY=$O(^ABSP(9002313.55,"B","ENVOY DIRECT VIA T1 LINE",0),1)
 S FDA(9002313.99,"1,",440.01)=POST
 D FILE^DIE("","FDA","MSG")
 I +$D(MSG)=0 D BMES^XPDUTL("  Successful setting default in ABSP SETUP file to HTTP POST!")
 I +$D(MSG) D
 . . S INS=$$GET1^DIQ(9002313.4,L,.01)
 . . D BMES^XPDUTL("  ISSUE SETTING DEFAULT IN ABSP SETUP FILE TO HTTP POST. PLEASE INVESTIGATE.")
 K FDA,MSG
 S FILE=9002313.4,FIELD=100.07
 S L=0,L2=0,L3=0
 F  S L=$O(^ABSPEI(L)) Q:+L=0  D
 . K FDA,MSG
 . S J=$$GET1^DIQ(FILE,L_",",100.07,"I")
 . I J=ENVOY D
 . . S FDA(FILE,L_",",100.07)=POST
 . . D FILE^DIE("","FDA","MSG")
 . . I +$D(MSG)=0 S L3=L3+1
 . . I +$D(MSG) D
 . . . S INS=$$GET1^DIQ(9002313.4,L,.01)
 . . . D BMES^XPDUTL("  ISSUE CONVERTING "_INS_" TO HTTP POST. PLEASE INVESTIGATE.")
 . . . S L2=1
 ;
 I 'L2 D
 . I L3 D
 . . D BMES^XPDUTL("  Success moving "_L3_" insurers to new connectivity!")
 . E  D
 . . D BMES^XPDUTL("  No insurers needed to be moved to new connectivity!")
 I L2 D BMES^XPDUTL("  ISSUES MOVING 1 OR MORE insurers to new connectivity!")
 ;
 Q
