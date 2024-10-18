draw_set_halign(fa_center);

if(keyboard_check_released(vk_escape) || (optionHovering != -1 && keyboard_check_released(vk_enter))) { // use the hovering variable that is set on first frame to delay the enter check, janky, kinda not super, but works
	instance_destroy();
}

var _mouseDir = ((point_direction(x, y, mouse_x, mouse_y) + 270) + (180 / menuTabCount)) % 360; // nightmare line for real, pound sand nerd if you can't read this effortlessly
	
optionHovering = floor((_mouseDir / 360) * menuTabCount);
	
if(mouse_check_button_released(mb_left)) {
	var _dist = point_distance(x, y, mouse_x, mouse_y);
	if(_dist < tileSize * 2.25 && _dist > tileSize * 1.48) {
		audio_play_sound(snd_correctDing, 0, 0);
		menuTabOpen = menuTabList[optionHovering];
	}
}