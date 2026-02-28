/// oSoldier - Draw Event
/// Draw the soldier (rectangle for now, or sprite if assigned)

// Check if this soldier has a sprite assigned
if (sprite_index != -1) {
    // Draw the sprite
    draw_self();
    
    // Draw shield effect if active
    if (shield) {
        var a = 100 + 50 * sin(shield_timer * 0.2);
        draw_set_alpha(a / 255);
        draw_circle_color(x + sprite_width/2, y + sprite_height/2, sprite_width/2 + 5, c_aqua, c_aqua, true);
        draw_set_alpha(1);
    }
} else {
    // No sprite - draw blue rectangle
    var col = make_color_rgb(0, 100, 255);
    draw_rectangle_color(x, y, x + size, y + size, col, col, col, col, false);
    draw_rectangle_color(x, y, x + size, y + size, make_color_rgb(100, 150, 255), c_white, c_white, c_white, true);
    
    // Draw shield effect if active
    if (shield) {
        var a = 100 + 50 * sin(shield_timer * 0.2);
        draw_set_alpha(a / 255);
        draw_circle_color(x + size/2, y + size/2, size/2 + 5, c_aqua, c_aqua, true);
        draw_set_alpha(1);
    }
}