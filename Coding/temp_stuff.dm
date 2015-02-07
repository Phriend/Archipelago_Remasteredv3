
mob
	player
		icon = 'People.dmi'

		var
			tmp/isActing
			obj/item/tool/equipped

		Move()
//			step_size = 32
			if ( health <= 0 )
				setBusy(1)
				return 0

			if ( isActing )
				return 0

			.. ()

/*		verb
			SetDay()
				set category = "Debug"
				island.luminosity = 1
			SetNight()
				set category = "Debug"
				island.luminosity = 0*/


		proc


			isBusy()
				if ( health <= 0 )
					return 1

				return isActing
			setBusy(busy)
				isActing = busy


			getEquipedItem()
				return equipped

