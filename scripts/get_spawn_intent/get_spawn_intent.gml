/// get_spawn_intent() -> struct
/// Returns lane + reason data for the next spawn based on lightweight director scoring.
function get_spawn_intent() {
    var _pattern = oLevelManager.current_wave_pattern;
    var lanes = enemy_lanes();

    if (!is_array(lanes) || array_length(lanes) <= 0) {
        return { lane: 0, reason: "fallback_no_lanes", intent_score: 0 };
    }

    var cooldown_len = array_length(oLevelManager.lane_spawn_cooldown);
    var best_lane = lanes[0];
    if (best_lane < 0 || best_lane >= cooldown_len) best_lane = 0;

    var _best_score = -999999;
    var reason = "fallback";
    var low_army = instance_number(oSoldier) < 12;

    for (var i = 0; i < array_length(lanes); i++) {
        var _lane_id = lanes[i];
        if (_lane_id < 0 || _lane_id >= cooldown_len) continue;

        var _score = 100;

        // Cooldown memory: avoid repeatedly stacking the exact same lane.
        var cooldown = oLevelManager.lane_spawn_cooldown[_lane_id];
        _score -= cooldown * 22;

        // Pressure equalizer: prefer lane with fewer active enemies / less progress.
        var lane_enemy_count = 0;
        var furthest_y = -9999;
        var enemy_count = instance_number(oEnemy);

        for (var e = 0; e < enemy_count; e++) {
            var inst = instance_find(oEnemy, e);
            if (inst.lane == _lane_id) {
                lane_enemy_count++;
                furthest_y = max(furthest_y, inst.y);
            }
        }

        _score -= lane_enemy_count * 10;
        _score -= max(0, furthest_y) / 40;

        if (_pattern.is_swarm) {
            _score += (_lane_id != oLevelManager.last_spawn_lane) ? 15 : -8;
        }

        if (low_army && furthest_y > DESIGN_H * 0.55) {
            _score -= 18;
        }

        _score += irandom_range(-6, 6);

        if (_score > _best_score) {
            _best_score = _score;
            best_lane = _lane_id;
            reason = "cooldown_and_pressure";
        }
    }

    return {
        lane: best_lane,
        reason: reason,
        intent_score: _best_score
    };
}
