global.movementLocked = 1;

tileSize = global.tileGapGeneral;
tileX = 0;
tileY = 0;

symbol = "H";
meaning = "Dog";
pronunciation = "Ee-nu"; // not a format because not answerable in a meaningful way and romaji already does this
romaji = "Inu";

//is this all the formats? Mayhaps add more in the future i guess
// meaning of formats:  Kanji , eng chars,  meaning in eng, 
//all possible formats: symbol,  romaji,       meaning, 
guessFormatGiven = [];
guessFormatAnswer = [];

guessCurrentFormat = 0;
guessOptionCount = 3;
guessList = [symbol]; // nice job naming an array list moron
optionHovering = -1; // highlight and pass this option when making symbol guess

difficulty = irandom(3); // jplt levels?
description = "No description now.";
verbType = "not implemented"; // ichidan, godan

#region text entry from debug manager lol
acceptInput = 0;

entryString = "";

///@desc This function takes the value to check and uses entryString and returns whether they are the same
///@param valueCheckAgainst This can be any of the written formats so romaji, meaning, or ect... I think just those two for now though
parseEntry = function(valueCheckAgainst) {
	if(entryString != "") {
		// do the logic here
		entryString = string_letters(entryString); // remove non alphabet characters
		if(valueCheckAgainst == "romaji") {
			var _contains = false;
			for(var _i = array_length(romaji) - 1; _i >= 0; _i--) {
				if(string_letters(romaji[_i]) == entryString) { // check a letter stripped romaji answer vs letter stipped guess input
					_contains = true;
					break;
				}
			}
				
			if(_contains) {
				entryString = ""; // option for clearing right answers
				array_delete(guessFormatAnswer, array_get_index(guessFormatAnswer, "romaji"), 1);
				audio_play_sound(snd_correctDing, 0, 0);
				return true;
			} else {
				//if clear answers on wrong config
				//entryString = ""; // option for clearing wrong answers
				audio_play_sound(snd_wrongDing, 0, 0);
				return false;
			}
		} else if(valueCheckAgainst == "meaning") {
			var _contains = false;
			for(var _i = array_length(meaning) - 1; _i >= 0; _i--) {
				if(string_letters(meaning[_i]) == entryString) { // check a letter stripped meaning answer vs letter stipped guess input
					_contains = true;
					break;
				}
			}
			
			if(_contains) {
				entryString = ""; // option for clearing right answers
				array_delete(guessFormatAnswer, array_get_index(guessFormatAnswer, "meaning"), 1);
				audio_play_sound(snd_correctDing, 0, 0);
				return true;
			} else {
				//if clear answers on wrong config
				//entryString = ""; // option for clearing wrong answers
				audio_play_sound(snd_wrongDing, 0, 0);
				return false;
			}
		}
	}
}
#endregion

fillGuessWithDifficulty = function(guessFormat = "symbol") {
	guessCurrentFormat = guessFormat;
	var _data = variable_instance_get(id, guessFormat); // get variable from format string, they are the same (right?)
	if(is_array(_data)) {
		guessList = [_data[irandom(array_length(_data) - 1)]]
	} else { // get either the variable whole or a random value if it's an array
		guessList = [_data]
	}
	
	if(guessFormat == "symbol") {
		repeat(guessOptionCount - 1) {
			array_push(guessList, global.manager.getWordData()[0]);
		}
	} else if(guessFormat == "romaji") {
		repeat(guessOptionCount - 1) {
			var _info = global.manager.getWordData()[1];
			array_push(guessList, _info[irandom(array_length(_info) - 1)]);
		}
	} else if(guessFormat == "meaning") {
		repeat(guessOptionCount - 1) {
			var _info = global.manager.getWordData()[3];
			array_push(guessList, _info[irandom(array_length(_info) - 1)]);
		}
	} else if(guessFormat == "pronunciation") {
		repeat(guessOptionCount - 1) {
			var _info = global.manager.getWordData()[2];
			array_push(guessList, _info[irandom(array_length(_info) - 1)]);
		}
	} // copy paste brother, copy paste, all these are the same but for different values
	
	guessList = array_shuffle(guessList);
}

setWheel = function() {
	if(array_contains(guessFormatAnswer, "symbol")) {
		fillGuessWithDifficulty("symbol");
	} else if(array_contains(guessFormatAnswer, "meaningWheel")) { // only do one of these
		fillGuessWithDifficulty("meaning");
	} else if(array_contains(guessFormatAnswer, "pronunciationWheel")) {
		fillGuessWithDifficulty("pronunciation");
	} else if(array_contains(guessFormatAnswer, "romajiWheel")) {
		fillGuessWithDifficulty("romaji");
	} else {
		guessCurrentFormat = 0;
	}
}

initializeQuiz = function(xTile, yTile, infoGiven, infoNeeded, guessCount, guessDifficulty) {
	tileX = xTile;
	tileY = yTile;
	
	var _data = script_getTileData(tileX, tileY);
	symbol = _data[0];
	romaji = _data[1];
	pronunciation = _data[2];
	meaning = _data[3];
	difficulty = _data[4];
	description = _data[5];
	
	guessFormatGiven = infoGiven;
	guessFormatAnswer = infoNeeded;

	difficulty = guessDifficulty;
	guessOptionCount = guessCount;
	setWheel();
}