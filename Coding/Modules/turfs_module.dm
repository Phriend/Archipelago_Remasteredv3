
turf
	icon = 'NewGraphics.dmi'
	Grass
		icon_state = "Grass"
	Sand
		icon = 'turfs.dmi'
		name = "Sand"
		icon_state = "nog"
/*		SandGrass1
			icon_state = "ng"
		SandGrass2
			icon_state = "eg"
		SandGrass3
			icon_state = "neg"
		SandGrass4
			icon_state = "wg"
		SandGrass5
			icon_state = "sg"
		SandGrass6
			icon_state = "seg"
		SandGrass7
			icon_state = "nwg"
		SandGrass8
			icon_state = "swg"
		SandDirt1
			icon = 'things2.dmi'
			icon_state = "sand1"
		SandDirt2
			icon = 'things2.dmi'
			icon_state = "sand2"
		SandDirt3
			icon = 'things2.dmi'
			icon_state = "sand3"
		SandDirt4
			icon = 'things2.dmi'
			icon_state = "sand4"
		SandDirt5
			icon = 'things2.dmi'
			icon_state = "sand5"
		SandDirt6
			icon = 'things2.dmi'
			icon_state = "sand6"
		SandDirt7
			icon = 'things2.dmi'
			icon_state = "sand7"
		SandDirt8
			icon = 'things2.dmi'
			icon_state = "sand8"
*/


	Water
		icon = 'turfs.dmi'
		icon_state = "water"
		WaterFall
			icon_state = "waterfall"

	Shoals
		icon = 'turfs.dmi'
		icon_state= "shoals"
		density = 1

	Dirt
		icon = 'things2.dmi'
		icon_state = "dirt"
		name = "Dirt"
		/*DirtGrass1
			icon_state = "dirt1"
		DirtGrass2
			icon_state = "dirt2"
		DirtGrass3
			icon_state = "dirt3"
		DirtGrass4
			icon_state = "dirt4"
		DirtGrass5
			icon_state = "dirt5"
		DirtGrass6
			icon_state = "dirt6"
		DirtGrass7
			icon_state = "dirt7"
		DirtGrass8
			icon_state = "dirt8"*/


	Cave_Wall
		icon = 'things2.dmi'
		icon_state = "Cave Wall"

		density = 1
		opacity = 1
		indoors = 1

	Cave_Wall2
		icon = 'things2.dmi'
		icon_state = "Cave Wall2"

		density = 1
		opacity = 0
		indoors = 1
	Cave
		icon = 'Things.dmi'
		icon_state = "Dirt"


		indoors = 1

obj
	Spring
		icon = 'NewGraphics.dmi'
		icon_state = "Spring"
		density = 1



obj/turfedge
	mouse_opacity = 0
	layer = MY_TURF_LAYER+1
	icon = 'turfedges.dmi'


turf/proc/addEdges()
	CheckEdge(WEST)
	CheckEdge(NORTH)
	CheckEdge(EAST)
	CheckEdge(SOUTH)
	CheckEdge(NORTHEAST)
	CheckEdge(NORTHWEST)
	CheckEdge(SOUTHEAST)
	CheckEdge(SOUTHWEST)
turf/proc/CheckEdge()

/*
turf/Shoals/CheckEdge(direction)
	var turf/edge = get_step(src,direction)
	if ( !edge || edge == src )
		return
	if ( istype(edge,/turf/Water) || istype(edge,/turf/Shoals) )
		return
	//icon = 'things2.dmi'


	var /obj/turfedge/TE = new(src)
	switch ( direction )
		if ( NORTH )	TE.icon_state = "waves north"
		if ( EAST )		TE.icon_state = "waves east"
		if ( WEST )		TE.icon_state = "waves west"
		if ( SOUTH )	TE.icon_state = "waves south"

*/
turf/Water/CheckEdge(direction)
	var turf/edge = get_step(src,direction)
	if ( !edge || edge == src )
		return
	if ( istype(edge,/turf/Water) || istype(edge,/turf/Shoals) )
		return
	//icon = 'things2.dmi'


	var /obj/turfedge/TE = new(src)
	switch ( direction )
		if ( NORTH )	TE.icon_state = "waves north"
		if ( EAST )		TE.icon_state = "waves east"
		if ( WEST )		TE.icon_state = "waves west"
		if ( SOUTH )	TE.icon_state = "waves south"


/*

turf/Grass/CheckEdge(direction)
	var turf/edge = get_step(src,direction)
	if ( !edge || edge == src )
		return
	if ( istype(edge,/turf/Grass) || edge.density )
		return

	var /obj/turfedge/TE = new(edge)

	switch ( direction )
		if ( NORTH )	TE.icon_state = "grass north"
		if ( EAST )	TE.icon_state = "grass east"
		if ( WEST )	TE.icon_state = "grass west"
		if ( SOUTH )	TE.icon_state = "grass south"
		if ( SOUTHEAST ) TE.icon_state = "Grass SouthEast"
		if ( SOUTHWEST ) TE.icon_state = "Grass SouthWest"
		if ( NORTHEAST ) TE.icon_state = "Grass NorthEast"
		if ( NORTHWEST ) TE.icon_state = "Grass NorthWest"
turf/Dirt/CheckEdge(direction)
	var turf/edge = get_step(src,direction)
	if ( !edge || edge == src )
		return

	if ( istype(edge,type) )
		return
	if ( istype(edge,/turf/Grass) || edge.density  )
		return

	var /obj/turfedge/TE = new(edge)

	switch ( direction )
		if ( NORTH )	TE.icon_state = "dirt north"
		if ( EAST )	TE.icon_state = "dirt east"
		if ( WEST )	TE.icon_state = "dirt west"
		if ( SOUTH )	TE.icon_state = "dirt south"


	TE.layer++

turf/Sand/CheckEdge(direction)
	var turf/edge = get_step(src,direction)
	if ( !edge || edge == src )
		return
	if ( istype(edge,type) )
		return

	if ( istype(edge,/turf/Grass) || edge.density  || istype(edge,/turf/Dirt))
		return

	var /obj/turfedge/TE = new(edge)

	switch ( direction )
		if ( NORTH )	TE.icon_state = "sand north"
		if ( EAST )	TE.icon_state = "sand east"
		if ( WEST )	TE.icon_state = "sand west"
		if ( SOUTH )	TE.icon_state = "sand south"


	TE.layer+=2
	*/


obj
	Trees
		icon = 'temp_tree.dmi'
		density = 1
		opacity = 1
	Tree
		icon = 'temp_tree.dmi'
		density = 1

obj/Quarry
	density = 1
	icon = 'temp_quarry.dmi'

obj/Quarry/Anvil
	icon = 'Anvil.dmi'

	weight = 50
	var/pickedUp
	verb
		Get()
			set src in oview(1)
			if ( usr:isBusy() )
				return
			Move(usr)
			pickedUp = 1
		Drop()
			set src in usr
			if ( usr:isBusy() )
				return
			density = 0
			Move(usr.loc)
			density = initial(density)
			if ( usr:equipped == src )
				usr:equipped = null
				suffix = null