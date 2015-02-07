mob/layer = MY_MOB_LAYER
turf/layer = MY_TURF_LAYER
obj/layer = MY_OBJ_LAYER


world
	name="Archipelago Remastered:Version 3.0"
	status="Archipelago:Version 3.0 Server"
	hub = "GauHelldragon.ArchipelagoRemastered"
	view = 5
	New()
		loading = 0
//		WorldLoad()

		initBIlist()
		InititlizeOreList()
		InitilizeMetalCrafts()
		island = isItemTypeInList(/area/island,world.contents)

		loadTurfs()

		spawn(0)
			TimeLoop()
		spawn(0)
			HourLoop()
		..()

		spawn(10)
			loading = 2

proc
	Type2Name(type)
		var pos = length("[type]")+1
		var char = copytext("[type]",pos-1,pos)
		//world << "Pos = [pos], char = [char]"
		for ( , char != "/" && pos > 2, pos-- )


			char = copytext("[type]",pos-1,pos)
			//world << "Pos = [pos], char = [char]"

		if ( pos <= 2 )
			return "[type]"
		else
			return copytext("[type]",pos+1)


	isItemTypeInList(type,list)
		for ( var/thing in list )
			if ( istype(thing,type) )
				return thing
		return 0


world
	mob = /mob/starter
	area = /area/island
//	turf = /turf/Water


mob/player/verb
	say(message as text)
		if(usr.Muted == 1)
			usr << output("You are muted!","mainwindow.output1")
			return
		if(!(message == ""))
			winset(usr, "input", "command=\"!say \\\"\"")
			view() << output("<font color=blue>[src.name] says : </font>[html_encode(message)]","mainwindow.output1")
	ooc(message as text)
		if(usr.Muted == 1)
			usr << output("You are muted!","mainwindow.output1")
			return
		for ( var/mob/player/PC in world.contents )
			if(!(message == ""))
				winset(usr, "input", "command=\"!ooc \\\"\"")
				PC << output("<font color=red>[src.name] says : </font>[html_encode(message)]","mainwindow.output1")
	who()
		usr << output("People playing right now:","mainwindow.output1")

		var tribeMessage
		for ( var/mob/player/PC in world.contents )
			if ( PC.tribeName )
				tribeMessage = "<font color = red>Tribe : [PC.tribeName] "
			else
				tribeMessage = ""
			src << output("  <B><font color=blue>[PC] [tribeMessage]","mainwindow.output1")
	admin_help(message as text)
		for ( var/mob/player/PC in world.contents )
			if(PC.GM >= 1)
				PC << output("<font color=red><b>ADMIN HELP([src]) : </font>[html_encode(message)]</b>","mainwindow.output1")


/*world/proc/WorldSave()
	world << "<B><font color = green>Saving world..."

	fdel("world.sav")

	var savefile/worldsave = new("world.sav")


	worldsave["/Tribes"] << TribesList


	var list/saveList = new()

	for ( var/obj/thing in contents )
		if ( ShouldSave(thing) )
			saveList += thing

	worldsave["/Things"] << saveList
			//worldsave["/Things/"] << thing

	world << "<B><font color = green>World save complete."*/

world/Del()
//	WorldSave()
//	SaveObjects()
	return ..()


/*world/proc/WorldLoad()
	world.log << "Starting world load..."

	if ( !hasfile("world.sav") )
		world.log << "No world save file."
		return

	var savefile/worldsave = new("world.sav")

	worldsave["/Tribes"] >> TribesList


	var list/thingList
	//while ( !worldsave.eof )
	worldsave["/Things/"] >> thingList



	world.log << "World load complete."*/


world/proc/ShouldSave(obj/thing)
	if ( ismob(thing.loc) )
		return 0


	if ( istype(thing,/obj/Fire) )
		return 1
	if ( istype(thing,/obj/Compost) )
		return 1
	if ( istype(thing,/obj/Plowed_Land) )
		return 1
	if ( istype(thing,/obj/building) )
		return 1
	if ( istype(thing,/obj/item) )
		return 1
	if ( istype(thing,/obj/plant) )
		return 1


	return 0

obj
	Write(savefile/SF)


		var temppointer = mouse_drag_pointer
		if ( istype(src,/obj/item) )
			mouse_drag_pointer = 0

		var ret = ..(SF)
		SF["x"] << x
		SF["y"] << y
		SF["z"] << z
		if ( istype(src,/obj/item) )
			mouse_drag_pointer = temppointer


		return ret


	Read(savefile/SF)
		var
			tempx
			tempy
			tempz

		SF["x"] >> tempx
		SF["y"] >> tempy
		SF["z"] >> tempz

		var ret = ..(SF)

		loc = locate(tempx,tempy,tempz)
		if ( istype(src,/obj/item) )

			if (!mouse_drag_pointer )

				src:LoadPointer()

		return ret

