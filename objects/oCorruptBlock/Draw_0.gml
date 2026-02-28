/// oCorruptBlock - Draw Event

// Pulsing red danger effect
var pulse_scale = 1 + 0.1 * sin(pulse);
image_blend = c_red;
image_alpha = 0.8 + 0.2 * sin(pulse * 2);

draw_sprite_ext(spr_WhiteBlock, 0, x, y, pulse_scale, pulse_scale, 0, c_white, image_alpha);

// Red warning circle
var circle_alpha = 0.3 + 0.3 * sin(pulse);
draw_set_alpha(circle_alpha);
draw_circle_color(x + 30, y + 30, 35, c_red, c_red, true);
draw_set_alpha(1);