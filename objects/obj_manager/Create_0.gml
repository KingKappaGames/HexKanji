randomize();

global.manager = id;
global.movementLocked = 0;
displayGalleryMode = false; // no quizes and shows the meaning and romaji on the tile by default

x = 2100;
y = 2100;

var _dictionary = file_text_open_write("wordDictionary.txt");
file_text_write_string(_dictionary, ""); // clear word data from file before rebuilding
file_text_close(_dictionary);

totalWordCollectionList = ds_list_create(); // preload the arrays to a theoretical max size...
totalSentenceCollectionList = ds_list_create(); //this will be a 2d array of all sentences and in the sub arrays the data for each sentence. Then the word collections will simply store index references to the sentences that they relate to and refer back via that

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
moveSpeed = 7;

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

	var _wordCount = ds_list_size(totalWordCollectionList);
	for(var _x = 0; _x < mapWidth; _x++) {
		for(var _y = 0; _y < mapHeight; _y++) {
			var _wordIndex = irandom(_wordCount - 1);
			var _filterValue = 1;
			/*with(obj_filter) {
				var _dist = point_distance(tileX, tileY, _x, _y) / tileRadius;
				_filterValue *= other.totalWordCollectionList[| _wordIndex][4] / 7;
				if(_filterValue < 1 - _dist) { // fail condition
					//reset tile attempt... there must be a better way to get tile values like this than just randomly grabbing until it fufills all options...
				}
			}*/
			while(totalWordCollectionList[| _wordIndex][4] > 2) {
				_wordIndex = irandom(_wordCount - 1);
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
					var _col = make_color_rgb(0, irandom_range(0, 128), irandom_range(128, 255));//choose(c_red, c_blue, c_green, c_purple, c_orange);
					draw_rectangle_color(_x * tileGapHorizontal - _xCut - x % tileGapHorizontal, _y * tileGapVertical - _yCut - y % tileGapVertical, _x * tileGapHorizontal - _xCut + tileGapHorizontal - x % tileGapHorizontal, _y * tileGapVertical - _yCut + tileGapVertical - y % tileGapVertical, _col, _col, _col, _col, false);
					draw_text_transformed((_x + .5) * tileGapHorizontal - _xCut - x % tileGapHorizontal, _y * tileGapVertical + tileGapVertical / 2 - _yCut - y % tileGapVertical, tiles[_x][_y][0], clamp(3 / string_length(tiles[_x][_y][0]), .3, .75), clamp(4 / string_length(tiles[_x][_y][0]), .3, .75), 0);
					if(displayGalleryMode) {
						draw_text_transformed((_x + .5) * tileGapHorizontal - _xCut - x % tileGapHorizontal, _y * tileGapVertical + tileGapVertical / 2 - _yCut - y % tileGapVertical - tileGapVertical * .3, tiles[_x][_y][1][0], clamp(2 / string_length(tiles[_x][_y][3][0]), .3, .75), clamp(3 / string_length(tiles[_x][_y][3][0]), .3, .75), 0);
						draw_text_transformed((_x + .5) * tileGapHorizontal - _xCut - x % tileGapHorizontal, _y * tileGapVertical + tileGapVertical / 2 - _yCut - y % tileGapVertical + tileGapVertical * .3, tiles[_x][_y][3][0], clamp(2 / string_length(tiles[_x][_y][3][0]), .3, .75), clamp(3 / string_length(tiles[_x][_y][3][0]), .3, .75), 0);
					}
					
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
	_quiz.initializeQuiz(_tileX, _tileY, ["symbol"], ["meaningWheel", "romajiWheel", "pronunciationWheel"], 3 + irandom(5), 0);
}

startTileInfoScreen = function() {
	var _tileX = round(x / tileGapHorizontal);
	var _tileY = round(y / tileGapVertical);
	
	var _quiz = instance_create_depth(_tileX * tileGapHorizontal, _tileY * tileGapVertical, -100, obj_tileInfoScreenManager); // maybe these should both be made into made quiz () ? idk
	_quiz.initializeInfoScreen(_tileX, _tileY);
}
#endregion

#region word packs and file stuff
///@deprecated
///@desc This function takes a provided file adress and copies it's contents to the top of the word list
addWordSet = function(packURL) {
	var _packRead = file_text_open_read(packURL);
	var _dictionary = getDictWrite();
	
	while(!file_text_eof(_packRead)) {
		file_text_write_string(_dictionary, file_text_read_string(_packRead));  
		file_text_writeln(_dictionary);
		file_text_readln(_packRead);
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

getSentenceTextFromDictionary = function(sentenceIndex) {
	var _collectionRead = file_text_open_read("wordDictionary.txt");
	
	repeat(sentenceIndex - 1) {
		file_text_readln(_collectionRead);
		if(file_text_eof(_collectionRead)) {
			show_error($"You have requested a sentence with an index greater than the total sentence count! Monka. Index: {sentenceIndex}", true);
		}
	}
	var _sentenceData = file_text_readln(_collectionRead);
	closeFile(_collectionRead);
	
	return _sentenceData;
}

parseWordTextToArray = function(wordText) {
	//parse the text to arrays and text and reals
	var _wordDataArr = [];
	
	var _charCount = string_length(wordText) - 1; // you have to cut off the new line character at the end with this -1
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
	
	//array_push(_wordDataArr, array_create(0, 0)); // stick an array on the end for sentence ids, (NOT ANYMORE, switching to local sorting)
	
	//show_debug_message(_wordDataArr)
	return _wordDataArr;
}

parseSentenceTextToArray = function(sentenceText) {
	//parse the text to arrays and text and reals
	var _sentenceDataArr = [];
	
	var _charCount = string_length(sentenceText) - 1; // you have to cut off the new line character at the end with this -1
	var _target = _sentenceDataArr; // set the target to sub arrays as they are created
	var _chunkStartPos = 1; // the beginning of this piece of data in the string
	var _forceQuotes = false;
	for(var _charI = 1; _charI <= _charCount; _charI++) {
		//show_debug_message(_sentenceDataArr)
		if(!_forceQuotes) {
			if(string_char_at(sentenceText, _charI) == " " || _charI == _charCount) { // if text broken by SPACE or ending then block word within those spaces based on the chunk start pos and current value adjusted for character
				array_push(_target, string_copy(sentenceText, _chunkStartPos, (_charI - _chunkStartPos) + (_charI == _charCount))); // push word pos back or forward but not if it's at the end because then it's not a character thing but a position thing and thus there's no character to adjust for...
				_chunkStartPos = _charI + 1;
			} else if(string_char_at(sentenceText, _charI) == "[") { // can only handle one array deep because it doesn't track history of ins and outs for targetting
				_target = array_create(0, 0);
				_charI += 1;
				_chunkStartPos = _charI + 1; // if you find an array opener then jump the scan forward past the array and following space to the start of the first value and set new word start too, also set target to new array for this opener
			} else if(string_char_at(sentenceText, _charI) == "]") {
				array_push(_sentenceDataArr, _target); // before you close this array's construction add the set to the main set
			
				_target = _sentenceDataArr;
				_charI += 1;
				_chunkStartPos = _charI + 1;
			} else if(string_char_at(sentenceText, _charI) == "\"") {
				_forceQuotes = true;
				_chunkStartPos = _charI + 1; // start the quote block and set beginning to first quoted character
			}
			
		} else {
			if(string_char_at(sentenceText, _charI) == "\"") {
				_forceQuotes = false;
				array_push(_target, string_copy(sentenceText, _chunkStartPos, (_charI - _chunkStartPos))); // push word pos back or forward but not if it's at the end because then it's not a character thing but a position thing and thus there's no character to adjust for...
				_charI++;
				_chunkStartPos = _charI + 1;
			}
		}
		
		//show_debug_message($"End: {_wordDataArr}");
	}

	return _sentenceDataArr;
}

///@desc Returns an info array of the values for a word
///@param word This can either be the word text as a string or an index as a real (:
getWordData = function(word = -1) {	
	if(word == -1) {
		word = irandom(ds_list_size(totalWordCollectionList) - 1);
	}
	
	if(is_string(word)) {
		return parseWordTextToArray(word);
	}
	
	if(is_real(word)) {
		return totalWordCollectionList[| word];
		//return parseWordTextToArray(getWordTextFromDictionary(word)); // if you want to grab one word from the text file...
	}
}

///@desc Adds the given files data into the data set directly, adding onto the initially created set
loadAllWordsFromFileToDataCollection = function(fileURL) {
	var _collectionRead = file_text_open_read(fileURL);
	
	while(!file_text_eof(_collectionRead)) {
		ds_list_add(totalWordCollectionList, parseWordTextToArray(file_text_readln(_collectionRead)));
	}
	
	file_text_close(_collectionRead);
}

loadAllSentencesFromFileToDataCollection = function(fileURL) {
	var _collectionRead = file_text_open_read(fileURL);
	
	while(!file_text_eof(_collectionRead)) {
		ds_list_add(totalSentenceCollectionList, parseSentenceTextToArray(file_text_readln(_collectionRead)));
	}
	
	file_text_close(_collectionRead);
}

///@deprecated
///@desc This function goes through all the words in the game set and applies sentence index's to their data. However I've stopped doing it this way in favor of single instance checking when the user wants that item to avoid the upfront lag ~20 seconds. That's the word.
matchWordsWithSentences = function() {
	var _sentCount = ds_list_size(totalSentenceCollectionList); 
	var _sentOffset = irandom(_sentCount - 1);
	
	for(var _i = ds_list_size(totalWordCollectionList) - 1; _i > -1; _i--) {
		for(var _sentI = 0; _sentI < _sentCount; _sentI++) {
			if(array_contains(totalSentenceCollectionList[| (_sentI + _sentOffset) % (_sentCount - 1)][2], totalWordCollectionList[| _i][0])) { // if word kanji contained in sentence kanji
				array_push(totalWordCollectionList[| _i][6], (_sentI + _sentOffset) % (_sentCount - 1)); // add sentence index to word's sentences array
			}
		}
	}
}

#region file managment scripts (open / close) (The files should be being read directly to array, not transfered to a main file then read..........)
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
loadAllWordsFromFileToDataCollection("theGovSet.TXT");
loadAllSentencesFromFileToDataCollection("kanjiSentenceDump.txt");

//this should be setting the collections to empty preinit arrays, then with all desired files adding directly from those files into the arrays (vs concat to dict file then reading..WHY) then trimming the arrays.

setTileGrid(0, 0, 0, 200, 200, 200, 200);