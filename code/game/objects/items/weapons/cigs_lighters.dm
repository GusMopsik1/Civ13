//cleansed 9/15/2012 17:48

/*
CONTAINS:
MATCHES
CIGARETTES
CIGARS
SMOKING PIPES
CHEAP LIGHTERS
ZIPPO

CIGARETTE PACKETS ARE IN FANCY.DM
*/

//For anything that can light stuff on fire
/obj/item/weapon/flame
	var/lit = FALSE

/proc/isflamesource(A)
	if (istype(A, /obj/item/weapon/flame))
		var/obj/item/weapon/flame/F = A
		return (F.lit)
	return FALSE

///////////
//MATCHES//
///////////
/obj/item/weapon/flame/match
	name = "match"
	desc = "A simple match stick, used for lighting fine smokables."
	icon = 'icons/russian/obj/cigarettes.dmi'
	icon_state = "match_unlit"
	var/burnt = FALSE
	var/smoketime = 5
	w_class = 1.0
	slot_flags = SLOT_EARS
	attack_verb = list("burnt", "singed")

/obj/item/weapon/flame/match/process()
	if (isliving(loc))
		var/mob/living/M = loc
		M.IgniteMob()
	smoketime--
	if (smoketime < 1)
		burn_out()
		return

/obj/item/weapon/flame/match/dropped(mob/user as mob)
	//If dropped, put ourselves out
	//not before lighting up the turf we land on, though.
	if (lit)
		spawn(0)
			burn_out()
	return ..()

/obj/item/weapon/flame/match/proc/burn_out()
	lit = FALSE
	burnt = TRUE
	damtype = "brute"
	icon_state = "match_burnt"
	item_state = "cigoff"
	name = "burnt match"
	desc = "A match. This one has seen better days."
	processing_objects -= src

//////////////////
//FINE SMOKABLES//
//////////////////
/obj/item/clothing/mask/smokable
	name = "smokable item"
	desc = "You're not sure what this is. You should probably ahelp it."
	body_parts_covered = FALSE
	var/lit = FALSE
	var/icon_on
	var/icon_off
	var/type_butt = null
	var/chem_volume = FALSE
	var/smoketime = FALSE
	var/matchmes = "USER lights NAME with FLAME"
	var/lightermes = "USER lights NAME with FLAME"
	var/zippomes = "USER lights NAME with FLAME"
	var/weldermes = "USER lights NAME with FLAME"
	var/ignitermes = "USER lights NAME with FLAME"
	heat_protection = 0
/obj/item/clothing/mask/smokable/New()
	..()
	flags |= NOREACT // so it doesn't react until you light it
	create_reagents(chem_volume) // making the cigarrete a chemical holder with a maximum volume of 15

/obj/item/clothing/mask/smokable/process()
	smoketime--
	if (smoketime < 1)
		die()
		return
	if (reagents && reagents.total_volume) // check if it has any reagents at all
		if (ishuman(loc))
			var/mob/living/human/C = loc
			if (src == C.wear_mask && C.check_has_mouth()) // if it's in the human/monkey mouth, transfer reagents to the mob
				reagents.trans_to_mob(C, REM, CHEM_INGEST, 0.2, FALSE, TRUE) // Most of it is not inhaled... balance reasons.
		else // else just remove some of the reagents
			reagents.remove_any(REM)

/obj/item/clothing/mask/smokable/proc/light(var/flavor_text = "[usr] lights the [name].")
	if (!lit)
		lit = TRUE
		damtype = "fire"
		playsound(src, 'sound/items/cig_light.ogg', 75, TRUE, -1)//Play the nice sound.
		if (reagents.get_reagent_amount("plasma")) // the plasma explodes when exposed to fire
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("plasma") / 2.5, TRUE), get_turf(src), FALSE, FALSE)
			e.start()
			qdel(src)
			return
		if (reagents.get_reagent_amount("fuel")) // the fuel explodes, too, but much less violently
			var/datum/effect/effect/system/reagents_explosion/e = new()
			e.set_up(round(reagents.get_reagent_amount("fuel") / 5, TRUE), get_turf(src), FALSE, FALSE)
			e.start()
			qdel(src)
			return
		flags &= ~NOREACT // allowing reagents to react after being lit
		reagents.handle_reactions()
		icon_state = icon_on
		item_state = icon_on
		if (ismob(loc))
			var/mob/living/M = loc
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		set_light(2, 0.25, "#E38F46")
		processing_objects += src

/obj/item/clothing/mask/smokable/proc/die(var/nomessage = FALSE)
	var/turf/T = get_turf(src)
	set_light(0)
	if (type_butt)
		var/obj/item/butt = new type_butt(T)
		transfer_fingerprints_to(butt)
		if (ismob(loc))
			var/mob/living/M = loc
			if (!nomessage)
				M << "<span class='notice'>Your [name] goes out.</span>"
			M.remove_from_mob(src) //un-equip it so the overlays can update
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		processing_objects -= src
		qdel(src)
	else
		new /obj/effect/decal/cleanable/ash(T)
		if (ismob(loc))
			var/mob/living/M = loc
			if (!nomessage)
				M << "<span class='notice'>Your [name] goes out, and you empty the ash.</span>"
			lit = FALSE
			icon_state = icon_off
			item_state = icon_off
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)
		processing_objects -= src

/obj/item/clothing/mask/smokable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if (isflamesource(W) ||istype(W, /obj/item/flashlight))
		var/text = matchmes
		if (istype(W, /obj/item/weapon/flame/match))
			text = matchmes
		else if (istype(W, /obj/item/weapon/flame/lighter/zippo))
			text = zippomes
		else if (istype(W, /obj/item/weapon/flame/lighter))
			text = lightermes
		text = replacetext(text, "USER", "[user]")
		text = replacetext(text, "NAME", "[name]")
		text = replacetext(text, "FLAME", "[W.name]")
		light(text)

/obj/item/clothing/mask/smokable/attack(var/mob/living/M, var/mob/living/user, def_zone)
	if (istype(M) && M.on_fire)
		user.do_attack_animation(M)
		light("<span class='notice'>\The [user] coldly lights the \the [src] with the burning body of \the [M].</span>")
		return TRUE
	else
		return ..()

/obj/item/clothing/mask/smokable/cigarette
	name = "cigarette"
	desc = "A roll of tobacco and nicotine."
	icon_state = "cigoff"
	throw_speed = 0.5
	item_state = "cigoff"
	w_class = TRUE
	slot_flags = SLOT_EARS | SLOT_MASK
	attack_verb = list("burnt", "singed")
	icon_on = "cigon"  //Note - these are in masks.dmi not in cigarette.dmi
	icon_off = "cigoff"
	type_butt = /obj/item/weapon/cigbutt
	chem_volume = 15
	smoketime = 300
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER casually lights the NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME.</span>"

	New()
		..()
		reagents.add_reagent("nicotine",15)
/obj/item/clothing/mask/smokable/cigarette/afterattack(obj/item/weapon/reagent_containers/glass/glass, mob/user as mob, proximity)
	..()
	if (!proximity)
		return
	if (istype(glass)) //you can dip cigarettes into beakers
		var/transfered = glass.reagents.trans_to_obj(src, chem_volume)
		if (transfered)	//if reagents were transfered, show the message
			user << "<span class='notice'>You dip \the [src] into \the [glass].</span>"
		else			//if not, either the beaker was empty, or the cigarette was full
			if (!glass.reagents.total_volume)
				user << "<span class='notice'>[glass] is empty.</span>"
			else
				user << "<span class='notice'>[src] is full.</span>"

/obj/item/clothing/mask/smokable/cigarette/attack_self(mob/user as mob)
	if (lit == TRUE)
		user.visible_message("<span class='notice'>[user] calmly drops and treads on the lit [src], putting it out instantly.</span>")
		die(1)
	return ..()

////////////
// CIGARS //
////////////
/obj/item/clothing/mask/smokable/cigarette/cigar
	name = "cigar"
	desc = "A brown roll of tobacco and... well, you're not quite sure. This thing's huge!"
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	type_butt = /obj/item/weapon/cigbutt/cigarbutt
	throw_speed = 0.5
	item_state = "cigaroff"
	smoketime = 1500
	chem_volume = 30
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to offend their NAME by lighting it with FLAME.</span>"
	zippomes = "<span class='rose'>With a flick of their wrist, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER insults NAME by lighting it with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"
	value = 17

	New()
		..()
		reagents.add_reagent("nicotine",30)

/obj/item/clothing/mask/smokable/cigarette/joint
	name = "joint"
	desc = "A joint filled with weed."
	icon_state = "joint"
	icon_on = "jointon"
	icon_off = "joint"
	smoketime = 200
	chem_volume = 70
	value = 28
	New()
		..()
		reagents.add_reagent("thc",30)

/obj/item/clothing/mask/smokable/cigarette/cigar/havana
	name = "Cuban cigar"
	desc = "A cigar fit for only the best of the best."
	icon_state = "cigar2off"
	icon_on = "cigar2on"
	icon_off = "cigar2off"
	smoketime = 7200
	chem_volume = 40
	value = 24
	New()
		..()
		reagents.add_reagent("nicotine",40)

/obj/item/weapon/cigbutt
	name = "cigarette butt"
	desc = "A manky old cigarette butt."
	icon = 'icons/obj/clothing/masks.dmi'
	icon_state = "cigbutt"
	w_class = TRUE
	slot_flags = SLOT_EARS
	throwforce = TRUE

/obj/item/weapon/cigbutt/New()
	..()
	pixel_x = rand(-10,10)
	pixel_y = rand(-10,10)
	transform = turn(transform,rand(0,360))

/obj/item/weapon/cigbutt/cigarbutt
	name = "cigar butt"
	desc = "A manky old cigar butt."
	icon_state = "cigarbutt"

/obj/item/clothing/mask/smokable/cigarette/cigar/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()

	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/////////////////
//SMOKING PIPES//
/////////////////
/obj/item/clothing/mask/smokable/pipe
	name = "smoking pipe"
	desc = "A hollow stem for drawing air through with an attached bowl for burning smokables. This one is carved from wood."
	icon_state = "pipeoff"
	item_state = "pipeoff"
	icon_on = "pipeon"  //Note - these are in masks.dmi
	icon_off = "pipeoff"
	smoketime = FALSE
	chem_volume = 50
	w_class = 2.0
	matchmes = "<span class='notice'>USER lights their NAME with their FLAME.</span>"
	lightermes = "<span class='notice'>USER manages to light their NAME with FLAME.</span>"
	zippomes = "<span class='rose'>With much care, USER lights their NAME with their FLAME.</span>"
	weldermes = "<span class='notice'>USER recklessly lights NAME with FLAME.</span>"
	ignitermes = "<span class='notice'>USER fiddles with FLAME, and manages to light their NAME with the power of science.</span>"

/obj/item/clothing/mask/smokable/pipe/New()
	..()
	name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/pipe/light(var/flavor_text = "[usr] lights the [name].")
	if (!lit && smoketime)
		lit = TRUE
		damtype = "fire"
		icon_state = icon_on
		item_state = icon_on
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		processing_objects += src
		if (ismob(loc))
			var/mob/living/M = loc
			M.update_inv_wear_mask(0)
			M.update_inv_l_hand(0)
			M.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/pipe/attack_self(mob/user as mob)
	if (lit == TRUE)
		user.visible_message("<span class='notice'>[user] puts out [src].</span>", "<span class='notice'>You put out [src].</span>")
		lit = FALSE
		icon_state = icon_off
		item_state = icon_off
		processing_objects -= src
	else if (smoketime)
		var/turf/location = get_turf(user)
		user.visible_message("<span class='notice'>[user] empties out [src].</span>", "<span class='notice'>You empty out [src].</span>")
		new /obj/effect/decal/cleanable/ash(location)
		smoketime = FALSE
		reagents.clear_reagents()
		name = "empty [initial(name)]"

/obj/item/clothing/mask/smokable/pipe/attackby(obj/item/weapon/W as obj, mob/user as mob)

	..()
	if (istype(W, /obj/item/stack/material/tobacco))
		var/obj/item/stack/material/tobacco/G = W
		if (smoketime)
			user << "<span class='notice'>[src] is already packed.</span>"
			return
		smoketime = 1000
		reagents.add_reagent("nicotine",15)
		name = "tobacco-packed [initial(name)]"
		if (G.amount > 1)
			G.amount -= 1
		else
			qdel(G)
	else if (istype(W, /obj/item/weapon/reagent_containers/pill/opium))
		var/obj/item/weapon/reagent_containers/pill/opium/G = W
		if (smoketime)
			user << "<span class='notice'>[src] is already packed.</span>"
			return
		smoketime = 500
		reagents.add_reagent("opium",5)
		name = "opium-packed [initial(name)]"
		qdel(G)

	else if (istype(W, /obj/item/weapon/reagent_containers/food/snacks/grown/peyote))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/peyote/G = W
		if (smoketime)
			user << "<span class='notice'>[src] is already packed.</span>"
			return
		smoketime = 200
		reagents.add_reagent("peyote", 5)
		name = "peyote-packed [initial(name)]"
		qdel(G)

	else if (istype(W, /obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/grown/G = W
		if (!G.dry)
			user << "<span class='notice'>[G] must be dried before you stuff it into [src].</span>"
			return
		if (smoketime)
			user << "<span class='notice'>[src] is already packed.</span>"
			return
		smoketime = 1000
		if (G.reagents)
			G.reagents.trans_to_obj(src, G.reagents.total_volume)
		name = "[G.name]-packed [initial(name)]"
		qdel(G)

	else if (istype(W, /obj/item/weapon/flame/lighter))
		var/obj/item/weapon/flame/lighter/L = W
		if (L.lit)
			light("<span class='notice'>[user] manages to light their [name] with [W].</span>")

	else if (istype(W, /obj/item/weapon/flame/match))
		var/obj/item/weapon/flame/match/M = W
		if (M.lit)
			light("<span class='notice'>[user] lights their [name] with the [W].</span>")
	else if (istype(W, /obj/item/flashlight))
		light("<span class='notice'>[user] lights their [name] with the [W].</span>")
	user.update_inv_wear_mask(0)
	user.update_inv_l_hand(0)
	user.update_inv_r_hand(1)

/obj/item/clothing/mask/smokable/pipe/cobpipe
	name = "corn cob pipe"
	desc = "A hollow stem for drawing air through with an attached bowl for burning smokables. This one is carved from a corn cob."
	icon_state = "cobpipeoff"
	item_state = "cobpipeoff"
	icon_on = "cobpipeon"  //Note - these are in masks.dmi
	icon_off = "cobpipeoff"
	chem_volume = 35

/////////
//ZIPPO//
/////////
/obj/item/weapon/flame/lighter
	name = "cheap lighter"
	desc = "A cheap-as-free lighter."
	icon = 'icons/obj/items.dmi'
	icon_state = "lighter-g"
	item_state = "lighter-g"
	w_class = TRUE
	throwforce = 4
	flags = CONDUCT
	slot_flags = SLOT_BELT
	attack_verb = list("burnt", "singed")
	var/base_state
	var/sound_toggleON = 'sound/items/lighter_on.ogg'
	var/sound_toggleOFF = 'sound/items/lighter_off.ogg'
	flammable = TRUE

/obj/item/weapon/flame/lighter/bullet
	name = "bullet lighter"
	desc = "A casing that is now a lighter, cheeki breeki."
	icon_state = "bullet"
	item_state = "bullet"
	sound_toggleON = 'sound/items/zippo_on.ogg'
	sound_toggleOFF = 'sound/items/zippo_off.ogg'

/obj/item/weapon/flame/lighter/zippo
	name = "\improper Zippo lighter"
	desc = "The zippo."
	icon_state = "zippo"
	item_state = "zippo"
	sound_toggleON = 'sound/items/zippo_on.ogg'
	sound_toggleOFF = 'sound/items/zippo_off.ogg'

/obj/item/weapon/flame/lighter/random
	New()
		icon_state = "lighter-[pick("r","c","y","g")]"
		item_state = icon_state
		base_state = icon_state

/obj/item/weapon/flame/lighter/attack_self(mob/living/user)
	if (!base_state)
		base_state = icon_state
	if (user.r_hand == src || user.l_hand == src)
		if (!lit)
			playsound(src, sound_toggleON, 30, FALSE)
			lit = TRUE
			icon_state = "[base_state]on"
			item_state = "[base_state]on"
			if (!istype(src, /obj/item/weapon/flame/lighter/zippo) )
				if (prob(5))
					user << "<span class='warning'>You burn yourself while lighting the lighter.</span>"
					if (user.l_hand == src)
						user.apply_damage(2,BURN,"l_hand")
					else
						user.apply_damage(2,BURN,"r_hand")


			set_light(2)
			processing_objects += src
		else
			playsound(src, sound_toggleOFF, 30, FALSE)
			lit = FALSE
			icon_state = "[base_state]"
			item_state = "[base_state]"
			set_light(0)
			processing_objects -= src
	else
		return ..()
	return


/obj/item/weapon/flame/lighter/attack(mob/living/human/M as mob, mob/living/human/user as mob)
	if (!istype(M, /mob))
		return
	M.IgniteMob()

	if (istype(M.wear_mask, /obj/item/clothing/mask/smokable/cigarette) && user.targeted_organ == "mouth" && lit)
		var/obj/item/clothing/mask/smokable/cigarette/cig = M.wear_mask
		if (M == user)
			cig.attackby(src, user)
		else
			if (istype(src, /obj/item/weapon/flame/lighter/zippo))
				cig.light("<span class='rose'>[user] whips the [name] out and holds it for [M].</span>")
			else
				cig.light("<span class='notice'>[user] holds the [name] out for [M], and lights the [cig.name].</span>")
	else
		..()

/obj/item/weapon/flame/lighter/process()
	return
