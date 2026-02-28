/// oGame - Step Event

// Increment game timer
global.game_timer++;

// Track soldier count changes
if (!variable_global_exists("last_soldier_count")) {
    global.last_soldier_count = 1;
}

var current_soldier_count = instance_number(oSoldier);

// Log significant soldier changes (every 5 soldiers or on decrease)
if (current_soldier_count != global.last_soldier_count) {
    var diff = current_soldier_count - global.last_soldier_count;
    
    if (abs(diff) >= 5 || diff < 0) {
        var event_type1 = diff > 0 ? "SOLDIER_INCREASE" : "SOLDIER_DECREASE";
        show_debug_message(string(current_time) + "," + 
                          string(global.game_timer) + "," + 
                          string(oLevelManager.level) + "," + 
                          string(oLevelManager.wave_count) + "," + 
                          event_type1 + "," + 
                          "army," + 
                          "1," + 
                          string(current_soldier_count) + "," + 
                          string(diff) + "," + 
                          string(instance_number(oEnemy)) + "," + 
                          string(current_soldier_count) + "," + 
                          string(score) + "," +
                          "0");
    }
    
    global.last_soldier_count = current_soldier_count;
}

// Print CSV header once
if (global.game_timer == 1) {
    show_debug_message("=== SPAWN LOG START ===");
    show_debug_message("timestamp,game_time,level,wave,type,subtype,lane,size,value,enemies_alive,soldiers_alive,score,lifetime");
}

// Safety check: make sure oConfig has initialized
if (!variable_global_exists("view_w") || !variable_global_exists("view_h")) {
    exit;
}

// 1. POWER-UP TIMERS
if (global.rapid_fire_timer > 0) {
    global.rapid_fire_timer--;
    if (global.rapid_fire_timer <= 0) global.rapid_fire_active = false;
}
if (global.double_damage_timer > 0) {
    global.double_damage_timer--;
    if (global.double_damage_timer <= 0) global.double_damage_active = false;
}
if (global.combo_timer > 0) {
    global.combo_timer--;
    if (global.combo_timer <= 0) global.combo = 0;
}

// 2. ENEMY SPAWNING (WAVE-BASED SYSTEM)
if (oLevelManager.state == 1) { // SPAWNING_WAVES
    oLevelManager.spawn_timer++;
    
    var pattern = oLevelManager.current_wave_pattern;
    
    // Check if we should spawn next enemy
    if (oLevelManager.enemies_spawned_this_wave < pattern.enemy_count) {
        var spawn_interval = pattern.spawn_interval;
        
        // First enemy spawns immediately
        if (oLevelManager.enemies_spawned_this_wave == 0) {
            spawn_interval = 60; // 1 second delay at wave start
        }
        
        if (oLevelManager.spawn_timer >= spawn_interval) {
            oLevelManager.spawn_timer = 0;
            
            // Determine enemy lane (left or right)
            var lanes = enemy_lanes();
            var lane = lanes[irandom(array_length(lanes) - 1)];
            
		// SWARM FORMATION SPAWNING
		if (pattern.is_swarm && pattern.swarm_formation > 0) {
		    // Spawn a group of swarm enemies in formation
		    var swarm_count = irandom_range(4, 6);  // Random 4-6 enemies per group
		    var spacing = 25; // Pixels between swarm enemies
		    var bounds = lane_bounds(lane);
    
		    // Calculate formation to fit within lane bounds
		    var formation_width = swarm_count * 20 + (swarm_count - 1) * spacing;
		    var spawn_y = -100;
    
		    // LEFT LANE (0): Start from left edge, spawn rightward
		    if (lane == 0) {
		        var start_x = bounds[0] + 5;  // 5px padding from left edge
        
		        for (var i = 0; i < swarm_count; i++) {
		            var spawn_x = start_x + i * (20 + spacing);
            
		            // Make sure we don't exceed lane bounds
		            if (spawn_x + 20 <= bounds[1]) {
		                with (instance_create_layer(spawn_x, spawn_y, "Instances", oEnemy)) {
		                    size = 20;
		                    max_hp = 1;
		                    hp = 1;
		                    lane = lane;
		                    is_mini_boss = false;
		                    is_boss = false;
		                    is_swarm = true;
		                    sprite_index = spr_enemy_swarm;
                    
		                    log_spawn_event("ENEMY", "swarm", lane, size, hp, 
		                                    global.game_timer, oLevelManager.wave_count, oLevelManager.level);
		                }
		            }
		        }
		    }
		    // RIGHT LANE (2): Start from right edge, spawn leftward
		    else if (lane == 2) {
		        var start_x = bounds[1] - 25;  // 5px padding from right edge, minus enemy size
        
		        for (var i = 0; i < swarm_count; i++) {
		            var spawn_x = start_x - i * (20 + spacing);
            
		            // Make sure we don't go below lane bounds
		            if (spawn_x >= bounds[0]) {
		                with (instance_create_layer(spawn_x, spawn_y, "Instances", oEnemy)) {
		                    size = 20;
		                    max_hp = 1;
		                    hp = 1;
		                    lane = lane;
		                    is_mini_boss = false;
		                    is_boss = false;
		                    is_swarm = true;
		                    sprite_index = spr_enemy_swarm;
                    
		                    log_spawn_event("ENEMY", "swarm", lane, size, hp, 
		                                    global.game_timer, oLevelManager.wave_count, oLevelManager.level);
		                }
		            }
		        }
		    }
    
		    oLevelManager.enemies_spawned_this_wave += swarm_count;
		} else {
                // REGULAR ENEMY SPAWNING
                var sz = irandom_range(pattern.enemy_size_min, pattern.enemy_size_max);
                var pos = find_clear_spawn_position(lane, sz, oEnemy, 15);
                
                if (pos != noone) {
                    with (instance_create_layer(pos[0], pos[1], "Instances", oEnemy)) {
                        size = sz;
                        max_hp = sz / 10;
                        if (max_hp < 2) max_hp = 2;
                        hp = max_hp;
                        lane = lane;
                        
                        is_mini_boss = pattern.is_mini_boss;
                        is_boss = pattern.is_boss;
                        is_swarm = false;
                        
                        // Boss setup
                        if (is_mini_boss) {
                            max_hp = size * 2;
                            hp = max_hp;
                            sprite_index = spr_enemy_mini;
                        }
                        if (is_boss) {
                            max_hp = size * 1.5;
                            hp = max_hp;
                            sprite_index = spr_enemy_boss;
                        } else if (!is_mini_boss) {
                            sprite_index = spr_enemy;
                        }
                        
                        // LOG SPAWN EVENT
                        var enemy_subtype = is_boss ? "boss" : (is_mini_boss ? "mini_boss" : "regular");
                        log_spawn_event("ENEMY", enemy_subtype, lane, size, hp, 
                                        global.game_timer, oLevelManager.wave_count, oLevelManager.level);
                    }
                    
                    oLevelManager.enemies_spawned_this_wave++;
                }
            }
        }
    } else {

        // Wave complete - check if all enemies dead
        if (instance_number(oEnemy) == 0) {
            oLevelManager.wave_count++;
            oLevelManager.enemies_spawned_this_wave = 0;
            oLevelManager.spawn_timer = 0;
            
            // Check if level complete
            var max_waves = 5; // Level 1 has 5 waves (0-4)
            if (oLevelManager.level > 1) {
                max_waves = 5 + (oLevelManager.level * 2);
            }
            
            if (oLevelManager.wave_count >= max_waves) {
                // Level complete!
                oLevelManager.state = 3; // LEVEL_COMPLETE
                oLevelManager.level_complete_timer = 180; // 3 second celebration
            } else {
                // Next wave
                oLevelManager.current_wave_pattern = get_wave_pattern(oLevelManager.level, oLevelManager.wave_count);
            }
        }
    }
}

// Handle level completion
if (oLevelManager.state == 3) { // LEVEL_COMPLETE
    oLevelManager.level_complete_timer--;
    
    if (oLevelManager.level_complete_timer <= 0) {
        // Start next level
        oLevelManager.level++;
        oLevelManager.state = 1;
        oLevelManager.wave_count = 0;
        oLevelManager.enemies_spawned_this_wave = 0;
        oLevelManager.spawn_timer = 0;
        oLevelManager.current_wave_pattern = get_wave_pattern(oLevelManager.level, 0);
    }
}

// 3. BLOCKS, CORRUPTED BLOCKS & POWER-UPS (STOP DURING BOSS FIGHTS)
var boss_alive = false;
with (oEnemy) {
    if (is_boss) {
        boss_alive = true;
        break;
    }
}

// Only spawn blocks if no boss is alive
if (!boss_alive) {
    block_spawn_counter++;
    if (block_spawn_counter >= BLOCK_SPAWN_RATE) {
        block_spawn_counter = 0;
        
        var pos = find_clear_spawn_position(good_lane(), 60, oNumberBlock, 15);
        
        if (pos != noone) {
            // Check if at max soldiers (49)
            var at_max_soldiers = (instance_number(oSoldier) >= global.MAXSOLDIERS);
            
            // If at max soldiers: 100% corrupted blocks (except wave 0)
            // Otherwise: 10% corrupted (normal)
            var spawn_corrupt = false;
            if (at_max_soldiers && oLevelManager.wave_count > 0) {
                spawn_corrupt = true;  // ALWAYS corrupt when maxed out!
            } else if (random(1) < 0.10 && oLevelManager.wave_count > 0) {
                spawn_corrupt = true;  // Normal 10% chance
            }
            
            if (spawn_corrupt) {
                // SPAWN CORRUPTED BLOCK
                with (instance_create_layer(pos[0], pos[1], "Instances", oCorruptBlock)) {
                    pulse = 0;
                    
                    log_spawn_event("CORRUPT", "corrupt", 1, 60, -5,
                                    global.game_timer, oLevelManager.wave_count, oLevelManager.level);
                }
            } else {
                // SPAWN NORMAL BLOCK
                var val;
                if (oLevelManager.wave_count == 0 && block_spawn_counter == 0) {
                    // First block: -2 to -1 (tutorial block)
                    val = -irandom_range(1, 2);
                } else {
                    // Normal blocks: 80% negative (-5 to -3), 20% positive (+1)
                    val = (random(1) < 0.80) ? -irandom_range(3, 5) : 1;
                }
                
                with (instance_create_layer(pos[0], pos[1], "Instances", oNumberBlock)) {
                    value = val;
                    original_value = val;
                    pulse = 0;
                    
                    // LOG SPAWN EVENT
                    var block_subtype = value > 0 ? "positive" : "negative";
                    log_spawn_event("BLOCK", block_subtype, 1, BLOCK_SIZE, value,
                                    global.game_timer, oLevelManager.wave_count, oLevelManager.level);
                }
            }
            
            // POWER-UP SPAWNING (15% chance) - STAYS THE SAME
            if (random(1) < 0.15) {
                // Check for clear space avoiding blocks, corrupted blocks, and other power-ups
                var powerup_pos = noone;
                var bounds = lane_bounds(good_lane());
                var spawn_y = -100;
                var attempts = 0;
                var max_attempts = 15;
                
                while (powerup_pos == noone && attempts < max_attempts) {
                    var spawn_x = irandom_range(bounds[0], bounds[1] - 40);
                    
                    // Check against oNumberBlock, oCorruptBlock, AND oPowerUp
                    var block_collision = collision_rectangle(spawn_x, spawn_y, spawn_x + 40, spawn_y + 40, oNumberBlock, false, true);
                    var corrupt_collision = collision_rectangle(spawn_x, spawn_y, spawn_x + 40, spawn_y + 40, oCorruptBlock, false, true);
                    var powerup_collision = collision_rectangle(spawn_x, spawn_y, spawn_x + 40, spawn_y + 40, oPowerUp, false, true);
                    
                    if (block_collision == noone && corrupt_collision == noone && powerup_collision == noone) {
                        powerup_pos = [spawn_x, spawn_y];
                    } else {
                        spawn_y -= 25; // Try further up
                        attempts++;
                    }
                }
                
                if (powerup_pos != noone) {
                    var pt = irandom(2);
                    with (instance_create_layer(powerup_pos[0], powerup_pos[1], "Instances", oPowerUp)) {
                        type = pt;
                        pulse = 0;
                        
                        // Set sprite based on type
                        switch (type) {
                            case 0: sprite_index = spr_powerup_rapid; break;
                            case 1: sprite_index = spr_powerup_shield; break;
                            case 2: sprite_index = spr_powerup_double; break;
                        }
                        
                        // LOG SPAWN EVENT
                        var powerup_subtype = "";
                        switch (type) {
                            case 0: powerup_subtype = "rapid_fire"; break;
                            case 1: powerup_subtype = "shield"; break;
                            case 2: powerup_subtype = "double_damage"; break;
                        }
                        
                        log_spawn_event("POWERUP", powerup_subtype, 1, 40, type,
                                        global.game_timer, oLevelManager.wave_count, oLevelManager.level);
                    }
                }
            }
        }
    }
}

// 4. SOLDIER COLLISION WITH NUMBER BLOCKS
with (oSoldier) {
    with (oNumberBlock) {
        var soldier_left = other.bbox_left;
        var soldier_right = other.bbox_right;
        var soldier_top = other.bbox_top;
        var soldier_bottom = other.bbox_bottom;
        
        var block_left = x;
        var block_right = x + BLOCK_SIZE;
        var block_top = y;
        var block_bottom = y + BLOCK_SIZE;
        
        if (soldier_right > block_left && soldier_left < block_right &&
            soldier_bottom > block_top && soldier_top < block_bottom) {
            
            if (value > 0) {
                // Add soldiers (max 5 per block due to cap)
                var add_count = min(value, global.MAXSOLDIERS - instance_number(oSoldier));
                repeat(add_count) {
                    instance_create_layer(0, 0, "Instances", oSoldier);
                }
                
                with (oGame) {
                    score += add_count * 10;
                }
            } else if (value < 0) {
                // Remove soldiers
                var remove_count = abs(value);
                repeat(remove_count) {
                    with (instance_find(oSoldier, 0)) {
                        if (instance_exists(self)) {
                            instance_destroy();
                            break;
                        }
                    }
                }
                
                with (oGame) {
                    score = max(0, score - 10);
                }
            }
            
            instance_destroy();
            exit;
        }
    }
}

// 5. SOLDIER COLLISION WITH CORRUPTED BLOCKS
with (oSoldier) {
    with (oCorruptBlock) {
        var soldier_left = other.bbox_left;
        var soldier_right = other.bbox_right;
        var soldier_top = other.bbox_top;
        var soldier_bottom = other.bbox_bottom;
        
        var corrupt_left = x;
        var corrupt_right = x + 60;
        var corrupt_top = y;
        var corrupt_bottom = y + 60;
        
        if (soldier_right > corrupt_left && soldier_left < corrupt_right &&
            soldier_bottom > corrupt_top && soldier_top < corrupt_bottom) {
            
            // Remove 5 soldiers
            var soldiers_to_remove = 5;
            
            repeat(soldiers_to_remove) {
                with (instance_find(oSoldier, 0)) {
                    if (instance_exists(self)) {
                        instance_destroy();
                        break;
                    }
                }
            }
            
            // Negative score penalty
            with (oGame) {
                score = max(0, score - 50);
            }
            
            // Destroy the corrupted block
            instance_destroy();
            exit;
        }
    }
}

// 6. SOLDIER COLLISION WITH POWER-UPS
with (oSoldier) {
    var hit_powerup = instance_place(x, y, oPowerUp);
    if (hit_powerup != noone) {
        with (hit_powerup) {
            switch (type) {
                case 0: // Rapid Fire
                    global.rapid_fire_active = true;
                    global.rapid_fire_timer = 360;
                    break;
                case 1: // Shield
                    with (oSoldier) {
                        shield = true;
                        shield_timer = 360;
                    }
                    break;
                case 2: // Double Damage
                    global.double_damage_active = true;
                    global.double_damage_timer = 360;
                    break;
            }
            
            with (oGame) {
                score += 5;
            }
            
            instance_destroy();
        }
        break;
    }
}

// 7. GAME OVER CHECKS
// Check if all soldiers dead
if (instance_number(oSoldier) == 0) {
    show_debug_message("###game_end###REASON:no_soldiers,TIME:" + string(global.game_timer));
    game_restart();
}

// Check if any enemy crossed danger line
with (oEnemy) {
    if (y + size >= GAME_OVER_LINE) {
        var enemy_type = is_boss ? "boss" : (is_mini_boss ? "mini_boss" : (is_swarm ? "swarm" : "regular"));
        show_debug_message("###game_end###REASON:enemy_crossed,ENEMY_TYPE:" + enemy_type +
                          ",TIME:" + string(global.game_timer));
        with (oGame) {
            game_restart();
        }
    }
}

// 2B. CONTINUOUS SWARM BACKGROUND SPAWNING (runs alongside main spawner)
// This adds ambient swarms even during regular waves
if (oLevelManager.state == 1) {
    var current_pattern = oLevelManager.current_wave_pattern;
    
    // Only spawn background swarms if we're in a regular wave (not swarm, boss, or mini-boss)
    if (!current_pattern.is_swarm && !current_pattern.is_boss && !current_pattern.is_mini_boss) {
        if (!variable_instance_exists(id, "swarm_background_timer")) {
            swarm_background_timer = 0;
        }
        
        swarm_background_timer++;
        
        // Spawn a small swarm group every 3 seconds
        if (swarm_background_timer >= 180) {
            swarm_background_timer = 0;
            
            var lanes = enemy_lanes();
            var lane = lanes[irandom(array_length(lanes) - 1)];
            var swarm_count = irandom_range(3, 4);  // Smaller background groups
            var spacing = 25;
            var bounds = lane_bounds(lane);
            var spawn_y = -100;
            
            if (lane == 0) {
                var start_x = bounds[0] + 5;
                for (var i = 0; i < swarm_count; i++) {
                    var spawn_x = start_x + i * (20 + spacing);
                    if (spawn_x + 20 <= bounds[1]) {
                        with (instance_create_layer(spawn_x, spawn_y, "Instances", oEnemy)) {
                            size = 20;
                            max_hp = 1;
                            hp = 1;
                            lane = lane;
                            is_mini_boss = false;
                            is_boss = false;
                            is_swarm = true;
                            sprite_index = spr_enemy_swarm;
                        }
                    }
                }
            } else if (lane == 2) {
                var start_x = bounds[1] - 25;
                for (var i = 0; i < swarm_count; i++) {
                    var spawn_x = start_x - i * (20 + spacing);
                    if (spawn_x >= bounds[0]) {
                        with (instance_create_layer(spawn_x, spawn_y, "Instances", oEnemy)) {
                            size = 20;
                            max_hp = 1;
                            hp = 1;
                            lane = lane;
                            is_mini_boss = false;
                            is_boss = false;
                            is_swarm = true;
                            sprite_index = spr_enemy_swarm;
                        }
                    }
                }
            }
        }
    }
}