XMUT4B ;(WASH ISC)/CAP-INTEGRITY CHECKER ;09/22/98  10:58
 ;;7.1;MailMan;**50**;Jun 02, 1994
SUMMARY ;
 W !!,"Summary of Integrity Check"
 I '$D(XMERROR) W !!,"No errors to report." Q
 D:$E($O(XMERROR(99)),1)=1 SUM
 D:$E($O(XMERROR(199)),1)=2 SUM^XMUT4BA
 K XMERROR
 Q
SUM ;
 W !!,"^XMB(3.7, MAILBOX file"
 S XMERRNUM=0
 F  S XMERRNUM=$O(XMERROR(XMERRNUM)) Q:'XMERRNUM!(XMERRNUM>199)  D
 . W !!,"Type ",$J(XMERRNUM,3)," errors=",XMERROR(XMERRNUM)
 . D DESCRIBE(XMERRNUM)
 Q
DESCRIBE(XMERRNUM) ; ERROR TYPE DICTIONARY
 N I,XMLINE
 F I=0:1 S XMLINE=$T(@XMERRNUM+I) Q:XMLINE=""!(XMLINE[";;;;")  D
 . W !,?4,$P(XMLINE,";;",2)
 Q
101 ;;Msg in basket, but not in Message file: removed from basket.  *FIXED*
 ;;A message in a basket points to a non-existent message in the
 ;;message file.
 ;;To fix this, the message is removed from the basket.
 ;;If left alone, the message would have been removed from the basket
 ;;when the user tried to access the message.
 ;;;;
102 ;;Msg in basket, but no seq #: seq # created.  *FIXED*
 ;;A message in a basket has no sequence number.
 ;;To fix this, a sequence number was created to place the message at
 ;;the end of the basket.
 ;;If left alone, the user would have had difficulty locating this
 ;;message.
 ;;;;
103 ;;Msg in basket, but no .01 field: .01 field created.  *FIXED*
 ;;A message in a basket has no message number in its .01 field.
 ;;To fix this, its message number (from the IEN) was placed in the
 ;;.01 field
 ;;If left alone, the MailMan would have had difficulty dealing with
 ;;this message.
 ;;;;
111 ;;Msg in basket, but no M xref: xref created.  *FIXED*
 ;;A message in a basket has no "M" cross-reference.
 ;;To fix this, the "M" cross-reference has been created.
 ;;If left alone, the 'unreferenced messages' purge might
 ;;have purged the message.
 ;;(This part of the integrity checker is called by XMAUTOPURGE
 ;;before it actually purges.)
 ;;;;
112 ;;Msg in basket, but no C xref: xref created.  *FIXED*
 ;;A message in a basket has a sequence number,
 ;;but it is not in the "C" cross-reference for that basket.
 ;;To fix this, the "C" cross-reference has been created, using
 ;;the message's sequence number.
 ;;If left alone, the user would have had difficulty locating this
 ;;message.
 ;;;;
113 ;;New msg in basket, but no N0 xref: xref created.  *FIXED*
 ;;A message in a basket is flagged new,
 ;;but it is not in the "N0" cross-reference for that basket.
 ;;To fix this, the "N0" cross-reference has been created.
 ;;If left alone, the message would not have appeared new to the user.
 ;;;;
121 ;;M xref, but not in bskt: xref killed.  *FIXED*
 ;;A message exists in the "M" cross-reference,
 ;;but not in the basket to which it is pointing.
 ;;To fix this, the "M" cross-reference has been killed.
 ;;If left alone, the "M" cross-reference would have prevented the
 ;;message from being purged during the unreferenced messages purge.
 ;;;;
122 ;;C xref, but msg not in basket: msg put in basket.  *FIXED*
 ;;A message exists in the "C" cross-reference,
 ;;but not in the user's basket.
 ;;To fix this, the message has been put in the basket at the
 ;;sequence number indicated by the C xref.
 ;;If left alone, there would have been problems when the user
 ;;tried to access the message.
 ;;;;
123 ;;C xref, but no msg seq #: seq # set using xref.  *FIXED*
 ;;A message exists in the "C" cross-reference,
 ;;but the sequence number is null in the basket entry.
 ;;To fix this, the message sequence number has been set using
 ;;the sequence number indicated by the C xref.
 ;;If left alone, there would have been problems when the user
 ;;tried to access the message.
 ;;;;
124 ;;C xref does not match msg seq #: xref killed.  *FIXED*
 ;;A message exists in the "C" cross-reference,
 ;;but the sequence number in the basket entry differs from
 ;;the sequence number in the "C" cross-reference.
 ;;To fix this, the "C" cross-reference has been killed.
 ;;If left alone, there would have been problems when the user
 ;;tried to access the message.
 ;;;;
125 ;;C xref duplicate seq #s: basket reseq'd.  *FIXED*
 ;;More than one message has the same sequence number.
 ;;To fix this, the entire basket was reseqenced.
 ;;If left alone, there would have been problems when the user
 ;;tried to access the messages with the duplicate sequence numbers.
 ;;;;
126 ;;N0 xref, but not in basket: put in basket.  *FIXED*
 ;;A message exists in the "N0" cross-reference,
 ;;but not in the user's basket to which it is pointing.
 ;;To fix this, the message has been put in the user's basket.
 ;;If left alone, there might have been problems when the user
 ;;tried to access the message.
 ;;;;
127 ;;N0 xref, but msg not flagged new: flag set.  *FIXED*
 ;;A message exists in the "N0" cross-reference,
 ;;but the message isn't flagged new
 ;;To fix this, the message new flag has been set.
 ;;If left alone, the message might have remained new even after
 ;;the user read it.
 ;;;;
131 ;;No basket zero node or B xref: 0 node created.  *FIXED*
 ;;A basket has no zero node or "B" cross-reference.
 ;;To fix this, a zero node is created using and the basket is
 ;;named "* No Name *".
 ;;If left alone, there might have been problems when the user
 ;;tried to access the basket.
 ;;;;
132 ;;Basket zero node, but no name or B xref: 0 node created.  *FIXED*
 ;;A basket has a zero node, but its name is null and it has
 ;;no "B" cross-reference.
 ;;To fix this, the basket is named "* No Name *".
 ;;If left alone, there might have been problems when the user
 ;;tried to access the basket.
 ;;;;
133 ;;No msg multiple zero node: 0 node created.  *FIXED*
 ;;A basket has no message multiple zero node.
 ;;To fix this, the message multiple zero node is created.
 ;;If left alone, there might have been problems when the user
 ;;tried to access the basket.
 ;;;;
151 ;;B xref, but basket name null: name set using xref.  *FIXED*
 ;;A basket has no name.
 ;;To fix this, the basket is named using the basket name from the
 ;;"B" cross-reference.
 ;;If left alone, there might have been problems when the user
 ;;tried to access the basket.
 ;;;;
152 ;;B xref, but no basket zero node: 0 node created.  *FIXED*
 ;;A basket has no zero node.
 ;;To fix this, a zero node is created using the basket name from the
 ;;"B" cross-reference.
 ;;If left alone, there might have been problems when the user
 ;;tried to access the basket.
 ;;;;
160 ;;Xmit basket<1000 has domain name: investigate msgs.  *WARNING*
 ;;One of the Postmaster's baskets with an IEN less than 1000
 ;;has the same name as of one of the domains in the DOMAIN file.
 ;;Usually, such baskets have IENs which are the DOMAIN IEN+1000 and
 ;;contain messages which are queued to be transmitted to the domain.
 ;;We must investigate the messages in this fake domain basket.
 ;;;;
161 ;;Msg in xmit basket<1000 not addressed to Postmaster: deleted.  *FIXED*
 ;;A message in a fake domain basket is not addressed to the Postmaster,
 ;;and it is not queued to go to the domain,
 ;;so it has been deleted from the basket.
 ;;;;
162 ;;Msg in xmit basket<1000: copied to proper bskt.  *FIXED*
 ;;A message in a fake domain basket is addressed to the Postmaster,
 ;;and is queued to go to the domain, but it is not in the proper
 ;;transmit basket.  It has been copied to the proper transmit basket.
 ;;;;
163 ;;Msg in xmit basket<1000: moved to proper bskt.  *FIXED*
 ;;A message in a fake domain basket is not addressed to the Postmaster,
 ;;and is queued to go to the domain, but it is not in the proper
 ;;transmit basket.  It has been moved to the proper transmit basket.
 ;;;;
164 ;;Xmit basket<1000 with no msgs: deleted.  *FIXED*
 ;;A fake domain basket has no messages, so to avoid further confusion,
 ;;it has been deleted.
 ;;;;
