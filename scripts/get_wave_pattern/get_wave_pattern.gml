/// get_wave_pattern(level, wave_number) -> struct
function get_wave_pattern(_level, _wave) {
    // Level 1 - Tutorial + escalating pressure
    if (_level == 1) {
        switch(_wave) {
            case 0: // First wave - onboarding, but no dead air
                return {
                    enemy_count: 6,
                    spawn_interval: 70,
                    enemy_size_min: 40,
                    enemy_size_max: 55,
                    is_mini_boss: false,
                    is_boss: false,
                    is_swarm: false,
                    swarm_formation: 0,
                    description: "Opening push"
                };

            case 1: // Swarm lane pressure starts
                return {
                    enemy_count: 18,
                    spawn_interval: 18,
                    enemy_size_min: 20,
                    enemy_size_max: 20,
                    is_mini_boss: false,
                    is_boss: false,
                    is_swarm: true,
                    swarm_formation: 7,
                    description: "Relentless swarm"
                };

            case 2: // True horde wave
                return {
                    enemy_count: 26,
                    spawn_interval: 14,
                    enemy_size_min: 20,
                    enemy_size_max: 20,
                    is_mini_boss: false,
                    is_boss: false,
                    is_swarm: true,
                    swarm_formation: 8,
                    description: "Horde crush"
                };

            case 3: // Mini-boss with continuous pressure
                return {
                    enemy_count: 12,
                    spawn_interval: 24,
                    enemy_size_min: 20,
                    enemy_size_max: 80,
                    is_mini_boss: true,
                    is_boss: false,
                    is_swarm: false,
                    swarm_formation: 6,
                    description: "Mini-boss + escorts"
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

    // Level 2+ - sustained pressure while preserving fair reaction windows
    var base_count = 16 + (_level * 6);
    var base_interval = max(12, 28 - (_level * 2));

    // Mini-boss every 4th wave
    if (_wave > 0 && _wave % 4 == 3) {
        return {
            enemy_count: 1,
            spawn_interval: 0,
            enemy_size_min: 80 + (_level * 6),
            enemy_size_max: 80 + (_level * 6),
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
            enemy_size_min: 100 + (_level * 12),
            enemy_size_max: 100 + (_level * 12),
            is_mini_boss: false,
            is_boss: true,
            is_swarm: false,
            swarm_formation: 0,
            description: "Level boss"
        };
    }

    // Regular waves - mostly swarms, occasional bruiser wave.
    var use_swarm = (random(1) < 0.85);

    return {
        enemy_count: base_count,
        spawn_interval: base_interval,
        enemy_size_min: use_swarm ? 20 : (38 + (_level * 3)),
        enemy_size_max: use_swarm ? 20 : (56 + (_level * 6)),
        is_mini_boss: false,
        is_boss: false,
        is_swarm: use_swarm,
        swarm_formation: use_swarm ? min(9, 6 + _level) : 0,
        description: use_swarm ? "Horde wave" : "Bruiser wave"
    };
}
