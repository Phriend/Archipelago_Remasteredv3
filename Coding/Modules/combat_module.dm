#define COMBAT_SWING_TIME	9
mob/var/tmp/isAttacking

obj/item/tool
	var
		damage = 5


mob/var/tmp/defense = 1
mob/player/DblClick()
	if ( usr == src )
		return ..()



	if ( get_dist(usr,src) > 1 )
		return ..()
	if ( usr:isBusy() )
		return ..()
	if(usr.isAttacking)
		return ..()
	if ( src:health <= 0 )
		return ..()

	if ( usr:isInSameTribe(name) )
		return ..()

	var obj/item/tool/equip = usr:getEquipedItem()

	var weaponName
	var damage
	if ( equip )
		weaponName = equip.name
		damage = equip.damage
	else
		weaponName = "fist"
		damage = 3


	var skill = usr:GetSkill(SKILL_COMBAT)
	var targetSkill = src:GetSkill(SKILL_COMBAT)

	damage += round(skill/3)
	damage -= (src.defense + round(targetSkill/3))

	if(damage <= 0)
		usr<<"Your attack did nothing!"
		src<<"[usr] failed to harm you!"
		return
	usr.Public_message("<b>[usr] swings \his [weaponName] at [src]!",MESSAGE_COMBAT)
	usr.isAttacking = 1
	sleep(10)
	usr.isAttacking = 0
	if ( !src )
		return
	if ( !usr )
		return

	var chance = 20 + 10 * skill

	chance -= targetSkill * 3
	chance = AdjustChance(chance)

	if ( prob(chance) )
		usr.Public_message("<b>[usr] hits [src] with \his [weaponName]!",MESSAGE_COMBAT)

		usr:GiveXP(SKILL_COMBAT,5)
		src:GiveXP(SKILL_COMBAT,1)

		src:Hurt(damage,"has been struck down by [usr]")
	else
		usr.Public_message("<b>[usr] misses [src]!",MESSAGE_COMBAT)

		usr:GiveXP(SKILL_COMBAT,5 * FAILURE_XP_BOOST)
		src:GiveXP(SKILL_COMBAT,3)

