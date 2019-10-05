extends "res://Scripts/WormSegment.gd"

signal segment_destroyed

func _on_CrashingEnemySegment_area_entered(area):
    if area.get_parent().has_method("removeNode"):
        area.get_parent().removeNode()
    emit_signal("segment_destroyed", self)

func damage():
    get_parent().damage()