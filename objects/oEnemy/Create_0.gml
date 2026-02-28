/// oEnemy - Create Event

lane = 0;
is_boss = false;
is_mini_boss = false;
is_swarm = false;  // NEW
size = 40;
hp = 2;
max_hp = 2;
flash = 0;
move_timer = 0;
birth_time = global.game_timer;

// Set sprite based on enemy type
if (is_boss) {
    sprite_index = spr_enemy_boss;
} else if (is_mini_boss) {
    sprite_index = spr_enemy_mini;
} else if (is_swarm) {
    sprite_index = spr_enemy_swarm;
} else {
    sprite_index = spr_enemy;
}