function script_SetTileSize(tileSizeHorizontal, tileSizeVertical, tileSizeGeneral = max(tileSizeHorizontal, tileSizeVertical)){
	global.tileGapHorizontal = tileSizeHorizontal;
	global.tileGapVertical = tileSizeVertical;
	global.tileGapGeneral = tileSizeGeneral;
	
	with(obj_manager) {
		tileGapHorizontal = tileSizeHorizontal;
		tileGapVertical = tileSizeVertical;
		tileGapGeneral = tileSizeGeneral;
	}
}