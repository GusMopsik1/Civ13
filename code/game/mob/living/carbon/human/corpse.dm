/mob/living/human/corpse
	icon = 'icons/mob/human.dmi'
	icon_state = "corpse_map_state"

/mob/living/human/corpse/New()
	..()
	death()

/mob/living/human/corpse/pirate
	gender = MALE

/mob/living/human/corpse/pirate/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Pirate")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Pirate"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()
////////////////////SPANISH/////////////////////////////////////
/mob/living/human/corpse/spanish
	gender = MALE

/mob/living/human/corpse/spanish/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Marinero")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Marinero"
		s_tone = rand(-65,-75)
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/spanish_cpt
	gender = MALE

/mob/living/human/corpse/spanish_cpt/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Capitan")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Capitan"
		s_tone = rand(-65,-75)
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/spanish_lt
	gender = MALE

/mob/living/human/corpse/spanish_lt/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Contramaestre")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Contramaestre"
		s_tone = rand(-65,-75)
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/spanish_sgt
	gender = MALE

/mob/living/human/corpse/spanish_sgt/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Guardiamarina")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Guardiamarina"
		s_tone = rand(-65,-75)
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/spanish_soldier
	gender = MALE

/mob/living/human/corpse/spanish_soldier/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Military Soldado")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Soldado"
		s_tone = rand(-65,-75)
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/spanish_rifleman
	gender = MALE

/mob/living/human/corpse/spanish_rifleman/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Rifle Soldado")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Rifleman"
		s_tone = rand(-65,-75)
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()
////////////////////////////////////////////////////////////////
mob/living/human/corpse/british_sailor
	gender = MALE

/mob/living/human/corpse/british_sailor/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Royal Navy Seaman")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		apply_damage(rand(0, 35), BRUTE, "head")
		apply_damage(rand(0, 35), BRUTE, "chest")
		apply_damage(rand(0, 35), BRUTE, "l_leg")
		apply_damage(rand(0, 35), BRUTE, "r_leg")
		apply_damage(rand(0, 35), BRUTE, "l_arm")
		apply_damage(rand(0, 35), BRUTE, "r_arm")
		updatehealth()//.
		name = "Royal Navy Seaman"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/british
	gender = MALE

/mob/living/human/corpse/british/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "British Town Guard")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Redcoat Soldier"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/japanese
	gender = MALE

/mob/living/human/corpse/japanese/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Shiro Nitohei")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Japanese Soldier"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/japanese_ww2
	gender = MALE

/mob/living/human/corpse/japanese_ww2/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Nitohei")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Japanese Soldier"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/japanese_ww2_antitank
	gender = MALE

/mob/living/human/corpse/japanese_ww2_antitank/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Nitohei Taisen-sha")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Japanese Soldier"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/ww2_jap_sl
	gender = MALE

/mob/living/human/corpse/ww2_jap_sl/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "IJA Gunso")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Japanese Sergeant"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/ww2_jap_medic
	gender = MALE

/mob/living/human/corpse/ww2_jap_medic/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Sento-i")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Japanese Medic"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/ww2_jap_mg
	gender = MALE

/mob/living/human/corpse/ww2_jap_mg/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Taiho")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Japanese Machinegunner"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/chinese_ww2
	gender = MALE

/mob/living/human/corpse/chinese_ww2/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Erdeng Bing")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Chinese Soldier"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()
/mob/living/human/corpse/russian
	gender = MALE

/mob/living/human/corpse/russian/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Ryadovoy")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Russian Soldier"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/russian_soviet
	gender = MALE

/mob/living/human/corpse/russian_soviet/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "K.A. Soldat")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Russian Soldier"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/russian_soviet_sgt
	gender = MALE

/mob/living/human/corpse/russian_soviet_sgt/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "K.A. Serjant")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Russian Sergeant"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

mob/living/human/corpse/russian_soviet_tanker
	gender = MALE

/mob/living/human/corpse/russian_soviet_tanker/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Tankist")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Russian Tanker"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/russiansgt
	gender = MALE

/mob/living/human/corpse/russiansgt/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Feldvebel")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Russian Sergeant"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/japanesesgt
	gender = MALE

/mob/living/human/corpse/japanesesgt/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Gunso")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Japanese Sergeant"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()


/mob/living/human/corpse/japanesecap
	gender = MALE

/mob/living/human/corpse/japanesecap/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Rikugun-Tai-i")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Japanese Captain"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()


/mob/living/human/corpse/Giant
	gender = MALE

/mob/living/human/corpse/Giant/New()
	..()
	icon_state = "body_m_giant"
	spawn (50) // must be here or they won't spawn, it seems - Kachnov
		death()

/mob/living/human/corpse/prisoner
	gender = MALE

/mob/living/human/corpse/prisoner/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "DO NOT USE")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Escaped Prisoner"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/bandit
	gender = MALE
	h_style = "Fade"

/mob/living/human/corpse/bandit/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Bandit")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(30,45))
		name = "Bandit"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/pmc
	gender = MALE

/mob/living/human/corpse/pmc/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Bandit")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(30,45))
		name = "pmc"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/ww2_american
	gender = MALE

/mob/living/human/corpse/ww2_american/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "US Rifleman")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(30,45))
		name = "American Soldier"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/ww2_american_medic
	gender = MALE

/mob/living/human/corpse/ww2_american_medic/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "US Field Medic")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(30,45))
		name = "American Medic"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/ww2_american_sl
	gender = MALE

/mob/living/human/corpse/ww2_american_sl/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "US Sergeant")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(30,45))
		name = "American Sergeant"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/ww2_american_mg
	gender = MALE

/mob/living/human/corpse/ww2_american_mg/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "US Machine Gunner")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(30,45))
		name = "American Machinegunner"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/beggar
	gender = MALE

/mob/living/human/corpse/beggar/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Beggar")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(30,45))
		name = "Beggar"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/beggar_f
	gender = FEMALE

/mob/living/human/corpse/beggar_f/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Beggar")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(30,45))
		name = "Beggar"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/nva
	gender = MALE

/mob/living/human/corpse/nva/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "NVA Binh Ni")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "NVA soldier"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/merchant
	gender = MALE

/mob/living/human/corpse/merchant/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Merchant")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Merchant"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/colony_civ
	gender = MALE

/mob/living/human/corpse/colony_civ/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Colonist")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Civilian"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/colony_civ_f
	gender = FEMALE

/mob/living/human/corpse/colony_civ_f/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Colonist")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Civilian"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/barmaiden
	gender = FEMALE

/mob/living/human/corpse/barmaiden/New()
	..()
	icon_state = "human_m_s"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Bar Keep/Bar Maiden")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustBruteLoss(rand(6,7))
		name = "Barmaiden"
		invisibility = 0
		spawn (50) // must be here or they won't spawn, it seems - Kachnov
			death()

/mob/living/human/corpse/skelet
	icon = 'icons/russian/mob/human.dmi'
	icon_state = "corpse_map_state"
	start_to_rot = 0

/mob/living/human/corpse/skelet/New()
	..()
	add_language("Skelet Tongue",TRUE)
	icon_state = "skeletman"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
//		job_master.EquipRank(src, "Pirate")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustFireLoss(rand(1000,10000))
		name = species.get_random_english_name(gender)
		invisibility = 0
		skeletman = 1
		spawn (50)
			icon = 'icons/mob/human.dmi'
			body_build = pick(get_body_build(gender,"Skelet"))
			prev_tone = s_tone
			s_tone = null
			update_hair()
			change_facial_hair()
			force_update_limbs()
			update_body(1,1)
			icon = 'icons/mob/human.dmi'
			regenerate_icons()
			death()

/mob/living/human/corpse/skelet/bandit

/mob/living/human/corpse/skelet/bandit/New()
	..()
	add_language("Skelet Tongue",TRUE)
	icon_state = "skeletman"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Bandit")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustFireLoss(rand(1000,10000))
		name = species.get_random_english_name(gender)
		invisibility = 0
		skeletman = 1
		spawn (50)
			icon = 'icons/mob/human.dmi'
			body_build = pick(get_body_build(gender,"Skelet"))
			prev_tone = s_tone
			s_tone = null
			update_hair()
			change_facial_hair()
			force_update_limbs()
			update_body(1,1)
			icon = 'icons/mob/human.dmi'
			regenerate_icons()
			death()

/mob/living/human/corpse/skelet/fbi

/mob/living/human/corpse/skelet/fbi/New()
	..()
	add_language("Skelet Tongue",TRUE)
	icon_state = "skeletman"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "FBI officer")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustFireLoss(rand(1000,10000))
		name = species.get_random_english_name(gender)
		invisibility = 0
		skeletman = 1
		spawn (50)
			icon = 'icons/mob/human.dmi'
			body_build = pick(get_body_build(gender,"Skelet"))
			prev_tone = s_tone
			s_tone = null
			update_hair()
			change_facial_hair()
			force_update_limbs()
			update_body(1,1)
			icon = 'icons/mob/human.dmi'
			regenerate_icons()
			death()

/mob/living/human/corpse/skelet/rifleman

/mob/living/human/corpse/skelet/rifleman/New()
	..()
	add_language("Skelet Tongue",TRUE)
	icon_state = "skeletman"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "USA Rifleman")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustFireLoss(rand(1000,10000))
		name = species.get_random_english_name(gender)
		invisibility = 0
		skeletman = 1
		spawn (50)
			icon = 'icons/mob/human.dmi'
			body_build = pick(get_body_build(gender,"Skelet"))
			prev_tone = s_tone
			s_tone = null
			update_hair()
			change_facial_hair()
			force_update_limbs()
			update_body(1,1)
			icon = 'icons/mob/human.dmi'
			regenerate_icons()
			death()

/mob/living/human/corpse/skelet/prolatariate

/mob/living/human/corpse/skelet/prolatariate/New()
	..()
	add_language("Skelet Tongue",TRUE)
	icon_state = "skeletman"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Prolatariate")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustFireLoss(rand(1000,10000))
		name = species.get_random_english_name(gender)
		invisibility = 0
		skeletman = 1
		spawn (50)
			icon = 'icons/mob/human.dmi'
			body_build = pick(get_body_build(gender,"Skelet"))
			prev_tone = s_tone
			s_tone = null
			update_hair()
			change_facial_hair()
			force_update_limbs()
			update_body(1,1)
			icon = 'icons/mob/human.dmi'
			regenerate_icons()
			death()

/mob/living/human/corpse/skelet/spetznaz

/mob/living/human/corpse/skelet/spetznaz/New()
	..()
	add_language("Skelet Tongue",TRUE)
	icon_state = "skeletman"
	var/spawntime = 0
	invisibility = 101
	if (!job_master)
		spawntime = 5
	spawn (spawntime)
		if (!job_master)
			qdel(src)
			return
		job_master.EquipRank(src, "Spetznaz")
		dir = pick(NORTH,SOUTH,EAST,WEST)
		adjustFireLoss(rand(1000,10000))
		name = species.get_random_english_name(gender)
		invisibility = 0
		skeletman = 1
		spawn (50)
			icon = 'icons/mob/human.dmi'
			body_build = pick(get_body_build(gender,"Skelet"))
			prev_tone = s_tone
			s_tone = null
			update_hair()
			change_facial_hair()
			force_update_limbs()
			update_body(1,1)
			icon = 'icons/mob/human.dmi'
			regenerate_icons()
			death()

