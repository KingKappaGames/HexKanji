var _line = 1;
var _file = file_text_open_read("kanjiDataNoBrackets.txt");
var _wordDump = file_text_open_write("kanjiDump.TXT");

var _kanji = [];
var _gradeLevel = [];
var _japPronunciationSymbols = [];
var _onRomajiReading = [];
var _translationEng = [];
var _kunRomajiReading = [];

var _targets = [_kanji, _gradeLevel, _japPronunciationSymbols, _onRomajiReading, _translationEng, _kunRomajiReading];
var _targetIndex = 0;

file_text_readln(_file); // drop first line (remove once done and take out guide line in file too)

while(!file_text_eof(_file)) {
	var _wordData = file_text_readln(_file);
	
	// grab each piece of data and add them to the proper array and then take that data and rebuild it into a properly formatted text file
	
	
	//parse the text to arrays and text and reals
	
	var _charCount = string_length(_wordData) - 2; // take off the last (two???) return characters, a blank space and then a return.. idk
	_targetIndex = 0;
	var _target = _targets[_targetIndex]; // set the target to sub arrays as they are created
	var _chunkStartPos = 1; // the beginning of this piece of data in the string
	var _forceQuotes = false;
	
	//var _charCountDebug = string_length(_wordData) - 1;
	//show_debug_message(_wordData)
	//show_debug_message("YOU HAVE BEEN AUDITED.                         |||")
	//for(var _i = 1; _i < _charCountDebug; _i++) {
	//	show_debug_message(string_char_at(_wordData, _i))
	//}
	
	for(var _charI = 1; _charI <= _charCount; _charI++) {
		if(!_forceQuotes) {
			var _charDebug = string_char_at(_wordData, _charI);
			if(string_char_at(_wordData, _charI) == "," || _charI == _charCount) { // if text broken by SPACE or ending then block word within those spaces based on the chunk start pos and current value adjusted for character
				array_push(_target, string_copy(_wordData, _chunkStartPos, (_charI - _chunkStartPos) + (_charI == _charCount) - (string_char_at(_wordData, _charI - 1) == "\""))); // push word pos back or forward but not if it's at the end because then it's not a character thing but a position thing and thus there's no character to adjust for...
				var _partDebug = string_copy(_wordData, _chunkStartPos, (_charI - _chunkStartPos) + (_charI == _charCount));
				_chunkStartPos = _charI + 1;
				if(_charI != _charCount) {
					_targetIndex++;
					_target = _targets[_targetIndex];
				}
			} else if(string_char_at(_wordData, _charI) == "\"") {
				_forceQuotes = true;
				_chunkStartPos = _charI + 1; // start the quote block and set beginning to first quoted character
			}
			
		} else {
			if(string_char_at(_wordData, _charI) == "\"") {
				_forceQuotes = false;
				if(_charI == _charCount) {
					array_push(_target, string_copy(_wordData, _chunkStartPos, (_charI - _chunkStartPos))); // if this is the end of the line (and thus no commas to collect) then grab yourself now
					_chunkStartPos = _charI + 1;
				}
			} // semi colons outside of strings represents words moving into words for same category. Make of that what you will...
			
			//grab each entry from between either periods, commas, or semicolons. Why all three? I don't know!
		}
	}
	//return ["犬", "inu", ["ee-N-oo"], ["dog", "loser"], 0, "This can also mean insults and such just like english."];
	
}

show_debug_message(_targets)
show_debug_message(array_length(_kanji))
show_debug_message(array_length(_gradeLevel))
show_debug_message(array_length(_japPronunciationSymbols))
show_debug_message(array_length(_onRomajiReading))
show_debug_message(array_length(_translationEng))
show_debug_message(array_length(_kunRomajiReading))

var _debug = file_exists("kanjiDump.TXT");
var _kanjiCount = array_length(_kanji);

for(var _i = 0; _i < _kanjiCount; _i++) {
	
	var _string = "\""; // initial string opener
	
	var _charCount = string_length(_translationEng[_i]);
	var _letterHold = -1;
	for(var _letter = 1; _letter <= _charCount; _letter++) {
		_letterHold = string_char_at(_translationEng[_i], _letter);
		if(_letterHold == "," || _letterHold == "." || _letterHold == ";") {
			_string += "\" \""; // replace delimeters with string breaks
			_letter++; // skip extra space that comes after all commas, periods, and semicolons... right? There's a space after all of them right? Right??
		} else {
			_string += _letterHold; // continue string...
		}
	}
	_string += "\""; // close string chain at end
	
	
	var _stringHir = "\""; // initial string opener
	
	_charCount = string_length(_japPronunciationSymbols[_i]);
	for(var _letter = 1; _letter <= _charCount; _letter++) {
		_letterHold = string_char_at(_japPronunciationSymbols[_i], _letter);
		if(_letterHold == "、") {
			_stringHir += "\" \""; // replace delimeters with string breaks
		} else {
			_stringHir += _letterHold; // continue string...
		}
	}
	_stringHir += "\""; // close string chain at end
	
	var _stringOn = "";
	if(_onRomajiReading[_i] != "-") {
		_stringOn = "\"*"; // initial string opener and opening * marker for on reading
	
		_charCount = string_length(_onRomajiReading[_i]);
		for(var _letter = 1; _letter <= _charCount; _letter++) {
			_letterHold = string_char_at(_onRomajiReading[_i], _letter);
			if(_letterHold == ",") {
				_stringOn += "\" \"*"
				; // replace delimeters with string breaks (plus leading * marker)
				_letter++; // skip extra space that comes after all commas, periods, and semicolons... right? There's a space after all of them right? Right??
			} else {
				_stringOn += _letterHold; // continue string...
			}
		}
		_stringOn += "\""; // close string chain at end
	}
	
	var _stringKun = ""; // initial non entry
	if(_kunRomajiReading[_i] != "-") {
		 _stringKun = "\""; // initial string opener
		_charCount = string_length(_kunRomajiReading[_i]);
		for(var _letter = 1; _letter <= _charCount; _letter++) {
			_letterHold = string_char_at(_kunRomajiReading[_i], _letter);
			if(_letterHold == ",") {
				_stringKun += "\" \""; // replace delimeters with string breaks
				_letter++; // skip extra space that comes after all commas, periods, and semicolons... right? There's a space after all of them right? Right??
			} else {
				_stringKun += _letterHold; // continue string...
			}
		}
		_stringKun += "\""; // close string chain at end
	}
	
	var _onString = $" {_stringOn}"; // adds the collection with space built in so that if it's null it wont create empty space groups... Not ideal but who cares it works
	
	var _dataText = $"{_kanji[_i]} [ {_stringKun}{_onString} ] [ {_stringHir} ] [ {_string} ] {_gradeLevel[_i]} \"There is no description for this!\"";
	file_text_write_string(_wordDump, _dataText); // write data to file
	file_text_writeln(_wordDump);
}

file_text_close(_wordDump);
file_text_close(_file);

//IT'S almost working!!! It now needs each category formatted... I need to go through each data type and break the large lists of entries for say meanings into actual lists and put quotes around each entry so that all entries can be non parsed... I think after those two things it will boot to the game ! Maybe I should find parenthesis within pronunciations and capitalize them? Later!