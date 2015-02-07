#define SKILL_XP_LEVEL_2	  100
#define SKILL_XP_LEVEL_3	  250
#define SKILL_XP_LEVEL_4	  500
#define SKILL_XP_LEVEL_5	 1000
#define SKILL_XP_LEVEL_6	 1750
#define SKILL_XP_LEVEL_7	 3000
#define SKILL_XP_LEVEL_8	 5000
#define SKILL_XP_LEVEL_9	 7500
#define SKILL_XP_LEVEL_10	10000
#define SKILL_XP_LEVEL_11	13000
#define SKILL_XP_LEVEL_12	16000
#define SKILL_XP_LEVEL_13	20000
#define SKILL_XP_LEVEL_14	24000
#define SKILL_XP_LEVEL_15	28000
#define SKILL_XP_LEVEL_16	33000
#define SKILL_XP_LEVEL_17	38000
#define SKILL_XP_LEVEL_18	44000
#define SKILL_XP_LEVEL_19	50000
#define SKILL_XP_LEVEL_20	58000



mob/player
	verb
		check()
			usr << "You need [checkXP(XP_Building)] Building XP to level."
			usr << "You need [checkXP(XP_Crafting)] Crafting XP to level."
			usr << "You need [checkXP(XP_Smithing)] Smithing XP to level."
			usr << "You need [checkXP(XP_Mining)] Mining XP to level."
			usr << "You need [checkXP(XP_Farming)] Farming XP to level."
			usr << "You need [checkXP(XP_Alchemy)] Alchemy XP to level."
			usr << "You need [checkXP(XP_Fishing)] Fishing XP to level."
			usr << "You need [checkXP(XP_Swimming)] Swimming XP to level."
			usr << "You need [checkXP(XP_Lumberjack)] Lumberjack XP to level."
			usr << "You need [checkXP(XP_Cooking)] Cooking XP to level."
			usr << "You need [checkXP(XP_Combat)] Combat XP to level."
	proc

		checkXP(PX)
			var hold
			hold = (checkSkillLevel(PX) - PX)
			return hold

		checkSkillLevel(XP)
			if ( XP < SKILL_XP_LEVEL_2 )
				return 100
			if ( XP < SKILL_XP_LEVEL_3 )
				return 250
			if ( XP < SKILL_XP_LEVEL_4 )
				return 500
			if ( XP < SKILL_XP_LEVEL_5 )
				return 1000
			if ( XP < SKILL_XP_LEVEL_6 )
				return 1750
			if ( XP < SKILL_XP_LEVEL_7 )
				return 3000
			if ( XP < SKILL_XP_LEVEL_8 )
				return 5000
			if ( XP < SKILL_XP_LEVEL_9 )
				return 7500
			if ( XP < SKILL_XP_LEVEL_10 )
				return 10000
			if ( XP < SKILL_XP_LEVEL_11 )
				return 13000
			if ( XP < SKILL_XP_LEVEL_12 )
				return 16000
			if ( XP < SKILL_XP_LEVEL_13 )
				return 20000
			if ( XP < SKILL_XP_LEVEL_14 )
				return 24000
			if ( XP < SKILL_XP_LEVEL_15 )
				return 28000
			if ( XP < SKILL_XP_LEVEL_16 )
				return 33000
			if ( XP < SKILL_XP_LEVEL_17 )
				return 38000
			if ( XP < SKILL_XP_LEVEL_18 )
				return 44000
			if ( XP < SKILL_XP_LEVEL_19 )
				return 50000
			if ( XP < SKILL_XP_LEVEL_20 )
				return 58000

			return 0