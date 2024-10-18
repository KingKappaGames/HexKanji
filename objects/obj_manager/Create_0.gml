randomize();

global.manager = id;
global.movementLocked = 0;

x = 2100;
y = 2100;

var _dictionary = file_text_open_write("wordDictionary.txt");
file_text_write_string(_dictionary, "");
file_text_close(_dictionary);

totalWordCount = 0;
totalWordCollectionArray = [];

#region tile sizes and map size
global.tileGapHorizontal = 200;
global.tileGapVertical = 200;
global.tileGapGeneral = 200;
tileGapHorizontal = 200;
tileGapVertical = 200;
tileGapGeneral = 200;
//script_SetTileSize(200, 200, 200);

tileMapWidth = 1000;
tileMapHeight = 1000;
#endregion

global.jpFont = font_add(working_directory + "ARIALUNI.TTF", 64, false, false, 32, 127);
draw_set_font(global.jpFont); // SETS FONT WITH JAPANESE SUPPORT???

localSurface = -1;
localBuffer = -1;

surfaceDrawX = x;
surfaceDrawY = y;

debugData = [0, 0, 0, 0, 0, 0];

goalX = x;
goalY = y;
moving = 0;
moveSpeed = 3;

updateSurfaceNextFrame = 1;

setTileGrid = function(tileSet, sorting, clumping, mapWidth, mapHeight, tileWidth, tileHeight) {
	// tileSet can a genre, 
	
	tileGapHorizontal = tileWidth;
	tileGapVertical = tileHeight;
	
	if(buffer_exists(localBuffer)) {
		buffer_delete(localBuffer);
	}
	localBuffer = buffer_create(ceil(camera_get_view_width(view_camera[0]) / tileGapHorizontal) * ceil(camera_get_view_height(view_camera[0]) / tileGapVertical) * tileGapHorizontal * tileGapVertical * 9, buffer_fixed, 1);
	
	tileMapWidth = tileGapHorizontal * mapWidth;
	tileMapHeight = tileGapVertical * mapHeight;
	
	x = tileMapWidth / 2 - (x % tileGapHorizontal) + tileGapHorizontal / 2;
	y = tileMapHeight / 2 - (y % tileGapVertical) + tileGapVertical / 2;
	
	surfaceDrawX = x;
	surfaceDrawY = y;
	
	global.tiles = array_create(mapWidth); // reset tile info
	tiles = global.tiles;
	for(var i = 0; i < mapWidth; i++) {
	    tiles[i] = array_create(mapHeight, 0);
	}

	for(var _x = 0; _x < mapWidth; _x++) {
		for(var _y = 0; _y < mapHeight; _y++) {
			var _wordIndex = irandom(totalWordCount - 1);
			var _filterValue = 1;
			with(obj_filter) {
				var _dist = point_distance(tileX, tileY, _x, _y) / tileRadius;
				_filterValue *= other.totalWordCollectionArray[_wordIndex][4] / 7;
				if(_filterValue < 1 - _dist) { // fail condition
					//reset tile attempt... there must be a better way to get tile values like this than just randomly grabbing until it fufills all options...
				}
			}
			tiles[_x, _y] = getWordData(_wordIndex); // tile get from style of request
		}
	}
	//algorithms for selecting harder, longer, more common, ect kanji from the sets
	
	updateSurfaceNextFrame = 1;
}

#region surfaces and buffers
drawLocalSurface = function() {
	if(surface_exists(localSurface)) {
		//draw event, called in draw!
		surface_set_target(localSurface);
		
		var _x = round((x - surface_get_width(getLocalSurface()) / 2) / tileGapHorizontal);
		var _y = round((y - surface_get_height(getLocalSurface()) / 2) / tileGapVertical);
		var _xCut = _x * tileGapHorizontal;
		var _yCut =	_y * tileGapVertical;
		
		var _drawHor = floor(surface_get_width(getLocalSurface()) / tileGapHorizontal);
		var _drawVer = floor(surface_get_height(getLocalSurface()) / tileGapHorizontal);
		
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		repeat(_drawVer) {
			repeat(_drawHor) {
				if(_x > -1 && _x < tileMapWidth / tileGapHorizontal && _y > -1 && _y < tileMapHeight / tileGapVertical) {
					var _col = make_color_rgb(0, irandom(128), irandom_range(128, 255));//choose(c_red, c_blue, c_green, c_purple, c_orange);
					draw_rectangle_color(_x * tileGapHorizontal - _xCut - x % tileGapHorizontal, _y * tileGapVertical - _yCut - y % tileGapVertical, _x * tileGapHorizontal - _xCut + tileGapHorizontal - x % tileGapHorizontal, _y * tileGapVertical - _yCut + tileGapVertical - y % tileGapVertical, _col, _col, _col, _col, false);
					draw_text_transformed((_x + .5) * tileGapHorizontal - _xCut - x % tileGapHorizontal, _y * tileGapVertical + tileGapVertical / 2 - _yCut - y % tileGapVertical, tiles[_x][_y][0], clamp(3 / string_length(tiles[_x][_y][0]), .3, .75), clamp(4 / string_length(tiles[_x][_y][0]), .3, .75), 0);
					//draw_text_transformed((_x + .5) * tileGapHorizontal - _xCut - x % tileGapHorizontal, _y * tileGapVertical + tileGapVertical / 2 - _yCut - y % tileGapVertical, tiles[_x][_y][3][0], clamp(3 / string_length(tiles[_x][_y][3][0]), .3, .75), clamp(4 / string_length(tiles[_x][_y][3][0]), .3, .75), 0);
				} else {
					var _col = make_color_rgb(127 + irandom(64), irandom(128) + 127, irandom_range(128, 255));//choose(c_red, c_blue, c_green, c_purple, c_orange);
					draw_rectangle_color(_x * tileGapHorizontal - _xCut - x % tileGapHorizontal, _y * tileGapVertical - _yCut - y % tileGapVertical, _x * tileGapHorizontal - _xCut + tileGapHorizontal - x % tileGapHorizontal, _y * tileGapVertical - _yCut + tileGapVertical - y % tileGapVertical, _col, _col, _col, _col, false);
				}
				_x++;
			}
			_x -= _drawHor;
			_y++;
		}
		surface_reset_target();
		debugData = [_x, _y, _xCut, _yCut, _drawHor, _drawVer];
		buffer_get_surface(localBuffer, localSurface, 0);
	} // else kys, I pass this surface from the surface create it should absolutely exist
}

makeLocalSurface = function(xCenter, yCenter) {
	if(surface_exists(localSurface)) {
		surface_set_target(localSurface);
		draw_clear_alpha(c_black, 1);
		surface_reset_target();
	} else {
		localSurface = surface_create(ceil(camera_get_view_width(view_camera[0]) * 1.5 / tileGapHorizontal) * tileGapHorizontal, ceil(camera_get_view_height(view_camera[0]) * 1.5 / tileGapVertical) * tileGapVertical);
	}
	
	drawLocalSurface();
	
	return localSurface;
	//draw a bunch of stuff to the surface..
}

getLocalSurface = function() {
	if(surface_exists(localSurface)) {
		return localSurface;
	} else {
		localSurface = surface_create(ceil(camera_get_view_width(view_camera[0]) * 1.5 / tileGapHorizontal) * tileGapHorizontal, ceil(camera_get_view_height(view_camera[0]) * 1.5 / tileGapVertical) * tileGapVertical);
		buffer_set_surface(localBuffer, localSurface, 0);
		return localSurface;
	}
}

#endregion

#region tile functionality
startTileQuiz = function() {
	var _tileX = round(x / tileGapHorizontal);
	var _tileY = round(y / tileGapVertical);
	
	var _quiz = instance_create_depth(_tileX * tileGapHorizontal, _tileY * tileGapVertical, -100, obj_quizManager); // maybe these should both be made into made quiz () ? idk
	_quiz.initializeQuiz(_tileX, _tileY, ["symbol"], [choose("romaji", "meaning"), "meaningWheel", "romajiWheel", "pronunciationWheel"], 3 + irandom(5), 0);
}

startTileInfoScreen = function() {
	var _tileX = round(x / tileGapHorizontal);
	var _tileY = round(y / tileGapVertical);
	
	var _quiz = instance_create_depth(_tileX * tileGapHorizontal, _tileY * tileGapVertical, -100, obj_tileInfoScreenManager); // maybe these should both be made into made quiz () ? idk
	_quiz.initializeInfoScreen(_tileX, _tileY);
}
#endregion

#region word packs and file stuff
///@desc This function takes a provided file adress and copies it's contents to the top of the word list
addWordSet = function(packURL) {
	var _packRead = file_text_open_read(packURL);
	var _dictionary = getDictWrite();
	
	while(!file_text_eof(_packRead)) {
		file_text_write_string(_dictionary, file_text_read_string(_packRead));  
		file_text_writeln(_dictionary);
		file_text_readln(_packRead);
		totalWordCount++;
	}
	
	closeFile(_dictionary);
	closeFile(_packRead);
}

getWordTextFromDictionary = function(wordIndex) {
	var _dictRead = getDictRead();
	
	repeat(wordIndex - 1) {
		file_text_readln(_dictRead);
		if(file_text_eof(_dictRead)) {
			show_error($"You have requested a word with an index greater than the total word count! Monka. Index: {wordIndex}", true);
		}
	}
	var _wordData = file_text_readln(_dictRead);
	closeFile(_dictRead);
	
	return _wordData;
}

parseWordTextToArray = function(wordText) {
	//parse the text to arrays and text and reals
	var _wordDataArr = [];
	
	var _charCount = string_length(wordText);
	var _target = _wordDataArr; // set the target to sub arrays as they are created
	var _chunkStartPos = 1; // the beginning of this piece of data in the string
	var _forceQuotes = false;
	for(var _charI = 1; _charI <= _charCount; _charI++) {
		//show_debug_message(_wordDataArr)
		if(!_forceQuotes) {
			if(string_char_at(wordText, _charI) == " " || _charI == _charCount) { // if text broken by SPACE or ending then block word within those spaces based on the chunk start pos and current value adjusted for character
				array_push(_target, string_copy(wordText, _chunkStartPos, (_charI - _chunkStartPos) + (_charI == _charCount))); // push word pos back or forward but not if it's at the end because then it's not a character thing but a position thing and thus there's no character to adjust for...
				_chunkStartPos = _charI + 1;
			} else if(string_char_at(wordText, _charI) == "[") { // can only handle one array deep because it doesn't track history of ins and outs for targetting
				_target = array_create(0, 0);
				_charI += 1;
				_chunkStartPos = _charI + 1; // if you find an array opener then jump the scan forward past the array and following space to the start of the first value and set new word start too, also set target to new array for this opener
			} else if(string_char_at(wordText, _charI) == "]") {
				array_push(_wordDataArr, _target); // before you close this array's construction add the set to the main set
			
				_target = _wordDataArr;
				_charI += 1;
				_chunkStartPos = _charI + 1;
			} else if(string_char_at(wordText, _charI) == "\"") {
				_forceQuotes = true;
				_chunkStartPos = _charI + 1; // start the quote block and set beginning to first quoted character
			}
			
		} else {
			if(string_char_at(wordText, _charI) == "\"") {
				_forceQuotes = false;
				array_push(_target, string_copy(wordText, _chunkStartPos, (_charI - _chunkStartPos))); // push word pos back or forward but not if it's at the end because then it's not a character thing but a position thing and thus there's no character to adjust for...
				_charI++;
				_chunkStartPos = _charI + 1;
			}
		}
		
		//show_debug_message($"End: {_wordDataArr}");
	}
	
	//show_debug_message(_wordDataArr)
	return _wordDataArr;
}

///@desc Returns an info array of the values for a word
///@param word This can either be the word text as a string or an index as a real (:
getWordData = function(word = irandom(totalWordCount - 1)) {	
	if(is_string(word)) {
		return parseWordTextToArray(word);
	}
	
	if(is_real(word)) {
		return totalWordCollectionArray[word];
		//return parseWordTextToArray(getWordTextFromDictionary(word)); // if you want to grab one word from the text file...
	}
}

loadAllWordsFromFileToDataCollection = function() {
	totalWordCollectionArray = []; // clear data going in right? Maybe make function that simply adds word data from a pack to the total but to be fair that's what the text dictionary already does... Hm... Maybe it should be remade so that the text packs just add their data collections to the list and don't bother adding the text in the files itself... In fact now that I'm saying that it seems obvious... Damn
	for(var _wordI = 1; _wordI <= totalWordCount; _wordI++) {
		array_push(totalWordCollectionArray, parseWordTextToArray(getWordTextFromDictionary(_wordI)));
		//show_debug_message(totalWordCollectionArray[array_length(totalWordCollectionArray) - 1])
	}
}

#region file managment scripts (open / close)
getDictWrite = function() {
	return file_text_open_append("wordDictionary.txt");
}

getDictRead = function() {
	return file_text_open_read("wordDictionary.txt");
}

closeFile = function(fileId) {
	file_text_close(fileId);
}
#endregion
#endregion

//addWordSet("baseWords.txt");
//addWordSet("terrariaWords.txt");
addWordSet("kanjiDump.TXT");

loadAllWordsFromFileToDataCollection();

setTileGrid(0, 0, 0, 200, 200, 200, 200);