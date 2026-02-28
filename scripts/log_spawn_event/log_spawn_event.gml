/// log_spawn_event(type, subtype, lane, size, value, time, wave, level)
/// Logs spawn events to a CSV-formatted debug output
function log_spawn_event(_type, _subtype, _lane, _size, _value, _time, _wave, _level) {
    // CSV Header (print once at game start):
    // timestamp,game_time,level,wave,type,subtype,lane,size,value,enemies_alive,soldiers_alive,score
    
    var timestamp = string(current_time);
    var game_time = string(global.game_timer ?? 0); // frames since game start
    var level_str = string(_level);
    var wave_str = string(_wave);
    var type_str = _type; // "ENEMY", "BLOCK", "POWERUP"
    var subtype_str = _subtype; // "regular", "mini_boss", "boss", "negative", "positive", "rapid_fire", etc.
    var lane_str = string(_lane);
    var size_str = string(_size);
    var value_str = string(_value);
    var enemies_alive = string(instance_number(oEnemy));
    var soldiers_alive = string(instance_number(oSoldier));
    var score_str = string(score);
    
    // CSV format
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
                   score_str;
    
    show_debug_message(csv_line);
}