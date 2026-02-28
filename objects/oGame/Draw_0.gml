/// oGame Draw Event (for in-game visual elements)
// Safety check: make sure oConfig has initialized
if (!variable_global_exists("view_w") || !variable_global_exists("view_h")) {
    exit;
}


// DRAW LANE DIVIDER LINES (clearer visualization)
// Draw two vertical RED lines to separate the 3 lanes
var lane_width = DESIGN_W / 3;

// Line between left lane and center lane (at x=256)
draw_line_width_colour(lane_width, 0, lane_width, DESIGN_H, 3, c_red, c_red);

// Line between center lane and right lane (at x=512)
draw_line_width_colour(lane_width * 2, 0, lane_width * 2, DESIGN_H, 3, c_red, c_red);

// OPTIONAL: Draw semi-transparent background for good lane (center)
var gl = lane_bounds(good_lane());
draw_set_alpha(0.15);
draw_rectangle_colour(gl[0], 0, gl[1], DESIGN_H, c_green, c_green, c_green, c_green, false);
draw_set_alpha(1.0);

// Danger line
var game_over_y = DESIGN_H - 130;
draw_line_width_colour(0, game_over_y, DESIGN_W, game_over_y, 3, c_red, c_red);
draw_text_colour(DESIGN_W/2-60, game_over_y-25, "DANGER LINE", c_red, c_red, c_red, c_red, 1);

