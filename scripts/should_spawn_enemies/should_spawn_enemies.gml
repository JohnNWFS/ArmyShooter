/// should_spawn_Instances() -> int
function should_spawn_Instances() {
    if (oLevelManager.state != 1) return 0;
    
    oLevelManager.spawn_timer++;
    var rate = max(MIN_ENEMY_SPAWN_RATE, BASE_ENEMY_SPAWN_RATE - oLevelManager.level * 2);
    
    if (oLevelManager.spawn_timer >= rate && oLevelManager.Instances_spawned_this_wave < oLevelManager.Instances_per_wave) {
        oLevelManager.spawn_timer = 0;
        oLevelManager.Instances_spawned_this_wave += Instances_PER_SPAWN;
        return Instances_PER_SPAWN;
    }
    return 0;
}