/// get_spawn_intent(pattern) -> struct
/// Returns lane + reason data for the next spawn based on lightweight director scoring.
function get_spawn_intent(_pattern) {
    var lanes = enemy_lanes();
    var best_lane = lanes[0];
    var best_score = -999999;
    var reason = "fallback";

    var low_army = instance_number(oSoldier) < 12;

    for (var i = 0; i < array_length(lanes); i++) {
        var ln = lanes[i];
        var score = 100;

        // Cooldown memory: avoid repeatedly stacking the exact same lane.
        var cooldown = oLevelManager.lane_spawn_cooldown[ln];
        score -= cooldown * 22;

        // Pressure equalizer: prefer lane with fewer active enemies / less progress.
        var lane_enemy_count = 0;
        var furthest_y = -9999;
        var enemy_count = instance_number(oEnemy);

        for (var e = 0; e < enemy_count; e++) {
            var inst = instance_find(oEnemy, e);
            if (inst.lane == ln) {
                lane_enemy_count++;
                furthest_y = max(furthest_y, inst.y);
            }
        }

        score -= lane_enemy_count * 10;
        score -= max(0, furthest_y) / 40;

        // Keep swarms threatening by slightly preferring the opposite lane.
        if (_pattern.is_swarm) {
            score += (ln != oLevelManager.last_spawn_lane) ? 15 : -8;
        }

        // Recovery behavior: when army is low, avoid piling pressure on the lane
        // that already has the deepest enemy push.
        if (low_army && furthest_y > DESIGN_H * 0.55) {
            score -= 18;
        }

        // Small random jitter keeps selection from becoming deterministic.
        score += irandom_range(-6, 6);

        if (score > best_score) {
            best_score = score;
            best_lane = ln;
            reason = "cooldown_and_pressure";
        }
    }

    return {
        lane: best_lane,
        reason: reason,
        score: best_score
    };
}
