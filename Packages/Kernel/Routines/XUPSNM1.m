XUPSNM1 ;BPOIFO/KEITH - NAME STANDARDIZATION ; 12 Aug 2002@20:20
 ;;8.0;KERNEL;**309**; Jul 10, 1995;
 ;
NOTES() ;Produce value for the file #20 NOTES ABOUT NAME field
 ;Output: string representing when, who and how editing occurred
 ;
 N XUWHEN,XUWHO,XUHOW
 S XUWHEN=$$FMTE^XLFDT($$NOW^XLFDT())
 S XUWHO=$S($G(DUZ)>0:$$GET1^DIQ(200,DUZ_",",.01),1:"Unknown")
 S XUWHO=XUWHO_" ("_$G(DUZ)_")"
 S XUHOW=$P($G(XQY0),U)
 Q "Edited: "_XUWHEN_" By: "_XUWHO_" With: "_XUHOW
 ;
COMP(XUX,XUDNC) ;Use existing name array
 ;Input: XUX=name array (pass by reference)
 ;     XUDNC='do not componentize' flag (pass by reference)
 ;
 N XUY,XUI,XUZ
 Q:$D(XUX)<10  Q:XUDNC=0
 S XUDNC=1,XUY="FAMILY^GIVEN^MIDDLE^PREFIX^SUFFIX^DEGREE"
 F XUI=1:1:6 S XUZ=$P(XUY,U,XUI) S:'$D(XUX(XUZ)) XUX(XUZ)=""
 Q
 ;
F1(XUX,XUCOMA)  ;Transform text value
 ;Input: XUX=text value to transform (pass by reference)
 ;    XUCOMA=comma indicator
 ;Output: 1 if changed, 0 otherwise
 ;
 N XUI,XUII,XUC,XUY,XUZ,XUOLDX S XUOLDX=XUX
 ;Transform accent grave to apostrophe
 S XUX=$TR(XUX,"`","'")
 ;Transform single characters
 F XUI=1:1:$L(XUX) S XUC=$E(XUX,XUI) D:$$FC1(.XUC,XUCOMA)
 .S XUX=$E(XUX,0,XUI-1)_XUC_$E(XUX,XUI+1,999)
 .Q
 ;Transform double character combinations
 S XUY="  ^--^,,^''^,-^,'^ ,^-,^',^ -^ '^- ^' ^-'^'-"
 S XUZ=" ^-^,^'^,^,^,^,^,^ ^ ^ ^ ^-^-"
 F XUI=1:1 S XUC=$P(XUY,U,XUI) Q:XUC=""  D
 .Q:XUX'[XUC
 .F XUII=1:1:$L(XUX,XUC)-1 D
 ..S XUX=$P(XUX,XUC,0,XUII)_$P(XUZ,U,XUI)_$P(XUX,XUC,XUII+1,999)
 ..Q
 .Q
 ;Remove NMI and NMN
 F XUY="NMI","NMN" I XUX[XUY,XUCOMA=3 D
 .S XUC=$F(XUX,XUY)
 .I " ,"[$E(XUX,(XUC-4))," ,"[$E(XUX,XUC) D
 ..S XUX=$E(XUX,0,(XUC-4))_$E(XUX,(XUC),999)
 ..F XUY="  ",",," I XUX[XUY D
 ...S XUC=$F(XUX,XUY) S XUX=$E(XUX,0,(XUC-3))_$E(XUX,(XUC-1),999) Q
 ..F XUZ=" ","," F XUC=1,$L(XUX) D
 ...I $E(XUX,XUC)=XUZ S XUX=$E(XUX,0,(XUC-1))_$E(XUX,(XUC+1),999) Q
 ..Q
 .Q
 ;Clean up numerics
 I XUX?.E1N.E D
 .S XUY="1ST^2ND^3RD^4TH^5TH^6TH^7TH^8TH^9TH"
 .F XUI=1:1:$L(XUX) S XUC=$E(XUX,XUI) D:XUC?1N
 ..I XUC," ,"[$E(XUX,XUI-1),$E(XUX,XUI,XUI+2)=$P(XUY,U,XUC)," ,"[$E(XUX,XUI+3) Q
 ..I XUC=1," ,"[$E(XUX,XUI-1),$E(XUX,XUI,XUI+3)="10TH"," ,"[$E(XUX,XUI+4) S XUI=XUI+1 Q
 ..S XUX=$E(XUX,0,XUI-1)_$E(XUX,XUI+1,999)
 ..Q
 .Q
 ;Check for dangling apostrophes
 I XUX["'" F XUI=1:1:$L(XUX) S XUC=$E(XUX,XUI) D:XUC?1"'"
 .I $E(XUX,(XUI-1))?1U,$E(XUX,(XUI+1))?1U Q
 .S XUX=$E(XUX,0,(XUI-1))_$E(XUX,(XUI+1),99),XUI=1
 .Q
 ;Remove parenthetical text from name value
 N XUCH S XUOLDX(2)=XUX,XUCH=1 F  Q:'XUCH  D
 .S XUCH=0,XUOLDX(1)=XUX,XUY="()[]{}" D
 ..F XUI=1,3,5 S XUC(1)=$E(XUY,XUI),XUC(2)=$E(XUY,XUI+1) D
 ...S XUZ(1)=$$CLAST(XUX,XUC(1)) Q:'XUZ(1)  S XUZ(2)=$F(XUX,XUC(2),XUZ(1))
 ...I XUZ(2)>XUZ(1) S XUX=$E(XUX,0,(XUZ(1)-2))_$E(XUX,XUZ(2),999)
 ...S XUCH=(XUX'=XUOLDX(1)) Q
 ..Q
 .Q
 S:XUX'=XUOLDX(2) XUAUDIT(2)=""
 F XUI=1:1:6 S XUC=$E(XUY,XUI) D
 .F  Q:XUX'[XUC  S XUX=$P(XUX,XUC)_$P(XUX,XUC,2,999)
 .Q
 ;Insure value begins and ends with an alpha character
 F  Q:'$L(XUX)!($E(XUX,1)?1A)  S XUX=$E(XUX,2,999)
 F  Q:'$L(XUX)!($E(XUX,$L(XUX))?1A)  Q:($L(XUX,",")=2)&($E(XUX,$L(XUX))=",")  S XUX=$E(XUX,1,($L(XUX)-1))
 Q XUX'=XUOLDX
 ;
CLAST(XUX,XUC) ;Find last instance of character
 N XUY,XUZ
 S XUZ=$F(XUX,XUC) Q:'XUZ XUZ
 F  S XUY=$F(XUX,XUC,XUZ) Q:'XUY  S XUZ=XUY
 Q XUZ
 ;
FC1(XUC,XUCOMA) ;Transform single character
 ;Input: XUC=character to transform (pass by reference)
 ;    XUCOMA=comma indicator
 ;Output: 1 if value is changed, 0 otherwise
 ;
 S XUC=$E(XUC) Q:'$L(XUC) 0
 ;See if comma stays
 I XUCOMA'=3,XUC?1"," Q 0
 ;Retain uppercase, numeric, hyphen, apostrophe and space
 Q:XUC?1U!(XUC?1N)!(XUC?1"-")!(XUC?1"'")!(XUC?1" ") 0
 ;Retain parenthesis, bracket and brace characters
 Q:XUC?1"("!(XUC?1")")!(XUC?1"[")!(XUC?1"]")!(XUC?1"{")!(XUC?1"}") 0
 ;Transform lowercase to uppercase
 I XUC?1L S XUC=$C($A(XUC)-32) Q 1
 ;Set all other characters to space
 S XUC=" " Q 1
