#define MAX_STOMACH 15
#define MAX_WATER 15

#define THIRST_DAMAGE 5
#define HUNGER_DAMAGE 4

#define HUNGER_RATE 3
#define THIRST_RATE 2


#define RESPAWN_TIME 150


//mob/player/verb/suicide()
//	Hurt(100,"commits suicide.")
mob/var/health
mob/player
	health = 100
	var

		stomach = MAX_STOMACH
		water = MAX_WATER
		hunger = 0
		thirst = 0
		rx
		ry
		tmp/isSleeping

	proc
		HourTick()
			saveGame()
			RunEffect()

			if ( isSleeping )
				return

			if ( health <= 0 )
				return

			if ( health < 100 )
				health ++
				winset(src,"HP","value=[health]")

			hunger++

			if ( hunger >= HUNGER_RATE )
				hunger = 0
				stomach--
				if ( stomach < 0 )
					stomach = 0
				gameMessage(src,"You are hungrier",MESSAGE_HUNGER)

			thirst++
			if ( thirst >= THIRST_RATE )
				thirst = 0
				water--
				if ( water < 0 )
					water = 0
				gameMessage(src,"You are thirstier",MESSAGE_THIRST)

			if ( !stomach )
				gameMessage(src,"You are starving!",MESSAGE_HUNGER)
				src:Hurt(HUNGER_DAMAGE,"dies of hunger!")
			if ( !water )
				gameMessage(src,"You are dehydrating!",MESSAGE_THIRST)
				src:Hurt(THIRST_DAMAGE,"dies of thirst!")




		addStomach(amount)
			stomach += amount
			if ( stomach > MAX_STOMACH )
				stomach = MAX_STOMACH
		addWater(amount)
			water += amount
			if ( water > MAX_WATER )
				water = MAX_WATER
		isFoodFull()
			return ( stomach >= MAX_STOMACH )
		isWaterFull()
			return ( water >= MAX_WATER )

		HealthStat()
			statpanel("Status","Health",health)
			statpanel("Status","Hunger",getHungerStatus())
			statpanel("Status","Thirst",getThirstStatus())
			statpanel("Status","--------")
			statpanel("Status","Intelligence","[GetIQName()] ([GetIQ()]%)")
			statpanel("Status","Defense","[defense]")
			statpanel("Status","Location","([x],[y])")
			statpanel("Status","Memory Loc.","([rx],[ry])")
			if ( tribeName )
				statpanel("Status","Tribe",tribeName)

		Hurt(HP,message)
			health -= HP
			winset(src,"HP","value=[health]")
			if ( health <= 0 )
				Die(message)

		Die(message,noMessage = 0)
			setBusy(1)
			if ( !message )
				message = " dies!"
			if ( !noMessage )
				//Public_message()
				world << "<B><font color=red>[src] [message]"
			icon_state = "dead"

			density = 0
			Effect_Duration = 0
			Effect_Type = 0

			equipped = null
			for ( var/obj/item/item in contents )
				item.Move(loc)

				if ( istype(item,/obj/item/tool) )
					item.suffix = null

			spawn(30)
				src << "You will respawn in [RESPAWN_TIME/10] seconds."

			spawn(RESPAWN_TIME)
				respawn()


		respawn()
			if ( health > 0 )
				return

			density = 1
			icon_state = null
			gameMessage(usr,"You have respawned.")
			setBusy(0)



			health = 100
			winset(src,"HP","value=[health]")
			stomach = MAX_STOMACH
			water = MAX_WATER




			var obj/spawnPoint = GetRandomSpawnPoint()


			loc = spawnPoint.loc


		getHungerStatus()
			var percent = 100 * stomach / MAX_STOMACH
			if ( percent <= 0 )
				return "Starving"
			if ( percent < 25 )
				return "Very Hungry"
			if ( percent < 50 )
				return "Hungry"
			if ( percent < 75 )
				return "Slightly Hungry"
			if ( percent < 100 )
				return "Not Hungry"
			return "Bloated"

		getThirstStatus()
			var percent = 100 * water / MAX_WATER
			if ( percent <= 0 )
				return "Dehydrated"
			if ( percent < 25 )
				return "Very Thirsty"
			if ( percent < 50 )
				return "Thirsty"
			if ( percent < 75 )
				return "Slightly Thirsty"
			if ( percent < 100 )
				return "Not Thirsty"
			return "Full"

		checkSleep()
			usr.sight &= ~BLIND
			if ( icon_state == "sleep" )
				icon_state = null
			density = 1

	verb
		Sleep()
			if ( isBusy() )
				return

			if ( isSleeping )
				usr << "You're already asleep!"
				verbs -= /mob/player/verb/Sleep
				return

			if ( istype(loc,/turf/Water) )
				usr << "You can't sleep in the water."
				return

			density = 0
			verbs += /mob/player/verb/Awaken
			verbs -= /mob/player/verb/Sleep
			icon_state = "sleep"
			isSleeping = 1
			setBusy(1)
			Public_message("[src] goes to sleep.")
			usr.sight |= BLIND

		Remember()
			rx = x
			ry = y
			usr << "You remember the coordinates you are at!"


		Awaken()

			if ( !isSleeping )
				usr << "You're not asleep!"
				verbs -= /mob/player/verb/Awaken
				return
			isSleeping = 0


			density = 1
			verbs += /mob/player/verb/Sleep
			verbs -= /mob/player/verb/Awaken

			icon_state = null

			setBusy(0)
			usr.sight &= ~BLIND

			Public_message("[src] wakes up.")