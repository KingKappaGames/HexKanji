///@desc Given the rubi text (with the formatting brackets) will return each area of clarified text / furigana text and the position of the original japanese plain text each section cooresponds to in char indexs
function script_getKanjiRubiPairs(rubiText, kanjiPlainText) {
	var _textLength = string_length(rubiText);
	var _bracketType = 0; // 0 is begin <rbORrt>, 1 is end </rbORrt>
	var _textType = 0; // 0 means kanji, 1 means furigana (furigana means rubi text?? I didn't know that till I googled it just now)
	var _searchedLength = 0;
	
	var _openPos = 0;
	var _closePos = 0;
	var _kanjiTextPos = 0; // this is the position of the kanji text in the actual plain text japanes, when you match up the rubi text with the plain text you need to search for the kanji that you have and from the pos you're at else you might find the same kanji several times and only mark one with multiple furiganas
	var _kanjiText = "";
	var _kanjiTextLength = 0;
	
	var _resultArray = [];
	var _resultIndex = 0;
	
	while(_searchedLength < _textLength - 4) { // - 4 because </xy> is 5 characters and must be the end of any search if applicable BUT strings are 1 indexed... (this mostly just prevents end runoff)
		if(_bracketType == 0) { // open
			if(_textType == 0) { // open kanji
				_openPos = string_pos_ext("<rb>", rubiText, _searchedLength);
				if(_openPos != 0) {
					_searchedLength = _openPos + 4;
					_bracketType = 1;
					continue;
				} else {
					break; // if no further openings then you're done
				}
			} else { // open furigana for previous kanji
				_openPos = string_pos_ext("<rt>", rubiText, _searchedLength);
				if(_openPos != 0) {
					_searchedLength = _openPos + 4;
					_bracketType = 1;
					continue;
				} else {
					break; // if no further openings then you're done
				}
			}
		} else if(_bracketType == 1) { // close
			if(_textType == 0) { // close kanji
				_closePos = string_pos_ext("</rb>", rubiText, _searchedLength);
				if(_closePos != 0) {
					_searchedLength = _closePos + 5;
					_bracketType = 0;
					_textType = 1; // furigana
					
					_kanjiText = string_copy(rubiText, _openPos + 4, (_closePos - _openPos) - 4);
					_kanjiTextLength = string_length(_kanjiText);
					
					continue;
				} else {
					break; // if no further openings then you're done
				}
			} else { // close furigana for previous kanji
				_closePos = string_pos_ext("</rt>", rubiText, _searchedLength);
				if(_closePos != 0) {
					_searchedLength = _closePos + 5;
					_bracketType = 0;
					_textType = 0; // back to kanji
					
					var _plainTextPos = string_pos_ext(_kanjiText, kanjiPlainText, _kanjiTextPos);
					_kanjiTextPos = _plainTextPos;
					
					array_push(_resultArray, [_plainTextPos, _plainTextPos + _kanjiTextLength, string_copy(rubiText, _openPos + 4, (_closePos - _openPos) - 4)]);
					
					_resultIndex++;
					
					continue;
				} else {
					break; // if no further openings then you're done
				}
			}
		}
	}
	
	return _resultArray;
}