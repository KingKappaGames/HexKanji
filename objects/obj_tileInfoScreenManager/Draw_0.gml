draw_set_halign(fa_center);
draw_set_valign(fa_middle);


script_drawCircleWidth(x, y, tileSize * 1.85, tileSize * .4, 64, c_black, 1);
draw_circle_color(x, y, tileSize * 1.5, c_dkgray, c_dkgray, false);
var _offset = 90;
if(menuTabCount == 2) {
	_offset = 180;
}
for(var _i = 0; _i < menuTabCount; _i++) {
	if(optionHovering == _i) {
		var _dist = point_distance(x, y, mouse_x, mouse_y);
		if(_dist < tileSize * 2.25 && _dist > tileSize * 1.48) {
			draw_set_color(c_orange);
		}
	}
	if(array_get_index(menuTabList, menuTabOpen) == _i) {
		draw_set_color(c_fuchsia);
		draw_text_transformed(x + dcos(_i * (360 / menuTabCount) + _offset) * tileSize * 1.8, y - 10 - dsin(_i * (360 / menuTabCount) + _offset) * tileSize * 1.8, menuTabList[_i], .3, .3, 0);
	} else {
		draw_text_transformed(x + dcos(_i * (360 / menuTabCount) + _offset) * tileSize * 1.8, y - 10 - dsin(_i * (360 / menuTabCount) + _offset) * tileSize * 1.8, menuTabList[_i], .3, .3, 0);
	}
	draw_set_color(c_white);
}

if(menuTabOpen == "symbol") {
	draw_text_transformed(x, y, symbol, 4 / string_length(symbol), 4 / string_length(symbol), 0);
} else { // not symbol main tab
	draw_text_transformed(x, y - tileSize * 1.25, symbol, .7, .7, 0);
	if(menuTabOpen == "pronunciation") {
		var _pronunciationCount = array_length(pronunciation);
		for(var _i = _pronunciationCount - 1; _i > -1; _i--) {
			draw_text_transformed(x, y - 60 * (_pronunciationCount / 2) + 60 * _i, pronunciation[_i], .7, .7, 0);
		}
	} else if(menuTabOpen == "description") {
		draw_text_ext_transformed(x, y, description, 90, tileSize * 5.6, .5, .5, 0);
	} else if(menuTabOpen == "technical") {
		draw_text_ext_transformed(x, y, verbType, 80, tileSize * 5.6, .5, .5, 270);
	} else if(menuTabOpen == "difficulty") {
		draw_text_transformed(x, y, difficulty, 4, 4, 0);
	} else if(menuTabOpen == "example") {
		if(array_length(examples) != 0) {
			var _sentenceData = manager.totalSentenceCollectionList[| examples[exampleSentenceCurrentIndex]];
			var _lineEnd = 1;
			var _lineStart = 1;
			var _verticalSteps = 0;
		
			while(_lineEnd < string_length(_sentenceData[0])) { // cant split kanji with no spaces for string ext...
				_lineEnd += 12; // kanji per line
		        draw_text_transformed(x, y - tileSize * .8 + 41 * _verticalSteps, string_copy(_sentenceData[0], _lineStart, _lineEnd - _lineStart), .45, .45, 0);
		        _verticalSteps++;
		        _lineStart = _lineEnd;
			
		    }
			draw_text_ext_transformed(x, y + tileSize * .24, _sentenceData[1], 80, tileSize * 7.2, .4, .4, 0);
			draw_text_ext_transformed(x, y + tileSize * 1.18, _sentenceData[4], 80, tileSize * 3, .7, .7, 0);
		
			draw_text_transformed(x, y + tileSize, "Arrow keys to change example", .35, .35, 0);
		} else {
			draw_text_transformed(x, y, "13000\n example sentences\nand not one\n has this kanji!", .8, .8, 0);
		}
	} else if(menuTabOpen == "meaning") {
		var _meaningCount = array_length(meaning);
		for(var _i = _meaningCount - 1; _i > -1; _i--) {
			draw_text_transformed(x, y - 60 * (_meaningCount / 2) + 60 * _i, meaning[_i], .6, .6, 0);
		}
	} else if(menuTabOpen == "romaji") {
		var _romajiCount = array_length(romaji);
		draw_text_transformed(x + 690, y - tileSize / 2 + 22, "* means On reading!", .5, .6, 0); //note to the side about * readings
		for(var _i = _romajiCount - 1; _i > -1; _i--) {
			draw_text_transformed(x, y - 60 * (_romajiCount / 2) + 60 * _i, romaji[_i], .7, .7, 0);
		}
	}
}

draw_set_halign(fa_left);