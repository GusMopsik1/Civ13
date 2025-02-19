/obj/structure/grille
	name = "grille"
	desc = "Flimsy wood rods, with screws to secure it to the floor."
	icon = 'icons/russian/obj/structures.dmi'
	icon_state = "grille"
	density = TRUE
	anchored = TRUE
	flags = CONDUCT
	layer = 2.9
	explosion_resistance = TRUE
	var/health = 10 // 50 is waaaaaay to fucking high.
	var/destroyed = FALSE
	var/hitsound = 'sound/effects/grillehit.ogg'
	flammable = TRUE
	not_movable = TRUE
	not_disassemblable = FALSE
/obj/structure/grille/ex_act(severity)
	qdel(src)

/obj/structure/grille/New()
	..()
	for (var/obj/structure/wild/W in get_turf(src))
		qdel(W)

/obj/structure/grille/update_icon()
	if (destroyed)
		icon_state = "[initial(icon_state)]-b"
	else
		icon_state = initial(icon_state)
/*
/obj/structure/grille/Bumped(atom/user)
	if (ismob(user)) shock(user, 70)
*/
/obj/structure/grille/attack_hand(mob/user as mob)

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	playsound(loc, hitsound, 80, TRUE)
	user.do_attack_animation(src)

	var/damage_dealt = TRUE
	var/attack_message = "kicks"

	damage_dealt += 1

	attack_generic(user,damage_dealt,attack_message)

/obj/structure/grille/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if (air_group || (height==0)) return TRUE
	if (istype(mover) && mover.checkpass(PASSGRILLE))
		return TRUE
	else
		if (istype(mover, /obj/item/projectile))
			return prob(30)
		else
			return !density

/obj/structure/grille/bullet_act(var/obj/item/projectile/Proj)
	if (!Proj)	return

	//Flimsy grilles aren't so great at stopping projectiles. However they can absorb some of the impact
	var/damage = Proj.get_structure_damage()
	var/passthrough = FALSE

	if (!damage) return

	//20% chance that the grille provides a bit more cover than usual. Support structure for example might take up 20% of the grille's area.
	//If they click on the grille itself then we assume they are aiming at the grille itself and the extra cover behaviour is always used.
	switch(Proj.damage_type)
		if (BRUTE)
			//bullets
			if (Proj.original == src || prob(20))
				Proj.damage *= between(0, Proj.damage/60, 0.5)
				if (prob(max((damage-10)/25, FALSE))*100)
					passthrough = TRUE
			else
				Proj.damage *= between(0, Proj.damage/60, TRUE)
				passthrough = TRUE
		if (BURN)
			//beams and other projectiles are either blocked completely by grilles or stop half the damage.
			if (!(Proj.original == src || prob(20)))
				Proj.damage *= 0.5
				passthrough = TRUE

	if (passthrough)
		. = PROJECTILE_CONTINUE
		damage = between(0, (damage - Proj.damage)*(Proj.damage_type == BRUTE? 0.4 : TRUE), 10) //if the bullet passes through then the grille avoids most of the damage

	health -= damage*0.2
	spawn(0) healthcheck() //spawn to make sure we return properly if the grille is deleted

/obj/structure/grille/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (iswirecutter(W))
		playsound(loc, 'sound/items/Wirecutter.ogg', 100, TRUE)
		PoolOrNew(/obj/item/stack/rods, list(get_turf(src), destroyed ? TRUE : 2))
		qdel(src)
	else if ((isscrewdriver(W)) && (istype(loc, /turf) || anchored))
		playsound(loc, 'sound/items/Screwdriver.ogg', 100, TRUE)
		anchored = !anchored
		user.visible_message("<span class='notice'>[user] [anchored ? "fastens" : "unfastens"] the grille.</span>", \
							 "<span class='notice'>You have [anchored ? "fastened the grille to" : "unfastened the grill from"] the floor.</span>")
		return

//window placing begin //TODO CONVERT PROPERLY TO MATERIAL DATUM
	else if (istype(W,/obj/item/stack/material))
		var/obj/item/stack/material/ST = W
		if (!ST.material.created_window)
			return FALSE

		var/dir_to_set = TRUE
		if (loc == user.loc)
			dir_to_set = user.dir
		else
			if ( ( x == user.x ) || (y == user.y) ) //Only supposed to work for cardinal directions.
				if ( x == user.x )
					if ( y > user.y )
						dir_to_set = 2
					else
						dir_to_set = TRUE
				else if ( y == user.y )
					if ( x > user.x )
						dir_to_set = 8
					else
						dir_to_set = 4
			else
				user << "<span class='notice'>You can't reach.</span>"
				return //Only works for cardinal direcitons, diagonals aren't supposed to work like this.
		for (var/obj/structure/window/WINDOW in loc)
			if (WINDOW.dir == dir_to_set)
				user << "<span class='notice'>There is already a window facing this way there.</span>"
				return
		user << "<span class='notice'>You start placing the window.</span>"
		if (do_after(user,20,src))
			for (var/obj/structure/window/WINDOW in loc)
				if (WINDOW.dir == dir_to_set)//checking this for a 2nd time to check if a window was made while we were waiting.
					user << "<span class='notice'>There is already a window facing this way there.</span>"
					return

			var/wtype = ST.material.created_window
			if (ST.use(1))
				var/obj/structure/window/WD = new wtype(loc, dir_to_set, TRUE)
				user << "<span class='notice'>You place the [WD] on [src].</span>"
				WD.update_icon()
		return
//window placing end

	else if (!(W.flags & CONDUCT)/* || !shock(user, 70)*/)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		user.do_attack_animation(src)
		playsound(loc, hitsound, 80, TRUE)
		switch(W.damtype)
			if ("fire")
				health -= W.force
			if ("brute")
				health -= W.force * 0.1
	healthcheck()
	..()
	return


/obj/structure/grille/proc/healthcheck()
	if (health <= 0)
		if (!destroyed)
			qdel(src)
			return
	return

/obj/structure/grille/fire_act(temperature)
	if (prob((temperature/500) * 30))
		visible_message("<span class = 'warning'>[src] burns.</span>")
		health = 0
		healthcheck()

/obj/structure/grille/attack_generic(var/mob/user, var/damage, var/attack_verb)
	visible_message("<span class='danger'>[user] [attack_verb] the [src]!</span>")
	attack_animation(user)
	health -= damage
	spawn(1) healthcheck()
	return TRUE

/obj/structure/grille/hitby(AM as mob|obj)
	..()
	visible_message("<span class='danger'>[src] was hit by [AM].</span>")
	playsound(loc, hitsound, 80, TRUE)
	var/tforce = FALSE
	if (ismob(AM))
		tforce = 10
	else if (isobj(AM))
		var/obj/item/I = AM
		tforce = I.throwforce
	health = max(0, health - tforce)
	if (health <= 0)
		destroyed=1
		PoolOrNew(/obj/item/stack/rods, get_turf(src))
		density=0
		update_icon()

// Used in mapping to avoid
/obj/structure/grille/broken
	destroyed = TRUE
	icon_state = "grille-b"
	density = FALSE
	New()
		..()
		health = rand(-5, -1) //In the destroyed but not utterly threshold.
		healthcheck() //Send this to healthcheck just in case we want to do something else with it.
/*
/obj/structure/grille/cult
	name = "cult grille"
	desc = "A matrice built out of an unknown material, with some sort of force field blocking air around it"
	icon_state = "grillecult"
	health = 40 //Make it strong enough to avoid people breaking in too easily

/obj/structure/grille/cult/CanPass(atom/movable/mover, turf/target, height = 1.5, air_group = FALSE)
	if (air_group)
		return FALSE //Make sure air doesn't drain
	..()
*/