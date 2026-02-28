/// oPlayerFormation - Draw Event
/// Only draw indicator if you have multiple soldiers

// Only show the formation center indicator if you have 2+ soldiers
if (instance_number(oSoldier) > 1) {
    draw_set_alpha(0.3);
   // draw_circle_color(x, y, 6, c_yellow, c_yellow, false);
    draw_set_alpha(1.0);
   // draw_circle_color(x, y, 6, c_yellow, c_yellow, true);
}