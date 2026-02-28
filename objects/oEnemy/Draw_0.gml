/// oEnemy - Draw Event

// Flash effect
if (flash > 0) {
    draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, c_white, 1);
} else {
    draw_sprite(sprite_index, 0, x, y);
}

// HP Bar (only if damaged)
if (hp < max_hp) {
    var bar_width = sprite_width;
    var bar_height = (is_boss || is_mini_boss) ? 6 : 4;
    var hp_ratio = hp / max_hp;
    
    // Background
    draw_rectangle_color(x, y - 10, x + bar_width, y - 10 + bar_height, 
        c_dkgray, c_dkgray, c_dkgray, c_dkgray, false);
    
    // Foreground
    var bar_color = (is_boss || is_mini_boss) ? c_yellow : c_lime;
    draw_rectangle_color(x, y - 10, x + bar_width * hp_ratio, y - 10 + bar_height, 
        bar_color, bar_color, bar_color, bar_color, false);
}

// Boss/Mini-boss border (optional visual enhancement)
if (is_boss || is_mini_boss) {
    draw_sprite_ext(sprite_index, 0, x, y, 1, 1, 0, c_yellow, 0.3);
}