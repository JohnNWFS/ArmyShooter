/// check_wave_complete(Instances_alive) -> string ("", "mini_boss", "boss")
function check_wave_complete(alive) {
    with (oLevelManager) {
        if (alive == 0 && Instances_spawned_this_wave >= Instances_per_wave) {
            wave_count++;
            Instances_spawned_this_wave = 0;
            spawn_timer = 0;
            
            if (wave_count == max_waves / 2 && !mini_boss_spawned) {
                mini_boss_spawned = true;
                return "mini_boss";
            }
            if (wave_count >= max_waves) {
                state = 2; // BOSS_FIGHT
                return "boss";
            }
        }
    }
    return "";
}