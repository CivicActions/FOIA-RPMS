XMUTERM ;ISC-SF/GMB - Delete Mailbox/Delete Message ;05/14/99  14:21
 ;;7.1;MailMan;**50**;Jun 02, 1994
 ; Taken from XUSTERM (SEA/AMF/WDE)
 ; Entry points used by MailMan options (not covered by DBIA):
 ; ALL1     XMMGR-TERMINATE-MANY
 ; ALL2     XMMGR-TERMINATE-SUGGEST
 ; CHOOSE   XMMGR-TERMINATE-ONE
 ; MESSAGE  XMMGR-PURGE-MESSAGE
MESSAGE ; Manager chooses messages to purge
 N DIR,XMABORT,XMZ,XMKILL
 Q:$$NOTAUTH()
 W @IOF,"This option enables you to purge any message."
 W !!,"Purge means:"
 W !,"-delete the message from all user mailboxes"
 W !,"-delete the message from the MESSAGE file ^XMB(3.9"
 W !,"-delete all responses from the MESSAGE file ^XMB(3.9"
 W !,"-delete the message from the MESSAGES TO BE NEW AT A LATER DATE file ^XMB(3.73"
 W !!,"Purge is not reversible.  The message is gone forever."
 S (XMABORT,XMKILL)=0
 F  D  Q:XMABORT
 . W !
 . S DIR(0)="NO^1:999999999999999:0^D CHKMSG^XMUTERM(Y)",DIR("A")="Purge MESSAGE"
 . S DIR("?")="This response must be a message number"
 . D ^DIR K DIR I $D(DIRUT) S XMABORT=1 Q
 . S XMZ=+Y
 . S DIR(0)="Y",DIR("A")="Are you sure",DIR("B")="NO"
 . D ^DIR K DIR I 'Y!$D(DIRUT) W !,"Message not purged." Q
 . S (XMKILL("MSG"),XMKILL("RESP"))=0
 . D KILL^XMA32A(XMZ,.XMKILL,XMABORT)
 . W !!,XMKILL("MSG")," message" W:XMKILL("RESP") " and ",XMKILL("RESP")," responses" W " purged."
 . S XMKILL=XMKILL+XMKILL("MSG")+XMKILL("RESP")
 Q
CHKMSG(XMZ) ;
 I '$D(^XMB(3.9,XMZ)) K X Q
 W "  ",$P($G(^XMB(3.9,XMZ,0)),U,1)
 Q
ALL1 ; MailMan chooses users to remove from MailMan
 ; (Users who shouldn't have mailboxes.)
 N XMTEST,DIR,XMABORT,XMCUTOFF,XMGRACE
 Q:$$NOTAUTH()
 S XMABORT=0
 W @IOF,"This option goes through the MailBox global and deletes the user's mailbox if"
 D HELP1
 D CUTOFF(1,.XMGRACE,.XMCUTOFF,.XMABORT) Q:XMABORT
 S DIR(0)="SO^T:Test Mode only;R:Real Mode"
 S DIR("B")="Test Mode only"
 S DIR("A")="Select Run Option"
 S DIR("?",1)="'Real Mode' will remove qualifying users from MailMan."
 S DIR("?",2)="'Test Mode' will not."
 S DIR("?",3)="Select 'Test Mode' to see who would be removed."
 S DIR("?")="Select 'Real Mode' to remove them."
 D ^DIR Q:$D(DIRUT)
 S XMTEST=$S(X="R":0,1:1)
 S (ZTSAVE("XMTEST"),ZTSAVE("XMCUTOFF"),ZTSAVE("XMGRACE"))=""
 W !!,"This report may take a while.  You might consider spooling it."
 D EN^XUTMDEVQ("ALL1TASK^XMUTERM1","MailMan: Remove user Mailboxes",.ZTSAVE)
 Q
ALL2 ; MailMan reports on users who maybe should be removed from MailMan
 ; (Users who haven't logged on in a while.)
 N XMTEST,DIR,XMABORT,XMCUTOFF,XMGRACE
 Q:$$NOTAUTH()
 S XMABORT=0
 W @IOF,"This option goes through the MailBox global and reports if"
 D HELP2
 W !!,"This option does not delete any mailboxes.  Use the XM-TERMINATE-ONE-USER"
 W !,"option to delete any user mailboxes identified in this report.",!
 D CUTOFF(2,.XMGRACE,.XMCUTOFF,.XMABORT) Q:XMABORT
 S ZTSAVE("XMCUTOFF")=""
 W !!,"This report may take a while.  You might consider spooling it."
 D EN^XUTMDEVQ("ALL2TASK^XMUTERM1","MailMan: Remove user Mailboxes",.ZTSAVE)
 Q
NOTAUTH() ;
 Q:$D(^XUSEC("XMMGR",DUZ)) 0
 W !!,*7,"You may not run this option.  You do not hold the 'XMMGR' security key!"
 Q 1
HELP1 ;
 W !,"- the user is not in the NEW PERSON file."
 W !,"- the user has no access code and was not terminated."
 W !,"- the user has no access code and was terminated w/o mailbox retention."
 W !,"- the user has an access code, but no primary menu."
 W !,"- the user has an access code and primary menu, but no verify code, AND"
 W !,"  - has never signed on, since being added before a cutoff date."
 W !,"  OR"
 W !,"  - last signed on before a cutoff date."
 W !!,"'Delete mailbox' includes:"
 W !,"- Delete user's private mail groups"
 W !,"- Remove user from membership in any group"
 W !,"- Remove user as authorized sender from any group"
 W !,"- Remove user from anyone's list of surrogates"
 W !,"- Delete user's mailbox"
 W !,"As a result, the user will not receive any mail.",!
 Q
HELP2 ;
 W !,"- the user has an access code, verify code, and primary menu, but"
 W !,"  last signed on before a cutoff date."
 W !,"- the user was terminated before a cutoff date and allowed to keep a mailbox."
 Q
CUTOFF(XMWHICH,XMGRACE,XMCUTOFF,XMABORT) ;
 N DIR
 S XMGRACE=$$FMADD^XLFDT(DT,-30)
 S DIR(0)="D^:"_XMGRACE_":EP"
 S DIR("A")="Logon cutoff date"
 S DIR("B")=$$FMTE^XLFDT(DT-10000)
 S DIR("??")="^D HCUTOFF^XMUTERM(XMWHICH)"
 D ^DIR I $D(DIRUT) S XMABORT=1 Q
 S XMCUTOFF=Y
 Q
HCUTOFF(XMWHICH) ;
 W !,"The cutoff date must be more than 30 days ago."
 W !,"It is used during the check to see if"
 I XMWHICH="*"!(XMWHICH=1) D
 . W !,"- the user has an access code and primary menu, but no verify code, AND"
 . W !,"  - has never signed on, since being added before a cutoff date."
 . W !,"  OR"
 . W !,"  - last signed on before a cutoff date."
 I XMWHICH="*"!(XMWHICH=2) D
 . W !,"- the user has an access code, verify code, and primary menu, but"
 . W !,"  last signed on before a cutoff date."
 W !!,"(If you do not wish to check mailboxes based on a cutoff date, enter '1900'.)"
 W !!,"Please enter that cutoff date."
 Q
CHOOSE ; Manager chooses user to remove from MailMan
 N XMCUTOFF,XMABORT,XMI,XMGRACE
 S XMABORT=0
 Q:$$NOTAUTH()
 W @IOF,"This option lets you delete the mailbox of a user if"
 D HELP2
 D HELP1
 D CUTOFF("*",.XMGRACE,.XMCUTOFF,.XMABORT) Q:XMABORT
 N DIR
 S DIR(0)="SO^M:MailMan presents;I:I select"
 S DIR("?",1)="Select 'M' if you want MailMan to $order through the MailBox file and"
 S DIR("?",2)="present to you candidates for mailbox deletion."
 S DIR("?",3)=""
 S DIR("?")="Select 'I' if you want to do the selection directly."
 D ^DIR Q:$D(DIRUT)
 I Y="M" D MMCHOOSE(XMGRACE,XMCUTOFF) Q
 D ICHOOSE(XMGRACE,XMCUTOFF)
 Q
MMCHOOSE(XMGRACE,XMCUTOFF) ;
 N XMI,XMABORT,XMTERM
 S (XMI,XMABORT)=0
 F  S XMI=$O(^XMB(3.7,XMI)) Q:XMI'>0  D  Q:XMABORT
 . D CHECK1^XMUTERM1(XMI,XMGRACE,XMCUTOFF,.XMTERM) I XMTERM D DELETE(XMI,.XMABORT) Q
 . D CHECK2^XMUTERM1(XMI,XMCUTOFF,.XMTERM) I XMTERM D DELETE(XMI,.XMABORT)
 Q
ICHOOSE(XMGRACE,XMCUTOFF) ;
 F  D  Q:XMABORT
 . N DIC,Y
 . S DIC="^XMB(3.7,"
 . S DIC(0)="AEQM"
 . S DIC("S")="N XMTERM,XMFORGET D CHECK1^XMUTERM1(Y,XMGRACE,XMCUTOFF,.XMTERM),CHECK2^XMUTERM1(Y,XMCUTOFF,.XMFORGET) I XMTERM!XMFORGET"
 . W ! D ^DIC I Y=-1 S XMABORT=1 Q
 . D DELETE(+Y)
 Q
DELETE(XMI,XMABORT) ;
 N XMREC,XMDELETE
 S XMREC=$G(^VA(200,XMI,0))
 I XMREC'="" D  Q:'XMDELETE
 . N DIR,Y
 . W !!,$P(XMREC,U)
 . W !,"Access Code: ",$S($P(XMREC,U,3)="":"NONE",1:"<Hidden>")
 . W ?25,"Verify Code: ",$S($P($G(^VA(200,XMI,.1)),U,2)="":"NONE",1:"<Hidden>")
 . W ?50,"Primary Menu: ",$S($P($G(^VA(200,XMI,201)),U,1)="":"NONE",1:$P($G(^DIC(19,$P(^(201),U),0)),U))
 . W !,"Date Entered: ",$S($P($G(^VA(200,XMI,1)),U,7)="":"NONE",1:$$FMTE^XLFDT($P(^(1),U,7),"2D"))
 . W ?25,"Last Logon: ",$S($P($G(^VA(200,XMI,1.1)),U,1)="":"NONE",1:$$FMTE^XLFDT($P(^(1.1),U,1),"2D"))
 . W !,"Term Date: ",$S($P(XMREC,U,11)="":"NONE",1:$$FMTE^XLFDT($P(XMREC,U,11),"2D"))
 . W:$P(XMREC,U,11) ?25,"Delete Mail: ",$S($P(XMREC,U,5)="y":"YES",1:"NO")
 . W ?50,"New Messages: ",$P(^XMB(3.7,XMI,0),U,6)
 . W !
 . S DIR(0)="Y"
 . S DIR("B")="NO"
 . S DIR("A")="Delete this user's mailbox"
 . D ^DIR I $D(DIRUT) S XMDELETE=0,XMABORT=1 Q
 . I 'Y S XMDELETE=0 Q
 . S XMDELETE=1
 W !,"Deleting mailbox for user ",XMI," ",$S(XMREC="":"* not in ^VA(200, *",1:$P(XMREC,U))
 D TERMINAT^XMUTERM1(XMI)
 Q
