XMUT4BA ;(WASH ISC)/CAP-INTEGRITY CHECKER ;06/14/99  16:50
 ;;7.1;MailMan;**50**;Jun 02, 1994
 Q
SUM ;
 W !!,"^XMB(3.9, MESSAGE file"
 S XMERRNUM=199
 F  S XMERRNUM=$O(XMERROR(XMERRNUM)) Q:'XMERRNUM!(XMERRNUM>299)  D
 . W !!,"Type ",$J(XMERRNUM,3)," errors=",XMERROR(XMERRNUM)
 . D DESCRIBE(XMERRNUM)
 Q
DESCRIBE(XMERRNUM) ; ERROR TYPE DICTIONARY
 N I,XMLINE
 F I=0:1 S XMLINE=$T(@XMERRNUM+I) Q:XMLINE=""!(XMLINE[";;;;")  D
 . W !,?4,$P(XMLINE,";;",2)
 Q
201 ;;Msg has bad/no 0 node *NOT FIXED*
 ;;A message has a bad/no zero node.
 ;;A message like this usually is not owned by anybody and can be
 ;;deleted.  Entries like this can be created by Network Mail when
 ;;your site is receiving a message, and the transmission ends
 ;;ungracefully before MailMan can recognize this and kill off the
 ;;incomplete transmission.
 ;;XMAUTOPURGE will usually purge this message.
 ;;;;
202 ;;Msg has no subject *FIXED*
 ;;A message has no subject.
 ;;This can happen with incoming network mail.
 ;;To fix this, the subject has been set to: "* No Subject *"
 ;;;;
203 ;;Msg subject <3 or >65 *NOT FIXED*
 ;;A message's subject is shorter or longer than the current standard
 ;;allows.
 ;;Most of these errors were created by versions of MailMan prior
 ;;to version 3.1 and do no harm.
 ;;;;
204 ;;Msg subject has no B xref *FIXED*
 ;;A message's subject has no "B" cross-reference.
 ;;To fix this, the "B" cross-reference is created.
 ;;If left alone, one could not have looked up this message by its
 ;;subject.
 ;;;;
205 ;;Msg subject B xref is too long *FIXED*
 ;;A message's subject "B" cross-reference is longer than in the DD.
 ;;To fix this, the "B" cross-reference is shortened.
 ;;If left alone, the "B" cross-reference would not have been killed
 ;;when the message was purged.
 ;;;;
206 ;;Msg has no sender *FIXED*
 ;;A message has no sender.
 ;;To fix this, the sender has been set to: "* No name *"
 ;;;;
207 ;;Msg has no date/time *FIXED*
 ;;A message has no date/time.
 ;;To fix this, the date/time has been set to: DT
 ;;;;
208 ;;Msg has no local create date *FIXED*
 ;;A message has no local create date.
 ;;This date is used by the message purge processes.
 ;;To fix this, the local create date has been set to the date
 ;;that the message was sent.
 ;;;;
209 ;;Msg local create date has no C xref *FIXED*
 ;;A message's local create date has no "C" cross-reference.
 ;;To fix this, the "C" cross-reference is created.
 ;;If left alone, the purge process would miss it.
 ;;;;
211 ;;Msg thinks it's a response to itself *FIXED*
 ;;A message points to itself in piece 8 of its zero node.
 ;;To fix this, piece 8 of the message zero node has been made null.
 ;;Run XMAUTOPURGE to purge the response.
 ;;;;
212 ;;Response has no original msg *FIXED*
 ;;A message seems to be a response, but the message to which it is
 ;;responding doesn't seem to be there.
 ;;Each response is associated with a message.  The response has the
 ;;original message number in piece 8 of its 0 node.  Local responses
 ;;have their subjects set to "R"_<original message number>.
 ;;(e.g. R1233 points to and is a response to message number 1233).
 ;;
 ;;In MailMan 3.2 and later, users are not allowed to use this
 ;;syntax for message subjects, in order to avoid contradictions
 ;;in the database.  This was not true in MailMan 3.09 and
 ;;earlier versions.
 ;;
 ;;A real message will usually have recipients
 ;;and be pointed at from ^XMB(3.7,"M",XMZ,...
 ;;
 ;;A real response will not have responses, although it may have recipients.
 ;;
 ;;To fix this, piece 8 of the response zero node has been made null.
 ;;Run XMAUTOPURGE to get rid of responses which don't have their
 ;;original messages.
 ;;;;
213 ;;Response not in response chain of original msg *FIXED*
 ;;A message seems to be a response, but the message to which it
 ;;claims to be responding does not have it in its response multiple.
 ;;To fix this, piece 8 of the response zero node has been made null.
 ;;Run XMAUTOPURGE to purge the response.
 ;;;;
216 ;;Response has no original msg *NOT FIXED*
 ;;A message seems to be a response, because its subject is Rnnn, but
 ;;the message to which it claims to be responding doesn't seem to be
 ;;there, and piece 8 of the response zero node is null.
 ;;Run XMAUTOPURGE to purge the response.
 ;;;;
217 ;;Response not in response chain of original msg *NOT FIXED*
 ;;A message seems to be a response, because its subject is Rnnn, but
 ;;the message to which it claims to be responding doesn't have it in
 ;;its response multiple, and piece 8 of the response zero node is null.
 ;;Run XMAUTOPURGE to purge the response.
 ;;;;
218 ;;Response didn't point to original msg in piece 8 *FIXED*
 ;;A message seems to be a response, because its subject is Rnnn, and
 ;;the message to which it claims to be responding does have it in
 ;;its response multiple, but piece 8 of the response zero node is null.
 ;;To fix this, piece 8 of the response zero node has been made to
 ;;point to its original message.
 ;;;;
221 ;;Recip null and no C xref *NOT FIXED*
 ;;A message recipient is null, and there is no "C" cross-reference
 ;;from which to regenerate the recipient.
 ;;This should be fixed manually.
 ;;;;
222 ;;Recip has no C xref: xref created *FIXED*
 ;;A message recipient has no "C" cross-reference.
 ;;To fix this the "C" cross-reference is created.
 ;;If left alone, responses might not have gone to the recipient.
 ;;;;
223 ;;Recip C xref is too long: xref shortened *FIXED*
 ;;A message recipient has a "C" cross-reference which is longer
 ;;than the DD expects.
 ;;To fix this the "C" cross-reference is shortened.
 ;;If left alone, nothing bad would have happened.
 ;;;;
231 ;;C xref, but recip null: fixed using numeric C xref *FIXED*
 ;;A message recipient is null, but it does have a numeric
 ;;"C" cross-reference, meaning that the recipient is local.
 ;;To fix this, the recipient is set to user pointed to by the
 ;;"C" cross-reference.
 ;;;;
232 ;;C xref, but recip null and C xref not numeric *NOT FIXED*
 ;;A message recipient is null, but it does have a "C" cross-reference.
 ;;However, the "C" cross-reference is not numeric, meaning that the
 ;;recipient is remote.  The "C" cross-reference may not have the
 ;;full recipient address, so we do not fix it.
 ;;This should be fixed manually.
 ;;;;
233 ;;C xref does not match recip: xref killed *FIXED*
 ;;A "C" cross-reference does not match the recipient value.
 ;;To fix this, the "C" cross-reference is killed.
 ;;;;
