

#define SMITH_TIME	40

obj/item/metal/MouseDrop(obj/quarry)
	if ( !quarry || !istype(quarry,/obj/Quarry) )
		return ..()

	if ( !canCombo(quarry) )
		return

	var equip = usr:getEquipedItem()
	if ( !equip || !istype(equip,/obj/item/tool/Hammer) )
		return

	if ( usr:isBusy() )
		return

	Smith(usr)

obj/item/metal/proc/Smith(mob/player/smith)
	var datum/metalCraft/MC = GetSelection(smith)

	if ( !MC )
		return

	if ( MC.matsNeeded > 1 )
		if ( !smith.hasItems(type,MC.matsNeeded) )
			gameMessage(smith,"You need [MC.matsNeeded] [src]s to build that.",MESSAGE_SMITHING)
			return
	if ( MC.IronAndSteel && !smith.hasItems(/obj/item/metal/Iron_Bar,MC.matsNeeded) )
		gameMessage(smith,"You also need an iron bar to make that.",MESSAGE_SMITHING)
		return


	smith.Public_message("[smith] starts hammering away at a [src].",MESSAGE_SMITHING)
	smith.setBusy(1)
	sleep(SMITH_TIME)
	if ( !smith )	return
	smith.setBusy(0)
	if ( !src )	return



//	var pSkill = smith.GetSkill(SKILL_SMITHING)

	var iSkill = MC.getSkillLevel(metalType)
	var XP = 10 * MC.matsNeeded * iSkill
/*
	var chance = AdjustChance( 50 + 8 * ( pSkill - iSkill ) )


	if ( prob(chance) )
		var obj/newObj = MC.build(smith.loc,smith)
		newObj.Move(smith)
		gameMessage("You */

	var obj/newObj = MC.build(smith.loc,matName)
	newObj.Move(smith)
	gameMessage(smith,"You forge a [newObj].",MESSAGE_SMITHING)

	if ( istype(MC,/datum/metalCraft/Key_and_Lock) )
		var obj/lock = MC:buildLock(smith.loc,matName)
		lock.Move(smith)


	smith.CheckIQ(IQ_MAKE,newObj)
	smith.GiveXP(SKILL_SMITHING,XP)

	if ( MC.IronAndSteel )
		var obj/item/iron = isItemTypeInList(/obj/item/metal/Iron_Bar,smith.contents)
		del iron

	if ( MC.matsNeeded > 1 )
		destroyOtherOres(MC.matsNeeded-1)

	del src


obj/item/metal/proc/destroyOtherOres(num)
	var count = 0
	for ( var/obj/item/metal/other in loc )
		if ( istype(other,type) && other != src )
			del other
			count++
			if ( count >= num )
				return

/*obj/item/metal/proc/GetType()
	switch (type)
		if ( /obj/item/metal/Iron_Bar )
			return IRON
		if ( /obj/item/metal/Bronze_Bar )
			return BRONZE
		if ( /obj/item/metal/Steel_Bar )
			return STEEL
		if ( /obj/item/metal/Brass_Bar )
			return BRASS
obj/item/metal/proc/getMatName()
	switch (type) */

obj/item/metal/proc/GetSelection(mob/player/smith)
	if ( !smith )
		return

	var list/selectList = new()


	var playerSkill = smith.GetSkill(SKILL_SMITHING)

	for ( var/datum/metalCraft/MC in metalCraftList )
		//world.log << "comparing playerskill [playerSkill] to mcskill  [MC.getSkillLevel(metalType)]"

		if ( ( metalType & MC.materialFlags ) && playerSkill >= MC.getSkillLevel(metalType) )
			selectList += Type2Name(MC.type)

	if ( !selectList.len )
		gameMessage(smith,"You have no idea what to make with [src].",MESSAGE_SMITHING)
		return

	selectList += "Nothing"

	smith.setBusy(1)
	var selection = input(smith,"What do you want to make with [src]","[src]") in selectList
	smith.setBusy(0)

	if ( selection == "Nothing" )
		return

	for ( var/datum/metalCraft/MC in metalCraftList )
		if ( Type2Name(MC.type) == selection )
			return MC

	world.log << "Could not find metalcraft selection item [selection]"

obj/item/tool/var/bonus = 0

obj/item/tool
	Dagger
		bonus = 1
		damage = 5
		icon_state = "Dagger"
		weight = 4
		defense = 6
	Sword
		bonus = 1
		weight = 6
		icon_state = "Sword"
		damage = 10
		defense = 3

	Blade
		bonus = -10
		weight = 35
		icon_state = "Blade"
		damage = 20
		defense = -10
	Shield
		bonus = 1
		weight = 15
		icon_state = "Shield"
		damage = 1
		defense = 10


var/list/metalCraftList

world/proc/InitilizeMetalCrafts()
	metalCraftList = new()
	for ( var/datumType in ( typesof(/datum/metalCraft) - /datum/metalCraft ) )
		metalCraftList += new datumType


datum/metalCraft
	var
		objType
		skillLevel
		materialFlags = IRON
		addBonus = 0
		matsNeeded = 1
		IronAndSteel = 0
		//setIcon = 0

	Nails
		objType = /obj/item/misc/Nails
		skillLevel = 1
	Knife
		objType = /obj/item/tool/Knife
		skillLevel = 1
	Blade
		objType = /obj/item/tool/Blade
		skillLevel = 12
		materialFlags = SILVER | GOLD
		matsNeeded = 8
		addBonus = -2
	Shield
		objType = /obj/item/tool/Shield
		skillLevel = 8
		materialFlags = SILVER | GOLD
		addBonus = 2
		matsNeeded = 4

	Dagger
		objType = /obj/item/tool/Dagger
		skillLevel = 2
		materialFlags = IRON | BRONZE | STEEL | BRASS | TITANIUM | ADAMANTIUM
		addBonus = 1
	Sword
		objType = /obj/item/tool/Sword
		skillLevel = 8
		materialFlags = IRON | BRONZE | STEEL | BRASS | TITANIUM | ADAMANTIUM
		addBonus = 1
		matsNeeded = 2
	Hammer
		objType = /obj/item/tool/Hammer
		skillLevel = 4
		materialFlags = IRON | BRONZE | STEEL | BRASS | TITANIUM | ADAMANTIUM
		addBonus = 1
	Trowel
		objType = /obj/item/tool/Trowel
		skillLevel = 4
		materialFlags = IRON | BRONZE | STEEL | BRASS | TITANIUM | ADAMANTIUM
		addBonus = 1
	Pickaxe
		objType = /obj/item/tool/Pickaxe
		skillLevel = 6
		materialFlags = IRON | BRONZE | STEEL | BRASS | TITANIUM | ADAMANTIUM
		addBonus = 1
		matsNeeded = 2

	Blowpipe
		objType = /obj/item/tool/Blow_Pipe
		skillLevel = 2
		materialFlags = STEEL | BRASS | SILVER | GOLD
		IronAndSteel = 1
	Tongs
		objType = /obj/item/tool/Tongs
		skillLevel = 1
		materialFlags = STEEL | BRASS | SILVER | GOLD
	Axe
		objType = /obj/item/tool/Axe
		skillLevel = 3
		materialFlags = IRON | BRONZE | STEEL | BRASS | TITANIUM | ADAMANTIUM
		addBonus = 1
		matsNeeded = 2
	Hook
		objType = /obj/item/misc/Hook
		skillLevel = 1
		materialFlags = STEEL | SILVER | GOLD
	Anvil
		objType = /obj/Quarry/Anvil
		skillLevel = 6
		materialFlags = STEEL
		matsNeeded = 5

	Key_and_Lock
		objType = /obj/item/misc/Key
		skillLevel = 4
		materialFlags = STEEL
		var
			lockCombo

		proc/buildLock(location,material)
			var  /obj/item/misc/Lock/lock = new(location)

			lock.name = "[material] [lock.name]"
			lock.lockNum = lockCombo

			return lock


		build(location,material)
			var obj/item/misc/Key/key = ..()

			lockCombo = getRandomCombo()

			key.lockNum = lockCombo

			return key

		proc/getRandomCombo()
			var num
			var i
			for ( i=1,i<=5,i++ )
				num += "[rand(1,9)]"

			return num

	proc
		getSkillLevel(material)
			switch ( material )
				if ( IRON )
					return skillLevel
				if ( BRONZE )
					return skillLevel + 1
				if ( STEEL )
					return skillLevel + 2
				if ( BRASS )
					return skillLevel + 3
				if ( SILVER )
					return skillLevel + 2
				if ( GOLD )
					return skillLevel + 4
				if ( TITANIUM )
					return skillLevel + 5
				if ( ADAMANTIUM )
					return skillLevel + 8


		build(location,material)
			var obj/item/newObj = new objType(location)

			newObj.name = "[material] [newObj.name]"

			if ( addBonus && istype(newObj,/obj/item/tool ) )
				switch ( material )
					if ( "Iron" )
						newObj.weight--
					if ( "Bronze" )
						newObj:bonus += 1
					if ( "Steel" )
						newObj:bonus += 2
						newObj.weight--
					if ( "Brass" )
						newObj:bonus += 3
						newObj.weight--
					if ( "Titanium" )
						newObj:bonus += 2
						newObj.weight -= 3
					if ( "Adamantium" )
						newObj:bonus += 5
						newObj.weight += 8
					if ( "Gold" )
						newObj:bonus += 2
						newObj.weight += 4
					if ( "Silver" )
						newObj:bonus += 1
						newObj.weight += 2

			return newObj

			//if ( setIcon )
			//	newObj.setIcon(material)


obj/item/metal
	icon = 'temp_metal.dmi'
	var
		matName
		metalType
	Iron_Bar
		icon_state = "iron"
		matName = "Iron"
		metalType = IRON
	Bronze_Bar
		icon_state = "bronze"
		matName = "Bronze"
		metalType = BRONZE

	Steel_Bar
		icon_state = "steel"
		matName = "Steel"
		metalType = STEEL
	Brass_Bar
		icon_state = "brass"
		matName = "Brass"
		metalType = BRASS
	Titanium_Bar
		icon_state = "titanium"
		matName = "Titanium"
		metalType = TITANIUM
	Adamantium_Bar
		icon_state = "adamantium"
		matName = "Adamantium"
		metalType = ADAMANTIUM
	Silver_Bar
		icon_state = "silver"
		matName = "Silver"
		metalType = SILVER
	Gold_Bar
		icon_state = "gold"
		matName = "Gold"
		metalType = GOLD
