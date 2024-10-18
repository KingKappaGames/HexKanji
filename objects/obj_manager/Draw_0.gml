if(updateSurfaceNextFrame == 1) {
	makeLocalSurface(x, y);
	updateSurfaceNextFrame = 0;
}

draw_surface(getLocalSurface(), surfaceDrawX - surface_get_width(getLocalSurface()) / 2, surfaceDrawY - surface_get_height(getLocalSurface()) / 2);

draw_set_color(c_black);
draw_circle(x, y, 5, true);
draw_set_color(c_white);

draw_text_transformed(x, y - 500, fps_real, .4, .4, 0);
/*
draw_text_transformed(x, y - 500, debugData[0], .3, .3, 0);
draw_text_transformed(x, y - 480, debugData[1], .3, .3, 0);
draw_text_transformed(x, y - 460, debugData[2], .3, .3, 0);
draw_text_transformed(x, y - 440, debugData[3], .3, .3, 0);
draw_text_transformed(x, y - 420, debugData[4], .3, .3, 0);
draw_text_transformed(x, y - 400, debugData[5], .3, .3, 0);