/// get_wave_pattern(level, wave_number) -> struct
function get_wave_pattern(_level, _wave) {
    // Level 1 - Tutorial waves
    if (_level == 1) {
        switch(_wave) {
            case 0: // First wave - 3 regular enemies (tutorial)
                return {
                    enemy_count: 3,
                    spawn_interval: 120,
                    enemy_size_min: 50,
                    enemy_size_max: 60,
                    is_mini_boss: false,
                    is_boss: false,
                    is_swarm: false,
                    swarm_formation: 0,
                    description: "Welcome wave"
                };
            
            case 1: // Second wave - SWARM FLOOD!
                return {
                    enemy_count: 12,  // 12 groups × 4-6 each = 48-72 enemies!
                    spawn_interval: 30,  // Spawn every 0.5 seconds
                    enemy_size_min: 20,
                    enemy_size_max: 20,
                    is_mini_boss: false,
                    is_boss: false,
                    is_swarm: true,
                    swarm_formation: 5,
                    description: "Swarm invasion"
                };
            
            case 2: // Third wave - MASSIVE SWARM + few regulars
                return {
                    enemy_count: 15,  // Mix of swarms and regulars
                    spawn_interval: 25,
                    enemy_size_min: 20,
                    enemy_size_max: 20,
                    is_mini_boss: false,
                    is_boss: false,
                    is_swarm: true,
                    swarm_formation: 6,
                    description: "Swarm horde"
                };
            
            case 3: // Mini-boss wave (with swarm escorts!)
                return {
                    enemy_count: 8,  // Swarms + mini-boss
                    spawn_interval: 40,
                    enemy_size_min: 20,
                    enemy_size_max: 80,  // Mix: swarms (20) and mini-boss (80)
                    is_mini_boss: true,
                    is_boss: false,
                    is_swarm: false,
                    swarm_formation: 5,
                    description: "Mini-boss with escort"
                };
            
            case 4: // Boss wave
                return {
                    enemy_count: 1,
                    spawn_interval: 0,
                    enemy_size_min: 100,
                    enemy_size_max: 100,
                    is_mini_boss: false,
                    is_boss: true,
                    is_swarm: false,
                    swarm_formation: 0,
                    description: "Boss fight"
                };
        }
    }
    
    // Level 2+ - SWARM APOCALYPSE
    var base_count = 10 + (_level * 5);  // Scale up massively with level
    var base_interval = max(20, 40 - (_level * 3));  // Faster spawning
    
    // Mini-boss every 4th wave
    if (_wave > 0 && _wave % 4 == 3) {
        return {
            enemy_count: 1,
            spawn_interval: 0,
            enemy_size_min: 80 + (_level * 5),
            enemy_size_max: 80 + (_level * 5),
            is_mini_boss: true,
            is_boss: false,
            is_swarm: false,
            swarm_formation: 0,
            description: "Mini-boss"
        };
    }
    
    // Boss at end of level
    var max_wave = 5 + (_level * 2);
    if (_wave >= max_wave - 1) {
        return {
            enemy_count: 1,
            spawn_interval: 0,
            enemy_size_min: 100 + (_level * 10),
            enemy_size_max: 100 + (_level * 10),
            is_mini_boss: false,
            is_boss: true,
            is_swarm: false,
            swarm_formation: 0,
            description: "Level boss"
        };
    }
    
    // Regular waves - 75% are SWARM WAVES
    var use_swarm = (random(1) < 0.75);  // 75% chance = swarms everywhere!
    
    return {
        enemy_count: base_count,
        spawn_interval: base_interval,
        enemy_size_min: use_swarm ? 20 : (35 + (_level * 2)),
        enemy_size_max: use_swarm ? 20 : (50 + (_level * 5)),
        is_mini_boss: false,
        is_boss: false,
        is_swarm: use_swarm,
        swarm_formation: use_swarm ? min(6, 4 + _level) : 0,
        description: use_swarm ? "Swarm wave" : "Wave " + string(_wave + 1)
    };
}