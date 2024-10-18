var _romaji = array_contains(guessFormatAnswer, "romaji");
var _meaning = array_contains(guessFormatAnswer, "meaning")

if(_romaji || _meaning) { // romaji FIRST for stacked text entries!!!
	//if(acceptInput == 1) { // this should probably be an index, accept value representing the info being put in
		if(keyboard_check_released(vk_enter)) {
			if(entryString == "help") {
				if(_romaji) {
					entryString = romaji[0]; // give romaji from options...
				} else if(_meaning) {
					entryString = meaning[0];
				}
				audio_play_sound(snd_fillDing, 0, 0);
			} else if(entryString == "x" || entryString == "xx" || entryString == "xxx" || entryString == "xxxx" || entryString == "xxxxx" || entryString == "xxxxxx") {
				if(_romaji) {
					entryString = string_copy(romaji[0], 0, string_length(entryString)) //[0]; // give romaji from options...
				} else if(_meaning) {
					entryString = string_copy(meaning[0], 0, string_length(entryString))
				}
				audio_play_sound(snd_fillDing, 0, 0);
			} else {
				if(_romaji) {
					parseEntry("romaji");
				} else if(_meaning) {
					parseEntry("meaning");
				}
			}
			if(array_length(guessFormatAnswer) == 0) {
				instance_destroy();
				exit;
			}
		}
	
		if(keyboard_check_pressed(vk_backspace)) {
			entryString = string_delete(entryString, string_length(entryString), 1);
		} else if(keyboard_check_pressed(keyboard_lastkey)) {
			var _uni = real(keyboard_lastkey);
			//if(_uni != 0) {
			//	show_debug_message(_uni); // if you are a lost soul looking for the ascii or whatever code this is (uni? But what?) then activate this and find out with the debug console. EZ PZ
			//}
			if((_uni > 64 && _uni < 91) || _uni == 32) { // what tf is char 91 I can't check till the game runs ); I hope it's space
				entryString = string_insert(string_lower(chr(keyboard_lastkey)), entryString, string_length(entryString) + 1);
			}
		}
	//}
}

draw_set_halign(fa_center);
if(guessCurrentFormat != 0) {
	var _guessesRemaining = array_length(guessList);
	var _mouseDir = (point_direction(x, y, mouse_x, mouse_y) + 270 - ((_guessesRemaining == 2) * 90) + (180 / guessOptionCount)) % 360; // nightmare line for real, pound sand nerd if you can't read this effortlessly
	
	if(_guessesRemaining < 2) {
		array_delete(guessFormatAnswer, array_get_index(guessFormatAnswer, guessCurrentFormat + "Wheel"), 1);
		if(array_length(guessFormatAnswer) == 0) {
			instance_destroy();
			exit;
		} else {
			setWheel();
		}
	} else if(_guessesRemaining == 2) {
		if(_mouseDir < 180) {
			optionHovering = 0;
		} else {
			optionHovering = 1;
		}
	} else {
		optionHovering = floor((_mouseDir / 360) * _guessesRemaining);
	}
	
	if(mouse_check_button_released(mb_left)) { // this all got a lot more complicated when i brought in multiple types without any clear check for what types are in play... Ah well!
		var _correct = 0;
		var _checkVariable = variable_instance_get(id, guessCurrentFormat);
		if(is_array(_checkVariable)) {
			if(array_contains(_checkVariable, guessList[optionHovering])) {
				_correct = 1;
			}
		} else if(_checkVariable == guessList[optionHovering]) {
			_correct = 1;
		}
		
		if(_correct) { // success
			audio_play_sound(snd_correctDing, 0, 0);
			array_delete(guessFormatAnswer, array_get_index(guessFormatAnswer, guessCurrentFormat + "Wheel"), 1);
			if(array_length(guessFormatAnswer) == 0) {
				instance_destroy();
				exit;
			} else {
				setWheel();
			}
		} else {
			array_delete(guessList, optionHovering, 1);
			guessOptionCount = array_length(guessList);
			audio_play_sound(snd_wrongDing, 0, 0);
		} // wrong bozo
	}
}

if(keyboard_check_released(vk_escape)) {
	instance_destroy();
}