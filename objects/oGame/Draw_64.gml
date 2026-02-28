/// oGame Draw GUI event (HUD ONLY - doesn't cover game objects)

// Safety check: make sure oConfig has initialized
/// oGame - Draw GUI Event
/// Display game stats and active power-ups

// Set font
draw_set_font(-1);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

// Stats box background at top
var box_height = 120;
draw_set_alpha(0.7);
draw_rectangle_color(0, 0, DESIGN_W, box_height, c_black, c_black, c_black, c_black, false);
draw_set_alpha(1);
draw_rectangle_color(0, 0, DESIGN_W, box_height, c_white, c_white, c_white, c_white, true);

// Top row: Score, Level, Army (centered in thirds)
var third = DESIGN_W / 3;

// Score (left third)
draw_set_halign(fa_center);
draw_text_color(third * 0.5, 20, "SCORE", c_yellow, c_yellow, c_yellow, c_yellow, 1);
draw_text_color(third * 0.5, 50, string(score), c_white, c_white, c_white, c_white, 1);

// Level (middle third)
draw_text_color(third * 1.5, 20, "LEVEL", c_aqua, c_aqua, c_aqua, c_aqua, 1);
draw_text_color(third * 1.5, 50, string(oLevelManager.level), c_white, c_white, c_white, c_white, 1);

// Army (right third)
draw_text_color(third * 2.5, 20, "ARMY", c_lime, c_lime, c_lime, c_lime, 1);
draw_text_color(third * 2.5, 50, string(instance_number(oSoldier)) + " / " + string(global.MAXSOLDIERS), c_white, c_white, c_white, c_white, 1);

// Power-up bars (aligned with lanes)
var bar_y = 85;
var bar_height = 25;
var lane_width = DESIGN_W / 3;

// Lane 0 (Left) - Shield power-up
if (global.rapid_fire_active) {
    var progress = global.rapid_fire_timer / 360;
    draw_rectangle_color(0, bar_y, lane_width * progress, bar_y + bar_height, 
        c_yellow, c_yellow, c_orange, c_orange, false);
    draw_set_halign(fa_center);
    draw_set_color(c_black);
    draw_text(lane_width * 0.5, bar_y + 5, "RAPID FIRE");
}

// Lane 1 (Center) - Double Damage power-up
if (instance_exists(oSoldier) && oSoldier.shield) {
    // Check if ANY soldier has shield
    var has_shield = false;
    with (oSoldier) {
        if (shield) {
            has_shield = true;
            var progress = shield_timer / 360;
            draw_rectangle_color(lane_width, bar_y, lane_width + (lane_width * progress), bar_y + bar_height,
                c_aqua, c_aqua, c_blue, c_blue, false);
            break;
        }
    }
    if (has_shield) {
        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text(lane_width * 1.5, bar_y + 5, "SHIELD");
    }
}

// Lane 2 (Right) - Rapid Fire power-up
if (global.double_damage_active) {
    var progress = global.double_damage_timer / 360;
    draw_rectangle_color(lane_width * 2, bar_y, lane_width * 2 + (lane_width * progress), bar_y + bar_height,
        make_color_rgb(255,100,255), make_color_rgb(255,100,255), 
        make_color_rgb(200,0,200), make_color_rgb(200,0,200), false);
    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text(lane_width * 2.5, bar_y + 5, "DOUBLE DAMAGE");
}

// Reset draw settings
draw_set_color(c_white);
draw_set_halign(fa_left);


/*if (!variable_global_exists("view_w") || !variable_global_exists("view_h")) {
    exit;
}

draw_set_font(-1);
draw_text_colour(30, 30, "SCORE: " + string(score), c_yellow, c_yellow, c_yellow, c_yellow, 1);
draw_text_colour(30, 100, "LEVEL: " + string(oLevelManager.level), c_aqua, c_aqua, c_aqua, c_aqua, 1);
draw_text_colour(30, 160, "ARMY: " + string(instance_number(oSoldier)), c_lime, c_lime, c_lime, c_lime, 1);

// ── DEBUG: Pulsing border to verify visible play area ──
var pulse = 5 + 5 * sin(current_time * 0.005);
var col = make_color_hsv(current_time * 0.1 mod 255, 255, 255);

var border = pulse;
draw_rectangle_colour(
    border,
    border,
    DESIGN_W - border - 1,
    DESIGN_H - border - 1,
    col, col, col, col,
    true
);

// Optional: actual camera bounds in white
draw_rectangle_colour(0, 0, DESIGN_W-1, DESIGN_H-1, c_white, c_white, c_white, c_white, true);

// DEBUG INFO (you can remove these later)
//draw_text_colour(30, 220, "Lane 0: " + string(lane_bounds(0)[0]) + " to " + string(lane_bounds(0)[1]), c_white, c_white, c_white, c_white, 1);
//draw_text_colour(30, 250, "Lane 1: " + string(lane_bounds(1)[0]) + " to " + string(lane_bounds(1)[1]), c_white, c_white, c_white, c_white, 1);
//draw_text_colour(30, 280, "Lane 2: " + string(lane_bounds(2)[0]) + " to " + string(lane_bounds(2)[1]), c_white, c_white, c_white, c_white, 1);
//draw_text_colour(30, 310, "WIDTH: " + string(DESIGN_W), c_white, c_white, c_white, c_white, 1);
*/