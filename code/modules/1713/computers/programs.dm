///////////DATUMS////////////////////
/datum/email
	var/subject = "no subject"
	var/sender = "unknown"
	var/receiver = "unknown"
	var/message = ""
	var/date = "0:00"
	var/read = FALSE

/datum/email/New(list/properties = null)
	..()
	if (!properties) return

	for (var/propname in vars)
		if (!isnull(properties[propname]))
			vars[propname] = properties[propname]

/datum/program
	var/name = "program"
	var/description = "a basic computer program."
	var/list/compatible_os = list("unga OS 94")
	var/list/tmp_comp_vars = list() //where local vars get stored, as items in the list
	var/mainbody = "---"
	var/mainmenu = "---"
	var/does_checks = FALSE //If the computer should check regularly, i.e., check for new emails to announce them.

	var/mob/living/human/user //who is using the computer, from origin
	var/obj/structure/computer/origin //where the program is located

/datum/program/proc/does_checks_proc()
	if (!does_checks)
		return

/datum/program/proc/reset_tmp_vars()
	tmp_comp_vars = list()

/datum/program/proc/do_html(mob/living/human/user)
	var/fullpage = {"
			<!DOCTYPE html>
			<meta charset='utf-8'>
			<head>[computer_browser_style]<title>[name]</title></head>
			<body>
			<center>[mainmenu]</center>
			<hr style="height:4px;border-width:0;color:gray;background-color:gray">
			[mainbody]
			</body>
			</html>
			"}
	usr << browse(fullpage,"window=[name];border=1;can_close=1;can_resize=0;can_minimize=0;titlebar=1;size=800x600")

/datum/program/Topic(href, href_list, hsrc)

	if (!origin)
		return

	var/mob/living/human/user = origin.user

	if (!user || user.lying || !ishuman(user))
		return

	user.face_atom(origin)

	if (!locate(user) in range(1,origin))
		user << "<span class = 'danger'>Get next to \the [origin] to use it.</span>"
		return FALSE

	if (!user.can_use_hands())
		user << "<span class = 'danger'>You have no hands to use this with.</span>"
		return FALSE

///////////////////ORION TRAIL GAME//////////////////////////////////
//////////////////////////////////////////////////////////////////////
#define ORION_TRAIL_WINTURN		9

//Orion Trail Events
#define ORION_TRAIL_RAIDERS		"Щиткурити"
#define ORION_TRAIL_FLUX		"Аномалия"
#define ORION_TRAIL_ILLNESS		"Вирус"
#define ORION_TRAIL_BREAKDOWN	"Ебать чё"
#define ORION_TRAIL_LING		"Генокрад"
#define ORION_TRAIL_LING_ATTACK "Засада метагея-генокрада"
#define ORION_TRAIL_MALFUNCTION	"Массовые галлюцинации"
#define ORION_TRAIL_COLLISION	"Чё"
#define ORION_TRAIL_SPACEPORT	"Карго"
#define ORION_TRAIL_BLACKHOLE	"Космос"
#define ORION_TRAIL_OLDSHIP		"Теха"
#define ORION_TRAIL_SEARCH		"Исследование техов"

#define ORION_STATUS_START		1
#define ORION_STATUS_NORMAL		2
#define ORION_STATUS_GAMEOVER	3
#define ORION_STATUS_MARKET		4

/datum/program/orion_trail
	name = "Space Station 13"
	description = "Исследуй станцию вместе с кооп-друзьяшками"
	var/busy = FALSE //prevent clickspam that allowed people to ~speedrun~ the game.
	var/engine = 0
	var/hull = 0
	var/electronics = 0
	var/food = 80
	var/fuel = 60
	var/turns = 4
	var/alive = 4
	var/eventdat = null
	var/event = null
	var/list/settlers = list("Harry","Larry","Bob")
	var/list/events = list(ORION_TRAIL_RAIDERS		= 3,
						   ORION_TRAIL_FLUX			= 1,
						   ORION_TRAIL_ILLNESS		= 3,
						   ORION_TRAIL_BREAKDOWN	= 2,
						   ORION_TRAIL_LING			= 3,
						   ORION_TRAIL_MALFUNCTION	= 2,
						   ORION_TRAIL_COLLISION	= 1,
						   ORION_TRAIL_SPACEPORT	= 2,
						   ORION_TRAIL_OLDSHIP		= 2
						   )
	var/list/stops = list()
	var/list/stopblurbs = list()
	var/lings_aboard = 0
	var/spaceport_raided = 0
	var/spaceport_freebie = 0
	var/last_spaceport_action = ""
	var/gameStatus = ORION_STATUS_START
	var/canContinueEvent = 0

	var/killed_crew = 0

/datum/program/orion_trail/proc/Reset()
	// Sets up the main trail
	stops = list("Прибытие","Западный Корридор","Восточный Корридор","Повреждённый Отсек","СБ","Дормы","Космос","Отбытие","ЦК")
	stopblurbs = list(
		"Прибытие является для многих началом... новой жизни? Да хуй его знает.",
		"Западное крыло в котором находится карго, ассистентская, иногда пробегают сбшники и прочие личности, который могут легко дать тебе пизды.",
		"Восточное крыло является наиболее опасным из-за РнД и ебанутых учёных, хохлов-ботаников, медиков, повара, бармена и так дальше до бесконечности. Зато тут можно найти в баре народ для путешествий а так-же купить еды и воды.",
		"Тут был недавно взрыв, не думаю что тут безопасно находиться. Зато тут куча вещей должно было остаться. Наверное.",
		"А вот и СБшная - место где находится дохуища оружия, где тебя могут пустить по кругу за графити на полу.",
		"Дормы со временем пока я путешествовал стали похожи на мини-государство. Думаю тут можно отдохнуть или сделать ещё прочие дела.",
		"Воу-воу-воу, ямы оказались в космосе из-за аномалии или нашего дебилизма. Шутка в том что у меня есть выбор из прыжка в портал или ходьбы до отбытия на своих ногах.",
		"Я в отбытии, ну может не только я. Шаттл прилетел, нужно продолжать идти, вокруг меня содомия и пиздец.",
		"Ямы долетели до ЦК и пережили данную смену, ура-ура."
		)

/datum/program/orion_trail/proc/newgame()
	// Set names of settlers in crew
	settlers = list()
	for(var/i = 1; i <= 3; i++)
		add_crewmember()
	add_crewmember("[usr]")
	// Re-set items to defaults
	engine = 1
	hull = 1
	electronics = 1
	food = 80
	fuel = 60
	alive = 4
	turns = 1
	event = null
	gameStatus = ORION_STATUS_NORMAL
	lings_aboard = 0
	killed_crew = 0

	//spaceport junk
	spaceport_raided = 0
	spaceport_freebie = 0
	last_spaceport_action = ""

/datum/program/orion_trail/do_html(mob/living/human/user)
	if(fuel <= 0 || food <=0 || settlers.len == 0)
		gameStatus = ORION_STATUS_GAMEOVER
		event = null
	mainbody = ""
	if(gameStatus == ORION_STATUS_GAMEOVER)
		mainbody = "<center><h1>Игра окончена</h1></center>"
		mainbody += "Твоя компания померла на станции или вблизи неё.<br><b>А стоило ли жить?</b>."
		if(!settlers.len)
			mainbody += "<br>Остатки вашей командды нашёл мимо проходящий член экипажа. Он был удивлён."
		else
			if(food <= 0)
				mainbody += "<br>У вашей командды закончилась еда и вы померли нахуй лол)"
			if(fuel <= 0)
				mainbody += "<br>У вас закончилась вода и вы медленно умираете от обезвоживания."

		mainbody += "<P ALIGN=Right><a href='?src=\ref[src];menu=1'>Респавн</a></P>"

	else if(event)
		mainbody = "[eventdat]"
	else if(gameStatus == ORION_STATUS_NORMAL)
		var/title = "title"
		var/subtext = "subtext"
		if (stops.len && stops[turns])
			title = stops[turns]
		if (stopblurbs.len && stopblurbs[turns])
			subtext = stopblurbs[turns]
		mainbody = "<center><h1>[title]</h1></center>"
		mainbody += "[subtext]"
		mainbody += "<h3><b>Компания:</b></h3>"
		mainbody += english_list(settlers)
		mainbody += "<br><b>Еда: </b>[food] | <b>Вода: </b>[fuel]"
		mainbody += "<br><b>Медикаменты: </b>[engine] | <b>Ткань: </b>[hull] | <b>Свет: </b>[electronics]"
		if(turns == 7)
			mainbody += "<P ALIGN=Right><a href='?src=\ref[src];pastblack=1'>В портал</a> <a href='?src=\ref[src];blackhole=1'>Пешком дойду</a></P>"
		else
			mainbody += "<P ALIGN=Right><a href='?src=\ref[src];continue=1'>Идти дальше</a></P>"
		mainbody += "<P ALIGN=Right><a href='?src=\ref[src];killcrew=1'>Убить своего</a></P>"
		mainbody += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть игру</a></P>"
	else
		mainbody = "<center><h2>Космическая Станция 13</h2></center>"
		mainbody += "<br><center><h3>Поиграйте за ассистента который путешевствует по станции!</h3></center><br><br>"
		mainbody += "<center><b><a href='?src=\ref[src];newgame=1'>Войти</a></b></center>"
	..()

/datum/program/orion_trail/Topic(href, href_list, hsrc)
	..()
	if(busy)
		return
	busy = TRUE

	var/xp_gained = 0
	if (href_list["continue"]) //Continue your travels
		if(gameStatus == ORION_STATUS_NORMAL && !event && turns != 7)
			if(turns >= ORION_TRAIL_WINTURN)
				win(user)
				xp_gained += 34
			else
				food -= (alive+lings_aboard)*2
				fuel -= 5
				if(turns == 2 && prob(30))
					event = ORION_TRAIL_COLLISION
					event()
				else if(prob(75))
					event = pickweight(events)
					if(lings_aboard)
						if(event == ORION_TRAIL_LING || prob(55))
							event = ORION_TRAIL_LING_ATTACK
					event()
				turns += 1

	else if(href_list["newgame"]) //Reset everything
		if(gameStatus == ORION_STATUS_START)
			Reset()
			newgame()
	else if(href_list["menu"]) //back to the main menu
		if(gameStatus == ORION_STATUS_GAMEOVER)
			gameStatus = ORION_STATUS_START
			event = null
			food = 80
			fuel = 60
			settlers = list("Harry","Larry","Bob")
	else if(href_list["search"]) //search old ship
		if(event == ORION_TRAIL_OLDSHIP)
			event = ORION_TRAIL_SEARCH
			event()
	else if(href_list["slow"]) //slow down
		if(event == ORION_TRAIL_FLUX)
			food -= (alive+lings_aboard)*2
			fuel -= 5
		event = null
	else if(href_list["pastblack"]) //slow down
		if(turns == 7)
			food -= ((alive+lings_aboard)*2)*3
			fuel -= 15
			turns += 1
			event = null
	else if(href_list["useengine"]) //use parts
		if(event == ORION_TRAIL_BREAKDOWN)
			engine = max(0, --engine)
			event = null
	else if(href_list["useelec"]) //use parts
		if(event == ORION_TRAIL_MALFUNCTION)
			electronics = max(0, --electronics)
			event = null
	else if(href_list["usehull"]) //use parts
		if(event == ORION_TRAIL_COLLISION)
			hull = max(0, --hull)
			event = null
	else if(href_list["wait"]) //wait 3 days
		if(event == ORION_TRAIL_BREAKDOWN || event == ORION_TRAIL_MALFUNCTION || event == ORION_TRAIL_COLLISION)
			food -= ((alive+lings_aboard)*2)*3
			event = null
	else if(href_list["keepspeed"]) //keep speed
		if(event == ORION_TRAIL_FLUX)
			if(prob(75))
				event = "Breakdown"
				event()
			else
				event = null
	else if(href_list["blackhole"]) //keep speed past a black hole
		if(turns == 7)
			if(prob(75))
				event = ORION_TRAIL_BLACKHOLE
				event()
			else
				event = null
				turns += 1
	else if(href_list["holedeath"])
		if(event == ORION_TRAIL_BLACKHOLE)
			gameStatus = ORION_STATUS_GAMEOVER
			event = null
	else if(href_list["eventclose"]) //end an event
		if(canContinueEvent)
			event = null

	else if(href_list["killcrew"]) //shoot a crewmember
		if(gameStatus == ORION_STATUS_NORMAL || event == ORION_TRAIL_LING)
			var/sheriff = remove_crewmember() //I shot the sheriff
			killed_crew++

			if(settlers.len == 0 || alive == 0)
				usr << "The last crewmember [sheriff], shot themselves, GAME OVER!"
				usr << 'sound/effects/gameover.ogg'
				gameStatus = ORION_STATUS_GAMEOVER
				event = null

				if(killed_crew >= 4)
					xp_gained -= 15//no cheating by spamming game overs

			if(event == ORION_TRAIL_LING) //only ends the ORION_TRAIL_LING event, since you can do this action in multiple places
				event = null
				killed_crew-- // the kill was valid

	//Spaceport specific interactions
	//they get a header because most of them don't reset event (because it's a shop, you leave when you want to)
	//they also call event() again, to regen the eventdata, which is kind of odd but necessary
	else if(href_list["buycrew"]) //buy a crewmember
		if(gameStatus == ORION_STATUS_MARKET)
			if(!spaceport_raided && food >= 10 && fuel >= 10)
				var/bought = add_crewmember()
				last_spaceport_action = "Я нанял челика в баре. Ну привет [bought]!"
				fuel -= 10
				food -= 10
				event()
				killed_crew-- // I mean not really but you know

	else if(href_list["sellcrew"]) //sell a crewmember
		if(gameStatus == ORION_STATUS_MARKET)
			if(!spaceport_raided && settlers.len > 1)
				var/sold = remove_crewmember()
				last_spaceport_action = "Я продал своего из компашки повару. Прощай [sold]!"
				fuel += 7
				food += 7
				event()

	else if(href_list["leave_spaceport"])
		if(gameStatus == ORION_STATUS_MARKET)
			event = null
			gameStatus = ORION_STATUS_NORMAL
			spaceport_raided = 0
			spaceport_freebie = 0
			last_spaceport_action = ""

	else if(href_list["raid_spaceport"])
		if(gameStatus == ORION_STATUS_MARKET)
			if(!spaceport_raided)
				var/success = min(15 * alive,100) //default crew (4) have a 60% chance
				spaceport_raided = 1

				var/FU = 0
				var/FO = 0
				if(prob(success))
					FU = rand(5,15)
					FO = rand(5,15)
					last_spaceport_action = "Наша компашка зарейдила это крыло спиздив [FO] еды и [FU] воды! (+[FU]FU,+[FO]FO)"
					xp_gained += 10
				else
					FU = rand(-5,-15)
					FO = rand(-5,-15)
					last_spaceport_action = "Нам дали пизды  [FU*-1] Fuel and [FO*-1] Food in your scramble to escape!"

					//your chance of lose a crewmember is 1/2 your chance of success
					//this makes higher % failures hurt more, don't get cocky space cowboy!
					if(prob(success*5))
						var/lost_crew = remove_crewmember()
						last_spaceport_action = "You failed to raid the spaceport! You lost [FU*-1] Fuel and [FO*-1] Food, AND [lost_crew] in your scramble to escape! ([FU]FI,[FO]FO,-Crew)"


				fuel += FU
				food += FO
				event()

	else if(href_list["buyparts"])
		if(gameStatus == ORION_STATUS_MARKET)
			if(!spaceport_raided && fuel > 5)
				switch(text2num(href_list["buyparts"]))
					if(1) //Engine Parts
						engine++
						last_spaceport_action = "Купить медикаменты"
					if(2) //Hull Plates
						hull++
						last_spaceport_action = "Купить ткань"
					if(3) //Spare Electronics
						electronics++
						last_spaceport_action = "Купить фонарик"
				fuel -= 5 //they all cost 5
				event()

	else if(href_list["trade"])
		if(gameStatus == ORION_STATUS_MARKET)
			if(!spaceport_raided)
				switch(text2num(href_list["trade"]))
					if(1) //Fuel
						if(fuel > 5)
							fuel -= 5
							food += 5
							last_spaceport_action = "Воду за еду"
							event()
					if(2) //Food
						if(food > 5)
							fuel += 5
							food -= 5
							last_spaceport_action = "Еду за воду"
							event()
	busy = FALSE
	sleep(0.5)
	do_html()
/datum/program/orion_trail/proc/event()
	eventdat = "<center><h1>[event]</h1></center>"
	canContinueEvent = 0
	switch(event)
		if(ORION_TRAIL_RAIDERS)
			eventdat += "СБшники пришли пиздить нас!"
			if(prob(50))
				var/sfood = rand(1,10)
				var/sfuel = rand(1,10)
				food -= sfood
				fuel -= sfuel
				eventdat += "<br>Они забрали [sfood] <b>еду</b> и [sfuel] <b>воду</b>. Вот пидорасы."
			else if(prob(10))
				var/deadname = remove_crewmember()
				eventdat += "<br>Блядь [deadname] ты еблан нахуй ты полез на них ёбаный долбоёб сука."
			else
				eventdat += "<br>В итоге они получили пизды в ответ."
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];eventclose=1'>Ну чё идём дальше</a></P>"
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"
			canContinueEvent = 1

		if(ORION_TRAIL_FLUX)
			eventdat += "Пиздец! <br>Гравитационный двигатель отключился и теперь нужно думать что делать дальше."
			eventdat += "<br>Если мы переждём в техах то сможем уберечься от возможной угрозы но если будем продолжать наше путешествие по станции то мы сэкономим еду и воду."
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];slow=1'>Переждать в техах</a> <a href='?src=\ref[src];keepspeed=1'>Идти дальше</a></P>"
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть игру</a></P>"

		if(ORION_TRAIL_OLDSHIP)
			eventdat += "<br>Странное судно пристыковалось к станции. Судя по всему там никого нет но стоит ли туда заходить? Там видно несколько ящиков."
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];search=1'>Да стоит</a><a href='?src=\ref[src];eventclose=1'>Пройти мимо</a></P><P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"
			canContinueEvent = 1

		if(ORION_TRAIL_SEARCH)
			switch(rand(100))
				if(0 to 15)
					var/rescued = add_crewmember()
					var/oldfood = rand(1,7)
					var/oldfuel = rand(4,10)
					food += oldfood
					fuel += oldfuel
					eventdat += "<br>Я нашёл в ящиках челика что прилетел сюда путешевствуя по космосу."
					eventdat += "<br>[rescued] теперь в нашей командде!"
					eventdat += "<br>А да мы ещё [oldfood] <b>еды</b> и [oldfuel] <b>воды</b> забрали с собой."
				if(15 to 35)
					var/lfood = rand(4,7)
					var/lfuel = rand(4,7)
					var/deadname = remove_crewmember()
					food -= lfood
					fuel -= lfuel
					eventdat += "<br>[deadname] пошёл внутрь корабля первым но вдруг судно взяло и улетело вместе с [lfood] <b>едой</b> и [lfuel] <b>водой</b>. Блядь."
				if(35 to 65)
					var/oldfood = rand(5,11)
					food += oldfood
					engine++
					eventdat += "<br>Внутри оказалось [oldfood] <b>еды</b> и ещё немного различных вещей."
				else
					eventdat += "<br>Внутри оказалось пусто, в ящиках пусто и вообще тут нихуя нету."
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];eventclose=1'>Идти дальше</a></P>"
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"
			canContinueEvent = 1

		if(ORION_TRAIL_ILLNESS)
			eventdat += "Отказ жопы"
			var/afood = rand(0,1)
			var/afuel = rand(0,1)
			food += afood
			fuel += afuel
			var/deadname = remove_crewmember()
			eventdat += "<br>[deadname] умер обосравшись и обоссавшись"
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];eventclose=1'>Идти дальше ахуевая</a></P>"
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"
			canContinueEvent = 1

		if(ORION_TRAIL_BREAKDOWN)
			eventdat += "Блядь один из нас наебнулся сильно и теперь не может идти"
			eventdat += "<br>Мы можем использовать медикаменты или подождать пока этот хуйло поспит 3 часа что бы отрегенить."
			if(engine >= 1)
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];useengine=1'>Залатать челика</a><a href='?src=\ref[src];wait=1'>Подождать</a></P>"
			else
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];wait=1'>Ждать</a></P>"
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"

		if(ORION_TRAIL_MALFUNCTION)
			eventdat += "Наша одежда исчезла с нихуя и теперь мы голые"
			eventdat += "<br>Я могу сшить одежду из ткани для всех или же мы будем искать хоть что-то около 3 часов."
			if(electronics >= 1)
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];useelec=1'>Сшить одежду</a><a href='?src=\ref[src];wait=1'>Искать</a></P>"
			else
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];wait=1'>Искать</a></P>"
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"

		if(ORION_TRAIL_COLLISION)
			eventdat += "Неожиданно по всей станции отключился свет."
			if(prob(25))
				var/sfood = rand(5,15)
				var/sfuel = rand(5,15)
				food -= sfood
				fuel -= sfuel
				eventdat += "<br>В темноте мы потеряли [sfood] <b>еды</b> и [sfuel] <b>воды</b>."
			if(prob(10))
				var/deadname = remove_crewmember()
				eventdat += "<br>[deadname] сказал что починит всё и убежал."
			eventdat += "<br>Можно сделать фонарик или же ждать 3 часа до починки света."
			if(hull >= 1)
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];usehull=1'>Сделать фонарик</a><a href='?src=\ref[src];wait=1'>Ждать</a></P>"
			else
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];wait=1'>Ждать</a></P>"
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"

		if(ORION_TRAIL_BLACKHOLE)
			eventdat += "Я наступил куда-то и нашу командду телепортировало в какой-то отель."
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];holedeath=1'>Идти дальше?</a></P>"
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"
			settlers = list()

		if(ORION_TRAIL_LING)
			eventdat += "Сообщают о генокрадах среди экипажа."
			if(settlers.len <= 2)
				eventdat += "<br>Но смотря на нашу командду генокрады вряд-ли будут среди нас."
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];eventclose=1'>Идти дальше</a></P>"
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"
				if(prob(10)) // "likely", I didn't say it was guaranteed!
					lings_aboard = min(++lings_aboard,2)
			else
				if(lings_aboard) //less likely to stack lings
					if(prob(20))
						lings_aboard = min(++lings_aboard,2)
				else if(prob(70))
					lings_aboard = min(++lings_aboard,2)

				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];killcrew=1'>Убить своего</a></P>"
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];eventclose=1'>Продолжить путешествие</a></P>"
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"
			canContinueEvent = 1

		if(ORION_TRAIL_LING_ATTACK)
			if(lings_aboard <= 0) //shouldn't trigger, but hey.
				eventdat += "На нас прыгнул генокрад а потом такой ебать а это санекмен насрал говнокодом."
				eventdat += "<br>И ты схватил баг."
			else
				var/ling1 = remove_crewmember()
				var/ling2 = ""
				if(lings_aboard >= 2)
					ling2 = remove_crewmember()

				eventdat += "Неожиданно мы замечаем как некоторые из нашей компании нападают на нас!"
				if(ling2)
					eventdat += "<br>[ling1] становится мясной тушей а [ling2]'s превращает свою руку в клинок!"
				else
					eventdat += "<br>[ling1]'s превращает свою руку в клинок!"

				var/chance2attack = alive*20
				if(prob(chance2attack))
					var/chancetokill = 30*lings_aboard-(5*alive) //eg: 30*2-(10) = 50%, 2 lings, 2 crew is 50% chance
					if(prob(chancetokill))
						var/deadguy = remove_crewmember()
						var/murder_text = pick("The changeling[ling2 ? "s" : ""] bring[ling2 ? "" : "s"] down [deadguy] and disembowel[ling2 ? "" : "s"] them in a spray of gore!", \
						"[ling2 ? pick(ling1, ling2) : ling1] corners [deadguy] and impales them through the stomach!", \
						"[ling2 ? pick(ling1, ling2) : ling1] decapitates [deadguy] in a single cleaving arc!")
						eventdat += "<br>[murder_text]"
					else
						eventdat += "<br><br><b>Я даю пизды[ling2 ? "s":""] и тот сьёбывает от нас! И Я ТАКОЙ РЕЗНЯЯЯЯЯЯЯЯЯ НАХУЙ!!!!!!!!</b>"
						if(ling2)
							food += 30
							lings_aboard = max(0,lings_aboard-2)
						else
							food += 15
							lings_aboard = max(0,--lings_aboard)
						eventdat += "<br><i>Ну еда из генокрада конечно хуйня но всё же.</i>\
						<br>Я разделал[ling2 ? "s" : ""] на<b>[ling2 ? "30" : "15"]</b> мяса!"
				else
					eventdat += "<br><br>Я даю пизды[ling2 ? "s":""] <br>[ling2 ? "" : "es"] уползает в вентиляцию."
					if(ling2)
						lings_aboard = max(0,lings_aboard-2)
					else
						lings_aboard = max(0,--lings_aboard)

			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];eventclose=1'>Продолжаем идти дальше</a></P>"
			eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"
			canContinueEvent = 1


		if(ORION_TRAIL_SPACEPORT)
			gameStatus = ORION_STATUS_MARKET
			if(spaceport_raided)
				eventdat += "Карго закрыто потому что кто-то напал на них с оружием."
				if(last_spaceport_action)
					eventdat += "<br><b>Последнее что успел сделать карго</b> [last_spaceport_action]"
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];leave_spaceport=1'>Идти дальше</a></P>"
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];close=1'>Закрыть</a></P>"
			else
				eventdat += "Наша компания не заметила как пришла в карго. Удивительно что вместо денег завхоз требует обмен ресурсами."
				eventdat += "<br>FO = Еда WT - Вода "
				if(last_spaceport_action)
					eventdat += "<br><b>Последнее что было это</b> [last_spaceport_action]"
				eventdat += "<h3><b>Компания:</b></h3>"
				eventdat += english_list(settlers)
				eventdat += "<br><b>Еда: </b>[food] | <b>Вода: </b>[fuel]"
				eventdat += "<br><b>Медикаменты: </b>[engine] | <b>Ткань: </b>[hull] | <b>Свет: </b>[electronics]"


				//If your crew is pathetic you can get freebies (provided you haven't already gotten one from this port)
				if(!spaceport_freebie && (fuel < 20 || food < 20))
					spaceport_freebie++
					var/FU = 10
					var/FO = 10
					var/freecrew = 0
					if(prob(30))
						FU = 25
						FO = 25

					if(prob(10))
						add_crewmember()
						freecrew++

					eventdat += "<br>Завхоз увидел что у вас мало еды и воды, так что теперь вы не помрёте с голоду или от жажды."
					if(freecrew)
						eventdat += "<br>Один из карговцев присоединяется к вам!"

					fuel += FU
					food += FO

				//CREW INTERACTIONS
				eventdat += "<P ALIGN=Right>Управление компанией:</P>"

				//Buy crew
				if(food >= 10 && fuel >= 10)
					eventdat += "<P ALIGN=Right><a href='?src=\ref[src];buycrew=1'>Обменять 10 еды и воды на члена компании</a></P>"
				else
					eventdat += "<P ALIGN=Right>В карго только завхоз - ещё одного члена компании я не смогу добавить к нам</P>"

				//Sell crew
				if(settlers.len > 1)
					eventdat += "<P ALIGN=Right><a href='?src=\ref[src];sellcrew=1'>Отправить за 7 еды и воды работать из компании</a></P>"
				else
					eventdat += "<P ALIGN=Right>Я один в компании - отправить некого работать</P>"

				//BUY/SELL STUFF
				eventdat += "<P ALIGN=Right>Детали:</P>"

				//Engine parts
				if(fuel > 5)
					eventdat += "<P ALIGN=Right><a href='?src=\ref[src];buyparts=1'>Купить медикаментов за 5 воды</a></P>"
				else
					eventdat += "<P ALIGN=Right>Медикаменты закончились</a>"

				//Hull plates
				if(fuel > 5)
					eventdat += "<P ALIGN=Right><a href='?src=\ref[src];buyparts=2'>Купить ткань за 5 воды</a></P>"
				else
					eventdat += "<P ALIGN=Right>Ткань закончилась</a>"

				//Electronics
				if(fuel > 5)
					eventdat += "<P ALIGN=Right><a href='?src=\ref[src];buyparts=3'>Купить запчасти для фонарика за 5 воды</a></P>"
				else
					eventdat += "<P ALIGN=Right>Детали закончились</a>"

				//Trade
				if(fuel > 5)
					eventdat += "<P ALIGN=Right><a href='?src=\ref[src];trade=1'>Воду за еду</a></P>"
				else
					eventdat += "<P ALIGN=Right>You don't have 5FU to trade.</P"

				if(food > 5)
					eventdat += "<P ALIGN=Right><a href='?src=\ref[src];trade=2'>Еду за воду</a></P>"
				else
					eventdat += "<P ALIGN=Right>You don't have 5FO to trade.</P"

				//Raid the spaceport
				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];raid_spaceport=1'>!! Напасть !!</a></P>"

				eventdat += "<P ALIGN=Right><a href='?src=\ref[src];leave_spaceport=1'>Идти дальше</a></P>"


//Add Random/Specific crewmember
/datum/program/orion_trail/proc/add_crewmember(var/specific = "")
	var/newcrew = ""
	if(specific)
		newcrew = specific
	else
		if(prob(50))
			newcrew = pick(first_names_male)
		else
			newcrew = pick(first_names_female)
	if(newcrew)
		settlers += newcrew
		alive++
	return newcrew


//Remove Random/Specific crewmember
/datum/program/orion_trail/proc/remove_crewmember(specific = "", dont_remove = "")
	var/list/safe2remove = settlers
	var/removed = ""
	if(dont_remove)
		safe2remove -= dont_remove
	if(specific && specific != dont_remove)
		safe2remove = list(specific)
	else
		removed = pick(safe2remove)

	if(removed)
		if(lings_aboard && prob(40*lings_aboard)) //if there are 2 lings you're twice as likely to get one, obviously
			lings_aboard = max(0,--lings_aboard)
		settlers -= removed
		alive--
	return removed


/datum/program/orion_trail/proc/win(mob/user)
	gameStatus = ORION_STATUS_START

#undef ORION_TRAIL_WINTURN
#undef ORION_TRAIL_RAIDERS
#undef ORION_TRAIL_FLUX
#undef ORION_TRAIL_ILLNESS
#undef ORION_TRAIL_BREAKDOWN
#undef ORION_TRAIL_LING
#undef ORION_TRAIL_LING_ATTACK
#undef ORION_TRAIL_MALFUNCTION
#undef ORION_TRAIL_COLLISION
#undef ORION_TRAIL_SPACEPORT
#undef ORION_TRAIL_BLACKHOLE
#undef ORION_TRAIL_OLDSHIP
#undef ORION_TRAIL_SEARCH

#undef ORION_STATUS_START
#undef ORION_STATUS_NORMAL
#undef ORION_STATUS_GAMEOVER
#undef ORION_STATUS_MARKET

/////////////////////////////////////////////////////////////
/datum/program/monkeysoftmail
	name = "MonkeySoft E-Mail Client"
	description = "Отправляйте и получайте электронные письма с помощью последней версии почтового клиента MonkeySoft!"
	compatible_os = list("unga OS 94","unga OS")
	does_checks = TRUE
	var/gotmailsound = 'sound/machines/computer/mail.ogg'
	tmp_comp_vars = list(
		"mail_rec" = "Recipient",
		"mail_snd" = "Sender",
		"mail_subj" = "Subject",
		"mail_msg" = "Message",
	)
 //pre-loaded emails for companies so they get notifications
/datum/program/monkeysoftmail/blue/New()
	..()
	tmp_comp_vars["mail_snd"]="mail@blu.ug"
/datum/program/monkeysoftmail/red/New()
	..()
	tmp_comp_vars["mail_snd"]="mail@rednikov.ug"
/datum/program/monkeysoftmail/yellow/New()
	..()
	tmp_comp_vars["mail_snd"]="mail@goldstein.ug"
/datum/program/monkeysoftmail/green/New()
	..()
	tmp_comp_vars["mail_snd"]="mail@kogama.ug"
/datum/program/monkeysoftmail/police/New()
	..()
	tmp_comp_vars["mail_snd"]="mail@police.gov"
/datum/program/monkeysoftmail/does_checks_proc()
	..()
	if (tmp_comp_vars["mail_snd"] && origin)
		if (islist(map.emails[tmp_comp_vars["mail_snd"]]))
			for(var/i, i <= map.emails[tmp_comp_vars["mail_snd"]].len, i++)
				if (istype(map.emails[tmp_comp_vars["mail_snd"]][i], /datum/email))
					var/datum/email/em =  map.emails[tmp_comp_vars["mail_snd"]][i]
					if (!em.read)
						playsound(origin.loc,gotmailsound,60)
						origin.visible_message("<big><font color='yellow'>\icon[getFlatIcon(origin)]У вас новое сообщение!</font></big>")
						return
	return
/datum/program/monkeysoftmail/reset_tmp_vars()
	tmp_comp_vars = list(
		"mail_rec" = "Recipient",
		"mail_snd" = "Sender",
		"mail_subj" = "Subject",
		"mail_msg" = "Message",
	)

/datum/program/monkeysoftmail/do_html(mob/living/human/user)
	if (mainmenu == "---")
		mainmenu = "<h2><font color=#60AFFE>MONKEYSOFT</font> E-MAIL CLIENT</h2><br>"
		mainmenu += "<a href='?src=\ref[src];sendmail=1'>Send e-mail</a>&nbsp;<a href='?src=\ref[src];mail=99999'>Inbox</a>"
		var/mdomain = "monkeysoft.ug"
		switch(user.civilization)
			if ("Rednikov Industries")
				mdomain = "rednikov.ug"
			if ("Giovanni Blu Stocks")
				mdomain = "blu.ug"
			if ("Kogama Kraftsmen")
				mdomain = "kogama.ug"
			if ("Goldstein Solutions")
				mdomain = "goldstein.ug"
			if ("Police")
				mdomain = "police.gov"
		var/cname = "mail@[mdomain]"
		if (user.original_job_title == "Legitimate Business")
			var/uname = "[lowertext(replacetext(user.real_name," ","_"))]@[mdomain]"
			uname = replacetext(uname,"'","")
			cname = uname
		if (tmp_comp_vars["mail_snd"] == "Sender")
			tmp_comp_vars["mail_snd"] = cname
		mainbody = "<b>Logged in as <i>[cname]</i></b><br>"
		if (islist(map.emails[cname]) && map.emails[cname].len>=1)
			for(var/i = map.emails[cname].len, i > 0, i--)
				if (istype(map.emails[cname][i], /datum/email))
					var/datum/email/em =  map.emails[cname][i]
					if (em.read)
						mainbody += "<a href='?src=\ref[src];mail=[i]'>[em.date] ([em.sender]): [em.subject]</a><br>"
					else
						mainbody += "<b><i>(NEW)</i> <a href='?src=\ref[src];mail=[i]'>[em.date] ([em.sender]): [em.subject]</b></a><br>"
	..()

/datum/program/monkeysoftmail/Topic(href, href_list, hsrc)
	..()
	mainbody = ""
	var/mdomain = "monkeysoft.ug"
	switch(user.civilization)
		if ("Rednikov Industries")
			mdomain = "rednikov.ug"
		if ("Giovanni Blu Stocks")
			mdomain = "blu.ug"
		if ("Kogama Kraftsmen")
			mdomain = "kogama.ug"
		if ("Goldstein Solutions")
			mdomain = "goldstein.ug"
		if ("Police")
			mdomain = "police.gov"
	var/cname = "mail@[mdomain]"
	if (user.original_job_title == "Legitimate Business")
		var/uname = "[lowertext(replacetext(user.real_name," ","_"))]@[mdomain]"
		uname = replacetext(uname,"'","")
		cname = uname
	if (tmp_comp_vars["mail_snd"]=="Sender")
		tmp_comp_vars["mail_snd"] = cname
	mainbody = "<b>Logged in as <i>[cname]</i></b><br>"
	if (href_list["mail"])
		if (href_list["mail"]=="99999")
			if (islist(map.emails[cname]) && map.emails[cname].len>=1)
				for(var/i = map.emails[cname].len, i > 0, i--)
					if (istype(map.emails[cname][i], /datum/email))
						var/datum/email/em =  map.emails[cname][i]
						if (em.read)
							mainbody += "<a href='?src=\ref[src];mail=c[i]'>[em.date] ([em.sender]): [em.subject]</a><br>"
						else
							mainbody += "<b><i>(NEW)</i> <a href='?src=\ref[src];mail=c[i]'>[em.date] ([em.sender]): [em.subject]</b></a><br>"

		else
			var/tcode = text2num(replacetext(href_list["mail"],"c",""))
			var/datum/email/chosen = map.emails[cname][tcode]
			chosen.read = TRUE
			mainbody += "---<br>From: <i>[chosen.sender]</i><br>To: <i>[chosen.receiver]</i><br><i>Received at [chosen.date]</i><br>---<br><b>[chosen.subject]</b><br>[chosen.message]<br>"
			mainbody += "<a href='?src=\ref[src];replymail=[tcode]'>Reply</a><br>"

	if (href_list["sendmail"])
		switch(href_list["sendmail"])
			if ("2")
				tmp_comp_vars["mail_rec"] = WWinput(user, "Who to send the e-mail to?","e-mail",cname,list("mail@rednikov.ug","mail@kogama.ug","mail@goldstein.ug","mail@blu.ug","mail@police.gov"))
			if ("3")
				tmp_comp_vars["mail_subj"] = input(user, "What is the subject?","e-mail",tmp_comp_vars["mail_subj"]) as text
			if ("4")
				tmp_comp_vars["mail_msg"] = input(user, "What is the message?","e-mail",tmp_comp_vars["mail_msg"]) as message
			if ("5")
				tmp_comp_vars["mail_snd"] = WWinput(user, "Send from which e-mail account?","e-mail",tmp_comp_vars["mail_snd"],list(cname))

//		mainbody += "From: <a href='?src=\ref[src];sendmail=5'>[tmp_comp_vars["mail_snd"]]</a><br>To: <a href='?src=\ref[src];sendmail=2'>[tmp_comp_vars["mail_rec"]]</a><br>"
		mainbody += "From: [tmp_comp_vars["mail_snd"]]<br>To: <a href='?src=\ref[src];sendmail=2'>[tmp_comp_vars["mail_rec"]]</a><br>"
		mainbody += "Subject: <a href='?src=\ref[src];sendmail=3'>[tmp_comp_vars["mail_subj"]]</a><br><br>"
		mainbody += "Message: <a href='?src=\ref[src];sendmail=4'>[tmp_comp_vars["mail_msg"]]</a><br>"
		mainbody += "<a href='?src=\ref[src];mail_send=1'>Send</a><br>"
	if (href_list["mail_send"])
		var/datum/email/eml = new/datum/email
		eml.subject = tmp_comp_vars["mail_subj"]
		eml.sender = tmp_comp_vars["mail_snd"]
		eml.receiver = tmp_comp_vars["mail_rec"]
		eml.message = tmp_comp_vars["mail_msg"]
		eml.date = roundduration2text()
		map.emails[eml.receiver] += list(eml)
		reset_tmp_vars()
		WWalert(user,"Mail sent successfully!","E-mail Sent")
	if (href_list["replymail"])
		var/tcode = text2num(href_list["replymail"])
		var/datum/email/chosen = map.emails[cname][tcode]
		tmp_comp_vars["mail_subj"] = "RE:[chosen.subject]"
		tmp_comp_vars["mail_snd"] = chosen.receiver
		tmp_comp_vars["mail_rec"] = chosen.sender
		tmp_comp_vars["mail_msg"] = "___________________<br>[chosen.message]"
		mainbody += "From: [chosen.receiver]<br>To: [chosen.sender]<br>"
		mainbody += "Subject: RE:[chosen.subject]<br><br>"
		mainbody += "Message: <a href='?src=\ref[src];sendmail=4'>[tmp_comp_vars["mail_msg"]]</a><br>"
		mainbody += "<a href='?src=\ref[src];mail_send=1'>Send</a><br>"

	sleep(0.5)
	do_html(user)

/////////////////////////////////////////////////
/////////////////////DEEPNET MARKETPLACE/////////
/datum/program/deepnet
	name = "D.E.E.P.N.E.T."
	description = "The not-so-legal marketplace for all your dodgy needs."
	compatible_os = list("unga OS 94","unga OS")

/datum/program/deepnet/do_html(mob/living/human/user)
	if (mainmenu == "---")
		mainmenu = "<h2>D.E.E.P.N.E.T.</h2><br>"
		mainmenu += "<b>Доставка занимает максимум 2 минуты!</i></b><br>"
		mainmenu += "<a href='?src=\ref[src];deepnet=2'>Купить</a>&nbsp;<a href='?src=\ref[src];deepnet=3'>Продать</a>&nbsp;<a href='?src=\ref[src];deepnet=4'>Аккаунт</a><br>"
	..()

/datum/program/deepnet/Topic(href, href_list, hsrc)
	..()
	mainbody = ""
	var/u_account = user.civilization
	if (user.original_job_title == "Legitimate Business")
		u_account = user.name
	if (user.original_job_title == "Citizen")
		u_account = user.name
	if (href_list["deepnet"])
		if (findtext(href_list["deepnet"],"b"))
			var/tcode = replacetext(href_list["deepnet"],"b","")
			var/cost = (map.globalmarketplace[tcode][4])
			if (!istype(user.l_hand, /obj/item/stack/money) && !istype(user.r_hand, /obj/item/stack/money))
				mainbody += "<b>You need to have money in one of your hands!</b>"
				sleep(0.5)
				do_html(user)
				return
			else
				var/obj/item/stack/money/mstack = null
				if (istype(user.l_hand, /obj/item/stack/money))
					mstack = user.l_hand
				else
					mstack = user.r_hand
				if (mstack.value*mstack.amount >= cost)
					mstack.amount -= (cost/mstack.value)
					if (mstack.amount<= 0)
						qdel(mstack)
					var/obj/BO = map.globalmarketplace[tcode][2]
					if (BO)
						BO.forceMove(get_turf(origin))
					map.globalmarketplace[tcode][7] = 0
					mainbody += "You fulfill the order."
					var/seller = map.globalmarketplace[tcode][1]
					map.marketplaceaccounts[seller] += cost
					map.globalmarketplace -= map.globalmarketplace[tcode]
					sleep(0.5)
					do_html(user)
					return
				else
					mainbody += "<b>Not enough money!</b>"
					sleep(0.5)
					do_html(user)
					return

		if (findtext(href_list["deepnet"],"ch"))
			var/tcode = replacetext(href_list["deepnet"],"ch","")
			var/cost = (map.globalmarketplace[tcode][4])
			var/newprice = input(user, "What shall the new price be, in dollars?","DEEPNET",cost/4) as num|null
			if (!isnum(newprice))
				return
			if (newprice <= 0)
				return
			map.globalmarketplace[tcode][4] = newprice*4
			mainbody += "You update the listing's price."
			sleep(0.5)
			do_html(user)
			return
		if (findtext(href_list["deepnet"],"cn"))
			var/tcode = replacetext(href_list["deepnet"],"cn","")
			var/obj/BO = map.globalmarketplace[tcode][2]
			BO.forceMove(get_turf(origin))
			map.globalmarketplace[tcode][7] = 0
			map.globalmarketplace -= map.globalmarketplace[tcode]
			mainbody += "You cancel your sell order and get your items back."
			sleep(0.5)
			do_html(user)
			return
		switch(href_list["deepnet"])
			if ("2") //buy
				var/list/currlist = list()
				for (var/i in map.globalmarketplace)
					if (map.globalmarketplace[i][7]==1 && map.globalmarketplace[i][5]=="deepnet")
						currlist += list(list(map.globalmarketplace[i][6],"[istype(map.globalmarketplace[i][2],/obj/item/stack) ? "[map.globalmarketplace[i][3]] of " : ""] <b>[map.globalmarketplace[i][2]]</b>, for [map.globalmarketplace[i][4]/4] dollars (<i>by [map.globalmarketplace[i][1]]</i>)"))
				if (isemptylist(currlist))
					mainbody += "<b>There are no orders on the DEEPNET!</b>"
				for (var/list/k in currlist)
					mainbody += "<a href='?src=\ref[src];deepnet=b[k[1]]'>[k[2]]</a><br>"
			if ("3","6","7","8") //sell
				mainbody += "<a href='?src=\ref[src];deepnet=6'>Add New</a>&nbsp;<a href='?src=\ref[src];deepnet=7'>Change</a>&nbsp;<a href='?src=\ref[src];deepnet=8'>Cancel</a><br><br>"
				if (href_list["deepnet"] == "6") //add
					var/obj/item/M = user.get_active_hand()
					if (M && istype(M))
						if (istype(M, /obj/item/stack))
							var/obj/item/stack/ST = M
							if (ST.amount <= 0)
								return
							else
								var/price = input(user, "What price do you want to place the [ST.amount] [ST] for sale in the DEEPNET? (in dollars) 0 to cancel.") as num|null
								if (!isnum(price))
									return
								if (price <= 0)
									return
								else
									//owner, object, amount, price, sale/buy, fulfilled
									var/idx = rand(1,999999)
									map.globalmarketplace += list("[idx]" = list(u_account,ST,ST.amount,price*4,"deepnet","[idx]",1))
									user.drop_from_inventory(ST)
									ST.forceMove(locate(0,0,0))
									mainbody += "You place \the [ST] for sale in the <b>DEEPNET</b>."
									sleep(0.5)
									do_html(user)
									return
						else
							var/price = input(user, "What price do you want to place the [M] for sale in the DEEPNET? (in dollars).") as num|null
							if (!isnum(price))
								return
							if (price <= 0)
								return
							else
								//owner, object, amount, price, sale/buy, id number, fulfilled
								var/idx = rand(1,999999)
								map.globalmarketplace += list("[idx]" = list(user.civilization,M,1,price*4,"deepnet","[idx]",1))
								user.drop_from_inventory(M)
								M.forceMove(locate(0,0,0))
								mainbody += "You place \the [M] for sale in the <b>DEEPNET</b>."
								sleep(0.5)
								do_html(user)
								return
					else
						WWalert(user,"Failed to create the order! You need to have the item in your active hand.","DEEPNET")
				if (href_list["deepnet"] == "7") //change
					var/list/currlist = list()
					for (var/i in map.globalmarketplace)
						if (map.globalmarketplace[i][1] == u_account)
							currlist += list(list(map.globalmarketplace[i][6],"[istype(map.globalmarketplace[i][2],/obj/item/stack) ? "[map.globalmarketplace[i][3]] of " : ""] <b>[map.globalmarketplace[i][2]]</b>, for [map.globalmarketplace[i][4]/4] dollars (<i>by [map.globalmarketplace[i][1]]</i>)"))
					if (isemptylist(currlist))
						mainbody += "You have no orders on the market!"
						sleep(0.5)
						do_html(user)
						return
					for (var/list/k in currlist)
						mainbody += "<a href='?src=\ref[src];deepnet=ch[k[1]]'>[k[2]]</a><br>"
				if (href_list["deepnet"] == "8") //cancel
					var/list/currlist = list()
					for (var/i in map.globalmarketplace)
						if (map.globalmarketplace[i][1] == u_account)
							currlist += list(list(map.globalmarketplace[i][6],"[istype(map.globalmarketplace[i][2],/obj/item/stack) ? "[map.globalmarketplace[i][3]] of " : ""] <b>[map.globalmarketplace[i][2]]</b>, for [map.globalmarketplace[i][4]/4] dollars (<i>by [map.globalmarketplace[i][1]]</i>)"))
					if (isemptylist(currlist))
						mainbody += "You have no orders on the market!"
						sleep(0.5)
						do_html(user)
						return
					for (var/list/k in currlist)
						mainbody += "<a href='?src=\ref[src];deepnet=cn[k[1]]'>[k[2]]</a><br>"

			if ("4") //account
				mainbody += "<big>Account: <b>[u_account]</b></big><br><br>"
				var/accmoney = map.marketplaceaccounts[u_account]
				if (map.marketplaceaccounts[u_account])
					if (accmoney <= 0)
						mainbody += "<b>Твой аккаунт пустой!</b>"
						map.marketplaceaccounts[u_account] = 0
					else
						mainbody += "You have [accmoney/4] dollars in your account.<br>"
						mainbody += "<a href='?src=\ref[src];deepnet=5'>Withdraw</a>"
				else
					mainbody += "<b>Твой аккаунт пустой!</b>"
			if ("5") //withdraw
				var/accmoney = map.marketplaceaccounts[u_account]
				if (accmoney > 0)
					var/obj/item/stack/money/dollar/SC = new /obj/item/stack/money/dollar(get_turf(origin))
					SC.amount = accmoney/20
					accmoney = 0
					map.marketplaceaccounts[u_account] = 0
					do_html(user)
	sleep(0.5)
	do_html(user)

///////////////////////////////////////////////////
/////////////////////CARTRADER MARKETPLACE/////////

/datum/program/cartrader
	name = "CARTRADER Platform"
	description = "The number 1 online car dealership."
	compatible_os = list("unga OS 94","unga OS")

/datum/program/cartrader/do_html(mob/living/human/user)
	if (mainmenu == "---")
		var/list/choice = list("Yamasaki M125 motorcycle (160)","ASNO Piccolino (400)","ASNO Quattroporte (500)","Yamasaki Kazoku (600)","SMC Wyoming (700)","SMC Falcon (750)","Ubermacht Erstenklasse (800)","Yamasaki Shinobu 5000 (900)")
		mainmenu = "<h2>CARTRADER NETWORK</h2><br>"
		for (var/i in choice)
			mainbody += "<a href='?src=\ref[src];cartrader=[i]'>[i]</a><br>"
	..()

/datum/program/cartrader/Topic(href, href_list, hsrc)
	..()
	mainbody = ""
	if (href_list["carlist"])
		var/list/choice = list("Yamasaki M125 motorcycle (160)","ASNO Piccolino (400)","ASNO Quattroporte (500)","Yamasaki Kazoku (600)","SMC Wyoming (700)","SMC Falcon (750)","Ubermacht Erstenklasse (800)","Yamasaki Shinobu 5000 (900)")
		for (var/i in choice)
			mainbody += "<a href='?src=\ref[src];cartrader=[i]'>[i]</a><br>"
		sleep(0.5)
		do_html(user)
	if (href_list["cartrader"])
		var/found = FALSE
		for(var/turf/T in get_area_turfs(/area/caribbean/supply))
			if (found)
				break
			for (var/obj/structure/ST in T)
				found = TRUE
				break
			for (var/mob/living/human/HT in T)
				found = TRUE
				break
		if (found)
			mainbody = "<h2>CARTRADER NETWORK</h2><br><font color='yellow'>Clear the arrival area first.</font><br><a href='?src=\ref[src];carlist=1'>Return to List</a><br>"
			sleep(0.5)
			do_html(user)
			return
		var/c_cost = splittext(href_list["cartrader"],"(")[2]
		c_cost = replacetext(href_list["cartrader"],"(","")
		c_cost = text2num(href_list["cartrader"])
		if (href_list["cartrader"] == "Yamasaki M125 motorcycle (160)")
			if (istype(user.get_active_hand(),/obj/item/stack/money) || istype(user.get_inactive_hand(),/obj/item/stack/money))
				var/obj/item/stack/money/D
				if (istype(user.get_active_hand(),/obj/item/stack/money))
					D = user.get_active_hand()
				else if (istype(user.get_inactive_hand(),/obj/item/stack/money))
					D = user.get_inactive_hand()
				if (D && D.value*D.amount >= c_cost*4)
					D.amount-=c_cost/5
				else
					mainbody = "<h2>CARTRADER NETWORK</h2><br><font color='yellow'>Not enough money!</font><br><a href='?src=\ref[src];carlist=1'>Return to List</a><br>"
					sleep(0.5)
					do_html(user)
					return
			else
				mainbody = "<h2>CARTRADER NETWORK</h2><br><font color='yellow'>Not enough money!</font><br><a href='?src=\ref[src];carlist=1'>Return to List</a><br>"
				sleep(0.5)
				do_html(user)
				return
			new /obj/structure/vehicle/motorcycle/m125/full(locate(origin.x+4,origin.y-1,origin.z))
			new /obj/item/clothing/head/helmet/motorcycle(locate(origin.x+4,origin.y-1,origin.z))
			return
		else
			var/obj/effects/premadevehicles/PV
			var/chosencolor = WWinput(user,"Which color do you want?","Car Purchase","Black",list("Black","Red","Blue","Green","Yellow","Dark Grey","Light Grey","White"))
			var/basecolor = chosencolor
			switch(chosencolor)
				if ("Black")
					chosencolor = "#181717"
				if ("Light Grey")
					chosencolor = "#919191"
				if ("Dark Grey")
					chosencolor = "#616161"
				if ("White")
					chosencolor = "#FFFFFF"
				if ("Green")
					chosencolor = "#007F00"
				if ("Red")
					chosencolor = "#7F0000"
				if ("Yellow")
					chosencolor = "#b8b537"
				if ("Blue")
					chosencolor = "#00007F"
			for(var/turf/T in get_area_turfs(/area/caribbean/supply))
				if (found)
					break
				for (var/obj/structure/ST in T)
					found = TRUE
					break
				for (var/mob/living/human/HT in T)
					found = TRUE
					break
			if (found)
				mainbody = "<h2>CARTRADER NETWORK</h2><br><font color='yellow'>Clear the arrival area first.</font><br><a href='?src=\ref[src];carlist=1'>Return to List</a><br>"
				sleep(0.5)
				do_html(user)
				return
			if (istype(user.get_active_hand(),/obj/item/stack/money) || istype(user.get_inactive_hand(),/obj/item/stack/money))
				var/obj/item/stack/money/D
				if (istype(user.get_active_hand(),/obj/item/stack/money))
					D = user.get_active_hand()
				else if (istype(user.get_inactive_hand(),/obj/item/stack/money))
					D = user.get_inactive_hand()
				if (D && D.value*D.amount >= c_cost*4)
					D.amount-=c_cost/5
				else
					mainbody = "<h2>CARTRADER NETWORK</h2><br><font color='yellow'>Not enough money!</font><br><a href='?src=\ref[src];carlist=1'>Return to List</a><br>"
					sleep(0.5)
					do_html(user)
					return
			else
				mainbody = "<h2>CARTRADER NETWORK</h2><br><font color='yellow'>Not enough money!</font><br><a href='?src=\ref[src];carlist=1'>Return to List</a><br>"
				sleep(0.5)
				do_html(user)
				return
			if (href_list["cartrader"] == "ASNO Quattroporte (500)")
				PV = new /obj/effects/premadevehicles/asno/quattroporte(locate(origin.x+3,origin.y-3,origin.z))
				spawn(5)
					map.vehicle_registations += list(list("[PV.reg_number]",user.civilization, "ASNO Quattroporte", basecolor))

			else if (href_list["cartrader"] == "ASNO Piccolino (400)")
				PV = new /obj/effects/premadevehicles/asno/piccolino(locate(origin.x+3,origin.y-3,origin.z))
				spawn(5)
					map.vehicle_registations += list(list("[PV.reg_number]",user.civilization, "ASNO Piccolino", basecolor))

			else if (href_list["cartrader"] == "Ubermacht Erstenklasse (800)")
				PV = new /obj/effects/premadevehicles/ubermacht/erstenklasse(locate(origin.x+3,origin.y-3,origin.z))
				spawn(5)
					map.vehicle_registations += list(list("[PV.reg_number]",user.civilization, "Ubermacht Erstenklasse", basecolor))

			else if (href_list["cartrader"] == "SMC Falcon (750)")
				PV = new /obj/effects/premadevehicles/smc/falcon(locate(origin.x+3,origin.y-3,origin.z))
				spawn(5)
					map.vehicle_registations += list(list("[PV.reg_number]",user.civilization, "SMC Falcon", basecolor))

			else if (href_list["cartrader"] == "Yamasaki Kazoku (600)")
				PV = new /obj/effects/premadevehicles/yamasaki/kazoku(locate(origin.x+3,origin.y-3,origin.z))
				spawn(5)
					map.vehicle_registations += list(list("[PV.reg_number]",user.civilization, "Yamasaki Kazoku", basecolor))

			else if (href_list["cartrader"] == "Yamasaki Shinobu 5000 (900)")
				PV = new /obj/effects/premadevehicles/yamasaki/shinobu(locate(origin.x+3,origin.y-3,origin.z))
				spawn(5)
					map.vehicle_registations += list(list("[PV.reg_number]",user.civilization, "Yamasaki Shinobu 5000", basecolor))
			else if  (href_list["cartrader"] == "SMC Wyoming (700)")
				PV = new /obj/effects/premadevehicles/smc/wyoming(locate(origin.x+3,origin.y-3,origin.z))
				spawn(5)
					map.vehicle_registations += list(list("[PV.reg_number]",user.civilization, "SMC Wyoming", basecolor))

			PV.custom_color = chosencolor
			PV.doorcode = rand(1000,9999)
			PV.new_number()
			var/obj/item/weapon/key/civ/C = new /obj/item/weapon/key/civ(origin.loc)
			C.name = "[PV.reg_number] key"
			C.icon_state = "modern"
			C.code = PV.doorcode
			var/obj/item/weapon/key/civ/C2 = new /obj/item/weapon/key/civ(origin.loc)
			C2.name = "[PV.reg_number] key"
			C2.icon_state = "modern"
			C2.code = PV.doorcode

////////////////////////////POLICE STUFF//////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
/datum/program/squadtracker
	name = "Squad-Trak"
	description = "Tracks the location of your squad."
	compatible_os = list("unga OS 94","unga OS 94 Police Edition")

/datum/program/squadtracker/do_html(mob/living/human/user)
	mainmenu = "<h2>SQUAD STATUS</h2><br>"
	if (origin.operatingsystem == "unga OS 94 Police Edition" && user.civilization != "Police" && user.civilization != "Paramedics")
		mainbody = "<font color ='red'><b>ACCESS DENIED</b></font>"
	else
		mainbody = ""
		for(var/mob/living/human/H in player_list)
			if (H.civilization == user.civilization)
				var/tst = ""
				if (H.stat == UNCONSCIOUS)
					tst = "(Unresponsive)"
				else if (H.stat == DEAD)
					tst = "(Dead)"
				mainbody += "<b>[H.name]</b> at <b>[H.get_coded_loc()]</b> ([H.x],[H.y]) <b><i>[tst]</i></b><br>"
	..()

/datum/program/licenseplates
	name = "License Plate Registry"
	description = "Connects to the main Police server to check updated status on license plates."
	compatible_os = list("unga OS 94 Police Edition")

/datum/program/licenseplates/do_html(mob/living/human/user)
	mainmenu = "<h2>LICENSE PLATE DATABASE</h2><br>"
	if (user.civilization != "Police")
		mainbody = "<font color ='red'><b>ACCESS DENIED</b></font>"
	else
		mainbody = ""
		for(var/list/L in map.vehicle_registations)
			mainbody += "<b>[L[1]]</b> - <b>[L[4]] [L[3]]</b> - registered to <b>[L[2]]</b><br>"
	..()
/datum/program/permits
	name = "Gun Permit Registry"
	description = "Connects to the main Police server for automated gun permit requests."
	compatible_os = list("unga OS 94 Police Edition")

/datum/program/permits/do_html(mob/living/human/user)
	mainmenu = "<h2>GUN PERMITS</h2><br>"
	mainmenu += "<a href='?src=\ref[src];permits=1'>Request Permit</a>"
	if (user.civilization == "Police" || user.civilization == "Paramedics")
		mainbody = "<font color='yellow'>This service is intended for civilians.</font>"
	..()

/datum/program/permits/Topic(href, href_list, hsrc)
	mainbody = ""
	if (href_list["permits"])
		if (user.civilization == "Police" || user.civilization == "Paramedics")
			mainbody = "<font color='yellow'>This service is intended for civilians.</font>"
			sleep(0.5)
			do_html(user)
			return
		else if (user.gun_permit)
			mainbody += "<font color='green'>You are already licenced.</font>"
			sleep(0.5)
			do_html(user)
			return
		else if  (user.civilization in map.warrants)
			mainbody += "<font color='red'>All the members of your company have had their gun permits revoked and the issue of new ones forbidden for murdering police officers.</font>"
			sleep(0.5)
			do_html(user)
			return
		else if  (user.real_name in map.warrants)
			mainbody += "<font color='red'>You have, or had, a warrant in your name, so your request was <b>denied</b>.</font>"
			sleep(0.5)
			do_html(user)
			return
		else
			if (istype(user.get_active_hand(),/obj/item/stack/money) || istype(user.get_inactive_hand(),/obj/item/stack/money))
				var/obj/item/stack/money/M
				if (istype(user.get_active_hand(),/obj/item/stack/money))
					M = user.get_active_hand()
				else if (istype(user.get_inactive_hand(),/obj/item/stack/money))
					M = user.get_inactive_hand()
				if (M && M.value*M.amount >= 100*4)
					M.amount-=100/5
					if (M.amount <= 0)
						qdel(M)
				else
					mainbody += "<font color='red'>Not enough money! You need to have 100 dollars in your hands to pay for the permit.</font>"
					sleep(0.5)
					do_html(user)
					return
				user.gun_permit = TRUE
				mainbody += "<font color='green'>Your licence was <b>approved</b>.</span>"
				map.scores["Police"] += 100
			else
				mainbody += "<font color='red'>You need to have 100 dollars in your hands to pay for the permit.</span>"
				sleep(0.5)
				do_html(user)
				return
	sleep(0.5)
	do_html(user)
/datum/program/warrants
	name = "Warrant Terminal"
	description = "Connects to the main Police server for up-to-date information on pending warrants."
	compatible_os = list("unga OS 94 Police Edition")

/datum/program/warrants/do_html(mob/living/human/user)
	if (mainmenu == "---")
		mainmenu = "<h2>WARRANT TERMINAL</h2><br>"
		mainmenu += "<a href='?src=\ref[src];warrants=2'>List Warrants</a>&nbsp;<a href='?src=\ref[src];warrants=3'>Register Suspect</a>"
	..()
/datum/program/warrants/Topic(href, href_list, hsrc)
	mainbody = ""
	if (href_list["warrants"])
		if (href_list["warrants"] == "2")
			for(var/obj/item/weapon/paper/police/warrant/SW in map.pending_warrants)
				mainbody += "[SW.arn]: [SW.tgt], working for [SW.tgtcmp] <a href='?src=\ref[src];warrants=w[SW.arn]'>(print)</a><br>"

		if (findtext(href_list["warrants"],"w"))
			if (user.civilization != "Police")
				mainbody += "<font color ='red'><b>ACCESS DENIED</b></font>"
				sleep(0.5)
				do_html(user)
				return
			else
				var/tcode = replacetext(href_list["warrants"],"w","")
				for(var/obj/item/weapon/paper/police/warrant/SW in map.pending_warrants)
					if (SW.arn == text2num(tcode))
						var/obj/item/weapon/paper/police/warrant/NW = new/obj/item/weapon/paper/police/warrant(origin.loc)
						NW.tgt_mob = SW.tgt_mob
						NW.tgt = SW.tgt
						NW.tgtcmp = SW.tgtcmp
						NW.reason = SW.reason
						NW.arn = SW.arn
						playsound(origin.loc, 'sound/machines/printer.ogg', 100, TRUE)
						mainbody += "Sucessfully printed warrant number [tcode]."
						sleep(0.5)
						do_html(user)
						return
		if (href_list["warrants"] == "3")
			if (user.civilization != "Police" && user.civilization != "Paramedics")
				var/done = FALSE
				var/found = FALSE
				for (var/mob/living/human/S in range(2,src))
					if (S.civilization != user.civilization && S.handcuffed && S != user)
						found = TRUE
						for(var/obj/item/weapon/paper/police/warrant/SW in map.pending_warrants)
							if (SW.tgt_mob == S)
								map.scores["Police"] += 100
								var/obj/item/stack/money/dollar/DLR = new/obj/item/stack/money/dollar(origin.loc)
								DLR.amount = 20
								DLR.update_icon()
								done = TRUE
								mainbody += "<font color='green'>Processed warrant no. <b>[SW.arn]</b> for <b>[SW.tgt]</b>, as a citizens arrest. Thank you for your service.</font>"
								map.pending_warrants -= SW
								SW.forceMove(null)
								qdel(SW)
								for(var/mob/living/human/HP in player_list)
									if (HP.civilization == "Police")
										HP << "<big><font color='yellow'>A suspect with a pending warrant has been dropped off at the Police station by a citizens arrest.</font></big>"
					if (!done && found)
						mainbody += "<font color='yellow'>There are no outstanding warrants for any of the suspects.</font>"
					else if (!done && !found)
						mainbody += "<font color='yellow'>There are no suspects present.</font>"
					else
						mainbody += "<font color='yellow'>There are no outstanding warrants for any of the suspects.</font>"
					sleep(0.5)
					do_html(user)
					return
			else
				var/done = FALSE
				var/found = FALSE
				for (var/mob/living/human/S in range(2,src))
					found = TRUE
					for(var/obj/item/weapon/paper/police/warrant/SW in map.pending_warrants)
						if (SW.tgt_mob == S)
							map.scores["Police"] += 300
							done = TRUE
							mainbody += "<font color='green'>Processed warrant no. <b>[SW.arn]</b> for <b>[SW.tgt]</b>.</font>"
							map.pending_warrants -= SW
							SW.forceMove(null)
							qdel(SW)
				if (!done && found)
					mainbody += "<font color='yellow'>There are no outstanding warrants for any of the suspects.</font>"
				else if (!done && !found)
					mainbody += "<font color='yellow'>There are no suspects present.</font>"
				else
					mainbody += "<font color='yellow'>There are no outstanding warrants for any of the suspects.</font>"
	sleep(0.5)
	do_html(user)

/datum/program/gunregistry
	name = "Firearm Database"
	description = "Connects to the main Police server to check updated status on all legally owned guns."
	compatible_os = list("unga OS 94 Police Edition")

/datum/program/gunregistry/do_html(mob/living/human/user)
	mainmenu = "<h2>FIREARM REGISTRY DATABASE</h2><br>"
	mainbody = ""
	if (user.civilization != "Police")
		mainbody += "<font color ='red'><b>ACCESS DENIED</b></font>"
		return
	else
		for(var/list/L in map.gun_registations)
			mainbody += "<b>[L[1]] (no. [L[2]])</b> - registered to <b>[L[3]]</b><br>"
	..()


/////////////////////////////////////////////////////////
/////////////////////NILE.UG MARKETPLACE/////////////////
////////////////A legal shop for non-gun stuff///////////
/datum/program/nilestore
	name = "nile.ug Store"
	description = "The internet store for all your shopping needs."
	compatible_os = list("unga OS 94","unga OS")

/datum/program/nilestore/do_html(mob/living/human/user)
	if (mainmenu == "---")
		mainmenu = "<h2><font color=#C19A6B>nile</font>.ug</h2><br>"
		mainmenu += "<b>We deliver worldwide!</i></b><br>"
		mainmenu += "<a href='?src=\ref[src];nile=2'>Buy</a>&nbsp;<a href='?src=\ref[src];nile=3'>Sell</a>&nbsp;<a href='?src=\ref[src];nile=4'>Account</a><br>"
	..()

/datum/program/nilestore/Topic(href, href_list, hsrc)
	..()
	mainbody = ""
	if (href_list["nile"])
		if (findtext(href_list["nile"],"b"))
			var/tcode = replacetext(href_list["nile"],"b","")
			var/cost = text2num(map.globalmarketplace[tcode][4])
			if (!istype(user.l_hand, /obj/item/stack/money) && !istype(user.r_hand, /obj/item/stack/money))
				mainbody += "<b>You need to have money in one of your hands!</b>"
				sleep(0.5)
				do_html(user)
				return
			else
				var/obj/item/stack/money/mstack = null
				if (istype(user.l_hand, /obj/item/stack/money))
					mstack = user.l_hand
				else
					mstack = user.r_hand
				if (mstack.value*mstack.amount >= cost)
					mstack.amount -= (cost/mstack.value)
					if (mstack.amount<= 0)
						qdel(mstack)
					var/obj/BO = map.globalmarketplace[tcode][2]
					if (BO)
						BO.forceMove(get_turf(origin))
					map.globalmarketplace[tcode][7] = 0
					mainbody += "You fulfill the order."
					var/seller = map.globalmarketplace[tcode][1]
					map.marketplaceaccounts[seller] += cost
					map.globalmarketplace -= map.globalmarketplace[tcode]
					sleep(0.5)
					do_html(user)
					return
				else
					mainbody += "<b>Not enough money!</b>"
					sleep(0.5)
					do_html(user)
					return

		if (findtext(href_list["nile"],"ch"))
			var/tcode = replacetext(href_list["nile"],"ch","")
			var/cost = text2num(map.globalmarketplace[tcode][4])
			var/newprice = input(user, "What shall the new price be, in dollars?","nile.ug",cost/4) as num|null
			if (!isnum(newprice))
				return
			if (newprice <= 0)
				return
			map.globalmarketplace[tcode][4] = newprice*4
			mainbody += "You update the listing's price."
			sleep(0.5)
			do_html(user)
			return
		if (findtext(href_list["nile"],"cn"))
			var/tcode = replacetext(href_list["nile"],"cn","")
			var/obj/BO = map.globalmarketplace[tcode][2]
			BO.forceMove(get_turf(origin))
			map.globalmarketplace[tcode][7] = 0
			map.globalmarketplace -= map.globalmarketplace[tcode]
			mainbody += "You cancel your sell order and get your items back."
			sleep(0.5)
			do_html(user)
			return
		switch(href_list["nile"])
			if ("2") //buy
				var/list/currlist = list()
				for (var/i in map.globalmarketplace)
					if (map.globalmarketplace[i][7]==1 && map.globalmarketplace[i][5]=="nile")
						currlist += list(list(map.globalmarketplace[i][6],"[istype(map.globalmarketplace[i][2],/obj/item/stack) ? "[map.globalmarketplace[i][3]] of " : ""] <b>[map.globalmarketplace[i][2]]</b>, for [map.globalmarketplace[i][4]/4] dollars (<i>by [map.globalmarketplace[i][1]]</i>)"))
				if (isemptylist(currlist))
					mainbody = "<b>We do not currently have any stock. Sorry for the incovenience.</b>"
				else

					for (var/list/k in currlist)
						mainbody += "<a href='?src=\ref[src];nile=b[k[1]]'>[k[2]]</a><br>"
			if ("3","6","7","8") //sell
				mainbody = "<a href='?src=\ref[src];nile=6'>Add New</a>&nbsp;<a href='?src=\ref[src];nile=7'>Change</a>&nbsp;<a href='?src=\ref[src];nile=8'>Cancel</a><br><br>"
				if (href_list["nile"] == "6") //add
					var/obj/item/M = user.get_active_hand()
					if (M && istype(M))
						if (istype(M, /obj/item/stack))
							var/obj/item/stack/ST = M
							if (ST.amount <= 0)
								return
							else
								var/price = input(user, "What price do you want to place the [ST.amount] [ST] for sale in the nile? (in dollars) 0 to cancel.") as num|null
								if (!isnum(price))
									return
								if (price <= 0)
									return
								else
									//owner, object, amount, price, sale/buy, fulfilled
									var/idx = rand(1,999999)
									map.globalmarketplace += list("[idx]" = list(user.civilization,ST,ST.amount,price*4,"nile","[idx]",1))
									user.drop_from_inventory(ST)
									ST.forceMove(locate(0,0,0))
									mainbody += "You place \the [ST] for sale at <b>nile.ug</b>."
									sleep(0.5)
									do_html(user)
									return
						else
							var/price = input(user, "What price do you want to place the [M] for sale at nile.ug? (in dollars).") as num|null
							if (!isnum(price))
								return
							if (price <= 0)
								return
							else
								//owner, object, amount, price, sale/buy, id number, fulfilled
								var/idx = rand(1,999999)
								map.globalmarketplace += list("[idx]" = list(user.civilization,M,1,price*4,"nile","[idx]",1))
								user.drop_from_inventory(M)
								M.forceMove(locate(0,0,0))
								mainbody += "You place \the [M] for sale in the <b>nile.ug</b>."
								sleep(0.5)
								do_html(user)
								return
					else
						WWalert(user,"Failed to create the order! You need to have the item in your active hand.","nile.ug")
				if (href_list["nile"] == "7") //change
					var/list/currlist = list()
					for (var/i in map.globalmarketplace)
						if (map.globalmarketplace[i][1] == user.civilization)
							currlist += list(list(map.globalmarketplace[i][6],"[istype(map.globalmarketplace[i][2],/obj/item/stack) ? "[map.globalmarketplace[i][3]] of " : ""] <b>[map.globalmarketplace[i][2]]</b>, for [map.globalmarketplace[i][4]/4] dollars (<i>by [map.globalmarketplace[i][1]]</i>)"))
					if (isemptylist(currlist))
						mainbody = "You have no orders on the market!"
						sleep(0.5)
						do_html(user)
						return
					for (var/list/k in currlist)
						mainbody += "<a href='?src=\ref[src];nile=ch[k[1]]'>[k[2]]</a><br>"
				if (href_list["nile"] == "8") //cancel
					var/list/currlist = list()
					for (var/i in map.globalmarketplace)
						if (map.globalmarketplace[i][1] == user.civilization)
							currlist += list(list(map.globalmarketplace[i][6],"[istype(map.globalmarketplace[i][2],/obj/item/stack) ? "[map.globalmarketplace[i][3]] of " : ""] <b>[map.globalmarketplace[i][2]]</b>, for [map.globalmarketplace[i][4]/4] dollars (<i>by [map.globalmarketplace[i][1]]</i>)"))
					if (isemptylist(currlist))
						mainbody = "You have no orders on the market!"
						sleep(0.5)
						do_html(user)
						return
					for (var/list/k in currlist)
						mainbody += "<a href='?src=\ref[src];nile=cn[k[1]]'>[k[2]]</a><br>"

			if ("4") //account
				mainbody = "<big>Account: <b>[user.civilization]</b></big><br><br>"
				var/accmoney = map.marketplaceaccounts[user.civilization]
				if (map.marketplaceaccounts[user.civilization])
					if (accmoney <= 0)
						mainbody += "<b>Твой аккаунт пустой!</b>"
						map.marketplaceaccounts[user.civilization] = 0
					else
						mainbody += "You have [accmoney/4] dollars in your company's account.<br>"
						mainbody += "<a href='?src=\ref[src];nile=5'>Withdraw</a>"
				else
					mainbody += "<b>Твой аккаунт пустой!</b>"
			if ("5") //withdraw
				var/accmoney = map.marketplaceaccounts[user.civilization]
				if (accmoney > 0)
					var/obj/item/stack/money/dollar/SC = new /obj/item/stack/money/dollar(get_turf(origin))
					SC.amount = accmoney/20
					accmoney = 0
					map.marketplaceaccounts[user.civilization] = 0
					do_html(user)
	sleep(0.5)
	do_html(user)


/////////////////////////////////////////////////////////
/////////////////////E-LEKTRA SHOP/////////////////////////
////////////////Where companies can get percursors///////////
/datum/program/elektra
	name = "E-LEKTRA Store"
	description = "Suppliers of the basic materials for tech production."
	compatible_os = list("unga OS 94","unga OS")

/datum/program/elektra/do_html(mob/living/human/user)
	if (mainmenu == "---")
		mainmenu = "<h2><font color='yellow'>E</font><font color='orange'>-LEKTRA</font> STORE</h2><br>"
		mainmenu += "<b>Доставляем хим кристалы для разработки чипов!</i></b><br>"
		mainmenu += "<b>Теперь на Русском языке!</i></b><br>"
		mainmenu += "<a href='?src=\ref[src];elektra=2'>Buy</a><br>"
	..()

/datum/program/elektra/Topic(href, href_list, hsrc)
	..()
	mainbody = ""
	switch(href_list["elektra"])
		if ("3")
			if (!istype(user.l_hand, /obj/item/stack/money) && !istype(user.r_hand, /obj/item/stack/money))
				mainbody = "<b>You need to have money in one of your hands!</b>"
				sleep(0.5)
				do_html(user)
				return
			else
				var/chosenprec
				switch(map.assign_precursors[user.civilization])
					if ("indigon crystals")
						chosenprec = map.precursor_stocks["indigon crystals"]
					if ("crimsonite crystals")
						chosenprec = map.precursor_stocks["crimsonite crystals"]
					if ("verdine crystals")
						chosenprec = map.precursor_stocks["verdine crystals"]
					if ("galdonium crystals")
						chosenprec = map.precursor_stocks["galdonium crystals"]
				var/forsale
				switch(map.assign_precursors[user.civilization])
					if ("indigon crystals")
						forsale = /obj/item/stack/precursor/blue
					if ("crimsonite crystals")
						forsale = /obj/item/stack/precursor/red
					if ("verdine crystals")
						forsale = /obj/item/stack/precursor/green
					if ("galdonium crystals")
						forsale = /obj/item/stack/precursor/yellow
				var/obj/item/stack/money/mstack = null
				if (istype(user.l_hand, /obj/item/stack/money))
					mstack = user.l_hand
				else
					mstack = user.r_hand
				if (mstack.value*mstack.amount >= chosenprec[2])
					mstack.amount -= (chosenprec[2]/mstack.value)
					if (mstack.amount<= 0)
						qdel(mstack)
					if (!forsale)
						mainbody = "Authentication Error!"
						sleep(0.5)
						do_html(user)
					var/obj/item/stack/precursor/PR = new forsale(null)
					if (PR)
						PR.forceMove(get_turf(origin))
					mainbody = "You fulfill the order."
					chosenprec[2] = min(360,round(chosenprec[2]*1.1))
					chosenprec[1] -= 1
					sleep(0.5)
					do_html(user)
					return
				else
					mainbody = "<b>Not enough money!</b>"
					sleep(0.5)
					do_html(user)
					return

		if ("2") //buy
			var/forsale
			switch(user.civilization)
				if ("Rednikov Industries")
					forsale = map.assign_precursors["Rednikov Industries"]
				if ("Giovanni Blu Stocks")
					forsale = map.assign_precursors["Giovanni Blu Stocks"]
				if ("Kogama Kraftsmen")
					forsale = map.assign_precursors["Kogama Kraftsmen"]
				if ("Goldstein Solutions")
					forsale = map.assign_precursors["Goldstein Solutions"]

			if (forsale)
				var/cost
				var/available
				switch(map.assign_precursors[user.civilization])
					if ("indigon crystals")
						cost = map.precursor_stocks["indigon crystals"][2]
						available = map.precursor_stocks["indigon crystals"][1]
					if ("crimsonite crystals")
						cost = map.precursor_stocks["crimsonite crystals"][2]
						available = map.precursor_stocks["crimsonite crystals"][1]
					if ("verdine crystals")
						cost = map.precursor_stocks["verdine crystals"][2]
						available = map.precursor_stocks["verdine crystals"][1]
					if ("galdonium crystals")
						cost = map.precursor_stocks["galdonium crystals"][2]
						available = map.precursor_stocks["galdonium crystals"][1]
				if (available>0)
					mainbody = "<a href='?src=\ref[src];elektra=3'>[forsale], [cost/4] dollars ([available] available)</a><br>"
				else
					mainbody = "<b>We are currently out of stock. Please visit soon!</b>"
			else
				mainbody = "<b>We are currently out of stock. Please visit soon!</b>"

	sleep(0.5)
	do_html(user)

/////////////////////////////////////////////////////////////////////////
//////////////////////////////JUNGLE BANK////////////////////////////////
///////For legitimate businessmen to deposit money and buy stocks////////
/datum/program/junglebank
	name = "JUNGLE Bank"
	description = "The oldest bank in the area. Established 313 B.C."
	compatible_os = list("unga OS 94","unga OS")

/datum/program/junglebank/do_html(mob/living/human/user)
	if (mainmenu == "---")
		mainmenu = "<h2>JUNGLE Bank</h2><br>"
		mainmenu += "<b><i>For all your financial needs.</i></b><br>"
		if (user.original_job_title == "Legitimate Business")
			mainmenu += "<a href='?src=\ref[src];bank=2'>Buy Stocks</a>&nbsp;<a href='?src=\ref[src];bank=3'>Sell Stocks</a>&nbsp;<a href='?src=\ref[src];bank=4'>Account</a><br>"
		else
			mainbody = "<font color='red'><b>ACCESS DENIED</b></font><br>"
	..()

/datum/program/junglebank/Topic(href, href_list, hsrc)
	..()
	mainbody = ""
	if (href_list["bank"])
		if (findtext(href_list["bank"],"b"))
			var/tcode = replacetext(href_list["bank"],"b","")
			var/cost = (map.globalmarketplace[tcode][4])
			if (map.marketplaceaccounts[user.name])
				if (map.marketplaceaccounts[user.name] < cost)
					mainbody += "<b>You don't have enough money in your account!<br>You have [map.marketplaceaccounts[user.name]/4] dollars and need [cost/4] dollars.</b>"
					sleep(0.5)
					do_html(user)
					return
				else
					map.globalmarketplace[tcode][7] = 0
					map.globalmarketplace[tcode][2] = user
					mainbody += "You buy the [map.globalmarketplace[tcode][1]] stocks."
					map.marketplaceaccounts[user.name] -= cost
					sleep(0.5)
					do_html(user)
		if (findtext(href_list["bank"],"s"))
			var/tcode = replacetext(href_list["bank"],"s","")
			var/cost = (map.globalmarketplace[tcode][4])
			var/choice1 = WWinput("Are you sure you want to sell [map.globalmarketplace[tcode][1]] stocks for [map.globalmarketplace[tcode][4]/4] dollars?","Selling Stocks","No", list("Yes","No"))
			if (choice1 == "No")
				sleep(0.5)
				do_html(user)
				return
			else
				map.globalmarketplace[tcode][7] = 1
				map.globalmarketplace[tcode][2] = null
				mainbody += "You sell the [map.globalmarketplace[tcode][1]] stocks."
				map.marketplaceaccounts[user.name] += cost
				sleep(0.5)
				do_html(user)
				return
		switch(href_list["bank"])
			if ("2") //buy
				var/list/currlist = list()
				for (var/i in map.globalmarketplace)
					if (map.globalmarketplace[i][7]==1 && map.globalmarketplace[i][5]=="bank" && map.globalmarketplace[i][2]==null)
						currlist += list(list(map.globalmarketplace[i][6],"<b>[map.globalmarketplace[i][1]]</b>, for [map.globalmarketplace[i][4]/4] dollars"))
				if (isemptylist(currlist))
					mainbody += "<b>There are no stocks available to buy!</b>"
				for (var/list/k in currlist)
					mainbody += "<a href='?src=\ref[src];bank=b[k[1]]'>[k[2]]</a><br>"
			if ("3") //sell
				var/list/currlist = list()
				for (var/i in map.globalmarketplace)
					if (map.globalmarketplace[i][7]==0 && map.globalmarketplace[i][5]=="bank" && map.globalmarketplace[i][2]==user)
						currlist += list(list(map.globalmarketplace[i][6],"<b>[map.globalmarketplace[i][1]]</b>, for [map.globalmarketplace[i][4]/4] dollars"))
				if (isemptylist(currlist))
					mainbody += "<b>There are no stocks available to sell!</b>"
				for (var/list/k in currlist)
					mainbody += "<a href='?src=\ref[src];bank=s[k[1]]'>[k[2]]</a><br>"
			if ("4") //account
				mainbody += "<big>Account: <b>[user]</b></big><br><br>"
				var/accmoney = map.marketplaceaccounts[user.name]
				if (map.marketplaceaccounts[user.name])
					if (accmoney <= 0)
						mainbody += "<a href='?src=\ref[src];bank=5'>Withdraw</a>&nbsp;<a href='?src=\ref[src];bank=6'>Deposit</a><br>"
						mainbody += "<b>Твой аккаунт пустой!</b>"
						map.marketplaceaccounts[user.name] = 0
					else
						mainbody += "<a href='?src=\ref[src];bank=5'>Withdraw</a>&nbsp;<a href='?src=\ref[src];bank=6'>Deposit</a><br>"
						mainbody += "You have [accmoney/4] dollars in your bank account.<br>"
				else
					mainbody += "<a href='?src=\ref[src];bank=5'>Withdraw</a>&nbsp;<a href='?src=\ref[src];bank=6'>Deposit</a><br>"
					mainbody += "<b>Твой аккаунт пустой!</b>"
			if ("5") //withdraw
				var/accmoney = map.marketplaceaccounts[user.name]
				if (accmoney > 0)
					var/obj/item/stack/money/dollar/SC = new /obj/item/stack/money/dollar(get_turf(origin))
					SC.amount = accmoney/20
					accmoney = 0
					map.marketplaceaccounts[user.name] = 0
					do_html(user)
			if ("6") //deposit
				if (!istype(user.l_hand, /obj/item/stack/money) && !istype(user.r_hand, /obj/item/stack/money))
					mainbody += "<b>You need to have money in one of your hands!</b>"
					sleep(0.5)
					do_html(user)
					return
				else
					var/obj/item/stack/money/mstack = null
					if (istype(user.l_hand, /obj/item/stack/money))
						mstack = user.l_hand
					else
						mstack = user.r_hand
					var/deposited = mstack.value*mstack.amount
					qdel(mstack)
					mainbody += "You deposit [deposited/4] dollars into your account.<br>"
					map.marketplaceaccounts[user.name] += deposited
					sleep(0.5)
					do_html(user)
					return
	sleep(0.5)
	do_html(user)
