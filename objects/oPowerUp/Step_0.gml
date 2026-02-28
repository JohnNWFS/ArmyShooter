/// oPowerUp - Step Event

// Move downward
y += BLOCK_SPEED;

// Pulse animation
pulse += 0.1;

// Check collision with soldiers
if (place_meeting(x, y, oSoldier)) {
    switch (type) {
        case 0:
            global.rapid_fire_active = true;
            global.rapid_fire_timer = 360;
            break;
        case 1:
            with (oSoldier) { shield = true; shield_timer = 360; }
            break;
        case 2:
            global.double_damage_active = true;
            global.double_damage_timer = 360;
            break;
    }
    var cols = [c_yellow, c_aqua, make_color_rgb(255,100,255)];
    spawn_particles(x+20, y+20, cols[type], 18);
    instance_destroy();
}

// Destroy if off screen
if (y > DESIGN_H + 100) {
    instance_destroy();
}