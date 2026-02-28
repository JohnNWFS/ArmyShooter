/// oSoldier - Step Event

// Use FIRE_RATE macro, halved when rapid fire is active
var rate = global.rapid_fire_active ? max(4, FIRE_RATE / 2) : FIRE_RATE;

fire_timer = (fire_timer + 1) % rate;

if (shield) {
    shield_timer--;
    if (shield_timer <= 0) shield = false;
}

if (fire_timer == 0) {
    // Center bullet on soldier
    // Soldier is at (x, y) with size 24
    // Bullet is 8 wide, so offset by (24-8)/2 = 8 to center horizontally
    var bx = x + 12 - 4;  // Center of soldier (x + 12) minus half bullet width (4)
    var by = y - 20;      // Spawn above soldier
    
    with (instance_create_layer(bx, by, "Instances", oBullet)) {
        damage = global.double_damage_active ? 2 : 1;
    }
}