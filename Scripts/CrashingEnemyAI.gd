extends "res://Scripts/WormSpawner.gd"

func _physics_process(delta):
    control(delta)
    
func init_segments() -> void:
    .init_segments()
    for segment in body:
        segment.connect("segment_destroyed", self, "on_segment_destroyed")

func on_segment_destroyed(segment):
    print(segment)
    queue_free() #TODO fancy effects

func control(delta):
    # Example movement with left-right rotating
    vel = Vector2(90, 0)
    if Input.is_action_pressed("ui_left"):
        heading -= PI * delta * 1
    elif Input.is_action_pressed("ui_right"):
        heading += PI*delta * 1