extends "res://Scripts/WormSegment.gd"

signal segment_destroyed
signal node_found
signal node_left

func _on_CrashingEnemySegment_area_entered(area):
    if area.is_in_group("SpaceNodeHitboxes"):
        area.get_parent().removeNode()
        #emit_signal("segment_destroyed", self)
        damage(1)

func damage(amount = 1):
    get_parent().damage(amount)

func _on_DetectNodeArea_area_entered(area):
    if area.is_in_group("SpaceNodeHitboxes"):
        emit_signal("node_found", area.get_parent())

func _on_DetectNodeArea_area_exited(area):
   if area.is_in_group("SpaceNodeHitboxes"):
        emit_signal("node_left", area.get_parent())
