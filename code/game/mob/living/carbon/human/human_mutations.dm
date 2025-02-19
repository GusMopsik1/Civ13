/mob/living/human/proc/togglerace(targetraceinput)
	src << "<span> You start to change....</span>"
	spawn(4000)
		if (src && orc+ant+crab+wolfman+lizard+gorillaman+skeletman+zombieman<=0)
			switch(targetraceinput)
				if ("orc")
					orc = 0
				if ("ant")
					ant = 0
				if ("crab")
					crab = 0
				if ("wolfman")
					wolfman = 0
				if ("lizard")
					lizard = 0
				if ("gorillaman")
					gorillaman = 0
				if ("skeletman")
					skeletman = 0
				if ("zombieman")
					zombieman = 0
/mob/living/human/proc/checkrace()
	if(!orc && !ant && !wolfman && !lizard && !gorillaman && !crab && !skeletman && !zombieman && can_mutate)
		return TRUE
	else
		return FALSE
/mob/living/human/rad_act()
	..()
	if (inducedSSD)
		return
	if(radiation >= 300 && checkrace()) //If you are super irradiated, and somehow still alive.
		if (prob(15))
			if (prob(15))
				src << "<span> You feel yourself getting more muscular and angry!</span>"
			else
				src << "<span> Your skin starts to turn a greenish hue!</span>"
			togglerace("orc")
			radiation -= radiation/8 //Reduce radiation a little.
		else if (prob(15))
			if (prob(50))
				src << "<span> Your skin starts to get covered with an exoskeleton!</span>"
			else
				src << "<span> You feel something sprout from your head!</span>"
			togglerace("ant")
			radiation -= radiation/8 //Reduce radiation a little.
		else if (prob(15))
			if (prob(50))
				src << "<span> You start to grow a shell!</span>"
			else
				src << "<span> Your hands turn into claws!</span>"
			togglerace("crab")
			radiation -= radiation/8 //Reduce radiation a little.
		else if (prob(10))
			if (prob(50))
				src << "<span> You start to grow fur all over your body!</span>"
			else
				src << "<span> You suddenly feel the urge to howl!</span>"
			togglerace("wolfman")
			radiation -= radiation/4 //Reduce radiation because you ain't resistant.
		else if (prob(10))
			if (prob(50))
				src << "<span> Your skin starts to grow out scales!</span>"
			else
				src << "<span> Your tongue becomes forked and long!</span>"
			togglerace("lizard")
			radiation -= radiation/4 //Reduce radiation because you ain't resistant.
		else if (prob(10))
			if (prob(50))
				src << "<span> You feel yourself craving bananas!</span>"
			else
				src << "<span> You notice dark fur spreading across your body!</span>"
			togglerace("gorillaman")
			radiation -= radiation/4 //Reduce radiation because you ain't resistant.
		else if (prob(10))
			if (prob(50))
				src << "<span> My skin flaking!</span>"
			else
				src << "<span> I feel empty inside me!</span>"
			togglerace("skeletman")
			radiation -= radiation/4 //Reduce radiation because you ain't resistant.
		else if (prob(10))
			if (prob(50))
				src << "<span> Brains...</span>"
			else
				src << "<span> Meat...</span>"
			togglerace("zombieman")
			radiation -= radiation/4 //Reduce radiation because you ain't resistant.
	if(radiation >= 350) //Corpse gotta be pretty bad tbh.
		if(stat == DEAD) //if dead.
			if (prob(30)) //decent chance.
				var/i
				for(i=1,i<contents.len,i++)//dump all items on ground
					drop_item(contents[i])
				var/mob/living/simple_animal/hostile/human/zombie/playerzombie //make a var for the zombie
				playerzombie = new /mob/living/simple_animal/hostile/human/zombie/ //make a zombie!
				//transferring vars.
				playerzombie.loc = loc
				playerzombie.name = real_name
				playerzombie.desc = "A zombie... looks like they were once someone."
				playerzombie.harm_intent_damage = 14 * getStatCoeff("strength")
				playerzombie.melee_damage_lower = 8 * getStatCoeff("strength")
				playerzombie.melee_damage_upper = 14 * getStatCoeff("strength")
				playerzombie.move_to_delay = 12 / getStatCoeff("dexterity")
				playerzombie.maxHealth = maxHealth //set health
				playerzombie.health = maxHealth //heal
				if(prob(1))
					playerzombie.desc = "A zombie... looks like it still remembers its faction."
					playerzombie.faction = faction
				qdel(src) //bye bye old body!
	return