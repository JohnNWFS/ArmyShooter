/// oEnemy - Step Event

// Swarm enemies move faster
if (is_swarm) {
    y += 3;  // Swarms move at 3 pixels/frame
} else {
    y += SCROLL_SPEED;  // Regular/boss/mini-boss move at 2 pixels/frame
}

// Boss/Mini-boss sine wave movement
if (is_boss || is_mini_boss) {
    move_timer += 0.05;
    var bounds = lane_bounds(lane);
    var center_x  = (bounds[0] + bounds[1]) / 2;
    var amplitude = (bounds[1] - bounds[0]) / 2 - size;
    x = center_x  + sin(move_timer) * amplitude - size/2;
}

// Flash timer
if (flash > 0) flash--;

// Check collision with soldiers
var soldier = instance_place(x, y, oSoldier);
if (soldier != noone) {
    if (soldier.shield) {
        // Shield absorbs hit
        soldier.shield = false;
        soldier.shield_timer = 0;
        spawn_particles(soldier.x + 12, soldier.y + 12, c_aqua, 15);
        
        // Destroy enemy unless it's a boss/mini-boss
        if (!is_boss && !is_mini_boss) {
            spawn_particles(x + size/2, y + size/2, ENEMY_COLOR, 20);
            instance_destroy();
        }
    } else {
        // No shield - soldier dies
        spawn_particles(soldier.x + 12, soldier.y + 12, SOLDIER_COLOR, 20);
        instance_destroy(soldier);
        global.combo = 0;
        
        // Regular enemies also die on impact (including swarms)
        if (!is_boss && !is_mini_boss) {
            spawn_particles(x + size/2, y + size/2, ENEMY_COLOR, 15);
            instance_destroy();
        }
    }
}

// Destroy if off screen
if (y > DESIGN_H + 100) {
    instance_destroy();
}