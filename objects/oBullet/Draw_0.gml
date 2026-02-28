var i = 0;
var sz = ds_queue_size(trail);
var temp = ds_queue_create();
repeat(sz) {
    var p = ds_queue_dequeue(trail);
    ds_queue_enqueue(trail, p);
    ds_queue_enqueue(temp, p);
    
    var a = 100 * (i + 1) / sz;
    var s = 6 * (i + 1) / sz;
    draw_set_alpha(a / 255);
    var col = damage > 1 ? make_color_rgb(255,100,255) : make_color_rgb(255,255,100);
    draw_circle_color(p[0], p[1], s, col, col, false);
    i++;
}
ds_queue_destroy(temp);
draw_set_alpha(1);

var col = damage > 1 ? make_color_rgb(255,100,255) : BULLET_COLOR;
draw_rectangle_color(x, y, x+8, y+16, col, col, col, col, false);
draw_rectangle_color(x, y, x+8, y+16, c_white, c_white, c_white, c_white, true);