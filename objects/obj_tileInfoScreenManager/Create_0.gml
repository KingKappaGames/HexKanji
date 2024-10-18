global.movementLocked = 1;

tileSize = global.tileGapGeneral;
tileX = 0;
tileY = 0;

symbol = "H";
meaning = "Dog";
pronunciation = "Ee-nu"; // not a format because not answerable in a meaningful way and romaji already does this
romaji = "Inu";

menuTabOpen = "symbol";
menuTabList = ["symbol", "technical", "pronunciation", "meaning", "description", "difficulty", "romaji", "example"]; // idk if half these will stick around but hey, just display the info nerd
menuTabCount = array_length(menuTabList);
optionHovering = -1; // highlight and pass this option when making symbol guess

difficulty = irandom(3); // jplt levels?
description = "No description now.";
verbType = "not implemented"; // ichidan, godan



initializeInfoScreen = function(xTile, yTile) {
	tileX = xTile;
	tileY = yTile;
	
	var _data = script_getTileData(tileX, tileY);
	symbol = _data[0];
	romaji = _data[1];
	pronunciation = _data[2];
	meaning = _data[3];
	difficulty = _data[4];
	description = _data[5];
}