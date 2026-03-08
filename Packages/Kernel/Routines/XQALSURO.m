XQALSURO ;ISC-SF.SEA/JLI - SURROGATES FOR ALERTS ;3/1/02  13:59 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1007**;APR 1, 2003
 ;;8.0;KERNEL;**114,125,173**;Jul 10, 1995
 ;;
 Q
OTHRSURO ; OPT:- XQALERT SURROGATE SET/REMOVE -- OTHERS SPECIFY SURROGATE FOR SELECTED USER
 N XQAUSER
 K DIR S DIR(0)="PD^200:AEMQ",DIR("A",1)="SURROGATE related to which"
 S DIR("A")="NEW PERSON entry"
 D ^DIR K DIR Q:Y'>0  W "  ",$P(Y,U,2)
 S XQAUSER=+Y
 I $$CURRSURO(XQAUSER)'>0 G SURROGAT
 G CHKREMV
 ;
SURROGAT ; USER SPECIFICATION OF SURROGATE
 N DIR,XQALSURO,XQALSTRT,XQALEND
SURRO1 S DIR(0)="P^200:AEMQ",DIR("A")="Select USER to be SURROGATE" D ^DIR K DIR Q:Y'>0  ; COS-0401-41366
 W "  ",$P(Y,U,2)
 S XQALSURO=+Y
 I $$CYCLIC(XQALSURO,XQAUSER)'>0 W $C(7),!,$$CYCLIC(XQALSURO,XQAUSER),! G SURRO1
 S DIR(0)="DO^::ATEX",DIR("A")="Specify Date/Time SURROGATE becomes active" ; BRX-1000-10427
 S DIR("A",1)="",DIR("A",2)=""
 S DIR("A",3)="if no date/time is entered, alerts will start going to"
 S DIR("A",4)="the SURROGATE immediately."
 D ^DIR K DIR
 S XQALSTRT=+Y
 S DIR(0)="DO^::AETX",DIR("A")="Specify Date/Time SURROGATE should be removed" ; BRX-1000-10427
 S DIR("A",1)="",DIR("A",2)=""
 S DIR("A",3)="if no date/time is entered, YOU must remove the SURROGATE"
 S DIR("A",4)="to terminate alerts going to the SURROGATE"
 D ^DIR K DIR
 S XQALEND=+Y
 D SETSURO(XQAUSER,XQALSURO,XQALSTRT,XQALEND)
 Q
 ;
CYCLIC(XQALSURO,XQAUSER) ; code added to prevent cyclical surrogates
 N XQALSTRT
 I XQALSURO=XQAUSER Q "You cannot specify yourself as your own surrogate!"
 S XQALSTRT=$$CURRSURO(XQALSURO) I XQALSTRT>0 D
 . I XQALSTRT=XQAUSER S XQALSURO="YOU are designated as the surrogate for this user - can't do it!" Q
 . F  S XQALSTRT=$$CURRSURO(XQALSTRT) Q:XQALSTRT'>0  I XQALSTRT=XQAUSER S XQALSURO="This forms a circle which leads back to you - can't do it!" Q
 . Q
 Q XQALSURO
 ;
SETSURO(XQAUSER,XQALSURO,XQALSTRT,XQALEND) ; SR
 N XQALFM
 I $G(XQAUSER)'>0 Q
 I $G(XQALSURO)'>0 Q
 I '$D(^XTV(8992,XQAUSER,0)) D
 . N XQALFM,XQALFM1
 . S XQALFM1(1)=XQAUSER
 . S XQALFM(8992,"+1,",.01)=XQAUSER
 . D UPDATE^DIE("","XQALFM","XQALFM1")
 . Q
 S XQAUSER=XQAUSER_","
 S XQALFM(8992,XQAUSER,.02)=XQALSURO
 I $G(XQALSTRT)>0 S XQALFM(8992,XQAUSER,.03)=XQALSTRT
 I $G(XQALEND)>0 S XQALFM(8992,XQAUSER,.04)=XQALEND
 D FILE^DIE("I","XQALFM")
 N XQAMESG,XMSUB,XMTEXT
 S XQAMESG(1,0)="You have been specified as a surrogate recipient for alerts for"
 S XQAMESG(2,0)=$$GET1^DIQ(200,(XQAUSER_","),.01,"E")_" (IEN="_$P(XQAUSER,",")_") effective "_$S($G(XQALSTRT)'>0:"immediately",1:$$FMTE^XLFDT(XQALSTRT))
 I $G(XQALEND)'>0 S XQAMESG(2,0)=XQAMESG(2,0)_"."
 E  S XQAMESG(3,0)="until "_$$FMTE^XLFDT(XQALEND)
 S XMSUB="Surrogate Recipient for "_$$GET1^DIQ(200,(XQAUSER_","),.01,"E")
 S XMTEXT="XQAMESG("
 D SENDMESG
 Q
 ;
 ; usage $$SETSURO1(XQAUSER,XQALSURO,XQALSTRT,XQALEND)  returns 0 if invalid, otherwise > 0
SETSURO1(XQAUSER,XQALSURO,XQALSTRT,XQALEND) ; SR. This should be used instead of SETSURO
 I $$CYCLIC(XQALSURO,XQAUSER)'>0 Q 0 ; Can't use as surrogate
 D SETSURO(XQAUSER,XQALSURO,XQALSTRT,XQALEND)
 Q XQALSURO
 ;
CHKREMV ;
 N DIR
 S DIR("A",1)=$$GET1^DIQ(8992,(XQAUSER_","),.02,"E")_" is currently your surrogate"
 S DIR(0)="Y",DIR("A")="Do you really want to REMOVE this surrogate",DIR("B")="YES"
 D ^DIR K DIR I 'Y Q
 D REMVSURO(XQAUSER)
 Q
 ;
REMVSURO(XQAUSER) ; SR
 I $G(XQAUSER)'>0 Q
 N XQALFM,XQALSURO
 S XQALSURO=+$P($G(^XTV(8992,XQAUSER,0)),U,2)
 S XQAUSER=XQAUSER_","
 S XQALFM(8992,XQAUSER,.02)="@"
 S XQALFM(8992,XQAUSER,.03)="@"
 S XQALFM(8992,XQAUSER,.04)="@"
 D FILE^DIE("","XQALFM")
 I XQALSURO>0 D
 . N XQAMESG,XMSUB,XMTEXT
 . S XQAMESG(1,0)="You have been REMOVED as a surrogate recipient for alerts for"
 . S XQAMESG(2,0)=$$GET1^DIQ(200,(XQAUSER_","),.01,"E")_" (IEN="_$P(XQAUSER,",")_")."
 . S XMTEXT="XQAMESG(",XMSUB="Removal as surrogate recipient"
 . D SENDMESG
 Q
 ;
CURRSURO(XQAUSER) ;SR. - returns current surrogate for user or -1  usage $$CURRSURO^XQALSURO(DUZ)
 N X S X=$G(^XTV(8992,XQAUSER,0))
 I $P(X,U,2)>0 D  I $P($G(^XTV(8992,XQAUSER,0)),U,2)>0 Q +$P(^XTV(8992,XQAUSER,0),U,2)
 . N NOW,DATE S NOW=$$NOW^XLFDT() ;   Get Current date/time to check date/times if present
 . S DATE=$P(X,U,4) I (DATE>0&(DATE<NOW))!('$$CYCLIC($P(X,U,2),XQAUSER)) D  Q  ;  Current Date/time past End date for surrogate or cyclic relationship
 . . N FDA
 . . S FDA(8992,(XQAUSER_","),.02)="@"
 . . S FDA(8992,(XQAUSER_","),.03)="@"
 . . S FDA(8992,(XQAUSER_","),.04)="@"
 . . D FILE^DIE("E","FDA") ;            Remove surrogate and related date/times
 . . Q
 . Q
 Q -1
 ;
GETSURO(XQAUSER) ;SR. - returns data for surrogate for user including times
 I $$CURRSURO(XQAUSER)'>0 Q ""
 N GLOBREF,IENS,X
 S IENS=XQAUSER_",",GLOBREF=$NA(^TMP($J,"XQALSURO")) K @GLOBREF
 D GETS^DIQ(8992,IENS,".02;.03;.04","IE",GLOBREF)
 S GLOBREF=$NA(@GLOBREF@(8992,IENS))
 S X=$G(@GLOBREF@(.02,"I"))_U_$G(@GLOBREF@(.02,"E"))_U_$G(@GLOBREF@(.03,"I"))_U_$G(@GLOBREF@(.04,"I"))
 K @GLOBREF
 Q X
 ;
GETFOR ;OPT.
 N XQAUSER,VALUES,XQACNT
 K DIR S DIR(0)="PD^200:AEMQ",DIR("A",1)="View Users who have selected a specified User as their Surrogate."
 S DIR("A")="Select User (NEW PERSON entry)"
 D ^DIR K DIR Q:Y'>0  W "  ",$P(Y,U,2)
 S XQAUSER=+Y
 D SUROFOR(.VALUES,XQAUSER) I VALUES'>0 W !,"No entries found.",!! Q
 S XQACNT=0 K DIRUT F I=0:0 S I=$O(VALUES(I)) Q:I'>0  D:(XQACNT>(IOSL-4))  Q:$D(DIRUT)  W !,?5,$P(VALUES(I),U,2) S XQACNT=XQACNT+1
 . S DIR(0)="E" D ^DIR K DIR
 . Q
 K DIRUT
 Q
 ;
SUROFOR(LIST,XQAUSER) ;SR. - returns list of users XQAUSER is acting as a surrogate for
 I $G(XQAUSER)="" Q
 N I,COUNT S I=0,COUNT=0 F  S I=$O(^XTV(8992,"AC",XQAUSER,I)) Q:I'>0  I $$CURRSURO(I)>0 D
 . S COUNT=COUNT+1,LIST(COUNT)=I_U_$$GET1^DIQ(200,(I_","),".01","E")_U_$$GET1^DIQ(8992,(I_","),".03","E")_U_$$GET1^DIQ(8992,(I_","),".04","E")
 S LIST=COUNT
 Q
 ;
SENDMESG ;
 N XMY,XMDUZ,XMCHAN
 S XMY(XQALSURO)="",XMDUZ=.5
 D ^XMD
 Q
