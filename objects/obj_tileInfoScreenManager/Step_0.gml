draw_set_halign(fa_center);

if(keyboard_check_released(vk_escape) || (optionHovering != -1 && keyboard_check_released(vk_enter))) { // use the hovering variable that is set on first frame to delay the enter check, janky, kinda not super, but works
	instance_destroy();
}

var _mouseDir = ((point_direction(x, y, mouse_x, mouse_y) + 270) + (180 / menuTabCount)) % 360; // nightmare line for real, pound sand nerd if you can't read this effortlessly
	
optionHovering = floor((_mouseDir / 360) * menuTabCount);
	
if(mouse_check_button_released(mb_left)) {
	var _dist = point_distance(x, y, mouse_x, mouse_y);
	if(_dist < (infoWheelRadius + infoWheelEdgeThickness) && _dist > (infoWheelRadius)) { // from inner to outer edge
		audio_play_sound(snd_correctDing, 0, 0);
		menuTabOpen = menuTabList[optionHovering];
	}
}

if(menuTabOpen == "example") {
	if(keyboard_check_released(vk_left)) {
		exampleSentenceCurrentIndex = clamp(exampleSentenceCurrentIndex - 1, 0, 99999);
	}
	if(keyboard_check_released(vk_right)) {
		exampleSentenceCurrentIndex = clamp(exampleSentenceCurrentIndex + 1, 0, array_length(examples) - 1);
	}
}