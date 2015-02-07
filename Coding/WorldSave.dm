obj
	var                   //These vars define the terms so they
		saved_x           //are recognized.
		saved_y
		saved_z

world/proc
	SaveObjects()                            //This is the Save proc.
		world<<"<font color=Green>Saving objects.</font>"
		var/savefile/F = new ("objects.sav") //creates the save file
		var/list/L = new
		for(var/obj/O in world)
			if(istype(O,/obj/plant) || istype(O,/obj/item) || istype(O,/obj/building))
				O.saved_x = O.x //these tell the game to save the objects
				O.saved_y = O.y //location.
				O.saved_z = O.z
				L += O
		F[""] << L
		world<<"<font color=Green>Saving complete.</font>"

world/proc/LoadObjects()                         //Its time to load the objs!
	world<<"<font color=Blue>Loading</font>"
	sleep(10)
	if ( !hasfile("objects.sav") )
		world.log << "No world save file."
		return
	var/savefile/F = new ("objects.sav")
	world<<"<font color=Blue>Loading</font>"
	sleep(10)
	var/list/L = new
	world<<"<font color=Blue>Loading</font>"
	sleep(10)
	F[""] >> L
	world<<"<font color=Blue>Loading</font>"
	sleep(10)
	if(!L) return
	world<<"<font color=Blue>Loading</font>"
	sleep(10)
//	for(var/obj/O in world) if(O.loc) del(O)
	world<<"<font color=Blue>Loading</font>"
	sleep(10)
	for(var/obj/O in L)
		O.loc = locate(O.saved_x,O.saved_y,O.saved_z) //loads the obj
	world<<"<font color=Blue>Loading Complete</font>."

mob/God/verb/Save() //the save verb
	set category = "MAP VERBS"
	world.SaveObjects()


mob/God/verb/Load() //the load verb
	set category = "MAP VERBS"
	world.LoadObjects()


var/global/host
var/global/ishost
mob/var/host


