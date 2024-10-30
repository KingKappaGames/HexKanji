draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if(guessCurrentFormat != 0) {
	script_drawCircleWidth(x, y, tileSize * 1.15, tileSize * .4, 24, c_black, 1);
	script_drawCircleWidth(x, y, tileSize * 1.05, tileSize * .33, 24, c_dkgray, 1);
	var _offset = 90;
	if(guessOptionCount == 2) {
		_offset = 180;
	}
	for(var _i = 0; _i < guessOptionCount; _i++) {
		if(optionHovering == _i) {
			draw_set_color(c_orange);
		}

		if(string_length(guessList[_i]) < 3) {
			draw_text_transformed(x + dcos(_i * (360 / guessOptionCount) + _offset) * tileSize * 1.02, y - 10 - dsin(_i * (360 / guessOptionCount) + _offset) * tileSize * 1.02, guessList[_i], .75, .75, 0);
		} else {
			var _width = string_width(guessList[_i]);
			draw_text_transformed(x + dcos(_i * (360 / guessOptionCount) + _offset) * tileSize * 1.02, y - 10 - dsin(_i * (360 / guessOptionCount) + _offset) * tileSize * 1.02, guessList[_i], clamp(110 / _width, .22, 99), clamp(100 / _width + .1, .32, 99), 0);
		}
		draw_set_color(c_white);
	}
}

var _answerFormat = "";
if(array_contains(guessFormatAnswer, "romaji")) {
	_answerFormat = "romaji";	
} else if(array_contains(guessFormatAnswer, "meaning")) {
	_answerFormat = "meaning";	
}

if(_answerFormat != "") {
	draw_rectangle(x - tileSize / 2, y + tileSize / 4, x + tileSize / 2, y + tileSize / 2, true); 
	if(entryString != "") {
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text_transformed(x - tileSize / 2 + 2, y + 2 + tileSize * .2, entryString, clamp((tileSize - 2) / string_width(entryString), .1, .45), .5, 0);
	} else {
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		draw_text_transformed(x - tileSize / 2 + 2, y + 2 + tileSize * .2, "enter " + _answerFormat, .36, .5, 0);
	}
}

draw_set_halign(fa_left);