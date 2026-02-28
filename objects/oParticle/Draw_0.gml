var a = 255 * (lifetime / max_lifetime);
var sz = size * (lifetime / max_lifetime);
if (sz > 0) {
    draw_set_alpha(a / 255);
    draw_circle_color(x, y, sz, color, color, false);
    draw_set_alpha(1);
}