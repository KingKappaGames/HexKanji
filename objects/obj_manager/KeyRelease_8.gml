/*

var _line = 1;
var _file = file_text_open_read("KanjiSentencesData.txt");
var _wordDump = file_text_open_write("kanjiSentenceDump.TXT");

var _japWriting = [];
var _translationEng = [];
var _kanji = [];
var _japPronunciationSymbols = [];
var _gradeLevel = [];

var _targets = [_japWriting, _translationEng, _kanji, _japPronunciationSymbols, _gradeLevel];
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
			if(string_char_at(_wordData, _charI) == " " || _charI == _charCount) { // if text broken by SPACE or ending then block word within those spaces based on the chunk start pos and current value adjusted for character
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

show_debug_message(array_length(_kanji))
show_debug_message(array_length(_japWriting))
show_debug_message(array_length(_gradeLevel))
show_debug_message(array_length(_japPronunciationSymbols))
show_debug_message(array_length(_translationEng))

var _sentenceCount = array_length(_japWriting);

for(var _i = 0; _i < _sentenceCount; _i++) {
	
	var _stringJapWriting = "\"";
	_stringJapWriting += _japWriting[_i];
	_stringJapWriting += "\"";
	
	
	var _stringKanjiContained = "\""; // initial string opener
	var _charCount = string_length(_kanji[_i]);
	for(var _letter = 1; _letter <= _charCount; _letter++) {
		var _letterHold = string_char_at(_kanji[_i], _letter);
		if(_letterHold == ",") {
			_stringKanjiContained += "\" \""; // replace delimeters with string breaks
		} else {
			_stringKanjiContained += _letterHold; // continue string...
		}
	}
	_stringKanjiContained += "\""; // close string chain at end
	
	
	var _stringHir = "\""; // initial string opener
	_stringHir += _japPronunciationSymbols[_i];
	_stringHir += "\""; // close string chain at end
	
	var _stringGrade = "\""; // initial string opener
	_stringGrade += string_copy(_gradeLevel[_i], 1, 1);
	if(string_char_at(_gradeLevel[_i], 2) != " ") {
		_stringGrade += string_copy(_gradeLevel[_i], 2, 1); // one or two digit number, check second pos for being a number (not a space) and if so add it. Hopefully no grade levels are reported as like 2b or something but I guess it'd be fine anyway..?
	}
	_stringGrade += "\""; // close string chain at end
	
	var _dataText = $"{_stringJapWriting} \"{_translationEng[_i]}\" [ {_stringKanjiContained} ] {_stringHir} {_stringGrade}";
	if(irandom(1000) == 0) {
		show_debug_message(_dataText);
	}
	file_text_write_string(_wordDump, _dataText); // write data to file
	file_text_writeln(_wordDump);
}

file_text_close(_wordDump);
file_text_close(_file);
