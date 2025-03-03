function script_drawCircleWidth(xCenter, yCenter, inner_radius, width, segments = 12, color = c_white, alpha = 1) {
	var jadd = 360/segments;
	draw_set_color(color);
	draw_set_alpha(alpha);
	draw_primitive_begin(pr_trianglestrip);
	for(var j = 0; j <= 360; j += jadd) {
	    draw_vertex(x + lengthdir_x(inner_radius, j), y + lengthdir_y(inner_radius, j));
	    draw_vertex(x + lengthdir_x(inner_radius + width, j), y + lengthdir_y(inner_radius + width, j));
	}
	draw_primitive_end();
	draw_primitive_begin(pr_trianglestrip);
	for(var j = 0; j <= 360; j += jadd) {
	    draw_vertex(x + lengthdir_x(inner_radius, j), y + lengthdir_y(inner_radius, j));
	    draw_vertex(x + lengthdir_x(inner_radius - width, j), y + lengthdir_y(inner_radius - width, j));
	}
	draw_primitive_end();
	draw_set_color(c_white);
	draw_set_alpha(1);
}