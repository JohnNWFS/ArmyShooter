/// log_death_event(type, subtype, lane, size, final_value, time, wave, level, frames_alive)
/// Logs when objects are destroyed/collected
function log_death_event(_type, _subtype, _lane, _size, _final_value, _time, _wave, _level, _frames_alive) {
    var timestamp = string(current_time);
    var game_time = string(global.game_timer ?? 0);
    var level_str = string(_level);
    var wave_str = string(_wave);
    var type_str = _type; // "ENEMY_DEATH", "BLOCK_COLLECTED"
    var subtype_str = _subtype;
    var lane_str = string(_lane);
    var size_str = string(_size);
    var value_str = string(_final_value);
    var enemies_alive = string(instance_number(oEnemy));
    var soldiers_alive = string(instance_number(oSoldier));
    var score_str = string(score);
    var lifetime_str = string(_frames_alive);
    
    var csv_line = timestamp + "," + 
                   game_time + "," + 
                   level_str + "," + 
                   wave_str + "," + 
                   type_str + "," + 
                   subtype_str + "," + 
                   lane_str + "," + 
                   size_str + "," + 
                   value_str + "," + 
                   enemies_alive + "," + 
                   soldiers_alive + "," + 
                   score_str + "," +
                   lifetime_str;
    
    show_debug_message(csv_line);
}