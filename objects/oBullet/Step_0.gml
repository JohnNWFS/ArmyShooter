/// oBullet - Step Event (MANUAL COLLISION - FIXED)

// Update trail
ds_queue_enqueue(trail, [x, y]);
if (ds_queue_size(trail) > 5) ds_queue_dequeue(trail);

// Move bullet upward
y -= BULLET_SPEED;

// Bullet rectangle
var bullet_left = x;
var bullet_right = x + 8;
var bullet_top = y;
var bullet_bottom = y + 16;
var bullet_damage = damage;  // Store for use in with statements

// Check collision with NUMBER BLOCKS
with (oNumberBlock) {
    var block_left = x;
    var block_right = x + BLOCK_SIZE;
    var block_top = y;
    var block_bottom = y + BLOCK_SIZE;
    
    // Rectangle overlap check
    if (bullet_right > block_left && bullet_left < block_right &&
        bullet_bottom > block_top && bullet_top < block_bottom) {
        
        // Only damage if block hasn't reached max value
        if (value < max_value) {
            value += bullet_damage;
            
            // Clamp to max value
            if (value > max_value) {
                value = max_value;
            }
            
            // Visual feedback when maxed
            if (value >= max_value) {
                image_blend = c_lime;  // Flash green when maxed at +5
            }
            
            spawn_particles(x + BLOCK_SIZE/2, y + BLOCK_SIZE/2,
                value > 0 ? POS_BLOCK_COLOR : CONVERTING_COLOR, 8);
            
            // Update score
            with (oGame) {
                score += bullet_damage;
            }
            
            // Destroy bullet and exit
            if (ds_exists(other.trail, ds_type_queue)) {
                ds_queue_destroy(other.trail);
            }
            instance_destroy(other);
            exit;
        }
        // If value >= max_value, bullet passes through
    }
}

// Check collision with ENEMIES (using precise sprite collision)
var hit_enemy = instance_place(x, y, oEnemy);
if (hit_enemy != noone) {
    with (hit_enemy) {
        hp -= other.damage;  // Use other.damage to get bullet's damage
        flash = 6;
        
        if (hp <= 0) {
            var pts = is_boss ? 100 : (is_mini_boss ? 50 : 5);
            
            with (oGame) {
                score += pts;
            }
            
            var col = is_boss ? BOSS_COLOR : (is_mini_boss ? make_color_rgb(180,50,50) : ENEMY_COLOR);
            var cnt = is_boss ? 35 : (is_mini_boss ? 25 : 15);
            
            spawn_particles(x + size/2, y + size/2, col, cnt);
            
            global.combo++;
            global.combo_timer = 120;
            
            // LOG DEATH EVENT
            var enemy_subtype = is_boss ? "boss" : (is_mini_boss ? "mini_boss" : "regular");
            var frames_lived = global.game_timer - birth_time;
            log_death_event("ENEMY_DEATH", enemy_subtype, lane, size, hp, 
                            global.game_timer, oLevelManager.wave_count, oLevelManager.level, frames_lived);
            
            if (is_boss) boss_defeated();
            instance_destroy();
        }
    }
    
    // Destroy the bullet (we're back in bullet's context here)
    if (ds_exists(trail, ds_type_queue)) {
        ds_queue_destroy(trail);
    }
    instance_destroy();
}

// Destroy if off screen
if (y < -50) {
    if (ds_exists(trail, ds_type_queue)) {
        ds_queue_destroy(trail);
    }
    instance_destroy();
}