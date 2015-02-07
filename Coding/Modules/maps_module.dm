obj/NoBuildZone
	icon = 'misc.dmi'
	icon_state = "red"
	New()
		icon = null

obj/RandomSpawnPoint/
	icon = 'misc.dmi'
	icon_state = "spawn"
	New()
		icon = null

obj/TitleSpot
	icon = 'misc.dmi'
	icon_state = "spawn"
	New()
		icon = null



turf/Title
	icon = 'title2.dmi'
	name = ""

	setLight()
	setWeather()
	addEdges()
	CheckEnviorment()
	CheckEdge()
	isLit()
	isIndoors()

turf/evilsmile
	icon = 'evilsmile.dmi'
	name = "Rawr"


proc/hasfile(filename)
	return length(file(filename))


proc/GetRandomSpawnPoint()
	var list/spawnPoints = new
	for ( var/obj/RandomSpawnPoint/RSP in world.contents )
		spawnPoints += RSP

	var obj/spawnPoint = pick(spawnPoints)

	return spawnPoint

obj/Button
	icon = 'misc.dmi'
	icon_state = "invis"

	Start_New_Game
		Click()
			if ( !loading )
				usr << "Map still loading, please wait."
				return

			if ( !istype(usr,/mob/starter) || usr:menu )
				return
			if ( hasfile("saves/[usr.key]") )

				usr:menu = 1
				var responce = alert(usr,"You already have a save game.","New Game","Nevermind","Start Over")
				usr:menu = 0
				if ( responce == "Nevermind")
					return


			fdel("saves/[usr.key]")
			if ( !istype(usr,/mob/starter) )
				return
			var obj/spawnPoint = GetRandomSpawnPoint()

			var /mob/player/Player = new /mob/player/(spawnPoint.loc)

			Player.name =  input(usr,"What name would you like your character to be?")

			Player.client = usr.client

			Player.AssignSkills()
			usr << "Welcome to Archipelago Remastered!<br>http://archipelago.ucoz.com/forum/5-24-1 This is the guide, read this before you start asking questions."

	Load
		Click()
			if ( !loading )
				usr << "Map still loading, please wait."
				return

			var client/C = usr.client

			if ( !istype(usr,/mob/starter) || usr:menu )
				usr << "Welcome to Archipelago Remastered!."
				return
			if ( !hasfile("saves/[usr.key]") )
				usr:menu = 1
				alert(usr,"You don't have a save game.","Woops","My bad.")
				usr:menu = 0
				return


			var savefile/SF = new("saves/[C.key]",3)

			var mob/player/NewPlayer = new /mob/player()

			SF >> NewPlayer

			NewPlayer.client = C

mob/player/verb/Get_Me_Out()
	set category = "Debug"
	if(usr.x == 0 || usr.y == 0 || usr.z==0 || usr.x>=300 || usr.y>=300)
//	usr.x = 150
//	usr.y = 150
//	usr.z = 2
		var obj/spawnPoint = GetRandomSpawnPoint()


		loc = spawnPoint.loc

mob/player
	Login()
		..()
		spawn (1)
			world << output("<font color=blue><b>[src] has logged in.","mainwindow.output1")
		MOTD_Display()
		if ( health <= 0 )
			Die("is still dead",1)
			spawn(RESPAWN_TIME)
				respawn()

		src.Name(src.name)

		if(src.equipped)
			src.defense += src:equipped.defense
		src.GetGM()
		src.bars()

	Logout()
		..()
		world << output("<font color=blue><b>[src] has logged out.","mainwindow.output1")
		var ret = ..()
		saveGame()
		del src
		return ret

	proc/saveGame()
		var savefile/SF = new("saves/[key]")
		SF << src




	Write(savefile/SF)
		//world.log << "Saving to [SF]"

		..(SF)
		SF["x"] << x
		SF["y"] << y
		SF["z"] << z

		//world.log << "Saving coords ([x],[y],[z])"

//		var tempz
//		SF["tempz"] >> tempz
//		world.log << "saved Z = [tempz]"


	Read(savefile/SF)
		//world.log << "Loading from  [SF]"
		var
			tempx
			tempy
			tempz

		SF["x"] >> tempx
		SF["y"] >> tempy
		SF["z"] >> tempz

		..(SF)

		//world.log << "Loading coords ([tempx],[tempy],[tempz])"
		loc = locate(tempx,tempy,tempz)

		AssignTribe()
	//verb
/*		DoIHaveSave()
			if ( isfile(key) )
				usr << "[key] I have a savegame."
			else
				usr << "[key] I don't have a savegame." */
/*		SaveGame()
			var savefile/SF = new("saves/[key]")
			SF << src
		CheckSaveData()
			var savefile/SF = new("saves/[key]")

			var/txtfile = file("barf.txt")
			fdel(txtfile)
			SF.ExportText("/",txtfile)
			usr << "Your savefile looks like this:"

			usr << "<xmp>[file2text(txtfile)]</xmp>" */

/*mob/player/verb/saveWorld()
	world.WorldSave()

mob/player/verb/inspectWorldSave()
	var savefile/SF = new("world.sav")

	var/txtfile = file("barf.txt")
	fdel(txtfile)
	SF.ExportText("/",txtfile)
	usr << "Your savefile looks like this:"

	usr << "<xmp>[file2text(txtfile)]</xmp>" */



/*client/verb/ClientInfo()
	if ( mob )
		usr << "mob = [mob]"
		usr << "mobtype = [mob.type]"
		usr << "location = ([mob.x],[mob.y],[mob.z])"

	else
		usr << "No mob" */

mob/starter
	var menu

	Login()
		var turf/spawnPoint = isItemTypeInList(/obj/TitleSpot,world.contents)
		loc = spawnPoint
		return ..()

	Logout()

		var ret = ..()
		del src
		return ret
