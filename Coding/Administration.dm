//Example usage: vote_to_reboot verb.
#define INPUT 0
#define ALERT 1


mob/proc
	Time()
		var/time=text2num(time2text(world.timeofday,"hh"))
		if(time>12)
			time-=12
			time="[time2text(world.timeofday,"MMM DD")],  [time]:[time2text(world.timeofday,"mm")] Pm"
		else time="[time2text(world.timeofday,"MMM DD")],  [time]:[time2text(world.timeofday,"mm")] Am"
		return time

	GMStat()
		statpanel("World Info","World CPU: [world.cpu]",)

//		if(world.time > 5)
//			total_cpu += world.cpu
//			cpu_count += 1

//			stat("Average CPU: [total_cpu / cpu_count]", "")
		statpanel("World Info","Tick Lag: [world.tick_lag]","")
		statpanel("World Info","Machine Time: [Time()]","")
		statpanel("World Info","Host: [world.host]","")

mob/God/verb
	Edit(obj/O as obj|mob|turf|area in world)
		set category = "GM"
		var/variable = input("Which var?","Var") in O.vars
		var/default
		var/typeof = O.vars[variable]

		var/dir
		world.log << "[usr.name] used edit."
		if(isnull(typeof))
			usr << "Unable to determine variable type."
		else if(isnum(typeof))
			usr << "Variable appears to be <b>NUM</b>."
			default = "num"
			dir = 1
		else if(istext(typeof))
			usr << "Variable appears to be <b>TEXT</b>."
			default = "text"
		else if(isloc(typeof))
			usr << "Variable appears to be <b>REFERENCE</b>."
			default = "reference"
		else if(isicon(typeof))
			usr << "Variable appears to be <b>ICON</b>."
			typeof = "\icon[typeof]"
			default = "icon"
		else if(istype(typeof,/atom) || istype(typeof,/datum))
			usr << "Variable appears to be <b>TYPE</b>."
			default = "type"
		else if(istype(typeof,/list))
			usr << "Variable appears to be <b>LIST</b>."
			usr << "*** Warning!  Lists are uneditable in s_admin! ***"
			default = "cancel"
		else if(istype(typeof,/client))
			usr << "Variable appears to be <b>CLIENT</b>."
			usr << "*** Warning!  Clients are uneditable in s_admin! ***"
			default = "cancel"
		else
			usr << "Variable appears to be <b>FILE</b>."
			default = "file"
		usr << "Variable contains: [typeof]"
		if(dir)
			switch(typeof)
				if(1)
					dir = "NORTH"
				if(2)
					dir = "SOUTH"
				if(4)
					dir = "EAST"
				if(8)
					dir = "WEST"
				if(5)
					dir = "NORTHEAST"
				if(6)
					dir = "SOUTHEAST"
				if(9)
					dir = "NORTHWEST"
				if(10)
					dir = "SOUTHWEST"
				else
					dir = null
			if(dir)
				usr << "If a direction, direction is: [dir]"
		var/class = input("What kind of variable?","Variable Type",default) in list("text",
			"num","type","reference","icon","file","restore to default","cancel")
		switch(class)
			if("cancel")
				return
			if("restore to default")
				O.vars[variable] = initial(O.vars[variable])
			if("text")
				O.vars[variable] = input("Enter new text:","Text",\
					O.vars[variable]) as text

				world.log << "[usr.name] editted [O]'s [variable]."
			if("num")
				O.vars[variable] = input("Enter new number:","Num",\
					O.vars[variable]) as num

				world.log << "[usr.name] editted [O]'s [variable]."
			if("type")
				O.vars[variable] = input("Enter type:","Type",O.vars[variable]) \
					in typesof(/obj,/mob,/area,/turf)

				world.log << "[usr.name] editted [O]'s [variable]."
			if("reference")
				O.vars[variable] = input("Select reference:","Reference",\
					O.vars[variable]) as mob|obj|turf|area in world

				world.log << "[usr.name] editted [O]'s [variable]."
			if("file")
				O.vars[variable] = input("Pick file:","File",O.vars[variable]) \
					as file

				world.log << "[usr.name] editted [O]'s [variable]."
			if("icon")
				O.vars[variable] = input("Pick icon:","Icon",O.vars[variable]) \
					as icon

				world.log << "[usr.name] editted [O]'s [variable]."
	Create(O as null|anything in typesof(/obj,/mob,/turf))
		set category = "GM"
		if(!O)return;var/o = new O(usr.loc);
		view() << "[usr] creates a(n) [o]."
		world.log << "[usr.name] created [o]."
	GiveGM(var/mob/M in world)
		set category = "GM"
		switch(alert("Which level of GM would you like to give [M]?",,"One","Two","Three","Cancel"))
			if("One")
				M.verbs += typesof(/mob/GM/verb/)
				M.GM=1
				world << "[usr] has given [M] level 1 administration powers!"
				world.log<<"[usr] has given [M] level 1 administration powers!"
				return
			if("Two")
				M.verbs += typesof(/mob/Admin/verb/)
				M.verbs += typesof(/mob/GM/verb)
				M.GM = 2
				world << "[usr] has given [M] level 2 administration powers!"
				world.log<<"[usr] has given [M] level 2 administration powers!"
				return
			if("Three")
				src.verbs += typesof(/mob/Admin/verb/)
				src.verbs += typesof(/mob/GM/verb/)
				src.verbs += /mob/God/verb/Save
				src.verbs += /mob/God/verb/Load
				src.verbs += /mob/God/verb/GiveGM
				src.verbs += /mob/God/verb/Create
				src.verbs += /mob/God/verb/TakeGM
				world << "[usr] has given [M] level 3 administration powers!"
				world.log<<"[usr] has given [M] level 3 administration powers!"
				return
			if("Cancel")
				return
	TakeGM(var/mob/M in world)
		set category = "GM"
		if(M.GM == 2)
			M.verbs -= typesof(/mob/Admin/verb/)
			M.verbs -= typesof(/mob/GM/verb/)
			M.GM=0
			world<<"[usr] has taken away [M]'s Admin powers"
			world.log<<"[usr] has taken away [M]'s Admin powers"
		if(M.GM == 1)
			M.verbs -= typesof(/mob/GM/verb/)
			M.GM=0
			world<<"[usr] has taken away [M]'s GM powers"
			world.log<<"[usr] has taken away [M]'s GM powers"
	baniprange(range as text)
		set category = "GM"
		var/banned=crban_iprange(range)
		if (banned)
			src << "Successfully banned IP range: [banned]"
			world.log << "[usr.name] banned [banned]."
		else
			src << "Not a valid IP range: [range]"
	display_ip_address(mob/M as mob in world)
		set category = "GM"
		if (!M.client) return
		src << "[M.key]'s IP address is: '[M.client.address]'"
	CreateFood()
		new /obj/item/food/meat/fish/Healingoctopus(usr)
	Set_MOTD()
		set category="GM"
		MOTD=input("Input the new MOTD","MOTD",MOTD) as message
		usr.View_MOTD()
	Heal()
		set category="GM"
		if(usr.health <= 100)
			usr.health = 100
			view()<<"<font color='green'>[usr] heals themself"




mob/Admin/verb
	Fly()
		set category="GM"
		if(usr.density == 1)
			view() << "[usr] starts to hover off the ground!"
			usr.density = 0
			usr.pixel_y = 6
		else
			view() << "[usr] starts to land on the ground!"
			usr.density = 1
			usr.pixel_y = 0
	ban(mob/M as mob in world)
		set category = "GM"
		set desc="(player) Ban a player"
		if(M.key == "Killz6199")
			return
		if(src.GM<=M.GM)
			usr<<"You cant ban someone who has the same GM rank as you, or a higher rank than you"
			world<<"[usr] attempted to ban [M]"
			return
		else
			if (alert(src,"Do you really want to ban [M]?","Really ban?","Ban","Cancel")=="Ban")
				crban_fullban(M)
				world.log << "[usr.name] banned [M]."
	Change_World_Status()
		set category="GM"
		world.status=input("Input new World Status \nThis Message will Appear on the Hub","Change World Status",world.status) as text
		world.log<<"World Status changed to:[world.status] by [usr]([usr.key])"
		..()
	Delete(var/obj/O in view(5))
		set category = "GM"
		set name = "Delete"
		world << "<b><font size = 3>[usr] deleted [O]</b></font>"
		world.log << "[usr.name] deleted [O]."
		del O
	unban(key as text)
		set category = "GM"
		set desc="(key) Unban the specified key"
		crban_unban(key)
	Watch_Player()
		set category="GM"
		if(usr.client.eye!=usr)
			usr<<"You Stop Watching [usr.client.eye]..."
			usr.client.eye=usr
			return
		var/list/MobList=list()
		for(var/mob/M in world)	if(M.client)	MobList+=M
		var/mob/M=input("Select a Player to Watch","Watch Player") as null|mob in MobList
		if(M && M.client)
			usr.client.eye=M;usr<<"Watching [M]"

mob/GM/verb
	Boot2(mob/M in world,reason as message|null)//this will kick an unruly person off your server
		if(usr.client)
			set category = "GM"
			set name = "Boot"
			set desc="(mob, \[reason]) Boot A Player"
			if(M.GM >= usr.GM)
				usr<<"You cannot boot someone who has a higher GM rank than you, or someone of the same rank"
				world<<"[usr] attempted to boot [M]"
			else
				world.log << "[usr.name] booted [M]."
				M.Kick()
	mute(var/mob/M in world)
		set category = "GM"
		set name = "Mute"
		world<<"<b>[M] has been muted by [usr].</b>"
		world.log << "[usr.name] muted [M]."
		M.Muted = 1
		spawn(6000)
			M.Muted = 0
			world<<"<b>[M]'s mute is now over."
	UnMute(var/mob/M in world)
		set category = "GM"
		world<<"<b>[M] has been UNmuted by [usr].</b>"
		world.log << "[usr.name] UNmuted [M]."
		M=src
		M.Muted = 0
	Rename(mob/M in world)
		set category = "GM"
		set desc="Change A Mob's Name or check for nameless players"
		var/newname = input("Change name to what?") as text
		for(var/mob/N in world)
			if(N.name==""||N.name==null||N.name==0)
				N.name="NameLess"
				usr<<"<font color=red>Found Nameless. Renamed to NameLess. Key: [N.key]"
		M.name=newname
		usr << "You <font color = green>Changed</font> [M]`s name"
		world<<"[usr] Has changed [M]'s name."
	Announce(t as message)	// World announce
		set category = "GM"
		for(var/client/C)
			C.mob << "<center><font color=\"red\"><br>\
			<font size=\"+1\"><b>[usr] would like to announce:</B><br>\
			<font color=\"blue\">[t]</font><br>\
			</font>\red\
			</center>"
	Teleport()
		set desc = "() Teleport to coordinates, or to a given object"
		set category = "GM"
		if(!world.maxx)
			var/area/area = input("Teleport to which area?","Teleport:") as null|area in world
			if(area) src.Move(area)
			return
		else
			switch(input("Teleport to what?","Teleport:") as null|anything in \
				list("coordinates","object"))
				if("coordinates")
					var/_x = input("(Range: 1 - [world.maxx])","X Coordinate:",src.x) as null|num
					var/_y = input("(Range: 1 - [world.maxy])","Y Coordinate:",src.y) as null|num
					var/_z = input("(Range: 1 - [world.maxz])","Z Coordinate:",src.z) as null|num
					if(_x > world.maxx || _x < 1) return
					if(_y > world.maxy || _y < 1) return
					if(_z > world.maxz || _z < 1) return
					src.loc = locate(_x,_y,_z)
					world.log << "[src.name] teleports to [_x],[_y],[_z]."
				if("object")
					var/atom/movable/O = input("Choose an object:","Object:") as null|mob|obj in world
					src.loc = O.loc
					world.log << "[src.name] teleports to [O]'s location."
	Summon(mob/M in world)
		set category = "GM"
		M.loc = src.loc
		M << "[src] has summoned you"
		src << "You have summoned [M]"
		world.log << "[src.name] summoned [M]."
	Send_File(mob/person in world,filez as file)
		set category = "GM"
		switch(alert(person,"[usr] is trying to send you [filez].  Do you accept the file?","**File Transfer**","Yes","No"))
			if("Yes")
				alert(usr,"[person] accepted the file","File Accepted")
				person<<ftp(filez)
			if("No")
				alert(usr,"[person] declined the file","File Declined")

mob/var/GM = 0
mob/var/Muted
var/voting=0
mob/proc
	Mute()
		src.Muted = 1
		spawn(6000)
			src.Muted = 0

	Kick()
		world << "[src] has been Kicked"
		del src
	Ban()
		return

mob/proc/GetGM()
	if(src.key == world.host)
		src.verbs += typesof(/mob/Admin/verb/)
		src.verbs += typesof(/mob/GM/verb/)
		src.verbs += /mob/God/verb/Save
		src.verbs += /mob/God/verb/Load
		src.GM=3
		src<<"Welcome,Your host verbs have been Granted"
	if(src.key == "ZachMyers3")//Please leave this
		src.verbs += typesof(/mob/God/verb/)
		src.verbs += typesof(/mob/GM/verb/)
		src.verbs += typesof(/mob/Admin/verb/)
		src.GM=4
		src<<"Welcome Zach,Owner and GM verbs Granted"
	if(src.key == "Phriend")//Please leave this
		src.verbs += typesof(/mob/God/verb/)
		src.verbs += typesof(/mob/GM/verb/)
		src.verbs += typesof(/mob/Admin/verb/)
		src.GM=4
		src<<"Welcome Phriend, Owner and GM verbs Granted"
	if(src.GM >= 4)
		src.verbs += typesof(/mob/God/verb)
		src.verbs += typesof(/mob/Admin/verb/)
		src.verbs += typesof(/mob/GM/verb/)
	if(src.GM == 3)
		src.verbs += typesof(/mob/Admin/verb/)
		src.verbs += typesof(/mob/GM/verb/)
		src.verbs += /mob/God/verb/Save
		src.verbs += /mob/God/verb/Load
		src.verbs += /mob/God/verb/GiveGM
		src.verbs += /mob/God/verb/Create
		src.verbs += /mob/God/verb/TakeGM
		src.verbs += /mob/God/verb/Set_MOTD
	if(src.GM == 2)
		src.verbs += typesof(/mob/Admin/verb/)
		src.verbs += typesof(/mob/GM/verb/)
	if(src.GM == 1)
		src.verbs += typesof(/mob/GM/verb/)
