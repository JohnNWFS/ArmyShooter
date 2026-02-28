/// spawn_particles(x, y, color, count=10)
function spawn_particles(_x, _y, _col, _count = 10) {
    repeat(_count) {
        var ang = random(360);
        var spd = random_range(2, 6);
        var vx = lengthdir_x(spd, ang);
        var vy = lengthdir_y(spd, ang) - 3;
        with (instance_create_layer(_x, _y, "Instances", oParticle)) {
            x = _x; y = _y; color = _col;
            vx = vx; vy = vy; lifetime = 30; max_lifetime = 30;
            size = irandom_range(3, 6);
        }
    }
}