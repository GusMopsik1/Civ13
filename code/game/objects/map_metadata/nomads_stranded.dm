/obj/map_metadata/nomads_stranded
	ID = MAP_NOMADS_STRANDED
	title = "Nomads (stranded)"
	lobby_icon_state = "civ13"
	no_winner ="The round is proceeding normally."
	caribbean_blocking_area_types = list(/area/caribbean/no_mans_land/invisible_wall/)
	respawn_delay = 6000 // 10 minutes!
	has_hunger = TRUE
	no_winner = "The round is proceeding normally."

	faction_organization = list(
		CIVILIAN,)

	roundend_condition_sides = list(
		list(CIVILIAN) = /area/caribbean/british
		)
	age = "514"
	civilizations = TRUE
	var/tribes_nr = 1
	faction_distribution_coeffs = list(CIVILIAN = 1)
	battle_name = "the civilizations"
	mission_start_message = "<big>Ваша экспедиционная комманда застряла на этих необитаемых островах. Пути назад нету а значит придётся тут развиваться.</big><br><b>Вики: https://civ13.github.io/civ13-wiki/Civilizations_and_Nomads</b>"
	ambience = list('sound/ambience/jungle1.ogg')
	faction1 = CIVILIAN
	availablefactions = list("Nomad")
	songs = list(
		"Words Through the Sky:1" = 'sound/music/words_through_the_sky.ogg',)
	research_active = TRUE
	nomads = TRUE
	gamemode = "Classic (Stone Age Start)"
	ordinal_age = 2
	default_research = 120
	research_active = FALSE
	age1_done = TRUE
	age2_done = TRUE
	var/list/arealist_r = list()
	var/list/arealist_g = list()
/obj/map_metadata/nomads_stranded/New()
	..()
	spawn(2500)
		for (var/i = 1, i <= 65, i++)
			var/turf/areaspawn = safepick(get_area_turfs(/area/caribbean/sea/sea))
			new/obj/structure/fish(areaspawn)
	spawn(2500)
		for (var/i = 1, i <= 30, i++)
			var/turf/areaspawn = safepick(get_area_turfs(/area/caribbean/nomads/forest/Jungle/river))
			new/obj/structure/piranha(areaspawn)
	spawn(18000)
		seasons()

/obj/map_metadata/nomads_stranded/faction2_can_cross_blocks()
	return (ordinal_age >= 2)

/obj/map_metadata/nomads_stranded/faction1_can_cross_blocks()
	return (ordinal_age >= 2)

/obj/map_metadata/nomads_stranded/cross_message(faction)
	if (faction == CIVILIAN)
		return "<big><b>As the world technological level advances, new shipbuilding techniques make us at last be able to navigate the oceans...</b></big>"


/obj/map_metadata/nomads_stranded/job_enabled_specialcheck(var/datum/job/J)
	if (J.is_nomad == TRUE)
		. = TRUE
	else
		. = FALSE