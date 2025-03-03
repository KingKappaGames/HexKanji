draw_set_halign(fa_center);
draw_set_valign(fa_middle);


script_drawCircleWidth(x, y, infoWheelRadius, infoWheelEdgeThickness, 128, #090909, 1);
draw_circle_color(x, y, infoWheelRadius, c_dkgray, c_dkgray, false);
var _offset = 90;
if(menuTabCount == 2) {
	_offset = 180;
}
for(var _i = 0; _i < menuTabCount; _i++) {
	if(optionHovering == _i) {
		var _dist = point_distance(x, y, mouse_x, mouse_y);
		if(_dist < (infoWheelRadius + infoWheelEdgeThickness) && _dist > (infoWheelRadius)) { // from inner to outer edge
			draw_set_color(c_orange);
		}
	}
	if(array_get_index(menuTabList, menuTabOpen) == _i) {
		draw_set_color(c_fuchsia);
		draw_text_transformed(x + dcos(_i * (360 / menuTabCount) + _offset) * (infoWheelRadius + infoWheelEdgeThickness / 2), y - 10 - dsin(_i * (360 / menuTabCount) + _offset) * (infoWheelRadius + infoWheelEdgeThickness / 2), menuTabList[_i], .28, .3, 0);
	} else {
		draw_text_transformed(x + dcos(_i * (360 / menuTabCount) + _offset) * (infoWheelRadius + infoWheelEdgeThickness / 2), y - 10 - dsin(_i * (360 / menuTabCount) + _offset) * (infoWheelRadius + infoWheelEdgeThickness / 2), menuTabList[_i], .28, .3, 0);
	}
	draw_set_color(c_white);
}

if(menuTabOpen == "symbol") {
	var _scaling = (5 * infoWheelRadius / room_width); // this simply adjusts the areas depending on either room width or wheel radius (in theory this allows for easier customization in the future, we'll see)
	draw_text_transformed(x, y, symbol, (4 / string_length(symbol)) * _scaling, (4 / string_length(symbol)) * _scaling, 0); // this 
} else { // not symbol main tab
	draw_text_transformed(x, y - infoWheelRadius * .85, symbol, .8, .8, 0);
	if(menuTabOpen == "pronunciation") {
		var _pronunciationCount = array_length(pronunciation);
		var _pronunciationGap = 72;
		for(var _i = _pronunciationCount - 1; _i > -1; _i--) {
			draw_text_transformed(x, y - _pronunciationGap * (_pronunciationCount / 2) + _pronunciationGap * _i, pronunciation[_i], .8, .8, 0);
		}
	} else if(menuTabOpen == "description") {
		draw_text_ext_transformed(x, y, description, 90, infoWheelRadius * 2.93, .6, .6, 0); // text scale affects this (wheel radius * .9 * 2 halves * (1/.6)
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
		
			var _scaleKanji = .5;
			var _lineWidthKanji = round(7 / _scaleKanji);
			while(_lineEnd < string_length(_sentenceData[0])) { // cant split kanji with no spaces for string ext...
				_lineEnd += _lineWidthKanji; // kanji per line
		        draw_text_transformed(x, y - infoWheelRadius * .51 + 42 * _verticalSteps, string_copy(_sentenceData[0], _lineStart, _lineEnd - _lineStart), _scaleKanji, _scaleKanji, 0);
		        _verticalSteps++;
		        _lineStart = _lineEnd;
			
		    }
			
			var _scaleEnglish = .4;
			var _lineWidthEnglish = (infoWheelRadius * 1.75) / _scaleEnglish; // this gets the width of the wheel but acounts for the text size since the width in GM doesn't use scale in it's calculations
			draw_text_ext_transformed(x, y + infoWheelRadius * .27, _sentenceData[1], 80, _lineWidthEnglish, _scaleEnglish, _scaleEnglish, 0); // translated sentence
			
			draw_text_transformed(x, y + infoWheelRadius * .89, _sentenceData[4], .7, .7, 0); // difficulty
			draw_text_transformed(x, y + infoWheelRadius * .78, "Arrow keys to change example", .35, .35, 0); // arrow key guide text
		} else {
			draw_text_transformed(x, y, "13000\n example sentences and not\none has this kanji!", .8, .8, 0);
		}
	} else if(menuTabOpen == "meaning") {
		var _meaningCount = array_length(meaning);
		for(var _i = _meaningCount - 1; _i > -1; _i--) {
			draw_text_transformed(x, y - 60 * (_meaningCount / 2) + 60 * _i, meaning[_i], .6, .6, 0);
		}
	} else if(menuTabOpen == "romaji") {
		var _romajiCount = array_length(romaji);
		draw_rectangle_color(x + (infoWheelRadius + infoWheelEdgeThickness) * 1.03, y - infoWheelRadius * .12, x + (infoWheelRadius + infoWheelEdgeThickness) * 2, y + infoWheelRadius * .12, #88bbff, #88bbff, #88bbff, #88bbff, false);
		draw_text_transformed(x + (infoWheelRadius + infoWheelEdgeThickness) * 1.385, y, "* means On reading!", .4, .5, 0); //note to the side about * readings
		for(var _i = _romajiCount - 1; _i > -1; _i--) {
			draw_text_transformed(x, y - 60 * (_romajiCount / 2) + 60 * _i, romaji[_i], .7, .7, 0);
		}
	}
}

draw_set_halign(fa_left);