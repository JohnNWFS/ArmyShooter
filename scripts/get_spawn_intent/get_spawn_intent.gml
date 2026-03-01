/// get_spawn_intent(pattern) -> struct
/// Returns lane + reason data for the next spawn based on lightweight director scoring.
function get_spawn_intent(_pattern) {
    var lanes = enemy_lanes();
    var best_lane = lanes[0];
    var best_score = -999999;
    var reason = "fallback";

    var army_count = instance_number(oSoldier);
    var low_army = army_count < 10;

    for (var i = 0; i < array_length(lanes); i++) {
        var _ln = lanes[i];
        var iscore = 100;

        // Keep lane variety, but allow tighter pressure chains than before.
        var cooldown = oLevelManager.lane_spawn_cooldown[_ln];
        iscore -= cooldown * 10;

        // Lane pressure info.
        var lane_enemy_count = 0;
        var furthest_y = -9999;
        var enemy_count = instance_number(oEnemy);

        for (var e = 0; e < enemy_count; e++) {
            var inst = instance_find(oEnemy, e);
            if (inst.lane == _ln) {
                lane_enemy_count++;
                furthest_y = max(furthest_y, inst.y);
            }
        }

        // Horde behavior: encourage stacking into active lanes so packs feel dense.
        iscore += lane_enemy_count * 8;

        // Still avoid runaway impossible pushes when army is weak.
        if (low_army && furthest_y > DESIGN_H * 0.62) {
            iscore -= 28;
        }

        // Swarm waves should feel relentless and frequently alternate flank pressure.
        if (_pattern.is_swarm) {
            iscore += (_ln != oLevelManager.last_spawn_lane) ? 14 : 8;
        }

        // Encourage closing pressure as wave progresses.
        iscore += max(0, furthest_y) / 70;

        // Small random jitter keeps selection from becoming deterministic.
        iscore += irandom_range(-5, 5);

        if (iscore > best_score) {
            best_score = iscore;
            best_lane = _ln;
            reason = "horde_pressure";
        }
    }

    return {
        lane: best_lane,
        reason: reason,
        iscore: best_score
    };
}
