XUSER2 ;ISF/RWF - New Person File Utilities ;8:47 AM  21 May 2003 [ 07/29/2004   9:01 AM ]
 ;;8.0;KERNEL;**267,251**;Jul 10, 1995
 Q
VALDEA(X,F) ;Check for a valid DEA#
 ;Returns 0 for NOT Valid, 1 for Valid
 ;F = 1 for Facility DEA check.
 I $D(X) K:$L(X)>9!($L(X)<9)!'(X?2U7N) X
 S F=$G(F)
 I $D(X),'F,$D(^VA(200,"PS1",X)),$O(^(X,0))'=DA D EN^DDIOL($C(7)_"CAN'T FILE: DUPLICATE DEA NUMBER") K X
 I $D(X),'F,$D(DA),$E(X,2)'=$E($P(^VA(200,DA,0),"^")) D EN^DDIOL($C(7)_"WARNING: DEA# FORMAT MISMATCH -- CHECK SECOND LETTER")
 I $D(X),'$$DEANUM(X) D EN^DDIOL($C(7)_"CAN'T FILE: DEA# FORMAT MISMATCH -- NUMERIC ALGORITHM FAILED") K X
 Q $D(X)
 ;
DEANUM(X) ;Check DEA # part
 N VA1,VA2
 S VA1=$E(X,3)+$E(X,5)+$E(X,7)+(2*($E(X,4)+$E(X,6)+$E(X,8)))
 S VA1=VA1#10,VA2=$E(X,9)
 Q VA1=VA2
 ;
REQ(XUV,XUFLAG) ;Called from forms:
 ; XUEXISTING USER, XUNEW USER, XUREACT USER, XU-CLINICAL TRAINEE
 ;from the:
 ; - Form-level pre-action
 ; - Post action on change for "Is this person a Clinical Trainee?"
 ;In:
 ; XUV = 1 if user is a clinical trainee; 0 otherwise
 ;          If XUV is not passed, its value is obtained from the
 ;          "Is this person a Clinical Trainee?" form-only field.
 ; XUFLAG = 1 if called from the XU-CLINICAL TRAINEE form;
 ;          otherwise, called from the other forms
 ;
 N XUB,XUF,XUP,XUBSSN,XUV
 I $G(XUFLAG) S (XUB,XUBSSN)="XU-CLINICAL TRAINEE 1",XUP=1
 E  D
 . S XUB="XUEXISTING USER TRAINEE"
 . S XUBSSN="XUEXISTING USER 1"
 . S XUP=5
 ;
 S:$D(XUV)[0 XUV=$$GET^DDSVALF("TR",XUB,XUP)
 ;
 ;If clinical trainee, Program of Study, editable and required and
 ;make Degree Level,Last Training Year editable, but not required.
 ;Otherwise, make them uneditable and not required, and delete their
 ;values.
 F XUF=12.1,12.2,12.3 D
 . D UNED^DDSUTL(XUF_"F",XUB,XUP,'XUV)
 . I XUF=12.2 D REQ^DDSUTL(XUF_"F",XUB,XUP,XUV)
 . D:'XUV PUT^DDSVAL(200,DA,XUF,"@","","I")
 ;
 ;Note: The following lines were commented out during Alpha testing
 ;to remove making the fields required.  The lines were left in
 ;in case at some future point they are made required again.
 ;If clinical trainee, make Street 1, City, State, Zip, and SSN
 ;required
 ;F XUF=3,6,7,8 D REQ^DDSUTL("F"_XUF,XUB,XUP,XUV)
 ;If DOB is made Required, add to the following For loop: ',5'
 ;'UNIQUE NAME' equals 'F5'
 ;F XUF=1 D REQ^DDSUTL("F"_XUF,XUBSSN,1,XUV) ; Make SSN required
 Q
