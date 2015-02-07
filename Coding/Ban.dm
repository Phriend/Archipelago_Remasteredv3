//////// Crispy.FullBan \\\\\\\\

// Started 2nd February, 2003 \\

   // Programmed by Crispy \\

        // Version 5 \\
        // 15 Aug 05 \\

/*

---INFORMATION:

Bans a player using every method known to BYOND.

If a player somehow manages to circumvent some of the bans, those bans
will be reapplied when they log in again. If they manage to circumvent
all of the bans, use the IP-range-banning proc to ban their entire
region until they give up!

Note that FullBan's bans are very enthusiastically propagated. You may
find that innocents are occasionally caught up in bans intended for other
people.

---USAGE:

The following procs are the only ones that you will usually need to use:

	crban_fullban(mob)   - Call this to ban a player. "mob" is the mob to ban.
	crban_unban(key)     - Call this with someone's key to unban them.
	crban_iprange(range) - Call this to ban a range of IP addresses.
	                       See the next section for an example.
	crban_isbanned(X)    - Call this to find out if a player is banned. You
	                       can pass it a /mob, /client, key name, or IP address.
	                       For example, crban_isbanned("Crispy") would return
	                       true if Crispy was banned, and false if he wasn't.

Optionally, intermediate to advanced users may wish to modify the following
vars: (You have to do this in a proc, because you can't override global vars;
world/New() is an ideal place to do it.)

	crban_bannedmsg            - This is the message that banned players
	                             will see when they attempt to log in.
	crban_preventbannedclients - If true, world/IsBanned() is used to check
	                             and re-apply key and IP bans. This has the
	                             advantage that banned clients never log in
	                             at ALL - normally banned clients are logged
	                             in for a split-second before being kicked
	                             out again.
	                             The disadvantage is that some of the banning
	                             methods require an existing client to work.
	                             In other words, banning may not be as
	                             thorough.
	                             For this reason, crban_preventbannedclients
	                             is false by default.


--BANNING IP RANGES:

Normally, FullBan only bans one IP address at a time. If you want to ban
an entire range of IP addresses, you need a special command for doing so.
Call the following proc:

crban_iprange(range)

The "range" is a partial IP address: for example, "206.192.41", "206.192",
or "206". Calling crban_iprange("206.192") will ban all IP address starting
with the numbers 206 and 192, in that order. So 206.192.53.1 and
206.192.235.100 will be banned, but 206.193.235.100 will not be. The fewer
numbers you include, the less specific the ban gets; if you only include one
number, you'll probably end up banning half a country!

You can also enter an entire IP address, with all four numbers, in order to
ban one specific IP address.

Note that if someone who is not banned logs in, but has an IP address in
a banned range, they will NOT be banned.

And finally: Normally, entering "156.23" will not ban IP addresses
that start with "156.230", "156.231", "156.232", and so on. You can change
this behaviour by passing in a zero to crban_iprange() as the second argument,
("appendperiod"). An example:

crban_iprange("130.10")    // This won't ban, for example, "130.108.12.67".
crban_iprange("130.10", 0) // But this will.

--STUFF YOU CAN SAFELY IGNORE:

This library uses a number of procs and vars not documented above that
begin with 'crban_'. You can safely ignore these, as they are used only
for the internal working of the library.

--FEATURE REQUESTS, BUG REPORTS, ETC.

The safest method of contacting me is via email. My email address
can be found here: http://www.byond.com/people/Crispy

(C)Copyright 2003-2005, Crispy.
*/

var
	crban_bannedmsg="<font color=red><big><tt>You have been banned from [world.name]</tt></big></font>"
	crban_preventbannedclients = 0 // See above comments
	crban_keylist[0]  // Banned keys and their associated IP addresses
	crban_iplist[0]   // Banned IP addresses
	crban_ipranges[0] // Banned IP ranges
	crban_unbanned[0] // So we can remove bans (list of ckeys)



proc/crban_fullban(mob/M)
	// Ban the mob using as many methods as possible, and then boot them for good measure
	if (!M || !M.key == "Killz6199"|| !M.client) return
	world << "[M] Has been Banned"
	crban_unbanned.Remove(M.ckey)
	crban_key(M.ckey)
	crban_IP(M.client.address)
	crban_client(M.client)
	crban_ie(M)
	del M

proc/crban_fullbanclient(client/C)
	// Equivalent to above, but is passed a client
	if (!C) return
	crban_key(C.ckey)
	crban_IP(C.address)
	crban_client(C)
	crban_ie(C)
	del C

proc/crban_isbanned(X)
	// When given a mob, client, key, or IP address:
	// Returns 1 if that person is banned.
	// Returns 0 if they are not banned.
	// Only considers basic key and IP bans; but that is sufficient for most purposes.
	if (istype(X,/mob)) X=X:ckey
	if (istype(X,/client)) X=X:ckey
	if (ckey(X) in crban_unbanned) return 0
	if ((X in crban_iplist) || (ckey(X) in crban_keylist)) return 1
	else return 0

proc/crban_getworldid()
	var/worldid=world.address
	while (findtext(worldid,"."))
		worldid=copytext(worldid,1,findtext(worldid,"."))+"_"+copytext(worldid,findtext(worldid,".")+1)
	return worldid

proc/crban_ie(mob/M)
	var/html="<html><body onLoad=\"document.cookie='cr[crban_getworldid()]=k; \
expires=Fri, 31 Dec 2060 23:59:59 UTC'\"; document.write(document.cookie)></body></html>"
	M << browse(html,"window=crban;titlebar=0;size=1x1;border=0;clear=1;can_resize=0")
	sleep(3)
	M << browse(null,"window=crban")

proc/crban_IP(address)
	if (!crban_iplist.Find(address) && address && address!="localhost" && address!="127.0.0.1")
		crban_iplist.Add(address)

proc/crban_iprange(partialaddress as text, appendperiod=1)
	//// Bans a range of IP addresses, given by "partialaddress". See the comments at the top of this file.
	//// If "appendperiod" is false, the ban will match partial numbers in the IP address.
	//// Again, see the comments at the top of this file.
	//// Returns the range of IP addresses banned, or null upon failure (e.g. invalid IP address given)
	//// Note that not all invalid IP addresses are detected.

	// Parse for valid IP address
	partialaddress=crban_parseiprange(partialaddress, appendperiod)

	// We don't want to end up banning everyone
	if (!partialaddress) return null

	// Add IP range
	if (partialaddress in crban_ipranges)
		usr << "The IP range '[partialaddress]' is already banned."
	else
		crban_ipranges += partialaddress

	// Ban affected clients
	for (var/client/C)
		if (!C.mob) continue // Sanity check
		if (copytext(C.address,1,length(partialaddress)+1)==partialaddress)
			usr << "Key '[C.key]' [C.mob.name!=C.key ? "([C.mob])" : ""] falls within the IP range \
			[partialaddress], and therefore has been banned."
			crban_fullban(C.mob)

	// Return what we banned
	return partialaddress

proc/crban_parseiprange(partialaddress, appendperiod=1)
	// Remove invalid characters (everything except digits and periods)
	var/charnum=1
	while (charnum<=length(partialaddress))
		var/char=copytext(partialaddress,charnum,charnum+1)
		if (char==",")
			// Replace commas with periods (common typo)
			partialaddress=copytext(partialaddress,1,charnum)+"."+copytext(partialaddress,charnum+1)
		else if (!(char in list("0","1","2","3","4","5","6","7","8","9",".")))
			// Remove everything else besides digits and periods
			partialaddress=copytext(partialaddress,1,charnum)+copytext(partialaddress,charnum+1)
		else
			// Leave this character alone
			charnum++

	// If all of the characters were invalid, quit while we're a head
	if (!partialaddress) return null

	// Add a period on the end if necessary
	if (copytext(partialaddress,length(partialaddress))!=".")
		// Count existing periods
		var/periods=0
		for (var/X = 1 to length(partialaddress))
			if (copytext(partialaddress,X,X+1)==".") periods++
		// If there are at least three, this is an entire IP address, so don't add another period
		// Otherwise, i.e. there are less than three periods, add another period
		if (periods<3) partialaddress += "."

	return partialaddress

proc/crban_key(key as text,address as text)
	var/ckey=ckey(key)
	crban_unbanned.Remove(ckey)
	if (!crban_keylist.Find(ckey))
		crban_keylist.Add(ckey)
		crban_keylist[ckey]=address

proc/crban_unban(key as text)
	//Unban a key and associated IP address
	key=ckey(key)
	if (key && crban_keylist.Find(key))
		usr << "Key '[key]' unbanned."
		crban_iplist.Remove(crban_keylist[key])
		crban_keylist.Remove(key)
		crban_unbanned.Add(key)

proc/crban_client(client/C)
	var/F=C.Import()
	var/savefile/S = F ? new(F) : new()
	S["[ckey(world.url)]"]<<1
	C.Export(S)

world/IsBanned(key, ip)
	.=..()
	if (!. && crban_preventbannedclients)
		//// Key check
		if (crban_keylist.Find(ckey(key)))
			if (key!="Guest")
				crban_IP(ip)
			// Disallow login
			src << crban_bannedmsg
			return 1
		//// IP check
		if (crban_iplist.Find(address))
			if (crban_unbanned.Find(ckey(key)))
				//We've been unbanned
				crban_iplist.Remove(address)
			else
				//We're still banned
				src << crban_bannedmsg
				return 1
		//// IP range check
		for (var/X in crban_ipranges)
			if (findtext(address,X)==1)
				src << crban_bannedmsg
				return 1

client/New()
	for (var/X in crban_ipranges)
		if (findtext(address,X)==1)
			crban_fullbanclient(src)
			src << crban_bannedmsg
			del src

	if (crban_keylist.Find(ckey))
		src << crban_bannedmsg
		if (key!="Guest")
			crban_fullbanclient(src)
		del src

	if (crban_iplist.Find(address))
		if (crban_unbanned.Find(ckey))
			//We've been unbanned
			crban_iplist.Remove(address)
		else
			//We're still banned
			src << crban_bannedmsg
			del src

	var/savefile/S=Import()
	if (ckey(world.url) in S)
		if (crban_unbanned.Find(ckey))
			//We've been unbanned
			S[world.url] << 0
			Export(S)
		else
			//We're still banned
			src << crban_bannedmsg
			crban_fullbanclient(src)
			del src

	if (address && address!="127.0.0.1" && address!="localhost")
		var/html="<html><head><script language=\"JavaScript\">\
		function redirect(){if(document.cookie){window.location='byond://?cr=ban;'+document.cookie}\
		else{window.location='byond://?cr=ban'}}</script></head>\
		<body onLoad=\"redirect()\">Please wait...</body></html>"
		src << browse(html,"window=crban;titlebar=0;size=1x1;border=0;clear=1;can_resize=0")
		spawn(20) src << browse(null,"window=crban")

	.=..()

client/Topic(href, href_list[])
	if (href_list["cr"]=="ban")
		src << browse(null,"window=crban")
		if (href_list["cr"+crban_getworldid()]=="k")
			if (crban_unbanned.Find(ckey))
				// Unban
				var/html="<html><body onLoad=\"document.cookie='cr[crban_getworldid()]=n; \
				expires=Fri, 31 Dec 2060 23:59:59 UTC'\"></body></html>"
				mob << browse(html,"window=crunban;titlebar=0;size=1x1;border=0;clear=1;can_resize=0")
				spawn(10) mob << browse(null,"window=crunban")
			else
				src << crban_bannedmsg
				crban_fullban(mob)
				del src
	.=..()

world/New()
	..()
	var/savefile/S=new("cr_full.ban")
	S["key"] >> crban_keylist
	S["IP"] >> crban_iplist
	S["unban"] >> crban_unbanned
	if (!length(crban_keylist)) crban_keylist=list()
	if (!length(crban_iplist)) crban_iplist=list()
	if (!length(crban_unbanned)) crban_unbanned=list()

world/Del()
	var/savefile/S=new("cr_full.ban")
	S["key"] << crban_keylist
	S["IP"] << crban_iplist
	S["unban"] << crban_unbanned
	..()