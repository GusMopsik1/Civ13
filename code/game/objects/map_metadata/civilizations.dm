/obj/map_metadata/civilizations
	ID = MAP_CIVILIZATIONS
	title = "Two Kingdoms"
	lobby_icon_state = "civ13"
	caribbean_blocking_area_types = list(/area/caribbean/no_mans_land/invisible_wall/)
	respawn_delay = 6000 // 10 minutes!
	has_hunger = TRUE


	faction_organization = list(CIVILIAN,)
	roundend_condition_sides = list(
		list(CIVILIAN) = /area/caribbean/british
		)
	age = "1013"
	no_winner = "The round is proceeding normally."
	civilizations = TRUE
	faction_distribution_coeffs = list(CIVILIAN = 1)
	battle_name = "the kingdoms"
	mission_start_message = "<big>Два замка развиваются для того что бы через <b>12 часов</b> начать взаимодействовать с собой.</big><br><b>Wiki Guide: http://civ13.github.io/civ13-wiki/Civilizations_and_Nomads</b>"
	ambience = list('sound/ambience/jungle1.ogg')
	faction1 = CIVILIAN
	availablefactions_run = TRUE
	songs = list(
		"Words Through the Sky:1" = 'sound/music/words_through_the_sky.ogg',)
	default_research = 48
	gamemode = "Two Kingdoms"
	ordinal_age = 2
	age1_done = TRUE
	age2_done = TRUE
	research_active = FALSE

/obj/map_metadata/civilizations/New()
	var/newnamea = list("West Kingdom" = list(default_research,default_research,default_research,null,0,"saltire","#D4AF37","#660000"))
	var/newnameb = list("East Kingdom" = list(default_research,default_research,default_research,null,0,"saltire","#C0C0C0","#006600"))
	custom_civs += newnamea
	custom_civs += newnameb
	civa_research = list(default_research,default_research,default_research,null)
	civb_research = list(default_research,default_research,default_research,null)
	spawn(1)

	..()
	spawn(18000)
		seasons()

/obj/map_metadata/civilizations/proc/walldown()
	for (var/turf/wall/rockwall/RW)
		RW.ChangeTurf(/turf/floor/dirt/jungledirt)
	world << "<font color=#CECE00><big><b>ВЕЛИКАЯ СТЕНА СПАЛА!</b></big></font>"
	admin_ended_all_grace_periods = TRUE
	return
/obj/map_metadata/civilizations/proc/wallup()
	for (var/turf/floor/dirt/jungledirt/JD)
		JD.ChangeTurf(/turf/wall/rockwall)
	world <<"<font color=#CECE00><big><b>ВЕЛИКАЯ СТЕНА АКТИВНА!</b></big></font>"
	admin_ended_all_grace_periods = FALSE
	return

/obj/map_metadata/civilizations/faction2_can_cross_blocks()
	return (admin_ended_all_grace_periods)

/obj/map_metadata/civilizations/faction1_can_cross_blocks()
	return (admin_ended_all_grace_periods)

/obj/map_metadata/civilizations/cross_message(faction)
	return "<big><b>ВЕЛИКИЙ ПЕРИОД ОКОНЧЕН!</b></big>"