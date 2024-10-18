///@desc This function returns the data array for the tile requested. Data will be symbol, romaji, pronunciation, meaning.
function script_getTileData(xSource, ySouce, value = -1){
	if(value == -1) {
		return global.tiles[xSource][ySouce];
	} else {
		// if value = string?
		return global.tiles[xSource][ySouce][value];
	}
}