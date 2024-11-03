if(difficultyChangeDisplayTimer > 0) {
	draw_set_halign(fa_left);
	draw_set_alpha(difficultyChangeDisplayTimer / difficultyChangeTextFadeTime);
	draw_text_transformed(17, 30, $"{difficultyGeneratorData} : difficulty levels", .45, .55, 0);
	if(difficultyChangedSinceGen) {
		draw_text_transformed_color(32, 75, $"You have unapplied map changes", .5, .5, 0, c_red, c_red, c_red, c_red, difficultyChangeDisplayTimer / difficultyChangeTextFadeTime);
	}
	draw_set_alpha(1);
	draw_set_halign(fa_center);
}
