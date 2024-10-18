///@desc This gets the info array for a symbol of kanji or alphabetics, listed 0-9999 all combined. Array of symbol character, romaji, pronunciation, meaning
///@param symbol This is the index of the symbol to get.
function script_getSymbolInfo(symbol){
	if(symbol == -2) {
		symbol = irandom_range(1, 29); // standard random from existing symbols
	} // LOWER CASE ALL INPUTS THAT ARE TO BE TYPED
	if(symbol < 21) {
		if(symbol == 0) { // the meanings should be arrays of possible meanings... food, meal, eat stem ect. Then give them the word if they know any of the meanings I guess? Or specify you want a verb or noun ect
			return ["DEFAULT" /*character*/, "DEFAULT", ["Dee-fall-t"], ["This is the default character in the funtion, this is not supposed to be visible in game."], 10, "Go away, go away, go away"];
		} else if(symbol == 1) {
			return ["犬", "inu", ["ee-N-oo"], ["dog", "loser"], 0, "This can also mean insults and such just like english."];
		} else if(symbol == 2) {
			return ["人", "hito", ["hee-TOH", "(origin) JEE-n", "(counter) NEE-n"], ["person", "somebody", "human", "character", "counter for people"], 0, "Human word, means many types of person, people, individual. Also signifies origin or experience, kanadajin is canadian where jin is the -ian or 職人, craftsmen from work and person (nin). Also a counter for people."];
		} else if(symbol == 3) {
			return ["食", "shoku", ["(On) show-koo", "(On) jee-kee", "(Kun) koo", "(Kun) tah"], ["food", "appetite", "meal"], 0, "Food and meals, also the kanji base of taberu, to eat. Half of the kanji for meal types, chuushoku 昼食 being lunch for ex."];
		} else if(symbol == 4) {
			return ["東", "higashi", ["hee-GAH-SHEE"], ["east"], 1, "East cardinal direction, east geography, such things."];
		} else if(symbol == 5) {
			return ["行く", "iku", ["ee-KOO", "yoo-KOO"], ["go", "move", "happen", "pass time", "die"], 0, "Like in English this means many, many things in different levels of colloquillity. Though largely similar usage to English."];
		} else if(symbol == 6) {
			return ["日本", "nihon", ["nee-HOE-n", "nee-P-OH-n"], ["japan"], 0, "This is the country of Japan. Pretty cool huh? Bet you didn't know it could fit in your computer."];
		} else if(symbol == 7) {         //?? I am not qualified for this bro
			return ["学生", "gakusei", ["gawk-SAY"], ["student"], 1, "General student, though the connotation is older because earlier school students have their own words that would usually be used instead."];
		} else if(symbol == 8) {
			return ["私", "watashi", ["wah-TAH-SHEE"], ["i", "me", "myself"], 0, "This refers to oneself. Is somewhat formal."];
		} else if(symbol == 9) {
			return ["夏", "natsu", ["nah-t-soo"], ["summer"], 1, "The season of summer. Whoo."];
		} else if(symbol == 10) {
			return ["花", "hana", ["hah-NAH"], ["flower", "blossum", "beauty", "petal"], 0, "All things flowers and blooms. Also refers to beauty I assume in a metaphorical way. Don't ask me I don't speak japanese. :D"];
		} else if(symbol == 11) {
			return ["家族", "kazoku", ["KAH-zoe-koo"], ["family"], 2, "Family. There are many more words for members of family."];
		} else if(symbol == 12) {
			return ["音楽", "ongaku", ["OH-N-gah-k"], ["music"], 2, "Music and songs."];
		} else if(symbol == 13) {
			return ["左", "hidari", ["(Kun) hee-dah-ree", "(On) sah", "(On) shah"], ["left", "left hand", "political left"], 1, "Like English this means various things to do with left sided terms. Politically left, left side, handedness, ect."];
		} else if(symbol == 14) {
			return ["右", "migi", ["(Kun) mee-GEE", "(On) oo", "(On) yoo"], ["right", "right hand", "political right"], 0, "Like English this can refer to many right things, direction, handedness, politics, ect."];
		} else if(symbol == 15) {
			return ["会社", "kaisha", ["k-eye-SH-UH"], ["company", "workplace"], 2, "The place you or others work. Can mean company, firm, offices, and other workspace things."];
		} else if(symbol == 16) {
			return ["今", "ima", ["EE-mah", "(prefix)(On) koh-n"], ["now", "current"], 0, "Refers to the current. This means now in time but also today, this week, this year, and other things."];
		} else if(symbol == 17) {
			return ["日", "hi", ["hee", "(counter) NEE-chee"], ["day", "sun", "japan", "day counter"], 0, "Word for sun that turns into daytime, day cycles, and days."];
		} else if(symbol == 18) {
			return ["危機", "kiki", ["k-kee"], ["crisis", "critical situation", "emergency"], 5, "Crisis or other extreme event, jptl1 so I made it high difficulty. Not expected to know this tbh."];
		} else if(symbol == 19) {
			return ["一番", "ichiban", ["eech-ee-bah-n"], ["number one", "best", "most"], 2, "Word that refers to the most of something. Very often used with adjectives to mean -est. Big, biggest. Ect. Also means round of a game maybe."];
		} else if(symbol == 20) {
			return ["部屋", "heya", ["hey-yah"], ["room", "apartment"], 3, "Means room in general not just bed room or your room and also means apartment or flat."];
		}
	} else if(symbol < 41) {
		if(symbol == 21) {
			return ["友達", "tomodachi", ["toh-moh-DAH-CHI"], ["friend", "companion"], 3, "Friendly people, from kanji for friend 友 and accomplish 達. Friend 友 cannot be used alone btw."];
		} else if(symbol == 22) {
			return ["猫", "neko", ["(Kun) NEH-koh", "(On?) b-y-ow"], ["cat"], 2, "The house cat. Meows are pronounced 'nyan' which is where nyan cat comes from."];
		} else if(symbol == 23) {
			return ["車", "kuruma", ["(Kun) koo-ROO-MAH", "(On) shah"], ["car", "automobile", "wheel"], 1, "There are specific words for specific vehicles but car works for most."];
		} else if(symbol == 24) {
			return ["下手", "heta", ["heh-TAH"], ["awkward", "poor"], 2, "Means poor quality or unskilled 'bad' person or thing, adjective usually. From 下 under and 手 hand."];
		} else if(symbol == 25) {
			return ["上手", "jouzu", ["joh-ZOO"], ["skillful", "proficient", "clever", "good at"], 2, "High quality or ability. Adjective usually, From 上 over and 手 hand."];
		} else if(symbol == 26) {
			return ["彼", "kare", ["(Kun) KAH-reh", "(Kun) kah-no", "(On) hee"], ["he", "him", "boyfriend"], 1, "As a pronoun it's he/him as a noun maybe boyfriend. Could also say boyufurendo... It's a common word."];
		} else if(symbol == 27) {
			return ["彼女", "kanojo", ["KAH-noh-joh"], ["she", "her", "girlfriend"], 2, "Female pronoun, like 彼 kare refers to girlfriend as well, simply 彼 plus 女 for female."];
		} else if(symbol == 28) {
			return ["形", "katachi", ["(Kun) kah-TAH-CHI", "(Kun) kah-tah", "(Kun) nah-ree", "(On) kay?", "(On) g-ee-yow?"], ["shape", "form", "visage"], 2, "The visual morphology of something I suppose."];
		} else if(symbol == 29) {
			return ["空港", "kuukou", ["koo-KOH"], ["airport"], 3, "Airports, love em. Also this comes from 空 for sky and 港 for port which is like sky port, that's really cool. Though it could just be 'air' port which is what it is in english, that's kinda cool too."];
		}/* else if(symbol == ) {
			return ["", "", "", [], 0, ""];
		} else if(symbol == ) {
			return ["", "", "", [], 0, ""];
		} else if(symbol == ) {
			return ["", "", "", [], 0, ""];
		} else if(symbol == ) {
			return ["", "", "", [], 0, ""];
		} else if(symbol == ) {
			return ["", "", "", [], 0, ""];
		} else if(symbol == ) {
			return ["", "", "", [], 0, ""];
		} else if(symbol == ) {
			return ["", "", "", [], 0, ""];
		} else if(symbol == ) {
			return ["", "", "", [], 0, ""];
		}*/
	}
}