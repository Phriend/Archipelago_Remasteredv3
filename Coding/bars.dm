client/proc
	adjustHP(v as num)winset(src,"HP","value=[v]")
	adjusthunger(v as num)winset(src,"Hunger","value=[v]")
	adjustthirst(v as num)winset(src,"Thirst","value=[v]")



mob/player/proc/bars()
	spawn(10)
		src.bars2()
mob/player/proc/bars2()

		winset(src,"HP","value=[health]")
		winset(src,"Hunger","value=[stomach*(100/15)]")
		winset(src,"Thirst","value=[water*(100/15)]")
		src.bars()