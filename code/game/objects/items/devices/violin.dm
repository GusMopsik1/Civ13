/obj/item/violin
	name = "Violin"
	desc = "A classic violin. "
	icon = 'icons/russian/obj/musician.dmi'
	icon_state = "violin"
	item_state = "violin"
	force = WEAPON_FORCE_PAINFUL
	var/datum/song/song
	var/playing = FALSE
	var/help = FALSE
	var/edit = TRUE
	var/repeat = FALSE
	flammable = TRUE
	value = 0

/obj/item/violin/proc/playnote(var/note as text)
	//world << "Note: [note]"
	var/soundfile
	/*BYOND loads resource files at compile time if they are ''. This means you can't really manipulate them dynamically.
	Tried doing it dynamically at first but its more trouble than its worth. Would have saved many lines tho.*/
	switch(note)
		if ("Cn1")	soundfile = 'sound/violin/Cn1.mid'
		if ("C#1")	soundfile = 'sound/violin/C#1.mid'
		if ("Db1")	soundfile = 'sound/violin/Db1.mid'
		if ("Dn1")	soundfile = 'sound/violin/Dn1.mid'
		if ("D#1")	soundfile = 'sound/violin/D#1.mid'
		if ("Eb1")	soundfile = 'sound/violin/Eb1.mid'
		if ("En1")	soundfile = 'sound/violin/En1.mid'
		if ("E#1")	soundfile = 'sound/violin/E#1.mid'
		if ("Fb1")	soundfile = 'sound/violin/Fb1.mid'
		if ("Fn1")	soundfile = 'sound/violin/Fn1.mid'
		if ("F#1")	soundfile = 'sound/violin/F#1.mid'
		if ("Gb1")	soundfile = 'sound/violin/Gb1.mid'
		if ("Gn1")	soundfile = 'sound/violin/Gn1.mid'
		if ("G#1")	soundfile = 'sound/violin/G#1.mid'
		if ("Ab1")	soundfile = 'sound/violin/Ab1.mid'
		if ("An1")	soundfile = 'sound/violin/An1.mid'
		if ("A#1")	soundfile = 'sound/violin/A#1.mid'
		if ("Bb1")	soundfile = 'sound/violin/Bb1.mid'
		if ("Bn1")	soundfile = 'sound/violin/Bn1.mid'
		if ("B#1")	soundfile = 'sound/violin/B#1.mid'
		if ("Cb2")	soundfile = 'sound/violin/Cb2.mid'
		if ("Cn2")	soundfile = 'sound/violin/Cn2.mid'
		if ("C#2")	soundfile = 'sound/violin/C#2.mid'
		if ("Db2")	soundfile = 'sound/violin/Db2.mid'
		if ("Dn2")	soundfile = 'sound/violin/Dn2.mid'
		if ("D#2")	soundfile = 'sound/violin/D#2.mid'
		if ("Eb2")	soundfile = 'sound/violin/Eb2.mid'
		if ("En2")	soundfile = 'sound/violin/En2.mid'
		if ("E#2")	soundfile = 'sound/violin/E#2.mid'
		if ("Fb2")	soundfile = 'sound/violin/Fb2.mid'
		if ("Fn2")	soundfile = 'sound/violin/Fn2.mid'
		if ("F#2")	soundfile = 'sound/violin/F#2.mid'
		if ("Gb2")	soundfile = 'sound/violin/Gb2.mid'
		if ("Gn2")	soundfile = 'sound/violin/Gn2.mid'
		if ("G#2")	soundfile = 'sound/violin/G#2.mid'
		if ("Ab2")	soundfile = 'sound/violin/Ab2.mid'
		if ("An2")	soundfile = 'sound/violin/An2.mid'
		if ("A#2")	soundfile = 'sound/violin/A#2.mid'
		if ("Bb2")	soundfile = 'sound/violin/Bb2.mid'
		if ("Bn2")	soundfile = 'sound/violin/Bn2.mid'
		if ("B#2")	soundfile = 'sound/violin/B#2.mid'
		if ("Cb3")	soundfile = 'sound/violin/Cb3.mid'
		if ("Cn3")	soundfile = 'sound/violin/Cn3.mid'
		if ("C#3")	soundfile = 'sound/violin/C#3.mid'
		if ("Db3")	soundfile = 'sound/violin/Db3.mid'
		if ("Dn3")	soundfile = 'sound/violin/Dn3.mid'
		if ("D#3")	soundfile = 'sound/violin/D#3.mid'
		if ("Eb3")	soundfile = 'sound/violin/Eb3.mid'
		if ("En3")	soundfile = 'sound/violin/En3.mid'
		if ("E#3")	soundfile = 'sound/violin/E#3.mid'
		if ("Fb3")	soundfile = 'sound/violin/Fb3.mid'
		if ("Fn3")	soundfile = 'sound/violin/Fn3.mid'
		if ("F#3")	soundfile = 'sound/violin/F#3.mid'
		if ("Gb3")	soundfile = 'sound/violin/Gb3.mid'
		if ("Gn3")	soundfile = 'sound/violin/Gn3.mid'
		if ("G#3")	soundfile = 'sound/violin/G#3.mid'
		if ("Ab3")	soundfile = 'sound/violin/Ab3.mid'
		if ("An3")	soundfile = 'sound/violin/An3.mid'
		if ("A#3")	soundfile = 'sound/violin/A#3.mid'
		if ("Bb3")	soundfile = 'sound/violin/Bb3.mid'
		if ("Bn3")	soundfile = 'sound/violin/Bn3.mid'
		if ("B#3")	soundfile = 'sound/violin/B#3.mid'
		if ("Cb4")	soundfile = 'sound/violin/Cb4.mid'
		if ("Cn4")	soundfile = 'sound/violin/Cn4.mid'
		if ("C#4")	soundfile = 'sound/violin/C#4.mid'
		if ("Db4")	soundfile = 'sound/violin/Db4.mid'
		if ("Dn4")	soundfile = 'sound/violin/Dn4.mid'
		if ("D#4")	soundfile = 'sound/violin/D#4.mid'
		if ("Eb4")	soundfile = 'sound/violin/Eb4.mid'
		if ("En4")	soundfile = 'sound/violin/En4.mid'
		if ("E#4")	soundfile = 'sound/violin/E#4.mid'
		if ("Fb4")	soundfile = 'sound/violin/Fb4.mid'
		if ("Fn4")	soundfile = 'sound/violin/Fn4.mid'
		if ("F#4")	soundfile = 'sound/violin/F#4.mid'
		if ("Gb4")	soundfile = 'sound/violin/Gb4.mid'
		if ("Gn4")	soundfile = 'sound/violin/Gn4.mid'
		if ("G#4")	soundfile = 'sound/violin/G#4.mid'
		if ("Ab4")	soundfile = 'sound/violin/Ab4.mid'
		if ("An4")	soundfile = 'sound/violin/An4.mid'
		if ("A#4")	soundfile = 'sound/violin/A#4.mid'
		if ("Bb4")	soundfile = 'sound/violin/Bb4.mid'
		if ("Bn4")	soundfile = 'sound/violin/Bn4.mid'
		if ("B#4")	soundfile = 'sound/violin/B#4.mid'
		if ("Cb5")	soundfile = 'sound/violin/Cb5.mid'
		if ("Cn5")	soundfile = 'sound/violin/Cn5.mid'
		if ("C#5")	soundfile = 'sound/violin/C#5.mid'
		if ("Db5")	soundfile = 'sound/violin/Db5.mid'
		if ("Dn5")	soundfile = 'sound/violin/Dn5.mid'
		if ("D#5")	soundfile = 'sound/violin/D#5.mid'
		if ("Eb5")	soundfile = 'sound/violin/Eb5.mid'
		if ("En5")	soundfile = 'sound/violin/En5.mid'
		if ("E#5")	soundfile = 'sound/violin/E#5.mid'
		if ("Fb5")	soundfile = 'sound/violin/Fb5.mid'
		if ("Fn5")	soundfile = 'sound/violin/Fn5.mid'
		if ("F#5")	soundfile = 'sound/violin/F#5.mid'
		if ("Gb5")	soundfile = 'sound/violin/Gb5.mid'
		if ("Gn5")	soundfile = 'sound/violin/Gn5.mid'
		if ("G#5")	soundfile = 'sound/violin/G#5.mid'
		if ("Ab5")	soundfile = 'sound/violin/Ab5.mid'
		if ("An5")	soundfile = 'sound/violin/An5.mid'
		if ("A#5")	soundfile = 'sound/violin/A#5.mid'
		if ("Bb5")	soundfile = 'sound/violin/Bb5.mid'
		if ("Bn5")	soundfile = 'sound/violin/Bn5.mid'
		if ("B#5")	soundfile = 'sound/violin/B#5.mid'
		if ("Cb6")	soundfile = 'sound/violin/Cb6.mid'
		if ("Cn6")	soundfile = 'sound/violin/Cn6.mid'
		if ("C#6")	soundfile = 'sound/violin/C#6.mid'
		if ("Db6")	soundfile = 'sound/violin/Db6.mid'
		if ("Dn6")	soundfile = 'sound/violin/Dn6.mid'
		if ("D#6")	soundfile = 'sound/violin/D#6.mid'
		if ("Eb6")	soundfile = 'sound/violin/Eb6.mid'
		if ("En6")	soundfile = 'sound/violin/En6.mid'
		if ("E#6")	soundfile = 'sound/violin/E#6.mid'
		if ("Fb6")	soundfile = 'sound/violin/Fb6.mid'
		if ("Fn6")	soundfile = 'sound/violin/Fn6.mid'
		if ("F#6")	soundfile = 'sound/violin/F#6.mid'
		if ("Gb6")	soundfile = 'sound/violin/Gb6.mid'
		if ("Gn6")	soundfile = 'sound/violin/Gn6.mid'
		if ("G#6")	soundfile = 'sound/violin/G#6.mid'
		if ("Ab6")	soundfile = 'sound/violin/Ab6.mid'
		if ("An6")	soundfile = 'sound/violin/An6.mid'
		if ("A#6")	soundfile = 'sound/violin/A#6.mid'
		if ("Bb6")	soundfile = 'sound/violin/Bb6.mid'
		if ("Bn6")	soundfile = 'sound/violin/Bn6.mid'
		if ("B#6")	soundfile = 'sound/violin/B#6.mid'
		if ("Cb7")	soundfile = 'sound/violin/Cb7.mid'
		if ("Cn7")	soundfile = 'sound/violin/Cn7.mid'
		if ("C#7")	soundfile = 'sound/violin/C#7.mid'
		if ("Db7")	soundfile = 'sound/violin/Db7.mid'
		if ("Dn7")	soundfile = 'sound/violin/Dn7.mid'
		if ("D#7")	soundfile = 'sound/violin/D#7.mid'
		if ("Eb7")	soundfile = 'sound/violin/Eb7.mid'
		if ("En7")	soundfile = 'sound/violin/En7.mid'
		if ("E#7")	soundfile = 'sound/violin/E#7.mid'
		if ("Fb7")	soundfile = 'sound/violin/Fb7.mid'
		if ("Fn7")	soundfile = 'sound/violin/Fn7.mid'
		if ("F#7")	soundfile = 'sound/violin/F#7.mid'
		if ("Gb7")	soundfile = 'sound/violin/Gb7.mid'
		if ("Gn7")	soundfile = 'sound/violin/Gn7.mid'
		if ("G#7")	soundfile = 'sound/violin/G#7.mid'
		if ("Ab7")	soundfile = 'sound/violin/Ab7.mid'
		if ("An7")	soundfile = 'sound/violin/An7.mid'
		if ("A#7")	soundfile = 'sound/violin/A#7.mid'
		if ("Bb7")	soundfile = 'sound/violin/Bb7.mid'
		if ("Bn7")	soundfile = 'sound/violin/Bn7.mid'
		if ("B#7")	soundfile = 'sound/violin/B#7.mid'
		if ("Cb8")	soundfile = 'sound/violin/Cb8.mid'
		if ("Cn8")	soundfile = 'sound/violin/Cn8.mid'
		if ("C#8")	soundfile = 'sound/violin/C#8.mid'
		if ("Db8")	soundfile = 'sound/violin/Db8.mid'
		if ("Dn8")	soundfile = 'sound/violin/Dn8.mid'
		if ("D#8")	soundfile = 'sound/violin/D#8.mid'
		if ("Eb8")	soundfile = 'sound/violin/Eb8.mid'
		if ("En8")	soundfile = 'sound/violin/En8.mid'
		if ("E#8")	soundfile = 'sound/violin/E#8.mid'
		if ("Fb8")	soundfile = 'sound/violin/Fb8.mid'
		if ("Fn8")	soundfile = 'sound/violin/Fn8.mid'
		if ("F#8")	soundfile = 'sound/violin/F#8.mid'
		if ("Gb8")	soundfile = 'sound/violin/Gb8.mid'
		if ("Gn8")	soundfile = 'sound/violin/Gn8.mid'
		if ("G#8")	soundfile = 'sound/violin/G#8.mid'
		if ("Ab8")	soundfile = 'sound/violin/Ab8.mid'
		if ("An8")	soundfile = 'sound/violin/An8.mid'
		if ("A#8")	soundfile = 'sound/violin/A#8.mid'
		if ("Bb8")	soundfile = 'sound/violin/Bb8.mid'
		if ("Bn8")	soundfile = 'sound/violin/Bn8.mid'
		if ("B#8")	soundfile = 'sound/violin/B#8.mid'
		if ("Cb9")	soundfile = 'sound/violin/Cb9.mid'
		if ("Cn9")	soundfile = 'sound/violin/Cn9.mid'
		else		return

	hearers(15, get_turf(src)) << sound(soundfile)

/obj/item/violin/proc/playsong()
	do
		var/cur_oct[7]
		var/cur_acc[7]
		for (var/i = TRUE to 7)
			cur_oct[i] = "3"
			cur_acc[i] = "n"

		for (var/line in song.lines)
			//world << line
			for (var/beat in splittext(lowertext(line), ","))
				//world << "beat: [beat]"
				var/list/notes = splittext(beat, "/")
				if (!notes.len)
					return
				for (var/note in splittext(notes[1], "-"))
					//world << "note: [note]"
					if (!playing || !isliving(loc))//If the violin is playing, or isn't held by a person
						playing = FALSE
						return
					if (length(note) == FALSE)
						continue
					//world << "Parse: [copytext(note,1,2)]"
					var/cur_note = text2ascii(note) - 96
					if (cur_note < 1 || cur_note > 7)
						continue
					for (var/i=2 to length(note))
						var/ni = copytext(note,i,i+1)
						if (!text2num(ni))
							if (ni == "#" || ni == "b" || ni == "n")
								cur_acc[cur_note] = ni
							else if (ni == "s")
								cur_acc[cur_note] = "#" // so shift is never required
						else
							cur_oct[cur_note] = ni
					playnote(uppertext(copytext(note,1,2)) + cur_acc[cur_note] + cur_oct[cur_note])
				if (notes.len >= 2 && text2num(notes[2]))
					sleep(song.tempo / text2num(notes[2]))
				else
					sleep(song.tempo)
		if (repeat > 0)
			repeat-- //Infinite loops are baaaad.
	while (repeat > 0)
	playing = FALSE

/obj/item/violin/attack_self(mob/user as mob)
	if (!isliving(user) || user.stat || user.restrained() || user.lying)	return
	user.set_using_object(src)

	var/dat = "<HEAD><TITLE>Violin</TITLE></HEAD><BODY>"

	if (song)
		if (song.lines.len > 0 && !(playing))
			dat += "<A href='?src=\ref[src];play=1'>Play Song</A><BR><BR>"
			dat += "<A href='?src=\ref[src];repeat=1'>Repeat Song: [repeat] times.</A><BR><BR>"
		if (playing)
			dat += "<A href='?src=\ref[src];stop=1'>Stop Playing</A><BR>"
			dat += "Repeats left: [repeat].<BR><BR>"
	if (!edit)
		dat += "<A href='?src=\ref[src];edit=2'>Show Editor</A><BR><BR>"
	else
		dat += "<A href='?src=\ref[src];edit=1'>Hide Editor</A><BR>"
		dat += "<A href='?src=\ref[src];newsong=1'>Start a New Song</A><BR>"
		dat += "<A href='?src=\ref[src];import=1'>Import a Song</A><BR><BR>"
		if (song)
			var/calctempo = (10/song.tempo)*60
			dat += "Tempo : <A href='?src=\ref[src];tempo=10'>-</A><A href='?src=\ref[src];tempo=1'>-</A> [calctempo] BPM <A href='?src=\ref[src];tempo=-1'>+</A><A href='?src=\ref[src];tempo=-10'>+</A><BR><BR>"
			var/linecount = FALSE
			for (var/line in song.lines)
				linecount += 1
				dat += "Line [linecount]: [line] <A href='?src=\ref[src];deleteline=[linecount]'>Delete Line</A> <A href='?src=\ref[src];modifyline=[linecount]'>Modify Line</A><BR>"
			dat += "<A href='?src=\ref[src];newline=1'>Add Line</A><BR><BR>"
		if (help)
			dat += "<A href='?src=\ref[src];help=1'>Hide Help</A><BR>"
			dat += {"
					Lines are a series of chords, separated by commas (,), each with notes seperated by hyphens (-).<br>
					Every note in a chord will play together, with chord timed by the tempo.<br>
					<br>
					Notes are played by the names of the note, and optionally, the accidental, and/or the octave number.<br>
					By default, every note is natural and in octave 3. Defining otherwise is remembered for each note.<br>
					Example: <i>C,D,E,F,G,A,B</i> will play a C major scale.<br>
					After a note has an accidental placed, it will be remembered: <i>C,C4,C,C3</i> is <i>C3,C4,C4,C3</i><br>
					Chords can be played simply by seperating each note with a hyphon: <i>A-C#,Cn-E,E-G#,Gn-B</i><br>
					A pause may be denoted by an empty chord: <i>C,E,,C,G</i><br>
					To make a chord be a different time, end it with /x, where the chord length will be length<br>
					defined by tempo / x: <i>C,G/2,E/4</i><br>
					Combined, an example is: <i>E-E4/4,/2,G#/8,B/8,E3-E4/4</i>
					<br>
					Lines may be up to [MAX_CHARS_PER_LINE] characters.<br>
					A song may only contain up to [MAX_CHARS_PER_LINE] lines.<br>
					"}
		else
			dat += "<A href='?src=\ref[src];help=2'>Show Help</A><BR>"
	dat += "</BODY></HTML>"
	user << browse(dat, "window=violin;size=700x300")
	onclose(user, "violin")

/obj/item/violin/Topic(href, href_list)

	if (!in_range(src, usr) || !isliving(usr) || !usr.canmove || usr.restrained())
		usr << browse(null, "window=violin;size=700x300")
		onclose(usr, "violin")
		return

	if (href_list["newsong"])
		song = new()
	else if (song)
		if (href_list["repeat"]) //Changing this from a toggle to a number of repeats to avoid infinite loops.
			if (playing) return //So that people cant keep adding to repeat. If the do it intentionally, it could result in the server crashing.
			repeat = round(Clamp(WWinput(usr, "How many times do you want to repeat this piece? (maximum of 5 times)", "Repeats", 1, "num"), 0, 5))

		else if (href_list["tempo"])
			song.tempo += round(text2num(href_list["tempo"]))
			if (song.tempo < 1)
				song.tempo = TRUE

		else if (href_list["play"])
			if (song)
				playing = TRUE
				spawn() playsong()

		else if (href_list["newline"])
			var/newline = html_encode(input("Enter your line: ", "violin") as text|null)
			if (!newline)
				return
			if (song.lines.len > MAX_CHARS_PER_LINE)
				return
			if (length(newline) > MAX_CHARS_PER_LINE)
				newline = copytext(newline, TRUE, MAX_CHARS_PER_LINE)
			song.lines.Add(newline)

		else if (href_list["deleteline"])
			var/num = round(text2num(href_list["deleteline"]))
			if (num > song.lines.len || num < 1)
				return
			song.lines.Cut(num, num+1)

		else if (href_list["modifyline"])
			var/num = round(text2num(href_list["modifyline"]),1)
			var/content = html_encode(input("Enter your line: ", "violin", song.lines[num]) as text|null)
			if (!content)
				return
			if (length(content) > MAX_CHARS_PER_LINE)
				content = copytext(content, TRUE, MAX_CHARS_PER_LINE)
			if (num > song.lines.len || num < 1)
				return
			song.lines[num] = content

		else if (href_list["stop"])
			playing = FALSE

		else if (href_list["help"])
			help = text2num(href_list["help"]) - 1

		else if (href_list["edit"])
			edit = text2num(href_list["edit"]) - 1

		else if (href_list["import"])
			var/t = ""
			do
				t = html_encode(input(usr, "Please paste the entire song, formatted:", text("[]", name), t)  as message)
				if (!in_range(src, usr))
					return

				if (length(t) >= MAX_CHARS_TOTAL)
					var/cont = WWinput(usr, "Your song is too long! Would you like to continue editing it?", "Error", "Yes", list("Yes", "No"))
					if (cont == "No")
						break
			while (length(t) > MAX_CHARS_TOTAL)

			//split into lines
			spawn()
				var/list/lines = splittext(t, "\n")
				var/tempo = 5
				if (!lines || !lines.len)
					return
				if (copytext(lines[1],1,6) == "BPM: " && text2num(copytext(lines[1],6)))
					tempo = 600 / text2num(copytext(lines[1],6))
					lines.Cut(1,2)
				if (lines.len > MAX_CHARS_PER_LINE)
					usr << "Too many lines!"
					lines.Cut(MAX_CHARS_PER_LINE+1)
				var/linenum = TRUE
				for (var/l in lines)
					if (length(l) > MAX_CHARS_PER_LINE)
						usr << "Line [linenum] too long!"
						lines.Remove(l)
					else
						linenum++
				song = new()
				song.lines = lines
				song.tempo = tempo

	add_fingerprint(usr)
	for (var/mob/M in viewers(1, loc))
		if ((M.client && M.using_object == src))
			attack_self(M)
	return
