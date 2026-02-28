/// oNumberBlock - Step Event

// Move downward
y += BLOCK_SPEED;

// Pulse animation
pulse += 0.1;

// Check collision with soldiers
if (place_meeting(x, y, oSoldier)) {
    //show_debug_message("BLOCK COLLECTED! Value: " + string(value));
    
    // Handle positive blocks
    if (value > 0) {
        var current_soldiers = instance_number(oSoldier);
        var soldiers_to_add = min(value, global.MAXSOLDIERS - current_soldiers);
        
        if (soldiers_to_add > 0) {
            repeat (soldiers_to_add) {
                instance_create_layer(0, 0, "Instances", oSoldier);
            }
            score += soldiers_to_add * 10;
        }
        spawn_particles(x + BLOCK_SIZE/2, y + BLOCK_SIZE/2, POS_BLOCK_COLOR, 20);
    }
    // Handle negative blocks
    else if (value < 0) {
        var lose = abs(value);
        repeat (lose) {
            var s = instance_find(oSoldier, 0);
            if (s != noone) instance_destroy(s);
        }
        score = max(0, score - 10);
        spawn_particles(x + BLOCK_SIZE/2, y + BLOCK_SIZE/2, NEG_BLOCK_COLOR, 25);
    }
    
    // Destroy the block
    instance_destroy();
}

// Destroy if off screen
if (y > DESIGN_H + 100) {
    instance_destroy();
}