if(mouse_check_button_released(mb_left)) {
	if(moving == 0 && global.movementLocked == 0) {
		if(mouse_x > 0 && mouse_x < tileMapWidth && mouse_y > 0 && mouse_y < tileMapHeight) {
			goalX = mouse_x;
			goalY = mouse_y;
			moving = 1;
		}
		instance_destroy(obj_quizManager);
	}
}

if(keyboard_check_released(vk_enter)) {
	if(moving == 0 && global.movementLocked == 0) {
		startTileInfoScreen();
	}
}

if(moving == 1) {
	x = lerp(x, goalX, moveSpeed / 100);
	y = lerp(y, goalY, moveSpeed / 100);
	if(point_distance(x, y, goalX, goalY) < moveSpeed + 3) {
		moving = 0; // leave the player offset a bit, kinda fun maybe?
		startTileQuiz();
		surfaceDrawX = x;
		surfaceDrawY = y;
		updateSurfaceNextFrame = 1;
	}
}

camera_set_view_pos(view_camera[0], x - camera_get_view_width(view_camera[0]) / 2, y - camera_get_view_height(view_camera[0]) / 2);

if(keyboard_check_released(vk_tab)) {
	window_set_fullscreen(!window_get_fullscreen())
}

//show_debug_message($"x/y: {x},{y}")
//show_debug_message($"x/y: {global.tiles[floor(x / tileGapHorizontal)][floor(y / tileGapVertical)]}")