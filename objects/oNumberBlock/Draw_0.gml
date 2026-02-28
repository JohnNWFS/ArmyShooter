/// oNumberBlock Draw Event

// Visual feedback based on value
if (value >= max_value) {
    image_blend = c_lime;  // Bright green when maxed at +5
} else if (value <= min_value) {
    image_blend = c_red;   // Red when at minimum -5
} else if (value < 0) {
    image_blend = c_orange;  // Orange for negative
} else {
    image_blend = c_green;   // Green for positive
}

draw_self();

// Text showing value in the middle
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text_transformed_color(
    x + BLOCK_SIZE * 0.5,
    y + BLOCK_SIZE * 0.5,
    string(value),
    1, 1, 0,
    c_white, c_white, c_white, c_white,
    1
);

// Optional: Progress bar for negative blocks (currently commented out)
if (value < 0) {
    var prog = 1 - abs(value) / abs(original_value);
    var bw = BLOCK_SIZE - 10;
    var bx = x + 5, by = y + BLOCK_SIZE + 5;
    //draw_rectangle_color(bx, by, bx + bw, by + 4, c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
    //draw_rectangle_color(bx, by, bx + bw * prog, by + 4, c_yellow, c_yellow, c_yellow, c_yellow, false);
}

// Debug info (comment out for release)
//draw_text(x-20, y-20, id);
//draw_text(x-20, y-40, "Block");